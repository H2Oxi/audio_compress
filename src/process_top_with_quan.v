`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 10:36:10
// Design Name: 
// Module Name: process_top
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


module process_top_with_quan(
    input clk_in,
    input rst_n, 
    //axi
    input start_sys,
    input intr_clr_sys,
    input [18 : 0] start_music_addr,
    output  start_clr_sys,
    output  intr_sys,
    //dual bram
    output [31 : 0] bram_addra,
    output  [31 : 0] shared_wire_o_r,
    output  [3 : 0]  bram_wea_r,
    output  bram_ena_r,
    output  bram_rsta
    
    );

    (* KEEP="TRUE" *)wire   start_mdct                     ;
    (* KEEP="TRUE" *)wire   [18 : 0] start_music_addr_r    ;
    (* KEEP="TRUE" *)wire   finish_mdct                      ;  
    (* KEEP="TRUE" *)wire   start_imdct                    ;
    (* KEEP="TRUE" *)wire finish_imdct                     ;
    
    (* KEEP="TRUE" *)wire [7:0] addr_imdct_in              ;
    (* KEEP="TRUE" *)wire [15:0] reg1_16_imdct             ;
    
    (* KEEP="TRUE" *)wire      [8 : 0] addra_mdct_o_r;    
    (* KEEP="TRUE" *)wire  wea_mdct_r                ;
    (* KEEP="TRUE" *)wire  bram_ena_r_mdct                ;
    (* KEEP="TRUE" *)wire  [15 : 0] douta_mdct_o_r  ;
    (* KEEP="TRUE" *)wire signed [15:0] reg1_16_mdct      ;
    (* KEEP="TRUE" *)wire   [18 : 0] addr_mdct       ;
    (* KEEP="TRUE" *) wire rstn_mdct  ;
    (* KEEP="TRUE" *) wire rstn_imdct ;
    
    (* KEEP="TRUE" *)wire     [8 : 0] addra_r      ;       
    (* KEEP="TRUE" *)wire wea_r                    ;      
    (* KEEP="TRUE" *)wire ena_r                    ;     
    (* KEEP="TRUE" *)wire [3 : 0] douta_quan_o_r   ;                   
    (* KEEP="TRUE" *)wire [15:0] mdct_data         ; 
    (* KEEP="TRUE" *)wire [8:0] addr_mdct_quan          ;

    wire [8 : 0] addra_r_iquan            ;
    wire wea_r_iquan                      ;
    wire ena_r_iquan                      ;
    wire [15 : 0] douta_iquan_o_r   ;    
    wire [3:0] quan_data            ;
    wire [8:0] addr_iquan           ;
    
    (* KEEP="TRUE" *)wire  start_quan  ;
    (* KEEP="TRUE" *)wire finish_quan  ;
    (* KEEP="TRUE" *)wire   rstn_quan  ;
    
    (* KEEP="TRUE" *)wire  start_iquan  ;
    (* KEEP="TRUE" *)wire finish_iquan  ;
    (* KEEP="TRUE" *)wire   rstn_iquan  ;
    
  
process_ctrl_with_quan u1(
    .clk_in            (clk_in ) ,
    .rst_n             (rst_n  ) , 
                       
    .start_sys         (start_sys       ) ,
    .intr_clr_sys      (intr_clr_sys    ) ,
    .start_music_addr  (start_music_addr) ,
    .start_clr_sys     (start_clr_sys   ) ,
    .intr_sys          (intr_sys        ) ,
                       
    .start_mdct        (start_mdct        ) ,
    .start_music_addr_r(start_music_addr_r) ,
    .finish_mdct       (finish_mdct       ) ,  
    .rstn_mdct         (rstn_mdct       ) , 
                       
    .start_imdct       (start_imdct ) ,
    .finish_imdct      (finish_imdct) ,
    .rstn_imdct         (rstn_imdct)  ,
    
    . start_quan      (start_quan ) ,
    .finish_quan     (finish_quan) ,
    .  rstn_quan       (rstn_quan) ,    

    . start_iquan       (start_iquan ) ,
    .finish_iquan      (finish_iquan) ,
    .  rstn_iquan        (rstn_iquan)    
    );    
mdct_top u2(
    .clk_in                (clk_in)  ,
    .rst_n                 (rstn_mdct )  ,//sw
    .start                 (start_mdct)  ,//start is spike  
    .intr                  (finish_mdct)   ,
    //                    
    .addra_mdct_o_r        (addra_mdct_o_r  )  ,
    .wea_mdct_r            (wea_mdct_r      )  ,
    .bram_ena_r            (bram_ena_r_mdct      )  ,
    .douta_mdct_o_r        (douta_mdct_o_r  )  ,      
    //                    
    .start_music_addr_r    (start_music_addr_r)  , 
    .reg1_16               (reg1_16_mdct)  ,
    .addr_mdct             (addr_mdct)
    );
imdct_top u3(
    .clk_in            (clk_in           )     ,
    .rst_n             (rstn_imdct            )     ,//sw
    .start             (start_imdct            )     ,//start is spike
    .bram_addra        (bram_addra       )     ,
    .shared_wire_o_r   (shared_wire_o_r  )     ,
    .bram_wea_r        (bram_wea_r       )     ,
    .bram_ena_r        (bram_ena_r       )     ,
    .bram_rsta         (bram_rsta        )     ,
    .intr              (finish_imdct             )     ,
    .addr_imdct_in     (addr_imdct_in    )     ,
    .reg1_16           (reg1_16_imdct          )
    );
music_rom u4 (
  .clka(clk_in),    // input wire clka
  .ena(1'd1),      // input wire ena
  .addra(addr_mdct),  // input wire [13 : 0] addra
  .douta(reg1_16_mdct)  // output wire [15 : 0] douta
);  
quan_ctrl u5(
    .clk_in (clk_in),
    .rst_n  (rstn_quan  ),//sw
    .start  ( start_quan),//start is spike 
    .intr   (finish_quan), 
    //
     .addra_r           (addra_r        ) ,
     .wea_r             (wea_r          )  ,
     .ena_r             (ena_r          )  ,
     .douta_quan_o_r    (douta_quan_o_r ) ,      
    //
     .mdct_data     (mdct_data) ,
     .addr_mdct     (addr_mdct_quan)
    );

iquan_ctrl u6(
    .clk_in(clk_in) ,
    .rst_n (  rstn_iquan  ) ,//sw
    .start ( start_iquan) ,//start is spike 
    .intr  (finish_iquan) , 
    //
    .addra_r         (addra_r_iquan        )   ,
    .wea_r           (  wea_r_iquan          ) ,
    .ena_r           (  ena_r_iquan          ) ,
    .douta_iquan_o_r (douta_iquan_o_r)   ,      
    //
    .quan_data       (quan_data  )    ,
    .addr_iquan      (addr_iquan )
    ); 
central_ram ram_0 (
  .clka(clk_in),    // input wire clka
  .ena(bram_ena_r_mdct),      // input wire ena
  .wea(wea_mdct_r),      // input wire [0 : 0] wea
  .addra(addra_mdct_o_r),  // input wire [8 : 0] addra
  .dina(douta_mdct_o_r),    // input wire [15 : 0] dina
  .clkb(clk_in),    // input wire clkb
  .enb(1'd1),      // input wire enb
  .addrb(addr_mdct_quan),  // input wire [8 : 0] addrb
  .doutb(mdct_data)  // output wire [15 : 0] doutb
);
unzip_ram unzip_ram (
  .clka(clk_in),    // input wire clka
  .ena(ena_r),      // input wire ena
  .wea(wea_r),      // input wire [0 : 0] wea
  .addra(addra_r),  // input wire [8 : 0] addra
  .dina(douta_quan_o_r),    // input wire [3 : 0] dina
  .clkb(clk_in),    // input wire clkb
  .enb(1'd1),      // input wire enb
  .addrb(addr_iquan),  // input wire [8 : 0] addrb
  .doutb(quan_data)  // output wire [3 : 0] doutb
);
central_ram ram_1 (
  .clka(clk_in),    // input wire clka
  .ena(ena_r_iquan),      // input wire ena
  .wea(wea_r_iquan),      // input wire [0 : 0] wea
  .addra(addra_r_iquan),  // input wire [8 : 0] addra
  .dina(douta_iquan_o_r),    // input wire [15 : 0] dina
  .clkb(clk_in),    // input wire clkb
  .enb(1'd1),      // input wire enb
  .addrb({0,addr_imdct_in}),  // input wire [8 : 0] addrb
  .doutb(reg1_16_imdct)  // output wire [15 : 0] doutb
);       
endmodule
