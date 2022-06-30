-------------------------------------------------------------------------------
-- Title      : RV32I
-- Project    : RV32I
-------------------------------------------------------------------------------
-- File       : RV32I.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-05
-- Last update: 2022-02-12
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity RV32I is

  port (
    -- instruction
    instruction_decode  : out std_logic_vector(31 downto 0);
    instruction_execute : out std_logic_vector(31 downto 0);
    -- global ports
    clock               : in  std_logic;
    reset               : in  std_logic;
    instruction_fetch   : in  std_logic_vector(31 downto 0);

    -- ports to "fetch_stage_1"
    instruction_mem_adr : out std_logic_vector(31 downto 0);

    -- ports to "execute_stage_1"
    write_data_mem : out std_logic_vector(31 downto 0);

    -- ports to "mem_stage_1"
    read_data_mem : in  std_logic_vector(31 downto 0);
    data_mem_adr  : out std_logic_vector(31 downto 0);

    -- ports to "RV32I_control_1"
    MemWrite : out std_logic;
    MemRead  : out std_logic);

end entity RV32I;

-------------------------------------------------------------------------------

architecture str of RV32I is

-----------------------------------------------------------------------------
-- Internal signal declarations
-----------------------------------------------------------------------------

  -- outputs of "fetch_stage_1"
  signal pc_decode      : std_logic_vector(31 downto 0);
  signal next_pc_decode : std_logic_vector(31 downto 0);
  signal Rs1_fetch      : std_logic_vector(4 downto 0);
  signal Rs2_fetch      : std_logic_vector(4 downto 0);
  signal Rd_decode      : std_logic_vector(4 downto 0);

  -- outputs of "decode_stage_1"
  signal alu_ctrl_execute     : std_logic_vector(3 downto 0);
  signal pc_execute           : std_logic_vector(31 downto 0);
  signal next_pc_execute      : std_logic_vector(31 downto 0);
  signal rd_execute           : std_logic_vector(4 downto 0);
  signal read_data1_execute   : std_logic_vector(31 downto 0);
  signal read_data2_execute   : std_logic_vector(31 downto 0);
  signal shamt_execute        : std_logic_vector(4 downto 0);
  signal Rs1_execute          : std_logic_vector(4 downto 0);
  signal Rs2_execute          : std_logic_vector(4 downto 0);
  signal Rs1_decode           : std_logic_vector(4 downto 0);
  signal Rs2_decode           : std_logic_vector(4 downto 0);
  signal target_address_fetch : std_logic_vector(31 downto 0);
  signal Zero                 : std_logic;
  signal immediate_execute    : std_logic_vector(31 downto 0);

  -- outputs of "execute_stage_1"
  signal alu_result_mem   : std_logic_vector(31 downto 0);
  signal data_mem_adr_int : std_logic_vector(31 downto 0);
  signal next_pc_mem      : std_logic_vector(31 downto 0);
  signal rd_mem           : std_logic_vector(4 downto 0);

  -- outputs of "mem_stage_1"
  signal rd_wb         : std_logic_vector(4 downto 0);
  signal alu_result_wb : std_logic_vector(31 downto 0);
  signal next_pc_wb    : std_logic_vector(31 downto 0);
  signal read_data_wb  : std_logic_vector(31 downto 0);

  -- outputs of "wb_stage_1"
  signal write_data_decode : std_logic_vector(31 downto 0);
  signal write_reg_decode  : std_logic_vector(4 downto 0);

  -- outputs of "RV32I_control_1"
  signal PcWrite         : std_logic;
  signal PipeWrite_fetch : std_logic;
  signal PCSrc           : std_logic;
  signal forward_mux_Rs1 : std_logic_vector(1 downto 0);
  signal forward_mux_Rs2 : std_logic_vector(1 downto 0);
  signal ALUSrc          : std_logic;
  signal PCSel           : std_logic;
  signal ALUCtrl         : std_logic_vector(3 downto 0);
  signal forward_A       : std_logic_vector(1 downto 0);
  signal forward_B       : std_logic_vector(1 downto 0);
  signal RegWrite        : std_logic;
  signal MemToReg        : std_logic_vector(1 downto 0);

  signal instruction_decode_int : std_logic_vector(31 downto 0);

begin  -- architecture str

