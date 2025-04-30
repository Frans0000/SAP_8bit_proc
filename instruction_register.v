module instruction_register(
    input wire rst,
    input wire in_bus,    // reading from the bus
    input wire clk,
    input wire out_bus,   // outputing data onto the bus
    inout wire [7:0] bus_data,  
    output wire [3:0] decoder_data  // opcode
);

reg [7:0] instruction;
wire [7:0] bus_value;

// initialization
initial begin
    instruction = 8'h00;
end

// debugging purposes
assign bus_value = bus_data;

// loading instruction
always @(posedge clk) begin
    if (rst) begin
        instruction <= 8'h00;
    end 
    else if (in_bus) begin
        instruction <= bus_value;
    end
end

// opcode
assign decoder_data = instruction[7:4];

// 4 lower bits when out_bus is active
assign bus_data = out_bus ? {4'b0000, instruction[3:0]} : 8'bZ;

endmodule