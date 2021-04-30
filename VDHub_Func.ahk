; JRW's FC (Forked & Cobbled) VirtualDesktopAccessor.dll 
;
;Combined the entire contents of VirtualDesktopAccessor.dll: https://github.com/Ciantic/VirtualDesktopAccessor (Just used the example)
;Took one function {Move Windows Around} from Mr. Doge's script here: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=82994
;Used a function from Windows Desktop Switcher by pmb6tz (Toggle Pin/Unpin Windows&Apps): https://github.com/pmb6tz/windows-desktop-switcher/issues/55
;Add the GUI's myself. They can be and are encouraged to be changed to your liking. Just a simple templete I quickly used and repeated. 
;
; You'll need the actual VirtualDesktopAccessor.dll and you'll need to point hVirtualDesktopAccessor DLLCall to the actual file path of the VirtualDesktopAccessor.dll if for any reason it does not work..
; You can find it on Line 86. hVirtualDesktopAccessor := DllCall("LoadLibrary", Str, "<YourFilePath>\VirtualDesktopAccessor.dll", "Ptr")
;Line 162 is where you will change the coordinates for the GUI.
CustomColor = FFF666

{ ; GUI's Below 1- 10

Gui VDM1: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 1
        WinSet, Transcolor, %CustomColor% 100
		
Gui VDM2: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 2
        WinSet, Transcolor, %CustomColor% 100
		
Gui VDM3: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 3
        WinSet, Transcolor, %CustomColor% 100
		
Gui VDM4: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 4
        WinSet, Transcolor, %CustomColor% 100

Gui VDM5: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 5
        WinSet, Transcolor, %CustomColor% 100
		
Gui VDM6: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 6
        WinSet, Transcolor, %CustomColor% 100
		
Gui VDM7: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 7
        WinSet, Transcolor, %CustomColor% 100
		
Gui VDM8: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 8
        WinSet, Transcolor, %CustomColor% 100
		
Gui VDM9: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 9
        WinSet, Transcolor, %CustomColor% 100
		
Gui VDM10: new, +LastFound +AlwaysOnTop -Caption +ToolWindow
        Gui, Color, Yellow
        Gui, Font, s9, Arial Bold
        Gui, Add, Text,, Desktop 10
        WinSet, Transcolor, %CustomColor% 100

}


;===

;===

DetectHiddenWindows, On
hwnd:=WinExist("ahk_pid " . DllCall("GetCurrentProcessId","Uint"))
hwnd+=0x1000<<32

hVirtualDesktopAccessor := DllCall("LoadLibrary", Str, ".\VirtualDesktopAccessor.dll", "Ptr") 
GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
IsWindowOnCurrentVirtualDesktopProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnCurrentVirtualDesktop", "Ptr")
MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")
RegisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "RegisterPostMessageHook", "Ptr")
UnregisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnregisterPostMessageHook", "Ptr")
IsPinnedWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedWindow", "Ptr")
RestartVirtualDesktopAccessorProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "RestartVirtualDesktopAccessor", "Ptr")
GetWindowDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetWindowDesktopNumber", "Ptr")
activeWindowByDesktop := {}

; Restart the virtual desktop accessor when Explorer.exe crashes, or restarts (e.g. when coming from fullscreen game)
explorerRestartMsg := DllCall("user32\RegisterWindowMessage", "Str", "TaskbarCreated")
OnMessage(explorerRestartMsg, "OnExplorerRestart")
OnExplorerRestart(wParam, lParam, msg, hwnd) {
    global RestartVirtualDesktopAccessorProc
    DllCall(RestartVirtualDesktopAccessorProc, UInt, result)
}

MoveCurrentWindowToDesktop(number) {
	global MoveWindowToDesktopNumberProc, activeWindowByDesktop ;GoToDesktopNumberProc, 
	WinGet, activeHwnd, ID, A
	activeWindowByDesktop[number] := 0 ; Do not activate
	DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, number)
	;DllCall(GoToDesktopNumberProc, UInt, number)
}

GoToPrevDesktop() {
	global GetCurrentDesktopNumberProc, GoToDesktopNumberProc
	current := DllCall(GetCurrentDesktopNumberProc, UInt)
	if (current = 0) {
		GoToDesktopNumber(9)
	} else {
		GoToDesktopNumber(current - 1)      
	}
	return
}

GoToNextDesktop() {
	global GetCurrentDesktopNumberProc, GoToDesktopNumberProc
	current := DllCall(GetCurrentDesktopNumberProc, UInt)
	if (current = 9) {
		GoToDesktopNumber(0)
	} else {
		GoToDesktopNumber(current + 1)    
	}
	return
}

