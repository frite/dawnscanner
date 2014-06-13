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

        attr_reader :stats

        def initialize(options={})
          @filename = ""
          @stats    = {}
          @debug    = false

          @filename = options[:filename] unless options[:filename].nil?
          @debug = options[:debug] unless options[:debug].nil?

          @raw_file_content = File.readlines(@filename)
          @ast = RubyParser.new.parse(File.binread(@filename), @filename)
          debug_me(@ast)

          calc_stats
        end


        private

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
          @stats[:total_lines] = lines
          @stats[:empty_lines] = nl
          @stats[:comment_lines] = comment

          @stats
        end

      end
    end
  end
end
