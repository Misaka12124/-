module count (
    input clk,
    input start,//对应getrand
    input pause,//对应反应按键
    input rst_n,//对应外部复位
    output reg[15:0] Q,
    output reg out_time//超时后输出高电平
    //考虑到产生随机数最高为5000，不存在提前输出超时信号的情况
);
//考虑把always放在一起
//拆分为对应的4个十进制数（以二进制表示：4bit
//Q={Q1,Q2,Q3,Q4}
reg[3:0] Q1;
reg[3:0] Q2;
reg[3:0] Q3;
reg[3:0] Q4;
reg flag;
//计数系统，十进制
always @(posedge clk) begin
    if((start == 1'b1) || (rst_n == 1'b0))
    begin//初始化，在收到次级计数器的可计数信号后开始计数
        Q1 <= 4'd0;
        Q2 <= 4'd0;
        Q3 <= 4'd0;
        Q4 <= 4'd0;
        out_time <= 1'b0;
    end
    else if(Q4 == 4'd9) begin
        Q4 <= 4'd0;
        if(Q3 == 4'd9)begin
            Q3 <= 4'd0;
            if(Q2 == 4'd9)begin
                Q2 <= 4'd0;
                if(Q1 == 4'd9)begin
                    Q1 <= 4'd9;
                    Q2 <= 4'd9;
                    Q3 <= 4'd9;
                    Q4 <= 4'd9;
                    out_time <= 1'b1;
                end
                else
                    Q1 <= Q1+4'd1;
            end
            else
                Q2 <= Q2+4'd1;
        end
        else
            Q3 <= Q3+4'd1;
    end
    else
        Q4 <= Q4+4'd1;
end
always @(posedge clk) begin
    if(~rst_n || start) begin
        flag <= 1'b0;
    end
    else if(pause) begin
        flag <= 1'b1;
    end
    else begin
        flag <= flag;
    end
end

//按下反应按键前计数，按下后锁存
always @(posedge clk) begin
if(flag) begin
    Q <= Q;
end
else
    begin
    Q[3:0] <= Q4;
    Q[7:4] <= Q3;
    Q[11:8] <= Q2;
    Q[15:12] <= Q1;
end

end
endmodule //count