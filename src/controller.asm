.386
.model flat,stdcall
option casemap:none
includelib msvcrt.lib
includelib acllib.lib
include inc\acllib.inc
include inc\sharedVar.inc
include inc\iconPosition.inc
include inc\view.inc
include inc\msvcrt.inc
include inc\model.inc

printf proto C :dword,:vararg

.data
coord sbyte "%d,%d",10,0
now_window sbyte "current Window: %d",10,0

.code
	;判断点击的坐标是否在矩形框内，是返回1，不是则返回0,注意，bottom一般比up大，因为这个是人眼看到的底部，而windows坐标系是左上角为0
	is_inside_the_rect proc C x:dword,y:dword,left:dword,right:dword,up:dword,bottom:dword
		mov eax,x
		mov ebx,y
		.if	eax <= left
			mov eax,0
		.elseif	eax >= right
			mov eax,0
		.elseif ebx >= bottom
			mov eax,0
		.elseif ebx <= up
			mov eax,0
		.else	
			mov eax,1
		.endif	
		ret
	is_inside_the_rect endp

	iface_mouseEvent proc C x:dword,y:dword,button:dword,event:dword
		mov ecx,event
		cmp ecx,BUTTON_DOWN
		jne not_click
			

			invoke	printf,offset now_window,currWindow ;现在所处的界面

			.if	currWindow == 0;开始菜单
				;开始菜单的开始键
				invoke is_inside_the_rect,x,y,menu_start_game_left,menu_start_game_right,menu_start_game_up,menu_start_game_bottom
					.if eax == 1
						
						invoke printf,offset coord,x,y ;点击了开始键后的事件
						invoke KeyboardEvent,0
					.endif


				;开始菜单的退出键
				invoke is_inside_the_rect,x,y,menu_exit_game_left,menu_exit_game_right,menu_exit_game_up,menu_exit_game_bottom
					.if eax == 1

						invoke printf,offset coord,x,y ;点击了后的事件
						invoke KeyboardEvent,1
					.endif

			.elseif currWindow == 1 ;游戏主界面
				invoke is_inside_the_rect,x,y,gaming_house_left,gaming_house_right,gaming_house_up,gaming_house_bottom
					.if eax == 1
						
						invoke printf,offset coord,x,y ;点击了房子
						invoke KeyboardEvent,1
					.endif
					;action
					;	其他情况都发射针
						invoke KeyboardEvent,0

			.elseif currWindow == 2 ;最终得分
				invoke is_inside_the_rect,x,y,final_score_house_left,final_score_house_right,final_score_house_up,final_score_house_bottom
					.if eax == 1
						
						invoke printf,offset coord,x,y ;点击了房子
						invoke KeyboardEvent,1
					.endif

				invoke is_inside_the_rect,x,y,final_score_restart_left,final_score_restart_right,final_score_restart_up,final_score_restart_bottom
					.if eax == 1

						invoke printf,offset coord,x,y ;点击了重新开始
						invoke KeyboardEvent,0
					.endif

			.elseif	currWindow == 3 ;好耶，你通关了！
				
				;房子，返回主菜单
				invoke is_inside_the_rect,x,y,pass_game_house_left,pass_game_house_right,pass_game_house_up,pass_game_house_bottom
					.if eax == 1

						invoke printf,offset coord,x,y ;点击了后的事件
						invoke KeyboardEvent,1
					.endif

				;重新开始游戏
				invoke is_inside_the_rect,x,y,pass_game_continue_left,pass_game_continue_right,pass_game_continue_up,pass_game_continue_bottom
					.if eax == 1
						
						invoke printf,offset coord,x,y ;点击了后的事件
						invoke KeyboardEvent,0
					.endif
			
			.endif



		not_click:
		ret 
	iface_mouseEvent endp


end