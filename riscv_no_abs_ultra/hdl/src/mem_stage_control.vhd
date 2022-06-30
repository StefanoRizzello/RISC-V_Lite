-------------------------------------------------------------------------------
-- Title      : mem_stage_control
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mem_stage_control.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-10
-- Last update: 2022-02-10
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

entity mem_stage_control is

  port (
    clock         : in  std_logic;
    reset         : in  std_logic;
    MemToReg_mem  : in  std_logic_vector(1 downto 0);
    RegWrite_mem  : in  std_logic;
    RegWrite      : out std_logic;
    MemToReg      : out std_logic_vector(1 downto 0));

end entity mem_stage_control;

-------------------------------------------------------------------------------

architecture str of mem_stage_control is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------


begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  pipe : process (clock, reset) is
  begin  -- process mem_ctrl_proc
    if reset = '0' then                 -- asynchronous reset (active low)
      MemToReg <= "00";
      RegWrite <= '0';
    elsif clock'event and clock = '1' then
      MemToReg <= MemToReg_mem;
      RegWrite <= RegWrite_mem;
    end if;  -- rising clock 
  end process pipe;

end architecture str;

-------------------------------------------------------------------------------
