// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : alu_shifter_rv32i.v
// Deskripsi : Implementasi sublok shifter pada ALU

module alu_shifter_rv32i(
    input [31:0] in,
    input [31:0] shamt,
    input [1:0] type,
    output reg [31:0] out
);

always @(*) begin
    case (type)
    2'b00: out = in << shamt;
    2'b01: out = in >> shamt;
    2'b10: out = $signed(in) >>> shamt;
    default: out = 32'd0;
    endcase
end

endmodule