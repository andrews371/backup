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

		COMP1		;NOVAS VARIÁVEIS
		COMP2
		COMP3
		COMP4
		COMP5
		COMP6
		COMP7
		RESULT
		CONT

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
	
	;CADA UM DESSES COMP (COMP1, COMP2, ..., COMP7) É PARA TESTAR O VALOR ADEQUADO DE TENSÃO
	MOVLW	.35		 ;EQUIVALE A 23h -> REFERÊNCIA PARA 07
	MOVWF	COMP1
	MOVLW	.50		 ;EQUIVALE A 32h -> REFERÊNCIA PARA 10
	MOVWF	COMP2
	MOVLW	.99		 ;EQUIVALE A 63h -> REFERÊNCIA PARA 19
	MOVWF	COMP3
	MOVLW	.101		 ;EQUIVALE A 65h -> REFERÊNCIA PARA 20
	MOVWF	COMP4
	MOVLW	.167		 ;EQUIVALE A A7h -> REFERÊNCIA PARA 33
	MOVWF	COMP5
	MOVLW	.219		 ;EQUIVALE A DBh -> REFERÊNCIA PARA 43
	MOVWF	COMP6
	MOVLW	.252		 ;EQUIVALE A FCh -> REFERÊNCIA PARA 49
	MOVWF	COMP7
	
COMECO
    MOVLW   .8
    MOVWF   CONT		;CONT SERVE PARA CONTAR OS 8 BITS QUE SERÃO MANDADOS PARA O DISPLAY
    BSF	    ADCON0,1		;INICIA A CONVERSÃO
AINDA_NAO_CONVERTEU		;REPETE ESSE LAÇO ATÉ QUE A CONVERSÃO TERMINE
    BTFSC   ADCON0,1		;QUANDO O BIT 1 DO ADCON0 FOR 0, A CONVERSÃO TERMINOU
    GOTO    AINDA_NAO_CONVERTEU
    
    ;A PARTIR DAQUI VAMOS COMPARAR O VALOR DE CONVERSÃO COM OS 
    ;VALORES DE TENSÃO FIXADOS ACIMA NOS REGISTRADORES COMP
    
    MOVFW   COMP1		
    SUBWF   ADRESH,W
    BTFSC   STATUS,C
    GOTO    $ + 2
    GOTO    SETA_00		;O VALOR DE ADRESH FOI MENOR QUE COMP1 QUE É A REFERÊNCIA PARA 07 
    BTFSS   STATUS,Z		;ENTAO VAI SER SETADO 00
    GOTO    TESTA_ENTRE_7_10	;SE CHEGOU AQUI É PORQUE O VALOR DE CONVERSÃO ESTÁ ENTRE 35 E 50 (REFERÊNCIA PARA 07 E 10)
    GOTO    SETA_07		;AQUI VAMOS SETAR COMO 07
    
SETA_00
    MOVLW   B'00000000'		;SETANDO 0
    MOVWF   RESULT

ROTATE_00
    RLF	    RESULT		;ROTACIONA BIT A BIT O VALOR DE RESULT
    BTFSC   STATUS,C		;TESTA O CARRY
    GOTO    SETA_GP0_00		;SE O CARRY É 1, PULA PARA SETA_GP0, PARA QUE O GP0 POSSA SER SETADO
    BCF	    GPIO,GP0		;SE O CARRY É 0 LIMPA GP0
    BSF	    GPIO,GP1		;SETA GP1 PARA DAR UM PULSO DE CLOCK E MANDAR O VALOR DE GP0
    NOP
    BCF	    GPIO,GP1		;LIMPA GP1
    GOTO    CONTA_BITS  	;PULA PARA O METODO QUE IRÁ CONTAR 1 E VOLTAR PARA O ROTATE PARA ROTACIONAR O PRÓXIMO BIT. 
				;ISSO IRÁ SER FEITO 8 VEZES PARA ROTACIONAR OS 8 BITS EM "RESULT" E MANDAR PARA O CARRY
