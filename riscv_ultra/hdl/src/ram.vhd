-------------------------------------------------------------------------------
-- Title      : ram
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ram.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-02-01
-- Last update: 2022-02-01
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-02-01  1.0      wackoz  Created
-------------------------------------------------------------------------------

library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity ram is
  port
    (
      clock    : in  std_logic;
      data     : in  std_logic_vector (31 downto 0);
      address  : in  integer range 0 to 255;
      w_en     : in  std_logic;
      q        : out std_logic_vector (31 downto 0);
      reset    : in  std_logic;
      filename : in  string(1 to 8));
end ram;
architecture rtl of ram is
  type mem is array(0 to 255) of std_logic_vector(31 downto 0);
  signal ram_block : mem;
  signal bootload  : boolean := false;

begin

  ram_process : process (clock, address, reset, data, bootload) is
    file data_file     : text open read_mode is filename;
    variable data_line : line;
    variable data_init : std_logic_vector(31 downto 0);
    variable ok        : boolean;
    variable i         : natural := 0;
  begin  -- process ram_process
    if reset = '0' then                 -- asynchronous reset (active low)
      q <= (others => '0');
      if(bootload = false) then
        while (not(endfile(data_file)) and i < 255) loop  -- initialize memory with
          readline(data_file, data_line);
          read(data_line, data_init);
          ram_block(i) <= std_logic_vector(data_init);
          i            := i +1;
        end loop;
        while i < 256 loop              -- initialize the rest of mem
          ram_block(i) <= (others => '0');
          i            := i +1;
        end loop;
        bootload <= true;
      end if;
    elsif (w_en = '1') and clock'event and clock = '1' then
      ram_block(address) <= data;
    else
      q <= ram_block(address);
    end if;
  end process ram_process;
end rtl;
