library verilog;
use verilog.vl_types.all;
entity ControlUnit is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        L               : in     vl_logic;
        load_term       : out    vl_logic;
        load_expression : out    vl_logic;
        inc             : out    vl_logic;
        load_counter    : out    vl_logic;
        c1              : out    vl_logic;
        c2              : out    vl_logic;
        c3              : out    vl_logic;
        c4              : out    vl_logic;
        c5              : out    vl_logic;
        c6              : out    vl_logic;
        c7              : out    vl_logic;
        c8              : out    vl_logic;
        done_signal     : out    vl_logic
    );
end ControlUnit;
