/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2020 Spring ---------------------- //
// ---------------------- Editor : Claire C ---------------------- //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2020.02.05 ---------------------- //
// ----------------------   mini system top ---------------------- //
/////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
`include "conv.v"
`include "sat_adder.v"
`include "Controller.v"
/////////////////////////////////////////////////////////
//													   //
//               Do not modify the code below              //
//													   //
/////////////////////////////////////////////////////////

module system (clk, rst, ROM_IF_Q, ROM_W_Q, RAM_Q, ROM_IF_A, ROM_W_A,
  ROM_IF_OE, ROM_W_OE, RAM_A, RAM_WE, RAM_OE, RAM_D, done);

  input         clk;
  input         rst;
  input  [15:0] ROM_IF_Q, ROM_W_Q;
  input  [15:0] RAM_Q;

  output [19:0] ROM_IF_A, ROM_W_A;
  output		ROM_IF_OE, ROM_W_OE;
  output [19:0] RAM_A;
  output        RAM_WE;
  output        RAM_OE;
  output [15:0] RAM_D;
  output        done;
  

  wire [2:0]  sel_if, sel_w;
  wire 		  clear;
  wire [33:0]	out0, out1, out2;
  

  

  conv conv1 (
  .clk(clk), .rst(rst), .clear(clear), .w_w(sel_w[0]), .w_in(ROM_W_Q), .if_w(sel_if[0]), .if_in(ROM_IF_Q), .out(out0));
  
  conv conv2 (
  .clk(clk), .rst(rst), .clear(clear), .w_w(sel_w[1]), .w_in(ROM_W_Q), .if_w(sel_if[1]), .if_in(ROM_IF_Q), .out(out1));
  
  conv conv3 (
  .clk(clk), .rst(rst), .clear(clear), .w_w(sel_w[2]), .w_in(ROM_W_Q), .if_w(sel_if[2]), .if_in(ROM_IF_Q), .out(out2));
  
  sat_adder a1 (
  .in0(out0), .in1(out1), .in2(out2), .sum(RAM_D));

  Controller c1(
  .clk(clk), .rst(rst), .ROM_IF_A(ROM_IF_A), .ROM_W_A(ROM_W_A), .ROM_IF_OE(ROM_IF_OE),
  .ROM_W_OE(ROM_W_OE), .RAM_A(RAM_A), .RAM_WE(RAM_WE), .RAM_OE(RAM_OE), .sel_if(sel_if),
  .sel_w(sel_w), .clear(clear), .done(done));

endmodule
