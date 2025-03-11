`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/26 15:11:21
// Design Name: 
// Module Name: top_quan
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




module top_quan(
    input wire [15:0] input_quan,
    output wire [15:0] output_iquan
    );
    
    parameter INPUT_WIDTH = 8;
    parameter OUTPUT_WIDTH = 4;
    parameter NUM_INTERVALS = 16;

    

     wire [3:0] output_quan; // 创建一个中间连接的信号

    // 实例化 quan 模块
    quan quan_instance(
        .input_quan(input_quan),
        .output_quan(output_quan)
    );

    // 实例化 inv_quan 模块，连接 quan 模块的输出到 inv_quan 模块的输入
    inv_quan inv_quan_instance(
        .input_iquan(output_quan),
        .output_iquan(output_iquan)
    );
endmodule

/*
module top_quan(
    input wire clk,       // 时钟信号
    input wire reset,     // 复位信号
    input wire [15:0] input_quan,
    output wire [15:0] output_iquan
    );
    
    parameter INPUT_WIDTH = 8;
    parameter OUTPUT_WIDTH = 4;
    parameter NUM_INTERVALS = 16;

    

     wire [3:0] output_quan; // 创建一个中间连接的信号

    // 实例化 quan 模块
    quan quan_instance(
        .clk(clk),
        .reset(reset),
        .input_quan(input_quan),
        .output_quan(output_quan)
    );

    // 实例化 inv_quan 模块，连接 quan 模块的输出到 inv_quan 模块的输入
    inv_quan inv_quan_instance(
        .clk(clk),
        .reset(reset),
        .input_iquan(output_quan),
        .output_iquan(output_iquan)
    );
endmodule
*/