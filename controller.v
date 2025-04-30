module controller(
    input wire clk,
    input wire rst,
    input wire [1:0] steps_required, 
    
    // signals to fetch instruction
    output reg pc_enable,
    output reg mar_load,
    output reg ram_read,
    output reg in_bus,
    
    // status of controller
    output reg fetch_complete,
    
    // steps counter   
    output reg [1:0] step           
);

// machine states
parameter FETCH_PC_ADDR           = 3'b000; // PC -> BUS, MAR <- BUS
parameter LATCHED_ADDR_TO_MAR     = 3'b001; // MAR loaded, turn RAM to read
parameter RAM_INSTRUCTION_OUT     = 3'b010; // RAM -> BUS, IR <- BUS 
parameter IR_INSTRUCTION_IN       = 3'b011; // IR loaded, turn off read signal
parameter DECODE_EXECUTE          = 3'b100; // decoding and executing

reg [2:0] state;

// initialization
initial begin
    step = 0;
    fetch_complete = 0;
    state = FETCH_PC_ADDR;
    pc_enable = 0;
    mar_load = 0;
    ram_read = 0;
    in_bus = 0;
end

always @(posedge clk) begin
    if (rst) begin
        step <= 0;
        fetch_complete <= 0;
        state <= FETCH_PC_ADDR;
        pc_enable <= 0;
        mar_load <= 0;
        ram_read <= 0;
        in_bus <= 0;
    end 
    else begin
        if (!fetch_complete) begin
            // fetch
            case (state)
                FETCH_PC_ADDR: begin
                    // PC puts address on the bus
                    pc_enable <= 1;
                    mar_load <= 1;
                    ram_read <= 0;
                    in_bus <= 0;
                    state <= LATCHED_ADDR_TO_MAR;
                end

                LATCHED_ADDR_TO_MAR: begin 
                    // RAM starts reading
                    ram_read <= 1;
                    pc_enable <= 0;
                    mar_load <= 0;
                    state <= RAM_INSTRUCTION_OUT;
                end

                RAM_INSTRUCTION_OUT: begin 
                    // in_bus active while ram_read active
                    in_bus <= 1;
                    ram_read <= 1;
                    state <= IR_INSTRUCTION_IN;
                end

                IR_INSTRUCTION_IN: begin    
                    // turn off signals, IR loaded data
                    in_bus <= 0;
                    ram_read <= 0;
                    state <= DECODE_EXECUTE;
                end
                
                DECODE_EXECUTE: begin 
                    fetch_complete <= 1;    
                    // reset all signals
                    pc_enable <= 0;
                    mar_load <= 0;
                    ram_read <= 0;
                    in_bus <= 0;
                end
            
                default: begin
                    state <= FETCH_PC_ADDR;
                end
            endcase
        end 
        else begin
            // execute
            if (step == steps_required) begin
                fetch_complete <= 0;  
                step <= 0;
                state <= FETCH_PC_ADDR;
            end 
            else begin
                step <= step + 1;
            end
        end
    end
end

endmodule