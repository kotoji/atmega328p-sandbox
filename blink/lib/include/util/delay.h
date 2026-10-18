#ifndef _UTIL_DELAY_H_
#define _UTIL_DELAY_H_

#if !defined(F_CPU)
#error "F_CPU is not defined. Please define the CPU frequency in Hz."
#endif

#include <stdint.h>

// 3 cycles per count
void _delay_loop_1(uint8_t __count) {
  asm volatile("1:\n"
               "  subi %0,1\n"
               "  brne 1b\n"
               : "+d"(__count));
}

// 4 cycles per count
void _delay_loop_2(uint16_t __count) {
  asm volatile("1:\n"
               "  sbiw %0,1\n"
               "  brne 1b\n"
               : "+w"(__count));
}

static inline void delay_ms(uint16_t ms) {
  while (ms--) {
    _delay_loop_2(F_CPU / 4 / 1000);
  }
}

#endif // _UTIL_DELAY_H_
