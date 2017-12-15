; *********************************************************************
; 	Afonso Castelão - 90700
; 	Pedro Luís      - 90763
; 	Pedro Leitão    - 90764
; *********************************************************************

;Constantes
pixelscreen EQU 8000H
DISPLAYS   EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 8       ; primeira linha a testar (4ª linha, 1000b)

STOPPED   EQU 0
RUNNING   EQU 1
PAUSED    EQU 2
RESUMING  EQU 3
STOPPING  EQU 4

;Pilha
PLACE 1000H
pilha: TABLE 100H

SP_inicial:

PLACE 2000H

; Tabela de vectores de interrupção
tabint:        WORD    rot0
			   WORD    rot1

;dados

;Variaveis
random:     WORD 1234h
int_ninja:  WORD 0
int_arma:   WORD 0
score:      WORD 0

ninjas_em_jogo: WORD 4
estado_do_jogo: WORD 0
display_buffer: TABLE 128

random_state:
        WORD 17H
		WORD 37H
		WORD 11H
		WORD 13H

;Objetos no Mundo
mundo:
numero_objetos: WORD 6
	WORD ninja1
	WORD ninja2
	WORD ninja3
	WORD ninja4
	WORD arma1
	WORD arma2
	
ninja1:
	WORD 0 ; x
	WORD 16 ; y
	WORD objeto_ninja
	WORD 1 ; visivel
	
ninja2:
	WORD 4 ; x
	WORD 16 ; y
	WORD objeto_ninja
	WORD 1 ; visivel

ninja3:
	WORD 8 ; x
	WORD 16 ; y
	WORD objeto_ninja
	WORD 1 ; visivel

ninja4:
	WORD 12 ; x
	WORD 16 ; y
	WORD objeto_ninja
	WORD 1 ; visivel

arma1:
	WORD 27 ; x
	WORD 8 ; y
	WORD objeto_prenda
	WORD 1 ; visivel

arma2:
	WORD 27 ; x
	WORD 20 ; y
	WORD objeto_estrela
	WORD 1 ; visivel
	
;------Imagens dos objetos--------------------------	
ninja_img:
	STRING 01000000B
	STRING 11100000B
	STRING 01000000B
	STRING 10100000B
	
estrela_img:
	STRING 10100000B
	STRING 01000000B
	STRING 10100000B
	STRING 00000000B ; para aceder a word
	
prenda_img:
	STRING 01000000B
	STRING 11100000B
	STRING 01000000B
	STRING 00000000B ; para aceder a word
;----------------------------------------------------

objeto_ninja:
	WORD 3   ;largura em pixeis
	WORD 4	 ;altura em pixeis
    WORD ninja_img	 ;pixeis da imagem
	
	
objeto_estrela:
	WORD 3   ;largura em pixeis
	WORD 3	 ;altura em pixeis
    WORD estrela_img	 ;pixeis da imagem
	
objeto_prenda:
	WORD 3   ;largura em pixeis
	WORD 3	 ;altura em pixeis
    WORD prenda_img	 ;pixeis da imagem

str_start0: STRING "PRESS C",0
str_start1: STRING "TO",0,0
str_start2: STRING "START",0

LETRAS:
            WORD LETRA_A
            WORD LETRA_B
            WORD LETRA_C
            WORD LETRA_D
            WORD LETRA_E
            WORD LETRA_F
            WORD LETRA_G
            WORD LETRA_H
            WORD LETRA_I
            WORD LETRA_J
            WORD LETRA_K
            WORD LETRA_L
            WORD LETRA_M
            WORD LETRA_N
            WORD LETRA_O
            WORD LETRA_P
            WORD LETRA_Q
            WORD LETRA_R
            WORD LETRA_S
            WORD LETRA_T
            WORD LETRA_U
            WORD LETRA_V
            WORD LETRA_W
            WORD LETRA_X
            WORD LETRA_Y
            WORD LETRA_Z
		
LETRA_Z:
            WORD 4
            WORD 5
            WORD PIXELS_Z
PIXELS_Z:
            STRING 11100000B
            STRING 00100000B
            STRING 01000000B
            STRING 10000000B
            STRING 11100000B
			STRING 0
 
LETRA_Y:
            WORD 4
            WORD 5
            WORD PIXELS_Y
PIXELS_Y:
            STRING 10100000B
            STRING 10100000B
            STRING 01000000B
            STRING 01000000B
            STRING 01000000B
 			STRING 0

LETRA_X:
            WORD 4
            WORD 5
            WORD PIXELS_X
PIXELS_X:
            STRING 10100000B
            STRING 10100000B
            STRING 01000000B
            STRING 10100000B
            STRING 10100000B
 			STRING 0

LETRA_W:
            WORD 6
            WORD 5
            WORD PIXELS_W
PIXELS_W:
            STRING 10001000B
            STRING 10101000B
            STRING 10101000B
            STRING 01010000B
            STRING 01010000B
 			STRING 0

LETRA_V:
            WORD 4
            WORD 5
            WORD PIXELS_V
PIXELS_V:
            STRING 10100000B
            STRING 10100000B
            STRING 10100000B
            STRING 01000000B
            STRING 01000000B
 			STRING 0

LETRA_U:
            WORD 5
            WORD 5
            WORD PIXELS_U
PIXELS_U:
            STRING 10010000B
            STRING 10010000B
            STRING 10010000B
            STRING 10010000B
            STRING 01100000B
 			STRING 0

LETRA_T:
            WORD 4
            WORD 5
            WORD PIXELS_T
PIXELS_T:
            STRING 11100000B
            STRING 01000000B
            STRING 01000000B
            STRING 01000000B
            STRING 01000000B
			STRING 0
 
LETRA_S:
            WORD 5
            WORD 5
            WORD PIXELS_S
