
`ifndef SCOREBOARD_H
`define SCOREBOARD_H

`include "VGASyncGen.vh"
`include "digits10.v"

/*
 player_stats - Holds two-digit score and one-digit lives counter.
 scoreboard_generator - Outputs video signal with score/lives digits.
 */

module player_stats(reset, score0, score1, lives, incscore, declives);
   
   input reset;
   output reg [3:0] score0;
   output reg [3:0] score1;
   input 	    incscore;
   output reg [3:0] lives;
   input 	    declives;

   always @(posedge incscore or posedge reset)
     begin
	if (reset) begin
           score0 <= 0;
           score1 <= 0;
	end else if (score0 == 9) begin
           score0 <= 0;
           score1 <= score1 + 1;
	end else begin
           score0 <= score0 + 1;
	end
     end

   always @(posedge declives or posedge reset)
     begin
	if (reset)
          lives <= 3;
	else if (lives != 0)
          lives <= lives - 1;
     end

endmodule

module scoreboard_generator(score0, score1, lives, vpos, hpos, board_gfx);

   input [3:0] score0;
   input [3:0] score1;
   input [3:0] lives;
   input [10:0] vpos;
   input [10:0] hpos;
   output 	       board_gfx;

   reg [3:0] 	       score_digit;
   reg [7:0] 	       score_bits;
   
   always @(*)
     begin
	case (hpos[7:5])
          1: score_digit = score1;
          2: score_digit = score0;
          6: score_digit = lives;
          default: score_digit = 15; // no digit
	endcase
     end
   
   // digits10_case numbers(
   digits10_array digits(
			 .digit(score_digit),
			 .yofs(vpos[4:2]),
			 .bits(score_bits)
			 );

   assign board_gfx = score_bits[hpos[4:2] ^ 3'b111];
   
endmodule

module scoreboard_top(
		      input  RST, // active low
		      input  CLK, // 12MHz clock
		      // VGA
		      output VGA_BLUE,
		      output VGA_GREEN,
		      output VGA_RED,
		      output VGA_HSYNC,
		      output VGA_VSYNC);
   

   // RST - pull up
   wire 		     reset;
   SB_IO 
     #(
       .PIN_TYPE(6'b0000_01),
       .PULLUP(1'b1)
       )
   reset_t
     (
      .PACKAGE_PIN(RST),
      .D_IN_0(reset)
      );

   wire vsync = VGA_VSYNC;
   wire hsync = VGA_HSYNC;
   wire red   = VGA_RED;
   wire green = VGA_GREEN;
   wire blue  = VGA_BLUE;
   wire clk;
   wire display_on;
   wire [10:0] 	     hpos;
   wire [10:0] 	     vpos;
   
   wire 		     board_gfx;

   VGASyncGen
     // 640x480@73Hz
     #(.FDivider(83), 
       .QDivider(5),
       .activeHvideo(640),
       .activeVvideo(480),
       .hfp(24),
       .hpulse(40),
       .hbp(128),
       .vfp(9),
       .vpulse(2),
       .vbp(29))
   hvsync_gen(
	      .clk(CLK),
	      // .reset(reset),
	      .hsync(hsync),
	      .vsync(vsync),
	      .x_px(hpos),
	      .y_px(vpos),
	      .activevideo(display_on),
	      .px_clk(clk));
   
   scoreboard_generator scoreboard_gen(
				       .score0(0),
				       .score1(1),
				       .lives(3),
				       .vpos(vpos),
				       .hpos(hpos),
				       .board_gfx(board_gfx)
				       );

   assign red = display_on && board_gfx;
   assign green = display_on && board_gfx;
   assign blue = display_on && board_gfx;

endmodule

`endif
