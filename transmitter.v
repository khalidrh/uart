module trasnm (
    input clk,            // Clock input
    input rst,            // Reset input
    input [7:0] din,      // Data to transmit
    input first,          // Start transmission signal
    output reg tx,        // UART serial output
    output reg done       // Transmission done signal
);
wire clkslow;
freq_div slow(
        .clk(clk),    // Input clock (100 MHz)
        .rst(rst),    // Reset signal
        .clkdiv(clkslow) // Output clock (9.6 kHz)
    );
    parameter idl = 0,    // Idle state
              start = 1,  // Start bit state
              send = 2,   // Sending data bits state
              fin = 3;    // Stop bit state

    reg [1:0] st, nx;     // Current and next states
    reg [3:0] cnt;        // Counter to track bit transmission
    reg [7:0] hold;       // Register to store data to be transmitted

    // Sequential block: State transitions and outputs
    always @(posedge clkslow or posedge rst) begin
        if (rst) begin
            st <= idl;
            tx <= 1'b1;   // UART idle line is high
            done <= 1'b1; // Ready for new data
            cnt <= 4'b0000; // Reset bit counter
        end else begin
            st <= nx;     // Update state
            if (st == send && cnt < 8) begin
                tx <= hold[cnt]; // Transmit current bit
                cnt <= cnt + 1; // Increment bit counter
            end
            if (st == start) tx <= 1'b0;  // Start bit
            if (st == fin) tx <= 1'b1;    // Stop bit
        end
    end

    // Combinational block: Determine next state and control done signal
    always @(*) begin
        nx = st;          // Default to current state
        done = 1'b0;      // Default done is low
        case (st)
            idl: begin
                if (first && done) begin
                    nx = start;      // Move to start state
                    done = 1'b0;     // Clear done signal
                    hold = din;      // Load data
                    cnt = 4'b0000;    // Reset counter
                end
            end
            start: nx = send;        // Move to send state
            send: if (cnt == 8) nx = fin; // All bits sent, move to finish
            fin: begin
                nx = idl;            // Return to idle
                done = 1'b1;         // Set done signal
            end
        endcase
    end
endmodule
