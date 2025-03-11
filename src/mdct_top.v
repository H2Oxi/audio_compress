`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 14:59:28
// Design Name: 
// Module Name: mdct_top
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


module mdct_top(
    input clk_in,
    input rst_n,//sw
    input start,//start is spike 
    output reg intr, 
    //
    output reg [8 : 0] addra_mdct_o_r,
    output reg wea_mdct_r            ,
    output reg bram_ena_r            ,
    output reg [15 : 0] douta_mdct_o_r,      
    //
    input [18 : 0] start_music_addr_r, 
    input signed [15:0] reg1_16      ,
    output  [18 : 0] addr_mdct
    );
    
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
(* KEEP="TRUE" *)reg [8:0] count;
(* KEEP="TRUE" *)reg [9:0] count_sys;
(* KEEP="TRUE" *)reg count_sys_en;

(* KEEP="TRUE" *)(* KEEP="TRUE" *)wire signed [31:0] reg1; 
(* KEEP="TRUE" *)reg  signed [31:0] reg2;
(* KEEP="TRUE" *)reg [8:0] addr_t;
reg  addr_t_en;
(* KEEP="TRUE" *)reg [8:0] addr_mdct_in;
(* KEEP="TRUE" *)wire rst_ctrl                          ;

                                      
(* KEEP="TRUE" *)wire signed  [31:0] reset_w3_in        ;
(* KEEP="TRUE" *)wire signed  [31:0] reset_w6_in         ;
(* KEEP="TRUE" *)wire signed  [15:0] t3                  ;
(* KEEP="TRUE" *)wire signed  [15:0] t4                  ;
(* KEEP="TRUE" *)wire signed  [15:0] t5                  ;
(* KEEP="TRUE" *)wire signed  [31:0] shared_wire_o  ;

//wire signed [15:0] reg1_16;

(* KEEP="TRUE" *)reg wait_flag;
reg mdct_en;
(* KEEP="TRUE" *)wire t_en;
(* KEEP="TRUE" *)reg count_en;
(* KEEP="TRUE" *)wire signed  [31:0] rst_temp;
(* KEEP="TRUE" *)wire signed  [15:0] rst_temp_0;

(* KEEP="TRUE" *)wire  wea_mdct                       ;
(* KEEP="TRUE" *)wire [8 : 0] addra_mdct_o           ;
(* KEEP="TRUE" *)wire [31 : 0] mdct_o          ;
(* KEEP="TRUE" *)reg [8 : 0] addra_read_mdct           ;
(* KEEP="TRUE" *)reg [8 : 0] addra_read_mdct_nxt           ;

wire  bram_rsta  =1'b0              ;
//wire  bram_rstb  =1'b0              ;
reg  bram_enb                 ;
wire  bram_ena                 ;

//wire  [31:0] ram_mdct_o        ;
(* KEEP="TRUE" *)wire  [15:0]douta_mdct_o;


(* KEEP="TRUE" *)reg  addra_read_en           ;
(* KEEP="TRUE" *)wire signed [25:0] shared_wire_o_temp= shared_wire_o[31:6];//26,0
(* KEEP="TRUE" *)wire signed [37:0] mdct_o_temp;//26,0
(* KEEP="TRUE" *)wire signed [11:0] t5_temp= t5[15:4];//12,11

assign addr_mdct=addr_mdct_in+start_music_addr_r;

assign mdct_o_temp=shared_wire_o_temp*t5_temp;//38,11
assign mdct_o=mdct_o_temp[36:5];

assign douta_mdct_o=mdct_o[27:12];
assign wea_mdct=(count==509) ;

assign t_en=start||rst_ctrl||(count==509);
assign reg1=reg1_16[15]?{10'b1111111111,reg1_16,6'd0}:{10'b0000000000,reg1_16,6'd0};//16,6,10
assign rst_ctrl=(count_en)?((count==511)?1:0):0;
assign rst_temp_0=t3+(t4>>>8);
//assign reset_w3_in=reg2+((reg1[15:0])*(({16'd1,16'd0}+t1[15]?{4'b1111,4'b1111,4'b1111,4'b1111,t1}:{16'd0,t1})>>>16));
assign reset_w3_in=reg2+(rst_temp);
assign reset_w6_in=reg2;


//assign addra_imdct_o=count_sys[8:0];
assign addra_mdct_o= wea_mdct? addr_t:addra_read_mdct;   
assign rst_temp=rst_temp_0*reg1_16;//16,16,6
assign bram_ena=wea_mdct?1:(addra_read_en);

always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            addra_read_mdct <= 0;
    else
            addra_read_mdct <= (addra_read_en)?(addra_read_mdct+1):addra_read_mdct; 
 end

always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
            count <= 510;
    else
            count <= (count_en)?(count+1):count; 
 end
 always @ (posedge clk_in or negedge rst_n) 
begin
    if(!rst_n) begin addr_t<=0;  end
    else begin
            addr_t<=(addr_t_en)?(addr_t+1):addr_t;end
end 
always @ (posedge clk_in or negedge mdct_en)
 begin
    if(!mdct_en)
            addr_mdct_in <= 0;
    else
            addr_mdct_in <= addr_mdct_in+1; 
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
                        if(count_sys<256) 
                            begin
                                next_state = S0;                                     
                            end
                        else begin 
                                 next_state = S1;
                            end 
                    else    begin                    
                            if(count==510&&count_sys==0)begin
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
                         mdct_en=0;
                         count_sys_en=0;
                         wait_flag=0;
                         count_en=0;
                         intr=0;
                         addr_t_en=0;
                         addra_read_en=0; end
    else
         case(current_state)
        IDLE:begin 
					intr = 1'b0 ;   
					addr_t_en=0;    
					mdct_en=0;
                    count_sys_en=0;
                    wait_flag=0;
                    count_en=0;
                    addra_read_en=0;
        end
        S0:  begin
                    if(rst_ctrl) 
                        if(count_sys<256) 
                            begin
                                count_sys_en = 1;                                              
                            end
                            else begin 
                                 count_sys_en=0;mdct_en=0;
                            end 
                    else
                        begin                    
                            count_sys_en=0;
                            if(count==510&&count_sys==0)
                            begin
                                if(wait_flag==0)
                                    begin mdct_en=1;end                                                                       
                            end
                            else if(count==510&&count_sys!=0)
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
//com block

//assign imdct_o=(shared_wire_o<<1)*t2;
wire signed [15:0]reg2_temp=reg2[21:6];
wire signed [31:0] temp_reg2_mul=reg2_temp*t3;
assign shared_wire_in=reg1+temp_reg2_mul;//32,-->16,6,10
    
always @ (posedge clk_in or negedge rst_n) 
 begin
    if(!rst_n)
     reg2<=0;
    else
            reg2<=reg1;
end


    
/*        
music_in u1 (
  .clka(clk_in),    // input wire clka
  .ena(1'd1),      // input wire ena
  .addra(addr_mdct_in),  // input wire [10 : 0] addra
  .douta(reg1_16)  // output wire [31 : 0] douta
);*/
 
gen_t3 u2 (
  .clka(clk_in),    // input wire clka
  .ena(t_en),      // input wire ena
  .addra(addr_t),  // input wire [7 : 0] addra
  .douta(t3)  // output wire [31 : 0] douta
);

gen_t4 u3 (
  .clka(clk_in),    // input wire clka
  .ena(t_en),      // input wire ena
  .addra(addr_t),  // input wire [7 : 0] addra
  .douta(t4)  // output wire [31 : 0] douta
);    

gen_t5 u4 (
  .clka(clk_in),    // input wire clka
  .ena(t_en),      // input wire ena
  .addra(addr_t),  // input wire [7 : 0] addra
  .douta(t5)  // output wire [31 : 0] douta
);
shared_block_mdct u5(
    .clk_in         (clk_in) ,
    .rst_sys        (rst_n) ,
    .rst_ctrl       (rst_ctrl)     ,
    .shared_wire_in (shared_wire_in)     ,
    .reset_w3_in    (reset_w3_in    ) ,    
    .reset_w6_in    (reset_w6_in    ) ,  
    .t1             (t4             ) ,
    .shared_wire_o  (shared_wire_o  ) 

    );
    
always @ (negedge clk_in or negedge rst_n) 
begin
    if(!rst_n) begin
    addra_mdct_o_r <=0 ;  
    wea_mdct_r     <=0;       
    bram_ena_r     <=0;       
    douta_mdct_o_r       <=0;  
    end
    else begin
    addra_mdct_o_r <= addra_mdct_o ;     
    wea_mdct_r     <= wea_mdct     ;
    bram_ena_r     <= bram_ena     ;
    douta_mdct_o_r       <= douta_mdct_o        ;       
    end
end
   

/*
blk_mem_gen_0 u6 (
  .clka (clk_in),            // input wire clka
  .rsta (bram_rsta),            // input wire rsta
  .ena  (bram_ena_r),              // input wire ena
  .wea  (bram_wea_r),              // input wire [3 : 0] wea
  .addra({21'd0,addra_mdct_o_r,2'd0}),          // input wire [31 : 0] addra
  .dina (mdct_o_r),            // input wire [31 : 0] dina
  .douta(ram_mdct_o),          // output wire [31 : 0] douta
  .clkb (clk_in),            // input wire clkb
  .rstb (bram_rstb),            // input wire rstb
  .enb  (1'b0 ),              // input wire enb
  .web  (4'd0 ),              // input wire [3 : 0] web
  .addrb(32'd0),          // input wire [31 : 0] addrb
  .dinb (32'd0),            // input wire [31 : 0] dinb
  .doutb(bram_doutb),          // output wire [31 : 0] doutb
  .rsta_busy(rsta_busy),  // output wire rsta_busy
  .rstb_busy(rstb_busy)  // output wire rstb_busy
);*/



    
endmodule
