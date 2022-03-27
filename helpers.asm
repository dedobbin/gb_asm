INCLUDE "hardware.inc"

SECTION "HELPERS", ROMX
; Do not turn the LCD off outside of VBlank
WaitVBlank::
    ld a, [rLY]
    cp 144
    jp c, WaitVBlank
    ret

InvertTwoCpl::
    cpl
    inc a
    ret

SECTION "OAM DMA routine", ROM0
    CopyDMARoutine::
      ; DMARoutine can only read from hi-ram, so copy dma routine there, call it in the future using    `ld  a, HIGH(wShadowOAM) and call hOAMDMA;`
      ld  hl, DMARoutine
      ld  b, DMARoutineEnd - DMARoutine ; Number of bytes to copy
      ld  c, LOW(hOAMDMA) ; Low byte of the destination address
    .copy
      ld  a, [hli]
      ldh [c], a
      inc c
      dec b
      jr  nz, .copy
      ret
    
    DMARoutine:
      ldh [rDMA], a
      
      ld  a, 40
    .wait
      dec a
      jr  nz, .wait
      ret
    DMARoutineEnd:

SECTION "OAM DMA", HRAM ;When handling DMA routine, cpu can only access hi-ram, so we need to copy our routine in here 

hOAMDMA::
    ds DMARoutineEnd - DMARoutine ; Reserve space to copy the routine to