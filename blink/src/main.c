#include <avr/io.h>

static volatile unsigned int i;
static volatile unsigned long j = 1;

int main() {
  DDRB |= 1 << 5; // Set PB5 as output (for the LED)
  while (1) {
    PORTB |= 1 << 5; // Set PB5 high (turn on the LED)
    for (i = 0; i < 65000; i++) {
    }
    PORTB = 0;
    for (j = 0; j < 65000; j++) {
    }
  }
}
