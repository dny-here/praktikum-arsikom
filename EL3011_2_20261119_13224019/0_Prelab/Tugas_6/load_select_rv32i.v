// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : 19 November 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : load_select_rv32i.v
// Deskripsi : Implementasi load select

module load_select_rv32i(
    input [31:0] dmem_out,
    input [2:0] cu_loadtype,
    output reg [31:0] load_out
);

always @(*) begin
    case(cu_loadtype)
    3'b000: load_out = {{24{dmem_out[7]}},dmem_out[7:0]};
    3'b001: load_out = {{16{dmem_out[15]}},dmem_out[15:0]};
    3'b010: load_out = dmem_out;
    3'b011: load_out = {24'h000000, dmem_out[7:0]};
    3'b100: load_out = {16'h0000, dmem_out[15:0]};
    default: load_out = 32'd0;
endcase
end

endmodule