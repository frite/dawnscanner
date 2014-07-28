
class Array

  # Calculates Jaccard distance between self and another array provided as
  # input.
  #
  # other_array - is the array we want to calculate the distance from self
  #
  # returns a float between 0 and 1.
  def jaccard_index(other_array)
    intersection = other_array & self
    union = other_array + self
    return intersection.length.to_f / union.length.to_f
  end

  def sounds_like(other_array)
    return (self.likeness_index(other_array) + self.jaccard_index(other_array) ).to_f / 2
  end

  # Calculates a likeness index based on how much :canary symbol are found form
  # the two sets intersection. The value is divided by the total amount of
  # :canary introduced in the array passed as parameter.
  #
  # other_array - is the array with :canary, it is eventually coming from the
  # knowledge base.
  #
  # returns a float between 0 and 1
  def likeness_index(other_array)
    diff = other_array - self
    ratio = (other_array.canary_count != 0) ? 1.0 / other_array.canary_count : 0.0
    return (diff.canary_count * ratio).to_f
  end

  def canary_count
    count = 0
    self.each do |elem|
      count +=1 if elem == :canary
      count += elem.canary_count if elem.class == Array
    end
    return count
  end
end

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
            a = true
            elem[:pre_conditions].each do |e|
              a = a && is_this_precondition_met?(e)
              debug_me "evaluating pre condition: #{e.inspect}. met?: #{a}"
              return true if a && elem[:pre_conditions_operand] == :or
              return false if !a && elem[:pre_conditions_operand] == :and
            end

            debug_me "are_preconditions_met?(#{elem}): #{a}"
            return a
          end

          # canary is either a target variable and a method parameter we don't
          # want to use
          def is_this_precondition_met?(e)
            @source_ast.deep_each do |sexp|
              # debug_me("src=#{sexp.inspect} - dst=#{e.inspect}: #{sexp.inspect == e.inspect}")
              if e.sexp_type == :lasgn && sexp.sexp_type == :lasgn
                canary_var = (e.entries[1] == :canary)
                # debug_me "#{sexp.entries[2]} vs #{e.entries[2]}: likeness is #{sexp.entries[2].to_a.sounds_like(e.entries[2].to_a)}"
                return true if sexp.entries[2].to_a.sounds_like(e.entries[2].to_a) > 0.60
              end
              if e.sexp_type == :attrasgn && sexp.sexp_type == :attrasgn
                return true if (e.entries[2] == sexp.entries[2]) && (e.entries[3].to_a == sexp.entries[3].to_a)
              end
              return true if sexp == e
            end
            false
          end

          def is_vulerable_code?(e)
            @source_ast.deep_each do |sexp|
              if (e.sexp_type == :attrasgn) && (sexp.sexp_type == :attrasgn)
                return true if (e.entries[2] == sexp.entries[2]) && (e.entries[3].to_a == sexp.entries[3].to_a)
              end
            end
            false
          end

          def vuln?
            @vulnerable_ast.each do |vuln_elem|
              pre = are_preconditions_met?(vuln_elem)
              found = is_vulerable_code?(vuln_elem[:ast]) if pre
              return debug_me_and_return_true("source code vulnerable") if pre && found
            end
            false
          end
        end
      end
    end
  end
end
