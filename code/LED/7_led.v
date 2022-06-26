module seven_led (
    input [2:0] state,//状态输入
    input [15:0] act_time,//反应时间
    input [15:0] max_result,
    input clk,
    output reg[6:0] LED1,
    output reg[6:0] LED2,
    output reg[6:0] LED3,
    output reg[6:0] LED4
);
//接收反应时间的译码结果
wire[6:0] LE1;
wire[6:0] LE2;
wire[6:0] LE3;
wire[6:0] LE4;

wire[6:0] LE5;
wire[6:0] LE6;
wire[6:0] LE7;
wire[6:0] LE8;
Binary_To_7Segment L1(.Binary(act_time[15:12]),.r_Hex_Encoding(LE1));
Binary_To_7Segment L2(.Binary(act_time[11:8]),.r_Hex_Encoding(LE2));
Binary_To_7Segment L3(.Binary(act_time[7:4]),.r_Hex_Encoding(LE3));
Binary_To_7Segment L4(.Binary(act_time[3:0]),.r_Hex_Encoding(LE4));

Binary_To_7Segment L5(.Binary(max_result[15:12]),.r_Hex_Encoding(LE5));
Binary_To_7Segment L6(.Binary(max_result[11:8]),.r_Hex_Encoding(LE6));
Binary_To_7Segment L7(.Binary(max_result[7:4]),.r_Hex_Encoding(LE7));
Binary_To_7Segment L8(.Binary(max_result[3:0]),.r_Hex_Encoding(LE8));
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b111, S5 = 3'b110;
//对于每个状态给予对应输出
always @(posedge clk) begin
   case (state)
   //对应输出 FDU，即初始状态
    S0:
    begin
        LED1 <= 7'b0000000;
        LED2 <= 7'b1110001;
        LED3 <= 7'b0111111;
        LED4 <= 7'b0111110;
    end
    //对应输出----
    S1:
    begin
        LED1 <= 7'b1000000;
        LED2 <= 7'b1000000;
        LED3 <= 7'b1000000;
        LED4 <= 7'b1000000;
    end
    //对应输出||||
    S3:
    begin
        LED1 <= 7'b0000110;
        LED2 <= 7'b0000110;
        LED3 <= 7'b0000110;
        LED4 <= 7'b0000110;
    end
    //对应输出FAIL
    S2:
    begin
        LED1 <= 7'b1110001;//F
        LED2 <= 7'b1110111;//A
        LED3 <= 7'b0000110;//I
        LED4 <= 7'b0111000;//L
    end
    //输出反应时间
    S4:
    begin
        LED1 <= LE1;
        LED2 <= LE2;
        LED3 <= LE3;
        LED4 <= LE4;
    end
    S5:
    begin
        LED1 <= LE5;
        LED2 <= LE6;
        LED3 <= LE7;
        LED4 <= LE8;
    end
    default://缺省输出0000
    begin
        LED1 <= 7'b0111111;
        LED2 <= 7'b0111111;
        LED3 <= 7'b0111111;
        LED4 <= 7'b0111111;
    end
endcase 
end
endmodule //7_led