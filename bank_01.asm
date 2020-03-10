.segment "BANK_01"
.include "ram.inc"
.include "val.inc"

.import _jmp_FrameDelay_b03
.import _jmp_ReadBytesAfterJSR_b03
.import _jmp_EOR_16bit_plus2_b03
.import _jmp_EOR_16bit_b03
.import _loc_03_C048
.import _jmp_HideAllSprites_b03
.import _jmp_SelectInitialPlayerDataAddress_b03
.import _jmp_SelectPlayerSubroutine_b03
.import _jmp_ReadBytes_0380_AfterJSR_b03
.import _loc_03_C07B
.import _jmp_WriteSoundID_b03

.export _loc_01_8000
_loc_01_8000:
	JMP _loc_01_804E
	JMP _loc_01_8087
.export _loc_01_8006_minus1
_loc_01_8006:
_loc_01_8006_minus1 = _loc_01_8006 - 1
	JMP _loc_01_80A3
.export _loc_01_8009
_loc_01_8009:
	JMP _loc_01_81D9
.export _loc_01_800C
_loc_01_800C:
	JMP _loc_01_827E
.export _loc_01_800F
_loc_01_800F:
	JMP _loc_01_87ED
.export _loc_01_8012
_loc_01_8012:
	JMP _loc_01_88E0
.export _loc_01_8015_minus1
_loc_01_8015:
_loc_01_8015_minus1 = _loc_01_8015 - 1
	JMP _loc_01_8596
.export _loc_01_8018
_loc_01_8018:
	JMP _loc_01_863C
.export _loc_01_801B
_loc_01_801B:
	JMP _loc_01_8696
.export _loc_01_801E
_loc_01_801E:
	JMP _loc_01_878F
.export _jmp_TeamsPalette_and_BallPalette
_jmp_TeamsPalette_and_BallPalette:
	JMP _TeamsPalette_and_BallPalette
.export _loc_01_8024
_loc_01_8024:
	JMP _loc_01_847D
.export _loc_01_8027
_loc_01_8027:
	JMP _loc_01_83AA
.export _loc_01_802A
_loc_01_802A:
	JMP _loc_01_8361
.export _loc_01_802D
_loc_01_802D:
	JMP _loc_01_8A71
.export _loc_01_8030
_loc_01_8030:
	JMP _loc_01_89F3
.export _loc_01_8033_minus1
_loc_01_8033:
_loc_01_8033_minus1 = _loc_01_8033 - 1
	JMP _loc_01_8341
.export _loc_01_8036
_loc_01_8036:
	JMP _loc_01_8BE8
.export _loc_01_8039
_loc_01_8039:
	JMP _loc_01_8D1A
.export _jmp_SetBotTimerThrowIn_b01
_jmp_SetBotTimerThrowIn_b01:
	JMP SetBotTimerThrowIn
.export _loc_01_803F
_loc_01_803F:
	JMP _loc_01_8B6B
.export _loc_01_8042
_loc_01_8042:
	JMP _loc_01_8B24
.export _loc_01_8045
_loc_01_8045:
	JMP _loc_01_886C
.export _loc_01_8048
_loc_01_8048:
	JMP _loc_01_88B2
.export _loc_01_804B
_loc_01_804B:
	JMP _loc_01_8B3F

_loc_01_804E:
	LDA #$00
	STA $2A
	LDA plr_w_ball
	BPL bra_01_8059
	LDA #$16
bra_01_8059:
	JSR _jmp_SelectInitialPlayerDataAddress_b03
	SEC
	LDY #$05
	LDA (plr_data),Y
	SBC #$80
	TAX
	INY
	INY
	LDA (plr_data),Y
	SBC #$00
	BMI bra_01_8072
	CMP #$01
	BCC bra_01_8074
	INC $2A
bra_01_8072:
	LDX #$00
bra_01_8074:
	STX cam_edge_x_lo
	STX $3A
	LDA $2A
	STA cam_edge_x_hi
	LDA byte_for_2000
	AND #$FE
	ORA $2A
	STA byte_for_2000
	RTS

_loc_01_8087:
	LDA #$00
bra_01_8089:
	PHA
	SEC
	TXA
	SBC #$F0
	PHA
	TYA
	SBC #$00
	PHA
	BCC bra_01_809E
	PLA
	TAY
	PLA
	TAX
	PLA
	ADC #$00
	BNE bra_01_8089
bra_01_809E:
	PLA
	PLA
	PLA
	TAY
	RTS

_loc_01_80A3:
	LDA #$01
	JSR _jmp_FrameDelay_b03
	LDA #$00
	STA $2C
	SEC
	LDA cam_edge_y_lo
	SBC $03C0
	TAX
	LDA cam_edge_y_hi
	SBC $03C1
	TAY
	BPL bra_01_80C2
	DEC $2C
	JSR _jmp_EOR_16bit_b03
bra_01_80C2:
	TYA
	BNE bra_01_80CC
	CPX #$10
	BCS bra_01_80CC
	JMP _loc_01_80A3
bra_01_80CC:
	LDX #$10
	LDY #$00
	BIT $2C
	BPL bra_01_80D7
	JSR _jmp_EOR_16bit_b03
bra_01_80D7:
	TXA
	CLC
	ADC $03C0
	AND #$F0
	STA $03C0
	TAX
	TYA
	ADC $03C1
	STA $03C1
	TAY
	JSR _loc_01_8087
	STX $2A
	STY $2B
	BIT $2C
	BMI bra_01_8107
	LDA $2A
	CLC
	ADC #$E0
	BCS bra_01_8100
	CMP #$F0
	BNE bra_01_8105
bra_01_8100:
	INC $2B
	CLC
	ADC #$10
bra_01_8105:
	STA $2A
bra_01_8107:
	LDA $2A
	STA $03C3
	LDA $2B
	STA $03C4
	LSR $2B
	ROR $2A
	LDA $2A
	CLC
	ADC #<table_01_8D3E
	STA $59
	LDA $2B
	ADC #>table_01_8D3E
	STA $5A
	LDA #$08
	STA $03C6
	LDA $03C3
	ASL
	ROL $03C6
	ASL
	ROL $03C6
	STA $03C5
bra_01_8135:
	LDA #$01
	JSR _jmp_FrameDelay_b03
	LDA $037D
	BNE bra_01_8135
	LDA #$01
	STA $037D
	LDA $03C4
	STA $2A
	LDA $03C3
	LSR $2A
	ROR
	LSR $2A
	ROR
	LSR $2A
	ROR
	LSR $2A
	ROR
	LSR $2A
	ROR
	TAX
	LDA table_01_8F66,X
	PHA
	LDA #$08
	STA nmt_buf_cnt
	STA nmt_buf_cnt + 11
	LDA $03C3
	AND #$E0
	LSR
	LSR
	ORA #$C0
	STA nmt_buf_ppu_lo
	STA nmt_buf_ppu_lo + 11
	LDA #$23
	STA nmt_buf_ppu_hi
	LDA #$27
	STA nmt_buf_ppu_hi + 11
	LDX #$00
	PLA
bra_01_8184:
	STA nmt_buffer + 3,X
	STA nmt_buffer + 14,X
	INX
	CPX #$08
	BNE bra_01_8184
	LDA #$00
	STA nmt_buf_cnt + 22
	LDA #$80
	STA $037D
	LDA #$00
	STA field_buf_cnt
_loc_01_819E:
bra_01_819E:
	LDA #$01
	JSR _jmp_FrameDelay_b03
	LDA $037D
	BNE bra_01_819E
	LDA #$01
	STA $037D
	LDA #$00
	STA $2C
	LDY field_buf_cnt
	JSR _loc_01_82B4
	BEQ bra_01_81D1
	LDY field_buf_cnt
	JSR _loc_01_82B4
	BEQ bra_01_81D1
	LDY field_buf_cnt
	JSR _loc_01_82B4
	BEQ bra_01_81D1
	LDA #$80
	STA $037D
	JMP _loc_01_819E
bra_01_81D1:
	LDA #$80
	STA $037D
	JMP _loc_01_80A3

_loc_01_81D9:
	LDA plr_w_ball
	BPL bra_01_81E0
	LDA #$16
bra_01_81E0:
	JSR _jmp_SelectInitialPlayerDataAddress_b03
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	SEC
	SBC #$78
	TAX
	INY
	INY
	LDA (plr_data),Y
	SBC #$00
	TAY
	TXA
	SEC
	SBC #$40
	TYA
	SBC #$00
	BPL bra_01_8201
	LDX #$40
	LDY #$00
	BEQ bra_01_820E
bra_01_8201:
	TXA
	SEC
	SBC #$D0
	TYA
	SBC #$02
	BMI bra_01_820E
	LDX #$D0
	LDY #$02
bra_01_820E:
	STX $03BE
	STY $03BF
	LDA #$00
	STA $2A
	LDA $03BE
	SEC
	SBC cam_edge_y_lo
	TAX
	LDA $03BF
	SBC cam_edge_y_hi
	TAY
	PHP
	BPL bra_01_822D
	JSR _jmp_EOR_16bit_b03
bra_01_822D:
	LDA #$00
	STA $03C2
	TYA
	BNE bra_01_823E
	TXA
	BNE bra_01_823A
	PLP
	RTS

bra_01_823A:
	CPX #$04
	BCC bra_01_8246
bra_01_823E:
	LDA #$20
	STA $2A
	LDX #$03
	LDY #$00
bra_01_8246:
	LDA #$80
	STA $03C2
	PLP
	BPL bra_01_8264
	LDA $2A
	EOR #$FF
	STA $2A
	TXA
	EOR #$FF
	TAX
	TYA
	EOR #$FF
	TAY
	INC $2A
	BNE bra_01_8264
	INX
	BNE bra_01_8264
	INY
bra_01_8264:
	LDA $2A
	CLC
	ADC $03BB
	STA $03BB
	TXA
	ADC cam_edge_y_lo
	STA cam_edge_y_lo
	TYA
	ADC cam_edge_y_hi
	STA cam_edge_y_hi
	STY $03B9
_loc_01_827E:
	LDX cam_edge_y_lo
	LDY cam_edge_y_hi
	JSR _loc_01_8087
	STX $3B
	LDX #$00
bra_01_828B:
	SEC
	LDA cam_edge_y_lo
	SBC table_01_82AB,X
	LDA cam_edge_y_hi
	SBC table_01_82AB + 1,X
	BCC bra_01_829E
	INX
	INX
	BNE bra_01_828B
bra_01_829E:
	TXA
	LSR
	TAX
	LDA table_01_82B1,X
	STA chr_bank
	LDA #$02
	STA chr_bank + 1
	RTS

table_01_82AB:
.byte $E0,$00
.byte $40,$02
.byte $00,$30

table_01_82B1:
.byte $20,$00,$22

_loc_01_82B4:
	LDA #$00
	STA $2B
	LDA ($59),Y
	ASL
	ROL $2B
	ASL
	ROL $2B
	ASL
	ROL $2B
	ASL
	ROL $2B
	ADC #<table_01_9026
	STA $2A
	LDA $2B
	ADC #>table_01_9026
	STA $2B
	LDX $2C
	LDA #$08
	STA nmt_buf_cnt,X
	STA nmt_buf_cnt + 11,X
	LDA field_buf_cnt
	ASL
	TAY
	LDA table_01_8331,Y
	CLC
	ADC $03C5
	STA nmt_buf_ppu_lo,X
	LDA table_01_8331 + 1,Y
	ADC $03C6
	STA nmt_buf_ppu_hi,X
	PHA
	LDA nmt_buf_ppu_lo,X
	CLC
	ADC #$20
	STA nmt_buf_ppu_lo + 11,X
	PLA
	ADC #$00
	STA nmt_buf_ppu_hi + 11,X
	LDY #$00
	JSR _loc_01_831A
	JSR _loc_01_831A
	LDA #$00
	STA nmt_buf_cnt,X
	STX $2C
	INC field_buf_cnt
	LDA field_buf_cnt
	CMP #$08
	RTS

_loc_01_831A:
.scope
index = $2C
counter = $2D
	LDX index
	LDA #$08
	STA counter
bra_01_8320:
	LDA ($2A),Y
	STA nmt_buffer + 3,X
	INY
	INX
	DEC counter
	BNE bra_01_8320
	INX
	INX			; освободить место в буффере для счетчика и байтов 2006
	INX
	STX index
	RTS
.endscope

table_01_8331:
.byte $00,$00
.byte $08,$00
.byte $10,$00
.byte $18,$00
.byte $00,$04
.byte $08,$04
.byte $10,$04
.byte $18,$04

_loc_01_8341:
	LDA #$21
_loc_01_8343:
	PHA
	JSR _jmp_ReadBytes_0380_AfterJSR_b03

.word pal_buffer
 
	LDA #$04
	JSR _jmp_FrameDelay_b03
	PLA
	STA pal_buffer + $09
	STA pal_buffer + $0D
	CLC
	ADC #$01
	CMP #$2D
	BNE bra_01_835E
	LDA #$21
bra_01_835E:
	JMP _loc_01_8343
_loc_01_8361:
	JSR _jmp_HideAllSprites_b03
	LDA #$00
	STA $5B
	LDX #$00
	JSR _loc_01_8373
	LDX #$01
	JSR _loc_01_8373
	RTS

_loc_01_8373:
	STX $39
	LDA goals_total,X
	LDY #$00
@decimal_loop:
	CMP #$0A
	BCC @quit_loop
	SBC #$0A
	INY
	BNE @decimal_loop
@quit_loop:
	PHA
	TYA
	PHA
	ASL $39
	LDX $39
	LDA table_01_83A6,X
	LDY table_01_83A6 + 1,X
	TAX
	PLA
	JSR _loc_01_83F5
	LDX $39
	LDY table_01_83A6 + 1,X
	LDA table_01_83A6,X
	CLC
	ADC #$28
	TAX
	PLA
	JSR _loc_01_83F5
	RTS

table_01_83A6:
.byte $20,$50
.byte $A0,$90

_loc_01_83AA:
	LDA #$00
bra_01_83AC:
	PHA
	JSR _jmp_HideAllSprites_b03
	LDA #$00
	STA $5B
	PLA
	PHA
	CLC
	JSR _loc_01_83D1
	PLA
	CLC
	ADC #$01
	PHA
	SEC
	JSR _loc_01_83D1
	LDA #$01
	JSR _jmp_FrameDelay_b03
	PLA
	CMP #$38
	BNE bra_01_83AC
	JSR _jmp_HideAllSprites_b03
	RTS

_loc_01_83D1:
	AND #$03
	STA $2A
	ASL
	ADC $2A
	TAX
	LDA table_01_83E9,X
	PHA
	LDY table_01_83E9 + 2,X
	LDA table_01_83E9 + 1,X
	TAX
	PLA
	JSR _loc_01_83F5
	RTS

table_01_83E9:
.byte $0A,$34,$40
.byte $00,$5C,$40
.byte $0B,$84,$40
.byte $0C,$AC,$40

_loc_01_83F5:
	STX $2A
	STY $2B
	AND #$7F
	STA $2D
	ASL
	ADC $2D
	TAX
	JSR _loc_01_840F
	INX
	JSR _loc_01_840F
	INX
	LDA table_01_8456,X
	JMP _loc_01_841B
_loc_01_840F:
	LDA table_01_8456,X
	PHA
	JSR _loc_01_841B
	PLA
	ASL
	ASL
	ASL
	ASL
_loc_01_841B:
	STA $2D
	LDA #$04
	STA $2E
bra_01_8421:
	ROL $2D
	BCC bra_01_844A
	LDY $5B
	LDA #$3C
	STA oam_t,Y
	LDA #$01
	STA oam_a,Y
	LDA #$04
	SEC
	SBC $2E
	ASL
	ASL
	ASL
	CLC
	ADC $2A
	STA oam_x,Y
	LDA $2B
	STA oam_y,Y
	INY
	INY
	INY
	INY
	STY $5B
bra_01_844A:
	DEC $2E
	BNE bra_01_8421
	LDA $2B
	CLC
	ADC #$08
	STA $2B
	RTS

table_01_8456:		; байты для спрайтов GOAL и счета после гола
.byte $F9,$99,$F0
.byte $62,$22,$20
.byte $F1,$F8,$F0
.byte $F1,$71,$F0
.byte $8A,$AF,$20
.byte $F8,$F1,$F0
.byte $F8,$F9,$F0
.byte $F9,$11,$10
.byte $F9,$F9,$F0
.byte $F9,$F1,$F0
.byte $F8,$B9,$F0
.byte $F9,$F9,$90
.byte $88,$88,$F0

_loc_01_847D:
	LDA game_mode_flags
	AND #FLAG_GM_UNKNOWN_10
	BNE bra_01_84EC
	LDA #$8C
	STA $2A
	LDA timer_sec
	JSR _loc_01_84ED
	LDA #$17
	JSR _loc_01_8504
	LDA timer_min
	JSR _loc_01_84ED
	LDA game_mode_flags
	AND #F_OUT_OF_PLAY
	BNE bra_01_84EC
	DEC timer_ms
	BPL bra_01_84EC
	LDX #$00
	LDA timer_sec
bra_01_84AA:
	CMP #$0A
	BCC bra_01_84B3
	SBC #$0A
	INX
	BNE bra_01_84AA
bra_01_84B3:
	STX $2A
	LDA #$1E
	STA timer_ms
	SEC
	LDA timer_sec
	SBC #$05
	BCS bra_01_84D3
	DEC timer_min
	BPL bra_01_84D0
	LDA #$00
	STA timer_min
	STA timer_sec
	RTS

bra_01_84D0:
	CLC
	ADC #$3C
bra_01_84D3:
	STA timer_sec
	LDX timer_min
	BNE bra_01_84EC
_loc_01_84DB:
	CMP #$0A
	BCC bra_01_84E4
	SBC #$0A
	JMP _loc_01_84DB
bra_01_84E4:
	TAX
	BNE bra_01_84EC
	LDA #SOUND_TIME_LOW
	JSR _jmp_WriteSoundID_b03
bra_01_84EC:
	RTS

_loc_01_84ED:		; отображение таймера времени на экране
	LDY #$00
bra_01_84EF:
	CMP #$0A
	BCC bra_01_84F8
	SBC #$0A
	INY
	BNE bra_01_84EF
bra_01_84F8:
	JSR _loc_01_8500
	TYA
	JSR _loc_01_8500
	RTS

_loc_01_8500:
	ASL
	CLC
	ADC #$03
_loc_01_8504:
	LDX $5B
	STA oam_t,X
	LDA #$01
	STA oam_a,X
	LDA #$18
	STA oam_y,X
	LDA $2A
	STA oam_x,X
	SEC
	SBC #$08
	STA $2A
	JSR _loc_03_C07B
	RTS

_TeamsPalette_and_BallPalette:		; 8521
	LDX #$00
	LDA team_id
	JSR _SelectTeamPalette
	LDX #$08
	LDA team_id + 1
	JSR _SelectTeamPalette
	LDA #$0F		; палитра мяча
	STA pal_buffer + $19
	LDA #$30
	STA pal_buffer + $1A
	RTS

_SelectTeamPalette:		; 853C
	ASL
	ASL
	TAY
	LDA TeamPlette_table + 3,Y
	STA pal_buffer + $18,X
	LDA #$02
	STA $2B
@loop:
	LDA TeamPlette_table,Y
	STA pal_buffer + $14,X
	INX
	INY
	DEC $2B
	BPL @loop
	RTS

TeamPlette_table:		; 8556
.byte $37,$11,$16,$0F
.byte $0A,$30,$35,$37
.byte $11,$30,$35,$37
.byte $26,$30,$35,$17
.byte $31,$0F,$36,$0F
.byte $16,$30,$35,$37
.byte $2C,$30,$35,$17
.byte $14,$30,$35,$26
.byte $30,$31,$35,$37
.byte $25,$11,$35,$37
.byte $28,$30,$26,$37
.byte $01,$21,$35,$16
.byte $21,$30,$35,$17
.byte $34,$30,$35,$17
.byte $25,$16,$36,$0F
.byte $30,$16,$36,$0F

_loc_01_8596:
	BIT $03D2
	BMI bra_01_85A3
	LDA #$01
	JSR _jmp_FrameDelay_b03
	JMP _loc_01_8596
bra_01_85A3:
	LDA #$01
	JSR _jmp_FrameDelay_b03
	LDA $037D
	BNE bra_01_85A3
	LDA #$01
	STA $037D
	LDX $03CE
	LDA $03CE,X
	ASL
	TAX
	LDA table_01_A446,X
	STA $2A
	LDA table_01_A446 + 1,X
	STA $2B
	JSR _loc_01_860C
	LDA #$08
	JSR _jmp_FrameDelay_b03
	JSR _loc_01_85E3
	LDA #$01
	JSR _jmp_FrameDelay_b03
	LDA #$00
	DEC $03CE
	BEQ bra_01_85DD
	LDA #$80
bra_01_85DD:
	STA $03D2
	JMP _loc_01_8596
_loc_01_85E3:
bra_01_85E3:
	LDA #$01
	JSR _jmp_FrameDelay_b03
	LDA $037D
	BNE bra_01_85E3
; перерисовка ворот при касании сетки мячом после гола
	LDA #$01
	STA $037D
	LDX $03CE
	LDA $03CE,X
	LDX #<table_01_A58F
	LDY #>table_01_A58F
	CMP #$09
	BCC bra_01_8604
	LDX #<table_01_A54C
	LDY #>table_01_A54C
