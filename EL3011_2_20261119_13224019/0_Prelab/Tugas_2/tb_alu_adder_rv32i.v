// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_alu_adder_rv32i.v
// Deskripsi : Testbench untuk subblok adder/subtractor pada ALU RV32I

`timescale 1ns / 1ps

module tb_alu_adder_rv32i;

    // Inputs
    reg [31:0] in1;
    reg [31:0] in2;
    reg        type;

    // Outputs
    wire [31:0] out;

    // Intermediate signed wires untuk $monitor di Icarus Verilog (vvp)
    wire signed [31:0] in1_signed = in1;
    wire signed [31:0] in2_signed = in2;
    wire signed [31:0] out_signed = out;

    // Instansiasi Unit Under Test (UUT)
    alu_adder_rv32i uut (
        .in1(in1),
        .in2(in2),
        .type(type),
        .out(out)
    );

    initial begin
        // Untuk melihat waveform di GTKWave / Icarus Verilog
        $dumpfile("tb_alu_adder_rv32i.vcd");
        $dumpvars(0, tb_alu_adder_rv32i);

        // Gunakan intermediate wire (in1_signed, in2_signed, out_signed)
        $monitor("Time=%0t ns | type=%b | in1=%h (%0d) | in2=%h (%0d) | out=%h (%0d)", 
                  $time, type, in1, in1_signed, in2, in2_signed, out, out_signed);

        // 1. Uji Penjumlahan Dasar (type = 0): 15 + 10 = 25
        in1  = 32'd15;
        in2  = 32'd10;
        type = 1'b0;
        #10;

        // 2. Uji Pengurangan Dasar (type = 1): 15 - 10 = 5
        type = 1'b1;
        #10;

        // 3. Uji Pengurangan Hasil Negatif (type = 1): 10 - 25 = -15 (32'hFFFF_FFF1)
        in1  = 32'd10;
        in2  = 32'd25;
        type = 1'b1;
        #10;

        // 4. Uji Penjumlahan dengan Bilangan Negatif (type = 0): -15 + 20 = 5
        in1  = -32'd15; // 32'hFFFF_FFF1
        in2  = 32'd20;
        type = 1'b0;
        #10;

        // 5. Uji Penjumlahan Nilai Besar / Overflow (type = 0): FFFF_FFFF + 1 = 0000_0000
        in1  = 32'hFFFF_FFFF;
        in2  = 32'h0000_0001;
        type = 1'b0;
        #10;

        // 6. Uji Pengurangan Nilai Identik (type = 1): A5A5_A5A5 - A5A5_A5A5 = 0
        in1  = 32'hA5A5_A5A5;
        in2  = 32'hA5A5_A5A5;
        type = 1'b1;
        #10;

        $finish;
    end

endmodule