PIXELS_S:
            STRING 01110000B
            STRING 10000000B
            STRING 01100000B
            STRING 00010000B
            STRING 11100000B
 			STRING 0

LETRA_R:
            WORD 5
            WORD 5
            WORD PIXELS_R
PIXELS_R:
            STRING 11100000B
            STRING 10010000B
            STRING 11100000B
            STRING 10010000B
            STRING 10010000B
 			STRING 0

LETRA_Q:
            WORD 5
            WORD 5
            WORD PIXELS_Q
PIXELS_Q:
            STRING 01100000B
            STRING 10010000B
            STRING 10010000B
            STRING 10100000B
            STRING 01010000B
			STRING 0
 
LETRA_P:
            WORD 5
            WORD 5
            WORD PIXELS_P
PIXELS_P:
            STRING 11100000B
            STRING 10010000B
            STRING 11100000B
            STRING 10000000B
            STRING 10000000B
			STRING 0
 
LETRA_O:
            WORD 5
            WORD 5
            WORD PIXELS_O
PIXELS_O:
            STRING 01100000B
            STRING 10010000B
            STRING 10010000B
            STRING 10010000B
            STRING 01100000B
 			STRING 0

LETRA_N:
            WORD 5
            WORD 5
            WORD PIXELS_N
PIXELS_N:
            STRING 10010000B
            STRING 11010000B
            STRING 10110000B
            STRING 10010000B
            STRING 10010000B
			STRING 0
 
LETRA_M:
            WORD 6
            WORD 5
            WORD PIXELS_M
PIXELS_M:
            STRING 10001000B
            STRING 11011000B
            STRING 10101000B
            STRING 10001000B
            STRING 10001000B
			STRING 0
 
LETRA_L:
            WORD 4
            WORD 5
            WORD PIXELS_L
PIXELS_L:
            STRING 10000000B
            STRING 10000000B
            STRING 10000000B
            STRING 10000000B
            STRING 11100000B
			STRING 0
 
LETRA_K:
            WORD 5
            WORD 5
            WORD PIXELS_K
PIXELS_K:
            STRING 10010000B
            STRING 10100000B
            STRING 11000000B
            STRING 10100000B
            STRING 10010000B
 			STRING 0

LETRA_J:
            WORD 4
            WORD 5
            WORD PIXELS_J
PIXELS_J:
            STRING 00100000B
            STRING 00100000B
            STRING 00100000B
            STRING 10100000B
            STRING 11000000B
 			STRING 0

LETRA_I:
            WORD 2
            WORD 5
            WORD PIXELS_I
PIXELS_I:
            STRING 10000000B
            STRING 10000000B
            STRING 10000000B
            STRING 10000000B
            STRING 10000000B
 			STRING 0

LETRA_H:
            WORD 5
            WORD 5
            WORD PIXELS_H
PIXELS_H:
            STRING 10010000B
            STRING 10010000B
            STRING 11110000B
            STRING 10010000B
            STRING 10010000B
			STRING 0
 
LETRA_G:
            WORD 5
            WORD 5
            WORD PIXELS_G
PIXELS_G:
            STRING 01110000B
            STRING 10000000B
            STRING 10110000B
            STRING 10010000B
            STRING 01110000B
			STRING 0
 
LETRA_F:
            WORD 4
            WORD 5
            WORD PIXELS_F
PIXELS_F:
            STRING 11100000B
            STRING 10000000B
            STRING 11000000B
            STRING 10000000B
            STRING 10000000B
			STRING 0
 
LETRA_E:
            WORD 4
            WORD 5
            WORD PIXELS_E
PIXELS_E:
            STRING 11100000B
            STRING 10000000B
            STRING 11000000B
            STRING 10000000B
            STRING 11100000B
			STRING 0
 
LETRA_D:
            WORD 5
            WORD 5
            WORD PIXELS_D
PIXELS_D:
            STRING 11100000B
            STRING 10010000B
            STRING 10010000B
            STRING 10010000B
            STRING 11100000B
			STRING 0
 
LETRA_C:
            WORD 5
            WORD 5
            WORD PIXELS_C
PIXELS_C:
            STRING 01100000B
            STRING 10010000B
            STRING 10000000B
            STRING 10010000B
            STRING 01100000B
			STRING 0
 
LETRA_B:
            WORD 5
            WORD 5
            WORD PIXELS_B
PIXELS_B:
            STRING 11100000B
            STRING 10010000B
            STRING 11100000B
            STRING 10010000B
            STRING 11100000B
			STRING 0
 
LETRA_A:
            WORD 5
            WORD 5
            WORD PIXELS_A
PIXELS_A:
            STRING 01100000B
            STRING 01100000B
            STRING 10010000B
            STRING 11110000B
            STRING 10010000B
			STRING 0
;codigo	
inicio:
PLACE 0
MOV SP, SP_inicial	; incializa o stack pointer

start_prog:

	;CALL ecra_xadrez
	CALL CLEAR_SCREEN
	MOV R5,str_start0
	MOV R1,0
	MOV R2,7
	CALL PRINT_STR
	MOV R5,str_start1
	MOV R1,11
	MOV R2,13
	CALL PRINT_STR
	MOV R5,str_start2
	MOV R1,5
	MOV R2,19
	CALL PRINT_STR


	
	XOR R2,R2
	CALL inicializar_jogo
	CALL inicializar_interrupts

	
;* -- main_loop -----------------------------------------------------------------
;* 
;* Descrição: Chama os processos principais do jogo 
;*
main_loop:
	
	
	CALL testa_interrupts	
	CALL testa_tecla_premida
	JNC  main_loop

    CALL   ACCAO_TECLA	
	
espera_tecla_levantada:	
	CALL tecla_levantada
	JZ   main_loop
	CALL testa_interrupts
	JMP  espera_tecla_levantada         ; volta a fazer este loop se ainda nao se largou a tecla



