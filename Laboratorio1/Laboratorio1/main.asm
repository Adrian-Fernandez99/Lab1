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

	LDI		R16, 0x00
	OUT		DDRC, R16		// Setear puerto C como entrada
	LDI		R16, 0xFF
	OUT		PORTC, R16		// Habilitar pull-ups en puerto C

// PORTB como salida inicialmente encendido
	LDI		R16, 0xFF
	OUT		DDRB, R16		// Setear puerto B como salida

// Realizar variables
	LDI		R17, 0xFF
	LDI		R19, 0x00
	LDI		R20, 0x00

CONTADOR:
	// Revisar entrada D
	IN		R16, PIND		// Leemos la entrada del puerto D
	CP		R17, R16		// Comparamos para ver si hubo cambio de estado
	BRNE	+1
	CALL	DEDEDO
	// Revisar entrada C
	IN		R16, PINC		// Leemos la entrada del puerto D
	CP		R17, R16		// Comparamos para ver si hubo cambio de estado
	BRNE	+1
	CALL	CECECO
	BREQ	CONTADOR		// Si no hubo cambio regresamos

SUMAD:
// Establecemos el bit 2 como botón de suma y el bit 3 como resta.
	SBRS	R16, 2			// Revisamos que el bit de suma este encendido	
	CALL	SUMA1
	SBRS	R16, 3			// Revisamos que el bit de resta este encendido	
	DEC		R19
	OUT		PINB, R19
	RJMP	CONTADOR

SUMAC:
	// Establecemos el bit 2 como botón de suma y el bit 3 como resta.
	SBRS	R16, 2			// Revisamos que el bit de suma este encendido	
	CALL	SUMA2
	SBRS	R16, 3			// Revisamos que el bit de resta este encendido	
	DEC		R20
	OUT		PINB, R20
	RJMP	CONTADOR

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

DEDEDO:
	CALL	DELAY			// Si hubo cambio esperamos para evitar rebote
	IN		R16, PIND		// Nos aseguramos que la elctura haya sido correcta
	CP		R17, R16
	BREQ	CONTADOR
	MOV		R17, R16		// Generamos nuevo estado antiguo
	JMP		SUMAD

CECECO:
	CALL	DELAY			// Si hubo cambio esperamos para evitar rebote
	IN		R16, PINC		// Nos aseguramos que la elctura haya sido correcta
	CP		R17, R16
	BREQ	CONTADOR
	MOV		R17, R16		// Generamos nuevo estado antiguo
	JMP		SUMAC

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