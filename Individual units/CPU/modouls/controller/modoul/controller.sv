module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);


reg w;
reg [4:0] r_state;
reg [1:0] wbsel;
reg [1:0] regsel;
reg wen;
reg enB;
reg enA;
reg enC;
reg enstat;
reg selA; 
reg selB;

assign {waiting,reg_sel,wb_sel,w_en,en_A,en_B,en_C,en_status,sel_A,sel_B} = {w,regsel,wbsel,wen,enA,enB,enC,enstat,selA,selB};


always_ff @(posedge clk) begin
	if (~rst_n) begin
	    r_state <= 5'b00000;

	end else if (waiting==1'b1 && r_state==5'b00000 && start == 1'b1) begin
        r_state<=5'b11111;

	end else if(r_state == 5'b00000) begin r_state <= 5'b00000; end


    else begin
        case({start,opcode,ALU_op})

        {1'b0,3'b110,2'b10}:r_state<=5'b00001;

        {1'b0,3'b110,2'b00}:r_state<=5'b00010;

        {1'b0,3'b101,2'b00}:r_state<=5'b00101;

        {1'b0,3'b101,2'b01}:r_state<=5'b01001;

        {1'b0,3'b101,2'b10}:r_state<=5'b01100;

        {1'b0,3'b101,2'b11}:r_state<=5'b10000;

        default:r_state<=5'b00000;

        endcase


        case(r_state)

        {5'b00001}:r_state<=5'b00000;

        //11000
        {5'b00010}:r_state<=5'b00011;
        {5'b00011}:r_state<=5'b00100;
        {5'b00100}:r_state<=5'b00000;

        //10100
        {5'b00101}:r_state<=5'b00110;
        {5'b00110}:r_state<=5'b00111;
        {5'b00111}:r_state<=5'b01000;
        {5'b01000}:r_state<=5'b00000;

        //10101
        {5'b01001}:r_state<=5'b01010;
        {5'b01010}:r_state<=5'b01011;
        {5'b01011}:r_state<=5'b00000;

        //10110
        {5'b01100}:r_state<=5'b01101;
        {5'b01101}:r_state<=5'b01110;
        {5'b01110}:r_state<=5'b01111;
        {5'b01111}:r_state<=5'b00000;

        //10111
        {5'b10000}:r_state<=5'b10001;
        {5'b10001}:r_state<=5'b10010;
        {5'b10010}:r_state<=5'b00000;


        endcase
	end
end 

/*always_ff @(posedge clk) begin
	
	if (~rst_n) begin
	r_state <= 5'b00000;

end else begin
case(r_state)

////
{5'b00001}:r_state<=5'b00000;

//11000
{5'b00010}:r_state<=5'b00011;
{5'b00011}:r_state<=5'b00100;
{5'b00100}:r_state<=5'b00000;

//10100
{5'b00101}:r_state<=5'b00110;
{5'b00110}:r_state<=5'b00111;
{5'b00111}:r_state<=5'b01000;
{5'b01000}:r_state<=5'b00000;

//10101
{5'b01001}:r_state<=5'b01010;
{5'b01010}:r_state<=5'b01011;
{5'b01011}:r_state<=5'b00000;

//10110
{5'b01100}:r_state<=5'b01101;
{5'b01101}:r_state<=5'b01110;
{5'b01110}:r_state<=5'b01111;
{5'b01111}:r_state<=5'b00000;

//10111
{5'b10000}:r_state<=5'b10001;
{5'b10001}:r_state<=5'b10010;
{5'b10010}:r_state<=5'b00000;


endcase
end

end*/

always_comb begin

 case(r_state)
{5'b11111}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0;/**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00; end
{5'b00000}:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0; /**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00;end

{5'b00001}:begin w=1'b0;wbsel=2'b10;regsel=2'b10;wen=1'b1; /**/enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;selA=1'b1;selB=1'b1;end

//11000
{5'b00010}:begin w=1'b0;regsel=2'b00;enB=1'b1;/**/enA=1'b0;enC=1'b0;enstat=1'b0;selA=1'b1;selB=1'b1;wen=1'b0;wbsel=2'b00; end
{5'b00011}:begin w=1'b0;enB=1'b0;enC=1'b1;selB=1'b0;selA=1'b1;/**/ regsel=2'b00; wbsel=2'b00;wen=1'b0; enA=1'b0;enstat=1'b0;end
{5'b00100}:begin w=1'b0;enA=1'b0;enC=1'b0;wen=1'b1;wbsel=2'b00;regsel=2'b01;/**/ enB=1'b0;enstat=1'b0;selB=1'b0;selA=1'b1; end

//10100
{5'b00101}:begin w=1'b0;regsel=2'b00;enB=1'b1; /**/ wbsel=2'b00; wen=1'b0; enA=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;end
{5'b00110}:begin w=1'b0;regsel=2'b10;enB=1'b0;enA=1'b1;/**/wbsel=2'b00;wen=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;end
{5'b00111}:begin w=1'b0;selB=1'b0;selA=1'b0;enC=1'b1;enA=1'b0;/**/regsel=2'b10;wbsel=2'b00; wen=1'b0;enB=1'b0;enstat=1'b0;end
{5'b01000}:begin w=1'b0;wbsel=2'b00;enC=1'b0;regsel=2'b01;wen=1'b1;/**/enA=1'b0;enB=1'b0; enstat=1'b0;selA=1'b0;selB=1'b0; end

//10101
{5'b01001}:begin w=1'b0;regsel=2'b00;enB=1'b1;/**/wbsel=2'b00; wen=1'b0; enA=1'b0; enC=1'b0;enstat=1'b0; selA=1'b1;selB=1'b1;end
{5'b01010}:begin w=1'b0;regsel=2'b10;enB=1'b0;enA=1'b1;/**/ enC=1'b0;wbsel=2'b00; wen=1'b0;enstat=1'b0; selA=1'b1;selB=1'b1; end
{5'b01011}:begin w=1'b0;enA=1'b0;selB=1'b0;selA=1'b0;enstat=1'b1;/**/regsel=2'b10; wbsel=2'b00; wen=1'b0; enB=1'b0; enC=1'b0;end

//10110
{5'b01100}:begin w=1'b0;regsel=2'b00;enB=1'b1; /**/ wbsel=2'b00; wen=1'b0; enA=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;end
{5'b01101}:begin w=1'b0;regsel=2'b10;enB=1'b0;enA=1'b1;/**/wbsel=2'b00;wen=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;end
{5'b01110}:begin w=1'b0;selB=1'b0;selA=1'b0;enC=1'b1;enA=1'b0;/**/regsel=2'b10;wbsel=2'b00; wen=1'b0;enB=1'b0;enstat=1'b0;end
{5'b01111}:begin w=1'b0;wbsel=2'b00;enC=1'b0;regsel=2'b01;wen=1'b1;/**/enA=1'b0;enB=1'b0; enstat=1'b0;selA=1'b0;selB=1'b0; end

//10111
{5'b10000}:begin w=1'b0;regsel=2'b00;enB=1'b1; /**/ wbsel=2'b00; wen=1'b0; enA=1'b0; enC=1'b0; enstat=1'b0; selA=1'b1;selB=1'b1;end
{5'b10001}:begin w=1'b0;enB=1'b0;selB=1'b0;enC=1'b1; /**/wbsel=2'b00; regsel=2'b00;wen=1'b0; enA=1'b0;enstat=1'b0; selA=1'b1;end
{5'b10010}:begin w=1'b0;enC=1'b0;regsel=2'b01;wen=1'b1; /**/ wbsel=2'b00; enA=1'b0; enB=1'b0; enstat=1'b0; selA=1'b1; selB=1'b0;end


default:begin w=1'b1;enA=1'b0;enB=1'b0;enC=1'b0;enstat=1'b0;wen=1'b0;/**/wbsel=2'b00;selA=1'b1;selB=1'b1; regsel=2'b00; end


	endcase
	
end







  // your implementation here
endmodule: controller
