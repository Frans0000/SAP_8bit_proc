module register
(
	input wire rst,
	input wire reg_load,	//read from bus
	input wire clk,
	input wire reg_enable,	//write to bus
	inout wire [7 : 0] bus_data,
	output wire [7 : 0] out_data
	);
	
reg [7:0] data;

always @(posedge clk) begin
	if(rst) begin
	data <= 0;
	end
	
	else begin
		if(reg_load) begin
		data <= bus_data;
		end
	
	end
		
end	

assign bus_data = reg_enable ? data : 8'bZ;
assign out_data = data;


endmodule