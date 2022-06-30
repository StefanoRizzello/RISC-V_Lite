-------------------------------------------------------------------------------
-- Title      : mux_4to1
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mux_4to1.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-25
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

-------------------------------------------------------------------------------

entity mux_4to1 is

  port(
    in_mux_0 : in  std_logic_vector(31 downto 0);
    in_mux_1 : in  std_logic_vector(31 downto 0);
    in_mux_2 : in  std_logic_vector(31 downto 0);
    in_mux_3 : in  std_logic_vector(31 downto 0);
    sel      : in  std_logic_vector(1 downto 0);
    out_mux  : out std_logic_vector (31 downto 0));

end entity mux_4to1;

-------------------------------------------------------------------------------

architecture str of mux_4to1 is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  mux_proc : process (sel, in_mux_0, in_mux_1, in_mux_2, in_mux_3) is
  begin  -- process mux_proc
    if sel = "00" then
      out_mux <= in_mux_0;
    elsif sel = "01" then
      out_mux <= in_mux_1;
    elsif sel = "10" then
      out_mux <= in_mux_2;
    else
      out_mux <= in_mux_3;
    end if;
  end process mux_proc;

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
