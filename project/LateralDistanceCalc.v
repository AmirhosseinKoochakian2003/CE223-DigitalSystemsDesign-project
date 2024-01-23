module LateralDistanceCalc(clk, rst, start, x, v, distance, done);
    input clk;
    input rst;
    input start;
    input [15:0] x;
    input [15:0] v;
    output [15:0] distance;
    output done;

    wire [15:0] high16 = 16'B0000100000000000;
    wire [3:0] high4 = 4'B0001;
    wire [3:0] seven = 4'B0111;

    //multiplier
    wire [15:0] multiplier_input1_wire;
    wire [15:0] multiplier_input2_wire;
    wire [15:0] multiplier_output_wire;

    //wires of term : 
    wire [15:0] term_input_wire;
    wire [15:0] term_output_wire;

    //wires of expression : 
    wire [15:0] expression_input_wire;
    wire [15:0] expression_output_wire;

    //wires of counter :
    wire [3:0] counter_output_wire;

    //adder
    wire [15:0] adder_output_wire;

    //ROM
    wire [15:0] rom_output_wire;

     //compare
    wire L, E, G;

    //declaring wires : 
    wire load_term, load_expression, inc, load_counter, c1, c2, c3, c4, c5, c6, c7, c8; //control unit output wires

    ControlUnit controlUnit(clk, rst, start, L, load_term, load_expression, inc, load_counter, c1, c2, c3, c4, c5, c6, c7, c8, done);
    FourBitCounter counter4(clk, load_counter, rst, inc, high4, counter_output_wire);
    CMP cmp (counter_output_wire, seven, L, E, G);

    //term
    TriState tri_ (term_input_wire, high16, c7);
    TriState tri2 (term_input_wire, multiplier_output_wire, c8); // khoroji mult

    //expression
    TriState tri3 (expression_input_wire, high16, c7);
    TriState tri4 (expression_input_wire, adder_output_wire, c8); // khoroj adder

    Register term(clk, load_term, rst, term_input_wire, term_output_wire);
    Register expression(clk, load_expression, rst, expression_input_wire, expression_output_wire);

    FixedPointAdder adder(expression_output_wire, term_output_wire, adder_output_wire);
    FixedPointMultiplier multiplier(multiplier_input1_wire, multiplier_input2_wire, multiplier_output_wire);

    ROM rom(counter_output_wire, rom_output_wire);

    //multiplier
    TriState tri5 (multiplier_input1_wire, term_output_wire, c1);
    TriState tri6 (multiplier_input1_wire, v, c2);
    TriState tri7 (multiplier_input2_wire, expression_output_wire, c3);
    TriState tri8 (multiplier_input2_wire, rom_output_wire, c4);
    TriState tri9 (multiplier_input2_wire, x, c5);

    //distance
    TriState tri10 (distance, multiplier_output_wire, c6);

    // always @(multiplier_output_wire)
    //     begin
    //         $display("state -> %b mult => %b * %b = %b", state, multiplier_input1_wire, multiplier_input2_wire, multiplier_output_wire);
    //     end
endmodule


module TriState(out, in, control);
    input [15:0] in;
    output [15:0] out;
    input control;

    assign out = control ? in : 16'Bzzzzzzzzzzzzzzzz;
endmodule

module ROM(address, out);
    input [3:0] address;
    output reg [15:0] out;

    always @(address) 
        begin
            if (address == 1) out = 16'Hfc00;
            else if (address == 2) out = 16'Hff55;
            else if (address == 3) out = 16'Hffbc;
            else if (address == 4) out = 16'Hffdb;
            else if (address == 5) out = 16'Hffe9;
            else if (address == 6) out = 16'Hfff0;
            else if (address == 7) out = 16'Hfff5; 
        end
endmodule

