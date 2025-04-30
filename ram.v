module ram(
    input wire ram_read,
    input wire ram_write,
    input wire [3:0] addr, // address from MAR
    inout wire [7:0] bus,
    input wire clk
);

// 16 bytes of memory
reg [7:0] memory [0:15];

// initialization of memory
initial begin 
    // clear memory
    integer i;
    for (i = 0; i < 16; i = i + 1) begin
        memory[i] = 8'h00;
    end
    
    // example instructions
    memory[0] = 8'b0001_0001; // 8'b0001_0001 - MOV A, 1
    memory[1] = 8'b0010_0011; // 8'b0010_0011 - MOV B, 3
	memory[2] = 8'b0111_0000; // 8'b0111_0000 - ADD A, B (A = A + B = 1 + 3 = 4)
    memory[3] = 8'b1001_0000; // 8'b1001_0000 - OUT A
end

// writing to ram
always @(posedge clk) begin
    if (ram_write) begin
        memory[addr] <= bus;
    end
end

// outputing data on the bus
assign bus = ram_read ? memory[addr] : 8'bZ;

endmodule