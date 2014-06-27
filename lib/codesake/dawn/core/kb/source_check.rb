module Codesake
  module Dawn
    module Core
      module Kb
        module SourceCheck
          include Codesake::Dawn::Core::Kb::BasicCheck


          attr_accessor     :source_ast
          attr_accessor     :vulnerable_ast

          def initialize(options={})
            super(options)
            @vulnerable_ast = options[:vulnerable_ast] unless options[:vulnerable_ast].nil?
            @source_ast     = options[:source_ast] unless options[:source_ast].nil?
          end

          # s(:call, nil, :require, s(:str, "net/http"))
          def are_preconditions_met?(elem)
            ret = false
            elem[:pre_conditions].each do |e|
              a = is_this_precondition_met?(e)
              debug_me "evaluating pre condition: #{e.inspect}. met?: #{a}"
              return true if a && elem[:pre_conditions_operand] == :or
              return false if !a && elem[:pre_conditions_operand] == :and
            end

            return false if elem[:pre_conditions_operand] == :or
            return true if elem[:pre_conditions_operand] == :and
          end

          def is_this_precondition_met?(e)
            @source_ast.deep_each do |sexp|
              debug_me("src=#{sexp.inspect} - dst=#{e.inspect}")
              return true if sexp === e
            end
            false
          end

          def vuln?
            @vulnerable_ast.each do |vuln_elem|
              pre = are_preconditions_met?(vuln_elem)
            end
            false
          end
        end
      end
    end
  end
end
