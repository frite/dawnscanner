require 'ruby_parser'

module Codesake
  module Dawn
    module Kb
      class SSLVerificationBypass
        include Codesake::Dawn::Core::Kb::SourceCheck

        def initialize
          super({
            :name=>"SSL Verification Bypass",
            :severity=>:high,
            :priority=>:high,
            :kind=>Codesake::Dawn::KnowledgeBase::SOURCE_CHECK,
            :applies=>["sinatra", "padrino", "rails", "rack"]
          })

          self.vulnerable_ast = [
            # case 1. Both net/http and net/https libraries must be required and canary must be an Net::HTTP object. We must use ssl and verify_mode must set to VERIFY_NONE
            {:pre_conditions=>[
                  RubyParser.new.parse("request 'net/https'"),
                  RubyParser.new.parse("request 'net/http'"),
                  RubyParser.new.parse("canary = Net::HTTP.new(uri.host, uri.port)"),
                  RubyParser.new.parse("canary.use_ssl = true")
             ],
             :pre_conditions_operand=>:and,
             :ast=>RubyParser.new.parse("canary.verify_mode = OpenSSL::SSL::VERIFY_NONE")
            },
          ]

        end
      end
    end
  end
end
