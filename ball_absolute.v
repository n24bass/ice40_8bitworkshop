/*
 * VGA output example.
 * A bouncing ball using absolute coordinates.
 */

// look in pins.pcf for all the pin names on the iCE40HX8K-B-EVB

`include "VGASyncGen.vh"

`define VGAMODE1

module top (
            input RST, // active low
            input CLK, // 12MHz clock
            // VGA
            output VGA_BLUE,
            output VGA_GREEN,
            output VGA_RED,
            output VGA_HSYNC,
            output VGA_VSYNC,
            output LED1
            );

   // RST - pull up
   wire reset;
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

   assign LED1 = !reset;
   
   // -- VGA --

`ifdef VGAMODE1
   parameter VGA_HSIZE = 640;
   parameter VGA_VSIZE = 480;
`elsif VGAMODE2
   parameter VGA_HSIZE = 1024;
   parameter VGA_VSIZE = 600;
`elsif VGAMODE3
   parameter VGA_HSIZE = 1024;
   parameter VGA_VSIZE = 768;
`endif
   
   wire vsync = VGA_VSYNC;
   wire hsync = VGA_HSYNC;
   wire red   = VGA_RED;
   wire green = VGA_GREEN;
   wire blue  = VGA_BLUE;
   wire pclk;
   reg [10:0] hpos;
   reg [10:0] vpos;
   wire display_on;
   wire vsync, hsync;

   VGASyncGen
`ifdef VGAMODE1
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
`elsif VGAMODE2
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
`elsif VGAMODE3
     // 1024x768@60Hz (65MHz pixel clock)
     #(.FDivider(49), // 12MHz base clock
       .QDivider(3), // 
       .activeHvideo(1024),
       .activeVvideo(768),
       .hfp(24),
       .hpulse(136),
       .hbp(133),
       .vfp(3),
       .vpulse(6),
       .vbp(29))
`endif
     vga_generator(.clk(CLK),
                   .hsync(hsync),
                   .vsync(vsync),
                   .x_px(hpos),
                   .y_px(vpos),
                   .activevideo(display_on),
                   .px_clk(pclk));

   // -- 

   localparam BALL_SPEED = 2;
   localparam BALL_SIZE = 4;
   localparam ball_horiz_initial = VGA_HSIZE / 2;
   localparam ball_vert_initial = VGA_VSIZE / 2;

   // ball position
   reg [10:0] ball_hpos = ball_horiz_initial;
   reg [10:0] ball_vpos = ball_vert_initial;

   // ball velocity vector
   reg [10:0] ball_horiz_move = BALL_SPEED;
   reg [10:0] ball_vert_move  = BALL_SPEED;

   wire ball_hgfx = ((hpos - ball_hpos) < BALL_SIZE) && ((hpos - ball_hpos) >= 0);
   wire ball_vgfx = ((vpos - ball_vpos) < BALL_SIZE) && ((vpos - ball_vpos) >= 0);
   // wire ball_gfx = ball_hgfx && ball_vgfx;
   wire grid_gfx = (((hpos&7)==0) && ((vpos&7)==0));

   reg prev_vsync;
   always @(posedge pclk) begin
      prev_vsync <= vsync;
      if (prev_vsync && !vsync) begin
         // ball collide
         if (ball_hpos >= (VGA_HSIZE - BALL_SIZE)) ball_horiz_move = -BALL_SPEED;
         else if (ball_hpos <= 0) ball_horiz_move = BALL_SPEED;
         if (ball_vpos >= (VGA_VSIZE - BALL_SIZE)) ball_vert_move = -BALL_SPEED;
         else if (ball_vpos <= 0) ball_vert_move = BALL_SPEED;

         if (reset) begin
            // add velocity vector to ball position
            ball_hpos <= ball_hpos + ball_horiz_move;
            ball_vpos <= ball_vpos + ball_vert_move;
         end else begin
            // reset ball position
            ball_hpos <= ball_horiz_initial;
            ball_vpos <= ball_vert_initial;
         end
      end
      if (display_on) begin
         red   <= ball_hgfx;
         green <= (grid_gfx | (ball_hgfx & ball_vgfx));
         blue  <= ball_vgfx;
      end else begin
         red   <= 0;
         green <= 0;
         blue  <= 0;
      end
   end

endmodule
