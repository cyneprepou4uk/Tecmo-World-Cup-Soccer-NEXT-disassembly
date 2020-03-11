.segment "BANK_03"
.include "ram.inc"
.include "val.inc"

.import _MusicDriver_b00
.import _loc_01_804E
.import _loc_01_80A3_minus1
.import _loc_01_81D9
.import _loc_01_827E
.import _loc_01_87ED
.import _loc_01_88E0
.import _loc_01_8596_minus1
.import _loc_01_863C
.import _loc_01_8696
.import _loc_01_878F
.import _TeamsPalette_and_BallPalette_b01
.import _loc_01_847D
.import _loc_01_83AA
.import _loc_01_8361
.import _loc_01_8A71
.import _loc_01_89F3
.import _loc_01_8341_minus1
.import _loc_01_8BE8
.import _loc_01_8D1A
.import _SetBotTimerThrowIn_b01
.import _loc_01_8B6B
.import _loc_01_8B24
.import _loc_01_886C
.import _loc_01_88B2
.import _loc_01_8B3F
.import _TeamSelecScreentFunction_and_PasswordScreenFunction_b02
.import _loc_02_83C9
.import _loc_02_8A1A_minus1
.import _LoadLogoPalette_b02
.import _loc_02_80D1_minus1
.import _MainMenuScreenFunction_b03
.import _loc_02_9842
.import _loc_02_974F
.import _loc_02_A02A
.import _loc_02_A0F0
.import _loc_02_A1ED
.import _loc_02_A330_minus1
.import _loc_02_8033
.import _loc_02_B000

_RESET_VECTOR:		; C081
	LDA #$00
	STA $8000
	LDA #$08
	STA $2000
	SEI
	CLD
	LDX #$FF
	TXS
@wait_for_vblank1:
	LDA $2002
	BPL @wait_for_vblank1
@wait_for_vblank2:
	LDA $2002
	BPL @wait_for_vblank2
	LDA #$00
	STA $00
	STA $01
	TAY
	LDX #$08
@clear_ram_loop:
	STA ($00),Y
	INY
	BNE @clear_ram_loop
	INC $01
	DEX
	BNE @clear_ram_loop
	LDA #$28
	STA byte_for_2000
	LDA #$06
	STA byte_for_2001
	STA $2001
	LDA #$00
	STA $A000
	STA $E000
	STA $4010
	LDA #$40
	STA $4017
	LDA $2002
	LDA #$10
	TAX
@loop:
	STA $2006
	STA $2006
	DEX
	BNE @loop
	JSR _ClearNametable_b03
	JSR _HideAllSprites_b03
	LDX #$E0
	TXS
	LDA #$00
	STA $01
	STA $02
	STA $05
	STA $06
	STA $09
	STA $0A
	STA $0D
	STA $0E
	STA $11
	STA $12
	STA $15
	STA $16
	LDA #$28
	STA byte_for_2000
	LDA #$1E
	STA byte_for_2001
	LDA #$20
	STA pal_buf_cnt
	LDA #$00
	STA pal_buf_ppu_lo
	LDA #$3F
	STA pal_buf_ppu_hi
	LDX #$00
	LDA #$00
	JSR _LoadScreenPalette_b03
	LDX #$10
	LDA #$01
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDX #$01
	LDA #$1E
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_C2F2_minus1
	LDY #<_loc_03_C2F2_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA byte_for_2000
	ORA #$80
	STA byte_for_2000
	STA byte_for_2000_nmi
	STA $2000		; enable NMI
	JMP _PauseCheck_03_C55B

_NMI_VECTOR:
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA byte_for_2000
	AND #$7F
	STA $2000
	STA byte_for_2000
	TSX
	TXA
	LDX #$FF
	TXS
	PHA
	LDA #<oam_mem
	STA $2003
	LDA #>oam_mem
	STA $4014
	JSR _WriteToPPU_Palette_and_Background
	BIT $2002
	LDA #$3F		; хз зачем это
	STA $2006
	LDA #$00		; а тут видимо запись скроллинга
	STA $2006
	STA $2006
	STA $2006
	LDA byte_for_2000
	STA $2000
	BIT $2002
	LDA $3A
	STA $2005
	LDA $3B
	STA $2005
	LDA #$06
	STA $8000
	LDA #$00
	STA $8001		; банксвич 06
	LDA #$07
	STA $8000
	LDA #$01
	STA $8001		; банксвич 07
	JSR _MusicDriver_b00
	JSR JoystickDriver
	JSR BankswitchCHR
	LDA $23
	ORA #$80
	STA $23
	LDA #$06
	STA $8000
	LDA prg_bank
	STA $8001		; банксвич 06
	LDA #$07
	STA $8000
	LDA prg_bank + 1
	STA $8001		; банксвич 07
	JSR _RandomGenerator
	PLA
	TAX
	TXS
	LDA byte_for_8000
	STA $8000
	LDA byte_for_2000
	ORA #$80
	STA byte_for_2000
	STA byte_for_2000_nmi
	STA $2000
	PLA
	TAY
	PLA
	TAX
	PLA
	RTI			; возврат из NMI

_WriteToPPU_Palette_and_Background:		; C1EB
	LDA bg_or_pal_write_flag
	BEQ _WriteToPPU_Background
; запись палитры
	DEC bg_or_pal_write_flag
	LDA #<pal_buffer
	STA $3D
	LDA #>pal_buffer
	STA $3E
	LDY #$00
@set_ppu_addr:
	LDA ($3D),Y		; всегда читается из 0380
	BEQ @rts		; вряд ли в 0380 когда-либо будет 00, там почти все время 20, возможно можно удалить
	TAX
	INY
	LDA ($3D),Y
	PHA
	INY
	LDA ($3D),Y
	BIT $2002
	STA $2006
	PLA
	STA $2006
	INY
@write_loop:
	LDA ($3D),Y
	STA $2007
	INY
	DEX
	BNE @write_loop
	BEQ @set_ppu_addr
@rts:
	RTS

_WriteToPPU_Background:		; C227
	LDA $037D
	BPL @rts
	LDX #$00
	STX $037D
@set_ppu_addr:
	LDA nmt_buf_cnt,X
	BEQ @rts
	TAY
	INX
	LDA nmt_buf_ppu_lo - 1,X
	PHA
	INX
	LDA nmt_buf_ppu_hi - 2,X
	BIT $2002
	STA $2006
	PLA
	STA $2006
	INX
@write_loop:
	LDA nmt_buffer,X
	STA $2007
	INX
	DEY
	BNE @write_loop
	BEQ @set_ppu_addr
@rts:
	RTS

JoystickDriver:		; C258
	LDX #$00
	LDA btn_hold
	JSR ReadJoyReg
	INX
	LDA btn_hold + 1
	JSR ReadJoyReg
	RTS

ReadJoyReg:		; C268
.scope
temp = $45
buttons_copy = $46
counter = $47
	STA buttons_copy		; хранение текущей нажатой кнопки
	LDY #$01
	STY $4016
	DEY
	STY $4016
	LDA #$04
	STA counter
	LDY #$08
@read_loop:
	LDA $4016,X
	LSR
	ROL temp
	AND #$01
	ORA temp
	STA temp
	DEY
	BNE @read_loop
	CMP buttons_copy			; зачем-то сравнивается с предыдущими нажатыми кнопками
	BEQ @write_pressed_buttons
	DEC counter
	BNE ReadJoyReg
	BEQ @rts		; еще не использовался
@write_pressed_buttons:
	LDA btn_hold,X
	EOR temp
	AND temp
	STA btn_press,X
	LDA temp
	STA btn_hold,X
@rts:
	RTS
.endscope

BankswitchCHR:		; C2A2
; сначала запись двух банков фона
	LDA #$00
	STA $8000
	LDA chr_bank
	STA $8001
	LDA #$01
	STA $8000
	LDA chr_bank + 1
	STA $8001
	LDX #$00
	LDY #$02
@sprites_bankswitch_loop:
	STY $8000
	LDA chr_bank + 2,X
	STA $8001
	INX
	INY
	CPY #$06
	BNE @sprites_bankswitch_loop
	RTS

_RandomGenerator:		; C2CE
	LDX frame_cnt
	LDA $0300,X
	ADC $0700,X
	ROL random
	EOR #$FF
	ROL random
	ADC random
	STA random
	SBC $0780,X
	ADC frame_cnt
	STA random + 1
	INC frame_cnt
	RTS

_loc_03_C2F2:		; C2F2
_loc_03_C2F2_minus1 = _loc_03_C2F2 - 1
	LDA byte_for_2001
	ORA #$1E
	STA byte_for_2001
_GoToLogoScreen:		; C2F8 переход сюда после завершения матча в режиме 2 players
	LDA game_mode_flags
	AND #$FB
	STA game_mode_flags
	LDA #$00
	STA $03D2
	LDA #MUSIC_LOGO
	JSR _WriteSoundID_b03
	LDA #$04
	JSR _FrameDelay_b03
	LDX #$05
	LDA #$3C
	STA $01,X
	LDA #$04
	STA $02,X
	LDA #>_loc_02_8A1A_minus1
	LDY #<_loc_02_8A1A_minus1
	JSR _SetSubReturnAddressForLater_b03
@delay_loop:
	LDA #$01
	JSR _FrameDelay_b03
; попытка ускорить загрузку начального экрана
	LDA #BTN_START
	AND btn_press
	BNE @start_was_pressed
	BIT $03D2
	BPL @delay_loop
@start_was_pressed:
	BIT $03D2
	BMI @skip_palette_load
	LDA #$80
	STA $03D2
	LDA #$00
	STA $3B
	STA $3A
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _LoadLogoPalette_b02
@skip_palette_load:
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _MainMenuScreenFunction_b03
	LDA game_mode_flags
	ORA #FLAG_GM_UNKNOWN_08
	STA game_mode_flags
	LDA #$FF		; для экрана с паролем, чтобы знать нужно ли вводить пароль если FF
	STA team_id
_ContinueWalkthrough:		; C36E переход сюда если играть против компа и победить/проиграть
	LDA #SOUND_OFF
	JSR _WriteSoundID_b03
	LDA game_mode_flags
	AND #$FB
	STA game_mode_flags
	LDA #$00
	STA goals_total
	STA goals_total + 1
	STA goals_pk
	STA goals_pk + 1
	STA goals_half
	STA goals_half + 1
	STA team_w_ball
	STA half_time_cnt
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _TeamSelecScreentFunction_and_PasswordScreenFunction_b02
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _loc_02_83C9
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _loc_01_8A71
	JSR _loc_03_C507
bra_03_C3C8:
	LDA #$01
	JSR _FrameDelay_b03
	LDA game_mode_flags
	AND #F_TIMEUP
	BEQ bra_03_C3C8
	JSR _loc_03_C476
	JSR _loc_03_C4B8
	JSR _loc_03_C507
	INC half_time_cnt
	LDA #$0B
	STA team_w_ball
bra_03_C3E5:
	LDA #$01
	JSR _FrameDelay_b03
	LDA game_mode_flags
	AND #$01
	BEQ bra_03_C3E5
	JSR _loc_03_C476
	JSR _loc_03_C4B8
	JSR _loc_03_C425
	LDX #$05
	LDA #$3C
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_CE73_minus1
	LDY #<_loc_03_CE73_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA game_mode_flags
	ORA #F_GM_PENALTY
	STA game_mode_flags
bra_03_C413:
	LDA #$01
	JSR _FrameDelay_b03
	LDA game_mode_flags
	AND #F_GM_PENALTY
	BNE bra_03_C413
	JSR _loc_03_C425
@infinite_loop:
	JMP @infinite_loop
_loc_03_C425:
	LDX #$00
	LDA goals_total			; сравнение голов для выявления победителя
	CMP goals_total + 1
	BEQ @draw
	BCC @you_lost
	LDX #$08
@you_lost:
	LDA game_mode_flags
	AND #$F7
	STA game_mode_flags
	TXA
	ORA game_mode_flags
	STA game_mode_flags
	PLA
	PLA
	BIT game_mode_flags
	BPL @one_player_mode
	JMP _GoToLogoScreen
@one_player_mode:
	TXA
	BEQ @continue_vs_cpu
	LDA game_cnt
	CMP #$0E
	BNE @continue_vs_cpu
	JMP @all_teams_defeated
@continue_vs_cpu:
	JMP _ContinueWalkthrough
@draw:
	RTS
@all_teams_defeated:
	LDX #$05
	LDA #$3C
	STA $01,X
	LDA #$04
	STA $02,X
	LDA #>_loc_02_80D1_minus1
	LDY #<_loc_02_80D1_minus1
	JSR _SetSubReturnAddressForLater_b03
@wait:		; будет выполняться ежекадрово, выхода из титров не существует
	LDA #$01
	JSR _FrameDelay_b03
	JMP @wait

_loc_03_C476:
	LDA game_mode_flags
	AND #$FB
	STA game_mode_flags
	LDA #$00
	STA $05
	STA $06
	LDA #$00
	STA $09
	STA $0A
	LDA #$00
	STA $0D
	STA $0E
	LDA #$00
	STA $11
	STA $12
	LDA #$00
	STA $15
	STA $16
	LDA #$00
	STA $19
	STA $1A
	LDA #$00
	STA $1D
	STA $1E
	LDA #SOUND_TIME_UP
	JSR _WriteSoundID_b03
	LDA #MSG_TIME_UP
	JSR _WriteMessageOnScreenWithSprites
	LDA #$A0
	JSR _FrameDelay_b03
	RTS

_loc_03_C4B8:
	JSR _ClearNametable_b03
	JSR _HideAllSprites_b03
	LDA byte_for_2000
	AND #$FC
	STA byte_for_2000
	LDA #$00
	STA $3A
	STA $3B
	LDX #$00
	LDA #$07
	JSR _LoadScreenPalette_b03
	LDX #$10
	LDA #$08
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #$1C
	STA chr_bank
	LDA #$1A
	STA chr_bank + 1
	LDX #$03
bra_03_C4E7:
	TXA
	CLC
	ADC #$18
	STA chr_bank + 2,X
	DEX
	BPL bra_03_C4E7
	LDA #MUSIC_HALF_TIME
	JSR _WriteSoundID_b03
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _loc_02_B000
	RTS

_loc_03_C507:
	JSR _ClearNametable_b03
	JSR _HideAllSprites_b03
	JSR _ClearRamBeforeMatch
	JSR _loc_03_CF97
	LDA #$04
	STA chr_bank + 2
	LDA #$00
	STA $03B6
	STA cam_edge_x_lo
	STA cam_edge_x_hi
	STA $03BB
	STA cam_edge_y_lo
	STA cam_edge_y_hi
	LDA #$3B
	STA timer_ms
	LDA #$00
	STA timer_sec
	LDX timer_opt
	LDA Minutes_table_03_C558,X
	STA timer_min
	LDX #$05
	LDA #$3C
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_CCC4_minus1
	LDY #<_loc_03_CCC4_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA game_mode_flags
	AND #$DE
	STA game_mode_flags
	RTS

Minutes_table_03_C558:		; время тайма
.byte $0F,$1E,$2D

_PauseCheck_03_C55B:
; попытка поставить игру на паузу
	LDA game_mode_flags		; проверка режима игры
	AND #FLAG_GM_UNKNOWN_04
	BEQ @skip_pause
	LDA #BTN_START
	AND btn_press
	BEQ @skip_pause
	JSR _SetPauseInGame
@skip_pause:
	LDX #$01
loop_03_C56E:
	LDA $00,X
	BEQ @next_check
	CMP #$FF
	BEQ _BankswitchPRG_03_C5CE
	DEC $00,X		; уменьшение задержки на 01
	BEQ _BankswitchPRG_03_C5B3
@next_check:
_LoopFrameDelay:		; сюда есть 2 JMP
	TXA
	CLC
	ADC #$04		; X + 4
	TAX
	CPX #$21
	BNE loop_03_C56E
@infinite_loop:
	LDA $23
	BPL @infinite_loop
	AND #$7F
	STA $23
	JMP _PauseCheck_03_C55B

_SetPauseInGame:		; C58E
	LDA #MSG_PAUSE
	JSR _WriteMessageOnScreenWithSprites
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _loc_02_8033
@infinite_loop:		; ожидание выхода из паузы
	LDA $23
	BPL @infinite_loop
	AND #$7F
	STA $23
	LDA #BTN_START
	AND btn_press
	BEQ @infinite_loop
	RTS

_BankswitchPRG_03_C5B3:		; C5B3
	LSR byte_for_2000_nmi
	STX $00
	LDA $02,X
	STA prg_bank
	LDA $03,X
	STA prg_bank + 1
	JSR _BankswitchPRG
	LDA $01,X
	TAX
	TXS
	SEC
	ROR byte_for_2000_nmi
	PLA
	TAY
	PLA
	TAX
	RTS

_BankswitchPRG_03_C5CE:		; C5CE
	STX $00
	LDA $02,X
	STA prg_bank
	CLC
	ADC #$01
	STA prg_bank + 1
	JSR _BankswitchPRG
	LDA $01,X
	TAX
	TXS
	RTS

.export _SetSubReturnAddressForLater_b03
_SetSubReturnAddressForLater_b03:		; C5E1
; возврат впоследствии осуществляется из C5CE
; параметры входа в подпрограмму
	; $01,X - откуда читать стек	(1E 3C 5A 78 96 B4 D2)
	; X - откуда читать $01			(01 05 09 0D 11 15 19)
	; A - старший байт адреса
	; Y - младший байт адреса
	PHA
	TYA
	LDY $01,X
	STA $0101,Y
	PLA
	STA $0102,Y
	LDA #$FF		; байт FF означает что возврат готов
	STA $00,X
	RTS

.export _loc_03_C5F1
_loc_03_C5F1:
	LDA #$00
	LDX $00
	STA $00,X
	STA $01,X
	JMP _LoopFrameDelay

.export _FrameDelay_b03
_FrameDelay_b03:		; C609
; в A подается количество кадров задержки, при задержке работает в основном лишь NMI
; что позволяет воспроизвести музыку, опросить джойстик и отрисовать графику
	STA $49
	TXA
	PHA
	TYA
	PHA
	LDX $00
	LDA prg_bank
	STA $02,X
	LDA prg_bank + 1
	STA $03,X
	LDA $49
	STA $00,X
	TXA
	TAY
	TSX
	STX $01,Y
	LDX $00
	JMP _LoopFrameDelay

; C627 (еще не считывались, неизвестно откуда читается, вероятно мусор)
.byte $20,$40,$18,$18,$18,$18,$18,$18

.export _SelectPlayerSubroutine_b03
_SelectPlayerSubroutine_b03:		; C62F
; на вход подается A с номером нужной подпрограммы из таблицы
	TAX
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL
	BNE @rts
	TXA
	LDY #plr_state
	STA (plr_data),Y
	ASL
	TAX
	LDA PlyerStateSubroutine_table + 1,X
	LDY #plr_sub_hi
	STA (plr_data),Y
	INY
	LDA PlyerStateSubroutine_table,X
	STA (plr_data),Y	; plr_sub_lo
	LDA #$01
	INY
	STA (plr_data),Y
@rts:
	RTS

_SavePlayerSubroutine:		; C652
	LDY #plr_sub1_timer
	STA (plr_data),Y
	DEY
	PLA
	STA (plr_data),Y	; plr_sub_lo
	DEY
	PLA
	STA (plr_data),Y	; plr_sub_hi
	JMP SelectNextIndexForPlayers

_IncreasePlayerAnimationCounterLow:		; C66D
	LDY #plr_anim_cnt_lo
	LDA (plr_data),Y
	CLC
	ADC #$01
	STA (plr_data),Y
	RTS

_ClearPlayerAnimationCounterLow:		; C677
	LDY #plr_anim_cnt_lo
	LDA #$00
	STA (plr_data),Y
	RTS

_IncreasePlayerRunningAnimation:		; C67E
; анимация увеличивается во время обычного бега, лишний код был удален в 017
; тут нужно сделать нормальную таблицу с байтами увеличения дробной части анимации в зависимости от скорости
	LDY #plr_anim_cnt_fr
	LDA #$20
	CLC
	ADC (plr_data),Y
	STA (plr_data),Y
	BCC @rts
	DEY
	LDA (plr_data),Y	; plr_anim_cnt_lo
	CLC
	ADC #$01
	AND #$03
	STA (plr_data),Y
	LDA #$04
	LDY plr_cur_id
	BEQ @player_is_gk
	CPY #$0B
	BEQ @player_is_gk
	LDA #$03
@player_is_gk:
	JSR _loc_01_878F
@rts:
	RTS

_loc_03_C6B9:
	STA plr_w_ball
	CMP #$0B
	LDA #$00
	BCC bra_03_C6C4
	LDA #$0B
bra_03_C6C4:
	CMP team_w_ball
	STA $0428
	STA team_w_ball
	BEQ bra_03_C6DA
	LDA #$80
	ORA $042C
	STA $042C
	JSR _loc_03_C6E1
bra_03_C6DA:
	LDA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	RTS

_loc_03_C6E1:
	LDA plr_wo_ball
	BMI bra_03_C6F6
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
bra_03_C6F6:
	JSR _loc_03_C71D
	BCS bra_03_C703
	LDA team_w_ball
	EOR #$0B
	JSR _FindClosestPlayer_ForControl
bra_03_C703:
	STA plr_wo_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL
	BNE bra_03_C717
	LDA #STATE_WITHOUT_BALL
	JSR _SelectPlayerSubroutine_b03
	RTS

; код еще не выполнялся
bra_03_C717:
	LDA #$FF
	STA plr_wo_ball
	RTS

_loc_03_C71D:
	LDX cam_edge_y_lo
	LDY cam_edge_y_hi
	SEC
	TXA
	SBC #$60
	TYA
	SBC #$02
	BCC bra_03_C73A
	LDA #$00
	LDX plr_w_ball
	BMI bra_03_C750
	CPX #$0B
	BCS bra_03_C750
	JMP _loc_03_C74E
bra_03_C73A:
	SEC
	TXA
	SBC #$B0
	TYA
	SBC #$00
	BCS bra_03_C74E
	LDA #$0B
	LDX plr_w_ball
	BMI bra_03_C750
	CPX #$0B
	BCC bra_03_C750
_loc_03_C74E:
bra_03_C74E:
	CLC
	RTS

bra_03_C750:
	SEC
	RTS

.export _PrepareBytesForNametable_b03
_PrepareBytesForNametable_b03:	; C752
; X - младший байт для $43
; Y - старший байт для $44
.scope
nmt_data = $43
	STX nmt_data
	STY nmt_data + 1
@main_loop:
	LDY #$00
	LDA (nmt_data),Y
	BEQ @rts
	PHA
@wait:
	LDA #$01
	JSR _FrameDelay_b03
	LDA $037D
	BNE @wait
	LDA #$01
	STA $037D
	PLA
	TAX
	STA nmt_buf_cnt
	INY
	LDA (nmt_data),Y
	STA nmt_buf_ppu_lo
	INY
	LDA (nmt_data),Y
	STA nmt_buf_ppu_hi
	INY
@loop:
	LDA (nmt_data),Y
	STA nmt_buffer,Y
	INY
	DEX
	BNE @loop
	TXA
	STA nmt_buffer,Y
	TYA
	CLC
	ADC nmt_data
	STA nmt_data
	BCC @skip
	INC nmt_data + 1
@skip:
	LDA #$80
	STA $037D
	JMP @main_loop
@rts:
	RTS
.endscope

