library verilog;
use verilog.vl_types.all;
entity RV32I is
    port(
        instruction_decode: out    vl_logic_vector(31 downto 0);
        instruction_execute: out    vl_logic_vector(31 downto 0);
        clock           : in     vl_logic;
        reset           : in     vl_logic;
        instruction_fetch: in     vl_logic_vector(31 downto 0);
        instruction_mem_adr: out    vl_logic_vector(31 downto 0);
        write_data_mem  : out    vl_logic_vector(31 downto 0);
        read_data_mem   : in     vl_logic_vector(31 downto 0);
        data_mem_adr    : out    vl_logic_vector(31 downto 0);
        MemWrite        : out    vl_logic;
        MemRead         : out    vl_logic
    );
end RV32I;
