module Codesake
  module Dawn
    module Core
      module Kb
        module SourceCheck

          include Codesake::Dawn::Core::Kb::BasicCheck

          attr_accessor     :source_ast

          def initialize(options)
            super(options)
          end

          def vuln?
            false
          end
        end
      end
    end
  end
end