_BallRelativePosition:		; C79E
; позиция мяча относительно игрока когда тот держит мяч
; на вход подается A
.scope
index = $2A
	ASL
	STA index
	ASL
	ADC index	; умножить на 6
	STA index
	LDY #plr_dir
	LDA (plr_data),Y
	CLC
	ADC #$10	; округлить число в большую сторону до кратного $20, видимо для ботов раз те поворачиваются на любой угол
	AND #$E0	; оставить числа кратные $20
	LSR
	LSR
	LSR			; разделить на $20, получится 8 значений
	LSR
	LSR
	TAX
	LDA AdditionalIndexForDirection_table,X
	CLC
	ADC index
	STA index
	TAX
	LDY #plr_spr_a
	LDA (plr_data),Y
	AND #$40	; проверить поворот спрайта игрока по горизонтали
	PHP
	LDA BallPositionRelativeX_table,X
	PLP
	BEQ @skip_eor
	EOR #$FF
	CLC
	ADC #$01
@skip_eor:
	PHA
	LDY #plr_pos_x_lo
	CLC
	ADC (plr_data),Y
	STA ball_pos_x_lo
	INY
	INY
	LDX #$00
	PLA
	BPL @skip
	DEX
@skip:
	TXA
	ADC (plr_data),Y
	STA ball_pos_x_hi
	LDY #plr_spr_a
	LDA (plr_data),Y
	PHP
	LDX index
	LDA BallPositionRelativeY_table,X
	PLP
	BPL @skip_eor2
	EOR #$FF
	CLC
	ADC #$01
@skip_eor2:
	PHA
	LDY #plr_pos_y_lo
	CLC
	ADC (plr_data),Y
	STA ball_pos_y_lo
	INY
	INY
	LDX #$00
	PLA
	BPL @skip2
	DEX
@skip2:
	TXA
	ADC (plr_data),Y
	STA ball_pos_y_hi
	RTS
.endscope

AdditionalIndexForDirection_table:		; C811 сложение с индексом поворота
.byte $00,$02,$04,$02,$00,$02,$04,$02

BallPositionRelativeX_table:		; C819
BallPositionRelativeY_table = BallPositionRelativeX_table + 1
; 21 позиций мяча относительно игрока (X и Y)
; с учетом стороны поворота игрока и его действия
.byte $01,$F7
.byte $FB,$F9
.byte $F7,$02
.byte $00,$FA
.byte $F6,$FB
.byte $FA,$00
.byte $00,$04
.byte $06,$06
.byte $07,$01
.byte $00,$04
.byte $FD,$FD
.byte $FC,$00
.byte $01,$FD
.byte $FF,$FF
.byte $FD,$01
.byte $02,$00
.byte $04,$00
.byte $00,$02
.byte $00,$FD
.byte $FD,$FD
.byte $00,$FD

_loc_03_C843:
	SEC
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	SBC #$10
	TAX
	INY
	INY
	LDA (plr_data),Y
	SBC #$00
	BCS bra_03_C856
	LDA #$00
	TAX
bra_03_C856:
	TAY
	LDA #$00
_loc_03_C859:
	PHA
	SEC
	TXA
	SBC #$30
	TAX
	TYA
	SBC #$00
	TAY
	PLA
	BCC bra_03_C86B
	ADC #$00
	JMP _loc_03_C859
bra_03_C86B:
	CMP #$0A
	BCC bra_03_C871
	LDA #$00
bra_03_C871:
	PHA
	SEC
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	SBC #$98
	TAX
	INY
	INY
	LDA (plr_data),Y
	SBC #$00
	BCS bra_03_C885
	LDA #$00
	TAX
bra_03_C885:
	TAY
	PLA
bra_03_C887:
	PHA
	SEC
	TXA
	SBC #$30
	TAX
	TYA
	SBC #$00
	TAY
	PLA
	BCC bra_03_C89C
	ADC #$09
	CMP #$96
	BCC bra_03_C887
	SBC #$0A
bra_03_C89C:
	RTS

.export _loc_03_C89D
_loc_03_C89D:
	LDX #$00
bra_03_C89F:
	CMP #$0A
	BCC bra_03_C8A8
	SBC #$0A
	INX
	BNE bra_03_C89F
bra_03_C8A8:
	STX $37
	JSR _loc_03_C8D3
	TXA
	CLC
	ADC #$28
	TAX
	TYA
	ADC #$00
	LDY #plr_aim_x_hi
	STA (plr_data),Y
	DEY
	TXA
	STA (plr_data),Y
	LDA $37
	JSR _loc_03_C8D3
	TXA
	CLC
	ADC #$B0
	TAX
	TYA
	ADC #$00
	LDY #plr_aim_y_hi
	STA (plr_data),Y
	DEY
	TXA
	STA (plr_data),Y
	RTS

_loc_03_C8D3:
	LDX #$00
	STX $39
	ASL
	ASL
	ASL
	ASL
	STA $38
	ROL $39
	LDY $39
	ASL
	ROL $39
	ADC $38
	TAX
	TYA
	ADC $39
	TAY
	RTS

_ClearRamBeforeMatch:		; C8EC
; очистка 03B4-06B3 и 0769-07FF
.scope
ram = $2A
ram_lo = $2A
ram_hi = $2B
	LDA #$B4
	STA ram_lo
	LDA #$03
	STA ram_hi
	LDX #$03
	LDA #$00
	TAY
@main_loop:
	DEX
	BMI @clear_the_rest
@clear_loop:	; очистка 03B4-06B3
	STA (ram),Y
	INY
	BNE @clear_loop
	INC ram_hi
	JMP @main_loop
@clear_the_rest:
	LDY #$B5
@loop:		; очистка 06B5-06FF
	STA (ram),Y
	INY
	BNE @loop
@rts:
	RTS
.endscope

.export _WriteSoundID_b03
_WriteSoundID_b03:		; C910
	LDY sound_cnt
	CPY #$04
	BCS @skip
	STA sound_queue,Y
	INC sound_cnt
@skip:
	RTS

.export _EOR_16bit_b03
_EOR_16bit_b03:		; C91E
	TXA
	EOR #$FF
	TAX
	TYA
	EOR #$FF
	TAY
	INX
	BNE @skip
	INY
@skip:
	RTS

_loc_03_C92B:
	CMP #$0B
	LDA #$00
	BCC bra_03_C933
	LDA #$0B
bra_03_C933:
	STA $0428
	RTS

_SetUnknownPlayerFlag:		; C937
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #FLAG_PL_UNKNOWN
	STA (plr_data),Y
	RTS

_ClearUnknownPlayerFlag:		; C940
	LDY #plr_flags
	LDA (plr_data),Y
	AND #FLAG_PL_UNKNOWN_CLEAR
	STA (plr_data),Y
	RTS

; код еще не выполнялся
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	STA (plr_data),Y
	RTS

; код еще не выполнялся
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	RTS

_FindClosestPlayer_ForControl:		; C95B 
; поиск ближайшего к мячу в пределах 16 пикселей
; в A подается 00 или 0B
	LDX #$00
	STX my_temp
	BEQ _BeginSearchForClosestPlayer
_FindClosestPlayer_ForRecievePass:
	LDX #$80
	STX my_temp
_BeginSearchForClosestPlayer:
.scope
base_player_number = $2A	; начальный номер игрока команды
search_range_lo = $2B
search_range_hi = $2C
player_number = $2D			; номер игрока, который станет управляемым
counter = $2E
	STA base_player_number
	INC base_player_number		; пропуск киперов
	LDA #$10
	STA search_range_lo
	LDA #$00
	STA search_range_hi
@main_loop:
	LDA base_player_number
	STA player_number
	LDA #$0A
	STA counter
@search_loop:
	LDA player_number
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL
	BNE @no_control
	BIT my_temp
	BMI @check_pass
	JSR _CheckIfPlayerIsCloseToBall
	JMP @skip2
@check_pass:
	JSR _CheckIfPlayerIsCloseToPass
@skip2:
	BCS @player_is_close
@no_control:
	INC player_number
	DEC counter
	BNE @search_loop
	LDA search_range_lo		; увеличить диапазон поиска
	CLC
	ADC #$10
	STA search_range_lo
	BCC @main_loop
	INC search_range_hi
	JMP @main_loop
@player_is_close:
	LDA player_number
	RTS
.endscope

_CheckIfPlayerIsCloseToBall:		; C998, хорошо бы объединить с CA17, можно через LDA,Z
										; либо выделить 4 temp и скопировать туда нужные данные заранее
; на вход подается $2B (lo) и $2C (hi)
; на выходе C = 1 если игрок в пределах искомого радиуса
.scope
search_range_lo = $2B
search_range_hi = $2C
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	SEC
	SBC ball_pos_x_lo
	TAX
	INY
	INY
	LDA (plr_data),Y	; plr_pos_x_hi
	SBC ball_pos_x_hi
	TAY
	BCS @skip
	JSR _EOR_16bit_b03
@skip:
	SEC
	TXA
	SBC search_range_lo
	TYA
	SBC search_range_hi
	BCS @clc
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	SEC
	SBC ball_pos_y_lo
	TAX
	INY
	INY
	LDA (plr_data),Y	; plr_pos_y_hi
	SBC ball_pos_y_hi
	TAY
	BCS @skip2
	JSR _EOR_16bit_b03
@skip2:
	SEC
	TXA
	SBC search_range_lo
	TYA
	SBC search_range_hi
	BCS @clc
	SEC
	RTS
@clc:
	CLC
	RTS
.endscope

_CheckIfPlayerIsCloseToPass:		; CA17, хорошо бы объединить с C998,  можно через LDA,Z
; на вход подается $2B (lo) и $2C (hi)
; на выходе C = 1 если игрок в пределах искомого радиуса
.scope
search_range_lo = $2B
search_range_hi = $2C
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	SEC
	SBC ball_land_pos_x_lo
	TAX
	INY
	INY
	LDA (plr_data),Y	; plr_pos_x_hi
	SBC ball_land_pos_x_hi
	TAY
	BCS @skip
	JSR _EOR_16bit_b03
@skip:
	SEC
	TXA
	SBC search_range_lo
	TYA
	SBC search_range_hi
	BCS @clc
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	SEC
	SBC ball_land_pos_y_lo
	TAX
	INY
	INY
	LDA (plr_data),Y	; plr_pos_y_hi
	SBC ball_land_pos_y_hi
	TAY
	BCS @skip2
	JSR _EOR_16bit_b03
@skip2:
	SEC
	TXA
	SBC search_range_lo
	TYA
	SBC search_range_hi
	BCS @clc
	SEC
	RTS
@clc:
	CLC
	RTS
.endscope

.export _ClearNametable_b03
_ClearNametable_b03:		; CA59
	LDA byte_for_2000
	AND #$7F
	STA byte_for_2000
	STA $2000		; отключить NMI
	LDA #$06
	STA $2001		; включить рендеринг
	LDA #$20
	JSR _ClearNMT_Loop
	LDA #$24
	JSR _ClearNMT_Loop
	LDA #$1E
	STA $2001		; включить рендеринг
	LDA byte_for_2000
	ORA #$80
	STA byte_for_2000
	STA $2000		; включить NMI
	RTS

_ClearNMT_Loop:		; CA80 на вход подается 20 или 24 для очистки страницы nametable
	BIT $2002
	STA $2006
	LDA #$00
	STA $2006
	LDA #$00
	LDX #$C0
	LDY #$04
@ppu_clear_loop:		; очистка 2000-23BF или 2400-27BF
	STA $2007
	DEX
	BNE @ppu_clear_loop
	DEY
	BNE @ppu_clear_loop
	TXA
	LDX #$40
@loop:		; отдельная очистка атрибутов nametable
	STA $2007
	DEX
	BNE @loop
	BIT $2002
	LDA #$00
	STA $2005
	STA $2005
	RTS

.export _HideAllSprites_b03
_HideAllSprites_b03:		; CAAF
	LDY #$00
	LDA #$F8
@loop:
	STA oam_y,Y
	INY
	BNE @loop
	RTS

.export _ReadBytesAfterJSR_b03
_ReadBytesAfterJSR_b03:		; CABD здесь считываются байты, которые находятся после JSR
	ASL
	TAY
	PLA
	STA $3C
	PLA
	STA $3D
	INY
	LDA ($3C),Y
	PHA
	INY
	LDA ($3C),Y
	STA $3D
	PLA
	STA $3C
	JMP ($003C)

.export _LoadScreenPalette_b03
_LoadScreenPalette_b03:		; CAD4
; выбор палитры из таблицы
; параметры входа в подпрограмму
	; X - 
	; A - 
	LDY #$00
	STY $42
	ASL
	ROL $42
	ASL
	TAY
	ROL $42
	ASL
	ROL $42
	STA $41
	TYA
	ADC $41
	BCC @skip_increase
	INC $42
@skip_increase:
	CLC
	ADC #<ScreenPalette_table
	STA $41
	LDA $42
	ADC #>ScreenPalette_table
	STA $42
	LDA #$10
	STA pal_buf_cnt
	LDY #$00
bra_03_CAFD:
	TXA
	AND #$03
	BEQ bra_03_CB07
	LDA ($41),Y
	INY
	BNE bra_03_CB09
bra_03_CB07:
	LDA #$0F
bra_03_CB09:
	STA pal_buffer + 3,X
	INX
	DEC pal_buf_cnt
	BNE bra_03_CAFD
	LDA #$20
	STA pal_buf_cnt
	RTS

.export _EOR_16bit_plus2_b03
_EOR_16bit_plus2_b03:		; CB4A
	JSR _EOR_16bit_b03
	INY
	INY
	RTS

.export _EOR_16bit_plus4_b03
_EOR_16bit_plus4_b03:		; CB50
	JSR _EOR_16bit_b03
	INY
	INY
	INY
	INY
	RTS

_BankswitchPRG:		; CB58
	LDA #$06
	STA byte_for_8000
	STA $8000
	LDA prg_bank
	STA $8001
	LDA #$07
	STA byte_for_8000
	STA $8000
	LDA prg_bank + 1
	STA $8001
	RTS

_loc_03_CB75:
	TXA
	PHA
	LDA #$00
	STA $4E
	STA $4F
	STA $50
	STA $51
	LDX #$10
bra_03_CB83:
	ROR $4B
	ROR $4A
	BCC bra_03_CB96
	CLC
	LDA $50
	ADC $4C
	STA $50
	LDA $51
	ADC $4D
	STA $51
bra_03_CB96:
	ROR $51
	ROR $50
	ROR $4F
	ROR $4E
	DEX
	BNE bra_03_CB83
	PLA
	TAX
	RTS

_loc_03_CBA4:
	TXA
	PHA
	LDA #$00
	STA $55
	STA $56
	LDX #$18
	ROL $52
	ROL $53
	ROL $58
bra_03_CBB4:
	ROL $55
	ROL $56
	BCS bra_03_CBCA
	LDA $56
	CMP $57
	BEQ bra_03_CBC4
	BCC bra_03_CBD7
	BCS bra_03_CBCA
bra_03_CBC4:
	LDA $55
	CMP $54
	BCC bra_03_CBD7
bra_03_CBCA:
	LDA $55
	SBC $54
	STA $55
	LDA $56
	SBC $57
	STA $56
	SEC
bra_03_CBD7:
	ROL $52
	ROL $53
	ROL $58
	DEX
	BNE bra_03_CBB4
	PLA
	TAX
	RTS

.export _SelectInitialPlayerDataAddress_b03
_SelectInitialPlayerDataAddress_b03:		; CBE3
_SelectInitialBallDataAddress:				; если на вход подается 16
_SelectInitialShadowDataAddress:			; если на вход подается 17
	ASL
	TAX
	LDA BasePlayerDataAddress_table,X
	STA plr_data
	LDA BasePlayerDataAddress_table + 1,X
	STA plr_data + 1
	RTS

BasePlayerDataAddress_table:		; CBF0 читается из 2х мест, из FA60 читается для мяча
.word $042D		; вратарь внизу
.word $044D
.word $046D
.word $048D
.word $04AD
.word $04CD
.word $04ED
.word $050D
.word $052D
.word $054D
.word $056D
.word $058D		; вратарь вверху
.word $05AD
.word $05CD
.word $05ED
.word $060D
.word $062D
.word $064D
.word $066D
.word $068D
.word $06AD
.word $06CD
.word $03D3		; мяч
.word $03F3		; тень мяча

_loc_03_CC20:
	CLC
	ADC #$40
_loc_03_CC23:
	ASL
	PHP
	BPL @plus
	EOR #$FF
@plus:
	AND #$7E
	TAX
	LDA table_03_CC44 + 1,X
	TAY
	LDA table_03_CC44,X
	TAX
	PLP
	BCC @rts
	JMP _EOR_16bit_b03
@rts:
	RTS

table_03_CC44:		; предположительно угол удара или сторона движения ботов
.byte $00,$00
.byte $00,$00
.byte $06,$00
.byte $0C,$00
.byte $12,$00
.byte $19,$00
.byte $1F,$00
.byte $25,$00
.byte $2B,$00
.byte $31,$00
.byte $38,$00
.byte $3E,$00
.byte $44,$00
.byte $4A,$00
.byte $50,$00
.byte $56,$00
.byte $5C,$00
.byte $61,$00
.byte $67,$00
.byte $6D,$00
.byte $73,$00
.byte $78,$00
.byte $7E,$00
.byte $83,$00
.byte $88,$00
.byte $8E,$00
.byte $93,$00
.byte $98,$00
.byte $9D,$00
.byte $A2,$00
.byte $A7,$00
.byte $AB,$00
.byte $B0,$00
.byte $B5,$00
.byte $B9,$00
.byte $BD,$00
.byte $C1,$00
.byte $C5,$00
.byte $C9,$00
.byte $CD,$00
.byte $D1,$00
.byte $D4,$00
.byte $D8,$00
.byte $DB,$00
.byte $DE,$00
.byte $E1,$00
.byte $E4,$00
.byte $E7,$00
.byte $EA,$00
.byte $EC,$00
.byte $EE,$00
.byte $F1,$00
.byte $F3,$00
.byte $F4,$00
.byte $F6,$00
.byte $F8,$00
.byte $F9,$00
.byte $FB,$00
.byte $FC,$00
.byte $FD,$00
.byte $FE,$00
.byte $FE,$00
.byte $FF,$00
.byte $00,$01

_loc_03_CCC4:
_loc_03_CCC4_minus1 = _loc_03_CCC4 - 1
	LDA game_mode_flags
	AND #$FB
	STA game_mode_flags
	JSR _ClearNametable_b03
	JSR _HideAllSprites_b03
	LDX #$00
	LDA #$02
	JSR _LoadScreenPalette_b03
	LDX #$10
	LDA #$02
	JSR _LoadScreenPalette_b03
	INC bg_or_pal_write_flag
	LDA #MUSIC_FIELD
	JSR _WriteSoundID_b03
	LDA #$00
	STA $03D3
	JSR _loc_03_D5AD
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает перед затемнением экрана перед отрисовкой поля
	JSR _loc_01_8D1A
	LDX #$0D
	LDA #$78
	STA $01,X
	LDA #$02
	STA $02,X
	LDA #>_loc_01_80A3_minus1
	LDY #<_loc_01_80A3_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDX #$11
	LDA #$96
	STA $01,X
	LDA #$02
	STA $02,X
	LDA #>_loc_03_E4D9_minus1
	LDY #<_loc_03_E4D9_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDX #$19
	LDA #$D2
	STA $01,X
	LDA #$02
	STA $02,X
	LDA #>_loc_01_8596_minus1
	LDY #<_loc_01_8596_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA team_w_ball
	CLC
	ADC #$06
	STA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDA #STATE_UNKNOWN_13
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA game_mode_flags
	ORA #F_OUT_OF_PLAY
	STA game_mode_flags
	JSR _loc_03_D72F
	LDA #$00
	STA $042C
	LDA team_w_ball
	EOR #$0B
	CLC
	ADC #$07
	STA plr_wo_ball
	LDA #$90
	STA $03C0
	LDA #$A0
	STA cam_edge_y_lo
	LDA #$00
	STA cam_edge_y_hi
	STA $03C1
	LDA #$80
	STA cam_edge_x_lo
	LDA #$00
	STA cam_edge_x_hi
bra_03_CD87:
	LDA #$01
	JSR _FrameDelay_b03
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает после затемнения экрана перед отрисовкой поля
	JSR _loc_01_804E
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает после затемнения экрана перед отрисовкой поля
	JSR _loc_01_81D9
	BIT $03C2
	BMI bra_03_CD87
	JSR _loc_03_CF97
	LDA #$02
	JSR _FrameDelay_b03
	LDA game_mode_flags
	ORA #FLAG_GM_UNKNOWN_04
	STA game_mode_flags
_loc_03_CDC1:
bra_03_CDC1:
	LDA #$01
	JSR _FrameDelay_b03
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает когда поле уже отрисовано, но игроков еще не видно
	JSR _loc_01_804E
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает когда поле уже отрисовано, но игроков еще не видно
	JSR _loc_01_81D9
	JSR _loc_03_DE96
	JSR _loc_03_D4E8
	BCS bra_03_CE17
	JSR _loc_03_D72F
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает когда поле уже отрисовано, но игроков еще не видно
	JSR _loc_01_87ED
	JSR _loc_03_CFDA
	LDA timer_sec
	ORA timer_min
	BNE bra_03_CDC1
	LDA #F_TIMEUP
	ORA game_mode_flags
	STA game_mode_flags
	JMP _loc_03_C5F1
bra_03_CE17:
	TXA
	PHA
	LDA team_w_ball
	PHA
	LDA $0428
	PHA
	LDA plr_w_ball
	BMI bra_03_CE36
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
bra_03_CE36:
	LDA #$08
bra_03_CE38:
	PHA
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_03_DE96
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал при зателе мяча за линию аута
	JSR _loc_01_87ED
	PLA
	SEC
	SBC #$01
	BNE bra_03_CE38
	LDA game_mode_flags
	AND #$FB
	STA game_mode_flags
	PLA
	STA $0428
	PLA
	STA team_w_ball
	PLA
	JSR _ReadBytesAfterJSR_b03

table_03_CE6B:		; таблица читается после JSR
					; используется сразу после забитого гола
					; или когда мяч вне игры
.word table_03_CE6B_D07A
.word table_03_CE6B_D173
.word table_03_CE6B_D257
.word table_03_CE6B_D37F

_loc_03_CE73:
_loc_03_CE73_minus1 = _loc_03_CE73 - 1
	LDA game_mode_flags
	AND #$FB
	STA game_mode_flags
	LDX #$00
	LDA #$02
	JSR _LoadScreenPalette_b03
	LDX #$10
	LDA #$02
	JSR _LoadScreenPalette_b03
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал при переходе в пенальти после экрана со счетом, который еще виднелся
	JSR _loc_02_A02A
	LDA byte_for_2000
	AND #$7F
	STA $2000
	STA byte_for_2000
	JSR _loc_03_CF97
	LDX #$00
	LDA #$09
	JSR _LoadScreenPalette_b03
	LDX #$00
	LDA #$0F
bra_03_CEB0:
	STA pal_buffer + 3,X
	INX
	INX
	INX
	INX
	CPX #$20
	BNE bra_03_CEB0
	LDA byte_for_2000
	ORA #$80
	STA byte_for_2000
	STA byte_for_2000_nmi
	STA $2000
	LDA #MUSIC_PENALTY
	JSR _WriteSoundID_b03
