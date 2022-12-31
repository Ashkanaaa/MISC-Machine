module cpu(input clk, input rst_n, input load, input start, input [15:0] instr,
           output waiting, output [15:0] out, output N, output V, output Z);
    
    reg [15:0] ir;
   // decoder & datapath
    wire [1:0] shift_op;
    wire [15:0] sximm5;
    wire [15:0] sximm8;
    wire [2:0] r_addr;
    wire [2:0] w_addr;
    wire [15:0] mdata;
    wire [7:0] pc;
    assign mdata = 16'd0;
    assign pc = 8'd0;

    // decoder & controller
    wire [1:0] reg_sel;
    wire [2:0] opcode;
    wire [1:0] ALU_op;
   

    // datapath & controller
    wire [1:0] wb_sel;
    wire w_en;
    wire en_A;
    wire en_B;
    wire sel_A;
    wire sel_B;
    wire en_C;
    wire en_status;
    

    // datapath outputs
    wire [15:0] dpo;
    wire Z_out;
    wire N_out;
    wire V_out;

    //CPU outputs
    assign out = dpo;
    assign Z = Z_out;
    assign N = N_out;
    assign V = V_out;

        /*module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
		        input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);*/

    datapath dp(.clk(clk), .mdata(mdata), .pc(pc), .wb_sel(wb_sel), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .en_A(en_A),
                .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), .sel_B(sel_B), .ALU_op(ALU_op), .en_C(en_C), .en_status(en_status),
                .sximm8(sximm8), .sximm5(sximm5), .datapath_out(dpo), .Z_out(Z_out), .N_out(N_out), .V_out(V_out));

                /*module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		        output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);*/

    idecoder id(.ir(ir), .reg_sel(reg_sel), 
                .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op), .sximm5(sximm5), .sximm8(sximm8), 
                .r_addr(r_addr), .w_addr(w_addr));

                /*module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);
                */

    controller ctr(.clk(clk), .rst_n(rst_n), .start(start), .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op),
                .Z(Z_out), .N(N_out), .V(V_out), .waiting(waiting), .reg_sel(reg_sel), .wb_sel(wb_sel), .w_en(w_en), .en_A(en_A), .en_B(en_B), .en_C(en_C), .en_status(en_status),.sel_A(sel_A), .sel_B(sel_B));

    always_ff @(posedge clk) begin
        if (load == 1'd1) begin
            ir <= instr;
        end else begin
            ir <= ir;
        end
    end
endmodule: cpu

