module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		        output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);
    wire [2:0]  Rn = ir[10:8];
    wire [2:0]  Rd = ir[7:5];
    wire [2:0]  Rm = ir[2:0];
    wire [7:0]  imm8 = ir[7:0];
    wire [4:0]  imm5 = ir[4:0];

    reg [2:0]  sel_out;

    assign r_addr = sel_out;
    assign w_addr = sel_out;
    assign shift_op = ir[4:3];
    assign sximm8 = 16'(signed'(ir[7:0]));
    assign sximm5 = 16'(signed'(ir[4:0]));
    assign ALU_op = ir[12:11];
    assign opcode = ir[15:13];

    always_comb begin : registerSelect
        case (reg_sel)
              2'b00: sel_out = Rm;
              2'b01: sel_out = Rd;
              2'b10: sel_out = Rn;
            default: sel_out = Rn;
        endcase
    end
endmodule: idecoder
