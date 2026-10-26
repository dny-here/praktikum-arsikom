// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : pc_rv32i.v
// Deskripsi : Implementasi Program Counter 32 bit RISC-V pada Verilog
module pc_rv32i(
    input       [31:0]  PC_in,
    input               clk,
    input               reset,
    output  reg [31:0]  PC_out
);

always @(posedge clk or posedge reset) begin
    if(reset) begin
        PC_out <= 32'h0;
    end else begin
        PC_out <= PC_in;
    end
end

endmodule