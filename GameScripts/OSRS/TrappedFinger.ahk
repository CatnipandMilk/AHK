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
;@Ahk2Exe-SetName Trapped Finger
;@Ahk2Exe-SetDescription Trapped Finger - Taps in a Box.
;@Ahk2Exe-SetCopyright Catnipandmilk © 2022
;@Ahk2Exe-SetCompanyName Catnip and Milk


#SingleInstance force
CoordMode, Mouse, Screen
SetKeyDelay -1
SetMouseDelay 0
SetBatchLines -1

isClicking:=False

Gui, a: New, hwndhGui AlwaysOnTop +Resize MinSize250x100
Gui, Add, Button, Section w100 yp+20 x+10 gStartClicking, Start Alt+1
Gui, Add, Button, w100 yp x+10 gStopClicking, Stop Alt+2
Gui, Add, Text,Center xs+10 w200, `nHold Alt+Left click to select an area`n`nTrapped Finger will randomly click inside the box at random intervals.

Gui, Add, Text, xs vStatus w120, Idle

Gui, Add, Link, xs, <a href="https://www.Catnipandmilk.com">Catnip and Milk</a>`

Gui, Show,, Trapped Finger
OnMessage(0x112, "WM_SYSCOMMAND")
return

ClickTimer:
loop
 {
	if (!isClicking) {
		Tooltip, Stopped!
		Sleep, 1000
		Tooltip
		return
	}
	Random, newX, x1,x2
	Random, newY, y1,y2
	MouseMove, newX, newY
	Random, var, 839, 1986
	Sleep, %var%
	
	Click
	delay := DelaySecondsMin*1000
	Sleep, delay
}
return

!1::
StartClicking:
Gui, a: Submit, Nohide
if (!isClicking) {
	isClicking:=True
	Settimer, ClickTimer, -1
	UpdateText("Status", "Clicking inside the box!")
}
return

!2::
StopClicking:
Gui, a: Submit, Nohide
isClicking:=False
UpdateText("Status", "Idle")
return

UpdateText(ControlID, NewText)
{
	static OldText := {}
	global hGui
	if (OldText[ControlID] != NewText)
	{
		GuiControl, %hGui%:, % ControlID, % NewText
		OldText[ControlID] := NewText
	}
}


WM_SYSCOMMAND(wp, lp, msg, hwnd)  {
   static SC_CLOSE := 0xF060
   if (wp != SC_CLOSE)
      Return
   
   ExitApp
}

marker(X:=0, Y:=0, W:=0, H:=0)
{
T:=3,
w2:=W-T,
h2:=H-T

Gui marker: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
Gui marker: Color, Aqua ;Color
Gui marker: Show, w%W% h%H% x%X% y%Y% NA

WinSet, Transparent, 150
WinSet, Region, 0-0 %W%-0 %W%-%H% 0-%H% 0-0 %T%-%T% %w2%-%T% %w2%-%h2% %T%-%h2% %T%-%T%
Return
}

!LButton::
Tooltip
WinGetPos XN, YN, , , A
MouseGetPos x1, y1
While GetKeyState("LButton","P") {
   MouseGetPos x2, y2
   x:= (x1<x2)?(x1):(x2)
   y:= (y1<y2)?(y1):(y2)
   
   w:= Abs(x2-x1), h:= Abs(y2-y1)
   marker(x, y, w, h)
   if (w >= 100 || h >= 100) {
	   break
   }
}
if (x2<x1) {
	tempX := x2
	x2 := x1
	x1 := tempX
}
if (y2<y1) {
	tempY := y2
	y2 := y1
	y1 := tempy
}
Return