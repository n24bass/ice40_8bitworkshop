/*
 * VGA output example.
 *
 * As we raster out the physical screen (640 X pixels, by 480 Y pixels),
 * we also step across the texture, but we do so at an angle, and rate
 * that are parameterised by time.
 *
 */

`define __COMMON_CODE_ROOT_FOLDER "../.."
// `include "../../hdl/core.vh"
`include "VGASyncGen.vh"

// look in pins.pcf for all the pin names on the TinyFPGA BX board

module top (
	    input  CLK, // 16 or 12MHz clock
	    // output USBPU, // USB pull-up resistor
	    output VGA_BLUE,
	    output VGA_GREEN,
	    output VGA_RED,
	    output VGA_HSYNC,
	    output VGA_VSYNC);

   // drive USB pull-up resistor to '0' to disable USB
   // assign USBPU = 0;

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

   VGASyncGen
     // // 640x480@73Hz
     // #(.FDivider(83), 
     //   .QDivider(5),
     //   .activeHvideo(640),
     //   .activeVvideo(480),
     //   .hfp(24),
     //   .hpulse(40),
     //   .hbp(128),
     //   .vfp(9),
     //   .vpulse(2),
     //   .vbp(29))
     // 1024x600@60Hz
     #(.FDivider(66), 
       .QDivider(4),
       .activeHvideo(1024),
       .activeVvideo(600),
       .hfp(48),
       .hpulse(32),
       .hbp(240),
       .vfp(3),
       .vpulse(10),
       .vbp(12))
   vga_generator(.clk(CLK),
			    .hsync(hsync),
			    .vsync(vsync),
			    .x_px(hpos),
			    .y_px(vpos),
			    .activevideo(video_active),
			    .px_clk(pclk));

   reg 		   prev_vsync;

   always @(posedge pclk)
     begin
   	prev_vsync <= vsync;
   	if (prev_vsync && !vsync) begin
	   //
   	end
   	if (video_active) begin
           blue <= hpos[4];
           green <= vpos[4];
   	   red <= ((hpos & 7) == 0) || ((vpos & 7) == 0);
   	end else begin
           blue <= 1'b0;
           green <= 1'b0;
           red <= 1'b0;
   	end
     end

endmodule