;R1 - x
;R2 - y
;R5 - str


;* -- Rotina que desenha letras -----------------------------------------------------------------
;* 
;* Descrição: Desenha as letras de uma string
;*
;* Parametros: R1 - coluna de referencia, R2 - linha de referencia, R5 - string
;*-------------------------------------------
PRINT_STR:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	
	DEC R5
loop_letra:
	INC R5
	MOVB R6,[R5]
	OR R6,R6
	JZ fim_ps
	MOV R7,' '
	CMP R6,R7
	JNZ nao_espaco
	MOV R7,3
	ADD R1,R7
	JMP loop_letra
nao_espaco:
	MOV R7,'Z'
	CMP R6,R7
	JGT loop_letra
	MOV R7,'A'
	CMP R6,R7
	JLT loop_letra
	SUB R6,R7
	SHL R6,1
	MOV R7,LETRAS
	ADD R7,R6
	MOV R3,[R7]
	
	MOV R0,1
	CALL draw_objeto
	MOV  R0,[R3]
	ADD  R1,R0
	JMP  loop_letra
	
fim_ps:
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
	
	
;* -- Rotina de aleatorio -------------------------------------------
;* 
;* Descrição: Gera um numero pseudoaleatoriamente. 
;*-----------------------------------------------------------------
randomize:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	
	MOV  R5,0FFH
	
	MOV  R0,random_state
	MOV  R1,[R0]    ; a
	MOV  R2,[R0+2]  ; b
	MOV  R3,[R0+4]  ; c
	MOV  R4,[R0+6]  ; x
	
	INC  R4
	AND  R4,R5
	MOV  [R0+6],R4
	
	XOR  R1,R3
	XOR  R1,R4
	
	MOV  [R0],R1
	
	ADD  R2,R1
	AND  R2,R5
	MOV  [R0+2],R2
	
	SHR  R2,1
	XOR  R2,R1
	ADD  R3,R2
	AND  R3,R5
	
	MOV  [R0+4],R3
	
	MOV  R0,R3
	
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	RET
	
;* -- Rotina de Serviço de Interrupção 0 -------------------------------------------
;* 
;* Descrição: Trata interrupções clock ligado à INT0. 
;*
rot0:
	PUSH R0
	PUSH R1
	MOV R0,int_arma
	MOV R1,[R0]
	INC R1
	MOV [R0],R1	 ; ativa a flag
	POP R1
	POP R0
	RFE

;*-----------------------------------------------------------------------------------

;* -- Rotina de Serviço de Interrupção 1 -------------------------------------------
;* 
;* Descrição: Trata interrupções clock ligado à INT1. 
;*		
rot1:
	PUSH R0
	PUSH R1
	MOV R0,int_ninja
	MOV R1,[R0]
	INC R1
	MOV [R0],R1	 ; ativa a flag
	POP R1
	POP R0
	RFE
;*-------------------------------------------------------------------------------

;* -- Rotina de limpeza do ecrã -------------------------------------------
;* 
;* Descrição: Limpa o ecrã. 
;*
CLEAR_SCREEN:	 ;limpa o ecrã
	PUSH R0
	PUSH R1
	PUSH R2
	MOV R2,0	 ;valor a meter no ecrã
	MOV R0,pixelscreen	 ;ecrã em R0
	MOV R1,128	 ;numero de bytes
loop_cs:
	MOVB [R0],R2	; mete um byte a 0
	DEC R1	 ; menos um byte a apagar
	JZ FIM_CS
	INC R0	;proxima byte
	JMP loop_cs; repete para o próximo byte
FIM_CS:
	POP R2
	POP R1
	POP R0
	RET
;*-----------------------------------------------------------------------


;* -- Rotina de ecrã final -------------------------------------------
;* 
;* Descrição: Mete o ecrã em xadrez. 
;*
ecra_xadrez:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4

	MOV R0, pixelscreen
	MOV R1, 32	 ; numero de linhas

	MOV R4,055H ; COMPLENTO DE 0AAH
	MOV R2,0FFH	
linha:
	XOR R4,R2	 ; R4 varia entre 0AAH e 055H
	MOV R3, 4	 ; quantidade de bytes por linha
PROX_BYTE:	 ; desenha byte a byte a linha
	MOVB [R0],R4
	INC R0
	DEC R3
	JNZ PROX_BYTE
	DEC R1
	JNZ linha
	
	POP R4
	POP R3	
	POP R2
	POP R1
	POP R0
	RET
;
	

		
		
		
	

;* -- Rotina de SHR-------
;* 
;* Descrição: 	Faz o SHR do objeto
;*
;* Parâmetros:  R7 - linha da imagem do objeto, R1 - numero de bits a shiftar
SHIFTR_N:
	PUSH R1
	OR  R1,R1
AGAIN_SHRN:
	JZ	DONE_SHRN	 ;quando o x é 0 não faz shift
	SHR R7,1	 ;shift 1 vez para a direira
	DEC	R1	 ;menos uma vez a shiftar
	JNZ AGAIN_SHRN	 ;shifta a proxima vez
DONE_SHRN:	 ;já shiftou todas as vezes a shiftar
	POP R1
	RET
;*------------------------------------------------	

;* -- Rotina de SHL--------------
;* 
;* Descrição: 	Faz o SHL do objeto
;*
;* Parâmetros:  R7 - linha da imagem do objeto, R8 - numero de bits a shiftar	
SHIFTL_N:	 ;trata do objeto quando este ocupa mais de um byte
	PUSH R8
	OR  R8,R8
AGAIN_SHLN:
	JZ	DONE_SHLN	 ; se o objeto nao ocupa 2 bytes nao da shift para a esquerda 
	SHL R7,1	 ;s hift 1 vez para a esquerda
	DEC	R8	 ; menos uma vez a shiftar
	JNZ AGAIN_SHLN	 ; shifta a próxima vez 
