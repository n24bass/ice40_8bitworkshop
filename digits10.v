
`ifndef DIGITS10_H
 `define DIGITS10_H

 `include "VGASyncGen.vh"

/*
 ROM module with 5x5 bitmaps for the digits 0-9.

 digits10_case - Uses the case statement.
 digits10_array - Uses an array and initial block.

 These two modules are functionally equivalent.
 */

// `define _HEX_ 

// module for 10-digit bitmap ROM
module digits10_case(digit, yofs, bits);

   input [3:0] digit;		// digit 0-9
   input [2:0] yofs;		// vertical offset (0-4)
   output reg [4:0] bits;	// output (5 bits)

   // combine {digit,yofs} into single ROM address
   wire [6:0] 	    caseexpr = {digit,yofs};
   
   always @(*)
     case (caseexpr)/*{w:5,h:5,count:10}*/
       7'o00: bits = 5'b11111;
       7'o01: bits = 5'b10001;
       7'o02: bits = 5'b10001;
       7'o03: bits = 5'b10001;
       7'o04: bits = 5'b11111;

       7'o10: bits = 5'b01100;
       7'o11: bits = 5'b00100;
       7'o12: bits = 5'b00100;
       7'o13: bits = 5'b00100;
       7'o14: bits = 5'b11111;

       7'o20: bits = 5'b11111;
       7'o21: bits = 5'b00001;
       7'o22: bits = 5'b11111;
       7'o23: bits = 5'b10000;
       7'o24: bits = 5'b11111;

       7'o30: bits = 5'b11111;
       7'o31: bits = 5'b00001;
       7'o32: bits = 5'b11111;
       7'o33: bits = 5'b00001;
       7'o34: bits = 5'b11111;

       7'o40: bits = 5'b10001;
       7'o41: bits = 5'b10001;
       7'o42: bits = 5'b11111;
       7'o43: bits = 5'b00001;
       7'o44: bits = 5'b00001;

       7'o50: bits = 5'b11111;
       7'o51: bits = 5'b10000;
       7'o52: bits = 5'b11111;
       7'o53: bits = 5'b00001;
       7'o54: bits = 5'b11111;

       7'o60: bits = 5'b11111;
       7'o61: bits = 5'b10000;
       7'o62: bits = 5'b11111;
       7'o63: bits = 5'b10001;
       7'o64: bits = 5'b11111;

       7'o70: bits = 5'b11111;
       7'o71: bits = 5'b00001;
       7'o72: bits = 5'b00001;
       7'o73: bits = 5'b00001;
       7'o74: bits = 5'b00001;

       7'o100: bits = 5'b11111;
       7'o101: bits = 5'b10001;
       7'o102: bits = 5'b11111;
       7'o103: bits = 5'b10001;
       7'o104: bits = 5'b11111;

       7'o110: bits = 5'b11111;
       7'o111: bits = 5'b10001;
       7'o112: bits = 5'b11111;
       7'o113: bits = 5'b00001;
       7'o114: bits = 5'b11111;

`ifdef _HEX_
       // A
       7'o120: bits = 5'b01110;
       7'o121: bits = 5'b10001;
       7'o122: bits = 5'b11111;
       7'o123: bits = 5'b10001;
       7'o124: bits = 5'b10001;

       // B
       7'o130: bits = 5'b11110;
       7'o131: bits = 5'b10001;
       7'o132: bits = 5'b11110;
       7'o133: bits = 5'b10001;
       7'o134: bits = 5'b11110;

       // C
       7'o140: bits = 5'b01111;
       7'o141: bits = 5'b10000;
       7'o142: bits = 5'b10000;
       7'o143: bits = 5'b10000;
       7'o144: bits = 5'b01111;

       // D
       7'o150: bits = 5'b11110;
       7'o151: bits = 5'b10001;
       7'o152: bits = 5'b10001;
       7'o153: bits = 5'b10001;
       7'o154: bits = 5'b11110;

       // E
       7'o160: bits = 5'b11111;
       7'o161: bits = 5'b10000;
       7'o162: bits = 5'b11110;
       7'o163: bits = 5'b10000;
       7'o164: bits = 5'b11111;

       // F
       7'o170: bits = 5'b11111;
       7'o171: bits = 5'b10000;
       7'o172: bits = 5'b11110;
       7'o173: bits = 5'b10000;
       7'o174: bits = 5'b10000;
`endif
       default: bits = 0;
     endcase
endmodule

