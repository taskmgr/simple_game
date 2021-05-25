.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib

include inc\acllib.inc
include inc\windows.inc
include inc\sharedVar.inc
include inc\view.inc
include inc\controller.inc ;CONTROLLER

.data
winTitle byte "见缝插针", 0

.code
main proc;梦开始的地方
	invoke init_first  ;初始化绘图环境
	invoke initWindow, offset winTitle, 425, 50, 550, 700 
	invoke registerMouseEvent,iface_mouseEvent ;注册控制流事件，注意，如果要定义按钮动作，进入这个函数内进行函数代码的添加
	
	invoke loadMenu, 0  ;显示主菜单
	;invoke loadMenu, 2 ;显示最终得分菜单
	;invoke loadMenu, 3 ;显示好耶你通关了


	;显示游戏主界面
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