GoToDesktopNumber(num) {
	global GetCurrentDesktopNumberProc, GoToDesktopNumberProc, IsPinnedWindowProc, activeWindowByDesktop

	; Store the active window of old desktop, if it is not pinned
	WinGet, activeHwnd, ID, A
	current := DllCall(GetCurrentDesktopNumberProc, UInt) 
	isPinned := DllCall(IsPinnedWindowProc, UInt, activeHwnd)
	if (isPinned == 0) {
		activeWindowByDesktop[current] := activeHwnd
	}

	; Try to avoid flashing task bar buttons, deactivate the current window if it is not pinned
	if (isPinned != 1) {
		WinActivate, ahk_class Shell_TrayWnd
	}

	; Change desktop
	DllCall(GoToDesktopNumberProc, Int, num)
	return
}

; Windows 10 desktop changes listener
DllCall(RegisterPostMessageHookProc, Int, hwnd, Int, 0x1400 + 30)
OnMessage(0x1400 + 30, "VWMess")
VWMess(wParam, lParam, msg, hwnd) {
	global IsWindowOnCurrentVirtualDesktopProc, IsPinnedWindowProc, activeWindowByDesktop
	vdeGUI_pos := "x1080 y740"
	desktopNumber := lParam + 1
	
	; Try to restore active window from memory (if it's still on the desktop and is not pinned)
	WinGet, activeHwnd, ID, A 
	isPinned := DllCall(IsPinnedWindowProc, UInt, activeHwnd)
	oldHwnd := activeWindowByDesktop[lParam]
	isOnDesktop := DllCall(IsWindowOnCurrentVirtualDesktopProc, UInt, oldHwnd, Int)
	if (isOnDesktop == 1 && isPinned != 1) {
		WinActivate, ahk_id %oldHwnd%
	}

	; Menu, Tray, Icon, Icons/icon%desktopNumber%.ico
	
	; When switching to desktop 1
	 if (lParam == 0) {
		Gui, VDM1: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}
		}else{
		Gui, VDM1: hide
	}
		; 
	; 
	 if (lParam == 1) {
		Gui, VDM2: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}
	}else{
		Gui, VDM2: hide
}
		; 
	; 
	 if (lParam == 2) { ;|| lParam == 3
		Gui, VDM3: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}
	}else{
		Gui, VDM3:hide
}
	if (lParam == 3) {
		Gui, VDM4: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}
	}else{
		Gui, VDM4: hide
}
	if (lParam == 4) {
		Gui, VDM5: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}		
		}else{
		Gui, VDM5: hide	
	}
	if (lParam == 5) {
		Gui, VDM6: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}
	}else{
		Gui, VDM6: hide
}	

	if (lParam == 6) {
		Gui, VDM7: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}
	}else{
		Gui, VDM7: hide
}

	if (lParam == 7) {
		Gui, VDM8: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}
	}else{
		Gui, VDM8: hide
}

	if (lParam == 8) {
		Gui, VDM9: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}
	}else{
		Gui, VDM9: hide
}
		
	if (lParam == 9) {
		Gui, VDM10: show, % vdeGUI_pos, NoActivate
		SendInput, !{esc}
	}else{
		Gui, VDM10: hide
}
		

}

;===============================================================;
;  https://www.autohotkey.com/boards/viewtopic.php?f=6&t=82994  ;
;===============================================================;
IServiceProvider := ComObjCreate("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{6D5140C1-7436-11CE-8034-00AA006009FA}")
IVirtualDesktopManagerInternal := ComObjQuery(IServiceProvider, "{C5E0CDCA-7B6E-41B2-9FC4-D93975CC467B}", "{F31574D6-B682-4CDC-BD56-1827860ABEC6}")
MoveViewToDesktop := vtable(IVirtualDesktopManagerInternal, 4) ; void MoveViewToDesktop(object pView, IVirtualDesktop desktop);
GetCurrentDesktop := vtable(IVirtualDesktopManagerInternal, 6) ; IVirtualDesktop GetCurrentDesktop();
CanViewMoveDesktops := vtable(IVirtualDesktopManagerInternal, 5) ; bool CanViewMoveDesktops(object pView);
ImmersiveShell := ComObjCreate("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{00000000-0000-0000-C000-000000000046}") 


if !(IApplicationViewCollection := ComObjQuery(ImmersiveShell,"{1841C6D7-4F9D-42C0-AF41-8747538F10E5}","{1841C6D7-4F9D-42C0-AF41-8747538F10E5}" ) ) ; 1607-1809
{
    MsgBox IApplicationViewCollection interface not supported.
}
GetViewForHwnd							:= vtable(IApplicationViewCollection, 6) ; (IntPtr hwnd, out IApplicationView view);

