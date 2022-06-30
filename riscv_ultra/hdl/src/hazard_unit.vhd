-------------------------------------------------------------------------------
-- Title      : hazard_unit
-- Project    : 
-------------------------------------------------------------------------------
-- File       : hazard_unit.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-31
-- Last update: 2022-02-13
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

entity hazard_unit is

  port (
    clock           : in  std_logic;
    reset           : in  std_logic;
    MemRead_decode  : in  std_logic;
    MemWrite_decode : in  std_logic;
    PCSrc           : in  std_logic;
    opcode_fetch    : in  std_logic_vector(6 downto 0);
    opcode_decode   : in  std_logic_vector(6 downto 0);
    Rs1_decode      : in  std_logic_vector(4 downto 0);
    Rs2_decode      : in  std_logic_vector(4 downto 0);
    Rs1_fetch       : in  std_logic_vector(4 downto 0);
    Rs2_fetch       : in  std_logic_vector(4 downto 0);
    Rd_execute      : in  std_logic_vector(4 downto 0);
    Rd_decode       : in  std_logic_vector(4 downto 0);
    PcWrite         : out std_logic;
    PipeWrite_fetch : out std_logic;
    StallSrc        : out std_logic);

end entity hazard_unit;
-------------------------------------------------------------------------------

architecture str of hazard_unit is
  type states is (idle, idle2, nop, stall, stall1, stall2);
  signal current_state, next_state : states;
-----------------------------------------------------------------------------
-- Internal signal declarations
-----------------------------------------------------------------------------
begin  -- architecture str

  fsm : process (clock, reset) is
  begin  -- process fsm
    if reset = '0' then                     -- asynchronous reset (active low)
      current_state <= idle;
    elsif clock'event and clock = '1' then  -- falling clock edge
      current_state <= next_state;
    end if;
  end process fsm;

  state_ev : process(MemRead_decode, PCSrc, current_state, opcode_decode,
                     opcode_fetch, rd_decode, rs1_fetch, rs2_fetch) is
  begin  -- process state_ev
    case current_state is
      when idle =>
        if ((opcode_fetch = "1100011") and (opcode_decode = "0000011")
            and((rs1_fetch = rd_decode) or (rs2_fetch = rd_decode))) then
          next_state <= stall1;         -- BEQ stall twice if decode inst is LW
        elsif ((opcode_fetch = "1100011") and (opcode_decode /= "1100011"
                                               or opcode_decode /= "0100011")
               and((rs1_fetch = rd_decode) or (rs2_fetch = rd_decode))) then
          next_state <= stall;          -- BEQ stall once for other inst
        elsif (opcode_fetch = "1101111" or opcode_fetch = "1100011") then  --JAL/BEQ common case
          next_state <= idle2;
        elsif (MemRead_decode = '1' and ((Rd_decode = Rs1_fetch) or (Rd_decode = Rs2_fetch))) then
          next_state <= stall;          --REVIEW
        else
          next_state <= idle;
        end if;

      when idle2 =>
        -- if PCSrc = '0' then
        --   next_state <= idle;
        if PCSrc = '1' then
          next_state <= nop;
        elsif ((opcode_fetch = "1100011") and (opcode_decode = "0000011")
               and((rs1_fetch = rd_decode) or (rs2_fetch = rd_decode))) then
          next_state <= stall1;         -- BEQ stall twice if decode inst is LW
        elsif ((opcode_fetch = "1100011") and (opcode_decode /= "1100011"
                                               or opcode_decode /= "0100011")
               and((rs1_fetch = rd_decode) or (rs2_fetch = rd_decode))) then
          next_state <= stall;          -- BEQ stall once for other inst
        elsif (opcode_fetch = "1101111" or opcode_fetch = "1100011") then  --JAL/BEQ common case
          next_state <= idle2;
        elsif (MemRead_decode = '1' and ((Rd_decode = Rs1_fetch) or (Rd_decode = Rs2_fetch))) then
          next_state <= stall;          --REVIEW
        else
          next_state <= idle;
        end if;

      when stall =>
        next_state <= idle2;

      when stall1 =>
        next_state <= stall2;

      when stall2 =>
        next_state <= idle2;

      when nop =>
        next_state <= idle;

      when others =>
        next_state <= idle;
    end case;
  end process state_ev;

  state_as : process (current_state) is
  begin  -- process state_as
    PcWrite         <= '1';
    PipeWrite_fetch <= '1';
    StallSrc        <= '1';
    case current_state is
      when idle =>
      when idle2 =>
      when stall =>
        StallSrc        <= '0';
        PCWrite         <= '0';
        PipeWrite_fetch <= '0';
      when stall1 =>
        StallSrc        <= '0';
        PCWrite         <= '0';
        PipeWrite_fetch <= '0';
      when stall2 =>
        StallSrc        <= '0';
        PCWrite         <= '0';
        PipeWrite_fetch <= '0';
      when nop =>
        StallSrc <= '0';
      when others => null;
    end case;
  end process state_as;
-----------------------------------------------------------------------------
-- Component instantiations
-----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
