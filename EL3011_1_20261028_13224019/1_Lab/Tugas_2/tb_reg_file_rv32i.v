// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_reg_file_rv32i.v
// Deskripsi : Testbench untuk register file RISC-V (RV32I) 32×32
// Timescale for simulation
`timescale 1ns/1ps

module tb_reg_file_rv32i;

// Variables for testbenches
reg             cu_rdwrite;
reg             clock;
reg     [4:0]   rs1_addr;
reg     [4:0]   rs2_addr;
reg     [4:0]   rd_addr;
reg     [31:0]  rd_in;
wire    [31:0]  rs1;
wire    [31:0]  rs2;

// 32 x Registers (32-bit)
 reg [31:0] rf [0:31];
 integer i;
 integer error;
 reg [31:0] expected[0:9];

// Initialize the clock
always #10 clock = ~clock;

// Taking the main module to the testbench
reg_file_rv32i u0 (
    .clock(clock),
    .cu_rdwrite(cu_rdwrite),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr),
    .rd_in(rd_in),
    .rs1(rs1),
    .rs2(rs2)
);

task init;
begin
    for (i = 0; i < 32; i = i + 1) begin
        rf[i] = 32'b0;
    end
    cu_rdwrite <= 0;
    clock <= 0;
    rs1_addr <= 0;
    rs2_addr <= 0;
    rd_addr <= 0;
    rd_in <= 0;
    error = 0;
    for (i = 0; i < 10; i = i + 1) begin
        expected[i] = 32'b0;
    end
    expected[1] = 32'h00000011;
    expected[2] = 32'h00000022;
    expected[3] = 32'h00000033;
    expected[4] = 32'h00000044;
end
endtask

task testing;
begin
    @(negedge clock);
    cu_rdwrite <= 1;

    @(negedge clock);
    rd_addr <= 0;
    rd_in <= 32'hFFFFFFFF;

    for(i = 1; i < 5; i = i + 1) begin
        @(negedge clock);
        rd_addr <= i;
        rd_in <= expected[i];
    end
    
    @(negedge clock);
    cu_rdwrite <= 0;

    for(i = 0; i < 10; i = i + 1) begin
        @(negedge clock);  
        rs1_addr <= i;
        @(negedge clock);
        #1;
        if(rs1 !== expected[i]) begin
            $display("-----------------------------------");
            $display("FAIL");
            $display("T = %0t | alamat  = %h | actual = %h | expected = %h", $time, rs1_addr, rs1, expected[i]);
            error = error + 1;
        end else begin
            $display("-----------------------------------");
            $display("PASS");
        end
    end
end
endtask

initial begin
    $dumpfile("reg_file_rv32i.vcd");
    $dumpvars(0, tb_reg_file_rv32i);

    init;
    testing;

    #5
    $display("Testbench selesai dengan %d error", error);
    $finish;
    
end

endmodule