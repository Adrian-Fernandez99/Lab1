/*

	Laboratorio1.asm

Created: 2/7/2025 5:10:10 PM
Author : Adrián Fernández
Descripción:
	Se realiza dos contadores binario de 4 bits.
	El conteo es visto por medio de LEDs en la protoboard.
	Se usan pushbuttons para el incremento y decrecimiento 
	de los valores.
*/


// Configurar la pila
.include "M328PDEF.inc"
.cseg
.org 0x0000


// Configurar el MCU
LDI R16, LOW(RAMEND)
OUT SPL, R16
LDI R16, HIGH(RAMEND)
OUT SPH, R16

SETUP:
// Configurar pines de entrada y salida (DDRx, PORTx, PINx)
// PORTD como entrada con pull-up habilitado
	LDI		R16, 0x00
	OUT		DDRD, R16		// Setear puerto D como entrada
	LDI		R16, 0xFF
	OUT		PORTD, R16		// Habilitar pull-ups en puerto D

// PORTB como salida inicialmente encendido
	LDI		R16, 0xFF
	OUT		DDRB, R16		// Setear puerto B como salida
// PORTD como salida inicialmente encendido
	LDI		R16, 0xFF
	OUT		DDRC, R16		// Setear puerto C como salida

// Realizar variables
	LDI		R17, 0xFB
	LDI		R19, 0x00
	LDI		R20, 0x00
	LDI		R21, 0xF7
	LDI		R22, 0xEF
	LDI		R23, 0xDF

CONTADOR:
	IN		R16, PIND
DECREMENTO1:
	CP		R16, R17
	BRNE	INCREMENTO1
	CALL	DELAY
	IN		R16, PIND
	CP		R17, R16
	BRNE	INCREMENTO1
	DEC		R19
	OUT		PINB, R19
INCREMENTO1:
	CP		R16, R21
	BRNE	DECREMENTO2
	CALL	DELAY
	IN		R16, PIND
	CP		R21, R16
	CALL	SUMA1
DECREMENTO2:
	CP		R16, R22
	BRNE	INCREMENTO2
	CALL	DELAY
	IN		R16, PIND
	CP		R22, R16
	BRNE	INCREMENTO2
	DEC		R20
	OUT		PINC, R20
INCREMENTO2:
	CP		R16, R23
	BRNE	CONTADOR
	CALL	DELAY
	IN		R16, PIND
	CP		R21, R16
	CALL	SUMA2
	JMP CONTADOR

// Sub-rutina (no de interrupción)
DELAY:
	LDI		R18, 0xFF
SUB_DELAY1:
	DEC		R18
	CPI		R18, 0
	BRNE	SUB_DELAY1
	LDI		R18, 0xFF
SUB_DELAY2:
	DEC		R18
	CPI		R18, 0
	BRNE	SUB_DELAY2
	LDI		R18, 0xFF
SUB_DELAY3:
	DEC		R18
	CPI		R18, 0
	BRNE	SUB_DELAY3
	RET

SUMA1:
	INC		R19
	SBRC	R19, 4
	LDI		R19, 0x00
	OUT		PINB, R19
	RET

SUMA2:
	INC		R20
	SBRC	R20, 4
	LDI		R20, 0x00
	OUT		PINC, R20
	RET

// Rutinas de interrupción