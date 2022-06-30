-------------------------------------------------------------------------------
-- Title      : execute_stage_control
-- Project    : 
-------------------------------------------------------------------------------
-- File       : execute_stage_control.vhd
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
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity execute_stage_control is

  port (
    clock            : in  std_logic;
    reset            : in  std_logic;
    alu_ctrl_execute : in  std_logic_vector(3 downto 0);
    MemRead_execute  : in  std_logic;
    ALUOp_execute    : in  std_logic_vector(1 downto 0);
    MemToReg_execute : in  std_logic_vector(1 downto 0);
    MemWrite_execute : in  std_logic;
    RegWrite_execute : in  std_logic;
    opcode_execute   : in  std_logic_vector(6 downto 0);
    MemWrite         : out std_logic;
    MemRead          : out std_logic;
    MemToReg_mem     : out std_logic_vector(1 downto 0);
    RegWrite_mem     : out std_logic;
    ALUCtrl          : out std_logic_vector(3 downto 0);

    -- ports to "forwarding_unit_1"
    Rs1_execute : in  std_logic_vector(4 downto 0);
    Rs2_execute : in  std_logic_vector(4 downto 0);
    Rd_mem      : in  std_logic_vector(4 downto 0);
    Rd_wb       : in  std_logic_vector(4 downto 0);
    RegWrite    : in  std_logic;
    forward_A   : out std_logic_vector(1 downto 0);
    forward_B   : out std_logic_vector(1 downto 0));

end entity execute_stage_control;

-------------------------------------------------------------------------------

architecture str of execute_stage_control is

  component alu_control is
    port (
      alu_ctrl_execute : in  std_logic_vector(3 downto 0);
      ALUOp_execute    : in  std_logic_vector(1 downto 0);
      ALUCtrl          : out std_logic_vector(3 downto 0));
  end component alu_control;

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal RegWrite_mem_int : std_logic;

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "alu_control_1"
  alu_control_1 : entity work.alu_control
    port map (
      alu_ctrl_execute => alu_ctrl_execute,
      ALUOp_execute    => ALUOp_execute,
      ALUCtrl          => ALUCtrl);

  pipe : process (clock, reset) is
  begin  -- process pipe
    if reset = '0' then                     -- asynchronous reset (active low)
      MemWrite         <= '0';
      MemRead          <= '0';
      MemToReg_mem     <= "00";
      RegWrite_mem_int <= '0';
    elsif clock'event and clock = '1' then  -- rising clock edge
        MemWrite         <= MemWrite_execute;
        MemRead          <= MemRead_execute;
        MemToReg_mem     <= MemToReg_execute;
        RegWrite_mem_int <= RegWrite_execute;
    end if;
    end process pipe;

      -- instance "forwarding_unit_1"
      forwarding_unit_1 : entity work.forwarding_unit
        port map (
          Rs1_execute    => Rs1_execute,
          Rs2_execute    => Rs2_execute,
          Rd_mem         => Rd_mem,
          Rd_wb          => Rd_wb,
          RegWrite_mem   => RegWrite_mem_int,
          opcode_execute => opcode_execute,
          RegWrite       => RegWrite,
          forward_A      => forward_A,
          forward_B      => forward_B);

      RegWrite_mem <= RegWrite_mem_int;

    end architecture str;

-------------------------------------------------------------------------------
