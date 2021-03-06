byte_for_2000_nmi = $21					; хранение бита7 для регистра 2000 (00 или 80)

btn_hold = $24			 				; удержанные кнопки
; $25
btn_press = $26							; одноразовые кнопки
; $27

; temp = $2A

byte_for_2000 = $28						; хранение байта для регистра 2000
byte_for_2001 = $29						; хранение байта для регистра 2001

; $3C, $3D, $3E - для indirect, 2 раза $3C + $3D, 1 раз $3D + $3E

my_temp = $3F							; 2 адреса, использовались раньше только в _ReadBytes_0380_AfterJSR_b03 CB18 для indirect
; $40

spr_cnt_index = $5B						; порядковый номер текущего спрайта
spr_limit = $5C							; лимит счетчика спрайтов
spr_cnt_ovf = $5D 						; флаг overflow счетчика спрайтов, 80 если лимит исчерпан, иначе 00
; 5E - что-то для спрайтов
; 5F - что-то для спрайтов
spr_cnt_index_copy = $60				; временная копия spr_cnt_index

plr_data = $61							; младший и старший байты начального адреса параметров игрока и мяча
; $62

; $65									; бывший byte_00_for_8000, в нем всегда 00
											; используется для ORA с номером банка для 8000, результат хранится $66
byte_for_8000 = $66						; номер банка для 8000, для безопасных переключений банков
prg_bank = $67							; номер банка prg для 8001
; $68
chr_bank = $69							; номер банка chr для 8001
; $6A, $6B, $6C, $6D, $6E

plr_cur_id = $6F						; номер игрока, с которым игра работает в данный момент
											; меняется на протяжении кадра от 00 до 16, в отличие от $042B
ball_data = $70							; младший и старший байты начального адреса параметров мяча
; $71

team_atk = $7C							; агрессия команды, влияет на шанс бота сагриться на игрока с мячом
; $7D
team_def = $7E							; защита команды
; $7F

bot_behav = $86							; поведение бота с мячом
											; 00 - бежать с мячом в сторону ворот, 80 - удар по воротам, 81 - пас напарнику
bot_mate = $87							; номер напарника бота, которому бот будет давать пас

team_behav = $88						; что-то связанное с поведением команды в зависимости от зоны на поле
; $89

goals_pk = $8F							; голы в пенальти
; $90

frame_cnt = $93							; счетчик кадров

psw_char_cnt = $94						; счетчик букв на экране с паролем
psw_hold_btn_timer = $95				; таймер удержания кнопки влево/вправо для переключения на другую букву
psw_char_blink_timer = $96				; таймер между отображением/скрытием выделенной буквы на экране с паролем
psw_char_blink_state = $97				; состояние выделенной буквы, четные - отображенить, нечетные - скрыть

gk_has_ball = $98						; используется при анимации касания мяча и кипера при ловле и отбивании
											; 00 - завладел мячом, 80 - не завладел мячом
gk_hold_ball_timer = $99				; таймер удержания мяча кипером

oam_mem = $0800
oam_y = oam_mem + $000					; Y координата спрайта
oam_t = oam_mem + $100					; тайл спрайта
oam_a = oam_mem + $200					; палитра и поворот спрайта
oam_x = oam_mem + $300					; X координата спрайта

bg_or_pal_write_flag = $0300			; 00 если требуется считать буфер как фон, 01 если как палитру

nmt_buffer = $030D						; 3 управляющих байта + байты с палитрой
										; управляющих может быть несколько внути буффера
nmt_buf_cnt		= nmt_buffer			; $030D счетчик количества чтения nmt_buffer
nmt_buf_ppu_lo	= nmt_buffer + 1		; $030E второй байт для 2006
nmt_buf_ppu_hi	= nmt_buffer + 2		; $030F первый байт для 2006
; $0310, $0311, $0312, $0313, $0314, $0315, $0316, $0317, $0318, $0319, $031A, $031B, $031C, $031D, $031E, $031F
; $0320, $0321, $0322, $0323, $0324, $0325, $0326, $0327, $0328, $0329, $032A, $032B, $032C, $032D, $032E, $032F
; $0330, $0331, $0332, $0333, $0334, $0335, $0336, $0337, $0338, $0339, $033A, $033B, $033C, $033D, $033E, $033F
; $0340, $0341, $0342, $0343, $0344, $0345, $0346, $0347, $0348, $0349, $034A, $034B, $034C, $034D, $034E, $034F

