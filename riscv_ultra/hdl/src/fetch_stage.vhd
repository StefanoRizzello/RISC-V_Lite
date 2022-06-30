-------------------------------------------------------------------------------
-- Title      : RV32I fetch stage
-- Project    : 
-------------------------------------------------------------------------------
-- File       : fetch_stage.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-03
-- Last update: 2022-02-10
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Fetch stage for RV32I
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-------------------------------------------------------------------------------

entity fetch_stage is

  port (
    clock                : in  std_logic;
    reset                : in  std_logic;
    PCSrc                : in  std_logic;
    instruction_fetch    : in  std_logic_vector(31 downto 0);
    target_address_fetch : in  std_logic_vector(31 downto 0);
    PcWrite              : in  std_logic;
    PipeWrite_fetch       : in  std_logic;
    Rs1_fetch            : out std_logic_vector(4 downto 0);
    Rs2_fetch            : out std_logic_vector(4 downto 0);
    Rd_decode            : out std_logic_vector(4 downto 0);
    instruction_mem_adr  : out std_logic_vector(31 downto 0);
    pc_decode            : out std_logic_vector(31 downto 0);
    next_pc_decode       : out std_logic_vector(31 downto 0);
    instruction_decode   : out std_logic_vector(31 downto 0));
end entity fetch_stage;

-------------------------------------------------------------------------------
architecture str of fetch_stage is

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------
  component mux_2to1 is
    port (
      in_mux_0 : in  std_logic_vector(31 downto 0);
      in_mux_1 : in  std_logic_vector(31 downto 0);
      sel      : in  std_logic;
      out_mux  : out std_logic_vector (31 downto 0));
  end component mux_2to1;

  component reg is
    port (
      D                    : in  std_logic_vector (31 downto 0);
      clock, reset, enable : in  std_logic;
      Q                    : out std_logic_vector (31 downto 0));
  end component reg;

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal pc_in, pc_out_int                  : std_logic_vector(31 downto 0);
  signal pcinput_in_mux_0, pcinput_in_mux_1 : std_logic_vector(31 downto 0);
  signal next_pc                            : std_logic_vector(31 downto 0);
  signal instruction_decode_int             : std_logic_vector(31 downto 0);
begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- Program Counter (PC)
  PC : reg
    port map (
      D      => pc_in,
      clock  => clock,
      reset  => reset,
      enable => PcWrite,
      Q      => pc_out_int);

  -- instance "PCinputmux"
  pcinputmux : mux_2to1
    port map (
      in_mux_0 => pcinput_in_mux_0,
      in_mux_1 => pcinput_in_mux_1,
      sel      => PCSrc,
      out_mux  => pc_in);

  -- mux signals assignment
  pcinput_in_mux_0 <= next_pc;
  pcinput_in_mux_1 <= target_address_fetch;

  --output assignment
  instruction_mem_adr <= pc_out_int;
  pipe : process (clock, reset) is
  begin  -- process pipe
    if reset = '0' then                     -- asynchronous reset (active low)
      instruction_decode_int <= (others => '0');
      pc_decode              <= (others => '0');
      next_pc_decode         <= (others => '0');
    elsif clock'event and clock = '1' then  -- rising clock edge
      if PipeWrite_fetch = '1' then
        instruction_decode_int <= instruction_fetch;
        pc_decode              <= pc_out_int;
        next_pc_decode         <= next_pc;
      end if;
    end if;
  end process pipe;

  next_pc            <= std_logic_vector(unsigned(pc_out_int) + 4);
  instruction_decode <= instruction_decode_int;
  Rd_decode          <= instruction_decode_int(11 downto 7);
  Rs1_fetch          <= instruction_fetch(19 downto 15);
  Rs2_fetch          <= instruction_fetch(24 downto 20);

end architecture str;

-------------------------------------------------------------------------------