bra_01_8604:
	STX $2A
	STY $2B
	JSR _loc_01_860C
	RTS

_loc_01_860C:
	LDY #$00
	LDX #$00
bra_01_8610:
	LDA ($2A),Y
	STA nmt_buf_cnt,X
	BEQ bra_01_8636
	STA $2C
	INY
	LDA ($2A),Y
	STA nmt_buf_ppu_lo,X
	INY
	LDA ($2A),Y
	STA nmt_buf_ppu_hi,X
	INY
bra_01_8626:
	LDA ($2A),Y
	STA $0310,X
	INY
	INX
	DEC $2C
	BNE bra_01_8626
	INX
	INX
	INX
	BNE bra_01_8610
bra_01_8636:
	LDA #$80
	STA $037D
	RTS

_loc_01_863C:
	LDA game_mode_flags
	AND #FLAG_GM_UNKNOWN_10
	BNE bra_01_865C
	LDX $03C9
	INX
	CPX #$0C
	BCC bra_01_864D
	LDX #$00
bra_01_864D:
	STX $03C9
	LDA plr_w_ball
	JSR _loc_01_865D
	LDA plr_wo_ball
	JSR _loc_01_865D
bra_01_865C:
	RTS

_loc_01_865D:
	BMI bra_01_8695
	BIT game_mode_flags
	BMI bra_01_8668
	CMP #$0B
	BCS bra_01_8695
bra_01_8668:
	JSR _jmp_SelectInitialPlayerDataAddress_b03
	LDY #plr_spr_a
	LDA (plr_data),Y
	PHA
	AND #$03
	ORA #$80
	STA (plr_data),Y
	LDY #plr_anim_id
	LDA (plr_data),Y
	PHA
	LDA #$2F
	LDX $03C9
	CPX #$06
	BCC bra_01_8686
	LDA #$30
bra_01_8686:
	STA (plr_data),Y
	JSR _loc_01_8696
	PLA
	LDY #plr_anim_id
	STA (plr_data),Y
	PLA
	LDY #plr_spr_a
	STA (plr_data),Y
bra_01_8695:
	RTS

_loc_01_8696:		; сравнение координат игроков с позицией камеры
					; управление может переключиться на другого игрока, если текущий ушел за экран
					; plr_data здесь может быть и ball_data, так как обрабатываются еще и адреса мяча
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_VISIBLE_CLEAR
	STA (plr_data),Y
	BIT ram_unk_5D
	BMI @rts
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	SEC
	SBC cam_edge_y_lo
	STA $36
	INY
	INY
	LDA (plr_data),Y
	SBC cam_edge_y_hi
	BNE @rts
	SEC
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	SBC cam_edge_x_lo
	STA $34
	INY
	INY
	LDA (plr_data),Y	; plr_pos_x_hi
	SBC cam_edge_x_hi
	BEQ @continue
@rts:
	RTS

@continue:
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_VISIBLE
	STA (plr_data),Y
	LDA #$00
	STA $2F
	LDA #$01
	STA $38
	LDY #plr_spr_a
	LDA (plr_data),Y
	AND #$E2
	STA $39
	LDY #plr_anim_id
	LDA (plr_data),Y
	ASL
	ROL $2F
	ADC #<table_01_97C6
	STA $2E
	LDA $2F
	ADC #>table_01_97C6
	STA $2F
	LDY #$00
	STY $2C
	LDA ($2E),Y
	STA $2A
	INY
	LDA ($2E),Y
	STA $2B
@repeat:
	JSR _loc_01_8705
	JMP @repeat
_loc_01_8705:
	LDY $2C
	LDA ($2A),Y
	AND #$07
	BEQ bra_01_871E
	CMP #$01
	BNE bra_01_8714
	JMP _loc_01_8773
bra_01_8714:
	CMP #$02
	BNE bra_01_871B
	JMP _loc_01_8776
bra_01_871B:
	JMP _loc_01_877D
bra_01_871E:
	LDA ($2A),Y
	LSR
	LSR
	LSR
	STA $2D
	INY
	LDA ($2A),Y
	INY
	STY $2C
	BIT $39
	BPL bra_01_8734
	EOR #$FF
	SEC
	SBC #$10
bra_01_8734:
	CLC
	ADC $36
	STA $2E
bra_01_8739:
	LDY $2C
	INC $2C
	LDA ($2A),Y
	BIT $39
	BVC bra_01_8748
	EOR #$FF
	CLC
	ADC #$F8
bra_01_8748:
	LDX $5B
	CLC
	ADC $34
	STA oam_x,X
	LDA $2E
	STA oam_y,X
	LDY $2C
	LDA ($2A),Y
	PHA
	AND #$01
	ORA $39
	STA oam_a,X
	PLA
	AND #$FE
	ORA $38
	STA oam_t,X
	JSR _loc_03_C07B
	INC $2C
	DEC $2D
	BNE bra_01_8739
	RTS

_loc_01_8773:
	PLA
	PLA
	RTS

_loc_01_8776:
	LDA #$00
	STA $38
	INC $2C
	RTS

_loc_01_877D:
	LDY $2C
	INY
	LDA ($2A),Y
	INY
	STY $2C
	TAY
	AND #$03
	TAX
	TYA
	LSR
	LSR
	STA chr_bank + 2,X
	RTS

_loc_01_878F:
; на вход подается A
	; 11 - во время удара кипера от ворот
	ASL
	TAX
	LDA table_01_9666,X
	STA $2A
	LDA table_01_9666 + 1,X
	STA $2B
	LDY #plr_anim_cnt_lo
	LDA (plr_data),Y
	ASL
	ASL
	TAY
	STA $2C
	LDA ($2A),Y
	PHA
	LDY #plr_dir
	LDA (plr_data),Y
	CLC
	ADC #$10		; сделать направление кратным $20, скорее всего для ботов, раз они поворачиваются куда хотят
	AND #$E0		; оставить байты кратные $20
	LSR
	LSR
	LSR				; деление на $20 для получения 8 возможных результатов
	LSR
	TAX
	LDA table_01_87DD,X
	CLC
	ADC $2C
	TAY
	LDA ($2A),Y
	LDY #plr_anim_id
	STA (plr_data),Y
	PLA
	LDY table_01_87DD,X
bra_01_87C6:
	ASL
	ASL
	DEY
	BNE bra_01_87C6
	AND #$C0
	STA $2C
	LDY #plr_spr_a
	LDA (plr_data),Y
	AND #$3F
	ORA table_01_87DD + 1,X
	EOR $2C
	STA (plr_data),Y
	RTS

table_01_87DD:	; читается из 3х мест
; первый байт строки относится индексу стороны поворота игрока, а также является неким счетчиком умножения на 4
.byte $01,$80
.byte $02,$C0
.byte $03,$40
.byte $02,$40
.byte $01,$00
.byte $02,$00
.byte $03,$00
.byte $02,$80

_loc_01_87ED:
.scope
player_counter = $2A
	BIT $042C
	BVS bra_01_8808
	LDA $042C
	BMI bra_01_87F8
	RTS
bra_01_87F8:
	AND #$7F
	STA $042C
	LDA #$00
	JSR _loc_01_8849
	LDA #$0B
	JSR _loc_01_8849
	RTS
bra_01_8808:
	LDA #$00
	STA player_counter
@loop:
	LDA player_counter	; исключить киперов из цикла
	BEQ @skip_loop
	CMP #$0B
	BEQ @skip_loop
	JSR _jmp_SelectInitialPlayerDataAddress_b03
	LDY #plr_state
	LDA (plr_data),Y
	CMP #STATE_RUN_BASE
	BEQ @skip_loop
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDY #plr_tbl_lo
	LDA player_counter
	ASL
	CLC
	ADC #<table_01_A5D6
	STA (plr_data),Y
	INY
	LDA #$00
	ADC #>table_01_A5D6
	STA (plr_data),Y	; plr_tbl_hi
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_BUSY
	STA (plr_data),Y
@skip_loop:
	INC player_counter
	LDA player_counter
	CMP #$16
	BNE @loop
	RTS
.endscope

_loc_01_8849:
; на вход подается 00 или 0B в зависимости от команды
	STA $2A
	JSR _loc_01_886C
	INC $2A		; исключает вратарей из вычисления, иначе те убегут с ворот
	LDA #$0A
	STA $2B
bra_01_8854:
	LDA $2A
	JSR _loc_01_88B2
	LDA $2B
	ASL
	ASL
	ASL
	ASL
	ADC random
	STA random
	INC $2A
	DEC $2B
	BNE bra_01_8854
	RTS

_loc_01_886C:
.scope
temp = $2E
	PHA
	CMP #$0B
	LDA #$00
	PHP
	BCC bra_01_8876
	LDA #$0B
bra_01_8876:
	EOR team_w_ball
	BEQ bra_01_887D
	LDA #$02
bra_01_887D:
	TAX
	LDA #$00
	STA temp + 1
	LDA area_id
	PLP
	BCC @skip
	EOR #$FF
	CLC
	ADC #$28
@skip:
; умножение числа на #$28
	ASL
	ASL
	ASL
	STA temp
	ROL temp + 1
	LDY temp + 1
	ASL
	ROL temp + 1
	ASL
	ROL temp + 1
	ADC temp
	PHA
	TYA
	ADC temp + 1
	TAY
	PLA
	CLC
	ADC table_01_A5D2,X
	STA $2C
	TYA
	ADC table_01_A5D2 + 1,X
	STA $2D
	PLA
	RTS
.endscope

_loc_01_88B2:
	PHA
	JSR _jmp_SelectInitialPlayerDataAddress_b03
	PLA
	CMP #$0B
	BCC bra_01_88BD
	SBC #$0B
bra_01_88BD:
	SEC
	SBC #$01
	ASL
	ASL
	BIT random
	BPL bra_01_88C9
	ADC #$02
bra_01_88C9:
	LDY #plr_tbl_lo
	CLC
	ADC $2C
	STA (plr_data),Y
	INY
	LDA $2D
	ADC #$00
	STA (plr_data),Y	; plr_tbl_hi
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_BUSY
	STA (plr_data),Y
	RTS

_loc_01_88E0:
	BIT $042C
	BVS @do_not_defense
	LDX #$00
	LDA plr_frame_id
	CMP #$0B
	BCC @is_first_team
	SBC #$0B
	LDX #$0B
@is_first_team:
	TAY
	TXA
	EOR team_w_ball
	PHP
	TXA
	BEQ @skip
	LDX #$01
@skip:
	PLP
	BEQ @check_defense_chance
	LDA a: team_atk,X
	CMP random
	BCC @do_not_attack
	JMP _BeginFollowEnemy
@do_not_attack:
	JMP @do_not_defense
@check_defense_chance:
	CPY #$05
	BCS @do_not_defense
	LDA a: team_def,X
	CMP random
	BCC @do_not_defense
	JMP _BeginDefenseGates
@do_not_defense:
	LDY #plr_tbl_lo
	LDA (plr_data),Y
	STA $2A
	INY
	LDA (plr_data),Y	; plr_tbl_hi
	STA $2B
	LDY #$00
	LDA ($2A),Y
	LSR		; обрезание первых 4х битов и заодно получение поинтера для чтения таблицы
	LSR
	LSR
	LSR
	JSR _jmp_ReadBytesAfterJSR_b03

table_01_8933:		; байты привязаны к JSR, используются для непрямого прыжка в CAD1
.word table_01_8933_8941
.word table_01_8933_8941
.word table_01_8933_8947
.word table_01_8933_8968
.word _BeginFollowEnemy
.word _BeginDefenseGates
.word table_01_8933_89EA

table_01_8933_8941:
	LDA #STATE_IDLE
	JSR _jmp_SelectPlayerSubroutine_b03
	RTS

table_01_8933_8947:
_loc_01_8947:
	LDY #$01
	LDA ($2A),Y
_loc_01_894B:
	PHA
	LDA plr_frame_id
	CMP #$0B
	BCC bra_01_895A
	PLA
	EOR #$FF
	CLC
	ADC #$96
	PHA
bra_01_895A:
	PLA
	LDY #$06
	STA (plr_data),Y
	JSR _loc_03_C048
	LDA #STATE_RUN_AREA
	JSR _jmp_SelectPlayerSubroutine_b03
	RTS

table_01_8933_8968:
	LDY #$01
	LDA ($2A),Y
	AND #$1F
	JSR _loc_01_8996
	LDY #plr_act_timer2
	STA (plr_data),Y
	LDY #$00
	LDA ($2A),Y
	AND #$0F
	ASL
	ASL
	STA $2C
	INY
	LDA ($2A),Y
	ROL
	ROL
	ROL
	AND #$03
	ORA $2C
	JSR _loc_01_8996
	LDY #$06
	STA (plr_data),Y
	LDA #STATE_UNKNOWN_10
	JSR _jmp_SelectPlayerSubroutine_b03
	RTS

_loc_01_8996:
	TAX
	AND #$0F
	ASL
	ASL
	ASL
	CPX #$10
	BCC bra_01_89A4
	EOR #$FF
	ADC #$00
bra_01_89A4:
	LDX plr_frame_id
	CPX #$0B
	BCC bra_01_89AF
	EOR #$FF
	ADC #$00
bra_01_89AF:
	RTS

_BeginFollowEnemy:		; 89B0, обычный прыжок и из таблицы
	LDA #STATE_FOLLOW_ENEMY
	JSR _jmp_SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	RTS

_BeginDefenseGates:		; 89C0, обычный прыжок и из таблицы
	LDY #plr_unknown_19
	LDA (plr_data),Y
bra_01_89C4:
	CMP #$0A
	BCC bra_01_89CC
	SBC #$0A
	BCS bra_01_89C4
bra_01_89CC:
	ADC #$0A
	LDX plr_frame_id
	CPX #$0B
	BCC bra_01_89D7
	ADC #$81
bra_01_89D7:
	JSR _loc_01_894B
	LDA #STATE_UNKNOWN_14
	JSR _jmp_SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	RTS

table_01_8933_89EA:
	JSR _loc_01_8947
	LDA #STATE_RUN_BASE
	JSR _jmp_SelectPlayerSubroutine_b03
	RTS

_loc_01_89F3:
	STA $7A
	LDY #$00
	CMP #$0B
	BCC @is_first_team
	SBC #$0B
	INY
@is_first_team:
	PHA
	LDA team_id,Y
	ASL
	TAY
	LDA table_01_B357,Y
	STA $77
	LDA table_01_B357 + 1,Y
	STA $78
	PLA
	TAY
	LDA table_01_8B19,Y
	LDY #$09
	CPX #$09
	BEQ bra_01_8A2C
	CPX #$03
	BCS bra_01_8A56
	SBC #$00
	PHA
	TXA
	STA $79
	ASL
	ADC $79
	STA $79
	PLA
	ADC $79
	TAY
bra_01_8A2C:
	LDA ($77),Y
	LDX $7A
	CPX #$0B
	BCC bra_01_8A49
	PHA
	TYA
	CLC
	ADC $7B
	TAY
	PLA
	CLC
	ADC table_01_B282,Y
	BPL bra_01_8A43
	LDA #$00
bra_01_8A43:
	CMP #$10
	BCC bra_01_8A49
	LDA #$0F
bra_01_8A49:
	ASL
	TAY
	LDA table_01_B327,Y
	STA $77
	LDA table_01_B327 + 1,Y
	STA $78
	RTS

; код пока что ниразу не выполнялся
bra_01_8A56:
	CPX #$05
	BNE bra_01_8A60
	CLC
	ADC #$0B
	JMP _loc_01_8A67
bra_01_8A60:
	CPX #$06
	BNE bra_01_8A67
	CLC
	ADC #$0E
_loc_01_8A67:
bra_01_8A67:
	TAY
	LDA ($77),Y
	STA $77
	LDA #$00
	STA $78
	RTS

_loc_01_8A71:
	LDA #$00
	BIT game_mode_flags
	BMI bra_01_8A7B
; в зависимости от 03B3 считываются особы параметры команд
	LDA game_cnt
bra_01_8A7B:
; код умножает байт на 11 (0B)
	STA $2A
	ASL
	TAX
	ADC $2A
	STA $2A
	TXA
	ASL
	ASL
	ADC $2A
	STA $7B
	LDX #$00
	JSR _loc_01_8A95
	LDX #$01
	JSR _loc_01_8A95
	RTS

_loc_01_8A95:		; 8A95 параметры команд
					; непонятно зачем, если все равно почти все параметры обнулятся перед игрой
.scope
data = $2A
counter = $2C		; счетчик игроков в одной команде
	LDA team_id,X
	ASL
	TAY
	LDA table_01_B357,Y
	STA data
	LDA table_01_B357 + 1,Y
	STA data + 1
	LDY #$11
	LDA (data),Y
	STA team_atk,X
	INY
	LDA (data),Y
	STA team_def,X
	LDY #$0A
	LDA (data),Y
	LDY $7B
	CLC
	ADC table_01_B28B + 1,Y
	BPL bra_01_8ABD
	LDA #$00
bra_01_8ABD:
	CMP #$10
	BCC bra_01_8AC3
	LDA #$0F
bra_01_8AC3:
	TAY
	LDA table_01_B347,Y
	STA $80,X
	TXA
	BEQ bra_01_8ACE
	LDA #$0B
bra_01_8ACE:
	LDY #$00
	STY counter
bra_01_8AD2:
	PHA
	JSR _jmp_SelectInitialPlayerDataAddress_b03
	LDX counter
	LDA table_01_8B19,X
	CLC
	ADC #$07
	TAY
	LDA (data),Y
	LDY #plr_unknown_0E
	STA (plr_data),Y
	LDA counter
	BNE bra_01_8B0C
	LDY #$09
	LDA (data),Y
	LDY $7B
	CLC
	ADC table_01_B28B,Y
	BPL bra_01_8AF7
	LDA #$00
bra_01_8AF7:
	CMP #$10
	BCC bra_01_8AFD
	LDA #$0F
bra_01_8AFD:
	ASL
	TAX
	LDY #plr_init_spd_fr
	LDA table_01_B327,X
	STA (plr_data),Y
	INY
	LDA table_01_B327 + 1,X
	STA (plr_data),Y
bra_01_8B0C:
	PLA
	CLC
	ADC #$01
	INC counter
	LDX counter
	CPX #$0B
	BNE bra_01_8AD2
	RTS
.endscope

table_01_8B19:		; 11 байтов для игроков, читается из 2х мест
.byte $00,$03,$03,$03,$03,$02,$01,$02,$01,$02,$01

_loc_01_8B24:
	TAX
	LDY #$00
	LDA random + 1
	ADC random
	CMP table_01_8B3B,X
	BCC bra_01_8B39
	INY
	CMP table_01_8B3B + 1,X
	BCC bra_01_8B39
	INY
bra_01_8B39:
	TYA
	RTS

table_01_8B3B:		; для некого рандома
.byte $55,$AA
.byte $64,$B2

_loc_01_8B3F:
	SEC
	LDA ball_pos_y_lo
	SBC #$00
	LDA ball_pos_y_hi
	SBC #$03
	BCC @clc
	LDX ball_pos_x_lo
	LDY $03DA
	BEQ @skip
	JSR _jmp_EOR_16bit_plus2_b03
@skip:
	TXA
	SEC
	SBC #$80
	TYA
	SBC #$00
	BCC @clc
	LDA random
	CMP #$40
	BCC @clc
	SEC
	RTS
@clc:
	CLC
	RTS

_loc_01_8B6B:
	BIT plr_w_ball
	BPL bra_01_8B73
	JMP _loc_01_8B97
bra_01_8B73:
	LDY #plr_pos_x_lo
	JSR _loc_01_8B85
	STA $2A
	LDY #plr_pos_y_lo
	JSR _loc_01_8B85
	ASL
	ASL
	ORA $2A
	TAX
	RTS

_loc_01_8B85:
	SEC
	LDA (plr_data),Y
	SBC $03D3,Y
	TAX
	INY
	INY
	LDA (plr_data),Y	; plr_pos_x_hi / plr_pos_y_hi
	SBC $03D3,Y
	JSR _loc_01_8BC3
	RTS

_loc_01_8B97:
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	SEC
	SBC ball_land_pos_x_lo
	TAX
	INY
	INY		; plr_pos_x_hi
	SBC ball_land_pos_x_hi
	JSR _loc_01_8BC3
	STA $2A
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	SEC
	SBC ball_land_pos_y_lo
	TAX
	INY
	INY
	LDA (plr_data),Y	; plr_pos_y_hi
	SBC ball_land_pos_y_hi
	JSR _loc_01_8BC3
	ASL
	ASL
	ORA $2A
	TAX
	RTS

_loc_01_8BC3:
; на выходе код ожидает получить A = 00 01 02
	TAY
	PHP
	BPL @skip
	JSR _jmp_EOR_16bit_b03
@skip:
	TYA
	BNE @continue
	CPX #$04
	BCS @continue
	PLP
	LDA #$00
	RTS

@continue:
	LDA #$01
	PLP
	BMI @rts
	ASL
@rts:
	RTS

SetBotTimerThrowIn:		; вычисление таймера для бота, который выбивает из углового
	LDA random + 1
	LDY #plr_act_timer2
	AND #$0F
	ADC #$10
	STA (plr_data),Y
	RTS

_loc_01_8BE8:
	BIT $82
	BMI bra_01_8BFD
	LDA #$80
	STA $82
	LDA #$01
	STA $83
	LDA #$00
	STA $84
	LDA area_id
	STA $85