SETA_GP0_00			
    BSF	    GPIO,GP0		;AQUI VAMOS SETAR O GP0
    BSF	    GPIO,GP1		;SETA GP1 PARA DAR UM PULSO DE CLOCK E MANDAR O VALOR DE GP0
    NOP
    BCF	    GPIO,GP1		;LIMPA GP1 DESCENDO A BORDA DO MESMO 
    GOTO    CONTA_BITS		;NOVAMENTE PULA PARA CONTAR MAIS 1 ATÉ CHEGAR EM 8 PARA ROTACIONAR TODOS OS BITS DE "RESULT"

TESTA_ENTRE_7_10		;DE FORMA ANÁLOGA VAMOS TESTAR SE O VALOR DA CONVERSÃO ESTÁ ENTRE
    MOVFW   COMP2		;7 E 10
    SUBWF   ADRESH,W
    BTFSC   STATUS,C
    GOTO    TESTA_10		;AQUI O ADRESH DEU MAIOR QUE COMP2 ENTAO SO PODE SER 10 OU MAIS QUE DEVE IR PARA A SAÍDA PORTANDO VAMOS PULAR O CÓDIGO PARA FAZER ESSE TESTE
    GOTO    SETA_07		;AQUI INDICA QUE ADRESH É MENOR QUE COMP2 (VER EM CIMA NA REFERÊNCIA)
				;ENTÃO A SAÍDA SÓ PODE SER 2 E PORTANDO VAMOS PULAR PARA O CÓDIGO QUE MANDA 07 NA SAÍDA

				
;O FUNCIONAMENTO AQUI É ANÁLOGO AO SETA_00 SENDO QUE VAMOS MANDAR PARA
;A SAÍDA 7 E NÃO 0.
SETA_07				
    MOVLW   B'00000111'		
    MOVWF   RESULT

ROTATE_07
    RLF	    RESULT
    BTFSC   STATUS,C
    GOTO    SETA_GP0_07
    BCF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

SETA_GP0_07
    BSF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

TESTA_10			;TESTE ANÁLOGO AO JÁ EXPLICADO, VAMOS SABER SE O VALOR DA CONVERSÃO
    MOVFW   COMP3		;É MAIOR OU IGUAL AO VALOR QUE DEVE SETAR 10 NA SAÍDA
    SUBWF   ADRESH,W
    BTFSC   STATUS,C
    GOTO    $ + 2
    GOTO    SETA_10
    BTFSS   STATUS,Z
    GOTO    TESTA_ENTRE_19_20
    GOTO    SETA_19

;O FUNCIONAMENTO AQUI É ANÁLOGO AO SETA_00 SENDO QUE VAMOS MANDAR PARA
;A SAÍDA 10 E NÃO 0.
SETA_10
    MOVLW   B'00001010'
    MOVWF   RESULT

ROTATE_10
    RLF	    RESULT
    BTFSC   STATUS,C
    GOTO    SETA_GP0_10
    BCF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

SETA_GP0_10
    BSF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS	   

TESTA_ENTRE_19_20		;ANÁLOGO AO JÁ EXPLICADO PARA TESTAR SE O VALOR DA CONVERSÃO ESTÁ 
    MOVFW   COMP4		;NO INTERVALO QUE DEVE MANDAR 19 PARA A SAÍDA OU UM VALOR MAIOR
    SUBWF   ADRESH,W
    BTFSC   STATUS,C
    GOTO    TESTA_20
    GOTO    SETA_19

;O FUNCIONAMENTO AQUI É ANÁLOGO AO SETA_00 SENDO QUE VAMOS MANDAR PARA
;A SAÍDA 19 E NÃO 0.    
SETA_19
    MOVLW   B'00010011'
    MOVWF   RESULT

ROTATE_19
    RLF	    RESULT
    BTFSC   STATUS,C
    GOTO    SETA_GP0_19
    BCF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

