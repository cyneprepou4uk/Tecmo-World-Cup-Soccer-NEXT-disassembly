.segment "BANK_02"
.include "ram.inc"
.include "val.inc"

.import _SetSubReturnAddressForLater_b03
.import _FrameDelay_b03
.import _loc_03_C5F1
.import _LoadScreenPalette_b03
.import _PrepareBytesForNametable_b03
.import _EOR_16bit_plus2_b03
.import _EOR_16bit_plus4_b03
.import _EOR_16bit_b03
.import _HideAllSprites_b03
.import _SelectInitialPlayerDataAddress_b03
.import _SelectPlayerSubroutine_b03
.import _ClearNametable_b03
.import _WriteSoundID_b03

.export _loc_02_8033
_loc_02_8033:
	LDA #$09
	STA $6D
	LDX #$80
	LDY #$00
	JSR _loc_02_8044
	LDY #$01
	JSR _loc_02_8044
	RTS

_loc_02_8044:
	STY $2A
	LDA table_02_809A,Y
	STA $2B
	LDA team_id,Y
	ASL
	ADC team_id,Y
	TAY
	LDA #$03
	STA $2C
bra_02_8057:
	LDA #$03
	SEC
	SBC $2C
	ASL
	ASL
	ASL
	ADC $2B
	STA oam_x,X
	LDA #$70
	STA oam_y,X
	LDA #$01
	STA oam_a,X
	LDA table_02_8399,Y
	JSR _loc_02_80B9
	INY
	DEC $2C
	BNE bra_02_8057
	LDA $2B
	CLC
	ADC #$04
	STA $2B
	LDY $2A
	LDA goals_total,Y
	LDY #$00
bra_02_8087:
	CMP #$0A
	BCC bra_02_8090
	SBC #$0A
	INY
	BNE bra_02_8087
bra_02_8090:
	PHA
	TYA
	JSR _loc_02_809C
	PLA
	JSR _loc_02_809C
	RTS

table_02_809A:		; X координата спрайтов текста команд и счета на паузе
.byte $4C,$9C

_loc_02_809C:
	PHA
	LDA $2B
	STA oam_x,X
	CLC
	ADC #$08
	STA $2B
	LDA #$01
	STA oam_a,X
	LDA #$80
	STA oam_y,X
	PLA
	CLC
	ADC #$80
	JSR _loc_02_80B9
	RTS

_loc_02_80B9:
	PHA
	AND #$E0
	STA oam_t,X
	PLA
	AND #$1F
	ASL
	ORA oam_t,X
	STA oam_t,X
	INC oam_t,X
	INX
	INX
	INX
	INX
	RTS

_loc_02_80D1:
.export _loc_02_80D1_minus1
_loc_02_80D1_minus1 = _loc_02_80D1 - 1
	JSR _ClearNametable_b03
	JSR _HideAllSprites_b03
	LDX #$00
	LDA #$02
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$24
	STA chr_bank
	LDA #$26
	STA chr_bank + 1
	LDX #<table_02_95BF
	LDY #>table_02_95BF
	JSR _PrepareBytesForNametable_b03
	LDA #$20
	JSR _loc_02_894C
	LDA #$21
	JSR _loc_02_894C
	LDA #$C8
	STA $03C0
	LDA #$22
	STA $03C1
	LDA #$FF
	STA $03C5
	LDA team_id
	ASL
	ADC team_id
	TAX
	LDY #$00
bra_02_8115:
; чтение имен команд для фотографии игроков после прохождения игры
	LDA table_02_8399,X
	STA $03C2,Y
	INX
	INY
	CPY #$03
	BNE bra_02_8115
	LDA #$80
	JSR _loc_02_894C
	LDX #$00
	LDA #$06
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #MUSIC_FINAL
	JSR _WriteSoundID_b03
	LDA #$FE
	JSR _FrameDelay_b03
	LDA #$0F
	STA game_cnt
	JSR _loc_02_840A
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$04
	STA $02,X
	LDA #>_loc_02_81AD_minus1
	LDY #<_loc_02_81AD_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA #$46
	JSR _FrameDelay_b03
	LDX #$00
	LDA #$06
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$1E
	STA chr_bank + 1
	LDA #$00
	STA $03BB
	STA cam_edge_y_lo
	STA cam_edge_y_hi
	STA $A000
_loc_02_8178:
	LDA #$01
	JSR _FrameDelay_b03
	CLC
	LDA $03BB
	ADC #$40
	STA $03BB
	LDA cam_edge_y_lo
	ADC #$00
	STA cam_edge_y_lo
	BCC bra_02_8193
	INC cam_edge_y_hi
bra_02_8193:
	LDA cam_edge_y_lo
	LDX cam_edge_y_hi
bra_02_8199:
	SEC
	SBC #$F0
	PHA
	TXA
	SBC #$00
	TAX
	PLA
	BCC bra_02_81A6
	BCS bra_02_8199
bra_02_81A6:
	ADC #$F0
	STA $3B
	JMP _loc_02_8178

_loc_02_81AD:
_loc_02_81AD_minus1 = _loc_02_81AD - 1
	LDA #$00
	STA $03BF
_loc_02_81B2:
bra_02_81B2:
	LDA #$01
	JSR _FrameDelay_b03
; чтение Y камеры на экранах с крупным шрифтом
	LDA cam_edge_y_lo
	CLC
	ADC #$08
	AND #$F0
	CMP $03BF
	BEQ bra_02_81B2
	STA $03BF
	LDA cam_edge_y_lo
	AND #$F0
	LDX cam_edge_y_hi
	STX $2B
	LSR $2B
	ROR
	LSR $2B
	ROR
	LSR $2B
	ROR
	LSR $2B
	ROR
	ADC #<table_02_831B
	STA $2A
	LDA $2B
	ADC #>table_02_831B
	STA $2B
	LDY #$00
	LDA ($2A),Y
	CMP #$FF
	BEQ bra_02_823D
	CMP #$FE
	BNE bra_02_8206
	LDX #$0D
	LDA #$78
	STA $01,X
	LDA #$04
	STA $02,X
	LDA #>_loc_02_82D9_minus1
	LDY #<_loc_02_82D9_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA #$11
bra_02_8206:
	ASL
	TAX
	LDA table_02_91B5,X
	STA $73
	LDA table_02_91B5 + 1,X
	STA $74
	LDY #$00
bra_02_8214:
	LDA ($73),Y
	STA $03C0,Y
	INY
	CMP #$FF
	BNE bra_02_8214
	LDA #$08
	STA $03C1
	LDA $3B
	AND #$F0
	ASL
	ROL $03C1
	ASL
	ROL $03C1
	ORA $03C0
	STA $03C0
	LDA #$80
	JSR _loc_02_894C
	JMP _loc_02_81B2
bra_02_823D:
	LDA #$20
	JSR _FrameDelay_b03
	LDA #$00
	STA $05
	STA $06
	LDA #$14
	JSR _FrameDelay_b03
	LDA #$00
bra_02_824F:
	PHA
	LDA #$01
	JSR _FrameDelay_b03
	PLA
	CLC
	ADC #$40
	BCC bra_02_824F
	LDX #$00
bra_02_825D:
	DEC oam_x,X
	INX
	INX
	INX
	INX
	BNE bra_02_825D
	LDA $3A
	SBC #$01
	STA $3A
	BCS bra_02_8274
	LDA byte_for_2000
	EOR #$01
	STA byte_for_2000
bra_02_8274:
	LDA #$00
	LDX $3A
	CPX #$E5
	BNE bra_02_824F
	LDA #$14
	JSR _FrameDelay_b03
	LDX #$10
	LDA #$0D
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$04
	JSR _FrameDelay_b03
	LDX #$10
	LDA #$0E
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$04
	JSR _FrameDelay_b03
	LDX #$10
	LDA #$0F
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$04
	JSR _FrameDelay_b03
	LDX #$10
	LDA #$02
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$08
	JSR _FrameDelay_b03
	LDX #$10
	LDA #$10
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
_loc_02_82D1:
	LDA #$01
	JSR _FrameDelay_b03
	JMP _loc_02_82D1

_loc_02_82D9:
_loc_02_82D9_minus1 = _loc_02_82D9 - 1
	LDX #$10
	LDA #$0A
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$04
	JSR _FrameDelay_b03
	LDX #$10
	LDA #$0B
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$04
	JSR _FrameDelay_b03
	LDX #$10
	LDA #$0C
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$04
	JSR _FrameDelay_b03
	LDX #$10
	LDA #$04
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	JMP _loc_03_C5F1

table_02_831B:		; таблица с байтами, которые читаются исходя из скроллинга камеры
					; на экране с титрами
					; 11 видимо означает пустоту, остальные байты некий текст
					; байт FE заставляет зайца переливаться
					; 12 - текст adviser
.byte $11,$11,$11,$11,$11,$11,$11,$11,$12,$11,$11,$11,$11,$11,$11,$13
.byte $11,$11,$11,$FE,$11,$11,$11,$11,$11,$11,$11,$14,$15,$16,$11,$11
.byte $11,$11,$11,$11,$17,$11,$11,$11,$FE,$11,$11,$11,$11,$11,$11,$11
.byte $1E,$11,$11,$11,$11,$11,$11,$1F,$11,$22,$11,$23,$FE,$11,$11,$11
.byte $11,$11,$11,$11,$11,$11,$11,$18,$11,$11,$11,$11,$11,$11,$19,$11
.byte $11,$11,$FE,$11,$11,$11,$11,$11,$11,$11,$1A,$11,$11,$11,$11,$11
.byte $11,$1B,$11,$1C,$11,$1D,$FE,$11,$11,$11,$11,$11,$11,$11,$11,$11
.byte $11,$11,$11,$11,$11,$11,$26,$11,$11,$11,$11,$11,$11,$FF

table_02_8399:		; 3 буквы имен команд, чтение из 3х мест
.byte $42,$52,$41
.byte $46,$52,$47
.byte $49,$54,$41
.byte $48,$4F,$4C
.byte $41,$52,$47
.byte $55,$52,$53
.byte $55,$52,$55
.byte $50,$4F,$4C
.byte $45,$4E,$47
.byte $53,$50,$41
.byte $43,$4F,$4C
.byte $53,$43,$4F
.byte $46,$52,$41
.byte $55,$53,$41
.byte $4B,$4F,$52
.byte $4A,$50,$4E

.export _loc_02_83C9
_loc_02_83C9:
	BIT game_mode_flags
	BMI bra_02_8409
	LDA #MUSIC_GAME_NUMBER
	JSR _WriteSoundID_b03
	JSR _loc_02_840A
	LDA #$C8
bra_02_83D8:
	PHA
	LDA #$01
	JSR _FrameDelay_b03
	PLA
	TAX
	LDA #(BTN_A | BTN_B | BTN_START)
	AND btn_press
	BNE bra_02_83EB
	DEX
	TXA
	BNE bra_02_83D8
bra_02_83EB:
	LDX #$00
	LDA #$02
	JSR _LoadScreenPalette_b03
	LDX #$10
	LDA #$02
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA byte_for_2000
	ORA #$20
	STA byte_for_2000
	LDA #$00
	STA $A000
bra_02_8409:
	RTS

_loc_02_840A:
	JSR _ClearNametable_b03
	JSR _HideAllSprites_b03
	LDX #$00
	LDA #$05
	JSR _LoadScreenPalette_b03
	LDX #$10
	LDA #$04
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDX #$03
bra_02_8425:
	TXA
	CLC
	ADC #$18
	STA chr_bank + 2,X
	DEX
	BPL bra_02_8425
	LDA #$24
	STA chr_bank
	LDA #$26
	STA chr_bank + 1
	LDA #$7F
	STA cam_edge_x_hi
	LDA #$F4
	STA $03B9
	LDA byte_for_2000
	AND #$DF
	STA byte_for_2000
	LDA #$01
	STA $A000
	LDA #$EF
	STA $3B
	LDA #$00
	JSR _loc_02_894C
; чтение номера команды в режиме против CPU для вывода номера раунда перед игрой
	LDX game_cnt
	INX
	TXA
	JSR _loc_02_894C
bra_02_845F:
	LDA #$01
	JSR _FrameDelay_b03
	DEC $03B9
	JSR _loc_02_8478
	LDA $3B
	SEC
	SBC #$02
	STA $3B
	BCS bra_02_845F
	LDA #$00
	STA $3B
	RTS

_loc_02_8478:
	JSR _HideAllSprites_b03
	LDA #<table_02_9144
	STA $2A
	LDA #>table_02_9144
	STA $2B
	LDX #$00
	STX $2C
_loc_02_8487:
	LDY #$00
	LDA ($2A),Y
	BNE bra_02_848E
	RTS
bra_02_848E:
	LDX #$00
	STA $2D
	INY
	LDA ($2A),Y
	BPL bra_02_8498
	DEX
bra_02_8498:
	CLC
	ADC $03B9
	PHA
	TXA
	ADC #$00
	BEQ bra_02_84A6
	PLA
	LDA #$F8
	PHA
bra_02_84A6:
	PLA
	STA $2E
	INY
bra_02_84AA:
	LDX $2C
	LDA $2E
	STA oam_y,X
	LDA ($2A),Y
	PHA
	AND #$3F
	STA oam_t,X
	LDA #$08
	STA oam_a,X
	PLA
	ASL
	ROL oam_a,X
	ASL
	ROL oam_a,X
	INY
	LDA ($2A),Y
	ADC cam_edge_x_hi
	STA oam_x,X
	INY
	INX
	INX
	INX
	INX
	STX $2C
	DEC $2D
	BNE bra_02_84AA
	TYA
	CLC
	ADC $2A
	STA $2A
	BCC bra_02_84E5
	INC $2B
bra_02_84E5:
	JMP _loc_02_8487

; 84E8, еще не считывались и неизвестно где поинтеры на таблицу
.byte $D8,$E0,$E8,$F0,$F8,$00,$08,$10,$18

.export _TeamSelecScreentFunction_and_PasswordScreenFunction_b02
_TeamSelecScreentFunction_and_PasswordScreenFunction_b02:
	JSR _ClearNametable_b03
	JSR _HideAllSprites_b03
	LDA byte_for_2000
	ORA #$20
	STA byte_for_2000
	LDA #$1C
	STA chr_bank
	LDA #$1A
	STA chr_bank + 1
	LDX #$03
@loop:
	LDA @SpriteBanks_table,X
	STA chr_bank + 2,X
	DEX
	BPL @loop
	LDX #$10
	LDA #$02
	JSR _LoadScreenPalette_b03
	LDX #$00
	LDA #$02
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$02
	JSR _FrameDelay_b03
	LDX #<table_02_8DD0
	LDY #>table_02_8DD0
	JSR _PrepareBytesForNametable_b03
	BIT game_mode_flags
	BPL @password_screen
	LDX #<table_02_9137
	LDY #>table_02_9137
	JSR _PrepareBytesForNametable_b03
	JMP @skip
@password_screen:
	JSR PasswordScreenFunction
@skip:
	LDA #$02
	JSR _FrameDelay_b03
	LDX #$00
	LDA #$05
	JSR _LoadScreenPalette_b03
	LDX #$10
	LDA #$03
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	JMP _loc_02_8560

@SpriteBanks_table:		; 855C
.byte $08,$09,$1A,$1B

_loc_02_8560:
	LDA #MUSIC_TEAM_SELECT
	JSR _WriteSoundID_b03
	LDA #$01
	STA timer_opt
	LDX #$05
	LDA #$3C
	STA $01,X
	LDA #$04
	STA $02,X
	LDA #>_SpectatorsPaletteAndFlagsOnTeamSelectScreen_minus1
	LDY #<_SpectatorsPaletteAndFlagsOnTeamSelectScreen_minus1
	JSR _SetSubReturnAddressForLater_b03
	BIT game_mode_flags
	BPL bra_02_8599
	LDA #$00
	STA team_ban
	STA team_ban + 1
	STA team_id
	JSR _loc_02_8898
	LDA #$01
	STA team_id + 1
	JSR _loc_02_8898
	JMP _loc_02_86C2
