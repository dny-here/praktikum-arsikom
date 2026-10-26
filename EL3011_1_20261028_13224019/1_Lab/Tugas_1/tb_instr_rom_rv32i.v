// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_instr_rom_rv32i.v
// Deskripsi : Testbench for Instruction ROM 32x32 Single-Cycle RISC-V (RV32I)
module tb_instr_rom_rv32i;

// Variables for testbench
reg [31:0] ADDR;
reg clock;
reg reset;
wire [31:0] INSTR;
integer i;
integer error;
reg [31:0] mem [0:31];

instr_rom_rv32i u0 (
    .ADDR(ADDR),
    .clock(clock),
    .reset(reset),
    .INSTR(INSTR)
);

always #10 clock = ~clock;

task init;
 begin
    for (i = 0; i < 32; i = i + 1) mem[i] = 32'h00000013;
    mem[0] = 32'h00100293; 
    mem[1] = 32'h00000313; 
    mem[2] = 32'h00A00393; 
    mem[3] = 32'h0053C863; 
    mem[4] = 32'h00530333;
    mem[5] = 32'h00128293;
    mem[6] = 32'hFF5FF06F;
    mem[7] = 32'h00000513;

    clock <= 0;
    reset <= 0;
    ADDR <= 0;
    error = 0;
 end
endtask

task testing;
begin
    for(i = 0; i < 32; i = i + 1) begin
        @(negedge clock);
        reset <= $random;
        ADDR <= i << 2;
        @(negedge clock)
        if(INSTR == mem[i] && reset !== 1'b1) begin
            $display("PASS (address = %h, actual = %h, expected = %h, reset = %h)", ADDR, INSTR, mem[i], reset);
        end else if (INSTR == 32'h00000013 && reset == 1'b1) begin
            $display("PASS (address = %h, actual = %h, expected = %h, reset = %h)", ADDR, INSTR, 32'h00000013, reset);
        end else begin
            $display("FAIL (address = %h, actual = %h, expected = %h, reset = %h)", ADDR, INSTR, mem[i], reset);
            error = error + 1;
        end
    end
end
endtask

initial begin
    $dumpfile("instr_rom_rv32i.vcd");
    $dumpvars(0, tb_instr_rom_rv32i);

    init;
    testing;

    $display("Testbench ended with %d errors", error);
    $finish;
end

 endmodule