windowToCurrentVirtualDesktop(wintitle)
{
    global
    DetectHiddenWindows, on
    WinGet, outHwndList, List, %wintitle%
    DetectHiddenWindows, off

    thePView:=0
    loop % outHwndList {
        pView := 0
        DllCall(GetViewForHwnd, "UPtr", IApplicationViewCollection, "Ptr", outHwndList%A_Index%, "Ptr*", pView, "UInt")

        pfCanViewMoveDesktops := 0
        DllCall(CanViewMoveDesktops, "ptr", IVirtualDesktopManagerInternal, "Ptr", pView, "int*", pfCanViewMoveDesktops, "UInt") ; return value BOOL
        if (pfCanViewMoveDesktops)
        {
            theHwnd:=outHwndList%A_Index%
            thePView:=pView
            break
        }
    }
    if (thePView) {
        CurrentIVirtualDesktop := 0
        GetCurrentDesktop_return_value := DllCall(GetCurrentDesktop, "UPtr", IVirtualDesktopManagerInternal, "UPtrP", CurrentIVirtualDesktop, "UInt")

        DllCall(MoveViewToDesktop, "ptr", IVirtualDesktopManagerInternal, "Ptr", thePView, "UPtr", CurrentIVirtualDesktop, "UInt")
        ; uncomment below to always activate window
        winactivate, ahk_id %theHwnd%
    }
}

VTable(ppv, idx)
{
Return NumGet(NumGet(1*ppv)+A_PtrSize*idx)
}
;=================================================================================
;=================================================================================
;~ PinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinWindow", "Ptr")
;~ UnPinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinWindow", "Ptr")

;~ PinWindow(windowID:="") {
    ;~ global PinWindowProc, windowID
	;~ return
;~ }

;~ UnpinWindow(windowID:="") {
    ;~ global (UnpinWindowProc, windowID)
	;~ return
;~ }



;=================================================================================;
;  https://github.com/pmb6tz/windows-desktop-switcher/issues/55                   ;
;=================================================================================;
global IsPinnedWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedWindow", "Ptr")
global PinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinWindow", "Ptr")
global UnPinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinWindow", "Ptr")
global IsPinnedAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedApp", "Ptr")
global PinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinApp", "Ptr")
global UnPinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinApp", "Ptr")

_GetCurrentWindowID() {
    WinGet, activeHwnd, ID, A
    return activeHwnd
}

_GetCurrentWindowTitle() {
    WinGetTitle, activeHwnd, A
    return activeHwnd
}

OnTogglePinOnTopPress() {
        _notif(_TruncateString(_GetCurrentWindowTitle(), 100), "Toggled 'Pin On Top'")
	Winset, Alwaysontop, , A
}

OnTogglePinWindowPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    if (_GetIsWindowPinned(windowID)) {
        _UnpinWindow(windowID)
        _ShowTooltipForUnpinnedWindow(windowTitle)
    }
    else {
        _PinWindow(windowID)
        _ShowTooltipForPinnedWindow(windowTitle)
    }
}

OnTogglePinAppPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    if (_GetIsAppPinned(windowID)) {
        _UnpinApp(windowID)
        _ShowTooltipForUnpinnedApp(windowTitle)
    }
    else {
        _PinApp(windowID)
        _ShowTooltipForPinnedApp(windowTitle)
    }
}

_PinWindow(windowID:="") {
    _CallWindowProc(PinWindowProc, windowID)
}

_UnpinWindow(windowID:="") {
    _CallWindowProc(UnpinWindowProc, windowID)
}

_GetIsWindowPinned(windowID:="") {
    return _CallWindowProc(IsPinnedWindowProc, windowID)
}

_PinApp(windowID:="") {
    _CallWindowProc(PinAppProc, windowID)
}

_UnpinApp(windowID:="") {
    _CallWindowProc(UnpinAppProc, windowID)
}

_GetIsAppPinned(windowID:="") {
    return _CallWindowProc(IsPinnedAppProc, windowID)
}

_CallWindowProc(proc, window:="") {
    if (window == "") {
        window := _GetCurrentWindowID()
    }
    return DllCall(proc, UInt, window)
}

_notif(txt, title:="") {
    HideTrayTip()
    TrayTip, %title%, %txt%, 1
}

HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
}
_ShowTooltipForPinnedWindow(windowTitle) {
    _notif(_TruncateString(windowTitle, 100), "Pinned Window")
}

_ShowTooltipForUnpinnedWindow(windowTitle) {
    _notif(_TruncateString(windowTitle, 100), "Unpinned Window")
}

_ShowTooltipForPinnedApp(windowTitle) {
    _notif(_TruncateString(windowTitle, 100), "Pinned App")
}

_ShowTooltipForUnpinnedApp(windowTitle) {
    _notif(_TruncateString(windowTitle, 100), "Unpinned App")
}

_TruncateString(string:="", n:=10) {
    return (StrLen(string) > n ? SubStr(string, 1, n-3) . "..." : string)
}

;====================;
; Homemade Functions ;
;====================;

LeftVirtDesk() {
		Send, #^{Left}
}

RightVirtDesk() {
Send, #^{Right}	
}

NewVirtDesk() {
		Send, #^d
}

DestroyVirtDesk() {
		send, #^{f4}
}




