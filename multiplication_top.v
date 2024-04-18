// Define a top-level module named "multiplication_top" to perform multiplication using registers and control logic
module multiplication_top(a_in, b_in, result, clk, reset, start, ready);
    // Input ports: 
    input [63:0] a_in, b_in;
    input clk, reset, start;
    // Output ports:
    output ready;
    output [128:0] result;

    // Internal wires for interconnecting modules and control signals
    wire [63:0] multiplier_out;
    wire [64:0] adder_out;
    wire [128:0] product_out;
    wire control_wr;
    wire control_initial_wr;
    wire control_sh_right;

    // Instantiate multiplier register module
    multiplier_register mru1(
        .data_out(multiplier_out),
        .data_in(b_in),
        .clk(clk),
        .reset(reset)
    );

    // Instantiate adder module
    adder_df addu1(
        .sum(adder_out),
        .a(multiplier_out),
        .b(product_out[128:64])
    );

    // Instantiate product register module
    product_register pru1(
        .clk(clk),
        .reset(reset),
        .data_in(adder_out),
        .wr(control_wr),
        .initial_data_in(a_in),
        .initial_wr(control_initial_wr),
        .data_out(product_out),
        .sh_right(control_sh_right)
    );

    // Instantiate control module
    control cu1(
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(product_out[0]),
        .ready(ready),
        .wr(control_wr),
        .initial_wr(control_initial_wr),
        .sh_right(control_sh_right)
    );

    // Assign result to the output of the product register
    assign result = product_out;
endmodule