bra_02_8599:
	BIT game_mode_flags
	BVS bra_02_85B9
	LDA team_id
	CMP #$FF
	BNE bra_02_85B9
	LDA #$00
	STA team_ban
	STA team_ban + 1
	STA team_id
	JSR _loc_02_8898
	JSR _loc_02_8640
	JSR _loc_02_86B0
bra_02_85B9:
	LDA team_id
	JSR _loc_02_8898
	LDX #$07
	JSR _loc_02_8809
	JSR _loc_02_8640
	LDA game_mode_flags
	AND #FLAG_GM_UNKNOWN_08
	BNE bra_02_85E2
	LDA team_id + 1
	STA team_id + 1
	JSR _loc_02_8898
	LDX #$0B
	JSR _loc_02_8809
	JSR _loc_02_8640
	JMP _loc_02_860C
bra_02_85E2:
	LDA #$00
	STA $03B4
	STA $03B5
bra_02_85EA:
	PHA
	JSR _loc_02_887E
	PLA
	BCC bra_02_85FB
	CLC
	ADC #$01
	CMP #$10
	BNE bra_02_85EA
	JMP _loc_02_860C
bra_02_85FB:
	STA team_id + 1
	JSR _loc_02_8898
	JSR _loc_02_8640
	LDA #$14
	JSR _FrameDelay_b03
	JSR _loc_02_87B4
_loc_02_860C:
bra_02_860C:
	LDA #$01
	JSR _FrameDelay_b03
	LDA #(BTN_A | BTN_B | BTN_START)
	AND btn_press
	BEQ bra_02_860C
	LDA #$00
	STA $05
	STA $06
	LDA #SOUND_FANS
	JSR _WriteSoundID_b03
	LDA #$3C
	JSR _FrameDelay_b03
	LDA #$0F
	STA $2A
	LDA #$FE
	STA game_cnt
bra_02_8631:
	LDA $2A
	JSR _loc_02_887E
	BCC bra_02_863B
	INC game_cnt
bra_02_863B:
	DEC $2A
	BPL bra_02_8631
	RTS

_loc_02_8640:
	LDA #$00
	STA $2A
bra_02_8644:
	LDA $2A
	JSR _loc_02_887E
	BCC bra_02_8665
	LDA $2A
	LDX #$00
	CMP team_id
	BEQ bra_02_8664
	LDX #$06
	CMP team_id + 1
	BNE bra_02_8664
	LDX #$02
	BIT game_mode_flags
	BMI bra_02_8664
	LDX #$04
bra_02_8664:
	SEC
bra_02_8665:
	JSR BannedTeamsSpriteDisplay
	INC $2A
	LDA $2A
	CMP #$10
	BNE bra_02_8644
	RTS

BannedTeamsSpriteDisplay:		; 8671
; отображение забаненых команд в списке в меню выбора команд
	PHP
	LDY $2A
	PLP
	BCS bra_02_8680
	LDA #$F8
	STA oam_y,Y
	RTS
bra_02_8680:
	LDA table_02_86A8,X
	STA oam_a,Y
	LDA table_02_86A8 + 1,X
	STA oam_t,Y
	LDA $2A
	AND #$07
	ASL
	ASL
	ASL
	ASL
	CLC
	ADC #$47
	STA oam_y,Y
	LDA #$2C
	LDX $2A
	CPX #$08
	BCC bra_02_86A4
	LDA #$8C
bra_02_86A4:
	STA oam_x,Y
	RTS

table_02_86A8:
.byte $01,$57
.byte $02,$59
.byte $02,$5B
.byte $00,$61

_loc_02_86B0:
bra_02_86B0:
	LDA #$01
	JSR _FrameDelay_b03
	LDX #$00
	JSR _loc_02_8814
	LDA #(BTN_A | BTN_B)
	AND btn_press
	BEQ bra_02_86B0
	RTS

_loc_02_86C2:
	LDA #$00
	STA $03B6
	JSR GameTimeOptionSprites
bra_02_86CA:
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_02_8640
	BIT $03B6
	BMI bra_02_86F0
	LDX #$00
	JSR _loc_02_8814
	LDA #(BTN_A | BTN_B)
	AND btn_press
	BEQ bra_02_86F0
	LDA $03B6
	ORA #$80
	STA $03B6
	LDX #$07
	JSR _loc_02_8809
bra_02_86F0:
	BIT $03B6
	BVS bra_02_870E
	LDX #$01
	JSR _loc_02_8814
	LDA #(BTN_A | BTN_B)
	AND btn_press + 1
	BEQ bra_02_870E
	LDA $03B6
	ORA #$40
	STA $03B6
	LDX #$0B
	JSR _loc_02_8809
bra_02_870E:
	JSR _loc_02_8745
	LDA $03B6
	CMP #(BTN_A | BTN_B)
	BNE bra_02_86CA
	LDA #$00
bra_02_871A:
	PHA
	CMP timer_opt
	BEQ bra_02_872C
	ASL
	ASL
	ASL
	TAX
	LDA #$F8
	STA oam_y + $40,X
	STA oam_y + $44,X
bra_02_872C:
	PLA
	CLC
	ADC #$01
	CMP #$03
	BNE bra_02_871A
	LDA #$00
	STA $05
	STA $06
	LDA #SOUND_FANS
	JSR _WriteSoundID_b03
	LDA #$46
	JSR _FrameDelay_b03
	RTS

_loc_02_8745:
	LDA #BTN_SELECT
	AND btn_press
	BEQ bra_02_8761
	LDX timer_opt
	INX
	CPX #$03
	BNE bra_02_8756
	LDX #$00
bra_02_8756:
	STX timer_opt
	JSR GameTimeOptionSprites
	LDA #SOUND_SELECT
	JSR _WriteSoundID_b03
bra_02_8761:
	RTS

GameTimeOptionSprites:		; 8762
; подсветка цифр времени тайма на экране выбора команд
.scope
counter = $2A
	LDA #$00
	STA counter
@loop:
	LDA counter
	ASL
	ASL
	TAY
	ASL
	TAX
	LDA #$D0
	STA oam_y + $40,X
	STA oam_y + $44,X
	LDA table_02_87A8,Y
	STA oam_x + $40,X
	LDA table_02_87A8 + 1,Y
	STA oam_t + $40,X
	LDA table_02_87A8 + 2,Y
	STA oam_x + $44,X
	LDA table_02_87A8 + 3,Y
	STA oam_t + $44,X
	LDY #$03
	LDA counter
	CMP timer_opt
	BNE @change_palette
	LDY #$00
@change_palette:
	TYA
	STA oam_a + $40,X
	STA oam_a + $44,X
	INC counter
	LDA counter
	CMP #$03
	BNE @loop
	RTS
.endscope

table_02_87A8:
; X спрайта, тайл спрайта, X спрайта, тайл спрайта
.byte $98,$43, 	$A0,$4B
.byte $B0,$47, 	$B8,$41
.byte $C8,$49, 	$D0,$4B

_loc_02_87B4:
	LDA #$00
	STA $2A
bra_02_87B8:
	PHA
	JSR _loc_02_887E
	BCS bra_02_87C0
	INC $2A
bra_02_87C0:
	PLA
	CLC
	ADC #$01
	CMP #$10
	BNE bra_02_87B8
	LDA $2A
	BEQ bra_02_87FA
	LDA random
_loc_02_87CF:
	CMP $2A
	BCC bra_02_87D8
	SBC $2A
	JMP _loc_02_87CF
bra_02_87D8:
	ASL $2A
	CLC
	ADC $2A
bra_02_87DD:
	PHA
	TAX
	LDA #$04
	CPX #$04
	BCS bra_02_87E8
	LDA table_02_8805,X
bra_02_87E8:
	JSR _FrameDelay_b03
	LDX #$01
	STX $2A
	STX $2B
	JSR _loc_02_884E
	PLA
	SEC
	SBC #$01
	BNE bra_02_87DD
bra_02_87FA:
	LDX #$0B
	JSR _loc_02_8809
	LDA #$14
	JSR _FrameDelay_b03
	RTS

table_02_8805:
.byte $14,$10,$0C,$08

_loc_02_8809:
	LDA #$16
	STA $0393,X
	INC bg_or_pal_write_flag
	RTS

_loc_02_8814:
	STX $2A
	LDA #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	AND btn_press,X
	BNE bra_02_882E
	LDA btn_hold,X
	AND #$0F
	BEQ bra_02_884D
	INC $03B4,X
	LDY $03B4,X
	CPY #$08
	BCC bra_02_884D
bra_02_882E:
	PHA
	LDY #$01
	AND #$0C
	BNE bra_02_8837
	LDY #$08
bra_02_8837:
	PLA
	AND #$0A
	BEQ bra_02_8843
	TYA
	EOR #$FF
	CLC
	ADC #$01
	TAY
bra_02_8843:
	STY $2B
	LDA #$00
	STA $03B4,X
	JSR _loc_02_884E
bra_02_884D:
	RTS

_loc_02_884E:
	LDA team_id,X
	JSR _loc_02_8886
bra_02_8854:
	LDX $2A
	LDA team_id,X
	CLC
	ADC $2B
	AND #$0F
	STA team_id,X
	JSR _loc_02_887E
	BCS bra_02_8854
	LDX $2A
	LDA team_id,X
	JSR _loc_02_8898
	LDX $2A
	LDA #$00
	STA $03B4,X
	JSR _loc_02_8640
	LDA #SOUND_SELECT
	JSR _WriteSoundID_b03
	RTS

_loc_02_887E:
	JSR _loc_02_88AA
bra_02_8881:
	ASL
	DEY
	BPL bra_02_8881
	RTS

_loc_02_8886:
	JSR _loc_02_88AA
	AND table_02_8890,Y
	STA team_ban,X
	RTS

table_02_8890:		; 8890
.byte $7F,$BF,$DF,$EF,$F7,$FB,$FD,$FE

_loc_02_8898:
	JSR _loc_02_88AA
	ORA table_02_88A2,Y
	STA team_ban,X
	RTS

table_02_88A2:		; 88A2
.byte $80,$40,$20,$10,$08,$04,$02,$01

_loc_02_88AA:
	PHA
	AND #$08
	LSR
	LSR
	LSR
	TAX
	PLA
	AND #$07
	TAY
	LDA team_ban,X
	RTS

_SpectatorsPaletteAndFlagsOnTeamSelectScreen:	; 88B9
_SpectatorsPaletteAndFlagsOnTeamSelectScreen_minus1 = _SpectatorsPaletteAndFlagsOnTeamSelectScreen - 1
	LDA #$00
	STA flag_anim_cnt
	LDA #$21
@loop:
	STA pal_buffer + $10	; изменить палитру зрителей от 21 до 2C
	CLC
	ADC #$01
	CMP #$2D
	BNE @skip_color_number_reset
	LDA #$21
@skip_color_number_reset:
	PHA
	INC bg_or_pal_write_flag
	JSR _TeamSelectFlagAnimation
	LDA #$04
	JSR _FrameDelay_b03
	PLA
	JMP @loop

_TeamSelectFlagAnimation:		; 88DE
.scope
flags_counter = $2A
	LDA #$00
	STA flags_counter
@main_loop:
	LDA flags_counter
	ASL
	TAY
	ASL
	ASL
	TAX
	LDA Flags_x_pos_table,Y
	STA oam_x + $C0,X
	CLC
	ADC #$08
	STA oam_x + $C4,X
	LDA Flags_y_pos_table,Y
	STA oam_y + $C0,X
	STA oam_y + $C4,X
	LDA flags_counter
	CLC
	ADC flag_anim_cnt
	CMP #$03
	BCC @skip_flag_cnt_reset
	SBC #$03
@skip_flag_cnt_reset:
	ASL
	TAY
	LDA Flags_tiles_table,Y
	STA oam_t + $C0,X
	LDA Flags_tiles_table + 1,Y
	STA oam_t + $C4,X
	BNE @skip_sprite_hiding
	LDA #$F8	; скрыть второй спрайт флага
	STA oam_y + $C4,X
@skip_sprite_hiding:
	LDA #$00
	STA oam_a + $C0,X
	STA oam_a + $C4,X
	INC flags_counter
	LDA flags_counter
	CMP #$04
	BNE @main_loop
	LDX flag_anim_cnt
	INX
	CPX #$03
	BNE @skip_counter_reload
	LDX #$00
@skip_counter_reload:
	STX flag_anim_cnt
	RTS
.endscope

Flags_x_pos_table:		;893E
Flags_y_pos_table = Flags_x_pos_table + 1
; X спрайта, Y спрайта
.byte $28,$20
.byte $38,$20
.byte $C2,$20
.byte $D2,$20

Flags_tiles_table:		; 8946
; если второй тайл 00, то спрайт будет скрыт с экрана
.byte $B4,$00
.byte $B6,$BC
.byte $BE,$00

_loc_02_894C:
	ASL
	BCC bra_02_895A
	LDA #$C0
	STA $73
	LDA #$03
	STA $74
	JMP _loc_02_8965
bra_02_895A:
	TAX
	LDA table_02_91B5,X
	STA $73
	LDA table_02_91B5 + 1,X
	STA $74
_loc_02_8965:
	LDY #$00
	LDA ($73),Y
	STA $75
	INY
	LDA ($73),Y
	STA $76
	INY
	TYA
_loc_02_8972:
	PHA
	TAY
	LDA ($73),Y
	CMP #$FF
	BEQ bra_02_89E9
	PHA
bra_02_897B:
	LDA #$01
	JSR _FrameDelay_b03
	LDA $037D
	BNE bra_02_897B
	LDA #$01
	STA $037D
	JSR _loc_02_89EB
	PLA
	CMP #$20
	BNE bra_02_8997
	LDA #$00
	JMP _loc_02_89C2
bra_02_8997:
	CMP #$2D
	BNE bra_02_89A0
	LDA #$01
	JMP _loc_02_89C2
bra_02_89A0:
	CMP #$21
	BNE bra_02_89A9
	LDA #$26
	JMP _loc_02_89C2
bra_02_89A9:
	CMP #$2E
	BNE bra_02_89B2
	LDA #$27
	JMP _loc_02_89C2
bra_02_89B2:
	CMP #$41
	BCC bra_02_89BB
	SBC #$35
	JMP _loc_02_89C2
bra_02_89BB:
	CMP #$30
	BCC bra_02_89C2
	SEC
	SBC #$2E
_loc_02_89C2:
bra_02_89C2:
	ASL
	ASL
	TAX
	LDA table_02_9457,X
	STA $0310
	LDA table_02_9457 + 1,X
	STA $0311
	LDA table_02_9457 + 2,X
	STA $0315
	LDA table_02_9457 + 3,X
	STA $0316
	LDA #$80
	STA $037D
	PLA
	CLC
	ADC #$01
	JMP _loc_02_8972
bra_02_89E9:
	PLA
	RTS

_loc_02_89EB:
	LDA $75
	STA nmt_buf_ppu_lo
	LDX $76
	STX nmt_buf_ppu_hi
	CLC
	ADC #$20
	STA nmt_buf_ppu_lo + 5
	TXA
	ADC #$00
	STA nmt_buf_ppu_hi + 5
	LDA #$02
	STA nmt_buf_cnt
	STA nmt_buf_cnt + 5
	LDA #$00
	STA nmt_buf_cnt + 10
	LDA $75
	CLC
	ADC #$02
	STA $75
	BCC bra_02_8A19
	INC $76
bra_02_8A19:
	RTS

