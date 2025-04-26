module alu(
input wire [7:0] a,
input wire [7:0] b,
input wire sub, //0 is ADD; 1 is SUB
input wire alu_enable, //write to bus
output wire [7:0] result, 
output wire c, //carry flag
output wire z, //zero flag
input wire inc_a,
input wire dec_a
);

wire [8:0] full_result; //9 bit result to catch carry bit

assign full_result = inc_a ? (a + 1) : 
                     dec_a ? (a - 1) : 
                     sub   ? (a + ~b + 1) : (a + b);  //U2


assign result = alu_enable ? full_result [7:0] : 8'bZ;	
assign c = full_result[8]; 
assign z = (result == 8'b00000000);


endmodule


