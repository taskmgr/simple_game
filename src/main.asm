.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib

include inc\acllib.inc
include inc\windows.inc
include inc\sharedVar.inc
include inc\view.inc

.data
winTitle byte "见缝插针", 0

.code
main proc;梦开始的地方
	invoke init_first  ;初始化绘图环境
	invoke initWindow, offset winTitle, 425, 50, 550, 700 
	invoke loadMenu, 0  ;显示主菜单
	
	;invoke loadMenu, 3
	;mov pindeg[0], 0
	;mov pindeg[4], 180
	;mov pindeg[8], 90
	;mov pinnum, 12
	;invoke FlushScore, 20
	;invoke initGameWindow, 3, 10
	;mov pindeg[12], 45
	;mov pinnum, 11
	invoke init_second
	ret
main endp

end main