;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       ATIVIDADE 5                               *
;*             ANDRE OLIVEIRA DE SOUSA - 11325684                  *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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
		
		RESULT	
		VAR_CINCO
		VAR_CINQUENTA_UM
		PARTE_INTEIRA	
		PARTE_DECIMAL
		CONT_4
		CONT_8
		CONT_10
		TENSAO

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
	MOVLW	B'00000100'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	MOVLW	B'00010100'	;VAMOS USAR A PORTA 2 COMO ENTRADA
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000111'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00001001'	;BIT 0 HABILITA O CONVERSOR A OPERAR, APESAR QUE N�O INICIOU A CONVERS�O
	MOVWF	ADCON0		;BIT 3 E 2 ESTANDO EM 1 E 0 RESPECTIVAMENTE PERMITE USAR A PORTA 2 COMO ENTRADA
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

;INICIALIZACAO DE VARIAVEIS QUE SERAO USADAS PARA OPERACOES DE CONTA
COMECO
    MOVLW   .4
    MOVWF   CONT_4		
    MOVLW   .8
    MOVWF   CONT_8
    MOVLW   B'00000101'		;CINCO
    MOVWF   VAR_CINCO
    MOVLW   B'00110011'		;CINQUENTA E UM
    MOVWF   VAR_CINQUENTA_UM
    MOVLW   B'00000001'		;UM
    MOVWF   PARTE_INTEIRA
    MOVLW   B'00000001'		;UM
    MOVWF   PARTE_DECIMAL
    BSF	    ADCON0,1		;INICIA A CONVERS�O
AINDA_NAO_CONVERTEU		;REPETE ESSE LA�O AT� QUE A CONVERS�O TERMINE
    BTFSC   ADCON0,1		;QUANDO O BIT 1 DO ADCON0 FOR 0, A CONVERS�O TERMINOU
    GOTO    AINDA_NAO_CONVERTEU

    
;AQUI PARA ENCONTRAR A PARTE INTEIRA DA CONVERSAO VAMOS DIVIDIR O RESULTADO
;DA CONVERSAO POR 51
ENCONTRANDO_PARTE_INTEIRA   
    MOVFW   ADRESH
    MOVWF   RESULT		;VARIAVEL QUE ARMAZENA O VALOR DA CONVERSAO
    SUBWF   VAR_CINQUENTA_UM,W	;SUBTRAINDO O VALOR DA CONVERSAO DE 51 PARA SABER SE JA TEMOS A PARTE INTEIRA QUE SERA 
    BTFSS   STATUS,C		;PROCURAMOS O MAIOR VALOR QUE FA�A COM QUE 51 MULTIPLICADO POR ELE N�O SEJA MAIOR QUE O RESULTADO DA CONVERS�O
    GOTO    MULTIPLICA_51	;CASO A SUBTRA��O SEJA MENOR QUE ZERO MULTIPLICAMOS 51 POR UM VALOR MAIOR
    BTFSC   STATUS,Z		;VAMOS TESTAR SE O RESULTADO DA SUBTRA��O � MAIOR OU IGUAL A ZERO
    GOTO    SEGUNDA_PARTE	;CASO SEJA ZERO (STATUS Z = 1) ENCONTRAMOS O MAIOR VALOR QUE ATENDE OS REQUISITOS E PODEMOS IR PARA A SEGUNDA PARTE
    DECF    PARTE_INTEIRA	;CASO CONTRARIO, O RESULTADO DA MULTIPLICA��O DE 51 PELO VALOR ATUAL DEU MAIOR QUE O VALOR DA CONVERS�O
    MOVLW   B'00110011'		;ENTAO DECREMENTAMOS ESSE VALOR, POIS O ANTERIOR � O MAIOR QUE SE ENCAIXA NAS CONDI��ES
    SUBWF   VAR_CINQUENTA_UM,F	;SUBTRAIMOS O VALOR DE "VAR_CIQUENTA_UM" QUE � O VALOR DE ACUMULADO DE 51 SOMADO A 51 SEMPRE QUE PRECISAR MULTIPLICAR 51 POR UM N�MERO 1 UNIDADE MAIOR
    GOTO    SEGUNDA_PARTE	;CHEGANDO AQUI TAMB�M TEMOS A PARTE INTEIRA E PODEMOS IR PARA A SEGUNDA PARTE

