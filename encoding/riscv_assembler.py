#!/usr/bin/env python3
"""
RISC-V Assembler
Converts RISC-V assembly instructions to hexadecimal machine code.
Supports: I-type (ADDI, LW), S-type (SW), R-type (ADD, SUB, SLT, AND, OR), B-type (BEQ)
"""

import re
import sys


class RISCVAssembler:
    """Assembler for RISC-V instructions."""
    
    # Instruction format definitions
    INSTRUCTIONS = {
        # I-type instructions
        'ADDI': {'opcode': 0x13, 'funct3': 0x0, 'type': 'I'},
        'LW': {'opcode': 0x03, 'funct3': 0x2, 'type': 'I'},
        
        # S-type instructions
        'SW': {'opcode': 0x23, 'funct3': 0x2, 'type': 'S'},
        
        # B-type instructions
        'BEQ': {'opcode': 0x63, 'funct3': 0x0, 'type': 'B'},
        
        # R-type instructions
        'ADD': {'opcode': 0x33, 'funct3': 0x0, 'funct7': 0x00, 'type': 'R'},
        'SUB': {'opcode': 0x33, 'funct3': 0x0, 'funct7': 0x20, 'type': 'R'},
        'AND': {'opcode': 0x33, 'funct3': 0x7, 'funct7': 0x00, 'type': 'R'},
        'OR': {'opcode': 0x33, 'funct3': 0x6, 'funct7': 0x00, 'type': 'R'},
        'SLT': {'opcode': 0x33, 'funct3': 0x2, 'funct7': 0x00, 'type': 'R'},
    }
    
    @staticmethod
    def parse_register(reg_str):
        """Parse register name to number (x0-x31)."""
        reg_str = reg_str.strip()
        if reg_str.startswith('x'):
            try:
                reg_num = int(reg_str[1:])
                if 0 <= reg_num <= 31:
                    return reg_num
            except ValueError:
                pass
        raise ValueError(f"Invalid register: {reg_str}")
    
    @staticmethod
    def sign_extend_12bit(value):
        """Sign extend 12-bit value to 32-bit."""
        if value & 0x800:
            return value - 0x1000
        return value
    
    @staticmethod
    def encode_i_type(opcode, funct3, rd, rs1, imm):
        """Encode I-type instruction."""
        imm = int(imm) & 0xFFF
        instr = opcode | (rd << 7) | (funct3 << 12) | (rs1 << 15) | (imm << 20)
        return instr
    
    @staticmethod
    def encode_s_type(opcode, funct3, rs1, rs2, imm):
        """Encode S-type instruction."""
        imm = int(imm)
        imm11_5 = (imm >> 5) & 0x7F
        imm4_0 = imm & 0x1F
        instr = opcode | (imm4_0 << 7) | (funct3 << 12) | (rs1 << 15) | (rs2 << 20) | (imm11_5 << 25)
        return instr
    
    @staticmethod
    def encode_b_type(opcode, funct3, rs1, rs2, imm):
        """Encode B-type instruction."""
        imm = int(imm) >> 1  # Immediate is in half-words
        imm12 = (imm >> 12) & 1
        imm11 = (imm >> 11) & 1
        imm10_5 = (imm >> 5) & 0x3F
        imm4_1 = imm & 0xF
        instr = opcode | (imm4_1 << 8) | (imm11 << 7) | (funct3 << 12) | (rs1 << 15) | (rs2 << 20) | (imm10_5 << 25) | (imm12 << 31)
        return instr
    
    @staticmethod
    def encode_r_type(opcode, funct3, funct7, rd, rs1, rs2):
        """Encode R-type instruction."""
        instr = opcode | (rd << 7) | (funct3 << 12) | (rs1 << 15) | (rs2 << 20) | (funct7 << 25)
        return instr
    
    def assemble_instruction(self, instruction):
        """
        Assemble a single instruction.
        
        Args:
            instruction: Assembly instruction string (e.g., "ADDI x1, x0, 12")
        
        Returns:
            32-bit integer machine code
        """
        instruction = instruction.strip()
        if not instruction or instruction.startswith('#'):
            return None
        
        # Remove comments
        if '#' in instruction:
            instruction = instruction.split('#')[0]
        
        # Parse instruction mnemonic and operands
        parts = instruction.split()
        mnemonic = parts[0].upper()
        
        if mnemonic not in self.INSTRUCTIONS:
            raise ValueError(f"Unknown instruction: {mnemonic}")
        
        instr_info = self.INSTRUCTIONS[mnemonic]
        instr_type = instr_info['type']
        
        # Extract operands
        operands_str = ' '.join(parts[1:]).replace(',', ' ').split()
        operands = [op.strip() for op in operands_str if op.strip()]
        
        # Encode based on instruction type
        if instr_type == 'I':
            if mnemonic == 'LW':
                # LW rd, imm(rs1)
                rd = self.parse_register(operands[0])
                match = re.match(r'(-?\d+)\(x(\d+)\)', operands[1])
                if not match:
                    raise ValueError(f"Invalid LW format: {operands[1]}")
                imm = int(match.group(1))
                rs1 = int(match.group(2))
            else:  # ADDI
                # ADDI rd, rs1, imm
                rd = self.parse_register(operands[0])
                rs1 = self.parse_register(operands[1])
                imm = int(operands[2])
            
            return self.encode_i_type(instr_info['opcode'], instr_info['funct3'], rd, rs1, imm)
        
        elif instr_type == 'S':
            # SW rs2, imm(rs1)
            rs2 = self.parse_register(operands[0])
            match = re.match(r'(-?\d+)\(x(\d+)\)', operands[1])
            if not match:
                raise ValueError(f"Invalid SW format: {operands[1]}")
            imm = int(match.group(1))
            rs1 = int(match.group(2))
            
            return self.encode_s_type(instr_info['opcode'], instr_info['funct3'], rs1, rs2, imm)
        
        elif instr_type == 'B':
            # BEQ rs1, rs2, imm
            rs1 = self.parse_register(operands[0])
            rs2 = self.parse_register(operands[1])
            imm = int(operands[2])
            
            return self.encode_b_type(instr_info['opcode'], instr_info['funct3'], rs1, rs2, imm)
        
        elif instr_type == 'R':
            # R-type: MNEMONIC rd, rs1, rs2
            rd = self.parse_register(operands[0])
            rs1 = self.parse_register(operands[1])
            rs2 = self.parse_register(operands[2])
            
            return self.encode_r_type(instr_info['opcode'], instr_info['funct3'], 
                                     instr_info['funct7'], rd, rs1, rs2)


