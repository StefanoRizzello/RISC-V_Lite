-------------------------------------------------------------------------------
-- Title      : forwarding_unit
-- Project    : 
-------------------------------------------------------------------------------
-- File       : forwarding_unit.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-30
-- Last update: 2022-02-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;               -- purpose: 

-------------------------------------------------------------------------------

entity forwarding_unit is

  port (
    Rs1_execute    : in  std_logic_vector(4 downto 0);
    Rs2_execute    : in  std_logic_vector(4 downto 0);
    Rd_mem         : in  std_logic_vector(4 downto 0);
    Rd_wb          : in  std_logic_vector(4 downto 0);
    opcode_execute : in  std_logic_vector(6 downto 0);
    RegWrite_mem   : in  std_logic;
    RegWrite       : in  std_logic;
    forward_A      : out std_logic_vector(1 downto 0);
    forward_B      : out std_logic_vector(1 downto 0));

end entity forwarding_unit;

-------------------------------------------------------------------------------

architecture str of forwarding_unit is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal Rs1_execute_int : std_logic_vector(4 downto 0);
  signal Rs2_execute_int : std_logic_vector(4 downto 0);
  signal Rd_mem_int      : std_logic_vector(4 downto 0);
  signal Rd_wb_int       : std_logic_vector(4 downto 0);

begin  -- architecture str

  forwarding_proc : process (Rs1_execute_int, Rs2_execute_int, Rd_mem_int, Rd_wb_int, RegWrite_mem, RegWrite) is
  begin  -- process forwarding_proc
    -- EX Hazard
    if (RegWrite = '1' and (Rd_wb_int /= "00000") and not ((RegWrite_mem = '1') and (Rd_mem_int /= "00000") and (Rd_mem_int = Rs1_execute_int)) and (Rd_wb_int = Rs1_execute_int)) then
      forward_A <= "01";
    elsif (RegWrite_mem = '1' and (Rd_mem_int /= "00000") and (Rd_mem_int = Rs1_execute_int)) then
      forward_A <= "10";
    else
      forward_A <= "00";
    end if;
    -- MEM Hazard
    if (RegWrite = '1' and (Rd_wb_int /= "00000") and not ((RegWrite_mem = '1') and (Rd_mem_int /= "00000") and (Rd_mem_int = Rs2_execute_int)) and (Rd_wb_int = Rs2_execute_int)) then
      forward_B <= "01";
    elsif (RegWrite_mem = '1' and (Rd_mem_int /= "00000") and (Rd_mem_int = Rs2_execute_int)) then
      forward_B <= "10";
    else
      forward_B <= "00";
    end if;
  end process forwarding_proc;

  reg_detect_proc : process (opcode_execute, Rs1_execute, Rs2_execute, Rd_mem, Rd_wb) is
  begin  -- process reg_detect_proc
    if opcode_execute = "0110111" then     --LUI
      Rs1_execute_int <= "00000";
      Rs2_execute_int <= "00000";
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    elsif opcode_execute = "0010111" then  --AUIPC
      Rs1_execute_int <= "00000";
      Rs2_execute_int <= "00000";
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    elsif opcode_execute = "1101111" then  --JAL
      Rs1_execute_int <= "00000";
      Rs2_execute_int <= "00000";
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    elsif opcode_execute = "1100011" then  --BEQ
      Rs1_execute_int <= Rs1_execute;
      Rs2_execute_int <= Rs2_execute;
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    elsif opcode_execute = "0000011" then  --LW
      Rs1_execute_int <= Rs1_execute;
      Rs2_execute_int <= "00000";
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    elsif opcode_execute = "0100011" then  --SW
      Rs1_execute_int <= Rs1_execute;
      Rs2_execute_int <= Rs2_execute;
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    elsif opcode_execute = "0010011" then  --ADDI / ANDI
      Rs1_execute_int <= Rs1_execute;
      Rs2_execute_int <= "00000";
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    elsif opcode_execute = "0010011" then  -- SRAI
      Rs1_execute_int <= Rs1_execute;
      Rs2_execute_int <= "00000";
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    elsif opcode_execute = "0110011" then  --ADD / SLT / XOR
      Rs1_execute_int <= Rs1_execute;
      Rs2_execute_int <= Rs2_execute;
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    elsif opcode_execute = "0001011" then  --ABSOLUTE
      Rs1_execute_int <= Rs1_execute;
      Rs2_execute_int <= "00000";
      Rd_mem_int      <= Rd_mem;
      Rd_wb_int       <= Rd_wb;
    else
      Rs1_execute_int <= "00000";
      Rs2_execute_int <= "00000";
      Rd_mem_int      <= "00000";
      Rd_wb_int       <= "00000";
    end if;
  end process reg_detect_proc;


-----------------------------------------------------------------------------
-- Component instantiations
-----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
