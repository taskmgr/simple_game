; 得到当前的事件队列长度，为0时队列空
; 得到当前鼠标的坐标
;mouseEvent proto C:DWORD,:DWORD,:DWORD,:DWORD

;iface_mouseEvent proc C x:dword,y:dword,button:dword,event:dword
extrn iface_mouseEvent:proc
