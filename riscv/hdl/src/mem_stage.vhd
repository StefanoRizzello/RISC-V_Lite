-------------------------------------------------------------------------------
-- Title      : RV32I mem stage
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mem_stage.vhd
-- Author     : GR17 (F.Bongo, S.Rizzello, F.Vacca)
-- Company    : 
-- Created    : 2022-01-03
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

entity mem_stage is
  port (
    clock          : in  std_logic;
    reset          : in  std_logic;
    alu_result_mem : in  std_logic_vector(31 downto 0);
    next_pc_mem    : in  std_logic_vector(31 downto 0);
    rd_mem         : in  std_logic_vector(4 downto 0);
    read_data_mem  : in  std_logic_vector(31 downto 0);
    rd_wb          : out std_logic_vector(4 downto 0);
    alu_result_wb  : out std_logic_vector(31 downto 0);
    next_pc_wb     : out std_logic_vector(31 downto 0);
    read_data_wb   : out std_logic_vector(31 downto 0));

end entity mem_stage;

-------------------------------------------------------------------------------

architecture str of mem_stage is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str
  pipe : process (clock, reset) is
  begin  -- process pipe
    if reset = '0' then                     -- asynchronous reset (active low)
      rd_wb         <= (others => '0');
      alu_result_wb <= (others => '0');
      read_data_wb  <= (others => '0');
      next_pc_wb    <= (others => '0');
    elsif clock'event and clock = '1' then  -- rising clock edge
      rd_wb         <= rd_mem;
      alu_result_wb <= alu_result_mem;
      read_data_wb  <= read_data_mem;
      next_pc_wb    <= next_pc_mem;
    end if;
  end process pipe;
end architecture str;
-------------------------------------------------------------------------------
