# -- Project setup --
#
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
# PROJ = sprite_bitmap
# TOP = sprite_bitmap_top
#
# PROJ = sprite_rotation
# TOP = control_test_top
#
PROJ = ball_paddle
TOP = ball_paddle_top

BUILD     = ./build
DEVICE    = 8k

# for iCE40HX8K-EVB
FOOTPRINT = ct256
PINMAP = pins.pcf
# for TinyFPGA-BX (not yet)
#FOOTPRINT = cm81
#PINMAP = pins_tinyfpga.pcf

# Files
FILES = $(PROJ).v

.PHONY: all clean burn

all:
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	yosys -p "synth_ice40 -top $(TOP) -blif $(BUILD)/$(PROJ).blif" $(FILES)
	# Place and route using arachne
	arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ).asc -p $(PINMAP) $(BUILD)/$(PROJ).blif
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

prog: 
	iceprog $(BUILD)/$(PROJ).bin
	# tinyprog -p $(BUILD)/$(PROJ).bin

clean:
	rm build/*
