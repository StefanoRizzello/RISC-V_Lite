library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mux_2to1 is
  port(
    in_mux_0 : in  std_logic_vector(31 downto 0);
    in_mux_1 : in  std_logic_vector(31 downto 0);
    sel      : in  std_logic;
    out_mux  : out std_logic_vector (31 downto 0));
end mux_2to1;

architecture arch of mux_2to1 is
begin
  out_mux <= in_mux_0 when sel = '0' else
             in_mux_1 when sel = '1';

end architecture arch;