DONE_SHLN:	 ; ja shiftou todas as vezes
	POP R8
	RET	
;*--------------------------------------------------
	

;* -- Rotina de colisao--------------
;* 
;* Descrição: 	Gere as colisoes quando é o ninja a colidir
;*
;* Parâmetros:  R6 - Objeto com que o ninja colidiu
;*              R4 - tem o ninja que colidiu
colisao_ninja_arma:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	
	MOV R1,[R6+4] ; R1 contem o tipo de arma
	
	MOV R0,0
	PUSH R4
	MOV R4,R6
    CALL draw_var_objeto	 ; apaga a arma
	MOV R2,29	 ; linha do pixel de referencia da nova arma
	MOV [R4],R2
	CALL arma_aleatoria
	POP R4
	
	MOV R2,objeto_prenda
	CMP R1,R2
	JNZ cna_colidiu_com_estrela
	
	MOV R0,2 ; desenhar sem testar colisao
	CALL draw_var_objeto
	CALL add_score
	JMP cna_fim
	
cna_colidiu_com_estrela:	

	CALL morte_ninja
	
cna_fim:
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET


;* -- Rotina de score--------------
;* 
;* Descrição: 	Adiciona ao score
;*
add_score:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	MOV R0, score	 
	MOV R1, [R0]	 ; obtem o score atual
	MOV R2, 63H
	CMP R1, R2
	JGE fim_adiciona_score	 ; quando o score é 99 nao faz nada
	ADD R1, 3	 ; adiciona ao score 3
	MOV [R0], R1
	decimal:
	MOV    R1,   10
	MOV    R2,   [R0]      
	DIV    R2,   R1      ; obtem o valor das dezenas
	MOV    R3, R2        
	SHL    R3,   4         ; coloca esse valor no nibble high de R3
	MOV    R2,   [R0]
	MOD    R2,   R1      ; obtem o valor das unidades
	OR     R3,   R2        ; coloca esse valor no nibble low
	
	MOV   R1, DISPLAYS
	MOVB  [R1], R3	 ; coloca nos displays o score em decimal
fim_adiciona_score:	
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	
	
;* -- Rotina de colisao--------------
;* 
;* Descrição: gere as colisoes
;* Parametros: R4 - Objeto, R2 - byte da colisao, R3 - pixel da colisao
;*
colisao:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	

	MOV R1,pixelscreen
	SUB R2,R1
	MOV R5,R2
	SHR R2,2 ; linha da colisao

	SHL R5,14 ; os dois bits de menor peso dao o byte
	SHR R5,11 ; o byte multiplicado por 8 da o 1 pixel da coluna 

	OR  R3,R3  ; situaçao de erro
	JZ  done_pixel_c ; nao sabemos o pixel da colisao
	MOV R0,7
testa_pixel_c:
	SHR R3,1
	JC  done_pixel_c ; ja sabemos o pixel
	DEC R0
	JMP testa_pixel_c
done_pixel_c:
	ADD R0,R5 ; coluna da colisao em R0
	
	MOV R1,objeto_ninja
	MOV R3,[R4+4]
	CMP R3,R1
	JNZ teste_colisao_arma	 ; se nao é um ninja testa as armas
	
	MOV R6,arma1
	MOV R7,[R6+2]
	SHR R2,4
	SHR R7,4
	CMP R2,R7
	JNZ colisao_com_arma2	 ; se a colisao nao foi com a arma 1 entao foi com a 2
	CALL colisao_ninja_arma
	JMP fim_de_colisao
colisao_com_arma2:
	MOV R6,arma2
	CALL colisao_ninja_arma
	JMP fim_de_colisao
	

teste_colisao_arma:
; quando chega a este ponto temos R4 - arma, R0 - coluna, R2 - linha
    MOV R6,R4    ; arma que provocou a colisao em R6
	
	MOV  R1,mundo
	
	MOV  R5,[R1]  ; numero de objetos
move_prox_ninja_c:
	ADD  R1,2     ; R3 aponta primeira variavel de estado

	MOV  R4,[R1]  ; tem variavel de estado
	MOV  R3,[R4+4] ; tem tipo do objeto
	MOV  R7,[R4+6] ; visivel ?
	OR   R7,R7
	JZ   outro_objeto_c
	
	MOV  R7,objeto_ninja
	CMP	 R3,R7
	JNZ  outro_objeto_c	 ; se o objeto nao é um ninja, vai para o proximo
	
	MOV  R8,[R4]
	CMP  R0,R8
	JLT  outro_objeto_c	 ; se a coluna do objeto que colidiu é menor do que a que se esta a testar entao testa-se o proximo objeto
	MOV  R7,[R3]
	ADD  R8,R7
	DEC  R8
	CMP  R0,R8
	JGT   outro_objeto_c	 ; se a linha do objeto que colidiu é maior do que a que se esta a testar entao testa-se o proximo objeto
	
	CALL colisao_ninja_arma
	JMP fim_de_colisao

outro_objeto_c:
	DEC    R5
	JNZ    move_prox_ninja_c
	
fim_de_colisao:
	POP R8
    POP R7
    POP R6
    POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
;*-------------------------------------------------------------------------	

;* -- Rotina de desenho simplificada -----------------------------------------------------------------
;* 
;* Descrição: Desenha ou apaga objetos so com um parametro
;*
;* Parâmetros:  R4 - objeto
;* Retorna: R1 - coluna, R2 - linha, R3 - imagem
;*----------------------------------------------------------------------------------------------------------------------	
draw_var_objeto:
	PUSH R3
	PUSH R2
	PUSH R1
	PUSH R0
	
	MOV R1, [R4]
	MOV R2, [R4+2]
	MOV R3, [R4+4]
	CALL draw_objeto
	
	POP R0
	POP R1
	POP R2
	POP R3
	RET
	
