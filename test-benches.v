first code : clock divider test bench

module tb_freq_div;

    // Testbench signals
    reg clk;            // Input clock (100 MHz)
    reg rst;            // Reset signal
    wire clkdiv;        // Output clock (9.6 kHz)

    // Instantiate the freq_div module
    freq_div uut (
        .clk(clk),
        .rst(rst),
        .clkdiv(clkdiv)
    );

    // Generate 100 MHz clock
    always begin
        #5 clk = ~clk; // Toggle every 5 ns (100 MHz = 10 ns period)
    end

    // Initial block for test stimulus
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 0;
        
        // Apply reset
        $display("Applying Reset");
        rst = 1;
        #20;  // Wait for some time (20 ns)
        rst = 0;  // Deassert reset
        
        // Run for some cycles and observe clkdiv
        #200000; // Simulate for 200 us (enough to observe toggling at 9.6 kHz)
        
        // End simulation
        $finish;
    end

    // Monitor the clkdiv signal
    initial begin
        $monitor("Time: %t, clkdiv = %b", $time, clkdiv);
    end

endmodule
----------------------------------------------------------------------------------
