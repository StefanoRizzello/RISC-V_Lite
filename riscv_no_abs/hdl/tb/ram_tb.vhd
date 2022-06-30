-------------------------------------------------------------------------------
-- Title      : Testbench for design "ram"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ram_tb.vhd
-- Author     : wackoz  <wackoz@wT14>
-- Company    : 
-- Created    : 2022-01-17
-- Last update: 2022-01-18
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-01-17  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity ram_tb is

end entity ram_tb;

-------------------------------------------------------------------------------

architecture test of ram_tb is
  component ram is
    port (
      clock    : in  std_logic;
      data     : in  std_logic_vector (31 downto 0);
      address  : in  integer range 0 to 31;
      w_en     : in  std_logic;
      q        : out std_logic_vector (31 downto 0);
      reset    : in  std_logic;
      filename : in  string(1 to 8));
  end component ram;

  -- component ports
  signal data     : std_logic_vector (31 downto 0) := (others => '0');
  signal address  : integer range 0 to 31;
  signal w_en     : std_logic                      := '0';
  signal q        : std_logic_vector (31 downto 0);
  signal reset    : std_logic                      := '1';
  signal filename : string(1 to 8)                 := "data.txt";
  -- filename must be of 8 char

  -- clock
  signal clock : std_logic := '1';

begin  -- architecture test
  -- component instantiation
  DUT : ram
    port map (
      clock    => clock,
      data     => data,
      address  => address,
      w_en     => w_en,
      q        => q,
      reset    => reset,
      filename => filename);

  -- clock generation
  clock <= not clock after 1 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    --reset test
    wait for 1 ns;
    reset   <= '0';
    wait for 3 ns;
    reset   <= '1';
    wait for 10.5 ns;
    -- write test
    address <= 25;
    data    <= std_logic_vector(to_unsigned(12, 32));
    w_en    <= '1';
    wait for 5 ns;
    data    <= std_logic_vector(to_unsigned(0, 32));
    wait for 5 ns;
    w_en    <= '0';
    wait for 30 ns;
    -- read test
    address <= 25;
    wait;
  end process WaveGen_Proc;

end architecture test;

-------------------------------------------------------------------------------

configuration ram_tb_test_cfg of ram_tb is
  for test
  end for;
end ram_tb_test_cfg;

-------------------------------------------------------------------------------
