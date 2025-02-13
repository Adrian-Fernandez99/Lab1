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
	LDI		R16, 0xFF		// Registro de entrada
	LDI		R17, 0xFF		// Registro de comparación
	LDI		R18, 0xFF		// Registro de delay
	LDI		R19, 0x00		// Registro de contador 1
	LDI		R20, 0x00		// Registro de contador 2

CONTADOR:					
	MOV		R17, R16		// Movemos valor actual a calor anterior
	OUT		PORTC, R20		// Matememos ambas salidas encendidas
	OUT		PORTB, R19
	IN		R16, PIND		// leemos el PIND
	CP		R16, R17		// Comparamos si no es la misma lecura que antes
	BREQ	CONTADOR		// Si es la misma regresamos			
DECREMENTO1:
	LDI		R17, 0xFB		// Valor que esperamos para decrementar el contador 1
	CP		R16, R17		// Comparamos con la entrada
	BRNE	INCREMENTO1		// Si no es el valor que esperamos pasamos a otra función 
	CALL	DELAY			// Realizamos antirebote
	IN		R16, PIND		// Leemos otra vez
	CP		R17, R16		// Comparamos
	BRNE	CONTADOR		// Si fue una lectura falsa se regresa al contador
BOTON_SUELTO:				// Función para esperar a que se suelte el boton
	CALL	DELAY			// Se espera un momento
	IN		R16, PIND		// Se lee otra vez 
	SBIS	PIND, 2			// Hasta que el boton deje de estar apachado (bit = 1) se salta
	RJMP	BOTON_SUELTO	// De lo contrario se vuelve a empezar
	DEC		R19				// Se realiza el decremento
	JMP		CONTADOR		// Se regresa al incio
INCREMENTO1:				// Este es igual que el decremento1 pero distinta operación
	LDI		R17, 0xF7		// Se sube valor deseado
	CP		R16, R17		// Se compara
	BRNE	DECREMENTO2
	CALL	DELAY			// Antirebote
	IN		R16, PIND
	CP		R17, R16
	BRNE	CONTADOR
BOTON_SUELTO2:				// Función para esperar a que se suelte el boton
	CALL	DELAY			// Misma logica, distinto bit verificado
	IN		R16, PIND
	SBIS	PIND, 3
	RJMP	BOTON_SUELTO2
	CALL	SUMA1			// Se realiza el incremento
	JMP		CONTADOR
DECREMENTO2:				// Este es igual que el decremento1 pero distinto registro
	LDI		R17, 0xEF		// Se sube valor deseado
	CP		R16, R17		// Se compara
	BRNE	INCREMENTO2
	CALL	DELAY			// Antirebote
	IN		R16, PIND
	CP		R17, R16
	BRNE	CONTADOR
BOTON_SUELTO3:				// Función para esperar a que se suelte el boton
	CALL	DELAY			// Misma logica, distinto bit verificado
	IN		R16, PIND
	SBIS	PIND, 4
	RJMP	BOTON_SUELTO3
	DEC		R20				// Se realiza el incremento
	JMP		CONTADOR
INCREMENTO2:				// Este es igual que el decremento2 pero distinta operación
	LDI		R17, 0xDF		// Se sube valor deseado
	CP		R16, R17		// Se compara
	BRNE	CONTADOR
	CALL	DELAY			// Antirebote
	IN		R16, PIND
	CP		R17, R16
	BRNE	CONTADOR
BOTON_SUELTO4:				// Función para esperar a que se suelte el boton
	CALL	DELAY			// Misma logica, distinto bit verificado
	IN		R16, PIND
	SBIS	PIND, 5
	RJMP	BOTON_SUELTO4
	CALL	SUMA2			// Se realiza el incremento
	JMP		CONTADOR

// Sub-rutina (no de interrupción)
DELAY:						// Se realiza un delay
	LDI		R18, 0xFF		// Se carga el valor maximo
SUB_DELAY1:
	DEC		R18				// Se baja el valor
	CPI		R18, 0
	BRNE	SUB_DELAY1		// Esperar hasta que el valor sea 0
	LDI		R18, 0xFF		// Cuando el valor es 0 pasar y volver a cargar el maximo
SUB_DELAY2:					// Repetir cuantas veces sea necesario para el anitrebote
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

SUMA1:						// Función para el incremento del primer contador
	INC		R19				// Se incrementa el valor
	SBRC	R19, 4			// Se observa si tiene más de 4 bits
	LDI		R19, 0x00		// En ese caso es overflow y debe regresar a 0
	RET

SUMA2:						// Función para el incremento del primer contador
	INC		R20				// Se incrementa el valor
	SBRC	R20, 4			// Se observa si tiene más de 4 bits
	LDI		R20, 0x00		// En ese caso es overflow y debe regresar a 0
	RET

// Rutinas de interrupción