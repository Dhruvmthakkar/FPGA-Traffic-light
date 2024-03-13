//Traffic controller project Dhruv Thakkar - 20/12/2023

// defining the timescale 
`timescale 1ns/1ps ;

//defining parameters
`define True 1'b1
`define False 1'b0
// delays 
`define Y2RDelay = 3
`define R2GDelay = 2

//begining the module

module Traffic_light_controller( road1, road2, x,clk, rst)

//input/output ports
// we have two bit outputs for 3 states 
output[1:0] road1, road2 ;

input x;
//ulatrasonic sensor input

input clk, rst;

 //status defination
 parameter RED = 2'd0,
          YELLOW = 2'd1,
          GREEN =  2'd2;


//states
 parameter 
S0 = 3'd0, //green   ->  red
S1 = 3'd1, //yellow ->  red
S2 = 3'd2, //red   -> red 
S3 = 3'd3, //red   ->  green
S4 = 3'd4; //red   ->  yellow

//state change variables 
reg [2:0] state;
reg [2:0] next_state;

//state change only at posedge of clock
always@(posedge clk)
if(rst)
state <= S0;
else
state <= next_state;

//computing values of both the signals at both roads 
always@(state)
begin
//default case S0
  road1 =Green;
  road2 =RED;

  case (state)
  S0 : ;
  S1 : road1= YELLOW;
  S2 : begin 
      road1 = RED;
      road2 =RED;
       end
  S3 : road2 = GREEN;
       
  S4: begin
      road1=RED;
      road2=YELLOW;
  end 
  endcase
end


// state machines using case statements(sensor outputs)basically x=1 means there is a car on the road 
always@(state or x )
begin 
     case (state)
     S0 : if(x)
         next_state= S1;
         else 
         next_state= S0;
     S1 : begin //delay
         repeat (`Y2RDelay) next_state = S2;
         next_state =S2;
          end
        
     S2 : begin //delay 
         repeat (`R2GDelay) next_state = S3;
         next_state = S3;
          end
    S3 : if(x)
         next_state  = S3;
         else 
         next state = S4;
    S4: begin     
        repeat (`Y2RDelay) next_state = S4;
         next_state =S0;
        end
        default :next_state =S0;

     endcase
end  
endmodule
