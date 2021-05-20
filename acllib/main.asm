;
.386
.model flat,stdcall
option casemap:none

INCLUDELIB msvcrt.lib
INCLUDELIB acllib.lib
include acllib.inc
include module.inc

printf	PROTO C:ptr sbyte, :VARARG



.data
szMsg byte "Hello!!World!!!",0ah,0
szMsg2 byte "Hello!!World!!!%d",0


.code
main proc
	 invoke mymsg,offset szMsg
	 invoke init_first ;先调用这个，初始化环境
	 invoke initWindow, offset szMsg,900,100,300,300 ;然后初始化窗口，就一次
	 invoke beginPaint;然后开始画画
	 invoke paintText,0,0,addr szMsg
	 invoke endPaint;结束画画；可以出现若干次beginpaint、endpaint
	 invoke init_second ;启动事件循环
;	 invoke MessageBoxA, 0,offset szMsg,offset szMsg,0
	 mov eax,0
	 ret
main endp
end main