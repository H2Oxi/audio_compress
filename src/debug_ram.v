`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 14:03:12
// Design Name: 
// Module Name: debug_ram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debug_ram(
    output rstb          ,
    output enb           ,
    output [3 : 0] web   ,    
    output reg [31 : 0] addrb,    
    output [31 : 0] dinb ,    
    input clk_in,
    input rst_n ,
    input debug_start    
    );
reg[1:0] current_state;
reg[1:0] next_state;
assign web=4'd0;
assign rstb=0;
assign enb=next_state;
assign dinb=0;

always @ (negedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            addrb <= 0;
    else
            addrb <= enb?(addrb+4):addrb;      
end 
      
always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            current_state <= 0;
    else
            current_state <= next_state;
            
end    
always @ (*) begin
    case(current_state)
        0: begin
                  if(debug_start) 
                    next_state = 1;
              end
        1: begin  next_state = 1;      end
        default:begin 
        next_state=0;
        end   
   endcase
end
    
endmodule
