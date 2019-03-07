# Project setup
# PROJ      = test_pattern
# PROJ      = segment_decoder
# PROJ      = bitmapped_digits
PROJ = ball_absolute
BUILD     = ./build
DEVICE    = 8k
# for iCE40HX8K-EVB
FOOTPRINT = ct256
PINMAP = pins.pcf
# for TinyFPGA-BX
#FOOTPRINT = cm81
#PINMAP = pins_tinyfpga.pcf

# Files
FILES = $(PROJ).v

.PHONY: all clean burn

all:
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	yosys -p "synth_ice40 -top top -blif $(BUILD)/$(PROJ).blif" $(FILES)
	# Place and route using arachne
	arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ).asc -p $(PINMAP) $(BUILD)/$(PROJ).blif
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

prog: 
	iceprog $(BUILD)/$(PROJ).bin
	# tinyprog -p $(BUILD)/$(PROJ).bin

clean:
	rm build/*
