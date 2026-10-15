# Pipelined RISC-V CPU

A Verilog implementation of a simple five-stage RISC-V pipeline: Fetch, Decode,
Execute, Memory, and Writeback. The top-level module connects the datapath,
control logic, register file, and instruction/data memories.

## Design

- `Top_cpu.v` connects the five stages and selects the next PC.
- `pipeline_reg.v` holds values between stages; enables and clears support stalls and flushes.
- `hazard_unit.v` detects load-use hazards and selects forwarding paths. The forwarding muxes are in `demux_result.v`.
- `Control_unit.v`, `alu.v`, and `sign_extend.v` implement instruction decode, arithmetic/logic, and immediate generation.
- `register_file.v`, `instruction_memory.v`, and `data_memory.v` provide register and memory access.

The currently decoded instruction subset includes ADDI, ADD, SUB, AND, OR,
SLT, LW, SW, BEQ, JAL, and LUI. The directed program in
`encoding/program.asm` exercises forwarding, a load-use stall, branches, JAL,
and memory access. Its assembled instructions are in `src/instruction_memory.v`.

## Run The CPU Test

Run the simulation commands from the `vcd_files/` directory:

```bash
cd vcd_files
iverilog -s compare_tb -o pipeline_test ../tb/compare_tb.v ../src/*.v
vvp pipeline_test
```

The test prints a cycle trace and a final register snapshot, then reports
`PIPELINE TEST: PASS` or `PIPELINE TEST: FAIL`.

To regenerate the instruction memory after editing the assembly program, run
this from the project root:

```bash
python3 encoding/riscv_assembler.py encoding/program.asm src/instruction_memory.v
```
Note the test bench only validates the current assembly code hence if you change it the test will fail.

