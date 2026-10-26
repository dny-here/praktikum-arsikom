// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : data_mem_rv32i.v
// Deskripsi : Template Data Memory 256 x 32-bit

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
 // Isi awal memori untuk pengujian

 initial begin
 ... // Lengkapi inisialisasi
 end
 
 always @(negedge clock) begin
 if (cu_store) begin
 ... // Lengkapi store word, halfword, dan byte
 ... // Gunakan cu_storetype sesuai keluaran CU
 end
 end
 
 assign dmem_out = mem[waddr];
endmodule
