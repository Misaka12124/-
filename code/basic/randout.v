module randout(
    input clk,        //系统时钟信号
    input rst_n,      //同步复位信号，低电平有效
    input new,        //新随机数产生信号，上升沿有效
    
    output wire  [12:0] rand_num
    );
parameter seed = 13'b1010001001011;  //初始种子
parameter feedback = 13'd4761;  //反馈系数
wire [12:0] temp;
reg  [12:0] rand_code;//内部保持改变的随机数
reg  [12:0] rand_num_temp;//限制范围前的随机数
//信号缓存器更新模块
reg new_pre;
always @(posedge clk) begin
    if(!rst_n) begin
        new_pre <= 1'b0;//同步复位
    end
    else begin
        new_pre <= new;//存储上一周期的new信号
    end
end

//m序列模块
wire feedback_item = ^(feedback & rand_code);
always @(posedge clk ) begin
    if(!rst_n) begin
        rand_code <= seed;//同步复位为初始种子
    end
    //防止全0锁死
    else if( rand_code == 13'd0) begin
        rand_code <= seed;
    end
    else begin
        rand_code <= {feedback_item,rand_code[12:1]};
    end
end
//在得到new信号上升沿后，输出此时的内部随机数，其余时刻锁存
always @(posedge clk) begin
    if(!rst_n) begin
        rand_num_temp <= seed;
    end
    else if(~new_pre & new) begin
        rand_num_temp <= rand_code;
    end
    else begin
        rand_num_temp <= rand_num_temp;
    end
end

//限制范围
assign temp = (rand_num_temp > 13'd5000) ? (rand_num_temp - 13'd5000) : rand_num_temp;
assign rand_num = (temp < 13'd500) ? (temp + 13'd500) : temp;

endmodule