.386
.model flat,stdcall
option casemap:none

INCLUDELIB acllib.lib
INCLUDELIB myLib.lib
include inc/acllib.inc
include inc/sharedVar.inc
include inc/model.inc
include inc/msvcrt.inc

calPsin PROTO C :dword, :dword
calPcos PROTO C :dword, :dword
myitoa PROTO C :dword, :ptr sbyte

colorBLACK EQU 00000000h
colorWHITE EQU 00ffffffh
colorEMPTY EQU 0ffffffffh

.data	
srcBg byte "..\..\..\resource\icon\background.jpg", 0
srcTitle byte "..\..\..\resource\icon\title.jpg", 0
srcPin byte "..\..\..\resource\icon\pin.jpg", 0 
srcStart byte "..\..\..\resource\icon\start.jpg", 0 
srcExit byte "..\..\..\resource\icon\exit.jpg", 0 
srcBg2 byte "..\..\..\resource\icon\background2.jpg", 0 
srcContinue byte "..\..\..\resource\icon\continue.jpg", 0 
srcHome byte "..\..\..\resource\icon\home.jpg", 0 
srcHome2 byte "..\..\..\resource\icon\home2.jpg", 0 
srcMenu byte "..\..\..\resource\icon\menu.jpg", 0 
srcScore byte "..\..\..\resource\icon\score.jpg", 0 
srcWin byte "..\..\..\resource\icon\win.jpg", 0 
srcReload byte "..\..\..\resource\icon\reload.jpg", 0 
imgBg ACL_Image <>
imgTitle ACL_Image <>
imgPin ACL_Image <>
imgStart ACL_Image <>
imgExit ACL_Image <>
imgBg2 ACL_Image <>
imgContinue ACL_Image <>
imgHome ACL_Image <>
imgHome2 ACL_Image <>
imgMenu ACL_Image <>
imgScore ACL_Image <>
imgWin ACL_Image <>
imgReload ACL_Image <>

fontName byte "等线", 0
titleScore byte "得 分", 0

colorCCircle dword 008515c7h  ;中心圆颜色
colorScore dword 008eb0fch  ;记分牌颜色
colors  dword 00cccc99h  ;底部针头颜色
		dword 0099cc99h
		dword 00996699h
		dword 009999ffh
		dword 009966cch
		dword 0099ccffh

strScore byte 10 DUP(0)
strPinNum byte 10 DUP(0)
strCurNum byte 10 DUP(0)

lowy dword 545  ;底部针头最上端纵坐标 
lowyText dword 534  ;底部针头数字最上端纵坐标
initPinNum dword ?  ;预置针数量
totalPinNum dword ?  ;要插入的针数量
pinLen dword 170  ;针长
pinX dword ? 
pinY dword ?



.code
;@brief:刷新记分牌
;@param num:当前分数
FlushScore proc C num: dword
	mov ebx, num
	invoke myitoa, ebx, offset strScore
	ret
FlushScore endp


;@brief:载入主界面/失败/成功界面
;@param win:界面类型（0主界面，2失败界面，3成功界面）
loadMenu proc C win:dword
	mov ebx, win
	mov currWindow, ebx	
	
	;选择生成的窗口
	cmp ebx, 0  
	jz mainwindow	
	cmp ebx, 2
	jz loser
	cmp ebx,3
	jz winner

mainwindow:
	;载入图片
	invoke loadImage, offset srcBg, offset imgBg
	invoke loadImage, offset srcTitle, offset imgTitle
	invoke loadImage, offset srcPin, offset imgPin
	invoke loadImage, offset srcStart, offset imgStart
	invoke loadImage, offset srcExit, offset imgExit	
	;显示主界面
	invoke beginPaint
	invoke putImageScale, offset imgBg, 0, 0, 550, 700
	invoke putImageScale, offset imgTitle, 45, 110, 500, 150
	invoke putImageScale, offset imgPin, 246, 120, 60, 100
	invoke putImageScale, offset imgStart, 155, 310, 240, 100
	invoke putImageScale, offset imgExit, 155, 460, 240, 100
	invoke endPaint
	jmp finish

