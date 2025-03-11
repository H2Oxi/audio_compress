`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/26 15:06:44
// Design Name: 
// Module Name: inv_quan
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




module inv_quan (
    input wire [3:0] input_iquan,
    output wire [15:0] output_iquan
    );
    
    parameter INPUT_WIDTH = 4; // 输入位数参数
    parameter OUTPUT_WIDTH = 16; // 输出位数参数
    parameter NUM_INTERVALS = 16; // 间隔数量参数
    
    reg [INPUT_WIDTH-1:0] input_reg;
    reg [OUTPUT_WIDTH-1:0] output_reg;
    reg [3:0] i; // 声明循循环变量
    // 创建一个数组，定义 boundries 参数
    reg [15:0] boundaries [0:16];

    initial begin
        // 给多维寄存器数组赋值
        boundaries[0] = 16'h0000;
        boundaries[1] = 16'h3af9;
        boundaries[2] = 16'h51a8;
        boundaries[3] = 16'h6069;
        boundaries[4] = 16'h6bd7;
        boundaries[5] = 16'h74f2;
        boundaries[6] = 16'h7b04;
        boundaries[7] = 16'h7e7f;
        boundaries[8] = 16'h7ff7;
        boundaries[9] = 16'h8179;
        boundaries[10] = 16'h851c;
        boundaries[11] = 16'h8b7b;
        boundaries[12] = 16'h9511;
        boundaries[13] = 16'ha195;
        boundaries[14] = 16'hb2ce;
        boundaries[15] = 16'hc7ca;
        boundaries[16] = 16'hFFFF;
    end
    
    always @(input_iquan) begin
            input_reg <= input_iquan;
            // 输出信号赋值
            case (input_iquan)
                0: output_reg <= boundaries [0];
                1: output_reg <= boundaries [1];
                2: output_reg <= boundaries [2];
                3: output_reg <= boundaries [3];
                4: output_reg <= boundaries [4];
                5: output_reg <= boundaries [5];
                6: output_reg <= boundaries [6];
                7: output_reg <= boundaries [7];
                8: output_reg <= boundaries [8];
                9: output_reg <= boundaries [9];
                10: output_reg <= boundaries [10];
                11: output_reg <= boundaries [11];
                12: output_reg <= boundaries [12];
                13: output_reg <= boundaries [13];
                14: output_reg <= boundaries [14];
                15: output_reg <= boundaries [15];
                default: output_reg <= 16'h0000; // 默认情况
            endcase
        end       
    assign output_iquan = output_reg;
endmodule

/*
module inv_quan (
    input wire clk,       // 时钟信号
    input wire reset,     // 复位信号
    input wire [3:0] input_iquan,
    output wire [15:0] output_iquan
    );
    
    parameter INPUT_WIDTH = 4; // 输入位数参数
    parameter OUTPUT_WIDTH = 16; // 输出位数参数
    parameter NUM_INTERVALS = 16; // 间隔数量参数
    
    reg [INPUT_WIDTH-1:0] input_reg;
    reg [OUTPUT_WIDTH-1:0] output_reg;
    reg [3:0] i; // 声明循循环变量
    // 创建一个数组，定义 boundries 参数
    reg [15:0] boundaries [0:16];

    initial begin
        // 给多维寄存器数组赋值
        boundaries[0] = 16'h0000;
        boundaries[1] = 16'h3af9;
        boundaries[2] = 16'h51a8;
        boundaries[3] = 16'h6069;
        boundaries[4] = 16'h6bd7;
        boundaries[5] = 16'h74f2;
        boundaries[6] = 16'h7b04;
        boundaries[7] = 16'h7e7f;
        boundaries[8] = 16'h7ff7;
        boundaries[9] = 16'h8179;
        boundaries[10] = 16'h851c;
        boundaries[11] = 16'h8b7b;
        boundaries[12] = 16'h9511;
        boundaries[13] = 16'ha195;
        boundaries[14] = 16'hb2ce;
        boundaries[15] = 16'hc7ca;
        boundaries[16] = 16'hFFFF;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) 
        begin
            input_reg <= {INPUT_WIDTH{1'b0}};
            output_reg <= {OUTPUT_WIDTH{1'b0}};
        end 
        
        else 
        begin
            input_reg <= input_iquan;
            // 输出信号赋值
            for (i = 0; i < NUM_INTERVALS-1; i = i + 1) begin
                if (input_reg == i) begin
                    output_reg <= boundaries[i];
                end
            end
            if (input_reg == 15) begin
                output_reg <= boundaries[15];
            end
        end       
    end
    assign output_iquan = output_reg;
endmodule
*/

/*
boundaries[0] = 16'h8000;
        boundaries[1] = 16'hBAF9;
        boundaries[2] = 16'hDEA8;
        boundaries[3] = 16'hE069;
        boundaries[4] = 16'hEBD7;
        boundaries[5] = 16'hF4F2;
        boundaries[6] = 16'hFB04;
        boundaries[7] = 16'hF17F;
        boundaries[8] = 16'hFFF7;
        boundaries[9] = 16'h0179;
        boundaries[10] = 16'h051C;
        boundaries[11] = 16'h0B7B;
        boundaries[12] = 16'h1511;
        boundaries[13] = 16'h2195;
        boundaries[14] = 16'h32CE;
        boundaries[15] = 16'h47CA;
        boundaries[16] = 16'h7FFF;
*/

/*
module inv_quan (
    input wire clk,       // 时钟信号
    input wire reset,     // 复位信号
    input wire [3:0] input_iquan,
    output wire [15:0] output_iquan
    );
    
    parameter INPUT_WIDTH = 4; // 输入位数参数
    parameter OUTPUT_WIDTH = 16; // 输出位数参数
    parameter NUM_INTERVALS = 16; // 间隔数量参数
    
    reg [INPUT_WIDTH-1:0] input_reg;
    reg [OUTPUT_WIDTH-1:0] state[0:15];
    reg [OUTPUT_WIDTH-1:0] i; // 声明循循环变量
    // 创建一个数组，定义 boundries 参数
    reg [15:0] boundaries [0:16];

    initial begin
        // 给多维寄存器数组赋值
        boundaries[0] = 16'h0000;
        boundaries[1] = 16'h0004;
        boundaries[2] = 16'h0008;
        boundaries[3] = 16'h000C;
        boundaries[4] = 16'h0010;
        boundaries[5] = 16'h0014;
        boundaries[6] = 16'h0018;
        boundaries[7] = 16'h001C;
        boundaries[8] = 16'h0020;
        boundaries[9] = 16'h0024;
        boundaries[10] = 16'h0028;
        boundaries[11] = 16'h002C;
        boundaries[12] = 16'h0030;
        boundaries[13] = 16'h0034;
        boundaries[14] = 16'h0038;
        boundaries[15] = 16'h003C;
        boundaries[16] = 16'h0040;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) 
        begin
            input_reg <= {INPUT_WIDTH{1'b0}};
            for (i = 0; i < NUM_INTERVALS; i = i + 1) begin
                state [i] <= {OUTPUT_WIDTH{1'b0}};
            end
        end 
        
        else 
        begin
            input_reg <= input_iquan;
            // 输出信号赋值
            for (i = 0; i < NUM_INTERVALS; i = i + 1) begin
                state[i] <= {OUTPUT_WIDTH{1'b0}};
            end
            for (i = 0; i < NUM_INTERVALS; i = i + 1) begin
                if (input_reg == i) begin
                    state[i] <= boundaries[i];
                end
            end
        end       
    end
    assign output_iquan = state[0]|state[1]|state[2]|state[3]|state[4]|state[5]|state[6]|state[7]|state[8]|state[9]|state[10]|state[11]|state[12]|state[13]|state[14]|state[15];

endmodule
*/
