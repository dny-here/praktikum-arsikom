// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_load_select_rv32i.v
// Deskripsi : Testbench untuk modul load select (LB, LH, LW, LBU, LHU) pada RV32I

`timescale 1ns / 1ps

module tb_load_select_rv32i;

    // Inputs
    reg [31:0] dmem_out;
    reg [2:0]  cu_loadtype;

    // Outputs
    wire [31:0] load_out;

    // Instansiasi Unit Under Test (UUT)
    load_select_rv32i uut (
        .dmem_out(dmem_out),
        .cu_loadtype(cu_loadtype),
        .load_out(load_out)
    );

    initial begin
        // Opsional: Untuk melihat waveform di GTKWave / Icarus Verilog
        $dumpfile("tb_load_select_rv32i.vcd");
        $dumpvars(0, tb_load_select_rv32i);

        // Monitor perubahan sinyal di console
        $monitor("Time=%0t ns | cu_loadtype=%b | dmem_out=%h | load_out=%h", 
                  $time, cu_loadtype, dmem_out, load_out);

        // --- Set Data Uji 1: Byte & Halfword memiliki MSB = 1 (Negatif dalam Signed) ---
        // dmem_out[7:0]  = 8'hA5    (bit 7 = 1)
        // dmem_out[15:0] = 16'h80A5 (bit 15 = 1)
        dmem_out = 32'h1234_80A5;

        // 1. Uji LB / Load Byte Signed (000): Sign-extend bit 7 (1) -> FFFF_FFA5
        cu_loadtype = 3'b000;
        #10;

        // 2. Uji LH / Load Halfword Signed (001): Sign-extend bit 15 (1) -> FFFF_80A5
        cu_loadtype = 3'b001;
        #10;

        // 3. Uji LW / Load Word (010): Full 32-bit -> 1234_80A5
        cu_loadtype = 3'b010;
        #10;

        // 4. Uji LBU / Load Byte Unsigned (011): Zero-extend 24-bit -> 0000_00A5
        cu_loadtype = 3'b011;
        #10;

        // 5. Uji LHU / Load Halfword Unsigned (100): Zero-extend 16-bit -> 0000_80A5
        cu_loadtype = 3'b100;
        #10;

        // --- Set Data Uji 2: Byte & Halfword memiliki MSB = 0 (Positif dalam Signed) ---
        // dmem_out[7:0]  = 8'h7F    (bit 7 = 0)
        // dmem_out[15:0] = 16'h7F7F (bit 15 = 0)
        dmem_out = 32'hDEAD_7F7F;

        // 6. Uji LB (000): Sign-extend bit 7 (0) -> 0000_007F
        cu_loadtype = 3'b000;
        #10;

        // 7. Uji LH (001): Sign-extend bit 15 (0) -> 0000_7F7F
        cu_loadtype = 3'b001;
        #10;

        // 8. Uji LW (010): Full 32-bit -> DEAD_7F7F
        cu_loadtype = 3'b010;
        #10;

        // 9. Uji LBU (011): Zero-extend -> 0000_007F
        cu_loadtype = 3'b011;
        #10;

        // 10. Uji LHU (100): Zero-extend -> 0000_7F7F
        cu_loadtype = 3'b100;
        #10;

        $finish;
    end

endmodule