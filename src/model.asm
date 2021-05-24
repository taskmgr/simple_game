.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib
include msvcrt.inc

include inc\sharedVar.inc
include inc\model.inc
include inc\acllib.inc
;include sharedVar.asm

.code
;FlushScore proc C num: dword
;	ret
;FlushScore endp
;loadMenu proc C win:dword
;	ret
;loadMenu endp
;initGameWindow proc C num: dword,speed:dword
;	ret
;initGameWindow endp
;flushGameWindow proc C
;	ret
;flushGameWindow endp

KeyboardEvent proc C windowType:dword
	;寄存器压栈
	pushad
	.if currWindow == 0 && windowType == 0
		invoke Window0Type0
	.elseif currWindow == 0 && windowType == 1
		invoke Window0Type1
	.elseif currWindow == 0 && windowType == 2
		invoke Window0Type2
	.elseif currWindow == 1 && windowType == 0
		invoke Window1Type0
	.elseif currWindow == 1 && windowType == 1
		invoke Window1Type1
	.elseif currWindow == 1 && windowType == 2
		invoke Window1Type2
	.elseif currWindow == 2 && windowType == 0
		invoke Window2Type0
	.elseif currWindow == 2 && windowType == 1
		invoke Window2Type1
	.elseif currWindow == 3 && windowType == 0
		invoke Window3Type0
	.elseif currWindow == 3 && windowType == 1
		invoke Window3Type1
	.else
		mov eax,0
	.endif

	;寄存器出栈
	popad

	ret
KeyboardEvent endp

Window0Type0 proc C
	invoke InitWindow
	ret
Window0Type0 endp

Window0Type1 proc C
	invoke crt_exit,0
	ret
Window0Type1 endp

Window0Type2 proc C
	ret
Window0Type2 endp

Window1Type0 proc C
	local middle1:DWORD

	;test
	;invoke crt_printf,addr szMiddle4Fmt,cdeg

	mov esi,0
	;循环
	ACT1:
	mov eax,pindeg[4*esi]
	sub eax,cdeg
	mov middle1,eax
	push esi
	invoke crt_abs,middle1
	pop esi
	;判断差距是否大于10
	.if eax < 10
		mov middle1,esi
		;pushad
		;invoke crt_printf,addr szMiddle3Fmt,esi
		;popad
		invoke cancelTimer,0
		invoke loadMenu,2
		ret
	.endif
	;循环判断
	inc esi
	cmp esi,modelInsertedPinNumber
	jl ACT1;<

	;未发生碰撞
	;进行变量的一些设置
	mov eax,cdeg
	mov ebx,modelInsertedPinNumber
	mov pindeg[ebx*4],eax

	dec pinnum

	inc modelInsertedPinNumber

	inc modelScore
	invoke FlushScore,modelScore

	;判断游戏是否结束
	.if pinnum == 0
		invoke cancelTimer,0
		invoke loadMenu,3
		ret
	.endif

	ret
Window1Type0 endp

Window1Type1 proc C
	invoke cancelTimer,0
	invoke loadMenu,0
	ret
Window1Type1 endp

Window1Type2 proc C
	ret
Window1Type2 endp

Window2Type0 proc C
	invoke Window0Type0
	ret
Window2Type0 endp

Window2Type1 proc C
	invoke loadMenu,0
	ret
Window2Type1 endp

Window3Type0 proc C
	inc modelNowDifficulty
	invoke InitWindow
	ret
Window3Type0 endp

Window3Type1 proc C
	invoke loadMenu,0
	ret
Window3Type1 endp

InitParam proc C
	mov modelScore,0
	mov modelNowDifficulty,5
	ret
InitParam endp

InitWindow proc C
	local middle1:DWORD,middle2:dword

	;设置随机数种子
	push 0
	call crt_time
	add esp,4
	push eax
	call crt_srand
	add esp,4

	;初始化cdeg
	invoke crt_rand
	mov edx,0
	mov ecx,360
	div ecx
	mov cdeg,edx
	;invoke crt_printf,addr szMiddle2Fmt,cdeg

	;初始化modelInsertedPinNumber
	mov eax,modelNowDifficulty
	mov modelInsertedPinNumber,eax 

	;初始化pindeg
	invoke crt_memset,addr pindeg,0,360

	lea eax,middle1
	;外循环，生成随机数
	mov esi,0
	ACT1:
	invoke crt_rand
	mov edx,0
	mov ecx,36
	div ecx
	mov eax,edx
	mov edx,0
	mov ebx,10
	mul ebx
	mov edx,eax
	mov middle1,edx
	
	;内循环，判断当前随机出来的随机数，是否出现过
	.if esi >= 1
		mov edi,0
		ACT2:
		cmp edx,dword ptr pindeg[4*edi]
		;如果相等，则返回ACT1，重新生成
		jz ACT1;=
		;如果不相等，则生成合法，继续执行，判断内循环是否结束
		inc edi
		cmp edi,esi
		jl ACT2;<
	.endif
	
	;从寄存器中移入内存s
	mov dword ptr pindeg[4*esi],edx
	mov middle1,edx
	;pushad
	;invoke crt_printf,addr szMiddle1Fmt,middle1
	;popad
	
	;外循环判断
	inc esi
	cmp esi,modelNowDifficulty
	jl ACT1 ;<跳转

	;初始化pinnum
	mov eax,modelNowDifficulty
	mov ebx,2
	mul ebx
	mov pinnum,eax

	;设置转速
	mov eax,modelNowDifficulty
	mov ebx,2
	mul ebx
	mov ebx,35
	sub ebx,eax
	;invoke crt_printf,addr szMiddle2Fmt,ebx
	mov modelOmega,ebx

	;载入页面
	pushad
	invoke initGameWindow,modelNowDifficulty,modelOmega
	popad

	
	;test
	;mov cdeg,100
	;invoke Window1Type0
	;
	;mov edi,4
	;mov eax,pindeg[edi]
	;mov cdeg,eax
	;
	;invoke Window1Type0
	
	ret
InitWindow endp

end