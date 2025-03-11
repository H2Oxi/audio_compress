`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/14 13:10:22
// Design Name: 
// Module Name: quan_ctrl
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


module iquan_ctrl(
    input clk_in,
    input rst_n,//sw
    input start,//start is spike 
    output reg intr, 
    //
    output reg [8 : 0] addra_r,
    output reg wea_r            ,
    output  ena_r            ,
    output reg [15 : 0] douta_iquan_o_r,      
    //
    input signed [3:0] quan_data      ,
    output reg [8:0] addr_iquan
    );
    wire [3 : 0] douta_iquan_o;
    
    reg[1:0] current_state;
    reg[1:0] next_state;
    reg en_iquan;
    
    assign ena_r=wea_r;
    always @ (posedge clk_in or negedge rst_n) 
     begin
        if(!rst_n)
                addr_iquan <= 0;
        else
                addr_iquan <= en_iquan?(addr_iquan+1):addr_iquan;      
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
                      if(start) 
                         next_state = 1;
                      else
                         next_state = 0;
                  end
            1: begin  
                      if(addr_iquan==256) 
                         next_state = 2;
                      else
                         next_state = 1;            
            end
            2:begin next_state = 0;end
            3:begin end
            default:begin 
            next_state=0;
            end   
       endcase
    end  
    always @ (posedge clk_in or negedge rst_n) 
     begin
        if(!rst_n)begin
            intr=0;
            en_iquan=0;
        end
        else
             case(current_state)
                0:begin intr=0;en_iquan=0;end
                1:begin en_iquan=1;end
                2:begin en_iquan=0;intr=1;end
                3:begin end
                default: begin end            
             endcase
    end
        always @ (negedge clk_in or negedge rst_n) 
    begin
        if(!rst_n) begin
            wea_r<=0;  
            addra_r<=0;
            douta_iquan_o_r<=0;
        end
        else begin
            wea_r<=en_iquan;
            addra_r<=addr_iquan;
            douta_iquan_o_r<=douta_iquan_o+16'b1000_0000_0000_0000;
        end
    end         
                   
    inv_quan inv_quan_instance(
        .input_iquan(quan_data),
        .output_iquan(douta_iquan_o)
    );
    
    



endmodule
