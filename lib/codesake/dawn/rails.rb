require "codesake/dawn/engine"

module Codesake
  module Dawn
    class Rails
      include Codesake::Dawn::Engine


      def initialize(options={})
        super(options)
      end
    end
  end
end
