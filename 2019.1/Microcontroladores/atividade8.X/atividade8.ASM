;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       ATIVIDADE 8                               *
;*             ANDRE OLIVEIRA DE SOUSA - 11325684                  *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 16F628A                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p16f628a.inc>	;ARQUIVO PADR�O MICROCHIP PARA 16F628A

	__CONFIG _BODEN_OFF & _CP_OFF & _CPD_OFF & _LVP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES

		;NOVAS VARI�VEIS
		CONTL
		CONTH
		CONT
		DISTANCIA_ENCONTRADA

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER�O ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000010'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISA		;COMO SA�DAS
	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISB		;COMO SA�DAS
	
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000000'
	MOVWF	T1CON
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL
	BCF	PORTB,RB0
	BCF	PORTB,RB1
	BCF	PORTB,RB2
	BCF	PORTB,RB3
	BCF	PORTB,RB4
	BCF	PORTB,RB5
	BCF	PORTB,RB6
	BCF	PORTB,RB7
	
COMECO	
	MOVLW	.0
	MOVWF	DISTANCIA_ENCONTRADA
	MOVLW	.2
	MOVWF	CONT
	CLRF	TMR1H		; ZERA OS TMR1H:TMR1L
	CLRF    TMR1L		
	MOVLW	B'00000000'		
	MOVWF	TMR1H		
	MOVLW	B'00000000'	
	MOVWF	TMR1L
	BCF	PORTA,RA0
	BCF	PORTA,RA1
	
	;PULSO PARA ACIONAR O ULTRASSON
	BSF	PORTA,RA0
	CALL	DELAY_10US
	BCF	PORTA,RA0
	
	;TESTE DA RESPOSTA DO ULTRASSON
TESTE_INICIAL_GP3
	BTFSC	PORTA,RA1	    ;VERIFICA SE GP3 RECEBEU A RESPOSTA
	GOTO	TEMPO_RESPOSTA	    ;SE RA1 FOR 1, RECEBEU A RESPOSTA
	GOTO	TESTE_INICIAL_GP3   ;SE RA1 FOR 0, AINDA N�O RECEBEU A RESPOSTA

	;VERIFICA POR QUANTO TEMPO O RA1 PERMANECEU EM N�VEL L�GICO ALTO
