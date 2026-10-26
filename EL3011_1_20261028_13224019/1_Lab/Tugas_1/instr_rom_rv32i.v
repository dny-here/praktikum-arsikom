// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : instr_rom_rv32i.v
// Deskripsi : Instruction ROM 32x32 Single-Cycle RISC-V (RV32I)

module instr_rom_rv32i (
 input wire [31:0] ADDR, // byte address dari PC
 input wire clock,
 input wire reset,
 output reg [31:0] INSTR // instruksi 32-bit
);

 // 32 word x 32-bit
 reg [31:0] mem [0:31];
 // Word index = PC[6:2] (bit [1:0] = 2'b00)
 wire [4:0] waddr = ADDR[6:2];
 integer i;


 initial begin
    for (i = 0; i < 32; i = i + 1) mem[i] = 32'h00000013;
    mem[0] = 32'h00100293; 
    mem[1] = 32'h00000313; 
    mem[2] = 32'h00A00393; 
    mem[3] = 32'h0053C863; 
    mem[4] = 32'h00530333;
    mem[5] = 32'h00128293;
    mem[6] = 32'hFF5FF06F;
    mem[7] = 32'h00000513;
 end

 // Baca sinkron; reset keluarkan NOP
 always @(posedge clock or posedge reset) begin
    if (reset) INSTR <= 32'h00000013; // NOP RV32I
    else INSTR <= mem[waddr];
 end
endmodule