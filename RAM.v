//*************************************************
//** 2019 spring iVCAD
//** Description: Random-access memory
//** Mar. 2018 Henry authored
//** Mar. 2019 Kevin revised
//*************************************************

`timescale 1ns/10ps

module RAM (CK, A, WE, OE, D, Q);

  input         CK;
  input  [19:0] A;
  input         WE;
  input         OE;
  input  [15:0] D;
  output [15:0] Q;

  reg    [15:0] Q;
  reg    [19:0] latched_A;
  reg    [15:0] memory [0:786431];

  always @(posedge CK) begin
  
    if (WE) begin
	
		memory[A] <= D;
		
    end
	
		latched_A <= A;
  end

  always @(OE or latched_A) begin
  
    if (OE) begin
	
      Q = memory[latched_A];
	  
    end
    else begin
	
      Q = 24'hz;
	  
    end
	
  end

endmodule
