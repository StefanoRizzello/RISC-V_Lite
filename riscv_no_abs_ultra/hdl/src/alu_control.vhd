-------------------------------------------------------------------------------
-- Title      : alu_control
-- Project    : 
-------------------------------------------------------------------------------
-- File       : alu_control.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-10
-- Last update: 2022-02-02
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity alu_control is

  port (
    alu_ctrl_execute : in  std_logic_vector(3 downto 0);
    ALUOp_execute    : in  std_logic_vector(1 downto 0);
    ALUCtrl          : out std_logic_vector(3 downto 0));

end entity alu_control;

-------------------------------------------------------------------------------

architecture str of alu_control is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal funct7 : std_logic;
  signal funct3 : std_logic_vector(2 downto 0);

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  alu_ctrl_proc : process (ALUOp_execute, funct3, funct7) is
  begin  -- process alu_ctrl_proc
    ALUCtrl <= (others => '0');
    case ALUOp_execute is
      when "00" => ALUCtrl <= "0010";
      when "01" => ALUCtrl <= "0110";
      when "11" => ALUCtrl <= "0000";
      when "10" =>
        if (funct3 = "000") then ALUCtrl    <= "0010";  -- ADD
        elsif (funct7 = '0') and (funct3 = "010") then ALUCtrl <= "0100";  -- SET<
        elsif (funct7 = '0') and (funct3 = "100") then ALUCtrl <= "0111";  --XOR
        elsif (funct7 = '1') and (funct3 = "101") then ALUCtrl <= "0101";  --SHIFT
        elsif (funct3 = "111") then ALUCtrl                    <= "0011";  --ANDI
        end if;
      when others => null;
    end case;
  end process alu_ctrl_proc;

  funct7 <= alu_ctrl_execute(3);
  funct3 <= alu_ctrl_execute(2 downto 0);

end architecture str;

-------------------------------------------------------------------------------
