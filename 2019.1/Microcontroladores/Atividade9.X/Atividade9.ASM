;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       ATIVIDADE 9                               *
;*             ANDRE OLIVEIRA DE SOUSA - 11325684                  *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;NOVAS VARIÁVEIS
		MULTIPLO_51_LOW	
		MULTIPLO_51_HIGH
		DIV_PARCIAL_LOW
		DIV_PARCIAL_HIGH
		CONT10
		VALOR_ENCONTRADO
		FLAG
		VALOR1
		VALOR2
		VALOR3
		VALOR4
		RESTO_AUX
		
		

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÃO ESCRITAS AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.
	
	
ENCONTRANDO_RESTO
	MOVFW	MULTIPLO_51_LOW
	SUBWF	DIV_PARCIAL_LOW,F	
	
	RETURN

MULT_RESTO
	MOVLW	.9
	MOVWF	CONT10
	MOVLW	.0
	MOVWF	DIV_PARCIAL_HIGH
	MOVFW	DIV_PARCIAL_LOW
	MOVWF	RESTO_AUX
	
CONTINUA_RESTO	
	MOVFW	RESTO_AUX
	ADDWF	DIV_PARCIAL_LOW,F
	BTFSC	STATUS,C
	INCF	DIV_PARCIAL_HIGH
	DECFSZ	CONT10
	GOTO	CONTINUA_RESTO
	
	RETURN
	
	
	
DEC_MULT_DIVISOR_HIGH
	DECF	MULTIPLO_51_HIGH
	MOVLW	.51
	SUBWF	MULTIPLO_51_LOW,F
	
	RETURN
	
	
DEC_MULT_DIVISOR_LOW
	MOVLW	.51
	SUBWF	MULTIPLO_51_LOW,F
	ADDWF	MULTIPLO_51_LOW,W	;TESTANDO SE HÁ ESTOURO DE CARRY
	BTFSC	STATUS,C		;SE HOUVER ENTÃO TEMOS QUE DECREMENTAR
	DECF	MULTIPLO_51_HIGH	;O MULTIPLO_51_HIGH TAMBÉM
					
	RETURN
	
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000100'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00010100'	;VAMOS USAR A PORTA 2 COMO ENTRADA
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00001001'	;BIT 0 HABILITA O CONVERSOR A OPERAR, APESAR QUE NÃO INICIOU A CONVERSÃO
	MOVWF	ADCON0		;BIT 3 E 2 ESTANDO EM 1 E 0 RESPECTIVAMENTE PERMITE USAR A PORTA 2 COMO ENTRADA
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	;OBS.: ROTINAS QUE SÃO CHAMADAS VIA CALL ESTÃO NA PARTE DE ROTINAS LÁ EM CIMA
	;ROTINAS QUE SÃO CHAMADAS VIA GOTO, ESTÃO NA SEQUÊNCIA NO DECORRRER DO CÓDIGO
	
MAIN
	
	 
	MOVLW	.1			
	MOVWF	FLAG	
	MOVLW	.1
	MOVWF	VALOR_ENCONTRADO
	MOVLW	.51
	MOVWF	MULTIPLO_51_LOW
	MOVLW	.0
	MOVWF	MULTIPLO_51_HIGH
	MOVLW	.0
	MOVWF	DIV_PARCIAL_HIGH

	BSF	ADCON0,1		;INICIA A CONVERSÃO
        BTFSC   ADCON0,1		;QUANDO O BIT 1 DO ADCON0 FOR 0, A CONVERSÃO TERMINOU
	GOTO    $ - 1
	MOVFW	ADRESH
	MOVWF	DIV_PARCIAL_LOW		;ARMAZENA OS PRIMEIROS 8 BITS DO DIVIDENDO PARCIAL
					;NO INICIO SÓ VAMOS PRECISAR DE 8 BITS
	;CORPO DA ROTINA PRINCIPAL
COMECO
	MOVFW	ADRESH
	SUBWF	MULTIPLO_51_LOW,W
	BTFSS	STATUS,C
	GOTO	MULT_51
	
	BTFSC	STATUS,Z
	GOTO	SETA_VALOR
	DECF	VALOR_ENCONTRADO	;O RESULTADO É O VALOR ANTERIOR
	MOVLW	.51
	SUBWF	MULTIPLO_51_LOW,F	;VOLTANDO AO VALOR ANTERIOR
	GOTO	SETA_VALOR
	
	
MULT_51
	MOVLW	.51
	ADDWF	MULTIPLO_51_LOW,F
	BTFSC	STATUS,C
	INCF	MULTIPLO_51_HIGH
	INCF	VALOR_ENCONTRADO
	GOTO	COMECO
	
	
	
