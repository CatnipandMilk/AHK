#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;	░█████╗░░█████╗░████████╗███╗░░██╗██╗██████╗░
;	██╔══██╗██╔══██╗╚══██╔══╝████╗░██║██║██╔══██╗
;	██║░░╚═╝███████║░░░██║░░░██╔██╗██║██║██████╔╝
;	██║░░██╗██╔══██║░░░██║░░░██║╚████║██║██╔═══╝░
;	╚█████╔╝██║░░██║░░░██║░░░██║░╚███║██║██║░░░░░
;	░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚══╝╚═╝╚═╝░░░░░
;	░█████╗░███╗░░██╗██████╗░
;	██╔══██╗████╗░██║██╔══██╗
;	███████║██╔██╗██║██║░░██║
;	██╔══██║██║╚████║██║░░██║
;	██║░░██║██║░╚███║██████╔╝
;	╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░
;	███╗░░░███╗██╗██╗░░░░░██╗░░██╗░░░░█████╗░░█████╗░███╗░░░███╗
;	████╗░████║██║██║░░░░░██║░██╔╝░░░██╔══██╗██╔══██╗████╗░████║
;	██╔████╔██║██║██║░░░░░█████═╝░░░░██║░░╚═╝██║░░██║██╔████╔██║
;	██║╚██╔╝██║██║██║░░░░░██╔═██╗░░░░██║░░██╗██║░░██║██║╚██╔╝██║
;	██║░╚═╝░██║██║███████╗██║░╚██╗██╗╚█████╔╝╚█████╔╝██║░╚═╝░██║
;	╚═╝░░░░░╚═╝╚═╝╚══════╝╚═╝░░╚═╝╚═╝░╚════╝░░╚════╝░╚═╝░░░░░╚═╝
; 
;@Ahk2Exe-SetName CensorBox.exe
;@Ahk2Exe-SetDescription Creates a resizeable and colorable box.
;@Ahk2Exe-SetCopyright CatnipandMilk © 2023
;@Ahk2Exe-SetCompanyName Catnip and Milk

; Name:           CENSOR BOX 
; Description:    Hide parts of the screen with a colored box
; credits:        Speedmaster, Lexikos, flyingDman, rommmcek, MancioDellaVega, CatnipandMilk
; Topic:          https://www.autohotkey.com/boards/viewtopic.php?f=6&t=78160
; Sript version:  1.5
; AHK Version:    1.1.24.03 (A32/U32/U64)
; Tested on:      Win 7, Win 10 
; shortcuts::     F1 add a new box
;                 F2 color the box with the top left pixel
;                 F2 Long press (> 0.6 sec) highlight box in red
;                 F3 freeze/unfreeze all boxes
;                 F4 remove selected box
;                 F5 hide/show all boxes
;                 F6 make current box semi transparent
;                 F12 Open in the shortcuts menu
;                 CTRL+F12 = exit script
;                 Shift + Left Button show x-cross
;                 Shift Up (while LButton down) to start drawing rectangle
;                 All boxes are resizable

#SingleInstance force

OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x84, "WM_NCHITTEST")
OnMessage(0x83, "WM_NCCALCSIZE")
OnMessage(0x86, "WM_NCACTIVATE")
CoordMode, pixel, screen
CoordMode, mouse, screen

; Message box
msgbox, F1: New Box`nF2: Color Box w/ Top left pixel`nF2 Long press (> 0.6 sec) highlight box in red`nF3: Freeze/Unfreeze all boxes`nF4: Remove selected box`nF5: Hide/Show all boxes`nF6: Make current box semi-transparent`nF12: Open this window`nCTRL+F12 = exit script`n`nShift + Left Button show x-cross`nShift Up (while LButton down) to start drawing rectangle`nAll boxes are resizable.`n`nwww.CatnipandMilk.com


BW := 2           				; Border width (and height) in pixels
BC := "FF8800"       			; Border color
FirstCall := True
Gui, -Caption  +LastFound +AlwaysOnTop
Gui, Color, %BC%

Gui, Cross1: -Caption +AlwaysOnTop 
Gui, Cross1: Color, % bc
Gui, Cross2: -Caption +AlwaysOnTop 
Gui, Cross2: Color, % bc
count:= 0
Return

+LButton::
While GetKeyState("Shift", "P") {
    MouseGetPos, OriginX, OriginY
    ;OriginX-=8, OriginY-=5
    Gui, Cross1: show, % "NA y0 w1 x" OriginX " h" A_ScreenHeight
    Gui, Cross2: show, % "NA x0 h1 y" OriginY " w" A_ScreenWidth
    Sleep, 10
}
Gui, Cross1: Hide
Gui, Cross2: Hide
if !GetKeyState("LButton", "P")
    Return
WinGetActiveStats, Title, WindowWidth, WindowHeight, WindowX, WindowY
SetTimer, DrawRectangle, 20
Return

DrawRectangle: ; thx flyingDman
MouseGetPos, X2, Y2
Gui, +LastFound

X2<OriginX? (X1:=X2, X2:=OriginX): X1:=OriginX, Y2<OriginY? (Y1:=Y2, Y2:=OriginY): Y1:=OriginY
W1 := X2 - X1, H1 := Y2 - Y1, W2 := W1 - BW, H2 := H1 - BW
WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0 %BW%-%BW% %W2%-%BW% %W2%-%H2% %BW%-%H2% %BW%-%BW%
If (FirstCall) {
    Gui, Show, NA x%X1% y%Y1% w%W1% h%H1%
	FirstCall := False
}
else WinMove, , , X1, Y1, W1, H1
Return

