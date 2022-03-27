;https://spkelly.net/tilegen/

BackgroundTileData::
	DB $80,$00,$24,$00,$02,$00,$10,$00
	DB $40,$00,$02,$00,$48,$00,$22,$00

	; DB $50,$00,$80,$00,$09,$00,$00,$00
	; DB $40,$00,$04,$00,$10,$00,$82,$00

	DB $00,$ff,$00,$ff,$00,$ff,$ff,$00
	DB $ff,$00,$00,$ff,$00,$ff,$00,$ff
BackgroundTileDataEnd::

ObjTileData::
	; paddle
	DB $ff,$ff,$ff,$ff,$ff,$00,$ff,$00
	DB $ff,$00,$ff,$00,$ff,$ff,$ff,$ff

	; ball
	DB $38,$38,$7c,$7c,$fe,$fe,$ff,$ff
	DB $ff,$ff,$7e,$7e,$7c,$7c,$38,$38
ObjTileDataEnd::