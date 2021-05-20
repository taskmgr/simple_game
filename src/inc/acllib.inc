
ifndef __ACLLIB_H__
__ACLLIB_H__	EQU	<>
	include Windows.inc
BLACK	EQU	<RGB ( 0 , 0 , 0 )>
RED	EQU	<RGB ( 255 , 0 , 0 )>
GREEN	EQU	<RGB ( 0 , 255 , 0 )>
BLUE	EQU	<RGB ( 0 , 0 , 255 )>
CYAN	EQU	<RGB ( 0 , 255 , 255 )>
MAGENTA	EQU	<RGB ( 255 , 0 , 255 )>
YELLOW	EQU	<RGB ( 255 , 255 , 0 )>
WHITE	EQU	<RGB ( 255 , 255 , 255 )>
EMPTY	EQU	0ffffffffh
DEFAULT	EQU	- 1
ACL_Pen_Style typedef DWORD
PEN_STYLE_SOLID = 0
PEN_STYLE_DASH = 1
PEN_STYLE_DOT = 2
PEN_STYLE_DASHDOT = 3
PEN_STYLE_DASHDOTDOT = 4
PEN_STYLE_NULL = 5

ACL_Brush_Style typedef DWORD
BRUSH_STYLE_SOLID = - 1 
BRUSH_STYLE_HORIZONTAL = 2
BRUSH_STYLE_VERTICAL = 3
BRUSH_STYLE_FDIAGONAL = 4
BRUSH_STYLE_BDIAGONAL = 5
BRUSH_STYLE_CROSS = 6
BRUSH_STYLE_DIAGCROSS = 7
BRUSH_STYLE_NULL = 8

ACL_Mouse_Button typedef DWORD
NO_BUTTON = 0 
LEFT_BUTTON = 1
MIDDLE_BUTTON = 2
RIGHT_BUTTON = 3

ACL_Mouse_Event typedef DWORD
BUTTON_DOWN = 0
BUTTON_DOUBLECLICK = 1
BUTTON_UP = 2
ROLL_UP = 3
ROLL_DOWN = 4
MOUSEMOVE = 5

ACL_Keyboard_Event typedef DWORD
KEY_DOWN = 0
KEY_UP = 1

ACL_Image	struct 
hbitmap	HBITMAP	?
width_	DWORD	?
height	DWORD	?
ACL_Image	ends

ACL_Color typedef COLORREF
ACL_Sound typedef DWORD
proto_KeyboardEventCallback typedef proto C  :DWORD,:DWORD
KeyboardEventCallback typedef ptr proto_KeyboardEventCallback
proto_CharEventCallback typedef proto C  :SBYTE
CharEventCallback typedef ptr proto_CharEventCallback
proto_MouseEventCallback typedef proto C  :DWORD,:DWORD,:DWORD,:DWORD
MouseEventCallback typedef ptr proto_MouseEventCallback
proto_TimerEventCallback typedef proto C  :DWORD
TimerEventCallback typedef ptr proto_TimerEventCallback
myprog proto C
init_first proto C
init_second proto C  
msgBox proto C  :ptr SBYTE, :ptr SBYTE, :DWORD
initWindow proto C  :ptr SBYTE, :DWORD, :DWORD, :DWORD, :DWORD
registerKeyboardEvent proto C  :KeyboardEventCallback
registerCharEvent proto C  :CharEventCallback
registerMouseEvent proto C  :MouseEventCallback
registerTimerEvent proto C  :TimerEventCallback
startTimer proto C  :DWORD, :DWORD
cancelTimer proto C  :DWORD
loadSound proto C  :ptr SBYTE, :ptr ACL_Sound
playSound proto C  :ACL_Sound, :DWORD
stopSound proto C  :ACL_Sound
beginPaint proto C  
endPaint proto C  
clearDevice proto C  
getWidth proto C  
getHeight proto C  
setPenColor proto C  :ACL_Color
setPenWidth proto C  :DWORD
setPenStyle proto C  :ACL_Pen_Style
setBrushColor proto C  :ACL_Color
setBrushStyle proto C  :ACL_Brush_Style
setTextColor proto C  :ACL_Color
setTextBkColor proto C  :ACL_Color
setTextSize proto C  :DWORD
setTextFont proto C  :ptr SBYTE
paintText proto C  :DWORD, :DWORD, :ptr SBYTE
setCaretSize proto C  :DWORD, :DWORD
setCaretPos proto C  :DWORD, :DWORD
showCaret proto C  
hideCaret proto C  
putPixel proto C  :DWORD, :DWORD, :ACL_Color
getPixel proto C  :DWORD, :DWORD
getX proto C  
getY proto C  
moveTo proto C  :DWORD, :DWORD
moveRel proto C  :DWORD, :DWORD
arc proto C  :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
line proto C  :DWORD, :DWORD, :DWORD, :DWORD
lineTo proto C  :DWORD, :DWORD
lineRel proto C  :DWORD, :DWORD
polyBezier proto C  :ptr POINT, :DWORD
polyLine proto C  :ptr POINT, :DWORD
chrod proto C  :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
ellipse proto C  :DWORD, :DWORD, :DWORD, :DWORD
pie proto C  :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
polygon proto C  :ptr POINT, :DWORD
rectangle proto C  :DWORD, :DWORD, :DWORD, :DWORD
roundrect proto C  :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
loadImage proto C  :ptr SBYTE, :ptr ACL_Image
freeImage proto C  :ptr ACL_Image
putImage proto C  :ptr ACL_Image, :DWORD, :DWORD
putImageScale proto C  :ptr ACL_Image, :DWORD, :DWORD, :DWORD, :DWORD
putImageTransparent proto C  :ptr ACL_Image, :DWORD, :DWORD, :DWORD, :DWORD, :ACL_Color
initConsole proto C  
endif 
