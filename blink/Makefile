MCU        := atmega328p
F_CPU      := 16000000UL
BOOT_ADDR  := 0x7E00          # hfuse 0xDE = BOOTSZ 512B

CC         := avr-gcc
OBJCOPY    := avr-objcopy
SIZE       := avr-size
CFLAGS     := -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os -Wall -Wextra -std=gnu11 \
              -ffunction-sections -fdata-sections

AVRDUDE      ?= avrdude
AVRDUDE_CONF ?= -C /etc/avrdude.conf
PORT         ?= /dev/ttyUSB0
BAUD         ?= 19200
ISP          := $(AVRDUDE) $(AVRDUDE_CONF) -c stk500v1 -p atmega328p -P $(PORT) -b $(BAUD)

BUILD  := $(CURDIR)/.build
SSRCS  := $(wildcard src/*.S)
CSRCS  := $(wildcard src/*.c)
SOBJS  := $(SSRCS:src/%.S=$(BUILD)/%.o)
COBJS  := $(CSRCS:src/%.c=$(BUILD)/%.o)
OBJS   := $(SOBJS) $(COBJS)
$(info $(OBJS))

.PHONY: all
all: clean upload

.PHONY: clean
clean:
	rm -rf $(BUILD)

.PHONY: upload
upload: build
	$(ISP) -U flash:w:$(BUILD)/app.hex:i

.PHONY: build
build: $(BUILD)/app.hex

$(BUILD)/app.hex: $(BUILD)/app.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(BUILD)/app.elf: $(OBJS)
	$(CC) $(CFLAGS) -nostartfiles -T link.x -Wl,--gc-sections -o $@ $^

$(BUILD)/%.o: src/%.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD)/%.o: src/%.S
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) -c -o $@ $<
