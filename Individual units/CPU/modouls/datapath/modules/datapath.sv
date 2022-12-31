module datapath(input clk, input [15:0] mdata, input [7:0] pc, input [1:0] wb_sel,
                input [2:0] w_addr, input w_en, input [2:0] r_addr, input en_A,
                input en_B, input [1:0] shift_op, input sel_A, input sel_B,
                input [1:0] ALU_op, input en_C, input en_status,
		        input [15:0] sximm8, input [15:0] sximm5,
                output [15:0] datapath_out, output Z_out, output N_out, output V_out);
    // reg [15:0] out;
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [2:0] stat;
    reg [15:0] data;
    

    assign Z_out = stat[2];
    assign N_out = stat[1];
    assign V_out = stat[0];
    assign datapath_out = c;

    wire [15:0] r_data;
    wire [15:0] shift_out;
    wire [15:0] ALU_out;
    wire Z;
    reg N;
    reg V;

    wire [15:0] vala = sel_A ? 16'd0 : a;//mux for val_A
    wire [15:0] valb = sel_B ? sximm5: shift_out;//mux for val_B

    always_comb begin : overflow
        case (ALU_op)
            2'b00:  if (vala[15] != valb[15] || ALU_out[15] == vala[15]) begin V = 1'd0; end else begin V=1'b1; end
            
            
            2'b01:  if (vala[15] == valb[15] ||  ALU_out[15] == vala[15]) begin V = 1'd0; end else begin V=1'b1; end
                    
            default: V = 1'd0;
        endcase
    end

    always_comb begin : regfileIn
        case (wb_sel)
            2'b00: data <= c;
            2'b01: data <= {8'd0, pc};
            2'b10: data <= sximm8;
            2'b11: data <= mdata;
        endcase
    end

    always_comb begin : stat_N
        if(ALU_out[15] == 1'b1) begin
            N = 1'b1;
        end else begin
            N = 1'b0;
        end
    end


    //(input [15:0] w_data, input [2:0] w_addr, input w_en, input [2:0] r_addr, input clk, output [15:0] r_data);
        regfile regf(.w_data(data),.w_addr(w_addr),.w_en(w_en),.r_addr(r_addr),.clk(clk),.r_data(r_data));
    //module shifter(input [15:0] shift_in, input [1:0] shift_op, output reg [15:0] shift_out);
        shifter sh(.shift_in(b),.shift_op(shift_op),.shift_out(shift_out));
    //module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z);
        ALU alu(.val_A(vala),.val_B(valb),.ALU_op(ALU_op),.ALU_out(ALU_out),.Z(Z));

    always_ff @(posedge clk) begin //for register a

        if(en_A) begin
            a <= r_data;
        end else begin
            a <= a;
        end

    end

    always_ff @(posedge clk) begin//for register b

        if(en_B) begin
            b <= r_data;
        end else begin
            b <= b;
        end

    end

    always_ff @(posedge clk) begin//for register stat

        if(en_status) begin
            stat <= {Z, N, V};
        end else begin
            stat <= stat;
        end

    end

    always_ff @(posedge clk) begin//for register c

        if(en_C) begin
            c <= ALU_out;
        end else begin
            c <= c;
        end

    end

endmodule: datapath