field_buf_ppu_lo = $03C5				; корректирующий байт для nmt_buf_ppu_lo
field_buf_ppu_hi = $03C6				; корректирующий байт для nmt_buf_ppu_hi
field_buf_cnt = $03C7					; счетчик количества участков адресов с тайлами поля в nmt_buffer

; $037D - что-то связанное с отрисовкой фона

random = $037E							; результат рандома
; $037F

pal_buffer = $0380						; 3 управляющих байта + 32 байта с палитрой
pal_buf_cnt		= pal_buffer				; $0380 счетчик количества чтения pal_buffer
pal_buf_ppu_lo	= pal_buffer + 1			; $0381 второй байт для 2006
pal_buf_ppu_hi	= pal_buffer + 2			; $0382 первый байт для 2006
; $0383, $0384, $0385, $0386, $0387, $0388, $0389, $038A, $038B, $038C, $038D, $038E, $038F, $0390, $0391, $0392
; $0393, $0394, $0395, $0396, $0397, $0398, $0399, $039A, $039B, $039C, $039D, $039E, $039F, $03A0, $03A1, $03A2

; $03A3 - возможно свободный

game_mode_flags = $03A4					; флаги игрового состояния, смотреть описание байтов в val.inc

goals_half = $03A5						; голы первого тайма
; $03A6
goals_total = $03A7						; общие голы за 2 тайма
; $03A8
team_id = $03A9							; номер команды
; $03AA
team_ban = $03AB						; выделение исключаемых команд крестиками, для левого и правого столбика
; $03AC

team_w_ball = $03AD						; чья команда владеет мячом, 00 или 0B
half_time_cnt = $03AE					; номер тайма
timer_opt = $03AF
timer_ms = $03B0						; терции времени
timer_sec = $03B1						; секунды времени
timer_min = $03B2						; минуты времени

game_cnt = $03B3						; номер команды в режиме против CPU

team_sel_hold_btn_timer = $03B4			; таймер удержания кнопки движения на экране выбора команд
; $03B5

cam_edge_x_lo = $03B7					; дистанция камеры от левого до правого края экрана
cam_edge_x_hi = $03B8					; 16бит 0000 до 0100

cam_edge_y_lo = $03BC					; дистанция камеры от верхнего до нижнего края экрана
cam_edge_y_hi = $03BD					; 16бит от FFFF до 0310, без учета сдвига камеры после гола - от 0040 до 02D0

flag_anim_cnt = $03BA					; номер анимации флагов на экране выбора команд

soccer_text_color_cnt = $03D3			; счетчик цветов надписи soccer на экране с логотипом
											; у этого адреса иная функция на поле, вроде связанная с мячом

game_mode_opt = $03D4					; опция режима игры

; $03D5 ???
; $03D7 ???

psw_char_sum_id = $03D5				; сумма двух букв пароля
	; $03D6, $03D7, $03D8, $03D9
ball_pos_x_lo = $03D8					; позиция мяча
ball_pos_x_hi = $03DA
	psw_char_id = $03DA					; номер буквы при ручном вводе пароля
	; $03DB, $03DC, $03DD, $03DE, $03DF, $03E0, $03E1, $03DE2

; $03DB ???
; $03DD ???

ball_pos_y_lo = $03DE
ball_pos_y_hi = $03E0
ball_push_anim_id = $03E2				; номер анимации толкания мяча игроком перед собой
ball_anim_id = $03E4					; номер анимации графики мяча
ball_dir = $03E6						; направление мяча