def assemble_file(input_file, output_file=None):
    """
    Assemble a file of RISC-V assembly instructions.
    
    Args:
        input_file: Input file with assembly instructions (one per line)
        output_file: Optional output file for Verilog memory initialization
    """
    assembler = RISCVAssembler()
    
    try:
        with open(input_file, 'r') as f:
            lines = f.readlines()
        
        print(f"\nAssembling {input_file}:")
        print("-" * 90)
        print(f"{'Addr':<8} {'Assembly':<30} {'Hex':<12} {'Binary':<36}")
        print("-" * 90)
        
        encodings = []
        addr = 0
        
        for line in lines:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            
            try:
                machine_code = assembler.assemble_instruction(line)
                if machine_code is not None:
                    hex_str = f"0x{machine_code:08x}"
                    binary_str = f"{machine_code:032b}"
                    print(f"[{addr:<6}] {line:<30} {hex_str:<12} {binary_str}")
                    encodings.append((addr, machine_code, line))
                    addr += 1
            except Exception as e:
                print(f"Error assembling '{line}': {e}")
        
        print("-" * 90)
        
        # Generate Verilog output
        if output_file:
            with open(output_file, 'w') as f:
                f.write("module Instruction_memory(Address,reset, ReadData);\n")
                f.write("    input [31:0]Address;\n")
                f.write("    output [31:0] ReadData;\n")
                f.write("    input reset;\n\n")
                f.write("    reg [31:0] memory [1023:0];\n")
                f.write("    assign ReadData = (!reset)? {32{1'b0}} : memory[Address[31:2]];\n\n")
                f.write("    initial begin\n")
                
                for addr, machine_code, asm in encodings:
                    f.write(f"        memory[{addr}] = 32'h{machine_code:08x};   // {asm}\n")
                
                # Pad remaining memory with zeros
                for addr in range(len(encodings), 16):
                    f.write(f"        memory[{addr}] = 32'h00000000;\n")
                
                f.write("    end\n")
                f.write("endmodule\n")
            
            print(f"\nVerilog output written to {output_file}")
        
        return encodings
    
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found")
    except Exception as e:
        print(f"Error: {e}")


def interactive_mode():
    """Interactive assembler mode."""
    assembler = RISCVAssembler()
    
    print("\n" + "="*80)
    print("RISC-V Assembler - Interactive Mode")
    print("="*80)
    print("Enter assembly instructions (one per line). Type 'quit' to exit.\n")
    
    addr = 0
    print(f"{'Addr':<8} {'Assembly':<30} {'Hex':<12} {'Binary':<36}")
    print("-" * 90)
    
    while True:
        try:
            line = input(f"[{addr}] > ").strip()
            
            if line.lower() == 'quit':
                break
            
            if not line or line.startswith('#'):
                continue
            
            machine_code = assembler.assemble_instruction(line)
            if machine_code is not None:
                hex_str = f"0x{machine_code:08x}"
                binary_str = f"{machine_code:032b}"
                print(f"      {hex_str:<12} {binary_str}")
                addr += 1
        
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(f"Error: {e}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("RISC-V Assembler")
        print("\nUsage:")
        print("  Interactive mode:     python3 riscv_assembler.py")
        print("  Assemble file:        python3 riscv_assembler.py <input.asm> [output.v]")
        print("\nExample assembly format (input.asm):")
        print("  ADDI x1, x0, 12")
        print("  ADDI x2, x0, 10")
        print("  SLT x7, x2, x1")
        print("  SW x2, 0(x1)")
        print("  LW x3, 0(x1)")
        print("  ADD x4, x1, x2")
        print("\nSupported instructions:")
        print("  I-type: ADDI, LW")
        print("  S-type: SW")
        print("  B-type: BEQ")
        print("  R-type: ADD, SUB, AND, OR, SLT")
        sys.exit(1)
    
    if len(sys.argv) == 2 and sys.argv[1].endswith('.asm'):
        output_file = sys.argv[1].replace('.asm', '_memory.v')
        assemble_file(sys.argv[1], output_file)
    elif len(sys.argv) >= 2:
        assemble_file(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)
    else:
        interactive_mode()
