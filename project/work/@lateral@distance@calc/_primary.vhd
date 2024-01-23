library verilog;
use verilog.vl_types.all;
entity LateralDistanceCalc is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        x               : in     vl_logic_vector(15 downto 0);
        v               : in     vl_logic_vector(15 downto 0);
        distance        : out    vl_logic_vector(15 downto 0);
        done            : out    vl_logic
    );
end LateralDistanceCalc;