_loc_03_CECB:
	LDA #$00
	STA $8A
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D605_minus1
	LDY #<_loc_03_D605_minus1
	JSR _SetSubReturnAddressForLater_b03
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал перед осветлением экрана при переходе в пенальти
	JSR _loc_02_A0F0
bra_03_CEF0:
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_03_DE96
	LDA $8A
	AND #$20
	BEQ bra_03_CEF0
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает перед отображением счета в пенальти после гола/отбития удара
	JSR _loc_02_A1ED
	LDA $8E
	STA $2A
	SEC
	LDA goals_pk
	SBC goals_pk + 1
	BCS bra_03_CF1D
	EOR #$FF
	ADC #$01
bra_03_CF1D:
	LSR $2A
	SBC #$00
	BPL bra_03_CF25
	LDA #$00
bra_03_CF25:
	STA $2B
	LDA #$05
	SEC
	SBC $2A
	BEQ bra_03_CF30
	BCS bra_03_CF32
bra_03_CF30:
	LDA #$01
bra_03_CF32:
	SEC
	SBC $2B
	BEQ bra_03_CF4A
	BCC bra_03_CF4A
	INC $8E
	BNE @skip
; уменьшение еще не выполнялось
	DEC $8E
@skip:
	LDA team_w_ball
	EOR #$0B
	STA team_w_ball
	JMP _loc_03_CECB
bra_03_CF4A:
	LDA #MUSIC_HALF_TIME
	JSR _WriteSoundID_b03
	LDA #$00
bra_03_CF51:
	PHA
	LDA #$01
	JSR _FrameDelay_b03
	PLA
	TAX
	LDA #$D0
	AND btn_press
	BNE bra_03_CF6B
	LDA #(BTN_A | BTN_B)
	AND $0027
	BNE bra_03_CF6B
	INX
	TXA
	BNE bra_03_CF51
bra_03_CF6B:
	LDA #F_TIMEUP
	ORA game_mode_flags
	AND #$EF
	STA game_mode_flags
	LDX #$00
	JSR _loc_03_CF8D
	INX
	JSR _loc_03_CF8D
	LDA #$00
	STA $09
	STA $0A
	LDA #$00
	STA $0D
	STA $0E
	JMP _loc_03_C5F1
_loc_03_CF8D:
	LDA goals_pk,X
	CLC
	ADC goals_total,X
	STA goals_total,X
	RTS

_loc_03_CF97:
	LDX #$00
@read_table_loop:
	LDA table_03_CFBA,X
	STA pal_buffer + 3,X
	INX
	CPX #$20
	BNE @read_table_loop
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает перед затемнением экрана перед отрисовкой поля
	JSR _TeamsPalette_and_BallPalette_b01
	INC bg_or_pal_write_flag
	RTS

table_03_CFBA:		; читаются сразу все 32 байта таблицы
.byte $0A,$0F,$1A,$30
.byte $0A,$0F,$25,$36
.byte $0A,$0F,$21,$36
.byte $0A,$16,$26,$36
.byte $0A,$30,$16,$35
.byte $0A,$0F,$0F,$30
.byte $0A,$2B,$11,$26
.byte $0A,$28,$0F,$30

_loc_03_CFDA:
	JSR _loc_03_C71D
	BCS bra_03_D051
	BIT $042C
	BVC bra_03_CFE7
	JMP _loc_03_D074
bra_03_CFE7:
	LDA team_w_ball
	BNE bra_03_CFF4
	BIT game_mode_flags
	BMI bra_03_CFF4
	JMP _loc_03_D074
bra_03_CFF4:
	LDA plr_wo_ball
	BMI bra_03_D019
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_state
	LDA (plr_data),Y
	CMP #STATE_WITHOUT_BALL
	BNE bra_03_D019
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_VISIBLE
	BNE bra_03_D073
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
bra_03_D019:
	LDA team_w_ball
	EOR #$0B
	STA $2A
	INC $2A
	LDA #$0A
	STA $2B
	LDA #$00
	STA $2C
bra_03_D02A:
	LDA $2A
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	TAX
	AND #F_VISIBLE
	BEQ bra_03_D03F
	TXA
	AND #F_CONTROL
	BNE bra_03_D03F
	INC $2C
bra_03_D03F:
	INC $2A
	DEC $2B
	BNE bra_03_D02A
	LDA $2C
	BEQ bra_03_D074
	LDA team_w_ball
	EOR #$0B
	JSR _FindClosestPlayer_ForControl
bra_03_D051:
	CMP plr_wo_ball
	BEQ bra_03_D073
	STA plr_wo_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL
	BNE bra_03_D074
	LDA #STATE_WITHOUT_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
bra_03_D073:
	RTS

_loc_03_D074:
bra_03_D074:
	LDA #$80
	STA plr_wo_ball
	RTS

table_03_CE6B_D07A:
	LDA #$00
	STA $09
	STA $0A
	LDA #MSG_THROW_IN
	JSR _WriteAndSkipMessageOnScreen
	JSR _loc_03_D49F
	LDX ball_pos_x_lo
	LDY ball_pos_x_hi
	LDA $0428
	EOR #$0B
	STA team_w_ball
	BEQ bra_03_D09B
	JSR _EOR_16bit_plus2_b03
bra_03_D09B:
	STX $2A
	STY $2B
	LDX ball_pos_y_lo
	LDY ball_pos_y_hi
	LDA team_w_ball
	BEQ bra_03_D0AD
	JSR _EOR_16bit_plus4_b03
bra_03_D0AD:
	STX $2C
	STY $2D
	LDX #$00
	LDA $2B
	BEQ bra_03_D0B8
	INX
bra_03_D0B8:
	LDA $2D
	CMP #$02
	BCC bra_03_D0C0
	INX
	INX
bra_03_D0C0:
	LDA table_03_D16F,X
	CLC
	ADC team_w_ball
	STA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDX #$00
	LDA ball_pos_x_hi
	BEQ bra_03_D0D7
	INX
	INX
	INX
bra_03_D0D7:
	LDY #plr_pos_x_lo
	LDA table_03_D169,X
	STA (plr_data),Y
	INY
	INY
	LDA table_03_D169 + 1,X
	STA (plr_data),Y
	LDY #plr_dir
	LDA table_03_D169 + 2,X
	STA (plr_data),Y
	LDY #plr_pos_y_lo
	LDA ball_pos_y_lo
	STA (plr_data),Y
	INY
	INY
	LDA ball_pos_y_hi
	STA (plr_data),Y
	LDA #$02
	JSR _BallRelativePosition
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_THROW_IN
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA area_id
	LDX #$00
bra_03_D11B:
	SEC
	SBC #$05
	BCC bra_03_D123
	INX
	BNE bra_03_D11B
bra_03_D123:
	TXA
	LDX ball_pos_x_hi
	BEQ bra_03_D12C
	CLC
	ADC #$08
bra_03_D12C:
	CLC
	ADC #$04
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал когда закончился таймер надписи out of play throw in
	JSR _loc_02_974F
	LDA #$80
	STA plr_wo_ball
	LDA #$00
	STA ball_z_lo
	STA ball_z_hi
	LDA #$01
	STA ball_anim_id
	JSR _loc_03_DCED
bra_03_D154:
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_03_DE96
	BIT plr_w_ball
	BPL bra_03_D154
	LDA #$02
	JSR _FrameDelay_b03
	JMP _loc_03_D4D5

table_03_D169:
.byte $0E,$00,$40
.byte $F2,$01,$C0

table_03_D16F:
.byte $0A,$06,$01,$02

table_03_CE6B_D173:
	LDA #$00
	STA $09
	STA $0A
	LDA #$00
	STA ball_z_lo
	STA ball_z_hi
	LDA #$01
	STA ball_anim_id
	LDA #MSG_GOAL_KICK
	JSR _WriteAndSkipMessageOnScreen
	JSR _loc_03_D49F
	LDA $0428
	EOR #$0B
	STA team_w_ball
	STA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDX #$B8
	LDY #$00
	LDA ball_pos_x_hi
	BEQ bra_03_D1A8
	JSR _EOR_16bit_plus2_b03
bra_03_D1A8:
	TYA
	LDY #plr_pos_x_hi
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y
	LDX #$C8
	LDY #$00
	LDA team_w_ball
	BNE bra_03_D1BE
	JSR _EOR_16bit_plus4_b03
bra_03_D1BE:
	TYA
	LDY #plr_pos_y_hi
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y
	LDY #plr_dir
	LDA #$00
	LDX team_w_ball
	BNE bra_03_D1D3
	LDA #$80
bra_03_D1D3:
	STA (plr_data),Y
	LDA #$00
	JSR _BallRelativePosition
	LDA #$01
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал когда закончилась надпись out of play goal kick
	JSR _loc_02_9842
	LDA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_GOAL_KICK
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA game_mode_opt
	AND #$DF
	STA game_mode_opt
	LDA random		; вычисление таймера для бота кипера, когда тот выбивает goal kick
	AND #$0F
	CLC
	ADC #$10
	LDY #plr_act_timer1
	STA (plr_data),Y
	LDA #$80
	STA plr_wo_ball
bra_03_D222:
	LDA #$01
	JSR _FrameDelay_b03
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _loc_01_804E
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _loc_01_81D9
	JSR _loc_03_DE96
	BIT plr_w_ball
	BPL bra_03_D222
	LDA #$02
	JSR _FrameDelay_b03
	JMP _loc_03_D4D5

table_03_CE6B_D257:
	LDA #$00
	STA $09
	STA $0A
	LDA #$00
	STA ball_z_lo
	STA ball_z_hi
	LDA #$01
	STA ball_anim_id
	LDA #MSG_CORNER_KICK
	JSR _WriteAndSkipMessageOnScreen
	JSR _loc_03_D49F
	LDA $0428
	EOR #$0B
	STA team_w_ball
	LDX ball_pos_x_lo
	LDY ball_pos_x_hi
	LDA team_w_ball
	BEQ bra_03_D288
	JSR _EOR_16bit_plus2_b03
bra_03_D288:
	TYA
	PHP
	LDY #$02
	LDX #$0A
	PLP
	BEQ bra_03_D294
	LDX #$06
	INY
bra_03_D294:
	TYA
	PHA
	CLC
	TXA
	ADC team_w_ball
	STA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #$34
	LDX #$00
	LDA ball_pos_x_hi
	BEQ bra_03_D2AD
	LDY #$CC
	INX
bra_03_D2AD:
	LDA ball_pos_y_hi
	CMP #$02
	BCC bra_03_D2BC
	INX
	INX
	TYA
	EOR #$FF
	ADC #$80
	TAY
bra_03_D2BC:
	TYA
	LDY #plr_dir
	STA (plr_data),Y
	TXA
	ASL
	ASL
	ASL
	TAX
	LDA table_03_D35F,X
	STA ball_pos_x_lo
	LDA table_03_D35F + 1,X
	STA ball_pos_x_hi
	LDA table_03_D35F + 2,X
	STA ball_pos_y_lo
	LDA table_03_D35F + 3,X
	STA ball_pos_y_hi
	LDY #plr_pos_x_lo
	LDA table_03_D35F + 4,X
	STA (plr_data),Y
	INY
	INY
	LDA table_03_D35F + 5,X
	STA (plr_data),Y
	LDY #plr_pos_y_lo
	LDA table_03_D35F + 6,X
	STA (plr_data),Y
	INY
	INY
	LDA table_03_D35F + 7,X
	STA (plr_data),Y
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_CORNER_KICK
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	PLA
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал когда закончилась надпись out of play corner kick
	JSR _loc_02_9842
	LDA #$80
	STA plr_wo_ball
	JSR _loc_03_DCED
bra_03_D32A:
	LDA #$01
	JSR _FrameDelay_b03
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _loc_01_804E
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _loc_01_81D9
	JSR _loc_03_DE96
	BIT plr_w_ball
	BPL bra_03_D32A
	LDA #$02
	JSR _FrameDelay_b03
	JMP _loc_03_D4D5

table_03_D35F:		; какие-то параметры игрока
.byte $14,$00,$AC,$00,$0C,$00,$A8,$00
.byte $EC,$01,$AC,$00,$F4,$01,$A8,$00	; еще не считывался
.byte $14,$00,$54,$03,$0C,$00,$58,$03
.byte $EC,$01,$54,$03,$F4,$01,$58,$03

table_03_CE6B_D37F:
	LDA #MUSIC_GOAL
	JSR _WriteSoundID_b03
	LDA #SOUND_FANS
	JSR _WriteSoundID_b03
	LDA #$00
bra_03_D38B:
	PHA
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_ALL_CLEAR
	STA (plr_data),Y
	LDA #STATE_FREEZE
	JSR _SelectPlayerSubroutine_b03
	PLA
	CLC
	ADC #$01
	CMP #$16
	BNE bra_03_D38B
	LDX #$00
	LDA ball_pos_y_hi
	CMP #$02
	BCC bra_03_D3AE
	INX
bra_03_D3AE:
	STX $03CA
_loc_03_D3B1:
	LDA #$01
	JSR _FrameDelay_b03
	LDX #$01
	LDY #$00
	LDA $03CA
	BNE bra_03_D3C2
	JSR _EOR_16bit_b03
bra_03_D3C2:
	TXA
	CLC
	ADC cam_edge_y_lo
	STA cam_edge_y_lo
	TAX
	TYA
	ADC cam_edge_y_hi
	STA cam_edge_y_hi
	BMI bra_03_D3F2
	CMP #$03
	BCC bra_03_D3DC
	CPX #$10
	BCS bra_03_D3F2
bra_03_D3DC:
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал когда был забит гол верхней команде и камера начала скроллиться
	JSR _loc_01_827E
	JSR _loc_03_DE96
	JMP _loc_03_D3B1
bra_03_D3F2:
	LDX #$15
	LDA #$B4
	STA $01,X
	LDA #$02
	STA $02,X
	LDA #>_loc_01_8341_minus1
	LDY #<_loc_01_8341_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA #$00
	STA $09
	STA $0A
	LDA #$00
	STA $0D
	STA $0E
	LDA #$00
	STA $11
	STA $12
	LDA #$00
	STA $19
	STA $1A
	LDA #$14
	JSR _FrameDelay_b03
	LDA #$02
	STA chr_bank + 2
	LDA byte_for_2000
	AND #$DF
	STA byte_for_2000
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал перед появлению надписи GOAL
	JSR _loc_01_83AA
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал когда закончился таймер надписи GOAL
	JSR _loc_01_8361
	LDA #$28
	JSR _FrameDelay_b03
	LDX $03CA
	LDA goals_total,X
	CMP #$63
	BCS bra_03_D464
	INC goals_total,X
	LDA half_time_cnt
	BNE bra_03_D464
	INC goals_half,X
bra_03_D464:
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал перед попыткой игры увеличить счет крупных цифр после гола
	JSR _loc_01_8361
	LDA #$6E
	JSR _FrameDelay_b03
	JSR _HideAllSprites_b03
	LDA byte_for_2000
	ORA #$20
	STA byte_for_2000
	LDA team_w_ball
	BEQ bra_03_D489
	LDA #$01
bra_03_D489:
	EOR $03CA
	BNE bra_03_D496
	LDA team_w_ball
	EOR #$0B
	STA team_w_ball
bra_03_D496:
	LDA #$00
	STA $15
	STA $16
	JMP _loc_03_CCC4

_loc_03_D49F:
	LDA #$00
	STA ball_z_lo
	STA ball_z_hi
@loop:
	PHA
	TAX
	BEQ @skip_gk
	CMP #$0B
	BEQ @skip_gk
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_ALL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
@skip_gk:
	PLA
	CLC
	ADC #$01
	CMP #$16
	BNE @loop
	LDA #$03
	STA ball_anim_id
	LDA game_mode_flags
	ORA #F_OUT_OF_PLAY
	STA game_mode_flags
	RTS

_loc_03_D4D5:		; D4D5
	LDA game_mode_flags
	AND #$DF
	STA game_mode_flags		; можно пропустить STA + LDA, сразу делать ORA
	LDA game_mode_flags
	ORA #FLAG_GM_UNKNOWN_04
	STA game_mode_flags
	JMP _loc_03_CDC1

_loc_03_D4E8:
; сравнение координат мяча с линиями аута
	LDX ball_pos_x_lo
	LDY ball_pos_x_hi
	BEQ @skip
	JSR _EOR_16bit_plus2_b03
@skip:
	STX $2A		; возможно нет необходимости во временных адресах конкретно здесь, все равно перезапишутся
	STY $2B
	SEC
	TXA
	SBC #$0E
	TYA
	SBC #$00
	BCS bra_03_D509
	LDA #SOUND_WHISTLE
	JSR _WriteSoundID_b03
	LDX #$00
	SEC
	RTS
bra_03_D509:		; сравнение координат мяча с линиями аута
	LDX ball_pos_y_lo
	LDY ball_pos_y_hi
	CPY #$02
	BCC @ball_is_upstairs
	JSR _EOR_16bit_plus4_b03
@ball_is_upstairs:
	STX $2C
	STY $2D
	LDA ball_z_hi
	BNE bra_03_D569
	LDA ball_z_lo
	CMP #$19
	BCS bra_03_D569
	LDX #$00
@loop:
	CMP table_03_D939,X		; вычисление степени подлета мяча от 00 до 05
	BCC @skip2
	INX
	BNE @loop
@skip2:
	TXA
	ASL
	TAX
	SEC
	LDA $2A
	SBC table_03_D595,X
	LDA $2B
	SBC table_03_D595 + 1,X
	BCC bra_03_D569
	SEC
	LDA $2C
	SBC table_03_D5A1,X
	LDA $2D
	SBC table_03_D5A1 + 1,X
	BCS bra_03_D58E
	LDA plr_w_ball
	BMI bra_03_D558
	BEQ bra_03_D58E
	CMP #$0B
	BEQ bra_03_D58E
bra_03_D558:
	LDA #SOUND_WHISTLE
	JSR _WriteSoundID_b03
	LDA $03D3
	ORA #$10
	STA $03D3
	LDX #$03
	SEC
	RTS
bra_03_D569:
	SEC
	LDA $2C
	SBC #$A2
	LDA $2D
	SBC #$00
	BCS bra_03_D58E
	LDX #$01
	LDA #$00
	LDY ball_pos_y_hi
	CPY #$02
	BCS bra_03_D581
	LDA #$0B
bra_03_D581:
	EOR $0428
	BNE bra_03_D587
	INX
bra_03_D587:
	LDA #SOUND_WHISTLE
	JSR _WriteSoundID_b03
	SEC
	RTS
bra_03_D58E:
	CLC
	RTS

table_03_D595:		; линия гола
.byte $CC,$00
.byte $CB,$00
.byte $CA,$00
.byte $C9,$00
.byte $C8,$00
.byte $C7,$00

table_03_D5A1:		; линия гола
.byte $A2,$00
.byte $A1,$00
.byte $A0,$00
.byte $9F,$00
.byte $9E,$00
.byte $9D,$00

_loc_03_D5AD:
	LDA #$80
	STA plr_w_ball
	LDA #$00
	PHA
	LDA #$04
	STA prg_bank
	LDA #$05
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает перед затемнением экрана перед отрисовкой поля
	JSR _loc_02_9842
	LDA #$C0
	STA $2B
	LDA #$01
	STA $2C
	LDA #$00
	STA $2A
bra_03_D5D0:
	LDA $2A
	JSR _SelectInitialPlayerDataAddress_b03
	LDA #$00
	LDX $2A
	CPX #$0B
	BCC bra_03_D5DF
	LDA #$02
bra_03_D5DF:
	LDY #plr_spr_a
	STA (plr_data),Y
	INC $2A
	LDA $2A
	CMP #$16
	BNE bra_03_D5D0
	LDA #$02
	STA game_mode_opt
	LDA #$00
	STA ball_pos_y_lo
	LDA #$00
	STA ball_pos_x_lo
	LDA #$01
	STA ball_pos_x_hi
	LDA #$02
	STA ball_pos_y_hi
	RTS

bra_03_D605:
_loc_03_D605:
_loc_03_D605_minus1 = _loc_03_D605 - 1
	LDA #$01
	JSR _FrameDelay_b03
	BIT $8A
	BPL bra_03_D605
	LDA #$AB
	STA $03DB
	LDA #$FC
	STA $03DD
	LDX #$00
	LDY #$00
	LDA $8D
	CMP #$80
	BEQ bra_03_D62D
	LDX #$55
	LDY #$03
	CMP #$40
	BEQ bra_03_D62D
	JSR _EOR_16bit_b03
bra_03_D62D:
	STX $03D5
	STY $03D7
	LDA #$18
	STA ball_z_lo
bra_03_D638:
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_03_D6B1
	JSR _loc_03_DC68
	DEC ball_z_lo
	BNE bra_03_D638
	LDA #$08
	JSR _FrameDelay_b03
bra_03_D64D:
	LDA #$01
	JSR _FrameDelay_b03
	INC ball_pos_y_lo
	LDA ball_pos_y_lo
	CMP #$80
	BCC bra_03_D64D
	LDX team_w_ball
	BEQ bra_03_D663
	LDX #$01
bra_03_D663:
	INC goals_pk,X
	LDA #SOUND_FANS
	JSR _WriteSoundID_b03
	LDX #$0D
	LDA #$78
	STA $01,X
	LDA #$04
	STA $02,X
	LDA #>_loc_02_A330_minus1
	LDY #<_loc_02_A330_minus1
	JSR _SetSubReturnAddressForLater_b03
	SEC
	JMP _loc_03_D69F

_loc_03_D680:
_loc_03_D680_minus1 = _loc_03_D680 - 1
	LDA #SOUND_CATCH
	JSR _WriteSoundID_b03
	LDA #$00
	STA $03DB
	LDA #$FB
	STA $03DD
bra_03_D68F:
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_03_DC68
	LDA ball_pos_y_lo
	CMP #$10
	BCS bra_03_D68F
	CLC
_loc_03_D69F:
	ROL $91
	ROL $92
	LDA #$14
	JSR _FrameDelay_b03
	LDA $8A
	ORA #$20
	STA $8A
	JMP _loc_03_C5F1
_loc_03_D6B1:
	LDA #$18
	SEC
	SBC ball_z_lo
	TAX
	LDA table_03_D6D4,X
	STA ball_anim_id
; чтение режима игры из опций
	LDA game_mode_opt
	AND #$3F
	STA game_mode_opt
	TXA
	AND #$03
	CLC
	ROR
	ROR
	ROR
	ORA game_mode_opt
	STA game_mode_opt
	RTS

table_03_D6D4:		; анимация мяча в пенальти в зависимости от высоты
.byte $09,$09,$09,$09,$09,$08,$08,$08,$08,$08,$07,$07,$07,$07,$07,$06
.byte $06,$06,$06,$06,$05,$05,$05,$05,$05,$04,$04,$04,$04,$04,$04,$04

; код еще не выполнялся
	JSR _CalculateBallDirectionForPass
	STA ball_dir

_loc_03_D6FA:
_loc_03_D6FA_minus1 = _loc_03_D6FA - 1		; считывается из нескольких мест
	JSR _loc_03_DDF2
	JSR _loc_03_DE36
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_03_DB5E
	LDA $03D3
	ORA #$80
	STA $03D3
bra_03_D710:
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_03_DBBE
	JSR _loc_03_DD17
	JSR _loc_03_DCED
	JSR _loc_03_DA1A
	JSR _loc_03_D8B3
	JSR _loc_03_D9A3
	BIT $03D3
	BMI bra_03_D710
	JMP _loc_03_C5F1