+LButton Up::
SetTimer, DrawRectangle, Off
Gui, Cancel
FirstCall := True
if GetKeyState("Shift", "P")
    Return
newbox:
count++
Gui box_%count%: -caption -DPIScale +AlwaysOnTop +resize ;+LabelGui +LastFound
        Gui box_%count%: Margin, 0,0
Gui box_%count%: color, black
Gui box_%count%: show, % "NA x" X1 " y" Y1 " w" W1-16 " h" H1-16, box_%count% ; offset (-16) might be PC/OS specific
currentgui:="box_" count
return

f1::
w1:=100
h1:=100
x1:=a_screenwidth//2-w1//2
y1:=a_screenheight//2-h1//2
goto newbox
return

F2::
    transparency:=100  ; 0-255 level of transparency (0 =Transparent , 255=full visibile)

    KeyWait, F2, U T0.6    ; Long press (> 0.6 sec) 
    If ErrorLevel   
    {
        Gui,%currentgui%: +LastFound
        WinSet,Transparent,%transparency% ; Set Box to transparency
        Gui, %currentgui%:Color, FF0000
    }
	else
	{
        WinGetPos,px,py,,, %currentgui%
        PixelGetColor, outcolor, % px-1, % py-1, RGB
        Gui,%currentgui%: +LastFound
        WinSet,Transparent,255 ; Set Box to No transparency
        Gui %currentgui%: color, % outcolor
    }
    
    KeyWait, F2, U T0.6   ;Wait no more than 0.6 sec for key release (also suppress auto-repeat)
return


f3::
freeze:=!freeze
if freeze
    loop, % count
        gui box_%a_index%: -resize
else
    loop, % count
        gui box_%a_index%: +resize
return

f4::
gui %currentgui%: Destroy ; Thx MancioDellaVega
return

F5::
hide:=!hide
if hide
    loop, % count {
            Gui, box_%a_index%:Default
            gui box_%a_index% : -caption
            gui box_%a_index%: hide   
        }
else
    loop, % count {
            Gui, box_%a_index%:Default
            GuiGetPos( X,Y,W,H, "box_" a_index )
            gui box_%a_index%: show
            WinMove, box_%a_index%,,x,y,w,h
        }
return

f6::
        transparency:=100  ; 0-255 level of transparency (0 =Transparent , 255=full visibile)
trans:=!Trans
if trans 
    {
        Gui,%currentgui%: +LastFound
        WinSet,Transparent, %transparency% ; Set Box to transparency
    }
    else {
        Gui,%currentgui%: +LastFound
        WinSet,Transparent, 255
    }
return


F12::
    MsgBox, F1: New Box`nF2: Color Box w/ Top left pixel`nF2 Long press (> 0.6 sec) highlight box in red`nF3: Freeze/Unfreeze all boxes`nF4: Remove selected box`nF5: Hide/Show all boxes`nF6: Make current box semi-transparent`nF12: Open this window`nCTRL+F12 = Exit script`n`nShift + Left Button show x-cross`nShift Up (while LButton down) to start drawing rectangle`nAll boxes are resizable.`n`nwww.CatnipandMilk.com
return


WM_LBUTTONDOWN() {
    global currentgui, freeze
    MouseGetPos, xpos, ypos 
¬:= (A_Gui) && currentgui:=a_gui
¬:= (A_Gui) && (!freeze)  && move()
}

move() { 
	PostMessage, 0xA1, 2 ; WM_NCLBUTTONDOWN
}

; thx Lexikos
; https://autohotkey.com/board/topic/23969-resizable-window-border/
; Sizes the client area to fill the entire window.
WM_NCCALCSIZE()
{
    if A_Gui
        return 0
}

; Prevents a border from being drawn when the window is activated.
WM_NCACTIVATE()
{
    if A_Gui
        return 1
}

; Redefine where the sizing borders are.  This is necessary since
; returning 0 for WM_NCCALCSIZE effectively gives borders zero size.
WM_NCHITTEST(wParam, lParam)
{
    static border_size = 6
    
    if !A_Gui
        return
    
    WinGetPos, gX, gY, gW, gH
    
    x := lParam<<48>>48, y := lParam<<32>>48
    
    hit_left    := x <  gX+border_size
    hit_right   := x >= gX+gW-border_size
    hit_top     := y <  gY+border_size
    hit_bottom  := y >= gY+gH-border_size
    
    if hit_top
    {
        if hit_left
            return 0xD
        else if hit_right
            return 0xE
        else
            return 0xC
    }
    else if hit_bottom
    {
        if hit_left
            return 0x10
        else if hit_right
            return 0x11
        else
            return 0xF
    }
    else if hit_left
        return 0xA
    else if hit_right
        return 0xB
    
    ; else let default hit-testing be done
}


;thx VxE's , Icarus
GuiGetPos( ByRef X, ByRef Y, ByRef W, ByRef H, GuiID=1 ) {
	Gui %GuiID%:+LastFound Exist
	IfWinExist
	{
		WinGetPos X, Y
		VarSetCapacity( rect, 16, 0 )
		DllCall("GetClientRect", uint, MyGuiHWND := WinExist(), uint, &rect )
		W := NumGet( rect, 8, "int" )
		H := NumGet( rect, 12, "int" )
	}
}


return
guiclose:
^F12::
exitapp

