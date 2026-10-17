ENTRY( _start )

__bootloader_size = 512;
__register_size = 0x100;
__stack_size = 512;

PROVIDE( _stack_size = __stack_size );
PROVIDE( _bootloader_size = __bootloader_size );

MEMORY
{
  /* 1 word = 16 bit */
  FLASH (rx)    : ORIGIN = 0x00000000, LENGTH = 32K - __bootloader_size

  /* 1 word = 8 bit */
  SRAM  (rwx)   : ORIGIN = 0x00800000, LENGTH = 2K
  EEPROM (rw)   : ORIGIN = 0x00810000, LENGTH = 1K
}

SECTIONS
{
  .vector :
  {
    /* --gc-sections flag removes vectors as unused without KEEP */
    KEEP(*(.vector));
    . = ALIGN(2);
  } >FLASH AT>FLASH

  .text :
  {
    . = ALIGN(2);
    *(.text .text.*)
    *(.rodata .rodata.*)
    . = ALIGN(2);
  } >FLASH AT>FLASH

  /* the first 256 bytes of SRAM is reserved for registers
     (32 general purpose registers, 64 I/O registers, and 160 I/O Ext registers) */
  .dalign ORIGIN(SRAM) + __register_size:
  {
    . = ALIGN(2);
    PROVIDE( _data_vma = . );
  } >SRAM AT>FLASH

  .dlalign :
  {
    . = ALIGN(2);
    PROVIDE( _data_lma = . );
  } >FLASH AT>FLASH

  .data :
  {
    PROVIDE( _sdata = . );
    *(.data .data.*)
    . = ALIGN(2);
    PROVIDE( _edata = . );
  } >SRAM AT>FLASH

  /* linker ignores .dalign, .dlalign, and .data sections when .data section is empty,
     so .bss section might be placed at the top of SRAM unless specified explicitly. */
  .bss _edata (NOLOAD) :
  {
    . = ALIGN(1);
    PROVIDE( _sbss = . );
    *(.bss*)
    . = ALIGN(1);
    PROVIDE( _ebss = . );
  } >SRAM

  .stack ORIGIN(SRAM) + LENGTH(SRAM) - __stack_size (NOLOAD):
  {
    PROVIDE( _heap_end = . );
    . = ALIGN(1);
    PROVIDE( _susrstack = . );
    . = . + __stack_size;
    PROVIDE( _eusrstack = . );
  } >SRAM
}
