
module receiver(
    input clk,              // Clock input
    input rx,               // UART serial input
    input rst,              // Reset input
    output reg [7:0] do,    // 8-bit parallel data output
    output reg busy,        // Receiver busy signal
    output reg done         // Data reception complete signal
);

wire clkslow;
freq_div slow(
        .clk(clk),    // Input clock (100 MHz)
        .rst(rst),    // Reset signal
        .clkdiv(clkslow) // Output clock (9.6 kHz)
    );

    // State definitions
    parameter idle = 2'b00,  // Idle state
              rec  = 2'b01,  // Receiving state
              fin  = 2'b10;  // Finished state

    // Registers for state machine and data handling
    reg [3:0] cnt;           // Bit counter
    reg [1:0] st, ns;        // Current state and next state
    reg [7:0] stored;        // Register to store received data

    // Sequential block: State machine and counters
        always @(posedge clkslow or posedge rst) begin
        if (rst) begin
            st <= idle;
            busy <= 0;
            done <= 0;
            do <= 0;
            cnt <= 0;
            stored <= 0;
        end else begin
            st <= ns;  // Transition to next state
            if (st == rec) begin
                cnt <= cnt + 1;           // Increment bit counter
                stored <= {rx, stored[7:1]}; // Shift in the received bit
            end
        end
    end

    // Combinational block: State transition logic and signal control
    always @(*) begin
        // Default values
        ns = st;
        busy = 0;
        done = 0;
        case (st)
            idle: begin
                busy = 0;
                done = 0;
                ns = (rx == 0) ? rec : idle;  // Detect the start bit (low)
            end

            rec: begin
                busy = 1;
                if (cnt == 8) begin
                    ns = fin;  // When 8 bits are received, move to finish state
                end else begin
                    ns = rec;  // Stay in receiving state
                end
            end

            fin: begin
                do = stored;  // Output the received byte
                done = 1;     // Indicate reception is complete
                busy = 0;     // Receiver is no longer busy
                ns = idle;    // Return to idle state
                cnt = 0;      // Reset bit counter
            end
        endcase
    end

endmodule
