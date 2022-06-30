-------------------------------------------------------------------------------
-- Title      : Testbench for design "RV32I"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : RV32I_tb.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-10
-- Last update: 2022-02-11
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
use ieee.std_logic_textio.all;
use std.textio.all;

-------------------------------------------------------------------------------

entity RV32I_tb is

end entity RV32I_tb;

-------------------------------------------------------------------------------

architecture arch of RV32I_tb is
  type instr is (LUI, AUIPC, JAL, BEQ, LW, SW, ADD, ADDI, ANDI, SRAI, SLT, EXOR, UNDEFINED, NOP, ABSOLUTE);
  signal fetch, decode, execute               : instr;
  signal opcode_fetch                         : std_logic_vector(6 downto 0);
  signal opcode_decode                        : std_logic_vector(6 downto 0);
  signal opcode_execute                       : std_logic_vector(6 downto 0);
  signal funct3_fetch                         : std_logic_vector(2 downto 0);
  signal funct3_decode                        : std_logic_vector(2 downto 0);
  signal funct3_execute                       : std_logic_vector(2 downto 0);
  signal rs1_fetch, rs2_fetch, rd_fetch       : std_logic_vector(4 downto 0);
  signal rs1_decode, rs2_decode, rd_decode    : std_logic_vector(4 downto 0);
  signal rs1_execute, rs2_execute, rd_execute : std_logic_vector(4 downto 0);
  --signal immediate                            : std_logic_vector(31 downto 0);

  signal clock               : std_logic        := '0';
  signal reset               : std_logic;
  signal inst_adr, data_adr  : integer range 0 to 256;
  signal write_data_mem      : std_logic_vector(31 downto 0);
  signal data_mem_adr        : std_logic_vector(31 downto 0);
  signal MemWrite            : std_logic;
  signal read_data_mem       : std_logic_vector (31 downto 0);
  signal instruction_mem_adr : std_logic_vector(31 downto 0);
  signal instruction_fetch   : std_logic_vector(31 downto 0);
  signal instruction_decode  : std_logic_vector(31 downto 0);
  signal instruction_execute : std_logic_vector(31 downto 0);
  signal MemRead             : std_logic;
  constant NOP_instruction   : std_logic_vector := "00000000000000000000000000010011";

begin  -- architecture arch

  clock <= not clock after 1.11 ns;
-------------------------------------------------------------------------------
  fetch <= LUI when opcode_fetch = "0110111" else
           ABSOLUTE when opcode_fetch = "0001011" else
           AUIPC    when opcode_fetch = "0010111" else
           JAL      when opcode_fetch = "1101111" else
           BEQ      when opcode_fetch = "1100011" else
           LW       when opcode_fetch = "0000011" else
           SW       when opcode_fetch = "0100011" else
           ADDI     when opcode_fetch = "0010011" and funct3_fetch = "000" and instruction_fetch /= NOP_instruction else
           ANDI     when opcode_fetch = "0010011" and funct3_fetch = "111" else
           SRAI     when opcode_fetch = "0010011" and funct3_fetch = "101" else
           ADD      when opcode_fetch = "0110011" and funct3_fetch = "000" else
           SLT      when opcode_fetch = "0110011" and funct3_fetch = "010" else
           EXOR     when opcode_fetch = "0110011" and funct3_fetch = "100" else
           NOP      when instruction_fetch = NOP_instruction else
           UNDEFINED;
  -------------------------------------------------------------------------------
  rs1_fetch <= "00000" when fetch = LUI or fetch = AUIPC or fetch = JAL                                               else instruction_fetch(19 downto 15);
  rs2_fetch <= "00000" when fetch = LUI or fetch = AUIPC or fetch = JAL or fetch = LW or fetch = ADDI or fetch = ANDI else instruction_fetch(24 downto 20);
  rd_fetch  <= "00000" when fetch = BEQ or fetch = SW                                                                 else instruction_fetch(11 downto 7);
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

  decode <= LUI when opcode_decode = "0110111" else
            ABSOLUTE when opcode_decode = "0001011" else
            AUIPC    when opcode_decode = "0010111" else
            JAL      when opcode_decode = "1101111" else
            BEQ      when opcode_decode = "1100011" else
            LW       when opcode_decode = "0000011" else
            SW       when opcode_decode = "0100011" else
            ADDI     when opcode_decode = "0010011" and funct3_decode = "000" and instruction_decode /= NOP_instruction else
            ANDI     when opcode_decode = "0010011" and funct3_decode = "111" else
            SRAI     when opcode_decode = "0010011" and funct3_decode = "101" else
            ADD      when opcode_decode = "0110011" and funct3_decode = "000" else
            SLT      when opcode_decode = "0110011" and funct3_decode = "010" else
            EXOR     when opcode_decode = "0110011" and funct3_decode = "100" else
            NOP      when instruction_decode = NOP_instruction else
            UNDEFINED;
