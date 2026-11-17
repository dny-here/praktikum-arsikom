// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_alu_gate_rv32i.v
// Deskripsi : Testbench untuk subblok gate (XOR, OR, AND) pada ALU RV32I

`timescale 1ns / 1ps

module tb_alu_gate_rv32i;

    // Inputs
    reg [31:0] in1;
    reg [31:0] in2;
    reg [1:0]  type;

    // Outputs
    wire [31:0] out;

    // Instansiasi Unit Under Test (UUT)
    alu_gate_rv32i uut (
        .in1(in1),
        .in2(in2),
        .type(type),
        .out(out)
    );

    initial begin
        // Opsional: Untuk melihat waveform di GTKWave / Icarus Verilog
        $dumpfile("tb_alu_gate_rv32i.vcd");
        $dumpvars(0, tb_alu_gate_rv32i);

        // Monitor perubahan sinyal di console
        $monitor("Time=%0t ns | type=%b | in1=%h | in2=%h | out=%h", 
                  $time, type, in1, in2, out);

        // --- Set Data Uji 1: Pola Bit Berselang-seling ---
        in1  = 32'hFFFF_0000;
        in2  = 32'h00FF_FF00;

        // 1. Uji Operasi XOR (type = 00): FFFF_0000 ^ 00FF_FF00 = FF00_FF00
        type = 2'b00;
        #10;

        // 2. Uji Operasi OR (type = 01): FFFF_0000 | 00FF_FF00 = FFFF_FF00
        type = 2'b01;
        #10;

        // 3. Uji Operasi AND (type = 10): FFFF_0000 & 00FF_FF00 = 00FF_0000
        type = 2'b10;
        #10;

        // --- Set Data Uji 2: Pola Bit Komplementer (A5A5 vs 5A5A) ---
        in1  = 32'hA5A5_A5A5;
        in2  = 32'h5A5A_5A5A;

        // 4. Uji XOR (type = 00): A5A5_A5A5 ^ 5A5A_5A5A = FFFF_FFFF
        type = 2'b00;
        #10;

        // 5. Uji OR (type = 01): A5A5_A5A5 | 5A5A_5A5A = FFFF_FFFF
        type = 2'b01;
        #10;

        // 6. Uji AND (type = 10): A5A5_A5A5 & 5A5A_5A5A = 0000_0000
        type = 2'b10;
        #10;

        // --- Set Data Uji 3: Nilai Identik ---
        in1  = 32'h1234_5678;
        in2  = 32'h1234_5678;

        // 7. Uji XOR nilai sama (type = 00): Hasil harus 0000_0000
        type = 2'b00;
        #10;

        $finish;
    end

endmodule