_loc_02_8A1A:
.export _loc_02_8A1A_minus1
_loc_02_8A1A_minus1 = _loc_02_8A1A - 1
	LDA byte_for_2000
	AND #$FC
	ORA #$20
	STA byte_for_2000
	LDA #$00
	STA $3A
	LDA #$98
	STA $3B
	JSR _loc_02_8AF6
	LDA #$8C
	JSR _loc_02_8AB6
	BCS bra_02_8A85
_loc_02_8A34:
	LDA #$01
	JSR _FrameDelay_b03
	BIT $03D2
	BMI bra_02_8A85
	LDX $3B
	INX
	CPX #$F0
	BEQ bra_02_8A4A
	STX $3B
	JMP _loc_02_8A34
bra_02_8A4A:
	LDA #$00
	STA $3B
	LDA #$80
	JSR _loc_02_8AB6
	BCS bra_02_8A85
	LDX #$1F
bra_02_8A57:
	TXA
	AND #$03
	BEQ bra_02_8A61
	LDA #$30
	STA pal_buffer + 3,X
bra_02_8A61:
	DEX
	BPL bra_02_8A57
	INC bg_or_pal_write_flag
	LDA #$18
	JSR _loc_02_8AB6
	BCS bra_02_8A85
	LDA #$20
bra_02_8A72:
	JSR _loc_02_8ACB
	LDA $2A
	PHA
	LDA #$0E
	JSR _loc_02_8AB6
	PLA
	BCS bra_02_8A85
	SEC
	SBC #$10
	BPL bra_02_8A72
bra_02_8A85:
	LDA #$80
	STA $03D2
	LDA #$00
	STA soccer_text_color_cnt
_loc_02_8A8F:
	LDA #$02
	JSR _FrameDelay_b03
	LDX soccer_text_color_cnt
	LDA SoccerColorLogo_table,X
	STA pal_buffer + $0D
	LDA SoccerColorLogo_table + 1,X
	STA pal_buffer + $0E
	INX
	INX
	CPX #$14
	BNE bra_02_8AAB
	LDX #$00
bra_02_8AAB:
	STX soccer_text_color_cnt
	INC bg_or_pal_write_flag
	JMP _loc_02_8A8F
_loc_02_8AB6:
bra_02_8AB6:
	PHA
	LDA #$01
	JSR _FrameDelay_b03
	PLA
	BIT $03D2
	SEC
	BMI bra_02_8AC8
	SBC #$01
	BNE bra_02_8AB6
	CLC
bra_02_8AC8:
	RTS

.export _LoadLogoPalette_b02
_LoadLogoPalette_b02:		; 8AC9
	LDA #$00
_loc_02_8ACB:
	STA $2A
	LDX #$00
bra_02_8ACF:
	TXA
	AND #$03
	BNE bra_02_8AD8
	LDA #$0F
	BNE bra_02_8AE8
bra_02_8AD8:
	LDA table_02_8C42,X
	AND #$30
	CMP $2A
	LDA table_02_8C42,X
	BCS bra_02_8AE8
	AND #$0F
	ORA $2A
bra_02_8AE8:
	STA pal_buffer + 3,X
	INX
	CPX #$20
	BNE bra_02_8ACF
	INC bg_or_pal_write_flag
	RTS

_loc_02_8AF6:
	JSR _ClearNametable_b03
	JSR _HideAllSprites_b03
	LDA #$1C
	STA chr_bank
	LDA #$1E
	STA chr_bank + 1
	LDA #$0F
	LDX #$1F
@write_loop:
	STA pal_buffer + 3,X
	DEX
	BPL @write_loop
	LDA #$30
	STA $0392
	INC bg_or_pal_write_flag
	LDX #<table_02_8C76
	LDY #>table_02_8C76
	JSR _PrepareBytesForNametable_b03
	RTS

.export _MainMenuScreenFunction_b03
_MainMenuScreenFunction_b03:		; 8B20
; изменение позиции курсора и попытка дальнейшей игры, затем моргание текста
	LDA #$1D
	STA $6C
	LDA #$00
	STA game_mode_opt
	JSR _MainMenuCursorSpritePosition
@cursor_loop:
	LDA #$01
	JSR _FrameDelay_b03
	LDA #(BTN_UP | BTN_DOWN | BTN_SELECT)
	AND btn_press
	BEQ @skip
	TAX
	LDY #$01
	AND #BTN_SELECT
	BNE @change_cursor_position
	TXA
	AND #$04		; проверка на кнопку вниз
	BNE @change_cursor_position
	LDY #$FF
@change_cursor_position:
	TYA
	CLC
	ADC game_mode_opt		; добавление 01 или FF
	BPL @check_overflow
	LDA #$02
@check_overflow:
	CMP #$03
	BCC @write_position
	LDA #$00
@write_position:
	STA game_mode_opt
	JSR _MainMenuCursorSpritePosition
@skip:
	LDA #(BTN_A | BTN_START)
	AND btn_press
	BEQ @cursor_loop
	LDA #SOUND_OFF
	JSR _WriteSoundID_b03
	LDA #$00
	STA $05
	STA $06
	JSR _LoadLogoPalette_b02		; чтобы надпись Soccer была видна после выбора опции
	LDA #$02
	JSR _FrameDelay_b03
	LDA #SOUND_OPTION_SELECT
	JSR _WriteSoundID_b03
	LDX game_mode_opt		; чтение опции с режимом игры
	LDA FlagsForGameMode_table,X
	STA game_mode_flags
	LDA #$00
@text_blink_loop:
	PHA
@wait_for_text_disappear:
	LDA #$01
	JSR _FrameDelay_b03
	LDA $037D
	BNE @wait_for_text_disappear
	LDA #$01
	STA $037D
	JSR WhereToDrawTextNearCursor
	LDX #$00
	TXA
@clear_loop:
	STA $0310,X
	INX
	CPX #$0A
	BNE @clear_loop
	LDA #$08
	JSR _FrameDelay_b03
@wait_for_text_appear:
	LDA #$01
	JSR _FrameDelay_b03
	LDA $037D
	BNE @wait_for_text_appear
	LDA #$01
	STA $037D
	JSR WhereToDrawTextNearCursor
	LDA game_mode_opt
	ASL
	ASL
	ASL
	ADC game_mode_opt		; позиция курсора * 9
	TAX
	LDY #$00
@read_text_loop:
	LDA table_02_8C27,X
	STA $0310,Y
	INX
	INY
	CPY #$09
	BNE @read_text_loop
	LDA #$08
	JSR _FrameDelay_b03
	PLA
	CLC
	ADC #$01
	CMP #$04		; текст моргает 4 раза
	BNE @text_blink_loop
	RTS

_MainMenuCursorSpritePosition:		; 8BE0
	LDA game_mode_opt		; позиция курсора
	ASL
	ASL
	ASL
	ASL
	CLC
	ADC #$97
	STA oam_y
	LDA #$7F
	STA oam_t
	LDA #$03
	STA oam_a
	LDA #$53
	STA oam_x
	RTS

WhereToDrawTextNearCursor:		; 8BFD
; по каким адресам PPU записывать байты текста в главном меню
; во время моргания этого текста
	LDA #$09		; количество байтов текста для чтения
	STA nmt_buf_cnt
	LDA game_mode_opt
	ASL
	TAX
	LDA table_02_8C21,X
	STA nmt_buf_ppu_lo
	LDA table_02_8C21 + 1,X
	STA nmt_buf_ppu_hi
	LDA #$00
	STA nmt_buffer + $0C
	LDA #$80
	STA $037D
	RTS

FlagsForGameMode_table:		; 8C1E
.byte F_1_PLAYER
.byte F_2_PLAYERS
.byte F_CONTINUE

table_02_8C21:		; координата PPU
.byte $6C,$22
.byte $AC,$22
.byte $EC,$22

table_02_8C27:
.byte $31,$20,$50,$4C,$41,$59,$45,$52,$20	; 1 Player
.byte $32,$20,$50,$4C,$41,$59,$45,$52,$53	; 2 Players
.byte $43,$4F,$4E,$54,$49,$4E,$55,$45,$20	; Continue

table_02_8C42:		; палитра экрана с логотипом
.byte $0F,$15,$05,$30
.byte $0F,$0F,$1A,$30
.byte $0F,$0F,$27,$37
.byte $0F,$00,$11,$30
.byte $0F,$0F,$0F,$0F
.byte $0F,$0F,$0F,$0F
.byte $0F,$0F,$0F,$0F
.byte $0F,$0F,$00,$30

SoccerColorLogo_table:		; 8C62, палитра переливающейся надписи SOCCER на логотипе
.byte $27,$37
.byte $37,$30
.byte $30,$30
.byte $37,$30
.byte $27,$37
.byte $17,$27
.byte $07,$17
.byte $0F,$0F
.byte $07,$17
.byte $17,$27

table_02_8C76:		; байты nametable экрана с логотипом
.byte $18,$84,$20,$54,$45,$43,$4D,$4F
.byte $20,$57,$4F,$52,$4C,$44,$20,$43,$48,$41,$4D,$50,$49,$4F,$4E,$53
.byte $48,$49,$50,$0A,$CB,$20,$EB,$EC,$ED,$F0,$F1,$F4,$F5,$F8,$F9,$FC
.byte $09,$EC,$20,$EE,$EF,$F2,$F3,$F6,$F7,$FA,$FB,$FE,$12,$07,$21,$E5
.byte $80,$81,$84,$85,$90,$91,$94,$95,$C0,$C1,$C4,$C5,$D0,$D1,$C0,$D5
.byte $AE,$12,$27,$21,$E7,$82,$83,$86,$87,$92,$93,$96,$97,$C2,$C3,$C6
.byte $C7,$D2,$D3,$D6,$D7,$B3,$12,$47,$21,$D4,$88,$89,$8C,$8D,$98,$99
.byte $9C,$9D,$C8,$C9,$CC,$CD,$D8,$D9,$DC,$DD,$E0,$11,$68,$21,$8A,$8B
.byte $8E,$8F,$9A,$9B,$9E,$9F,$CA,$CB,$CE,$DE,$DA,$DB,$DE,$DF,$BF,$0B
.byte $8B,$21,$A0,$A1,$A4,$A5,$B0,$B1,$B4,$B5,$B5,$E1,$E4,$0B,$AB,$21
.byte $A2,$A3,$A6,$A7,$B2,$D3,$B6,$B7,$E2,$E3,$E6,$0A,$CB,$21,$A8,$A9
.byte $AC,$AD,$B8,$B9,$BC,$BD,$E8,$E9,$09,$EB,$21,$AA,$AB,$DE,$AF,$BA
.byte $BB,$BE,$DE,$EA,$0C,$0A,$22,$60,$61,$64,$65,$64,$68,$64,$68,$60
.byte $69,$6C,$6D,$0F,$2A,$22,$62,$63,$66,$67,$66,$6A,$66,$6A,$70,$6B
.byte $6E,$6F,$00,$54,$4D,$08,$6C,$22,$31,$20,$50,$4C,$41,$59,$45,$52
.byte $09,$AC,$22,$32,$20,$50,$4C,$41,$59,$45,$52,$53,$08,$EC,$22,$43
.byte $4F,$4E,$54,$49,$4E,$55,$45,$11,$28,$23,$40,$20,$31,$39,$39,$30
.byte $20,$54,$45,$43,$4D,$4F,$2C,$4C,$54,$44,$2E,$20,$C0,$23,$FF,$FF
.byte $FF,$FF,$FF,$FF,$FF,$FF,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$00,$00
.byte $00,$00,$00,$00,$00,$00,$50,$50,$00,$00,$00,$00,$50,$50,$20,$E0
.byte $23,$55,$55,$59,$5A,$5A,$56,$55,$55,$55,$55,$55,$55,$55,$55,$55
.byte $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
.byte $55,$00

table_02_8DD0:		; nametable экрана ввбора команд
.byte $20,$40,$20,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$20,$60,$20,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80,$20,$80,$20,$80,$80,$80,$80,$B9
.byte $80,$B9,$80,$80,$80,$B3,$80,$B3,$80,$B3,$80,$B3,$80,$B3,$80,$B3
.byte $80,$80,$80,$BB,$80,$BB,$80,$80,$80,$80,$80,$20,$A0,$20,$80,$80
.byte $80,$80,$B9,$80,$B9,$80,$80,$84,$8A,$8A,$8A,$8A,$8A,$8A,$8A,$8A
.byte $8A,$8A,$8A,$85,$80,$80,$BB,$80,$BB,$80,$80,$80,$80,$80,$20,$C0
.byte $20,$80,$80,$80,$80,$B9,$80,$B9,$80,$80,$88,$54,$45,$41,$4D,$20
.byte $53,$45,$4C,$45,$43,$54,$89,$80,$80,$BB,$80,$BB,$80,$80,$80,$80
.byte $80,$0A,$E0,$20,$80,$80,$80,$80,$84,$8A,$8A,$8A,$8A,$D2,$0B,$F5
.byte $20,$D3,$8A,$8A,$8A,$8A,$8A,$85,$80,$80,$80,$80,$05,$00,$21,$80
.byte $80,$80,$80,$88,$05,$1B,$21,$89,$80,$80,$C8,$C9,$20,$20,$21,$80
.byte $80,$80,$80,$88,$20,$20,$42,$52,$41,$5A,$49,$4C,$20,$20,$20,$20
.byte $20,$20,$45,$4E,$47,$4C,$41,$4E,$44,$20,$89,$80,$80,$CA,$CB,$05
.byte $40,$21,$CC,$CD,$80,$80,$88,$05,$5B,$21,$89,$80,$80,$80,$80,$20
.byte $60,$21,$CE,$CF,$80,$80,$88,$20,$20,$57,$2E,$47,$45,$52,$4D,$41
.byte $4E,$59,$20,$20,$20,$53,$50,$41,$49,$4E,$20,$20,$20,$89,$80,$80
.byte $80,$80,$05,$80,$21,$80,$80,$80,$80,$88,$05,$9B,$21,$89,$80,$80
.byte $80,$80,$20,$A0,$21,$80,$80,$80,$80,$88,$20,$20,$49,$54,$41,$4C
.byte $59,$20,$20,$20,$20,$20,$20,$20,$43,$4F,$4C,$4F,$4D,$42,$49,$41
.byte $89,$80,$80,$80,$80,$05,$C0,$21,$80,$80,$80,$80,$88,$05,$DB,$21
.byte $89,$80,$80,$80,$80,$20,$E0,$21,$80,$80,$80,$80,$88,$20,$20,$48
.byte $4F,$4C,$4C,$41,$4E,$44,$20,$20,$20,$20,$20,$53,$43,$4F,$54,$4C
.byte $41,$4E,$44,$89,$80,$80,$80,$80,$05,$00,$22,$80,$80,$80,$80,$88
.byte $05,$1B,$22,$89,$80,$80,$80,$80,$20,$20,$22,$82,$82,$82,$82,$88
.byte $20,$20,$41,$52,$47,$45,$4E,$54,$49,$4E,$41,$20,$20,$20,$46,$52
.byte $41,$4E,$43,$45,$20,$20,$89,$82,$82,$82,$82,$05,$40,$22,$90,$91
.byte $94,$95,$88,$05,$5B,$22,$89,$90,$91,$94,$95,$20,$60,$22,$92,$93
.byte $96,$97,$88,$20,$20,$53,$4F,$56,$49,$45,$54,$20,$20,$20,$20,$20
.byte $20,$55,$53,$41,$20,$20,$20,$20,$20,$89,$92,$93,$96,$97,$05,$80
.byte $22,$94,$95,$90,$91,$88,$05,$9B,$22,$89,$94,$95,$90,$91,$20,$A0
.byte $22,$96,$97,$92,$93,$88,$20,$20,$55,$52,$55,$47,$55,$41,$59,$20
.byte $20,$20,$20,$20,$4B,$4F,$52,$45,$41,$20,$20,$20,$89,$96,$97,$92
.byte $93,$05,$C0,$22,$90,$91,$94,$95,$88,$05,$DB,$22,$89,$90,$91,$94
.byte $95,$20,$E0,$22,$92,$93,$96,$97,$88,$20,$20,$50,$4F,$4C,$41,$4E
.byte $44,$20,$20,$20,$20,$20,$20,$4A,$41,$50,$41,$4E,$20,$20,$20,$89
.byte $92,$93,$96,$97,$20,$00,$23,$94,$95,$90,$91,$D0,$D1,$D1,$D1,$D1
.byte $D1,$D1,$D1,$D1,$20,$C0,$C1,$C4,$C5,$20,$D1,$D1,$D1,$D1,$D1,$D1
.byte $D1,$D1,$D4,$94,$95,$90,$91,$05,$20,$23,$96,$97,$92,$93,$88,$04
.byte $2E,$23,$C2,$C3,$C6,$C7,$05,$3B,$23,$89,$96,$97,$92,$93,$10,$40
.byte $23,$81,$81,$81,$81,$88,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
.byte $20,$05,$5B,$23,$89,$81,$81,$81,$81,$20,$60,$23,$83,$83,$83,$83
.byte $86,$8B,$D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7,$D7
.byte $D7,$D7,$D7,$D7,$D7,$D7,$8B,$87,$83,$83,$83,$83,$20,$80,$23,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$20
.byte $A0,$23,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$20,$C0,$23,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$AA,$AA,$EA
.byte $FA,$FA,$BA,$AA,$AA,$AA,$FF,$FF,$FF,$FF,$FF,$FF,$AA,$AA,$FF,$FF
.byte $FF,$FF,$FF,$FF,$AA,$20,$E0,$23,$FA,$FF,$FF,$FF,$FF,$FF,$FF,$FA
.byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$0F,$7F,$5F,$53,$5C,$5F,$DF,$0F
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00

