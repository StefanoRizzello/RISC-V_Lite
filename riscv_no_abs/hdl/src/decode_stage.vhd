-------------------------------------------------------------------------------
-- Title      : RV32I decode stage
-- Project    : 
-------------------------------------------------------------------------------
-- File       : decode_stage.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-03
-- Last update: 2022-02-10
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

entity decode_stage is

  port (
    clock                : in  std_logic;
    reset                : in  std_logic;
    instruction_decode   : in  std_logic_vector(31 downto 0);
    instruction_execute  : out std_logic_vector(31 downto 0);  -- TO BE REMOVED
    pc_decode            : in  std_logic_vector(31 downto 0);
    next_pc_decode       : in  std_logic_vector(31 downto 0);
    RegWrite             : in  std_logic;
    write_reg_decode     : in  std_logic_vector(4 downto 0);
    write_data_decode    : in  std_logic_vector(31 downto 0);
    data_mem_adr         : in  std_logic_vector(31 downto 0);
    forward_mux_Rs1      : in  std_logic_vector(1 downto 0);
    forward_mux_Rs2      : in  std_logic_vector(1 downto 0);
    alu_ctrl_execute     : out std_logic_vector(3 downto 0);
    pc_execute           : out std_logic_vector(31 downto 0);
    next_pc_execute      : out std_logic_vector(31 downto 0);
    rd_execute           : out std_logic_vector(4 downto 0);
    read_data1_execute   : out std_logic_vector(31 downto 0);
    read_data2_execute   : out std_logic_vector(31 downto 0);
    shamt_execute        : out std_logic_vector(4 downto 0);
    Rs1_execute          : out std_logic_vector(4 downto 0);
    Rs2_execute          : out std_logic_vector(4 downto 0);
    Rs1_decode           : out std_logic_vector(4 downto 0);
    Rs2_decode           : out std_logic_vector(4 downto 0);
    target_address_fetch : out std_logic_vector(31 downto 0);
    Zero                 : out std_logic;
    immediate_execute    : out std_logic_vector(31 downto 0));

end entity decode_stage;

-------------------------------------------------------------------------------

architecture str of decode_stage is

  component reg_file is
    port (
      read_reg1, read_reg2   : in  std_logic_vector (4 downto 0);
      write_reg              : in  std_logic_vector (4 downto 0);
      clock, reset           : in  std_logic;
      write_data             : in  std_logic_vector (31 downto 0);
      write_en               : in  std_logic;
      read_data1, read_data2 : out std_logic_vector (31 downto 0));
  end component reg_file;

  component immediate_generator is
    port (
      instruction : in  std_logic_vector(31 downto 0);
      immediate   : out std_logic_vector(31 downto 0));
  end component immediate_generator;

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal read_data1_int, read_data2_int : std_logic_vector(31 downto 0);
  signal immediate_int                  : std_logic_vector(31 downto 0);
  signal alu_ctrl_int                   : std_logic_vector(3 downto 0);
  signal rd_int                         : std_logic_vector(4 downto 0);
  signal shamt_int                      : std_logic_vector(4 downto 0);

  signal Rs1_Decode_int : std_logic_vector(4 downto 0);
  signal Rs2_decode_int : std_logic_vector(4 downto 0);

  signal equality_A : std_logic_vector(31 downto 0);
  signal equality_B : std_logic_vector(31 downto 0);

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "register_file"
  register_file : reg_file
    port map (
      read_reg1  => Rs1_Decode_int,
      read_reg2  => Rs2_decode_int,
      write_reg  => write_reg_decode,
      clock      => clock,
      reset      => reset,
      write_data => write_data_decode,
      write_en   => RegWrite,
      read_data1 => read_data1_int,
      read_data2 => read_data2_int);


  -- instance "immediate_generator_1"
  immediate_generator_1 : immediate_generator
    port map (
      instruction => instruction_decode,
      immediate   => immediate_int);

  pipe : process (clock, reset) is
  begin  -- process pipe
    if reset = '0' then                 -- asynchronous reset (active low)
      immediate_execute   <= (others => '0');
      instruction_execute <= (others => '0');

      pc_execute       <= (others => '0');
      alu_ctrl_execute <= (others => '0');
      rd_execute       <= (others => '0');
      shamt_execute    <= (others => '0');
      next_pc_execute  <= (others => '0');
      Rs1_execute      <= (others => '0');
      Rs2_execute      <= (others => '0');

    elsif clock'event and clock = '1' then  -- rising clock edge
        pc_execute          <= pc_decode;
        instruction_execute <= instruction_decode;
        immediate_execute   <= immediate_int;
        alu_ctrl_execute <= alu_ctrl_int;
        rd_execute       <= rd_int;
        shamt_execute    <= shamt_int;
        next_pc_execute  <= next_pc_decode;
        Rs1_execute      <= Rs1_Decode_int;
        Rs2_execute      <= Rs2_decode_int;
    end if;
  end process pipe;

  --target address, shift already done in immediate generator output for branch
  --and jump instructions
  target_address_fetch <= std_logic_vector(signed(pc_decode) + (signed(immediate_int(31 downto 0))));

  -- instruction association
  alu_ctrl_int <= instruction_decode(30)&instruction_decode(14 downto 12);
  rd_int       <= instruction_decode(11 downto 7);
  shamt_int    <= instruction_decode(24 downto 20);

  Rs1_Decode_int <= instruction_decode(19 downto 15);
  Rs2_decode_int <= instruction_decode(24 downto 20);

  Rs1_decode <= Rs1_decode_int;
  Rs2_decode <= Rs2_decode_int;

  -- instance "mux_4to1_Rs1_forwarding"
  mux_4to1_Rs1_forwarding : entity work.mux_4to1
    port map (
      in_mux_0 => read_data1_int,
      in_mux_1 => write_data_decode,
      in_mux_2 => data_mem_adr,
      in_mux_3 => x"00000000",
      sel      => forward_mux_Rs1,
      out_mux  => equality_A);

  -- instance "mux_4to1_Rs2_forwarding"
  mux_4to1_Rs2_forwarding : entity work.mux_4to1
    port map (
      in_mux_0 => read_data2_int,
      in_mux_1 => write_data_decode,
      in_mux_2 => data_mem_adr,
      in_mux_3 => x"00000000",
      sel      => forward_mux_Rs2,
      out_mux  => equality_B);

  -- instance "equality_checker_1"
  equality_checker_1 : entity work.equality_checker
    port map (
      a     => equality_A,
      b     => equality_B,
      equal => Zero);

  pipe_read_data : process (clock, reset) is
  begin  -- process pipe
    if reset = '0' then                     -- asynchronous reset (active low)
      read_data1_execute <= (others => '0');
      read_data2_execute <= (others => '0');
    elsif clock'event and clock = '0' then  -- rising clock edge
        read_data1_execute <= read_data1_int;
        read_data2_execute <= read_data2_int;
    end if;
  end process pipe_read_data;

end architecture str;

-------------------------------------------------------------------------------
