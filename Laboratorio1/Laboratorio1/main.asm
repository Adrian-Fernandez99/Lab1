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
	LDI		R16, 0xFF
	LDI		R17, 0xFF
	LDI		R18, 0xFF
	LDI		R19, 0x00
	LDI		R20, 0x00

CONTADOR:
	MOV		R17, R16
	OUT		PORTC, R20
	OUT		PORTB, R19
	IN		R16, PIND
	CP		R16, R17
	BREQ	CONTADOR
DECREMENTO1:
	LDI		R17, 0xFB
	CP		R16, R17
	BRNE	INCREMENTO1
	CALL	DELAY
	IN		R16, PIND
	CP		R17, R16
	BRNE	CONTADOR
BOTON_SUELTO:
	CALL	DELAY
	IN		R16, PIND
	SBIS	PIND, 2
	RJMP	BOTON_SUELTO
	DEC		R19
	JMP		CONTADOR
INCREMENTO1:
	LDI		R17, 0xF7
	CP		R16, R17
	BRNE	DECREMENTO2
	CALL	DELAY
	IN		R16, PIND
	CP		R17, R16
	BRNE	CONTADOR
BOTON_SUELTO2:
	CALL	DELAY
	IN		R16, PIND
	SBIS	PIND, 3
	RJMP	BOTON_SUELTO2
	CALL	SUMA1
	JMP		CONTADOR
DECREMENTO2:
	LDI		R17, 0xEF
	CP		R16, R17
	BRNE	INCREMENTO2
	CALL	DELAY
	IN		R16, PIND
	CP		R17, R16
	BRNE	CONTADOR
BOTON_SUELTO3:
	CALL	DELAY
	IN		R16, PIND
	SBIS	PIND, 4
	RJMP	BOTON_SUELTO3
	DEC		R20
	JMP		CONTADOR
INCREMENTO2:
	LDI		R17, 0xDF
	CP		R16, R17
	BRNE	CONTADOR
	CALL	DELAY
	IN		R16, PIND
	CP		R17, R16
	BRNE	CONTADOR
BOTON_SUELTO4:
	CALL	DELAY
	IN		R16, PIND
	SBIS	PIND, 5
	RJMP	BOTON_SUELTO4
	CALL	SUMA2
	JMP		CONTADOR

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
	LDI		R18, 0xFF
SUB_DELAY4:
	DEC		R18
	CPI		R18, 0
	BRNE	SUB_DELAY4
	RET

SUMA1:
	INC		R19
	SBRC	R19, 4
	LDI		R19, 0x00
	RET

SUMA2:
	INC		R20
	SBRC	R20, 4
	LDI		R20, 0x00
	RET

// Rutinas de interrupción