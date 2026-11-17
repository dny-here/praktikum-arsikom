// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_alu_slt_rv32i.v
// Deskripsi : Testbench untuk subblok SLT / SLTU pada ALU RV32I

`timescale 1ns / 1ps

module tb_alu_slt_rv32i;

    // Inputs
    reg [31:0] in1;
    reg [31:0] in2;
    reg        type;

    // Outputs
    wire [31:0] out;

    // Intermediate signed wires untuk $monitor di Icarus Verilog (vvp)
    wire signed [31:0] in1_signed = in1;
    wire signed [31:0] in2_signed = in2;

    // Instansiasi Unit Under Test (UUT)
    alu_slt_rv32i uut (
        .in1(in1),
        .in2(in2),
        .type(type),
        .out(out)
    );

    initial begin
        // Untuk melihat waveform di GTKWave / Icarus Verilog
        $dumpfile("tb_alu_slt_rv32i.vcd");
        $dumpvars(0, tb_alu_slt_rv32i);

        // Gunakan intermediate wire (in1_signed dan in2_signed)
        $monitor("Time=%0t ns | type=%b | in1=%h (signed:%0d) | in2=%h (signed:%0d) | out=%0d", 
                  $time, type, in1, in1_signed, in2, in2_signed, out);

        // --- Set Data Uji 1: Dua Bilangan Positif (in1 < in2) ---
        in1  = 32'd10;
        in2  = 32'd20;

        // 1. Uji SLT (type = 0): 10 < 20 -> out harus 1
        type = 1'b0;
        #10;

        // 2. Uji SLTU (type = 1): 10 < 20 -> out harus 1
        type = 1'b1;
        #10;

        // --- Set Data Uji 2: Dua Bilangan Positif (in1 > in2) ---
        in1  = 32'd50;
        in2  = 32'd25;

        // 3. Uji SLT (type = 0): 50 < 25 (False) -> out harus 0
        type = 1'b0;
        #10;

        // 4. Uji SLTU (type = 1): 50 < 25 (False) -> out harus 0
        type = 1'b1;
        #10;

        // --- Set Data Uji 3: Kasus Kritis! Negatif vs Positif ---
        // in1 = -5 (32'hFFFF_FFFB, unsigned = 4,294,967,291)
        // in2 = 10 (32'h0000_000A, unsigned = 10)
        in1  = -32'd5;
        in2  = 32'd10;

        // 5. Uji SLT Signed (type = 0): -5 < 10 (True) -> out harus 1
        type = 1'b0;
        #10;

        // 6. Uji SLTU Unsigned (type = 1): 32'hFFFF_FFFB < 10 (False) -> out harus 0
        type = 1'b1;
        #10;

        // --- Set Data Uji 4: Dua Bilangan Negatif ---
        // in1 = -20 (32'hFFFF_FFEC), in2 = -5 (32'hFFFF_FFFB)
        in1  = -32'd20;
        in2  = -32'd5;

        // 7. Uji SLT Signed (type = 0): -20 < -5 (True) -> out harus 1
        type = 1'b0;
        #10;

        // 8. Uji SLTU Unsigned (type = 1): FFFF_FFEC < FFFF_FFFB (True) -> out harus 1
        type = 1'b1;
        #10;

        // --- Set Data Uji 5: Nilai Sama (in1 == in2) ---
        in1  = 32'h8000_0000;
        in2  = 32'h8000_0000;
        type = 1'b0; // SLT: harus 0
        #10;
        type = 1'b1; // SLTU: harus 0
        #10;

        $finish;
    end

endmodule