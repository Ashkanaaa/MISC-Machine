module tb_datapath(output err);
    reg reg_err;

    reg [15:0]  sim_mdata;
    reg [7:0]   sim_pc;
    reg [15:0]  sim_sximm8;
    reg [15:0]  sim_sximm5;
    reg [2:0]   sim_w_addr;
    reg         sim_w_en;
    reg         sim_en_A;
    reg         sim_en_B;
    reg [1:0]   sim_shift_op;
    reg         sim_sel_A;
    reg         sim_sel_B;
    reg [1:0]   sim_ALU_op;
    reg [1:0]   sim_wb_sel;
    reg         sim_en_status;
    reg         sim_en_C;
    reg [2:0]   sim_r_addr;
    reg         sim_clk;

    wire [15:0] sim_datapath_out;
    wire        sim_Z_out;
    wire        sim_N_out;
    wire        sim_V_out;

    assign err = reg_err;

    datapath DUT(.clk(sim_clk), .mdata(sim_mdata), .pc(sim_pc), .wb_sel(sim_wb_sel),
                .w_addr(sim_w_addr), .w_en(sim_w_en), .r_addr(sim_r_addr), .en_A(sim_en_A),
                .en_B(sim_en_B), .shift_op(sim_shift_op), .sel_A(sim_sel_A), .sel_B(sim_sel_B),
                .ALU_op(sim_ALU_op), .en_C(sim_en_C), .en_status(sim_en_status),
                .sximm8(sim_sximm8), .sximm5(sim_sximm5),
                .datapath_out(sim_datapath_out), .Z_out(sim_Z_out), .N_out(sim_N_out), .V_out(sim_V_out));

    /*
    module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
                input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);
    */

    integer num_passes = 0;
    integer num_fails = 0;

    task clock; #5; sim_clk = 0; #5; sim_clk = 1; #5; sim_clk = 0; #5; endtask
    task disable_all; sim_w_en = 1'd0; sim_en_B = 1'd0; sim_en_C = 1'd0; sim_en_status = 1'd0; sim_w_en = 1'd0; endtask 
    task reset; #5;
        // set register values to 0
        sim_w_addr = 3'd0; sim_sximm8 = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
        sim_w_addr = 3'd1; sim_sximm8 = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
        sim_w_addr = 3'd2; sim_sximm8 = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
        sim_w_addr = 3'd3; sim_sximm8 = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
        sim_w_addr = 3'd4; sim_sximm8 = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
        sim_w_addr = 3'd5; sim_sximm8 = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
        sim_w_addr = 3'd6; sim_sximm8 = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
        sim_w_addr = 3'd7; sim_sximm8 = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;

        // set A, B and C to 0
        sim_en_A = 1'd1; sim_en_B = 1'd1; sim_en_C = 1'd1;
        clock; clock;

        // set enables/selects/addresses/operators to 0
        disable_all;
        sim_r_addr = 3'd0; sim_w_addr = 3'd0; sim_sel_A = 1'd0; sim_sel_B = 1'd0;
        sim_ALU_op = 2'd0; sim_shift_op = 2'd0;
    endtask

    task read_en;
        disable_all;
        sim_sel_A = 1'd1; sim_sel_B = 1'd0;
        sim_ALU_op = 2'd0; sim_shift_op = 2'd0;
        #5;
    endtask

    task sel_A; sim_sel_A = 1'd0; endtask
    task sel_B; sim_sel_B = 1'd0; endtask
    task de_sel_A; sim_sel_A = 1'd1; endtask
    task de_sel_B; sim_sel_B = 1'd1; endtask

    task add_AB; sel_A; sel_B; sim_ALU_op = 2'd0; write_C; endtask
    task add_Ain; sel_A; de_sel_B; sim_ALU_op = 2'd0; write_C; endtask
    task add_B; de_sel_A; sel_B; sim_ALU_op = 2'd0; write_C; endtask
    task add_in; de_sel_A; de_sel_B; sim_ALU_op = 2'd0; write_C; endtask

    task sub_AB; sel_A; sel_B; sim_ALU_op = 2'd1; write_C; endtask
    task sub_Ain; sel_A; de_sel_B; sim_ALU_op = 2'd1; write_C; endtask
    task sub_B; de_sel_A; sel_B; sim_ALU_op = 2'd1; write_C; endtask
    task sub_in; de_sel_A; de_sel_B; sim_ALU_op = 2'd1; write_C; endtask

    task and_AB; sel_A; sel_B; sim_ALU_op = 2'd2; write_C; endtask
    task and_Ain; sel_A; de_sel_B; sim_ALU_op = 2'd2; write_C; endtask
    task and_0; de_sel_A; sim_ALU_op = 2'd2; write_C; endtask

    task neg_B; sel_B; sim_ALU_op = 2'd3; write_C; endtask
    task neg_in; de_sel_B; sim_ALU_op = 2'd3; write_C; endtask

    task no_shift; sim_shift_op = 2'd0; endtask
    task l_shift; sim_shift_op = 2'd1; endtask
    task r_shift; sim_shift_op = 2'd2; endtask
    task ar_shift; sim_shift_op = 2'd3; endtask

    task write_A; disable_all; sim_en_A = 1'd1; clock; sim_en_A = 1'd0; endtask
    task write_B; disable_all; sim_en_B = 1'd1; clock; sim_en_B = 1'd0; endtask
    task write_C; disable_all; sim_en_C = 1'd1; clock; sim_en_C = 1'd0; endtask

    task read_r0; read_en; sim_r_addr = 3'd0; write_B; add_B; write_C; endtask
    task read_r1; read_en; sim_r_addr = 3'd1; write_B; add_B; write_C; endtask
    task read_r2; read_en; sim_r_addr = 3'd2; write_B; add_B; write_C; endtask
    task read_r3; read_en; sim_r_addr = 3'd3; write_B; add_B; write_C; endtask
    task read_r4; read_en; sim_r_addr = 3'd4; write_B; add_B; write_C; endtask
    task read_r5; read_en; sim_r_addr = 3'd5; write_B; add_B; write_C; endtask
    task read_r6; read_en; sim_r_addr = 3'd6; write_B; add_B; write_C; endtask
    task read_r7; read_en; sim_r_addr = 3'd7; write_B; add_B; write_C; endtask 
    task read_Z; disable_all; sim_en_status = 1'd1; clock; sim_en_status = 1'd0; endtask;

    task write_r0; sim_w_en = 1'd1; sim_w_addr = 3'd0; clock; sim_w_en = 1'd0; endtask
    task write_r1; sim_w_en = 1'd1; sim_w_addr = 3'd1; clock; sim_w_en = 1'd0; endtask
    task write_r2; sim_w_en = 1'd1; sim_w_addr = 3'd2; clock; sim_w_en = 1'd0; endtask
    task write_r3; sim_w_en = 1'd1; sim_w_addr = 3'd3; clock; sim_w_en = 1'd0; endtask
    task write_r4; sim_w_en = 1'd1; sim_w_addr = 3'd4; clock; sim_w_en = 1'd0; endtask
    task write_r5; sim_w_en = 1'd1; sim_w_addr = 3'd5; clock; sim_w_en = 1'd0; endtask
    task write_r6; sim_w_en = 1'd1; sim_w_addr = 3'd6; clock; sim_w_en = 1'd0; endtask
    task write_r7; sim_w_en = 1'd1; sim_w_addr = 3'd7; clock; sim_w_en = 1'd0; endtask

    task w_reg; sim_wb_sel = 2'b00; endtask
    task w_in; sim_wb_sel = 2'b10; endtask

    task test_V;
        sim_sximm8 = 16'd32767; w_in; write_r0; disable_all;
        sim_sximm8 = -16'd32768; w_in; write_r1; disable_all;
        sim_r_addr = 3'd0; write_A; sim_r_addr = 3'd1; write_B; add_AB; read_Z;
        assert (sim_V_out === 16'd0) begin
            $display("[PASS] V is %-d", sim_V_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] V is %-d\n expected: 0", sim_V_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        sim_sximm8 = 16'd32767; w_in; write_r1; disable_all;
        sim_sximm8 = -16'd32768; w_in; write_r0; disable_all;
        sim_r_addr = 3'd0; write_A; sim_r_addr = 3'd1; write_B; add_AB; read_Z;
        assert (sim_V_out === 16'd0) begin
            $display("[PASS] V is %-d", sim_V_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] V is %-d\n expected: 0", sim_V_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        sim_sximm8 = 16'd32767; w_in; write_r0; disable_all;
        sim_sximm8 = 16'd5; w_in; write_r1; disable_all;
        sim_r_addr = 3'd0; write_A; sim_r_addr = 3'd1; write_B; add_AB; read_Z;
        assert (sim_V_out === 16'd1) begin
            $display("[PASS] V is %-d", sim_V_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] V is %-d\n expected: 1", sim_V_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        sim_sximm8 = -16'd32768; w_in; write_r0; disable_all;
        sim_sximm8 = -16'd5; w_in; write_r1; disable_all;
        sim_r_addr = 3'd0; write_A; sim_r_addr = 3'd1; write_B; add_AB; read_Z;
        assert (sim_V_out === 16'd1) begin
            $display("[PASS] V is %-d", sim_V_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] V is %-d\n expected: 1", sim_V_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        sim_sximm8 = 16'd32767; w_in; write_r0; disable_all;
        sim_sximm8 = -16'd5; w_in; write_r1; disable_all;
        sim_r_addr = 3'd0; write_A; sim_r_addr = 3'd1; write_B; sub_AB; read_Z;
        assert (sim_V_out === 16'd1) begin
            $display("[PASS] V is %-d", sim_V_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] V is %-d\n expected: 1", sim_V_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        sim_sximm8 = -16'd32768; w_in; write_r0; disable_all;
        sim_sximm8 = 16'd5; w_in; write_r1; disable_all;
        sim_r_addr = 3'd0; write_A; sim_r_addr = 3'd1; write_B; sub_AB; read_Z;
        assert (sim_V_out === 16'd1) begin
            $display("[PASS] V is %-d", sim_V_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] V is %-d\n expected: 1", sim_V_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task test_1;
        sim_sximm8 = 16'd400; w_in; write_r0; disable_all;
        sim_sximm8 = -16'd3040; w_in; write_r1; disable_all;
        read_r0; w_reg; write_r2; disable_all;
        sim_r_addr = 3'd2; write_A; sim_r_addr = 3'd0; write_B; add_AB; w_reg; write_r3; disable_all;
        sim_r_addr = 3'd3; write_A; sim_r_addr = 3'd0; write_B; sub_AB; w_reg; write_r4; disable_all;
        sim_r_addr = 3'd0; write_B; r_shift; add_B; write_C; no_shift; w_reg; write_r5; disable_all;
        sim_r_addr = 3'd0; write_A; sim_sximm5 = 16'd30; sub_Ain; w_reg; write_r6; disable_all;

        disable_all;
        read_r6;
        assert (sim_datapath_out === 16'd370) begin
            $display("[PASS] r6 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r6 is %-d, expected: 370", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r5;
        assert (sim_datapath_out === 16'd200) begin
            $display("[PASS] r5 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r5 is %-d, expected: 200", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r4;
        assert (sim_datapath_out === 16'd400) begin
            $display("[PASS] r4 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r4 is %-d, expected: 400", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r3;
        assert (sim_datapath_out === 16'd800) begin
            $display("[PASS] r3 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r3 is %-d, expected: 800", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r2;
        assert (sim_datapath_out === 16'd400) begin
            $display("[PASS] r2 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r2 is %-d, expected: 400", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r1;
        assert (sim_datapath_out === -16'd3040) begin
            $display("[PASS] r1 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r1 is %-d, expected: -3040", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r0;
        assert (sim_datapath_out === 16'd400) begin
            $display("[PASS] r0 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r0 is %-d, expected: 400", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task test_2;
        sim_sximm8 = -16'd200; w_in; write_r0; disable_all;
        sim_sximm8 = -16'd1; w_in; write_r7; disable_all;
        sim_r_addr = 3'd7; write_A; sim_r_addr = 3'd0; write_B; and_AB; w_reg; write_r5; disable_all;
        sim_r_addr = 3'd7; write_B; neg_B; w_reg; write_r1; disable_all;
        sim_r_addr = 3'd0; write_B; l_shift; add_B; no_shift; w_reg; write_r0; disable_all;

        disable_all;
        read_r7;
        assert (sim_datapath_out === -16'd1) begin
            $display("[PASS] r7 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r7 is %-d, expected: -1", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r5;
        assert (sim_datapath_out === -16'd200) begin
            $display("[PASS] r5 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r5 is %-d, expected: -200", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r1;
        assert (sim_datapath_out === 16'd0) begin
            $display("[PASS] r1 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r1 is %-d, expected: 0", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r1; read_Z;
        assert (sim_Z_out === 1'd1) begin
            $display("[PASS] Z is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] Z is %-d, expected: 1", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r0;
        assert (sim_datapath_out === -16'd400) begin
            $display("[PASS] r0 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r0 is %-d, expected: -400", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task test_3; 
        sim_sximm8 = 16'd32767; w_in; write_r4; disable_all;
        sim_r_addr = 3'd4; write_A; sim_sximm5 = 16'd30; sub_Ain; w_reg; write_r5; disable_all;
        sim_r_addr = 3'd4; write_A; sim_sximm5 = 16'd0; and_Ain; w_reg; write_r6; disable_all;
        sim_r_addr = 3'd4; write_A; sim_sximm5 = 16'd30; sub_Ain; w_reg; write_r7; disable_all;
        sim_r_addr = 3'd7; write_A; sim_r_addr = 3'd5; write_B; and_AB; w_reg; write_r2; disable_all;

        disable_all;
        read_r4;
        assert (sim_datapath_out === 16'd32767) begin
            $display("[PASS] r4 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r4 is %-d, expected: 32767", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r4; read_Z;
        assert (sim_Z_out === 1'd0) begin
            $display("[PASS] Z is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] Z is %-d, expected: 0", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r5;
        assert (sim_datapath_out === 16'd32737) begin
            $display("[PASS] r5 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r5 is %-d, expected: 32737", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r6;
        assert (sim_datapath_out === 16'd0) begin
            $display("[PASS] r6 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r6 is %-d, expected: 0", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r7;
        assert (sim_datapath_out === 16'd32737) begin
            $display("[PASS] r7 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r7 is %-d, expected: 32737", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r2;
        assert (sim_datapath_out === 16'd32737) begin
            $display("[PASS] r2 is %-d", sim_datapath_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] r2 is %-d, expected: 32737", sim_datapath_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task test_4; 
        sim_sximm8 = 16'd32767; w_in; write_r4; disable_all;
        sim_sximm8 = 16'd5; w_in; write_r0; disable_all;
        sim_sximm8 = -16'd32767; w_in; write_r2; disable_all;
        sim_r_addr = 3'd4; write_A; sim_r_addr = 3'd0; write_B; add_AB; w_reg; write_r5; disable_all;
        
        disable_all;
        read_Z;
        assert (sim_Z_out === 16'd0 & sim_V_out === 16'd1) begin
            $display("[PASS] V is %-d\n Z is %-d", sim_V_out, sim_Z_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] V is %-d, expected: 1\n Z is %-d, expected: 0", sim_V_out, sim_Z_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        sim_r_addr = 3'd2; write_A; sim_r_addr = 3'd0; write_B; sub_AB; w_reg; write_r6; disable_all;

        disable_all;
        read_Z;
        assert (sim_Z_out === 16'd0 & sim_V_out === 16'd1) begin
            $display("[PASS] V is %-d\n Z is %-d", sim_V_out, sim_Z_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] V is %-d\n expected: 1, Z is %-d, expected: 0", sim_V_out, sim_Z_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r2; read_Z;
        assert (sim_Z_out === 1'd0 & sim_N_out === 1'd1) begin
            $display("[PASS] Z is %-d\n N is %-d", sim_Z_out, sim_N_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] Z is %-d, expected: 0\n N is %-d, expected: 1", sim_Z_out, sim_N_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        read_r4; read_Z;
        assert (sim_Z_out === 1'd0 & sim_N_out === 1'd0) begin
            $display("[PASS] Z is %-d\n N is %-d", sim_Z_out, sim_N_out);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] Z is %-d, expected: 0\n N is %-d, expected: 0", sim_Z_out, sim_N_out);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    initial begin
        sim_mdata = 16'd0;
        sim_pc = 8'd0;
        reg_err = 1'b0;
        reset;
        test_1;
        test_2;
        test_3;
        test_4;
        test_V;
        #5;

        $display("\n\n==== TEST SUMMARY ====");
        $display("  TEST COUNT: %-5d", num_passes + num_fails);
        $display("    - PASSED: %-5d", num_passes);
        $display("    - FAILED: %-5d", num_fails);
        $display("======================\n\n");
        $stop;
    end // initial
endmodule: tb_datapath


    /*
    datapath(input clk, input [15:0] datapath_in, input wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
                output [15:0] datapath_out, output Z_out);


    test_1
    mov r0, #400
    mov r1, #-3040
    mov r2, r0
    add r3, r2, r0
    sub r4, r3, r0
    mov r5, r0 lsr #1
    sub r6, r0, #30

    out r6 = 370
    out r5 = 200
    out r4 = 400
    out r3 = 800
    out r2 = 400
    out r1 = -3040
    out r0 = 400


    test_2
    mov r0, #-200
    mov r7, #-1
    and r5, r7, r0
    neg r1, r7
    mov r0, r0 lsl #1

    out r7 = -1
    out r5 = -200
    out r1 = 0
    out Z = 1
    out r0 = -400


    test_3
    mov r4, #32767
    add r5, r4, #-300
    and r6, r4, #0
    sub r7, r4, #300
    and r2, r7, r5

    out r4 = 32767
    out r5 = 32467
    out r6 = 0
    out r7 = 32467
    out r2 = 32467

    test_4
    mov r4, #32767
    mov r0, #5
    mov r2, #-32768
    add r5, r4, r0
    out V = 1

    sub r6, r2, r0
    out V = 1
    
    read r4
    out Z = 0
    out N = 0

    read r2
    out Z = 0
    out N = 1


    */