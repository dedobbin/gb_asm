SECTION "joypad", ROMX

INCLUDE "constants.inc"

;reds output into d as bbbbdddd , b meaning button and d direction
ReadInput::
    ;TODO: Most programs read from the port several times in a row (the first reads are used as a short delay, allowing the inputs to stabilize, and only the value from the last read is actually used).
    push hl
    
    ; Read P14
    ld HL, USER_IO
    ld A, $20
    ld [HL], A
    ld A, [HL]
    cpl
    and a, %00001111
    ld d, a

    ld HL, USER_IO
    ld A, $10
    ld [HL], A
    ld A, [HL]
    cpl

    sla a
    sla a
    sla a
    sla a
    or a, d
    ld d, a

    pop hl
    ret

;     push hl
;     ld hl, USER_IO
;     ld a, $20
;     ld [hl], a
    
;     bit BUTTON_RIGHT, [hl]
;     jp nz, .update_right_end
;     ld  a, [player_obj+1]
;     inc a
;     ld  [player_obj+1],a
;     add a,8
;     ld  [player_obj+5],a
; .update_right_end
    
;     bit BUTTON_LEFT, [hl]
;     jp nz, .update_left_end
;     ld  a, [player_obj+1]
;     dec a
;     ld  [player_obj+1],a
;     sub a, 8
;     ld  [player_obj+5],a
; .update_left_end
  
; ;     bit BUTTON_UP, [hl]
; ;     jp nz, .update_up_end
; ;     ld  a, [player_obj]
; ;     dec a
; ;     ld  [player_obj],a
; ;     ld  [player_obj+4],a
; ; .update_up_end
  
; ;     bit BUTTON_DOWN, [hl]
; ;     jp nz, .update_down_end
; ;     ld  a, [player_obj]
; ;     inc a
; ;     ld  [player_obj],a
; ;     ld  [player_obj+4],a
; ; .update_down_end
  
    ; pop hl
    ; ret