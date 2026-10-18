#include <avr/io.h>
#include <util/delay.h>

int main() {
  DDRB |= 1 << DDB5; // Set PB5 as output
  while (1) {
    PORTB |= 1 << PORTB5;
    delay_ms(500);
    PORTB &= ~(1 << PORTB5);
    delay_ms(500);
  }
}
