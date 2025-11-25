BasicUpstart2(init)
	*= $c000 "init"

// ======================================================================================
// CONSTANTS
// ======================================================================================

	.const BORDER_COLOR_ADDR		= $d020
	.const BG_COLOR_ADDR			= $d021
	.const CHAR_HORIZONTAL_BOTTOM		= $6f
	.const CHAR_HORIZONTAL_TOP		= $77
	.const CHAR_PERIOD			= $2e
	.const CHAR_SPACE 			= $20
	.const CHAR_VERTICAL_LEFT		= $65
	.const CHAR_VERTICAL_RIGHT		= $67
	.const RASTER_LINE_ADDR			= $d012
	.const SCREEN_TOP_LEFT_ADDR 		= $0400
	.const SCREEN_BOTTOM_LEFT_ADDR		= $07c0
	.const SCREEN_TOP_LEFT_COLOR_ADDR	= $d800

	.const PIECE_I 	= $00
	.const PIECE_O 	= $01
	.const PIECE_T 	= $02
	.const PIECE_L 	= $03
	.const PIECE_J 	= $04
	.const PIECE_S 	= $05
	.const PIECE_Z 	= $06

	.const zp_temp1	= $fb
	.const zp_temp2	= $fd

// ======================================================================================
// VARIABLES
// ======================================================================================

	current_color:		.byte $00
	current_piece:		.byte $00
	current_rotation:	.byte $00
	current_x:		.byte $00
	current_y:		.byte $00

	next_piece:		.byte $00
	next_rotation:		.byte $00

	board:			.fill 200, ($00)
	piece_buffer:		.fill 4, ($00)
	random_seed:		.byte $00

// ======================================================================================
// MAIN PROGRAM
// ======================================================================================

init:
	jsr empty_screen
	jsr draw_board

main_loop:
	jsr wait
	jsr draw_current_piece
	jmp main_loop

// ======================================================================================
// INIT SUBROUTINES
// ======================================================================================

empty_screen:
	ldx #$fa				// 250 byte chunks
!:
	lda #CHAR_SPACE				// fill screen char ram with spaces
	sta SCREEN_TOP_LEFT_ADDR-1, x
	sta SCREEN_TOP_LEFT_ADDR+249, x
	sta SCREEN_TOP_LEFT_ADDR+499, x
	sta SCREEN_TOP_LEFT_ADDR+749, x
	lda #$01				// fill screen char color ram with white
	sta SCREEN_TOP_LEFT_COLOR_ADDR-1, x
	sta SCREEN_TOP_LEFT_COLOR_ADDR+249, x
	sta SCREEN_TOP_LEFT_COLOR_ADDR+499, x
	sta SCREEN_TOP_LEFT_COLOR_ADDR+749, x
	dex
	bne !-
	lda #$00
	sta BORDER_COLOR_ADDR
	lda #$00
	sta BG_COLOR_ADDR
	rts

draw_board:
	ldx #$0a
!:
	lda #CHAR_HORIZONTAL_BOTTOM		// draw top border
	sta SCREEN_TOP_LEFT_ADDR+94, x
	lda #CHAR_HORIZONTAL_TOP		// draw bottom border
	sta SCREEN_BOTTOM_LEFT_ADDR-26, x
	dex
	bne !-
	lda #$86
	sta zp_temp1
	lda #$04
	sta zp_temp1+1
	ldx #$14
!:
	lda #CHAR_VERTICAL_RIGHT		// draw left border
	ldy #$00
	sta (zp_temp1), y
	lda zp_temp1
	clc
	adc #$0b
	sta zp_temp1
	lda zp_temp1+1
	adc #$00
	sta zp_temp1+1
	lda #CHAR_VERTICAL_LEFT			// draw right border
	ldy #$00
	sta (zp_temp1), y
	lda zp_temp1
	clc
	adc #$1d
	sta zp_temp1
	lda zp_temp1+1
	adc #$00
	sta zp_temp1+1
	dex
	bne !-
	rts

// ======================================================================================
// MAIN LOOP SUBROUTINES
// ======================================================================================

wait:
	lda RASTER_LINE_ADDR
	cmp #$fa
	bne wait