_loc_03_D72F:
	SEC
	LDA ball_pos_x_lo
	SBC #$10
	TAX
	LDA ball_pos_x_hi
	SBC #$00
	BCS bra_03_D740
	LDX #$00
	TXA
bra_03_D740:
	TAY
	LDA #$00
_loc_03_D743:
	PHA
	SEC
	TXA
	SBC #$60
	TAX
	TYA
	SBC #$00
	TAY
	PLA
	BCC bra_03_D755
	ADC #$00
	JMP _loc_03_D743
bra_03_D755:
	CMP #$05
	BCC bra_03_D75B
	LDA #$04
bra_03_D75B:
	STA $2A
	SEC
	LDA ball_pos_y_lo
	SBC #$A0
	TAX
	LDA ball_pos_y_hi
	SBC #$00
	BCS bra_03_D76E
	LDX #$00
	TXA
bra_03_D76E:
	TAY
	LDA #$00
_loc_03_D771:
	PHA
	SEC
	TXA
	SBC #$58
	TAX
	TYA
	SBC #$00
	TAY
	PLA
	BCC bra_03_D783
	ADC #$04
	JMP _loc_03_D771
bra_03_D783:
	CMP #$23
	BCC bra_03_D789
	LDA #$23
bra_03_D789:
	CLC
	ADC $2A
	CMP area_id
	BEQ bra_03_D79C
	STA area_id
	LDA #$80
	ORA $042C
	STA $042C
bra_03_D79C:
	RTS

_loc_03_D79D:
_loc_03_D79D_minus1 = _loc_03_D79D - 1
	LDA #$00
	STA ball_z_lo
	STA ball_z_hi
	STA $03D3
	LDA game_mode_opt
	AND #$DF
	STA game_mode_opt
_loc_03_D7B0:
bra_03_D7B0:
	LDA #$01
	JSR _FrameDelay_b03
	JSR _loc_03_DCED
	BIT $03D3
	BVC bra_03_D7B0
	LDA $03D3
	AND #$20
	BNE bra_03_D7D1
	LDA $03D3
	ORA #$20
	STA $03D3
	LDA #$00
	STA ball_push_anim_id
bra_03_D7D1:
	LDA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDX ball_push_anim_id
	LDA table_03_D842,X
	EOR #$FF
	CLC
	ADC #$01
	STA $2A
	LDA #$FF
	STA $2B
	LDY #plr_dir
	LDA (plr_data),Y
	CLC
	ADC #$10
	AND #$E0
	LDY #$00
	TAX
	AND #$20
	BNE bra_03_D7FE
	TXA
	AND #$40
	BEQ bra_03_D7FF
	INY
bra_03_D7FE:
	INY
bra_03_D7FF:
	JSR _loc_03_D839
	INC ball_push_anim_id
	LDA ball_push_anim_id
	CMP #$0B
	BNE bra_03_D814
	LDA $03D3
	AND #$9F
	STA $03D3
bra_03_D814:
	LDA ball_push_anim_id
	AND #$01
	STA ball_anim_id
	INC ball_anim_id
	LDX #$00
	LDA ball_push_anim_id
	AND #$02
	BEQ bra_03_D82A
	LDX #$40
bra_03_D82A:
	STX $2A
	LDA game_mode_opt
	AND #$3F
	ORA $2A
	STA game_mode_opt
	JMP _loc_03_D7B0
_loc_03_D839:
	DEY
	BMI bra_03_D852
	DEY
	BMI bra_03_D87C
	JMP _loc_03_D883

table_03_D842:		; влияет на анимацию толкания мяча ногами
					; когда игрок бежит с мячом
.byte $05,$06,$07,$08,$09,$09,$09,$08,$07,$06,$05

; D84D (неиспользуемые)
.byte $FF,$FF,$FF,$FF,$FF

bra_03_D852:
	LDX #$00
	LDY #$00
	JSR _loc_03_D899
_loc_03_D859:
	LDY #plr_spr_a
	LDA (plr_data),Y
	LDX $2A
	LDY $2B
	AND #$80
	BEQ bra_03_D868
	JSR _EOR_16bit_b03
_loc_03_D868:
bra_03_D868:
	TYA
	PHA
	TXA
	LDY #plr_pos_y_lo
	CLC
	ADC (plr_data),Y
	STA ball_pos_y_lo
	INY
	INY
	PLA
	ADC (plr_data),Y
	STA ball_pos_y_hi
	RTS

bra_03_D87C:
	JSR _loc_03_D88A
	JSR _loc_03_D859
	RTS

_loc_03_D883:
	LDX #$00
	LDY #$00
	JSR _loc_03_D868
_loc_03_D88A:
	LDY #plr_spr_a
	LDA (plr_data),Y
	LDX $2A
	LDY $2B
	AND #$40
	BEQ bra_03_D899
	JSR _EOR_16bit_b03
_loc_03_D899:
bra_03_D899:
	TYA
	PHA
	TXA
	LDY #plr_pos_x_lo
	CLC
	ADC (plr_data),Y
	TAX
	INY
	INY
	PLA
	ADC (plr_data),Y
	BPL bra_03_D8AC
	LDX #$00		; код еще не выполнялся
	TXA
bra_03_D8AC:
	STX ball_pos_x_lo
	STA ball_pos_x_hi
	RTS

_loc_03_D8B3:
.scope
index = $2B
	LDA ball_z_hi
	BNE @rts
	LDA ball_z_lo
	CMP #$20		; высота перекладины
	BCS @rts
	LDY #$00
@loop:
	CMP table_03_D939,Y		; вычисление степени подлета мяча от 00 до 05
	BCC @skip
	INY
	BNE @loop
@skip:
	TYA
	ASL
	ASL
	STA index
	LDA ball_dir
	LDX ball_pos_y_lo
	LDY ball_pos_y_hi
	CPY #$02
	BCC @ball_is_upstairs
	JSR _EOR_16bit_plus4_b03
	LDA ball_dir
	CLC
	ADC #$80
	SEC
@ball_is_upstairs:
	ROL $2C
	CMP #$30
	BCC @rts
	CMP #$D0
	BCS @rts
	TXA
	LDX index
	SEC
	SBC table_03_D98F,X
	TAX
	TYA
	LDY index
	SBC table_03_D98F + 1,Y
	BCC @rts
	BNE @rts
	CPX #$08
	BCS @rts
	CLC
	LDX ball_pos_x_lo
	LDY ball_pos_x_hi
	BEQ @skip2
	JSR _EOR_16bit_plus2_b03
	SEC
@skip2:
	ROL $2C
	SEC
	TXA
	LDX index
	SBC table_03_D98F + 2,X
	TAX
	TYA
	LDY index
	SBC table_03_D98F + 3,Y
	TAY
	BCS @skip3
	JSR _EOR_16bit_b03
@skip3:
	TYA
	BNE @rts
	CPX #$08
	BCS @rts
	JSR _loc_03_D93E
@rts:
	RTS
.endscope

table_03_D939:		; читается из 2х мест, сравниваются с высотой подлета мяча 
.byte $08,$0E,$16,$1C,$FF

_loc_03_D93E:
	LDY $2B
	LDX table_03_D98F + 2,Y
	LDA table_03_D98F + 3,Y
	TAY
	LSR $2C
	BCC bra_03_D94E
	JSR _EOR_16bit_plus2_b03
bra_03_D94E:
	STX ball_pass_pos_x_lo
	STY ball_pass_pos_x_hi
	LDY $2B
	LDX table_03_D98F,Y
	LDA table_03_D98F + 1,Y
	TAY
	LSR $2C
	BCC bra_03_D964
	JSR _EOR_16bit_plus4_b03
bra_03_D964:
	STX ball_pass_pos_y_lo
	STY ball_pass_pos_y_hi
	JSR _CalculateBallDirectionForPass
	SEC
	SBC ball_dir
	ASL
	STA $2A
	LDA ball_dir
	CLC
	ADC #$80
	CLC
	ADC $2A
	STA ball_dir
	JSR _loc_03_DDDF
	JSR _loc_03_DB5E
	JSR _loc_03_DF5E
	LDA #SOUND_GOALSPOT
	JSR _WriteSoundID_b03
	RTS

table_03_D98F:		; чтение из 2х мест
; y_lo, y_hi, x_lo, x_hi
.byte $A4,$00,$C9,$00
.byte $A3,$00,$C8,$00
.byte $A2,$00,$C7,$00
.byte $A1,$00,$C6,$00
.byte $A0,$00,$C5,$00

_loc_03_D9A3:
	LDA ball_z_hi
	BEQ bra_03_D9AB
; прыжок еще не выполнялся
	JMP _loc_03_DA15
bra_03_D9AB:
	LDA ball_z_lo
	CMP #$19
	BCC bra_03_DA15
	CMP #$20
	BCS bra_03_DA15
	LDA #$00
	LDX ball_pos_y_lo
	LDY ball_pos_y_hi
	CPY #$02
	BCC bra_03_D9C7
	JSR _EOR_16bit_plus4_b03
	LDA #$80
bra_03_D9C7:
	EOR $03DD
	AND #$80
	BEQ bra_03_DA15
	SEC
	TXA
	SBC #$A6
	TAX
	TYA
	SBC #$00
	BCC bra_03_DA15
	BNE bra_03_DA15
	CPX #$04
	BCS bra_03_DA15
	LDX ball_pos_x_lo
	LDY ball_pos_x_hi
	BEQ bra_03_D9EB
	JSR _EOR_16bit_plus2_b03	; прыжок еще не выполнялся
bra_03_D9EB:
	SEC
	TXA
	SBC #$D0
	TYA
	SBC #$00
	BCC bra_03_DA15
	LSR $041E		; код еще не выполнялся, был лишь переход на RTS через BCC
	ROR $041D
	LDA ball_dir
	EOR #$FF
	CLC
	ADC #$81
	STA ball_dir
	JSR _loc_03_DDDF
	JSR _loc_03_DB5E
	JSR _loc_03_DF5E
	LDA #SOUND_GOALSPOT
	JSR _WriteSoundID_b03
_loc_03_DA15:
bra_03_DA15:
	RTS

_loc_03_DA1A:
; сравнение координат мяча с сеткой ворот, скорее всего для обработки касаний
	LDA game_mode_opt
	AND #$DF
	STA game_mode_opt
	LDA $03D3
	AND #$10
	BNE @continue1
	RTS
@continue1:	
	LDA #$00
	STA $2E
	LDX ball_pos_y_lo
	LDY ball_pos_y_hi
	CPY #$02
	BCC @ball_is_upstairs
	JSR _EOR_16bit_plus4_b03
	INC $2E
@ball_is_upstairs:
	STX $2A
	STY $2B
	SEC
	TXA
	SBC #$A4	; что-то связано с координатами сетки по вертикали
	TYA
	SBC #$00
	BCC @continue2
	RTS
@continue2:
	SEC
	TXA
	SBC #$92	; что-то связано с координатами сетки по вертикали
	TYA
	SBC #$00
	BCS @continue3
	RTS
@continue3:
	LDX ball_pos_x_lo
	LDY ball_pos_x_hi
	BEQ @skip1
	INC $2E
	INC $2E
	JSR _EOR_16bit_plus2_b03
@skip1:
	SEC
	TXA
	SBC #$D0
	TYA
	SBC #$00
	BCS @out_of_play
	RTS
@out_of_play:
	LDA game_mode_opt
	ORA #F_OUT_OF_PLAY
	STA game_mode_opt
	LDA $03D7
	BEQ bra_03_DAC8
	TXA
	SBC #$D4
	TYA
	SBC #$00
	BCS bra_03_DAC8
	LDX #$00
	LDA $2E
	CMP #$02
	BCC @skip2
	LDX #$08
@skip2:
	TXA
	BEQ @skip3
	LDA #$80
@skip3:
	EOR $03D7
	AND #$80
	BNE @continue4
	RTS
@continue4:
	LDA ball_dir
	EOR #$FF
	CLC
	ADC #$01
	JMP _loc_03_DB13
bra_03_DAC8:
	SEC
	LDA $2A
	SBC #$9A
	LDA $2B
	SBC #$00
	BCS bra_03_DB3A
	LDA $2E
	LSR
	LDA #$00
	BCC @skip4
	LDA #$80
@skip4:
	EOR $03DD
	AND #$80
	BEQ bra_03_DB3A
	SEC
	LDA ball_pos_x_lo
	SBC #$D0
	STA $2A
	LDA ball_pos_x_hi
	SBC #$00
	BCS bra_03_DAFA
	LDA #$00		; код еще не выполнялся
	STA $2A
bra_03_DAFA:
	LSR
	ROR $2A
	LSR
	ROR $2A
	LDY $2A
	CPY #$19
	BCC bra_03_DB08
	LDY #$18		; инструкция еще не выполнялась
bra_03_DB08:
	LDX table_03_DB3B,Y
	LDA ball_dir
	EOR #$FF
	CLC
	ADC #$81
_loc_03_DB13:
	STA ball_dir
	TXA
	LSR $2E
	BCC bra_03_DB1D
	ADC #$08
bra_03_DB1D:
	JSR _loc_03_F98D
	LSR $041E
	ROR $041D
	LSR $041E
	ROR $041D
	LDA #$00
	STA $0421
	STA $0423
	JSR _loc_03_DDDF
	JSR _loc_03_DB5E
bra_03_DB3A:	; сюда 2 перехода выше
	RTS

table_03_DB3B:		; вроде что-то связано с сеткой при ее касании мячом
.byte $01,$01,$02,$02,$02,$02,$03,$03,$03,$03,$04,$04,$04,$04,$05,$05
.byte $05,$05,$06,$06,$06,$06,$07,$07,$07

_loc_03_DB5E:
	LDX $03D5
	LDY $03D7
	JSR _loc_03_DB9B
	CLC
	TXA
	ADC ball_pos_x_lo
	TAX
	TYA
	ADC ball_pos_x_hi
	BPL bra_03_DB76
	LDA #$00
	TAX
bra_03_DB76:
	STX ball_land_pos_x_lo
	STA ball_land_pos_x_hi
	LDX $03DB
	LDY $03DD
	JSR _loc_03_DB9B
	CLC
	TXA
	ADC ball_pos_y_lo
	TAX
	TYA
	ADC ball_pos_y_hi
	BPL bra_03_DB94
	LDA #$00
	TAX
bra_03_DB94:
	STX ball_land_pos_y_lo
	STA ball_land_pos_y_hi
	RTS

_loc_03_DB9B:
	TYA
	PHP
	BPL bra_03_DBA2
	JSR _EOR_16bit_b03
bra_03_DBA2:
	STX $4A
	STY $4B
	LDA $041F
	STA $4C
	LDA $0420
	STA $4D
	JSR _loc_03_CB75
	LDX $4F
	LDY $50
	PLP
	BPL bra_03_DBBD
	JSR _EOR_16bit_b03
bra_03_DBBD:
	RTS

_loc_03_DBBE:
	JSR _loc_03_DC68
	CLC
	LDA $0421
	ADC $0422
	STA $0422
	LDA $0423
	ADC ball_z_lo
	STA ball_z_lo
	LDA #$00
	BIT $0423
	BPL bra_03_DBDD
	LDA #$FF
bra_03_DBDD:
	ADC ball_z_hi
	STA ball_z_hi
	BMI bra_03_DBF7
	CLC
	LDA $0421
	ADC #$F7
	STA $0421
	LDA $0423
	ADC #$FF
	STA $0423
	RTS

bra_03_DBF7:
	LDA #$00
	STA ball_z_lo
	STA ball_z_hi
	LSR $041E
	ROR $041D
	LDA $041E
	BNE bra_03_DC1D
	LDA $041D
	CMP #$20
	BCS bra_03_DC1D
	LDA $03D3
	AND #$7F
	STA $03D3
	JSR _loc_03_DCBD
	RTS

bra_03_DC1D:
	LSR $041C
	ROR $041B
	LSR $041C
	ROR $041B
	LSR $041C
	ROR $041B
	LSR $041C
	ROR $041B
	NOP
	NOP
	NOP
	JSR _loc_03_DDF2
	JSR _loc_03_DB5E
	LDX $0421
	LDY $0423
	JSR _EOR_16bit_b03
	TXA
	STY $2B
	LSR $2B
	ROR
	STA $0421
	LDA $2B
	STA $0423
	DEC $041F
	BNE bra_03_DC67
	DEC $0420
	BPL bra_03_DC67
	LDA #$00
	STA $041F
	STA $0420
bra_03_DC67:
	RTS

_loc_03_DC68:
	CLC
	LDA $03D5
	ADC $03D6
	TAX
	LDA $03D7
	ADC ball_pos_x_lo
	TAY
	LDA #$00
	BIT $03D7
	BPL bra_03_DC80
	LDA #$FF
bra_03_DC80:
	ADC ball_pos_x_hi
	BPL bra_03_DC89
	LDA #$00
	TAX
	TAY
bra_03_DC89:
	STX $03D6
	STY ball_pos_x_lo
	STA ball_pos_x_hi
	CLC
	LDA $03DB
	ADC $03DC
	TAX
	LDA $03DD
	ADC ball_pos_y_lo
	TAY
	LDA #$00
	BIT $03DD
	BPL bra_03_DCAA
	LDA #$FF
bra_03_DCAA:
	ADC ball_pos_y_hi
	BPL bra_03_DCB3
	LDA #$00
	TAX
	TAY
bra_03_DCB3:
	STX $03DC
	STY ball_pos_y_lo
	STA ball_pos_y_hi
	RTS

_loc_03_DCBD:
	LDA $03D3
	AND #$10
	BNE bra_03_DCEC
	LDA #$00
	JSR _FindClosestPlayer_ForControl
	LDA #STATE_UNKNOWN_01
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA #$0B
	JSR _FindClosestPlayer_ForControl
	LDA #STATE_UNKNOWN_01
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
bra_03_DCEC:
	RTS

_loc_03_DCED:
	CLC
	LDA ball_z_lo
	ADC ball_pos_x_lo
	STA $03F8
	LDA ball_z_hi
	ADC ball_pos_x_hi
	STA $03FA
	CLC
	LDA ball_pos_y_lo
	ADC #$02
	STA $03FE
	LDA ball_pos_y_hi
	ADC #$00
	STA $0400
	LDA #$E0
	STA $0404
	RTS

_loc_03_DD17:
	LDX #$00
bra_03_DD19:
	SEC
	LDA ball_z_lo
	SBC table_03_DD5D,X
	LDA ball_z_hi
	SBC table_03_DD5D + 1,X
	BCC bra_03_DD2C
	INX
	INX
	BNE bra_03_DD19
bra_03_DD2C:
	TXA
	LSR
	CLC
	ADC #$03
	STA ball_anim_id
	BIT $03D3
	BPL bra_03_DD5C
	LDA $03E1
	BNE bra_03_DD4B
	LDA #$02
	STA $03E1
	LDA game_mode_opt
	EOR #$80
	STA game_mode_opt
bra_03_DD4B:
	DEC $03E1
	BIT game_mode_opt
	BPL bra_03_DD5C
	LDA ball_anim_id
	CLC
	ADC #$07
	STA ball_anim_id
bra_03_DD5C:
	RTS

table_03_DD5D:
.byte $0C,$00
.byte $18,$00
.byte $24,$00
.byte $30,$00
.byte $3C,$00
.byte $48,$00
.byte $FF,$FF

_CalculateBallDirectionForPass:		; DD6B
	LDA #$00
	STA $2A
	LDA ball_pass_pos_x_lo
	SEC
	SBC ball_pos_x_lo
	TAX
	LDA ball_pass_pos_x_hi
	SBC ball_pos_x_hi
	TAY
	BCS bra_03_DD83
	JSR _EOR_16bit_b03
bra_03_DD83:
	ROL $2A
	STX $53
	STY $58
	LDA #$00
	STA $52
	LDA ball_pass_pos_y_lo
	SEC
	SBC ball_pos_y_lo
	TAX
	LDA ball_pass_pos_y_hi
	SBC ball_pos_y_hi
	TAY
	BCS bra_03_DDA1
	JSR _EOR_16bit_b03
bra_03_DDA1:
	ROL $2A
	STX $54
	STY $57
	SEC
	TXA
	SBC $53
	TYA
	SBC $58
	BCS bra_03_DDB4
	LDX $53
	LDY $58
bra_03_DDB4:
	STX $041B
	STY $041C
	JSR _loc_03_CBA4
	LDX #$00
bra_03_DDBF:
	LDA table_03_FBFA,X
	SEC
	SBC $52
	LDA table_03_FBFA + 1,X
	SBC $53
	BCS bra_03_DDD0
	INX
	INX
	BNE bra_03_DDBF
bra_03_DDD0:
	TXA
	LSR
	LSR $2A
	BCS bra_03_DDD8
	EOR #$7F
bra_03_DDD8:
	LSR $2A
	BCS bra_03_DDDE
	EOR #$FF
bra_03_DDDE:
	RTS

_loc_03_DDDF:
	JSR _loc_03_DE6D
	STX $03D5
	STY $03D7
	JSR _loc_03_DE64
	STX $03DB
	STY $03DD
	RTS

_loc_03_DDF2:
	JSR _loc_03_DDDF
	LDA #$00
	STA $52
	LDA $041B
	STA $53
	LDA $041C
	STA $58
	LDA ball_dir
	BPL bra_03_DE0C
	EOR #$FF
	AND #$7F
bra_03_DE0C:
	CMP #$40
	BCC bra_03_DE14
	EOR #$3F
	AND #$3F
bra_03_DE14:
	CMP #$20
	BCC bra_03_DE1E
	LDX $03D5
	LDY $03D7
bra_03_DE1E:
	TYA
	BPL bra_03_DE24
	JSR _EOR_16bit_b03
bra_03_DE24:
	STX $54
	STY $57
	JSR _loc_03_CBA4
	LDA $52
	STA $041F
	LDA $53
	STA $0420
	RTS

_loc_03_DE36:
	LDA $041F
	STA $4A
	LDA $0420
	LSR
	ROR $4A
	STA $4B
	LDA #$09
	STA $4C
	LDA #$00
	STA $4D
	JSR _loc_03_CB75
	LDA $4E
	STA $0421
	LDA $4F
	STA $0423
	LDA #$00
	STA $0422
	STA ball_z_lo
	STA ball_z_hi
	RTS

_loc_03_DE64:
	LDA ball_dir
	JSR _loc_03_CC20
	JMP _loc_03_DE73
_loc_03_DE6D:
	LDA ball_dir
	JSR _loc_03_CC23
_loc_03_DE73:
	TYA
	PHP
	BPL bra_03_DE7A
	JSR _EOR_16bit_b03
bra_03_DE7A:
	STX $4A
	STY $4B
	LDA $041D
	STA $4C
	LDA $041E
	STA $4D
	JSR _loc_03_CB75
	LDX $4F
	LDY $50
	PLP
	BPL bra_03_DE95
	JSR _EOR_16bit_b03
bra_03_DE95:
	RTS

_loc_03_DE96:
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	LDA #$00
	STA spr_cnt_index
	STA spr_cnt_ovf
	LDA #$00
	STA spr_limit
	JSR _loc_01_847D
	LDA plr_w_ball
	BMI @skip
	JSR _SelectInitialPlayerDataAddress_b03
	JSR _loc_01_8696
@skip:
	LDA #$16
	JSR _SelectInitialBallDataAddress
	JSR _loc_01_8696
	LDA #$17
	JSR _SelectInitialShadowDataAddress
	JSR _loc_01_8696
	JSR _loc_01_863C
	LDA spr_limit
	PHA
	LDA spr_cnt_index
	STA spr_cnt_index_copy
	TAX
	LDA game_mode_flags
	AND #F_GM_PENALTY
	BNE bra_03_DEE7
	SEC
	SBC $5E
	ASL
	ASL
	CMP spr_cnt_index
	BCS bra_03_DEE6
	LDA spr_cnt_index
