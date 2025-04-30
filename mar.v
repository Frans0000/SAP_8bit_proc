module mar(
    input wire mar_load,
    input wire clk,
    input wire [7:0] bus,  
    output wire [3:0] addr
);

reg [3:0] reg_address;

// initialize
initial begin
    reg_address = 4'h0;
end

always @(posedge clk) begin
    if (mar_load) begin
        reg_address <= bus[3:0];  // taking 4 bits from the bus
    end
end

assign addr = reg_address;

endmodule