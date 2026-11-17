// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : alu_gate_rv32i.v
// Deskripsi : Implementasi sublok gate pada ALU

module alu_gate_rv32i(
    input [31:0] in1,
    input [31:0] in2,
    input [1:0] type,
    output reg [31:0] out
);

always @(*) begin
    case (type)
    2'b00: out = in1 ^ in2;
    2'b01: out = in1 | in2;
    2'b10: out = in1 & in2;
    default: out = 32'd0;
    endcase
end

endmodule