// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : pc_4_adder_rv32i.v
// Deskripsi : Implementasi 4-Adder Program Counter RISC-V di Verilog

`timescale 1ns/1ps
module pc_4_adder_rv32i (
    input  wire [31:0] PC_old,   // nilai PC saat ini
    output wire [31:0] PC_4_add  // PC + 4 (alamat instruksi berikutnya)
);
    
    assign PC_4_add = PC_old + 32'd4;

endmodule