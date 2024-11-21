module trasnm (
    input clk,
    input rst,
    input [7:0] din,
    input first,
    output reg tx,
    output reg done
);
    parameter idl=0, start=1, send=2, fin=3;
    reg [1:0] st, nx;
    reg [3:0] cnt;
    reg [7:0] hold;

    // Sequential Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            st <= idl;
            tx <= 1;       // UART idle state is HIGH
            done <= 1;     // Ready for new transmission
            cnt <= 0;
        end else begin
            st <= nx;      // Update state
            if (st == send && cnt < 8) begin
                tx <= hold[cnt];  // Send current bit
                cnt <= cnt + 1;  // Increment bit counter
            end
        end
    end

    // Combinational Logic
    always @(*) begin
        // Default values
        nx = st;
        case (st)
            idl: begin
                if (first && done) begin
                    nx = start;
                    done = 0;    // Clear done signal
                    hold = din;  // Capture data
                    cnt = 0;     // Reset counter
                end
            end
            start: begin
                tx = 0;       // Start bit (LOW)
                nx = send;    // Move to send state
            end
            send: begin
                if (cnt == 8) nx = fin; // All bits sent, move to fin
            end
            fin: begin
                tx = 1;       // Stop bit (HIGH)
                nx = idl;     // Return to idle
                done = 1;     // Transmission complete
            end
        endcase
    end
endmodule
