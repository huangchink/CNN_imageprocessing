`define DATA_BIT 16
module conv(clk,rst,clear,w_w,w_in,if_w,if_in,out);

  // ---------------------- input  ---------------------- //
 input	clk;
 input	rst;
 input	clear;
 input	w_w;
 input	if_w;	
 input [`DATA_BIT-1:0] w_in;
 input [`DATA_BIT-1:0] if_in;
 
 // ---------------------- output  ---------------------- //
 output signed [`DATA_BIT*2+1:0]out;
 wire signed [`DATA_BIT*2:0]out1;
 // -----------------------  reg  ----------------------- //
 reg signed [`DATA_BIT-1:0] weight [2:0];
 reg signed [`DATA_BIT-1:0] feature [2:0];
 
 // ---------------------- Write down Your design below  ---------------------- //
 always@(posedge rst  or posedge clk)
begin
if(rst)
begin
weight[0]<=16'd0;
weight[1]<=16'd0;
weight[2]<=16'd0;
feature[0]<=16'd0;
feature[1]<=16'd0;
feature[2]<=16'd0;
end

else if(clear)
begin
weight[0]<=16'd0;
weight[1]<=16'd0;
weight[2]<=16'd0;
feature[0]<=16'd0;
feature[1]<=16'd0;
feature[2]<=16'd0;
end
else
begin
if(w_w==1'b1 )
begin
weight[0]<=weight[1];
weight[1]<=weight[2];
weight[2]<=w_in;
end

if(if_w==1'b1 )
begin
feature[0]<=feature[1];
feature[1]<=feature[2];
feature[2]<=if_in;
end
end
end

assign out1 = weight[2]*feature[2]+weight[1]*feature[1]+weight[0]*feature[0];
assign out  ={out1[32],out1};
  
endmodule