bra_01_8BFD:
	LDA #$00
	STA bot_behav
	JSR _loc_01_8CA8
	JSR _loc_01_8C4F
	DEC $83
	BNE bra_01_8C4C
	LDA #$00
	STA $84
	JSR _loc_01_8C4F
	LDA $84
	AND #$0C
	BNE bra_01_8C27
	LDA random + 1
	AND #$0C
	CMP #$0C
	BNE bra_01_8C23
	LDA #$04
bra_01_8C23:
	ORA $84
	STA $84
bra_01_8C27:
	LDA $84
	AND #$03
	BNE bra_01_8C43
	LDA random
	AND #$03
	CMP #$03
	BNE bra_01_8C3F
	LDA #$01
	LDX $03DA
	BEQ bra_01_8C3F
	LDA #$02
bra_01_8C3F:
	ORA $84
	STA $84
bra_01_8C43:
	LDA random
	AND #$3C
	ADC #$08
	STA $83
bra_01_8C4C:
	LDA $84
	RTS

_loc_01_8C4F:
	LDY #plr_pos_y_hi
	LDA (plr_data),Y
	CMP #$03
	BCS bra_01_8C62
	LDA $84
	AND #$F3
	ORA #$04
	STA $84
	JMP _loc_01_8C65
bra_01_8C62:
	JSR _loc_01_8C92
_loc_01_8C65:
	LDA #$00
	STA $2A
	LDX ball_pos_x_lo
	LDY $03DA
	BEQ bra_01_8C76
	INC $2A
	JSR _jmp_EOR_16bit_plus2_b03
bra_01_8C76:
	SEC
	TXA
	SBC #$40
	TYA
	SBC #$00
	BCS bra_01_8C91
	LDX #$01
	LSR $2A
	BCC bra_01_8C86
	INX
bra_01_8C86:
	LDA $84
	AND #$FC
	STA $84
	TXA
	ORA $84
	STA $84
bra_01_8C91:
	RTS
_loc_01_8C92:
	SEC
	LDA ball_pos_y_lo
	SBC #$40
	LDA ball_pos_y_hi
	SBC #$03
	BCC bra_01_8CA7
	LDA $84
	AND #$F3
	ORA #$08
	STA $84
bra_01_8CA7:
	RTS

_loc_01_8CA8:
	LDY area_id
	CPY $85
	BNE bra_01_8CB0
	RTS
bra_01_8CB0:
	STY $85
	LDA #<table_01_B727
	STA $2A
	LDA #>table_01_B727
	STA $2B
	LDA (team_behav),Y
	ASL
	BCC bra_01_8CC1
	INC $2B
bra_01_8CC1:
	TAY
	LDA ($2A),Y
	TAX
	INY
	LDA ($2A),Y
	STX $2A
	STA $2B
	LDY #$00
	LDA ($2A),Y
	BEQ bra_01_8CDA
	CMP random
	BCC bra_01_8CDA
	JMP _loc_01_8D0A
bra_01_8CDA:
	INY
	LDA ($2A),Y
	BEQ bra_01_8D09
	CMP random + 1
	BCC bra_01_8D09
	INY
	LDA ($2A),Y
	BEQ bra_01_8D09
	STA $2C
	INY
bra_01_8CEC:
	ASL random
	ROL random + 1
	LDA ($2A),Y
	CMP random + 1
	INY
	LDA ($2A),Y
	INY
	BCC bra_01_8D05
	CMP plr_w_ball
	BEQ bra_01_8D05
	JMP _loc_01_8D11
bra_01_8D05:
	DEC $2C
	BNE bra_01_8CEC
bra_01_8D09:
	RTS

_loc_01_8D0A:
	LDA #$80
	STA bot_behav
	PLA
	PLA
	RTS

_loc_01_8D11:
	STA bot_mate
	LDA #$81
	STA bot_behav
	PLA
	PLA
	RTS

_loc_01_8D1A:
	LDA #$00
	STA $2B
; чтение номера второй команды
	LDA team_id + 1
; умножение на 40 (28)
	ASL
	ASL
	ASL
	STA $2A
	ASL
	ASL
	ROL $2B
	ADC $2A
	PHA
	LDA $2B
	ADC #$00
	TAX
	PLA
	CLC
	ADC #<table_01_B4A7
	STA team_behav
	TXA
	ADC #>table_01_B4A7
	STA team_behav + 1
	RTS

table_01_8D3E:		; поинтеры на table_01_9026
					; байтами выбирается набор тайлов размером 2x8 для поля
.byte $00,$00,$00,$00,$00,$00,$00,$00		; не использованы
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $01,$01,$01,$01,$01,$01,$01,$01
.byte $02,$02,$02,$02,$02,$02,$02,$02
.byte $03,$04,$04,$05,$06,$04,$04,$07
.byte $08,$09,$09,$0A,$0B,$0C,$0C,$0D
.byte $0E,$0F,$0F,$04,$04,$10,$10,$11
.byte $12,$13,$14,$15,$15,$16,$12,$13
.byte $10,$0F,$17,$18,$18,$19,$10,$0F
.byte $12,$13,$20,$20,$20,$20,$12,$13
.byte $00,$00,$00,$00,$00,$00,$00,$00		; не использованы

; 8DBE
.byte $10,$0F,$04,$1A,$1B,$04,$10,$0F
.byte $12,$13,$20,$20,$20,$20,$12,$13
.byte $10,$62,$2C,$2C,$2C,$2C,$63,$0F
.byte $12,$60,$33,$1C,$1D,$33,$61,$13
.byte $10,$04,$04,$1E,$1F,$04,$04,$0F
.byte $12,$20,$20,$20,$20,$20,$20,$13
.byte $10,$04,$04,$04,$04,$04,$04,$0F
.byte $12,$20,$20,$20,$20,$20,$20,$13
.byte $10,$04,$04,$04,$04,$04,$04,$0F
.byte $12,$20,$20,$20,$20,$20,$20,$13
.byte $10,$04,$04,$04,$04,$04,$04,$0F
.byte $12,$20,$20,$20,$20,$20,$20,$13
.byte $10,$04,$04,$21,$22,$04,$04,$0F
.byte $12,$20,$20,$23,$24,$20,$20,$13
.byte $10,$04,$04,$25,$26,$04,$04,$0F
.byte $00,$00,$00,$00,$00,$00,$00,$00		; не использованы

; 8E3E
.byte $12,$20,$27,$28,$29,$2A,$20,$13
.byte $2B,$2C,$2D,$2E,$2F,$30,$2C,$31
.byte $32,$33,$34,$35,$36,$37,$33,$38
.byte $10,$04,$39,$3A,$3B,$3C,$04,$0F
.byte $12,$20,$20,$3D,$3E,$20,$20,$13
.byte $10,$04,$04,$3F,$40,$04,$04,$0F
.byte $12,$20,$20,$41,$42,$20,$20,$13
.byte $10,$04,$04,$04,$04,$04,$04,$0F
.byte $12,$20,$20,$20,$20,$20,$20,$13
.byte $10,$04,$04,$04,$04,$04,$04,$0F
.byte $12,$20,$20,$20,$20,$20,$20,$13
.byte $10,$04,$04,$04,$04,$04,$04,$0F
.byte $12,$20,$20,$20,$20,$20,$20,$13
.byte $10,$04,$04,$04,$04,$04,$04,$0F
.byte $12,$20,$20,$43,$44,$20,$20,$13
.byte $00,$00,$00,$00,$00,$00,$00,$00		; не использованы

; 8EBE
.byte $10,$45,$2C,$46,$47,$2C,$48,$0F
.byte $12,$49,$33,$33,$33,$33,$4A,$13
.byte $10,$0F,$04,$04,$04,$04,$10,$0F
.byte $12,$13,$20,$4B,$4C,$20,$12,$13
.byte $10,$0F,$04,$04,$04,$04,$10,$0F
.byte $12,$13,$4D,$15,$15,$4E,$12,$13
.byte $10,$0F,$4F,$18,$18,$50,$10,$0F
.byte $51,$13,$13,$20,$20,$12,$12,$52
.byte $53,$54,$54,$55,$56,$57,$57,$58
.byte $59,$20,$20,$5A,$5B,$20,$20,$5C
.byte $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D
.byte $5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E
.byte $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
.byte $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F		; не использованы

; 8F3E
.byte $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
.byte $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
.byte $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
.byte $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
.byte $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
.byte $00,$00,$00,$00,$00,$00,$00,$00		; не использованы
.byte $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F		; не использованы

table_01_8F66:		; атрибуты фона поля, одним выбранным забивается часть атрибутов
.byte $AA,$AA,$AA,$AA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$50,$55,$55
.byte $55,$55

; 8F88 (тут только AA AA, нахер такое надо)
.byte $00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$AA,$AA,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00

table_01_9026:		; наборы тайлов для полосок размером 2x8 тайлов
; 00-0F
.byte $04,$05,$04,$05,$04,$05,$04,$05,$05,$04,$05,$04,$05,$04,$05,$04
.byte $04,$05,$04,$05,$04,$05,$04,$05,$06,$07,$06,$07,$06,$07,$06,$07
.byte $08,$08,$08,$08,$08,$08,$08,$08,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
.byte $02,$02,$02,$02,$02,$02,$02,$02,$00,$A4,$00,$00,$00,$00,$00,$00
.byte $02,$02,$02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00
.byte $02,$90,$88,$89,$89,$89,$8C,$8D,$00,$92,$B0,$B1,$B1,$B1,$B1,$B1
.byte $98,$99,$9C,$9C,$9C,$9D,$91,$02,$B1,$B1,$B1,$B1,$B1,$B4,$93,$00
.byte $02,$02,$02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$A5,$00
.byte $A9,$A6,$18,$18,$18,$18,$18,$18,$02,$14,$38,$61,$1B,$1B,$1B,$1B
.byte $18,$18,$18,$18,$18,$18,$18,$18,$1B,$1B,$1B,$1B,$1B,$39,$38,$1B
.byte $18,$80,$81,$0E,$0E,$0E,$0E,$0E,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
.byte $0E,$0E,$0E,$0E,$0E,$84,$85,$18,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
.byte $18,$18,$18,$18,$18,$18,$18,$18,$1B,$39,$38,$1B,$1B,$1B,$1B,$1B
.byte $18,$18,$18,$18,$18,$18,$A7,$AC,$1B,$1B,$1B,$1B,$64,$39,$15,$02
.byte $02,$14,$62,$27,$02,$02,$02,$02,$00,$16,$17,$00,$00,$00,$00,$00
.byte $02,$02,$02,$02,$02,$14,$15,$02,$00,$00,$00,$00,$00,$16,$17,$00

; 10-1F
.byte $02,$14,$15,$02,$02,$02,$02,$02,$00,$16,$17,$00,$00,$00,$00,$00
.byte $02,$02,$02,$02,$26,$67,$15,$02,$00,$00,$00,$00,$00,$16,$17,$00
.byte $00,$16,$17,$00,$00,$00,$00,$00,$02,$14,$15,$02,$02,$02,$02,$02
.byte $00,$00,$00,$00,$00,$16,$17,$00,$02,$02,$02,$02,$02,$14,$15,$02
.byte $00,$00,$00,$00,$00,$16,$17,$00,$02,$02,$02,$02,$02,$14,$3A,$19
.byte $00,$00,$00,$00,$00,$00,$00,$00,$19,$19,$19,$19,$19,$19,$19,$19
.byte $00,$16,$17,$00,$00,$00,$00,$00,$19,$3B,$15,$02,$02,$02,$02,$02
.byte $02,$02,$02,$02,$02,$2A,$1B,$1B,$00,$00,$00,$00,$00,$00,$00,$00
.byte $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$00,$00,$00,$00,$00,$00,$00,$00
.byte $1B,$1B,$2B,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00
.byte $02,$02,$02,$02,$02,$02,$02,$24,$00,$00,$00,$00,$00,$00,$00,$22
.byte $25,$02,$02,$02,$02,$02,$02,$02,$23,$00,$00,$00,$00,$00,$00,$00
.byte $1A,$68,$69,$1A,$1A,$1A,$1A,$1A,$02,$2A,$73,$25,$02,$02,$02,$02
.byte $1A,$1A,$1A,$1A,$1A,$6C,$6D,$1A,$02,$02,$02,$02,$24,$76,$2B,$02
.byte $02,$02,$02,$46,$47,$35,$02,$02,$00,$00,$00,$00,$00,$78,$79,$0C
.byte $02,$02,$34,$52,$53,$02,$02,$02,$0C,$7C,$7D,$00,$00,$00,$00,$00

; 20-2F
.byte $00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02
.byte $02,$02,$02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$2C,$7A,$7B,$0C
.byte $02,$02,$02,$02,$02,$02,$02,$02,$0C,$7E,$7F,$2D,$00,$00,$00,$00
.byte $00,$00,$00,$4E,$4F,$33,$00,$00,$02,$28,$71,$27,$02,$02,$02,$02
.byte $00,$00,$32,$5A,$5B,$00,$00,$00,$02,$02,$02,$02,$26,$74,$29,$02
.byte $02,$70,$2B,$02,$02,$02,$02,$02,$41,$23,$00,$00,$00,$00,$00,$00
.byte $02,$02,$02,$02,$02,$2A,$75,$02,$00,$00,$00,$00,$00,$00,$22,$54
.byte $00,$00,$00,$00,$00,$00,$00,$2C,$02,$02,$02,$02,$02,$02,$02,$40
.byte $43,$00,$00,$00,$00,$00,$00,$00,$A3,$02,$02,$02,$02,$02,$02,$02
.byte $00,$00,$00,$00,$00,$00,$00,$56,$02,$02,$02,$02,$02,$02,$02,$A2
.byte $2D,$00,$00,$00,$00,$00,$00,$00,$55,$02,$02,$02,$02,$02,$02,$02
.byte $A8,$14,$15,$02,$02,$02,$02,$02,$AA,$AB,$3E,$18,$18,$18,$18,$18
.byte $02,$02,$02,$02,$02,$02,$02,$02,$18,$18,$18,$18,$18,$18,$18,$18
.byte $02,$02,$02,$02,$02,$02,$02,$42,$18,$18,$18,$18,$18,$18,$18,$0D
.byte $02,$02,$02,$02,$02,$02,$02,$02,$18,$18,$18,$18,$18,$18,$18,$1C
.byte $02,$02,$02,$02,$02,$02,$02,$02,$1D,$18,$18,$18,$18,$18,$18,$18

; 30-3F
.byte $57,$02,$02,$02,$02,$02,$02,$02,$0D,$18,$18,$18,$18,$18,$18,$18
.byte $02,$02,$02,$02,$02,$14,$15,$AD,$18,$18,$18,$18,$18,$3F,$AE,$AF
.byte $00,$16,$3C,$1A,$1A,$1A,$1A,$1A,$02,$14,$15,$02,$02,$02,$02,$02
.byte $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$02,$02,$02,$02,$02,$02,$02,$02
.byte $1A,$1A,$1A,$1A,$1A,$1A,$1A,$0F,$02,$02,$02,$02,$02,$02,$02,$48
.byte $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1E,$02,$02,$02,$02,$02,$02,$02,$02
.byte $1F,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$02,$02,$02,$02,$02,$02,$02,$02
.byte $0F,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$5D,$02,$02,$02,$02,$02,$02,$02
.byte $1A,$1A,$1A,$1A,$1A,$3D,$17,$00,$02,$02,$02,$02,$02,$14,$15,$02
.byte $02,$02,$02,$02,$02,$02,$02,$4A,$00,$00,$00,$00,$00,$00,$00,$2E
.byte $A1,$02,$02,$02,$02,$02,$02,$02,$49,$00,$00,$00,$00,$00,$00,$00
.byte $02,$02,$02,$02,$02,$02,$02,$A0,$00,$00,$00,$00,$00,$00,$00,$5C
.byte $5F,$02,$02,$02,$02,$02,$02,$02,$2F,$00,$00,$00,$00,$00,$00,$00
.byte $4B,$21,$00,$00,$00,$00,$00,$00,$02,$72,$29,$02,$02,$02,$02,$02
.byte $00,$00,$00,$00,$00,$00,$20,$5E,$02,$02,$02,$02,$02,$28,$77,$02
.byte $02,$2A,$73,$25,$02,$02,$02,$02,$00,$00,$00,$44,$45,$31,$00,$00

; 40-4F
.byte $02,$02,$02,$02,$24,$76,$2B,$02,$00,$00,$30,$50,$51,$00,$00,$00
.byte $00,$00,$00,$00,$2E,$78,$79,$0C,$02,$02,$02,$02,$02,$02,$02,$02
.byte $0C,$7C,$7D,$2F,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02
.byte $00,$00,$00,$00,$00,$7A,$7B,$0C,$02,$02,$02,$4C,$4D,$37,$02,$02
.byte $0C,$7E,$7F,$00,$00,$00,$00,$00,$02,$02,$36,$58,$59,$02,$02,$02
.byte $02,$02,$02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$2C,$18,$18
.byte $02,$28,$71,$27,$02,$02,$02,$02,$18,$6A,$6B,$18,$18,$18,$18,$18
.byte $02,$02,$02,$02,$26,$74,$29,$02,$18,$18,$18,$18,$18,$6E,$6F,$18
.byte $02,$02,$02,$02,$02,$02,$02,$02,$18,$18,$2D,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$16,$3C,$1A,$02,$02,$02,$02,$02,$14,$15,$02
.byte $1A,$3D,$17,$00,$00,$00,$00,$00,$02,$14,$15,$02,$02,$02,$02,$02
.byte $00,$00,$00,$00,$00,$00,$00,$20,$02,$02,$02,$02,$02,$02,$02,$26
.byte $21,$00,$00,$00,$00,$00,$00,$00,$27,$02,$02,$02,$02,$02,$02,$02
.byte $00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$28,$19,$19
.byte $00,$00,$00,$00,$00,$00,$00,$00,$19,$19,$29,$02,$02,$02,$02,$02
.byte $02,$02,$02,$02,$02,$14,$38,$1B,$00,$00,$00,$00,$00,$16,$17,$00

; 50-5F
.byte $1B,$39,$15,$02,$02,$02,$02,$02,$00,$16,$17,$00,$00,$00,$00,$00
.byte $00,$16,$17,$00,$00,$00,$00,$00,$02,$14,$60,$25,$02,$02,$02,$02
.byte $00,$00,$00,$00,$00,$16,$17,$00,$02,$02,$02,$02,$24,$65,$15,$02
.byte $02,$14,$3A,$63,$19,$19,$19,$19,$B5,$B8,$1A,$1A,$1A,$1A,$1A,$1A
.byte $19,$19,$19,$19,$19,$3B,$3A,$19,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
.byte $19,$19,$19,$19,$19,$19,$19,$19,$1A,$82,$83,$0E,$0E,$0E,$0E,$0E
.byte $19,$19,$19,$19,$19,$19,$19,$19,$0E,$0E,$0E,$0E,$0E,$86,$87,$1A
.byte $19,$3B,$3A,$19,$19,$19,$19,$19,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A
.byte $19,$19,$19,$19,$66,$3B,$15,$02,$1A,$1A,$1A,$1A,$1A,$1A,$B9,$B7
.byte $00,$BA,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02
.byte $00,$94,$B2,$B3,$B3,$B3,$B3,$B3,$02,$96,$8A,$8B,$8B,$8B,$8E,$8F
.byte $B3,$B3,$B3,$B3,$B3,$B6,$95,$00,$9A,$9B,$9E,$9E,$9E,$9F,$97,$02
.byte $00,$00,$00,$00,$00,$00,$BB,$00,$02,$02,$02,$02,$02,$02,$02,$02
.byte $09,$09,$09,$09,$09,$09,$09,$09,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B
.byte $10,$11,$10,$11,$10,$11,$10,$11,$12,$13,$12,$13,$12,$13,$12,$13
.byte $13,$12,$13,$12,$13,$12,$13,$12,$12,$13,$12,$13,$12,$13,$12,$13

; 60-63
.byte $00,$00,$00,$00,$00,$2E,$1A,$1A,$02,$02,$02,$02,$02,$02,$02,$02
.byte $1A,$1A,$2F,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02
.byte $02,$02,$02,$02,$02,$14,$15,$02,$00,$00,$00,$00,$00,$16,$3E,$18
.byte $02,$14,$15,$02,$02,$02,$02,$02,$18,$3F,$17,$00,$00,$00,$00,$00

table_01_9666:		; что-то связано с параметрами анимации игроков во время действий
.word table_01_9666_96E6		; еще не использовался, и вряд ли будет использован
.word table_01_9666_96E6
.word table_01_9666_96EA
.word table_01_9666_96EE
.word table_01_9666_96FE
.word table_01_9666_970E
.word table_01_9666_971A
.word table_01_9666_971E
.word table_01_9666_9722
.word table_01_9666_972E
.word table_01_9666_9736
.word table_01_9666_973E
.word table_01_9666_9746
.word table_01_9666_9756
.word table_01_9666_975E
.word table_01_9666_976E
.word table_01_9666_9776
.word table_01_9666_977A
.word table_01_9666_978A
.word table_01_9666_979A
.word table_01_9666_97A2
.word table_01_9666_97AA
.word table_01_9666_97BA

; 9694 (видимо не используется)
.byte $C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97
.byte $C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97
.byte $C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97
.byte $C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97
.byte $C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97,$C6,$97
.byte $C6,$97

