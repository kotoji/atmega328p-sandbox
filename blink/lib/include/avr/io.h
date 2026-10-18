#ifndef _AVR_IO_H_
#define _AVR_IO_H_

#include <avr/sfr_defs.h>

#if defined(__AVR_ATmega328P__) || defined(__AVR_ATmega328__)
#include <avr/iom328p.h>
#else
#error "This file is for ATmega328P/328 only."
#endif

#include <avr/common.h>
#include <avr/portpins.h>

#endif /* _AVR_IO_H_ */
