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

    

     wire [3:0] output_quan; // ����һ���м����ӵ��ź�

    // ʵ���� quan ģ��
    quan quan_instance(
        .input_quan(input_quan),
        .output_quan(output_quan)
    );

    // ʵ���� inv_quan ģ�飬���� quan ģ�������� inv_quan ģ�������
    inv_quan inv_quan_instance(
        .input_iquan(output_quan),
        .output_iquan(output_iquan)
    );
endmodule

/*
module top_quan(
    input wire clk,       // ʱ���ź�
    input wire reset,     // ��λ�ź�
    input wire [15:0] input_quan,
    output wire [15:0] output_iquan
    );
    
    parameter INPUT_WIDTH = 8;
    parameter OUTPUT_WIDTH = 4;
    parameter NUM_INTERVALS = 16;

    

     wire [3:0] output_quan; // ����һ���м����ӵ��ź�

    // ʵ���� quan ģ��
    quan quan_instance(
        .clk(clk),
        .reset(reset),
        .input_quan(input_quan),
        .output_quan(output_quan)
    );

    // ʵ���� inv_quan ģ�飬���� quan ģ�������� inv_quan ģ�������
    inv_quan inv_quan_instance(
        .clk(clk),
        .reset(reset),
        .input_iquan(output_quan),
        .output_iquan(output_iquan)
    );
endmodule
*/