;* -- Rotina de desenho -----------------------------------------------------------------
;* 
;* Descrição: Desenha ou apaga objetos 
;*
;* Parâmetros:  R0 - 1)Desenha 2) sem colisoes ou 0)apaga, R1 - coluna de referencia, R2 - linha de referencia, R3 - imagem do objeto R4 - objeto
;*----------------------------------------------------------------------------------------------------------------------
draw_objeto:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	MOV R10,pixelscreen	 ; pixelscreen em R10
	SHL R2,2	 ; multiplica linha por 4
	ADD R10,R2	 ; adiciona ao endereço inicial do pixelscreen a linha*4   
	MOV R2,R1	 ; guarda em R2 a coluna
	SHR R2,3	 ; divide a coluna por 8
	ADD R10,R2   ; endereço do byte da 1 linha
	SHL R1,13
	SHR R1,13	 ; offset do pixel
	
	PUSH R4       ; Variavel do objeto guardada no stack
	MOV R4,[R3]   ; numero de colunas
	MOV R5,[R3+2] ; numero de linhas
	MOV R6,[R3+4] ; imagem (pixeis)
	MOV R2,0
	
	MOV R9,R1	 ; mete em R9 o offset do pixel
	ADD R9,R4	 ; soma o numero de colunas
	DEC R9
	SHR R9,3 	; Se R9 <> 0 entao atravessa dois bytes
	
LOOP_LINHA:
	MOVB R7,[R6]	 ; mete em R7 uma linha do objeto
	
	CALL SHIFTR_N	; mete o bit de referencia no offset
	
	MOVB R8,[R10]	 ; mete em R8 o conteudo do byte do ecrã
	OR R0,R0	 ; quando o R0 é 0 vai apagar o Objeto
	JNZ DRAW_1	 ;quando nao é 0 vai desenhar

	NOT R7	 ; nega a linha do objeto
	AND R8,R7	 ; apaga a linha que vai aparecer no ecrã
	JMP DONE_D1	 
DRAW_1:
	MOV R4,R8
	XOR R4,R7
	
	OR  R8,R7
	
	OR R2,R2 ; se ja colidiu, nao vale a pena testar de novo
	JNZ DONE_D1

	BIT R0,0
	JZ DONE_D1
	CMP R8,R4
	JZ DONE_D1 ; nao houve colisao
	MOV R3,R8
	XOR R3,R4  ; Pixel da colisao em R3
	MOV R2,R10
DONE_D1:
	MOVB [R10],R8	 ; mete no byte do ecrã a linha
	
	OR R9,R9	 ; se nao atravessa dois bytes acabou de desenhar a linha
	JZ FIM_LINHA
	
	INC R10	 ; próximo byte
	MOVB R7,[R6]	 ; linha do objeto em R7	 
	MOV R8,8
	SUB R8,R1	 ; numero de bits a shiftar

	CALL SHIFTL_N
	
	MOVB R8,[R10]	 ; mete em R8 os bits do ecrã da linha a alterar

	OR R0,R0	 ; R0 = 0: vai apagar
	JNZ DRAW_2	; R0 = 1: vai desenhar
	NOT R7	 ; nega a linha
	AND R8,R7	 ; apaga a linha
	JMP DONE_D2
	
DRAW_2:
	MOV R4,R8
	XOR R4,R7
	
	OR  R8,R7
	
	OR R2,R2 ; se ja colidiu, nao vale a pena testar de novo
	JNZ DONE_D2

	BIT R0,0
	JZ DONE_D2
	CMP R8,R4
	JZ DONE_D2 ; nao houve colisao
	MOV R3,R8
	XOR R3,R4  ; Pixel da colisao em R3
	MOV R2,R10
	
DONE_D2:
	MOVB [R10],R8	 ; mete a linha no ecra
	
	DEC R10	 ; volta ao byte inicial
	
FIM_LINHA:
	DEC R5	 ;  menos uma linha a fazer
	JZ FIM_DRAW	 ; se ja estao todas sai da rotina
	INC R6	 ; proxima linha da imagem
	ADD R10,4 	; endereço da proxima linha do ecrã
	
	JMP LOOP_LINHA	 ; repete para a proxima linha

FIM_DRAW:

	POP R4    ; vai buscar a vaiavel do objeto guardada em stack
	OR  R2,R2
	JZ  sem_colisao
	
	CALL colisao ; R4 objeto, R2 byte da colisao e R3 pixel da colisao
	
sem_colisao:
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
;*-------------------------------------------------------------------------
	
	
;* -- Rotina de subir ninja -----------------------------------------------------------------
;* 
;* Descrição: Apaga o ninja, sobe uma linha e desenha-o
;*
;* Parâmetros:  R4 - objeto
;*----------------------------------------------------------------------------------------------------------------------
MOVER_NINJA_CIMA:
    PUSH   R0
	PUSH   R1
	PUSH   R2
	PUSH   R3
	PUSH   R4
	PUSH   R5
	
	MOV	   R0, [R4+6]
	OR	   R0, R0
	JZ	   DONE_MN	 ; se o ninja já desapareceu nao acontece nada
	MOV	   R2,[R4+2]   ; R2 contem a linha
	OR	   R2,R2
	JZ     DONE_MN	 ; se a linha é 0 nao sobe mais
	MOV    R1,[R4]	 ; R1 = coluna
	MOV    R3,[R4+4]	 ; R3 = objeto
    MOV    R0,0
	CALL   draw_objeto	 ; apaga o objeto
	DEC    R2
	MOV    [R4+2],R2	 ; sobe de linha
	INC    R0	 
	CALL   draw_objeto	 ; desenha objeto

