module controller(
    input wire clk,
    input wire rst,
    input wire [1:0] steps_required, // ile kroków potrzebuje instrukcja
    
	output reg pc_enable,
    output reg mar_load,
    output reg ram_read,
    output reg in_bus,
	
	output reg [1:0] step            // aktualny krok wykonania
    
);

parameter FETCH_PC_ADDR       		= 3'b000;
parameter LATCHED_ADDR_TO_MAR   	= 3'b001;
parameter RAM_INSTRUCTION_OUT      	= 3'b010;
parameter IR_INSTRUCTION_IN 		= 3'b011;
parameter DECODE_EXECUTE         	= 3'b100;


reg fetch;                  // czy mamy robiæ FETCH nowej instrukcji
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
            // tutaj implementacja fetchowania instrukcji
			case (state)

            FETCH_PC_ADDR: begin
                pc_enable <= 1;
                mar_load <= 1;
                ram_read <= 0;
                in_bus <= 0;
                state <= LATCHED_ADDR_TO_MAR;	//wystawiasz na magistrale pc i dajesz mar_load ¿eby przy zboczu to wczyta³
            end

            LATCHED_ADDR_TO_MAR: begin // po narastajacym zboczu addr jest juz wczytany wiec ustawiasz zeby na kolejnym zboczu ram wrzucil na magistrale polecenie
                ram_read <= 1;
                pc_enable <= 0;
				mar_load <= 0;
				state <= RAM_INSTRUCTION_OUT;
            end

            RAM_INSTRUCTION_OUT: begin // wyplu³ na magistrale polecenie, wiec ustawiawsz in_bus ¿eby instruction register zaci¹gn¹³
				in_bus <= 1;
				ram_read <= 0;
				
                state <= IR_INSTRUCTION_IN;
            end

            IR_INSTRUCTION_IN: begin	// przy narastaj¹cym zboczu instruction register zaci¹ga polecenie
	            in_bus <= 0;
                state <= DECODE_EXECUTE;
            end
			
			DECODE_EXECUTE: begin //mozna wykonywac instrukcje
				fetch <= 0;	
			end
		
			default: state <= FETCH_PC_ADDR;
        endcase
			
			
        end else begin
            if (step == steps_required) begin
                // jeœli skoñczyliœmy wszystkie kroki instrukcji
                fetch <= 1;  // znowu fetch nowej instrukcji
                step <= 0;
				state <= FETCH_PC_ADDR;
            end else begin
                step <= step + 1;
            end
        end
    end
end

endmodule


