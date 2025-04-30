module alu(
input wire [7:0] a,
input wire [7:0] b,
input wire sub, //0 is ADD; 1 is SUB
input wire alu_enable, //write to bus
output wire [7:0] result, 
output reg c, //carry flag
output reg z, //zero flag
input wire inc_a,
input wire dec_a
);

wire [8:0] full_result; //9 bit result to catch carry bit
wire [7:0] alu_result;

// operation
assign full_result = inc_a ? (a + 1) : 
                     dec_a ? (a - 1) : 
                     sub   ? (a + ~b + 1) : (a + b);  //U2

// result on bus
assign alu_result = full_result[7:0];
assign result = alu_enable ? alu_result : 8'bZ;

// flags
always @(*) begin
    c = full_result[8];     // ninth bit is carry
    z = (alu_result == 8'b00000000) ? 1'b1 : 1'b0;  // zero flag
end

endmodule