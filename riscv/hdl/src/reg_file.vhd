-------------------------------------------------------------------------------
-- Title      : reg_file
-- Project    : 
-------------------------------------------------------------------------------
-- File       : reg_file.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-02-01
-- Last update: 2022-02-06
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
use work.param_pkg.all;

entity reg_file is
  port (
    read_reg1, read_reg2   : in  std_logic_vector (4 downto 0);
    write_reg              : in  std_logic_vector (4 downto 0);
    clock, reset           : in  std_logic;
    write_data             : in  std_logic_vector (31 downto 0);
    write_en               : in  std_logic;
    read_data1, read_data2 : out std_logic_vector (31 downto 0)
    );
end reg_file;

architecture arch of reg_file is

  component reg is
    port (
      D                    : in  std_logic_vector (31 downto 0);
      clock, reset, enable : in  std_logic;
      Q                    : out std_logic_vector (31 downto 0)
      );
  end component;

  component dec_5to32 is
    port (
      in_dec  : in  std_logic_vector (4 downto 0);
      out_dec : out std_logic_vector (31 downto 0)
      );
  end component;

  component mux_32to1 is
    port(
      in_mux  : in  mux_array;
      sel     : in  std_logic_vector (4 downto 0);
      out_mux : out std_logic_vector (31 downto 0));
  end component;

  signal q_array : mux_array;

  signal out_dec_s : std_logic_vector (31 downto 0);
  signal en_reg    : std_logic_vector (31 downto 0);

  signal sel_delay1 : std_logic_vector(4 downto 0);
  signal sel_delay2 : std_logic_vector(4 downto 0);

begin

  gen_and :
  for i in (31) downto 0 generate
    en_reg(i) <= write_en and out_dec_s(i);
  end generate gen_and;

  gen_reg :
  for i in (31) downto 1 generate
    reg_i : reg
      port map (write_data, clock, reset, en_reg(i), q_array(i));
  end generate gen_reg;

  dec : dec_5to32 port map (write_reg, out_dec_s);

  -- mux1 : mux_32to1 port map (q_array, read_reg1, read_data1);
  -- mux2 : mux_32to1 port map (q_array, read_reg2, read_data2);

  -- internal pipelining

  mux1 : mux_32to1 port map (q_array, sel_delay1, read_data1);
  mux2 : mux_32to1 port map (q_array, sel_delay2, read_data2);

  mux_del_sel : process (clock, reset) is
  begin  -- process mux_del_sel
    if reset = '0' then                     -- asynchronous reset (active low)
      sel_delay1 <= (others => '0');
      sel_delay2 <= (others => '0');
    elsif clock'event and clock = '0' then  -- rising clock edge
      sel_delay1 <= read_reg1;
      sel_delay2 <= read_reg2;
    end if;
  end process mux_del_sel;

  -- instance "x0"
  x0 : entity work.reg
    port map (
      D      => x"00000000",
      clock  => clock,
      reset  => reset,
      enable => '0',
      Q      => q_array(0));
end arch;  -- arch


