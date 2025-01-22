# frozen_string_literal: true

RSpec.describe 'global/array_port_format' do
  include_context 'configuration common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, :array_port_format)
  end

  describe '#array_port_format' do
    specify 'デフォルト値は:packedである' do
      configuration = create_configuration
      expect(configuration).to have_property(:array_port_format, :packed)
    end

    it '入力された配列形式を返す' do
      [:packed, :unpacked, :serialized].each do |format|
        value = random_string(/#{format}/i)
        configuration = create_configuration(array_port_format: value)
        expect(configuration).to have_property(:array_port_format, format)

        value = random_string(/#{format}/i).to_sym
        configuration = create_configuration(array_port_format: value)
        expect(configuration).to have_property(:array_port_format, format)
      end
    end
  end

  it '表示可能オブジェクトとして、設定値を返す' do
    value = [:packed, :unpacked, :serialized].sample
    configuration = create_configuration(array_port_format: value)
    expect(configuration.printables[:array_port_format]).to eq value
  end

  describe 'エラーチェック' do
    context '入力がpacked/unpacked/serialized以外の場合' do
      it 'SourceErrorを起こす' do
        [nil, true, false, '', 'foo', :foo, 0, Object.new].each do |value|
          expect {
            create_configuration(array_port_format: value)
          }.to raise_source_error "illegal input value for array port format: #{value.inspect}"
        end
      end
    end
  end
end
