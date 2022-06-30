-------------------------------------------------------------------------------
-- Title      : RV32I execute stage
-- Project    : 
-------------------------------------------------------------------------------
-- File       : execute_stage.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-03
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

entity execute_stage is

  port (
    clock              : in  std_logic;
    reset              : in  std_logic;
    ALUSrc             : in  std_logic;
    PCSel              : in  std_logic;
    ALUCtrl            : in  std_logic_vector(3 downto 0);
    shamt_execute      : in  std_logic_vector(4 downto 0);
    pc_execute         : in  std_logic_vector(31 downto 0);
    next_pc_execute    : in  std_logic_vector(31 downto 0);
    rd_execute         : in  std_logic_vector(4 downto 0);
    read_data1_execute : in  std_logic_vector(31 downto 0);
    read_data2_execute : in  std_logic_vector(31 downto 0);
    immediate_execute  : in  std_logic_vector(31 downto 0);
    forward_A          : in  std_logic_vector(1 downto 0);
    forward_B          : in  std_logic_vector(1 downto 0);
    write_data_decode  : in  std_logic_vector(31 downto 0);
    alu_result_mem     : out std_logic_vector(31 downto 0);
    write_data_mem     : out std_logic_vector(31 downto 0);
    data_mem_adr       : out std_logic_vector(31 downto 0);
    next_pc_mem        : out std_logic_vector(31 downto 0);
    rd_mem             : out std_logic_vector(4 downto 0));

end entity execute_stage;

-------------------------------------------------------------------------------

architecture str of execute_stage is

  component mux_2to1 is
    port (
      in_mux_0 : in  std_logic_vector(31 downto 0);
      in_mux_1 : in  std_logic_vector(31 downto 0);
      sel      : in  std_logic;
      out_mux  : out std_logic_vector (31 downto 0));
  end component mux_2to1;

  component alu is
    port (
      A       : in  std_logic_vector(31 downto 0);
      B       : in  std_logic_vector(31 downto 0);
      ALUCtrl : in  std_logic_vector(3 downto 0);
      shamt   : in  std_logic_vector(4 downto 0);
      result  : out std_logic_vector(31 downto 0));
  end component alu;

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal alu_A, alu_B, alu_result_int : std_logic_vector(31 downto 0);
  signal out_mux_forward_A            : std_logic_vector(31 downto 0);
  signal out_mux_forward_B            : std_logic_vector(31 downto 0);
  
  signal data_mem_adr_int : std_logic_vector(31 downto 0);

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "mux_alu_b"
  alu_b_mux : mux_2to1
    port map (
      in_mux_0 => out_mux_forward_B,
      in_mux_1 => immediate_execute,
      sel      => ALUSrc,
      out_mux  => alu_B);

  -- instance "mux_PC"
  mux_PC : mux_2to1
    port map (
      in_mux_0 => out_mux_forward_A,
      in_mux_1 => pc_execute,
      sel      => PCSel,
      out_mux  => alu_A);

  -- instance "alu_inst"
  alu_inst : alu
    port map (
      A       => alu_A,
      B       => alu_B,
      ALUCtrl => ALUCtrl,
      shamt   => shamt_execute,
      result  => alu_result_int);



  pipe : process (clock, reset) is
  begin  -- process pipe
    if reset = '0' then                     -- asynchronous reset (active low)
      alu_result_mem   <= (others => '0');
      rd_mem           <= (others => '0');
      write_data_mem   <= (others => '0');
      data_mem_adr_int <= (others => '0');
      next_pc_mem      <= (others => '0');
    elsif clock'event and clock = '1' then  -- rising clock edge
      alu_result_mem   <= alu_result_int;
      rd_mem           <= rd_execute;
      write_data_mem   <= out_mux_forward_B;
      data_mem_adr_int <= alu_result_int;
      next_pc_mem      <= next_pc_execute;
    end if;
  end process pipe;

  -- instance "forward_A_mux"
  forward_A_mux : entity work.mux_4to1
    port map (
      in_mux_0 => read_data1_execute,
      in_mux_1 => write_data_decode,
      in_mux_2 => data_mem_adr_int,
      in_mux_3 => x"00000000",
      sel      => forward_A,
      out_mux  => out_mux_forward_A);

  -- instance "forward_B_mux"
  forward_B_mux : entity work.mux_4to1
    port map (
      in_mux_0 => read_data2_execute,
      in_mux_1 => write_data_decode,
      in_mux_2 => data_mem_adr_int,
      in_mux_3 => x"00000000",
      sel      => forward_B,
      out_mux  => out_mux_forward_B);

  data_mem_adr <= data_mem_adr_int;
  
end architecture str;

-------------------------------------------------------------------------------
