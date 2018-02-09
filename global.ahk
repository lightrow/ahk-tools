#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#MaxHotkeysPerInterval 9000
#MaxThreadsPerHotkey 2
#MaxThreads 200
#Persistent

#Include, %A_ScriptDir%\VDE\libraries\tooltip.ahk
#Include, %A_ScriptDir%\shellrun.ahk
#Include, %A_ScriptDir%\Default Keyboard Lang.ahk

USA := 0x0409
RUS := 0x0419

SetDefaultKeyboard(USA)

toggle := False




DetectHiddenWindows On
SetTitleMatchMode 2
CoordMode, Mouse, Screen
DetectHiddenWindows, On

Run, windowslide.ahk
;Run, WindowDrag.ahk
;Run, OnWinStuff.ahk
Run titlebardrag.ahk

global taskbarID=0

;ShellRun("C:\Program Files\Realtek\Audio\HDA\RAVCpl64.exe")



Borderless(window) {
	if (WinActive("ahk_class Progman") || WinActive("ahk_Class DV2ControlHost") || (WinActive("Start") && WinActive("ahk_class Button")) || WinActive("ahk_class Shell_TrayWnd") || WinActive("ahk_class Shell_SecondaryTrayWnd") || WinActive("ahk_exe SearchUI.exe") ) {
  	return
  }
	_ShowTooltip("Borderless Toggle")
	WinGet, active_id, ID, %window%
	WinGet Style, Style, %window%
	if(Style & 0xC40000) {
		WinSet, ExStyle, -0x00000200, ahk_id %active_id%
		WinSet, Style, -0xC40000, ahk_id %active_id% ; -0x40000  0xC00000 ^0x00800000L
	; WinRestore, ahk_id %active_id% 
	; WinMaximize, ahk_id %active_id% 
	} else {
		WinSet, Style, +0xC40000, ahk_id %active_id%
		WinRestore, ahk_id %active_id%
	}
	return
}


CheckHoverArea(){
	MouseGetPos, X, Y, mouseHoveringID
    if (!taskbarID) {
        WinGet, taskbarID, ID, ahk_class Shell_TrayWnd
    }
	if (!sndtaskbarID) {
		WinGet, sndtaskbarID, ID, ahk_class Shell_SecondaryTrayWnd
	}
	if ( mouseHoveringID == taskbarID || mouseHoveringID == sndtaskbarID) {
		if ( X >= 1412 && X <= 1455 )
			 return "lang" 
		else if ( X >= 1381 && X <= 1410 )
			 return "vol" 
;		else if ( X >= 1351 && X <= 1380 )
;			 return "aimp" 
		else return "lol"				
	}
}


_IsCursorHoveringTaskbar() {
    MouseGetPos,,, mouseHoveringID
    if (!taskbarID) {
        WinGet, taskbarID, ID, ahk_class Shell_TrayWnd
    }
    return (mouseHoveringID == taskbarID)
}


ScrollUp(){
	checkhover := CheckHoverArea()
	if (checkhover == "lol") {
		Send #^{Left}
		return
	}
	if ( checkhover == "lang" ) {
		PostMessage, 0x50, 0x02,0,, A ; 0x50 is WM_INPUTLANGCHANGEREQUEST.
		return
	}
	if ( checkhover == "vol" ) {
		Send {Volume_Up}
		return
	}
	if ( checkhover == "aimp" ) {
		Send {Media_Prev}
		return
	}
}
ScrollDown(){
	checkhover := CheckHoverArea()
	if (checkhover == "lol") {
		Send #^{Right}
		return
	}
	if ( checkhover == "lang" ) {
		PostMessage, 0x50, 0x04,0,, A ; 0x50 is WM_INPUTLANGCHANGEREQUEST.
		return
	}
	if ( checkhover == "vol" ) {
		Send {Volume_Down}
		return
	}
	if ( checkhover == "aimp" ) {
		Send {Media_Next}
		return
	}
}

CenterActiveWindow()
{
	SysGet, VirtualWidth, 78
	SysGet, VirtualHeight, 79
    WinGetPos,X,Y, Width, Height, A
    windowWidth := A_ScreenWidth * 0.8 ; desired width
    windowHeight := A_ScreenHeight * 0.8 ; desired height
    WinGetTitle, windowName, A
	if (X >= 0) {
		WinMove, %windowName%, , A_ScreenWidth/2-(windowWidth/2) , A_ScreenHeight/2-(windowHeight/2) , windowWidth, windowHeight
	} else {
		WinMove, %windowName%, , A_ScreenWidth/2-(windowWidth/2) - 1920, A_ScreenHeight/2-(windowHeight/2) + 562, windowWidth, windowHeight - 281
	}
}
MoveBetween()
{
    WinGetPos, X,Y, windowWidth, windowHeight, A
    ;windowWidth := A_ScreenWidth * 0.7 ; desired width
    ;windowHeight := A_ScreenHeight * 0.7 ; desired height
    WinGetTitle, windowName, A
	if (X < 0) {
		WinMove, %windowName%, , X + 1920, Y - 562, windowWidth, windowHeight
	} else {
		WinMove, %windowName%, , X - 1920, Y + 562, windowWidth, windowHeight 
	}
}





CenterWindow(WinTitle)
{
    WinGetPos,X,Y, Width, Height, %WinTitle%
    WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}




_ShowTooltip(message:="") {
    params := {}
    params.message := message
    params.lifespan := 500
    params.position := 0
    params.fontSize := 14
    params.fontWeight := 900  ; 400
    params.fontColor := "0xFFFFFF"
    params.backgroundColor := "0x1F1F1F"
    Toast(params)
}






RWin::LWin
capslock::ctrl

