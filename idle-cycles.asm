	processor 6502
	include "vcs.h"
	include "macro.h"

	SEG.U ram
	ORG $80

BgColor ds 1
NoteIndex ds 1
NoteTime ds 1

	SEG code
	ORG $F000

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
	REPEAT 192
		inx
		stx COLUBK
		sta WSYNC
	REPEND
	inc $80

	lda #%01000010
	sta VBLANK

	ldx NoteIndex
	inc NoteTime
	lda #20
	cmp NoteTime
	bne NotePlaying
	lda #0
	sta NoteTime
	inx
	cpx #6
	bne NextNote
	ldx #0
NextNote
	stx NoteIndex
NotePlaying
	lda Music,X
	sta AUDF0
 
	REPEAT 30
		sta WSYNC
	REPEND

	jmp StartOfFrame

Music
	dc 4, 7, 13, 2, 13, 8
MusicEnd

	ORG $FFFA

	.word Reset
	.word Reset
	.word Reset
End


