module cpu_top();
	
reg CLK;
initial CLK <= 0;
always #50 CLK <= ~CLK;


reg [7:0] bus_driver;	
wire [7:0] BUS;

reg RST;
initial begin 
RST <= 0;
RST <= #100 1;
RST <= #200 0;
bus_driver = 8'b0;
end

assign BUS = bus_driver;

// instruction decoder's
wire pc_inc;
wire pc_load;
wire pc_enable;

wire mar_load;

wire ram_read;
wire ram_write;

wire in_bus;
wire out_bus;

wire reg_load_a;
wire reg_enable_a;

wire alu_enable;
wire c;
wire z;
wire sub;

wire reg_load_b;
wire reg_enable_b;

wire reg_load_o;


//between modules
wire [3:0] addr;

wire [3:0] decoder_data;

wire [7:0] out_data_a;

wire [7:0] out_data_b;

wire [7:0] out_data_o;

wire inc_a;
wire dec_a;

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


//nowe do komunikacji z kontrolerem

wire [1:0] step;
wire [1:0] steps_required;

instruction_decoder instruction_decoder(
    .opcode(decoder_data),
   	.c(c),    
    .z(z),    
    .reg_load_a(reg_load_a),
    .reg_enable_a(reg_enable_a),
    .reg_load_b(reg_load_b),
    .reg_enable_b(reg_enable_b),
    .alu_enable(alu_enable),
    .sub(sub),
    .reg_load_o(reg_load_o),
    .pc_inc(pc_inc),
    .pc_load(pc_load),
    .pc_enable(pc_enable),
    .ram_read(ram_read),
    .ram_write(ram_write),
    .mar_load(mar_load),
    .in_bus(in_bus),
    .out_bus(out_bus),
	.step(step),
	.steps_required(steps_required),
	.inc_a(inc_a),
	.dec_a(dec_a)
);


controller controller(
    .clk(CLK),
    .rst(RST),
    .steps_required(steps_required), // ile kroków potrzebuje instrukcja
    .step(step),            // aktualny krok wykonania 
	.pc_enable(pc_enable),
	.mar_load(mar_load),
	.ram_read(ram_read),
	.in_bus(in_bus)
);

endmodule