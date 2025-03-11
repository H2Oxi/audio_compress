`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 14:59:28
// Design Name: 
// Module Name: shared_block
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


module shared_block_mdct(
    input  clk_in,
    input  rst_sys,
    input  rst_ctrl,
    input  signed [31:0] shared_wire_in,
    input  signed [31:0] reset_w3_in,    
    input  signed [31:0] reset_w6_in,  
    input  signed [15:0] t1, 
    output signed [31:0] shared_wire_o
    
    );
    wire signed [31:0] w1,w2,w3,w6;//,w8;
    reg signed  [31:0] w4,w7;
    wire signed [43:0] w5;
    
    assign w2=shared_wire_in+w1;
    assign w1=(w5[43]?{2'b11,w5[43:14]}:{2'b00,w5[43:14]})-w7;    
    assign shared_wire_o=w2;
   // assign w5=(w4[15:0])*t1;    
    //assign w8=t2[15]?{4'b1111,4'b1111,4'b1111,4'b1111,t2}:{16'd0,t2};    
    //assign shared_wire_o=(w2[15:0] * t2);
    wire signed [27:0] w4_temp = w4[27:0];
    assign w5=t1*w4_temp;//,14
    assign w6=rst_ctrl?reset_w6_in:w4;
    assign w3=rst_ctrl?reset_w3_in:w2;
    //reg1
    always @(posedge clk_in or negedge rst_sys)
    begin
        if(!rst_sys)begin 
        w4<= 0;   
        end
        else
        w4<= w3;       
    end
    //reg2

    always @(posedge clk_in or negedge rst_sys)
    begin
        if(!rst_sys)begin 
        w7<=0;    
        end        
        else        
        w7<= w6;  
    end 
    
    
       
endmodule
