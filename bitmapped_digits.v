/*
 * VGA output example.
 *
 * As we raster out the physical screen (640 X pixels, by 480 Y pixels),
 * we also step across the texture, but we do so at an angle, and rate
 * that are parameterised by time.
 *
 */

// `define __COMMON_CODE_ROOT_FOLDER "../.."
// `include "../../hdl/core.vh"
`include "VGASyncGen.vh"

// module for 10-digit bitmap ROM
module digits10_case(digit, yofs, bits);
  
  input [3:0] digit;		// digit 0-9
  input [2:0] yofs;		// vertical offset (0-4)
  output reg [4:0] bits;	// output (5 bits)

  // combine {digit,yofs} into single ROM address
  wire [6:0] caseexpr = {digit,yofs};
  
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

      default: bits = 0;
    endcase
endmodule

module digits10_array(digit, yofs, bits);
  
  input [3:0] digit;		// digit 0-9
  input [2:0] yofs;		// vertical offset (0-4)
  output [7:0] bits;		// output (5 bits)

  reg [7:0] bitarray[0:15][0:7]; // ROM array (16 x 5 x 5 bits)

  assign bits = bitarray[digit][yofs];	// assign module output
  
  integer i,j;
  
  initial begin/*{w:5,h:5,count:10}*/
    bitarray[0][0] = 5'b11111;
    bitarray[0][1] = 5'b10001;
    bitarray[0][2] = 5'b10001;
    bitarray[0][3] = 5'b10001;
    bitarray[0][4] = 5'b11111;

    bitarray[1][0] = 5'b01100;
    bitarray[1][1] = 5'b00100;
    bitarray[1][2] = 5'b00100;
    bitarray[1][3] = 5'b00100;
    bitarray[1][4] = 5'b11111;

    bitarray[2][0] = 5'b11111;
    bitarray[2][1] = 5'b00001;
    bitarray[2][2] = 5'b11111;
    bitarray[2][3] = 5'b10000;
    bitarray[2][4] = 5'b11111;

    bitarray[3][0] = 5'b11111;
    bitarray[3][1] = 5'b00001;
    bitarray[3][2] = 5'b11111;
    bitarray[3][3] = 5'b00001;
    bitarray[3][4] = 5'b11111;

    bitarray[4][0] = 5'b10001;
    bitarray[4][1] = 5'b10001;
    bitarray[4][2] = 5'b11111;
    bitarray[4][3] = 5'b00001;
    bitarray[4][4] = 5'b00001;

    bitarray[5][0] = 5'b11111;
    bitarray[5][1] = 5'b10000;
    bitarray[5][2] = 5'b11111;
    bitarray[5][3] = 5'b00001;
    bitarray[5][4] = 5'b11111;

    bitarray[6][0] = 5'b11111;
    bitarray[6][1] = 5'b10000;
    bitarray[6][2] = 5'b11111;
    bitarray[6][3] = 5'b10001;
    bitarray[6][4] = 5'b11111;

    bitarray[7][0] = 5'b11111;
    bitarray[7][1] = 5'b00001;
    bitarray[7][2] = 5'b00001;
    bitarray[7][3] = 5'b00001;
    bitarray[7][4] = 5'b00001;

    bitarray[8][0] = 5'b11111;
    bitarray[8][1] = 5'b10001;
    bitarray[8][2] = 5'b11111;
    bitarray[8][3] = 5'b10001;
    bitarray[8][4] = 5'b11111;

    bitarray[9][0] = 5'b11111;
    bitarray[9][1] = 5'b10001;
    bitarray[9][2] = 5'b11111;
    bitarray[9][3] = 5'b00001;
    bitarray[9][4] = 5'b11111;

    // clear unused array entries
    for (i = 0; i <= 9; i++)
      for (j = 5; j <= 7; j++)
    	bitarray[i][j] = 0; 

    for (i = 10; i <= 15; i++)
      for (j = 0; j <= 7; j++) 
        bitarray[i][j] = 0; 
  end
endmodule


// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
	    input  CLK, // 16 or 12MHz clock
	    output VGA_BLUE,
	    output VGA_GREEN,
	    output VGA_RED,
	    output VGA_HSYNC,
	    output VGA_VSYNC);

   wire 	   vsync, hsync, red, green, blue;
   assign VGA_VSYNC = vsync;
   assign VGA_HSYNC = hsync;
   assign VGA_RED = red;
   assign VGA_GREEN = green;
   assign VGA_BLUE = blue;

   wire 	   pclk;
   reg [10:0] 	   hpos;
   reg [10:0] 	   vpos;
   wire 	   video_active;

   VGASyncGen vga_generator(.clk(CLK),
			    .hsync(hsync),
			    .vsync(vsync),
			    .x_px(hpos),
			    .y_px(vpos),
			    .activevideo(video_active),
			    .px_clk(pclk));

   reg 		   prev_vsync;

   wire [3:0] 	   digit = hpos[7:4];
   wire [2:0] 	   xofs = hpos[3:1];
   wire [2:0] 	   yofs = vpos[3:1];
   wire [7:0] 	   bits;
   
   digits10_array numbers(.digit(digit),
			 .yofs(yofs),
			 .bits(bits)
			 );
   
   always @(posedge pclk)
     begin
   	prev_vsync <= vsync;
   	if (prev_vsync && !vsync) begin
           // vsync has been brought low; we're in the vertical blanking period;
           // update per-frame animation values
   	end
   	if (video_active) begin
   	   red = 0;
   	   green = bits[xofs ^ 3'b111]; // 0..7
   	   blue = 0;
   	end else begin
           blue = 1'b0;
           green = 1'b0;
           red = 1'b0;
   	end
     end

endmodule
