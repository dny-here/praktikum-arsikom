// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : alu_adder_rv32i.v
// Deskripsi : Implementasi sublok adder pada ALU

module alu_adder_rv32i(
    input [31:0] in1,
    input [31:0] in2,
    input type,
    output [31:0] out
);

assign out = (type == 1'b0) ? in1 + in2 : in1 - in2;

endmodule