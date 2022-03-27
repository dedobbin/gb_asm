INCLUDE "hardware.inc"
INCLUDE "constants.inc"

SECTION "HEADER", ROM0[$100]
EntryPoint:
    di
    jp Start ;

REPT $150 - $104
    db 0
ENDR

SECTION "Game code", ROM0

Start: 
    call WaitVBlank
    ld a, %00000000 ; reset a
    ld [rLCDC], a ; I guess this sets it so tile pattern #0 is at $9000

    call CopyDMARoutine 

    call LoadTiles

    call SetBackground

    call InitObjs

    call BallInit

    ld hl, game_mode
    ld [hl], 1 ;run in 'gameplay mode' , todo: dont hardcode

    ; Whole song and dance
    ; Init display registers
    ld a, %11100100
    ld [rBGP], a

    ; this sets the x and y scroll
    xor a ; ld a, 0
    ld [rSCY], a
    ld [rSCX], a

    ; Shut sound down
    ld [rNR52], a

    ; Turn screen on, display background
    ld a, %10000011
    ld [rLCDC], a

    ;ei
.game_loop
    call WaitVBlank
    ld a, [game_mode]
    cp a, 1
    jp z, .game_play
    cp a, 2
    jp z, .game_over

.game_play
    call BallUpdate
    call ReadInput
    call PlayerUpdate
    
    jp .update_oam

.game_over
    jp .update_oam

.update_oam
    ;ld  a, HIGH(wShadowOAM)
    ld  a, HIGH($c100)
    call hOAMDMA

    jr  .game_loop

; SECTION "Shadow OAM", WRAM0,ALIGN[8]

; wShadowOAM:
;   ds 4 * 40 ; This is the buffer we'll write sprite data to