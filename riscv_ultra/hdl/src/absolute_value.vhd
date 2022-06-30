-------------------------------------------------------------------------------
-- Title      : absolute_value
-- Project    : 
-------------------------------------------------------------------------------
-- File       : absolute_value.vhd
-- Author     : stefano  <stefano@stefano-N56JK>
-- Company    : 
-- Created    : 2022-02-02
-- Last update: 2022-02-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-02-02  1.0      stefano Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity absolute_value is

  port (
    in_abs  : in  std_logic_vector(31 downto 0);
    out_abs : out std_logic_vector(31 downto 0));

end entity absolute_value;

-------------------------------------------------------------------------------

architecture str of absolute_value is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal out_abs_int : std_logic_vector(31 downto 0);

begin  -- architecture str

  abs_proc : process (in_abs) is
  begin  -- process abs_proc
    out_abs_int <= (others => '0');
    if in_abs(31) = '1' then
      out_abs_int <= std_logic_vector(signed(not(in_abs)) + 1);
    else
      out_abs_int <= in_abs;
    end if;
  end process abs_proc;

  out_abs <= out_abs_int;
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
