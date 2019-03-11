
// `include "hvsync_generator.v"
`include "VGASyncGen.vh"
`include "digits10.v"
`include "ram.v"

/*
Displays a grid of digits on the CRT using a RAM module.
*/

module test_ram1_top(
		     input  CLK, // 16 or 12MHz clock
		     output VGA_BLUE,
		     output VGA_GREEN,
		     output VGA_RED,
		     output VGA_HSYNC,
		     output VGA_VSYNC);

   wire 	   vsync, hsync, red, green, blue, reset;
   assign VGA_VSYNC = vsync;
   assign VGA_HSYNC = hsync;
   assign VGA_RED = red;
   assign VGA_GREEN = green;
   assign VGA_BLUE = blue;

   wire 	   display_on;
   wire 	   clk;
   wire [10:0] 	   hpos;
   wire [10:0] 	   vpos;

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
     // // 1024x600@60Hz
     // #(.FDivider(66), 
     //   .QDivider(4),
     //   .activeHvideo(1024),
     //   .activeVvideo(600),
     //   .hfp(48),
     //   .hpulse(32),
     //   .hbp(240),
     //   .vfp(3),
     //   .vpulse(10),
     //   .vbp(12))
     // // 1024x768@60Hz (65MHz pixel clock)
     // #(.FDivider(49), // 12MHz base clock
     //   .QDivider(3), // 
     //   .activeHvideo(1024),
     //   .activeVvideo(768),
     //   .hfp(24),
     //   .hpulse(136),
     //   .hbp(133),
     //   .vfp(3),
     //   .vpulse(6),
     //   .vbp(29))
     vga_generator(.clk(CLK),
		   .hsync(hsync),
		   .vsync(vsync),
		   .x_px(hpos),
		   .y_px(vpos),
		   .activevideo(display_on),
		   .px_clk(clk));
  
  wire [9:0] ram_addr;
  wire [7:0] ram_read;
  reg [7:0] ram_write;
  reg ram_writeenable = 0;
  
  // RAM to hold 32x32 array of bytes
  RAM_sync ram(
	       .clk(clk),
	       .dout(ram_read),
	       .din(ram_write),
	       .addr(ram_addr),
	       .we(ram_writeenable)
	       );
  
  // hvsync_generator hvsync_gen(
  //   .clk(clk),
  //   .reset(reset),
  //   .hsync(hsync),
  //   .vsync(vsync),
  //   .display_on(display_on),
  //   .hpos(hpos),
  //   .vpos(vpos)
  // );
 
   wire [4:0] row = vpos[9:5];	// [7:3] 5-bit row, vpos / 8
   wire [4:0] col = hpos[9:5];	// [7:3] 5-bit column, hpos / 8
   wire [2:0] rom_yofs = vpos[2:0]; // scanline of cell
   wire [7:0] rom_bits;		   // 5 pixels per scanline
   
   wire [3:0] digit = ram_read[3:0]; // read digit from RAM
   wire [2:0] xofs = hpos[2:0];      // which pixel to draw (0-7)
  
  assign ram_addr = {row,col};	// 10-bit RAM address

  // digits ROM
  digits10_case numbers(
			.digit(digit),
			.yofs(rom_yofs),
			.bits(rom_bits)
			);

   // extract bit from ROM output
   wire       red = display_on && 0;
   wire       green = display_on && rom_bits[(xofs - 3) ^ 3'b111];
   wire       blue = display_on && 0;
   // assign rgb = {b,g,r};

  // increment the current RAM cell
  always @(posedge clk)
    case (hpos[2:0])
      // on 7th pixel of cell
      6: begin
        // increment RAM cell
        ram_write <= (ram_read + 1);
        // only enable write on last scanline of cell
        ram_writeenable <= (vpos[2:0] == 7);
      end
      // on 8th pixel of cell
      7: begin
        // disable write
        ram_writeenable <= 0;
      end
    endcase
      
endmodule