shad_pos_x_lo = $03F8					; позиция тени мяча
shad_pos_x_hi = $03FA
shad_pos_y_lo = $03FE
shad_pos_y_hi = $0400

ball_land_pos_x_lo = $0413				; позиция приземления мяча, к которой бегут боты из обоих команд
ball_land_pos_x_hi = $0414
ball_land_pos_y_lo = $0415
ball_land_pos_y_hi = $0416

ball_pass_pos_y_lo = $0417				; копия позиции напарника, которому бот дает пас
ball_pass_pos_y_hi = $0418
ball_pass_pos_x_lo = $0419
ball_pass_pos_x_hi = $041A

ball_z_lo = $0424						; высота мяча
ball_z_hi = $0426

area_id = $0427							; какой-то номер зоны на поле, от 00 до 27

plr_w_ball = $0429						; номер игрока с мячом, 80 - мячом никто не владеет
plr_wo_ball = $042A						; номер игрока без мяча
plr_frame_id = $042B					; номер игрока, с которым игра работает на текущем кадре,
											; увеличивается на 01 ежекадрово, в отличие от $6F

; что-то связанное с 0427 = $042C

; параметры игроков
plr_flags = $00				; флаги состояния игрока, смотреть описание байтов в val.inc, последние 4 бита не используются
; 042D, 044D, 046D, 048D, 04AD, 04CD, 04ED, 050D, 052D, 054D, 056D
; 058D, 05AD, 05CD, 05ED, 060D, 062D, 064D, 066D, 068D, 06AD, 06CD

plr_spr_a = $01				; атрибут спрайта игрока
; 042E, 044E, 046E, 048E, 04AE, 04CE, 04EE, 050E, 052E, 054E, 056E
; 058E, 05AE, 05CE, 05EE, 060E, 062E, 064E, 066E, 068E, 06AE, 06CE

plr_cur_spd_x_fr = $02		; текущая скорость игрока во время движения
; 042F, 044F, 046F, 048F, 04AF, 04CF, 04EF, 050F, 052F, 054F, 056F
; 058F, 05AF, 05CF, 05EF, 060F, 062F, 064F, 066F, 068F, 06AF, 06CF

plr_pos_x_fr = $03			; координата игрока
; 0430, 0450, 0470, 0490, 04B0, 04D0, 04F0, 0510, 0530, 0550, 0570
; 0590, 05B0, 05D0, 05F0, 0610, 0630, 0650, 0670, 0690, 06B0, 06D0

plr_cur_spd_x_lo = $04		; текущая скорость игрока во время движения
; 0431, 0451, 0471, 0491, 04B1, 04D1, 04F1, 0511, 0531, 0551, 0571
; 0591, 05B1, 05D1, 05F1, 0611, 0631, 0651, 0671, 0691, 06B1, 06D1

plr_pos_x_lo = $05			; координата игрока
; 0432, 0452, 0472, 0492, 04B2, 04D2, 04F2, 0512, 0532, 0552, 0572
; 0592, 05B2, 05D2, 05F2, 0612, 0632, 0652, 0672, 0692, 06B2, 06D2

plr_act_timer1 = $06		; таймер ботов для авто выбивания мяча из углового и goal kick
							; длительность подката, может еще что-то
; 0433, 0453, 0473, 0493, 04B3, 04D3, 04F3, 0513, 0533, 0553, 0573
; 0593, 05B3, 05D3, 05F3, 0613, 0633, 0653, 0673, 0693, 06B3, 06D3

plr_pos_x_hi = $07			; координата игрока
; 0434, 0454, 0474, 0494, 04B4, 04D4, 04F4, 0514, 0534, 0554, 0574
; 0594, 05B4, 05D4, 05F4, 0614, 0634, 0654, 0674, 0694, 06B4, 06D4

plr_cur_spd_y_fr = $08		; текущая скорость игрока во время движения
; 0435, 0455, 0475, 0495, 04B5, 04D5, 04F5, 0515, 0535, 0555, 0575
; 0595, 05B5, 05D5, 05F5, 0615, 0635, 0655, 0675, 0695, 06B5, 06D5

