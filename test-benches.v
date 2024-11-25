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

Transmitter test bench: 
`timescale 1ns / 1ps

module tb_trasnm;

    // Testbench signals
    reg clk;                 // 100 MHz system clock
    reg rst;                 // Reset signal
    reg [7:0] din;           // Data to transmit
    reg first;               // Start transmission signal
    wire tx;                 // UART serial output
    wire done;               // Transmission done signal

    // Instantiate the UART transmitter module
    trasnm uut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .first(first),
        .tx(tx),
        .done(done)
    );

    // Generate 100 MHz clock (10 ns period)
    always begin
        #5 clk = ~clk; // Toggle clock every 5 ns
    end

    // Testbench process
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        first = 0;
        din = 8'b0;

        // Apply reset
        $display("Applying reset...");
        rst = 1;
        #20;  // Reset duration
        rst = 0;

        // Wait for stabilization
        #100;

        // Transmit first byte: 8'h55
        $display("Starting transmission of byte 8'h55...");
        din = 8'h55;    // Data to be transmitted
        first = 1;      // Assert start signal
        #10;            // Hold start signal for one clock cycle
        first = 0;      // De-assert start signal

        // Wait for transmission to complete
        wait(done == 1);
        $display("Byte 8'h55 transmitted.");

        // Wait before next transmission
        #200;

        // Transmit second byte: 8'hAA
        $display("Starting transmission of byte 8'hAA...");
        din = 8'hAA;    // Data to be transmitted
        first = 1;      // Assert start signal
        #10;            // Hold start signal for one clock cycle
        first = 0;      // De-assert start signal

        // Wait for transmission to complete
        wait(done == 1);
        $display("Byte 8'hAA transmitted.");

        // End simulation
        $finish;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time: %0t | tx: %b | done: %b | din: %h | first: %b",
                 $time, tx, done, din, first);
    end

endmodule
---------------------------------------------------------------------

