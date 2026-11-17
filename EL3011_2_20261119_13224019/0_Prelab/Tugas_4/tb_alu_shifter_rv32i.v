// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_alu_shifter_rv32i.v
// Deskripsi : Testbench untuk subblok shifter (SLL, SRL, SRA) pada ALU RV32I

`timescale 1ns / 1ps

module tb_alu_shifter_rv32i;

    // Inputs
    reg [31:0] in;
    reg [31:0] shamt;
    reg [1:0]  type;

    // Outputs
    wire [31:0] out;

    // Instansiasi Unit Under Test (UUT)
    alu_shifter_rv32i uut (
        .in(in),
        .shamt(shamt),
        .type(type),
        .out(out)
    );

    initial begin
        // Opsional: Untuk melihat waveform di GTKWave / Icarus Verilog
        $dumpfile("tb_alu_shifter_rv32i.vcd");
        $dumpvars(0, tb_alu_shifter_rv32i);

        // Monitor perubahan sinyal di console
        $monitor("Time=%0t ns | type=%b | shamt=%2d | in=%h | out=%h", 
                  $time, type, shamt, in, out);

        // --- Set Data Uji 1: Bilangan dengan MSB = 1 (Negatif dalam Signed) ---
        // Memudahkan pengamatan perbedaan antara SRL (isi 0) dan SRA (isi 1)
        in    = 32'hF000_0008;
        shamt = 32'd4;

        // 1. Uji Shift Left Logical / SLL (type = 00): F000_0008 << 4 = 0000_0080
        type = 2'b00;
        #10;

        // 2. Uji Shift Right Logical / SRL (type = 01): F000_0008 >> 4 = 0F00_0000
        type = 2'b01;
        #10;

        // 3. Uji Shift Right Arithmetic / SRA (type = 10): F000_0008 >>> 4 = FF00_0000
        type = 2'b10;
        #10;

        // --- Set Data Uji 2: Bilangan dengan MSB = 0 (Positif dalam Signed) ---
        in    = 32'h7000_0080;
        shamt = 32'd8;

        // 4. Uji SLL (type = 00): 7000_0080 << 8 = 0000_8000
        type = 2'b00;
        #10;

        // 5. Uji SRL (type = 01): 7000_0080 >> 8 = 0070_0000
        type = 2'b01;
        #10;

        // 6. Uji SRA (type = 10) pada bilangan positif: 7000_0080 >>> 8 = 0070_0000 (sama dengan SRL)
        type = 2'b10;
        #10;

        // --- Set Data Uji 3: Pergeseran 0 bit & Pergeseran Ekstrem (31 bit) ---
        in    = 32'h8000_0001;
        shamt = 32'd0;
        type  = 2'b00; // Geser 0 bit: hasil tetap 8000_0001
        #10;

        shamt = 32'd31;
        type  = 2'b10; // SRA 31 bit pada MSB=1: hasil harus FFFF_FFFF
        #10;

        $finish;
    end

endmodule