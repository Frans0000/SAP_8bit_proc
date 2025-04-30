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
    memory[0] = 8'b0001_1001; // MOV A, 9    
	memory[1] = 8'b0101_0000; // store A, addr so value A goes to memory[0]
	memory[2] = 8'b0001_1111; // MOV A, 15
	memory[3] = 8'b0011_0000; // load to A value from memory[0]
	memory[4] = 8'b0010_0100; // MOV B, 4
	memory[5] = 8'b0111_0000; // ADD A, B so should be 9 + 4 = 13
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