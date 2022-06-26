module Binary_To_7Segment (
    input [3:0] Binary,//二进制输入
    output reg[6:0] r_Hex_Encoding//七段显示码
);
always @(*) begin
case (Binary)
  4'b0000 : r_Hex_Encoding = 7'h3f;//0111111 0
  4'b0001 : r_Hex_Encoding = 7'h06;//0000110 1
  4'b0010 : r_Hex_Encoding = 7'h5b;//2
  4'b0011 : r_Hex_Encoding = 7'h4f;//3
  4'b0100 : r_Hex_Encoding = 7'h66;//4       
  4'b0101 : r_Hex_Encoding = 7'h6d;//5
  4'b0110 : r_Hex_Encoding = 7'h7d;//6
  4'b0111 : r_Hex_Encoding = 7'h07;//7
  4'b1000 : r_Hex_Encoding = 7'h7f;//8
  4'b1001 : r_Hex_Encoding = 7'h6f;//9
  default : r_Hex_Encoding = 7'h3f;//0
endcase
end

endmodule //Binary_To_7Segment