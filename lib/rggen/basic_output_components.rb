# frozen_string_literal: true

require 'docile'
require 'facets/kernel/attr_singleton'

require_relative 'basic_output_components/version'

require_relative 'basic_output_components/systemverilog_utility/identifier'
require_relative 'basic_output_components/systemverilog_utility/data_object'
require_relative 'basic_output_components/systemverilog_utility/interface_port'
require_relative 'basic_output_components/systemverilog_utility/interface_instance'
require_relative 'basic_output_components/systemverilog_utility/structure_definition'
require_relative 'basic_output_components/systemverilog_utility/module_definition'
require_relative 'basic_output_components/systemverilog_utility'

require_relative 'basic_output_components/systemverilog/component'
require_relative 'basic_output_components/systemverilog/feature'
require_relative 'basic_output_components/systemverilog/feature_rtl'
require_relative 'basic_output_components/systemverilog/feature_ral'
require_relative 'basic_output_components/systemverilog'

module RgGen
  module BasicOutputComponents
    def self.setup(builder)
      SystemVerilog.setup_rtl(builder)
      SystemVerilog.setup_ral(builder)
    end
  end

  setup do |builder|
    BasicOutputComponents.setup(builder)
  end
end