bra_03_DEE6:
	TAX
bra_03_DEE7:
	STX spr_cnt_index
	LDA #$00
bra_03_DEEB:
	PHA
	CMP plr_w_ball
	BEQ bra_03_DEF7
	JSR _SelectInitialPlayerDataAddress_b03
; бряк срабатывает когда поле уже отрисовано, но игроков еще не видно
	JSR _loc_01_8696
bra_03_DEF7:
	PLA
	CLC
	ADC #$01
	CMP #$16
	BNE bra_03_DEEB
	BIT spr_cnt_ovf
	BMI @skip_hiding
	LDY spr_limit
	LDX spr_cnt_index
	LDA #$F8
@hide_unused_sprites:
	STA oam_y,X
	INX
	BNE @try_to_quit_loop
	LDX spr_cnt_index_copy
@try_to_quit_loop:
	DEY
	BNE @hide_unused_sprites
@skip_hiding:
	PLA
	SEC
	SBC spr_limit
	STA $2A
	LDA $5F
	CLC
	ADC #$08
	CMP $2A
	BCC bra_03_DF28
	LDA #$00
bra_03_DF28:
	STA $5F
	LDA $2A
	SEC
	SBC $5F
	STA $5E
	LDA #$00
	STA plr_cur_id
bra_03_DF35:
	LDA plr_cur_id
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_sub1_timer
	LDA (plr_data),Y
	BEQ bra_03_DF55
	CMP #$FF
	BEQ bra_03_DF55
	SEC
	SBC #$01
	STA (plr_data),Y
	BNE bra_03_DF55
	LDY #plr_sub_hi
	LDA (plr_data),Y
	PHA
	INY
	LDA (plr_data),Y	; plr_sub_lo
	PHA
	RTS

bra_03_DF55:
SelectNextIndexForPlayers:
	INC plr_cur_id
	LDA plr_cur_id
	CMP #$16
	BNE bra_03_DF35
	RTS

_loc_03_DF5E:
	LDA $03D3
	AND #$10
	BNE bra_03_DFB9
	LDA #$00
bra_03_DF67:
	PHA
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_state
	LDA (plr_data),Y
	CMP #STATE_FOLLOW_BALL
	BNE bra_03_DF80
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
bra_03_DF80:
	PLA
	CLC
	ADC #$01
	CMP #$16
	BNE bra_03_DF67
	LDA team_w_ball
	JSR _FindClosestPlayer_ForRecievePass
	LDA #STATE_FOLLOW_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA team_w_ball
	EOR #$0B
	JSR _FindClosestPlayer_ForRecievePass
	LDA #STATE_FOLLOW_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA plr_cur_id
	JSR _SelectInitialPlayerDataAddress_b03
bra_03_DFB9:
	RTS

CheckButtonsWhenShooting_03_DFBA:
; проверяются кнопки чтобы вычислить направление
; если это CPU, код срабатывает только при ударе по воротам, и то видимо не всегда
	LDA btn_hold
	LDX team_w_ball
	BEQ @check_buttons
	LDA btn_hold + 1
	BIT game_mode_flags
	BMI @check_buttons
	LDA random		; если второй игрок CPU
	AND #$03
	TAX
	LDA BotDirection_table_03_DFE6,X
	JMP _loc_03_DFDE
@check_buttons:
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	BEQ bra_03_DFE5
	TAX
	LDA Direction_table_03_E083,X
_loc_03_DFDE:
	LDY #plr_dir
	STA (plr_data),Y
	JSR _loc_03_DFEA
bra_03_DFE5:
	RTS

BotDirection_table_03_DFE6:		; читаются с пмощью рандома, один из 4х байтов
								; похожая таблица в table_03_EA79
.byte $00,$20,$E0,$00

_loc_03_DFEA:
	LDX team_w_ball
	BEQ bra_03_DFF2
	CLC
	ADC #$80
bra_03_DFF2:
	CMP #$60
	BCC bra_03_E01C
	CMP #$A1
	BCS bra_03_E01C
	STA $2A
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	TAX
	INY
	INY
	LDA (plr_data),Y
	TAY
	LDA team_w_ball
	BEQ bra_03_E00E
	JSR _EOR_16bit_plus4_b03
bra_03_E00E:
	SEC
	TXA
	SBC #$40
	TYA
	SBC #$01
	BCS bra_03_E01C
	LDA $2A
	JSR _loc_03_E01D
bra_03_E01C:
	RTS

_loc_03_E01D:
	LDX #$00
	LDY #$01
	CMP #$80
	BEQ bra_03_E02E
	LDX #$28
	CMP #$A0
	BNE bra_03_E02E
	JSR _EOR_16bit_plus2_b03
bra_03_E02E:
	LDA team_w_ball
	BEQ bra_03_E036
	JSR _EOR_16bit_plus2_b03
bra_03_E036:
	TYA
	LDY #plr_aim_x_hi
	STA (plr_data),Y
	DEY
	TXA
	STA (plr_data),Y
	LDX #$9C
	LDY #$00
	LDA team_w_ball
	BEQ bra_03_E04B
	JSR _EOR_16bit_plus4_b03
bra_03_E04B:
	TYA
	LDY #plr_aim_y_hi
	STA (plr_data),Y
	DEY
	TXA
	STA (plr_data),Y
	JSR _loc_03_E613
	RTS

; код еще не выполнялся
	LDA btn_hold
	LDX team_w_ball
	BNE bra_03_E063
	LDA btn_hold + 1
bra_03_E063:
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	BEQ @rts
	TAX
	LDA Direction_table_03_E083,X
	LDY #plr_dir
	STA (plr_data),Y
@rts:
	RTS

CompareWithCurrentDirection_03_E070:
; проверка необходимости повторно вычислить скорость когда игрок меняет направление движения
; в A подается кнопка движения
	TAX
	LDA Direction_table_03_E083,X
	LDY #plr_dir
	CMP (plr_data),Y
	BEQ @direction_is_the_same
	STA (plr_data),Y	; записать новое направление
	JSR CalculatePlayerCurrentSpeed_03_E580
@direction_is_the_same:
	JSR _loc_03_E4A9
	RTS

Direction_table_03_E083:		; читается из 5 мест, направление игрока при нажатии кнопки движения
.byte $FF,$40,$C0,$FF,$00,$20,$E0,$FF,$80,$60,$A0,$FF,$FF,$FF,$FF,$FF

_loc_03_E093:
	LDX btn_hold
	TAY
	BEQ bra_03_E0A3
	LDX btn_hold + 1
	BIT game_mode_flags
	BMI bra_03_E0A3
	LDX #$00
bra_03_E0A3:
	LDA #$00
_loc_03_E0A5:
	STA $2B
	TXA
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	BNE bra_03_E0B1
	JSR _ClearPlayerAnimationCounterLow
	CLC
	RTS

bra_03_E0B1:			; ограничение кипера на зоне
	JSR CompareWithCurrentDirection_03_E070
	LDA #$00
	STA $2A
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	TAX
	INY
	INY
	LDA (plr_data),Y
	TAY
	BEQ bra_03_E0C9
	JSR _EOR_16bit_plus2_b03
	INC $2A
bra_03_E0C9:
	SEC
	TXA
	LDX $2B
	SBC table_03_E15B,X
	TYA
	SBC table_03_E15B + 1,X
	BCS bra_03_E0EE
	LDA table_03_E15B,X
	LDY table_03_E15B + 1,X
	TAX
	LSR $2A
	BCC bra_03_E0E4
	JSR _EOR_16bit_plus2_b03
bra_03_E0E4:
	TYA
	LDY #plr_pos_x_hi
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y
bra_03_E0EE:
	LDA #$00
	STA $2A
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	TAX
	INY
	INY
	LDA (plr_data),Y
	TAY
	CMP #$02
	BCC bra_03_E105
	JSR _EOR_16bit_plus4_b03
	INC $2A
bra_03_E105:
	SEC
	TXA
	PHA
	LDX $2B
	SBC table_03_E15B + 2,X
	TYA
	SBC table_03_E15B + 3,X
	PLA
	BCS bra_03_E11E
	LDA table_03_E15B + 2,X
	LDY table_03_E15B + 3,X
	TAX
	JMP _loc_03_E12E
bra_03_E11E:
	SBC table_03_E15B + 4,X
	TYA
	SBC table_03_E15B + 5,X
	BCC bra_03_E13F
	LDA table_03_E15B + 4,X
	LDY table_03_E15B + 5,X
	TAX
_loc_03_E12E:
	LSR $2A
	BCC bra_03_E135
	JSR _EOR_16bit_plus4_b03
bra_03_E135:
	TYA
	LDY #plr_pos_y_hi
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y
bra_03_E13F:
	LDY #plr_act_timer2
	LDA (plr_data),Y
	SEC
	SBC #$01
	STA (plr_data),Y
	BPL bra_03_E159
	LDA #$05
	STA (plr_data),Y
	LDY #plr_anim_cnt_lo
	LDA (plr_data),Y
	CLC
	ADC #$01
	AND #$03
	STA (plr_data),Y
bra_03_E159:
	SEC
	RTS

table_03_E15B:		; ограничение кипера на зоне
.byte $B8,$00,$A8,$00,$C8,$00
.byte $D0,$00,$A8,$00,$C0,$00

_loc_03_E167:
	JSR _loc_01_89F3
	LDY #plr_init_spd_fr
	LDA $77
	STA (plr_data),Y
	INY
	LDA $78
	STA (plr_data),Y
	RTS

_DoTackle:
; сначала идет проверка на киперов, но бесполезная
; так как где-то еще код не дает киперу сделать подкат
	LDA plr_w_ball
	BNE bra_03_E17E
; прыжок еще не выполнялся
	JMP _loc_03_E209
bra_03_E17E:
	CMP #$0B
	BNE bra_03_E185
	JMP _loc_03_E209
bra_03_E185:
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA #SOUND_TACKLE
	JSR _WriteSoundID_b03
	JSR _ClearPlayerAnimationCounterLow
	LDA #$08
	JSR _loc_01_878F
	LDA #$04
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$08
	JSR _loc_01_878F
	LDY #plr_init_spd_lo
	LDA #$02
	STA (plr_data),Y
	DEY
	LDA #$00
	STA (plr_data),Y	; plr_init_spd_fr
	JSR CalculatePlayerCurrentSpeed_03_E580
	LDA plr_cur_id
	LDX #$01
	JSR _loc_03_E167
	LDY #plr_act_timer1
	LDA #$18
	STA (plr_data),Y
	LDY #plr_act_timer2
	LDA #$00
	STA (plr_data),Y
bra_03_E1CA:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _loc_03_E4A9
	JSR _loc_03_E255
	LDY #plr_act_timer1
	LDA (plr_data),Y
	SEC
	SBC #$01
	STA (plr_data),Y
	BNE bra_03_E1CA
	JSR _loc_03_E223
	LDY #plr_act_timer1
	LDA #$0A
	STA (plr_data),Y
bra_03_E1E9:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _loc_03_E4A9
	LDY #plr_act_timer1
	LDA (plr_data),Y
	SEC
	SBC #$01
	STA (plr_data),Y
	BNE bra_03_E1E9
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$08
	JSR _loc_01_878F
	LDA #$0A
	JSR _SavePlayerSubroutine
_loc_03_E209:
	LDA plr_cur_id
	CMP plr_wo_ball
	BNE @skip
	JMP _PlayerStateWithoutBall
@skip:
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_FOLLOW_ENEMY
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
_loc_03_E223:
	LDY #plr_cur_spd_x_fr
	JSR _loc_03_E22E
	LDY #plr_cur_spd_y_fr
	JSR _loc_03_E22E
	RTS

_loc_03_E22E:
	LDA (plr_data),Y
	TAX
	INY
	INY
	STY $2A
	LDA (plr_data),Y	; plr_cur_spd_x_lo / plr_cur_spd_y_lo
	TAY
	PHP
	BPL bra_03_E23E
	JSR _EOR_16bit_b03
bra_03_E23E:
	TYA
	LSR
	TAY
	TXA
	ROR
	TAX
	PLP
	BPL bra_03_E24A
	JSR _EOR_16bit_b03
bra_03_E24A:
	TYA
	LDY $2A
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y
	RTS

_loc_03_E255:
	LDY #plr_act_timer2
	LDA (plr_data),Y
	BPL bra_03_E25E
	JMP _loc_03_E34D
bra_03_E25E:
	LDA plr_w_ball		; проверка на киперов
	BMI bra_03_E28C
	BNE bra_03_E268
	JMP _loc_03_E342
bra_03_E268:
	CMP #$0B
	BNE bra_03_E26F
	JMP _loc_03_E342
bra_03_E26F:
	LDX #$0C
	JSR _ComparePlayerWithBallCoordinates1
	BCC bra_03_E28C
	LDA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_DODGE
	JSR _SelectPlayerSubroutine_b03
	JMP _loc_03_E342
bra_03_E28C:
	LDY #plr_dir
	LDA (plr_data),Y
	CLC
	ADC #$10
	AND #$E0
	LSR
	LSR
	LSR
	TAX
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	STA $2A
	ADC table_03_E34E,X
	STA (plr_data),Y
	INY
	INY
	LDA (plr_data),Y
	STA $2B
	ADC table_03_E34E + 1,X
	STA (plr_data),Y
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	STA $2C
	ADC table_03_E34E + 2,X
	STA (plr_data),Y
	INY
	INY
	LDA (plr_data),Y
	STA $2D
	ADC table_03_E34E + 3,X
	STA (plr_data),Y
	LDA #$16
	LDX #$08
	JSR _ComparePlayerWithBallCoordinates1
	LDA $2A
	LDY #plr_pos_x_lo
	STA (plr_data),Y
	INY
	INY
	LDA $2B
	STA (plr_data),Y
	LDY #plr_pos_y_lo
	LDA $2C
	STA (plr_data),Y
	INY
	INY
	LDA $2D
	STA (plr_data),Y
	BCC bra_03_E34D
	LDA plr_cur_id
	LDX #$01
	JSR _loc_01_89F3
	LDA $77
	STA $041D
	LDA $78
	STA $041E
	LDY #plr_dir
	LDA (plr_data),Y
	STA ball_dir
	LDA #$10
	STA $041B
	LDA #$00
	STA $041C
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D6FA_minus1
	LDY #<_loc_03_D6FA_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA plr_w_ball
	BMI bra_03_E342
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_DEAD
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA #$80
	STA plr_w_ball
	LDA plr_cur_id
	JSR _loc_03_C92B
_loc_03_E342:
bra_03_E342:
	LDA plr_cur_id
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_act_timer2
	LDA #$80
	STA (plr_data),Y
_loc_03_E34D:
bra_03_E34D:
	RTS	
table_03_E34E:		; какие-то параметры игроков
.byte $00,$00,$1A,$00
.byte $14,$00,$14,$00
.byte $1A,$00,$00,$00
.byte $14,$00,$EC,$FF
.byte $00,$00,$E6,$FF
.byte $EC,$FF,$EC,$FF
.byte $E6,$FF,$00,$00
.byte $EC,$FF,$14,$00

_loc_03_E36E:
	LDA #$00
	STA $09
	STA $0A
	LDA plr_cur_id
	JSR _loc_03_C6B9
	JSR _loc_03_E3E1
	LDA #SOUND_RECEIVE
	JSR _WriteSoundID_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _ClearUnknownPlayerFlag
	LDA ball_dir
	CLC
	ADC #$80
	LDY #plr_dir
	STA (plr_data),Y
	SEC
	LDA ball_z_lo
	SBC #$0C
	LDA ball_z_hi
	SBC #$00
	BCC bra_03_E3C7
	BIT $0423
	BPL bra_03_E3C7
	JSR _ClearPlayerAnimationCounterLow
	LDA #$07
	JSR _loc_01_878F
	LDA #$01
	JSR _BallRelativePosition
bra_03_E3B7:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _loc_03_DD17
	JSR _loc_03_DCED
	DEC ball_z_lo
	BNE bra_03_E3B7
bra_03_E3C7:
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_WITH_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JMP SelectNextIndexForPlayers
_loc_03_E3E1:
	LDA btn_hold
	LDX team_w_ball
	BEQ bra_03_E405
	LDA btn_hold + 1
	BIT game_mode_flags
	BMI bra_03_E405
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал когда CPU завладел мячом
	JSR _loc_01_8B3F
	BCC bra_03_E40F
	BCS bra_03_E410
bra_03_E405:
	TAX
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	BEQ bra_03_E40F
	TXA
	AND #$C0
	BNE bra_03_E410
bra_03_E40F:
	RTS

bra_03_E410:
	PLA
	PLA
	JSR _ClearUnknownPlayerFlag
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDX #$00
	LDY #$00
bra_03_E421:
	SEC
	LDA ball_z_lo
	SBC table_03_E461,X
	LDA ball_z_hi
	SBC table_03_E461 + 1,X
	BMI bra_03_E435
	INX
	INX
	INY
	BNE bra_03_E421
bra_03_E435:
	TYA
	JSR _ReadBytesAfterJSR_b03

table_03_E439:		; таблица читается после JSR
.word table_03_E439_E43F
.word table_03_E439_E447
.word table_03_E439_E44F

table_03_E439_E43F:
	LDA #STATE_UNKNOWN_07
	JSR _SelectPlayerSubroutine_b03
	JMP _loc_03_E454

table_03_E439_E447:
	LDA #STATE_UNKNOWN_08
	JSR _SelectPlayerSubroutine_b03
	JMP _loc_03_E454

table_03_E439_E44F:
	LDA #STATE_UNKNOWN_0A
	JSR _SelectPlayerSubroutine_b03
_loc_03_E454:
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JMP SelectNextIndexForPlayers	
table_03_E461:
.byte $04,$00
.byte $08,$00
.byte $FF,$3F

_loc_03_E467:
	LDY #plr_aim_x_lo
	LDA (plr_data),Y
	LDY #plr_pos_x_lo
	SEC
	SBC (plr_data),Y
	TAX
	LDY #plr_aim_x_hi
	LDA (plr_data),Y
	LDY #plr_pos_x_hi
	SBC (plr_data),Y
	TAY
	BCS bra_03_E47F
	JSR _EOR_16bit_b03
bra_03_E47F:
	TYA
	BNE bra_03_E4A5
	CPX #$06
	BCS bra_03_E4A5
	LDY #plr_aim_y_lo
	LDA (plr_data),Y
	LDY #plr_pos_y_lo
	SEC
	SBC (plr_data),Y
	TAX
	LDY #plr_aim_y_hi
	LDA (plr_data),Y
	LDY #plr_pos_y_hi
	SBC (plr_data),Y
	TAY
	BCS bra_03_E49E
	JSR _EOR_16bit_b03
bra_03_E49E:
	TYA
	BNE bra_03_E4A5
	CPX #$06
	BCC bra_03_E4A7
bra_03_E4A5:
	CLC
	RTS

bra_03_E4A7:
	SEC
	RTS

_loc_03_E4A9:
	LDY #plr_cur_spd_x_fr
	JSR _loc_03_E4B0
	LDY #plr_cur_spd_y_fr
_loc_03_E4B0:
	CLC
	LDA (plr_data),Y
	INY
	ADC (plr_data),Y
	STA (plr_data),Y
	LDX #$00
	INY
	LDA (plr_data),Y
	BPL bra_03_E4C0
	DEX
bra_03_E4C0:
	INY
	ADC (plr_data),Y
	STA (plr_data),Y
	INY
	INY
	TXA
	ADC (plr_data),Y
	BPL bra_03_E4D6
	LDA #$00
	STA (plr_data),Y
	DEY
	DEY
	STA (plr_data),Y
	DEY
	DEY
bra_03_E4D6:
	STA (plr_data),Y
	RTS

_loc_03_E4D9:
_loc_03_E4D9_minus1 = _loc_03_E4D9 - 1
	LDA #$00
	STA plr_frame_id
_loc_03_E4DE:
	LDA #$01
	JSR _FrameDelay_b03
	LDA plr_frame_id
	JSR _SelectInitialPlayerDataAddress_b03
	JSR _loc_03_C843
	LDY #plr_unknown_19
	STA (plr_data),Y
	LDY #plr_flags
	LDA (plr_data),Y
	TAX
	AND #F_CONTROL
	BNE bra_03_E506
	TXA
	AND #F_BUSY
	BEQ bra_03_E506
	TXA
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
; бряк сработал после разводки мяча
	JSR _loc_01_88E0
bra_03_E506:
	LDY #plr_flags
	LDA (plr_data),Y
	AND #FLAG_PL_UNKNOWN
	BEQ bra_03_E517
	LDA (plr_data),Y
	AND #FLAG_PL_UNKNOWN_CLEAR
	STA (plr_data),Y
	JSR _loc_03_E527
bra_03_E517:
	LDX plr_frame_id
	INX
	CPX #$16
	BNE bra_03_E521
	LDX #$00
bra_03_E521:
	STX plr_frame_id
	JMP _loc_03_E4DE
_loc_03_E527:
	LDY #plr_state
	LDA (plr_data),Y
	JSR _ReadBytesAfterJSR_b03

table_03_E52E:		; таблица читается после JSR
.word table_03_E52E_E57D		; 00
.word table_03_E52E_E57D		; 01
.word table_03_E52E_E576		; 02 прыжок на RTS
.word table_03_E52E_E59B		; 03 прыжок на другой RTS
.word table_03_E52E_E57D		; 04
.word table_03_E52E_E576		; 05 прыжок на RTS
.word table_03_E52E_E576		; 06 прыжок на RTS, еще не использовалось
.word table_03_E52E_E576		; 07 прыжок на RTS, еще не использовалось
.word table_03_E52E_E576		; 08 прыжок на RTS, еще не использовалось
.word table_03_E52E_E576		; 09 прыжок на RTS, еще не использовалось
.word table_03_E52E_E576		; 0A прыжок на RTS, еще не использовалось
.word table_03_E52E_E576		; 0B прыжок на RTS, еще не использовалось
.word table_03_E52E_E576		; 0C прыжок на RTS, еще не использовалось
.word table_03_E52E_E576		; 0D прыжок на RTS, еще не использовалось
.word table_03_E52E_E576		; 0E прыжок на RTS, еще не использовалось
.word table_03_E52E_E59C		; 0F
.word table_03_E52E_E5A2		; 10
.word table_03_E52E_E5E1		; 11
.word table_03_E52E_E57D		; 12
.word table_03_E52E_E57D		; 13
.word table_03_E52E_E59C		; 14
.word table_03_E52E_E59C		; 15
.word table_03_E52E_E576		; 16 прыжок на RTS

_loc_03_E55C:
	LDY #plr_aim_x_lo
	LDA ball_pos_x_lo
	STA (plr_data),Y
	INY
	LDA ball_pos_x_hi
	STA (plr_data),Y
	INY
	LDA ball_pos_y_lo
	STA (plr_data),Y
	INY
	LDA ball_pos_y_hi
	STA (plr_data),Y
	RTS

table_03_E52E_E576:
	RTS

_loc_03_E577:
	JSR _loc_03_E55C
	JMP _loc_03_E5E4

table_03_E52E_E57D:
_loc_03_E57D:
	JSR _loc_03_E577
