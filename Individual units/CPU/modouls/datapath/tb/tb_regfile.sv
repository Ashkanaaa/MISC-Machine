module tb_regfile(output err);
  // regfile(input [15:0] w_data, input [2:0] w_addr, input w_en, input [2:0] r_addr, input clk, output [15:0] r_data
  reg reg_err;

  reg [15:0]  sim_w_data;
  reg [2:0]   sim_w_addr;
  reg         sim_w_en;
  reg [2:0]   sim_r_addr;
  reg         sim_clk;

  wire [15:0] sim_r_data;

  assign err = reg_err;

  regfile DUT ( .w_data(sim_w_data), .w_addr(sim_w_addr), .w_en(sim_w_en), 
                .r_addr(sim_r_addr),
                .clk(sim_clk),
                .r_data(sim_r_data) );

  integer num_passes = 0;
  integer num_fails = 0;

  task clock; #5; sim_clk = 0; #5; sim_clk = 1; #5; sim_clk = 0; #5; endtask
  task reset; #5;
    sim_w_addr = 3'd0; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    sim_w_addr = 3'd1; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    sim_w_addr = 3'd2; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    sim_w_addr = 3'd3; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    sim_w_addr = 3'd4; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    sim_w_addr = 3'd5; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    sim_w_addr = 3'd6; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    sim_w_addr = 3'd7; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;

    sim_w_data = 16'd0; sim_w_addr = 3'd0; sim_w_en = 1'd0; sim_r_addr = 3'd0; clock; #5;
  endtask

  task test_1;
    reset;
    #5; sim_w_addr = 3'd0; sim_w_data = 16'd5030; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    #5; sim_w_addr = 3'd1; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    #5; sim_w_addr = 3'd5; sim_w_data = -16'd30; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    #5; sim_w_addr = 3'd7; sim_w_data = -16'd30500; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    
    #5;
    sim_r_addr = 3'd0;
    #5;
    assert (sim_r_data === 16'd5030) begin
      $display("[PASS] r0 is %-d", sim_r_data);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] r0 is %-d, expected: 5030", sim_r_data);
      num_fails = num_fails + 1;
    end

    #5;
    sim_r_addr = 3'd1;
    #5;
    assert (sim_r_data === 16'd0) begin
      $display("[PASS] r1 is %-d", sim_r_data);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] r1 is %-d, expected: 0", sim_r_data);
      num_fails = num_fails + 1;
    end

    #5;
    sim_r_addr = 3'd5;
    #5;
    assert (sim_r_data === -16'd30) begin
      $display("[PASS] r5 is %-d", sim_r_data);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] r5 is %-d, expected: -30", sim_r_data);
      num_fails = num_fails + 1;
    end

    #5;
    sim_r_addr = 3'd7;
    #5;
    assert (sim_r_data === -16'd30500) begin
      $display("[PASS] r7 is %-d", sim_r_data);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] r7 is %-d, expected: -30500", sim_r_data);
      num_fails = num_fails + 1;
    end
  endtask

  task test_2;
    reset;
    #5; sim_w_addr = 3'd2; sim_w_data = 16'd32767; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    #5; sim_w_addr = 3'd3; sim_w_data = -16'd32768; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    #5; sim_w_addr = 3'd4; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    #5; sim_w_addr = 3'd6; sim_w_data = 16'd0; sim_w_en = 1'd1; clock; sim_w_en = 1'd0; #5;
    
    #5;
    sim_r_addr = 3'd2;
    #5;
    assert (sim_r_data === 16'd32767) begin
      $display("[PASS] r2 is %-d", sim_r_data);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] r2 is %-d, expected: 32767", sim_r_data);
      num_fails = num_fails + 1;
    end

    #5;
    sim_r_addr = 3'd3;
    #5;
    assert (sim_r_data === -16'd32768) begin
      $display("[PASS] r3 is %-d", sim_r_data);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] r3 is %-d, expected: -32768", sim_r_data);
      num_fails = num_fails + 1;
    end

    #5;
    sim_r_addr = 3'd4;
    #5;
    assert (sim_r_data === 16'd0) begin
      $display("[PASS] r4 is %-d", sim_r_data);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] r4 is %-d, expected: 0", sim_r_data);
      num_fails = num_fails + 1;
    end

    #5;
    sim_r_addr = 3'd6;
    #5;
    assert (sim_r_data === -16'd0) begin
      $display("[PASS] r6 is %-d", sim_r_data);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] r6 is %-d, expected: 0", sim_r_data);
      num_fails = num_fails + 1;
    end
  endtask

  initial begin
    #5;
    test_1;
    test_2;

    reg_err <= (num_fails === 0) ? 1'b0 : 1'b1;  #5;
    $display("\n\n==== TEST SUMMARY ====");
    $display("  TEST COUNT: %-5d", num_passes + num_fails);
    $display("    - PASSED: %-5d", num_passes);
    $display("    - FAILED: %-5d", num_fails);
    $display("======================\n\n");
    $stop;
  end // initial
endmodule: tb_regfile
