# frozen_string_literal: true

require 'bundler/setup'
require 'rggen/devtools/spec_helper'
require 'rggen/core'

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/default_register_map'
builder.plugin_manager.activate_plugin_by_name(:'rggen-default-register-map')

require 'rggen/spreadsheet_loader'
builder.plugin_manager.activate_plugin_by_name(:'rggen-spreadsheet-loader')

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/systemverilog/rtl'
builder.plugin_manager.activate_plugin_by_name(:'rggen-sv-rtl')

require 'rggen/systemverilog/ral'
builder.plugin_manager.activate_plugin_by_name(:'rggen-sv-ral')

RGGEN_ROOT = ENV['RGGEN_ROOT'] || File.expand_path('../..', __dir__)
RGGEN_SYSTEMVERILOG_ROOT = File.expand_path('..', __dir__)
RGGEN_SAMPLE_DIRECTORY = File.join(RGGEN_ROOT, 'rggen-sample')