loser:
	;载入图片
	invoke loadImage, offset srcBg2, offset imgBg2
	invoke loadImage, offset srcHome2, offset imgHome2
	invoke loadImage, offset srcScore, offset imgScore
	invoke loadImage, offset srcReload, offset imgReload
	;显示失败界面
	invoke beginPaint
	invoke putImageScale, offset imgBg2, 25, 165, 500, 330
	invoke putImageScale, offset imgScore, 100, 180, 350, 100
	invoke putImageScale, offset imgHome2, 155, 400, 70, 70
	invoke putImageScale, offset imgReload, 325, 400, 70, 70
	;显示得分
	invoke setTextSize, 80
	invoke setTextColor, 00cc9900h
	invoke setTextBkColor, colorEMPTY
	invoke paintText, 235, 295, offset strScore
	invoke endPaint
	jmp finish

winner:
	;载入图片
	invoke loadImage, offset srcBg2, offset imgBg2
	invoke loadImage, offset srcHome2, offset imgHome2
	invoke loadImage, offset srcWin, offset imgWin
	invoke loadImage, offset srcContinue, offset imgContinue
	;显示成功界面
	invoke beginPaint
	invoke putImageScale, offset imgBg2, 25, 165, 500, 330
	invoke putImageScale, offset imgWin, 25, 215, 500, 100
	invoke putImageScale, offset imgHome2, 155, 365, 70, 70
	invoke putImageScale, offset imgContinue, 325, 365, 70, 70
	invoke endPaint
	jmp finish

finish:	
	ret 
loadMenu endp


;@brief:刷新游戏界面
flushGameWindow proc C
	add cdeg, 2
	cmp cdeg, 360
	jb ta
	mov cdeg, 0
ta:
	invoke loadImage, offset srcBg, offset imgBg
	invoke loadImage, offset srcHome, offset imgHome
	
	invoke beginPaint
	invoke putImageScale, offset imgBg, 0, 0, 550, 700
	invoke putImageScale, offset imgHome, 60, 35, 60, 60	
	
	;绘制记分牌
	invoke setPenWidth, 1
	invoke setPenColor, colorScore
	invoke setBrushColor, colorScore
	invoke roundrect, 215, 35, 335, 100, 10, 10
	;绘制记分牌分数
	invoke setTextColor, colorWHITE
	invoke setTextFont, offset fontName
	invoke setTextBkColor, colorEMPTY
	invoke setTextSize, 28
	invoke paintText, 245, 40, offset titleScore
	invoke paintText, 260, 70, offset strScore

	mov ecx, 0  ;循环次数=预置针数量
t0:	
	;计算针终点
	mov edx, cdeg  
	add edx, pindeg[ecx*4]  ;计算当前角度
	cmp edx, 360
	jb t2  ;小于360度直接计算
	cmp edx, 720
	jae t3  ;大于等于720度跳至l3
	sub edx, 360  ;大于等于360，小于720
	jmp t2
t3:
	sub edx, 720
t2:
	mov eax, 275
	add eax, pcos[edx*4]
	mov pinX, eax  ;计算横坐标
	mov eax, 320
	add eax, psin[edx*4]
	mov pinY, eax  ;计算纵坐标
	push ecx
	;绘制预置针
	invoke setPenColor, colorBLACK
	invoke setPenWidth, 2
	invoke line, 275, 320, pinX, pinY 
	;绘制预置针头
	invoke setPenWidth, 30
	invoke line, pinX, pinY, pinX, pinY
	pop ecx
	inc ecx
	cmp ecx, initPinNum
	jb t0

	; 绘制插入针
	mov ebx, totalPinNum
	cmp pinnum, ebx
	je tc
tb:
	;计算针终点
	mov edx, cdeg  
	add edx, pindeg[ecx*4]  ;计算当前角度
	cmp edx, 360
	jb ti  ;小于360度直接计算
	cmp edx, 720
	jae th  ;大于等于720度跳至th
	sub edx, 360  ;大于等于360，小于720
	jmp ti
th:
	sub edx, 720