table_01_9666_96E6:		; эту таблицу следует разобрать подробнее
.byte $00,$12,$14,$18
table_01_9666_96EA:
.byte $00,$75,$76,$77
table_01_9666_96EE:
.byte $00,$11,$13,$17,$00,$12,$14,$18,$12,$11,$15,$17,$12,$12,$16,$18
table_01_9666_96FE:
.byte $00,$7B,$7D,$81,$00,$7C,$7E,$82,$12,$7B,$7F,$81,$12,$7C,$80,$82
table_01_9666_970E:
.byte $00,$21,$24,$27,$00,$22,$25,$28,$00,$23,$26,$29
table_01_9666_971A:
.byte $00,$1B,$1C,$1D
table_01_9666_971E:
.byte $00,$42,$44,$46
table_01_9666_9722:
.byte $00,$2D,$32,$37,$00,$2E,$33,$38,$00,$31,$36,$3B
table_01_9666_972E:
.byte $00,$4A,$4E,$52,$00,$4B,$4F,$53
table_01_9666_9736:
.byte $00,$E1,$E3,$E5,$00,$E2,$E4,$E6
table_01_9666_973E:
.byte $00,$22,$25,$28,$00,$23,$26,$29
table_01_9666_9746:
.byte $00,$54,$59,$5E,$00,$55,$5A,$5F,$00,$56,$5B,$60,$00,$4B,$4F,$53
table_01_9666_9756:
.byte $00,$63,$65,$67,$00,$64,$66,$68
table_01_9666_975E:
.byte $00,$6C,$6F,$72,$00,$6D,$70,$73,$00,$6E,$71,$74,$3F,$31,$36,$3B
table_01_9666_976E:
.byte $00,$3C,$3E,$40,$00,$3D,$3F,$41
table_01_9666_9776:
.byte $00,$8F,$90,$91
table_01_9666_977A:
.byte $00,$83,$87,$8B,$00,$84,$88,$8C,$00,$85,$89,$8D,$00,$86,$8A,$8E
table_01_9666_978A:
.byte $00,$19,$1A,$2B,$00,$8F,$90,$91,$12,$19,$2A,$2B,$12,$8F,$90,$91
table_01_9666_979A:
.byte $00,$92,$94,$96,$00,$93,$95,$97
table_01_9666_97A2:
.byte $00,$98,$99,$9A,$00,$93,$95,$97
table_01_9666_97AA:
.byte $00,$E8,$E8,$E8,$00,$E9,$E9,$E9,$00,$EA,$EA,$EA,$00,$EB,$EB,$EB
table_01_9666_97BA:
.byte $00,$EC,$EC,$EC,$00,$F0,$ED,$ED,$00,$F0,$EE,$EE

table_01_97C6:				; параметры спрайтов анимаций
.word table_01_97C6_99C6
.word table_01_97C6_99C7
.word table_01_97C6_99CE
.word table_01_97C6_99D5
.word table_01_97C6_99DE
.word table_01_97C6_99E7
.word table_01_97C6_99F0
.word table_01_97C6_99F9
.word table_01_97C6_9A02
.word table_01_97C6_9A0B
.word table_01_97C6_9A14
.word table_01_97C6_99DE
.word table_01_97C6_9A1D
.word table_01_97C6_99F0
.word table_01_97C6_9A26
.word table_01_97C6_9A02
.word table_01_97C6_9A2F
.word table_01_97C6_9A38
.word table_01_97C6_9A42
.word table_01_97C6_9A4C
.word table_01_97C6_9A58
.word table_01_97C6_9A64
.word table_01_97C6_9A70
.word table_01_97C6_9A7C
.word table_01_97C6_9A86
.word table_01_97C6_9A8E
.word table_01_97C6_9A9B
.word table_01_97C6_9AA8
.word table_01_97C6_9AB4
.word table_01_97C6_9AC0
.word table_01_97C6_9ACC
.word table_01_97C6_9ACD
.word table_01_97C6_9ACE
.word table_01_97C6_9ACF
.word table_01_97C6_9ADE
.word table_01_97C6_9AEB
.word table_01_97C6_9AFA
.word table_01_97C6_9B09
.word table_01_97C6_9B16
.word table_01_97C6_9B27
.word table_01_97C6_9B36
.word table_01_97C6_9B43
.word table_01_97C6_9B52
.word table_01_97C6_9B5F
.word table_01_97C6_9B6C
.word table_01_97C6_9B6D
.word table_01_97C6_9B7C
.word table_01_97C6_9B8F
.word table_01_97C6_9B96
.word table_01_97C6_9B9D
.word table_01_97C6_9BAA
.word table_01_97C6_9BB9
.word table_01_97C6_9BCA
.word table_01_97C6_9BCB
.word table_01_97C6_9BCC
.word table_01_97C6_9BD9
.word table_01_97C6_9BE8
.word table_01_97C6_9BF9
.word table_01_97C6_9BFA
.word table_01_97C6_9BFB
.word table_01_97C6_9C08
.word table_01_97C6_9C15
.word table_01_97C6_9C22
.word table_01_97C6_9C2F
.word table_01_97C6_9C3C
.word table_01_97C6_9C45
.word table_01_97C6_9C50
.word table_01_97C6_9C5F
.word table_01_97C6_9C60
.word table_01_97C6_9C6D
.word table_01_97C6_9C6E
.word table_01_97C6_9C7D
.word table_01_97C6_9C7E
.word table_01_97C6_9C7F
.word table_01_97C6_9C80
.word table_01_97C6_9C91
.word table_01_97C6_9C9E
.word table_01_97C6_9C9F
.word table_01_97C6_9CA0
.word table_01_97C6_9CB5
.word table_01_97C6_9CC2
.word table_01_97C6_9CC3
.word table_01_97C6_9CC4
.word table_01_97C6_9CD3
.word table_01_97C6_9CE0
.word table_01_97C6_9CEF
.word table_01_97C6_9D02
.word table_01_97C6_9D11
.word table_01_97C6_9D12
.word table_01_97C6_9D13
.word table_01_97C6_9D22
.word table_01_97C6_9D33
.word table_01_97C6_9D44
.word table_01_97C6_9D45
.word table_01_97C6_9D46
.word table_01_97C6_9D59
.word table_01_97C6_9D68
.word table_01_97C6_9D77
.word table_01_97C6_9D78
.word table_01_97C6_9D79
.word table_01_97C6_9D86
.word table_01_97C6_9D95
.word table_01_97C6_9DA2
.word table_01_97C6_9DB3
.word table_01_97C6_9DC0
.word table_01_97C6_9DCF
.word table_01_97C6_9DE2
.word table_01_97C6_9DEF
.word table_01_97C6_9DFE
.word table_01_97C6_9E11
.word table_01_97C6_9E24
.word table_01_97C6_9E37
.word table_01_97C6_9E46
.word table_01_97C6_9E57
.word table_01_97C6_9E66
.word table_01_97C6_9E79
.word table_01_97C6_9E86
.word table_01_97C6_9E99
.word table_01_97C6_9EA6
.word table_01_97C6_9EB3
.word table_01_97C6_9EBC
.word table_01_97C6_9EC9
.word table_01_97C6_9ED4
.word table_01_97C6_9EE1
.word table_01_97C6_9EEC
.word table_01_97C6_9EF7
.word table_01_97C6_9F04
.word table_01_97C6_9F11
.word table_01_97C6_9F1E
.word table_01_97C6_9F2B
.word table_01_97C6_9F36
.word table_01_97C6_9F3F
.word table_01_97C6_9F4E
.word table_01_97C6_9F5B
.word table_01_97C6_9F6A
.word table_01_97C6_9F77
.word table_01_97C6_9F86
.word table_01_97C6_9F93
.word table_01_97C6_9FA6
.word table_01_97C6_9FB3
.word table_01_97C6_9FC2
.word table_01_97C6_9FCF
.word table_01_97C6_9FDE
.word table_01_97C6_9FEB
.word table_01_97C6_9FF8
.word table_01_97C6_A005
.word table_01_97C6_A010
.word table_01_97C6_A01D
.word table_01_97C6_A028
.word table_01_97C6_A035
.word table_01_97C6_A042
.word table_01_97C6_A04F
.word table_01_97C6_A05C
.word table_01_97C6_A069
.word table_01_97C6_A076
.word table_01_97C6_A083
.word table_01_97C6_A094
.word table_01_97C6_A0A5
.word table_01_97C6_A0B6
.word table_01_97C6_A0C5
.word table_01_97C6_A0D2
.word table_01_97C6_A0DF
.word table_01_97C6_A0F2
.word table_01_97C6_A105
.word table_01_97C6_A11A
.word table_01_97C6_A127
.word table_01_97C6_A132
.word table_01_97C6_A13F
.word table_01_97C6_A150
.word table_01_97C6_A15F
.word table_01_97C6_A170
.word table_01_97C6_A181
.word table_01_97C6_A192
.word table_01_97C6_A1A3
.word table_01_97C6_A1B4
.word table_01_97C6_A1C5
.word table_01_97C6_A1D4
.word table_01_97C6_A1E1
.word table_01_97C6_A1EE
.word table_01_97C6_A201
.word table_01_97C6_A214
.word table_01_97C6_A225
.word table_01_97C6_A234
.word table_01_97C6_A245
.word table_01_97C6_A250
.word table_01_97C6_A25D
.word table_01_97C6_A26E
.word table_01_97C6_A27F
.word table_01_97C6_A290
.word table_01_97C6_A2A3
.word table_01_97C6_A2A4
.word table_01_97C6_A2A5
.word table_01_97C6_A2A6
.word table_01_97C6_A2A7
.word table_01_97C6_A2A8
.word table_01_97C6_A2A9
.word table_01_97C6_A2AA
.word table_01_97C6_A2AB
.word table_01_97C6_A2AC
.word table_01_97C6_A2AD
.word table_01_97C6_A2AE
.word table_01_97C6_A2AF
.word table_01_97C6_A2B0
.word table_01_97C6_A2B1
.word table_01_97C6_A2B2
.word table_01_97C6_A2B3
.word table_01_97C6_A2B4
.word table_01_97C6_A2B5
.word table_01_97C6_A2B6
.word table_01_97C6_A2B7
.word table_01_97C6_A2B8
.word table_01_97C6_A2B9
.word table_01_97C6_A2BA
.word table_01_97C6_A2BB
.word table_01_97C6_A2BC
.word table_01_97C6_A2BD
.word table_01_97C6_A2BE
.word table_01_97C6_A2BF
.word table_01_97C6_A2C0
.word table_01_97C6_A2C1
.word table_01_97C6_A2C2
.word table_01_97C6_A2C3
.word table_01_97C6_A2C4
.word table_01_97C6_A2C5
.word table_01_97C6_A2C6
.word table_01_97C6_A2CD
.word table_01_97C6_A2DE
.word table_01_97C6_A2EB
.word table_01_97C6_A2FE
.word table_01_97C6_A30B
.word table_01_97C6_A318
.word table_01_97C6_A325
.word table_01_97C6_A326
.word table_01_97C6_A34B
.word table_01_97C6_A372
.word table_01_97C6_A39F
.word table_01_97C6_A3C6
.word table_01_97C6_A3E3
.word table_01_97C6_A3FE
.word table_01_97C6_A41B
.word table_01_97C6_A426
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445
.word table_01_97C6_A445

