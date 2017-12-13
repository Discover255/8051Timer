		ORG  0000H
		LJMP MAIN
		ORG  000BH
		LJMP INT
		ORG  0030H
MAIN: 	MOV  R0,#0
		MOV  R1,#0
		MOV  R2,#3
		MOV  R3,#0
		MOV  R4,#5
		MOV  R5,#1
		MOV  R6,#5
		MOV  R7,#0
		SETB RS1
		CPL  P1.2
		MOV  R3,#0
		CLR  RS1
		MOV  TMOD,#01H
		MOV  TL0,#1
		MOV  TH0,#240
		SETB TR0
		SETB ET0
		SETB EA
		;seraching here can be binary searching
		LJMP IF0
IF0:	CJNE R7,#255,LOOP1
		MOV  R7,#0
		LCALL TIMEDEC
		CPL	 P1.0
LOOP1:	NOP
IF2:	CJNE R0,#0,ELIF21
		MOV  A,R1
		LJMP BREAK1
ELIF21:	CJNE R0,#1,ELIF22
		MOV  A,R2
		LJMP BREAK1
ELIF22:	CJNE R0,#2,ELIF23
		MOV  A,R3
		LJMP BREAK1
ELIF23:	CJNE R0,#3,ELIF24
		MOV  A,R4
		LJMP BREAK1
ELIF24:	CJNE R0,#4,ELSE2
		MOV  A,R5
		LJMP BREAK1
ELSE2:	MOV  A,R6
BREAK1:	MOV  DPTR,#SEGTAB
		MOVC A,@A+DPTR
		SETB P2.6
		MOV  P0,A
		CLR  P2.6
		MOV  DPTR,#SELECT
		MOV  A,R0
		MOVC A,@A+DPTR
		SETB P2.7
		MOV  P0,A
		CLR  P2.7
		LCALL FLICK
		JB   00H,IF15TRUNK;sometimes flagbit read is wrong,00H is a signal with a low freq for  flick
		LCALL CHECKP30
		LCALL CHECKP31
		LCALL CHECKP32
		JNB  09H,IF43
		CLR  09H
		LCALL MOVSELECT
IF43:	JNB  06H,IF21
		CLR  06H
		LCALL TIMEINC
IF21:	JNB  03H,SWITCH1;the bit at 03H is the sign of key P3.0 up
		CLR  03H
		LCALL MOVSELECT
SWITCH1:SETB RS1
		MOV  A,13H
CASE0:	CJNE A,#0,CASE1
IF15TRUNK:LJMP IF15
CASE1:	CJNE R3,#1,CASE2
		CLR  RS1
		LCALL SKIPH
		SJMP IF15
CASE2:  CJNE R3,#2,CASE3
		CLR  RS1
		LCALL SKIPM
		SJMP IF15
CASE3:  CJNE R3,#3,IF15
		CLR  RS1
		LCALL SKIPS
		SJMP IF15
IF15:	SETB RS1
		MOV  A,#1
		CJNE A,10H,IF9
		LJMP RESET1
IF9:	JNC  IF10
RESET1: MOV  R0,#0
		CLR  RS1
		LCALL INDEX
IF10:	CLR  RS1
		LJMP IF0

;========================================================================================

INT:	NOP
		MOV  TL0,#1
		MOV  TH0,#240
		JNB  0DH,IF42
		INC  07H;provide a clock for timer
IF42:	INC  10H;increase group 3th R0,for update of view
		INC  11H;increase group 3th R1,for flick of time
IF30:	JNB  02H,IF31;check P3.0 keyup event
		INC  12H;increase group 3th R2,for confirm the event of P3.0 keyup
IF31:	JNB  05H,IF47;check P3.1 keyup event
		INC  14H;increase group 3th R4,for confirm the event of P3.1 keyup
IF47:	JNB  08H,QUITINT;check P3.2 keyup event
		INC  15H;increase group 3th R5,for confirm the event of P3.2 keyup
QUITINT:RETI

;===================================================================================================

TIMEDEC:NOP
IF3:	CJNE R6,#0,ELSE3
IF4:	CJNE R5,#0,ELSE4
IF5:	CJNE R4,#0,ELSE5
IF6:	CJNE R3,#0,ELSE6
IF7:	CJNE R2,#0,ELSE7
IF8:	CJNE R1,#0,ELSE8
		CLR  P2.3
		CLR  09H
		RET
ELSE8:	DEC	 R1
		LJMP BORROW2
ELSE7:	DEC  R2
		LJMP BORROW3
ELSE6:	DEC  R3
		LJMP BORROW4
ELSE5:	DEC  R4
		LJMP BORROW5
ELSE4:	DEC  R5
		LJMP BORROW6
ELSE3:	DEC  R6
		RET
BORROW2:MOV  R2,#9
BORROW3:MOV  R3,#5
BORROW4:MOV  R4,#9
BORROW5:MOV  R5,#5
BORROW6:MOV  R6,#9
		RET

;-------------------------------------------------------------------------------------------

INDEX:  INC  R0
		MOV  A,#6
		CJNE A,00H,CHECK1
		MOV  R0,#0
		SJMP RETURN1
CHECK1: JNC  RETURN1
		MOV  R0,#0
RETURN1:RET

;-------------------------------------------------------------------------------------------

SKIPH:  CJNE R0,#0,IF11
		LCALL INDEX
IF11:	CJNE R0,#1,RETURN2
		LCALL INDEX
RETURN2:RET

;---------------------------------------------------------------------------------------------

SKIPM:  CJNE R0,#2,IF12
		LCALL INDEX
IF12:	CJNE R0,#3,RETURN3
		LCALL INDEX
RETURN3:RET