table_02_9137:		; фраза game time на экране выбора команд
.byte $09,$47,$23,$47,$41,$4D,$45
.byte $20,$54,$49,$4D,$45,$00

table_02_9144:		; байты для спрайтов зайца между матчами
.byte $02
.byte $D9,$04,$F1
.byte $5C,$F7

.byte $04
.byte $E1,$00,$F7
.byte $45,$F7
.byte $01,$FF
.byte $50,$FF

.byte $04
.byte $E9,$02,$F9
.byte $47,$F9
.byte $03,$01
.byte $52,$01

.byte $07
.byte $F1,$08,$F9
.byte $4D,$F9
.byte $09,$01
.byte $58,$01
.byte $0C,$09
.byte $59,$09
.byte $91,$09

.byte $08
.byte $F9,$0A,$F5
.byte $0B,$FD
.byte $0E,$04
.byte $5E,$F1
.byte $4F,$F9
.byte $5A,$01
.byte $5B,$09
.byte $93,$09

.byte $05
.byte $01,$94,$F1
.byte $20,$F5
.byte $21,$FD
.byte $64,$F3
.byte $65,$FB

.byte $05
.byte $09,$96,$F1
.byte $22,$F5
.byte $23,$FD
.byte $66,$F3
.byte $67,$FB

.byte $07
.byte $11,$6C,$F1
.byte $95,$F1
.byte $EE,$F1
.byte $06,$F9
.byte $6D,$F9
.byte $97,$F9
.byte $EF,$F9

.byte $02
.byte $19,$E8,$F1
.byte $E9,$F9

.byte $02
.byte $21,$EA,$F1
.byte $EB,$F9

.byte $00		; завершить чтение таблицы, если попадется 00

table_02_91B5:		; читается из 2х мест
					; поинтеры на текст крупных букв
.word table_02_91B5_9203
.word table_02_91B5_9214
.word table_02_91B5_921F
.word table_02_91B5_922A
.word table_02_91B5_9235
.word table_02_91B5_9240
.word table_02_91B5_924B
.word table_02_91B5_9256
.word table_02_91B5_9261
.word table_02_91B5_926C
.word table_02_91B5_9277
.word table_02_91B5_9283
.word table_02_91B5_928F
.word table_02_91B5_929B
.word table_02_91B5_92A7
.word table_02_91B5_92B4
.word table_02_91B5_92C1
.word table_02_91B5_92C9
.word table_02_91B5_92DC
.word table_02_91B5_92EF
.word table_02_91B5_9302
.word table_02_91B5_9315
.word table_02_91B5_9328
.word table_02_91B5_933B
.word table_02_91B5_934E
.word table_02_91B5_9361
.word table_02_91B5_9374
.word table_02_91B5_9387
.word table_02_91B5_939A
.word table_02_91B5_93AD
.word table_02_91B5_93C0
.word table_02_91B5_93D3
.word table_02_91B5_93E6
.word table_02_91B5_93F1
.word table_02_91B5_93F8
.word table_02_91B5_940B
.word table_02_91B5_941E
.word table_02_91B5_9431
.word table_02_91B5_9444

; текст крупными буквами
table_02_91B5_9203:
.byte $C2,$20,$54,$45,$43,$4D,$4F,$20,$57,$4F,$52,$4C,$44,$43,$55,$50,$FF
table_02_91B5_9214:
.byte $C8,$22,$31,$53,$54,$20,$47,$41,$4D,$45,$FF
table_02_91B5_921F:
.byte $C8,$22,$32,$4E,$44,$20,$47,$41,$4D,$45,$FF
table_02_91B5_922A:
.byte $C8,$22,$33,$52,$44,$20,$47,$41,$4D,$45,$FF
table_02_91B5_9235:
.byte $C8,$22,$34,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_9240:
.byte $C8,$22,$35,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_924B:
.byte $C8,$22,$36,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_9256:
.byte $C8,$22,$37,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_9261:
.byte $C8,$22,$38,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_926C:
.byte $C8,$22,$39,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_9277:
.byte $C7,$22,$31,$30,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_9283:
.byte $C7,$22,$31,$31,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_928F:
.byte $C7,$22,$31,$32,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_929B:
.byte $C7,$22,$31,$33,$54,$48,$20,$47,$41,$4D,$45,$FF
table_02_91B5_92A7:
.byte $C6,$22,$53,$45,$4D,$49,$2D,$46,$49,$4E,$41,$4C,$FF
table_02_91B5_92B4:
.byte $C6,$22,$46,$49,$4E,$41,$4C,$20,$47,$41,$4D,$45,$FF
table_02_91B5_92C1:
.byte $CB,$22,$53,$54,$41,$46,$46,$FF
table_02_91B5_92C9:
.byte $00,$00,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$FF
table_02_91B5_92DC:
.byte $01,$00,$20,$20,$20,$20,$41,$44,$56,$49,$53,$45,$52,$20,$20,$20,$20,$20,$FF
table_02_91B5_92EF:
.byte $01,$00,$20,$20,$20,$20,$53,$2E,$54,$4F,$4D,$49,$45,$20,$20,$20,$20,$20,$FF
table_02_91B5_9302:
.byte $01,$00,$20,$20,$20,$20,$50,$4C,$41,$4E,$4E,$45,$52,$20,$20,$20,$20,$20,$FF
table_02_91B5_9315:
.byte $01,$00,$20,$20,$20,$20,$20,$20,$41,$4E,$44,$20,$20,$20,$20,$20,$20,$20,$FF
table_02_91B5_9328:
.byte $00,$00,$20,$20,$20,$20,$50,$49,$43,$54,$55,$52,$45,$53,$20,$20,$20,$20,$FF
table_02_91B5_933B:
.byte $00,$00,$20,$20,$20,$20,$20,$4B,$2E,$55,$45,$44,$41,$20,$20,$20,$20,$20,$FF
table_02_91B5_934E:
.byte $01,$00,$20,$20,$20,$20,$20,$53,$4F,$55,$4E,$44,$20,$20,$20,$20,$20,$20,$FF
table_02_91B5_9361:
.byte $01,$00,$20,$20,$20,$20,$52,$2E,$4E,$49,$54,$54,$41,$20,$20,$20,$20,$20,$FF
table_02_91B5_9374:
.byte $00,$00,$20,$20,$20,$50,$52,$4F,$47,$52,$41,$4D,$4D,$45,$52,$20,$20,$20,$FF
table_02_91B5_9387:
.byte $01,$00,$20,$20,$20,$20,$59,$2E,$49,$4E,$4F,$53,$45,$20,$20,$20,$20,$20,$FF
table_02_91B5_939A:
.byte $00,$00,$20,$20,$20,$20,$20,$41,$2E,$4F,$48,$42,$41,$20,$20,$20,$20,$20,$FF
table_02_91B5_93AD:
.byte $00,$00,$20,$20,$20,$53,$2E,$57,$41,$4B,$41,$59,$41,$4D,$41,$20,$20,$20,$FF
table_02_91B5_93C0:
.byte $01,$00,$20,$20,$20,$45,$44,$2E,$44,$45,$53,$49,$47,$4E,$20,$20,$20,$20,$FF
table_02_91B5_93D3:
.byte $01,$00,$20,$20,$20,$54,$2E,$4D,$49,$59,$41,$4D,$41,$45,$20,$20,$20,$20,$FF
table_02_91B5_93E6:
.byte $88,$20,$56,$49,$43,$54,$4F,$52,$59,$21,$FF
table_02_91B5_93F1:
.byte $D0,$22,$54,$45,$41,$4D,$FF
table_02_91B5_93F8:
.byte $01,$00,$20,$20,$4B,$2E,$4B,$41,$57,$41,$53,$48,$49,$4D,$41,$20,$20,$20,$FF
table_02_91B5_940B:
.byte $00,$00,$20,$20,$53,$2E,$49,$57,$41,$42,$41,$59,$41,$53,$48,$49,$20,$20,$FF
table_02_91B5_941E:
.byte $01,$00,$20,$20,$20,$50,$52,$45,$53,$45,$4E,$54,$45,$44,$20,$20,$20,$20,$FF
table_02_91B5_9431:
.byte $00,$00,$20,$20,$20,$20,$20,$20,$20,$42,$59,$20,$20,$20,$20,$20,$20,$20,$FF
table_02_91B5_9444:
.byte $01,$00,$20,$20,$20,$20,$20,$28,$29,$2A,$2B,$2C,$20,$20,$20,$20,$20,$20,$FF

table_02_9457:		; номера тайлов крупного шрифта
.byte $00,$00,$00,$00	; пробел
.byte $50,$51,$52,$53	; символ -
.byte $08,$01,$0A,$0F	; цифра 0
.byte $41,$43,$1A,$1B	; цифра 1
.byte $44,$05,$46,$47	; цифра 2
.byte $44,$05,$32,$07	; цифра 3
.byte $48,$49,$4A,$4B	; цифра 4
.byte $04,$4C,$4E,$07	; цифра 5
.byte $4D,$31,$4F,$07	; цифра 6
.byte $3C,$3D,$36,$37	; цифра 7
.byte $30,$05,$45,$07	; цифра 8
.byte $30,$58,$32,$5A	; цифра 9
.byte $08,$01,$02,$03	; буква A
.byte $04,$05,$06,$07
.byte $08,$09,$0A,$0B
.byte $0C,$01,$0E,$0F
.byte $04,$10,$06,$12
.byte $04,$10,$16,$0D
.byte $08,$11,$0A,$13
.byte $14,$15,$16,$17
.byte $18,$19,$1A,$1B
.byte $00,$1D,$1E,$1F
.byte $14,$21,$16,$23
.byte $28,$00,$0E,$2A
.byte $24,$25,$26,$27
.byte $24,$2D,$26,$2F
.byte $08,$01,$0A,$0F
.byte $0C,$29,$02,$2B
.byte $08,$01,$0A,$40
.byte $0C,$29,$02,$42
.byte $30,$31,$32,$07
.byte $34,$35,$36,$37
.byte $28,$33,$0A,$0F
.byte $38,$39,$3A,$3B
.byte $2C,$2D,$2E,$2F
.byte $20,$21,$22,$23
.byte $20,$21,$36,$37
.byte $3C,$3D,$3E,$3F	; буква Z
.byte $60,$60,$62,$62	; символ !
.byte $00,$00,$68,$00	; символ .

; дальше какая-то херня, возможно для фотографии команды после прохождения игры
.byte $EB,$EC,$00,$EE
.byte $ED,$F0,$EF,$F2
.byte $F1,$F4,$F3,$F6
.byte $F5,$F8,$F7,$FA
.byte $F9,$FC,$FB,$FE

; 950B (еще не использовались)
.byte $00,$00,$00
.byte $00,$44,$45,$46,$47,$08,$38,$0A,$3A,$40,$41,$36,$37,$68,$01,$06
.byte $0F,$68,$01,$30,$31,$14,$15,$1C,$03,$04,$0D,$30,$31,$04,$0D,$06
.byte $31,$3C,$3D,$36,$37,$42,$43,$06,$31,$04,$01,$30,$31,$04,$01,$02
.byte $03,$04,$05,$06,$07,$08,$09,$0A,$0B,$08,$0C,$0A,$0E,$04,$0D,$06
.byte $0F,$04,$0D,$02,$47,$08,$11,$0A,$13,$14,$15,$02,$03,$18,$19,$1A
.byte $1B,$00,$1D,$1E,$1F,$14,$17,$02,$39,$20,$00,$22,$23,$24,$25,$26
.byte $27,$28,$29,$2A,$2B,$08,$38,$0A,$3A,$04,$01,$02,$47,$08,$38,$0A
.byte $12,$04,$01,$02,$10,$04,$0D,$30,$31,$34,$35,$36,$37,$20,$21,$0A
.byte $3A,$20,$21,$32,$33,$2C,$2D,$2E,$2F,$16,$17,$36,$37,$16,$17,$36
.byte $37,$3C,$3D,$3E,$3F,$60,$60,$62,$62,$00,$00,$4A,$00,$EB,$EC,$00
.byte $EE,$ED,$F0,$EF,$F2,$F1,$F4,$F3,$F6,$F5,$F8,$F7,$FA,$F9,$FC,$FB
.byte $FE

table_02_95BF:
.byte $1C,$02,$21,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $1C,$22,$21,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$1C
.byte $42,$21,$80,$80,$84,$85,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
.byte $80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$1C,$62
.byte $21,$82,$83,$86,$87,$80,$80,$80,$80,$88,$83,$80,$80,$80,$80,$80
.byte $80,$80,$88,$82,$83,$80,$80,$80,$80,$80,$80,$80,$80,$1C,$82,$21
.byte $88,$89,$8C,$8D,$90,$80,$91,$94,$80,$80,$80,$80,$80,$80,$C5,$D0
.byte $80,$80,$80,$80,$D4,$D5,$80,$80,$82,$83,$80,$80,$1C,$A2,$21,$80
.byte $8B,$8E,$8F,$92,$80,$93,$96,$80,$97,$C2,$80,$C3,$C6,$C7,$D2,$D3
.byte $D6,$D7,$80,$C0,$C1,$C4,$80,$80,$80,$80,$80,$1C,$C2,$21,$A0,$A1
.byte $A4,$A5,$98,$9A,$99,$9C,$DB,$9D,$C8,$95,$C9,$CC,$CD,$D8,$D9,$DC
.byte $DD,$DF,$61,$64,$65,$70,$71,$74,$75,$88,$1C,$E2,$21,$A2,$A3,$00
.byte $00,$A2,$B0,$9B,$9E,$F1,$9F,$CA,$CB,$00,$CE,$CF,$DA,$00,$DE,$00
.byte $6A,$63,$66,$67,$72,$73,$76,$77,$FD,$1C,$02,$22,$A0,$A0,$00,$00
.byte $8A,$B2,$B1,$B4,$D1,$B5,$E0,$E1,$00,$E4,$E5,$F0,$00,$F4,$F5,$69
.byte $00,$6C,$6D,$78,$79,$7C,$7D,$A2,$1C,$22,$22,$A2,$A2,$A6,$A7,$A2
.byte $A2,$B3,$B6,$A2,$B7,$00,$E2,$E3,$E6,$E7,$F2,$F3,$F6,$F7,$6B,$00
.byte $6E,$6F,$7A,$7B,$7E,$7F,$FF,$1C,$42,$22,$A8,$A8,$A8,$A8,$A9,$AC
.byte $AC,$AC,$AD,$B8,$B8,$B9,$BC,$BD,$E8,$BD,$E9,$EB,$EE,$EF,$FA,$FB
.byte $FE,$EC,$ED,$F8,$F9,$FC,$1C,$62,$22,$81,$81,$81,$81,$AA,$81,$81
.byte $81,$AA,$81,$81,$81,$AB,$AE,$AE,$AE,$AF,$BA,$BA,$BA,$BB,$BE,$BE
.byte $BE,$BF,$EA,$EA,$EA,$18,$D0,$23,$55,$55,$55,$55,$55,$55,$55,$55
.byte $55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
.byte $00