module digits10_array(digit, yofs, bits);
   
   input [3:0] digit;		// digit 0-9
   input [2:0] yofs;		// vertical offset (0-4)
   output [7:0] bits;		// output (5 bits)

   reg [7:0] 	bitarray[0:15][0:7]; // ROM array (16 x 5 x 5 bits)

   assign bits = bitarray[digit][yofs];	// assign module output
   
   integer 	i,j;
   
   initial begin/*{w:5,h:5,count:10}*/
      bitarray[0][0] <= 5'b11111;
      bitarray[0][1] <= 5'b10001;
      bitarray[0][2] <= 5'b10001;
      bitarray[0][3] <= 5'b10001;
      bitarray[0][4] <= 5'b11111;

      bitarray[1][0] <= 5'b01100;
      bitarray[1][1] <= 5'b00100;
      bitarray[1][2] <= 5'b00100;
      bitarray[1][3] <= 5'b00100;
      bitarray[1][4] <= 5'b11111;

      bitarray[2][0] <= 5'b11111;
      bitarray[2][1] <= 5'b00001;
      bitarray[2][2] <= 5'b11111;
      bitarray[2][3] <= 5'b10000;
      bitarray[2][4] <= 5'b11111;

      bitarray[3][0] <= 5'b11111;
      bitarray[3][1] <= 5'b00001;
      bitarray[3][2] <= 5'b11111;
      bitarray[3][3] <= 5'b00001;
      bitarray[3][4] <= 5'b11111;

      bitarray[4][0] <= 5'b10001;
      bitarray[4][1] <= 5'b10001;
      bitarray[4][2] <= 5'b11111;
      bitarray[4][3] <= 5'b00001;
      bitarray[4][4] <= 5'b00001;

      bitarray[5][0] <= 5'b11111;
      bitarray[5][1] <= 5'b10000;
      bitarray[5][2] <= 5'b11111;
      bitarray[5][3] <= 5'b00001;
      bitarray[5][4] <= 5'b11111;

      bitarray[6][0] <= 5'b11111;
      bitarray[6][1] <= 5'b10000;
      bitarray[6][2] <= 5'b11111;
      bitarray[6][3] <= 5'b10001;
      bitarray[6][4] <= 5'b11111;

      bitarray[7][0] <= 5'b11111;
      bitarray[7][1] <= 5'b00001;
      bitarray[7][2] <= 5'b00001;
      bitarray[7][3] <= 5'b00001;
      bitarray[7][4] <= 5'b00001;

      bitarray[8][0] <= 5'b11111;
      bitarray[8][1] <= 5'b10001;
      bitarray[8][2] <= 5'b11111;
      bitarray[8][3] <= 5'b10001;
      bitarray[8][4] <= 5'b11111;

      bitarray[9][0] <= 5'b11111;
      bitarray[9][1] <= 5'b10001;
      bitarray[9][2] <= 5'b11111;
      bitarray[9][3] <= 5'b00001;
      bitarray[9][4] <= 5'b11111;

      // clear unused array entries
      for (i = 0; i <= 9; i++)
	for (j = 5; j <= 7; j++)
    	  bitarray[i][j] <= 0; 

      for (i = 10; i <= 15; i++)
	for (j = 0; j <= 7; j++) 
          bitarray[i][j] <= 0;

      
   end
endmodule

// test module
module test_numbers_top(
			input  RST, // active low
			input  CLK, // 12MHz clock
			// VGA
			output VGA_BLUE,
			output VGA_GREEN,
			output VGA_RED,
			output VGA_HSYNC,
			output VGA_VSYNC);
   
   // RST - pull up
   wire 		       reset;
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

   wire 		       vsync = VGA_VSYNC;
   wire 		       hsync = VGA_HSYNC;
   wire 		       red   = VGA_RED;
   wire 		       green = VGA_GREEN;
   wire 		       blue  = VGA_BLUE;
   wire 		       clk;

   wire 		       display_on;
  // wire 			       vsync, hsync;
   wire [10:0] 	       hpos;
   wire [10:0] 	       vpos;
   
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
   
   wire [3:0] 		       digit = hpos[6:3] - 3;
   wire [2:0] 		       xofs = hpos[2:0];
   wire [2:0] 		       yofs = vpos[2:0];
   wire [7:0] 		       bits;
   
   // digits10_array numbers(
   digits10_case numbers(
			  .digit(digit),
			  .yofs(yofs),
			  .bits(bits)
			  );

   assign red = display_on && 0;
   assign green = display_on && bits[xofs ^ 3'b111];
   assign blue = display_on && 0;

endmodule

`endif
