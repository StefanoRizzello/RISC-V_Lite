library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.param_pkg.all;

entity mux_32to1 is
  port(
    in_mux  : in  mux_array;
    sel     : in  std_logic_vector (4 downto 0);
    out_mux : out std_logic_vector (31 downto 0));
end mux_32to1;

architecture arch of mux_32to1 is

begin
  dec_proc : process (in_mux, sel) is
  begin
    case sel is
      when "00000" => out_mux <= in_mux(0);
      when "00001" => out_mux <= in_mux(1);
      when "00010" => out_mux <= in_mux(2);
      when "00011" => out_mux <= in_mux(3);
      when "00100" => out_mux <= in_mux(4);
      when "00101" => out_mux <= in_mux(5);
      when "00110" => out_mux <= in_mux(6);
      when "00111" => out_mux <= in_mux(7);
      when "01000" => out_mux <= in_mux(8);
      when "01001" => out_mux <= in_mux(9);
      when "01010" => out_mux <= in_mux(10);
      when "01011" => out_mux <= in_mux(11);
      when "01100" => out_mux <= in_mux(12);
      when "01101" => out_mux <= in_mux(13);
      when "01110" => out_mux <= in_mux(14);
      when "01111" => out_mux <= in_mux(15);
      when "10000" => out_mux <= in_mux(16);
      when "10001" => out_mux <= in_mux(17);
      when "10010" => out_mux <= in_mux(18);
      when "10011" => out_mux <= in_mux(19);
      when "10100" => out_mux <= in_mux(20);
      when "10101" => out_mux <= in_mux(21);
      when "10110" => out_mux <= in_mux(22);
      when "10111" => out_mux <= in_mux(23);
      when "11000" => out_mux <= in_mux(24);
      when "11001" => out_mux <= in_mux(25);
      when "11010" => out_mux <= in_mux(26);
      when "11011" => out_mux <= in_mux(27);
      when "11100" => out_mux <= in_mux(28);
      when "11101" => out_mux <= in_mux(29);
      when "11110" => out_mux <= in_mux(30);
      when "11111" => out_mux <= in_mux(31);
      when others  => out_mux <= (others => '0');
    end case;
  end process;
end architecture arch;