.export _loc_02_974F
_loc_02_974F:
	LDX #$00
	STX $2C
	PHA
	JSR _loc_02_9764
	PLA
	SEC
	SBC #$04
	EOR #$0F
	CLC
	ADC #$04
	JSR _loc_02_9764
	RTS

_loc_02_9764:
	ASL
	TAX
	LDA table_02_9922,X
	STA $2A
	LDA table_02_9922 + 1,X
	STA $2B
	LDA #$0B
	STA $2D
_loc_02_9774:
	LDA $2C
	CMP plr_w_ball
	BNE bra_02_977E
	JMP _loc_02_9838
bra_02_977E:
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	LDA team_w_ball
	LDX $2C
	CPX #$0B
	BCC bra_02_97A0
	TXA
	SBC #$0B
	TAX
	LDA team_w_ball
	EOR #$0B
bra_02_97A0:
	TAY
	BEQ bra_02_97A9
	STX $2E
	CLC
	ADC $2E
	TAX
bra_02_97A9:
	TXA
	ASL
	ASL
	TAY
	LDA ($2A),Y
	TAX
	INY
	LDA ($2A),Y
	INY
	STY $2E
	TAY
	BMI bra_02_97F3
	AND #$60
	BEQ bra_02_97E0
	AND #$20
	PHP
	TYA
	AND #$1F
	PLP
	BEQ bra_02_97C8
	ORA #$E0
bra_02_97C8:
	TAY
	LDA $2C
	CMP #$0B
	BCC bra_02_97D2
	JSR _EOR_16bit_b03
bra_02_97D2:
	CLC
	TXA
	ADC ball_pos_x_lo
	TAX
	TYA
	ADC ball_pos_x_hi
	TAY
	JMP _loc_02_97E9
bra_02_97E0:
	LDA $2C
	CMP #$0B
	BCC bra_02_97E9
	JSR _EOR_16bit_plus2_b03
_loc_02_97E9:
bra_02_97E9:
	TYA
	LDY #plr_pos_x_hi
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y
bra_02_97F3:
	LDY $2E
	LDA ($2A),Y
	TAX
	INY
	LDA ($2A),Y
	TAY
	BMI bra_02_9838
	AND #$60
	BEQ bra_02_9825
	AND #$20
	PHP
	TYA
	AND #$1F
	PLP
	BEQ bra_02_980D
	ORA #$E0
bra_02_980D:
	TAY
	LDA $2C
	CMP #$0B
	BCC bra_02_9817
	JSR _EOR_16bit_b03
bra_02_9817:
	CLC
	TXA
	ADC ball_pos_y_lo
	TAX
	TYA
	ADC ball_pos_y_hi
	TAY
	JMP _loc_02_982E
bra_02_9825:
	LDA $2C
	CMP #$0B
	BCC bra_02_982E
	JSR _EOR_16bit_plus4_b03
_loc_02_982E:
bra_02_982E:
	TYA
	LDY #plr_pos_y_hi
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y	; plr_pos_y_lo
_loc_02_9838:
bra_02_9838:
	INC $2C
	DEC $2D
	BEQ bra_02_9841
	JMP _loc_02_9774
bra_02_9841:
	RTS

.export _loc_02_9842
_loc_02_9842:
	ASL
	TAX
	LDA table_02_9922,X
	STA $2A
	LDA table_02_9922 + 1,X
	STA $2B
	LDA #$00
	STA $2C
_loc_02_9852:
	LDA $2C
	CMP plr_w_ball
	BNE bra_02_985C
	JMP _loc_02_9916
bra_02_985C:
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	LDA team_w_ball
	LDX $2C
	CPX #$0B
	BCC bra_02_987E
	TXA
	SBC #$0B
	TAX
	LDA team_w_ball
	EOR #$0B
bra_02_987E:
	TAY
	BEQ bra_02_9887
	STX $2D
	CLC
	ADC $2D
	TAX
bra_02_9887:
	TXA
	ASL
	ASL
	TAY
	LDA ($2A),Y
	TAX
	INY
	LDA ($2A),Y
	INY
	STY $2D
	TAY
	BMI bra_02_98D1
	AND #$60
	BEQ bra_02_98BE
	AND #$20
	PHP
	TYA
	AND #$1F
	PLP
	BEQ bra_02_98A6
	ORA #$E0
bra_02_98A6:
	TAY
	LDA $2C
	CMP #$0B
	BCC bra_02_98B0
	JSR _EOR_16bit_b03
bra_02_98B0:
	CLC
	TXA
	ADC ball_pos_x_lo
	TAX
	TYA
	ADC ball_pos_x_hi
	TAY
	JMP _loc_02_98C7
bra_02_98BE:
	LDA $2C
	CMP #$0B
	BCC bra_02_98C7
	JSR _EOR_16bit_plus2_b03
_loc_02_98C7:
bra_02_98C7:
	TYA
	LDY #plr_pos_x_hi
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y	; plr_pos_x_lo
bra_02_98D1:
	LDY $2D
	LDA ($2A),Y
	TAX
	INY
	LDA ($2A),Y
	TAY
	BMI bra_02_9916
	AND #$60
	BEQ bra_02_9903
	AND #$20
	PHP
	TYA
	AND #$1F
	PLP
	BEQ bra_02_98EB
	ORA #$E0
bra_02_98EB:
	TAY
	LDA $2C
	CMP #$0B
	BCC bra_02_98F5
	JSR _EOR_16bit_b03
bra_02_98F5:
	CLC
	TXA
	ADC ball_pos_y_lo
	TAX
	TYA
	ADC ball_pos_y_hi
	TAY
	JMP _loc_02_990C
bra_02_9903:
	LDA $2C
	CMP #$0B
	BCC bra_02_990C
	JSR _EOR_16bit_plus4_b03
_loc_02_990C:
bra_02_990C:
	TYA
	LDY #plr_pos_y_hi
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y	; plr_pos_y_lo
_loc_02_9916:
bra_02_9916:
	INC $2C
	LDA $2C
	CMP #$16
	BEQ bra_02_9921
	JMP _loc_02_9852
bra_02_9921:
	RTS

table_02_9922:		; читается из 2х мест
.word table_02_9922_994A
.word table_02_9922_99A2
.word table_02_9922_99FA
.word table_02_9922_9A52
.word table_02_9922_9AAA
.word table_02_9922_9B02
.word table_02_9922_9B5A
.word table_02_9922_9BB2
.word table_02_9922_9C0A
.word table_02_9922_9C62
.word table_02_9922_9CBA
.word table_02_9922_9D12
.word table_02_9922_9D6A
.word table_02_9922_9DC2
.word table_02_9922_9E1A
.word table_02_9922_9E72
.word table_02_9922_9ECA
.word table_02_9922_9F22
.word table_02_9922_9F7A
.word table_02_9922_9FD2

; 20 кусков по 88 байтов в каждом
table_02_9922_994A:
.byte $FF,$00,$47,$03,$FF,$00,$A7,$02,$97,$01,$77,$02,$FF,$00,$67
.byte $02,$67,$00,$77,$02,$37,$01,$37,$02,$07,$01,$07,$02,$C7,$00
.byte $37,$02,$DF,$01,$07,$02,$F7,$00,$04,$02,$1F,$00,$07,$02,$FF
.byte $00,$47,$03,$FF,$00,$AF,$02,$87,$01,$87,$02,$CF,$00,$77,$02
.byte $77,$00,$87,$02,$2F,$01,$77,$02,$BF,$00,$23,$02,$FF,$00,$4F
.byte $02,$A7,$01,$37,$02,$3F,$01,$23,$02,$57,$00,$37,$02
table_02_9922_99A2:
.byte $4E,$01,$39,$03,$60,$00,$E0,$02,$48,$40,$F0,$7F,$A0,$00,$80
.byte $02,$60,$01,$80,$02,$80,$00,$20,$02,$C0,$01,$E0,$01,$80,$01
.byte $20,$02,$00,$01,$D0,$01,$00,$01,$20,$02,$40,$00,$E0,$01,$00
.byte $80,$00,$80,$40,$00,$20,$02,$C0,$01,$20,$02,$00,$01,$20,$02
.byte $00,$01,$60,$02,$C0,$00,$30,$02,$A0,$01,$E0,$01,$40,$01,$30
.byte $02,$00,$01,$80,$01,$00,$01,$C0,$01,$60,$00,$C0,$01
table_02_9922_99FA:
.byte $00,$80,$00,$80,$60,$00,$C0,$01,$A0,$01,$C0,$01,$00,$01,$C0
.byte $01,$E0,$00,$00,$02,$40,$00,$00,$01,$40,$01,$20,$01,$F0,$40
.byte $48,$40,$60,$41,$30,$40,$A0,$40,$28,$40,$00,$80,$00,$80,$00
.byte $80,$00,$80,$80,$00,$40,$03,$60,$01,$80,$02,$40,$01,$30,$03
.byte $E0,$00,$20,$03,$A0,$00,$A0,$02,$A0,$01,$40,$02,$00,$01,$E0
.byte $02,$00,$01,$40,$02,$E0,$00,$A0,$02,$40,$00,$80,$02
table_02_9922_9A52:
.byte $00,$80,$00,$80,$60,$00,$C0,$01,$C0,$01,$C0,$01,$00,$01,$C0
.byte $01,$E0,$00,$00,$02,$10,$7F,$48,$40,$00,$80,$00,$80,$C0,$01
.byte $00,$01,$60,$7F,$28,$40,$C0,$00,$20,$01,$A0,$7E,$30,$40,$00
.byte $80,$00,$80,$A0,$00,$80,$02,$80,$01,$40,$03,$C0,$00,$30,$03
.byte $20,$01,$20,$03,$00,$01,$E0,$02,$C0,$01,$80,$02,$60,$01,$A0
.byte $02,$00,$01,$40,$02,$20,$01,$A0,$02,$60,$00,$40,$02
table_02_9922_9AAA:
.byte $00,$80,$00,$80,$40,$00,$C0,$01,$A0,$01,$C0,$01,$00,$01,$00
.byte $02,$00,$01,$80,$02,$40,$40,$40,$40,$40,$01,$00,$01,$00,$01
.byte $20,$01,$48,$40,$00,$40,$00,$01,$80,$01,$00,$80,$00,$80,$00
.byte $80,$00,$80,$60,$00,$B0,$01,$C0,$01,$B0,$01,$00,$01,$20,$02
.byte $00,$01,$60,$02,$80,$00,$60,$01,$40,$01,$20,$01,$40,$01,$50
.byte $01,$80,$00,$C0,$00,$00,$01,$60,$01,$A0,$00,$20,$01
table_02_9922_9B02:
.byte $00,$80,$00,$80,$40,$00,$C0,$01,$A0,$01,$C0,$01,$00,$01,$00
.byte $02,$00,$01,$80,$02,$48,$40,$00,$40,$40,$01,$00,$01,$00,$01
.byte $20,$01,$A0,$00,$C0,$01,$00,$01,$80,$01,$00,$80,$00,$80,$00
.byte $80,$00,$80,$40,$00,$20,$02,$C0,$01,$B0,$01,$00,$01,$20,$02
.byte $A0,$00,$80,$02,$80,$00,$B0,$01,$60,$01,$60,$01,$40,$01,$C0
.byte $01,$A0,$01,$20,$01,$00,$01,$C0,$01,$A0,$00,$60,$01
table_02_9922_9B5A:
.byte $00,$80,$00,$80,$40,$00,$E0,$01,$A0,$01,$E0,$01,$E0,$00,$20
.byte $02,$E0,$00,$60,$02,$48,$40,$00,$40,$A0,$01,$40,$01,$40,$01
.byte $80,$01,$40,$40,$C0,$7F,$E0,$00,$40,$01,$00,$80,$00,$80,$00
.byte $80,$00,$80,$40,$00,$80,$02,$C0,$01,$20,$02,$00,$01,$20,$02
.byte $A0,$00,$80,$02,$20,$01,$C0,$01,$C0,$01,$C0,$01,$00,$01,$E0
.byte $01,$A0,$00,$80,$01,$A0,$00,$D0,$01,$40,$00,$E0,$00
table_02_9922_9BB2:
.byte $00,$80,$00,$80,$40,$40,$40,$40,$C0,$01,$E0,$01,$A0,$00,$40
.byte $02,$E0,$00,$80,$02,$40,$40,$C0,$7F,$A0,$01,$80,$01,$60,$01
.byte $20,$02,$80,$00,$20,$02,$48,$40,$00,$40,$00,$80,$00,$80,$00
.byte $80,$00,$80,$40,$00,$80,$02,$C0,$01,$80,$02,$00,$01,$90,$02
.byte $A0,$00,$E0,$02,$A0,$00,$20,$02,$60,$01,$E0,$01,$40,$01,$40
.byte $02,$40,$00,$D0,$01,$00,$01,$20,$02,$A0,$00,$C0,$01
table_02_9922_9C0A:
.byte $00,$80,$00,$80,$00,$80,$00,$80,$80,$01,$40,$02,$48,$40,$00
.byte $40,$E0,$00,$A0,$02,$40,$40,$C0,$7F,$A0,$01,$E0,$01,$60,$01
.byte $20,$02,$A0,$00,$30,$02,$00,$01,$E0,$01,$20,$00,$A0,$01,$00
.byte $80,$00,$80,$80,$00,$20,$03,$C0,$01,$E0,$02,$00,$01,$80,$02
.byte $C0,$00,$E0,$02,$80,$00,$A0,$02,$C0,$01,$C0,$01,$60,$01,$80
.byte $02,$A0,$00,$80,$02,$80,$00,$40,$02,$40,$00,$80,$01
table_02_9922_9C62:
.byte $00,$80,$00,$80,$00,$80,$00,$80,$80,$01,$A0,$02,$48,$40,$00
.byte $40,$00,$01,$E0,$02,$40,$40,$C0,$7F,$A0,$01,$E0,$01,$40,$01
.byte $40,$02,$A0,$00,$80,$02,$E0,$00,$40,$02,$20,$00,$00,$02,$00
.byte $80,$00,$80,$40,$00,$20,$03,$A0,$01,$00,$03,$20,$01,$E0,$02
.byte $80,$00,$00,$03,$80,$00,$60,$02,$C0,$01,$C0,$01,$E0,$00,$00
.byte $03,$C0,$00,$A0,$02,$C0,$00,$E0,$02,$40,$00,$E0,$01
table_02_9922_9CBA:
.byte $00,$80,$00,$80,$00,$80,$00,$80,$60,$01,$00,$03,$20,$01,$A0
.byte $02,$48,$40,$00,$40,$40,$40,$C0,$7F,$C0,$01,$20,$02,$00,$01
.byte $40,$02,$C0,$00,$A0,$02,$80,$00,$60,$02,$40,$00,$E0,$01,$00
.byte $80,$00,$80,$A0,$00,$E0,$02,$80,$01,$E0,$02,$E0,$00,$20,$03
.byte $80,$00,$20,$03,$B0,$00,$70,$02,$C0,$01,$E0,$01,$00,$01,$A0
.byte $02,$A0,$00,$A0,$02,$00,$01,$00,$03,$60,$00,$00,$02
table_02_9922_9D12:
.byte $00,$80,$00,$80,$00,$80,$00,$80,$60,$01,$00,$03,$00,$01,$E0
.byte $02,$48,$40,$00,$40,$40,$40,$C0,$7F,$A0,$01,$40,$02,$00,$01
.byte $C0,$02,$80,$00,$A0,$02,$A0,$00,$00,$03,$40,$00,$20,$02,$00
.byte $80,$00,$80,$C0,$00,$50,$03,$80,$01,$E0,$02,$E0,$00,$40,$03
.byte $A0,$00,$30,$03,$80,$00,$E0,$02,$C0,$01,$E0,$01,$E0,$00,$F0
.byte $02,$E0,$00,$E0,$02,$00,$01,$00,$03,$40,$00,$E0,$01
table_02_9922_9D6A:
.byte $00,$80,$00,$80,$40,$00,$C0,$01,$E0,$01,$C0,$01,$00,$01,$00
.byte $02,$00,$01,$80,$02,$A0,$00,$E0,$01,$00,$80,$00,$80,$C0,$7F
.byte $40,$40,$B8,$7F,$00,$40,$00,$01,$20,$01,$80,$00,$00,$01,$00
.byte $80,$00,$80,$60,$00,$E0,$01,$C0,$01,$C0,$01,$00,$01,$00,$02
.byte $00,$01,$80,$02,$A0,$00,$80,$01,$80,$01,$20,$01,$60,$01,$80
.byte $01,$60,$01,$E0,$00,$20,$01,$60,$01,$A0,$00,$20,$01
table_02_9922_9DC2:
.byte $00,$80,$00,$80,$40,$00,$C0,$01,$E0,$01,$C0,$01,$00,$01,$00
.byte $02,$00,$01,$80,$02,$C0,$00,$00,$02,$00,$80,$00,$80,$B8,$7F
.byte $00,$40,$C0,$00,$C0,$01,$00,$01,$00,$01,$80,$00,$00,$01,$00
.byte $80,$00,$80,$60,$00,$E0,$01,$C0,$01,$20,$02,$20,$01,$20,$02
.byte $60,$01,$80,$02,$A0,$00,$E0,$01,$60,$01,$80,$01,$80,$01,$C0
.byte $01,$80,$01,$20,$01,$00,$01,$E0,$01,$A0,$00,$80,$01
table_02_9922_9E1A:
.byte $00,$80,$00,$80,$60,$00,$C0,$01,$C0,$01,$E0,$01,$00,$01,$20
.byte $02,$00,$01,$80,$02,$A0,$00,$80,$01,$00,$80,$00,$80,$B8,$7F
.byte $00,$40,$C0,$7F,$C0,$7F,$00,$01,$00,$01,$40,$00,$00,$01,$00
.byte $80,$00,$80,$40,$00,$40,$02,$C0,$01,$20,$02,$20,$01,$40,$02
.byte $60,$01,$80,$02,$20,$01,$C0,$01,$80,$01,$A0,$01,$00,$01,$E0
.byte $01,$60,$01,$80,$01,$80,$01,$C0,$01,$C0,$00,$60,$01
table_02_9922_9E72:
.byte $00,$80,$00,$80,$60,$00,$E0,$01,$C0,$7F,$40,$40,$60,$01,$40
.byte $02,$00,$01,$80,$02,$C0,$00,$40,$02,$00,$80,$00,$80,$C0,$7F
.byte $C0,$7F,$A0,$00,$20,$02,$B8,$7F,$00,$40,$40,$00,$80,$01,$00
.byte $80,$00,$80,$40,$00,$80,$02,$C0,$01,$80,$02,$20,$01,$A0,$02
.byte $60,$01,$E0,$02,$A0,$00,$50,$02,$80,$01,$E0,$01,$80,$01,$20
.byte $02,$20,$01,$40,$02,$00,$01,$20,$02,$A0,$00,$E0,$01
table_02_9922_9ECA:
.byte $00,$80,$00,$80,$C0,$00,$80,$02,$00,$80,$00,$80,$B8,$7F,$00
.byte $40,$00,$01,$A0,$02,$A0,$00,$40,$02,$E0,$01,$80,$01,$C0,$7F
.byte $C0,$7F,$C0,$00,$00,$02,$20,$01,$E0,$01,$60,$00,$80,$01,$00
.byte $80,$00,$80,$60,$00,$E0,$02,$A0,$01,$00,$03,$20,$01,$A0,$02
.byte $60,$01,$E0,$02,$A0,$00,$A0,$02,$C0,$01,$A0,$01,$80,$01,$A0
.byte $02,$00,$01,$C0,$01,$80,$01,$20,$02,$40,$00,$E0,$01
table_02_9922_9F22:
.byte $00,$80,$00,$80,$A0,$00,$E0,$02,$00,$80,$00,$80,$B8,$7F,$00
.byte $40,$00,$01,$E0,$02,$A0,$00,$40,$02,$C0,$01,$E0,$01,$C0,$7F
.byte $C0,$7F,$C0,$00,$60,$02,$20,$01,$20,$02,$40,$00,$C0,$01,$00
.byte $80,$00,$80,$60,$00,$E0,$02,$A0,$01,$20,$03,$E0,$00,$E0,$02
.byte $60,$01,$E0,$02,$20,$01,$00,$03,$E0,$01,$00,$02,$40,$01,$A0
.byte $02,$20,$01,$E0,$01,$80,$01,$00,$03,$60,$00,$00,$02
table_02_9922_9F7A:
.byte $00,$80,$00,$80,$C0,$00,$E0,$02,$00,$80,$00,$80,$00,$01,$90
.byte $02,$B8,$7F,$00,$40,$00,$01,$40,$02,$C0,$01,$E0,$01,$C0,$7F
.byte $C0,$7F,$A0,$00,$80,$02,$60,$01,$80,$02,$A0,$00,$20,$02,$00
.byte $80,$00,$80,$A0,$00,$00,$03,$40,$01,$00,$03,$00,$01,$30,$03
.byte $60,$01,$20,$03,$00,$01,$E0,$02,$E0,$01,$C0,$01,$80,$01,$E0
.byte $02,$00,$01,$E0,$01,$20,$01,$00,$03,$60,$00,$00,$02
table_02_9922_9FD2:
.byte $00,$80,$00,$80,$C0,$00,$00,$03,$00,$80,$00,$80,$00,$01,$00
.byte $03,$B8,$7F,$00,$40,$00,$01,$80,$02,$C0,$01,$40,$02,$C0,$7F
.byte $C0,$7F,$A0,$00,$A0,$02,$60,$01,$E0,$02,$A0,$00,$20,$02,$00
.byte $80,$00,$80,$A0,$00,$00,$03,$40,$01,$00,$03,$00,$01,$30,$03
.byte $60,$01,$20,$03,$00,$01,$E0,$02,$E0,$01,$C0,$01,$80,$01,$E0
.byte $02,$00,$01,$E0,$01,$20,$01,$00,$03,$60,$00,$00,$02

