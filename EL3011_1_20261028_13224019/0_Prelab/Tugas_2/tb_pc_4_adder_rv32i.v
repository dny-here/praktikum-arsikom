// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_pc_4_adder_rv32i.v
// Deskripsi : Testbench untuk 4-Adder Program Counter RISC-V di Verilog
module tb_pc_4_adder_rv32i;

reg     [31:0] PC_old;
wire    [31:0] PC_4_add;
integer i;
integer error;

pc_4_adder_rv32i u0 (
    .PC_old(PC_old),
    .PC_4_add(PC_4_add)
);

task init;
begin
    PC_old <= 0;
    error = 0;
end
endtask

task check;
begin
    if(PC_4_add !== PC_old + 4) begin
        $display("-----------------------------------");
        $display("T=%0t | Output tidak sesuai!", $time);
        $display("T=%0t | PC_old = %d | PC_4_add = %d", $time, PC_old, PC_4_add);
        error = error + 1;
    end else begin
        $display("-----------------------------------");
        $display("T=%0t | Output sesuai!", $time);
        $display("T=%0t | PC_old = %d | PC_4_add = %d", $time,  PC_old, PC_4_add);
    end
end
endtask

task testing;
begin
    for (i = 0; i < 10; i = i + 1) begin
        #10
        PC_old <= $random;
        check;
    end
end
endtask

initial begin
    // Dumpfile for gtkwave
    $dumpfile("pc_4_adder_rv32i.vcd");
    $dumpvars(0, tb_pc_4_adder_rv32i);

    // Testbench checking
    init;
    check;
    testing;

    // Finishing
    $display("Testbench ended with %d error", error);
    $finish;

end


endmodule