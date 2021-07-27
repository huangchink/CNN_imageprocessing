 /////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2020 Spring ---------------------- //
// ---------------------- Editor : Claire C ---------------------- //
// ---------------------- Version : v.1.00  ---------------------- //
// ---------------------- Date : 2020.02.05 ---------------------- //
// ---------------------mini system controller-------------------- //
/////////////////////////////////////////////////////////////////////
//`timescale 1ns/10ps

module Controller (clk, rst, ROM_IF_A, ROM_W_A, ROM_IF_OE, ROM_W_OE, RAM_A, 
					RAM_WE, RAM_OE, sel_if, sel_w, clear, done);

  parameter INIT    = 3'b000,READ_W=3'b001,WRITE=3'b010,READ_C=3'b011,READ_9=3'b100,Done=3'b101;
            //You should complete this part

  input         clk;
  input         rst;
  output reg [19:0] ROM_IF_A, ROM_W_A;
  output reg		ROM_IF_OE, ROM_W_OE;
  output reg [19:0] RAM_A;
  output reg		RAM_WE;
  output reg		RAM_OE;
  output reg [2:0]  sel_if, sel_w;
  output reg		clear;
  output reg 		done;

  reg	[2:0] tsel_if, tsel_w;
  reg   [2:0]  state,n_state;
  reg	[19:0] column;
  reg   [19:0]  row;
  reg   [3:0]	counter;

always@(posedge clk or posedge rst)begin//state
if(rst)
	state<=INIT;
else
	state<=n_state;
end

//You should complete all the other control signals here
always@(posedge clk or posedge rst)begin//counter for all cases
  if(rst)begin
    counter<=4'd0;
  end

