// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 21 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : pc_4_adder_rv32i.v
// Deskripsi : Implementasi 4-Adder Program Counter RISC-V di Verilog
module pc_4_adder_rv32i(
    input   [31:0] PC_old,
    output  [31:0] PC_4_add
);

assign PC_4_add = PC_old + 4;

endmodule