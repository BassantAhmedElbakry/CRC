# CRC

## What is LFSR?
<br>- The LFSR is a shift register that has some of its outputs together in exclusive-OR or exclusive-NOR configurations to form a feedback path.
<br>- The initial content of the shift register is referred to as seed. (Note: any value 
can be a seed except all 0’s to avoid lookup state)

## LFSR Applications:
<br>1) Pattern Generators
<br>2) Encryption
<br>3) Compression
<br>4) CRC
<br>5) Pseudo-Random Bit Sequences (PRBS)

![WhatsApp Image 2023-08-29 at 01 19 26](https://github.com/BassantAhmedElbakry/CRC/assets/104600321/658f3c14-e256-4fed-80e0-0fed518708da)

![WhatsApp Image 2023-08-29 at 01 19 45](https://github.com/BassantAhmedElbakry/CRC/assets/104600321/dce9e377-a0d3-4f8b-883b-14d97a932ae2)

## Specification:
<br>1. All registers are set to LFSR Seed value using asynchronous active 
low reset (SEED = 8'hD8)
<br>2. All outputs are registered
<br>3. DATA serial bit length vary from 1 byte to 4 bytes (Typically: 1 Byte)
<br>4. ACTIVE input signal is high during data transmission, low otherwise
<br>5. CRC 8 bits are shifted serially through CRC output port 
<br>6. Valid signal is high during CRC bits transmission, otherwise low.

## Operation:
<br>1. Initialize the shift registers (R7 – R0) to 8'hD8
<br>2. Shift the data bits into the LFSR in the order of LSB first.
<br>3. Once the last data bit is shifted into the LFSR, the registers contain 
the CRC bits 
<br>4. Shift out the CRC bits in the (R7 – R0) in order, R0 contains the LSB

<br>Testbench with clock frequency = 10 M Hz

