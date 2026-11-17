// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_multiplexer4_to_1.v
// Deskripsi : Testbench untuk multiplexer 4 to 1 sebesar 32-bit

`timescale 1ns / 1ps

module tb_multiplexer4_to_1;

    // Inputs (dideklarasikan sebagai reg karena diberi nilai di dalam blok initial)
    reg [31:0] W;
    reg [31:0] X;
    reg [31:0] Y;
    reg [31:0] Z;
    reg [1:0]  sel;

    // Outputs (dideklarasikan sebagai wire)
    wire [31:0] D;

    // Instansiasi Unit Under Test (UUT)
    multiplexer4_to_1 uut (
        .W(W),
        .X(X),
        .Y(Y),
        .Z(Z),
        .sel(sel),
        .D(D)
    );

    initial begin
        // Opsional: Untuk melihat waveform di GTKWave / Icarus Verilog
        $dumpfile("tb_multiplexer4_to_1.vcd");
        $dumpvars(0, tb_multiplexer4_to_1);

        // Monitor perubahan sinyal di console
        $monitor("Time=%0t ns | sel=%b | W=%h X=%h Y=%h Z=%h | D=%h", 
                  $time, sel, W, X, Y, Z, D);

        // Inisialisasi nilai awal input
        W   = 32'hAAAA_AAAA;
        X   = 32'h5555_5555;
        Y   = 32'hF0F0_F0F0;
        Z   = 32'h1234_5678;
        sel = 2'b00;
        #10; // Tunggu 10 ns (D seharusnya bernilai W = AAAA_AAAA)

        // Uji sel = 01
        sel = 2'b01;
        #10; // D seharusnya bernilai X = 5555_5555

        // Uji sel = 10
        sel = 2'b10;
        #10; // D seharusnya bernilai Y = F0F0_F0F0

        // Uji sel = 11
        sel = 2'b11;
        #10; // D seharusnya bernilai Z = 1234_5678

        // Uji perubahan nilai data saat sel tetap di 11 (Z)
        Z   = 32'hDEAD_BEEF;
        #10; // D seharusnya langsung berubah menjadi DEAD_BEEF

        // Kembali ke sel = 00 dengan nilai W baru
        W   = 32'hFFFF_0000;
        sel = 2'b00;
        #10; // D seharusnya bernilai FFFF_0000

        $finish;
    end

endmodule