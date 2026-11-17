// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : multiplexer_4_to_1.v
// Deskripsi : Implementasi multiplexer 4 to 1 generik sebesar 32-bit

module multiplexer4_to_1(
    input [31:0] W,
    input [31:0] X,
    input [31:0] Y,
    input [31:0] Z,
    input [1:0] sel,
    output reg [31:0] D
);

always @(*) begin
    case (sel)
    2'b00: D = W;
    2'b01: D = X;
    2'b10: D = Y;
    2'b11: D = Z; 
endcase
end 

endmodule