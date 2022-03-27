SECTION "ball_vars", WRAM0
    ball_speed_x: DS 1
    ball_speed_y: DS 1

SECTION "ball", ROMX

INCLUDE "constants.inc"

;TODO: better values for most
BOUNDRY_TOP equ($11)
BOUNDRY_BOTTOM equ($99)
BOUNDRY_RIGHT equ($a6)
BOUNDRY_LEFT equ($5)

BallInit::
    ld hl, ball_speed_x
    ld [hl], 1
    ld hl, ball_speed_y
    ld [hl], -1
    ret 

BallUpdate::
    ; ======== y ========
    ld a, [ball_speed_y]
    ld b, a
    ld a, [ball_obj]
    add a, b
    ld c, a ; new y pos

    ld a, [ball_obj+1]
    ld h, a
    ld l, c
    call Collision
    ld a, d
    cp a, 1
    jp nz, .add_y_speed
    ld a, [ball_speed_y]
    call InvertTwoCpl
    ld [ball_speed_y], a
    ld b, a
    ld a, [ball_obj]
    add a, b
    ld c, a
.add_y_speed
    ld a, c
    ld [ball_obj], a

    ; ======== x ========
    ld a, [ball_speed_x]
    ld b, a
    ld a, [ball_obj+1]
    add a, b
    ld c, a ; new x pos

    ld h, c
    ld a, [ball_obj]
    ld l, a
    call Collision
    ld a, d
    cp a, 1
    jp nz, .add_x_speed
    ld a, [ball_speed_x]
    call InvertTwoCpl
    ld [ball_speed_x], a
    ld b, a
    ld a, [ball_obj+1]
    add a, b
    ld c, a
.add_x_speed
    ld a, c
    ld [ball_obj+1], a
    ret

; Checks for collision, assuming h is x and l is y
; Stores 1 in d if collision, 0 if not
Collision:
    ;paddle
    ld a, l
    ld b, a
    ld a, [player_obj]
    cp a, b 
    jp nc, .paddle_col_end
    ; right side of ball > left side of paddle
    ld a, h
    add a, 10 ; TODO: get rid of mgaic number - One would assume, this should be 8, but 10 gives player more leancy and with 8, ball can no through paddle? :|
    ld b, a
    ld a, [player_obj+1]
    cp a, b
    jp nc, .paddle_col_end
    ; check left side of ball < right side of paddle
    ld a, [player_obj+5] ; TODO: use paddle_w
    add a, 10 ; One would assume, this should be 8, but 10 gives player more leancy and with 8, ball can no through paddle? :|
    ld b, a
    ld a, h
    cp a, b
    jp nc, .paddle_col_end
    
    jp .col_yes
.paddle_col_end
    
    ld a, l
    cp a, BOUNDRY_BOTTOM
    jp z, .touch_bottom
    cp a, BOUNDRY_TOP
    jp z, .col_yes

    ld a, h
    cp a, BOUNDRY_RIGHT
    jp z, .col_yes
    cp a, BOUNDRY_LEFT
    jp z, .col_yes

    ld d, 0 ;If we came here there was no colision.
    jp .col_end
.touch_bottom:
    call SetGameOver
    jp .col_end
.col_yes
    ld d, 1
.col_end
    ret

    