DONE_MN:
	POP    R5
	POP    R4
	POP    R3
	POP    R2
	POP    R1
	POP    R0
	RET
	

;* -- Rotina de descer ninja -----------------------------------------------------------------
;* 
;* Descrição: Apaga o ninja, desce uma linha e desenha-o
;*
;* Parâmetros:  R4 - objeto
;*----------------------------------------------------------------------------------------------------------------------	
MOVER_NINJA_BAIXO:
    PUSH   R0
	PUSH   R1
	PUSH   R2
	PUSH   R3
	PUSH   R4
	PUSH   R5
	
	MOV	   R0,[R4+6]
	OR	   R0, R0
	JZ	   DONE_MD
	MOV	   R2,[R4+2]   ; R2 contem a linha
	MOV    R1,[R4]	 ; R1 = contem a coluna
	MOV    R3,[R4+4]	 ; R3 = imagem do objeto
    MOV    R0,0
	CALL   draw_objeto	 ; apaga o objeto
	MOV    R5,	27
	CMP    R2, R5	 
	JGT	   mata_ninja	 ; se o ninja tentar descer mais do que o chao morre
	INC    R2
	MOV    [R4+2],R2	 ; desce de linha
	INC    R0	 
	CALL   draw_objeto	 ; desenha objeto
	JMP DONE_MD

mata_ninja:
	CALL morte_ninja

DONE_MD:
	POP    R5
	POP    R4
	POP    R3
	POP    R2
	POP    R1
	POP    R0
	RET
	
;* -- Rotina de subir ninja -----------------------------------------------------------------
;* 
;* Descrição: Apaga o ninja permanentemente, e se já nao ha ninjas acaba o jogo
;*
;*----------------------------------------------------------------------------------------------------------------------
morte_ninja:
	PUSH R0	 
	PUSH R1
	
	MOV R1,ninjas_em_jogo
	MOV R0,[R1]
	DEC R0	 ; menos um ninja em jogo
	MOV [R1],R0
	OR R0,R0
	JNZ mn_continue     ; not game over
	
	MOV R1,estado_do_jogo
	MOV [R1],R0         ; game over
	
	CALL ecra_xadrez
	JMP done_mn
	
mn_continue:
	XOR R0,R0
	CALL draw_var_objeto	 ; apaga o ninja
	MOV [R4 + 6], R0	 ; faz o ninja desaparecer

done_mn:
	POP R1
	POP R0
	RET


;* -- Rotina de deteçao de teclas -----------------------------------------------------------------
;* 
;* Descrição: Deteta qual a tecla premida e faz a sua devida funçao
;*
;* Parametros: R6 - valor da tecla premida
;*----------------------------------------------------------------------------------------------------------------------	
ACCAO_TECLA:          
    PUSH   R1
	PUSH   R2
	PUSH   R3
	PUSH   R4
	PUSH   R5
	PUSH   R6
	PUSH   R7
	
	MOV    R1,estado_do_jogo
	MOV    R2,[R1]
	OR     R2,R2
	JZ     so_teclas_com_jogo_parado	 ; se o jogo tiver parado so atuam certas teclas
	DEC    R2
	DEC    R2
	JZ     so_teclas_com_jogo_parado
	

TESTA0:
	MOV    R5,   0
	CMP    R6,   R5	 ; testa se a tecla é 0
	JNZ    TESTA1	 ; quando nao é 0 vai para o proximo teste      
	MOV    R4,ninja1	 
	CALL   MOVER_NINJA_CIMA	 ; sobe o ninja1

	
TESTA1:	
	MOV    R5,   1	 
	CMP    R6,   R5	 ; testa se a tecla é 1
	JNZ    TESTA2           
	MOV    R4,ninja2
	CALL   MOVER_NINJA_CIMA	 ; sobe o ninja2
	JMP DONE_AT	
TESTA2:	
	MOV    R5,   2
	CMP    R6,   R5	 ; testa se a tecla é 2        
	JNZ    TESTA3           
	MOV    R4,ninja3
	CALL   MOVER_NINJA_CIMA	 ; sobe o ninja3
	JMP DONE_AT	
TESTA3:	
	MOV    R5,   3	 
	CMP    R6,   R5	 ; testa se a tecla é 3         
	JNZ    TESTA4           
	MOV    R4,ninja4
	CALL   MOVER_NINJA_CIMA	 ; sobe o ninja4
	JMP DONE_AT	
TESTA4:	
	MOV    R5,   4	
	CMP    R6,   R5	 ; testa se a tecla é 4
	JNZ    TESTA5           
	MOV    R4,ninja1
	CALL   MOVER_NINJA_BAIXO  ; desce o ninja1
	JMP DONE_AT	
TESTA5:	
	MOV    R5,   5	
	CMP    R6,   R5  ; testa se a tecla é 5
	JNZ    TESTA6           
	MOV    R4,ninja2
	CALL   MOVER_NINJA_BAIXO  ; desce o ninja2
	JMP DONE_AT	
TESTA6:	
	MOV    R5,   6
	CMP    R6,   R5	 ; testa se a tecla é 6         
	JNZ    TESTA7           
	MOV    R4,ninja3
	CALL   MOVER_NINJA_BAIXO  ; desce o ninja3
	JMP DONE_AT	
TESTA7:	
	MOV    R5,   7
	CMP    R6,   R5	 ; testa se a tecla é 7         
	JNZ    TESTAC
	MOV    R4,ninja4
	CALL   MOVER_NINJA_BAIXO  ; desce o ninja4
	JMP DONE_AT	
	
