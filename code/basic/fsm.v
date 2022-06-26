module fsm (
    input [3:0] option,//{start,react,get_rand,time_out}
    input [15:0] act_time,//主计数器结果
    input clk,
    input rst_n,//同步复位，低电平有效
    output reg[2:0] state//输出状态
);

//状态S0：初始状态
//状态S1：按下start按键后，对应----
//状态S3：随机数时间过后，等待按下反应按键，对应||||
//状态S2：fail状态
//状态S4：正常输出
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b111;

always @(posedge clk) begin
if(rst_n == 1'b0) begin
    state <= S0;//复位为S0状态
end
else begin
    case(state)
    S0:
    begin
        if(option[3]) begin
            state <= S1;
        end
        else begin
            state <= state;
        end
    end
    S1:
    begin
        if(option[1]) begin//随机数计数完成
        state <= S3;
        end
        else if(option[2]) begin//提前按下反应按键
        state <= S2;
        end
        else begin
        state <= state;//其他情况均保持S0
        end
    end
    S3:
    begin
        //正常操作且反应时间大于100
        if(((option[2] == 1'b1) && (act_time > 16'd256)) && (option[0] == 1'b0)) begin
            state <= S4;
        end
        //正常操作且反应时间小于100 或 超时
        else if(((option[2] == 1'b1) && (act_time < 16'd256)) || (option[0] == 1'b1)) begin
            state <= S2;
        end
        else begin
            state <= state;//其他情况保持
        end
    end
    default: 
    begin
        state <= state;
    end
    endcase
end
end
endmodule //fsm