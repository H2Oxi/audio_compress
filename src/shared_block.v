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


module shared_block(
    input  clk_in,
    input  rst_sys,
    input  rst_ctrl,
    input  signed [31:0] shared_wire_in,
    input  signed [31:0] reset_w3_in,    
    input  signed [31:0] reset_w6_in,  
    input  signed [15:0] t1,
    input  signed [15:0] t2, 
   // input  fast_clk,
    output signed [31:0] shared_wire_o
    
    );
    wire signed [31:0] w1,w2,w3,w5,w6;//,w8;
    reg signed  [31:0] w4,w7;
    
    
    assign w2=shared_wire_in+w1;
    assign w1=(w5<<<2)-w7;    
   // assign w5=(w4[15:0])*t1;    
    //assign w8=t2[15]?{4'b1111,4'b1111,4'b1111,4'b1111,t2}:{16'd0,t2};    
    //assign shared_wire_o=(w2[15:0] * t2);
/*mult_gen_0 multi_0 (
  .CLK(fast_clk),  // input wire CLK
  .A(w2[31:16]),      // input wire [15 : 0] A
  .B(t2),      // input wire [15 : 0] B
  .P(shared_wire_o)      // output wire [31 : 0] P
);*/
    wire signed [15:0] w2_temp=w2[31:16];
    assign shared_wire_o=w2_temp*t2;

/*mult_gen_0 multi_1 (
  .CLK(fast_clk),  // input wire CLK
  .A(w4[31:16]),      // input wire [15 : 0] A
  .B(t1),      // input wire [15 : 0] B    //1£¬16£¬14
  .P(w5)      // output wire [31 : 0] P
);    */
    wire signed [15:0] w4_temp=w4[31:16];
    assign w5=w4_temp*t1;   

    assign w6=rst_ctrl?reset_w6_in:w4;
    assign w3=rst_ctrl?reset_w3_in:w2;
    //reg1
    always @ (posedge clk_in or negedge rst_sys) 
    begin
        if(!rst_sys)begin 
        w4<= 0;   
        end
        else
        w4<= w3;       
    end
    //reg2
    always @ (posedge clk_in or negedge rst_sys) 
    begin
        if(!rst_sys)begin 
        w7<=0;    
        end        
        else        
        w7<= w6;  
    end 
    
    
       
endmodule
