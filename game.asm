SECTION "game", ROMX

INCLUDE "graphics.inc"
INCLUDE "constants.inc"

LoadTiles::
    call ClearTiles
    
    ; backgrounds
    ld hl, $9000 
    ld de, BackgroundTileData
    ld bc, BackgroundTileDataEnd - BackgroundTileData
.copy_background_tiles_loop
    ld a,[de] 
    ld [hli], a  
    inc de 
    dec bc 
    ld a, b 
    or c   
    jr nz, .copy_background_tiles_loop

    ; objs - TODO: this draws only black?
    ld hl, $8000 
    ld de, ObjTileData 
    ld bc, ObjTileDataEnd - ObjTileData 
.copy_obj_tiles_loop
    ld a,[de] 
    ld [hli], a 
    inc de 
    dec bc 
    ld a, b 
    or c   
    jr nz, .copy_obj_tiles_loop
    ret

SetBackground::
    ld hl, $9800
    ;ld bc, $234
    ld bc, $9c00 - $9800
    ld de, $A000
.set_background_loop:
    ld [hl], 1
    inc de
    ;ld [hl], 3 ; non existing
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, .set_background_loop
    ret

InitObjs::
    ; byte 1 is the Y position
    ld  a,130
    ld  [player_obj],a

    ; byte 2 is the X position
    ld  a,32
    ld  [player_obj+1],a

    ; byte 3 is the entry in tilemap
    ld  a,0
    ld  [player_obj+2],a

    ; byte 4 is flip
    ld  a,0
    ld  [player_obj+3],a


    ; byte 1 is the Y position
    ld  a,130
    ld  [player_obj+4],a

    ; byte 2 is the X position
    ld  a,32+8
    ld  [player_obj+5],a

    ; byte 3 is the entry in tilemap
    ld  a,0
    ld  [player_obj+6],a

    ; byte 4 is flip
    ld  a,0
    ld  [player_obj+7],a


    ; byte 1 is the Y position
    ld  a,50
    ld  [ball_obj],a

    ; byte 2 is the X position
    ld  a,50
    ld  [ball_obj+1],a

    ; byte 3 is the entry in tilemap
    ld  a,1
    ld  [ball_obj+2],a

    ; byte 4 is flip
    ld  a,0
    ld  [ball_obj+3],a
    ret

ClearTiles:
    ;$87f0 - $8000
    ld a, $87
    sub a, 80
    ld b, a

    ld a, $f0
    sbc a, $00
    ld c, a

    ld hl, $8000
.clear_tiles_loop
    ld [hl], 0
    inc hl
    dec bc
    ld a, b
    or c
    jp nz, .clear_tiles_loop
    ret

; reads input from d
; todo: use PADDLE_W
PlayerUpdate::
    ld a, [game_mode]
    cp a, 1 ; check if in gameplaymode
    jp nz, .player_update_end

    bit BUTTON_RIGHT, d
    jp z, .update_right_end
    ld  a, [player_obj+1]
    inc a
    ld  [player_obj+1],a
    add a,8
    ld  [player_obj+5],a
.update_right_end
    bit BUTTON_LEFT, d
    jp z, .update_left_end
    ld  a, [player_obj+1]
    dec a
    ld  [player_obj+1],a
    add a,8
    ld  [player_obj+5],a
.update_left_end
.player_update_end

    ld a, [game_mode]
    cp a, 2 ; check if in game over mode
    jp nz, .game_over_end
    bit BUTTON_A, d
    jp nz, .game_over_end
    call InitObjs
    ld a, 1
    ld [game_mode], a
.game_over_end
    ret

SetGameOver::
    ld hl, ball_obj
    ld [hl], -50
    ld hl, ball_obj+1
    ld [hl], -50

    ld b, 0
    ld hl, player_obj
.paddle_loop
    inc b
    ld [hl], -50
    inc hl
    ld [hl], -50
    inc hl
    inc hl
    inc hl
    inc hl
    ld a, b
    cp a, PADDLE_W
    jp nz, .paddle_loop

    ; todo: bg
    


    ; todo: font
    ld a, 2
    ld [game_mode], a
    ret

SECTION "oam_vars",WRAM0[$C100]

; megaman_sprites: DS 4*12
player_obj:: DS 4*PADDLE_W ; 2 tile
ball_obj:: DS 4*1 ; 1 tile
rest_obj: DS 4*37 ; total of 40

SECTION "game_Vars",WRAMX
game_mode:: DS 1 ; 1 = gameplay, 2 = gameover TODO: get rid of magic numbers