MULTIPLICA_51
    MOVLW   B'00110011'		;MULTIPLICANDO CINQUENTA E UM PARA O PROCESSO DE DIVIS�O 
    ADDWF   VAR_CINQUENTA_UM,W	;PARA ISSO SOMA O VALOR DE "VAR_CINQUENTA_UM" QUE INICIALMENTE � 51 COM 51 QUE EQUIVALE A MULTIPLICAR 51 POR UM VALOR 1 UNIDADE MAIOR
    MOVWF   VAR_CINQUENTA_UM	;ARMAZENA O RESULTADO EM "VAR_CINQUENTA_UM" QUE VAI ACUMULANDO OS RESULTADOS DA MULTIPLICA��O PARA TESTES MENCIONADOS ANTERIORMENTE
    INCF    PARTE_INTEIRA	;CADA VEZ QUE MULTIPLICAMOS 51 TEMOS 1 A MAIS NO QUOCIENTE COMO POSS�VEL CANDIDATO A RESULTADO INTEIRO DA DIVIS�O
    GOTO    ENCONTRANDO_PARTE_INTEIRA  ;VOLTA PARA TESTAR SE TEMOS O RESULTADO DA DIVIS�O OU SE PASSAMOS DELE
    
SEGUNDA_PARTE			;VAMOS DIVIDIR O RESTO DA DIVIS�O POR 5, POIS ASSIM O RESULTADO INTEIRO, SER� A PARTE DECIMAL DA CONVERS�O QUE QUEREMOS
    MOVFW   VAR_CINQUENTA_UM	;SUBTRAINDO O VALOR DA MULTIPLICA��O CALCULADO ANTES DO RESULTADO DA CONVERS�O, TEMOS O RESTO DA DIVIS�O
    SUBWF   RESULT,F		;RESULT ARMAZENA O RESTO DA DIVIS�O
    
    
ENCONTRANDO_PARTE_DECIMAL	;ESTE PASSO � AN�LOGO AO PASSO PARA ENCONTRAR A PARTE INTEIRA
    MOVFW   RESULT		
    SUBWF   VAR_CINCO,W		;O VALOR DO DIVISOR AGORA SER� 5 E N�O MAIS 51
    BTFSS   STATUS,C		;AQUI ASSIM COMO ANTES VAMOS TESTAR SE O RESULTADO DA SUBTRA��O DEU NEGATIVO
    GOTO    MULTIPLICA_5	;POSITIVO OU ZERO PARA SABERMOS SE J� TEMOS O VALOR QUE ATENDE AOS REQUISITOS DE UMA DIVIS�O DA MESMA FORMA J� FEITA ANTES
    DECF    PARTE_DECIMAL	;SE O STATUS Z � 0, PASSAMOS DO VALOR E TEMOS QUE DECREMENT�-LO E ESTE VALOR � O NOVO RESULTADO DA DIVIS�O E � A PARTE DECIMAL QUE DESEJAMOS
    GOTO    PRIMEIRA_ROTACAO	;PROXIMA ETAPA

MULTIPLICA_5
    MOVLW   B'00000101'		;MULTIPLICANDO CINCO PARA O PROCESSO DE DIVIS�O 
    ADDWF   VAR_CINCO,W		;COMO FIZEMOS ANTES, VAMOS MULTIPLICAR 5 POR 2, POIS J� TESTAMOS POR 0 E 1 ANTES E ARMAZENAR O VALOR EM "VAR_CINCO"
    MOVWF   VAR_CINCO		;PARA SABERMOS POR QUANTO DEVEMOS MULTIPLICAR 5 PARA O VALOR SER O MAXIMO POSSIVEL
    INCF    PARTE_DECIMAL	;SEM FAZER COM QUE A SUBTRA��O DE "VAR_CINCO" E O RESTO CALCULADO ANTES SEJA MAIOR QUE 1
    GOTO    ENCONTRANDO_PARTE_DECIMAL
    
