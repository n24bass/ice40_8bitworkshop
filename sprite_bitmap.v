
`ifndef SPRITE_BITMAP_H
 `define SPRITE_BITMAP_H

// `include "hvsync_generator.v"
 `include "VGASyncGen.vh"

/*
 Simple sprite renderer example.

 car_bitmap - ROM for a car sprite.
 sprite_bitmap_top - Example sprite rendering module.
 */

module car_bitmap(yofs, bits);
  
  input [3:0] yofs;
  output [7:0] bits;

  reg [7:0]    bitarray[0:15];
  
  assign bits = bitarray[yofs];
  
  initial begin /*{w:8,h:16}*/
    bitarray[0] = 8'b0;
    bitarray[1] = 8'b1100;
    bitarray[2] = 8'b11001100;
    bitarray[3] = 8'b11111100;
    bitarray[4] = 8'b11101100;
    bitarray[5] = 8'b11100000;
    bitarray[6] = 8'b1100000;
    bitarray[7] = 8'b1110000;
    bitarray[8] = 8'b110000;
    bitarray[9] = 8'b110000;
    bitarray[10] = 8'b110000;
    bitarray[11] = 8'b1101110;
    bitarray[12] = 8'b11101110;
    bitarray[13] = 8'b11111110;
    bitarray[14] = 8'b11101110;
    bitarray[15] = 8'b101110;
  end
  
endmodule

module sprite_bitmap_top(
			 input 	RST, // active low
			 input 	CLK, // 12MHz clock
			 output PDL_D,
			 output PDL_E,
			 // VGA
			 output VGA_BLUE,
			 output VGA_GREEN,
			 output VGA_RED,
			 output VGA_HSYNC,
			 output VGA_VSYNC);

  // RST - pull up
  wire 				reset;
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

  wire 				vsync, hsync, red, green, blue;
  assign VGA_VSYNC = vsync;
  assign VGA_HSYNC = hsync;
  assign VGA_RED = red;
  assign VGA_GREEN = green;
  assign VGA_BLUE = blue;
  wire 				clk;

  wire 				display_on;
  wire [10:0] 			hpos;
  wire [10:0] 			vpos;
  
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

  reg 				sprite_active;
  reg [3:0] 			car_sprite_xofs;
  reg [3:0] 			car_sprite_yofs;
  wire [7:0] 			car_sprite_bits;
  
  reg [10:0] 			player_x = 128;
  reg [10:0] 			player_y = 128;
  
  car_bitmap car(.yofs(car_sprite_yofs),
		 .bits(car_sprite_bits));

  // start Y counter when we hit the top border (player_y)
  reg	prev_hsync;
  always @(posedge clk) begin
    prev_hsync <= hsync;
    if (prev_hsync && !hsync) begin
      if (vpos == player_y) begin
	car_sprite_yofs <= 15;
      end else if (car_sprite_yofs != 0) begin
	car_sprite_yofs <= car_sprite_yofs - 1;
      end
    end
  end
  
  // restart X counter when we hit the left border (player_x)
  always @(posedge clk) begin
    if (hpos == player_x) begin
      car_sprite_xofs <= 15;
    end else if (car_sprite_xofs != 0) begin
      car_sprite_xofs <= car_sprite_xofs - 1;
    end
  end

  // mirror sprite in X direction
  wire [3:0] 			car_bit = car_sprite_xofs >= 8 ? 
				15 - car_sprite_xofs:
				car_sprite_xofs;

  wire 				car_gfx = car_sprite_bits[car_bit[2:0]];

  assign red = display_on && car_gfx;
  assign green = display_on && car_gfx;
  assign blue = display_on && car_gfx;

endmodule

`endif
