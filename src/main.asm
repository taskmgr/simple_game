.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib


include inc\acllib.inc
include inc\sharedVar.inc
include inc\controller.inc

printf proto c:dword,:vararg
mouseEvent proto C:DWORD,:DWORD,:DWORD,:DWORD

.data
hello sbyte	"hello",0
coord sbyte "%d,%d",10,0


.code

iface_mouseEvent proc C x:dword,y:dword,button:dword,event:dword
	mov ecx,event
	cmp ecx,BUTTON_DOWN
	jne not_click

		invoke printf,offset coord,x,y

	not_click:
	ret 
iface_mouseEvent endp

main proc;梦开始的地方

	invoke	init_first
	invoke	initWindow,offset hello,DEFAULT,DEFAULT,500,500
	push	iface_mouseEvent
	call registerMouseEvent
	add esp,4
	invoke	init_second

	ret
main endp


end main