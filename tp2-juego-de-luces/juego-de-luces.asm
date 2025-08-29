;*** Directivas de inclusion ***
LIST P=16F887
#include "p16f887.inc"

;**** Definición de Variables ****
	    CBLOCK  0X20
		    DELAY1 
		    DELAY2 
		    DELAY3
	    ENDC
;*** Inicializacion del programa ***
	ORG 0x00
	GOTO INICIO

;*** Configuracion de puertos***
	; Establesco como digital
	BSF STATUS, RPO
	BSF STATUS, RP1   ; BANK 3
	BCF ANSEL,  ANS5  ; RE5 DIGITAL
	BCF ANSELH, ANS12 ; RB0 DIGITAL
	BCF ANSELH, ANS10 ; RB1 DIGITAL
	BCF ANSELH, ANS8  ; RB2 DIGITAL
	BCF ANSELH, ANS9  ; RB3 DIGITAL
	BCF ANSELH, ANS11 ; RB4 DIGITAL
	BCF ANSELH, ANS13 ; RB5 DIGITAL
			  ; RB6 DIGITAL
			  ; RB7 DIGITAL
; Entrada o salida
        BCF STATUS, RP1   ; BANK 1
        BSF TRISE, TRISE0 ; RE0 ENTRADA
	BCF TRISB, TRISB0 ; RB0 SALIDA
	BCF TRISB, TRISB1 ; RB1 SALIDA
	BCF TRISB, TRISB2 ; RB2 SALIDA
	BCF TRISB, TRISB3 ; RB3 SALIDA
	BCF TRISB, TRISB4 ; RB4 SALIDA
	BCF TRISB, TRISB5 ; RB5 SALIDA
	BCF TRISB, TRISB6 ; RB6 SALIDA
	BCF TRISB, TRISB7 ; RB7 SALIDA
; Estado inicial
	BCF STATUS, RP0   ; BANK 0
	BCF PORTE, RE0	  ; RE0 LOW
	BCF PORTB, RB0	  ; RB0 LOW
	BCF PORTB, RB1    ; RB1 LOW
	BCF PORTB, RB2    ; RB2 LOW
	BCF PORTB, RB3    ; RB3 LOW
	BCF PORTB, RB4    ; RB4 LOW
	BCF PORTB, RB5    ; RB5 LOW
	BCF PORTB, RB6    ; RB6 LOW
	BCF PORTB, RB7    ; RB7 LOW

;*** Programa principal ***
INICIO	ORG 0x05    
		BTFSC   PORTE,0			; PULSO -> BARRIDO
	    GOTO    BLINKING		; NO PULSO -> VOY A BLINKING
	    MOVLW   b'10000000'		; pone en 1 el MSB
	    MOVWF   PORTB			; prende led  izq
BARRIDO_D   CALL    DELAY_200ms
	    BTFSC   PORTE,0			; PULSO -> BARRIDO
	    GOTO    BLINKING
	    RRF	    PORTB
	    BTFSS   PORTB,0			; Si el 1 llego al BIT0 de PORTB termina el loop y pasa a BARRIDO_I
	    GOTO    BARRIDO_D		; Sino sigue moviendo a la der
BARRIDO_I   CALL    DELAY_200ms
	    BTFSC   PORTE,0			; PULSO -> BARRIDO
	    GOTO    BLINKING		; NO PULSO -> VOY A BLINKING
	    RLF	    PORTB
	    BTFSS   PORTB,7			; Si el 1 llego al BIT7 de PORTB vuelve a BARRIDO_D
	    GOTO    BARRIDO_I		; Sino sigue moviendo a la izq
	    GOTO    BARRIDO_D

BLINKING	CLRF PORTB			; Apaga todos los leds
BLINK	    CALL    DELAY_1s
	    BTFSS   PORTE,0			; NO PULSO -> (salta) BLINKING
	    GOTO    BARRIDO_D		; PULSO -> BARRIDO
	    COMF    PORTB			; Invierte todos los leds
	    GOTO    BLINK			; Repite

;*** Subrutinas ***
	; Subrutina de Retardo con 3 Bucles Anidados para 200ms
DELAY_200ms		MOVLW   D'141'	; m -> W
				MOVWF   DELAY1	; W -> DELAY1
	    LOOP1	MOVLW   D'142'	; n -> W
				MOVWF   DELAY2	; W -> DELAY2
	    LOOP2	MOVLW   D'2'	; p -> W
				MOVWF   DELAY3	; W -> DELAY3
	    LOOP3	DECFSZ  DELAY3,F
	    GOTO    LOOP3
	    DECFSZ  DELAY2,F
	    GOTO    LOOP2
	    DECFSZ  DELAY1,F
	    GOTO    LOOP1
	    RETURN	

; Subrutina de retardo con 3 bucles anidados para 1s
DELAY_1s	MOVLW   D'255'	; 255 -> W
			MOVWF   DELAY1	; W -> DELAY1
	LOOPA	MOVLW   D'245'	; 245 -> W
			MOVWF   DELAY2	; W -> DELAY2
	LOOPB	MOVLW   D'4'	; p -> W
			MOVWF   DELAY3	; W -> DELAY3
	LOOPC	DECFSZ  DELAY3,F
			GOTO    LOOP3
			DECFSZ  DELAY2,F
			GOTO    LOOP2
			DECFSZ  DELAY1,F
			GOTO    LOOP1
			RETURN	
		
	

	    END


