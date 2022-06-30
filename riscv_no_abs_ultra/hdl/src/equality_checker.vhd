-------------------------------------------------------------------------------
-- Title      : Equality Checker
-- Project    : 
-------------------------------------------------------------------------------
-- File       : equality_checker.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-02-04
-- Last update: 2022-02-04
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

entity equality_checker is
  port (
    a     : in  std_logic_vector(31 downto 0);
    b     : in  std_logic_vector(31 downto 0);
    equal : out std_logic);

end entity equality_checker;

-------------------------------------------------------------------------------

architecture str of equality_checker is

  signal equal_vector : std_logic_vector(31 downto 0);
  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "unary_AND_1"
  unary_AND_1 : entity work.unary_AND
    port map (
      inp  => equal_vector,
      outp => equal);

  equal_vector <= not(a xor b);

end architecture str;

-------------------------------------------------------------------------------