CalculatePlayerCurrentSpeed_03_E580:
	JSR CalculatePlayerSpeed_03_E697
	TYA
	LDY #plr_cur_spd_x_lo
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y	; plr_cur_spd_x_fr
	JSR _loc_03_E68D
	TYA
	LDY #$0A
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y
	RTS

table_03_E52E_E59B:
	RTS

table_03_E52E_E59C:
	JSR _loc_03_E5E4
	JMP CalculatePlayerCurrentSpeed_03_E580

table_03_E52E_E5A2:
	LDY #plr_act_timer1
	LDA (plr_data),Y
	LDY #$05
	JSR _loc_03_E5C6
	TYA
	LDY #plr_aim_x_hi
	JSR _loc_03_E5DA
	LDY #plr_act_timer2
	LDA (plr_data),Y
	LDY #$0B
	JSR _loc_03_E5C6
	TYA
	LDY #plr_aim_y_hi
	JSR _loc_03_E5DA
	JSR _loc_03_E5E4
	JMP CalculatePlayerCurrentSpeed_03_E580
_loc_03_E5C6:
	LDX #$00
	PHA
	PLA
	BPL bra_03_E5CD
	DEX
bra_03_E5CD:
	CLC
	ADC $03D3,Y
	PHA
	TXA
	ADC $03D5,Y
	TAY
	PLA
	TAX
	RTS

_loc_03_E5DA:
	STA (plr_data),Y
	DEY
	TXA
	STA (plr_data),Y
	RTS

table_03_E52E_E5E1:
	JMP _loc_03_E57D

_loc_03_E5E4:
	JSR _loc_03_E604
	LDY plr_frame_id
	BEQ @player_is_gk
	CPY #$0B
	BEQ @player_is_gk
	LDA #$00
	TAX
	BCC @is_first_team
	LDA #$0B
@is_first_team:
	EOR team_w_ball
	BEQ @skip
	INX
@skip:
	LDA plr_frame_id
	JSR _loc_03_E167
@player_is_gk:
	RTS

_loc_03_E604:
	JSR _loc_03_E613
	LDA #$01
	JSR _FrameDelay_b03
	LDA plr_frame_id
	JSR _SelectInitialPlayerDataAddress_b03
	RTS

_loc_03_E613:
	LDA #$00
	STA $2A
	LDY #plr_aim_x_lo
	LDA (plr_data),Y
	LDY #plr_pos_x_lo
	SEC
	SBC (plr_data),Y
	TAX
	LDY #plr_aim_x_hi
	LDA (plr_data),Y
	LDY #plr_pos_x_hi
	SBC (plr_data),Y
	TAY
	BCS bra_03_E62F
	JSR _EOR_16bit_b03
bra_03_E62F:
	ROL $2A
	STX $53
	STY $58
	LDA #$00
	STA $52
	LDY #plr_aim_y_lo
	LDA (plr_data),Y
	LDY #plr_pos_y_lo
	SEC
	SBC (plr_data),Y
	TAX
	LDY #plr_aim_y_hi
	LDA (plr_data),Y
	LDY #plr_pos_y_hi
	SBC (plr_data),Y
	TAY
	BCS bra_03_E651
	JSR _EOR_16bit_b03
bra_03_E651:
	ROL $2A
	STX $54
	STY $57
	SEC
	TXA
	SBC $53
	TYA
	SBC $58
	BCS bra_03_E664
	LDX $53
	LDY $58
bra_03_E664:
	JSR _loc_03_CBA4
	LDX #$00
bra_03_E669:
	LDA table_03_FBFA,X
	SEC
	SBC $52
	LDA table_03_FBFA + 1,X
	SBC $53
	BCS bra_03_E67A
	INX
	INX
	BNE bra_03_E669
bra_03_E67A:
	TXA
	LSR
	LSR $2A
	BCS bra_03_E682
	EOR #$7F
bra_03_E682:
	LSR $2A
	BCS bra_03_E688
	EOR #$FF
bra_03_E688:
	LDY #plr_dir
	STA (plr_data),Y
	RTS

_loc_03_E68D:
	LDY #plr_dir
	LDA (plr_data),Y
	JSR _loc_03_CC20
	JMP _loc_03_E69E

CalculatePlayerSpeed_03_E697:
	LDY #plr_dir
	LDA (plr_data),Y
	JSR _loc_03_CC23
_loc_03_E69E:
	TYA
	PHP
	BPL bra_03_E6A5
	JSR _EOR_16bit_b03
bra_03_E6A5:
	STX $4A
	STY $4B
	LDY #plr_init_spd_fr
	LDA (plr_data),Y
	STA $4C
	INY
	LDA (plr_data),Y
	STA $4D
	JSR _loc_03_CB75
	LDX $4F
	LDY $50
	PLP
	BPL bra_03_E6C1
	JSR _EOR_16bit_b03
bra_03_E6C1:
	RTS

PlyerStateSubroutine_table:		; E6C2, байты для PLA + PLA + RTS
.word _PlayerStateIdle					- 1		; 00
.word _PlayerStateUnknown01				- 1		; 01
.word _PlayerStateWithBall				- 1		; 02
.word _PlayerStateFollowBall			- 1		; 03
.word _PlayerStateWithoutBall			- 1		; 04
.word _PlayerStateDead					- 1		; 05
.word _PlayerStateDodge					- 1		; 06
.word _PlayerStateUnknown07				- 1		; 07
.word _PlayerStateUnknown08				- 1		; 08
.word _PlayerStateUnknown09				- 1		; 09, скорее всего не используется
.word _PlayerStateUnknown0A				- 1		; 0A
.word _PlayerStateUnknown0B				- 1		; 0B, скорее всего не используется
.word _PlayerStateThrowIn				- 1		; 0C
.word _PlayerStateGoalKick				- 1		; 0D
.word _PlayerStateCornerKick			- 1		; 0E
.word _PlayerStaterRunToArea			- 1		; 0F
.word _PlayerStateUnknown10				- 1		; 10
.word _PlayerStateFollowEnemy			- 1		; 11
.word _PlayerStateFreeze				- 1		; 12
.word _PlayerStateUnknown13				- 1		; 13
.word _PlayerStateUnknown14				- 1		; 14
.word _PlayerStaterRunToBase			- 1		; 15
.word _PlayerStateGoalkeeperGetsBall	- 1		; 16, аналогично 0D
.word _PlayerStateUnknown17				- 1		; 17
.word _PlayerStateUnknown18				- 1		; 18
.word _PlayerStateUnknown19				- 1		; 19

_PlayerStateIdle:		; E6F6
	LDY #$00
	LDA (plr_data),Y
	AND #$FB
	STA (plr_data),Y
	JSR _ClearPlayerAnimationCounterLow
_loc_03_E701:
bra_03_E701:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #FLAG_PL_UNKNOWN
	BNE @check_gk
	JSR _SetUnknownPlayerFlag
	LDX plr_cur_id		; проверка индекса киперов
	BEQ @skip_gk
	CPX #$0B
	BEQ @skip_gk
	LDA #$01
	JSR _loc_01_878F
@skip_gk:
	JMP _loc_03_E701
@check_gk:
	LDX plr_cur_id		; проверка индекса киперов
	BEQ @move_gk
	CPX #$0B
	BNE @skip_moving
@move_gk:
	JSR _GoalkeeperReturnsToCenter
	JMP _loc_03_E701
@skip_moving:
	LDA #$00
	LDX plr_cur_id
	CPX #$0B
	BCC bra_03_E739
	LDA #$0B
bra_03_E739:
	EOR team_w_ball
	BEQ bra_03_E701
	LDA #$16
	LDX #$0A
	JSR _ComparePlayerWithBallCoordinates1
	BCC bra_03_E701
	BIT plr_w_ball
	BMI bra_03_E7B1
	LDA ball_dir
	LDY #plr_dir
	SEC
	SBC (plr_data),Y
	BCS bra_03_E75A
	EOR #$FF
	ADC #$01
bra_03_E75A:
	CMP #$40
	BCC bra_03_E701
	BIT random
	BPL bra_03_E79F
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_WITH_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_DEAD
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA plr_cur_id
	JSR _loc_03_C6B9
	JMP SelectNextIndexForPlayers
bra_03_E79F:
	LDA #STATE_DEAD
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JMP SelectNextIndexForPlayers
bra_03_E7B1:
	LDA $041E
	CMP #$03
	BCS bra_03_E7BD
	BIT random
	BPL bra_03_E819
bra_03_E7BD:
	BIT $0423
	BMI bra_03_E819
	LDA random + 1
	STA ball_dir
	ADC random
	AND #$1F
	ADC #$80
	STA $041D
	LDA #$30
	STA $041B
	LDA #$00
	STA $041E
	STA $041C
	LDA #$80
	STA plr_w_ball
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D6FA_minus1
	LDY #<_loc_03_D6FA_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA #$04	; небольшой таймер для игрока, прежде чем тот упадет на землю после удара об мяч
	JSR _SavePlayerSubroutine
	LDA #STATE_DEAD
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _loc_03_DF5E
	LDA plr_cur_id
	JSR _SelectInitialPlayerDataAddress_b03
	LDA plr_cur_id
	JSR _loc_03_C92B
	JMP SelectNextIndexForPlayers
bra_03_E819:
	JMP _loc_03_E36E

_GoalkeeperReturnsToCenter:		; E81C
; автоматический возврат кипера на центр ворот если он не активен
	SEC
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	SBC #$00
	TAX
	INY
	INY
	LDA (plr_data),Y
	SBC #$01
	TAY
	PHP
	BCS bra_03_E831
	JSR _EOR_16bit_b03
bra_03_E831:
	TYA
	BNE bra_03_E838
	CPX #$08		; погрешность смещения
	BCC bra_03_E864
bra_03_E838:
	LDY #plr_init_spd_fr
	LDA (plr_data),Y
	TAX
	INY
	LDA (plr_data),Y
	TAY
	LDA #$40
	PLP
	BCC bra_03_E84B
	JSR _EOR_16bit_b03
	LDA #$C0
bra_03_E84B:
	PHA
	TYA
	LDY #plr_cur_spd_x_lo
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y	; plr_cur_spd_x_fr
	PLA
	LDY #plr_dir
	STA (plr_data),Y
	LDY #$02
	JSR _loc_03_E4B0
	JSR _IncreasePlayerRunningAnimation
	RTS

bra_03_E864:
	PLP
	JSR _ClearPlayerAnimationCounterLow
	LDA #$02
	JSR _loc_01_878F
	RTS

_PlayerStateUnknown01:		; E86E
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
bra_03_E878:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _SetUnknownPlayerFlag
	JSR _IncreasePlayerRunningAnimation
	JSR _loc_03_E4A9
	BIT plr_w_ball
	BMI bra_03_E89B
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
bra_03_E89B:
	LDA #$16
	LDX #$0C
	JSR _ComparePlayerWithBallCoordinates1
	BCC bra_03_E878
	LDA plr_w_ball
	BMI bra_03_E8B9

; код еще не выполнялся
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03

bra_03_E8B9:
	LDA plr_cur_id
	JSR _loc_03_C6B9
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_WITH_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JMP SelectNextIndexForPlayers

_PlayerStateWithBall:		; E8D8
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA plr_cur_id
	JSR _loc_03_C6B9
	JSR _ClearUnknownPlayerFlag
	LDY #plr_dir
	LDA (plr_data),Y
	AND #$E0
	ORA #$01
	STA (plr_data),Y
	LDA plr_cur_id
	JSR _loc_03_C92B
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D79D_minus1
	LDY #<_loc_03_D79D_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA plr_cur_id
	LDX #$02
	JSR _loc_03_E167
	LDA #$00
	STA $82
bra_03_E915:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDA btn_hold
	LDX team_w_ball
	BEQ bra_03_E934
	LDA btn_hold + 1
	BIT game_mode_flags
	BMI bra_03_E934
; бряк сработал через кадр когда CPU завладел мячом
	JSR _loc_01_8BE8
	BIT bot_behav
	BPL bra_03_E934
	JMP BotShootingOrPassing_03_EA25
bra_03_E934:
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	BEQ @buttons_not_pressed
	JSR CompareWithCurrentDirection_03_E070
	LDA $03D3
	ORA #$40
	STA $03D3
	JSR _IncreasePlayerRunningAnimation
	JMP _loc_03_E95E
@buttons_not_pressed:
	LDA $03D3
	AND #$BF
	STA $03D3
	LDA #$00
	JSR _BallRelativePosition
	JSR _ClearPlayerAnimationCounterLow
	LDA #$06
	JSR _loc_01_878F
_loc_03_E95E:
	LDY #plr_dir
	LDA (plr_data),Y
	STA ball_dir
	LDA team_w_ball
	BNE bra_03_E972
	LDA #(BTN_A | BTN_B)
	AND btn_press
	JMP _loc_03_E97C
bra_03_E972:
	BIT game_mode_flags
	BPL bra_03_E915
	LDA #(BTN_A | BTN_B)
	AND btn_press + 1
_loc_03_E97C:
	BEQ bra_03_E915
	LDX #$04
	AND #$80
	BNE bra_03_E986
	LDX #$00
bra_03_E986:
	LDA table_03_E9B7,X
	STA $041B
	LDA table_03_E9B7 + 1,X
	STA $041C
	LDA table_03_E9B7 + 2,X
	STA $041D
	LDA table_03_E9B7 + 3,X
	STA $041E
	TXA
	BNE bra_03_E9B1
	LDA random
	AND #$3F
	ADC $041B
	STA $041B
	BCC bra_03_E9B1
	INC $041C
bra_03_E9B1:
	JSR CheckButtonsWhenShooting_03_DFBA
	JMP _loc_03_E9BF

table_03_E9B7:
.byte $E0,$00,$00,$03
.byte $80,$00,$C0,$03

_loc_03_E9BF:
	LDA #SOUND_SHOOT
	JSR _WriteSoundID_b03
	JSR _ClearPlayerAnimationCounterLow
	LDA #$05
	JSR _loc_01_878F
	LDA #$02
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$05
	JSR _loc_01_878F
	LDA #$02
	JSR _SavePlayerSubroutine
	LDY #plr_dir
	LDA (plr_data),Y
	STA ball_dir
	LDA #$80
	STA plr_w_ball
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D6FA_minus1
	LDY #<_loc_03_D6FA_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA #$04
	JSR _SavePlayerSubroutine
	JSR _loc_03_DF5E
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$05
	JSR _loc_01_878F
	LDA #$30
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers

BotShootingOrPassing_03_EA25:
; бот с мячом собрался давать пас или бить по воротам
	LDA bot_behav
	LSR
	BCC @shooting
	LDA bot_mate	; бот решил делать пас, чтение его напарника
	JSR _loc_03_EA7D
	LDA #$00
	STA $041D
	LDA #$02
	STA $041E
	JMP _loc_03_E9BF
@shooting:
	LDA random		; срабатывает когда бот собирается бить по воротам
	AND #$03
	TAX
	LDA BotDirection_table_03_EA79,X
	LDY #plr_dir
	STA (plr_data),Y
	CLC
	ADC #$80
	JSR _loc_03_E01D
	LDY #plr_aim_x_lo
	LDA (plr_data),Y
	STA ball_pass_pos_x_lo
	INY
	LDA (plr_data),Y
	STA ball_pass_pos_x_hi
	LDY #plr_aim_y_lo
	LDA (plr_data),Y
	STA ball_pass_pos_y_lo
	INY
	LDA (plr_data),Y
	STA ball_pass_pos_y_hi
	JSR _CalculateBallDirectionForPass
	LDA #$00
	STA $041D
	LDA #$04
	STA $041E
	JMP _loc_03_E9BF

BotDirection_table_03_EA79:			; читаются с пмощью рандома, один из 4х байтов
									; похожая таблица в table_03_DFE6
.byte $E0,$00,$20,$00
	
_loc_03_EA7D:
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	STA ball_pass_pos_x_lo
	INY
	INY
	LDA (plr_data),Y	; plr_pos_x_hi
	STA ball_pass_pos_x_hi
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	STA ball_pass_pos_y_lo
	INY
	INY
	LDA (plr_data),Y	; plr_pos_y_hi
	STA ball_pass_pos_y_hi
	LDA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	JSR _CalculateBallDirectionForPass
	STA ball_dir
	LDY #plr_dir
	STA (plr_data),Y
	RTS

_PlayerStateFollowBall:		; EAAD
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
_loc_03_EAB7:
bra_03_EAB7:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDA #$00
	STA $2A
	LDY #plr_aim_y_hi
	LDX #$03
bra_03_EAC4:
	LDA ball_land_pos_x_lo,X
	CMP (plr_data),Y
	STA (plr_data),Y
	BEQ bra_03_EACF
	INC $2A
bra_03_EACF:
	DEY
	DEX
	BPL bra_03_EAC4
	LDA $2A
	BEQ bra_03_EAE0
	JSR _loc_03_E613
	JSR CalculatePlayerCurrentSpeed_03_E580
	JMP _loc_03_EAB7
bra_03_EAE0:
	JSR _loc_03_E467
	BCS bra_03_EAEE
	JSR _IncreasePlayerRunningAnimation
	JSR _loc_03_E4A9
	JMP _loc_03_EB00
bra_03_EAEE:
	LDA ball_dir
	CLC
	ADC #$80
	LDY #plr_dir
	STA (plr_data),Y
	JSR _ClearPlayerAnimationCounterLow
	LDA #$01
	JSR _loc_01_878F
_loc_03_EB00:
	BIT plr_w_ball
	BMI bra_03_EB15
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
bra_03_EB15:
	LDA #$16
	LDX #$0C
	JSR _ComparePlayerWithBallCoordinates1
	BCC bra_03_EAB7
	JMP _loc_03_E36E

_PlayerStateWithoutBall:		; EB21, сюда прыжок из таблицы и обычный
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _ClearUnknownPlayerFlag
	LDY #plr_dir
	LDA #$FF
	STA (plr_data),Y
	LDA plr_cur_id		; проверка на киперов, от нее частично зависит будет ли кипер делать подкат
	BNE @not_first_gk
	JMP _PlayerStateWithoutBall_ForGoalkeeper
@not_first_gk:
	CMP #$0B
	BNE @not_second_gk
	JMP _PlayerStateWithoutBall_ForGoalkeeper
@not_second_gk:
	LDX #$01
	JSR _loc_03_E167
	LDA game_mode_flags
	AND #F_OUT_OF_PLAY
	BEQ bra_03_EB5E
_loc_03_EB4E:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _ClearPlayerAnimationCounterLow
	LDA #$01
	JSR _loc_01_878F
	JMP _loc_03_EB4E
bra_03_EB5E:
	LDA plr_cur_id
	CMP #$0B
	BCC bra_03_EB79
	BIT game_mode_flags
	BMI bra_03_EB79
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_FOLLOW_ENEMY
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
_loc_03_EB79:
bra_03_EB79:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDA plr_cur_id
	CMP plr_wo_ball
	BEQ bra_03_EB95
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
bra_03_EB95:
	LDA btn_hold
	LDX team_w_ball
	BNE bra_03_EBA0
	LDA btn_hold + 1
bra_03_EBA0:
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	BEQ bra_03_EBB0
	JSR CompareWithCurrentDirection_03_E070
	JSR _loc_03_EC19
	JSR _IncreasePlayerRunningAnimation
	JMP _loc_03_EBB8
bra_03_EBB0:
	JSR _ClearPlayerAnimationCounterLow
	LDA #$01
	JSR _loc_01_878F
_loc_03_EBB8:
	LDX #$08
	LDA #$16
	JSR _ComparePlayerWithBallCoordinates1
	BCC @is_far_from_the_ball
	LDA plr_w_ball
	BMI @nobody_owns_the_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_DEAD
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
@nobody_owns_the_ball:
	LDA plr_cur_id
	JSR _loc_03_C6B9
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_WITH_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JMP SelectNextIndexForPlayers
@is_far_from_the_ball:
	LDA team_w_ball
	BEQ @read_2nd_player
	LDA #BTN_A
	AND btn_press
	JMP @check_button
@read_2nd_player:
	LDA #BTN_A
	AND btn_press + 1
@check_button:
	BNE @tackle
	JMP _loc_03_EB79
@tackle:
	JMP _DoTackle

_loc_03_EC19:
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	TAX
	INY
	INY
	LDA (plr_data),Y
	TAY
	CMP #$02
	PHP
	BCC bra_03_EC2B
	JSR _EOR_16bit_plus4_b03
bra_03_EC2B:
	SEC
	TXA
	SBC #$88
	TYA
	SBC #$00
	BCS bra_03_EC49

; код еще не выполнялся
	LDX #$88
	LDY #$00
	PLP
	PHP
	BCC bra_03_EC3F
	JSR _EOR_16bit_plus4_b03
bra_03_EC3F:
	TYA
	LDY #plr_pos_y_hi
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y
bra_03_EC49:
	PLP
	RTS

_PlayerStateWithoutBall_ForGoalkeeper:		; EC4B
	LDY #plr_act_timer2
	LDA #$00
	STA (plr_data),Y
	LDA plr_cur_id
	LDX #$09
	JSR _loc_03_E167
_loc_03_EC58:
bra_03_EC58:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDA plr_cur_id
	CMP plr_wo_ball
	BNE bra_03_EC75
	LDA plr_w_ball
	BMI bra_03_EC8A
	LDX #$00
	CMP #$0B
	BCC bra_03_EC71
	LDX #$0B
bra_03_EC71:
	CPX plr_cur_id
	BNE bra_03_EC8A
bra_03_EC75:
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	LDA #$80
	STA plr_wo_ball
	JMP SelectNextIndexForPlayers
bra_03_EC8A:
	LDA plr_cur_id
	BEQ bra_03_ECAB
	BIT game_mode_flags
	BMI bra_03_ECAB
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал когда CPU завладел мячом
	JSR _loc_01_8B6B
	LDA #$06
	JSR _loc_03_E0A5
	JMP _loc_03_ECB0
bra_03_ECAB:
	LDA plr_cur_id
	JSR _loc_03_E093
_loc_03_ECB0:
	BCC bra_03_ECBD
	JSR _ClearUnknownPlayerFlag
	LDA #$04
	JSR _loc_01_878F
	JMP _loc_03_ECC5
bra_03_ECBD:
	JSR _SetUnknownPlayerFlag
	LDA #$02
	JSR _loc_01_878F
_loc_03_ECC5:
	LDX #$09
	LDA #$16
	JSR _ComparePlayerWithBallCoordinates2
	BCC bra_03_ECDD
	LDA ball_z_hi
	BNE bra_03_EC58
	LDA ball_z_lo
	CMP #$1C
	BCS bra_03_ECDD
	JMP _loc_03_EDE9
bra_03_ECDD:
	LDX #$14
	LDA #$16
	JSR _ComparePlayerWithBallCoordinates2
	BCS bra_03_ECE9
	JMP _loc_03_EC58
bra_03_ECE9:
	LDA ball_z_hi
	BEQ bra_03_ECF1
; прыжок еще не выполнялся
	JMP _loc_03_EC58
bra_03_ECF1:
	LDA ball_z_lo
	CMP #$18
	BCC bra_03_ECFB
	JMP _loc_03_EC58
bra_03_ECFB:
	JSR _loc_03_E55C
	JSR _loc_03_E613
	LDY #plr_dir
	LDA (plr_data),Y
	CLC
	ADC #$80
	SEC
	SBC ball_dir
	BCS bra_03_ED12
	EOR #$FF
	ADC #$01
bra_03_ED12:
	CMP #$20
	BCS bra_03_ED19
	JMP _loc_03_EC58
