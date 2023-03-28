#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MouseGetPos, xpos, ypos
#Persistent
ToolTip, ARK AutoRun`nToggle with CapsLock
SetTimer, RemoveToolTip, -5000
return

RemoveToolTip:
ToolTip
return

#If WinActive("ARK: Survival Evolved")
CapsLock::Send, % "{w " . ((Toggle := !Toggle) ? "down}" : "up}")