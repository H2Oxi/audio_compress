`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 14:59:28
// Design Name: 
// Module Name: imdct_top
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


module imdct_top(
    input clk_in,
    input rst_n,//sw
    input start,//start is spike
    //input intr_clr,
    //output reg start_clr,
    output [31 : 0] bram_addra,
   // output signed  [31:0]  shared_wire_o,
    output reg [31 : 0] shared_wire_o_r,
    output reg [3 : 0]  bram_wea_r,
    output reg bram_ena_r,
    output  bram_rsta,
    output reg intr,
    
    output reg [7:0] addr_imdct_in  ,
    input [15:0] reg1_16
    );
    
      /*   
      bram_ena    
      bram_wea   
      bram_rsta    
      bram_addra   
      bram_wea_r

bram_ena_r
bram_rsta
      intr_clr     
      start_clr    
      intr            
    */
//参数声明
parameter IDLE = 3'b000;//init all 
parameter S0 =   3'b001;  //start_imdct
parameter S1 =   3'b010;  //finish_imdct
parameter S2 =   3'b100; 
parameter S3 =   3'b101; 
parameter WAIT = 3'b011;
//内部信号声明
(* KEEP="TRUE" *) reg[2:0] current_state;
(* KEEP="TRUE" *) reg[2:0] next_state;
(* KEEP="TRUE" *)wire signed [31:0] shared_wire_in;
(* KEEP="TRUE" *)reg [7:0] count;
(* KEEP="TRUE" *)reg [9:0] count_sys;
(* KEEP="TRUE" *)reg count_sys_en;
(* KEEP="TRUE" *)wire [31:0] reg1; 
(* KEEP="TRUE" *)reg  [31:0] reg2;
(* KEEP="TRUE" *)reg [8:0] addr_t;
(* KEEP="TRUE" *)reg  addr_t_en;

(* KEEP="TRUE" *)wire rst_ctrl                          ;
(* KEEP="TRUE" *)wire signed  [31:0]  shared_wire_o;                                 
(* KEEP="TRUE" *)wire signed  [31:0] reset_w3_in        ;
(* KEEP="TRUE" *)wire signed  [31:0] reset_w6_in         ;
(* KEEP="TRUE" *)wire signed  [15:0] t1                  ;
(* KEEP="TRUE" *)wire signed  [15:0] t2                  ;
// signed  [31:0] shared_wire_o  ;


(* KEEP="TRUE" *)reg wait_flag;
(* KEEP="TRUE" *)reg imdct_en;
(* KEEP="TRUE" *)wire t_en;
(* KEEP="TRUE" *)reg count_en;
(* KEEP="TRUE" *)wire signed  [31:0] rst_temp;
(* KEEP="TRUE" *)wire signed  [17:0] rst_temp_0;

(* KEEP="TRUE" *)wire  wea_imdct                       ;
(* KEEP="TRUE" *)wire [8 : 0] addra_imdct_o           ;
(* KEEP="TRUE" *)wire [31 : 0] douta_imdct_o          ;
(* KEEP="TRUE" *)reg [8 : 0] addra_read_imdct           ;
(* KEEP="TRUE" *)reg  addra_read_en           ;

assign  bram_rsta  =1'b0              ;
(* KEEP="TRUE" *)wire  bram_rstb  =1'b0              ;
(* KEEP="TRUE" *)reg  bram_enb                 ;
(* KEEP="TRUE" *)wire  bram_ena                 ;
(* KEEP="TRUE" *)reg  [3:0]  bram_web          ;
(* KEEP="TRUE" *)reg  [31:0] bram_addrb        ;
(* KEEP="TRUE" *)reg  [31:0] bram_dinb         ;
(* KEEP="TRUE" *)wire  [31:0] bram_doutb        ;
(* KEEP="TRUE" *)wire [3:0]bram_wea            ;
(* KEEP="TRUE" *)wire rsta_busy                ;
(* KEEP="TRUE" *)wire rstb_busy                ;

(* KEEP="TRUE" *)reg [8:0]    addra_imdct_o_r;
//reg [3 : 0]  bram_wea_r;
//reg          bram_ena_r;
//reg [31 : 0] shared_wire_o_r;

assign bram_addra={21'd0,addra_imdct_o_r,2'd0};

assign wea_imdct=(count==253) ;
assign bram_wea={4{wea_imdct}};

assign t_en=start||rst_ctrl||(count==253);
assign reg1=reg1_16<<<16;
assign rst_ctrl=(count_en)?((count==255)?1:0):0;
assign rst_temp_0=({4'b0001,14'd0}+(t1[15]?{2'b11,t1}:{2'b00,t1}));
//assign reset_w3_in=reg2+((reg1[15:0])*(({16'd1,16'd0}+t1[15]?{4'b1111,4'b1111,4'b1111,4'b1111,t1}:{16'd0,t1})>>>16));
assign reset_w3_in=reg2+(rst_temp<<<4);
assign reset_w6_in=reg2;


//assign addra_imdct_o=count_sys[8:0];
assign addra_imdct_o= wea_imdct? addr_t:addra_read_imdct;   
assign bram_ena=wea_imdct?1:(addra_read_en);

wire signed [15:0] reg1_temp=reg1[31:16];
wire signed [15:0] rst_temp_0_temp=rst_temp_0[17:2];
assign rst_temp=reg1_temp*rst_temp_0_temp;

always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            addra_read_imdct <= 0;
    else
            addra_read_imdct <= (addra_read_en)?(addra_read_imdct+1):addra_read_imdct; 
 end

always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            count <= 254;
    else
            count <= (count_en)?(count+1):count; 
 end
 
 always @ (posedge clk_in or negedge rst_n) 
begin
    if(!rst_n) begin addr_t<=0;  end
    else begin
            addr_t<=(addr_t_en)?(addr_t+1):addr_t;end
end

always @ (posedge clk_in or negedge imdct_en)
 begin
    if(!imdct_en)
            addr_imdct_in <= 0;
    else
            addr_imdct_in <= addr_imdct_in+1; 
 end



always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            current_state <= IDLE;
    else
            current_state <= next_state;
end

always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            count_sys <= 0;
    else
            count_sys <= (count_sys_en)?(count_sys+1):count_sys;
end



//次态的组合逻辑
//always @ (current_state or start or rst_ctrl or count_sys or count) begin
always @ (*) begin
    case(current_state)
        IDLE: begin
                  if(start) 
                    next_state = S0;
                  else  begin  
                    next_state = IDLE;                         
                  end
              end
        S0:  begin
                    if(rst_ctrl) 
                        if(count_sys<512) 
                            begin
                                next_state = S0;                                     
                            end
                        else begin 
                                 next_state = S1;
                            end 
                    else    begin                    
                            if(count==254&&count_sys==0)begin
                                if(wait_flag==0)begin 
                                    next_state=WAIT;
                                end
                                else next_state=S0;                                                                       
                            end
                            else               
                                    next_state = S0;  

                            
                    end
             end
        S1:  begin next_state=IDLE; end   
        WAIT : begin next_state = S0;end
        default:begin 
        next_state=IDLE;
        end
        
   endcase
end
//com block
always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)begin
                         imdct_en=0;
                         count_sys_en=0;
                         wait_flag=0;
                         count_en=0;
                          
                         intr=0;
                         addr_t_en=0;
                         addra_read_en=0;
                         end
    else
         case(current_state)
        IDLE:begin  
					intr = 1'b0 ;       
        end
        S0:  begin
                    if(rst_ctrl) 
                        if(count_sys<512) 
                            begin
                                count_sys_en = 1;                                           
                            end
                            else begin 
                                 count_sys_en=0;imdct_en=0;
                            end 
                    else
                        begin
                            count_sys_en=0;                    
                            if(count==254&&count_sys==0)
                            begin
                                if(wait_flag==0)
                                begin 
                                imdct_en=1;
                                end
                                                                       
                            end
                            else if(count==252&&count_sys!=0)
                                begin
                                    addr_t_en=1; 
                                end
                                 else 
                                    addr_t_en=0; 
                        end
             end
        S1:  begin
                    count_en=0;
                    intr <= 1'b1 ;
                    addra_read_en=1;
                    
                     
                    
                    
             end
    /*    S2:  begin
                    
             end             */
             
        WAIT : begin wait_flag=1;count_en=1;end
        default:begin 
        
        end
                 
         
         endcase   
end
//assign imdct_o=(shared_wire_o<<1)*t2;

assign shared_wire_in=reg1+reg2;
    
always @ (posedge clk_in or negedge rst_n) 
begin
    if(!rst_n) reg2<=0;
    else
            reg2<=reg1;
end


    
 /*       
audio_in u1 (
  .clka(clk_in),    // input wire clka
  .ena(1'd1),      // input wire ena
  .addra(addr_imdct_in),  // input wire [10 : 0] addra
  .douta(reg1_16)  // output wire [31 : 0] douta
);*/
 
gen_t2 u2 (
  .clka(clk_in),    // input wire clka
  .ena(t_en),      // input wire ena
  .addra(addr_t),  // input wire [7 : 0] addra
  .douta(t2)  // output wire [31 : 0] douta
);

gen_t1 u3 (
  .clka(clk_in),    // input wire clka
  .ena(t_en),      // input wire ena
  .addra(addr_t),  // input wire [7 : 0] addra
  .douta(t1)  // output wire [31 : 0] douta
);    

shared_block u4(
    .clk_in         (clk_in) ,
    .rst_sys        (rst_n) ,
    .rst_ctrl       (rst_ctrl)     ,
    .shared_wire_in (shared_wire_in)     ,
    .reset_w3_in    (reset_w3_in    ) ,    
    .reset_w6_in    (reset_w6_in    ) ,  
    .t1             (t1             ) ,
    .t2             (t2             ) , 
    .shared_wire_o  (shared_wire_o  ) 
   // .fast_clk       (fast_clk       )
    );
    
always @ (negedge clk_in or negedge rst_n) 
begin
    if(!rst_n) begin
    addra_imdct_o_r<=0;  
    bram_wea_r     <=0;       
    bram_ena_r     <=0;       
    shared_wire_o_r<=0;  
    end
    else begin
    addra_imdct_o_r<= addra_imdct_o;     
    bram_wea_r     <= bram_wea   ;
    bram_ena_r     <= bram_ena   ;
    shared_wire_o_r<= shared_wire_o;       
    end
end


/*
blk_mem_gen_0 u5 (
  .clka (clk_in),            // input wire clka
  .rsta (bram_rsta),            // input wire rsta
  .ena  (bram_ena_r),              // input wire ena
  .wea  (bram_wea_r),              // input wire [3 : 0] wea
  .addra({21'd0,addra_imdct_o_r,2'd0}),          // input wire [31 : 0] addra
  .dina (shared_wire_o_r),            // input wire [31 : 0] dina
  .douta(douta_imdct_o),          // output wire [31 : 0] douta
  .clkb (clk_in),            // input wire clkb
  .rstb (bram_rstb),            // input wire rstb
  .enb  (1'b0),              // input wire enb
  .web  (4'd0),              // input wire [3 : 0] web
  .addrb(32'd0),          // input wire [31 : 0] addrb
  .dinb (32'd0),            // input wire [31 : 0] dinb
  .doutb(bram_doutb),          // output wire [31 : 0] doutb
  .rsta_busy(rsta_busy),  // output wire rsta_busy
  .rstb_busy(rstb_busy)  // output wire rstb_busy
);*/


endmodule
