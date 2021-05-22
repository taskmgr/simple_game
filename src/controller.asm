.386
.model flat,stdcall
option casemap:none
includelib msvcrt.lib
includelib acllib.lib
include inc\acllib.inc

printf proto C :dword,:vararg

.data
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


end