bra_03_ED19:
	LDA #$03
	STA ball_anim_id
	LDA #$00
	STA ball_z_lo
	STA ball_z_hi
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _ClearUnknownPlayerFlag
	JSR _ClearPlayerAnimationCounterLow
	LDA plr_cur_id
	JSR _loc_03_C92B
	LDA ball_dir
	CLC
	ADC #$08
	AND #$E0
	STA $2B
	LSR
	LSR
	LSR
	LSR
	STA $2A
	LDY #plr_dir
	LDA (plr_data),Y
	SEC
	SBC $2B
	AND #$E0
	LSR
	LSR
	LSR
	LSR
	LSR
	TAX
	LDA table_03_EF8F,X
	CLC
	ADC $2A
	AND #$0F
	LDY #plr_act_timer1
	STA (plr_data),Y
	TAX
	LDA table_03_EF97,X
	PHA
	AND #$C0
	STA $2A
	LDY #plr_spr_a
	LDA (plr_data),Y
	AND #$3F
	ORA $2A
	STA (plr_data),Y
	PLA
	AND #$03
	ASL
	STA $2A
	ASL
	ADC $2A
	LDY #plr_anim_cnt_lo
	STA (plr_data),Y
	JSR _loc_03_EEA3
	LDA #$00
	LDY #plr_act_timer2
	STA (plr_data),Y
_loc_03_ED8F:		; таймер анимации кипера при отбивании/ловли
	LDY #plr_act_timer2
	LDA (plr_data),Y
	TAX
	CLC
	ADC #$01
	STA (plr_data),Y
	LDA table_03_EFBF,X
	BNE bra_03_EDA9
	BIT gk_has_ball
	BMI bra_03_EDA6
	JMP _loc_03_EEFD
bra_03_EDA6:
	JMP _PlayerStateWithoutBall_ForGoalkeeper
bra_03_EDA9:
	CPX #$02
	BNE bra_03_EDB4
	BIT gk_has_ball
	BPL bra_03_EDB4
	LDA #$0C
bra_03_EDB4:
	PHA
	LDY #plr_act_timer1
	LDA (plr_data),Y
	TAY
	LDA table_03_EF97,Y
	AND #$03
	ASL
	ASL
	STA $2A
	ASL
	ADC $2A
	STA $2A
	TXA
	ASL
	ADC $2A
	STA $2A
	JSR _loc_03_EF30
	LDY #plr_anim_cnt_lo
	LDA (plr_data),Y
	TAX
	CLC
	ADC #$01
	STA (plr_data),Y
	LDA table_03_EFA7,X
	LDY #plr_anim_id
	STA (plr_data),Y
	PLA
	JSR _SavePlayerSubroutine
	JMP _loc_03_ED8F
_loc_03_EDE9:
	LDA #$00
	STA gk_has_ball
	LDA #$00
	STA ball_z_lo
	STA ball_z_hi
	LDA #$03
	STA ball_anim_id
	LDA #$06
	JSR _BallRelativePosition
	LDA ball_dir
	CLC
	ADC #$80
	LDY #plr_dir
	STA (plr_data),Y
	BIT plr_w_ball
	BPL bra_03_EE4A
	LDA random + 1		; шанс того, что кипер выпустит мяч из рук при ловле
	CMP #$E0
	BCC bra_03_EE4A
	LDA random
	AND #$1F
	BIT random
	BPL bra_03_EE24
	EOR #$FF
	ADC #$00
bra_03_EE24:
	CLC
	ADC #$80
	ADC ball_dir
	STA ball_dir
	LSR $041E
	ROR $041D
	JSR _loc_03_DDDF
	LDA #$80
	STA plr_w_ball
	JSR _loc_03_DF5E
	LDA #$80
	STA gk_has_ball
	LDA #SOUND_MISS_CATCH
	JSR _WriteSoundID_b03
	JMP _loc_03_EE6F
bra_03_EE4A:
	LDA plr_w_ball
	BMI bra_03_EE5F
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
bra_03_EE5F:
	LDA plr_cur_id
	JSR _loc_03_C6B9
	LDA #SOUND_CATCH
	JSR _WriteSoundID_b03
	LDA #$00
	STA $09
	STA $0A
_loc_03_EE6F:
	JSR _ClearPlayerAnimationCounterLow
	LDX ball_z_lo
	LDA #$13
	CPX #$0C
	BCC bra_03_EE7D
; инструкция еще не выполнялась
	LDA #$14
bra_03_EE7D:
	LDY #plr_act_timer2
	STA (plr_data),Y
; бряк сработал при ловле кипером мяча
	JSR _loc_01_878F
	LDA #$08
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDY #plr_act_timer2
	LDA (plr_data),Y
	JSR _loc_01_878F
	LDA #$14
	JSR _SavePlayerSubroutine
	BIT gk_has_ball
	BMI bra_03_EEA0
	JMP _loc_03_EEFD
bra_03_EEA0:
	JMP _PlayerStateWithoutBall_ForGoalkeeper
_loc_03_EEA3:
	LDA #$00
	STA gk_has_ball
	LDA plr_w_ball
	BPL bra_03_EEE1
	LDA $041E
	CMP #$02
	BCC bra_03_EEE1
	LDA #SOUND_MISS_CATCH
	JSR _WriteSoundID_b03
	LDA random
	CMP #$A0
	BCC bra_03_EEC1
	SBC #$A0
bra_03_EEC1:
	STA $2A
	LDA #$30
	LDX plr_cur_id
	BEQ bra_03_EECB
	LDA #$B0
bra_03_EECB:
	CLC
	ADC $2A
	STA ball_dir
	JSR _loc_03_DDDF
	LDA #$80
	STA plr_w_ball
	JSR _loc_03_DF5E
	LDA #$80
	STA gk_has_ball
	RTS

bra_03_EEE1:
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	LDA plr_cur_id
	JSR _loc_03_C6B9
	LDA #$00
	STA $09
	STA $0A
	RTS

_loc_03_EEFD:
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_GK_GET_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA random		; вычисление таймера для бота кипера, когда тот выбивает после ловли
	AND #$0F
	CLC
	ADC #$70
	LDY #plr_act_timer1
	STA (plr_data),Y
	LDA $042C
	ORA #$40
	STA $042C
	LDA #$80
	STA plr_wo_ball
	JMP SelectNextIndexForPlayers
_loc_03_EF30:
	BIT gk_has_ball
	BPL bra_03_EF37
	JMP _loc_03_EF8E
bra_03_EF37:
	LDX $2A
	LDY #plr_spr_a
	LDA (plr_data),Y
	AND #$40
	PHP
	LDA table_03_EFE6,X
	PLP
	BEQ bra_03_EF4B
	EOR #$FF
	CLC
	ADC #$01
bra_03_EF4B:
	PHA
	LDY #plr_pos_x_lo
	CLC
	ADC (plr_data),Y
	STA ball_pos_x_lo
	INY
	INY
	LDX #$00
	PLA
	BPL bra_03_EF5C
	DEX
bra_03_EF5C:
	TXA
	ADC (plr_data),Y
	STA ball_pos_x_hi
	LDY #plr_spr_a
	LDA (plr_data),Y
	PHP
	LDX $2A
	LDA table_03_EFE6 + 1,X
	PLP
	BPL bra_03_EF74
	EOR #$FF
	CLC
	ADC #$01
bra_03_EF74:
	PHA
	LDY #plr_pos_y_lo
	CLC
	ADC (plr_data),Y
	STA ball_pos_y_lo
	INY
	INY
	LDX #$00
	PLA
	BPL bra_03_EF85
	DEX
bra_03_EF85:
	TXA
	ADC (plr_data),Y
	STA ball_pos_y_hi
	JSR _loc_03_DCED
_loc_03_EF8E:
	RTS

table_03_EF8F:
.byte $07,$00,$02,$04,$06,$01,$03,$05

table_03_EF97:		; читается из 2х мест
.byte $42,$41,$40,$00,$01,$02,$03,$83,$82,$81,$80,$C0,$C1,$C2,$C3,$43

table_03_EFA7:
.byte $A7,$A8,$A9,$9E,$9F,$A0,$AB,$AC
.byte $AD,$AF,$B0,$B1,$B2,$B3,$B4,$B6,$B7,$B8,$B9,$BA,$BB,$A4,$A5,$A6

table_03_EFBF:		; таймеры анимации поднятия кипера при ловле/отбивании мяча
.byte $14,$10,$20,$18,$0C,$14,$00

; EFC6		таблица еще не считывалась, и непонятно откуда читается
.byte $0C,$0B,$F6,$F4,$0F,$00,$F1,$00,$0A
.byte $F4,$F4,$0B,$FE,$F3,$FE,$0D,$F4,$F5,$0A,$0C,$F1,$00,$0F,$00,$F6
.byte $0C,$0C,$F5,$02,$0D,$02,$F3

table_03_EFE6:
.byte $F1,$00
.byte $F3,$FF
.byte $F4,$00
.byte $03,$FB		; еще не читались
.byte $02,$FE		; еще не читались
.byte $FD,$FE		; еще не читались
.byte $0A,$F4
.byte $10,$F2
.byte $0D,$F5
.byte $FD,$FA
.byte $FE,$FB
.byte $FF,$FF
.byte $F4,$0B
.byte $F2,$10
.byte $F5,$0D
.byte $F9,$03
.byte $FB,$FD
.byte $FF,$01
.byte $FE,$F3
.byte $FB,$F1
.byte $00,$F4
.byte $FB,$03
.byte $FD,$02
.byte $FD,$00

_PlayerStateDead:		; F016
	LDA #SOUND_DEAD
	JSR _WriteSoundID_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _ClearUnknownPlayerFlag
	JSR _ClearPlayerAnimationCounterLow
	LDA #$09
	JSR _loc_01_878F
	LDA #$40	; таймер состояния трупа
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$09
	JSR _loc_01_878F
	LDA #$0C	; таймер поднятия после трупа
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	LDA plr_cur_id
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _loc_01_886C
	JSR _loc_01_88B2
	JMP SelectNextIndexForPlayers

_PlayerStateDodge:		; F067
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _ClearUnknownPlayerFlag
	JSR _ClearPlayerAnimationCounterLow
	LDA #$0A
	JSR _loc_01_878F
	LDA #$14
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0A
	JSR _loc_01_878F
	LDA #$06
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_WITH_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JMP SelectNextIndexForPlayers

_PlayerStaterRunToArea:		;F0A8
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
_loc_03_F0B0:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _SetUnknownPlayerFlag
	LDY #plr_unknown_19
	LDA (plr_data),Y
	LDY #plr_act_timer1
	CMP (plr_data),Y
	BNE bra_03_F0CA
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
bra_03_F0CA:
	JSR _IncreasePlayerRunningAnimation
	JSR _loc_03_E4A9
	JMP _loc_03_F0B0

_PlayerStateUnknown10:		;F0D3
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
_loc_03_F0DB:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _SetUnknownPlayerFlag
	JSR _loc_03_E467
	BCC bra_03_F0F3
	JSR _ClearPlayerAnimationCounterLow
	LDA #$01
	JSR _loc_01_878F
	JMP _loc_03_F0DB
bra_03_F0F3:
	JSR _IncreasePlayerRunningAnimation
	JSR _loc_03_E4A9
	JMP _loc_03_F0DB

_PlayerStateFollowEnemy:		;F0FC
	JSR _ClearPlayerAnimationCounterLow
_loc_03_F0FF:
	LDA game_mode_flags
	AND #F_OUT_OF_PLAY
	BEQ bra_03_F116
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _SetUnknownPlayerFlag
	LDA #$01
	JSR _loc_01_878F
	JMP _loc_03_F0FF
bra_03_F116:
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #$00
	LDY #plr_act_timer1
	STA (plr_data),Y
bra_03_F124:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _SetUnknownPlayerFlag
	JSR _IncreasePlayerRunningAnimation
	JSR _loc_03_E4A9
	LDA plr_cur_id
	CMP #$0B
	LDA #$00
	BCC bra_03_F13C
	LDA #$0B
bra_03_F13C:
	EOR team_w_ball		; от этого зависит побежит ли бот за мячом, если сбил своего же игрока с мячом
	BNE bra_03_F151
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
bra_03_F151:
	LDA plr_w_ball
	BMI bra_03_F178
	LDY #plr_act_timer1
	LDA (plr_data),Y
	CLC
	ADC #$01
	STA (plr_data),Y
	LSR
	BCC bra_03_F178
	LDA #$16
	LDX #$20
	JSR _ComparePlayerWithBallCoordinates1
	BCC bra_03_F124
	LDA random
	CMP #$E0
	BCC bra_03_F124
	JSR _ClearUnknownPlayerFlag
	JMP _DoTackle
bra_03_F178:
	LDA #$16
	LDX #$0C
	JSR _ComparePlayerWithBallCoordinates1
	BCC bra_03_F124
	LDA plr_w_ball
	BMI bra_03_F1AC
	LDX random
	CPX #$40
	BCC bra_03_F1CB
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_DEAD
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA plr_cur_id
	JSR _SelectInitialPlayerDataAddress_b03
bra_03_F1AC:
	LDA plr_cur_id
	JSR _loc_03_C6B9
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_WITH_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JMP SelectNextIndexForPlayers
bra_03_F1CB:
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_DEAD
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JMP SelectNextIndexForPlayers

_PlayerStateFreeze:		;F1E5
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _ClearPlayerAnimationCounterLow
_loc_03_F1F2:
bra_03_F1F2:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #FLAG_PL_UNKNOWN
	BNE bra_03_F1F2
	JSR _SetUnknownPlayerFlag
	LDA #$02
	LDX plr_cur_id
	BEQ bra_03_F20E
	CPX #$0B
	BEQ bra_03_F20E
	LDA #$01
bra_03_F20E:
; бряк сработал когда был забит гол верхней команде и камера уже успела слегка проскроллиться
	JSR _loc_01_878F
	JMP _loc_03_F1F2

_PlayerStateUnknown13:		;F214
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA #$01
	STA ball_anim_id
	JSR _SetUnknownPlayerFlag
	JSR _ClearPlayerAnimationCounterLow
	LDA random
	AND #$0F
	ADC #$16
	LDY #plr_act_timer1
	STA (plr_data),Y
bra_03_F234:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDA #$06
; бряк срабатывает когда поле уже отрисовано, но игроков еще не видно
; но игра уже успела прочитать таймер времени
	JSR _loc_01_878F
	LDX #$00
	LDA team_w_ball
	BEQ bra_03_F258
	INX
	BIT game_mode_flags
	BMI bra_03_F258
	LDY #plr_act_timer1
	LDA (plr_data),Y
	SEC
	SBC #$01
	STA (plr_data),Y
	BEQ bra_03_F25F
	BNE bra_03_F234
bra_03_F258:
	LDA #(BTN_A | BTN_B)
	AND btn_press,X
	BEQ bra_03_F234
bra_03_F25F:
	LDA #SOUND_WHISTLE
	JSR _WriteSoundID_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_WITH_BALL
	JSR _SelectPlayerSubroutine_b03
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	LDA plr_wo_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_WITHOUT_BALL
	JSR _SelectPlayerSubroutine_b03
	LDA plr_w_ball
	JSR _SelectInitialPlayerDataAddress_b03
	LDA #$80
	STA $042C
	LDA game_mode_flags
	AND #$DF
	STA game_mode_flags
	JMP SelectNextIndexForPlayers

_PlayerStateUnknown14:		;F2A4
_loc_03_F2A4:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _SetUnknownPlayerFlag
	LDY #plr_unknown_19
	LDA (plr_data),Y
	LDY #plr_act_timer1
	CMP (plr_data),Y
	BNE bra_03_F2C6
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
bra_03_F2C6:
	JSR _IncreasePlayerRunningAnimation
	JSR _loc_03_E4A9
	JMP _loc_03_F2A4

_PlayerStaterRunToBase:		;F2CF
	JMP _PlayerStaterRunToArea

_PlayerStateUnknown07:		; F2D2
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR CheckButtonsWhenShooting_03_DFBA
	LDA #SOUND_SHOOT
	JSR _WriteSoundID_b03
	JSR _ClearPlayerAnimationCounterLow
	LDA #$0B
; бряк сработал при удержании кнопки для удара в одно касание
	JSR _loc_01_878F
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _loc_03_F428
	LDA #$02
	JSR _SavePlayerSubroutine
	JSR _loc_03_DF5E
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0B
	JSR _loc_01_878F
	LDA #$30
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers

_PlayerStateUnknown08:		;F319
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR CheckButtonsWhenShooting_03_DFBA
	LDA #SOUND_SHOOT
	JSR _WriteSoundID_b03
	JSR _ClearPlayerAnimationCounterLow
	LDA #$0C
; бряк сработал при ударе в одно касание с характерным звуком
	JSR _loc_01_878F
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _loc_03_F428
	LDA #$02
	JSR _SavePlayerSubroutine
	JSR _loc_03_DF5E
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0C
	JSR _loc_01_878F
	LDA #$20
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0C
	JSR _loc_01_878F
	LDA #$18
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0C
	JSR _loc_01_878F
	LDA #$0C
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers

_PlayerStateUnknown09:		;F37A, скорее всего вообще не используется, и предыдущий JMP выглядит так же
	JMP SelectNextIndexForPlayers

_PlayerStateUnknown0A:		;F37D
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR CheckButtonsWhenShooting_03_DFBA
	LDA #SOUND_SHOOT_FAST
	JSR _WriteSoundID_b03
	LDY #plr_dir
	LDA ball_dir
	SEC
	SBC (plr_data),Y
	BCS bra_03_F39D
	EOR #$FF
	ADC #$01
bra_03_F39D:
	CMP #$40
	BCS bra_03_F3A4
	JMP _loc_03_F3D9
bra_03_F3A4:
	JSR _ClearPlayerAnimationCounterLow
	LDA #$0D
	JSR _loc_01_878F
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _loc_03_F428
	LDA #$02
	JSR _SavePlayerSubroutine
	JSR _loc_03_DF5E
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0D
	JSR _loc_01_878F
	LDA #$30
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers

_PlayerStateUnknown0B:		;F3D9, скорее всего вообще не используется
_loc_03_F3D9:				; а этот прыжок был использован
	JSR _ClearPlayerAnimationCounterLow
	LDA #$0E
	JSR _loc_01_878F
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0E
	JSR _loc_01_878F
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _loc_03_F428
	LDA #$02
	JSR _SavePlayerSubroutine
	JSR _loc_03_DF5E
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0E
	JSR _loc_01_878F
	LDA #$20
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0E
	JSR _loc_01_878F
	LDA #$18
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
_loc_03_F428:
	LDY #plr_dir
	LDA (plr_data),Y
	STA ball_dir
	LDA #$00
	STA $041D
	LDA #$04
	STA $041E
	LDA #$80
	STA $041B
	LDA #$00
	STA $041C
	LDA #$80
	STA plr_w_ball
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D6FA_minus1
	LDY #<_loc_03_D6FA_minus1
	JSR _SetSubReturnAddressForLater_b03
	RTS

_PlayerStateThrowIn:		;F45A
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _ClearPlayerAnimationCounterLow
	LDA plr_cur_id
	JSR _loc_03_C92B
	LDA team_w_ball
	BEQ bra_03_F486
	BIT game_mode_flags
	BMI bra_03_F486
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
	JSR _SetBotTimerThrowIn_b01
_loc_03_F486:
bra_03_F486:	; сюда есть прыжок снизу
	LDA #$01
	JSR _SavePlayerSubroutine
	LDA #$02
	JSR _BallRelativePosition
	LDA #$0F
	JSR _loc_01_878F
	LDA btn_hold
	LDX team_w_ball
	BEQ bra_03_F4A9
	LDA #$00
	BIT game_mode_flags
	BPL bra_03_F4A9
	LDA btn_hold + 1
	LDX #$01
bra_03_F4A9:
	STX $2B
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	STA $2A
	BEQ bra_03_F4DD
	LDX #$01
	LDY #plr_pos_x_hi
	LDA (plr_data),Y
	BEQ bra_03_F4BA
	INX
bra_03_F4BA:
	TXA
	AND $2A
	BNE bra_03_F4D1
	LDA $2A
	AND #$0C
	BEQ bra_03_F4DD
	LDA $2A
	AND #$FC
	STA $2A
	TXA
	ORA $2A
	STA $2A
bra_03_F4D1:
	LDA $2A
	AND #$0F
	TAX
	LDA Direction_table_03_E083,X
	LDY #plr_dir
	STA (plr_data),Y
bra_03_F4DD:
	LDA #(BTN_A | BTN_B)
	LDX $2B
	BEQ bra_03_F4F6
	BIT game_mode_flags
	BMI bra_03_F4F6
	LDY #plr_act_timer2
	LDA (plr_data),Y
	SEC
	SBC #$01
	STA (plr_data),Y
	BEQ bra_03_F4FB
	JMP _loc_03_F486
bra_03_F4F6:
	AND btn_press,X
	BEQ bra_03_F486
bra_03_F4FB:
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$0F
; бряк сработал когда CPU выбрасывал из аута
	JSR _loc_01_878F
	LDA #$03
	JSR _BallRelativePosition
	LDA #SOUND_THROW
	JSR _WriteSoundID_b03
	LDA #$00
	STA $041D
	LDA #$02
	STA $041E
	LDY #plr_dir
	LDA (plr_data),Y
	STA ball_dir
	LDA #$40
	STA $041B
	LDA #$00
	STA $041C
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D6FA_minus1
	LDY #<_loc_03_D6FA_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA #$80
	STA plr_w_ball
	LDA #$02
	JSR _SavePlayerSubroutine
	JSR _loc_03_DF5E
	LDA #$10
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	LDA #$80
	ORA $042C
	STA $042C
	JMP SelectNextIndexForPlayers

_PlayerStateGoalKick:
_PlayerStateGoalkeeperGetsBall:		;F563
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _ClearPlayerAnimationCounterLow
	LDY #plr_act_timer2
	LDA #$00
	STA (plr_data),Y
	STA gk_hold_ball_timer
	LDA #$00
	STA ball_z_lo
	LDA #$01
	STA ball_anim_id
	LDA plr_cur_id
	JSR _loc_03_C92B
	LDA plr_cur_id
	JSR _loc_03_C6B9
	JSR CalculatePlayerCurrentSpeed_03_E580
bra_03_F58F:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDY #plr_state
	LDA (plr_data),Y
	CMP #STATE_GOAL_KICK
	BNE @skip
	JSR CheckButtonsWhenShooting_03_DFBA
	LDA #$00
	JSR _BallRelativePosition
	JMP _loc_03_F5BB
@skip:
	INC gk_hold_ball_timer
	BEQ bra_03_F5E8
	LDA team_w_ball
	JSR _loc_03_E093
	BCC bra_03_F5BB
	LDA #$12
	JSR _loc_01_878F
	JMP _loc_03_F5C0
_loc_03_F5BB:
bra_03_F5BB:
	LDA #$10
; бряк сработал когда кипер полностью завладел мячом
	JSR _loc_01_878F
_loc_03_F5C0:
	LDA #$04
	JSR _BallRelativePosition
	JSR _loc_03_DCED
	LDX team_w_ball
	BEQ bra_03_F5E1
	LDX #$01
	BIT game_mode_flags
	BMI bra_03_F5E1
	LDY #plr_act_timer1
	LDA (plr_data),Y
	SEC
	SBC #$01
	STA (plr_data),Y
	BNE bra_03_F58F
	BEQ bra_03_F5F5
