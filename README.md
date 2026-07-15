# pattern-detection-system-verilog
A clocked pattern-matching engine implemented in SystemVerilog, allowing for needles of up to 8 bytes to be found in haystacks of any size.

## Overview
This project implements a system that allows for a needle input (the text desired to be found) to be compared to a continuous stream of haystack data (one byte at a time)

- A 64-bit programmable needle input (up to 8 characters, but you don't need to use them all)
- The haystack is brought in one byte at a time to reduce memory usage
- Match counting (count) and first-match position tracking (pos) for every full match found
- A jackpot flag raised on each complete match

## Architecture
- On reset, all internal state is cleared
- On the first clock cycle after reset, the needle is loaded into an internal 8-byte character array (char_bit)
- On each subsequent cycle, the current haystack byte (hay_bit) is compared against the expected next character of the needle
- A matching character advances the match counter (char_match)
- A full match (all needle characters matched in sequence) increments found_count, updates count and pos, and outputs jackpot
- A non-matching character resets the match counter, restarting the search from the current position
 
## How to Run
1. Compile pattern_checker.sv and testbench.sv in your SystemVerilog simulator
2. Run the simulation
3. Waveforms are dumped to dump.vcd; a screenshot is included in waveforms/
4. Text output is stored in docs/

## Verification
The design was verified using 2 test cases, each loading a different needle and haystack of different sizes
```
+------+-----------+----------------+------------------------------------------------------+
| TEST |  NEEDLE   | NEEDLE LENGTH  |                      HAYSTACK                         |
+------+-----------+----------------+------------------------------------------------------+
|  1   |   "ANA"   |  3 characters  | "BANANA"                                              |
+------+-----------+----------------+------------------------------------------------------+
|  2   |  "memory" |  6 characters  | "the memory stores data while memory controllers      |
|      |           |                |  access memory devices"                               |
+------+-----------+----------------+------------------------------------------------------+
```
For each test, the testbench streams the haystack into the design one byte per clock cycle. Sample output and waveform captures (shown in both binary and ASCII format for readability) are included in docs/ and waveforms/.

## Design Notes / Known Limitations
The haystack_bit_length variable has to be manually set every time for a new test case. Additionally, the max size of the needle is 8 characters. 

The design does not count overlapping matches (for example searching for "ANA" in "BANANA" would find one match, not two overlapping ones)

## Future Work
- Increase max character size of needle
- Automatically adjust haystack_bit_size instead of manually doing it every time for a new test
