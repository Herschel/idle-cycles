	processor 6502
	include "vcs.h"
	include "macro.h"

	seg.u ram
	org $80

BgColor		ds 1
NoteIndex	ds 1
NoteTime	ds 1
InstrumentIndex	ds 1

	seg code
	org $F000

Reset
	CLEAN_START
	lda #%1111
	sta AUDV0
	sta AUDC0

StartOfFrame

TwisterSetup
	lda #$23
	sta COLUP0
	lda #$20
	sta COLUP1
	lda #%00110000
	sta NUSIZ1
	lda #2
	sta ENAM1
VSync
	lda #2
	sta VSYNC
	sta WSYNC
	sta WSYNC
	lsr
	sta WSYNC
	sta VSYNC

VBlank
	sta WSYNC
	SLEEP 42
	sta RESP0
	sta WSYNC
	SLEEP 41
	sta RESP1
	sta WSYNC


	lda #2
	sta RESMP0
	sta RESMP1
	lda #0
	sta RESMP0
	sta RESMP1
	lda #%00010000
	sta HMM1
	sta WSYNC
	sta HMOVE

	ldx #33
VBlankLoop
	dex
	sta WSYNC
	bne VBlankLoop

	stx VBLANK

	ldx #192
	inc $80
Scanline
	txa
	adc $80
	and #$0f
	tay
	lda TwisterTable,Y
	sta GRP0
	dex
	sta WSYNC
	bne Scanline

Overscan
	lda #%01000010
	sta VBLANK

MusicDriver
	lax NoteIndex
	dec NoteTime
	bpl NoteActive
NextNote
	adc #2
	tax
	lsr
	cmp MusicPattern0
	bne LoadNextNote
ResetNote
	ldx #0
LoadNextNote
	stx NoteIndex
	lda MusicPattern0+2,X
	asl
	asl
	sta NoteTime
NoteActive
	; X = NoteIndex*2
	lda MusicPattern0+1,X
	sta AUDF0

	lda #0
	sta COLUBK
	ldx #29
OverscanLoop
	dex
	bne OverscanLoop

	jmp StartOfFrame

Intrument0
	.byte $f2
	.byte $ff, $ea, $84, $20

MusicPattern0
	.byte $04
	.word $040c, $040d, $040e, $040f
MusicPattern0End

TwisterTable
	.byte %00000000
	.byte %10000000
	.byte %11000000
	.byte %11100000
	.byte %11110000
	.byte %11111000
	.byte %11111100
	.byte %11111110
	.byte %11111111
	.byte %01111111
	.byte %00111111
	.byte %00011111
	.byte %00001111
	.byte %00000111
	.byte %00000011
	.byte %00000001

	org $FFFA

	.word Reset
	.word Reset
	.word Reset
End