plr_pos_y_fr = $09			; координата игрока
; 0436, 0456, 0476, 0496, 04B6, 04D6, 04F6, 0516, 0536, 0556, 0576
; 0596, 05B6, 05D6, 05F6, 0616, 0636, 0656, 0676, 0696, 06B6, 06D6

plr_cur_spd_y_lo = $0A		; текущая скорость игрока во время движения
; 0437, 0457, 0477, 0497, 04B7, 04D7, 04F7, 0517, 0537, 0557, 0577
; 0597, 05B7, 05D7, 05F7, 0617, 0637, 0657, 0677, 0697, 06B7, 06D7

plr_pos_y_lo = $0B			; координата игрока
; 0438, 0458, 0478, 0498, 04B8, 04D8, 04F8, 0518, 0538, 0558, 0578
; 0598, 05B8, 05D8, 05F8, 0618, 0638, 0658, 0678, 0698, 06B8, 06D8

plr_act_timer2 = $0C		; таймер ботов для авто выбивания мяча из аута, может еще что-то
; 0439, 0459, 0479, 0499, 04B9, 04D9, 04F9, 0519, 0539, 0559, 0579
; 0599, 05B9, 05D9, 05F9, 0619, 0639, 0659, 0679, 0699, 06B9, 06D9

plr_pos_y_hi = $0D			; координата игрока
; 043A, 045A, 047A, 049A, 04BA, 04DA, 04FA, 051A, 053A, 055A, 057A
; 059A, 05BA, 05DA, 05FA, 061A, 063A, 065A, 067A, 069A, 06BA, 06DA

plr_unknown_0E = $0E		; хз, записывается лишь в одном месте (вроде бы) и потом обнуляется
; 043B, 045B, 047B, 049B, 04BB, 04DB, 04FB, 051B, 053B, 055B, 057B
; 059B, 05BB, 05DB, 05FB, 061B, 063B, 065B, 067B, 069B, 06BB, 06DB

plr_anim_cnt_lo = $0F		; порядковый номер анимации
; 043C, 045C, 047C, 049C, 04BC, 04DC, 04FC, 051C, 053C, 055C, 057C
; 059C, 05BC, 05DC, 05FC, 061C, 063C, 065C, 067C, 069C, 06BC, 06DC

plr_anim_cnt_fr = $10
; 043D, 045D, 047D, 049D, 04BD, 04DD, 04FD, 051D, 053D, 055D, 057D
; 059D, 05BD, 05DD, 05FD, 061D, 063D, 065D, 067D, 069D, 06BD, 06DD

plr_anim_id = $11			; номер анимации, из которого выбираются спрайты
; 043E, 045E, 047E, 049E, 04BE, 04DE, 04FE, 051E, 053E, 055E, 057E
; 059E, 05BE, 05DE, 05FE, 061E, 063E, 065E, 067E, 069E, 06BE, 06DE

plr_state = $12				; номер текущего поведения игрока, смотреть описание байтов в val.inc
; 043F, 045F, 047F, 049F, 04BF, 04DF, 04FF, 051F, 053F, 055F, 057F
; 059F, 05BF, 05DF, 05FF, 061F, 063F, 065F, 067F, 069F, 06BF, 06DF

plr_dir = $13				; направление движения игрока
; 0440, 0460, 0480, 04A0, 04C0, 04E0, 0500, 0520, 0540, 0560, 0580
; 05A0, 05C0, 05E0, 0600, 0620, 0640, 0660, 0680, 06A0, 06C0, 06E0

plr_init_spd_fr = $14		; базовая скорость игрока
; 0441, 0461, 0481, 04A1, 04C1, 04E1, 0501, 0521, 0541, 0561, 0581
; 05A1, 05C1, 05E1, 0601, 0621, 0641, 0661, 0681, 06A1, 06C1, 06E1

plr_init_spd_lo = $15		; базовая скорость игрока
; 0442, 0462, 0482, 04A2, 04C2, 04E2, 0502, 0522, 0542, 0562, 0582
; 05A2, 05C2, 05E2, 0602, 0622, 0642, 0662, 0682, 06A2, 06C2, 06E2