/*
!^t::
{
Click, 444,52
Sleep 100
Click, 247, 468
Sleep 100
MouseMove 867, 373
Sleep 200
MouseGetPos,,, OutputVarWin, OutputVarCtl
ControlGetText, TextVar2 , %OutputVarCtl%, ahk_id %OutputVarWin%


if (TextVar2="Dark") {
	Send {WheelDown}
}
if (TextVar2="Light") {
	Send {WheelUp}
}
Sleep 200
Click 1020,829
return
}
*/

#a::Borderless("A")



#s::
{
	Send {MButton Down}
	While Getkeystate("s", "p")
	{
		sleep 10	
	}
	Send {MButton Up}
	return
}



*~WheelDown::ScrollDown()
*~WheelUp::ScrollUp()


#WheelDown::
{
Send #^{Right}
return
}

#WheelUp::
{
Send #^{Left}
return
}


#z::
{
if (WinActive("ahk_class Progman") || WinActive("ahk_Class DV2ControlHost") || (WinActive("Start") && WinActive("ahk_class Button")) || WinActive("ahk_class Shell_TrayWnd") || WinActive("ahk_exe SearchUI.exe") ) {
	return
}
WinGet, MinMax, MinMax, A
If (MinMax = 1)
	WinRestore, A
else
	WinMaximize, A
return
}


#!z::Send {Volume_Mute}


;#`::CenterActiveWindow()


^!l::
{
    _ShowTooltip("Cursor Lock")
    ConfineCursor:=!ConfineCursor
    WinGetPos, VarX, VarY, , , A
    MouseGetPos, , , WhichWindow, WhichControl
    ControlGetPos, X, Y, W, H, %WhichControl%, ahk_id %WhichWindow%
    VarX += X
    VarY += Y
    VarX2 := VarX + W
    VarY2 := VarY + H
    ClipCursor( ConfineCursor, VarX, VarY, VarX2, VarY2)
	Return

	ClipCursor( Confine=True, x1=0 , y1=0, x2=1, y2=1 ) {
		VarSetCapacity(R,16,0),  NumPut(x1,&R+0),NumPut(y1,&R+4),NumPut(x2,&R+8),NumPut(y2,&R+12)
		Return Confine ? DllCall( "ClipCursor", UInt,&R ) : DllCall( "ClipCursor" )
	}
}


!^Backspace::
{
Run C:\AHK\ahkReset.bat
return
}	

#q::
{
PostMessage, 0x112, 0xF060,,, A ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
return
}

!^t::
{
ShellRun("C:\UTILS\cmder\Cmder.exe")
_ShowTooltip("Cmder")
return
}	

!t::
{
ShellRun("C:\Users\Jo\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\WSL Terminal.lnk")
_ShowTooltip("mintty")
return
}	

!^e::
{
ShellRun("C:\UTILS\UWPLinks\Xodo.lnk")
_ShowTooltip("Xodo")
return
}	

!^r::
{
ShellRun("C:\Program Files\Microsoft VS Code\Code.exe" )  ;"--force-device-scale-factor=1.0"
_ShowTooltip("VSCode")

return
}	

!^w::
{
ShellRun("C:\Program Files (x86)\Notepad++\notepad++.exe")
_ShowTooltip("notepad++")
return
}	


!^q::
{
ShellRun("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", --enable-native-gpu-memory-buffers --enable-zero-copy )
_ShowTooltip("Chrome")
return
}

#+Escape::
{
Run "C:\UTILS\ProcessExplorer\procexp.exe"
_ShowTooltip("Process Explorer")
return
}


!^a::
{
ShellRun("C:\Program Files (x86)\AIMP\AIMP.exe")
_ShowTooltip("AIMP")
return
}


!^s::
{
Run "C:\Program Files\Everything\Everything.exe"
_ShowTooltip("Everything")
return
}


!^c::
{
ShellRun("C:\Windows\System32\calc.exe")
_ShowTooltip("Calc")
return
}

RAlt & s::
{
Send {ß}
return
}

RAlt & a::
{
if(Getkeystate("Shift", "p")) {
	Send {Ä}
	return
} else {
	Send {ä}
	return
}

}


RAlt & o::
{
if(Getkeystate("Shift", "p")) {
	Send {Ö}
	return
} else {
	Send {ö}
	return
}
}

RAlt & u::
{
if(Getkeystate("Shift", "p")) {
	Send {Ü}
	return
} else {
	Send {ü}
	return
}
}





#IfWinActive ahk_exe witcher3.exe
{

*CapsLock::LButton
/*{
Keywait CapsLock, T0.01
if errorlevel
	While Getkeystate("Capslock", "p")
	{
		Send {LButton Down}
		sleep 50
		Send {LButton up}
		sleep 50
	}
}
return
*/
}

#IfWinActive ahk_exe brogue.exe
{
h::Left
k::Right
}

#IfWinActive ahk_exe mintty.exe
{
	^Tab::
	{
		Send ^{b}
		Send {Right}
		return
	}
}


#IfWinActive ahk_exe code.exe
{


RAlt & s::
Send {blind}{down}
return



^WheelDown::^Down
^WheelUp::^Up
}



#IfWinActive ahk_exe gzdoom.exe
{

*CapsLock::Ctrl
/*{
Keywait CapsLock, T0.01
if errorlevel
	While Getkeystate("Capslock", "p")
	{
		Send {LButton Down}
		sleep 50
		Send {LButton up}
		sleep 50
	}
}
return
*/
}

#IfWinActive ahk_class ConsoleWindowClass
{
+PgUp::
Send {WheelUp} 
Return

+PgDn::
Send {WheelDown}
Return

^Up:: 
Send {WheelUp}
Return

^Down:: 
Send {WheelDown} 
Return
}