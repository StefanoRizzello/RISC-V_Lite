library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
  --generic (N : integer := 32);
  port(
    D                    : in  std_logic_vector (31 downto 0);
    clock, reset, enable : in  std_logic;
    Q                    : out std_logic_vector (31 downto 0));
end reg;

architecture arch of reg is

begin
  register_proc : process (clock, reset) is
  begin

    if reset = '0' then
      Q <= (others => '0');
    elsif clock'event and clock = '1' then
      if enable = '1' then
        Q <= D;
      end if;
    end if;
  end process;
end architecture arch;
