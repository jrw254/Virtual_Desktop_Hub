#NoEnv
#SingleInstance, Force
#Persistent
SetWorkingDir %A_ScriptDir%


#Include .\VDHub_Func.ahk
;===========================================
CustomColor = EEAA99
vdesk := false
vdGUI_pos := "x12 y740" ; Position of "VD Hub On" GUI

Gui vdesk: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui, Color, 69369C
Gui, Font, s9, Arial Bold
Gui, Add, Text,, VD Hub ON
WinSet, Transcolor, %CustomColor% 250

;============================================
~RShift & /::	; Toggle VDHub on/off
vdesk := !vdesk
if (vdesk)
 Gui, Vdesk: show, % vdGUI_pos, NoActivate
else
 gui, Vdesk: hide
return

/* List of Functions
OnTogglePinWindowPress()
OnTogglePinAppPress()
OnTogglePinOnTopPress()
GoToDesktopNumber()
MoveCurrentWindowToDesktop()
windowToCurrentVirtualDesktop("WinTitle")

HideTrayTip()

LeftVirtDesk()
RightVirtDesk()
NewVirtDesk()
DestroyVirtDesk()

*/


#If (vdesk)

;==============;
; Aux Controls ;
;==============;
NumpadDot::Send #{Tab}	; Windows + tab
NumpadEnter:: Send ^{Tab}	; Control + tab
NumpadSub:: WinHide ahk_class Shell_TrayWnd	; Hide Taskbar
NumpadAdd:: WinShow ahk_class Shell_TrayWnd	; Show Taskbar


;===================;
; Navigate Desktops ;
;===================;
Numpad1::GoToDesktopNumber(0)	; VD 1
Numpad2::GoToDesktopNumber(1)	; VD 2
Numpad3::GoToDesktopNumber(2)	; VD 3
Numpad4::GoToDesktopNumber(3)	; VD 4
Numpad5::GoToDesktopNumber(4)	; VD 5
Numpad6::GoToDesktopNumber(5)	; VD 6
Numpad7::GoToDesktopNumber(6)	; VD 7
Numpad8::GoToDesktopNumber(7)	; VD 8
Numpad9::GoToDesktopNumber(8)	; VD 9
Numpad0::GoToDesktopNumber(9)	; VD 10


;========================================================;
; Move to-from Virtual Desktop, send away without moving ;
;========================================================;
!Numpad1::MoveCurrentWindowToDesktop(0) ; VD1
!Numpad2::MoveCurrentWindowToDesktop(1)
!Numpad3::MoveCurrentWindowToDesktop(2)
!Numpad4::MoveCurrentWindowToDesktop(3)
!Numpad5::MoveCurrentWindowToDesktop(4)
!Numpad6::MoveCurrentWindowToDesktop(5)
!Numpad7::MoveCurrentWindowToDesktop(6)
!Numpad8::MoveCurrentWindowToDesktop(7)
!Numpad9::MoveCurrentWindowToDesktop(8)
!Numpad0::MoveCurrentWindowToDesktop(9)


/*
;===========================================;
; Move from-to Current Desktop, by WinTitle ;
;===========================================;
*/
;~ ^#Numpad0::
;~ windowToCurrentVirtualDesktop("WinTitle")

/*

Below is an alternative to windowToCurrentVirtualDesktop("WinTitle").
By using an inputbox to type in windows to bring forward.

*/
NumpadDiv::
 SetTitleMatchMode, 2
  InputBox, wintitle, Put Window Title Here, ,, 215, 111	; Type partial name of the window titile to bring to current window. Case sensitive
  windowToCurrentVirtualDesktop(wintitle)
 return



#If




