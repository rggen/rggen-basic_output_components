# frozen_string_literal: true

RSpec.describe 'bit_field/type/rwl' do
  include_context 'clean-up builder'
  include_context 'bit field ral common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:rw, :rol])
  end

  specify 'アクセス属性はRO' do
    sv_ral = create_sv_ral do
      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rol; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1; type :rol; initial_value 0; reference 'register_1.bit_field_0' }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
      end
    end

    expect(sv_ral.bit_fields[0].access).to eq 'RO'
    expect(sv_ral.bit_fields[1].access).to eq 'RO'
  end
end
