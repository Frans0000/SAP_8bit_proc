module instruction_register(
	input wire rst,
	input wire in_bus,	//read from bus
	input wire clk,
	input wire out_bus,	//write to bus
	inout wire [7:0] bus_data,
	output wire [3:0] decoder_data
);

reg [7:0] instruction;

always @(posedge clk) begin
	if(rst) begin
	instruction <= 0;
	end
	
	else begin
		if(in_bus) begin
		instruction <= bus_data;
		end
	
	end
		
end	

assign bus_data = out_bus ? {4'b0000, instruction[3:0]} : 8'bZ;
assign decoder_data = instruction;


endmodule