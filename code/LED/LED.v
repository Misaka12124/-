module LED (
    input [2:0] state,//状态
    input clk,//时钟信号
    input rst_n,//同步复位信号
    output reg[2:0]RGB,//红黄绿
    output reg[7:0] row,//行
    output reg[7:0] col 
);
reg [2:0]scan;//扫描信号，自上而下
reg [4:0]count;//等效于时钟分频
reg [9:0]count2;//等效于时钟分频
reg [1:0]count_inter;//控制图案变化
//等待随机数计数时LED信号
reg [7:0]wait1;
reg [7:0]wait2;
reg [7:0]wait3;
reg [7:0]wait4;
reg [7:0]wait5;
reg [7:0]wait6;
reg [7:0]wait7;
reg [7:0]wait8;
reg [2:0]RGB_temp;
//待机时LED信号（内部）
reg [11:0]dan1;
reg [11:0]dan2;
reg [11:0]dan3;
reg [11:0]dan4;
reg [11:0]dan5;
reg [11:0]dan6;
reg [11:0]dan7;
reg [11:0]dan8;

//状态S0：初始状态 
//状态S1：按下start按键后，对应----
//状态S3：随机数时间过后，等待按下反应按键，对应||||
//状态S2：fail状态
//状态S4：正常输出

parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b111;
//扫描信号0-7循环变化
always @(posedge clk) begin
	if(!rst_n) begin
		scan <= 3'b000;
    end
	else if(scan == 3'b111) begin
		scan <= 3'b000;
    end
	else begin
		scan <= scan+3'd1;
    end
end
//列信号每3*8个周期整体变换一次
always @(posedge clk) begin
    if(!rst_n) begin
        count <= 5'd0;
        count_inter <= 2'd0;
        RGB_temp <= 3'b100;
    end
    else begin
        if(count == 5'b11111) begin
            count <= 5'b00000;
            RGB_temp <= {RGB_temp[1:0],RGB_temp[2]};
            case(count_inter)//逐个改变图案
            2'b00:
            begin
                wait1 <= 8'b11111111;
                wait2 <= 8'b10000001;
                wait3 <= 8'b10000001;
                wait4 <= 8'b10000001;
                wait5 <= 8'b10000001;
                wait6 <= 8'b10000001;
                wait7 <= 8'b10000001;
                wait8 <= 8'b11111111;
                count_inter <= count_inter + 2'd1;
            end
            2'b01:
            begin
                wait1 <= 8'b00000000;
                wait2 <= 8'b01111110;
                wait3 <= 8'b01000010;
                wait4 <= 8'b01000010;
                wait5 <= 8'b01000010;
                wait6 <= 8'b01000010;
                wait7 <= 8'b01111110;
                wait8 <= 8'b00000000;
                count_inter <= count_inter + 2'd1;
            end
            2'b10:
            begin
                wait1 <= 8'b00000000;
                wait2 <= 8'b00000000;
                wait3 <= 8'b00111100;
                wait4 <= 8'b00100100;
                wait5 <= 8'b00100100;
                wait6 <= 8'b00111100;
                wait7 <= 8'b00000000;
                wait8 <= 8'b00000000;
                count_inter <= count_inter + 2'd1;
            end
            2'b11:
            begin
                wait1 <= 8'b00000000;
                wait2 <= 8'b00000000;
                wait3 <= 8'b00000000;
                wait4 <= 8'b00011000;
                wait5 <= 8'b00011000;
                wait6 <= 8'b00000000;
                wait7 <= 8'b00000000;
                wait8 <= 8'b00000000;   
                count_inter <= 2'b00;
            end
            default:
            begin
                wait1 <= 8'b00000000;
                wait2 <= 8'b00000000;
                wait3 <= 8'b00000000;
                wait4 <= 8'b00000000;
                wait5 <= 8'b00000000;
                wait6 <= 8'b00000000;
                wait7 <= 8'b00000000;
                wait8 <= 8'b00000000;   
                count_inter <= count_inter;
            end 
            endcase
        end
        else begin
        count <= count + 5'd1;
        end
    end
end

//旦字平移
always @(posedge clk) begin
    if(!rst_n) begin
        count2 <= 10'd0;
        dan1 <= 12'b000000000000;
        dan2 <= 12'b001111000000;
        dan3 <= 12'b001001000000;
        dan4 <= 12'b001111000000;
        dan5 <= 12'b001001000000;
        dan6 <= 12'b001111000000;
        dan7 <= 12'b000000000000;
        dan8 <= 12'b111111110000;
    end
    else begin
        if(count2 == 10'b1011111111) begin
            count2 <= 10'b000000000;
            //移位
            dan1 <= {dan1[10:0],dan1[11]};
            dan2 <= {dan2[10:0],dan2[11]};
            dan3 <= {dan3[10:0],dan3[11]};
            dan4 <= {dan4[10:0],dan4[11]};
            dan5 <= {dan5[10:0],dan5[11]};
            dan6 <= {dan6[10:0],dan6[11]};
            dan7 <= {dan7[10:0],dan7[11]};
            dan8 <= {dan8[10:0],dan8[11]};     
        end
        else begin
        count2 <= count2 + 10'd1;
        end
    end
end
//对应的行选中信号
always @(posedge clk) begin
    case (scan)
        3'b000:row <= 8'b00000001;
        3'b001:row <= 8'b00000010;
        3'b010:row <= 8'b00000100;
        3'b011:row <= 8'b00001000;
        3'b100:row <= 8'b00010000;
        3'b101:row <= 8'b00100000;
        3'b110:row <= 8'b01000000;
        3'b111:row <= 8'b10000000;
    endcase
end

//对应列变换
always @(posedge clk) begin
    case (state)
    S0://旦
    begin
        case (scan)//选取前8bit
        3'b000:col <= dan1[11:4];
        3'b001:col <= dan2[11:4];
        3'b010:col <= dan3[11:4];
        3'b011:col <= dan4[11:4];
        3'b100:col <= dan5[11:4];
        3'b101:col <= dan6[11:4];
        3'b110:col <= dan7[11:4];
        3'b111:col <= dan8[11:4];
        endcase
        RGB <= 3'b111;
    end
    S1:
    begin
        case (scan)//等待随机数计数信号
        3'b000:col <= wait1;
        3'b001:col <= wait2;
        3'b010:col <= wait3;
        3'b011:col <= wait4;
        3'b100:col <= wait5;
        3'b101:col <= wait6;
        3'b110:col <= wait7;
        3'b111:col <= wait8;
        endcase
        RGB <= RGB_temp;
    end
    S2://输出哭脸
    begin
        case (scan)
        3'b000:col <= 8'b00111100;
        3'b001:col <= 8'b01000010;
        3'b010:col <= 8'b10100101;
        3'b011:col <= 8'b10000001;
        3'b100:col <= 8'b10011001;
        3'b101:col <= 8'b10100101;
        3'b110:col <= 8'b01000010;
        3'b111:col <= 8'b00111100;
        endcase
        RGB <= 3'b100;
    end
    S3:
    begin
        case (scan)//等待按下反应按键
        3'b000:col <= 8'b00000000;
        3'b001:col <= 8'b00000000;
        3'b010:col <= 8'b00111100;
        3'b011:col <= 8'b00111100;
        3'b100:col <= 8'b00111100;
        3'b101:col <= 8'b00111100;
        3'b110:col <= 8'b00000000;
        3'b111:col <= 8'b00000000;
        endcase
        RGB <= 3'b010;
    end
    S4://输出笑脸
    begin
        case (scan)
        3'b000:col <= 8'b00111100;
        3'b001:col <= 8'b01000010;
        3'b010:col <= 8'b10100101;
        3'b011:col <= 8'b10000001;
        3'b100:col <= 8'b10100101;
        3'b101:col <= 8'b10011001;
        3'b110:col <= 8'b01000010;
        3'b111:col <= 8'b00111100;
        endcase
        RGB <= 3'b001;
    end
    default:
    begin
        case (scan)
        3'b000:col <= 8'b00000000;
        3'b001:col <= 8'b00000000;
        3'b010:col <= 8'b00000000;
        3'b011:col <= 8'b00000000;
        3'b100:col <= 8'b00000000;
        3'b101:col <= 8'b00000000;
        3'b110:col <= 8'b00000000;
        3'b111:col <= 8'b00000000;
        endcase
        RGB <= 3'b000;
    end        
    endcase
end    
endmodule