.export _loc_02_A02A
_loc_02_A02A:
	LDX #$00
	LDA #$02
	JSR _LoadScreenPalette_b03
	LDX #$10
	LDA #$02
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	JSR _ClearNametable_b03
	JSR _HideAllSprites_b03
	LDA #<table_02_A3BE
	STA $8A
	LDA #>table_02_A3BE
	STA $8B
	LDA #$00
	STA $8C
	LDA #$20
	STA $8D
	LDA #$1C
	STA chr_bank
	LDA #$1A
	STA chr_bank + 1
	LDA #$80
	STA cam_edge_x_lo
	LDA #$00
	STA cam_edge_x_hi
	STA cam_edge_y_lo
	STA cam_edge_y_hi
	STA $03F8
	STA $03FA
_loc_02_A071:
bra_02_A071:
	LDA #$01
	JSR _FrameDelay_b03
	LDA $037D
	BNE bra_02_A071
	LDA #$01
	STA $037D
	LDA #$80
	STA $037D
	LDA $8C
	STA $030E
	LDA $8D
	STA $030F
	LDX #$00
	LDY #$00
	STX $0331
bra_02_A096:
	LDA ($8A),Y
	BEQ bra_02_A0DC
	BMI bra_02_A0AC
	STA $2A
	INY
bra_02_A09F:
	LDA ($8A),Y
	STA $0310,X
	INY
	INX
	DEC $2A
	BNE bra_02_A09F
	BEQ bra_02_A0BC
bra_02_A0AC:
	AND #$7F
	STA $2A
	INY
	LDA ($8A),Y
	INY
bra_02_A0B4:
	STA $0310,X
	INX
	DEC $2A
	BNE bra_02_A0B4
bra_02_A0BC:
	CPX #$20
	BNE bra_02_A096
	STX nmt_buf_cnt
	TYA
	CLC
	ADC $8A
	STA $8A
	BCC bra_02_A0CD
	INC $8B
bra_02_A0CD:
	LDA $8C
	CLC
	ADC #$20
	STA $8C
	BCC bra_02_A071
	INC $8D
	JMP _loc_02_A071
bra_02_A0DC:
	LDA #$00
	STA team_w_ball
	STA $8E
	LDX #$00
	LDA #$09
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	RTS

.export _loc_02_A0F0
_loc_02_A0F0:
	JSR _loc_02_A19F
	JSR _HideAllSprites_b03
	LDA byte_for_2000
	ORA #$20
	STA byte_for_2000
	LDA #$04
	STA chr_bank + 2
	LDA #$2A
	STA chr_bank + 3
	LDA #$28
	STA chr_bank + 4
	LDA #$29
	STA chr_bank + 5
	LDA #$00
bra_02_A10E:
	PHA
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_UNKNOWN_19
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_anim_id
	LDA #$00
	STA (plr_data),Y
	PLA
	CLC
	ADC #$01
	CMP #$16
	BNE bra_02_A10E
	LDA team_w_ball
	CLC
	ADC #$09
	STA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDA #STATE_UNKNOWN_17
	JSR _SelectPlayerSubroutine_b03
	LDX #$00
	JSR _loc_02_A174
	LDA team_w_ball
	EOR #$0B
	JSR _SelectInitialPlayerDataAddress_b03
	LDA #STATE_UNKNOWN_18
	JSR _SelectPlayerSubroutine_b03
	LDX #$04
	JSR _loc_02_A174
	LDA #$FF
	STA ball_pos_x_lo
	LDA #$00
	STA ball_pos_x_hi
	LDA #$BF
	STA ball_pos_y_lo
	LDA #$00
	STA ball_pos_y_hi
	LDA #$09
	STA ball_anim_id
	LDA #SOUND_WHISTLE
	JSR _WriteSoundID_b03
	RTS

_loc_02_A174:
	LDY #plr_pos_x_lo
	LDA table_02_A197,X
	STA (plr_data),Y
	INY
	INY
	LDA table_02_A197 + 1,X
	STA (plr_data),Y	; plr_pos_x_hi
	LDY #plr_pos_y_lo
	LDA table_02_A197 + 2,X
	STA (plr_data),Y
	INY
	INY
	LDA table_02_A197 + 3,X
	STA (plr_data),Y	; plr_pos_y_hi
	LDY #plr_dir
	LDA #$80
	STA (plr_data),Y
	RTS

table_02_A197:
.byte $FF,$00,$BF,$00
.byte $FF,$00,$6F,$00

_loc_02_A19F:
	JSR _HideAllSprites_b03
	LDA byte_for_2000
	AND #$DF
	STA byte_for_2000
	LDX #$03
bra_02_A1AA:
	TXA
	CLC
	ADC #$1C
	STA chr_bank + 2,X
	DEX
	BPL bra_02_A1AA
	LDA #$00
	STA spr_cnt_index
	JSR _loc_02_A2EA
	LDA #$08
bra_02_A1BC:
	PHA
	LDX #$01
	LDA team_w_ball
	BEQ bra_02_A1CB
	INX
	BIT game_mode_flags
	BMI bra_02_A1CB
	INX
bra_02_A1CB:
	LDA #$40
	STA spr_cnt_index
	TXA
	JSR _loc_02_A2EA
	LDA #$06
	JSR _FrameDelay_b03
	LDA #$40
	STA spr_cnt_index
	LDA #$04
	JSR _loc_02_A2EA
	LDA #$06
	JSR _FrameDelay_b03
	PLA
	SEC
	SBC #$01
	BNE bra_02_A1BC
	RTS

.export _loc_02_A1ED
_loc_02_A1ED:
	JSR _HideAllSprites_b03
	LDA byte_for_2000
	AND #$DF
	STA byte_for_2000
	LDX #$03
bra_02_A1F8:
	TXA
	CLC
	ADC #$1C
	STA chr_bank + 2,X
	DEX
	BPL bra_02_A1F8
	LDA #$00
	STA spr_cnt_index
	JSR _loc_02_A232
	LDX #$00
	JSR _loc_02_A245
	LDX #$01
	JSR _loc_02_A245
	JSR _loc_02_A286
	LDA #$50
	JSR _FrameDelay_b03
	LDA #$00
	STA $0D
	STA $0E
	LDA #$01
	JSR _FrameDelay_b03
	LDX #$00
	LDA #$09
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	RTS

_loc_02_A232:
	LDA #$07
	LDX $8E
	CPX #$0A
	BCC bra_02_A241
	LDA #$05
	JSR _loc_02_A2EA
	LDA #$06
bra_02_A241:
	JSR _loc_02_A2EA
	RTS

_loc_02_A245:
	STX $2A
	LDA team_id,X
	STA $2B
	ASL
	ADC $2B
	TAY
	LDA #$38
	STA $2B
	LDA #$03
	STA $2C
	LDX spr_cnt_index
bra_02_A25A:
	LDA $2A
	ASL
	ASL
	ASL
	ASL
	ADC #$B8
	STA oam_y,X
	LDA table_02_8399,Y
	STA oam_t,X
	LDA #$01
	STA oam_a,X
	LDA $2B
	STA oam_x,X
	CLC
	ADC #$08
	STA $2B
	INY
	INX
	INX
	INX
	INX
	DEC $2C
	BNE bra_02_A25A
	STX spr_cnt_index
	RTS

_loc_02_A286:
	LDX $8E
	CPX #$0A
	BCC bra_02_A292
	TXA
	LSR
	LDA #$00
	ROL
	TAX
bra_02_A292:
	STX $2C
	STX $2D
	LDA $92
	LDY $91
bra_02_A29A:
	LSR
	PHA
	TYA
	ROR
	TAY
	PLA
	ROL $2A
	ROL $2B
	DEX
	BPL bra_02_A29A
	LDX spr_cnt_index
bra_02_A2A9:
	LDA $2D
	SEC
	SBC $2C
	LDY #$B8
	LSR
	BCC bra_02_A2B5
	LDY #$C8
bra_02_A2B5:
	ASL
	ASL
	ASL
	STA $2E
	ASL
	ADC $2E
	ADC #$5C
	STA oam_x,X
	LDA $8E
	CMP #$0A
	BCC bra_02_A2CD
	LDA #$7C
	STA oam_x,X
bra_02_A2CD:
	TYA
	STA oam_y,X
	LDA #$01
	STA oam_a,X
	LSR $2B
	ROR $2A
	LDA #$3A
	ADC #$00
	STA oam_t,X
	INX
	DEC $2C
	BPL bra_02_A2A9
	RTS

_loc_02_A2EA:
	ASL
	TAX
	LDA table_02_A36B,X
	STA $2A
	LDA table_02_A36B + 1,X
	STA $2B
	LDY #$00
	LDA ($2A),Y
	STA $2C
	INY
	LDA ($2A),Y
	STA $2D
	INY
	LDX spr_cnt_index
