// Define a module named "adder_df" with inputs "sum", "a", and "b"
module adder_df(sum, a, b);
    // Define input ports "a" and "b" with widths 64 and 65 bits respectively, b is 65 bits because we are adding the 128 to 64 bits of the product register
    input [63:0] a;
    input [64:0] b;

    // Define an output port "sum" with width 65 bits
    output [64:0] sum;

    // Assign the output "sum" as the result of adding "a" (after adding a leading zero bit) and "b"
    assign sum = {1'd0, a} + b; // Curly braces create a concatenation
endmodule
