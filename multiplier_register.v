// Define a module named "multiplier_register" to implement a register to store one of the inputs of the multiplier
module multiplier_register(data_out, data_in, clk, reset);
    // Input ports: data input (data_in), clock (clk), reset signal (reset)
    input [63:0] data_in;
    input clk, reset;
    // Output port: data output (data_out)
    output [63:0] data_out;
    // Internal register to store data
    reg [63:0] mul_reg;
    
    // Register process block triggered on the positive edge of the clock
    always @(posedge clk) begin
        // Reset condition: if reset signal is active, set the register contents to 64-bit zero
        if (reset) 
            mul_reg <= 64'd0;
        // Update condition: if reset signal is not active, load data_in into the register
        else 
            mul_reg <= data_in;
    end
    
    // Assign data_out to the contents of mul_reg
    assign data_out = mul_reg;
endmodule
