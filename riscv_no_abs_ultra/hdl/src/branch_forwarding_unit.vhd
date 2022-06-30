-------------------------------------------------------------------------------
-- Title      : branch_forwarding_unit
-- Project    : 
-------------------------------------------------------------------------------
-- File       : branch_forwarding_unit.vhd
-- Author     : stefano  <stefano@stefano-N56JK>
-- Company    : 
-- Created    : 2022-02-04
-- Last update: 2022-02-06
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-02-04  1.0      stefano Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
entity branch_forwarding_unit is

  port (
    Rs1_decode      : in  std_logic_vector(4 downto 0);
    Rs2_decode      : in  std_logic_vector(4 downto 0);
    Rd_mem          : in  std_logic_vector(4 downto 0);
    Rd_wb           : in  std_logic_vector(4 downto 0);
    opcode_decode   : in  std_logic_vector(6 downto 0);
    RegWrite_mem    : in  std_logic;
    RegWrite        : in  std_logic;
    forward_mux_Rs1 : out std_logic_vector(1 downto 0);
    forward_mux_Rs2 : out std_logic_vector(1 downto 0));

end entity branch_forwarding_unit;

-------------------------------------------------------------------------------

architecture str of branch_forwarding_unit is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  forwarding_proc : process (Rs1_decode, Rs2_decode, Rd_mem, Rd_wb, RegWrite_mem, RegWrite) is
  begin  -- process forwarding_proc
    -- EX Hazard
    if (RegWrite = '1' and (Rd_wb /= "00000") and not ((RegWrite_mem = '1') and (Rd_mem /= "00000") and (Rd_mem = Rs1_decode)) and (Rd_wb = Rs1_decode)) then
      forward_mux_Rs1 <= "01";
    elsif (RegWrite_mem = '1' and (Rd_mem /= "00000") and (Rd_mem = Rs1_decode)) then
      forward_mux_Rs1 <= "10";
    else
      forward_mux_Rs1 <= "00";
    end if;
    -- MEM Hazard
    if (RegWrite = '1' and (Rd_wb /= "00000") and not ((RegWrite_mem = '1') and (Rd_mem /= "00000") and (Rd_mem = Rs2_decode)) and (Rd_wb = Rs2_decode)) then
      forward_mux_Rs2 <= "01";
    elsif (RegWrite_mem = '1' and (Rd_mem /= "00000") and (Rd_mem = Rs2_decode)) then
      forward_mux_Rs2 <= "10";
    else
      forward_mux_Rs2 <= "00";
    end if;
  end process forwarding_proc;

 
-----------------------------------------------------------------------------
-- Component instantiations
-----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