table_01_97C6_99C6:
.byte $01
table_01_97C6_99C7:
.byte $03,$10,$08,$F8,$FC,$1D,$01
table_01_97C6_99CE:
.byte $03,$10,$08,$F8,$FC,$1F,$01
table_01_97C6_99D5:
.byte $03,$10,$10,$F8,$F8,$21,$00,$23,$01
table_01_97C6_99DE:
.byte $03,$10,$10,$F8,$F8,$25,$00,$27,$01
table_01_97C6_99E7:
.byte $03,$10,$10,$F8,$F8,$29,$00,$2B,$01
table_01_97C6_99F0:
.byte $03,$10,$10,$F8,$F8,$2D,$00,$2F,$01
table_01_97C6_99F9:
.byte $03,$10,$10,$F8,$F8,$31,$00,$33,$01
table_01_97C6_9A02:
.byte $03,$10,$10,$F8,$F8,$35,$00,$37,$01
table_01_97C6_9A0B:
.byte $03,$10,$10,$F8,$F8,$39,$00,$3B,$01
table_01_97C6_9A14:
.byte $03,$10,$10,$F9,$F8,$21,$00,$23,$01
table_01_97C6_9A1D:
.byte $03,$10,$10,$F9,$F8,$29,$00,$2B,$01
table_01_97C6_9A26:
.byte $03,$10,$10,$F9,$F8,$31,$00,$33,$01
table_01_97C6_9A2F:
.byte $03,$10,$10,$F9,$F8,$39,$00,$3B,$01
table_01_97C6_9A38:
.byte $02,$18,$F9,$F9,$C4,$01,$C6,$FD,$FD,$01
table_01_97C6_9A42:
.byte $02,$18,$F9,$F9,$C8,$01,$CA,$FD,$FD,$01
table_01_97C6_9A4C:
.byte $02,$10,$F9,$F9,$E0,$01,$E2,$08,$FB,$FC,$FD,$01
table_01_97C6_9A58:
.byte $02,$10,$F9,$F9,$E4,$01,$E6,$08,$FB,$FC,$FD,$01
table_01_97C6_9A64:
.byte $02,$10,$F9,$F9,$E8,$01,$EA,$08,$FB,$FC,$FD,$01
table_01_97C6_9A70:
.byte $02,$10,$F9,$F9,$EC,$01,$EE,$08,$FB,$FC,$FD,$01
table_01_97C6_9A7C:
.byte $02,$18,$F9,$F9,$CC,$01,$CE,$F9,$FF,$01
table_01_97C6_9A86:
.byte $02,$10,$F9,$FC,$C2,$F9,$FF,$01
table_01_97C6_9A8E:
.byte $03,$39,$10,$F9,$F9,$6C,$01,$6E,$08,$FE,$FD,$7D,$01
table_01_97C6_9A9B:
.byte $03,$39,$10,$F9,$F9,$70,$01,$72,$08,$FD,$FE,$7D,$01
table_01_97C6_9AA8:
.byte $02,$10,$F4,$F9,$F0,$01,$F2,$08,$FB,$FC,$FD,$01
table_01_97C6_9AB4:
.byte $02,$10,$F7,$F7,$F8,$FF,$FA,$08,$FC,$FA,$FD,$01
table_01_97C6_9AC0:
.byte $02,$10,$F9,$F4,$F4,$FC,$F6,$08,$FA,$FB,$FF,$01
table_01_97C6_9ACC:
.byte $01
table_01_97C6_9ACD:
.byte $01
table_01_97C6_9ACE:
.byte $01
table_01_97C6_9ACF:
.byte $03,$B3,$08,$F7,$F8,$C0,$08,$F9,$00,$C2,$08,$F8,$FD,$FD,$01
table_01_97C6_9ADE:
.byte $03,$B7,$10,$F8,$F8,$C0,$00,$C2,$08,$FB,$FD,$FD,$01
table_01_97C6_9AEB:
.byte $03,$BB,$08,$F2,$F8,$C0,$08,$EC,$00,$C2,$08,$F0,$FD,$FD,$01
table_01_97C6_9AFA:
.byte $03,$B3,$18,$F9,$F2,$C4,$FA,$C6,$02,$D0,$08,$FA,$FB,$FD,$01
table_01_97C6_9B09:
.byte $03,$B7,$10,$F9,$F9,$C4,$01,$C6,$08,$FB,$FC,$FD,$01
table_01_97C6_9B16:
.byte $03,$BB,$10,$F0,$F6,$C4,$FE,$C6,$08,$00,$F6,$CE,$08,$F6,$F8,$FD,$01
table_01_97C6_9B27:
.byte $03,$B3,$18,$F8,$F1,$C8,$F9,$CA,$00,$CC,$08,$F9,$F8,$FF,$01
table_01_97C6_9B36:
.byte $03,$B7,$10,$F8,$F9,$C8,$01,$CA,$08,$F9,$FC,$FF,$01
table_01_97C6_9B43:
.byte $03,$BB,$18,$F8,$ED,$C8,$F5,$CA,$FD,$CC,$08,$F9,$F3,$FF,$01
table_01_97C6_9B52:
.byte $03,$39,$10,$F9,$F9,$74,$01,$76,$08,$FD,$FE,$7D,$01
table_01_97C6_9B5F:
.byte $03,$39,$10,$F9,$F9,$78,$01,$7A,$08,$F9,$FE,$7F,$01
table_01_97C6_9B6C:
.byte $01
table_01_97C6_9B6D:
.byte $03,$B2,$08,$F7,$F9,$80,$08,$F9,$01,$82,$08,$F8,$FE,$7D,$01
table_01_97C6_9B7C:
.byte $03,$1A,$08,$E9,$01,$82,$08,$F8,$F9,$88,$08,$F9,$01,$8A,$08,$FE,$FE,$7D,$01
table_01_97C6_9B8F:
.byte $10,$10,$F1,$3C,$08,$00,$01
table_01_97C6_9B96:
.byte $10,$10,$F1,$3E,$08,$18,$01
table_01_97C6_9B9D:
.byte $03,$1A,$10,$F1,$F9,$A8,$01,$AA,$08,$F8,$FE,$7D,$01
table_01_97C6_9BAA:
.byte $03,$B2,$18,$F9,$F1,$84,$F9,$86,$01,$90,$08,$FA,$FA,$7D,$01
table_01_97C6_9BB9:
.byte $03,$1A,$08,$F2,$F1,$8C,$10,$F4,$F9,$8E,$01,$A0,$08,$F9,$FA,$7F,$01
table_01_97C6_9BCA:
.byte $01
table_01_97C6_9BCB:
.byte $01
table_01_97C6_9BCC:
.byte $03,$1A,$10,$FC,$FC,$AC,$04,$AE,$08,$FF,$00,$7D,$01
table_01_97C6_9BD9:
.byte $03,$B2,$18,$F8,$F1,$88,$F9,$8A,$01,$8C,$08,$F9,$F8,$7F,$01
table_01_97C6_9BE8:
.byte $03,$1A,$20,$F8,$E9,$98,$F1,$9A,$F9,$9C,$01,$9E,$08,$F9,$FE,$7F,$01
table_01_97C6_9BF9:
.byte $01
table_01_97C6_9BFA:
.byte $01
table_01_97C6_9BFB:
.byte $03,$1A,$10,$F8,$F1,$B0,$F9,$B2,$08,$F9,$F8,$7F,$01
table_01_97C6_9C08:
.byte $03,$47,$10,$F9,$F9,$E8,$01,$EA,$08,$FD,$FD,$FD,$01
table_01_97C6_9C15:
.byte $03,$47,$10,$F9,$F9,$EC,$01,$EE,$08,$FE,$FD,$FD,$01
table_01_97C6_9C22:
.byte $03,$47,$10,$F9,$F9,$F0,$01,$F2,$08,$FD,$FD,$FD,$01
table_01_97C6_9C2F:
.byte $03,$47,$10,$F9,$F9,$F4,$01,$F6,$08,$FD,$FD,$FD,$01
table_01_97C6_9C3C:
.byte $03,$47,$10,$F9,$FD,$E6,$FD,$FF,$01
table_01_97C6_9C45:
.byte $03,$47,$18,$F9,$F9,$F8,$01,$FA,$FE,$FF,$01
table_01_97C6_9C50:
.byte $03,$B3,$18,$F9,$F5,$F0,$FD,$F2,$04,$F4,$08,$FD,$FD,$FD,$01
table_01_97C6_9C5F:
.byte $01
table_01_97C6_9C60:
.byte $03,$B3,$10,$F9,$F6,$EC,$FE,$EE,$08,$FD,$F9,$FD,$01
table_01_97C6_9C6D:
.byte $01
table_01_97C6_9C6E:
.byte $03,$B3,$08,$F0,$FE,$F6,$08,$00,$FE,$F8,$08,$F9,$FD,$FF,$01
table_01_97C6_9C7D:
.byte $01
table_01_97C6_9C7E:
.byte $01
table_01_97C6_9C7F:
.byte $01
table_01_97C6_9C80:
.byte $03,$1A,$10,$E9,$F9,$84,$01,$86,$08,$F9,$FE,$80,$08,$F1,$FD,$7D,$01
table_01_97C6_9C91:
.byte $03,$1A,$10,$F9,$F9,$B4,$01,$B6,$08,$F8,$FD,$7D,$01
table_01_97C6_9C9E:
.byte $01
table_01_97C6_9C9F:
.byte $01
table_01_97C6_9CA0:
.byte $03,$1A,$10,$EE,$EF,$90,$F7,$92,$08,$F6,$FF,$96,$08,$FE,$F7,$94,$08,$EF,$F4,$7F,$01
table_01_97C6_9CB5:
.byte $03,$1A,$10,$F9,$F9,$B8,$01,$BA,$08,$FA,$FA,$7D,$01
table_01_97C6_9CC2:
.byte $01
table_01_97C6_9CC3:
.byte $01
table_01_97C6_9CC4:
.byte $03,$1A,$18,$F8,$F1,$A2,$F9,$A4,$01,$A6,$08,$F9,$F2,$7F,$01
table_01_97C6_9CD3:
.byte $03,$1A,$10,$F8,$F9,$BC,$01,$BE,$08,$F9,$F8,$7F,$01
table_01_97C6_9CE0:
.byte $03,$B3,$18,$F9,$FB,$CE,$03,$D8,$0B,$DA,$08,$F9,$FD,$FD,$01
table_01_97C6_9CEF:
.byte $03,$B7,$08,$F9,$01,$CE,$08,$FD,$F9,$CC,$08,$09,$01,$D0,$08,$FD,$F8,$FD,$01
table_01_97C6_9D02:
.byte $03,$BB,$08,$FB,$F9,$D0,$08,$03,$01,$D2,$08,$FD,$F8,$FF,$01
table_01_97C6_9D11:
.byte $01
table_01_97C6_9D12:
.byte $01
table_01_97C6_9D13:
.byte $03,$B3,$18,$F9,$FB,$D2,$03,$D4,$0B,$D6,$08,$FE,$FB,$FF,$01
table_01_97C6_9D22:
.byte $03,$B7,$08,$EF,$02,$D6,$10,$FF,$FA,$D2,$02,$D4,$08,$FE,$F9,$FF,$01
table_01_97C6_9D33:
.byte $03,$BB,$20,$FB,$F9,$D4,$01,$D6,$09,$D8,$11,$DA,$08,$00,$00,$FF,$01
table_01_97C6_9D44:
.byte $01
table_01_97C6_9D45:
.byte $01
table_01_97C6_9D46:
.byte $03,$B3,$10,$F0,$F9,$DC,$01,$DE,$10,$F8,$F9,$E0,$01,$E2,$08,$F9,$F9,$FF,$01
table_01_97C6_9D59:
.byte $03,$B7,$18,$F6,$F9,$D8,$01,$DA,$09,$DC,$08,$FC,$FD,$FF,$01
table_01_97C6_9D68:
.byte $03,$BB,$18,$F8,$FA,$DC,$02,$DE,$0A,$EC,$08,$01,$01,$FD,$01
table_01_97C6_9D77:
.byte $01
table_01_97C6_9D78:
.byte $01
table_01_97C6_9D79:
.byte $03,$B7,$10,$F9,$FC,$E0,$04,$E2,$08,$FE,$00,$FD,$01
table_01_97C6_9D86:
.byte $03,$BB,$18,$F9,$F9,$E0,$01,$E2,$09,$EC,$08,$F8,$FE,$FD,$01
table_01_97C6_9D95:
.byte $03,$B7,$10,$F9,$F9,$E4,$01,$E6,$08,$FD,$FE,$FD,$01
table_01_97C6_9DA2:
.byte $03,$BB,$10,$F9,$F9,$E4,$01,$E6,$08,$F4,$09,$EC,$08,$F8,$FA,$FD,$01
table_01_97C6_9DB3:
.byte $03,$B7,$10,$FC,$F9,$E8,$01,$EA,$08,$FF,$FE,$FD,$01
table_01_97C6_9DC0:
.byte $03,$BB,$08,$F9,$F9,$E8,$08,$FB,$01,$EA,$08,$FA,$F8,$FF,$01
table_01_97C6_9DCF:
.byte $03,$2B,$10,$F1,$F9,$DA,$01,$DC,$10,$01,$F9,$E0,$01,$E2,$08,$F6,$FF,$FD,$01
table_01_97C6_9DE2:
.byte $03,$2B,$10,$FB,$F5,$E4,$FD,$E6,$08,$F7,$F4,$FD,$01
table_01_97C6_9DEF:
.byte $03,$2B,$18,$F9,$F1,$E8,$F9,$EA,$01,$DE,$08,$FB,$EE,$FF,$01
table_01_97C6_9DFE:
.byte $03,$17,$08,$07,$FC,$C6,$18,$F7,$F4,$C0,$FC,$C2,$04,$C4,$08,$FB,$FD,$FD,$01
table_01_97C6_9E11:
.byte $03,$17,$08,$F1,$F9,$C8,$08,$F9,$01,$CA,$08,$01,$F9,$CC,$08,$F9,$FE,$FD,$01
table_01_97C6_9E24:
.byte $03,$17,$08,$F1,$F9,$CE,$08,$F9,$01,$D2,$08,$01,$F9,$D0,$08,$F8,$FD,$FD,$01
table_01_97C6_9E37:
.byte $03,$17,$08,$FB,$F9,$D4,$08,$F9,$01,$D6,$08,$FC,$F8,$FD,$01
table_01_97C6_9E46:
.byte $03,$17,$10,$F4,$F3,$D8,$02,$DC,$08,$F3,$FB,$DA,$08,$F1,$F8,$FD,$01
table_01_97C6_9E57:
.byte $03,$17,$18,$F8,$F1,$DE,$F9,$E0,$01,$E2,$08,$F9,$F8,$FD,$01
table_01_97C6_9E66:
.byte $03,$17,$08,$ED,$FF,$F0,$18,$FD,$F7,$E4,$FF,$E6,$07,$E8,$08,$F9,$FB,$FF,$01
table_01_97C6_9E79:
.byte $03,$17,$20,$F8,$F5,$EA,$FD,$EC,$05,$EE,$F9,$FF,$01
table_01_97C6_9E86:
.byte $03,$17,$18,$F8,$F1,$F2,$F9,$F4,$01,$F6,$08,$00,$09,$F8,$08,$F9,$F8,$FF,$01
table_01_97C6_9E99:
.byte $03,$31,$10,$F9,$F9,$40,$01,$42,$08,$FC,$FD,$7D,$01
table_01_97C6_9EA6:
.byte $03,$31,$10,$F9,$F9,$44,$01,$46,$08,$FC,$FD,$7D,$01
table_01_97C6_9EB3:
.byte $03,$31,$10,$F9,$FD,$48,$FC,$7F,$01
table_01_97C6_9EBC:
.byte $03,$31,$10,$F9,$F9,$4C,$01,$4E,$08,$F8,$FE,$7D,$01
table_01_97C6_9EC9:
.byte $03,$31,$18,$F9,$F9,$50,$01,$52,$FA,$7D,$01
table_01_97C6_9ED4:
.byte $03,$31,$10,$F9,$F9,$54,$01,$56,$08,$FA,$F8,$7F,$01
table_01_97C6_9EE1:
.byte $03,$31,$18,$F9,$F9,$58,$01,$5A,$FD,$7D,$01
table_01_97C6_9EEC:
.byte $03,$31,$18,$F9,$F9,$5C,$01,$5E,$FD,$7D,$01
table_01_97C6_9EF7:
.byte $03,$31,$10,$F9,$F9,$60,$01,$62,$08,$FB,$FC,$7D,$01
table_01_97C6_9F04:
.byte $03,$31,$10,$F9,$F9,$64,$01,$66,$08,$FB,$FC,$7D,$01
table_01_97C6_9F11:
.byte $03,$31,$10,$F9,$F9,$68,$01,$6A,$08,$FC,$FC,$7D,$01
table_01_97C6_9F1E:
.byte $03,$31,$10,$F9,$F9,$6C,$01,$6E,$08,$FB,$FC,$7D,$01
table_01_97C6_9F2B:
.byte $03,$31,$18,$F9,$F9,$70,$01,$72,$FA,$7F,$01
table_01_97C6_9F36:
.byte $03,$31,$10,$F9,$FC,$4A,$F9,$7F,$01
table_01_97C6_9F3F:
.byte $03,$35,$08,$F7,$F8,$40,$08,$F9,$00,$42,$08,$F8,$FD,$7D,$01
table_01_97C6_9F4E:
.byte $03,$35,$10,$F8,$F8,$44,$00,$46,$08,$FB,$FD,$7D,$01
table_01_97C6_9F5B:
.byte $03,$35,$08,$EC,$00,$4A,$08,$F2,$F8,$48,$08,$F0,$FD,$7D,$01
table_01_97C6_9F6A:
.byte $03,$39,$10,$F2,$F8,$60,$00,$62,$08,$F3,$FD,$7D,$01
table_01_97C6_9F77:
.byte $03,$35,$18,$FA,$F2,$4C,$FA,$4E,$02,$50,$08,$FB,$FB,$7D,$01
table_01_97C6_9F86:
.byte $03,$35,$10,$FA,$FB,$58,$03,$5A,$08,$FC,$FE,$7D,$01
table_01_97C6_9F93:
.byte $03,$35,$08,$F0,$F6,$52,$08,$F8,$FE,$56,$08,$00,$F6,$54,$08,$FA,$F8,$7D,$01
table_01_97C6_9FA6:
.byte $03,$39,$10,$F9,$F9,$64,$01,$66,$08,$FA,$FE,$7D,$01
table_01_97C6_9FB3:
.byte $03,$35,$18,$F8,$F1,$60,$F9,$62,$01,$64,$08,$F9,$F8,$7F,$01
table_01_97C6_9FC2:
.byte $03,$35,$10,$F8,$F9,$5C,$01,$5E,$08,$F9,$FC,$7F,$01
table_01_97C6_9FCF:
.byte $03,$35,$18,$F8,$ED,$66,$F5,$68,$FD,$6A,$08,$F9,$F3,$7F,$01
table_01_97C6_9FDE:
.byte $03,$39,$10,$F8,$F9,$68,$01,$6A,$08,$F9,$FA,$7F,$01
table_01_97C6_9FEB:
.byte $03,$3D,$10,$F9,$F9,$70,$01,$72,$08,$FE,$FD,$7D,$01
table_01_97C6_9FF8:
.byte $03,$3D,$10,$F9,$F9,$74,$01,$76,$08,$FD,$FE,$7D,$01
table_01_97C6_A005:
.byte $03,$3D,$18,$F9,$F9,$78,$01,$7A,$FE,$7F,$01
table_01_97C6_A010:
.byte $03,$3D,$10,$F9,$F9,$40,$01,$42,$08,$F8,$FC,$7D,$01
table_01_97C6_A01D:
.byte $03,$3D,$18,$F9,$F9,$44,$01,$46,$FC,$7D,$01
table_01_97C6_A028:
.byte $03,$3D,$10,$F9,$F9,$48,$01,$4A,$08,$FB,$F8,$7D,$01
table_01_97C6_A035:
.byte $03,$3D,$10,$F9,$F9,$4C,$01,$4E,$08,$FB,$F9,$7D,$01
table_01_97C6_A042:
.byte $03,$3D,$10,$F9,$F9,$50,$01,$52,$08,$F8,$F8,$7F,$01
table_01_97C6_A04F:
.byte $03,$3D,$10,$F9,$F9,$54,$01,$56,$08,$F8,$F9,$7F,$01
table_01_97C6_A05C:
.byte $03,$3D,$10,$F9,$F9,$64,$01,$66,$08,$FF,$FE,$7D,$01
table_01_97C6_A069:
.byte $03,$3D,$10,$F9,$F9,$68,$01,$6A,$08,$FF,$FF,$7D,$01
table_01_97C6_A076:
.byte $03,$3D,$10,$F9,$F9,$6C,$01,$6E,$08,$FA,$FF,$7F,$01
table_01_97C6_A083:
.byte $03,$41,$20,$F9,$F1,$40,$F9,$42,$01,$44,$09,$46,$08,$FA,$F5,$7F,$01
table_01_97C6_A094:
.byte $03,$41,$20,$F9,$F1,$50,$F9,$52,$01,$54,$09,$56,$08,$F8,$F9,$7F,$01
table_01_97C6_A0A5:
.byte $03,$41,$20,$F9,$F1,$48,$F9,$4A,$01,$4C,$09,$4E,$08,$F6,$F6,$7F,$01
table_01_97C6_A0B6:
.byte $03,$45,$18,$F9,$F1,$40,$F9,$42,$01,$44,$08,$FA,$F2,$7D,$01
table_01_97C6_A0C5:
.byte $03,$45,$10,$F9,$F9,$48,$01,$4A,$08,$F8,$F9,$7D,$01
table_01_97C6_A0D2:
.byte $03,$3D,$10,$F9,$F9,$70,$01,$72,$08,$FE,$FD,$7D,$01
table_01_97C6_A0DF:
.byte $03,$41,$10,$F1,$F3,$60,$FB,$62,$10,$01,$F3,$68,$FB,$6A,$08,$F5,$FB,$7F,$01
table_01_97C6_A0F2:
.byte $03,$41,$10,$F1,$F9,$64,$01,$66,$10,$01,$F1,$6C,$F9,$6E,$08,$F9,$FD,$7D,$01
table_01_97C6_A105:
.byte $03,$41,$08,$EF,$F6,$5C,$08,$F6,$FE,$5E,$10,$FE,$EF,$58,$F6,$5A,$08,$F8,$F9,$7D,$01
table_01_97C6_A11A:
.byte $03,$45,$08,$FD,$F9,$60,$10,$F9,$01,$62,$FB,$7D,$01
table_01_97C6_A127:
.byte $03,$45,$18,$F9,$F9,$4C,$01,$4E,$F8,$7D,$01
table_01_97C6_A132:
.byte $03,$3D,$10,$F9,$F9,$74,$01,$76,$08,$FD,$FE,$7D,$01
table_01_97C6_A13F:
.byte $03,$49,$20,$F9,$F1,$40,$F9,$42,$01,$44,$09,$46,$08,$F7,$F8,$7F,$01
table_01_97C6_A150:
.byte $03,$49,$08,$F2,$01,$4C,$18,$FA,$F1,$48,$F9,$4A,$F5,$7F,$01
table_01_97C6_A15F:
.byte $03,$49,$20,$F9,$F1,$50,$F9,$52,$01,$54,$09,$56,$08,$FC,$F9,$7F,$01
table_01_97C6_A170:
.byte $03,$49,$20,$F9,$F1,$4E,$F9,$58,$01,$5A,$09,$5C,$08,$FE,$F5,$7F,$01
table_01_97C6_A181:
.byte $03,$49,$10,$F1,$FD,$62,$05,$5E,$08,$F9,$F5,$60,$08,$F2,$01,$7F,$01
table_01_97C6_A192:
.byte $03,$49,$20,$F1,$F1,$64,$F9,$66,$01,$68,$09,$6A,$08,$F0,$07,$7F,$01
table_01_97C6_A1A3:
.byte $03,$49,$20,$F1,$F1,$70,$F9,$72,$01,$74,$09,$76,$08,$F3,$02,$7F,$01
table_01_97C6_A1B4:
.byte $03,$49,$20,$F1,$F1,$6C,$F9,$6E,$01,$78,$09,$7A,$08,$F3,$04,$7F,$01
table_01_97C6_A1C5:
.byte $03,$45,$18,$F1,$F9,$46,$01,$50,$08,$52,$08,$F2,$08,$7D,$01
table_01_97C6_A1D4:
.byte $03,$45,$10,$F1,$F9,$54,$01,$56,$08,$F3,$FE,$7D,$01
table_01_97C6_A1E1:
.byte $03,$3D,$10,$F9,$F9,$74,$01,$76,$08,$FD,$FE,$7D,$01
table_01_97C6_A1EE:
.byte $03,$4D,$10,$F0,$F9,$40,$01,$42,$10,$00,$F1,$48,$F9,$4A,$08,$01,$F6,$7D,$01
table_01_97C6_A201:
.byte $03,$4D,$10,$F1,$F1,$44,$F9,$46,$10,$01,$F1,$4C,$F9,$4E,$08,$05,$F4,$7D,$01
table_01_97C6_A214:
.byte $03,$4D,$08,$F1,$F8,$50,$10,$01,$F1,$58,$F9,$5A,$08,$02,$F7,$7D,$01
table_01_97C6_A225:
.byte $03,$4D,$08,$F1,$F9,$52,$08,$01,$F8,$54,$08,$05,$F7,$7F,$01
table_01_97C6_A234:
.byte $03,$45,$08,$F1,$F8,$64,$10,$FF,$F1,$58,$F9,$5A,$08,$00,$F2,$7F,$01
table_01_97C6_A245:
.byte $03,$45,$18,$F8,$F1,$5C,$F9,$5E,$F2,$7F,$01
table_01_97C6_A250:
.byte $03,$3D,$10,$F8,$F9,$74,$01,$76,$08,$FC,$FD,$7D,$01
table_01_97C6_A25D:
.byte $03,$4D,$08,$F1,$FA,$56,$10,$01,$F9,$5C,$01,$5E,$08,$F8,$FB,$7D,$01
table_01_97C6_A26E:
.byte $03,$4D,$08,$E9,$FC,$64,$10,$F9,$F4,$60,$FC,$62,$08,$F5,$FE,$7D,$01
table_01_97C6_A27F:
.byte $03,$4D,$10,$ED,$F9,$68,$01,$6A,$08,$FD,$F9,$66,$08,$F1,$00,$7D,$01
table_01_97C6_A290:
.byte $03,$4D,$08,$FD,$F9,$6C,$08,$01,$01,$6E,$08,$F1,$01,$70,$08,$F5,$02,$7D,$01
table_01_97C6_A2A3:
.byte $01
table_01_97C6_A2A4:
.byte $01
table_01_97C6_A2A5:
.byte $01
table_01_97C6_A2A6:
.byte $01
table_01_97C6_A2A7:
.byte $01
table_01_97C6_A2A8:
.byte $01
table_01_97C6_A2A9:
.byte $01
table_01_97C6_A2AA:
.byte $01
table_01_97C6_A2AB:
.byte $01
table_01_97C6_A2AC:
.byte $01
table_01_97C6_A2AD:
.byte $01
table_01_97C6_A2AE:
.byte $01
table_01_97C6_A2AF:
.byte $01
table_01_97C6_A2B0:
.byte $01
table_01_97C6_A2B1:
.byte $01
table_01_97C6_A2B2:
.byte $01
table_01_97C6_A2B3:
.byte $01
table_01_97C6_A2B4:
.byte $01
table_01_97C6_A2B5:
.byte $01
table_01_97C6_A2B6:
.byte $01
table_01_97C6_A2B7:
.byte $01
table_01_97C6_A2B8:
.byte $01
table_01_97C6_A2B9:
.byte $01
table_01_97C6_A2BA:
.byte $01
table_01_97C6_A2BB:
.byte $01
table_01_97C6_A2BC:
.byte $01
table_01_97C6_A2BD:
.byte $01
table_01_97C6_A2BE:
.byte $01
table_01_97C6_A2BF:
.byte $01
table_01_97C6_A2C0:
.byte $01
table_01_97C6_A2C1:
.byte $01
table_01_97C6_A2C2:
.byte $01
table_01_97C6_A2C3:
.byte $01
table_01_97C6_A2C4:
.byte $01
table_01_97C6_A2C5:
.byte $01
table_01_97C6_A2C6:
.byte $03,$10,$08,$F8,$FC,$1B,$01
table_01_97C6_A2CD:
.byte $03,$B7,$10,$ED,$F9,$F0,$01,$F2,$08,$FD,$F9,$DE,$08,$EF,$FD,$FD,$01
table_01_97C6_A2DE:
.byte $03,$BB,$10,$F9,$F9,$F0,$01,$F2,$08,$FB,$FC,$FD,$01
table_01_97C6_A2EB:
.byte $03,$B7,$08,$ED,$F5,$F4,$08,$F5,$FD,$F6,$08,$FD,$F5,$EC,$08,$F1,$F9,$FD,$01
table_01_97C6_A2FE:
.byte $03,$BB,$10,$F7,$F7,$F4,$FF,$F6,$08,$F9,$FA,$FD,$01
table_01_97C6_A30B:
.byte $03,$B7,$20,$F9,$ED,$F8,$F5,$FA,$FD,$EE,$EF,$FF,$01
table_01_97C6_A318:
.byte $03,$BB,$10,$F9,$F9,$F8,$01,$FA,$08,$FA,$FB,$FF,$01
table_01_97C6_A325:
.byte $01
table_01_97C6_A326:
.byte $10,$F1,$E9,$82,$F1,$84,$08,$F0,$ED,$81,$10,$01,$E8,$8A,$F0,$8C,$28,$11,$E1,$86,$E1,$93,$E9,$90,$F1,$88,$F1,$95,$18,$21,$E1,$4D,$E9,$51,$F1,$4F,$01
table_01_97C6_A34B:
.byte $10,$F1,$F1,$8E,$F9,$98,$08,$F0,$F7,$81,$08,$F9,$01,$96,$18,$01,$F1,$9A,$F1,$9F,$F9,$9C,$18,$11,$F1,$A0,$F1,$A5,$F9,$A2,$18,$21,$F1,$4D,$F9,$51,$01,$4F,$01
table_01_97C6_A372:
.byte $20,$F1,$F2,$A6,$FA,$B0,$02,$B2,$0A,$B4,$08,$F0,$02,$81,$18,$01,$F9,$A8,$01,$AA,$09,$AC,$30,$11,$F1,$AE,$F1,$B7,$F9,$B8,$01,$BA,$09,$BC,$09,$BF,$18,$21,$F9,$4D,$01,$51,$09,$4F,$01
table_01_97C6_A39F:
.byte $28,$F1,$F1,$C0,$F9,$C2,$F9,$81,$01,$C4,$09,$C6,$20,$01,$F9,$CA,$01,$CC,$09,$CE,$F7,$C9,$18,$11,$01,$D0,$09,$D2,$09,$D5,$18,$21,$F9,$4D,$01,$51,$09,$4F,$01
table_01_97C6_A3C6:
.byte $10,$F1,$FE,$D8,$FE,$D7,$18,$F9,$F6,$DA,$FE,$DC,$06,$DE,$30,$08,$F1,$E0,$F1,$E9,$F9,$E2,$01,$E4,$09,$E6,$09,$EB,$01
table_01_97C6_A3E3:
.byte $20,$F1,$E9,$F0,$F1,$F2,$F9,$F4,$01,$F6,$28,$01,$F1,$EC,$F9,$EE,$01,$F8,$09,$FA,$09,$FD,$08,$F4,$F2,$D7,$01
table_01_97C6_A3FE:
.byte $38,$F1,$E9,$40,$E9,$FF,$F1,$42,$F9,$44,$01,$46,$09,$48,$09,$4B,$28,$01,$E9,$4D,$F1,$51,$F9,$51,$01,$51,$09,$4F,$01
table_01_97C6_A41B:
.byte $20,$00,$F1,$4D,$F9,$51,$01,$51,$09,$4F,$01
table_01_97C6_A426:
.byte $18,$E9,$F9,$52,$00,$54,$00,$57,$18,$F9,$F8,$58,$00,$5A,$08,$5C,$30,$09,$F1,$E0,$F9,$E2,$01,$E4,$09,$E6,$F1,$E9,$09,$EB,$01
table_01_97C6_A445:
.byte $01

