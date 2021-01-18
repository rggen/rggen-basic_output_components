# frozen_string_literal: true

RSpec.describe 'bit_field/type/w1s' do
  include_context 'clean-up builder'
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:w1s])
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register_file, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  def create_bit_fields(&body)
    configuration = create_configuration(array_port_format: array_port_format)
    create_sv_rtl(configuration, &body).bit_fields
  end

  let(:array_port_format) do
    [:packed, :unpacked, :serialized].sample
  end

  it '出力ポート#value_out/入力ポート#clearを持つ' do
    bit_fields = create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1s; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :w1s; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1s; initial_value 0 }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :w1s; initial_value 0 }
      end

      register do
        name 'register_2'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1s; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :w1s; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1s; initial_value 0 }
      end

      register do
        name 'register_3'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1s; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :w1s; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1s; initial_value 0 }
      end

      register_file do
        name 'register_file_4'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1s; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :w1s; initial_value 0 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w1s; initial_value 0 }
          end
        end
      end
    end

    expect(bit_fields[0]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_0', direction: :output, data_type: :logic, width: 1
    )
    expect(bit_fields[0]).to have_port(
      :register_block, :clear,
      name: 'i_register_0_bit_field_0_clear', direction: :input, data_type: :logic, width: 1
    )

    expect(bit_fields[1]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_1', direction: :output, data_type: :logic, width: 2
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :clear,
      name: 'i_register_0_bit_field_1_clear', direction: :input, data_type: :logic, width: 2
    )

    expect(bit_fields[2]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [2], array_format: array_port_format
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :clear,
      name: 'i_register_0_bit_field_2_clear', direction: :input, data_type: :logic, width: 4,
      array_size: [2], array_format: array_port_format
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_0', direction: :output, data_type: :logic, width: 64
    )
    expect(bit_fields[3]).to have_port(
      :register_block, :clear,
      name: 'i_register_1_bit_field_0_clear', direction: :input, data_type: :logic, width: 64
    )

    expect(bit_fields[4]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[4]).to have_port(
      :register_block, :clear,
      name: 'i_register_2_bit_field_0_clear', direction: :input, data_type: :logic, width: 1,
      array_size: [4], array_format: array_port_format
    )

    expect(bit_fields[5]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_1', direction: :output, data_type: :logic, width: 2,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[5]).to have_port(
      :register_block, :clear,
      name: 'i_register_2_bit_field_1_clear', direction: :input, data_type: :logic, width: 2,
      array_size: [4], array_format: array_port_format
    )

    expect(bit_fields[6]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [4, 2], array_format: array_port_format
    )
    expect(bit_fields[6]).to have_port(
      :register_block, :clear,
      name: 'i_register_2_bit_field_2_clear', direction: :input, data_type: :logic, width: 4,
      array_size: [4, 2], array_format: array_port_format
    )

    expect(bit_fields[7]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[7]).to have_port(
      :register_block, :clear,
      name: 'i_register_3_bit_field_0_clear', direction: :input, data_type: :logic, width: 1,
      array_size: [2, 2], array_format: array_port_format
    )

    expect(bit_fields[8]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_1', direction: :output, data_type: :logic, width: 2,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :clear,
      name: 'i_register_3_bit_field_1_clear', direction: :input, data_type: :logic, width: 2,
      array_size: [2, 2], array_format: array_port_format
    )

    expect(bit_fields[9]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[9]).to have_port(
      :register_block, :clear,
      name: 'i_register_3_bit_field_2_clear', direction: :input, data_type: :logic, width: 4,
      array_size: [2, 2, 2], array_format: array_port_format
    )

    expect(bit_fields[10]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[10]).to have_port(
      :register_block, :clear,
      name: 'i_register_file_4_register_file_0_register_0_bit_field_0_clear', direction: :input, data_type: :logic, width: 1,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )

    expect(bit_fields[11]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_1', direction: :output, data_type: :logic, width: 2,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[11]).to have_port(
      :register_block, :clear,
      name: 'i_register_file_4_register_file_0_register_0_bit_field_1_clear', direction: :input, data_type: :logic, width: 2,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )

    expect(bit_fields[12]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[12]).to have_port(
      :register_block, :clear,
      name: 'i_register_file_4_register_file_0_register_0_bit_field_2_clear', direction: :input, data_type: :logic, width: 4,
      array_size: [2, 2, 2, 2, 2], array_format: array_port_format
    )
  end

  describe '#generate_code' do
    let(:array_port_format) { :packed }

    it 'rggen_bit_fieldをインスタンスするコードを出力する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1s; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 16; type :w1s; initial_value 0xabcd }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :w1s; initial_value 0 }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :w1s; initial_value 0 }
        end

        register do
          name 'register_3'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :w1s; initial_value 0 }
        end

        register do
          name 'register_4'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :w1s; initial_value 0 }
        end

        register_file do
          name 'register_file_5'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :w1s; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (1),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_1_SET)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         (i_register_0_bit_field_0_clear),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_0_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (16),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_1_SET)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         (i_register_0_bit_field_1_clear),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_0_bit_field_1),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (64),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_1_SET)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         (i_register_1_bit_field_0_clear),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_1_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_1_SET)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         (i_register_2_bit_field_0_clear[i]),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_2_bit_field_0[i]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_1_SET)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         (i_register_3_bit_field_0_clear[i][j]),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_3_bit_field_0[i][j]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_1_SET)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         (i_register_4_bit_field_0_clear[i][j][k]),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_4_bit_field_0[i][j][k]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_1_SET)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         (i_register_file_5_register_file_0_register_0_bit_field_0_clear[i][j][k][l][m]),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_file_5_register_file_0_register_0_bit_field_0[i][j][k][l][m]),
          .o_value_unmasked   ()
        );
      CODE
    end
  end
end