so_teclas_com_jogo_parado:
TESTAC:
	MOV    R5,   0ch
	CMP    R6,   R5	 ; testa se a tecla é  c       
	JNZ    TESTAD
	
	MOV    R1,estado_do_jogo
	MOV    R2,[R1]
	OR     R2,R2
	JNZ    DONE_AT	 ; se o jogo tiver a andar nao faz nada
	INC    R2

	CALL   inicializar_jogo	 ; começa o jogo
	MOV    R2,1
	MOV    [R1],R2
	
	JMP DONE_AT

TESTAD:
	MOV    R5,   0DH
	CMP    R6,   R5	 ; testa se a tecla é  d       
	JNZ    TESTAE
	
	MOV    R1,estado_do_jogo
	MOV    R2,[R1]
	MOV	   R3, 1
	CMP	   R2, R3
	JNZ	   TESTAPAUSED
	INC	   R2
	MOV    [R1], R2	 ; pausa o jogo
	JMP    DONE_AT
	TESTAPAUSED:
	MOV	   R3, 2
	CMP	   R2, R3
	JNZ	   DONE_AT
	DEC    R2
	MOV	   [R1], R2	 ; continua o jogo
	
	JMP DONE_AT
	
TESTAE:
	MOV    R5,   0EH
	CMP    R6,   R5	 ; testa se a tecla é  e      
	JNZ    DONE_AT
	MOV R1, estado_do_jogo
	MOV R2, 0
	MOV [R1], R2	 ; acaba o jogo
	CALL ecra_xadrez
DONE_AT:
    POP    R7
    POP    R6
	POP    R5
	POP    R4
	POP    R3
    POP    R2
	POP    R1
	RET
	
;* -- Rotina arma aleatoria -----------------------------------------------------------------
;* 
;* Descrição: Escolhe uma altura e o tipo de arma aleatoriamente
;*
;*----------------------------------------------------------------------------------------------------------------------	
arma_aleatoria:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4

	CALL randomize
	MOV R1,R0      ; R1 tem tipo de arma
	
	CALL randomize
	MOV  R3,14
	MOD  R0,R3     ; R3 altura aleatoria de 0 a 13
	
	MOV  R3,[R4+2]
	SHR  R3,4
	MOV  R3,0
	JZ   arma1_ae  ; se o shift duas instruçoes não deixou o registo a zero, estamos a processar a segunda arma
	MOV  R3,16	 ; altura minima da segunda arma

arma1_ae:
	ADD R3,R0	 
	MOV [R4+2],R3	 ; nova altura
	
	MOV R2,3
	AND R1,R2
	JNZ  e_estrela_ae	 ; 1/4 chances de ser prenda
	MOV R1, objeto_prenda
	MOV [R4+4], R1	 ; coloca o objeto a prenda
	JMP fim_arma_aleatoria
e_estrela_ae:
	MOV R1, objeto_estrela
	MOV [R4+4], R1	 ; coloca a estrela
fim_arma_aleatoria:
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	
;* -- Rotina que testa as flags das interrupções -------------------------------------------
;* 
;* Descrição: Deteta se as flags das interrupções estão ativas e quando estão faz a açao respetiva
;*
;*	
testa_interrupts:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7

	MOV R7,estado_do_jogo
	MOV R1,[R7]
	DEC R1
	JZ  running
	
	; limpar as flags de interrupts
	XOR    R5,R5
	MOV    R6,int_arma
	MOV    [R6],R5
	
	MOV    R6,int_ninja
	MOV    [R6],R5

	CALL   randomize  ; melhorar aleatoriadade inicial
	JMP    no_interrupts
	
running:
	MOV R6,random  ; incrementar random
	MOV R5,[R6]
	INC R5
	MOV [R6],R5
	
	MOV    R6,int_arma
	MOV    R5,[R6]
	OR     R5,R5
	JZ     testa_move_ninja
	XOR    R5,R5
	MOV    [R6],R5

	MOV    R6,mundo
	MOV    R5,[R6]  ; NUMERO DE OBJETOS
move_prox_arma:
	ADD	   R6,2     ; R3 APONTA PRIMEIRa variavel de estado

	MOV    R4,[R6]  ; TEM variavel de estado
	MOV    R3,[R4+4] ; tem endereço do objeto
	MOV    R1,objeto_ninja
	CMP	   R3,R1
	JZ     nao_arma
	
	MOV    R0,0
	CALL   draw_var_objeto	
	
	MOV    R1,[R4]
	SUB    R1,1
	MOV    [R4],R1
	JNC    desenha_arma
	CALL   arma_aleatoria
	MOV    R1,29    ; colocar a arma na ultima coluna menos a largura da arma
	MOV    [R4],R1
	
desenha_arma:
	MOV R0,1 
	CALL draw_var_objeto
	
	MOV R1,[R7]
	DEC R1
	JNZ  no_interrupts  ; o jogo parou

nao_arma:
	DEC    R5
	JNZ    move_prox_arma

testa_move_ninja:	
	MOV    R6,int_ninja
	MOV    R5,[R6]
	OR     R5,R5
	JZ     no_interrupts
	XOR    R5,R5
	MOV    [R6],R5

	MOV    R6,mundo
	MOV    R5,[R6]  ; NUMERO DE OBJETOS
move_prox_ninja:
	ADD	   R6,2     ; R3 APONTA PRIMEIRa variavel de estado

	MOV    R4,[R6]  ; TEM variavel de estado
	MOV    R3,[R4+4] ; tem endereço do objeto
	MOV    R1,objeto_ninja
	CMP	   R3,R1
	JNZ    nao_ninja
	
	CALL MOVER_NINJA_BAIXO  ; desce o ninja1
	MOV  R1,[R7]
	DEC  R1
	JNZ  no_interrupts  ; o jogo parou

nao_ninja:
	DEC    R5
	JNZ    move_prox_ninja
no_interrupts:
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
;*---------------------------------------------------------------------------


