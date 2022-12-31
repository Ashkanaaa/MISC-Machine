// final

module ALU(input [15:0] val_A, input [15:0] val_B, input [1:0] ALU_op, output [15:0] ALU_out, output Z);

  reg [15:0] out;
  reg zed;

  assign {ALU_out,Z} = {out,zed};

  always_comb begin 
    case (ALU_op)

      2'b00: out = val_A + val_B;
      2'b01: out = val_A - val_B;
      2'b10: out = val_A & val_B;
      2'b11: out = ~val_B;

      default:out = 16'd2;

    endcase
  end

  always_comb begin
    if(ALU_out == 16'd0)begin
      zed = 1'b1;
    end else begin
      zed = 1'b0;
    end
  end

endmodule: ALU


module shifter(input [15:0] shift_in, input [1:0] shift_op, output reg [15:0] shift_out);
  always_comb begin case(shift_op)
    2'b00: shift_out = shift_in;
    2'b01: shift_out = {shift_in[14:0], 1'b0};
    2'b10: shift_out = {1'b0, shift_in[15:1]};
    2'b11: shift_out = {shift_in[15], shift_in[15:1]};
    default: shift_out = shift_in;
  endcase end
endmodule: shifter



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

module controller(input clk, input rst_n,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B, output load_ir, output ram_w_en, output sel_addr, output load_pc, output clear_pc, output load_addr);


reg w;
reg [5:0] r_state;
reg [1:0] wbsel;
reg [1:0] regsel;
reg wen;
reg enB;
reg enA;
reg enC;
reg enstat;
reg selA; 
reg selB;
/**/
reg loadir;
reg ram_en;
reg seladd;
reg loadpc;
reg clearpc;
reg loadadd;
assign {waiting,reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B, load_ir,ram_w_en,sel_addr, load_pc, clear_pc, load_addr} = {w,regsel,wbsel,wen,enA,enB,enC,enstat,selA,selB,loadir,ram_en,seladd,loadpc, clearpc, loadadd};