table_01_A446:
.word table_01_A46A_A46A
.word table_01_A46A_A473
.word table_01_A46A_A47F
.word table_01_A46A_A48C
.word table_01_A46A_A499
.word table_01_A46A_A4AC
.word table_01_A46A_A4B9
.word table_01_A46A_A4C6
.word table_01_A46A_A4D2
.word table_01_A46A_A4DB
.word table_01_A46A_A4E4
.word table_01_A46A_A4F0
.word table_01_A46A_A4FD
.word table_01_A46A_A50A
.word table_01_A46A_A51D
.word table_01_A46A_A52A
.word table_01_A46A_A537
.word table_01_A46A_A543

; table_01_A46A
; первый байт - количество чтения байтов после 3го
; 2й и 3й байты - видимо координаты PPU
; байт 00 - завершить чтение таблицы
table_01_A46A_A46A:
.byte $01,$59,$22, 	$40
.byte $01,$79,$22, 	$42
.byte $00
table_01_A46A_A473:
.byte $01,$3A,$22, 	$43
.byte $04,$59,$22, 	$41,$44,$45,$4F
.byte $00
table_01_A46A_A47F:
.byte $02,$3B,$22, 	$48,$49
.byte $04,$5A,$22, 	$4A,$4B,$4E,$4F
.byte $00
table_01_A46A_A48C:
.byte $02,$3D,$22, 	$48,$49
.byte $04,$5C,$22, 	$4A,$4B,$4E,$4F
.byte $00
table_01_A46A_A499:
.byte $01,$3F,$22, 	$48
.byte $01,$20,$26, 	$49
.byte $02,$5E,$22, 	$4F,$4B
.byte $02,$40,$26, 	$4E,$4F
.byte $00
table_01_A46A_A4AC:
.byte $02,$21,$26, 	$48,$49
.byte $04,$40,$26, 	$4F,$4B,$4E,$4F
.byte $00
table_01_A46A_A4B9:
.byte $02,$23,$26, 	$48,$49
.byte $04,$42,$26, 	$4F,$4B,$4E,$4F
.byte $00
table_01_A46A_A4C6:
.byte $01,$25,$26, 	$43
.byte $04,$43,$26, 	$4F,$51,$54,$55
.byte $00
table_01_A46A_A4D2:
.byte $01,$46,$26, 	$56
.byte $01,$66,$26, 	$57
.byte $00
table_01_A46A_A4DB:
.byte $01,$59,$22, 	$42
.byte $01,$79,$22, 	$40
.byte $00
table_01_A46A_A4E4:
.byte $04,$79,$22, 	$41,$44,$45,$4F
.byte $01,$9A,$22, 	$43
.byte $00
table_01_A46A_A4F0:
.byte $04,$7A,$22, 	$4A,$4B,$4E,$4F
.byte $02,$9B,$22, 	$48,$49
.byte $00
table_01_A46A_A4FD:
.byte $04,$7C,$22, 	$4F,$4B,$4E,$4F
.byte $02,$9D,$22, 	$48,$49
.byte $00
table_01_A46A_A50A:
.byte $02,$7E,$22, 	$4F,$4B
.byte $02,$60,$26, 	$4E,$4F
.byte $01,$9F,$22, 	$48
.byte $01,$80,$26, 	$49
.byte $00
table_01_A46A_A51D:
.byte $04,$60,$26, 	$4F,$4B,$4E,$4F
.byte $02,$81,$26, 	$48,$49
.byte $00
table_01_A46A_A52A:
.byte $04,$62,$26, 	$4F,$4B,$4E,$50
.byte $02,$83,$26, 	$48,$49
.byte $00
table_01_A46A_A537:
.byte $04,$63,$26, 	$4F,$51,$54,$55
.byte $01,$85,$26, 	$43
.byte $00
table_01_A46A_A543:
.byte $01,$46,$26, 	$57
.byte $01,$66,$26, 	$56
.byte $00

table_01_A54C:		; графика ворот для нижнего игрока
					; первый байт - количество считываний, 2й и 3й - адреса PPU
					; байты = номер тайла
.byte $08,$58,$22,$00,$94,$B2,$B3,$B3,$B3,$B3,$B3
.byte $08,$78,$22,$02,$96,$8A,$8B,$8B,$8B,$8E,$8F
.byte $08,$98,$22,$09,$09,$09,$09,$09,$09,$09,$09
.byte $08,$40,$26,$B3,$B3,$B3,$B3,$B3,$B6,$95,$00
.byte $08,$60,$26,$9A,$9B,$9E,$9E,$9E,$9F,$97,$02
.byte $08,$80,$26,$09,$09,$09,$09,$09,$09,$09,$09
.byte $00

table_01_A58F:		; графика ворот для верхнего игрока
.byte $08,$38,$22,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
.byte $08,$58,$22,$02,$90,$88,$89,$89,$89,$8C,$8D
.byte $08,$78,$22,$00,$92,$B0,$B1,$B1,$B1,$B1,$B1
.byte $08,$20,$26,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
.byte $08,$40,$26,$98,$99,$9C,$9C,$9C,$9D,$91,$02
.byte $08,$60,$26,$B1,$B1,$B1,$B1,$B1,$B4,$93,$00
.byte $00

table_01_A5D2:		; считывается в зависимости от первой или второй команды
					; что-то связанное с поведением в зависимости от зоны 0427
					; в каждой таблице по 1600 байтов (40 зон * 40 байтов)
.word table_01_A5D2_A602
.word table_01_A5D2_AC42

table_01_A5D6:
.byte $00,$00		; кипер снизу, не считывается
.byte $60,$70
.byte $60,$75
.byte $60,$5E
.byte $60,$7D
.byte $60,$5B
.byte $60,$45
.byte $60,$62
.byte $60,$36
.byte $60,$4C
.byte $60,$3C
.byte $00,$00		; кипер сверху, не считывается
.byte $60,$70
.byte $60,$75
.byte $60,$5E
.byte $60,$7D
.byte $60,$51
.byte $60,$45
.byte $60,$59
.byte $60,$40
.byte $60,$4A
.byte $60,$3C

table_01_A5D2_A602:
; в зависимости от первого байта считываются байты из table_01_8933 для непрямого прыжка
	; этот байт делится на 16, чтобы обрезать младшие 4 бита, а потом умножается на 2
	; за что отвечают младшие 4 бита пока не известно, читаются в 8968 и умножаются на 2
; второй байт влияет на параметр игрока 0433
; в зависимости от рандома читается либо первые 2 байта, либо вторые
; вратари не входят в этот список, байты только для полевых игроков
.byte $20,$47, 	$20,$47	; зона 00
.byte $20,$4F, 	$20,$4F
.byte $20,$4A, 	$20,$4A
.byte $20,$5F, 	$20,$5F
.byte $20,$1F, 	$20,$1F
.byte $20,$12, 	$20,$13
.byte $20,$18, 	$20,$18
.byte $20,$17, 	$20,$17
.byte $20,$0F, 	$20,$10
.byte $20,$0C, 	$20,$16
.byte $20,$47, 	$20,$47	; зона 01
.byte $20,$4F, 	$20,$4F
.byte $20,$4A, 	$20,$4A
.byte $20,$5F, 	$20,$5F
.byte $20,$21, 	$20,$21
.byte $20,$12, 	$20,$13
.byte $20,$18, 	$20,$18
.byte $20,$17, 	$20,$17
.byte $20,$0F, 	$20,$10
.byte $20,$0B, 	$20,$0B
.byte $20,$47, 	$20,$47	; зона 02
.byte $20,$4E, 	$20,$4E
.byte $20,$4A, 	$20,$4A
.byte $20,$5F, 	$20,$5F
.byte $20,$21, 	$20,$2A
.byte $20,$12, 	$20,$12
.byte $20,$1A, 	$20,$1A
.byte $20,$17, 	$20,$17
.byte $30,$0B, 	$30,$0B
.byte $20,$0B, 	$20,$0B
.byte $20,$47, 	$20,$47	; зона 03
.byte $20,$4F, 	$20,$4F
.byte $20,$4B, 	$20,$4B
.byte $20,$5F, 	$20,$5F
.byte $20,$18, 	$20,$2B
.byte $33,$40, 	$33,$40
.byte $20,$1B, 	$20,$1B
.byte $20,$17, 	$20,$17
.byte $20,$0F, 	$20,$0F
.byte $20,$0B, 	$20,$0B
.byte $20,$33, 	$20,$47	; зона 04
.byte $20,$4F, 	$20,$4F
.byte $20,$4C, 	$20,$4C
.byte $20,$5E, 	$20,$5E
.byte $20,$23, 	$20,$2B
.byte $36,$00, 	$36,$00
.byte $20,$1B, 	$20,$1B
.byte $20,$17, 	$20,$17
.byte $20,$10, 	$20,$10
.byte $20,$0C, 	$20,$0C
.byte $20,$51, 	$20,$51	; зона 05
.byte $20,$4D, 	$20,$4D
.byte $20,$4A, 	$20,$4A
.byte $20,$67, 	$20,$47
.byte $20,$2A, 	$20,$2A
.byte $20,$1D, 	$20,$1D
.byte $20,$2E, 	$20,$2E
.byte $20,$18, 	$20,$18
.byte $20,$19, 	$20,$19
.byte $30,$18, 	$30,$18
.byte $20,$51, 	$20,$51	; зона 06
.byte $20,$4E, 	$20,$4E
.byte $20,$4B, 	$20,$4B
.byte $20,$68, 	$20,$68
.byte $20,$2A, 	$20,$2A
.byte $20,$1D, 	$20,$1D
.byte $20,$2E, 	$20,$2E
.byte $20,$0D, 	$20,$0D
.byte $33,$C0, 	$33,$C0
.byte $20,$0B, 	$20,$0B
.byte $20,$51, 	$20,$51	; зона 07
.byte $20,$4E, 	$20,$4E
.byte $20,$4B, 	$20,$4B
.byte $20,$68, 	$20,$68
.byte $20,$20, 	$20,$20
.byte $20,$1D, 	$20,$1D
.byte $20,$2E, 	$20,$2E
.byte $20,$18, 	$20,$18
.byte $20,$19, 	$20,$19
.byte $20,$0B, 	$20,$0B
.byte $20,$33, 	$20,$48	; зона 08
.byte $20,$4E, 	$20,$4E
.byte $20,$4B, 	$20,$4B
.byte $20,$5F, 	$20,$5F
.byte $36,$00, 	$36,$00
.byte $20,$1D, 	$20,$1D
.byte $20,$25, 	$20,$25
.byte $20,$0D, 	$20,$0D
.byte $20,$0F, 	$20,$0F
.byte $20,$0B, 	$20,$0B
.byte $20,$48, 	$20,$48	; зона 09
.byte $20,$58, 	$20,$58
.byte $20,$4C, 	$20,$4C
.byte $20,$5F, 	$20,$5F
.byte $20,$22, 	$20,$22
.byte $20,$13, 	$20,$13
.byte $20,$25, 	$20,$25
.byte $20,$18, 	$20,$18
.byte $20,$19, 	$20,$19
.byte $20,$0B, 	$20,$0B
.byte $20,$5A, 	$20,$5A	; зона 0A
.byte $20,$57, 	$20,$57
.byte $20,$53, 	$20,$53
.byte $20,$68, 	$20,$68
.byte $20,$2A, 	$20,$2A
.byte $20,$12, 	$20,$12
.byte $20,$2E, 	$20,$2E
.byte $20,$0E, 	$20,$0E
.byte $20,$19, 	$20,$19
.byte $20,$0B, 	$20,$0B
.byte $20,$5B, 	$10,$00	; зона 0B
.byte $20,$57, 	$10,$00
.byte $20,$53, 	$10,$00
.byte $20,$68, 	$10,$00
.byte $20,$29, 	$20,$29
.byte $20,$13, 	$20,$13
.byte $20,$2D, 	$20,$2D
.byte $20,$0E, 	$20,$0E
.byte $20,$10, 	$20,$10
.byte $20,$0B, 	$20,$0B
.byte $20,$51, 	$20,$51	; зона 0C
.byte $20,$58, 	$20,$58
.byte $20,$4A, 	$20,$4A
.byte $20,$69, 	$20,$69
.byte $20,$17, 	$20,$20
.byte $20,$12, 	$20,$12
.byte $20,$1A, 	$20,$25
.byte $20,$0E, 	$20,$0E
.byte $20,$0F, 	$20,$0F
.byte $20,$0B, 	$20,$0B
.byte $20,$51, 	$10,$00	; зона 0D
.byte $20,$62, 	$10,$00
.byte $20,$43, 	$20,$4B
.byte $20,$69, 	$10,$00
.byte $20,$21, 	$20,$36
.byte $20,$13, 	$20,$13
.byte $20,$1B, 	$20,$1B
.byte $20,$0D, 	$20,$0D
.byte $20,$19, 	$20,$19
.byte $20,$15, 	$20,$15
.byte $20,$52, 	$20,$52	; зона 0E
.byte $20,$59, 	$20,$59
.byte $20,$41, 	$20,$56
.byte $20,$73, 	$20,$73
.byte $20,$2A, 	$20,$2C
.byte $20,$13, 	$20,$13
.byte $20,$1B, 	$20,$1B
.byte $20,$0E, 	$20,$0E
.byte $20,$19, 	$20,$19
.byte $20,$15, 	$20,$15
.byte $20,$6E, 	$10,$00	; зона 0F
.byte $20,$61, 	$10,$00
.byte $20,$52, 	$10,$00
.byte $20,$71, 	$10,$00
.byte $20,$29, 	$20,$29
.byte $20,$26, 	$20,$26
.byte $20,$36, 	$20,$42
.byte $20,$17, 	$20,$17
.byte $20,$22, 	$20,$22
.byte $20,$14, 	$20,$24
.byte $20,$6F, 	$10,$00	; зона 10
.byte $20,$76, 	$10,$00
.byte $20,$53, 	$20,$56
.byte $20,$72, 	$10,$00
.byte $20,$3D, 	$20,$3D
.byte $20,$26, 	$20,$26
.byte $20,$44, 	$20,$44
.byte $20,$18, 	$20,$18
.byte $20,$36, 	$20,$36
.byte $20,$15, 	$20,$15
.byte $20,$6F, 	$10,$00	; зона 11
.byte $20,$76, 	$10,$00
.byte $20,$54, 	$10,$00
.byte $20,$72, 	$10,$00
.byte $20,$2A, 	$20,$3D
.byte $20,$26, 	$20,$26
.byte $20,$39, 	$20,$45
.byte $20,$19, 	$20,$19
.byte $20,$36, 	$20,$36
.byte $20,$15, 	$20,$15
.byte $20,$6F, 	$10,$00	; зона 12
.byte $20,$76, 	$10,$00
.byte $20,$54, 	$10,$00
.byte $20,$73, 	$10,$00
.byte $20,$33, 	$20,$3F
.byte $20,$27, 	$20,$27
.byte $20,$44, 	$20,$44
.byte $20,$1A, 	$20,$1A
.byte $20,$2C, 	$20,$2C
.byte $20,$16, 	$20,$16
.byte $20,$65, 	$10,$00	; зона 13
.byte $20,$6D, 	$10,$00
.byte $20,$5E, 	$10,$00
.byte $20,$74, 	$10,$00
.byte $20,$3D, 	$20,$3D
.byte $20,$27, 	$20,$27
.byte $20,$44, 	$20,$44
.byte $20,$1A, 	$20,$1A
.byte $20,$41, 	$20,$41
.byte $20,$16, 	$20,$16
.byte $20,$64, 	$10,$00	; зона 14
.byte $20,$80, 	$10,$00
.byte $20,$67, 	$10,$00
.byte $20,$84, 	$10,$00
.byte $20,$51, 	$20,$51
.byte $20,$30, 	$20,$30
.byte $20,$57, 	$20,$6B
.byte $20,$21, 	$20,$21
.byte $20,$3F, 	$20,$55
.byte $20,$28, 	$20,$28
.byte $20,$6F, 	$10,$00	; зона 15
.byte $20,$80, 	$10,$00
.byte $20,$67, 	$10,$00
.byte $20,$85, 	$10,$00
.byte $20,$47, 	$20,$47
.byte $20,$30, 	$20,$30
.byte $20,$58, 	$20,$58
.byte $20,$22, 	$20,$22
.byte $20,$4B, 	$20,$4B
.byte $20,$28, 	$20,$28
.byte $20,$79, 	$10,$00	; зона 16
.byte $20,$80, 	$10,$00
.byte $20,$68, 	$10,$00
.byte $20,$86, 	$10,$00
.byte $20,$52, 	$20,$52
.byte $20,$30, 	$20,$30
.byte $20,$57, 	$20,$57
.byte $20,$22, 	$20,$22
.byte $20,$37, 	$20,$37
.byte $20,$29, 	$20,$29
.byte $20,$70, 	$10,$00	; зона 17
.byte $20,$76, 	$10,$00
.byte $20,$69, 	$10,$00
.byte $20,$87, 	$10,$00
.byte $20,$52, 	$20,$52
.byte $20,$31, 	$20,$31
.byte $20,$4D, 	$20,$4D
.byte $20,$24, 	$20,$24
.byte $20,$4A, 	$20,$4A
.byte $20,$29, 	$20,$29
.byte $20,$6F, 	$10,$00	; зона 18
.byte $20,$81, 	$10,$00
.byte $20,$6A, 	$20,$72
.byte $20,$87, 	$10,$00
.byte $20,$50, 	$20,$50
.byte $20,$31, 	$20,$31
.byte $20,$58, 	$20,$58
.byte $20,$25, 	$20,$25
.byte $20,$4A, 	$20,$4A
.byte $20,$2A, 	$20,$2A
.byte $20,$64, 	$10,$00	; зона 19
.byte $20,$7F, 	$10,$00
.byte $20,$67, 	$20,$7C
.byte $20,$8E, 	$10,$00
.byte $20,$51, 	$20,$51
.byte $20,$3A, 	$20,$3A
.byte $20,$60, 	$20,$60
.byte $20,$2C, 	$20,$2C
.byte $20,$4A, 	$20,$4A
.byte $20,$28, 	$20,$28
.byte $20,$78, 	$10,$00	; зона 1A
.byte $20,$7F, 	$10,$00
.byte $20,$67, 	$10,$00
.byte $20,$85, 	$10,$00
.byte $20,$51, 	$20,$51
.byte $20,$3B, 	$20,$3B
.byte $20,$61, 	$20,$61
.byte $20,$2D, 	$20,$2D
.byte $20,$4A, 	$20,$4A
.byte $20,$28, 	$20,$28
.byte $20,$78, 	$10,$00	; зона 1B
.byte $20,$80, 	$10,$00
.byte $20,$68, 	$10,$00
.byte $20,$86, 	$10,$00
.byte $20,$52, 	$20,$52
.byte $20,$3B, 	$20,$3B
.byte $20,$57, 	$20,$57
.byte $20,$2D, 	$20,$2D
.byte $20,$4B, 	$20,$4B
.byte $20,$32, 	$20,$32
.byte $20,$79, 	$10,$00	; зона 1C
.byte $20,$6D, 	$10,$00
.byte $20,$6A, 	$10,$00
.byte $20,$87, 	$10,$00
.byte $20,$5C, 	$20,$5C
.byte $20,$3B, 	$20,$3B
.byte $20,$58, 	$20,$58
.byte $20,$38, 	$20,$38
.byte $20,$55, 	$20,$55
.byte $20,$32, 	$20,$32
.byte $20,$79, 	$10,$00	; зона 1D
.byte $20,$6C, 	$10,$00
.byte $20,$6A, 	$10,$00
.byte $20,$87, 	$10,$00
.byte $20,$5C, 	$20,$5C
.byte $20,$3B, 	$20,$3B
.byte $20,$58, 	$20,$58
.byte $20,$38, 	$20,$38
.byte $20,$55, 	$20,$55
.byte $20,$32, 	$20,$32
.byte $20,$78, 	$20,$78	; зона 1E
.byte $20,$74, 	$20,$7F
.byte $20,$71, 	$20,$7A
.byte $20,$7D, 	$20,$85
.byte $20,$48, 	$20,$5B
.byte $20,$45, 	$20,$62
.byte $20,$56, 	$20,$5F
.byte $20,$35, 	$20,$54
.byte $20,$42, 	$20,$5D
.byte $20,$46, 	$20,$46
.byte $20,$78, 	$20,$78	; зона 1F
.byte $20,$76, 	$20,$7F
.byte $20,$72, 	$20,$7B
.byte $20,$86, 	$20,$8F
.byte $20,$48, 	$20,$67
.byte $20,$3B, 	$20,$59
.byte $20,$57, 	$20,$6A
.byte $20,$36, 	$20,$36
.byte $20,$42, 	$20,$5F
.byte $20,$3C, 	$20,$51
.byte $20,$6E, 	$20,$83	; зона 20
.byte $20,$77, 	$20,$8A
.byte $20,$72, 	$20,$72
.byte $20,$7E, 	$20,$7E
.byte $20,$53, 	$20,$67
.byte $20,$4E, 	$20,$63
.byte $20,$56, 	$20,$6A
.byte $20,$38, 	$20,$38
.byte $20,$40, 	$20,$5E
.byte $20,$47, 	$20,$5A
.byte $20,$6E, 	$20,$7A	; зона 21
.byte $20,$77, 	$20,$77
.byte $20,$6A, 	$20,$73
.byte $20,$7D, 	$20,$7D
.byte $20,$53, 	$20,$66
.byte $20,$43, 	$20,$59
.byte $20,$56, 	$20,$56
.byte $20,$2E, 	$20,$4B
.byte $20,$3F, 	$20,$54
.byte $20,$3C, 	$20,$51
.byte $20,$67, 	$20,$67	; зона 22
.byte $20,$77, 	$20,$77
.byte $20,$60, 	$20,$6B
.byte $20,$7E, 	$20,$87
.byte $20,$53, 	$20,$5B
.byte $20,$3B, 	$20,$43
.byte $20,$4E, 	$20,$57
.byte $20,$2D, 	$20,$2D
.byte $20,$35, 	$20,$4B
.byte $20,$33, 	$20,$46
.byte $20,$78, 	$20,$8C	; зона 23
.byte $20,$7D, 	$20,$7D
.byte $20,$71, 	$20,$7A
.byte $33,$C0, 	$33,$C0
.byte $20,$5C, 	$20,$5C
.byte $20,$59, 	$20,$59
.byte $20,$74, 	$20,$7C
.byte $20,$47, 	$20,$4A
.byte $20,$56, 	$20,$5E
.byte $20,$50, 	$20,$50
.byte $20,$83, 	$20,$8D	; зона 24
.byte $20,$88, 	$20,$88
.byte $20,$7A, 	$20,$7B
.byte $20,$86, 	$20,$8F
.byte $20,$66, 	$20,$66
.byte $20,$63, 	$20,$63
.byte $20,$6B, 	$20,$73
.byte $20,$48, 	$20,$4A
.byte $20,$55, 	$20,$68
.byte $20,$5A, 	$20,$5A
.byte $20,$84, 	$20,$8F	; зона 25
.byte $20,$89, 	$20,$92
.byte $20,$7C, 	$20,$87
.byte $20,$73, 	$20,$7E
.byte $20,$6F, 	$20,$7A
.byte $20,$4F, 	$20,$4F
.byte $20,$6B, 	$20,$81
.byte $20,$4B, 	$20,$4B
.byte $20,$60, 	$20,$68
.byte $20,$5A, 	$20,$5A
.byte $20,$86, 	$20,$8F	; зона 26
.byte $30,$1B, 	$30,$1B
.byte $20,$73, 	$20,$7E
.byte $36,$00, 	$36,$00
.byte $20,$6F, 	$20,$7B
.byte $20,$63, 	$20,$63
.byte $20,$5F, 	$20,$6B
.byte $20,$4C, 	$20,$54
.byte $20,$52, 	$20,$67
.byte $20,$3A, 	$20,$3A
.byte $20,$84, 	$20,$86	; зона 27
.byte $20,$81, 	$20,$94
.byte $20,$76, 	$20,$7F
.byte $37,$C0, 	$37,$C0
.byte $20,$66, 	$20,$72
.byte $20,$71, 	$20,$7D
.byte $20,$59, 	$20,$59
.byte $20,$61, 	$20,$61
.byte $20,$4E, 	$20,$55
.byte $20,$50, 	$20,$50

