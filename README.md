# Simple as Possible 8-bit Processor

A minimalist 8-bit processor implemented in Verilog. 
Project is currently work in progress (LOAD/STORE) instructions are not implemented.

## Architecture

The processor features:
- 8-bit data bus architecture
- 4-bit addressing (16 bytes of RAM)
- von Neumann architecture
- Two general-purpose registers (A and B)
- ALU with add, subtract, increment, and decrement operations
- Conditional and unconditional jumps using carry and zero flags

### Schema
  ![schema](schema.png)


## Instruction Set

| Opcode (Binary) | Instruction | Description |
|-----------------|-------------|-------------|
| 0000 | NOP | No operation |
| 0001 | MOV A, imm | Load immediate value to register A |
| 0010 | MOV B, imm | Load immediate value to register B |
| 0011 | LOAD A, [addr] | Load from memory to register A |
| 0100 | LOAD B, [addr] | Load from memory to register B |
| 0101 | STORE A, [addr] | Store register A to memory |
| 0110 | STORE B, [addr] | Store register B to memory |
| 0111 | ADD A, B | Add B to A |
| 1000 | SUB A, B | Subtract B from A |
| 1001 | OUT A | Output register A |
| 1010 | OUT B | Output register B |
| 1011 | JMP addr | Jump to address |
| 1100 | JZ addr | Jump if zero flag is set |
| 1101 | JC addr | Jump if carry flag is set |
| 1110 | INC A | Increment register A |
| 1111 | DEC A | Decrement register A |

## Key Components

- **Program Counter**: Tracks the current instruction address
- **ALU**: Performs arithmetic and logical operations
- **Registers**: Storage for operands and results
- **Instruction Decoder**: Translates opcodes into control signals
- **Controller**: Manages instruction fetch and execute cycle
- **RAM**: 16 bytes of instruction/data memory
- **Output Register**: Displays computation results

## Sample Program

The processor comes pre-loaded with a simple program.

## Usage

This project can be simulated in any Verilog-compatible simulator. The main testbench is in the `cpu_top.v` file.
