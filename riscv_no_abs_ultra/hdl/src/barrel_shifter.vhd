-------------------------------------------------------------------------------
-- Title      : barrel_shifter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : barrel_shifter.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-22
-- Last update: 2022-02-01
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-01-22  1.0      stefano Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity barrel_shifter is

  port (
    x  : in  std_logic_vector(31 downto 0);
    sh : in  std_logic_vector(4 downto 0);
    y  : out std_logic_vector(31 downto 0));

end entity barrel_shifter;

-------------------------------------------------------------------------------

architecture str of barrel_shifter is

  component mux_2to1_bit is
    port (
      in_mux_0 : in  std_logic;
      in_mux_1 : in  std_logic;
      sel      : in  std_logic;
      out_mux  : out std_logic);
  end component mux_2to1_bit;

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal shift_value : std_logic_vector(31 downto 0);
  signal sh_out_1    : std_logic_vector(31 downto 0);
  signal sh_out_2    : std_logic_vector(31 downto 0);
  signal sh_out_3    : std_logic_vector(31 downto 0);
  signal sh_out_4    : std_logic_vector(31 downto 0);

begin  -- architecture str

  gen_stage0 : for i in 30 downto 0 generate
    mux_i : mux_2to1_bit
      port map (
        in_mux_0 => shift_value(i),
        in_mux_1 => shift_value(i+1),
        sel      => sh(0),
        out_mux  => sh_out_1(i));
  end generate gen_stage0;

  gen_stage1 : for i in 29 downto 0 generate
    mux_i : mux_2to1_bit
      port map (
        in_mux_0 => sh_out_1(i),
        in_mux_1 => sh_out_1(i+2),
        sel      => sh(1),
        out_mux  => sh_out_2(i));
  end generate gen_stage1;

  gen_stage2 : for i in 27 downto 0 generate
    mux_i : mux_2to1_bit
      port map (
        in_mux_0 => sh_out_2(i),
        in_mux_1 => sh_out_2(i+4),
        sel      => sh(2),
        out_mux  => sh_out_3(i));
  end generate gen_stage2;

  gen_stage3 : for i in 23 downto 0 generate
    mux_i : mux_2to1_bit
      port map (
        in_mux_0 => sh_out_3(i),
        in_mux_1 => sh_out_3(i+8),
        sel      => sh(3),
        out_mux  => sh_out_4(i));
  end generate gen_stage3;

  gen_stage4 : for i in 15 downto 0 generate
    mux_i : mux_2to1_bit
      port map (
        in_mux_0 => sh_out_4(i),
        in_mux_1 => sh_out_4(i+16),
        sel      => sh(4),
        out_mux  => y(i));
  end generate gen_stage4;

  shift_value  <= x;
  sh_out_1(31) <= shift_value(31);

  sh_out_2(31) <= sh_out_1(31);
  sh_out_2(30) <= sh_out_1(30);

  sh_out_3(31) <= sh_out_2(31);
  sh_out_3(30) <= sh_out_2(30);
  sh_out_3(29) <= sh_out_2(29);
  sh_out_3(28) <= sh_out_2(28);

  sh_out_4(31) <= sh_out_3(31);
  sh_out_4(30) <= sh_out_3(30);
  sh_out_4(29) <= sh_out_3(29);
  sh_out_4(28) <= sh_out_3(28);
  sh_out_4(27) <= sh_out_3(27);
  sh_out_4(26) <= sh_out_3(26);
  sh_out_4(25) <= sh_out_3(25);
  sh_out_4(24) <= sh_out_3(24);

  y(31) <= sh_out_4(31);
  y(30) <= sh_out_4(30);
  y(29) <= sh_out_4(29);
  y(28) <= sh_out_4(28);
  y(27) <= sh_out_4(27);
  y(26) <= sh_out_4(26);
  y(25) <= sh_out_4(25);
  y(24) <= sh_out_4(24);
  y(23) <= sh_out_4(23);
  y(22) <= sh_out_4(22);
  y(21) <= sh_out_4(21);
  y(20) <= sh_out_4(20);
  y(19) <= sh_out_4(19);
  y(18) <= sh_out_4(18);
  y(17) <= sh_out_4(17);
  y(16) <= sh_out_4(16);
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
