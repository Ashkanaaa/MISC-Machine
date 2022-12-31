module tb_idecoder(output err);

/*module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		        output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);*/
reg [15:0] ir;
reg [1:0] sel;
wire [2:0] opcode;
wire [1:0] alu_op;
wire [1:0] shift_op;
wire [15:0] sximm5;
wire [15:0] sximm8;
wire [2:0] r_addr;
wire [2:0] w_addr;
reg e;
assign err =e;

idecoder dut (.ir(ir),.reg_sel(sel),.opcode(opcode),.ALU_op(alu_op),.shift_op(shift_op),.sximm5(sximm5),.sximm8(sximm8),.r_addr(r_addr), .w_addr(w_addr));

initial begin

#5;
e<=1'b0;
ir<= 16'b1101000000100010;
sel<=2'b10; //selecting Rn which is 000 (r0)
#5;

assert(opcode === 3'b110) $display("[PASS] opcode is correct");
else $error("[FAIL] opcode is not correct");

if( opcode === 3'b110)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(alu_op === 2'b10) $display("[PASS] alu op is correct");
else $error("[FAIL] alu op is not correct");

if(alu_op === 2'b10)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(r_addr === 3'b000 && w_addr === 3'b000) $display("[PASS] selectred register is correct");
else $error("[FAIL] selectred register is not correct");

if(r_addr === 3'b000 && w_addr === 3'b000)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(shift_op === 2'b00) $display("[PASS] shift_op is correct");
else $error("[FAIL] shift_op is not correct");

if(shift_op === 2'b00)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(sximm8 === 16'b0000000000100010) $display("[PASS] sximm8 is correct");
else $error("[FAIL] sximm8 is not correct");

if(sximm8 === 16'b0000000000100010)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(sximm5 === 16'b0000000000000010) $display("[PASS] sximm5 is correct");
else $error("[FAIL] sximm5 is not correct");

if(sximm5 === 16'b0000000000000010)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

sel<=2'b01;//selecting Rd which is 001(r1)
#5;

assert(r_addr === 3'b001 && w_addr === 3'b001) $display("[PASS] selectred register is correct");
else $error("[FAIL] selectred register is not correct");

if(r_addr === 3'b001 && w_addr === 3'b001)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

sel<=2'b00;//selecting Rm which is 010(r2)
#5;

assert(r_addr === 3'b010 && w_addr === 3'b010) $display("[PASS] selectred register is correct");
else $error("[FAIL] selectred register is not correct");

if(r_addr === 3'b010 && w_addr === 3'b010)begin
e<=e;
end else begin
e<=1'b1;
end

#5;



///////////////////////////
ir<= 16'b1010001000111000;
sel<=2'b10; //selecting Rn which is 010(r2)
#5;


assert(opcode === 3'b101) $display("[PASS] opcode is correct");
else $error("[FAIL] opcode is not correct");

if( opcode === 3'b101)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(alu_op === 2'b00) $display("[PASS] alu op is correct");
else $error("[FAIL] alu op is not correct");

if(alu_op === 2'b00)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(r_addr === 3'b010 && w_addr === 3'b010) $display("[PASS] selectred register is correct");
else $error("[FAIL] selectred register is not correct");

if(r_addr === 3'b010 && w_addr === 3'b010)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(shift_op === 2'b11) $display("[PASS] shift_op is correct");
else $error("[FAIL] shift_op is not correct");

if(shift_op === 2'b11)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(sximm8 === 16'b0000000000111000) $display("[PASS] sximm8 is correct");
else $error("[FAIL] sximm8 is not correct");

if(sximm8 === 16'b0000000000111000)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

assert(sximm5 === 16'b1111111111111000) $display("[PASS] sximm5 is correct");
else $error("[FAIL] sximm5 is not correct");

if(sximm5 === 16'b1111111111111000)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

sel<=2'b01;//selecting Rd which is 001(r1)

#5;

assert(r_addr === 3'b001 && w_addr === 3'b001) $display("[PASS] selectred register is correct");
else $error("[FAIL] selectred register is not correct");

if(r_addr === 3'b001 && w_addr === 3'b001)begin
e<=e;
end else begin
e<=1'b1;
end

#5;

sel<=2'b00;//selecting Rm which is 000(r0)

#5;

assert(r_addr === 3'b000 && w_addr === 3'b000) $display("[PASS] selectred register is correct");
else $error("[FAIL] selectred register is not correct");

if(r_addr === 3'b000 && w_addr === 3'b000)begin
e<=e;
end else begin
e<=1'b1;
end

#5;


///////////////////////////

$display("\n\nvalue of err is: %-d",err);
$stop;

end
  
endmodule: tb_idecoder

