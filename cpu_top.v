module cpu_top();
    
reg CLK;
initial CLK = 0;
always #50 CLK = ~CLK;

wire [7:0] BUS;

reg RST;
initial begin 
    RST = 0;
    #100 RST = 1;  
    #100 RST = 0;  
end


wire ram_controller_read;
wire mar_controller;

// instruction decoder's signals
wire pc_inc;
wire pc_load;

wire reg_load_a;
wire reg_enable_a;

wire alu_enable;
wire c;
wire z;
wire sub;

wire reg_load_b;
wire reg_enable_b;
wire reg_load_o;
wire ram_write;
wire out_bus;
wire inc_a;
wire dec_a;

// controller's signals
wire pc_enable;
wire mar_load;
wire ram_read;
wire in_bus;
wire fetch_complete;

// signals between modules
wire [3:0] addr;
wire [3:0] decoder_data;
wire [7:0] out_data_a;
wire [7:0] out_data_b;
wire [7:0] out_data_o;
wire [1:0] step;
wire [1:0] steps_required;

// modules
program_counter program_counter(
    .clk(CLK),
    .rst(RST),
    .pc_inc(pc_inc), 
    .pc_load(pc_load), 
    .pc_enable(pc_enable), 
    .bus(BUS),
    .pc_out()
);

mar memory_address_register(
    .mar_load(mar_load),
    .clk(CLK),
    .bus(BUS),  
    .addr(addr)
);

ram ram(
    .ram_read(ram_read),
    .ram_write(ram_write),
    .addr(addr), 
    .bus(BUS),
    .clk(CLK)
);

instruction_register instruction_register(
    .rst(RST),
    .in_bus(in_bus),
    .clk(CLK),
    .out_bus(out_bus),    
    .bus_data(BUS),
    .decoder_data(decoder_data)
);

register register_a(
    .rst(RST),
    .reg_load(reg_load_a),    
    .clk(CLK),
    .reg_enable(reg_enable_a),    
    .bus_data(BUS),
    .out_data(out_data_a)    
);

alu alu(
    .a(out_data_a),
    .b(out_data_b),
    .sub(sub), 
    .alu_enable(alu_enable),
    .result(BUS), 
    .c(c), 
    .z(z),
    .inc_a(inc_a),
    .dec_a(dec_a)
);

register register_b(
    .rst(RST),
    .reg_load(reg_load_b),    
    .clk(CLK),
    .reg_enable(reg_enable_b),    
    .bus_data(BUS),
    .out_data(out_data_b)    
);

output_register output_register(
    .rst(RST),
    .reg_load(reg_load_o),    
    .clk(CLK),
    .bus_data(BUS),
    .out_data(out_data_o)
);

instruction_decoder instruction_decoder(
    .opcode(decoder_data),
    .c(c),    
    .z(z),    
    .fetch_complete(fetch_complete), //
    .reg_load_a(reg_load_a),
    .reg_enable_a(reg_enable_a),
    .reg_load_b(reg_load_b),
    .reg_enable_b(reg_enable_b),
    .alu_enable(alu_enable),
    .sub(sub),
    .reg_load_o(reg_load_o),
    .pc_inc(pc_inc),
    .pc_load(pc_load),
    .ram_write(ram_write),
    .out_bus(out_bus),
    .step(step),
    .steps_required(steps_required),
    .inc_a(inc_a),
    .dec_a(dec_a),
	.ram_controller_read(ram_controller_read),
	.mar_controller(mar_controller)
);

controller controller(
    .clk(CLK),
    .rst(RST),
    .steps_required(steps_required),
    .step(step),
    .pc_enable(pc_enable),
    .mar_load(mar_load),
    .ram_read(ram_read),
    .in_bus(in_bus),
    .fetch_complete(fetch_complete),
	.ram_controller_read(ram_controller_read),
	.mar_controller(mar_controller)
);

endmodule