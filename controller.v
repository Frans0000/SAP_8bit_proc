module controller(
    input wire clk,
    input wire rst,
    input wire [1:0] steps_required, 
    
	output reg pc_enable,
    output reg mar_load,
    output reg ram_read,
    output reg in_bus,
	
	output reg [1:0] step           
    
);

parameter FETCH_PC_ADDR       		= 3'b000;
parameter LATCHED_ADDR_TO_MAR   	= 3'b001;
parameter RAM_INSTRUCTION_OUT      	= 3'b010;
parameter IR_INSTRUCTION_IN 		= 3'b011;
parameter DECODE_EXECUTE         	= 3'b100;


reg fetch;                  
reg [2:0] state;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        step <= 0;
	    fetch <= 1;
	    state <= FETCH_PC_ADDR;
	    pc_enable <= 0;
	    mar_load <= 0;
	    ram_read <= 0;
	    in_bus <= 0;
    end else begin
        if (fetch) begin
            
			case (state)

            FETCH_PC_ADDR: begin
                pc_enable <= 1;
                mar_load <= 1;
                ram_read <= 0;
                in_bus <= 0;
                state <= LATCHED_ADDR_TO_MAR;	
            end

            LATCHED_ADDR_TO_MAR: begin 
                ram_read <= 1;
                pc_enable <= 0;
				mar_load <= 0;
				state <= RAM_INSTRUCTION_OUT;
            end

            RAM_INSTRUCTION_OUT: begin 
				in_bus <= 1;
				ram_read <= 0;
				
                state <= IR_INSTRUCTION_IN;
            end

            IR_INSTRUCTION_IN: begin	
	            in_bus <= 0;
                state <= DECODE_EXECUTE;
            end
			
			DECODE_EXECUTE: begin 
				fetch <= 0;	
			end
		
			default: state <= FETCH_PC_ADDR;
        endcase
			
			
        end else begin
            if (step == steps_required) begin
                fetch <= 1;  
                step <= 0;
				state <= FETCH_PC_ADDR;
            end else begin
                step <= step + 1;
            end
        end
    end
end

endmodule


