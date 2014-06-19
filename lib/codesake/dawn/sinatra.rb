require "codesake/dawn/engine"
require 'ruby_parser'

module Codesake
  module Dawn
    class Sinatra
      include Codesake::Dawn::Engine

      attr_reader :sinks
      attr_reader :appname

      # mount_point is the mounting point for this Sinatra application. It's
      # filled up only in padrino engines
      attr_reader :mount_point

      attr_reader :total_lines
      def initialize(options={})
        super(options)
        @mount_point = (options[:mp].nil?)? "" : options[:mp]
        @total_lines = 0
        @sources = []
        @views = []
        @controllers = []
        @filenames.each do |ff|
          s = Codesake::Dawn::Core::Source.new({:filename=>ff, :debug=>@debug, :auto_detect=>true, :mvc=>:sinatra})
          s.find_sinks
          @appname      = ff if s.kind == Codesake::Dawn::Core::Source::MAIN_APP
          @views        << s if s.kind == Codesake::Dawn::Core::Source::VIEW
          @controllers  << s if s.kind == Codesake::Dawn::Core::Source::CONTROLLER
          @sources      << s
          if s.kind != Codesake::Dawn::Core::Source::VIEW
            @total_lines += s.total_lines
          end
        end
      end


      # e = Haml::Engine.new(File.read(template))
      # e.precompiled  and grep for format_script


      def top_10_most_complex_sources
        a = @sources.sort {|k,j| j.cyclomatic_complexity <=> k.cyclomatic_complexity}
        a[0..9]
      end
    end
  end
end
