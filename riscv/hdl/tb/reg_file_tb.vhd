library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.param_pkg.all;

entity reg_file_tb is

end entity reg_file_tb;

architecture arch of reg_file_tb is

  signal read_reg1, read_reg2   : std_logic_vector (n_min-1 downto 0);
  signal write_reg              : std_logic_vector (n_min-1 downto 0);
  signal clock, reset, enable   : std_logic;
  signal write_data             : std_logic_vector (N-1 downto 0);
  signal write_en               : std_logic;
  signal read_data1, read_data2 : std_logic_vector (N-1 downto 0);

  constant Tck   : time    := 10 ns;
  signal i, j    : integer := 0;
  signal read_en : std_logic;

begin

  read_en <= '0', '1' after 350 ns;

  DUT : entity work.reg_file
    port map(
      read_reg1, read_reg2,
      write_reg,
      clock, reset, enable,
      write_data,
      write_en,
      read_data1, read_data2
      );

  clock_proc : process
  begin
    clock <= '0';
    wait for Tck/2;
    clock <= '1';
    wait for Tck/2;
  end process;

  write_proc : process (clock)
  begin
    write_en <= '1';
    if rising_edge(clock) then
      if i < N then
        write_reg  <= std_logic_vector(to_unsigned(i, 5));
        write_data <= std_logic_vector(to_unsigned(i, 32));
        i          <= i + 1;
      end if;
    end if;
  end process;

  read_proc : process (clock)
  begin
    if read_en = '1' then
      if rising_edge(clock) then
        if j < N then
          read_reg1 <= std_logic_vector(to_unsigned(j, 5));
          read_reg2 <= std_logic_vector(to_unsigned(j+1, 5));
          j         <= j + 2;
        end if;
      end if;
    end if;
  end process;

end arch;  -- arch
