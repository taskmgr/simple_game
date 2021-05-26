;参考的模块格式
.386
.model flat,stdcall
option casemap:none

.data
szMsg3 byte "FROM module:Hello!!World!!!",0
MessageBoxA PROTO :dword, :dword, :dword, :word

.code
;参考的注释格式
;@brief:显示一个消息框
;@param msg1:要显示的消息内容
;@return:恒返回0
mymsg proc C msg1:dword
	invoke MessageBoxA, 0,msg1,offset szMsg3,0
	mov eax,0
	ret
mymsg endp


end mymsg