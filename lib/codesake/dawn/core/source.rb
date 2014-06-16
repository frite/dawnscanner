require 'ruby_parser'

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

        attr_reader :total_lines, :empty_lines, :comment_lines, :cyclomatic_complexity
        attr_accessor :kind

        def initialize(options={})
          @filename = ""
          @debug    = false
          @total_lines = 0
          @empty_lines = 0
          @comment_lines = 0
          @cyclomatic_complexity = 1

          @filename = options[:filename] unless options[:filename].nil?
          @debug = options[:debug] unless options[:debug].nil?

          if $logger.nil?
            $logger  = Codesake::Commons::Logging.instance
            $logger.toggle_syslog
            $logger.helo "dawn-source", Codesake::Dawn::VERSION
          end

          @raw_file_content = File.readlines(@filename)

          @ast = RubyParser.new.parse(File.binread(@filename), @filename)
          calc_stats
          @cyclomatic_complexity = calc_cyclomatic_complexity

        end

        def ast
          (@debug)? @ast : nil
        end

        def find_sinks
          ret = []
          @ast.deep_each do |sexp|
            if (sexp.sexp_type == :attrasgn || sexp.sexp_type == :iasgn || sexp.sexp_type == :lasgn) && sexp.sexp_body.flatten.include?(:params)
              sink={}

              assign_root = sexp.sexp_body
              sink[:target]   = assign_root[0]
              sink[:filename] = @filename
              sink[:line]     = sexp.line
              debug_me assign_root[1].class
              debug_me assign_root[1].sexp_type
              # Trying to understand a call like var = a_method_here(params[1], params[2], ...)
              if assign_root[1].respond_to?(:sexp_type) && assign_root[1].sexp_type.to_sym == :call
                debug_me "here"
                sink[:type] = :call
                sink[:sources_count] = 0
                sink[:sources] = []
                assign_root[1].each_sexp do |call_element|
                  debug_me "#{call_element}"
                  if call_element.flatten.include?(':params')
                    debug_me "here"

                    sink[:sources_count] += 1
                    sink[:sources] << call_element.sexp_body.last.sexp_body.sexp_type
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