bra_03_F5E1:
	LDA #(BTN_A | BTN_B)	; проверка кнопок кипера для удара во время goal kick
	AND btn_press,X
	BEQ bra_03_F58F
bra_03_F5E8:
	LDA #$20
	STA $041B
	LDA #$01
	STA $041C
	JMP _loc_03_F600
bra_03_F5F5:
	LDA random
	AND #$07
	CLC
	ADC #$0E
	JSR _loc_03_EA7D
_loc_03_F600:
	JSR _ClearPlayerAnimationCounterLow
	LDA #$11
; бряк сработал когда кипер начинает выбивать мяч, но анимации еще нету
	JSR _loc_01_878F
	LDA #$05
	JSR _BallRelativePosition
	LDA #$08
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$11
; бряк сработал когда кипер уже почти ударил по мячу
	JSR _loc_01_878F
	LDA #$04
	JSR _SavePlayerSubroutine
	LDA #SOUND_SHOOT
	JSR _WriteSoundID_b03
	LDA #$00
	STA $041D
	LDA #$02
	STA $041E
	LDY #plr_dir
	LDA (plr_data),Y
	STA ball_dir
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D6FA_minus1
	LDY #<_loc_03_D6FA_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA #$80
	STA plr_w_ball
	LDA $042C
	AND #$BF
	STA $042C
	LDA #$02
	JSR _SavePlayerSubroutine
	JSR _loc_03_DF5E
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$11
; бряк сработал когда кипер уже ударил по мячу
	JSR _loc_01_878F
	LDA #$2E
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$11
; бряк сработал когда кипер закончил анимацию удара по мячу с вытянутой ногой
	JSR _loc_01_878F
	LDA #$10
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers

_PlayerStateCornerKick:		;F685
	LDY #plr_flags
	LDA (plr_data),Y
	ORA #F_CONTROL
	AND #F_BUSY_CLEAR
	STA (plr_data),Y
	JSR _ClearPlayerAnimationCounterLow
	LDA plr_cur_id
	JSR _loc_03_C92B
	LDA team_w_ball
	BEQ bra_03_F6AD
	BIT game_mode_flags
	BMI bra_03_F6AD
	LDY #plr_act_timer1
	LDA random		; вычисление таймера для бота, когда тот выбивает угловой
	AND #$1F
	CLC
	ADC #$08
	STA (plr_data),Y
_loc_03_F6AD:
bra_03_F6AD:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDA #$01
; бряк сработал после завершения таймера надписи corner kick
	JSR _loc_01_878F
	LDA btn_hold
	LDX team_w_ball
	BEQ bra_03_F6CC
	BIT game_mode_flags
	BMI bra_03_F6C7
	JMP _loc_03_F713
bra_03_F6C7:
	LDA btn_hold + 1
	LDX #$01
bra_03_F6CC:
	STX $2B
	STA $2A
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	BEQ bra_03_F70A
	LDX #$01
	LDA ball_pos_x_hi
	BEQ bra_03_F6DC
	INX
bra_03_F6DC:
	STX $2C
	LDY #$04
	LDA ball_pos_y_hi
	CMP #$02
	BCC bra_03_F6E9
	LDY #$08
bra_03_F6E9:
	TYA
	AND $2A
	BEQ bra_03_F6F6
	ORA $2C
	STA $2A
	JMP _loc_03_F6FF
bra_03_F6F6:
	LDA $2C
	AND $2A
	BEQ bra_03_F70A
	STA $2A
_loc_03_F6FF:
	LDA $2A
	AND #(BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT)
	TAX
	LDA Direction_table_03_E083,X
	JSR _loc_03_F79C
bra_03_F70A:
	LDX $2B
	BEQ bra_03_F720
	BIT game_mode_flags
	BMI bra_03_F720
_loc_03_F713:
	LDY #plr_act_timer1
	LDA (plr_data),Y
	SEC
	SBC #$01
	STA (plr_data),Y
	BNE bra_03_F6AD
	BEQ bra_03_F72A
bra_03_F720:
	LDA #(BTN_A | BTN_B)
	AND btn_press,X
	BNE bra_03_F72A
	JMP _loc_03_F6AD
bra_03_F72A:
	LDA #$05
; бряк сработал когда CPU собирался пробивать угловой
	JSR _loc_01_878F
	LDA #$08
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$05
; бряк сработал когда CPU замахнулся по мячу на угловом
	JSR _loc_01_878F
	LDA #$04
	JSR _SavePlayerSubroutine
	LDA #$E0
	STA $041D
	LDA #$01
	STA $041E
	LDA #$00
	STA $041B
	LDA #$01
	STA $041C
	LDY #plr_dir
	LDA (plr_data),Y
	STA ball_dir
	LDA #$80
	STA plr_w_ball
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D6FA_minus1
	LDY #<_loc_03_D6FA_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA #SOUND_SHOOT
	JSR _WriteSoundID_b03
	LDA #$02
	JSR _SavePlayerSubroutine
	JSR _loc_03_DF5E
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$05
; бряк сработал когда CPU ударил по мячу на угловом
	JSR _loc_01_878F
	LDA #$30
	JSR _SavePlayerSubroutine
	LDY #plr_flags
	LDA (plr_data),Y
	AND #F_CONTROL_CLEAR
	STA (plr_data),Y
	LDA #STATE_IDLE
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers
_loc_03_F79C:
	TAY
	CPY #$40
	BNE bra_03_F7A5
	LDA #$34
	BNE bra_03_F7AB
bra_03_F7A5:
	CPY #$C0
	BNE bra_03_F7B4
	LDA #$CC
bra_03_F7AB:
	LDY $2B
	BEQ bra_03_F7B4
	EOR #$FF
	CLC
	ADC #$81
bra_03_F7B4:
	LDY #plr_dir
	STA (plr_data),Y
	RTS

_PlayerStateUnknown17:		;F7B9
	JSR _ClearPlayerAnimationCounterLow
	LDA #$15
; бряк сработал перед свистком в пенальти перед ударом
	JSR _loc_01_878F
	LDA random
	AND #$0F
	CLC
	ADC #$18
	STA $8D
bra_03_F7CB:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDX team_w_ball
	BEQ bra_03_F7F5
	LDX #$01
	BIT game_mode_flags
	BMI bra_03_F7F5
	DEC $8D
	BNE bra_03_F7CB
	LDA #$00
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк срабатывает когда CPU готовится пробивать пенальти и уже стоит с мячом
	JSR _loc_01_8B24
	JMP _loc_03_F7FF
bra_03_F7F5:
	LDA #(BTN_A | BTN_B)
	AND btn_press,X
	BEQ bra_03_F7CB
	LDA btn_hold,X
_loc_03_F7FF:
	AND #(BTN_LEFT | BTN_RIGHT)
	LDY #plr_act_timer1
	STA (plr_data),Y
	TAX
	LDA table_03_F939,X
	STA $8D
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$15
	JSR _loc_01_878F
	LDA #$04
	JSR _SavePlayerSubroutine
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$15
	JSR _loc_01_878F
	LDA #$04
	JSR _SavePlayerSubroutine
	LDA #$80
	STA $8A
	LDA #SOUND_SHOOT
	JSR _WriteSoundID_b03
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$15
	JSR _loc_01_878F
	LDA #STATE_UNKNOWN_19
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers

_PlayerStateUnknown18:		;F83E
	JSR _ClearPlayerAnimationCounterLow
	LDA #$16
; бряк сработал перед свистком в пенальти перед ударом
	JSR _loc_01_878F
_loc_03_F846:
bra_03_F846:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDA $8A
	BPL bra_03_F846
	LDA team_w_ball
	EOR #$0B
	TAX
	BEQ bra_03_F878
	LDX #$01
	BIT game_mode_flags
	BMI bra_03_F878
	LDA #$06
	JSR _SavePlayerSubroutine
	LDA #$02
	PHA
	LDA #$02
	STA prg_bank
	LDA #$03
	STA prg_bank + 1
	JSR _BankswitchPRG
	PLA
; бряк сработал когда игрок в пенальти ударил по мячу и тот уже полетел
	JSR _loc_01_8B24
	JMP _loc_03_F888
bra_03_F878:
	LDA #(BTN_UP | BTN_LEFT | BTN_RIGHT)
	AND btn_press,X
	BNE bra_03_F885
	JSR _loc_03_F949
	JMP _loc_03_F846
bra_03_F885:
	LDA btn_hold,X
_loc_03_F888:
	AND #(BTN_UP | BTN_LEFT | BTN_RIGHT)
	TAX
	LDA table_03_F939,X
	LDY #plr_dir
	STA (plr_data),Y
	LDX #$00
	LDY #$00
	CMP #$80
	BEQ bra_03_F8A5
	LDX #$E0
	LDY #$03
	CMP #$40
	BEQ bra_03_F8A5
	JSR _EOR_16bit_b03
bra_03_F8A5:
	TYA
	LDY #plr_cur_spd_x_lo
	STA (plr_data),Y
	DEY
	DEY
	TXA
	STA (plr_data),Y	; plr_cur_spd_x_fr
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$16
; бряк сработал когда игрок в пенальти ударил по мячу и тот уже полетел
	JSR _loc_01_878F
	LDA #$EF
	STA $045E
	LDA #$87
	STA $0458
	LDA #$00
	STA $8B
	STA $8C
bra_03_F8C7:
	LDA #$01
	JSR _SavePlayerSubroutine
	LDY #plr_cur_spd_y_fr
	LDA $8B
	ASL
	TAX
	LDA table_03_F930,X
	STA (plr_data),Y
	INY
	INY
	LDA table_03_F930 + 1,X
	STA (plr_data),Y
	JSR _loc_03_E4A9
	JSR _loc_03_F949
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	STA $0452
	INC $8C
	LDX $8B
	LDA $8C
	CMP table_03_F936,X
	BNE bra_03_F8C7
	LDA #$00
	STA $8C
	INC $8B
	LDA $8B
	CMP #$03
	BNE bra_03_F8C7
	LDA #$00
	STA $045E
	LDY #plr_dir
	LDA (plr_data),Y
	CMP #$80
	BEQ bra_03_F915
	LDY #plr_pos_y_lo
	LDA #$87
	STA (plr_data),Y
bra_03_F915:
	JSR _IncreasePlayerAnimationCounterLow
	LDA #$16
; бряк срабатывает когда в пенальти кипер отбивает мяч либо он залетает в ворота
	JSR _loc_01_878F
	LDA #STATE_UNKNOWN_19
	JSR _SelectPlayerSubroutine_b03
	JMP SelectNextIndexForPlayers	
; F925 (код еще не выполннялся, но байты ниже читались)
_loc_03_F925:
	LDA #$01
	JSR _SavePlayerSubroutine
	JSR _loc_03_F949
	JMP _loc_03_F925

table_03_F930:		; читается после удара по мячу в пенальти
.byte $08,$FF
.byte $00,$00
.byte $F8,$00

table_03_F936:		; читается если кипер в пенальти прыгнул вбок или вверх
					; но не читается если он просто стоит на месте
.byte $0A,$02,$0A

table_03_F939:		; читается из 2х мест, что-то связано с проверкой кнопок движения
					; читается в пенальти при ударе в F806
.byte $80,$40,$C0,$80,$80,$40,$C0,$80,$80,$40,$C0,$80,$80,$40,$C0,$80

_loc_03_F949:
	BIT $8A
	BVS bra_03_F984
	LDA ball_z_lo
	BEQ bra_03_F984
	CMP #$06
	BCS bra_03_F984
	LDA #$16
	LDX #$0D
	JSR _ComparePlayerWithBallCoordinates2
	BCC bra_03_F984
	LDY #plr_dir
	LDA (plr_data),Y
	CMP #$80
	BNE bra_03_F96D
	LDA #$F0
	LDY #plr_anim_id
	STA (plr_data),Y
bra_03_F96D:
	LDX #$09
	LDA #$5A
	STA $01,X
	LDA #$0C
	STA $02,X
	LDA #>_loc_03_D680_minus1
	LDY #<_loc_03_D680_minus1
	JSR _SetSubReturnAddressForLater_b03
	LDA $8A
	ORA #$40
	STA $8A
bra_03_F984:
	RTS

_PlayerStateUnknown19:		;F985
_loc_03_F985:
	LDA #$01
	JSR _SavePlayerSubroutine
	JMP _loc_03_F985
_loc_03_F98D:
	LDX $03CE
	CPX #$03
	BCS bra_03_F9A4
	STA $03CF,X
	INC $03CE
	BIT $03D2
	BMI bra_03_F9A4
	LDA #$80
	STA $03D2
bra_03_F9A4:
	RTS

.export _loc_03_F9A5
_loc_03_F9A5:		; увеличить индекс для следующего спрайта
	INX
	BNE @still_have_some_sprites_left
	LDX spr_cnt_index_copy
@still_have_some_sprites_left:
	STX spr_cnt_index
	DEC spr_limit
	BNE @rts
	LDA #$80			; код еще не выполнялся
	STA spr_cnt_ovf		; код еще не выполнялся
@rts:
	RTS

_WriteAndSkipMessageOnScreen:		; F9B8
; попытка досрочно прервать надпись про мяч вне игры
; если надпись нельзя прерывать кнопками, код прыгает напрямую на F9DA
	JSR _WriteMessageOnScreenWithSprites
	LDA #$70		; базовая длительность кадров сообщения
@wait:
	PHA
	LDA #$01
	JSR _FrameDelay_b03
	LDA #(BTN_A | BTN_B)	; попытка прервать надпись кнопками
	AND btn_press
	BNE @button_was_pressed
	LDA #(BTN_A | BTN_B)
	AND btn_press + 1
	BNE @button_was_pressed
	PLA
	SEC
	SBC #$01
	BNE @wait
	PHA
@button_was_pressed:
	PLA
	RTS

_WriteMessageOnScreenWithSprites:		; F9DA
.scope
table 	= $2A
counter = $2C
x_pos 	= $2D
y_pos 	= $2E
; unknown = $6C
	LDX #$08
	STX $6C
	ASL
	TAX
	LDA SpriteTextMessage_table,X
	STA table
	LDA SpriteTextMessage_table + 1,X
	STA table + 1
	LDX #$00
	LDY #$00
@read_table_loop:
	LDA (table),Y
	BEQ @table_ended
	STA counter
	INY
	LDA (table),Y
	STA x_pos
	INY
	LDA (table),Y
	STA y_pos
	INY
@set_sprites:
	LDA y_pos
	STA oam_y,X
	LDA #$01
	STA oam_a,X
	LDA x_pos
	STA oam_x,X
	CLC
	ADC #$08
	STA x_pos
	LDA (table),Y
	CMP #$20
	BEQ @skip
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
@skip:
	INY
	DEC counter
	BNE @set_sprites
	BEQ @read_table_loop
@table_ended:
	LDA #$F8
@hide_sprites_loop:
	STA oam_y,X
	INX
	BNE @hide_sprites_loop
	RTS
.endscope

_ComparePlayerWithBallCoordinates1:		; FA43
	CMP #$16
	BNE @continue
	LDY ball_z_hi
	BNE @clc
	LDY ball_z_lo
	CPY #$18
	BCS @clc
	LDY plr_w_ball		; проверка на киперов
	BMI @continue
	BEQ @clc
	CPY #$0B
	BNE @continue
@clc:
	CLC
	RTS

@continue:
_ComparePlayerWithBallCoordinates2:		; FA60
; сюда 3 JSR, на вход всегда подается A = 16 для чтения мяча из таблицы
; X бывает 09 0D 14, это размер хитбокса
; на выходе будет C = 0 если касания нету, или C = 1 если касание есть
.scope
hitbox = $72
	STX hitbox
	ASL
	TAX
	LDA BasePlayerDataAddress_table,X
	STA ball_data
	LDA BasePlayerDataAddress_table + 1,X
	STA ball_data + 1
	SEC
	LDY #plr_pos_x_lo
	LDA (plr_data),Y
	SBC (ball_data),Y	; ball_pos_x_lo
	TAX
	INY
	INY
	LDA (plr_data),Y	; plr_pos_x_hi
	SBC (ball_data),Y	; ball_pos_x_hi
	TAY
	BPL @skip
	JSR _EOR_16bit_b03
@skip:
	TYA
	BNE @no_hit
	CPX hitbox
	BCS @no_hit
	SEC
	LDY #plr_pos_y_lo
	LDA (plr_data),Y
	SBC (ball_data),Y	; ball_pos_y_lo
	TAX
	INY
	INY
	LDA (plr_data),Y	; plr_pos_y_hi
	SBC (ball_data),Y	; ball_pos_y_hi
	TAY
	BPL @skip2
	JSR _EOR_16bit_b03
@skip2:
	TYA
	BNE @no_hit
	CPX hitbox
	BCS @no_hit
	SEC
	RTS
@no_hit:
	CLC
	RTS
.endscope

ScreenPalette_table:		; FAA8 палитра экранов
							; палитра экрана с логотипом теряется на первых кадрах запуска игры
								; она обрабатывается отдельно в банке 02 в 8AC9
; экран с логотипом (фон)
.byte $0F,$1A,$30
.byte $0F,$25,$36
.byte $0F,$21,$36
.byte $16,$26,$36

; экран с логотипом (спрайты)
.byte $30,$16,$35
.byte $0F,$0F,$30
.byte $2B,$11,$26
.byte $28,$0F,$30

; черная палитра для затемнения экрана (фон)
.byte $0F,$0F,$0F
.byte $0F,$0F,$0F
.byte $0F,$0F,$0F
.byte $0F,$0F,$0F

; экран с выбором команд (спрайты)
.byte $15,$00,$30
.byte $21,$0F,$30
.byte $0F,$0F,$30
.byte $0F,$00,$10

; экран с зайцем перед игрой против CPU и финальный экран (спрайты)
.byte $07,$17,$27
.byte $30,$27,$37
.byte $10,$0F,$0F
.byte $17,$27,$37

; экран с выбором команд (фон)
; экран с зайцем перед игрой против CPU и финальный экран (фон)
.byte $1A,$25,$30
.byte $30,$00,$30
.byte $21,$31,$30
.byte $21,$00,$30

; экран с командой после победы против CPU (фон)
.byte $15,$05,$30
.byte $07,$17,$37
.byte $0F,$0F,$0F
.byte $0F,$0F,$0F

; экран со счетом после тайма (фон)
.byte $1A,$00,$30
.byte $15,$05,$30
.byte $21,$31,$30
.byte $21,$10,$30

; экран со счетом после тайма (спрайты)
.byte $15,$31,$30
.byte $21,$0F,$30
.byte $0F,$0F,$30
.byte $0F,$00,$30

; палитра в пенальти (фон)
.byte $0A,$1A,$30
.byte $10,$16,$30
.byte $25,$21,$35
.byte $27,$21,$26

; переливание кубка зайца 1 (спрайты)
.byte $07,$17,$37
.byte $30,$27,$30
.byte $10,$0F,$0F
.byte $17,$37,$37

; переливание кубка зайца 2 (спрайты)
.byte $07,$27,$30
.byte $30,$30,$30
.byte $10,$0F,$0F
.byte $37,$30,$30

; переливание кубка зайца 3 (спрайты)
.byte $07,$17,$30
.byte $30,$27,$30
.byte $10,$0F,$0F
.byte $27,$27,$37

; перекрашивание зайца из кубка в талисман 1 (спрайты)
.byte $0F,$07,$27
.byte $20,$17,$27
.byte $0F,$0F,$0F
.byte $07,$17,$27

; перекрашивание зайца из кубка в талисман 2 (спрайты)
.byte $0F,$0F,$17
.byte $10,$07,$17
.byte $0F,$0F,$0F
.byte $0F,$07,$17

; перекрашивание зайца из кубка в талисман 3 (спрайты)
.byte $0F,$0F,$07
.byte $0F,$0F,$07
.byte $0F,$0F,$0F
.byte $0F,$0F,$07

; перекрашивание зайца из кубка в талисман 4 (спрайты)
.byte $05,$16,$15
.byte $30,$27,$37
.byte $10,$0F,$0F
.byte $0F,$0F,$0F

SpriteTextMessage_table:		; FB74
.word Message_kick_off			; 00
.word Message_time_up			; 01
.word Message_throw_in			; 02
.word Message_goal_kick			; 03
.word Message_corner_kick		; 04
.word Message_pause				; 05

; первый байт строки - количество символов для считывания
; второй/третий байты - X/Y спрайта
; 00 - завершить чтение
Message_kick_off:
.byte $08,$60,$50
.byte $4B,$49,$43,$4B,$20,$4F,$46,$46			; kick off
.byte $00
Message_time_up:
.byte $07,$64,$50
.byte $54,$49,$4D,$45,$20,$55,$50				; time up
.byte $00
Message_throw_in:
.byte $06,$68,$50
.byte $4F,$55,$54,$20,$4F,$46					; out of
.byte $04,$70,$60
.byte $50,$4C,$41,$59							; play
.byte $08,$60,$80
.byte $54,$48,$52,$4F,$57,$20,$49,$4E			; throw in
.byte $00
Message_goal_kick:
.byte $06,$68,$50
.byte $4F,$55,$54,$20,$4F,$46					; out of
.byte $04,$70,$60
.byte $50,$4C,$41,$59							; play
.byte $09,$58,$80
.byte $47,$4F,$41,$4C,$20,$4B,$49,$43,$4B		; goal kick
.byte $00
Message_corner_kick:
.byte $06,$68,$50
.byte $4F,$55,$54,$20,$4F,$46					; out of
.byte $04,$70,$60
.byte $50,$4C,$41,$59							; play
.byte $06,$68,$80
.byte $43,$4F,$52,$4E,$45,$52					; corner
.byte $04,$70,$90
.byte $4B,$49,$43,$4B							; kick
.byte $00
Message_pause:
.byte $05,$6C,$50
.byte $50,$41,$55,$53,$45						; pause
.byte $00

table_03_FBFA:		; угол движения ботов
					; читается из 2х мест
.byte $06,$00
.byte $0D,$00
.byte $13,$00
.byte $19,$00
.byte $20,$00
.byte $26,$00
.byte $2C,$00
.byte $33,$00
.byte $39,$00
.byte $40,$00
.byte $47,$00
.byte $4E,$00
.byte $55,$00
.byte $5C,$00
.byte $63,$00
.byte $6A,$00
.byte $71,$00
.byte $79,$00
.byte $81,$00
.byte $89,$00
.byte $91,$00
.byte $99,$00
.byte $A2,$00
.byte $AB,$00
.byte $B4,$00
.byte $BE,$00
.byte $C8,$00
.byte $D2,$00
.byte $DD,$00
.byte $E8,$00
.byte $F4,$00
.byte $00,$01
.byte $0D,$01
.byte $1A,$01
.byte $29,$01
.byte $38,$01
.byte $48,$01
.byte $59,$01
.byte $6B,$01
.byte $7F,$01
.byte $94,$01
.byte $AB,$01
.byte $C4,$01
.byte $DF,$01
.byte $FD,$01
.byte $1D,$02
.byte $42,$02
.byte $6A,$02
.byte $98,$02
.byte $DB,$02
.byte $07,$03
.byte $4C,$03
.byte $9D,$03
.byte $FE,$03
.byte $74,$04
.byte $07,$05
.byte $C3,$05
.byte $BE,$06
.byte $1B,$08
.byte $27,$0A
.byte $8F,$0D
.byte $5B,$20
.byte $BC,$40
.byte $FF,$FF	; эти 2 FF были считаны

.segment "VECTORS"
.word _NMI_VECTOR
.word _RESET_VECTOR
.word $FFD0		; IRQ/BRK вектор, не используется