work in progress.

# Overview
 "Designing Video Game Hardware in Verilog" from http://8bitworkshop.com/ implemented for iCE40HX8K Breakout Board. 

## Prerequisites

The projects in this repository include a Makefile for easy compilation of the verilog and downloading of the bitstream to the FPGA. This Makefile depends on the open source IceStorm toolchain described at http://www.clifford.at/icestorm/. 

You'll need to add a VGA output to your iCE40HX8K Breakout Board.  The basic schematic used
can be found here: https://www.fpga4fun.com/PongGame.html

The default pins used by the example are:

| iCE40HX8K-B-EVB pin | VGA pin | VGA signal | other |
|-----------------|---------|------------|------------|
| C16| 14 | VSYNC | |
| D16 | 13 | HSYNC | |
| E16 | 1 | RED | |
| F16 | 2 | GREEN | |
| G16 | 3 | BLUE | |
| H16 |  | | RESET |

Don't forget the 270ohm resistors in-line with the RGB pins. RESET (used in few projects) is active low.

## Project

* test_pattern - 10. A Test Pattern 
* segment_decorder - 11. Digits
* bitmapped_digits
* ball_absolute - 12. A Movin Ball
* digits10
* scoreboard
* chardisplay - 14. RAM, 15. Tile Graphics
* sprite_bitmap - 17. Sprites
* sprite_rotation .. work in progress.

## Makefile

Select PROJ and TOP for the target project in Makefile.

```
# PROJ      = test_pattern
# TOP = top
#
# PROJ      = segment_decoder
# TOP = top
#
# PROJ      = bitmapped_digits
# TOP = top
#
# PROJ = ball_absolute
# TOP = top
#
# PROJ = digits10
# TOP = test_numbers_top
# 
# PROJ = scoreboard
# TOP = scoreboard_top
#
# PROJ = chardisplay
# TOP = test_ram1_top
#
PROJ = sprite_bitmap
TOP = sprite_bitmap_top
```

Make.

```
$ make
```

Program.

```
$ make prog
```

## VGA Resolution

Default resolution is set to 1024x768 in VGASyncGen.vh. You can select deferent value. For example, in ball_absolute.v.

```
`define VGAMODE1

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
```

Enjoy.