table_01_A5D2_AC42:
.byte $20,$32, 	$20,$48	; зона 00
.byte $20,$30, 	$20,$4D
.byte $20,$35, 	$20,$41
.byte $20,$5E, 	$20,$66
.byte $20,$20, 	$20,$20
.byte $20,$12, 	$20,$12
.byte $20,$10, 	$20,$19
.byte $20,$03, 	$20,$03
.byte $20,$0D, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$29, 	$20,$48	; зона 01
.byte $20,$30, 	$20,$4D
.byte $20,$36, 	$20,$36
.byte $20,$54, 	$20,$54
.byte $20,$21, 	$20,$21
.byte $20,$12, 	$20,$12
.byte $20,$19, 	$20,$19
.byte $20,$10, 	$20,$10
.byte $20,$0D, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$29, 	$20,$48	; зона 02
.byte $20,$30, 	$20,$4D
.byte $20,$36, 	$20,$49
.byte $20,$55, 	$20,$6A
.byte $20,$20, 	$20,$2B
.byte $20,$07, 	$20,$12
.byte $20,$2D, 	$20,$3B
.byte $40,$00, 	$40,$00
.byte $20,$18, 	$40,$00
.byte $20,$04, 	$20,$04
.byte $20,$29, 	$20,$49	; зона 03
.byte $20,$31, 	$20,$44
.byte $20,$37, 	$20,$4A
.byte $20,$57, 	$20,$5F
.byte $20,$21, 	$20,$2C
.byte $32,$00, 	$32,$00
.byte $20,$24, 	$20,$24
.byte $40,$00, 	$40,$00
.byte $20,$0F, 	$40,$00
.byte $20,$0C, 	$20,$15
.byte $20,$29, 	$20,$48	; зона 04
.byte $20,$45, 	$20,$4D
.byte $20,$38, 	$20,$40
.byte $20,$5F, 	$20,$6B
.byte $20,$0D, 	$20,$17
.byte $40,$00, 	$40,$00
.byte $20,$25, 	$20,$25
.byte $20,$0D, 	$20,$0D
.byte $20,$10, 	$20,$10
.byte $20,$0B, 	$20,$0B
.byte $20,$46, 	$20,$48	; зона 05
.byte $20,$3A, 	$20,$4D
.byte $20,$40, 	$20,$4B
.byte $20,$5D, 	$20,$70
.byte $40,$00, 	$40,$00
.byte $20,$1C, 	$20,$1C
.byte $20,$10, 	$20,$19
.byte $20,$0F, 	$20,$0F
.byte $20,$0C, 	$20,$20
.byte $20,$0A, 	$40,$00
.byte $20,$33, 	$20,$48	; зона 06
.byte $20,$31, 	$20,$44
.byte $20,$38, 	$20,$41
.byte $20,$60, 	$20,$67
.byte $40,$00, 	$40,$00
.byte $20,$12, 	$20,$12
.byte $20,$06, 	$20,$06
.byte $20,$0F, 	$40,$00
.byte $20,$17, 	$20,$17
.byte $20,$0B, 	$20,$0B
.byte $20,$29, 	$20,$48	; зона 07
.byte $20,$30, 	$20,$4D
.byte $20,$40, 	$20,$49
.byte $20,$5F, 	$20,$6A
.byte $20,$20, 	$20,$35
.byte $20,$07, 	$20,$12
.byte $20,$2D, 	$20,$42
.byte $40,$00, 	$40,$00
.byte $20,$19, 	$40,$00
.byte $20,$02, 	$20,$0B
.byte $20,$28, 	$20,$3D	; зона 08
.byte $20,$3A, 	$20,$4D
.byte $20,$35, 	$20,$40
.byte $20,$5D, 	$20,$6A
.byte $20,$20, 	$20,$2C
.byte $20,$12, 	$40,$00
.byte $20,$2F, 	$20,$2F
.byte $40,$00, 	$40,$00
.byte $20,$19, 	$40,$00
.byte $20,$0B, 	$20,$0B
.byte $20,$33, 	$20,$48	; зона 09
.byte $20,$4D, 	$20,$4F
.byte $20,$55, 	$20,$5E
.byte $20,$60, 	$20,$75
.byte $20,$2C, 	$20,$4A
.byte $40,$00, 	$40,$00
.byte $20,$30, 	$20,$56
.byte $20,$0E, 	$20,$0E
.byte $20,$11, 	$40,$00
.byte $20,$0B, 	$20,$0B
.byte $20,$46, 	$20,$48	; зона 0A
.byte $20,$58, 	$20,$6A
.byte $20,$5B, 	$20,$5D
.byte $20,$70, 	$20,$7B
.byte $40,$00, 	$40,$00
.byte $20,$26, 	$20,$39
.byte $20,$2D, 	$20,$54
.byte $20,$19, 	$20,$22
.byte $20,$0C, 	$20,$20
.byte $20,$15, 	$20,$15
.byte $20,$3C, 	$20,$48	; зона 0B
.byte $20,$44, 	$20,$61
.byte $20,$54, 	$20,$67
.byte $20,$73, 	$20,$86
.byte $40,$00, 	$40,$00
.byte $20,$12, 	$20,$27
.byte $20,$2F, 	$20,$42
.byte $20,$0F, 	$20,$24
.byte $20,$2C, 	$20,$2D
.byte $20,$0C, 	$20,$1F
.byte $20,$3D, 	$20,$5D	; зона 0C
.byte $20,$45, 	$20,$61
.byte $20,$5F, 	$20,$68
.byte $20,$74, 	$20,$87
.byte $20,$3F, 	$20,$4A
.byte $20,$26, 	$20,$2F
.byte $20,$43, 	$20,$4C
.byte $40,$00, 	$40,$00
.byte $20,$37, 	$20,$37
.byte $20,$1F, 	$20,$2A
.byte $20,$3D, 	$20,$5C	; зона 0D
.byte $20,$45, 	$20,$62
.byte $20,$60, 	$20,$69
.byte $20,$72, 	$20,$88
.byte $20,$3F, 	$20,$54
.byte $20,$11, 	$20,$27
.byte $20,$44, 	$20,$4C
.byte $40,$00, 	$40,$00
.byte $20,$2D, 	$20,$2D
.byte $20,$20, 	$20,$34
.byte $20,$47, 	$20,$72	; зона 0E
.byte $20,$45, 	$20,$62
.byte $20,$60, 	$20,$69
.byte $20,$74, 	$20,$7D
.byte $20,$2C, 	$20,$54
.byte $40,$00, 	$40,$00
.byte $20,$43, 	$20,$4E
.byte $20,$17, 	$20,$17
.byte $20,$1B, 	$20,$24
.byte $20,$20, 	$20,$33
.byte $20,$64, 	$20,$66	; зона 0F
.byte $20,$76, 	$20,$88
.byte $20,$71, 	$20,$72
.byte $20,$85, 	$20,$85
.byte $40,$00, 	$40,$00
.byte $20,$3A, 	$20,$57
.byte $20,$38, 	$20,$5F
.byte $20,$2C, 	$20,$35
.byte $20,$4A, 	$20,$52
.byte $20,$32, 	$40,$00
.byte $20,$5B, 	$20,$66	; зона 10
.byte $20,$76, 	$20,$88
.byte $20,$69, 	$20,$72
.byte $20,$7B, 	$20,$86
.byte $40,$00, 	$40,$00
.byte $20,$31, 	$20,$4E
.byte $20,$39, 	$20,$61
.byte $20,$2A, 	$20,$2B
.byte $20,$41, 	$20,$4A
.byte $20,$33, 	$40,$00
.byte $20,$65, 	$20,$84	; зона 11
.byte $20,$6C, 	$20,$89
.byte $20,$72, 	$20,$7C
.byte $20,$87, 	$20,$87
.byte $20,$53, 	$20,$53
.byte $20,$44, 	$20,$4C
.byte $20,$40, 	$40,$00
.byte $20,$2D, 	$20,$2D
.byte $40,$00, 	$40,$00
.byte $20,$3D, 	$20,$49
.byte $20,$6F, 	$20,$85	; зона 12
.byte $20,$62, 	$20,$6B
.byte $20,$68, 	$20,$73
.byte $20,$7E, 	$20,$87
.byte $20,$34, 	$20,$5C
.byte $20,$3A, 	$20,$3A
.byte $20,$56, 	$40,$00
.byte $20,$2E, 	$20,$2F
.byte $40,$00, 	$40,$00
.byte $20,$28, 	$20,$47
.byte $20,$6F, 	$20,$85	; зона 13
.byte $20,$77, 	$20,$7F
.byte $20,$7D, 	$20,$7E
.byte $20,$8A, 	$20,$93
.byte $20,$35, 	$20,$5E
.byte $20,$3B, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$2C, 	$20,$38
.byte $20,$60, 	$20,$60
.byte $20,$33, 	$20,$52
.byte $20,$78, 	$40,$00	; зона 14
.byte $20,$75, 	$20,$88
.byte $20,$7C, 	$20,$7D
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $20,$4E, 	$20,$62
.byte $20,$6A, 	$20,$72
.byte $20,$40, 	$20,$49
.byte $20,$55, 	$20,$5E
.byte $40,$00, 	$40,$00
.byte $20,$79, 	$20,$7B	; зона 15
.byte $20,$6D, 	$20,$89
.byte $20,$7C, 	$20,$7D
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $20,$4E, 	$20,$56
.byte $20,$61, 	$20,$6B
.byte $20,$41, 	$20,$41
.byte $20,$54, 	$40,$00
.byte $20,$47, 	$20,$5A
.byte $20,$65, 	$20,$85	; зона 16
.byte $20,$76, 	$20,$88
.byte $20,$7C, 	$20,$7D
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $20,$4E, 	$20,$60
.byte $40,$00, 	$40,$00
.byte $20,$37, 	$20,$37
.byte $40,$00, 	$40,$00
.byte $20,$47, 	$20,$5D
.byte $20,$6E, 	$20,$8D	; зона 17
.byte $20,$6D, 	$20,$7F
.byte $20,$7C, 	$20,$7D
.byte $20,$86, 	$20,$87
.byte $20,$5B, 	$20,$66
.byte $20,$45, 	$20,$4E
.byte $20,$61, 	$40,$00
.byte $20,$38, 	$20,$40
.byte $40,$00, 	$40,$00
.byte $20,$3C, 	$20,$50
.byte $20,$6F, 	$20,$85	; зона 18
.byte $20,$76, 	$20,$77
.byte $20,$7C, 	$20,$7D
.byte $20,$86, 	$20,$87
.byte $20,$3F, 	$20,$68
.byte $20,$45, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$37, 	$20,$42
.byte $20,$57, 	$20,$60
.byte $20,$3D, 	$20,$52
.byte $20,$78, 	$10,$00	; зона 19
.byte $20,$87, 	$20,$87
.byte $20,$7C, 	$20,$7D
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $20,$58, 	$20,$61
.byte $20,$73, 	$20,$7C
.byte $20,$4B, 	$20,$4B
.byte $20,$5F, 	$20,$67
.byte $40,$00, 	$40,$00
.byte $20,$83, 	$10,$00	; зона 1A
.byte $20,$8A, 	$20,$92
.byte $20,$7C, 	$20,$7D
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $20,$57, 	$20,$6C
.byte $20,$74, 	$20,$7D
.byte $20,$4B, 	$20,$4B
.byte $20,$5E, 	$20,$5E
.byte $40,$00, 	$40,$00
.byte $20,$85, 	$20,$86	; зона 1B
.byte $20,$87, 	$20,$88
.byte $20,$7C, 	$20,$7D
.byte $20,$86, 	$20,$87
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $20,$86, 	$20,$87
.byte $20,$4A, 	$20,$4A
.byte $40,$00, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$85, 	$20,$86	; зона 1C
.byte $20,$80, 	$20,$88
.byte $20,$71, 	$20,$7C
.byte $20,$87, 	$10,$00
.byte $20,$53, 	$20,$68
.byte $40,$00, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$40, 	$20,$55
.byte $40,$00, 	$40,$00
.byte $20,$50, 	$20,$6F
.byte $20,$85, 	$20,$86	; зона 1D
.byte $20,$81, 	$40,$00
.byte $20,$88, 	$20,$88
.byte $20,$89, 	$10,$00
.byte $20,$72, 	$20,$7D
.byte $20,$4F, 	$20,$4F
.byte $40,$00, 	$40,$00
.byte $20,$42, 	$20,$57
.byte $20,$55, 	$20,$6A
.byte $20,$5B, 	$20,$70
.byte $40,$00, 	$40,$00	; зона 1E
.byte $20,$87, 	$20,$88
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$5B, 	$20,$6B
.byte $20,$7C, 	$20,$7D
.byte $20,$48, 	$20,$54
.byte $20,$72, 	$20,$73
.byte $20,$70, 	$20,$70
.byte $40,$00, 	$40,$00	; зона 1F
.byte $20,$87, 	$20,$88
.byte $20,$86, 	$20,$87
.byte $20,$84, 	$20,$85
.byte $40,$00, 	$40,$00
.byte $20,$75, 	$20,$75
.byte $20,$7D, 	$20,$7E
.byte $20,$52, 	$20,$52
.byte $20,$86, 	$20,$87
.byte $20,$7A, 	$20,$7A
.byte $20,$84, 	$20,$85	; зона 20
.byte $20,$87, 	$20,$88
.byte $40,$00, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$7A, 	$20,$84
.byte $20,$4F, 	$20,$76
.byte $20,$7F, 	$20,$89
.byte $20,$4A, 	$20,$4A
.byte $40,$00, 	$40,$00
.byte $20,$46, 	$20,$6F
.byte $20,$85, 	$20,$86	; зона 21
.byte $40,$00, 	$40,$00
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $20,$86, 	$20,$87
.byte $20,$57, 	$20,$57
.byte $40,$00, 	$40,$00
.byte $20,$4A, 	$20,$5F
.byte $20,$86, 	$20,$87
.byte $20,$52, 	$20,$65
.byte $20,$85, 	$20,$86	; зона 22
.byte $40,$00, 	$40,$00
.byte $20,$86, 	$20,$87
.byte $20,$87, 	$20,$88
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$54, 	$20,$55
.byte $20,$7C, 	$20,$7D
.byte $20,$51, 	$20,$6C
.byte $40,$00, 	$40,$00	; зона 23
.byte $20,$88, 	$20,$88
.byte $20,$86, 	$20,$87
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $20,$7F, 	$20,$80
.byte $20,$87, 	$20,$88
.byte $20,$56, 	$20,$56
.byte $20,$7C, 	$20,$7D
.byte $40,$00, 	$40,$00
.byte $40,$00, 	$40,$00	; зона 24
.byte $20,$87, 	$20,$88
.byte $20,$86, 	$20,$87
.byte $20,$86, 	$20,$87
.byte $40,$00, 	$40,$00
.byte $20,$7F, 	$20,$80
.byte $20,$87, 	$20,$88
.byte $20,$4C, 	$20,$4C
.byte $40,$00, 	$40,$00
.byte $20,$84, 	$20,$85
.byte $40,$00, 	$40,$00	; зона 25
.byte $40,$00, 	$40,$00
.byte $20,$86, 	$20,$87
.byte $30,$01, 	$30,$01
.byte $40,$00, 	$40,$00
.byte $20,$89, 	$20,$8A
.byte $40,$00, 	$40,$00
.byte $20,$4A, 	$20,$4B
.byte $20,$7C, 	$20,$7D
.byte $20,$84, 	$20,$85
.byte $20,$85, 	$20,$85	; зона 26
.byte $40,$00, 	$40,$00
.byte $20,$86, 	$20,$87
.byte $20,$86, 	$20,$87
.byte $20,$85, 	$20,$86
.byte $20,$80, 	$20,$8A
.byte $40,$00, 	$40,$00
.byte $20,$4C, 	$20,$4C
.byte $20,$86, 	$20,$87
.byte $20,$84, 	$20,$85
.byte $20,$85, 	$20,$86	; зона 27
.byte $40,$00, 	$40,$00
.byte $20,$86, 	$20,$87
.byte $20,$86, 	$20,$87
.byte $20,$85, 	$20,$86
.byte $40,$00, 	$40,$00
.byte $40,$00, 	$40,$00
.byte $20,$4C, 	$20,$4C
.byte $20,$86, 	$20,$87
.byte $20,$84, 	$20,$85

table_01_B282:		; в 8A3C эти байты являются началом таблицы
					; вместе с байтами из table_01_B28B
					; нужно быть аккуратнее при редактировании таблицы
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00

table_01_B28B:
; первый байт складывается с первым байтом второй строки из table_01_B357_
; затем проверяется на плюс и превышение #$10, иначе загрузка #$00 или #$0F
; после чего TAY и считывание из table_01_B347
; то есть код ожидает получить 00-0F
; аналогично со вторым байтом, но перед TAX он удваивается, затем читается из table_01_B327
; остальные байты не используются
.byte $00,$00,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07
.byte $07,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07
.byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$06
.byte $06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$06,$06
.byte $06,$06,$06,$06,$06,$06,$06,$07,$07,$06,$06,$06
.byte $06,$06,$06,$06,$06,$06,$07,$07,$06,$06,$06,$06
.byte $06,$06,$06,$06,$06,$07,$07,$06,$06,$06,$06,$06
.byte $06,$06,$06,$06,$07,$07,$06,$06,$06,$06,$06,$06
.byte $06,$06,$06,$07,$07,$06,$06,$06,$06,$06,$06,$06
.byte $06,$06,$07,$07,$06,$06,$06,$06,$06,$06,$06,$06
.byte $06,$07,$07,$06,$06,$06,$06,$06,$06,$06,$06,$06
.byte $07,$07,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07
.byte $07,$06,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07

table_01_B327:		; читается из 2х мест
					; байты скорости команды
