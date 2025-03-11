`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 09:43:14
// Design Name: 
// Module Name: process_ctrl
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


module process_ctrl(
    input clk_in,
    input rst_n, 
    //
    input start_sys,
    input intr_clr_sys,
    input [13 : 0] start_music_addr,
    output reg start_clr_sys,
    output reg intr_sys,
    //
    output reg start_mdct,
    output reg [13 : 0] start_music_addr_r,
    input finish_mdct,  
    output reg rstn_mdct,  
    //
    output reg start_imdct,
    input finish_imdct,
    output reg rstn_imdct      
    
    );
    
parameter IDLE = 3'b000;//init all 
parameter START_MDCT =   3'b001;  //start_imdct
parameter WAIT_MDCT =   3'b010;  //finish_imdct
parameter START_IMDCT =   3'b100; 
parameter WAIT_IMDCT =   3'b101; 
parameter INTERRUPT  =   3'b110;
parameter WAIT_GLOBAL_1      =       3'b111;
parameter WAIT_GLOBAL_2 = 3'b011;

(* KEEP="TRUE" *) reg[2:0] current_state;
(* KEEP="TRUE" *) reg[2:0] next_state;  

reg start_mdct_r     ;
reg start_imdct_r    ;

always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            start_music_addr_r <= 0;
    else
            start_music_addr_r <= start_music_addr;
end

always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            current_state <= IDLE;
    else
            current_state <= next_state;
end

always @ (*) begin
    case(current_state)
        IDLE: begin
                  if(start_sys) 
                    next_state = WAIT_GLOBAL_1;
                  else  begin  
                    next_state = IDLE;                         
                  end
              end
        START_MDCT: begin  next_state = WAIT_MDCT;      end
        WAIT_MDCT  :begin 
            if(finish_mdct)
                next_state = START_IMDCT;
            else
                next_state = WAIT_MDCT;
        end   
        START_IMDCT:begin next_state = WAIT_IMDCT; end
        WAIT_IMDCT :begin 
            if(finish_imdct)
                next_state = INTERRUPT;
            else
                next_state = WAIT_IMDCT;       
        end
        INTERRUPT  :begin next_state = IDLE;end
        WAIT_GLOBAL_1:begin next_state = WAIT_GLOBAL_2; end
        WAIT_GLOBAL_2:begin next_state = START_MDCT;end
        default:begin 
        next_state=IDLE;
        end
        
   endcase
end
always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
    begin
        start_clr_sys=0;
        intr_sys=0; 
        start_mdct_r =0;
        start_imdct_r=0;
        rstn_mdct=0;
        rstn_imdct=0;
    end
    else
         case(current_state)
        IDLE:begin 
                rstn_mdct=0;
                rstn_imdct=0;
                if(start_sys)
                    start_clr_sys <= 1'b1 ;
                else if (intr_clr_sys)
					intr_sys = 1'b0 ;       
        end
        START_MDCT  :begin start_mdct_r=1; end
        WAIT_MDCT   :begin start_mdct_r=0;end
        START_IMDCT :begin start_imdct_r=1;end
        WAIT_IMDCT  :begin start_imdct_r=0;end
        INTERRUPT   :begin intr_sys=1;end
        WAIT_GLOBAL_1:begin rstn_mdct=1;rstn_imdct=1;  end  
        WAIT_GLOBAL_2:begin end      
        
        default:begin end
        endcase
 end
 always @ (negedge clk_in or negedge rst_n) 
 begin     
     if(!rst_n) begin
            start_imdct <= 0;
            start_mdct<=0;end
    else begin
            start_imdct <= start_imdct_r;
            start_mdct<=start_mdct_r; end
end   
endmodule
