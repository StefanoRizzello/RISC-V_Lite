-------------------------------------------------------------------------------
-- Title      : Testbench for design "RV32I"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : RV32I_tb.vhd<2>
-- Author     :   <isa18_2021_2022@localhost.localdomain>
-- Company    : 
-- Created    : 2022-02-09
-- Last update: 2022-02-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-02-09  1.0      isa18_2021_2022	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity RV32I_tb is

end entity RV32I_tb;

-------------------------------------------------------------------------------

architecture arch of RV32I_tb is

  -- component ports
  signal clock               : std_logic;
  signal reset               : std_logic;
  signal instruction_fetch   : std_logic_vector(31 downto 0);
  signal instruction_mem_adr : std_logic_vector(31 downto 0);
  signal write_data_mem      : std_logic_vector(31 downto 0);
  signal read_data_mem       : std_logic_vector(31 downto 0);
  signal data_mem_adr        : std_logic_vector(31 downto 0);
  signal MemWrite            : std_logic;
  signal MemRead             : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture arch

  -- component instantiation
  DUT: entity work.RV32I
    port map (
      clock               => clock,
      reset               => reset,
      instruction_fetch   => instruction_fetch,
      instruction_mem_adr => instruction_mem_adr,
      write_data_mem      => write_data_mem,
      read_data_mem       => read_data_mem,
      data_mem_adr        => data_mem_adr,
      MemWrite            => MemWrite,
      MemRead             => MemRead);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here

    wait until Clk = '1';
  end process WaveGen_Proc;

  

end architecture arch;

-------------------------------------------------------------------------------

configuration RV32I_tb_arch_cfg of RV32I_tb is
  for arch
  end for;
end RV32I_tb_arch_cfg;

-------------------------------------------------------------------------------