;DESLOCA OS BITS DO PRIMEIRO D�GITO PARA A ESQUERDA 
;PARA POSTERIORMENTE SEREM ENVIADOS � SA�DA 
    
PRIMEIRA_ROTACAO		;AQUI APENAS DESLOCAMOS 4 VEZES OS BITS DA PARTE INTEIRA 
    BCF	    STATUS,C		;PARA POSTERIOR "CONCATENA��O" COM A PARTE DECIMAL ATRAV�S DE UMA SOMA
    RLF	    PARTE_INTEIRA	;ROTACIONA BIT A BIT O VALOR DE RESULT
    GOTO    CONTA_BITS		;PULA PARA O METODO QUE IR� CONTAR 1 E VOLTAR PARA O ROTATE PARA ROTACIONAR O PR�XIMO BIT. 

CONTA_BITS
    DECFSZ  CONT_4
    GOTO    PRIMEIRA_ROTACAO
    
;JUNTANDO AS DUAS SA�DAS
    
    MOVFW	PARTE_INTEIRA
    ADDWF	PARTE_DECIMAL,W
    MOVWF	TENSAO		;A "CONCATENA��O" MENCIONADA ANTES � FEITA ATRAV�S DA SOMA DA PARTE INTEIRA DESLOCADA DE 4 BITS
				;COM A PARTE DECIMAL E O RESULTADO � ARMAZENADO EM TENS�O QUE CONT�M
				;O VALOR INTEIRO E DECIMAL DA CONVERS�O EM 8 BITS
    
;SAIDA PARTE INTEIRA
    
;ATRAV�S DE UMA ROTA��O DE 8 BITS NA VARI�VEL TENS�O, PODEMOS MANDAR A SA�DA PARA O SHIFTER
SAIDA
    RLF	    TENSAO		;ROTACIONA BIT A BIT O VALOR DE RESULT
    BTFSC   STATUS,C		;TESTA O CARRY
    GOTO    SETA_GP0_SAIDA	;SE O CARRY � 1, PULA PARA SETA_GP0, PARA QUE O GP0 POSSA SER SETADO
    BCF	    GPIO,GP0		;SE O CARRY � 0 LIMPA GP0
    BSF	    GPIO,GP1		;SETA GP1 PARA DAR UM PULSO DE CLOCK E MANDAR O VALOR DE GP0
    NOP
    BCF	    GPIO,GP1		;LIMPA GP1
    GOTO    CONTA_BITS_SAIDA 	;PULA PARA O METODO QUE IR� CONTAR 1 E VOLTAR PARA O ROTATE PARA ROTACIONAR O PR�XIMO BIT. 
				;ISSO IR� SER FEITO 8 VEZES PARA ROTACIONAR OS 8 BITS EM "RESULT" E MANDAR PARA O CARRY
SETA_GP0_SAIDA			
    BSF	    GPIO,GP0		;AQUI VAMOS SETAR O GP0
    BSF	    GPIO,GP1		;SETA GP1 PARA DAR UM PULSO DE CLOCK E MANDAR O VALOR DE GP0
    NOP
    BCF	    GPIO,GP1		;LIMPA GP1 DESCENDO A BORDA DO MESMO 
    GOTO    CONTA_BITS_SAIDA	;NOVAMENTE PULA PARA CONTAR MAIS 1 AT� CHEGAR EM 8 PARA ROTACIONAR TODOS OS BITS DE "RESULT"

CONTA_BITS_SAIDA
    DECFSZ  CONT_8
    GOTO    SAIDA
    
;DELAY DE 500 ms ENTRE CADA EXIBI��O
    
    MOVLW	.10
    MOVWF	CONT_10
DELAY
    CLRF    TMR0
    BCF	    INTCON,T0IF
    MOVLW   .100
    MOVWF   TMR0
    BTFSS   INTCON,T0IF
    GOTO    $ - 1
    DECFSZ  CONT_10
    GOTO    DELAY	
    
    GOTO    COMECO


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
