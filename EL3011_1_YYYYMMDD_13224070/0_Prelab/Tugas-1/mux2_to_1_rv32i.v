// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : multiplexer2_to_1.v
// Deskripsi : Implementasi Multiplexer 2:1 berukuran 32 bit dalam Verilog

`timescale 1ns/1ps
module mux2_to_1_rv32i (
    input  wire [31:0] A,        //masukan saat selector = 0
    input  wire [31:0] B,        //masukan saat selector = 1
    input  wire        selector, //sinyal pemilih
    output wire [31:0] D         //keluaran
);
    assign D = selector ? B : A;
endmodule