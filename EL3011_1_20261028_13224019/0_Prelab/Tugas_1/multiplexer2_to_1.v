// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : multiplexer2_to_1.v
// Deskripsi : Implementasi Multiplexer 2:1 berukuran 32 bit dalam Verilog
module multiplexer2_to_1(
    input [31:0] A,
    input [31:0] B,
    input sel,
    output [31:0] D
);

assign D = (sel == 1'b0) ? A : B;

endmodule