always_ff @(posedge clk) begin
	
    if (~rst_n) begin r_state <= 6'd0; end // staying in 0 if reset == 0
  
  else if (r_state ==6'd0 && rst_n) begin r_state<=6'd62;end // going from 0 to 62 if reset == 1

  else if(r_state == 6'd62) begin r_state<= 6'd61; end //going from 62 to 61 unconditionally 

  else if(r_state == 6'd61) begin r_state<= 6'd48; end // going from 61 to 48 unconditionally
  
  else if(r_state == 6'd63) begin r_state<=6'd62; end // going from 63 to 62 uncondontionally 
  
  else if(r_state == 6'd48 && opcode == 3'b111) begin r_state <= 6'd60; end // goint from 48 to 60(halt) if opcode == 111
  
  else if(rst_n && r_state == 6'd60) begin r_state<=6'd60; end // staying in halt as long as reset == 1
  



 else begin
        case({r_state,opcode,ALU_op})

        {6'd48,3'b110,2'b10}:r_state<=6'b000001;

        {6'd48,3'b110,2'b00}:r_state<=6'b000010;

        {6'd48,3'b101,2'b00}:r_state<=6'b000101;

        {6'd48,3'b101,2'b01}:r_state<=6'b001001;

        {6'd48,3'b101,2'b10}:r_state<=6'b001100;

        {6'd48,3'b101,2'b11}:r_state<=6'b010000;

        {6'd48,3'b011,2'b00}:r_state<=6'd59;

        {6'd48,3'b100,2'b00}:r_state<=6'd54;



        //default:r_state<=6'd0;

        endcase
    

        case(r_state)

            /*{6'd0}: r_state <= 6'd62;
            {6'd63}: r_state <= 6'd62;
            {6'd62}: r_state <= 6'd61;
            {6'd61}: r_state <= 6'd48;*/

            
      
            //11010
            {6'b000001}:r_state<=6'd63;

            //11000
            {6'b000010}:r_state<=6'b000011;
            {6'b000011}:r_state<=6'b000100;
            {6'b000100}:r_state<=6'd63;

            //10100
            {6'b000101}:r_state<=6'b000110;
            {6'b000110}:r_state<=6'b000111;
            {6'b000111}:r_state<=6'b001000;
            {6'b001000}:r_state<=6'd63;

            //10101
            {6'b001001}:r_state<=6'b001010;
            {6'b001010}:r_state<=6'b001011;
            {6'b001011}:r_state<=6'd63;

            //10110
            {6'b001100}:r_state<=6'b001101;
            {6'b001101}:r_state<=6'b001110;
            {6'b001110}:r_state<=6'b001111;
            {6'b001111}:r_state<=6'd63;

            //10111
            {6'b010000}:r_state<=6'b010001;
            {6'b010001}:r_state<=6'b010010;
            {6'b010010}:r_state<=6'd63;

            /**/

            //01100
            {6'd59}:r_state<=6'd58;
            {6'd58}:r_state<=6'd57;
            {6'd57}:r_state<=6'd56;
            {6'd56}:r_state<=6'd55;
            {6'd55}:r_state<=6'd63;

            //10000
            {6'd54}:r_state<=6'd53;
            {6'd53}:r_state<=6'd52;
            {6'd52}:r_state<=6'd51;
            {6'd51}:r_state<=6'd50;
            {6'd50}:r_state<=6'd49;
            {6'd49}:r_state<=6'd63;


            //default:r_state<=6'd0;

        endcase
	end
end 

 //loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;

always_comb begin


case(r_state)

{6'b000000}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b0;selB=1'b0; regsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b1; loadpc=1'b1;clearpc=1'b1;loadadd=1'b0;end
{6'd63}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0;/**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00;/**/ loadir=1'b0; ram_en =1'b0; seladd=1'b1; loadpc=1'b1;clearpc=1'b0;loadadd=1'b0; end
{6'd62}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b1; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd61}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00;/**/loadir=1'b1; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd60}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd48}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end




//01100
{6'd59}:begin w=1'b1;enA=1'b1;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b0;selB=1'b0; regsel=2'b10;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd58}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b1;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b0;selB=1'b1; regsel=2'b10;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd57}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b1;end
{6'd56}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd55}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b1; /**/wbsel=2'b11;selA=1'b1;selB=1'b1; regsel=2'b01;/**/ loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end

//10000
{6'd54}:begin w=1'b1;enA=1'b1;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b0;selB=1'b0; regsel=2'b10;/**/ loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd53}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b1;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b0;selB=1'b1; regsel=2'b00;/**/ loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd52}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b0;selB=1'b0; regsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b1;end
{6'd51}:begin w=1'b1;enA=1'b0;enB=1'b1;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b0;selB=1'b0; regsel=2'b01;/**/ loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd50}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b1;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b1;selB=1'b0; regsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'd49}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b0;selB=1'b0; regsel=2'b00;/**/ loadir=1'b0; ram_en =1'b1; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end

//////////
//11010
{6'b000001}:begin w=1'b0;wbsel=2'b10;regsel=2'b10;wen=1'b1; /**/enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;selA=1'b1;selB=1'b1;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end

//11000
{6'b000010}:begin w=1'b0;regsel=2'b00;enB=1'b1;/**/enA=1'b0;enC=1'b0;enstat=1'b0;selA=1'b1;selB=1'b1;wen=1'b0;wbsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0; end
{6'b000011}:begin w=1'b0;enB=1'b0;enC=1'b1;selB=1'b0;selA=1'b1;/**/ regsel=2'b00; wbsel=2'b00;wen=1'b0; enA=1'b0;enstat=1'b0;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b000100}:begin w=1'b0;enA=1'b0;enC=1'b0;wen=1'b1;wbsel=2'b00;regsel=2'b01;/**/ enB=1'b0;enstat=1'b0;selB=1'b0;selA=1'b1;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0; end

//10100
{6'b000101}:begin w=1'b0;regsel=2'b00;enB=1'b1; /**/ wbsel=2'b00; wen=1'b0; enA=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b000110}:begin w=1'b0;regsel=2'b10;enB=1'b0;enA=1'b1;/**/wbsel=2'b00;wen=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b000111}:begin w=1'b0;selB=1'b0;selA=1'b0;enC=1'b1;enA=1'b0;/**/regsel=2'b10;wbsel=2'b00; wen=1'b0;enB=1'b0;enstat=1'b0;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b001000}:begin w=1'b0;wbsel=2'b00;enC=1'b0;regsel=2'b01;wen=1'b1;/**/enA=1'b0;enB=1'b0; enstat=1'b0;selA=1'b0;selB=1'b0;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0; end

//10101
{6'b001001}:begin w=1'b0;regsel=2'b00;enB=1'b1;/**/wbsel=2'b00; wen=1'b0; enA=1'b0; enC=1'b0;enstat=1'b0; selA=1'b1;selB=1'b1;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b001010}:begin w=1'b0;regsel=2'b10;enB=1'b0;enA=1'b1;/**/ enC=1'b0;wbsel=2'b00; wen=1'b0;enstat=1'b0; selA=1'b1;selB=1'b1; /**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b001011}:begin w=1'b0;enA=1'b0;selB=1'b0;selA=1'b0;enstat=1'b1;/**/regsel=2'b10; wbsel=2'b00; wen=1'b0; enB=1'b0; enC=1'b0;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end

//10110
{6'b001100}:begin w=1'b0;regsel=2'b00;enB=1'b1; /**/ wbsel=2'b00; wen=1'b0; enA=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b001101}:begin w=1'b0;regsel=2'b10;enB=1'b0;enA=1'b1;/**/wbsel=2'b00;wen=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b001110}:begin w=1'b0;selB=1'b0;selA=1'b0;enC=1'b1;enA=1'b0;/**/regsel=2'b10;wbsel=2'b00; wen=1'b0;enB=1'b0;enstat=1'b0;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b001111}:begin w=1'b0;wbsel=2'b00;enC=1'b0;regsel=2'b01;wen=1'b1;/**/enA=1'b0;enB=1'b0; enstat=1'b0;selA=1'b0;selB=1'b0; /**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end

//10111
{6'b010000}:begin w=1'b0;regsel=2'b00;enB=1'b1; /**/ wbsel=2'b00; wen=1'b0; enA=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b010001}:begin w=1'b0;enB=1'b0;selB=1'b0;enC=1'b1; /**/wbsel=2'b00; regsel=2'b00;wen=1'b0; enA=1'b0;enstat=1'b0; selA=1'b1;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end
{6'b010010}:begin w=1'b0;enC=1'b0;regsel=2'b01;wen=1'b1; /**/ wbsel=2'b00; enA=1'b0; enB=1'b0; enstat=1'b0; selA=1'b1; selB=1'b0;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0;end


default:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0;/**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00;/**/loadir=1'b0; ram_en =1'b0; seladd=1'b0; loadpc=1'b0;clearpc=1'b0;loadadd=1'b0; end


	endcase
	
end







  // your implementation here
endmodule: controller



/////////////////////////////////////////////////////////////////////////////////////////////////////

module idecoder(input [15:0] ir, input [1:0] reg_sel,
                output [2:0] opcode, output [1:0] ALU_op, output [1:0] shift_op,
		        output [15:0] sximm5, output [15:0] sximm8,
                output [2:0] r_addr, output [2:0] w_addr);
    wire [2:0]  Rn = ir[10:8];
    wire [2:0]  Rd = ir[7:5];
    wire [2:0]  Rm = ir[2:0];

    reg [2:0]  sel_out;

    assign r_addr = sel_out;
    assign w_addr = sel_out;
    assign shift_op = ir[4:3];
    assign sximm8 = 16'(signed'(ir[7:0]));
    assign sximm5 = 16'(signed'(ir[4:0]));
    assign ALU_op = ir[12:11];
    assign opcode = ir[15:13];

    always_comb begin : registerSelect
        case (reg_sel)
              2'b00: sel_out = Rm;
              2'b01: sel_out = Rd;
              2'b10: sel_out = Rn;
            default: sel_out = Rn;
        endcase
    end
endmodule: idecoder



module cpu(input [7:0] start_pc, input [15:0] ram_r_data, input clk, input rst_n,
           output waiting, output [15:0] out, output N, output V, output Z, output ram_w_en, output [7:0] ram_addr);
    
    reg [15:0] ir;
    wire load_ir;
   // wire ram_w_en;
    wire sel_addr;
    wire load_pc;
    wire clear_pc;
    
    reg [7:0] programC;
    wire [7:0] next_pc = clear_pc ? start_pc: programC + 8'd1;// mux for programm counter

    wire load_addr;
    reg [7:0] da;
    wire [7:0] mux_addr = sel_addr ? programC: da; //mux for ram_addr
    assign ram_addr = mux_addr;
    

   // decoder & datapath
    wire [1:0] shift_op;
    wire [15:0] sximm5;
    wire [15:0] sximm8;
    wire [2:0] r_addr;
    wire [2:0] w_addr;
    wire [15:0] mdata;
    wire [7:0] pc;
    assign mdata = ram_r_data;
    assign pc = programC;

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

                /*module controller(input clk, input rst_n,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B, output load_ir, output ram_w_en, output sel_addr, output load_pc, output clear_pc, output load_addr);


                */

    controller ctr(.clk(clk), .rst_n(rst_n), .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op),
                .Z(Z_out), .N(N_out), .V(V_out), .waiting(waiting), .reg_sel(reg_sel), .wb_sel(wb_sel), .w_en(w_en), .en_A(en_A), .en_B(en_B), .en_C(en_C), .en_status(en_status),.sel_A(sel_A), .sel_B(sel_B)
                ,.load_ir(load_ir), .ram_w_en(ram_w_en), .sel_addr(sel_addr),.load_pc(load_pc), .clear_pc(clear_pc),.load_addr(load_addr));

    
    always_ff @(posedge clk) begin// for pc register
        
        if (load_pc == 1'd1) begin
            programC <= next_pc;
        end else begin
            programC <= programC;
        end
    end
    
    always_ff @(posedge clk) begin // for instruction register
        
        if (load_ir == 1'd1) begin
            ir <= ram_r_data;
        end else begin
            ir <= ir;
        end
    end

    always_ff @(posedge clk) begin // for da register
        
        if (load_addr == 1'd1) begin
            da <= dpo;
        end else begin
            da <= da;
        end
    end
endmodule: cpu







//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*module cpu(input [7:0] start_pc, input [15:0] ram_r_data, input clk, input rst_n,
           output waiting, output [15:0] out, output N, output V, output Z, output ram_w_en, output [7:0] ram_addr);*/


module task3(input clk, input rst_n, input [7:0] start_pc, output[15:0] out);
  // your implementation here

wire [15:0] ram_r_data;//////

wire waiting;
wire N;
wire V;
wire Z;
wire ram_w_en;/////////
wire [7:0] ram_addr;////////

/*module ram(input clk, input ram_w_en, input [7:0] ram_r_addr, input [7:0] ram_w_addr,
           input [15:0] ram_w_data, output reg [15:0] ram_r_data);*/
cpu CP (.start_pc(start_pc), .ram_r_data(ram_r_data), .clk(clk), .rst_n(rst_n), .waiting(waiting), .out(out), .N(N), .V(V), .Z(Z), .ram_w_en(ram_w_en), .ram_addr(ram_addr));

ram RM(.clk(clk), .ram_w_en(ram_w_en), .ram_r_addr(ram_addr), .ram_w_addr(ram_addr), .ram_w_data(out)/**/, .ram_r_data(ram_r_data));








endmodule: task3


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////