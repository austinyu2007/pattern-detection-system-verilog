`timescale 1ns/1ps

module testbench();
  
  logic clk;
  logic reset;
  logic [63:0] needle;
  logic [3:0] nl;
  logic [7:0] hb;
  logic [7:0] pos;
  logic [7:0] count;
  logic [15:0] haystack_bit_length;
  logic [1023:0] haystack;
  logic jackpot;
  logic halt = 1'b0;
  string information_log[$];
  
  logic [7:0] char_tracker;
  
  pattern_checker pc
  (
    .clk(clk),
    .reset(reset),
    
    .halt(halt),
    .needle(needle),
    .needle_length(nl),
    .hay_bit(hb),
    .pos(pos),
    .count(count),
    .jackpot(jackpot)
  );
  
  
  initial begin
    clk = 1'b0;
    forever #5 begin
      clk = ~clk;
    end
  end
  
  initial begin
    #10;
    reset = 1'b1;
    
    #20;
    reset = 1'b0;
    haystack_bit_length = 47;
    needle = "ANA";
    nl = 4'b0011;
    haystack = "BANANA";
    char_tracker = 0;
    
    #1000;
    $display("THIS FINDS (ANA) IN (BANANA)");
    foreach (information_log[i]) begin
      $display("%s", information_log[i]);
    end
    information_log.delete();
    reset = 1'b1;
    
    #20;
    reset = 1'b0;
    haystack_bit_length = 559;
    needle = "memory";
    nl = 4'b0110;
    haystack = "the memory stores data while memory controllers access memory devices";
    char_tracker = 0;
    
    #1000;
    $display("");
    $display("THIS FINDS (memory) in (the memory stores data while memory controllers access memory devices)");
    foreach (information_log[i]) begin
      $display("%s", information_log[i]);
    end
    information_log.delete();
    reset = 1'b1;
    $finish;
  end

  
  //This is for the first needle searching
  always_ff @(posedge clk) begin
    hb <= haystack[haystack_bit_length - 8*char_tracker-:8];
    char_tracker <= char_tracker + 1;
    
    if (char_tracker > haystack_bit_length/8) begin
      halt <= 1'b1;
    end else begin
      halt <= 1'b0;
    end
    
    if (jackpot) begin
      information_log.push_back($sformatf("COUNT NUMBER  %d  FOUND AT POSITION     %d", count, pos));
    end
  end
  
    
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
  end
  
endmodule