TEMPO_RESPOSTA
	;INICIA CONTADOR		
	BSF     T1CON,TMR1ON	    ;INICIA A CONTAGEM DE TEMPO	
	BTFSC	PORTA,RA1
	GOTO	$ - 1
	BCF	T1CON,TMR1ON	    ;P�RA A CONTAGEM DE TEMPO
	
	;REFERENCIA DE TEMPO PARA DIST�NCIA DE 5 CM
	;VERIFICAR SE SE � MENOR QUE 5 CM
	MOVLW	B'00000001'
	MOVWF	CONTH
	MOVLW	B'00100010'
	MOVWF	CONTL
	CALL	VERIFICAR_DISTANCIA ;QUANDO RA1 FOR 0 JA TEMOS O TEMPO PARA CALCULAR A DIST�NCIA
	BTFSC	DISTANCIA_ENCONTRADA,0
	GOTO	MENOR5
	
	;REFERENCIA DE TEMPO PARA DIST�NCIA DE 6 CM
	;VERIFICAR SE � MAIOR OU IGUAL A 5 E MENOR QUE 6 CM
	MOVLW	B'00000001'
	MOVWF	CONTH
	MOVLW	B'01011100'
	MOVWF	CONTL
	CALL	VERIFICAR_DISTANCIA
	BTFSC	DISTANCIA_ENCONTRADA,0
	GOTO	IGUAL5
	
	;REFERENCIA DE TEMPO PARA DIST�NCIA DE 7 CM
	;VERIFICAR SE � MAIOR OU IGUAL A 6 E MENOR QUE 7 CM
	MOVLW	B'00000001'
	MOVWF	CONTH
	MOVLW	B'10010110'
	MOVWF	CONTL
	CALL	VERIFICAR_DISTANCIA ;QUANDO RA1 FOR 0 JA TEMOS O TEMPO PARA CALCULAR A DIST�NCIA
	BTFSC	DISTANCIA_ENCONTRADA,0
	GOTO	IGUAL6
	
	;REFERENCIA DE TEMPO PARA DIST�NCIA DE 8 CM
	;VERIFICAR SE � MAIOR OU IGUAL A 7 E MENOR QUE 8
	MOVLW	B'00000001'
	MOVWF	CONTH
	MOVLW	B'11010000'
	MOVWF	CONTL
	CALL	VERIFICAR_DISTANCIA ;QUANDO RA1 FOR 0 JA TEMOS O TEMPO PARA CALCULAR A DIST�NCIA
	BTFSC	DISTANCIA_ENCONTRADA,0
	GOTO	IGUAL7
	
	;REFERENCIA DE TEMPO PARA DIST�NCIA DE 9 CM
	;VERIFICAR SE � MAIOR OU IGUAL A 8 E MENOR QUE 9
	MOVLW	B'00000010'
	MOVWF	CONTH
	MOVLW	B'00001010'
	MOVWF	CONTL
	CALL	VERIFICAR_DISTANCIA ;QUANDO RA1 FOR 0 JA TEMOS O TEMPO PARA CALCULAR A DIST�NCIA
	BTFSC	DISTANCIA_ENCONTRADA,0
	GOTO	IGUAL8
	
	;REFERENCIA DE TEMPO PARA DIST�NCIA DE 10 CM
	;VERIFICAR SE � MAIOR OU IGUAL A 9 E MENOR QUE 10
	MOVLW	B'00000010'
	MOVWF	CONTH
	MOVLW	B'01000100'
	MOVWF	CONTL
	CALL	VERIFICAR_DISTANCIA ;QUANDO RA1 FOR 0 JA TEMOS O TEMPO PARA CALCULAR A DIST�NCIA
	BTFSC	DISTANCIA_ENCONTRADA,0
	GOTO	IGUAL9
	
	;REFERENCIA DE TEMPO PARA DIST�NCIA DE 11 CM
	;VERIFICAR SE � MAIOR OU IGUAL A 10 E MENOR QUE 11
	MOVLW	B'00000010'
	MOVWF	CONTH
	MOVLW	B'01111110'
	MOVWF	CONTL
	CALL	VERIFICAR_DISTANCIA ;QUANDO RA1 FOR 0 JA TEMOS O TEMPO PARA CALCULAR A DIST�NCIA
	BTFSC	DISTANCIA_ENCONTRADA,0
	GOTO	IGUAL10
	
	;REFERENCIA DE TEMPO PARA DIST�NCIA DE 12 CM
	;VERIFICAR SE � MAIOR OU IGUAL A 11 E MENOR QUE 12
	MOVLW	B'00000010'
	MOVWF	CONTH
	MOVLW	B'10111000'
	MOVWF	CONTL
	CALL	VERIFICAR_DISTANCIA ;QUANDO RA1 FOR 0 JA TEMOS O TEMPO PARA CALCULAR A DIST�NCIA
	BTFSC	DISTANCIA_ENCONTRADA,0
	GOTO	IGUAL11
	
	;TESTANDO SE A DIST�NCIA � 12 OU � MAIOR
	BTFSC	STATUS,Z
	GOTO	IGUAL12
	GOTO	MAIOR12
	
VERIFICAR_DISTANCIA	
	;TESTE DE DIST�NCIA
	MOVFW	CONTH
	SUBWF	TMR1H,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL
	GOTO	MENOR

;TESTANDO BITS MAIS SIGNIFICATIVOS DO TIMER
MAIOR_IGUAL
	BTFSC	STATUS,Z
	GOTO	TESTA_LOW   ;BITS MAIS SIGNIFICATIVOS DEU IGUAL, ENTAO TESTAMOS OS MENOS SIGNIFICATIVOS
	GOTO	MAIOR	

MAIOR
	RETURN
	
MENOR	
	MOVLW	.1
	MOVWF	DISTANCIA_ENCONTRADA
	RETURN
	
;TESTANDO BITS MENOS SIGNIFICATIVOS DO TIMER
TESTA_LOW
	MOVFW	CONTL
	SUBWF	TMR1L,W
	BTFSC	STATUS,C
	GOTO	MAIOR_IGUAL_L
	GOTO	MENOR_L
	
MAIOR_IGUAL_L
	RETURN
	
MENOR_L	
	MOVLW	.1
	MOVWF	DISTANCIA_ENCONTRADA
	RETURN
	
	
	
MENOR5	
	BCF	PORTB,RB0
	BCF	PORTB,RB1
	BCF	PORTB,RB2
	BCF	PORTB,RB3
	BCF	PORTB,RB4
	BCF	PORTB,RB5
	BCF	PORTB,RB6
	BCF	PORTB,RB7
	GOTO	DELAY_60
	
