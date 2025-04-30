module program_counter(
    input wire clk,
    input wire rst,
    input wire pc_inc,    
    input wire pc_load,   // load from bus
    input wire pc_enable, // put it on the bus
    inout wire [7:0] bus,
    output wire [7:0] pc_out
);

reg [7:0] pc;

// initialize
initial begin
    pc = 8'h00;
end

always @(posedge clk) begin
    if (rst) begin
        pc <= 8'h00;
    end 
    else begin
        if (pc_load) begin
            pc <= bus;
        end 
        else if (pc_inc) begin
            pc <= pc + 1;
        end
    end
end

// bus
assign bus = pc_enable ? pc : 8'bZ;
assign pc_out = pc; // for simulation purposes

endmodule