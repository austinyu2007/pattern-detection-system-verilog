`timescale 1ns/1ps

module pattern_checker
  (
    input logic clk,
    input logic reset,
    input logic halt,
    
    input logic [63:0] needle,
    input logic [3:0] needle_length,
    input logic [7:0] hay_bit,
    
    output logic [7:0] pos,
    output logic [7:0] count,
    output logic jackpot
  );
  logic [7:0] char_bit [0:7]; //Bit representations of each character of the needle
  logic [10:0] chars_processed; //Current location

  logic [7:0] found_count; //How many full needles have been found in the haystack
  logic [3:0] char_match; //How many characters have matched in a row
  logic [7:0] temp_position; //Stores the position of the first matched character of a possible full match
  logic needle_initialized; //Checks if the needle has been loaded into memory yet

  always_ff @(posedge clk or posedge reset or posedge halt) begin
    //Reset logic
    if (reset) begin
      pos 					<= '0;
      count 				<= '0;
      jackpot				<= '0;
      found_count 			<= '0;
      char_match 			<= '0;
      chars_processed 		<= '0;
      needle_initialized 	<= '0;
      temp_position 		<= '0;

      
      for (int i = 0; i < 8; i++) begin
        char_bit[i] <= 8'b0;
      end
      
    //If no reset, then initialize/look for needle
    end else if (halt == 1'b0) begin
      //If the needle has not been loaded into memory yet
      if (needle_initialized == 1'b0) begin
        //Load each bit of the needle into memory
        needle_initialized <= 1'b1;
        for (int i = 0; i < 8; i++) begin
          char_bit[i] <= needle[(i + 1) * 8 - 1 -:8];
        end
        
        
      //If the needle has indeed been loaded
      end else begin
        chars_processed <= chars_processed + 1;
        //If the needle bit has found a match in the haystack
        if (char_bit[needle_length - 1 - char_match] == hay_bit) begin
          //This checks if there are enough char matches for a full match. Subtract one since this uses the old value of char_match, and since we know we have a new char_match, there are enough match counts for a full match.
          if (char_match == needle_length - 1) begin
            char_match <= 4'b0; //Reset char matches to prepare for a new search
            found_count <= found_count + 1; //Add one to full match
            count <= found_count + 1; //Add one because of one cycle delay
            pos <= temp_position;
            jackpot <= 1'b1;
          //If there arent enough match counts yet, keep going
          end else begin
            jackpot <= 1'b0;
            char_match <= char_match + 1;
            //If this is the first char match count found
            if (char_match == 4'b0) begin
              temp_position <= chars_processed + 1;
            end
          end
        end else begin
          jackpot <= 1'b0;
          char_match <= 4'b0;
        end
      end
    end
    
  end
endmodule
