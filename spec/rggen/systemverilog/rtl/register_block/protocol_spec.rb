# frozen_string_literal: true

RSpec.describe 'register_block/protocol' do
  include_context 'configuration common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.builder.output_component_registry(:verilog) do
      register_component :register_block do
        component RgGen::Core::OutputBase::Component, RgGen::Core::OutputBase::ComponentFactory
        feature RgGen::Core::OutputBase::Feature, RgGen::Core::OutputBase::FeatureFactory
      end
    end

    @shared_contexts = []
    shared_contexts = @shared_contexts
    RgGen.define_list_feature(:register_block, :protocol) do
      verilog do
        shared_contexts << shared_context
        shared_context.feature_registry(registry)
      end
    end

    RgGen.define_list_item_feature(:register_block, :protocol, [:foo, :bar, :foobar, :baz]) do
      sv_rtl {}
    end

    RgGen.define_list_item_feature(:register_block, :protocol, [:foo, :bar, :foobar, :qux]) do
      verilog {}
    end
  end

  after(:all) do
    registries = @shared_contexts[0].__send__(:feature_registries)
    registries.pop
  end

  before do
    RgGen.enable(:global, [:bus_width, :address_width])
    RgGen.enable(:register_block, :protocol)
  end

  after do
    RgGen.enable_all
    delete_configuration_factory
  end

  describe 'configuration' do
    describe '#protocol' do
      before do
        RgGen.enable(:register_block, :protocol, [:qux, :foobar, :foo])
      end

      specify '既定値は定義されているプロトコルで、最初に有効になったプロトコル' do
        configuration = create_configuration
        expect(configuration).to have_property(:protocol, :foobar)

        configuration = create_configuration(protocol: nil)
        expect(configuration).to have_property(:protocol, :foobar)

        configuration = create_configuration(protocol: '')
        expect(configuration).to have_property(:protocol, :foobar)
      end

      it '指定されたホストプロトコルを返す' do
        {
          foo: [
            'foo', 'FOO', random_string(/foo/i)
          ],
          foobar: [
            'foobar', 'FOOBAR', random_string(/foobar/i)
          ]
        }.each do |protocol, values|
          values.each do |value|
            configuration = create_configuration(protocol: value)
            expect(configuration).to have_property(:protocol, protocol)

            configuration = create_configuration(protocol: value.to_sym)
            expect(configuration).to have_property(:protocol, protocol)
          end
        end
      end
    end

    it '表示可能オブジェクトとして、設定されたプロトコル名を返す' do
      RgGen.enable(:register_block, :protocol, [:foo, :bar, :foobar])
      protocol =  [:foo, :bar, :foobar].sample
      configuration = create_configuration(protocol: protocol)
      expect(configuration.printables[:protocol]).to eq protocol
    end

    describe 'エラーチェック' do
      context '対象の全生成器で、使用可能なプロトコルがない場合' do
        before do
          RgGen.enable(:register_block, :protocol, [:buz, :qux])
        end

        it 'ConfigurationErrorを起こす' do
          expect {
            create_configuration
          }.to raise_configuration_error 'no protocols are available'

          expect {
            create_configuration(protocol: nil)
          }.to raise_configuration_error 'no protocols are available'

          expect {
            create_configuration(protocol: '')
          }.to raise_configuration_error 'no protocols are available'
        end
      end

      context '有効になっていないプロトコルを指定した場合' do
        before do
          RgGen.enable(:register_block, :protocol, [:foo, :bar, :baz, :qux])
        end

        it 'ConfigurationErrorを起こす' do
          value = random_string(/foobar/i)
          expect {
            create_configuration(protocol: value)
          }.to raise_configuration_error "unknown protocol: #{value.inspect}"

          value = random_string(/foobar/i).to_sym
          expect {
            create_configuration(protocol: value)
          }.to raise_configuration_error "unknown protocol: #{value.inspect}"

          value = random_string(/baz/i)
          expect {
            create_configuration(protocol: value)
          }.to raise_configuration_error "unknown protocol: #{value.inspect}"

          value = random_string(/baz/i).to_sym
          expect {
            create_configuration(protocol: value)
          }.to raise_configuration_error "unknown protocol: #{value.inspect}"

          value = random_string(/qux/i)
          expect {
            create_configuration(protocol: value)
          }.to raise_configuration_error "unknown protocol: #{value.inspect}"

          value = random_string(/qux/i).to_sym
          expect {
            create_configuration(protocol: value)
          }.to raise_configuration_error "unknown protocol: #{value.inspect}"
        end
      end

      context '定義されていないプロトコルを指定した場合' do
        before do
          RgGen.enable(:register_block, :protocol, [:foo, :bar, :fizz])
        end

        it 'ConfigurationErrorを起こす' do
          value = random_string(/fizz/i)
          expect {
            create_configuration(protocol: value)
          }.to raise_configuration_error "unknown protocol: #{value.inspect}"

          value = random_string(/fizz/i).to_sym
          expect {
            create_configuration(protocol: value)
          }.to raise_configuration_error "unknown protocol: #{value.inspect}"
        end
      end
    end
  end

  describe 'sv rtl' do
    include_context 'sv rtl common'

    before do
      RgGen.enable(:register_block, :byte_size)
      RgGen.enable(:register_block, :protocol, :foo)
    end

    let(:bus_width) { 32 }

    let(:address_width) { 32 }

    let(:local_address_width) { 8 }

    let(:sv_rtl) do
      configuration = create_configuration(protocol: :foo, bus_width: bus_width, address_width: address_width)
      create_sv_rtl(configuration) { byte_size 256 }.register_blocks.first
    end

    it 'パラメータADDRESS_WIDTH/PRE_DECODE/BASE_ADDRESS/ERROR_STATUS/DEFAULT_READ_DATA/INSERT_SLICERを持つ' do
      expect(sv_rtl).to have_parameter(
        :address_width,
        name: 'ADDRESS_WIDTH', parameter_type: :parameter, data_type: :int, default: local_address_width
      )
      expect(sv_rtl).to have_parameter(
        :pre_decode,
        name: 'PRE_DECODE', parameter_type: :parameter, data_type: :bit, width: 1, default: 0
      )
      expect(sv_rtl).to have_parameter(
        :base_address,
        name: 'BASE_ADDRESS', parameter_type: :parameter, data_type: :bit, width: 'ADDRESS_WIDTH', default: "'0"
      )
      expect(sv_rtl).to have_parameter(
        :error_status,
        name: 'ERROR_STATUS', parameter_type: :parameter, data_type: :bit, width: 1, default: 0
      )
      expect(sv_rtl).to have_parameter(
        :default_read_data,
        name: 'DEFAULT_READ_DATA', parameter_type: :parameter, data_type: :bit, width: bus_width, default: "'0"
      )
      expect(sv_rtl).to have_parameter(
        :insert_slicer,
        name: 'INSERT_SLICER', parameter_type: :parameter, data_type: :bit, width: 1, default: 0
      )
    end
  end
end
