library verilog;
use verilog.vl_types.all;
entity CMP is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        L               : out    vl_logic;
        E               : out    vl_logic;
        G               : out    vl_logic
    );
end CMP;
