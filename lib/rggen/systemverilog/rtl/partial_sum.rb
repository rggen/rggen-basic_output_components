# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      module PartialSum
        private

        def partial_sums(operands)
          operands
            .chunk(&method(:integer?))
            .flat_map(&method(:calc_partial_sum))
            .reject(&method(:integer_zero?))
            .tap { |sums| sums.empty? && (sums << 0) }
        end

        def calc_partial_sum(kind_ans_values)
          kind, values = kind_ans_values
          kind && values.sum || values
        end

        def integer?(value)
          value.is_a?(Integer)
        end

        def integer_zero?(value)
          integer?(value) && value.zero?
        end
      end
    end
  end
end
