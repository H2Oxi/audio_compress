`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 15:45:10
// Design Name: 
// Module Name: Top
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


module Top(
    input CLK_in,  
    input RST_in,
    input Start 
   // input [13 : 0] start_music_addr

    );

wire clk_in   =  CLK_in                       ;                                    
//wire fast_clk                          ;                           
(* KEEP="TRUE" *) wire  [8 : 0] addra_imdct_o            ;            
// wire signed  [31:0]  shared_wire_o     ;     
(* KEEP="TRUE" *) wire [31 : 0] douta_imdct_o            ;
wire start=!Start;
//wire [13 : 0] start_music_addr      ;
(* KEEP="TRUE" *)wire start_clr_sys                  ;
(* KEEP="TRUE" *)wire intr_sys                       ;
(* KEEP="TRUE" *)wire [31 : 0] bram_addra            ;
(* KEEP="TRUE" *)wire [31 : 0] shared_wire_o_r       ;
(* KEEP="TRUE" *)wire [3 : 0]  bram_wea_r            ;
(* KEEP="TRUE" *)wire bram_ena_r  ;
(* KEEP="TRUE" *)wire bram_rsta   ;
(* KEEP="TRUE" *)wire intr_clr_sys=0;
(* KEEP="TRUE" *)wire [13 : 0] start_music_addr=0;
(* KEEP="TRUE" *)wire [31 : 0] douta          ;
(* KEEP="TRUE" *)wire rstb                   ;
(* KEEP="TRUE" *)wire enb                    ;
(* KEEP="TRUE" *)wire [3 : 0] web          ;
(* KEEP="TRUE" *)wire [31 : 0] addrb       ;
(* KEEP="TRUE" *)wire [31 : 0] dinb        ;
(* KEEP="TRUE" *)wire [31 : 0] doutb         ;
wire rsta_busy              ;
wire rstb_busy               ;
process_top u1(
    .clk_in(clk_in),
    .rst_n (RST_in ), 
    //axi
    .start_sys                 (start                ) ,
    .intr_clr_sys              (intr_clr_sys             ) ,
    .start_music_addr ( start_music_addr) ,
    .start_clr_sys             (start_clr_sys            ) ,
    .intr_sys                  (intr_sys                 ) ,
    //dual bram               
    .bram_addra       (bram_addra      ) ,
    .shared_wire_o_r  (shared_wire_o_r ) ,
    .bram_wea_r       (bram_wea_r      ) ,
    .bram_ena_r                (bram_ena_r               ) ,
    .bram_rsta                 (bram_rsta                )
    
    );
blk_mem_gen_0 u2 (
  .clka(clk_in),            // input wire clka
  .rsta(bram_rsta),            // input wire rsta
  .ena(bram_ena_r),              // input wire ena
  .wea(bram_wea_r),              // input wire [3 : 0] wea
  .addra(bram_addra),          // input wire [31 : 0] addra
  .dina(shared_wire_o_r),            // input wire [31 : 0] dina
  .douta(douta),          // output wire [31 : 0] douta
  .clkb(clk_in),            // input wire clkb
  .rstb(rstb),            // input wire rstb
  .enb(enb),              // input wire enb
  .web(web),              // input wire [3 : 0] web
  .addrb(addrb),          // input wire [31 : 0] addrb
  .dinb(dinb),            // input wire [31 : 0] dinb
  .doutb(doutb),          // output wire [31 : 0] doutb
  .rsta_busy(rsta_busy),  // output wire rsta_busy
  .rstb_busy(rstb_busy)  // output wire rstb_busy
);    
debug_ram u3(
    .rstb         (rstb ) ,
    .enb          (enb  ) ,
    .web          (web  )  ,    
    .addrb        (addrb)  ,    
    .dinb         (dinb )  ,    
    .clk_in       (clk_in)  ,
    .rst_n        (RST_in )   ,
    .debug_start  (intr_sys)  
    );    
  /*
  clk_wiz_0 u4
   (
    // Clock out ports
    .clk_out1(clk_in),     // output clk_out1
   // Clock in ports
    .clk_in1(CLK_in));      // input clk_in1    
    */
endmodule
