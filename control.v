// Define a module named "control" with input and output ports for controlling a process
module control(clk, reset, start, data_in, ready, wr, initial_wr, sh_right);
    // Input ports: clock (clk), reset signal (reset), start signal (start), data input (data_in)
    input clk, reset, start, data_in;

    // Output ports: ready signal (ready), write signal (wr), initial write signal (initial_wr), shift right signal (sh_right)
    output ready, wr, initial_wr, sh_right;

    // Internal wires for checking conditions
    wire wr_check;
    wire initial_wr_check;
    wire sh_right_check;
    wire ready_check;

    // Registers for state and counter
    reg [1:0] state;
    reg [9:0] counter;

    // Sequential logic to control state transitions
    always @(posedge clk) begin
        if (reset) begin
            // Reset state and counter to initial values
            state <= 2'd0;
            counter <= 10'd0;
        end
        else begin
            // State machine
            case (state)
                2'b00: begin // Idle state
                    if (start == 1) state <= 2'b01; // Transition to load state on start signal
                end

                2'b01: begin // Load state
                    counter <= 0; // Reset counter
                    state <= 2'b10; // Transition to operation state
                end

                2'b10: begin // Operation state
                    if (counter == 63) state <= 2'b00; // If counter reaches 63, transition back to idle state
                    counter <= counter + 1; // Increment counter
                end
            endcase
        end
    end

    // Conditions for output signals based on current state
    assign wr_check = (state == 2'b10) && data_in; // Check if in operation state and data_in is high, data_in is the first bit of the product register, if the data_in is high we update the product register with the value from the adder
    assign wr = wr_check ? 1 : 0; // Set wr high if wr_check is true, else set low
    
    assign initial_wr_check = (state == 2'b01); // Check if in load state, in the load state we initially load the input to the right 63 to 0 bits of the product register, which is indicated by initial_wr_check
    assign initial_wr = initial_wr_check ? 1 : 0; // Set initial_wr high if initial_wr_check is true, else set low
    
    assign sh_right_check = (state == 2'b10); // Check if in operation state, we always shift right in the operation state
    assign sh_right = sh_right_check ? 1 : 0; // Set sh_right high if sh_right_check is true, else set low
    
    assign ready_check = (state == 2'b00); // Check if in idle state, in the idle state the multiplier is ready to be used again
    assign ready = ready_check ? 1 : 0; // Set ready high if ready_check is true, else set low
endmodule

