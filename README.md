# pattern-detection-system-verilog
A clocked pattern-matching engine implemented in SystemVerilog, supporting programmable needle patterns up to 8 characters, with real-time match counting and position tracking — verified through two test cases with automated match logging.

## Overview
This project implements a streaming pattern-matching engine that scans a continuous stream of haystack bytes and detects occurrences of a programmable needle (search pattern), including:

- A 64-bit programmable needle input, supporting patterns up to 8 characters
- Character-by-character streaming comparison against a haystack fed one byte per clock cycle
- Match counting (count) and first-match position tracking (pos) for every full match found
- A jackpot flag asserted on each complete match

## Architecture
The design is a single FSM-driven module (pattern_checker) with the following behavior:

- On reset, all internal state (match counters, position tracking, loaded needle) is cleared
- On the first clock cycle after reset, the needle is loaded into an internal 8-byte character array (char_bit)
- On each subsequent cycle, the current haystack byte (hay_bit) is compared against the expected next character of the needle
- - A matching character advances the match counter (char_match)
- - A full match (all needle characters matched in sequence) increments found_count, updates count and pos, and asserts jackpot
- - A non-matching character resets the match counter, restarting the search from the current position
 
## How to Run
1. Compile pattern_checker.sv and testbench.sv in your SystemVerilog simulator (e.g. Icarus Verilog, ModelSim, Vivado Simulator)
2. Run the simulation — output is printed via $display, showing the count and position of each match found
3. Waveforms are dumped to dump.vcd (view with GTKWave or similar); a screenshot is included in waveforms/

## Verification
The design was verified using 2 directed test cases, each loading a different needle and haystack, verifying match detection across different pattern lengths:
```
+------+----------+---------+----------------------------+
| TEST | NEEDLE   | LENGTH  | HAYSTACK (see testbench.sv)|
+------+----------+---------+----------------------------+
|  1   | "ANA"    | 3 chars | "BANANA"                   |
+------+----------+---------+----------------------------+
|  2   | "memory" | 6 chars | "the memory stores..."     |
+------+----------+---------+----------------------------+
```
For each test, the testbench streams the haystack into the design one byte per clock cycle — using a configurable haystack_bit_length variable to correctly handle haystacks of different sizes — and logs every detected match (count and pos) to a queue, which is printed as a formatted table at the end of each run. Sample output and waveform captures (shown in both binary and ASCII format for readability) are included in docs/ and waveforms/.

## Design Notes / Known Limitations
The haystack_bit_length variable has to be manually set every time for a new test case. Additionally, the max size of the needle is 8 characters. 

The design does not count overlapping matches. After a full match is found, character matching resets and searches from the next position, rather than checking for matches that start within an already-matched sequence (e.g., searching for "ANA" in "BANANA" would find one match, not two overlapping ones)

## Future Work
- Increase max character size of needle
- Automatically adjust haystack_bit_size
