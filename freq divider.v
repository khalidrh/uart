module freq_div(
    input clk,            // Input clock (100 MHz)
    input rst,            // Asynchronous reset
    output reg clkdiv     // Output clock (9.6 kHz)
);

    parameter div = 10417; // Divider value = 100M / 9.6k
    reg [13:0] cnt;        // 14-bit counter to support the division factor

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            clkdiv <= 0;
        end else begin
            if (cnt == div/2 - 1) begin
                clkdiv <= ~clkdiv; // Toggle output clock
                cnt <= 0;         // Reset counter
            end else begin
                cnt <= cnt + 1;   // Increment counter
            end
        end
    end
endmodule
