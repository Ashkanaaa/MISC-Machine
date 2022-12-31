module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z);

  reg [15:0] out;
  reg zed;

  assign {ALU_out,Z} = {out,zed};

  always_comb begin 
    case (ALU_op)

      2'b00: out = val_A + val_B;
      2'b01: out = val_A - val_B;
      2'b10: out = val_A & val_B;
      2'b11: out = ~val_B;

      default:out = 16'd2;

    endcase
  end

  always_comb begin
    if(ALU_out == 16'd0)begin
      zed = 1'b1;
    end else begin
      zed = 1'b0;
    end
  end

endmodule: ALU
