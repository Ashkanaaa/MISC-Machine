module tb_controller(output err);
    reg sim_clk;
    reg sim_start;
    reg [2:0] sim_opcode;
    reg [1:0] sim_ALU_op;
    reg [1:0] sim_shift_op;
    reg sim_Z;
    reg sim_N;
    reg sim_V;

    reg sim_rst;
    wire sim_rst_n = ~sim_rst;

    wire sim_waiting;
    wire [1:0] sim_reg_sel;
    wire [1:0] sim_wb_sel;
    wire sim_w_en;
    wire sim_en_A;
    wire sim_en_B;
    wire sim_en_C;
    wire sim_en_status;
    wire sim_sel_A;
    wire sim_sel_B;

    reg reg_err;
    assign err = reg_err;

    integer num_passes = 0;
    integer num_fails = 0;

    controller DUT (.clk(sim_clk), .rst_n(sim_rst_n), .start(sim_start),
                    .opcode(sim_opcode), .ALU_op(sim_ALU_op), .shift_op(sim_shift_op),
                    .Z(sim_Z), .N(sim_N), .V(sim_V),
                    .waiting(sim_waiting), .reg_sel(sim_reg_sel), .wb_sel(sim_wb_sel),
                    .w_en(sim_w_en), .en_A(sim_en_A), .en_B(sim_en_B), .en_C(sim_en_C), .en_status(sim_en_status),
                    .sel_A(sim_sel_A), .sel_B(sim_sel_B));

    task reset; sim_opcode = 3'd0; sim_rst = 1'd1; #5; sim_rst = 1'd0; #5; endtask

    task clock;
        forever begin // forever clock
            sim_clk <= 1'd1;
            #2;
            sim_clk <= 1'd0;
            #3;
        end
    endtask

    task mov_reg;
        $display("\nTEST MOV_REG\n");
        reset; // reset

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        sim_opcode = 3'b110;
        sim_ALU_op = 3'b00;
        sim_start = 1'b1;
        #5; // clock cycle 1 start asserted for 1 cycle
        sim_start = 1'b0;

        #5 // clock cycle 2 to state MOV_REG 1
        $display("\nCYCLE 2");
        assert (sim_waiting === 1'd0) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 0", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_reg_sel === 2'b00) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 00", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd1 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 1 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 3 to state MOV_REG 2
        $display("\nCYCLE 3");
        assert (sim_sel_A === 1'b1 & sim_sel_B === 1'b0) begin
            $display("[PASS] select A B are %-b %-b", sim_sel_A, sim_sel_B);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select A B are %-b %-b, expected: 1 0", sim_sel_A, sim_sel_B);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd1 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 1 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 4 to state MOV_REG 3
        $display("\nCYCLE 4");
        assert (sim_reg_sel === 2'b01) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 01", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_wb_sel === 2'b00) begin
            $display("[PASS] select wb is %-b", sim_wb_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select wb is %-b, expected: 00", sim_wb_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd1) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 1", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 5 to state waiting
        $display("\nCYCLE 5");
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task cmp_AB;
        $display("\nTEST CMP_A_B\n");
        reset; // reset

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        sim_opcode = 3'b101;
        sim_ALU_op = 3'b01;
        sim_start = 1'b1;
        #5; // clock cycle 1 start asserted for 1 cycle
        sim_start = 1'b0;

        #5 // clock cycle 2 to state CMP 1
        $display("\nCYCLE 2");
        assert (sim_waiting === 1'd0) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 0", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_reg_sel === 2'b00) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] read/write is %-b, expected: 00", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd1 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 1 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 3 to state CMP 2
        $display("\nCYCLE 3");
        assert (sim_reg_sel === 2'b10) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] read/write is %-b, expected: 10", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd1 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 1 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 4 to state CMP 3
        $display("\nCYCLE 4");
        assert (sim_sel_A === 1'b0 & sim_sel_B === 1'b0) begin
            $display("[PASS] select A B are %-b %-b", sim_sel_A, sim_sel_B);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select A B are %-b %-b, expected: 0 0", sim_sel_A, sim_sel_B);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd1 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 1 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 5 to state waiting
        $display("\nCYCLE 5");
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task mvn_B;
        $display("\nTEST MVN_B\n");
        reset; // reset

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        sim_opcode = 3'b101;
        sim_ALU_op = 3'b11;
        sim_start = 1'b1;
        #5; // clock cycle 1 start asserted for 1 cycle
        sim_start = 1'b0;

        #5 // clock cycle 2 to state MVN 1
        $display("\nCYCLE 2");
        assert (sim_waiting === 1'd0) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 0", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_reg_sel === 2'b00) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 00", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd1 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 1 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 3 to state MVN 2
        $display("\nCYCLE 3");
        assert (sim_sel_B === 1'b0) begin
            $display("[PASS] select B is %-b", sim_sel_B);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select B is %-b, expected: 0", sim_sel_B);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd1 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 1 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 4 to state MVN 3
        $display("\nCYCLE 4");
        assert (sim_reg_sel === 2'b01) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 01", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_wb_sel === 2'b00) begin
            $display("[PASS] select wb is %-b", sim_wb_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select wb is %-b, expected: 00", sim_wb_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd1) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 1", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 5 to state waiting
        $display("\nCYCLE 5");
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task mov_im;
        $display("\nTEST MOV_IM\n");
        reset; // reset

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        sim_opcode = 3'b110;
        sim_ALU_op = 3'b10;
        sim_start = 1'b1;
        #5; // clock cycle 1 start asserted for 1 cycle
        sim_start = 1'b0;

        #5 // clock cycle 2 to state MOVIM 1
        $display("\nCYCLE 2");
        assert (sim_waiting === 1'd0) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 0", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_reg_sel === 2'b10) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 10", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_wb_sel === 2'b10) begin
            $display("[PASS] select wb is %-b", sim_wb_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select wb is %-b, expected: 10", sim_wb_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd1) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 1", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 3 to state waiting
        $display("\nCYCLE 3");
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task add_AB;
        $display("\nTEST ADD_A_B\n");
        reset; // reset

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        sim_opcode = 3'b101;
        sim_ALU_op = 3'b00;
        sim_start = 1'b1;
        #5; // clock cycle 1 start asserted for 1 cycle
        sim_start = 1'b0;

        #5 // clock cycle 2 to state ADD 1
        $display("\nCYCLE 2");
        assert (sim_waiting === 1'd0) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 0", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_reg_sel === 2'b00) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 00", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd1 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 1 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 3 to state ADD 2
        $display("\nCYCLE 3");
        assert (sim_reg_sel === 2'b10) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 10", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd1 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 1 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 4 to state ADD 3
        $display("\nCYCLE 4");
        assert (sim_sel_A === 1'b0 & sim_sel_B === 1'b0) begin
            $display("[PASS] select A B are %-b %-b", sim_sel_A, sim_sel_B);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select A B are %-b %-b, expected: 0 0", sim_sel_A, sim_sel_B);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd1 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 1 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 5 to state ADD 4
        $display("\nCYCLE 5");
        assert (sim_reg_sel === 2'b01) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 01", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_wb_sel === 2'b00) begin
            $display("[PASS] select wb is %-b", sim_wb_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select wb is %-b, expected: 00", sim_wb_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd1) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 1", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 5 to state waiting
        $display("\nCYCLE 6");
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task and_AB;
        $display("\nTEST AND_A_B\n");
        reset; // reset

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        sim_opcode = 3'b101;
        sim_ALU_op = 3'b10;
        sim_start = 1'b1;
        #5; // clock cycle 1 start asserted for 1 cycle
        sim_start = 1'b0;

        #5 // clock cycle 2 to state AND 1
        $display("\nCYCLE 2");
        assert (sim_waiting === 1'd0) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 0", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_reg_sel === 2'b00) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 00", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd1 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 1 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 3 to state AND 2
        $display("\nCYCLE 3");
        assert (sim_reg_sel === 2'b10) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 10", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd1 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 1 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 4 to state AND 3
        $display("\nCYCLE 4");
        assert (sim_sel_A === 1'b0 & sim_sel_B === 1'b0) begin
            $display("[PASS] select A B are %-b %-b", sim_sel_A, sim_sel_B);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select A B are %-b %-b, expected: 0 0", sim_sel_A, sim_sel_B);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd1 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 1 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 5 to state AND 4
        $display("\nCYCLE 5");
        assert (sim_reg_sel === 2'b01) begin
            $display("[PASS] read/write is %-b", sim_reg_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-b, expected: 01", sim_reg_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_wb_sel === 2'b00) begin
            $display("[PASS] select wb is %-b", sim_wb_sel);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] select wb is %-b, expected: 00", sim_wb_sel);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd1) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 1", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end

        #5 // clock cycle 5 to state waiting
        $display("\nCYCLE 6");
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        
        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    task test_reset;
        $display("\nTEST RESET\n");
        reset; // reset

        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        sim_opcode = 3'b101;
        sim_ALU_op = 3'b10;
        sim_start = 1'b1;
        #5; // clock cycle 1 start asserted for 1 cycle
        sim_start = 1'b0;

        #10; // run 2 clock cycles

        sim_rst = 1'd1; // mid operation reset
        #5;
        sim_rst = 1'd10;
        assert (sim_waiting === 1'd1) begin
            $display("[PASS] waiting is %-d", sim_waiting);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] waiting is %-d, expected: 1", sim_waiting);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
        
        assert (sim_en_A === 1'd0 & sim_en_B === 1'd0 & sim_en_C === 1'd0 & sim_en_status === 1'd0 & sim_w_en === 1'd0) begin
            $display("[PASS] enable A B C stat w are %-d %-d %-d %-d %-d", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_passes = num_passes + 1;
            reg_err <= reg_err;
        end else begin
            $error("[FAIL] enable A B C stat w are %-d %-d %-d %-d %-d, expected: 0 0 0 0 0", sim_en_A, sim_en_B, sim_en_C, sim_en_status, sim_w_en);
            num_fails = num_fails + 1;
            reg_err <= 1'd1;
        end
    endtask

    initial begin
        clock;
    end

    initial begin
        reg_err = 1'b0;
        sim_shift_op = 2'd0;
        sim_Z = 1'd0;
        sim_N = 1'd0;
        sim_V = 1'd0;

        #2;

        // test each instruction cycle
        mov_im;
        mov_reg;
        cmp_AB;
        mvn_B;
        add_AB;
        and_AB;
        test_reset;

        
        $display("\n\n==== TEST SUMMARY ====");
        $display("  TEST COUNT: %-5d", num_passes + num_fails);
        $display("    - PASSED: %-5d", num_passes);
        $display("    - FAILED: %-5d", num_fails);
        $display("======================\n\n");
        $stop;
    end
    //controller(input clk, input rst_n, input start,
    //              input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
    //              input Z, input N, input V,
    //              output waiting,
    //              output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
    //              output en_A, output en_B, output en_C, output en_status,
    //              output sel_A, output sel_B);x
endmodule: tb_controller
