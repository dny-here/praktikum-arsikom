// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_alu_rv32i.v
// Deskripsi : Testbench untuk ALU Top Level RV32I

`timescale 1ns / 1ps

module tb_alu_rv32i;

    // Inputs
    reg [31:0] in1;
    reg [31:0] in2;
    reg [1:0]  cu_ALUtype;
    reg        cu_adtype;
    reg [1:0]  cu_gatype;
    reg [1:0]  cu_shiftype;
    reg        cu_sltype;

    // Outputs
    wire [31:0] out;

    // Instansiasi Unit Under Test (UUT)
    alu_rv32i uut (
        .in1(in1),
        .in2(in2),
        .cu_ALUtype(cu_ALUtype),
        .cu_adtype(cu_adtype),
        .cu_gatype(cu_gatype),
        .cu_shiftype(cu_shiftype),
        .cu_sltype(cu_sltype),
        .out(out)
    );

    initial begin
        // Opsional: Untuk melihat waveform di GTKWave / Icarus Verilog
        $dumpfile("tb_alu_rv32i.vcd");
        $dumpvars(0, tb_alu_rv32i);

        // Monitor perubahan sinyal di console
        $monitor("Time=%0t ns | ALUtype=%b | ad=%b ga=%b sh=%b sl=%b | in1=%h | in2=%h | out=%h",
                  $time, cu_ALUtype, cu_adtype, cu_gatype, cu_shiftype, cu_sltype, in1, in2, out);

        // Inisialisasi sinyal kontrol awal
        in1         = 32'd0;
        in2         = 32'd0;
        cu_ALUtype  = 2'b00;
        cu_adtype   = 1'b0;
        cu_gatype   = 2'b00;
        cu_shiftype = 2'b00;
        cu_sltype   = 1'b0;

        // =================================================================
        // 1. UJI SUBBLOK ADDER (cu_ALUtype = 2'b00)
        // =================================================================
        cu_ALUtype = 2'b00;
        in1        = 32'd25;
        in2        = 32'd10;

        // a. ADD (cu_adtype = 0): 25 + 10 = 35 (0000_0023)
        cu_adtype = 1'b0;
        #10;

        // b. SUB (cu_adtype = 1): 25 - 10 = 15 (0000_000F)
        cu_adtype = 1'b1;
        #10;

        // c. SUB Negatif (cu_adtype = 1): 10 - 25 = -15 (FFFF_FFF1)
        in1 = 32'd10;
        in2 = 32'd25;
        #10;

        // =================================================================
        // 2. UJI SUBBLOK GATE LOGIKA (cu_ALUtype = 2'b01)
        // =================================================================
        cu_ALUtype = 2'b01;
        in1        = 32'hFFFF_0000;
        in2        = 32'h00FF_FF00;

        // a. XOR (cu_gatype = 00): FFFF_0000 ^ 00FF_FF00 = FF00_FF00
        cu_gatype = 2'b00;
        #10;

        // b. OR  (cu_gatype = 01): FFFF_0000 | 00FF_FF00 = FFFF_FF00
        cu_gatype = 2'b01;
        #10;

        // c. AND (cu_gatype = 10): FFFF_0000 & 00FF_FF00 = 00FF_0000
        cu_gatype = 2'b10;
        #10;

        // =================================================================
        // 3. UJI SUBBLOK SHIFTER (cu_ALUtype = 2'b10)
        // =================================================================
        cu_ALUtype = 2'b10;
        in1        = 32'hF000_0008; // MSB = 1 (negatif)
        in2        = 32'd4;         // shamt = 4

        // a. SLL (cu_shiftype = 00): F000_0008 << 4 = 0000_0080
        cu_shiftype = 2'b00;
        #10;

        // b. SRL (cu_shiftype = 01): F000_0008 >> 4 = 0F00_0000
        cu_shiftype = 2'b01;
        #10;

        // c. SRA (cu_shiftype = 10): F000_0008 >>> 4 = FF00_0000
        cu_shiftype = 2'b10;
        #10;

        // =================================================================
        // 4. UJI SUBBLOK SLT (cu_ALUtype = 2'b11)
        // =================================================================
        cu_ALUtype = 2'b11;
        in1        = -32'd5; // 32'hFFFF_FFFB (Signed: -5, Unsigned: 4294967291)
        in2        = 32'd10; // 32'h0000_000A (Signed: 10, Unsigned: 10)

        // a. SLT Signed (cu_sltype = 0): -5 < 10 (True) -> out = 0000_0001
        cu_sltype = 1'b0;
        #10;

        // b. SLTU Unsigned (cu_sltype = 1): FFFF_FFFB < 10 (False) -> out = 0000_0000
        cu_sltype = 1'b1;
        #10;

        $finish;
    end

endmodule