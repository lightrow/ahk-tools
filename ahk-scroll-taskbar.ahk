DetectHiddenWindows On

CheckHoverArea(){
	MouseGetPos, X, Y, mouseHoveringID
    if (!taskbarID) {
        WinGet, taskbarID, ID, ahk_class Shell_TrayWnd
    }
	if ( mouseHoveringID == taskbarID ) {
;		if ( X >= 1412 && X <= 1455 )			; Can be used for scrolling over an element in specific location
;			 return "lang" 						; such as language selector, volume icon, etc. but requires the 
;		else if ( X >= 1381 && X <= 1410 )		; coordinates of said elements which are dependant on screen
;			 return "vol" 						; resolution, number and arrangement of monitors and icons.
;		else if ( X >= 1351 && X <= 1380 )		; TODO - better solution.
;			 return "aimp" 
		else return "lol"				
	}
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

*~WheelDown::ScrollDown()
*~WheelUp::ScrollUp()