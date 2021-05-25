.data?
modelOmega dd ?
modelInsertedPinNumber dd ?
modelScore dd ?
modelLastScore dd ?
.data
modelMusicBackground byte "..\..\..\resource\music\background.mp3", 0
modelMusicShoot byte "..\..\..\resource\music\shoot.mp3", 0
modelMusicLose byte "..\..\..\resource\music\lose.mp3", 0
modelMusicWin byte "..\..\..\resource\music\win.mp3", 0
modelMusicBackgroundP dd 0
modelMusicShootP dd 1
modelMusicLoseP dd 2
modelMusicWinP dd 3

;É¾µô£¡£¡£¡£¡£¡£¡£¡£¡£¡
;szMiddle1Fmt byte "			%d",0ah,0
;szMiddle2Fmt byte "%d",0ah,0
;szMiddle3Fmt byte "%d:Åö×²À²",0ah,0
;szMiddle4Fmt byte "cdeg:%d",0ah,0

modelNowDifficulty dd 3


KeyboardEvent PROTO C:dword
Window0Type0 PROTO C
Window0Type1 PROTO C
Window0Type2 PROTO C
Window1Type0 PROTO C
Window1Type1 PROTO C
Window1Type2 PROTO C
Window2Type0 PROTO C
Window2Type1 PROTO C
Window3Type0 PROTO C
Window3Type1 PROTO C
InitParam PROTO C
InitWindow PROTO C