;* -- Rotina de inicializar arma -----------------------------------------------------------------
;* 
;* Descrição: Escolhe tipo de arma e altura aleatorias
;* 
;*Parametros: R4 - objeto
;*----------------------------------------------------------------------------------------------------------------------
inicializar_arma:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5

	MOV R3,29
	MOV [R4],R3
	
	CALL randomize ; Y aleatorio
	MOV R5,14
	MOD R0,R5
	ADD R0,R1
	MOV [R4+2],R0
	
	CALL randomize ; Estrela ou Arma
	MOV R2,3
	AND R0,R2
	JNZ  e_estrela_ia	 ;se de 0 a 3, o numero nao for 0 entao aparece estrela
	MOV R1, objeto_prenda
	JMP done_ia	 ;proxima arma

e_estrela_ia:
	MOV R1, objeto_estrela
done_ia:
	MOV [R4+4], R1	;coloca o objeto_estrela na arma

	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET
	
	
;* -- Rotina que inicializa o jogo -----------------------------------------------------------------
;* 
;* Descrição: Inicializa o mundo
;*
;* Parametros: R2 - Estado do jogo
;*----------------------------------------------------------------------------------------------------------------------
	; R2 != 0 indica que deve desenhar os ninjas e armas
inicializar_jogo:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5

; Inicializações
	MOV  R0,score	; começa o score a 0
	XOR  R1,R1
	MOV  [R0],R1
	MOV  R0, DISPLAYS
	MOVB [R0], R1

	MOV R0,estado_do_jogo
	MOV R1,STOPPED
	MOV [R0],R1
	
	MOV R0,ninjas_em_jogo
	MOV R1,4
	MOV [R0],R1
	
	OR  R2,R2
	JZ  done_ij
	
	CALL CLEAR_SCREEN	;chama a rotina que limpa o ecra

	;Inicializa as armas
	MOV R4, arma1
	XOR R1,R1
	CALL inicializar_arma
	
	MOV R4,arma2
	MOV R1,16
	CALL inicializar_arma

	;inicializar os ninjas
	MOV R0,2           ; desenhar	
	MOV R2,16
	;Inicializa o ninja1
	MOV R4,ninja1
	MOV [R4+6],R0       ; posicao
	MOV [R4+2],R2       ; visivel
	CALL draw_var_objeto

	;Inicializa o ninja2
	MOV R4,ninja2
	MOV [R4+6],R0
	MOV [R4+2],R2       ; visivel
	CALL draw_var_objeto

	;Inicializa o ninja3
	MOV R4,ninja3
	MOV [R4+6],R0
	MOV [R4+2],R2       ; visivel
	CALL draw_var_objeto

	;Inicializa o ninja4
	MOV R4,ninja4
	MOV [R4+6],R0
	MOV [R4+2],R2       ; visivel
	CALL draw_var_objeto
	
	MOV R4,arma1
	MOV R0,1
	CALL draw_var_objeto	 ;desenha a arma1

	MOV R4,arma2
	MOV R0,1
	CALL draw_var_objeto	 ;desenha a arma2

done_ij:
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET

inicializar_interrupts:
	PUSH R0
	MOV R0, 0
	MOV RCN, R0
	MOV BTE, tabint           ; incializa BTE
	EI0                     ; permite interrupções 0
	EI1
	EI 

	POP  R0
	RET

	; tecla premida em R6, flag C ativa se tecla premida
testa_tecla_premida:
	PUSH  R2
	PUSH  R3
	PUSH  R4
	PUSH  R5
	
	MOV    R2,   TEC_LIN    ; endereço do periférico das linhas
	MOV    R3,   TEC_COL    ; endereço do periférico das colunas
	MOV    R4,   DISPLAYS   ; endereço do periférico dos displays
	
	MOV    R5,   LINHA      ; começar o scan na coluna 4 para facilitar o loop 
	
testar_teclado_etp:	
    MOV    R1, R5           ; testar a linha corrente 
    MOVB   [R2], R1         ; escrever no periférico de saída (linhas)
	MOVB   R0,  [R3]        ; ler do periférico de entrada (colunas)
	MOV    R6,0FH
	AND    R0,R6
    CMP    R0,   0             ; há tecla premida?
    JNZ    tecla_etp           ; tratar tecla
	SHR    R5,   1             ; avançar para a próxima linha
	JNZ    testar_teclado_etp  ; scan da proxima linha 
	CLRC                       ; limpa o carry porque nao temos linha
	JMP    fim_etp
	
tecla_etp:	
	MOV    R6,   0          ; contador de linha

numero_linha:	
	SHR    R5,   1          ; move bit de menor peso para carry
	JC     linha_por_4      ; se carry temos a linha
	ADD    R6,   1
	JMP    numero_linha     ; continuar a contar

linha_por_4:	
	SHL    R6,   2          ; multiplica o numero da linha por 4

numero_coluna:
	SHR    R0,   1          ; move bit de menor peso para carry
	JC     fim_etp          ; sabe-se a tecla
	ADD    R6,   1          ; incrementa
	JMP    numero_coluna    ; ainda nao se sabe a tecla

fim_etp:
	POP    R5
	POP    R4
	POP    R3
	POP    R2
	RET
	
	
;* -- Rotina esperar que se largue a tecla -----------------------------------------------------------------
;* 
;* Descrição: Se a tecla ainda esta premida, ativa a flag Zero
;*
;*----------------------------------------------------------------------------------------------------------------------
tecla_levantada:
	PUSH   R0
	PUSH   R1
	PUSH   R3
	
	MOV    R3,   TEC_COL    ; endereço do periférico das colunas

	MOVB   R0,  [R3]        ; lê do periférico de entrada (colunas)
	MOV	   R1, 0FH
	AND    R0, R1
	CMP    R0,   0          ; deteta se ainda se está a carregar na tecla
	
	POP    R3
	POP    R1
	POP    R0
	RET
	
	


	
	