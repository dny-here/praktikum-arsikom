// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_multiplexer2_to_1.v
// Deskripsi : Testbench untuk Multiplexer 2:1 berukuran 32 bit dalam Verilog

`timescale 1ns/1ps
module tb_mux2_to_1_rv32i;
    reg  [31:0] A, B;
    reg         selector;
    wire [31:0] D;
    integer     errors = 0;

    mux2_to_1_rv32i dut (.A(A), .B(B), .selector(selector), .D(D));

    task apply(input [31:0] a, input [31:0] b, input s);
        begin
            A = a; B = b; 
            selector = s; 
            #10;
            if (D !== (s ? b : a)) begin
                errors = errors + 1;
                $display("FAIL t=%0t sel=%b A=%h B=%h D=%h expected=%h", $time, s, a, b, D, (s ? b : a));
            end else
                $display("ok   t=%0t sel=%b D=%h", $time, s, D);
            #10;
        end
    endtask

    initial begin
        apply(32'hAAAA_AAAA, 32'h5555_5555, 1'b0);
        apply(32'hAAAA_AAAA, 32'h5555_5555, 1'b1);
        apply(32'h1234_5678, 32'h5555_5555, 1'b0);
        apply(32'h1234_5678, 32'hDEAD_BEEF, 1'b1);
        apply(32'h0000_0000, 32'hFFFF_FFFF, 1'b1);
        apply(32'h0000_0000, 32'hFFFF_FFFF, 1'b0);
        
        if (errors == 0) $display("PASS");
        else             $display("FAIL: %0d kesalahan", errors);
        $stop;
    end
endmodule