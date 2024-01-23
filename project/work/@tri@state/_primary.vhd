library verilog;
use verilog.vl_types.all;
entity TriState is
    port(
        \out\           : out    vl_logic_vector(15 downto 0);
        \in\            : in     vl_logic_vector(15 downto 0);
        control         : in     vl_logic
    );
end TriState;
