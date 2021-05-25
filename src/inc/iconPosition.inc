;存放icon的位置

.data
menu_start_game_left dword 155
menu_start_game_right dword 395
menu_start_game_up dword 310
menu_start_game_bottom dword 410

;开始菜单的“退出游戏”按钮的坐标
menu_exit_game_left dword 155
menu_exit_game_right dword 396
menu_exit_game_up dword 460
menu_exit_game_bottom dword 560


;通关的这个界面好像和实际有点区别，可能得调整一下高度（宽度没问题）
;好耶，你通关了的房子
pass_game_house_left dword	155
pass_game_house_right dword 255
pass_game_house_up dword 365
pass_game_house_bottom dword 435

;好耶，你过关了的过关
pass_game_continue_left dword	325
pass_game_continue_right dword 395
pass_game_continue_up dword 365
pass_game_continue_bottom dword 435

;最终得分
;房子，返回主菜单
final_score_house_left dword	155
final_score_house_right dword 225
final_score_house_up dword 400
final_score_house_bottom dword 470

;最终得分的重新开始
final_score_restart_left dword	325
final_score_restart_right dword 395
final_score_restart_up dword 400
final_score_restart_bottom dword 470

;游戏界面的房子
gaming_house_left dword	60
gaming_house_right dword 120
gaming_house_up dword 35
gaming_house_bottom dword 95