.byte $14,$01
.byte $16,$01
.byte $18,$01
.byte $1A,$01
.byte $1C,$01
.byte $20,$01
.byte $24,$01
.byte $26,$01
.byte $28,$01
.byte $30,$01
.byte $90,$01
.byte $A0,$01
.byte $B0,$01
.byte $C0,$01
.byte $D0,$01
.byte $E0,$01

table_01_B347:
.byte $08,$07,$07,$06,$06,$05,$05,$04,$04,$03,$03,$02,$02,$01,$01,$00

table_01_B357:		; читается из 2х мест
					; какие-то параметры для 16 команд, читаются в зависимости от номера команды
.word table_01_B357_B377
.word table_01_B357_B38A
.word table_01_B357_B39D
.word table_01_B357_B3B0
.word table_01_B357_B3C3
.word table_01_B357_B3D6
.word table_01_B357_B3E9
.word table_01_B357_B3FC
.word table_01_B357_B40F
.word table_01_B357_B422
.word table_01_B357_B435
.word table_01_B357_B448
.word table_01_B357_B45B
.word table_01_B357_B46E
.word table_01_B357_B481
.word table_01_B357_B494

table_01_B357_B377:
; первая строка как-то связана со скоростью игроков
; первый байт второй строки читается, но другие байты строки видимо игнорируются
; байты в третьей строке это агрессия и защита команды
.byte $09,$09,$08,$09,$09,$08,$09,$08,$07,$08
.byte $08,$68,$58,$68,$05,$06,$05
.byte $40,$08
table_01_B357_B38A:
.byte $09,$08,$08,$09,$08,$08,$08,$07,$07,$08
.byte $08,$68,$6B,$60,$07,$06,$05
.byte $3C,$10
table_01_B357_B39D:
.byte $09,$07,$08,$09,$08,$09,$08,$06,$06,$08
.byte $08,$60,$68,$60,$07,$07,$06
.byte $41,$10
table_01_B357_B3B0:
.byte $09,$07,$09,$09,$09,$08,$08,$07,$08,$08
.byte $08,$70,$68,$60,$07,$07,$06
.byte $30,$04
table_01_B357_B3C3:
.byte $08,$09,$08,$08,$08,$08,$08,$09,$07,$08
.byte $07,$70,$78,$80,$06,$07,$05
.byte $20,$04
table_01_B357_B3D6:
.byte $07,$08,$07,$08,$09,$08,$07,$07,$06,$08
.byte $07,$90,$90,$60,$07,$07,$05
.byte $3C,$08
table_01_B357_B3E9:
.byte $09,$07,$06,$08,$08,$07,$07,$06,$06,$08
.byte $06,$A0,$90,$A0,$08,$06,$06
.byte $28,$02
table_01_B357_B3FC:
.byte $07,$06,$06,$08,$07,$07,$08,$06,$05,$01
.byte $06,$B0,$B0,$A0,$15,$15,$10
.byte $32,$04
table_01_B357_B40F:
.byte $07,$07,$05,$08,$07,$06,$06,$05,$04,$07
.byte $06,$A0,$A0,$90,$17,$17,$15
.byte $46,$08
table_01_B357_B422:
.byte $06,$06,$06,$07,$07,$07,$05,$05,$05,$07
.byte $05,$B0,$B0,$A0,$13,$15,$12
.byte $28,$10
table_01_B357_B435:
.byte $06,$06,$05,$08,$07,$06,$06,$05,$04,$07
.byte $04,$A0,$A0,$98,$24,$23,$23
.byte $20,$10
table_01_B357_B448:
.byte $06,$05,$04,$07,$06,$06,$05,$04,$04,$06
.byte $04,$A0,$A2,$A6,$24,$23,$23
.byte $20,$10
table_01_B357_B45B:
.byte $06,$07,$05,$07,$06,$06,$06,$05,$06,$06
.byte $06,$94,$98,$9B,$32,$35,$33
.byte $2A,$10
table_01_B357_B46E:
.byte $05,$04,$05,$06,$06,$06,$04,$04,$04,$05
.byte $05,$90,$92,$94,$34,$33,$33
.byte $20,$08
table_01_B357_B481:
.byte $05,$04,$04,$06,$06,$06,$04,$04,$03,$05
.byte $04,$82,$84,$86,$42,$42,$41
.byte $20,$08
table_01_B357_B494:
.byte $03,$03,$03,$06,$06,$05,$03,$02,$02,$04
.byte $03,$80,$84,$88,$42,$41,$41
.byte $10,$08

table_01_B4A7:		; что-то связанное с управлением бота с мячом в игре против компа
					; зависит от номера команды
					; байт читается в зависимости от номера зоны 0427, байт от 00 до 27
					; влияет на чтение из table_01_B727
; команда 1
.byte $3C,$24,$23,$22,$38,$3B,$47,$3A,$3D,$39,$3C,$3B,$3A,$39,$38,$18
.byte $17,$16,$15,$14,$13,$12,$11,$10,$19,$0E,$0D,$0C,$0B,$0A,$09,$4F
.byte $4E,$4D,$05,$04,$03,$02,$01,$00
; команда 2
.byte $30,$34,$33,$32,$2F,$31,$30,$30,$2F,$2E,$1D,$1C,$1B,$1A,$19,$31
.byte $30,$16,$2F,$2E,$13,$12,$11,$10,$14,$2D,$2C,$2B,$2A,$29,$04,$28
.byte $27,$26,$00,$04,$03,$02,$01,$00
; команда 3
.byte $25,$24,$23,$22,$21,$20,$1F,$1E,$1D,$1C,$1B,$1A,$16,$15,$19,$18
.byte $17,$16,$15,$2E,$13,$12,$11,$10,$14,$0E,$0D,$0C,$0B,$0A,$09,$08
.byte $07,$06,$05,$04,$03,$02,$01,$00
; команда 4
.byte $30,$34,$33,$32,$2F,$31,$30,$33,$2F,$2E,$1D,$1C,$1B,$1A,$19,$32
.byte $30,$16,$2F,$2E,$3C,$3C,$11,$38,$38,$2D,$2C,$2B,$2A,$29,$09,$28
.byte $27,$26,$05,$04,$03,$02,$01,$00
; команда 5
.byte $30,$34,$33,$32,$2F,$31,$30,$33,$2F,$2E,$25,$25,$3A,$3D,$3D,$18
.byte $12,$11,$10,$14,$32,$31,$30,$2F,$2E,$2D,$2C,$4C,$2A,$29,$04,$28
.byte $27,$26,$00,$04,$03,$02,$01,$00
; команда 6
.byte $3C,$24,$23,$22,$38,$0F,$18,$16,$1D,$1C,$30,$31,$32,$2F,$2E,$3C
.byte $3B,$3A,$39,$38,$32,$31,$4B,$2F,$2E,$0E,$2C,$4B,$2A,$0A,$04,$37
.byte $36,$35,$00,$04,$3F,$02,$3E,$00
; команда 7
.byte $30,$34,$33,$32,$2F,$31,$30,$33,$2F,$2E,$3B,$3D,$3A,$3D,$38,$18
.byte $3B,$3A,$39,$14,$13,$3C,$11,$38,$2F,$2D,$2C,$2B,$2A,$29,$04,$28
.byte $27,$26,$00,$04,$03,$02,$01,$00
; команда 8
.byte $30,$34,$33,$32,$2F,$31,$30,$33,$2F,$2E,$1D,$1C,$1B,$1A,$19,$18
.byte $17,$16,$15,$14,$30,$34,$33,$2F,$2E,$0E,$37,$32,$35,$0A,$04,$2C
.byte $36,$2A,$00,$04,$3F,$02,$3E,$00
; команда 9
.byte $30,$34,$33,$32,$2F,$31,$30,$33,$2F,$2E,$31,$30,$33,$2F,$2E,$18
.byte $17,$16,$15,$14,$13,$12,$11,$10,$2F,$0E,$0D,$0C,$0B,$0A,$09,$08
.byte $07,$06,$05,$04,$03,$02,$01,$00
; команда 10
.byte $30,$34,$33,$32,$2F,$31,$30,$33,$2F,$2E,$20,$1F,$16,$1C,$21,$18
.byte $18,$15,$14,$14,$13,$12,$4C,$10,$2F,$0E,$0D,$4B,$0B,$0A,$09,$08
.byte $07,$06,$05,$04,$03,$02,$01,$00
; команда 11
.byte $30,$32,$33,$32,$2F,$24,$18,$1F,$17,$1C,$3C,$3B,$4B,$39,$38,$18
.byte $16,$15,$15,$14,$3C,$3B,$4C,$39,$38,$31,$30,$0C,$2F,$2E,$04,$2C
.byte $2B,$2A,$00,$04,$03,$02,$01,$00
; команда 12
.byte $30,$34,$33,$32,$2F,$31,$30,$33,$2F,$2E,$3B,$3D,$3A,$3D,$38,$18
.byte $3B,$3A,$39,$14,$3C,$3C,$11,$38,$38,$43,$42,$0C,$41,$40,$04,$37
.byte $36,$35,$00,$04,$3F,$02,$3E,$00
; команда 13
.byte $30,$34,$33,$32,$2F,$48,$45,$4A,$44,$47,$49,$48,$3A,$47,$46,$45
.byte $3A,$3A,$3A,$44,$3C,$3C,$4B,$38,$38,$43,$42,$4B,$41,$40,$09,$37
.byte $36,$35,$05,$04,$3F,$02,$3E,$00
; команда 14
.byte $30,$34,$33,$32,$2F,$0F,$45,$4A,$44,$2E,$3C,$3B,$3A,$39,$38,$45
.byte $3A,$4B,$3A,$44,$3C,$12,$11,$10,$3D,$43,$42,$0C,$41,$40,$05,$37
.byte $36,$35,$00,$04,$3F,$02,$3E,$00
; команда 15
.byte $30,$34,$33,$32,$2F,$31,$30,$4A,$2F,$2E,$31,$30,$4A,$2F,$2E,$18
.byte $17,$16,$15,$14,$3C,$12,$11,$10,$38,$0E,$42,$36,$41,$0A,$09,$08
.byte $0C,$06,$05,$04,$03,$02,$01,$00
; команда 16
.byte $30,$34,$33,$32,$2F,$31,$30,$33,$2F,$2E,$31,$30,$1B,$2F,$2E,$18
.byte $17,$16,$15,$14,$13,$12,$11,$10,$30,$0E,$2C,$2B,$2A,$0A,$04,$37
.byte $36,$35,$00,$04,$3F,$02,$3E,$00

table_01_B727:		; что-то связанное с управлением бота с мячом в игре против компа
.word table_01_B729_B827
.word table_01_B729_B830
.word table_01_B729_B839
.word table_01_B729_B83C
.word table_01_B729_B845
.word table_01_B729_B84E
.word table_01_B729_B857
.word table_01_B729_B85E
.word table_01_B729_B867
.word table_01_B729_B86E
.word table_01_B729_B877
.word table_01_B729_B880
.word table_01_B729_B887
.word table_01_B729_B890
.word table_01_B729_B897
.word table_01_B729_B8A0
.word table_01_B729_B8A5
.word table_01_B729_B8AE
.word table_01_B729_B8B7
.word table_01_B729_B8C0
.word table_01_B729_B8C5
.word table_01_B729_B8CC
.word table_01_B729_B8D5
.word table_01_B729_B8DE
.word table_01_B729_B8E5
.word table_01_B729_B8EC
.word table_01_B729_B8F1
.word table_01_B729_B8FA
.word table_01_B729_B8FF
.word table_01_B729_B908
.word table_01_B729_B90F
.word table_01_B729_B916
.word table_01_B729_B91D
.word table_01_B729_B926
.word table_01_B729_B92F
.word table_01_B729_B938
.word table_01_B729_B941
.word table_01_B729_B94A
.word table_01_B729_B953
.word table_01_B729_B95A
.word table_01_B729_B961
.word table_01_B729_B968
.word table_01_B729_B971
.word table_01_B729_B97A
.word table_01_B729_B983
.word table_01_B729_B98C
.word table_01_B729_B995
.word table_01_B729_B99E
.word table_01_B729_B9A7
.word table_01_B729_B9B0
.word table_01_B729_B9B9
.word table_01_B729_B9C2
.word table_01_B729_B9CB
.word table_01_B729_B9D4
.word table_01_B729_B9D9
.word table_01_B729_B9E0
.word table_01_B729_B9E5
.word table_01_B729_B9EC
.word table_01_B729_B9F3
.word table_01_B729_B9FC
.word table_01_B729_BA03
.word table_01_B729_BA0A
.word table_01_B729_BA13
.word table_01_B729_BA1C
.word table_01_B729_BA25
.word table_01_B729_BA2A
.word table_01_B729_BA31
.word table_01_B729_BA38
.word table_01_B729_BA3D
.word table_01_B729_BA46
.word table_01_B729_BA4F
.word table_01_B729_BA56
.word table_01_B729_BA5F
.word table_01_B729_BA68
.word table_01_B729_BA6F
.word table_01_B729_BA78
.word table_01_B729_BA7F
.word table_01_B729_BA88
.word table_01_B729_BA8D
.word table_01_B729_BA94

; B7C7, байты ссылаются на FF в BA99, где начинается свободное место
.byte $99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA
.byte $99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA
.byte $99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA
.byte $99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA
.byte $99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA
.byte $99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA,$99,$BA

; первый байт - шанс рандома. если 00, то фиксированное действие
; если не 00, то байт должен быть ниже 037E
; второй байт аналогично проверяется на 00 и рандом с 037F
; но второй байт не должен быть 00, и шанс должен быть выше
table_01_B729_B827:
.byte $80,$FF,$03,$60,$14,$F8,$13,$80,$11
table_01_B729_B830:
.byte $E8,$F8,$03,$10,$15,$C0,$13,$80,$14
table_01_B729_B839:
.byte $FF,$00,$00
table_01_B729_B83C:
.byte $E8,$F8,$03,$60,$11,$C0,$13,$80,$14
table_01_B729_B845:
.byte $80,$FF,$03,$60,$14,$F8,$13,$80,$15
table_01_B729_B84E:
.byte $E8,$80,$03,$80,$14,$C0,$13,$80,$11
table_01_B729_B857:
.byte $E8,$80,$02,$80,$15,$C0,$13
table_01_B729_B85E:
.byte $E8,$80,$03,$60,$15,$60,$11,$C0,$13
table_01_B729_B867:
.byte $E8,$80,$02,$80,$11,$C0,$13
table_01_B729_B86E:
.byte $E8,$C0,$03,$80,$14,$C0,$13,$80,$15
table_01_B729_B877:
.byte $40,$F0,$03,$C0,$13,$40,$10,$20,$15
table_01_B729_B880:
.byte $00,$C0,$02,$B0,$15,$C0,$13
table_01_B729_B887:
.byte $00,$50,$03,$C0,$13,$40,$10,$40,$12
table_01_B729_B890:
.byte $00,$C0,$02,$B0,$11,$C0,$13
table_01_B729_B897:
.byte $40,$F0,$03,$C0,$13,$40,$12,$20,$11
table_01_B729_B8A0:
.byte $00,$F0,$01,$80,$11
table_01_B729_B8A5:
.byte $00,$80,$03,$20,$15,$20,$10,$20,$13
table_01_B729_B8AE:
.byte $00,$80,$03,$80,$13,$60,$10,$40,$12
table_01_B729_B8B7:
.byte $00,$80,$03,$20,$11,$20,$12,$C0,$13
table_01_B729_B8C0:
.byte $00,$80,$01,$80,$13
table_01_B729_B8C5:
.byte $00,$60,$02,$40,$10,$20,$15
table_01_B729_B8CC:
.byte $00,$80,$03,$80,$10,$60,$14,$40,$12
table_01_B729_B8D5:
.byte $00,$80,$03,$70,$14,$60,$10,$40,$12
table_01_B729_B8DE:
.byte $00,$60,$02,$60,$12,$60,$14
table_01_B729_B8E5:
.byte $00,$60,$02,$40,$12,$20,$11
table_01_B729_B8EC:
.byte $00,$60,$01,$C0,$10
table_01_B729_B8F1:
.byte $00,$60,$03,$30,$12,$30,$14,$30,$10
table_01_B729_B8FA:
.byte $00,$60,$01,$C0,$12
table_01_B729_B8FF:
.byte $00,$60,$03,$40,$10,$20,$14,$10,$15
table_01_B729_B908:
.byte $00,$60,$02,$40,$10,$20,$14
table_01_B729_B90F:
.byte $00,$40,$02,$40,$10,$40,$12
table_01_B729_B916:
.byte $00,$60,$02,$40,$12,$20,$14
table_01_B729_B91D:
.byte $00,$60,$03,$40,$12,$20,$14,$10,$15
table_01_B729_B926:
.byte $00,$80,$03,$80,$10,$20,$15,$20,$14
table_01_B729_B92F:
.byte $00,$F8,$03,$80,$10,$20,$15,$C0,$13
table_01_B729_B938:
.byte $00,$FF,$03,$C0,$13,$30,$15,$30,$11
table_01_B729_B941:
.byte $00,$F8,$03,$80,$12,$20,$11,$C0,$13
table_01_B729_B94A:
.byte $00,$80,$03,$80,$12,$20,$11,$20,$14
table_01_B729_B953:
.byte $E8,$F8,$02,$80,$15,$C0,$13
table_01_B729_B95A:
.byte $F8,$F8,$02,$40,$15,$40,$11
table_01_B729_B961:
.byte $E8,$F8,$02,$80,$10,$C0,$11
table_01_B729_B968:
.byte $40,$F0,$03,$A0,$14,$C0,$13,$30,$11
table_01_B729_B971:
.byte $40,$E8,$03,$10,$15,$30,$11,$C0,$13
table_01_B729_B97A:
.byte $00,$F8,$03,$80,$15,$80,$11,$F8,$13
table_01_B729_B983:
.byte $40,$E8,$03,$10,$11,$30,$12,$C0,$13
table_01_B729_B98C:
.byte $40,$F0,$03,$A0,$14,$C0,$13,$30,$15
table_01_B729_B995:
.byte $00,$F0,$03,$50,$15,$C0,$13,$50,$10
table_01_B729_B99E:
.byte $00,$F8,$03,$50,$15,$C0,$13,$50,$11
table_01_B729_B9A7:
.byte $00,$80,$03,$50,$11,$C0,$13,$50,$15
table_01_B729_B9B0:
.byte $00,$F0,$03,$50,$11,$C0,$13,$50,$10
table_01_B729_B9B9:
.byte $00,$F8,$03,$50,$15,$C0,$13,$50,$11
table_01_B729_B9C2:
.byte $00,$FF,$03,$C0,$13,$80,$15,$80,$11
table_01_B729_B9CB:
.byte $00,$F8,$03,$50,$11,$C0,$13,$50,$15
table_01_B729_B9D4:
.byte $80,$C0,$01,$D0,$15
table_01_B729_B9D9:
.byte $00,$80,$02,$50,$15,$50,$11
table_01_B729_B9E0:
.byte $80,$80,$01,$D0,$11
table_01_B729_B9E5:
.byte $00,$A0,$02,$10,$10,$A0,$15
table_01_B729_B9EC:
.byte $00,$A0,$02,$80,$10,$80,$14
table_01_B729_B9F3:
.byte $00,$C0,$03,$80,$14,$60,$12,$40,$10
table_01_B729_B9FC:
.byte $00,$A0,$02,$80,$12,$80,$14
table_01_B729_BA03:
.byte $00,$A0,$02,$10,$12,$A0,$11
table_01_B729_BA0A:
.byte $00,$C0,$03,$50,$10,$50,$14,$50,$15
table_01_B729_BA13:
.byte $F8,$80,$03,$10,$15,$C0,$13,$80,$14
table_01_B729_BA1C:
.byte $F8,$80,$03,$10,$11,$80,$13,$80,$14
table_01_B729_BA25:
.byte $00,$C0,$01,$A0,$15
table_01_B729_BA2A:
.byte $00,$E0,$02,$80,$15,$80,$13
table_01_B729_BA31:
.byte $00,$E0,$02,$80,$11,$80,$13
table_01_B729_BA38:
.byte $00,$C0,$01,$A0,$11
table_01_B729_BA3D:
.byte $00,$C0,$03,$80,$10,$80,$0C,$80,$0E
table_01_B729_BA46:
.byte $00,$C0,$03,$80,$12,$80,$0D,$80,$0E
table_01_B729_BA4F:
.byte $00,$C0,$02,$80,$10,$80,$15
table_01_B729_BA56:
.byte $00,$C0,$03,$80,$10,$80,$14,$80,$15
table_01_B729_BA5F:
.byte $00,$C0,$03,$80,$12,$80,$14,$80,$11
table_01_B729_BA68:
.byte $00,$C0,$02,$80,$12,$80,$11
table_01_B729_BA6F:
.byte $00,$F0,$03,$80,$10,$80,$12,$C0,$13
table_01_B729_BA78:
.byte $00,$80,$02,$80,$13,$80,$14
table_01_B729_BA7F:
.byte $00,$40,$03,$C0,$13,$60,$15,$40,$11
table_01_B729_BA88:
.byte $F8,$A0,$01,$80,$15
table_01_B729_BA8D:
.byte $FB,$80,$02,$80,$15,$80,$11
table_01_B729_BA94:
.byte $F8,$A0,$01,$80,$11

; BA99
.byte $FF	; вероятно не используется

; BA9A fill FF