-------------------------------------------------------------------------------

  rs1_decode <= "00000" when decode = LUI or decode = AUIPC or decode = JAL                                                  else instruction_decode(19 downto 15);
  rs2_decode <= "00000" when decode = LUI or decode = AUIPC or decode = JAL or decode = LW or decode = ADDI or decode = ANDI else instruction_decode(24 downto 20);
  rd_decode  <= "00000" when decode = BEQ or decode = SW                                                                     else instruction_decode(11 downto 7);

-------------------------------------------------------------------------------
  -----------------------------------------------------------------------------

  execute <= LUI when opcode_execute = "0110111" else
             ABSOLUTE when opcode_execute = "0001011" else
             AUIPC    when opcode_execute = "0010111" else
             JAL      when opcode_execute = "1101111" else
             BEQ      when opcode_execute = "1100011" else
             LW       when opcode_execute = "0000011" else
             SW       when opcode_execute = "0100011" else
             ADDI     when opcode_execute = "0010011" and funct3_execute = "000" and instruction_execute /= NOP_instruction else
             ANDI     when opcode_execute = "0010011" and funct3_execute = "111" else
             SRAI     when opcode_execute = "0010011" and funct3_execute = "101" else
             ADD      when opcode_execute = "0110011" and funct3_execute = "000" else
             SLT      when opcode_execute = "0110011" and funct3_execute = "010" else
             EXOR     when opcode_execute = "0110011" and funct3_execute = "100" else
             NOP      when instruction_execute = NOP_instruction else
             UNDEFINED;
  -----------------------------------------------------------------------------
  rs1_execute <= "00000" when execute = LUI or execute = AUIPC or execute = JAL                                                     else instruction_execute(19 downto 15);
  rs2_execute <= "00000" when execute = LUI or execute = AUIPC or execute = JAL or execute = LW or execute = ADDI or execute = ANDI else instruction_execute(24 downto 20);
  rd_execute  <= "00000" when execute = BEQ or execute = SW                                                                         else instruction_execute(11 downto 7);
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------


  -- waveform generation
  WaveGen_Proc : process
  begin
    --reset test
    wait for 1 ns;
    reset <= '0';
    wait for 3 ns;
    reset <= '1';
    wait;
  end process WaveGen_Proc;

  -- component instantiation
  processor : entity work.RV32I
    port map (
      clock               => clock,
      reset               => reset,
      instruction_mem_adr => instruction_mem_adr,
      instruction_fetch   => instruction_fetch,
      instruction_decode  => instruction_decode,
      instruction_execute => instruction_execute,
      read_data_mem       => read_data_mem,
      write_data_mem      => write_data_mem,
      data_mem_adr        => data_mem_adr,
      MemWrite            => MemWrite,
      MemRead             => MemRead);

  -- instance "ram_1"
  ram_instr : entity work.ram
    port map (
      clock    => clock,
      data     => x"00000000",
      address  => inst_adr,
      w_en     => '0',
      q        => instruction_fetch,
      reset    => reset,
      filename => "inst.txt");

  -- instance "ram_2"
  ram_data : entity work.ram
    port map (
      clock    => clock,
      data     => write_data_mem,
      address  => data_adr,
      w_en     => MemWrite,
      q        => read_data_mem,
      reset    => reset,
      filename => "data.txt");


  data_adr <= to_integer(unsigned(data_mem_adr(7 downto 0))/4);
  inst_adr <= to_integer(unsigned(instruction_mem_adr(7 downto 0))/4);

  warning_address : process (data_adr, inst_adr) is
  begin  -- process warning_address
    if to_integer(unsigned(data_mem_adr(7 downto 0))) mod 4 /= 0 and (MemWrite = '1' or MemWrite = '1') then
      report "address not aligned to word boundary" severity failure;
    end if;
  end process warning_address;

  opcode_fetch   <= instruction_fetch (6 downto 0);
  opcode_decode  <= instruction_decode (6 downto 0);
  opcode_execute <= instruction_execute(6 downto 0);
  funct3_fetch   <= instruction_fetch (14 downto 12);
  funct3_decode  <= instruction_decode (14 downto 12);
  funct3_execute <= instruction_execute(14 downto 12);


end architecture arch;

-------------------------------------------------------------------------------

