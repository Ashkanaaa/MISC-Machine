module tb_ALU(output err);
  // ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z)
  reg reg_err;

  reg [15:0]  sim_val_A;
  reg [15:0]  sim_val_B;
  reg [1:0]   sim_ALU_op;

  wire [15:0] sim_ALU_out;
  wire        sim_Z;

  assign err = reg_err;

  ALU DUT ( .val_A(sim_val_A), .val_B(sim_val_B), .ALU_op(sim_ALU_op),
            .ALU_out(sim_ALU_out), .Z(sim_Z));

  integer num_passes = 0;
  integer num_fails = 0;

  task test_1_add;
    #5;
    sim_val_A = 16'd0;
    sim_val_B = 16'd0;
    sim_ALU_op = 2'b00;
    #5;
    assert (sim_ALU_out === 16'd0 & sim_Z === 1'd1) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_2_and;
    #5;
    sim_val_A = 16'b1111111100000000;
    sim_val_B = 16'b0000000011111111;
    sim_ALU_op = 2'b10;
    #5;
    assert (sim_ALU_out === 16'd0 & sim_Z === 1'd1) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_3_sub;
    #5;
    sim_val_A = 16'd0;
    sim_val_B = 16'd0;
    sim_ALU_op = 2'b01;
    #5;
    assert (sim_ALU_out === 16'd0 & sim_Z === 1'd1) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_4_neg;
    #5;
    sim_val_A = 16'd0;
    sim_val_B = 16'd0;
    sim_ALU_op = 2'b11;
    #5;
    assert (sim_ALU_out === -16'd1 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_5_add;
    #5;
    sim_val_A = 16'd37;
    sim_val_B = -16'd5;
    sim_ALU_op = 2'b00;
    #5;
    assert (sim_ALU_out === 16'd32 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_6_add;
    #5;
    sim_val_A = -16'd3000;
    sim_val_B = -16'd7000;
    sim_ALU_op = 2'b00;
    #5;
    assert (sim_ALU_out === -16'd10000 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_7_add;
    #5;
    sim_val_A = 16'd10500;
    sim_val_B = 16'd8095;
    sim_ALU_op = 2'b00;
    #5;
    assert (sim_ALU_out === 16'd18595 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_8_and;
    #5;
    sim_val_A = 16'd8095;
    sim_val_B = -16'd35;
    sim_ALU_op = 2'b10;
    #5;
    assert (sim_ALU_out === 16'd8093 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_9_and;
    #5;
    sim_val_A = -16'd1;
    sim_val_B = 16'd30678;
    sim_ALU_op = 2'b10;
    #5;
    assert (sim_ALU_out === 16'd30678 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_10_and;
    #5;
    sim_val_A = 16'd25;
    sim_val_B = 16'd14;
    sim_ALU_op = 2'b10;
    #5;
    assert (sim_ALU_out === 16'd8 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_11_sub;
    #5;
    sim_val_A = -16'd100;
    sim_val_B = -16'd2000;
    sim_ALU_op = 2'b01;
    #5;
    assert (sim_ALU_out === 16'd1900 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_12_sub;
    #5;
    sim_val_A = 16'd20408;
    sim_val_B = 16'd2004;
    sim_ALU_op = 2'b01;
    #5;
    assert (sim_ALU_out === 16'd18404 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_13_sub;
    #5;
    sim_val_A = 16'd15;
    sim_val_B = -16'd2004;
    sim_ALU_op = 2'b01;
    #5;
    assert (sim_ALU_out === 16'd2019 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_14_neg;
    #5;
    sim_val_A = 16'd4095;
    sim_val_B = -16'd16964;
    sim_ALU_op = 2'b11;
    #5;
    assert (sim_ALU_out === 16'd16963 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_15_neg;
    #5;
    sim_val_A = 16'd457;
    sim_val_B = -16'd1;
    sim_ALU_op = 2'b11;
    #5;
    assert (sim_ALU_out === 16'd0 & sim_Z === 1'd1) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  task test_16_neg;
    #5;
    sim_val_A = -16'd30568;
    sim_val_B = 16'd4;
    sim_ALU_op = 2'b11;
    #5;
    assert (sim_ALU_out === -16'd5 & sim_Z === 1'd0) begin
      $display("[PASS] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_passes = num_passes + 1;
    end else begin
      $error("[FAIL] out is %-d, Z is %-d", sim_ALU_out, sim_Z);
      num_fails = num_fails + 1;
    end
    #5;
  endtask

  initial begin
    test_1_add;
    test_2_and;
    test_3_sub;
    test_4_neg;
    test_5_add;
    test_6_add;
    test_7_add;
    test_8_and;
    test_9_and;
    test_10_and;
    test_11_sub;
    test_12_sub;
    test_13_sub;
    test_14_neg;
    test_15_neg;
    test_16_neg;

    reg_err <= (num_fails === 0) ? 1'b0 : 1'b1;  #5;
    $display("\n\n==== TEST SUMMARY ====");
    $display("  TEST COUNT: %-5d", num_passes + num_fails);
    $display("    - PASSED: %-5d", num_passes);
    $display("    - FAILED: %-5d", num_fails);
    $display("======================\n\n");
    $stop;
  end // initial
endmodule: tb_ALU
