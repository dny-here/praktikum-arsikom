// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_pc_4_adder_rv32i.v
// Deskripsi : Testbench untuk 4-Adder Program Counter RISC-V di Verilog

`timescale 1ns/1ps
module tb_pc_4_adder_rv32i;
    reg  [31:0] PC_old;
    wire [31:0] PC_4_add;
    integer     errors = 0;

    pc_4_adder_rv32i dut (.PC_old(PC_old), .PC_4_add(PC_4_add));

    task apply(input [31:0] pc);
        begin
            PC_old = pc; #10;
            if (PC_4_add !== pc + 32'd4) begin
                errors = errors + 1;
                $display("FAIL PC_old=%h PC_4_add=%h expected=%h", pc, PC_4_add, pc + 32'd4);
            end else
                $display("ok   PC_old=%h PC_4_add=%h", pc, PC_4_add);
            #10;
        end
    endtask

    initial begin
        apply(32'h0000_0000);   
        apply(32'h0000_0004);
        apply(32'h0000_00FC);   
        apply(32'h0000_FFFC);   
        apply(32'h7FFF_FFFC);   
        apply(32'hFFFF_FFFC);   
        
        if (errors == 0) $display("PASS");
        else             $display("FAIL: %0d errors", errors);
        $stop;
    end
endmodule