ti:
	mov eax, 275
	add eax, pcos[edx*4]
	mov pinX, eax  ;计算横坐标
	mov eax, 320
	add eax, psin[edx*4]
	mov pinY, eax  ;计算纵坐标
	push ecx
	;绘制插入针
	invoke setPenColor, colorBLACK
	invoke setPenWidth, 2
	invoke line, 275, 320, pinX, pinY 
	;绘制插入针头 针头当前序号eax=total+init-ecx
	pop ecx
	mov eax, totalPinNum
	add eax, initPinNum
	sub eax, ecx
	
	xor ebx, ebx
	xor edx, edx
	mov bl, 6
	div bl
	mov dl, ah 
	push ecx
	invoke setPenColor, colors[edx*4]  ;根据余数选择颜色
	invoke setPenWidth, 30
	invoke line, pinX, pinY, pinX, pinY
	pop ecx
	inc ecx
	mov edx, ecx
	sub edx, initPinNum
	add edx, pinnum
	cmp edx, totalPinNum
	jb tb

tc:
	;绘制中心圆
	invoke setPenWidth, 1
	invoke setPenColor, colorCCircle
	invoke setBrushColor, colorCCircle
	invoke pie, 235, 280, 315, 360, 235, 320, 235, 320
	;绘制中心数字
	invoke setTextSize, 35
	invoke myitoa, pinnum, offset strPinNum
	cmp pinnum, 10
	jb t4
	invoke paintText, 256, 303, offset strPinNum
	jmp t5
t4:
	invoke paintText, 265, 303, offset strPinNum

t5:
	;绘制底部针头	
	mov eax, pinnum  ;当前剩余针头数 
	mov cx, 6  ;循环次数
	mov ebx, 0

t1:	
	mov edx, 0  ;记录余数
	push cx
	push eax
	mov bl, 6
	div bl
	mov dl, ah 
	push edx
	invoke setPenColor, colors[edx*4]  ;根据余数选择颜色
	pop edx
	invoke setBrushColor, colors[edx*4]
	invoke setPenWidth, 30
	invoke line, 275, lowy, 275, lowy  ;绘制针头	
	
	;绘制针头数字
	invoke setTextColor, colorWHITE
	invoke setTextSize, 20
	pop eax
	push eax
	invoke myitoa, eax, offset strCurNum
	pop eax
	cmp eax, 10
	push eax
	jb t6
	invoke paintText, 264, lowyText, offset strCurNum
	jmp t7
t6:
	invoke paintText, 270, lowyText, offset strCurNum
t7:
	pop eax
	pop cx
	dec eax
	cmp eax, 0
	jz finish

	add lowy, 30
	add lowyText, 30
	
	dec cx
	cmp cx, 0
	jz finish
	jmp t1

finish:	
	mov lowy, 545  ;恢复底部针头最上端纵坐标
	mov lowyText, 534

	invoke endPaint
	ret
	
flushGameWindow endp


;@brief:计时器回调函数
timer proc C id:dword
	invoke flushGameWindow
	ret
timer endp


;@brief:载入游戏界面
;@param omega:角速度
initGameWindow proc C num:dword, interval:dword
	mov currWindow, 1  

	;计算psin、pcos
	mov ecx, 0
cal:
	push ecx
	invoke calPsin, pinLen, ecx
	pop ecx
	mov psin[ecx*4] ,eax
	
	push ecx
	invoke calPcos, pinLen, ecx
	pop ecx
	mov pcos[ecx*4] ,eax
	inc ecx
	cmp ecx, 360
	jb cal

	;存储预置针数量
	mov eax, num
	mov initPinNum, eax
	;存储要插入的针总数
	mov eax, pinnum
	mov totalPinNum, eax

	;刷新初始分数
	;invoke FlushScore, 0

	invoke loadImage, offset srcBg, offset imgBg
	invoke loadImage, offset srcHome, offset imgHome
	
	invoke beginPaint
	invoke putImageScale, offset imgBg, 0, 0, 550, 700
	invoke putImageScale, offset imgHome, 60, 35, 60, 60	
	
	;绘制记分牌
	invoke setPenWidth, 1
	invoke setPenColor, colorScore
	invoke setBrushColor, colorScore
	invoke roundrect, 215, 35, 335, 100, 10, 10
	;绘制记分牌分数
	invoke setTextColor, colorWHITE
	invoke setTextFont, offset fontName
	invoke setTextBkColor, colorEMPTY
	invoke setTextSize, 28
	invoke paintText, 245, 40, offset titleScore
	invoke paintText, 260, 70, offset strScore

	mov ecx, 0  ;循环次数=预置针数量
