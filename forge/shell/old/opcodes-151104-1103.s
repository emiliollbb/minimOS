; minimOS 0.5a1 disassembler
; (c) 2015-2021 Carlos J. Santisteban
; last modified 20151104-1103

; Opcode list as bit-7 terminated strings
; @ expects single byte, & expects word
; Rockwell 65C02 version (plus STP & WAI)
; will be used by the assembler module too
da_oclist:
	.asc	"BR", 'K'+$80	; $00=BRK
	.asc	"ORA (@, X", ')'+$80	; $01=ORA (zp,X)
	.asc	"?22 ", '@'+$80	; $02=?
	.asc	"?1", '1'+$80	; $03=?
	.asc	"TSB ", '@'+$80	; $04=TSB zp	CMOS
	.asc	"ORA ", '@'+$80	; $05=ORA zp
	.asc	"ASL ", '@'+$80	; $06=ASL zp
	.asc	"RMB0 ", '@'+$80	; $07=RMB0 zp	CMOS R
	.asc	"PH", 'P'+$80	; $08=PHP
	.asc	"ORA #", '@'+$80	; $09=ORA #
	.asc	"AS", 'L'+$80	; $0A=ASL
	.asc	"?1", '1'+$80	; $0B=?
	.asc	"TSB ", '&'	; $0C=TSB abs	CMOS
	.asc	"ORA ", '&'+$80	; $0D=ORA abs
	.asc	"ASL ", '&'+$80	; $0E=ASL abs
	.asc	"BBR0 ", '@'+$80	; $0F=BBR0 rel	CMOS R
	.asc	"BPL ", '@'+$80	; $10=BPL rel
	.asc	"ORA (@), ", 'Y'+$80	; $11=ORA (zp),Y
	.asc	"ORA (@", ')'+$80	; $12=ORA (zp)	CMOS
	.asc	"?1", '1'+$80	; $13=?
	.asc	"TRB ", '@'+$80	; $14=TRB zp	CMOS
	.asc	"ORA @, ", 'X'+$80	; $15=ORA zp,X
	.asc	"ASL @, ", 'X'+$80	; $16=ASL zp,X
	.asc	"RMB1 ", '@'+$80	; $17=RMB1 zp	CMOS R
	.asc	"CL", 'C'+$80	; $18=CLC
	.asc	"ORA &, ", 'Y'+$80	; $19=ORA abs,Y
	.asc	"IN", 'C'+$80	; $1A=INC		CMOS
	.asc	"?1", '1'+$80	; $1B=?
	.asc	"TRB ", '&'+$80	; $1C=TRB abs	CMOS
	.asc	"ORA &, ", 'X'+$80	; $1D=ORA abs,X
	.asc	"ASL &, ", 'X'+$80	; $1E=ASL abs,X
	.asc	"BBR1 ", '@'+$80	; $1F=BBR1 rel	CMOS R
	.asc	"JSR ", '&'+$80	; $20=JSR abs
	.asc	"AND (@, X", ')'+$80	; $21=AND (zp,X)
	.asc	"?22 ", '@'+$80	; $22=?
	.asc	"?1", '1'+$80	; $23=?
	.asc	"BIT ", '@'+$80	; $24=BIT zp
	.asc	"AND ", '@'+$80	; $25=AND zp
	.asc	"ROL ", '@'+$80	; $26=ROL zp
	.asc	"RMB2 ", '@'+$80	; $27=RMB2 zp	CMOS R
	.asc	"PL", 'P'+$80	; $28=PLP
	.asc	"AND #", '@'+$80	; $29=AND #
	.asc	"RO", 'L'+$80	; $2A=ROL
	.asc	"?1", '1'+$80	; $2B=?
	.asc	"BIT ", '&'+$80	; $2C=BIT abs
	.asc	"AND ", '&'+$80	; $2D=AND abs
	.asc	"ROL ", '&'+$80	; $2E=ROL abs
	.asc	"BBR2 ", '@'+$80	; $2F=BBR2 rel	CMOS R
	.asc	"BMI ", '@'+$80	; $30=BMI rel
	.asc	"AND (@), ", 'Y'+$80	; $31=AND (zp),Y
	.asc	"AND (@", ')'+$80	; $32=AND (zp)	CMOS
	.asc	"?1", '1'+$80	; $33=?
	.asc	"BIT @, ", 'X'+$80	; $34=BIT zp,X	CMOS
	.asc	"AND @, ", 'X'+$80	; $35=AND zp,X
	.asc	"ROL @, ", 'X'+$80	; $36=ROL zp,X
	.asc	"RMB3 ", '@'+$80	; $37=RMB3 zp	CMOS R
	.asc	"SE", 'C'+$80	; $38=SEC
	.asc	"AND &, ", 'Y'+$80	; $39=AND abs,Y
	.asc	"DE", 'C'+$80	; $3A=DEC		CMOS
	.asc	"?1", '1'+$80	; $3B=?
	.asc	"BIT &, ", 'X'+$80	; $3C=BIT abs,X	CMOS
	.asc	"AND &, ", 'X'+$80	; $3D=AND abs,X
	.asc	"ROL &, ", 'X'+$80	; $3E=ROL abs,X
	.asc	"BBR3 ", '@'+$80	; $3F=BBR3 rel	CMOS R
	.asc	"RT", 'I'+$80	; $40=RTI
	.asc	"EOR (@, X", ')'+$80	; $41=EOR (zp,X)
	.asc	"?22 ", '@'+$80	; $42=?
	.asc	"?1", '1'+$80	; $43=?
	.asc	"?23 ", '@'+$80	; $44=?
	.asc	"EOR ", '@'+$80	; $45=EOR zp
	.asc	"LSR ", '@'+$80	; $46=LSR zp
	.asc	"RMB4 ", '@'+$80	; $47=RMB4 zp	CMOS R
	.asc	"PH", 'A'+$80	; $48=PHA
	.asc	"EOR #", '@'+$80	; $49=EOR #
	.asc	"LS", 'R'+$80	; $4A=LSR
	.asc	"?1", '1'+$80	; $4B=?
	.asc	"JMP ", '&'+$80	; $4C=JMP abs
	.asc	"EOR ", '&'+$80	; $4D=EOR abs
	.asc	"LSR ", '&'+$80	; $4E=LSR abs
	.asc	"BBR4 ", '@'+$80	; $4F=BBR4 rel	CMOS R
	.asc	"BVC ", '@'+$80	; $50=BVC rel
	.asc	"EOR (@), ", 'Y'+$80	; $51=EOR (zp),Y
	.asc	"EOR (@", ')'+$80	; $52=EOR (zp)	CMOS
	.asc	"?1", '1'+$80	; $53=?
	.asc	"?24 ", '@'+$80	; $54=?
	.asc	"EOR @, ", 'X'+$80	; $55=EOR zp,X
	.asc	"LSR @, ", 'X'+$80	; $56=LSR zp,X
	.asc	"RMB5 ", '@'+$80	; $57=RMB5 zp	CMOS R
	.asc	"CL", 'I'+$80	; $58=CLI
	.asc	"EOR &, ", 'Y'+$80	; $59=EOR abs,Y
	.asc	"PH", 'Y'+$80	; $5A=PHY		CMOS
	.asc	"?1", '1'+$80	; $5B=?
	.asc	"?38 ", '&'+$80	; $5C=?
	.asc	"EOR &, ", 'X'+$80	; $5D=EOR abs,X
	.asc	"LSR &, ", 'X'+$80	; $5E=LSR abs,X
	.asc	"BBR5 ", '@'+$80	; $5F=BBR5 rel	CMOS R
	.asc	"RT", 'S'+$80	; $60=RTS
	.asc	"ADC (@, X", ')'+$80	; $61=ADC (zp,X)
	.asc	"?22 ", '@'+$80	; $62=?
	.asc	"?1", '1'+$80	; $63=?
	.asc	"STZ ", '@'+$80	; $64=STZ zp	CMOS
	.asc	"ADC ", '@'+$80	; $65=ADC zp
	.asc	"ROR ", '@'+$80	; $66=ROR zp
	.asc	"RMB6 ", '@'+$80	; $67=RMB6 zp	CMOS R
	.asc	"PL", 'A'+$80	; $68=PLA
	.asc	"ADC #", '@'+$80	; $69=ADC #
	.asc	"RO", 'R'+$80	; $6A=ROR
	.asc	"?1", '1'+$80	; $6B=?
	.asc	"JMP (&", ')'+$80	; $6C=JMP (abs)
	.asc	"ADC ", '@'+$80	; $6D=ADC abs
	.asc	"ROR ", '@'+$80	; $6E=ROR abs
	.asc	"BBR6 ", '@'+$80	; $6F=BBR6 rel	CMOS R
	.asc	"BVS ", '@'+$80	; $70=BVS rel
	.asc	"ADC (@), ", 'Y'+$80	; $71=ADC (zp),Y
	.asc	"ADC (@", ')'+$80	; $72=ADC (zp)	CMOS
	.asc	"?1", '1'+$80	; $73=?
	.asc	"STZ @, ", 'X'+$80	; $74=STZ zp,X	CMOS
	.asc	"ADC @, ", 'X'+$80	; $75=ADC zp,X
	.asc	"ROR @, ", 'X'+$80	; $76=ROR zp,X
	.asc	"RMB7 ", '@'+$80	; $77=RMB7 zp	CMOS R
	.asc	"SE", 'I'+$80	; $78=SEI
	.asc	"ADC &, ", 'Y'+$80	; $79=ADC abs, Y
	.asc	"PL", 'Y'+$80	; $7A=PLY		CMOS
	.asc	"?1", '1'+$80	; $7B=?
	.asc	"JMP (&, X", ')'+$80	; $7C=JMP (abs,X)
	.asc	"ADC &, ", 'X'+$80	; $7D=ADC abs, X
	.asc	"ROR &, ", 'X'+$80	; $7E=ROR abs, X
	.asc	"BBR7 ", '@'+$80	; $7F=BBR7 rel	CMOS R
	.asc	"BRA ", '@'+$80	; $80=BRA rel	CMOS
	.asc	"STA (@, X", ')'+$80	; $81=STA (zp,X)
	.asc	"?22 ", '@'+$80	; $82=?
	.asc	"?1", '1'+$80	; $83=?
	.asc	"STY ", '@'+$80	; $84=STY zp
	.asc	"STA ", '@'+$80	; $85=STA zp
	.asc	"STZ ", '@'+$80	; $86=STZ zp	CMOS
	.asc	"SMB0 ", '@'+$80	; $87=SMB0 zp	CMOS R
	.asc	"DE", 'Y'+$80	; $88=DEY
	.asc	"BIT #", '@'+$80	; $89=BIT #
	.asc	"TX", 'A'+$80	; $8A=TXA
	.asc	"?1", '1'+$80	; $8B=?
	.asc	"STY ", '&'+$80	; $8C=STY abs
	.asc	"STA ", '&'+$80	; $8D=STA abs
	.asc	"STX ", '&'+$80	; $8E=STX abs
	.asc	"BBS0 ", '@'+$80	; $8F=BBS0 rel	CMOS R
	.asc	"BCC ", '@'+$80	; $90=BCC rel
	.asc	"STA (@), ", 'Y'+$80	; $91=STA (zp),Y
	.asc	"STA (@", ')'+$80	; $92=STA (zp)	CMOS
	.asc	"?1", '1'+$80	; $93=?
	.asc	"STY @, ", 'X'+$80	; $94=STY zp,X
	.asc	"STA @, ", 'X'+$80	; $95=STA zp,X
	.asc	"STX @, ", 'Y'+$80	; $96=STX zp,Y
	.asc	"SMB1 ", '@'+$80	; $97=SMB1 zp	CMOS R
	.asc	"TY", 'A'+$80	; $98=TYA
	.asc	"STA &, ", 'Y'+$80	; $99=STA abs, Y
	.asc	"TX", 'S'+$80	; $9A=TXS
	.asc	"?1", '1'+$80	; $9B=?
	.asc	"STZ ", '&'+$80	; $9C=STZ abs	CMOS
	.asc	"STA &, ", 'X'+$80	; $9D=STA abs,X
	.asc	"STZ &, ", 'X'+$80	; $9E=STZ abs,X	CMOS
	.asc	"BBS1 ", '@'+$80	; $9F=BBS1 rel	CMOS R
	.asc	"LDY #", '@'+$80	; $A0=LDY #
	.asc	"LDA (@, X", ')'+$80	; $A1=LDA (zp,X)
	.asc	"LDX #", '@'+$80	; $A2=LDX #
	.asc	"?1", '1'+$80	; $A3=?
	.asc	"LDY ", '@'+$80	; $A4=LDY zp
	.asc	"LDA ", '@'+$80	; $A5=LDA zp
	.asc	"LDX ", '@'+$80	; $A6=LDX zp
	.asc	"SMB2 ", '@'+$80	; $A7=SMB2 zp	CMOS R
	.asc	"TA", 'Y'+$80	; $A8=TAY
	.asc	"LDA #", '@'+$80	; $A9=LDA #
	.asc	"TA", 'X'+$80	; $AA=TAX
	.asc	"?1", '1'+$80	; $AB=?
	.asc	"LDY ", '&'+$80	; $AC=LDY abs
	.asc	"LDA ", '&'+$80	; $AD=LDA abs
	.asc	"LDX ", '&'+$80	; $AE=LDX abs
	.asc	"BBS2 ", '@'+$80	; $AF=BBS2 rel	CMOS R
	.asc	"BCS ", '@'+$80	; $B0=BCS rel
	.asc	"LDA (@), ", 'Y'+$80	; $B1=LDA (zp),Y
	.asc	"LDA (@", ')'+$80	; $B2=LDA (zp)	CMOS
	.asc	"?1", '1'+$80	; $B3=?
	.asc	"LDY @, ", 'X'+$80	; $B4=LDY zp,X
	.asc	"LDA @, ", 'X'+$80	; $B5=LDA zp,X
	.asc	"LDX @,", 'Y'+$80	; $B6=LDX zp,Y
	.asc	"SMB3 ", '@'+$80	; $B7=SMB3 zp	CMOS R
	.asc	"CL", 'V'+$80	; $B8=CLV
	.asc	"LDA &, ", 'Y'+$80	; $B9=LDA abs, Y
	.asc	"TS", 'X'+$80	; $BA=TSX
	.asc	"?1", '1'+$80	; $BB=?
	.asc	"LDY &, ", 'X'+$80	; $BC=LDY abs,X
	.asc	"LDA &, ", 'X'+$80	; $BD=LDA abs,X
	.asc	"LDX &, ", 'Y'+$80	; $BE=LDX abs,Y
	.asc	"BBS3 ", '@'+$80	; $BF=BBS3 rel	CMOS R
	.asc	"CPY #", '@'+$80	; $C0=CPY #
	.asc	"CMP (@, X", ')'+$80	; $C1=CMP (zp,X)
	.asc	"?22 ", '@'+$80	; $C2=?
	.asc	"?1", '1'+$80	; $C3=?
	.asc	"CPY ", '@'+$80	; $C4=CPY zp
	.asc	"CMP ", '@'+$80	; $C5=CMP zp
	.asc	"DEC ", '@'+$80	; $C6=DEC zp
	.asc	"SMB4 ", '@'+$80	; $C7=SMB4 zp	CMOS R
	.asc	"IN", 'Y'+$80	; $C8=INY
	.asc	"CMP #", '@'+$80	; $C9=CMP #
	.asc	"DE", 'X'+$80	; $CA=DEX
	.asc	"WA", 'I'+$80	; $CB=WAI	CMOS WDC
	.asc	"CPY ", '&'+$80	; $CC=CPY abs
	.asc	"CMP ", '&'+$80	; $CD=CMP abs
	.asc	"DEC ", '&'+$80	; $CE=DEC abs
	.asc	"BBS4 ", '@'+$80	; $CF=BBS4 rel	CMOS R
	.asc	"BNE ", '@'+$80	; $D0=BNE rel
	.asc	"CMP (@), ", 'Y'+$80	; $D1=CMP (zp),Y
	.asc	"CMP (@", ')'+$80	; $D2=CMP (zp)	CMOS
	.asc	"?1", '1'+$80	; $D3=?
	.asc	"?24 ", '@'+$80	; $D4=?
	.asc	"CMP @, ", 'X'+$80	; $D5=CMP zp,X
	.asc	"DEC @, ", 'X'+$80	; $D6=DEC zp,X
	.asc	"SMB5 ", '@'+$80	; $D7=SMB5 zp	CMOS R
	.asc	"CL", 'D'+$80	; $D8=CLD
	.asc	"CMP &, ", 'Y'+$80	; $D9=CMP abs, Y
	.asc	"PH", 'X'+$80	; $DA=PHX		CMOS
	.asc	"ST", 'P'+$80	; $DB=STP	CMOS WDC
	.asc	"?34 ", '&'+$80	; $DC=?
	.asc	"CMP &, ", 'X'+$80	; $DD=CMP abs,X
	.asc	"DEC &, ", 'X'+$80	; $DE=DEC abs,X
	.asc	"BBS5 ", '@'+$80	; $DF=BBS5 rel	CMOS R
	.asc	"CPX #", '@'+$80	; $E0=CPX #
	.asc	"SBC (@, X", ')'+$80	; $E1=SBC (zp,X)
	.asc	"?22 ", '@'+$80	; $E2=?
	.asc	"?1", '1'+$80	; $E3=?
	.asc	"CPX ", '@'+$80	; $E4=CPX zp
	.asc	"SBC ", '@'+$80	; $E5=SBC zp
	.asc	"INC ", '@'+$80	; $E6=INC zp
	.asc	"SMB6 ", '@'+$80	; $E7=SMB6 zp	CMOS R
	.asc	"IN", 'X'+$80	; $E8=INX
	.asc	"SBC #", '@'+$80	; $E9=SBC #
	.asc	"NO", 'P'+$80	; $EA=NOP
	.asc	"?1", '1'+$80	; $EB=?
	.asc	"CPX ", '&'+$80	; $EC=CPX abs
	.asc	"SBC ", '&'+$80	; $ED=SBC abs
	.asc	"INC ", '&'+$80	; $EE=INC abs
	.asc	"BBS6 ", '@'+$80	; $EF=BBS6 rel	CMOS R
	.asc	"BEQ ", '@'+$80	; $F0=BEQ rel
	.asc	"SBC (@), ", 'Y'+$80	; $F1=SBC (zp),Y
	.asc	"SBC (@", ')'+$80	; $F2=SBC (zp)	CMOS
	.asc	"?1", '1'+$80	; $F3=?
	.asc	"?24 ", '@'+$80	; $F4=?
	.asc	"SBC @, ", 'X'+$80	; $F5=SBC zp,X
	.asc	"INC @, ", 'X'+$80	; $F6=INC zp,X
	.asc	"SMB7 ", '@'+$80	; $F7=SMB7 zp	CMOS R
	.asc	"SE", 'D'+$80	; $F8=SED
	.asc	"SBC &, ", 'Y'+$80	; $F9=SBC abs,Y
	.asc	"PL", 'X'+$80	; $FA=PLX		CMOS
	.asc	"?1", '1'+$80	; $FB=?
	.asc	"?34 ", '&'+$80	; $FC=?
	.asc	"SBC &, ", 'X'+$80	; $FD=SBC abs,X
	.asc	"INC &, ", 'X'+$80	; $FE=INC abs,X
	.asc	"BBS7 ", '@'+$80	; $FF=BBS7 rel	CMOS R