-----------------------------------------------------------------------------
-- Component instantiations
----------------------------------------------------------------------------

  -- instance "fetch_stage_1"
  fetch_stage_1 : entity work.fetch_stage
    port map (
      clock                => clock,
      reset                => reset,
      PCSrc                => PCSrc,
      PcWrite              => PcWrite,
      instruction_fetch    => instruction_fetch,
      target_address_fetch => target_address_fetch,
      Rs1_fetch            => Rs1_fetch,
      Rs2_fetch            => Rs2_fetch,
      Rd_decode            => Rd_decode,
      PipeWrite_fetch      => PipeWrite_fetch,
      instruction_mem_adr  => instruction_mem_adr,
      pc_decode            => pc_decode,
      next_pc_decode       => next_pc_decode,
      instruction_decode   => instruction_decode_int);

  -- instance "decode_stage_1"
  decode_stage_1 : entity work.decode_stage
    port map (
      clock                => clock,
      reset                => reset,
      instruction_decode   => instruction_decode_int,
      instruction_execute  => instruction_execute,
      pc_decode            => pc_decode,
      next_pc_decode       => next_pc_decode,
      RegWrite             => RegWrite,
      write_reg_decode     => write_reg_decode,
      write_data_decode    => write_data_decode,
      data_mem_adr         => data_mem_adr_int,
      forward_mux_Rs1      => forward_mux_Rs1,
      forward_mux_Rs2      => forward_mux_Rs2,
      alu_ctrl_execute     => alu_ctrl_execute,
      pc_execute           => pc_execute,
      next_pc_execute      => next_pc_execute,
      rd_execute           => rd_execute,
      read_data1_execute   => read_data1_execute,
      read_data2_execute   => read_data2_execute,
      shamt_execute        => shamt_execute,
      Rs1_execute          => Rs1_execute,
      Rs2_execute          => Rs2_execute,
      Rs1_decode           => Rs1_decode,
      Rs2_decode           => Rs2_decode,
      target_address_fetch => target_address_fetch,
      Zero                 => Zero,
      immediate_execute    => immediate_execute);

  -- instance "execute_stage_1"
  execute_stage_1 : entity work.execute_stage
    port map (
      clock              => clock,
      reset              => reset,
      ALUSrc             => ALUSrc,
      PCSel              => PCSel,
      ALUCtrl            => ALUCtrl,
      shamt_execute      => shamt_execute,
      pc_execute         => pc_execute,
      next_pc_execute    => next_pc_execute,
      rd_execute         => rd_execute,
      read_data1_execute => read_data1_execute,
      read_data2_execute => read_data2_execute,
      immediate_execute  => immediate_execute,
      forward_A          => forward_A,
      forward_B          => forward_B,
      write_data_decode  => write_data_decode,
      alu_result_mem     => alu_result_mem,
      write_data_mem     => write_data_mem,
      data_mem_adr       => data_mem_adr_int,
      next_pc_mem        => next_pc_mem,
      rd_mem             => rd_mem);

  -- instance "mem_stage_1"
  mem_stage_1 : entity work.mem_stage
    port map (
      clock          => clock,
      reset          => reset,
      alu_result_mem => alu_result_mem,
      next_pc_mem    => next_pc_mem,
      rd_mem         => rd_mem,
      read_data_mem  => read_data_mem,
      rd_wb          => rd_wb,
      alu_result_wb  => alu_result_wb,
      next_pc_wb     => next_pc_wb,
      read_data_wb   => read_data_wb);

  -- instance "wb_stage_1"
  wb_stage_1 : entity work.wb_stage
    port map (
      clock             => clock,
      reset             => reset,
      rd_wb             => rd_wb,
      alu_result_wb     => alu_result_wb,
      read_data_wb      => read_data_wb,
      next_pc_wb        => next_pc_wb,
      write_data_decode => write_data_decode,
      write_reg_decode  => write_reg_decode,
      MemToReg          => MemToReg);

  -- instance "RV32I_control_1"
  RV32I_control_1 : entity work.RV32I_control
    port map (
      clock              => clock,
      reset              => reset,
      instruction_fetch  => instruction_fetch,
      instruction_decode => instruction_decode_int,
      Rs1_decode         => Rs1_decode,
      Rs2_decode         => Rs2_decode,
      Rd_execute         => Rd_execute,
      Zero               => Zero,
      Rs1_fetch          => Rs1_fetch,
      Rs2_fetch          => Rs2_fetch,
      Rd_decode          => Rd_decode,
      PcWrite            => PcWrite,
      PipeWrite_fetch    => PipeWrite_fetch,
      PCSrc              => PCSrc,
      forward_mux_Rs1    => forward_mux_Rs1,
      forward_mux_Rs2    => forward_mux_Rs2,
      ALUSrc             => ALUSrc,
      PCSel              => PCSel,
      alu_ctrl_execute   => alu_ctrl_execute,
      MemWrite           => MemWrite,
      MemRead            => MemRead,
      ALUCtrl            => ALUCtrl,
      Rs1_execute        => Rs1_execute,
      Rs2_execute        => Rs2_execute,
      Rd_mem             => Rd_mem,
      Rd_wb              => Rd_wb,
      forward_A          => forward_A,
      forward_B          => forward_B,
      RegWrite           => RegWrite,
      MemToReg           => MemToReg);

  instruction_decode <= instruction_decode_int;
  data_mem_adr       <= data_mem_adr_int;
end architecture str;

-------------------------------------------------------------------------------
