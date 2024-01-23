module TB_LDC;
    reg clk, rst, start;
    reg [15:0] x;
    reg [15:0] v;

    wire [15:0] distance;
    wire done; 

    LateralDistanceCalc lateralDistanceCalculator(clk, rst, start, x, v, distance, done);

    // initial $monitor("dis : %b", distance);

    initial 
        begin
            $dumpfile("wave.vcd");
            $dumpvars(0, TB_LDC);            
        end

    initial
        begin
            clk = 0;
            rst <= 0;
            start <= 1;
            repeat(100000) #10 clk = ~clk;
        end

    initial #10 start <= 0;


    initial
        begin
            // x <= 90 , v = 1
            x <= 16'B0000100001010010;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(60 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            start <= 1;
            #10 start <= 0;
            x <= 16'B0000010000101111;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(30 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            start <= 1;
            #10 start <= 0;
            x <= 16'B0000110010001111;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(90 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            start <= 1;
            #10 start <= 0;
            x <= 16'B0000011001001000;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(45 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            start <= 1;
            #10 start <= 0;
            x <= 16'B0000000000000000;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(0 degree) * v(1m/s) => distance : %b , done = %b", distance, done);        

            // x > 90 , v = 1
            start <= 1;
            #10 start <= 0;
            x <= 16'B0001000010111000;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(120 degree) * v(1m/s) => distance : %b , done = %b", distance, done);      

            start <= 1;
            #10 start <= 0;
            x <= 16'B0001010011110000;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(150 degree) * v(1m/s) => distance : %b , done = %b", distance, done);    

            start <= 1;
            #10 start <= 0;
            x <= 16'B0001100100100001;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(180 degree) * v(1m/s) => distance : %b , done = %b", distance, done);  

            // -90 <= x <= 0 , v = 1
            start <= 1;
            #10 start <= 0;
            x <= 16'B1111101111010001;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(-30 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            start <= 1;
            #10 start <= 0;
            x <= 16'B1111100110111000;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(-45 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            start <= 1;
            #10 start <= 0;
            x <= 16'B1111011110101110;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(-60 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            start <= 1;
            #10 start <= 0;
            x <= 16'B1111001101110001;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(-90 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            // -180 <= x < -90 , v = 1
            start <= 1;
            #10 start <= 0;
            x <= 16'B1110111100111111;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(-120 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            start <= 1;
            #10 start <= 0;
            x <= 16'B1110101100010000;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(-150 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            start <= 1;
            #10 start <= 0;
            x <= 16'B1110011011011111;
            v <= 16'B0000100000000000;
            #1000
            $display("cos(-180 degree) * v(1m/s) => distance : %b , done = %b", distance, done);

            // x = 60 , v = 1.5 => different volacity from 1m/s
            start <= 1;
            #10 start <= 0;
            x <= 16'B0000100001010010;
            v <= 16'B0000110000000000;
            #1000
            $display("cos(60 degree) * v(1.5 m/s) => distance : %b , done = %b", distance, done);

            // x = 30 , v = 3 => different volacity from 1m/s
            start <= 1;
            #10 start <= 0;
            x <= 16'B0000010000101111;
            v <= 16'B0001100000000000;
            #1000
            $display("cos(30 degree) * v(3 m/s) => distance : %b , done = %b", distance, done);

            // negative volacity
            start <= 1;
            #10 start <= 0;
            x <= 16'B0000100001010010;
            v <= 16'B1111000000000000;
            #1000
            $display("cos(60 degree) * v(-2 m/s) => distance : %b , done = %b", distance, done);

            // asynchronous rst signal , reset LDC and set done signal to 0 and high impedance distance as i used a tri state buffer for output
            start <= 1;
            #10 start <= 0;
            x <= 16'B0000100001010010;
            v <= 16'B1111000000000000;
            #10 rst = 1;
            rst = 0;
            $display("rst effect => distance : %b , done = %b", distance, done);

            // different start pulse
            start <= 1;
            #20 start <= 0;
            x <= 16'B0000011001001000;
            v <= 16'B0010100000000000;
            #1000
            $display("checking different start pulse : cos(45 degree) * v(5 m/s) => distance : %b , done = %b", distance, done);
            
            // different start pulse and x , v < 0
            start <= 1;
            #15 start <= 0;
            x <= 16'B0001010011110000;
            v <= 16'B1111100000000000;
            #1000
            $display("checking different start pulse : cos(150 degree) * v(-1 m/s) => distance : %b , done = %b", distance, done);        

            // different start pulse and unnormal x
            start <= 1;
            #13 start <= 0;
            x <= 16'B0000101000001100;
            v <= 16'B0000100000000000;
            #1000
            $display("checking different start pulse and x = 72 degree : cos(72 degree) * v(1 m/s) => distance : %b , done = %b", distance, done); 

            // unnormal x
            start <= 1;
            #10 start <= 0;
            x <= 16'B0000001100010000;
            v <= 16'B0000100000000000;
            #1000
            $display("x = 22 degree : cos(22 degree) * v(1 m/s) => distance : %b , done = %b", distance, done);

        end

endmodule

