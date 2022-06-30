-------------------------------------------------------------------------------
-- Title      : Decoder5to32
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dec_5to32.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-02-01
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

entity dec_5to32 is
  port(
    in_dec  : in  std_logic_vector (4 downto 0);
    out_dec : out std_logic_vector (31 downto 0));
end dec_5to32;

architecture arch of dec_5to32 is
  
begin
  dec_proc : process (in_dec) is
  begin
    case in_dec is
      when "00000" => out_dec <= x"00000001";
      when "00001" => out_dec <= x"00000002";
      when "00010" => out_dec <= x"00000004";
      when "00011" => out_dec <= x"00000008";
      when "00100" => out_dec <= x"00000010";
      when "00101" => out_dec <= x"00000020";
      when "00110" => out_dec <= x"00000040";
      when "00111" => out_dec <= x"00000080";
      when "01000" => out_dec <= x"00000100";
      when "01001" => out_dec <= x"00000200";
      when "01010" => out_dec <= x"00000400";
      when "01011" => out_dec <= x"00000800";
      when "01100" => out_dec <= x"00001000";
      when "01101" => out_dec <= x"00002000";
      when "01110" => out_dec <= x"00004000";
      when "01111" => out_dec <= x"00008000";
      when "10000" => out_dec <= x"00010000";
      when "10001" => out_dec <= x"00020000";
      when "10010" => out_dec <= x"00040000";
      when "10011" => out_dec <= x"00080000";
      when "10100" => out_dec <= x"00100000";
      when "10101" => out_dec <= x"00200000";
      when "10110" => out_dec <= x"00400000";
      when "10111" => out_dec <= x"00800000";
      when "11000" => out_dec <= x"01000000";
      when "11001" => out_dec <= x"02000000";
      when "11010" => out_dec <= x"04000000";
      when "11011" => out_dec <= x"08000000";
      when "11100" => out_dec <= x"10000000";
      when "11101" => out_dec <= x"20000000";
      when "11110" => out_dec <= x"40000000";
      when "11111" => out_dec <= x"80000000";
      when others  => out_dec <= (others => '0');
    end case;
  end process;
end architecture arch;