module ControlUnit(clk, rst, start, L, load_term, load_expression, inc, load_counter, c1, c2, c3, c4, c5, c6, c7, c8, done_signal);
    input start, L, clk, rst;
    output reg load_counter, load_expression, load_term;
    output reg c1, c2, c3, c4, c5, c6, c7, c8, done_signal, inc;

    reg [6:0] state = 7'B0000001; //one's hot

    // start for CU
    always @(negedge start)
        begin
            c1 = 0;
            c2 = 0;
            c3 = 0;
            c4 = 0;
            c5 = 0;
            c6 = 0;
            c7 = 1;
            c8 = 0;
            load_term = 1;
            load_expression = 1;
            inc = 0;
            load_counter = 1;
            done_signal = 0;
            state = 7'B0000010;
        end

    // control unit 
    always @(posedge clk or posedge rst) 
        begin
            //if (state != 1) $display("state : %d -> ",state);
            if (rst)
                begin
                    c1 = 0;
                    c2 = 0;
                    c3 = 0;
                    c4 = 0;
                    c5 = 0;
                    c6 = 0;
                    c7 = 0;
                    c8 = 0;
                    load_term = 0;
                    load_expression = 0;
                    inc = 0;
                    load_counter = 0;
                    done_signal = 0;                    
                    state = 7'B0000001; 
                end
            else
                begin
                    if (state == 7'B0000010)
                        begin
                            c1 = 1;
                            c2 = 0;
                            c3 = 0;
                            c4 = 1;
                            c5 = 0;
                            c6 = 0;
                            c7 = 0;
                            c8 = 1;
                            load_term = 1;
                            load_expression = 0;
                            inc = 0;
                            load_counter = 0;
                            done_signal = 0;
                            state = 7'B0000100;
                        end
                    else if (state == 7'B0000100)
                        begin
                            c1 = 1;
                            c2 = 0;
                            c3 = 0;
                            c4 = 0;
                            c5 = 1;
                            c6 = 0;
                            c7 = 0;
                            c8 = 1;
                            load_term = 1;
                            load_expression = 0;
                            inc = 0;
                            load_counter = 0;
                            done_signal = 0;
                            state = 7'B0001000;                            
                        end
                    else if (state == 7'B0001000)
                        begin
                            c1 = 1;
                            c2 = 0;
                            c3 = 0;
                            c4 = 0;
                            c5 = 1;
                            c6 = 0;
                            c7 = 0;
                            c8 = 1;
                            load_term = 1;
                            load_expression = 0;
                            inc = 0;
                            load_counter = 0;
                            done_signal = 0;
                            state = 7'B0010000;                             
                        end
                    else if (state == 7'B0010000)
                        begin
                            c1 = 0;
                            c2 = 0;
                            c3 = 0;
                            c4 = 0;
                            c5 = 0;
                            c6 = 0;
                            c7 = 0;
                            c8 = 1;
                            inc = 1;
                            load_term = 0;
                            load_expression = 1;
                            load_counter = 0;
                            done_signal = 0;
                            state = 7'B0100000;                              
                        end
                    else if (state == 7'B0100000)
                        begin
                            if (L)
                                begin
                                    c1 = 1;
                                    c2 = 0;
                                    c3 = 0;
                                    c4 = 1;
                                    c5 = 0;
                                    c6 = 0;
                                    c7 = 0;
                                    c8 = 1;
                                    inc = 0;
                                    load_term = 1;
                                    load_expression = 0;
                                    load_counter = 0;
                                    done_signal = 0;
                                    state = 7'B0000100;
                                end
                            else
                                begin
                                    c1 = 0;
                                    c2 = 1;
                                    c3 = 1;
                                    c4 = 0;
                                    c5 = 0;
                                    c6 = 1;
                                    c7 = 0;
                                    c8 = 1;
                                    load_term = 0;
                                    load_expression = 0;
                                    inc = 0;
                                    load_counter = 0;
                                    done_signal = 1;
                                    state = 7'B1000000;  
                                end                             
                        end
                    else if (state == 7'B1000000)
                        begin
                            c1 = 0;
                            c2 = 1;
                            c3 = 1;
                            c4 = 0;
                            c5 = 0;
                            c6 = 1;
                            c7 = 0;
                            c8 = 1;
                            load_term = 0;
                            load_expression = 0;
                            inc = 0;
                            load_counter = 0;
                            done_signal = 1;
                            state = 7'B0000001;                             
                        end
                end
        end
endmodule

module FixedPointAdder(in1, in2, out);
    input [15:0] in1;
    input [15:0] in2;
    output [15:0] out;

    assign out = in1 + in2;
endmodule

module FixedPointMultiplier(A, B, out);
    input [15:0] A;
    input [15:0] B;
    output reg [15:0] out;

    reg [15:0] op1;
    reg [15:0] op2;
    
    reg sign;

    reg [31:0] multiplicand;
    reg [31:0] accumulator;

    reg [5:0] i;

    always @(A or B) 
        begin
            sign = A[15] ^ B[15];
            op1 = (A ^ {16{A[15]}}) + A[15];
            op2 = (B ^ {16{B[15]}}) + B[15];

            multiplicand = op1;
            accumulator = 0;

        for (i = 0; i < 16; i = i + 1) 
            begin
                if (op2[0] == 1'b1)
                    accumulator = accumulator + multiplicand;

                    multiplicand = multiplicand << 1;
                    op2 = op2 >> 1;
            end
            out = (accumulator[26:11] ^ {16{sign}}) + sign;
        end
endmodule

module Register(clk, load, reset, in, out);
    parameter bandwidth = 16;

    input clk; 
    input load;
    input reset;
    input [bandwidth-1:0] in;
    output reg [bandwidth-1:0] out;

    always @(posedge clk or posedge reset) 
        begin
            if (reset)
                out = 0;
            else if(load)
                out = in; 
        end
endmodule

module FourBitCounter(clk, load, reset, inc, in, out);
    input clk; 
    input load;
    input reset;
    input inc;
    input [3:0] in;
    output reg [3:0] out;

    always @(posedge clk or posedge reset) 
        begin
            if (reset)
                out = 0;
            else if (inc)
                out = out + 1;
            else if(load)
                out = in;
        end
endmodule

module CMP(A, B, L, E, G);
    input [3:0] A;
    input [3:0] B;
    output L, E, G;

    assign L = A < B ? 1 : 0;
endmodule


