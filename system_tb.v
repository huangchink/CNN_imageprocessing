/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2020 Spring ---------------------- //
// ---------------------- Editor : Claire C ---------------------- //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2020.02.05 ---------------------- //
// ----------------------   mini system top ---------------------- //
/////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps
`define PERIOD 20.0
/////////////////////////////////////////////////////////
//													   //
//               Do not modify the code below              //
//													   //
/////////////////////////////////////////////////////////

`define INPUT_PIC "penguin.bmp"
`define WEIGHT "weight.txt"
`define size 256*256
`define width 256


`include "RAM.v"
`include "ROM.v"
`ifdef syn
`include "/usr/cad/CBDK/CBDK_IC_Contest_v2.1/Verilog/tsmc13_neg.v"
`include "system_syn.v"
`else
`include "system.v"
`endif

module system_tb;

  reg         clk;
  reg         rst;

  wire  [15:0] ROM_IF_Q, ROM_W_Q;
  wire  [15:0] RAM_Q;

  wire [19:0] ROM_IF_A, ROM_W_A;
  wire		ROM_IF_OE, ROM_W_OE;
  wire [19:0] RAM_A;
  wire        RAM_WE;
  wire        RAM_OE;
  wire [15:0] RAM_D;
  wire        done;

  reg [7:0] data [`size*3+54:0];
  reg         real_done;

  integer temp;
  integer ifile1, ofile, pointer;
  integer i, j;
  integer point=0;

  system sys1(
	.clk(clk), .rst(rst), .ROM_IF_Q(ROM_IF_Q), .ROM_W_Q(ROM_W_Q), .RAM_Q(RAM_Q), .ROM_IF_A(ROM_IF_A), .ROM_W_A(ROM_W_A),
	.ROM_IF_OE(ROM_IF_OE), .ROM_W_OE(ROM_W_OE), .RAM_A(RAM_A), .RAM_WE(RAM_WE), .RAM_OE(RAM_OE), .RAM_D(RAM_D), .done(done));

  ROM rom_if (
    .CK(clk),
    .A(ROM_IF_A),
    .OE(ROM_IF_OE),
    .Q(ROM_IF_Q)
  );
  
  ROM rom_w (
    .CK(clk),
    .A(ROM_W_A),
    .OE(ROM_W_OE),
    .Q(ROM_W_Q)
  );

  RAM ram1 (
    .CK(clk),
    .A(RAM_A),
    .WE(RAM_WE),
    .OE(RAM_OE),
    .D(RAM_D),
    .Q(RAM_Q)
  );

  always #(`PERIOD/2) clk = ~clk;
  always @(posedge clk) real_done <= done;

  `ifdef syn
  initial $sdf_annotate("system_syn.sdf", sys1);
  `endif

  initial begin
       clk = 0; rst = 0;
    #5 rst = 1;
    #5 rst = 0;
  end


  initial begin
    ifile1 = $fopen(`INPUT_PIC, "rb");
	
    ofile = $fopen("after_conv.bmp", "wb");

    pointer = $fread(data, ifile1);
    for(i=0;i<`width+3;i=i+1)begin
	rom_if.memory[i]=16'h00ff;
    end
    for(i=0;i<`size;i=i+1)begin
	rom_if.memory[point+`width+3]=data[3*i+54];
	point=point+1;
	if((i+1)%(`width)==0)begin
	rom_if.memory[point+`width+3]=16'h00ff;
	rom_if.memory[point+`width+4]=16'h00ff;
	point=point+2;
	end
    end
    for(i=0;i<`width+2;i=i+1)begin
	rom_if.memory[point+`width+3+i]=16'h00ff;
    end

    $readmemh(`WEIGHT, rom_w.memory);
    $fclose(ifile1);

    wait (real_done)

    for (i=0; i<54; i=i+1) begin
      $fwrite(ofile, "%c", data[i]);
    end

    for (i=0; i<`size; i=i+1) begin
      temp = ram1.memory[i];
      for(j=0;j<3;j=j+1)
      $fwrite(ofile, "%c", temp);
    end

    $fclose(ofile);
    $finish;
  end

  `ifdef FSDB
  initial begin
    $fsdbDumpfile("system.fsdb");
    $fsdbDumpvars("+struct", "+mda");
  end
  `endif

endmodule