//
else if(state==READ_W && counter==4'd9)
      counter<=4'd0;

//
  else if(state==READ_W)
     counter<=counter+4'd1;

  

  else if(state==READ_C)
     counter<=counter+4'd1;
  else if(state==READ_9)
     counter<=counter+4'd1;
  else if(state==WRITE || state==INIT)
     counter<=4'd0;
end
always@(*)begin//sel_w sel_if
    if(state==INIT)begin
    sel_w=3'b0;
      sel_if=3'b0;
end
else if(state==READ_W)
	begin
if(counter==4'd0)begin//
                  sel_w=3'b000;
		  sel_if=3'b000;
              end
else  if(counter==4'd1)begin
  			sel_w=3'b001;
		  sel_if=3'b001;

end
else if(counter==4'd2)begin
  			sel_w=3'b001;
		  sel_if=3'b001;

end
else if(counter==4'd3)begin
  			sel_w=3'b001;
		  sel_if=3'b001;

end

else   if(counter==4'd4)begin
                  sel_w=3'b010;
		  sel_if=3'b010;
              end
else   if(counter==4'd5)begin
                  sel_w=3'b010;
		  sel_if=3'b010;
              end
else   if(counter==4'd6)begin
                  sel_w=3'b010;
		  sel_if=3'b010;
              end
else  if(counter==4'd7)begin
                  sel_w=3'b100;
	          sel_if=3'b100;
              end
else  if(counter==4'd8)begin
                  sel_w=3'b100;
	          sel_if=3'b100;
              end
else  if(counter==4'd9)begin
                  sel_w=3'b100;
	          sel_if=3'b100;
              end
else begin
 	           sel_w=3'b100;
	          sel_if=3'b100;
    end
end
else if(state==READ_C)
	begin
          if(counter==4'd0)begin
                  sel_if=3'b000;
	            sel_w=3'b000;
              end
         else if(counter==4'd1)begin
                  sel_if=3'b001;
			sel_w=3'b000;
              end
         else if(counter==4'd2)begin
                  sel_if=3'b010;
			sel_w=3'b000;
              end
	 else if(counter==4'd3)begin
                  sel_if=3'b100;
			sel_w=3'b000;
              end
else  begin
			sel_if=3'b100;
			sel_w=3'b000;

end
    end
else if(state==READ_9)begin
if(counter==4'd0)begin//
                  sel_w=3'b000;
		  sel_if=3'b000;
              end
else  if(counter==4'd1)begin
  			sel_w=3'b000;
		  sel_if=3'b001;

end
else if(counter==4'd2)begin
  			sel_w=3'b000;
		  sel_if=3'b001;

end
else if(counter==4'd3)begin
  			sel_w=3'b000;
		  sel_if=3'b001;

end

else   if(counter==4'd4)begin
                  sel_w=3'b000;
		  sel_if=3'b010;
              end
else   if(counter==4'd5)begin
                  sel_w=3'b000;
		  sel_if=3'b010;
              end
else   if(counter==4'd6)begin
                  sel_w=3'b000;
		  sel_if=3'b010;
              end
else  if(counter==4'd7)begin
                  sel_w=3'b000;
	          sel_if=3'b100;
              end
else  if(counter==4'd8)begin
                  sel_w=3'b000;
	          sel_if=3'b100;
              end
else  if(counter==4'd9)begin
                  sel_w=3'b000;
	          sel_if=3'b100;
              end
else begin
sel_w=3'b000;
	          sel_if=3'b100;
end
end
	else if(state==WRITE)
   begin
	          sel_if=3'b000;
                  sel_w=3'b000;
    end
     else
begin
		sel_if=3'b000;
                  sel_w=3'b000;
end
end

always@(*)begin//RAM_A
if(state==INIT)
RAM_A=20'd0;
if(column==20'd0)
RAM_A=(row<<8)+column;
else
RAM_A=(row<<8)+(column-20'd2);
end

always@(*)begin//ROM_IF_A 
   
if(state==INIT)
ROM_IF_A=20'd0;
 else   if(state==READ_W)begin
   if(counter==4'd0)begin
    ROM_IF_A=(row<<8)+(row<<1)+column;
   end
   
  else if(counter==4'd1)begin
    ROM_IF_A=(row<<8)+(row<<1)+(column+20'd1);
   end
   
   else if(counter==4'd2)begin
    ROM_IF_A=(row<<8)+(row<<1)+(column+20'd2);
   end
   
   else if(counter==4'd3)begin
    ROM_IF_A=((row+20'd1)<<8)+((row+20'd1)<<1)+column;
   end
   
    else if(counter==4'd4)begin
    ROM_IF_A=((row+20'd1)<<8)+((row+20'd1)<<1)+(column+20'd1);
   end
   
    else if(counter==4'd5)begin
    ROM_IF_A=((row+20'd1)<<8)+((row+20'd1)<<1)+(column+20'd2);
   end
   
    else if(counter==4'd6)begin
    ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+column;
   end
   
    else if(counter==4'd7)begin
    ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+(column+20'd1);
   end
   
    else if(counter==4'd8)begin
    ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+(column+20'd2);
   end

    else if(counter==4'd9)begin
    ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+(column+20'd2);
   end
else ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+(column+20'd2);
   end

   else if(state==READ_9)begin
    if(counter==4'd0)begin
    ROM_IF_A=(row<<8)+(row<<1)+column;
   end
   
  else if(counter==4'd1)begin
    ROM_IF_A=(row<<8)+(row<<1)+(column+20'd1);
   end
   
   else if(counter==4'd2)begin
    ROM_IF_A=(row<<8)+(row<<1)+(column+20'd2);
   end
   
   else if(counter==4'd3)begin
    ROM_IF_A=((row+20'd1)<<8)+((row+20'd1)<<1)+column;
   end
   
    else if(counter==4'd4)begin
    ROM_IF_A=((row+20'd1)<<8)+((row+20'd1)<<1)+(column+20'd1);
   end
   
    else if(counter==4'd5)begin
    ROM_IF_A=((row+20'd1)<<8)+((row+20'd1)<<1)+(column+20'd2);
   end
   
    else if(counter==4'd6)begin
    ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+column;
   end
   
    else if(counter==4'd7)begin
    ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+(column+20'd1);
   end
   
    else if(counter==4'd8)begin
    ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+(column+20'd2);
   end

    else if(counter==4'd9)begin
    ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+(column+20'd2);
   end
else ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+(column+20'd2);
    end   
   else if(state==READ_C)begin
          if(counter==4'd0)begin
             ROM_IF_A=(row<<8)+(row<<1)+column;
          end
         else if(counter==4'd1)begin
             ROM_IF_A=((row+20'd1)<<8)+((row+20'd1)<<1)+column;
          end
         else if(counter==4'd2)begin
             ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+column;
          end
	 else if(counter==4'd3)begin
             ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+column;
          end
         else
 ROM_IF_A=((row+20'd2)<<8)+((row+20'd2)<<1)+column;
   end
else
ROM_IF_A=20'd0;
end
always@(*)begin// ROM_W_A
   if(state==INIT)
ROM_W_A=20'd0;
 else   if(state==READ_W)begin
          if(counter==4'd0)begin
             ROM_W_A=20'd0;
              end
         else if(counter==4'd1)begin
             ROM_W_A=20'd1;
              end
         else if(counter==4'd2)begin
             ROM_W_A=20'd2;
              end
         else if(counter==4'd3)begin
             ROM_W_A=20'd3;
              end
         else if(counter==4'd4)begin
             ROM_W_A=20'd4;
              end
         else if(counter==4'd5)begin
             ROM_W_A=20'd5;
              end
         else if(counter==4'd6)begin
             ROM_W_A=20'd6;
              end
         else if(counter==4'd7)begin
             ROM_W_A=20'd7;
              end
         else if(counter==4'd8)begin
             ROM_W_A=20'd8;
              end
	else if(counter==4'd9)begin

	ROM_W_A=20'd8;
	
	end
else ROM_W_A=20'd8;
    end   
else
ROM_W_A=20'd0;
end



always@(posedge clk or posedge rst)begin//col row
  if(rst)begin
     column<=20'd0;
	 row<=20'd0;
  end

else if (column==20'd0 && state==WRITE)
begin

column<=column+20'd3;
end
  else if(state==WRITE && column==20'd257)begin
        column<=20'd0;
        row<=row+20'd1;
   end
  else if(state==WRITE)
   column<=column+20'd1;
/*
   else if(state==READ_C && counter==4'd0 )begin//let column only plus one time
      column<=column+11'd1;
   end
*/
 
  else if(state==READ_C)
  row<=row;
end

     
 
  
 

always@(*)begin//n_state
  case(state)
       INIT:begin
            n_state=READ_W;
      

   
end
       READ_W:begin
                  if(counter==4'd9)
                     n_state=WRITE;
                  else
                     n_state=READ_W;
              end
       READ_C:begin
                  if(counter==4'd3)
                     n_state=WRITE;
                  else
                     n_state=READ_C;
              end
       READ_9:begin
                  if(counter==4'd9)
                     n_state=WRITE;
                  else
                     n_state=READ_9;
              end
       WRITE:begin
                  if(column==20'd257&&row==20'd255)
                     n_state=Done;
                  else if(column==20'd257)
                     n_state=READ_9;
                  else
                     n_state=READ_C;
              end
       Done:n_state=INIT;    
 default:n_state=Done;
endcase
end



always@(*)begin //out
case(state)
INIT:begin
	ROM_IF_OE=1'b0;
	ROM_W_OE=1'b0;
	RAM_WE=1'b0;
	RAM_OE=1'b0;
	clear=1'b0;
	done=1'b0;
	end
	
//You should complete this part	
READ_W:begin
        ROM_IF_OE=1'b1;
	ROM_W_OE=1'b1;
	RAM_WE=1'b0;
	RAM_OE=1'b0;
	clear=1'b0;
	done=1'b0;
      end
WRITE:begin
      ROM_IF_OE=1'b0;
	ROM_W_OE=1'b0;
	RAM_WE=1'b1;
	RAM_OE=1'b0;
	clear=1'b0;
	done=1'b0;
	end
READ_C:begin
      ROM_IF_OE=1'b1;
	ROM_W_OE=1'b0;
	RAM_WE=1'b0;
	RAM_OE=1'b0;
	clear=1'b0;
	done=1'b0;
	end
READ_9:begin
      ROM_IF_OE=1'b1;
	ROM_W_OE=1'b0;
	RAM_WE=1'b0;
	RAM_OE=1'b0;
	clear=1'b0;
	done=1'b0;
	end
Done:begin
      ROM_IF_OE=1'b0;
	ROM_W_OE=1'b0;
	RAM_WE=1'b0;
	RAM_OE=1'b0;
	clear=1'b0;
	done=1'b1;
	end

default:begin
	ROM_IF_OE=1'b0;
	ROM_W_OE=1'b0;
	RAM_WE=1'b0;
	RAM_OE=1'b0;
	clear=1'b0;
	done=1'b0;
	end
endcase
end
endmodule
