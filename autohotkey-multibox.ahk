#SingleInstance Force

; -- Modifiers
; ^     Ctrl
; !     Alt
; +     Shift
; <^>!  AltGr	
; #     WinKey
; ~      OnKeyDown, dont wait for keyup

; -- WARNING: multiboxing may be unauthorized by some servers, and this method may be seen as unauthorized automation, 
; -- Alternative is manually click on desired WoW window and press key, or having a second computer/keyboard 


WinGet, wowid, list, World of Warcraft 

wowsend(key, alsoFg:=True){
  global wowid2, wowid3, wowid4, wowid5
  if (alsoFg) { 
    KeyWait, %key%, D 
  }
  IfWinActive, World of Warcraft 
  { 
    ControlSend,, {%key%}, ahk_id %wowid2% 
  }
}


~i::wowsend("i")
<^>!p::wowsend("p")
~F8::wowsend("F8")

/*
~space::wowsend("space")
<^>!i::wowsend("i", False)
<^>!o::wowsend("o", False)
<^>!p::wowsend("p", False)
<^>!l::wowsend("l", False)
*/




/*
--------------------------------------------------------
; example sending several keys
; the "l" is only sent to bg windows, eg stop following
~i::
  wowsend("l", False)
  wowsend("i")
Return

; example special key
~space::wowsend("space")
---------------------------------------------------------
*/