IGUAL5
	BSF	PORTB,RB0
	BCF	PORTB,RB1
	BCF	PORTB,RB2
	BCF	PORTB,RB3
	BCF	PORTB,RB4
	BCF	PORTB,RB5
	BCF	PORTB,RB6
	BCF	PORTB,RB7
	GOTO	DELAY_60
	
IGUAL6
	BSF	PORTB,RB0
	BSF	PORTB,RB1
	BCF	PORTB,RB2
	BCF	PORTB,RB3
	BCF	PORTB,RB4
	BCF	PORTB,RB5
	BCF	PORTB,RB6
	BCF	PORTB,RB7
	GOTO	DELAY_60
	
IGUAL7
	BSF	PORTB,RB0
	BSF	PORTB,RB1
	BSF	PORTB,RB2
	BCF	PORTB,RB3
	BCF	PORTB,RB4
	BCF	PORTB,RB5
	BCF	PORTB,RB6
	BCF	PORTB,RB7
	GOTO	DELAY_60
	
IGUAL8
	BSF	PORTB,RB0
	BSF	PORTB,RB1
	BSF	PORTB,RB2
	BSF	PORTB,RB3
	BCF	PORTB,RB4
	BCF	PORTB,RB5
	BCF	PORTB,RB6
	BCF	PORTB,RB7
	GOTO	DELAY_60
	
IGUAL9
	BSF	PORTB,RB0
	BSF	PORTB,RB1
	BSF	PORTB,RB2
	BSF	PORTB,RB3
	BSF	PORTB,RB4
	BCF	PORTB,RB5
	BCF	PORTB,RB6
	BCF	PORTB,RB7
	GOTO	DELAY_60
	
IGUAL10
	BSF	PORTB,RB0
	BSF	PORTB,RB1
	BSF	PORTB,RB2
	BSF	PORTB,RB3
	BSF	PORTB,RB4
	BSF	PORTB,RB5
	BCF	PORTB,RB6
	BCF	PORTB,RB7
	GOTO	DELAY_60
	
IGUAL11
	BSF	PORTB,RB0
	BSF	PORTB,RB1
	BSF	PORTB,RB2
	BSF	PORTB,RB3
	BSF	PORTB,RB4
	BSF	PORTB,RB5
	BSF	PORTB,RB6
	BCF	PORTB,RB7
	GOTO	DELAY_60
	
IGUAL12
	BSF	PORTB,RB0
	BSF	PORTB,RB1
	BSF	PORTB,RB2
	BSF	PORTB,RB3
	BSF	PORTB,RB4
	BSF	PORTB,RB5
	BSF	PORTB,RB6
	BSF	PORTB,RB7
	GOTO	DELAY_60
	
MAIOR12
	;LEDS PISCANDO
	BSF	PORTB,RB0
	BSF	PORTB,RB1
	BSF	PORTB,RB2
	BSF	PORTB,RB3
	BSF	PORTB,RB4
	BSF	PORTB,RB5
	BSF	PORTB,RB6
	BSF	PORTB,RB7
DELAY_100
	;DELAY DE 100 MS PARA O OLHO HUMANO PODER ENXERGAR
	BANK1
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O DO TMR0
	BANK0
	BCF	INTCON,T0IF
	CLRF	TMR0
	MOVLW	.60
	MOVWF	TMR0
	BTFSS	INTCON,T0IF
	GOTO	$ - 1
	DECFSZ	CONT
	GOTO	DELAY_100
	;FIM DO DELAY
	;LEDS PISCANDO
	BCF	PORTB,RB0
	BCF	PORTB,RB1
	BCF	PORTB,RB2
	BCF	PORTB,RB3
	BCF	PORTB,RB4
	BCF	PORTB,RB5
	BCF	PORTB,RB6
	BCF	PORTB,RB7	

	
	;DELAY DE 60ms NECESS�RIO PARA DAR OUTRO PULSO DE SA�DA
DELAY_60
	BANK1
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O DO TMR0
	BANK0
	BCF	INTCON,T0IF
	CLRF	TMR0
	MOVLW	.10
	MOVWF	TMR0
	BTFSS	INTCON,T0IF
	GOTO	$ - 1
	;FIM DO DELAY
	
	GOTO	COMECO

DELAY_10US
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
