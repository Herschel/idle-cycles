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

	lda #0
	sta VBLANK

	lda #2
	sta VSYNC

	sta WSYNC
	sta WSYNC
	sta WSYNC

	lda #0
	sta VSYNC

	REPEAT 37
		sta WSYNC
	REPEND

	ldx $80
	ldy #192
Scanline
	stx COLUBK
	inx
	sta WSYNC
	dey
	bne Scanline

	inc $80

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

	REPEAT 30
		sta WSYNC
	REPEND

	jmp StartOfFrame

Intrument0
	.byte $f2
	.byte $ff, $ea, $84, $20

MusicPattern0
	.byte $04
	.word $040c, $040d, $040e, $040f
MusicPattern0End

	org $FFFA

	.word Reset
	.word Reset
	.word Reset
End


