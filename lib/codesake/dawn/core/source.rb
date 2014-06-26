require 'ruby_parser'
require 'haml'
require 'erb'

module Codesake
  module Dawn
    module Core

      # A Source is either a Ruby file being reviewed, or an ERB view file, or an
      # HAML view file.
      #
      # This class models everything deserves to be parsed for further
      # inspection.
      class Source
        include Codesake::Dawn::Debug

        SCRIPT      = :script
        CLASS       = :class
        CONTROLLER  = :controller
        VIEW        = :view
        MODEL       = :model
        HELPER      = :helper
        MAIN_APP    = :main_app


        attr_reader :total_lines, :empty_lines, :comment_lines, :cyclomatic_complexity, :kind, :filename

        # This attribute stores source file parsing status. I don't want to
        # rely on @ast being nil since the nil value is found also when the
        # source code is empty or fully commented on. In the case of a parsing
        # error, there is code inside.
        attr_reader :status
        attr_accessor :kind

        def initialize(options={})
          @filename = ""
          @debug    = false
          @total_lines = 0
          @empty_lines = 0
          @comment_lines = 0
          @cyclomatic_complexity = 1
          @kind = SCRIPT
          @status = :ok

          @filename   = options[:filename]  unless options[:filename].nil?
          @debug      = options[:debug]     unless options[:debug].nil?
          @kind       = options[:kind]      unless options[:kind].nil?
          @mvc        = options[:mvc]       unless options[:mvc].nil?

          @raw_file_content = File.readlines(@filename)
          @kind = auto_detect if ! options[:auto_detect].nil? && options[:auto_detect ]

          if $logger.nil?
            $logger  = Codesake::Commons::Logging.instance
            $logger.toggle_syslog
            $logger.helo "dawn-source", Codesake::Dawn::VERSION
          end

          begin
            @ast = RubyParser.new.parse(File.binread(@filename), @filename) if is_ruby?
            @ast = RubyParser.new.process(Haml::Engine.new(File.read(@filename)).precompiled, @filename) if is_haml?
            @ast = RubyParser.new.process(ERB.new(File.read(@filename)).src, @filename) if is_erb?
            $logger.warn "#{@filename} produced an empty AST. File can be either empty or all lines commented out" if @ast.nil?
            @status = :empty if @ast.nil?
            debug_me "AST is #{@ast}" unless @ast.nil?
            calc_stats
            @cyclomatic_complexity = calc_cyclomatic_complexity
          rescue => e
            $logger.err "#{@filename}: parsing error (#{e.message})"
            @ast = nil
            @status = :ko
          end

        end

        def is_erb?
          (File.extname(@filename) == ".erb")
        end
        def is_haml?
          (File.extname(@filename) == ".haml")
        end
        def is_ruby?
          (File.extname(@filename) == ".rb") || is_script?
        end
        def is_script?
          (@raw_file_content.nil?)? false : @raw_file_content.include?("#!/usr/bin/env ruby\n")
        end

        def ast
          (@debug)? @ast : nil
        end

        def auto_detect

          ret = nil

          # rails && padrino
          ret = VIEW        if @filename.include?("app/views") && (File.extname(@filename) == ".haml" || File.extname(@filename) == ".erb")
          ret = CONTROLLER  if @filename.include?("app/controller") && (File.extname(@filename) == ".rb")
          ret = MODEL       if @filename.include?("app/models") && (File.extname(@filename) == ".rb")
          ret = HELPER      if @filename.include?("app/helpers") && (File.extname(@filename) == ".rb")

          # padrino models
          ret = MODEL       if @filename.include?("models/") && (File.extname(@filename) == ".rb")

          ret = SCRIPT      if is_script?
          ret = MAIN_APP    if File.basename(@filename) == "app.rb" && (@mvc == :padrino || @mvc == :sinatra)
          ret = CLASS       if ret.nil?
          ret
        end

        def find_sinks
          return [] if @ast.nil?
          ret = []
          @ast.deep_each do |sexp|
            if (sexp.sexp_type == :attrasgn || sexp.sexp_type == :iasgn || sexp.sexp_type == :lasgn) && sexp.sexp_body.flatten.include?(:params)
              sink={}

              assign_root = sexp.sexp_body
              sink[:target]   = assign_root[0]
              sink[:filename] = @filename
              sink[:line]     = sexp.line
              # Trying to understand a call like var = a_method_here(params[1], params[2], ...)
              if assign_root[1].respond_to?(:sexp_type) && assign_root[1].sexp_type.to_sym == :call
                sink[:type] = :call
                sink[:sources_count] = 0
                sink[:sources] = []
                assign_root[1].each_sexp do |call_element|
                  if call_element.flatten.include?(:params)
                    sink[:sources_count] += 1
                    debug_me call_element.sexp_body.last
                    sink[:sources] << call_element.sexp_body.last.sexp_body.sexp_type if call_element.sexp_body.last.respond_to?(:sexp_body)
                  end
                end

              end

              ret << sink
            end
          end
          debug_me "#{ret.count} sinks found: #{ret}"
          ret
        end

        private
          def calc_cyclomatic_complexity
            return -1 if @ast.nil?

            ret = 1
            @ast.deep_each do |exp|
              ret +=1 if is_a_branch?(exp.sexp_type)
            end
            ret
          end
          def is_a_branch?(type)
            branch_types = [:if, :if_mod, :unless, :unless_mod, :when, :elsif, :ifop,
                            :while, :while_mod, :until, :until_mod, :for, :do_block, :brace_block,
                            :rescue, :rescue_mod]
            return true if branch_types.include?(type)
          end


        def calc_stats
          return {} if @raw_file_content.nil?
          comment = 0
          lines   = 0
          nl      = 0

          @raw_file_content.each do |line|
            comment += 1 if line.strip.chomp.start_with?('#')
            nl += 1 if line.strip.chomp.start_with?('\n') || line.strip.chomp.start_with?('\r') || line.chomp.empty?
            lines +=1
          end
          @total_lines = lines
          @empty_lines = nl
          @comment_lines = comment

          @stats
        end

      end
    end
  end
end
