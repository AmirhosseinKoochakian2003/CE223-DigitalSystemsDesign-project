library verilog;
use verilog.vl_types.all;
entity ROM is
    port(
        address         : in     vl_logic_vector(3 downto 0);
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end ROM;
