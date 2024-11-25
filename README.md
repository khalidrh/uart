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
