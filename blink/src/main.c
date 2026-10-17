// Data Direction Register for Port B
#define DDRB (*(volatile unsigned char *)0x24)
// State Register for Port B
#define PORTB (*(volatile unsigned char *)0x25)

static volatile unsigned int i = 0;

int main() {
  DDRB = 1 << 5; // Set PB5 as output (for the LED)
  while (1) {
    PORTB = 1 << 5; // Set PB5 high (turn on the LED)
    for (i = 0; i < 65000; i++) {
    }
    PORTB = 0;
    for (i = 0; i < 65000; i++) {
    }
  }
}
