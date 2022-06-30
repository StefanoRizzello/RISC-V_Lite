library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package param_pkg is
    type mux_array is array (0 to (31)) of std_logic_vector (31 downto 0);
end package param_pkg;
