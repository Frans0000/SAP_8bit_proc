module instruction_decoder(
    input wire [3:0] opcode,
    input wire c,    
    input wire z,    
    input wire fetch_complete, // signal from controller informing about fetch state
    
    // controll signals
    output reg reg_load_a,
    output reg reg_enable_a,
    output reg reg_load_b,
    output reg reg_enable_b,
    output reg alu_enable,
    output reg sub,
    output reg reg_load_o,
    output reg pc_inc,
    output reg pc_load,
    output reg ram_write,
    output reg out_bus,
    output reg inc_a,
    output reg dec_a,
    
	output reg ram_controller_read,
	//output reg ram_controller_write,
	output reg mar_controller,
    input wire [1:0] step,
    output reg [1:0] steps_required
);

always @(*) begin
    // reset
    reg_load_a = 0;
    reg_enable_a = 0;
    reg_load_b = 0;
    reg_enable_b = 0;
    alu_enable = 0;
    sub = 0;
    reg_load_o = 0;
    pc_inc = 0;
    pc_load = 0;
    ram_write = 0;
    out_bus = 0;
    inc_a = 0;
    dec_a = 0;
	mar_controller = 0;
    ram_controller_read = 0;
	
    steps_required = 2'b01; // default 1 step
    
    // decoding once fetch is completed
    if (fetch_complete) begin
        case (opcode)
            4'b0000: begin // NOP
                steps_required = 2'b01;
                pc_inc = 1;
            end

            4'b0001: begin // MOV A, immediate
                steps_required = 2'b10; 
                case (step)
                    2'b00: begin
                        out_bus = 1;
                        reg_load_a = 1;
                    end
                    2'b01: begin
                        pc_inc = 1;
                    end
                endcase
            end
            
            4'b0010: begin // MOV B, immediate
                steps_required = 2'b10; 
                case (step)
                    2'b00: begin
                        out_bus = 1;
                        reg_load_b = 1;
                    end
                    2'b01: begin
                        pc_inc = 1;
                    end
                endcase
            end

            4'b0011: begin // LOAD A, [addr]
                steps_required = 2'b11; // three steps
                case (step)
                    2'b00: begin
                        mar_controller = 1;
                    end
                    2'b01: begin
						out_bus = 1;
                        ram_controller_read = 1;
                    end
                    2'b10: begin
                        reg_load_a = 1;
                        pc_inc = 1;
                    end
                endcase
            end

            
            4'b0100: begin // LOAD B, [addr]
                steps_required = 2'b11;
                case (step)
                    2'b00: begin
						mar_controller = 1;
                    end
                    2'b01: begin
						out_bus = 1;
                        ram_controller_read = 1;
                    end
                    2'b10: begin
                        reg_load_b = 1;
                        pc_inc = 1;
                    end
                endcase
            end

            4'b0101: begin // STORE A, [addr]
                steps_required = 2'b11; 
                case (step)
                    2'b00: begin
                        mar_controller = 1;
                    end
                    2'b01: begin
                        out_bus = 1;
                    end
					2'b10: begin
						reg_enable_a = 1;
                        ram_write = 1;
                        pc_inc = 1;
					end
                endcase
            end

            4'b0110: begin // STORE B, [addr]
                steps_required = 2'b11; 
                case (step)
                    2'b00: begin
                        mar_controller = 1;
                    end
                    2'b01: begin
						out_bus = 1;
                    end
					2'b10: begin
						reg_enable_b = 1;
                        ram_write = 1;
                        pc_inc = 1;
					end
                endcase
            end

            4'b0111: begin // ADD A, B            
                steps_required = 2'b10; 
                case (step)
                    2'b00: begin
                        sub = 0;
                        alu_enable = 1;
                        reg_load_a = 1;
                    end
                    2'b01: begin
                        pc_inc = 1;
                    end
                endcase
            end

            4'b1000: begin // SUB A, B
                steps_required = 2'b10; 
                case (step)
                    2'b00: begin
                        sub = 1;
                        alu_enable = 1;
                        reg_load_a = 1;
                    end
                    2'b01: begin
                        pc_inc = 1;
                    end
                endcase
            end

            4'b1001: begin // OUT A
                steps_required = 2'b10; 
                case (step)
                    2'b00: begin
                       reg_enable_a = 1;
                       reg_load_o = 1;
                    end
                    2'b01: begin
                        pc_inc = 1;
                    end
                endcase
            end

            4'b1010: begin // OUT B
                steps_required = 2'b10; 
                case (step)
                    2'b00: begin
                       reg_enable_b = 1;
                       reg_load_o = 1;
                    end
                    2'b01: begin
                        pc_inc = 1;
                    end
                endcase
            end

            4'b1011: begin // JMP addr
                steps_required = 2'b10; 
                case (step)
                    2'b00: begin
                       out_bus = 1;
                       pc_load = 1;
                    end
                    2'b01: begin
                        // waiting for load
                    end
                endcase
            end

            4'b1100: begin // JZ addr jump if z == 1
                if (z) begin
                    steps_required = 2'b10; 
                    case (step)
                        2'b00: begin
                           out_bus = 1;
                           pc_load = 1;
                        end
                        2'b01: begin
                            // waiting for load
                        end
                    endcase
                end else begin
                    steps_required = 2'b01;
                    pc_inc = 1;
                end    
            end

            4'b1101: begin // JC addr jump if c == 1
                if (c) begin
                    steps_required = 2'b10; 
                    case (step)
                        2'b00: begin
                           out_bus = 1;
                           pc_load = 1;
                        end
                        2'b01: begin
                            // waiting for load
                        end
                    endcase
                end else begin
                    steps_required = 2'b01;
                    pc_inc = 1;
                end    
            end

            4'b1110: begin // INC A
                steps_required = 2'b10; 
                case (step)
                    2'b00: begin
                        inc_a = 1;
                        alu_enable = 1;
                        reg_load_a = 1;
                    end
                    2'b01: begin
                        pc_inc = 1;     
                    end
                endcase
            end

            4'b1111: begin // DEC A
                steps_required = 2'b10; 
                case (step)
                    2'b00: begin
                        dec_a = 1;
                        alu_enable = 1;
                        reg_load_a = 1;
                    end
                    2'b01: begin
                        pc_inc = 1;     
                    end
                endcase
            end

            default: begin
                // do nothing
            end
        endcase
    end
end

endmodule