_loc_02_A304:
	LDA ($2A),Y
	BEQ bra_02_A32D
	CMP #$20
	BEQ bra_02_A322
	STA oam_t,X
	LDA $2D
	STA oam_y,X
	LDA #$01
	STA oam_a,X
	LDA $2C
	STA oam_x,X
	INX
bra_02_A322:
	LDA $2C
	CLC
	ADC #$08
	STA $2C
	INY
	JMP _loc_02_A304
bra_02_A32D:
	STX spr_cnt_index
	RTS

.export _loc_02_A330_minus1
_loc_02_A330:
_loc_02_A330_minus1 = _loc_02_A330 - 1
	LDA #$00
bra_02_A332:
	PHA
	LDA #$04
	JSR _FrameDelay_b03
	PLA
	PHA
	TAY
	LDX #$00
bra_02_A33D:
	TXA
	AND #$03
	BEQ bra_02_A34F
	LDA table_02_A365,Y
	STA pal_buffer + $0B,X
	INY
	CPY #$06
	BNE bra_02_A34F
	LDY #$00
bra_02_A34F:
	INX
	CPX #$08
	BNE bra_02_A33D
	INC bg_or_pal_write_flag
	PLA
	CLC
	ADC #$01
	CMP #$06
	BNE bra_02_A332
	LDA #$00
	BEQ bra_02_A332

table_02_A365:		; что-то связанное со зрителями в пенальти
					; читается только при забитом голе
.byte $25,$21,$35,$27,$21,$26

table_02_A36B:
.word table_02_A36B_A37B
.word table_02_A36B_A387
.word table_02_A36B_A38C
.word table_02_A36B_A391
.word table_02_A36B_A397
.word table_02_A36B_A39D
.word table_02_A36B_A3A6
.word table_02_A36B_A3AE

table_02_A36B_A37B:		; kick side
.byte $5C,$B0,$4B,$49,$43,$4B,$20,$53,$49,$44,$45,$00
table_02_A36B_A387:		; 1p
.byte $78,$C0,$31,$50,$00
table_02_A36B_A38C:		; 2p
.byte $78,$C0,$32,$50,$00
table_02_A36B_A391:		; com
.byte $74,$C0,$43,$4F,$4D,$00
table_02_A36B_A397:		; zzz
.byte $00,$F8,$5A,$5A,$5A,$00
table_02_A36B_A39D:		; sudden
.byte $68,$A0,$53,$55,$44,$44,$45,$4E,$00
table_02_A36B_A3A6:		; death
.byte $6C,$AC,$44,$45,$41,$54,$48,$00
table_02_A36B_A3AE:		; 1 2 3 4 5
.byte $5C,$A8,$31,$20,$20,$32,$20,$20,$33,$20,$20,$34,$20,$20,$35,$00

table_02_A3BE:		; nametable экрана пенальти
.byte $20,$EC,$ED,$EE,$EF,$EE,$EF
.byte $EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF
.byte $EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$20,$EE,$EF,$EC,$EE,$EC
.byte $ED,$EE,$EF,$EE,$EF,$EC,$EE,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$EE,$EC
.byte $ED,$EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$20,$EC,$ED,$EE,$EF
.byte $EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF
.byte $EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$20,$EE,$EF,$EC
.byte $EE,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$EE,$EC,$ED,$EE,$EF,$EE,$EF,$EC
.byte $EE,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$20,$EC,$ED
.byte $EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED
.byte $EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$20,$EE
.byte $EF,$EC,$EE,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$EE,$EC,$ED,$EE,$EF,$EE
.byte $EF,$EC,$EE,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$EE,$EC,$ED,$EE,$EF,$20
.byte $EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED
.byte $EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED
.byte $20,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE
.byte $EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE,$EF,$EE,$EF,$EC,$ED,$EC,$ED,$EE
.byte $EF,$05,$EC,$ED,$EE,$EF,$F0,$96,$E7,$05,$F1,$EE,$EF,$EC,$ED,$20
.byte $EE,$EF,$EC,$ED,$F2,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC
.byte $FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$F3,$EC,$ED,$EE,$EF
.byte $84,$FF,$04,$F2,$FC,$FD,$FC,$10,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC
.byte $FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$04,$FD,$FC,$FD,$F3,$84,$FF,$20
.byte $F8,$F9,$F8,$F9,$F2,$F4,$F5,$F4,$F5,$F4,$F5,$F4,$F5,$F4,$F5,$F4
.byte $F5,$F4,$F5,$F4,$F5,$F4,$F5,$F4,$F5,$F4,$F5,$F3,$F8,$F9,$F8,$F9
.byte $20,$FA,$FB,$FA,$FB,$F2,$F6,$F7,$F6,$F7,$F6,$F7,$F6,$F7,$F6,$F7
.byte $F6,$F7,$F6,$F7,$F6,$F7,$F6,$F7,$F6,$F7,$F6,$F7,$F3,$FA,$FB,$FA
.byte $FB,$84,$00,$04,$F2,$FC,$FD,$FC,$10,$FD,$FC,$FD,$FC,$FD,$FC,$FD
.byte $FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$04,$FD,$FC,$FD,$F3,$84,$00
.byte $20,$D8,$D9,$DC,$DD,$F2,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD
.byte $FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$F3,$D8,$D9,$DC
.byte $DD,$20,$DA,$DB,$DE,$DF,$F2,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC
.byte $FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$FC,$FD,$F3,$DA,$DB
.byte $DE,$DF,$84,$D6,$01,$E2,$96,$E3,$01,$E6,$84,$D6,$02,$E0,$E8,$9C
.byte $E0,$02,$E9,$E0,$01,$EA,$9E,$E1,$01,$EB,$A0,$D5,$A0,$E1,$A0,$02
.byte $A0,$E1,$8F,$E1,$02,$E4,$E5,$8F,$E1,$A0,$02,$A0,$02,$A0,$E1,$A0
.byte $E1,$A0,$E1,$A0,$02,$20,$BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE,$BE
.byte $BE,$BE,$BE,$BE,$BE,$BE,$5E,$55,$55,$55,$55,$55,$55,$5E,$55,$55
.byte $55,$55,$55,$55,$55,$55,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00

PasswordScreenFunction:
	BIT game_mode_flags		; если 40, то переход на экран с паролем
	BVC @skip_password_input
	JMP PasswordInputScreenFunction
@skip_password_input:
	LDA team_id
	CMP #$FF
	BNE bra_02_A63D
	RTS
bra_02_A63D:		; сюда прыжок только в том случае, если это не первый экран с командами против компа
	ASL
	ASL
	ASL
	ASL
	STA $2A
	LDA team_id + 1
	ORA $2A
	STA $2A
	LDA team_ban
	STA $2B
	LDA team_ban + 1
	STA $2C
	LDA game_mode_flags
	AND #FLAG_GM_UNKNOWN_08
	ASL
	ASL
	ASL
	ASL
	STA $2D
	LDX #$04
	LDA #$00
@clear_loop:
	STA psw_char_sum_id,X
	DEX
	BPL @clear_loop
	STA $30
	STA $31
	TAX
bra_02_A66E:
	LDA $30
	CLC
	ADC $2A,X
	STA $30
	LDA $31
	ADC #$00
	STA $31
	INX
	CPX #$04
	BNE bra_02_A66E
	LDA $30
	PHA
	AND #$0F
	STA $2E
	PLA
	LSR $31
	ROR
	LSR $31
	ROR
	LSR $31
	ROR
	LSR
	ORA $2D
	STA $2D
	LDA #$00
	STA $30
_loc_02_A69A:
	LDA $30
	LSR
	LSR
	LSR
	TAX
	LDA $2A,X
	STA $31
	LDA #$08
	STA $32
bra_02_A6A9:
	LDY $30
	LDA table_02_A6F6,Y
	PHA
	LSR
	LSR
	LSR
	LSR
	TAY
	PLA
	AND #$0F
	TAX
	LDA #$00
	LSR $31
bra_02_A6BC:
	ROL
	DEX
	BPL bra_02_A6BC
	ORA psw_char_sum_id,Y
	STA psw_char_sum_id,Y
	INC $30
	LDA $30
	CMP #$24
	BEQ bra_02_A6D5
	DEC $32
	BNE bra_02_A6A9
	JMP _loc_02_A69A
bra_02_A6D5:
	LDX #$00
bra_02_A6D7:
	LDA psw_char_sum_id,X
	CLC
	ADC PasswordMask_table,X
	STA psw_char_sum_id,X
	INX
	CPX #$05
	BNE bra_02_A6D7
	LDX #<table_02_A9AC
	LDY #>table_02_A9AC
	JSR _PrepareBytesForNametable_b03
	JSR _loc_02_A71A
	RTS

PasswordMask_table:		; A6F1, читается из 2х мест, связано с паролем, маска для 5 сумм двух букв
.byte $3B,$8E,$C1,$4D,$00

table_02_A6F6:			; A6F6, читается из 2х мест
.byte $05,$14,$36,$11,$00,$25,$20,$40,$06,$01,$12,$10,$26,$22,$21,$35,$32,$42,$41,$04,$02,$31,$34,$16,$30,$07,$03,$17,$13,$27,$23,$37,$33,$43,$24,$15

bra_02_A71A:
_loc_02_A71A:
	LDA #$01
	JSR _FrameDelay_b03
	LDA $037D
	BNE bra_02_A71A		; @wait
	LDA #$01
	STA $037D
	LDX #$04
bra_02_A72B:
	LDA psw_char_sum_id,X
	STA $2A,X
	DEX
	BPL bra_02_A72B
	LDA #$09
	STA nmt_buf_cnt
	LDA #$51
	STA nmt_buf_ppu_lo
	LDA #$23
	STA nmt_buf_ppu_hi
	LDA #$00
	STA nmt_buf_cnt + $0C
	LDA #$08
	STA $2F
	LDX #$00
bra_02_A74D:
	LDY #$04
	LDA #$00
bra_02_A751:
	ASL $2D
	ROL $2C
	ROL $2B
	ROL $2A
	ROL
	DEY
	BNE bra_02_A751
	JSR _loc_02_A76F
	DEC $2F
	BNE bra_02_A74D
	LDA $2E
	JSR _loc_02_A76F
	LDA #$80
	STA $037D
	RTS

_loc_02_A76F:
	CLC
	ADC #$41
	STA $0310,X
	INX
	RTS

PasswordInputScreenFunction:		; A777
	LDA #SOUND_WHISTLE_FANS
	JSR _WriteSoundID_b03
	LDA #$60
	STA $3B
	LDA #$00		; серый
	STA pal_buffer + $09
	LDA #$30		; белый
	STA pal_buffer + $0A
	INC bg_or_pal_write_flag
	LDX #<table_02_A9AC
	LDY #>table_02_A9AC
	JSR _PrepareBytesForNametable_b03
	LDX #$09
	LDA #$00
@clear_characters_loop:
	STA psw_char_id,X
	DEX
	BPL @clear_characters_loop
	JSR CopyPasswordCharactersIntoSummary
	LDA #$00
	STA psw_char_cnt
	STA psw_hold_btn_timer
ContinuePasswordInput:		; A7A9, 2 прыжка
	LDA #$01
	JSR _FrameDelay_b03
	JSR PasswordCharacterBlinking
	LDA #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	AND btn_press
	BNE @button_is_pressed
	LDA btn_hold
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	BEQ bra_02_A808
	INC psw_hold_btn_timer
	LDX psw_hold_btn_timer
	CPX #$08
	BCS @button_is_pressed
	JMP _loc_02_A80C
@button_is_pressed:
	PHA
	LDA #SOUND_SELECT
	JSR _WriteSoundID_b03
	PLA
	TAX
	AND #$0C
	BEQ bra_02_A7F0
	LDX #$01
	AND #$08
	BNE bra_02_A7DE
	LDX #$FF
bra_02_A7DE:
	LDY psw_char_cnt
	TXA
	CLC
	ADC psw_char_id,Y
	AND #$0F
	STA psw_char_id,Y
	JSR CopyPasswordCharactersIntoSummary
	JMP _loc_02_A808
bra_02_A7F0:
	TXA
	LDX #$01
	LSR
	BCS bra_02_A7F8
	LDX #$FF
bra_02_A7F8:
	TXA
	CLC
	ADC psw_char_cnt
	BPL bra_02_A800
	LDA #$08
bra_02_A800:
	CMP #$09
	BCC bra_02_A806
	LDA #$00
bra_02_A806:
	STA psw_char_cnt
_loc_02_A808:
bra_02_A808:
	LDA #$00
	STA psw_hold_btn_timer
_loc_02_A80C:
	LDA #(BTN_A | BTN_START)
	AND btn_press
	BNE @button_is_pressed
	JMP ContinuePasswordInput
@button_is_pressed:
	JSR CheckForCorrectPassword
	BEQ @correct
	LDA #SOUND_WRONG
	JSR _WriteSoundID_b03
	JMP ContinuePasswordInput
@correct:
	JSR _HideAllSprites_b03
	LDA #$20
	JSR _WriteSoundID_b03
	LDA #$00
bra_02_A82D:
	PHA
	LDA #$01
	JSR _FrameDelay_b03
	PLA
	SEC
	SBC #$80
	TAX
	LDA $3B
	SBC #$00
	STA $3B
	TXA
	BCS bra_02_A82D
	LDA #$00
	STA $3B
	LDA #SOUND_FANS
	JSR _WriteSoundID_b03
	LDA #$00
bra_02_A84C:
	PHA
	LDA #$0A
	JSR _FrameDelay_b03
	LDX #$00
	LDA #$05
	JSR _LoadScreenPalette_b03
	LDX #$10
	LDA #$03
	JSR _LoadScreenPalette_b03
	PLA
	STA $2A
	LDX #$00
bra_02_A865:
	TXA
	AND #$03
	BEQ bra_02_A886
	CPX #$07
	BEQ bra_02_A886
	LDA pal_buffer + 3,X
	PHA
	AND #$0F
	STA $2B
	PLA
	AND #$F0
	CMP $2A
	BEQ bra_02_A881
	BCC bra_02_A881
	LDA $2A
bra_02_A881:
	ORA $2B
	STA pal_buffer + 3,X
bra_02_A886:
	INX
	CPX #$20
	BNE bra_02_A865
	INC bg_or_pal_write_flag
	LDA $2A
	CLC
	ADC #$10
	CMP #$30
	BNE bra_02_A84C
	LDA game_mode_flags
	AND #$BF
	STA game_mode_flags
	RTS

CheckForCorrectPassword:		; A8A2
; на выходе Z = 1 это правильный пароль
	JSR CopyPasswordCharactersIntoSummary
	LDX #$00
@mask_loop:
	LDA psw_char_sum_id,X
	SEC
	SBC PasswordMask_table,X
	STA psw_char_sum_id,X
	INX
	CPX #$05
	BNE @mask_loop
	LDA #$00
	STA $30
_loc_02_A8BA:
	LDA $30
	LSR
	LSR
	LSR
	STA $31
	LDA #$08
	STA $32
bra_02_A8C5:
	LDY $30
	LDA table_02_A6F6,Y
	PHA
	LSR
	LSR
	LSR
	LSR
	TAY
	PLA
	AND #$0F
	TAX
	LDA psw_char_sum_id,Y
bra_02_A8D7:
	LSR
	DEX
	BPL bra_02_A8D7
	LDX $31
	ROR $2A,X
	INC $30
	LDA $30
	CMP #$24
	BEQ bra_02_A8EE
	DEC $32
	BNE bra_02_A8C5
	JMP _loc_02_A8BA
