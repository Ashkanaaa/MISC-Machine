module tb_shifter(output err);

    reg e;
    reg [15:0] in;
    reg [1:0] op;
    wire [15:0]out;
    assign err = e;
    

    //(input [15:0] shift_in, input [1:0] shift_op, output reg [15:0] shift_out);

    shifter dut(.shift_in(in),.shift_op(op),.shift_out(out));

    initial begin
        #5;
        e <=1'b0;
        in <= 16'b1111000011001111;
        op <= 2'b00;

        #5;
        assert(out === 16'b1111000011001111) $display("[PASS] when op is 00, no change occurs");
        else $error("[FAIL] when op is 00 the input os diffrent than the output");

        if( out === 16'b1111000011001111)begin
            e<=1'b0;
        end else begin
            e<=1'b1;
        end

        #5;

        op<= 2'b01;

        #5;


        assert(out === 16'b1110000110011110) $display("[PASS] when op is 01, left shift occurs");
        else $error("[FAIL] when op is 01 left shiy does not occure");

        if(out === 16'b1110000110011110)begin
            e<=1'b0;
        end else begin
            e<=1'b1;
        end

        #5;
        op<=2'b10;

        #5;

        assert(out === 16'b0111100001100111) $display("[PASS] when op is 10, right shift occurs");
        else $error("[FAIL] when op is 10 right shift does not occure");

        if(out === 16'b0111100001100111)begin
            e<=1'b0;
        end else begin
            e<=1'b1;
        end


        #5;
        op<=2'b11;

        #5;

        assert(out === 16'b1111100001100111) $display("[PASS] when op is 11,arithmetic? right shif occurs");
        else $error("[FAIL] when op is 11 arithmetic? right shif does not occure");

        if(out === 16'b1111100001100111)begin
            e<=1'b0;
        end else begin
            e<=1'b1;
        end

        #5;

        in<=16'b0111111111111111;

        #5;

        assert(out === 16'b0011111111111111) $display("[PASS] when op is 11,arithmetic? right shif occurs");
        else $error("[FAIL] when op is 11 arithmetic? right shif does not occure");

        if(out === 16'b0011111111111111)begin
            e<=1'b0;
        end else begin
            e<=1'b1;
        end

        #5

        in<=16'b1100000000000000;

        #5;


        assert(out === 16'b1110000000000000) $display("[PASS] when op is 11,arithmetic? right shif occurs");
        else $error("[FAIL] when op is 11 arithmetic? right shif does not occure");

        if(out === 16'b1110000000000000)begin
            e<=1'b0;
        end else begin
            e<=1'b1;
        end


        $stop();

    end



  
endmodule: tb_shifter