!:
	lda RASTER_LINE_ADDR
	cmp #$fa
	beq !-
	rts

draw_current_piece:
	lda #$00
	sta current_color
	sta current_piece
	sta current_rotation

// ======================================================================================
// DATA
// ======================================================================================

	*= $2000 "Data"

	piece_I_0: .byte %01000000, %01000000, %01000000, %01000000
	piece_I_1: .byte %00000000, %11110000, %00000000, %00000000
	piece_I_2: .byte %01000000, %01000000, %01000000, %01000000
	piece_I_3: .byte %00000000, %11110000, %00000000, %00000000

	piece_O_0: .byte %01100000, %01100000, %00000000, %00000000
	piece_O_1: .byte %01100000, %01100000, %00000000, %00000000
	piece_O_2: .byte %01100000, %01100000, %00000000, %00000000
	piece_O_3: .byte %01100000, %01100000, %00000000, %00000000

	piece_T_0: .byte %01000000, %11100000, %00000000, %00000000
	piece_T_1: .byte %01000000, %11000000, %01000000, %00000000
	piece_T_2: .byte %11100000, %01000000, %00000000, %00000000
	piece_T_3: .byte %01000000, %01100000, %01000000, %00000000

	piece_L_0: .byte %01000000, %01000000, %01100000, %00000000
	piece_L_1: .byte %00100000, %11100000, %00000000, %00000000
	piece_L_2: .byte %11000000, %01000000, %01000000, %00000000
	piece_L_3: .byte %11100000, %10000000, %00000000, %00000000

	piece_J_0: .byte %01000000, %01000000, %11000000, %00000000
	piece_J_1: .byte %11100000, %00100000, %00000000, %00000000
	piece_J_2: .byte %01100000, %01000000, %01000000, %00000000
	piece_J_3: .byte %10000000, %11100000, %00000000, %00000000

	piece_S_0: .byte %01100000, %11000000, %00000000, %00000000
	piece_S_1: .byte %10000000, %11000000, %01000000, %00000000
	piece_S_2: .byte %01100000, %11000000, %00000000, %00000000
	piece_S_3: .byte %10000000, %11000000, %01000000, %00000000

	piece_Z_0: .byte %11000000, %01100000, %00000000, %00000000
	piece_Z_1: .byte %01000000, %11000000, %10000000, %00000000
	piece_Z_2: .byte %11000000, %01100000, %00000000, %00000000
	piece_Z_3: .byte %01000000, %11000000, %10000000, %00000000

	piece_data_lo:
		.byte <piece_I_0, <piece_I_1, <piece_I_2, <piece_I_3
		.byte <piece_O_0, <piece_O_1, <piece_O_2, <piece_O_3
		.byte <piece_T_0, <piece_T_1, <piece_T_2, <piece_T_3
		.byte <piece_L_0, <piece_L_1, <piece_L_2, <piece_L_3
		.byte <piece_J_0, <piece_J_1, <piece_J_2, <piece_J_3
		.byte <piece_S_0, <piece_S_1, <piece_S_2, <piece_S_3
		.byte <piece_Z_0, <piece_Z_1, <piece_Z_2, <piece_Z_3

	piece_data_hi:
		.byte >piece_I_0, >piece_I_1, >piece_I_2, >piece_I_3
		.byte >piece_O_0, >piece_O_1, >piece_O_2, >piece_O_3
		.byte >piece_T_0, >piece_T_1, >piece_T_2, >piece_T_3
		.byte >piece_L_0, >piece_L_1, >piece_L_2, >piece_L_3
		.byte >piece_J_0, >piece_J_1, >piece_J_2, >piece_J_3
		.byte >piece_S_0, >piece_S_1, >piece_S_2, >piece_S_3
		.byte >piece_Z_0, >piece_Z_1, >piece_Z_2, >piece_Z_3

	piece_colors:
		.byte $03	// I - CYAN
		.byte $07	// O - YELLOW
		.byte $04	// T - PURPLE
		.byte $08	// L - ORANGE
		.byte $06	// J - BLUE
		.byte $05	// S - GREEN
		.byte $02	// Z - RED