bra_02_A8EE:
	LDA $2E
	LSR
	LSR
	LSR
	LSR
	STA $2E
	LDA $2D
	AND #$80
	LSR
	LSR
	LSR
	LSR
	TAX
	LDA game_mode_flags
	AND #$F7
	STA game_mode_flags
	TXA
	ORA game_mode_flags
	STA game_mode_flags
	LDA $2C
	STA team_ban + 1
	LDA $2B
	STA team_ban
	LDA $2A
	PHA
	AND #$0F
	STA team_id + 1
	PLA
	LSR
	LSR
	LSR
	LSR
	STA team_id
	LDA #$00
	STA $31
	LDA $2E
	STA $30
	LDA $2D
	PHA
	AND #$80
	STA $2D
	PLA
	ASL
	ASL
	ROL $31
	ASL
	ROL $31
	ASL
	ROL $31
	ORA $30
	STA $30
	LDX #$00
bra_02_A948:
	LDA $30
	SEC
	SBC $2A,X
	STA $30
	LDA $31
	SBC #$00
	STA $31
	INX
	CPX #$04
	BNE bra_02_A948
	LDA $30
	ORA $31
	RTS

CopyPasswordCharactersIntoSummary:		; A95F
	LDX #$00
	LDY #$00
@loop:
	LDA psw_char_id,X
	ASL
	ASL		; умножение на 16
	ASL
	ASL
	ORA psw_char_id + 1,X
	STA psw_char_sum_id,Y		; старший ниббл это первая буква, младший - вторая
	INX
	INX
	INY
	CPY #$04
	BNE @loop
	LDA psw_char_id + 8		; копирование оставшейся одиночной девятой буквы
	STA psw_char_sum_id + 4
	JSR _loc_02_A71A
	RTS

PasswordCharacterBlinking:		; A981
	DEC psw_char_blink_timer
	BPL @skip
	LDA #$04	; повторно установить счетчик
	STA psw_char_blink_timer
	LDX #$F8	; скрыть спрайт буквы внизу экрана
	INC psw_char_blink_state
	LDA psw_char_blink_state
	LSR
	BCC @hide_character		; скрыть букву если байт нечетный
	LDX #$6F	; обычная позиция спрайта буквы
@hide_character:
	STX oam_y
	LDA psw_char_cnt
	ASL
	ASL		; умножить на 8
	ASL
	ADC #$88
	STA oam_x
	LDA #$5D
	STA oam_t
	LDA #$00
	STA oam_a
@skip:
	RTS

table_02_A9AC:		; читается из 2х мест
					; nametable слова password
.byte $08,$47,$23,$50,$41,$53,$53,$57,$4F,$52,$44,$00

; A9B8 fill FF



.segment "BANK_02_02"

.export _loc_02_B000
_loc_02_B000:
	JSR _loc_02_B007
	JSR _loc_02_B3F1
	RTS

_loc_02_B007:
	LDA byte_for_2000
	ORA #$01
	STA byte_for_2000
	LDA #$40
	STA $DB
	LDA #$20
	STA $DC
	LDA #<table_02_B25F
	STA $D8
	LDA #>table_02_B25F
	STA $D9
_loc_02_B023:
bra_02_B023:
	LDA #$01
	JSR _FrameDelay_b03
	LDA $037D
	BNE bra_02_B023
	LDA #$01
	STA $037D
	LDA #$20
	STA nmt_buf_cnt
	LDA $DB
	STA nmt_buf_ppu_lo
	LDA $DC
	STA nmt_buf_ppu_hi
	LDA #$00		; закончить чтение буффера здесь
	STA nmt_buf_cnt + $23
	LDA #$80
	STA $037D
	LDA $DB
	CLC
	ADC #$20
	STA $DB
	LDA $DC
	ADC #$00
	STA $DC
	LDX #$03
bra_02_B060:
	LDY #$00
	LDA ($D8),Y
	BNE bra_02_B06C
	STA nmt_buf_cnt
	JMP _loc_02_B0C0
bra_02_B06C:
	AND #$80
	BNE bra_02_B095
	LDA ($D8),Y
	STA $DD
	INY
bra_02_B076:
	LDA ($D8),Y
	STA nmt_buffer,X
	INX
	DEC $DD
	BNE bra_02_B076
	LDA $D8
	CLC
	ADC #$02
	STA $D8
	LDA $D9
	ADC #$00
	STA $D9
	JMP _loc_02_B0B9
bra_02_B095:
	LDA ($D8),Y
	AND #$7F
	STA $DD
bra_02_B09C:
	INY
	LDA ($D8),Y
	STA nmt_buffer,X
	INX
	DEC $DD
	BNE bra_02_B09C
	INY
	TYA
	CLC
	ADC $D8
	STA $D8
	LDA $D9
	ADC #$00
	STA $D9
_loc_02_B0B9:
	CPX #$23
	BNE bra_02_B060
	JMP _loc_02_B023
_loc_02_B0C0:
	JSR _loc_02_B0CF
	JSR _loc_02_B151
	LDA byte_for_2000
	AND #$FE
	STA byte_for_2000
	RTS

_loc_02_B0CF:
	LDA team_id
	STA $DE
	LDA #$6A
	STA $DB
	LDA #$21
	STA $DC
	JSR _loc_02_B0F6
	LDA team_id + 1
	STA $DE
	LDA #$73
	STA $DB
	LDA #$21
	STA $DC
	JSR _loc_02_B0F6
	RTS

_loc_02_B0F6:
	LDA #<table_02_B3C1
	STA $D8
	LDA #>table_02_B3C1
	STA $D9
bra_02_B100:
	LDA #$01
	JSR _FrameDelay_b03
	LDA $037D
	BNE bra_02_B100
	LDA #$01
	STA $037D
	LDA #$03
	STA nmt_buf_cnt
	LDA $DB
	STA nmt_buf_ppu_lo
	LDA $DC
	STA nmt_buf_ppu_hi
	LDA #$00
	STA nmt_buffer + 6
	LDA #$80
	STA $037D
	LDA #$00
	STA $DD
	TAY
	LDX #$03
bra_02_B132:
	LDA $DE
	CLC
	ADC $DD
	STA $DD
	DEX
	BNE bra_02_B132
	TYA
	LDX #$00
	LDY $DD
bra_02_B145:
	LDA ($D8),Y
	STA nmt_buffer + 3,X
	INY
	INX
	CPX #$03
	BNE bra_02_B145
	RTS

_loc_02_B151:
	LDA goals_half
	STA $DD
	LDA #$AA
	STA $DB
	LDA #$21
	STA $DC
	JSR _loc_02_B1D1
	LDA goals_half + 1
	STA $DD
	LDA #$B4
	STA $DB
	LDA #$21
	STA $DC
	JSR _loc_02_B1D1
	LDA half_time_cnt
	BEQ bra_02_B1AA
	LDA goals_total
	SEC
	SBC goals_half
	STA $DD
	LDA #$EA
	STA $DB
	LDA #$21
	STA $DC
	JSR _loc_02_B1D1
	LDA goals_total + 1
	SEC
	SBC goals_half + 1
	STA $DD
	LDA #$F4
	STA $DB
	LDA #$21
	STA $DC
	JSR _loc_02_B1D1
bra_02_B1AA:
	LDA goals_total
	STA $DD
	LDA #$2A
	STA $DB
	LDA #$22
	STA $DC
	JSR _loc_02_B1D1
	LDA goals_total + 1
	STA $DD
	LDA #$34
	STA $DB
	LDA #$22
	STA $DC
	JSR _loc_02_B1D1
	RTS

_loc_02_B1D1:
	LDA $DD
	STA $E0
bra_02_B1D7:
	LDA #$01
	JSR _FrameDelay_b03
	LDA $037D
	BNE bra_02_B1D7
	LDA #$01
	STA $037D
	LDA #$02
	STA nmt_buf_cnt
	LDA $DB
	STA nmt_buf_ppu_lo
	LDA $DC
	STA nmt_buf_ppu_hi
	LDA #$00
	STA nmt_buffer + 5
	LDA #$80
	STA $037D
	LDA #$0A
	STA $E2
	LDX #$01
bra_02_B208:
	JSR _loc_02_B233
	LDA $E4
	ORA #$30
	STA nmt_buffer + 3,X
	DEX
	LDA $E0
	ORA $E1
	BNE bra_02_B208
	TXA
	BMI bra_02_B22A
_loc_02_B21F:
	LDA #$00
	STA nmt_buffer + 3,X
	DEX
	BMI bra_02_B22A
	JMP _loc_02_B21F
bra_02_B22A:
	LDA #$00
	STA $E8
	STA $E9
	RTS

_loc_02_B233:
	TXA
	PHA
	LDA #$00
	STA $E4
	LDX #$10
	ROL $E0
	ROL $E1
bra_02_B242:
	ROL $E4
	LDA $E4
	CMP $E2
	BCC bra_02_B253
	SBC $E2
	STA $E4
bra_02_B253:
	ROL $E0
	ROL $E1
	DEX
	BNE bra_02_B242
	PLA
	TAX
	RTS

table_02_B25F:		; байты nametable счета между таймами
.byte $20,$80,$20,$80,$20,$80,$20,$80,$20,$80,$0E,$80,$84,$B9,$80,$80
.byte $BB,$0E,$80,$08,$80,$90,$A0,$A1,$A4,$A5,$B0,$00,$B9,$80,$80,$BB
.byte $00,$A8,$A9,$AC,$AD,$B8,$08,$80,$08,$80,$90,$A2,$A3,$A6,$A7,$B2
.byte $00,$B9,$80,$80,$BB,$00,$AA,$AB,$AE,$AF,$BA,$08,$80,$08,$80,$81
.byte $84,$0E,$8A,$81,$85,$08,$80,$08,$80,$81,$88,$06,$00,$82,$56,$53
.byte $06,$00,$81,$89,$08,$80,$08,$80,$81,$88,$0E,$00,$81,$89,$08,$80
.byte $08,$80,$81,$88,$05,$00,$83,$31,$53,$54,$06,$00,$81,$89,$08,$80
.byte $08,$80,$81,$88,$0E,$00,$81,$89,$08,$80,$04,$82,$85,$80,$B3,$B3
.byte $80,$88,$05,$00,$83,$32,$4E,$44,$06,$00,$85,$89,$80,$B3,$B3,$80
.byte $04,$82,$89,$90,$91,$94,$95,$8C,$8D,$8E,$8F,$88,$0E,$00,$89,$89
.byte $8C,$8D,$8E,$8F,$90,$91,$94,$95,$89,$92,$93,$96,$97,$92,$93,$96
.byte $97,$88,$05,$00,$85,$54,$4F,$54,$41,$4C,$04,$00,$89,$89,$92,$93
.byte $96,$97,$92,$93,$96,$97,$89,$94,$95,$90,$91,$94,$95,$90,$91,$88
.byte $0E,$00,$89,$89,$94,$95,$90,$91,$94,$95,$90,$91,$89,$96,$97,$92
.byte $93,$96,$97,$92,$93,$86,$0E,$8B,$89,$87,$96,$97,$92,$93,$96,$97
.byte $92,$93,$8D,$90,$91,$94,$95,$90,$91,$94,$95,$90,$91,$94,$95,$98
.byte $06,$99,$8D,$9C,$90,$91,$94,$95,$90,$91,$94,$95,$90,$91,$94,$95
.byte $8D,$92,$93,$96,$97,$92,$93,$96,$97,$92,$93,$96,$97,$9A,$06,$9B
.byte $8D,$9E,$92,$93,$96,$97,$92,$93,$96,$97,$92,$93,$96,$97,$0C,$81
.byte $81,$9D,$06,$B1,$81,$9F,$0C,$81,$20,$83,$20,$80,$20,$80,$20,$80
.byte $20,$80,$20,$80,$20,$80,$12,$AA,$84,$0F,$0B,$0E,$0F,$04,$AA,$04
.byte $00,$02,$AA,$02,$FF,$04,$00,$02,$FF,$03,$0F,$02,$00,$03,$0F,$10
.byte $00,$00

table_02_B3C1:		; 3 буквы имен команд
.byte $42,$52,$41
.byte $46,$52,$47
.byte $49,$54,$41
.byte $48,$4F,$4C
.byte $41,$52,$47
.byte $55,$52,$53
.byte $55,$52,$55
.byte $50,$4F,$4C
.byte $45,$4E,$47
.byte $53,$50,$41
.byte $43,$4F,$4C
.byte $53,$43,$4F
.byte $46,$52,$41
.byte $55,$53,$41
.byte $4B,$4F,$52
.byte $4A,$50,$4E

_loc_02_B3F1:		; начальная позиция флагов на экране со счетом и пропуск этого экрана
	LDX #$00
	LDY #$00
bra_02_B3F3:
	LDA table_02_B4AD,X
	STA oam_y,Y
	INX
	LDA table_02_B4AD,X
	STA oam_t,Y
	INX
	LDA table_02_B4AD,X
	STA oam_a,Y
	INX
	LDA table_02_B4AD,X
	STA oam_x,Y
	INX
	INY
	CPX #$18
	BNE bra_02_B3F3
	LDA #$2C
	STA $E3
	LDA #$01
	STA $E4
	LDA #$04
	STA $E5
	STA $E6
	LDA #$01
	STA $E7
	LDA #$21
	STA $E8
	LDA #$00
	STA $E9
bra_02_B41F:
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_02_B458
	JSR _loc_02_B488
	LDA #(BTN_A | BTN_START)	; попытка пропуска экрана со счетом
	AND btn_press
	BNE bra_02_B452
	LDA #$01
	STA $E9
bra_02_B436:
	LDA $E3
	SEC
	SBC #$01
	STA $E3
	LDA $E4
	SBC #$00
	STA $E4
	LDA $E3
	ORA $E4
	BNE bra_02_B41F
	RTS
bra_02_B452:
	LDA $E9
	BEQ bra_02_B436
	RTS

_loc_02_B458:		; флаги на экране со счетом
	DEC $E5
	BNE bra_02_B487
	LDA $E7
	ASL
	ASL
	ASL
	ASL
	TAX
	LDY #$00
bra_02_B467:
	LDA table_02_B4C5,X
	STA oam_y,Y
	INX
	LDA table_02_B4C5,X
	STA oam_t,Y
	INX
	LDA table_02_B4C5,X
	STA oam_a,Y
	INX
	LDA table_02_B4C5,X
	STA oam_x,Y
	INX
	INY
	CPY #$04
	BNE bra_02_B467
	INC $E7
	LDA $E7
	CMP #$03
	BNE bra_02_B482
	LDA #$00
	STA $E7
bra_02_B482:
	LDA #$04
	STA $E5
bra_02_B487:
	RTS

_loc_02_B488:
	DEC $E6
	BNE bra_02_B4AC
	INC $E8
	LDA $E8
	CMP #$2D
	BNE bra_02_B49C
	LDA #$21
	STA $E8
bra_02_B49C:
	LDA $E8
	STA $0390
	INC bg_or_pal_write_flag
	LDA #$04
	STA $E6
bra_02_B4AC:
	RTS

table_02_B4AD:		; параметры спрайтов флагов на экране со счетом (начальные байты)
.byte $38,$B5,$00,$78
.byte $F0,$BD,$00,$80
.byte $38,$B5,$00,$8A
.byte $F0,$BD,$00,$92
.byte $3F,$69,$01,$68
.byte $3F,$69,$01,$90

table_02_B4C5:		; параметры спрайтов флагов на экране со счетом (анимация)
.byte $38,$B5,$00,$78
.byte $F0,$BD,$00,$80
.byte $38,$B5,$00,$8A
.byte $F0,$BD,$00,$92
.byte $38,$B7,$00,$78
.byte $38,$BD,$00,$80
.byte $38,$B7,$00,$8A
.byte $38,$BD,$00,$92
.byte $38,$BF,$00,$78
.byte $F0,$BD,$00,$80
.byte $38,$BF,$00,$8A
.byte $F0,$BD,$00,$92

; B4F5 fill FF