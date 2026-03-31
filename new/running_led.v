`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/03/07 19:42:32
// Design Name: 
// Module Name: running_led
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


module running_led(
input clk,          // Basys3 板载 100MHz 时钟
    input rst,          // 复位按键 (高电平有效)
    output reg [15:0] led // Basys3 上的 16 个 LED 灯
);

// 1. 定义分频计数器
// 100MHz 的时钟周期是 10ns。要让 LED 肉眼可见地移动，比如每 0.1 秒移动一次。
// 0.1s / 10ns = 10,000,000，因此计数器需要计数到 10,000,000。
// 2^24 = 16,777,216，所以需要一个 24 位的计数器。
reg [23:0] timer;
wire tick; // 时钟节拍使能信号

// 产生 0.1 秒的节拍使能信号
always @(posedge clk or posedge rst) begin
    if (rst) begin
        timer <= 24'd0;
    end else if (timer == 24'd10_000_000 - 1) begin
        timer <= 24'd0;
    end else begin
        timer <= timer + 1'b1;
    end
end

// 当计数器满时，产生一个时钟周期的 tick 脉冲
assign tick = (timer == 24'd10_000_000 - 1);

// 2. LED 移位逻辑
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // 复位时，只亮最右边的一盏灯
        led <= 16'b0000_0000_0000_0001; 
    end else if (tick) begin
        // 只有在节拍信号到来时才移位
        // 将最高位放到最低位，实现循环移位 (跑马灯)
        led <= {led[14:0], led[15]}; 
    end
end
endmodule
123
4455
