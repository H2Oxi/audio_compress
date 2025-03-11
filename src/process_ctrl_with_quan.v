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


module process_ctrl_with_quan(
    input clk_in,
    input rst_n, 
    //
    input start_sys,
    input intr_clr_sys,
    input [18 : 0] start_music_addr,
    output reg start_clr_sys,
    output reg intr_sys,
    //
    output reg start_mdct,
    output reg [18 : 0] start_music_addr_r,
    input finish_mdct,  
    output reg rstn_mdct,  
    //
    output reg start_imdct,
    input finish_imdct,
    output reg rstn_imdct ,     
    //
    output reg start_quan,
    input finish_quan,
    output reg rstn_quan,
    //
    output reg start_iquan,
    input finish_iquan   ,
    output reg rstn_iquan    
    
    );
    
parameter IDLE =             4'b0000;//init all 
parameter START_MDCT =       4'b0001;  //start_imdct
parameter WAIT_MDCT =        4'b0010;  //finish_imdct
parameter START_IMDCT =      4'b0100; 
parameter WAIT_IMDCT =       4'b0101; 
parameter INTERRUPT  =       4'b0110;
parameter WAIT_GLOBAL_1   =  4'b0111;
parameter WAIT_GLOBAL_2 =    4'b0011;
parameter START_QUAN    =    4'b1000;
parameter WAIT_QUAN     =    4'b1001;
parameter START_IQUAN    =   4'b1010;
parameter WAIT_IQUAN    =    4'b1011;
parameter WAIT_GLOBAL_3  =   4'b1100;
parameter WAIT_GLOBAL_4  =   4'b1101;
parameter WAIT_GLOBAL_5  =   4'b1110;

(* KEEP="TRUE" *) reg[3:0] current_state;
(* KEEP="TRUE" *) reg[3:0] next_state;  

reg start_mdct_r     ;
reg start_imdct_r    ;
reg start_quan_r     ;
reg start_iquan_r    ;



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
                next_state = WAIT_GLOBAL_3;
            else
                next_state = WAIT_MDCT;
        end   
        START_QUAN  :begin next_state = WAIT_QUAN;end
        WAIT_QUAN   :begin 
            if(finish_quan)            
                next_state = WAIT_GLOBAL_4;
            else                       
                next_state = WAIT_QUAN;
        end
        START_IQUAN :begin next_state = WAIT_IQUAN;end
        WAIT_IQUAN  :begin 
            if(finish_iquan)            
                next_state = WAIT_GLOBAL_5;
            else                       
                next_state = WAIT_IQUAN;        
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
        WAIT_GLOBAL_3:begin next_state = START_QUAN;end
        WAIT_GLOBAL_4:begin next_state = START_IQUAN;end
        WAIT_GLOBAL_5:begin next_state = START_IMDCT;end
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
        rstn_quan    =0;
        rstn_iquan   =0;
        start_quan_r =0;
        start_iquan_r=0;
    end
    else
         case(current_state)
        IDLE:begin 
                rstn_mdct=0;
                rstn_imdct=0;
                rstn_quan    =0;
                rstn_iquan   =0;
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
        WAIT_GLOBAL_1:begin rstn_mdct=1;rstn_imdct=1;rstn_quan    =1;rstn_iquan   =1;  end  
        WAIT_GLOBAL_2:begin end      
        START_QUAN   :begin start_quan_r=1;end
        WAIT_QUAN    :begin start_quan_r=0;end
        START_IQUAN  :begin start_iquan_r=1;end
        WAIT_IQUAN   :begin start_iquan_r=0;end
        default:begin end
        endcase
 end
 always @ (negedge clk_in or negedge rst_n) 
 begin     
     if(!rst_n) begin
            start_imdct <= 0;
            start_mdct<=0;
            start_quan     <=0;
            start_iquan    <=0;
            end
    else begin
            start_imdct <= start_imdct_r;
            start_mdct<=start_mdct_r; 
            start_quan  <=start_quan_r   ;
            start_iquan <=start_iquan_r  ;
            end
end   
endmodule
