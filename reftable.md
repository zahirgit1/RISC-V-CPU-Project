# CPU Reference Table

This file tracks what is already implemented in the current CPU and what still needs to be added.

## 1) Current implemented functionality

| Area | Function | Status | Source / module |
|---|---|---|---|
| PC | Program counter register | ✅ Implemented | src/Pc.v |
| PC | PC + 4 sequential increment | ✅ Implemented | src/Pc.v, src/Top_cpu.v |
| PC | Branch target calculation with immediate | ✅ Implemented | src/Top_cpu.v |
| Instruction fetch | Instruction memory read | ✅ Implemented | src/instruction_memory.v |
| Register file | 32-bit register bank with read/write | ✅ Implemented | src/register_file.v |
| Sign extension | I-type immediate extension | ✅ Implemented | src/sign_extend.v |
| Sign extension | S-type immediate extension | ✅ Implemented | src/sign_extend.v |
| Sign extension | B-type immediate extension | ✅ Implemented | src/sign_extend.v |
| ALU | ADD | ✅ Implemented | src/alu.v |
| ALU | SUB | ✅ Implemented | src/alu.v |
| ALU | AND | ✅ Implemented | src/alu.v |
| ALU | OR | ✅ Implemented | src/alu.v |
| ALU | SLT | ✅ Implemented | src/alu.v |
| ALU flags | Zero | ✅ Implemented | src/alu.v |
| ALU flags | Negative | ✅ Implemented | src/alu.v |
| ALU flags | Overflow | ✅ Implemented | src/alu.v |
| ALU flags | CarryOut | ✅ Implemented | src/alu.v |
| Control | Main decoder | ✅ Implemented | src/Control_unit.v |
| Control | ALU decoder | ✅ Implemented | src/Control_unit.v |
| Control | Branch condition logic | ✅ Implemented | src/Control_unit.v |
| Memory | Data memory read | ✅ Implemented | src/data_memory.v |
| Memory | Data memory write | ✅ Implemented | src/data_memory.v |
| Writeback mux | Select ALU result vs memory data | ✅ Implemented | src/demux_result.v |
| ALU input mux | Select register or immediate operand | ✅ Implemented | src/demux_result.v |
| Top-level CPU | Single-cycle assembly of all modules | ✅ Implemented | src/Top_cpu.v |

## 2) Instructions currently supported

| Instruction | Category | Status | Notes |
|---|---|---|---|
| lw | Load | ✅ | Implemented in main decoder |
| sw | Store | ✅ | Implemented in main decoder |
| beq | Branch | ✅ | Implemented in main decoder |
| add | R-type | ✅ | Implemented |
| sub | R-type | ✅ | Implemented |
| and | R-type | ✅ | Implemented |
| or | R-type | ✅ | Implemented |
| slt | R-type | ✅ | Implemented |
| addi | I-type arithmetic | ✅ | Implemented |
| andi | I-type arithmetic | ✅ | Implemented |
| ori | I-type arithmetic | ✅ | Implemented |
| jal | J-Type |✅ | Implemented |

## 3) Missing features / next to implement

| Missing item | Priority | Why it is missing |
|---|---|---|---|
| JAL | High | No jump decoder logic and no J-type immediate support | Add J-type decoding + new PC source logic |
| JALR | High | No instruction support in decoder or control flow | Add JALR decode and PC update path |
| BNE | High | Only BEQ is supported | Add branch control for not-equal |
| BLT | High | Decoder and comparison logic are not implemented | Add signed compare support |
| BGE | High | Same as BLT | Add signed compare support |
| BLTU | High | Unsigned compare not implemented | Add unsigned branch compare support |
| BGEU | High | Unsigned compare not implemented | Add unsigned branch compare support |
| LBU | Medium | Load variant missing | Add data memory byte handling |
| LB | Medium | Load variant missing | Add sign-extension byte support |
| LH | Medium | Load variant missing | Add halfword support |
| LHU | Medium | Load variant missing | Add unsigned halfword support |
| SB | Medium | Store variant missing | Add byte store support |
| SH | Medium | Store variant missing | Add halfword store support |
| sll | Medium | Shift instruction not implemented in ALU | Add shift support |
| srl | Medium | Shift instruction not implemented in ALU | Add shift support |
| sra | Medium | Shift instruction not implemented in ALU | Add shift support |
| sltu | Medium | Unsigned less-than not implemented | Add compare support |
| lui | Medium | U-type immediate format missing | Add U-type decoding |
| auipc | Medium | U-type PC-relative support missing | Add U-type PC logic |
| fence / ecall / ebreak | Low | System instructions not included | Add system opcode handling |
| CSR instructions | Low | Not in scope yet | Future extension |
| multiplication | Low | ALU does not support MUL/DIV family | Add dedicated arithmetic unit |
| division | Low | ALU does not support DIV/REM family | Add dedicated arithmetic unit |
| pipeline hazards | Low | Single-cycle CPU only | Add forwarding / stalling for pipelining |

## 4) Current architectural status

The current design is a minimal single-cycle RISC-V CPU focused on core arithmetic and memory access.

It supports:
- register reads/writes
- PC incrementing
- immediate decoding for I/S/B types
- data memory access
- basic ALU operations
- branch control for BEQ

It does not yet support a full RV32I instruction set.

## 5) Recommended implementation order

1. Add JAL and JALR support
2. Add BNE, BLT, BGE, BLTU, BGEU
3. Add shift instructions (SLL, SRL, SRA)
4. Add remaining load/store variants (LB, LH, LBU, LHU, SB, SH)
5. Add U-type instructions (LUI, AUIPC)
6. Add full RV32I compliance pass
7. Add pipeline hazard handling 

## 6) Notes for future work

- The main decoder in src/Control_unit.v is the main gate for instruction support.
- The ALU in src/alu.v is the main gate for arithmetic/logic support.
- Sign extension in src/sign_extend.v currently handles only I/S/B types; U/J support will need expansion.
- The branch path in src/Top_cpu.v is currently limited to BEQ-style behavior.

## 7) checklist for tracking progress

- [Done ] JAL : saves PC+4 in Rd then jumps to pc + 21 bits sign extended immediate, connected the PCPlus4 to the writing register multiplexeur, updated the controlu unit to hand J instructions.
- [ ] JALR
- [ ] BNE
- [ ] BLT
- [ ] BGE
- [ ] BLTU
- [ ] BGEU
- [ ] LB
- [ ] LH
- [ ] LBU
- [ ] LHU
- [ ] SB
- [ ] SH
- [ ] SLL
- [ ] SRL
- [ ] SRA
- [ ] SLTU
- [ Done] LUI : loads imediate in uperhalf of the register
- [ ] AUIPC
- [ ] Fence / system instructions
- [ ] Full RV32I validation

## 8) Useful links

- src/Top_cpu.v
- src/Control_unit.v
- src/alu.v
- src/sign_extend.v
- src/register_file.v
- src/Pc.v
- src/data_memory.v
- src/instruction_memory.v


## 9) pipeline design :
- Added the necessary register
- test out without the hazard unit
- add the hazard unit logic
- added the forwarding units
- tested the cpu with a complete assembly program expected result calculated by hand to determine if it passes the pipeline test or not
- TEST succeded