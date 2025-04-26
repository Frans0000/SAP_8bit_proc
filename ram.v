module ram(
	input wire ram_read,
	input wire ram_write,
	input wire [3:0] addr, //address from MAR
	inout wire [7:0] bus,
	input wire clk
);



reg [7:0] memory [0:15]; //16 bytes

initial begin 

memory[0] = 8'b0001_0001;
memory[1] = 8'b0010_0011;

end

reg [7:0] data_out;

always @(posedge clk) begin
    if (ram_write) begin
        memory[addr] <= bus;
    end
	else if (ram_read) begin
		data_out <= memory[addr];
	end	else begin
	   data_out <= 8'bZ;
	end
end

assign bus = ram_read ? data_out : 8'bZ;

endmodule