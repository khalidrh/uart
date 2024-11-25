# uart
UART Transmitter and Receiver in Verilog
Overview
This project demonstrates the implementation of a Universal Asynchronous Receiver/Transmitter (UART) in Verilog. UART is a widely used serial communication protocol that facilitates data exchange between devices.

This repository contains Verilog modules for:

UART Transmitter: Converts parallel data into a serial stream.
UART Receiver: Converts serial data back into parallel format.
Clock divider : divide freq from built in clock to a desired freq.
The project is designed to simulate and test a functional UART communication system, and it can be extended for FPGA deployment.

Features
Configurable baud rate for communication.
Handles 8-bit data frames with start, stop, and optional parity bits.
Testbench included for simulation and validation of transmitter and receiver.
Design
UART Transmitter
The transmitter takes an 8-bit parallel data input and transmits it serially, including the start and stop bits for framing.

Workflow:
Idle State: The transmitter waits for a data input and a trigger signal.
Start Bit: The line goes low to indicate the start of data transmission.
Data Bits: Data is sent bit-by-bit starting with the LSB.
Stop Bit: The line goes high, marking the end of transmission.
Block Diagram:
rust
Parallel Data Input --> Serializer --> Frame Generator --> Serial Data Output
UART Receiver
The receiver detects a start bit, then reads the incoming serial data to reconstruct the original parallel data.

Workflow:
Idle State: Waits for a start bit (line goes low).
Start Bit Detection: Synchronizes to the incoming signal.
Data Bits Reception: Samples data bits at the center of each bit duration.
Stop Bit Validation: Verifies the presence of a stop bit to ensure data integrity.
Block Diagram:
Serial Data Input --> Frame Detector --> Deserializer --> Parallel Data Output
Baud Rate Calculation
The baud rate is derived from the system clock. For example, with a clock frequency of 100 MHz and a baud rate of 9600 bps, the clock divisor is calculated as:

Divisor = System Clock Frequency / (Baud Rate * Oversampling Factor)

The oversampling factor ensures proper synchronization and error-free data reception.

---------------------------------------------------------------------------------------
Freq Divider

The code implements a frequency divider in Verilog. It takes an input clock of 100 MHz and generates an output clock of 9.6 kHz. Here's what the code does step-by-step:

Inputs:

clk: The input clock, which runs at 100 MHz.
rst: An asynchronous reset signal to reset the counter and output clock.
Output:

clkdiv: The output clock signal that will have a frequency of 9.6 kHz.
Parameter:

div = 10417: This parameter defines the division factor. It’s calculated as:
100
 
MHz
9.6
 
kHz
=
10417
9.6kHz
100MHz
​
 =10417
This value is used to divide the input clock by 10417 to generate the output frequency of 9.6 kHz.
Counter (cnt):

A 14-bit counter (cnt) counts from 0 to div/2 - 1. The reason for dividing by 2 is to toggle the output clock at the halfway point, ensuring a 50% duty cycle for the output clock.
Operation:

Reset (rst): When the rst signal is high, the counter is reset to 0, and the output clock (clkdiv) is set to 0.
Counting: On every rising edge of the input clock (clk), the counter (cnt) is incremented.
Output Toggle: When the counter reaches div/2 - 1 (i.e., after counting 5208 cycles), the output clock (clkdiv) is toggled (flipped between 0 and 1), and the counter is reset to 0.
This toggling creates a square wave at the output with a frequency of 9.6 kHz.
Final Output:

The output clock (clkdiv) will toggle every 5208 input clock cycles, resulting in a frequency of 9.6 kHz.
Key Points:
The input clock frequency is 100 MHz.
The output clock frequency is 9.6 kHz.
The counter counts up to 5208 and toggles the output clock every time it reaches that count, generating a square wave with a 50% duty cycle.






