module mar(
	input mar_load,
	input clk,
	input wire [3:0] bus,
	output wire [3:0] addr
);

reg [3:0] reg_address;

always @(posedge clk)begin
	if(mar_load) begin
		reg_address <= bus;
	end
	
end

assign addr = reg_address;


endmodule