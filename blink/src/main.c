#include <avr/io.h>
#include <util/delay.h>

static volatile uint16_t ticks;

inline void __disable_interrupts() { asm volatile("cli" ::: "memory"); }

void start_tick_ms() {
  // Init
  ticks = 0UL;
  TCCR1A = 0;
  TCCR1B = 0;
  TCCR1C = 0;
  TIMSK1 = 0;
  TIFR1 = 1 << OCF1A;

  TCNT1 = 0L;
  OCR1A = F_CPU / 8 / 1000 - 1;
  TCCR1B = 1 << WGM12;   // CTC mode
  TCCR1B |= 1 << CS11;   // Prescaler 8
  TIMSK1 |= 1 << OCIE1A; // Enable TIM1_COMPA interrupt
  SREG |= 1 << SREG_I;   // Enable global interrupts
}

uint16_t get_tick_ms() {
  int8_t sr = SREG;
  __disable_interrupts();
  int16_t tc = ticks;
  SREG = sr;
  return tc;
}

__attribute__((signal)) void TIM1_COMPA() { ticks++; }

void delay_ms(uint16_t ms) {
  uint16_t t0 = get_tick_ms();
  while ((get_tick_ms() - t0) < ms) {
  }
}

int main() {
  start_tick_ms();
  DDRB |= 1 << DDB5; // Set PB5 as output
  while (1) {
    PORTB |= 1 << PORTB5;
    delay_ms(500);
    PORTB &= ~(1 << PORTB5);
    delay_ms(500);
  }
}
