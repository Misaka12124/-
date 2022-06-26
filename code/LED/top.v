module top (
    input clk,//时钟信号
    input start,//start按钮
    input act,//反应按钮
    input rst,//复位按钮
    input mode,//模式选择
    input finish_test,//结束测试
    //考虑到软件局限性，仅保留一个七段显示管
    //选取最具代表性的第4个
    //output [6:0] LED1,
    //output [6:0] LED2,
    //output [6:0] LED3,
    output [6:0] LED4,
    output reg[7:0] row,//行
    output reg[7:0] col,
    output reg[2:0] RGB
);
wire [12:0] rand_num;//产生的随机数
wire get_rand;
wire [15:0] act_time;//反应时间
wire out_time;
wire [2:0] state;
randout randout_top(.clk(clk),.rst_n(~rst),.new(start),.rand_num(rand_num));
count2rand count2rand_top(.clk(clk),.rst_n(~rst),.start(start),.rand_num(rand_num),.get_rand(get_rand));
count count_top(.clk(clk),.rst_n(~rst),.pause(act),.start(get_rand),.Q(act_time),.out_time(out_time));
fsm fsm_top(.clk(clk),.rst_n(~rst),.option({start,act,get_rand,out_time}),.mode(mode),.finish_test(finish_test),.act_time(act_time),.max_result(max_result),.state(state));
seven_led seven_led_top(.state(state),.act_time(act_time),.max_result(max_result),.clk(clk),/*.LED1(LED1),.LED2(LED2),.LED3(LED3),*/.LED4(LED4));
LED LED_top(.clk(clk),.rst_n(~rst),.state(state),.row(row),.col(col),.RGB(RGB));
endmodule //top