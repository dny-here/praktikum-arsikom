// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_brancher_rv32i.v
// Deskripsi : Testbench untuk modul brancher (BEQ, BNE, BLT, BGE, BLTU, BGEU) pada RV32I

`timescale 1ns / 1ps

module tb_brancher_rv32i;

    // Inputs
    reg [31:0]        PC_new;
    reg [31:0]        PC_branch;
    reg signed [31:0] in1;
    reg signed [31:0] in2;
    reg               cu_branch;
    reg [2:0]         cu_branchtype;

    // Outputs
    wire [31:0] PC_in;

    // Instansiasi Unit Under Test (UUT)
    brancher_rv32i uut (
        .PC_new(PC_new),
        .PC_branch(PC_branch),
        .in1(in1),
        .in2(in2),
        .cu_branch(cu_branch),
        .cu_branchtype(cu_branchtype),
        .PC_in(PC_in)
    );

    initial begin
        // Opsional: Untuk melihat waveform di GTKWave / Icarus Verilog
        $dumpfile("tb_brancher_rv32i.vcd");
        $dumpvars(0, tb_brancher_rv32i);

        // Monitor perubahan sinyal di console
        $monitor("Time=%0t ns | en=%b | type=%b | in1=%0d (%h) | in2=%0d (%h) | PC_in=%h", 
                  $time, cu_branch, cu_branchtype, in1, in1, in2, in2, PC_in);

        // Inisialisasi alamat PC_new (PC+4) dan PC_branch (PC+imm)
        PC_new    = 32'h0000_0004;
        PC_branch = 32'h0000_0020;

        // --- 1. Uji Saat Branch Tidak Aktif (cu_branch = 0) ---
        cu_branch     = 1'b0;
        cu_branchtype = 3'b000; // BEQ
        in1           = 32'd10;
        in2           = 32'd10; // Walaupun in1 == in2, PC_in harus tetap PC_new (0000_0004)
        #10;

        // Aktifkan cu_branch untuk pengujian instruksi B-type berikutnya
        cu_branch = 1'b1;

        // --- 2. Uji Data Sama: in1 = 15, in2 = 15 ---
        in1 = 32'd15;
        in2 = 32'd15;

        cu_branchtype = 3'b000; #10; // BEQ  (15 == 15) -> Taken (PC_branch: 0000_0020)
        cu_branchtype = 3'b001; #10; // BNE  (15 != 15) -> Not Taken (PC_new: 0000_0004)
        cu_branchtype = 3'b010; #10; // BLT  (15 < 15)  -> Not Taken (PC_new: 0000_0004)
        cu_branchtype = 3'b011; #10; // BGE  (15 >= 15) -> Taken (PC_branch: 0000_0020)
        cu_branchtype = 3'b100; #10; // BLTU (15 < 15)  -> Not Taken (PC_new: 0000_0004)
        cu_branchtype = 3'b101; #10; // BGEU (15 >= 15) -> Taken (PC_branch: 0000_0020)

        // --- 3. Uji Kasus Kritis Signed vs Unsigned: in1 = -5 (FFFF_FFFB), in2 = 10 (0000_000A) ---
        // Secara Signed   : -5 < 10
        // Secara Unsigned : 32'hFFFF_FFFB > 32'h0000_000A
        in1 = -32'sd5;
        in2 = 32'sd10;

        cu_branchtype = 3'b000; #10; // BEQ  (-5 == 10) -> Not Taken (0000_0004)
        cu_branchtype = 3'b001; #10; // BNE  (-5 != 10) -> Taken (0000_0020)
        cu_branchtype = 3'b010; #10; // BLT  (-5 < 10)  -> Taken (0000_0020)
        cu_branchtype = 3'b011; #10; // BGE  (-5 >= 10) -> Not Taken (0000_0004)
        cu_branchtype = 3'b100; #10; // BLTU (FFFF_FFFB < 10)  -> Not Taken (0000_0004)
        cu_branchtype = 3'b101; #10; // BGEU (FFFF_FFFB >= 10) -> Taken (0000_0020)

        // --- 4. Uji in1 > in2 Positif: in1 = 25, in2 = 10 ---
        in1 = 32'sd25;
        in2 = 32'sd10;

        cu_branchtype = 3'b010; #10; // BLT  (25 < 10)  -> Not Taken (0000_0004)
        cu_branchtype = 3'b011; #10; // BGE  (25 >= 10) -> Taken (0000_0020)
        cu_branchtype = 3'b100; #10; // BLTU (25 < 10)  -> Not Taken (0000_0004)
        cu_branchtype = 3'b101; #10; // BGEU (25 >= 10) -> Taken (0000_0020)

        // --- 5. Uji Default Case (cu_branchtype tidak valid = 3'b111) ---
        cu_branchtype = 3'b111; #10; // Default -> Not Taken (PC_new: 0000_0004)

        $finish;
    end

endmodule