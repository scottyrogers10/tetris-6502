BasicUpstart2(init)

	*= $c000 "init"

	.const BORDER_COLOR_ADDR		= $d020
	.const BG_COLOR_ADDR			= $d021
	.const CHAR_HORIZONTAL_BOTTOM		= $6f
	.const CHAR_HORIZONTAL_TOP		= $77
	.const CHAR_PERIOD			= $2e
	.const CHAR_SPACE 			= $20
	.const CHAR_VERTICAL_LEFT		= $65
	.const CHAR_VERTICAL_RIGHT		= $67
	.const SCREEN_TOP_LEFT_ADDR 		= $0400
	.const SCREEN_BOTTOM_LEFT_ADDR		= $07c0
	.const SCREEN_TOP_LEFT_COLOR_ADDR	= $d800

init:
	jsr empty_screen
	jsr draw_screen

loop:
	jmp loop

//------------------------------------------------------------------------
// INIT SUBROUTINES

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

draw_screen:
	ldx #$0a
!:
	lda #CHAR_HORIZONTAL_BOTTOM		// draw top border
	sta SCREEN_TOP_LEFT_ADDR+94, x
	lda #CHAR_HORIZONTAL_TOP		// draw bottom border
	sta SCREEN_BOTTOM_LEFT_ADDR-26, x
	dex
	bne !-
!:
	lda #CHAR_VERTICAL_RIGHT		// draw left border
	sta SCREEN_TOP_LEFT_ADDR+134, x

	lda #CHAR_VERTICAL_LEFT 		// draw right border
	sta SCREEN_TOP_LEFT_ADDR+145, x

	rts