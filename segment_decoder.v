/*
 * VGA output example.
 *
 * As we raster out the physical screen (640 X pixels, by 480 Y pixels),
 * we also step across the texture, but we do so at an angle, and rate
 * that are parameterised by time.
 *
 */

`include "VGASyncGen.vh"

module seven_segment_decoder(digit, segments);

  input [3:0] digit;
  output reg [6:0] segments;

  always @(*)
    case(digit)
      0: segments = 7'b1111110;
      1: segments = 7'b0110000;
      2: segments = 7'b1101101;
      3: segments = 7'b1111001;
      4: segments = 7'b0110011;
      5: segments = 7'b1011011;
      6: segments = 7'b1011111;
      7: segments = 7'b1110000;
      8: segments = 7'b1111111;
      9: segments = 7'b1111011;
      default: segments = 7'b0000000;
    endcase
   // segments = 7'b0110011;
   
endmodule

module segments_to_bitmap(segments, line, bits);
  
  input [6:0] segments;
  input [2:0] line;
  output reg [7:0] bits;
  
  always @(*)
    case (line)
      0:bits = (segments[6]?5'b11111:0) 
             ^ (segments[5]?5'b00001:0) 
             ^ (segments[1]?5'b10000:0);
      1:bits = (segments[1]?5'b10000:0) 
             ^ (segments[5]?5'b00001:0);
      2:bits = (segments[0]?5'b11111:0) 
             ^ (|segments[5:4]?5'b00001:0) 
             ^ (|segments[2:1]?5'b10000:0);
      3:bits = (segments[2]?5'b10000:0) 
             ^ (segments[4]?5'b00001:0);
      4:bits = (segments[3]?5'b11111:0) 
             ^ (segments[4]?5'b00001:0) 
             ^ (segments[2]?5'b10000:0);
      default:bits = 5'b00000;
    endcase
  
endmodule

// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
	    input CLK, // 16 or 12MHz clock
	    output VGA_BLUE,
	    output VGA_GREEN,
	    output VGA_RED,
	    output VGA_HSYNC,
	    output VGA_VSYNC);

   // drive USB pull-up resistor to '0' to disable USB
   // assign USBPU = 0;

   wire 	   vsync, hsync, red, green, blue, reset;
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
			    .activevideo(video_active),
			    .px_clk(pclk));

   reg 		   prev_vsync;

   wire [3:0] 	   digit = hpos[7:4];
   wire [2:0] 	   xofs = hpos[3:1];
   wire [2:0] 	   yofs = vpos[3:1];
   wire [7:0] 	   bits;
   wire [6:0] 	   segments;
   
   seven_segment_decoder decoder(
				 .digit(digit),
				 .segments(segments)
				 );
   
   segments_to_bitmap numbers(
			      .segments(segments),
			      .line(yofs),
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
   	   green = bits[~xofs]; // 0..7
   	   red = 1'b0;
   	   blue = 1'b0;
   	end else begin
           blue <= 1'b0;
           green <= 1'b0;
           red <= 1'b0;
   	end
     end

endmodule
