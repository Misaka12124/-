module count2rand (
    input clk,
    input start,//外部输入start
    input rst_n,//同步复位信号,低电平有效
    input wire[12:0] rand_num,//随机数发生模块产生的随机数
    output reg get_rand//到达随机数后会给出一个时钟周期的高电平脉冲
);

reg [12:0] Q;//内部计数
always @(posedge clk) begin
        //同步复位
        if(!rst_n) begin
            get_rand <= 1'b0;
            Q <= 13'd5001;//保证复位与start之间锁死
        end
        //外部游戏开始，在随机数产生的同时开始重新计时
        else if(start) begin
            Q <= 13'b0;
            get_rand <= 1'b0;
        end
        //到达随机数值，产生高电平脉冲
        else if(Q == rand_num) begin
            get_rand <= 1'b1;
            Q <= Q + 13'd1;
        end
        //防止二次产生到达信号，在十进制值为5001时锁死
        else if(Q == 13'd5001) begin
            Q <= Q;
        end
        //正常情况下计数
        else begin
            Q <= Q + 13'd1;
            get_rand <= 1'b0;
        end
end
endmodule