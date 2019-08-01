;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                      JUNHO DE 2019                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       ATIVIDADE 5                               *
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
		
		RESULT	
		VAR_CINCO
		VAR_CINQUENTA_UM
		PARTE_INTEIRA	
		PARTE_DECIMAL
		CONT_4
		CONT_8
		TENSAO

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

SUBROTINA1

	;CORPO DA ROTINA

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
	MOVLW	B'00000100'
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
MAIN

	;CORPO DA ROTINA PRINCIPAL
	
COMECO
    MOVLW   .4
    MOVWF   CONT_4		;CONT SERVE PARA CONTAR OS 8 BITS QUE SERÃO MANDADOS PARA O DISPLAY
    MOVLW   .8
    MOVWF   CONT_8
    MOVLW   B'00000101'
    MOVWF   VAR_CINCO
    MOVLW   B'00110011'		;CINQUENTA E UM
    MOVWF   VAR_CINQUENTA_UM
    MOVLW   B'00000001'
    MOVWF   PARTE_INTEIRA
    MOVLW   B'00000001'
    MOVWF   PARTE_DECIMAL
    BSF	    ADCON0,1		;INICIA A CONVERSÃO
AINDA_NAO_CONVERTEU		;REPETE ESSE LAÇO ATÉ QUE A CONVERSÃO TERMINE
    BTFSC   ADCON0,1		;QUANDO O BIT 1 DO ADCON0 FOR 0, A CONVERSÃO TERMINOU
    GOTO    AINDA_NAO_CONVERTEU
    
ENCONTRANDO_PARTE_INTEIRA   
    MOVFW   ADRESH
    MOVWF   RESULT
    SUBWF   VAR_CINQUENTA_UM,W
    BTFSS   STATUS,C
    GOTO    MULTIPLICA_51
    BTFSC   STATUS,Z
    GOTO    SEGUNDA_PARTE
    DECF    PARTE_INTEIRA
    MOVLW   B'00110011'
    SUBWF   VAR_CINQUENTA_UM,F
    GOTO    SEGUNDA_PARTE

MULTIPLICA_51
    MOVLW   B'00110011'	;MULTIPLICANDO CINQUENTA E UM PARA O PROCESSO DE DIVISÃO 
    ADDWF   VAR_CINQUENTA_UM,W
    MOVWF   VAR_CINQUENTA_UM
    INCF    PARTE_INTEIRA
    GOTO    ENCONTRANDO_PARTE_INTEIRA
    
SEGUNDA_PARTE
    MOVFW   VAR_CINQUENTA_UM
    SUBWF   RESULT,F
    
ENCONTRANDO_PARTE_DECIMAL   
    MOVFW   RESULT
    SUBWF   VAR_CINCO,W
    BTFSS   STATUS,C
    GOTO    MULTIPLICA_5
    BTFSC   STATUS,Z
    GOTO    PRIMEIRA_ROTACAO
    DECF    PARTE_DECIMAL
    GOTO    PRIMEIRA_ROTACAO

MULTIPLICA_5
    MOVLW   B'00000101'	;MULTIPLICANDO CINCO PARA O PROCESSO DE DIVISÃO 
    ADDWF   VAR_CINCO,W
    MOVWF   VAR_CINCO
    INCF    PARTE_DECIMAL
    GOTO    ENCONTRANDO_PARTE_DECIMAL
    
;DESLOCA OS BITS DO PRIMEIRO DÍGITO PARA A ESQUERDA 
;PARA POSTERIORMENTE SEREM ENVIADOS À SAÍDA 
    
PRIMEIRA_ROTACAO
    BCF	    STATUS,C
    RLF	    PARTE_INTEIRA	;ROTACIONA BIT A BIT O VALOR DE RESULT
    GOTO    CONTA_BITS		;PULA PARA O METODO QUE IRÁ CONTAR 1 E VOLTAR PARA O ROTATE PARA ROTACIONAR O PRÓXIMO BIT. 

CONTA_BITS
    DECFSZ  CONT_4
    GOTO    PRIMEIRA_ROTACAO
    
;JUNTANDO AS DUAS SAÍDAS
    
MOVFW	PARTE_INTEIRA
ADDWF	PARTE_DECIMAL,W
MOVWF	TENSAO
    
;SAIDA PARTE INTEIRA
    
SAIDA
    RLF	    TENSAO		;ROTACIONA BIT A BIT O VALOR DE RESULT
    BTFSC   STATUS,C		;TESTA O CARRY
    GOTO    SETA_GP0_SAIDA	;SE O CARRY É 1, PULA PARA SETA_GP0, PARA QUE O GP0 POSSA SER SETADO
    BCF	    GPIO,GP0		;SE O CARRY É 0 LIMPA GP0
    BSF	    GPIO,GP1		;SETA GP1 PARA DAR UM PULSO DE CLOCK E MANDAR O VALOR DE GP0
    NOP
    BCF	    GPIO,GP1		;LIMPA GP1
    GOTO    CONTA_BITS_SAIDA 	;PULA PARA O METODO QUE IRÁ CONTAR 1 E VOLTAR PARA O ROTATE PARA ROTACIONAR O PRÓXIMO BIT. 
				;ISSO IRÁ SER FEITO 8 VEZES PARA ROTACIONAR OS 8 BITS EM "RESULT" E MANDAR PARA O CARRY
SETA_GP0_SAIDA			
    BSF	    GPIO,GP0		;AQUI VAMOS SETAR O GP0
    BSF	    GPIO,GP1		;SETA GP1 PARA DAR UM PULSO DE CLOCK E MANDAR O VALOR DE GP0
    NOP
    BCF	    GPIO,GP1		;LIMPA GP1 DESCENDO A BORDA DO MESMO 
    GOTO    CONTA_BITS_SAIDA	;NOVAMENTE PULA PARA CONTAR MAIS 1 ATÉ CHEGAR EM 8 PARA ROTACIONAR TODOS OS BITS DE "RESULT"

CONTA_BITS_SAIDA
    DECFSZ  CONT_8
    GOTO    SAIDA
    
;FAZER UM DELAY AQUI SE PRECISAR
    
    GOTO    COMECO


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
