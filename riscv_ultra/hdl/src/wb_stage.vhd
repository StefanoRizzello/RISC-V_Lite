-------------------------------------------------------------------------------
-- Title      : wb_stage
-- Project    : RV32I
-------------------------------------------------------------------------------
-- File       : wb_stage.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-05
-- Last update: 2022-02-01
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

entity wb_stage is

  port (
    clock             : in  std_logic;
    reset             : in  std_logic;
    rd_wb             : in  std_logic_vector(4 downto 0);
    alu_result_wb     : in  std_logic_vector(31 downto 0);
    read_data_wb      : in  std_logic_vector(31 downto 0);
    next_pc_wb       : in  std_logic_vector(31 downto 0);
    write_data_decode : out std_logic_vector(31 downto 0);
    write_reg_decode  : out std_logic_vector(4 downto 0);
    MemToReg          : in  std_logic_vector(1 downto 0));

end entity wb_stage;

-------------------------------------------------------------------------------

architecture str of wb_stage is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal rd_wb_s : std_logic_vector(4 downto 0);

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "mux_4to1_1"
  mux_4to1_1 : entity work.mux_4to1
    port map (
      in_mux_0 => alu_result_wb,
      in_mux_1 => read_data_wb,
      in_mux_2 => next_pc_wb,
      in_mux_3 => x"00000000",
      sel      => MemToReg,
      out_mux  => write_data_decode);


  rd_wb_s          <= rd_wb;
  write_reg_decode <= rd_wb_s;

end architecture str;

-------------------------------------------------------------------------------
