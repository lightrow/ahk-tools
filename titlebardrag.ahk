#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen
SetMouseDelay, -1
SetKeyDelay, -1
SetWinDelay, -1
SetControlDelay, -1
SetBatchLines, -1

#MaxHotkeysPerInterval 9000
#MaxThreadsPerHotkey 2
#MaxThreads 200
#WinActivateForce

#Persistent

LWin & LButton::
{
  if ( WinActive("ahk_exe SearchUI.exe") ) {
    Click
  }
  MouseGetPos,,, WinUMID
  WinActivate, ahk_id %WinUMID%

  if (WinActive("ahk_class Progman") || WinActive("ahk_Class DV2ControlHost") || (WinActive("Start") && WinActive("ahk_class Button")) || WinActive("ahk_class Shell_TrayWnd") || WinActive("ahk_class Shell_SecondaryTrayWnd") || WinActive("ahk_exe SearchUI.exe") ) {
  	return
  }
  BlockInput, MouseMove
  WinGet, active_id, ID, A
	WinGet Style, Style, A
  if !(Style & 0xC40000) {
    WinSet, Style, +0xC40000, ahk_id %active_id%
  } 
  WinGetPos, posx, posy, Width, Height, A
  posx+=Width/2
  posy+=15
  
  MouseMove, %posx% ,%posy%, 0
  Send {Blind}{LButton Down}
  BlockInput, MouseMoveOff
  KeyWait LButton
  Send {Blind}{LButton Up}
  return
}