PROXIMOS_VALORES
	CALL	ENCONTRANDO_RESTO
	CALL	MULT_RESTO		    ;O RESTO SERÁ MULTIPLICADO POR 10 E 
					    ;PASSARÁ A SER O NOVO DIVIDENDO
	MOVLW	.1
	MOVWF	VALOR_ENCONTRADO
	MOVLW	.0
	MOVWF	MULTIPLO_51_HIGH		
	MOVLW	.51
	MOVWF	MULTIPLO_51_LOW		    ;VALOR DO DIVISOR E SEUS MÚLTIPLOS
CONTINUA_PROX_VALORES
	MOVFW	DIV_PARCIAL_HIGH
	SUBWF	MULTIPLO_51_HIGH,W	    ;COMP AS PARTES MAIS SIGNIFICATIVAS DE DIVISOR E DIVIDENDO PARA SE FAZER A DIVISÃO
	BTFSS	STATUS,C
	GOTO	MULT_51_PROX_VALORES	    ;DIVISOR/MÚLTIPLOS DELE É MAIOR OU IGUAL A DIVIDENDO
	BTFSC	STATUS,Z		    ;TESTANDO SE É MAIOR OU IGUAL
	GOTO	TESTA_LOW		    ;É IGUAL. DEVEMOS TESTAR OS BITS MENOS SIGNIFICATIVOS
	DECF	VALOR_ENCONTRADO	    ;É MAIOR. O VALOR QUE QUEREMOS É O ANTERIOR
	CALL	DEC_MULT_DIVISOR_HIGH	    ;O DIVISOR QUE QUEREMOS PARA CALCULAR O RESTO É O ANTERIOR
	GOTO	SETA_VALOR


;COMPARANDO BITS MENOS SIGNIFICATIVOS DO DIVISOR/MÚLTIPLOS DELE COM O DIVIDENDO
TESTA_LOW
	MOVFW	DIV_PARCIAL_LOW		    ;PASSARÁ A SER O NOVO DIVIDENDO
	SUBWF	MULTIPLO_51_LOW,W		    ;COMP AS PARTES MAIS SIGNIFICATIVAS DE DIVISOR E DIVIDENDO PARA SE FAZER A DIVISÃO
	BTFSS	STATUS,C
	GOTO	MULT_51_PROX_VALORES	    ;DIVISOR/MÚLTIPLOS DELE É MAIOR OU IGUAL A DIVIDENDO
	BTFSC	STATUS,Z		    ;TESTANDO SE É MAIOR OU IGUAL
	GOTO	SETA_VALOR		    ;É IGUAL. DEVEMOS TESTAR OS BITS MENOS SIGNIFICATIVOS
	DECF	VALOR_ENCONTRADO	    ;É MAIOR. O VALOR QUE QUEREMOS É O ANTERIOR
	CALL	DEC_MULT_DIVISOR_LOW	    ;O DIVISOR QUE QUEREMOS PARA CALCULAR O RESTO É O ANTERIOR
	GOTO	SETA_VALOR
	
	
MULT_51_PROX_VALORES			    ;MULTIPLICA 51. ESSA ROTINA SERVE PARA OS PRÓXIMOS
	MOVLW	.51			    ;VALORES, ONDE É TRATADA A POSSIBIIDADE DE ESTOURO
	ADDWF	MULTIPLO_51_LOW,F	    ;DE CARRY, USANDO DOIS REGISTRADORES DE 8 BITS
	BTFSC	STATUS,C
	INCF	MULTIPLO_51_HIGH
	INCF	VALOR_ENCONTRADO
	GOTO	CONTINUA_PROX_VALORES	
	
	

SETA_VALOR
	
	MOVLW	.2
	SUBWF	FLAG,W
	BTFSS	STATUS,C
	GOTO	VAR1
	MOVLW	.3
	SUBWF	FLAG,W
	BTFSS	STATUS,C
	GOTO	VAR2
	MOVLW	.4
	SUBWF	FLAG,W
	BTFSS	STATUS,C
	GOTO	VAR3
	GOTO	VAR4
	
VAR1
	MOVFW   VALOR_ENCONTRADO
	MOVWF   VALOR1
	INCF	FLAG
	GOTO	PROXIMOS_VALORES
	

VAR2
	MOVFW   VALOR_ENCONTRADO
	MOVWF   VALOR2
	INCF	FLAG
	GOTO	PROXIMOS_VALORES
	
VAR3
	MOVFW   VALOR_ENCONTRADO
	MOVWF   VALOR3
	INCF	FLAG
	GOTO	PROXIMOS_VALORES
	
VAR4
	MOVFW   VALOR_ENCONTRADO
	MOVWF   VALOR4
	INCF	FLAG
	GOTO	PROTOCOLO_SAIDA
	
	
PROTOCOLO_SAIDA
	;COLOCAR UM DELAY DE 100 MS
	GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
