  .equ SPL,  0x3d   ; Stack Pointer Low
  .equ SPH,  0x3e   ; Stack Pointer High
  .equ SREG, 0x3f   ; Status Register

 .section .vector,"ax",@progbits
_vector_base:
  .org  0x0000
  jmp   _start      ; External Pin, Power-on Reset, Brown-out Reset and Watchdog System Reset
  jmp   EXT_INT0    ; External Interrupt Request 0
  jmp   EXT_INT1    ; External Interrupt Request 1
  jmp   PCINT0      ; Pin Change Interrupt Request 0
  jmp   PCINT1      ; Pin Change Interrupt Request 1
  jmp   PCINT2      ; Pin Change Interrupt Request 2
  jmp   WDT_OVF     ; Watchdog Time-out Interrupt
  jmp   TIM2_COMPA  ; Timer/Counter2 Compare Match A
  jmp   TIM2_COMPB  ; Timer/Counter2 Compare Match B
  jmp   TIM2_OVF    ; Timer/Counter2 Overflow
  jmp   TIM1_CAPT   ; Timer/Counter1 Capture Event
  jmp   TIM1_COMPA  ; Timer/Counter1 Compare Match A
  jmp   TIM1_COMPB  ; Timer/Counter1 Compare Match B
  jmp   TIM1_OVF    ; Timer/Counter1 Overflow
  jmp   TIM0_CAPT   ; Timer/Counter0 Capture Event
  jmp   TIM0_COMPA  ; Timer/Counter0 Compare Match A
  jmp   TIM0_COMPB  ; Timer/Counter0 Compare Match B
  jmp   TIM0_OVF    ; Timer/Counter0 Overflow
  jmp   SPI_STC     ; SPI Serial Transfer Complete
  jmp   USART_RXC   ; USART, Rx Complete
  jmp   USART_UDRE  ; USART Data Register Empty
  jmp   USART_TXC   ; USART, Tx Complete
  jmp   ADC         ; ADC Conversion Complete
  jmp   EE_RDY      ; EEPROM Ready
  jmp   ANA_COMP    ; Analog Comparator
  jmp   TWI         ; 2-wire Serial Interface
  jmp   SPM_RDY     ; Store Program Memory Ready

  .section .init,"ax",@progbits
  .global _start
_start:
  jmp handle_reset

  .section .text.vector_handler,"ax",@progbits
  .weak   EXT_INT0
  .weak   EXT_INT1
  .weak   PCINT0
  .weak   PCINT1
  .weak   PCINT2
  .weak   WDT_OVF
  .weak   TIM2_COMPA
  .weak   TIM2_COMPB
  .weak   TIM2_OVF
  .weak   TIM1_CAPT
  .weak   TIM1_COMPA
  .weak   TIM1_COMPB
  .weak   TIM1_OVF
  .weak   TIM0_CAPT
  .weak   TIM0_COMPA
  .weak   TIM0_COMPB
  .weak   TIM0_OVF
  .weak   SPI_STC
  .weak   USART_RXC
  .weak   USART_UDRE
  .weak   USART_TXC
  .weak   ADC
  .weak   EE_RDY
  .weak   ANA_COMP
  .weak   TWI
  .weak   SPM_RDY

EXT_INT0:
EXT_INT1:
PCINT0:
PCINT1:
PCINT2:
WDT_OVF:
TIM2_COMPA:
TIM2_COMPB:
TIM2_OVF:
TIM1_CAPT:
TIM1_COMPA:
TIM1_COMPB:
TIM1_OVF:
TIM0_CAPT:
TIM0_COMPA:
TIM0_COMPB:
TIM0_OVF:
SPI_STC:
USART_RXC:
USART_UDRE:
USART_TXC:
ADC:
EE_RDY:
ANA_COMP:
TWI:
SPM_RDY:
1:
  rjmp 1b

  .section .text.handle_reset,"ax",@progbits
handle_reset:
  cli           ; disable interrupts
  clr  r1       ; clear zero register (r1)
  out  SREG, r1 ; clear status register
  /* init stack pointer */
  ldi  r16, hi8(_eusrstack - 1)
  out  SPH, r16
  ldi  r16, lo8(_eusrstack - 1)
  out  SPL, r16
  /* init data section */
  ldi  r30, lo8(_data_lma)
  ldi  r31, hi8(_data_lma)
  ldi  r26, lo8(_data_vma)
  ldi  r27, hi8(_data_vma)
  ldi  r28, lo8(_edata)
  ldi  r29, hi8(_edata)
  cp   r26, r28
  cpc  r27, r29
  brsh 2f
1:
  lpm  r0,  Z+
  st   X+,  r0
  cp   r26, r28
  cpc  r27, r29
  brsh 2f
  rjmp 1b
2:
  /* init bss section */
  ldi  r26, lo8(_sbss)
  ldi  r27, hi8(_sbss)
  ldi  r28, lo8(_ebss)
  ldi  r29, hi8(_ebss)
  cp   r26, r28
  cpc  r27, r29
  brsh 2f
1:
  st   X+,  r1
  cp   r26, r28
  cpc  r27, r29
  brsh 2f
  rjmp 1b
2:
  /* enable interrupts */
  sei
  /* call main */
  call main

loop:
  rjmp loop
