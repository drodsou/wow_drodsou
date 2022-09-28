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

; alternative way of assigning wow windows manually
wowPickWindowOrder(){
  global wowid1, wowid2, wowid3, wowid4, wowid5

  WinWaitActive, World of Warcraft
  WinGet, wowid1, ID
  WinMinimize
  
  WinWaitActive, World of Warcraft
  WinGet, wowid2, ID
  WinMinimize

  ;WinWaitActive, World of Warcraft
  ;WinGet, wowid3, ID
  ;WinMinimize

  ;WinActivate, % "ahk_id " wowid3
  WinActivate, % "ahk_id " wowid2
  WinActivate, % "ahk_id " wowid1
}


;WinGet, wowid, list, World of Warcraft 
wowPickWindowOrder()

wowsend(key, alsoFg:=True){
  global wowid2, wowid3, wowid4, wowid5
  if (alsoFg) { 
    KeyWait, %key%, D 
  }
  IfWinActive, World of Warcraft 
  { 
    ControlSend,, {%key%}, ahk_id %wowid2% 
    ControlSend,, {%key%}, ahk_id %wowid3% 
  }
}

; -- druid + priest
~i::
;  wowsend("l", False)
  wowsend("i")
Return
<^>!o::wowsend("o", False)
<^>!p::wowsend("p", False)
<^>!l::wowsend("l", False)
<^>!m::wowsend("m", False)
~F7::wowsend("F7")
~F8::wowsend("F8")

; -- warr + druid
;~m::wowsend("m")
;~i::wowsend("i")
;<^>!o::wowsend("o")
;<^>!l::wowsend("l")



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



