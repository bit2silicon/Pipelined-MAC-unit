# Pipelined MAC Unit — FPGA Implementation on Zynq ZC706

A parameterized, pipelined Multiply-Accumulate (MAC) unit implemented in Verilog and verified on a Xilinx Zynq-7000 ZC706 board using Vivado ILA.

---

## Overview

A MAC unit computes:

```
result = result + (a × b)
```

This project implements a **2-stage pipelined** version of the MAC and compares it against a non-pipelined baseline to demonstrate the frequency improvement from pipeline stage insertion.

| Feature           | Details                          |
| ----------------- | -------------------------------- |
| Device            | Xilinx Zynq-7000 XC7Z045 (ZC706) |
| Input Width       | 16-bit (parameterized)           |
| Accumulator Width | 40-bit (parameterized)           |
| Pipeline Stages   | 2                                |
| Clock             | 200MHz differential (IBUFDS)     |
| Verification      | Simulation + On-chip ILA         |

---

## Architecture

### Non-Pipelined MAC

Both multiply and accumulate happen in a single clock cycle. The critical path is:

```
Multiply (a×b) → Add to accumulator → Register
```

This limits maximum operating frequency.

### Pipelined MAC

The datapath is split into two stages with a pipeline register between them:

```
Stage 1: product_reg <= a × b          (multiply only)
Stage 2: result <= result + product_reg (accumulate only)
```

Each stage has half the combinational delay of the non-pipelined version, allowing a higher clock frequency. A `valid_s1` register propagates the valid signal through the pipeline alongside the data.

```
        ┌─────────┐    product_reg    ┌─────────────┐
a,b ───>│ Multiply│─────────────────>│  Accumulate │───> result
        └─────────┘                  └─────────────┘
valid_in──> valid_s1 ─────────────────────────────────> valid_out
```

**Latency:** 2 clock cycles from input to valid output.
**Throughput:** 1 result per clock cycle after initial latency.

---

## Parameters

| Parameter    | Default | Description                               |
| ------------ | ------- | ----------------------------------------- |
| INPUT_WIDTH  | 16      | Width of inputs a and b                   |
| PROD_WIDTH   | 32      | Width of product register (2×INPUT_WIDTH) |
| RESULT_WIDTH | 40      | Width of accumulator                      |

---

## Timing Results

Both designs synthesized and implemented on XC7Z045 with `use_dsp = "no"` to force LUT-based implementation.

| Design        | Constraint   | WNS      | Max Frequency |
| ------------- | ------------ | -------- | ------------- |
| Pipelined     | 2ns (500MHz) | +0.149ns | **540 MHz**   |
| Non-Pipelined | 2ns (500MHz) | -0.153ns | **464 MHz**   |

The pipelined design achieves **540MHz vs 464MHz** — a 16% frequency improvement by splitting the multiply-accumulate critical path into two pipeline stages.

At larger bit widths or in ASIC implementation (without optimized DSP blocks), the improvement is more significant — the multiply and accumulate paths scale differently with bit width, making pipelining essential at 32-bit and above.

---

## Hardware Verification — Vivado ILA

The design was verified on ZC706 hardware using Vivado Integrated Logic Analyzer (ILA).

### ILA Probe Configuration

| Probe  | Signal    | Width  |
| ------ | --------- | ------ |
| probe0 | a         | 16-bit |
| probe1 | b         | 16-bit |
| probe2 | valid_in  | 1-bit  |
| probe3 | valid_out | 1-bit  |
| probe4 | result    | 40-bit |
| probe5 | saturated | 1-bit  |

### Observations

- Counter drives a and b — values increment every clock cycle
- valid_in held high via button latch — MAC accumulates continuously
- result[39:0] updates every cycle, confirmed nonzero and growing
- valid_out confirmed high when accumulation is active
- 2-cycle pipeline latency observable between valid_in assertion and valid_out assertion

---

## Key Concepts Demonstrated

- **Pipeline stage insertion** — splitting critical path to improve Fmax
- **Valid signal propagation** — valid_s1 register tracks data through pipeline
- **Parameterized RTL** — configurable input and accumulator widths
- **On-chip debug** — Vivado ILA for hardware signal observation
- **Differential clock input** — IBUFDS instantiation for ZC706 200MHz clock
- **FPGA timing analysis** — WNS-based Fmax calculation

---

## Tools

- Vivado 2023.2
- Xilinx Zynq-7000 ZC706 Evaluation Board
- Verilog HDL
