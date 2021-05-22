.386
.model flat,stdcall
option casemap:none

includelib msvcrt.lib
includelib acllib.lib


include inc\acllib.inc
include inc\sharedVar.inc
include inc\controller.inc

printf proto c:dword,:vararg

.data
hello sbyte	"hello",0

.code

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