;---------------------------------------------------------------------------------------------

SKIPS:  CJNE R0,#4,IF13
		LCALL INDEX
IF13:	CJNE R0,#5,RETURN4
		LCALL INDEX
RETURN4:RET

;---------------------------------------------------------------------------------------------

FLICK:  SETB RS1
		MOV  A,#50
		CJNE A,11H,IF14
		SJMP RESET2
		RET
IF14:   JNC  RETURN5
RESET2: NOP
		CPL  00H
		MOV  R1,#0
		CLR  RS1
RETURN5:CLR  RS1
		RET

;---------------------------------------------------------------------------------------------

CHECKP30:	JB   P3.0,BREAK16
			SETB 01H
	BREAK16:JNB  01H,BREAK17
			JNB  P3.0,BREAK17
			SETB 02H
	BREAK17:SETB RS1
			CJNE R2,#5,ELSE18
			MOV  R2,#0
			CLR  01H
			CLR  02H
			JNB  P3.0,KEYUP01
			CLR  02H
			CPL  P1.3
			SETB 03H
			CLR  RS1
			LJMP BREAK18
	KEYUP01:SETB 02H
			CLR  RS1
			LJMP BREAK18
	ELSE18: JC   BREAK18
			MOV  R2,#0
			CLR  01H
			CLR  02H
			JNB  P3.0,KEYUP02
			CLR  02H
			CPL  P1.3
			SETB 03H
			CLR  RS1
			LJMP BREAK18
	KEYUP02:SETB 02H
			CLR  RS1
			LJMP BREAK18
	BREAK18:JB   02H,BREAK19
			CLR  02H
	BREAK19:NOP
RETURN6:	RET

;--------------------------------------------------------------------------------------------

CHECKP31:	JB   P3.1,BREAK26
			SETB 04H
	BREAK26:JNB  04H,BREAK27
			JNB  P3.1,BREAK27
			SETB 05H
	BREAK27:MOV  A,14H
			CJNE A,#5,ELSE28
			MOV  14H,#0
			CLR  04H
			CLR  05H
			JNB  P3.1,KEYUP11
			CLR  05H
			CPL  P1.4
			SETB 06H
			LJMP BREAK28
	KEYUP11:SETB 05H
			LJMP BREAK28
	ELSE28: JC   BREAK28
			MOV  14H,#0
			CLR  04H
			CLR  05H
			JNB  P3.1,KEYUP12
			CLR  05H
			CPL  P1.4
			SETB 06H
			LJMP BREAK28
	KEYUP12:SETB 05H
			LJMP BREAK28
	BREAK28:JB   05H,RETURN7
			CLR  05H
RETURN7:	RET

;---------------------------------------------------------------------------------------------

CHECKP32:	JB   P3.2,BREAK44
			SETB 07H
	BREAK44:JNB  07H,BREAK45
			JNB  P3.2,BREAK45
			SETB 08H
	BREAK45:MOV  A,15H
			CJNE A,#5,ELSE46
			MOV  14H,#0
			CLR  07H
			CLR  08H
			JNB  P3.2,KEYUP21
			CLR  08H
			CPL  P1.5
			SETB 06H
			LJMP BREAK46
	KEYUP21:SETB 08H
			LJMP BREAK46
	ELSE46: JC   BREAK46
			MOV  14H,#0
			CLR  07H
			CLR  08H
			JNB  P3.2,KEYUP22
			CLR  08H
			CPL  P1.5
			SETB 06H
			LJMP BREAK46
	KEYUP22:SETB 08H
			LJMP BREAK46
	BREAK46:JB   08H,RETURN9
			CLR  08H
RETURN9:	RET

;---------------------------------------------------------------------------------------------

TIMEINC:	MOV  A,13H
			;CLR  RS1
IF35:		CJNE A,#1,ELIF35_1
			LJMP INCH
ELIF35_1:	CJNE A,#2,ELIF35_2
			LJMP INCM
ELIF35_2: 	CJNE A,#3,RETURN8
			LJMP INCS
RETURN8:	RET

INCH:		NOP
IF36:		MOV  A,02H
			CJNE A,#9,ELSE36;
			;CJNE R2,#9,ELSE36;addressing R2,R1 using name may cause wrong addressing (RS0 == 0,RS1 == 0)
IF37:		MOV  A,01H
			CJNE A,#9,ELSE37
			MOV  01H,#0
			MOV  02H,#0
ELSE37:		INC  01H
			MOV  02H,#0
			RET
ELSE36:		INC  02H
			RET

INCM:		NOP
IF38:		MOV  A,04H
			CJNE A,#9,ELSE38
IF39:		MOV  A,03H
			CJNE A,#5,ELSE39
			MOV  03H,#0
			MOV  04H,#0
ELSE39:		INC  03H
			MOV  04H,#0
			RET
ELSE38:		INC  04H
			RET

INCS:		NOP
IF40:		MOV  A,06H
			CJNE A,#9,ELSE40
IF41:		MOV  A,05H
			CJNE A,#5,ELSE41
			MOV  05H,#0
			MOV  06H,#0
ELSE41:		INC  05H
			MOV  06H,#0
			RET
ELSE40:		INC  06H
			RET
;---------------------------------------------------------------------------------------------

MOVSELECT:	MOV  A,13H
IF25:		CJNE A,#3,ELIF25_1
			MOV  13H,#0
			RET
ELIF25_1:	JNC   ELIF25_2
			INC  13H
			RET
ELIF25_2:   MOV  13H,#0
			RET
;=====================================================================================================
;in this way,I can't hide all dig
SEGTAB:		 DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
SELECT: 	 DB 11111110B,11111101B,11111011B,11110111B,11101111B,11011111B
END