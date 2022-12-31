module tb_cpu(output err);
  // your implementation here

reg e;
assign err =e;

reg s_clk;
reg s_rst_n;
reg s_load;
reg s_start;
reg [15:0] s_instr;
wire s_waiting;
wire [15:0] s_out; 
wire s_N;
wire s_V;
wire s_Z;


 integer num_passes = 0;
 integer num_fails = 0;

/*module cpu(input clk, input rst_n, input load, input start, input [15:0] instr,
           output waiting, output [15:0] out, output N, output V, output Z);
    
*/
cpu dut(.clk(s_clk), .rst_n(s_rst_n), .load(s_load), .start(s_start), .instr(s_instr), .waiting(s_waiting), .out(s_out), .N(s_N), .V(s_V), .Z(s_Z));

task reset; s_rst_n = 1'd0; #5; s_rst_n = 1'd1; #5; endtask


initial begin
e<=1'b0;
s_clk <= 1'b0; 
forever #5 s_clk <= ~s_clk;
end


initial begin
  reset;
  s_instr <= 16'b1101000101111110; //MOV Rn(r1),#255(01111110)//r1=0000000001111110
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
  
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

////////////test for 2nd instruction
#10;
s_instr<=16'b1100000001011001; //MOV r2, r1{arithmetic right shif} //r2=0000000000111111
 s_load<=1'b1;
  #10;
  s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

s_start<=1'b0;
#10;

//2
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//3
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//4
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

////////////test for 3nd instruction
#10;
s_instr<=16'b1010000101101010; //ADD r3,r1,r2{lsl}//r3=0000000001111110+0000000001111110=0000000011111100
 s_load<=1'b1;
  #10;
  s_load<=1'b0;

  //0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;

//31
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

s_start<=1'b0;
#10;

//5
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//6
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//7
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//8
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

////////////preparing for 4th instruction
  s_instr <= 16'b1101010000000001; //MOV Rn(r4),#255(00000001)//r4=0000000001111110
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
end else begin
e<=1'b1;
end

#10;

////second preperation for 4th instruction
 s_instr <= 16'b1101010100000001; //MOV Rn(r5),#255(01111111)//r5=0000000001111110
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;


////////////test for 4th instruction
#10;
s_instr<=16'b1010110000000101; //CMP r4,r5
 s_load<=1'b1;
  #10;
  s_load<=1'b0;

  //0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;

//31
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

s_start<=1'b0;
#10;

//9
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//10
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//11
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

assert(s_Z === 1'b1) $display("[PASS] Z is correct");
else $error("[FAIL] Z is not correct");

if(s_Z === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

////////////second test for the 4th instruction

////////////preparing for 4th instruction
  s_instr <= 16'b1101010000000000; //MOV Rn(r4),#255(00000001)//r4=0000000001111110
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
end else begin
e<=1'b1;
end

#10;

////second preperation for 4th instruction
 s_instr <= 16'b1101010100000001; //MOV Rn(r5),#255(01111111)//r5=0000000001111110
  s_load<=1'b1;
  #10;
  s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;


////////////test for 4th instruction
#10;
s_instr<=16'b1010110000000101; //CMP r4,r5
 s_load<=1'b1;
  #10;
  s_load<=1'b0;

  //0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;

//31
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

s_start<=1'b0;
#10;

//9
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//10
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//11
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

assert(s_N === 1'b1) $display("[PASS] N is correct");
else $error("[FAIL] N is not correct");

if(s_N === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

///////////third test for 4th instruction


////////////preparing for 4th instruction
  s_instr <= 16'b1101010001111111; //MOV Rn(r4),#255(00000001)//r4=0000000001111110
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

////second preperation for 4th instruction
 s_instr <= 16'b1101010111111111; //MOV Rn(r5),#255(01111111)//r5=0000000001111110
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;


////////////test for 4th instruction
#10;
s_instr<=16'b1010110000000101; //CMP r4,r5
 s_load<=1'b1;
  #10;
  s_load<=1'b0;

  //0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;

//31
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

s_start<=1'b0;
#10;

//9
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//10
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//11
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

assert(s_V === 1'b0) $display("[PASS] V is correct");
else $error("[FAIL] V is not correct");

if(s_V === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;


/////////test for 5th instruction


////////////preparing for 5th instruction
  s_instr <= 16'b1101010000000001; //MOV Rn(r4),#1(00000001)//r4=00000001
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

////second preperation for 5th instruction
 s_instr <= 16'b1101010100000001; //MOV Rn(r5),#255(00000001)//r5=00000001
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;


//////////// 5th instruction
#10;
s_instr<=16'b1011010011000101; //AND r6,r4,r5
 s_load<=1'b1;
  #10;
  s_load<=1'b0;

  //0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;

//31
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

s_start<=1'b0;
#10;

//12
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//13
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//14
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//15
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;



/////////second test for 5th instruction


////////////preparing for 5th instruction
  s_instr <= 16'b1101010000000000; //MOV Rn(r4),#1(00000001)//r4=00000001
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

////second preperation for 5th instruction
 s_instr <= 16'b1101010100000001; //MOV Rn(r5),#255(00000001)//r5=00000001
  s_load<=1'b1;
  #10;
s_load<=1'b0;
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;
s_start<=1'b0;
#10;

assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;

assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end
#10;


//////////// 5th instruction
#10;
s_instr<=16'b1011010011000101; //AND r6,r4,r5
 s_load<=1'b1;
  #10;
  s_load<=1'b0;

  //0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;

//31
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

s_start<=1'b0;
#10;

//12
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//13
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//14
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//15
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;




//////////// 6th instruction
#10;
s_instr<=16'b1011100011000101; //MVN r6, r5 (r5==1)
 s_load<=1'b1;
  #10;
  s_load<=1'b0;

  //0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

s_start<=1'b1;
#10;

//31
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

s_start<=1'b0;
#10;

//16
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//17
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;

//18
assert(s_waiting === 1'b0) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b0)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;


//0
assert(s_waiting === 1'b1) $display("[PASS] waiting is correct");
else $error("[FAIL] waiting is not correct");

if(s_waiting === 1'b1)begin
e<=e;
num_passes = num_passes + 1;
end else begin
e<=1'b1;
num_fails = num_fails + 1;
end

#10;




   $display("\n\n==== TEST SUMMARY ====");
        $display("  TEST COUNT: %-5d", num_passes + num_fails);
        $display("    - PASSED: %-5d", num_passes);
        $display("    - FAILED: %-5d", num_fails);
        $display("======================\n\n");

  $display("\n\nvalue of err is: %-d",err);
  $stop();

end


endmodule: tb_cpu