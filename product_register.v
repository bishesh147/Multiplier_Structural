// Define a module named "product_register" to implement a register for storing product data
module product_register(clk, reset, data_in, wr, initial_data_in, initial_wr, sh_right, data_out);
    // Input ports:
    input [64:0] data_in;
    input [63:0] initial_data_in;
    input clk, reset, wr, initial_wr, sh_right;
    // Output port:
    output [128:0] data_out;

    // Internal register to store product data
    reg [128:0] prod_reg;

    // Register process block triggered on the positive edge of the clock
    always @(posedge clk) begin
        // Reset condition: if reset signal is active, set the register contents to 129-bit zero
        if (reset) 
            prod_reg <= 129'd0;
        else begin
            // Load initial data condition: if initial write signal is active, load initial_data_in, which is one of the inputs to the multiplier
            if (initial_wr == 1) 
                prod_reg <= {65'd0, initial_data_in};
            else begin
                // Write condition: if write signal is active, load data_in from the alu into the register and shift right
                if (wr == 1) 
                    prod_reg <= {1'd0, data_in, data_out[63:1]};
                // Shift right condition: if shift right signal is active, shift data_out right, we don't load the value from the alu
                else if (sh_right == 1) 
                    prod_reg <= {1'd0, data_out[128:1]};
            end
        end
    end

    // Assign data_out to the contents of prod_reg
    assign data_out = prod_reg;
endmodule
