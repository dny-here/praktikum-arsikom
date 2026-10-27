// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : data_mem_rv32i.v
// Deskripsi : Implementasi Data Memory 256 x 32-bit

module data_mem_rv32i (
    input wire clock,
    input wire cu_store,
    input wire [1:0] cu_storetype,
    input wire [31:0] dmem_addr,
    input wire [31:0] rs2,
    output wire [31:0] dmem_out
);

 reg [31:0] mem [0:255];
 wire [7:0] waddr = dmem_addr[9:2];
 integer i;

 initial begin
    for(i = 0; i < 256; i = i + 1) begin
        mem[i] = 32'h0000000;
    end

    // For some distinct pattern
    mem[0] = 32'hAABBCCDD;
    mem[1] = 32'h11223344;
 end
 
 always @(negedge clock) begin
 if (cu_store) begin
    case(cu_storetype)
    // SB (Store-Byte)
    2'b00:
    case(dmem_addr[1:0])
        2'b00: mem[waddr][7:0] <= rs2[7:0];
        2'b01: mem[waddr][15:8] <= rs2[7:0];
        2'b10: mem[waddr][23:16] <= rs2[7:0];
        2'b11: mem[waddr][31:24] <= rs2[7:0];
    endcase

    // SH (Store Halfword)
    2'b01:
    case(dmem_addr[1])
        1'b0: mem[waddr][15:0] <= rs2[15:0];
        1'b1: mem[waddr][31:16] <= rs2[15:0];
    endcase

    // SW (Store Word)
    2'b10:
    mem[waddr][31:0] <= rs2[31:0];
    endcase
 end
 end
 
 assign dmem_out = mem[waddr];
endmodule
