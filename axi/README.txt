AXI-Stream pipeline.
This change was implemented in: TopLevelModule, UART_rx, UART_tx.

FIFO with 32 entries.
Added in: CommandBuffer.vhd.

Double buffering with two independent FIFOs.
Added in: CommandBuffer.vhd.

Full AXI-Stream handshaking using tvalid, tready and tdata.
Implemented in: UART_rx, UART_tx, Serialiser, ShiftRegister, CommandBuffer, TopLevelModule.

All modules connected in a continuous dataflow system.
Also done in: TopLevelModule + CommandBuffer.