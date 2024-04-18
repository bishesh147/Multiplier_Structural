`timescale 1ps/1ps

// Define the testbench module "multiplication_top_tb"
module multiplication_top_tb;
    // Declare input registers a_in and b_in, clock (clk), reset signal, and start signal
    reg [63:0] a_in, b_in;
    reg clk, reset, start;
    // Declare output wires ready and result
    wire ready;
    wire [128:0] result;
    
    // Declare integer variable i
    integer i;

    // Instantiate the multiplication_top module with specified ports
    multiplication_top mlt1(a_in, b_in, result, clk, reset, start, ready);

    // Define clock toggling behavior
    always #1 clk = ~clk;

    // Define initial block for testbench initialization
    initial begin
        // Initialize reset signal, clock, and input ports
        reset = 1; clk = 1; a_in = 64'd0; b_in = 64'd0; start = 0;
        // Wait for 2 time units
        #2;
        // De-assert reset
        reset = 0;
        // Assign values to input ports a_in and b_in
        a_in = 17;
        b_in = 27;
        // Set start signal to initiate multiplication
        start = 1;
        // Wait for 4 time units
        #4;
        // Loop for 100 iterations
        for (i = 0; i < 100; i = i + 1) begin
            // Wait until ready signal is asserted, ready signal being asserted means the multiplier has reached the idle state, so it is ready for another operation
            while (ready == 0) begin
                #2; // Wait for 2 time units, we check ready signal every clock cycle which is 2 time units
            end

            // Display iteration number, time, input values, and result
            $display("%d. \t time = %d \t a_in = %d \t b_in = %d \t result = %d", i+1, $time, a_in, b_in, result);

            // Check if result is correct
            if (a_in * b_in != result) begin
                $display("Wrong!!!");
            end
            else $display("Right!!!");
            
            // Set start signal to initiate multiplication
            start = 1;
            // Update input values for next iteration
            a_in = (a_in + b_in) * 3;
            b_in = a_in - 137 * i;
            // Wait for 2 time units
            #2;
        end 
        // Wait for 10 time units before finishing simulation
        #10 $finish;
    end
endmodule
