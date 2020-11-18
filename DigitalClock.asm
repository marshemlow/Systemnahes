	MOV	A, #38H		; Use 2 lines and 5x7 matrix
	ACALL	CMND
	MOV	A, #0FH		; LCD ON, cursor ON, cursor blinking ON
	ACALL	CMND
	MOV	A, #01H		;Clear screen
	ACALL	CMND
	MOV	A, #06H		;Increment cursor
	ACALL	CMND
	MOV	A, #82H		;Cursor line one , position 2
	ACALL	CMND
	MOV	A, #3CH		;Activate second line
	ACALL	CMND
	MOV	A, #49D
	ACALL	DISP
	MOV	A, #54D
	ACALL	DISP
	MOV	A, #88D
	ACALL	DISP
	MOV	A, #50D
	ACALL	DISP
	MOV	A, #32D
	ACALL	DISP
	MOV	A, #76D
	ACALL	DISP
	MOV	A, #67D
	ACALL	DISP
	MOV	A, #68D
	ACALL	DISP

	MOV	A, #0C1H	;Jump to second line, position 1
	ACALL	CMND

	MOV	A, #67D
	ACALL	DISP
	MOV	A, #73D
	ACALL	DISP
	MOV	A, #82D
	ACALL	DISP
	MOV	A, #67D
	ACALL	DISP
	MOV	A, #85D
	ACALL	DISP
	MOV	A, #73D
	ACALL	DISP
	MOV	A, #84D
	ACALL	DISP
	MOV	A, #83D
	ACALL	DISP
	MOV	A, #84D
	ACALL	DISP
	MOV	A, #79D
	ACALL	DISP
	MOV	A, #68D
	ACALL	DISP
	MOV	A, #65D
	ACALL	DISP
	MOV	A, #89D
	ACALL	DISP

HERE:	SJMP	HERE

CMND:	MOV	P1, A
	CLR	P3.5
	CLR	P3.4
	SETB	P3.3
	CLR	P3.3
	ACALL	DELY
	RET

DISP:	MOV	P1, A
	SETB	P3.5
	CLR	P3.4
	SETB	P3.3
	CLR	P3.3
	ACALL	DELY
	RET

DELY:	CLR	P3.3
	CLR	P3.5
	SETB	P3.4
	MOV	P1, #0FFh
	SETB	P3.3
	MOV	A, P1
	JB	ACC.7, DELY

	CLR	P3.3
	CLR	P3.4
	RET

	END

RS	EQU	P0.4
EN	EQU	P0.5
PORT	EQU	P0
U	EQU	30H
L	EQU	31H
	ORG	000H

	MOV	DPTR, #INIT_COMMANDS
	ACALL	LCD_CMD
	MOV	DPTR, #LINE1
	ACALL	LCD_CMD
	MOV	DPTR, #TEXT1
	ACALL	LCD_DISP
	MOV	DPTR, #LINE2
	ACALL	LCD_CMD
	MOV	DPTR, #TEXT2
	ACALL	LCD_DISP
	SJMP	$


SPLITER:	MOV	L, A
	ANL	L, #00FH
	SWAP	A
	ANL	A, #00FH
	MOV	U, A
	RET

MOVE:	ANL	PORT, #0F0H
	ORL	PORT, A
	SETB	EN
	ACALL	DELAY
	CLR	EN
	ACALL	DELAY
	RET


LCD_CMD:	CLR	A
	MOVC	A, @A+DPTR
	JZ	EXIT2
	INC	DPTR
	CLR	RS
	ACALL	SPLITER
	MOV	A, U
	ACALL	MOVE
	MOV	A, L
	ACALL	MOVE
	SJMP	LCD_CMD
EXIT2:	RET



LCD_DATA:	SETB	RS
	ACALL	SPLITER
	MOV	A, U
	ACALL	MOVE
	MOV	A, L
	ACALL	MOVE
	RET

LCD_DISP:	CLR	A
	MOVC	A, @A+DPTR
	JZ	EXIT1
	INC	DPTR
	ACALL	LCD_DATA
	SJMP	LCD_DISP
EXIT1:	RET




DELAY:	MOV	R7, #10H
L2:	MOV	R6, #0FH
L1:	DJNZ	R6, L1
	DJNZ	R7, L2
	RET

INIT_COMMANDS:	DB	20H, 28H, 0CH, 01H, 06H, 80H, 0
LINE1:	DB	01H, 06H, 06H, 80H, 0
LINE2:	DB	0C0H, 0
CLEAR:	DB	01H, 0

;TEXT1:	DB	" CircuitsToday ", 0
;TEXT2:	DB	"4bit Using 1Port", 0

	END