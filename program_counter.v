module program_counter(
	input wire clk,
	input wire rst,
	input wire pc_inc, //increment
	input wire pc_load, // load from bus
	input wire pc_enable, //put it on the bus
	inout [3:0] bus,
	output wire [7:0] pc_out
);

reg [7:0] pc;

always @(posedge clk) begin
	if(rst) begin
		pc <= 8'b0;
	end
	
	else begin
	   if(pc_load) begin
		   pc <= bus;
	   end
	   
		else if (pc_inc) begin
		   pc <= pc+1;
		end
	end
end


assign bus = pc_enable ? pc : 8'bZ;
assign pc_out = pc; //simulation purposes

endmodule
