-------------------------------------------------------------------------------
-- Title      : add_sub
-- Project    : riscv-local
-------------------------------------------------------------------------------
-- File       : add_sub.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-18
-- Last update: 2022-02-04
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity add_sub is

  port (
    A   : in  std_logic_vector(31 downto 0);
    B   : in  std_logic_vector(31 downto 0);
    sel : in  std_logic;
    sum : out std_logic_vector(31 downto 0));

end entity add_sub;

-------------------------------------------------------------------------------

architecture str of add_sub is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal B_int : std_logic_vector(31 downto 0);

begin  -- architecture str

  add_sub_proc: process (B, sel) is
  begin  -- process add_sub
    if sel = '1' then
      B_int <= std_logic_vector(signed(not(B)) + 1);
    else
      B_int <= B;
    end if;
  end process add_sub_proc;

  sum <= std_logic_vector(signed(A) + signed(B_int));

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
