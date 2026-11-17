// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_imm_select_rv32i.v
// Deskripsi : Testbench untuk Immediate Selector (I, S, B, U, J-type) pada RV32I

`timescale 1ns / 1ps

module tb_imm_select_rv32i;

    // Inputs
    reg [31:7] trimmed_instr;
    reg [2:0]  cu_immtype;

    // Outputs
    wire [31:0] imm;

    // Variabel bantu 32-bit penuh agar mudah menguji instruksi RV32I utuh
    reg [31:0] full_instr;

    // Intermediate signed wire untuk $monitor di Icarus Verilog (vvp)
    wire signed [31:0] imm_signed = imm;

    // Instansiasi Unit Under Test (UUT)
    imm_select_rv32i uut (
        .trimmed_instr(trimmed_instr),
        .cu_immtype(cu_immtype),
        .imm(imm)
    );

    initial begin
        // Untuk melihat waveform di GTKWave / Icarus Verilog
        $dumpfile("tb_imm_select_rv32i.vcd");
        $dumpvars(0, tb_imm_select_rv32i);

        // Gunakan intermediate wire (imm_signed)
        $monitor("Time=%0t ns | cu_immtype=%b | full_instr=%h | imm=%h (signed: %0d)", 
                  $time, cu_immtype, full_instr, imm, imm_signed);

        // =================================================================
        // 1. UJI I-TYPE (cu_immtype = 3'b000)
        // =================================================================
        cu_immtype = 3'b000;

        // a. I-Type Positif: imm[11:0] = 12'h123 (291) -> Expected: 0000_0123 (291)
        full_instr    = 32'h1230_0093; // addi x1, x0, 0x123
        trimmed_instr = full_instr[31:7];
        #10;

        // b. I-Type Negatif: imm[11:0] = 12'hFF0 (-16) -> Expected: FFFF_FFF0 (-16)
        full_instr    = 32'hFF00_0093; // addi x1, x0, -16
        trimmed_instr = full_instr[31:7];
        #10;

        // =================================================================
        // 2. UJI S-TYPE (cu_immtype = 3'b001)
        // =================================================================
        cu_immtype = 3'b001;

        // a. S-Type Positif: 36 -> Expected: 0000_0024 (36)
        full_instr    = {7'b0000001, 5'd2, 5'd1, 3'b010, 5'b00100, 7'b0100011}; // sw x2, 36(x1)
        trimmed_instr = full_instr[31:7];
        #10;

        // b. S-Type Negatif: -8 -> Expected: FFFF_FFF8 (-8)
        full_instr    = {7'b1111111, 5'd2, 5'd1, 3'b010, 5'b11000, 7'b0100011}; // sw x2, -8(x1)
        trimmed_instr = full_instr[31:7];
        #10;

        // =================================================================
        // 3. UJI B-TYPE (cu_immtype = 3'b010)
        // =================================================================
        cu_immtype = 3'b010;

        // a. B-Type Positif: +16 -> Expected: 0000_0010 (16)
        full_instr    = {1'b0, 6'b000000, 5'd2, 5'd1, 3'b000, 4'b1000, 1'b0, 7'b1100011};
        trimmed_instr = full_instr[31:7];
        #10;

        // b. B-Type Negatif: -12 -> Expected: FFFF_FFF4 (-12)
        full_instr    = {1'b1, 6'b111111, 5'd2, 5'd1, 3'b000, 4'b0010, 1'b1, 7'b1100011};
        trimmed_instr = full_instr[31:7];
        #10;

        // =================================================================
        // 4. UJI U-TYPE (cu_immtype = 3'b011)
        // =================================================================
        cu_immtype = 3'b011;

        // a. U-Type: 20'h12345 -> Expected: 1234_5000
        full_instr    = 32'h1234_50B7; // lui x1, 0x12345
        trimmed_instr = full_instr[31:7];
        #10;

        // b. U-Type MSB=1: 20'hDEADB -> Expected: DEAD_B000
        full_instr    = 32'hDEAD_B0B7; // lui x1, 0xDEADB
        trimmed_instr = full_instr[31:7];
        #10;

        // =================================================================
        // 5. UJI J-TYPE (cu_immtype = 3'b100)
        // =================================================================
        cu_immtype = 3'b100;

        // a. J-Type Positif: +32 -> Expected: 0000_0020 (32)
        full_instr    = {1'b0, 10'd16, 1'b0, 8'h00, 5'd1, 7'b1101111}; // jal x1, 32
        trimmed_instr = full_instr[31:7];
        #10;

        // b. J-Type Negatif: -20 -> Expected: FFFF_FFEC (-20)
        full_instr    = {1'b1, 10'b11_1111_0110, 1'b1, 8'hFF, 5'd1, 7'b1101111}; // jal x1, -20
        trimmed_instr = full_instr[31:7];
        #10;

        // =================================================================
        // 6. UJI DEFAULT CASE (cu_immtype = 3'b111)
        // =================================================================
        cu_immtype = 3'b111;
        #10; // Expected: 0000_0000

        $finish;
    end

endmodule