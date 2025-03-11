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


module quan_ctrl(
    input clk_in,
    input rst_n,//sw
    input start,//start is spike 
    output reg intr, 
    //
    output reg [8 : 0] addra_r,
    output reg wea_r            ,
    output  ena_r            ,
    output reg [3 : 0] douta_quan_o_r,      
    //
    input  [15:0] mdct_data      ,
    output reg [8:0] addr_mdct
    );
    wire [3 : 0] douta_quan_o;
    
    reg[1:0] current_state;
    reg[1:0] next_state;
    reg en_quan;
    wire [15:0] mdct_data_non;
    
    assign mdct_data_non=mdct_data+16'b1000_0000_0000_0000;
    assign ena_r=wea_r;
    always @ (posedge clk_in or negedge rst_n) 
     begin
        if(!rst_n)
                addr_mdct <= 0;
        else
                addr_mdct <= en_quan?(addr_mdct+1):addr_mdct;      
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
                      if(addr_mdct==256) 
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
            en_quan=0;
        end
        else
             case(current_state)
                0:begin intr=0;en_quan=0;end
                1:begin en_quan=1;end
                2:begin en_quan=0;intr=1;end
                3:begin end
                default: begin end            
             endcase
    end
        always @ (negedge clk_in or negedge rst_n) 
    begin
        if(!rst_n) begin
            wea_r<=0;  
            addra_r<=0;
            douta_quan_o_r<=0;
        end
        else begin
            wea_r<=en_quan;
            addra_r<=addr_mdct;
            douta_quan_o_r<=douta_quan_o;
        end
    end         
                   
    quan quan_instance(
        .input_quan(mdct_data_non),
        .output_quan(douta_quan_o)
    );
    
    



endmodule