SETA_GP0_19
    BSF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

TESTA_20			;NOVAMENTE TESTAMOS SE O VALOR DA CONVERSÃO DEVE MANDAR 20 PARA A SAÍDA OU MAIS
    MOVFW   COMP5
    SUBWF   ADRESH,W
    BTFSC   STATUS,C
    GOTO    $ + 2
    GOTO    SETA_20
    BTFSS   STATUS,Z
    GOTO    TESTA_ENTRE_33_43
    GOTO    SETA_33

;O FUNCIONAMENTO AQUI É ANÁLOGO AO SETA_00 SENDO QUE VAMOS MANDAR PARA
;A SAÍDA 20 E NÃO 0.
SETA_20
    MOVLW   B'00010100'
    MOVWF   RESULT

ROTATE_20
    RLF	    RESULT
    BTFSC   STATUS,C
    GOTO    SETA_GP0_20
    BCF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

SETA_GP0_20
    BSF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

    
;TESTANDO SE O VALOR DA CONVERSÃO NOS SUGERE SETAR 33 OU MAIS COMO SAÍDA    
TESTA_ENTRE_33_43
    MOVFW   COMP6
    SUBWF   ADRESH,W
    BTFSC   STATUS,C
    GOTO    TESTA_43
    GOTO    SETA_33

;O FUNCIONAMENTO AQUI É ANÁLOGO AO SETA_00 SENDO QUE VAMOS MANDAR PARA
;A SAÍDA 33 E NÃO 0.
SETA_33
    MOVLW   B'00100001'
    MOVWF   RESULT

ROTATE_33
    RLF	    RESULT
    BTFSC   STATUS,C
    GOTO    SETA_GP0_33
    BCF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

SETA_GP0_33
    BSF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

;TESTA SE NA SAÍDA DEVEMOS MANDAR 43 DE ACORDO COM O QUE JÁ FOI EXPLICADO PARA OS 
;OUTROS TESTES
TESTA_43
    MOVFW   COMP7
    SUBWF   ADRESH,W
    BTFSC   STATUS,C
    GOTO    $ + 2
    GOTO    SETA_43
    GOTO    SETA_49

;O FUNCIONAMENTO AQUI É ANÁLOGO AO SETA_00 SENDO QUE VAMOS MANDAR PARA
;A SAÍDA 43 E NÃO 0.
SETA_43
    MOVLW   B'00101011'
    MOVWF   RESULT

ROTATE_43
    RLF	    RESULT
    BTFSC   STATUS,C
    GOTO    SETA_GP0_43
    BCF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

SETA_GP0_43
    BSF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

;O FUNCIONAMENTO AQUI É ANÁLOGO AO SETA_00 SENDO QUE VAMOS MANDAR PARA
;A SAÍDA 49 E NÃO 0.
SETA_49
    MOVLW   B'00110001'
    MOVWF   RESULT

ROTATE_49
    RLF	    RESULT
    BTFSC   STATUS,C
    GOTO    SETA_GP0_49
    BCF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS

SETA_GP0_49
    BSF	    GPIO,GP0
    BSF	    GPIO,GP1
    NOP
    BCF	    GPIO,GP1
    GOTO    CONTA_BITS
 
;AQUI VAMOS DECREMENTAR CONT QUE TEM O VALOR DE 8 ATÉ QUE ELE FIQUE 0
;ISSO ACONTECE PARA CONTAR 8 VEZES E ASSIM ROTACIONAR 8 VEZES O VALOR QUE QUEREMOS MANDAR
;COMO SAÍDA, FAZENDO COM QUE CADA UM DOS BITS POSSA IR PARA O CARRY ONDE PODEMOS TESTÁ-LO
;E DECIDIR SE MANDAMOS 0 OU 1 NA SAÍDA.
CONTA_BITS
    DECFSZ  CONT
    GOTO    ROTATE_00
    GOTO    COMECO


    GOTO    MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