plr_sub_hi = $16			; старший байт подпрограммы поведения игрока
; 0443, 0463, 0483, 04A3, 04C3, 04E3, 0503, 0523, 0543, 0563, 0583
; 05A3, 05C3, 05E3, 0603, 0623, 0643, 0663, 0683, 06A3, 06C3, 06E3

plr_sub_lo = $17			; младший байт подпрограммы поведения игрока
; 0444, 0464, 0484, 04A4, 04C4, 04E4, 0504, 0524, 0544, 0564, 0584
; 05A4, 05C4, 05E4, 0604, 0624, 0644, 0664, 0684, 06A4, 06C4, 06E4

plr_sub1_timer = $18		; таймер продолжительности текущего действия
							; пока таймер не 00, выполняется sub1
; 0445, 0465, 0485, 04A5, 04C5, 04E5, 0505, 0525, 0545, 0565, 0585
; 05A5, 05C5, 05E5, 0605, 0625, 0645, 0665, 0685, 06A5, 06C5, 06E5

plr_unknown_19 = $19		; хз, сравнивается с plr_act_timer1
; 0446, 0466, 0486, 04A6, 04C6, 04E6, 0506, 0526, 0546, 0566, 0586
; 05A6, 05C6, 05E6, 0606, 0626, 0646, 0666, 0686, 06A6, 06C6, 06E6

plr_aim_x_lo = $1A			; копия ball_pos_x_lo
; 0447, 0467, 0487, 04A7, 04C7, 04E7, 0507, 0527, 0547, 0567, 0587
; 05A7, 05C7, 05E7, 0607, 0627, 0647, 0667, 0687, 06A7, 06C7, 06E7

plr_aim_x_hi = $1B			; копия ball_pos_x_hi
; 0448, 0468, 0488, 04A8, 04C8, 04E8, 0508, 0528, 0548, 0568, 0588
; 05A8, 05C8, 05E8, 0608, 0628, 0648, 0668, 0688, 06A8, 06C8, 06E8

plr_aim_y_lo = $1C			; копия ball_pos_y_lo
; 0449, 0469, 0489, 04A9, 04C9, 04E9, 0509, 0529, 0549, 0569, 0589
; 05A9, 05C9, 05E9, 0609, 0629, 0649, 0669, 0689, 06A9, 06C9, 06E9

plr_aim_y_hi = $1D			; копия ball_pos_y_hi
; 044A, 046A, 048A, 04AA, 04CA, 04EA, 050A, 052A, 054A, 056A, 058A
; 05AA, 05CA, 05EA, 060A, 062A, 064A, 066A, 068A, 06AA, 06CA, 06EA

plr_tbl_lo = $1E			; младший байт некой таблицы поведения игрока
; 044B, 046B, 048B, 04AB, 04CB, 04EB, 050B, 052B, 054B, 056B, 058B
; 05AB, 05CB, 05EB, 060B, 062B, 064B, 066B, 068B, 06AB, 06CB, 06EB

plr_tbl_hi = $1F			; старший байт некой таблицы поведения игрока
; 044C, 046C, 048C, 04AC, 04CC, 04EC, 050C, 052C, 054C, 056C, 058C
; 05AC, 05CC, 05EC, 060C, 062C, 064C, 066C, 068C, 06AC, 06CC, 06EC

sound_cnt = $0700			; счетчик очереди звуков
sound_queue = $0701			; номер звука в очереди, смотреть описание байтов в val.inc
; $0702, $0703, $0704

; $2000
; $2001
; $2002
; $2003
; $2004
; $2005
; $2006
; $2007

; $4000
; $4001
; $4002
; $4003
; $4004
; $4005
; $4006
; $4007
; $4008
; $4009
; $400A
; $400B
; $400C
; $400D
; $400E
; $400F
; $4010
; $4011
; $4012
; $4013
; $4014
; $4015

; $4016
; $4017

