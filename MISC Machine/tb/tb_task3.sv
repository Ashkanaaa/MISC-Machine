// final

module tb_task3(output err);
    reg sim_clk;
    reg sim_rst;
    reg [7:0] sim_start_pc;
    wire sim_rst_n = ~sim_rst;
    wire [15:0] sim_out;
    reg reg_err;
    assign err = reg_err;

    integer num_passes = 0;
    integer num_fails = 0;

    //task1(input clk, input rst_n, input [7:0] start_pc, output[15:0] out);
    task3 DUT(.clk(sim_clk), .rst_n(sim_rst_n), .start_pc(sim_start_pc), .out(sim_out));

    task reset; sim_rst = 1'd1; #10; sim_rst = 1'd0; endtask

    // name tasks for each instruction time cycle
    task imovim; #40; #10; endtask // 1 cycle
    task imovreg; #40; #30; endtask // 3 cycles
    task iadd; #40; #40; endtask // 4 cycles
    task icmp; #40; #30; endtask // 3 cycles
    task iand; #40; #40; endtask // 4 cycles
    task imvn; #40; #30; endtask // 3 cycles
    task ildr; #40; #50; endtask // 5 cycles
    task istr; #40; #60; endtask // 6 cycles
    task ihalt; #40; endtask // 0 cycles

    task clock;
        forever begin // forever clock
            sim_clk <= 1'd1;
            #5;
            sim_clk <= 1'd0;
            #5;
        end
    endtask

    task testn46;
        assert (sim_out === -16'd46) begin
            $display("[PASS] out is -46");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -46", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn51;
        assert (sim_out === -16'd51) begin
            $display("[PASS] out is -51");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -51", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn56;
        assert (sim_out === -16'd56) begin
            $display("[PASS] out is -56");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -56", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task test200;
        assert (sim_out === 16'd200) begin
            $display("[PASS] out is 200");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: 200", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task test205;
        assert (sim_out === 16'd205) begin
            $display("[PASS] out is 205");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: 205", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task test210;
        assert (sim_out === 16'd210) begin
            $display("[PASS] out is 210");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: 210", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn6;
        assert (sim_out === -16'd6) begin
            $display("[PASS] out is -6");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -6", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task test5;
        assert (sim_out === 16'd5) begin
            $display("[PASS] out is 5");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: 5", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask
    
    task test0;
        assert (sim_out === 16'd0) begin
            $display("[PASS] out is 0");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: 0", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task test16185;
        assert (sim_out === 16'd16185) begin
            $display("[PASS] out is 16185");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: 16185", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn18330;
        assert (sim_out === -16'd18330) begin
            $display("[PASS] out is -18330");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -18330", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn16379;
        assert (sim_out === -16'd16379) begin
            $display("[PASS] out is -16379");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -16379", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn21499;
        assert (sim_out === -16'd21499) begin
            $display("[PASS] out is -21499");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -21499", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn16314;
        assert (sim_out === -16'd16314) begin
            $display("[PASS] out is -16314");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -16314", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn19678;
        assert (sim_out === -16'd19678) begin
            $display("[PASS] out is -19678");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -19678", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn16153;
        assert (sim_out === -16'd16153) begin
            $display("[PASS] out is -16153");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -16153", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn16186;
        assert (sim_out === -16'd16186) begin
            $display("[PASS] out is -16186");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -16186", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn16318;
        assert (sim_out === -16'd16186) begin
            $display("[PASS] out is -16186");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -16186", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn201;
        assert (sim_out === -16'd201) begin
            $display("[PASS] out is -201");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -201", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn10296;
        assert (sim_out === -16'd10296) begin
            $display("[PASS] out is -10296");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -10296", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn16351;
        assert (sim_out === -16'd16351) begin
            $display("[PASS] out is -16351");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -16351", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task testn16285;
        assert (sim_out === -16'd16285) begin
            $display("[PASS] out is -16285");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: -16285", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task test10;
        assert (sim_out === 16'd10) begin
            $display("[PASS] out is 10");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: 10", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    task test55;
        assert (sim_out === 16'd55) begin
            $display("[PASS] out is 55");
            num_passes = num_passes + 1;
            reg_err = reg_err;
        end else begin
            $error("[FAIL] out is %-d, expected: 55", sim_out);
            num_fails = num_fails + 1;
            reg_err = 1'd1;
        end
    endtask

    initial begin
        clock;
    end

    task testA;
        sim_start_pc = 8'd0; reset;
        imovim;
        imovim;
        iadd; testn51;
        iadd; testn46;
        icmp;
        imvn; testn6;
        imovreg; test5;
        iand; test0;
        imovreg; testn51;

        imovreg; testn56;
        imovreg; test5;
        imovreg; testn51;
        imovreg; testn46;
        imovreg; testn6;
        imovreg; test5;
        imovreg; test0;
        imovreg; testn51;
        ihalt;
    endtask

    task testB;
        sim_start_pc = 8'd18; reset;
        imovim;
        ildr;
        ildr;
        ildr;
        ildr;
        ildr;
        ildr;
        ildr;
        ildr;
        imvn; test16185;
        iand; test0;

        imovreg; test5;
        imovreg; testn18330; 
        imovreg; testn16314;
        imovreg; testn19678;
        imovreg; testn16379;
        imovreg; testn16153;
        imovreg; testn16186;
        imovreg; test0;
        ihalt;
    endtask

    task testC;
        sim_start_pc = 8'd38; reset;
        imovim;
        ildr;
        ildr;

        imovreg; testn16351;
        imovreg; testn16285;
    endtask

    task testD;  
        sim_start_pc = 8'd44; reset;
        imovim;
        imovim;
        iadd; testn51;
        iadd; test10;
        istr; testn56;
        istr; testn51;
        istr; test10;
        ildr;
        ildr;
        ildr;
        imvn; test55;

        imovreg; testn56;
        imovreg; test5; 
        imovreg; testn51;
        imovreg; test10;
        imovreg; test10;
        imovreg; testn51;
        imovreg; testn56;
        imovreg; test55;
        ihalt;
    endtask

    task testE;
        sim_start_pc = 8'd64; reset;
        imovim;
        imovim;
        ildr;
        istr; testn10296;
        ildr;
        iand; testn10296;
        istr; testn10296;
        ildr;
        imovreg; testn10296;

        imovreg; test0;
        imovreg; testn10296;
        imovreg; testn10296;
        imovreg; testn10296;
        imovreg; testn10296;
        ihalt;
    endtask

    initial begin
        reg_err = 1'b0;

        #2;
        $display("\nTEST A\n");
        testA; // task 1
        $display("\nTEST B\n");
        testB; // task 2
        $display("\nTEST C\n");
        testC; // task 2
        $display("\nTEST D\n");
        testD; // task 3
        $display("\nTEST E\n");
        testE; // task 3
        
        $display("\n\n==== TEST SUMMARY ====");
        $display("  TEST COUNT: %-5d", num_passes + num_fails);
        $display("    - PASSED: %-5d", num_passes);
        $display("    - FAILED: %-5d", num_fails);
        $display("======================\n\n");
        $stop;
    end
endmodule: tb_task3
