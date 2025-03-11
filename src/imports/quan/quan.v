`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/19 15:50:58
// Design Name: 
// Module Name: Lloyd_quan
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




module quan (
    input wire [15:0] input_quan,
    output wire [3:0] output_quan
);

    parameter INPUT_WIDTH = 16; // 输入位数参数
    parameter OUTPUT_WIDTH = 4; // 输出位数参数
    parameter NUM_INTERVALS = 16; // 间隔数量参数

    reg [OUTPUT_WIDTH-1:0] state;
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
    
    always @(input_quan) begin
            // 比较输入信号和阈值
            for (i = 0; i < NUM_INTERVALS-1; i = i + 1) begin
                if (input_quan >= boundaries[i] && input_quan < boundaries[i+1]) begin
                    state <= i;
                end
            end     
            if (input_quan >= boundaries[15] && input_quan < boundaries[16]) begin
                state <= 15;
            end 
        end
    assign output_quan = state;
endmodule

/*
module quan (
    input wire clk,       // 时钟信号
    input wire reset,     // 复位信号
    input wire [15:0] input_quan,
    output wire [3:0] output_quan
);

    parameter INPUT_WIDTH = 16; // 输入位数参数
    parameter OUTPUT_WIDTH = 4; // 输出位数参数
    parameter NUM_INTERVALS = 16; // 间隔数量参数

    reg [INPUT_WIDTH-1:0] input_reg;
    reg [OUTPUT_WIDTH-1:0] state;
    reg [3:0] i; // 声明循循环变量
    // 创建一个数组，定义 boundries 参数
    reg [15:0] boundaries [0:16];
    reg [3:0] output_reg;

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
            state <= {OUTPUT_WIDTH{1'b0}};
        end 
        
        else 
        begin
            input_reg <= input_quan;
            // 比较输入信号和阈值
            for (i = 0; i < NUM_INTERVALS-1; i = i + 1) begin
                if (input_reg >= boundaries[i] && input_reg < boundaries[i+1]) begin
                    state <= i;
                end
            end     
            if (input_reg >= boundaries[15] && input_reg < boundaries[16]) begin
                state <= 15;
            end 
        end
    end
    assign output_quan = state;
endmodule
*/

/*
boundaries[0] = 16'b1000110111111001;
        boundaries[1] = 16'b1011101011111001;
        boundaries[2] = 16'b1101000110101000;
        boundaries[3] = 16'b1110000001101001;
        boundaries[4] = 16'b1110101111010111;
        boundaries[5] = 16'b1111010011110010;
        boundaries[6] = 16'b1111101100000100;
        boundaries[7] = 16'b1111111001111111;
        boundaries[8] = 16'b1111111111110111;
        boundaries[9] = 16'b0000000101111001;
        boundaries[10] = 16'b0000010100011100;
        boundaries[11] = 16'b0000101101111011;
        boundaries[12] = 16'b0001010100010001;
        boundaries[13] = 16'b0010000110010101;
        boundaries[14] = 16'b0011001011001110;
        boundaries[15] = 16'b0100011111001010;
        boundaries[16] = 16'b0111001000000111;
*/

/*
module quan (
    input wire clk,       // 时钟信号
    input wire reset,     // 复位信号
    input wire [15:0] input_quan,
    output wire [3:0] output_quan
);

    parameter INPUT_WIDTH = 16; // 输入位数参数
    parameter OUTPUT_WIDTH = 4; // 输出位数参数
    parameter NUM_INTERVALS = 15; // 间隔数量参数

    reg [INPUT_WIDTH-1:0] input_reg;
    reg [OUTPUT_WIDTH-1:0] output_reg;
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
                state[i] <= {OUTPUT_WIDTH{1'b0}};
            end
        end 
        
        else 
        begin
            input_reg <= input_quan;
            
            // 比较输入信号和阈值
            for (i = 0; i < NUM_INTERVALS; i = i + 1) begin
                state[i] <= {OUTPUT_WIDTH{1'b0}};
            end
            for (i = 0; i < NUM_INTERVALS; i = i + 1) begin
                if (input_reg >= boundaries[i] && input_reg < boundaries[i+1]) begin
                    state[i] <= i;
                end
            end
        end
    end

    assign output_quan = state[0]|state[1]|state[2]|state[3]|state[4]|state[5]|state[6]|state[7]|state[8]|state[9]|state[10]|state[11]|state[12]|state[13]|state[14]|state[15];

endmodule
*/

/*
            // 生成4位输出使用for循环
            output_reg = 4'b0;
            for (i = 0; i < NUM_INTERVALS; i = i + 1) begin
                if (state == i) begin
                    output_reg = i;
                end
            end
            */
            /*
            // 生成4位输出
            case (state)
                0: output_reg <= 4'b0000;
                1: output_reg <= 4'b0001;
                2: output_reg <= 4'b0010;
                3: output_reg <= 4'b0011;
                4: output_reg <= 4'b0100;
                5: output_reg <= 4'b0101;
                6: output_reg <= 4'b0110;
                7: output_reg <= 4'b0111;
                8: output_reg <= 4'b1000;
                9: output_reg <= 4'b1001;
                10: output_reg <= 4'b1010;
                11: output_reg <= 4'b1011;
                12: output_reg <= 4'b1100;
                13: output_reg <= 4'b1101;
                14: output_reg <= 4'b1110;
                15: output_reg <= 4'b1111;
                default: output_reg <= 4'b0000; // 可以根据需要更改默认情况
            endcase
            */