l0:	
	;计算针终点
	mov edx, cdeg  
	add edx, pindeg[ecx*4]  ;计算当前角度
	cmp edx, 360
	jb l2  ;小于360度直接计算
	cmp edx, 720
	jae l3  ;大于等于720度跳至l3
	sub edx, 360  ;大于等于360，小于720
	jmp l2
l3:
	sub edx, 720
l2:
	mov eax, 275
	add eax, pcos[edx*4]
	mov pinX, eax  ;计算横坐标
	mov eax, 320
	add eax, psin[edx*4]
	mov pinY, eax  ;计算纵坐标
	push ecx
	;绘制预置针
	invoke setPenColor, colorBLACK
	invoke setPenWidth, 2
	invoke line, 275, 320, pinX, pinY 
	;绘制预置针头
	invoke setPenWidth, 30
	invoke line, pinX, pinY, pinX, pinY
	pop ecx
	inc ecx
	cmp ecx, initPinNum
	jb l0

	;绘制中心圆
	invoke setPenWidth, 1
	invoke setPenColor, colorCCircle
	invoke setBrushColor, colorCCircle
	invoke pie, 235, 280, 315, 360, 235, 320, 235, 320
	;绘制中心数字
	invoke setTextSize, 35
	invoke myitoa, pinnum, offset strPinNum
	cmp pinnum, 10
	jb l4
	invoke paintText, 256, 303, offset strPinNum
	jmp l5
l4:
	invoke paintText, 265, 303, offset strPinNum

l5:
	;绘制底部针头	
	mov eax, pinnum  ;当前剩余针头数 
	mov cx, 6  ;循环次数
	mov ebx, 0

l1:	
	mov edx, 0  ;记录余数
	push cx
	push eax
	mov bl, 6
	div bl
	mov dl, ah 
	push edx
	invoke setPenColor, colors[edx*4]  ;根据余数选择颜色
	pop edx
	invoke setBrushColor, colors[edx*4]
	invoke setPenWidth, 30
	invoke line, 275, lowy, 275, lowy  ;绘制针头	
	
	;绘制针头数字
	invoke setTextColor, colorWHITE
	invoke setTextSize, 20
	pop eax
	push eax
	invoke myitoa, eax, offset strCurNum
	pop eax
	cmp eax, 10
	push eax
	jb l6
	invoke paintText, 264, lowyText, offset strCurNum
	jmp l7
l6:
	invoke paintText, 270, lowyText, offset strCurNum
l7:
	pop eax
	dec eax
	cmp eax, 0
	jz finish

	add lowy, 30
	add lowyText, 30
	
	pop cx
	dec cx
	cmp cx, 0
	jz finish
	jmp l1

finish:	
	mov lowy, 545  ;恢复底部针头最上端纵坐标
	mov lowyText, 534
	invoke endPaint

	;初始化计时器
	invoke registerTimerEvent, offset timer
	invoke startTimer, 0, interval
	ret
initGameWindow endp	



;main proc C
	;invoke init_first  ;初始化绘图环境
	;invoke initWindow, offset winTitle, 425, 50, 550, 700 
	
	;mov pindeg[0], 0
	;mov pindeg[4], 180
	;mov pindeg[8], 90
	;mov pinnum, 12
	;invoke FlushScore, 20
	;invoke initGameWindow, 3, 10
	;mov pindeg[12], 70	
	;mov pindeg[16], 320
	;mov pindeg[20], 200
	;mov pindeg[24], 45
	;mov pinnum, 10
	;invoke FlushScore, 50

	;invoke cancelTimer, 0
	;mov pindeg[28], 33
	;invoke loadMenu, 3
	
	;invoke init_second  ;启动事件循环
	;ret
;main endp
;end main
end