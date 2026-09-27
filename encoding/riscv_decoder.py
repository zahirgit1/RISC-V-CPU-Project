#!/usr/bin/env python3
"""
RISC-V Instruction Decoder
Decodes hexadecimal RISC-V instruction encodings to human-readable assembly mnemonics.
Supports: I-type (ADDI, LW), S-type (SW), R-type (ADD, SUB, SLT, AND, OR), B-type (BEQ)
"""

def decode_instruction(hex_str):
    """
    Decode a 32-bit RISC-V instruction from hex string to assembly mnemonic.
    
    Args:
        hex_str: Instruction as hex string (e.g., '0x00208863')
    
    Returns:
        Assembly instruction string (e.g., 'BEQ x1, x2, 16')
    """
    val = int(hex_str, 16)
    opcode = val & 0x7F
    rd = (val >> 7) & 0x1F
    funct3 = (val >> 12) & 0x7
    rs1 = (val >> 15) & 0x1F
    rs2 = (val >> 20) & 0x1F
    funct7 = (val >> 25) & 0x7F
    imm_i = (val >> 20) & 0xFFF
    
    # Handle sign extension for I-type immediates
    if imm_i & 0x800:
        imm_i = imm_i - 0x1000
    
    # I-type Arithmetic (ADDI, etc.)
    if opcode == 0x13:
        return f"ADDI x{rd}, x{rs1}, {imm_i}"
    
    # Load Word (LW)
    elif opcode == 0x03:
        return f"LW x{rd}, {imm_i}(x{rs1})"
    
    # Store Word (SW)
    elif opcode == 0x23:
        imm_s = (((val >> 25) & 0x7F) << 5) | ((val >> 7) & 0x1F)
        if imm_s & 0x800:
            imm_s = imm_s - 0x1000
        return f"SW x{rs2}, {imm_s}(x{rs1})"
    
    # Branch Equal (BEQ)
    elif opcode == 0x63:
        imm_b = (((val >> 31) & 1) << 12) | (((val >> 25) & 0x3F) << 5) | (((val >> 8) & 0xF) << 1) | (((val >> 7) & 1) << 11)
        if imm_b & 0x1000:
            imm_b = imm_b - 0x2000
        return f"BEQ x{rs1}, x{rs2}, {imm_b}"
    
    # R-type Arithmetic
    elif opcode == 0x33:
        if funct3 == 0 and funct7 == 0:
            return f"ADD x{rd}, x{rs1}, x{rs2}"
        elif funct3 == 0 and funct7 == 0x20:
            return f"SUB x{rd}, x{rs1}, x{rs2}"
        elif funct3 == 2:
            return f"SLT x{rd}, x{rs1}, x{rs2}"
        elif funct3 == 7:
            return f"AND x{rd}, x{rs1}, x{rs2}"
        elif funct3 == 6:
            return f"OR x{rd}, x{rs1}, x{rs2}"
    
    return f"UNKNOWN (0x{val:08x})"


def decode_file(filename):
    """
    Decode all instructions from a Verilog instruction memory file.
    
    Args:
        filename: Path to instruction memory file
    """
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
        
        print(f"\nDecoding instructions from {filename}:")
        print("-" * 80)
        print(f"{'Address':<12} {'Hex':<12} {'Decoded Instruction':<35} {'Comment':<20}")
        print("-" * 80)
        
        for line in lines:
            line = line.strip()
            if 'memory[' in line and '32\'h' in line:
                # Parse: memory[X] = 32'hYYYYYYYY; // comment
                parts = line.split('=')
                if len(parts) >= 2:
                    addr_part = line.split('[')[1].split(']')[0]
                    hex_part = parts[1].split(';')[0].strip().replace('32\'h', '0x')
                    comment = line.split('//')[-1].strip() if '//' in line else ''
                    
                    decoded = decode_instruction(hex_part)
                    print(f"mem[{addr_part:<3}]      {hex_part:<12} {decoded:<35} {comment:<20}")
        
        print("-" * 80)
    
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found")
    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("RISC-V Instruction Decoder")
        print("\nUsage:")
        print("  Decode single instruction: python3 riscv_decoder.py <hex_instruction>")
        print("  Decode from file:          python3 riscv_decoder.py --file <filename>")
        print("\nExamples:")
        print("  python3 riscv_decoder.py 0x00208863")
        print("  python3 riscv_decoder.py --file src/instruction_memory.v")
        sys.exit(1)
    
    if sys.argv[1] == "--file" and len(sys.argv) > 2:
        decode_file(sys.argv[2])
    else:
        # Decode single instruction
        hex_instr = sys.argv[1]
        if not hex_instr.startswith('0x') and not hex_instr.startswith('0X'):
            hex_instr = '0x' + hex_instr
        decoded = decode_instruction(hex_instr)
        print(f"{hex_instr} → {decoded}")
