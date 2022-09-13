; -- Modifiers
; ^     Ctrl
; !     Alt
; +     Shift
; <^>!  AltGr	
; #     WinKey
; ~      ??

; -- for two-box WoW on same computer, two monitors, automate alt-tab, sendkey, alt-tab
; -- open both WoW windows, run this script, click in first one (will minimize), then click in second one (will minimize)

; -- WARNING: multiboxing may be unauthorized by some servers, and this method may be seen as unauthorized automation, 
; -- Alternative is manually click on desired WoW window and press key, or having a second computer/keyboard 

WinWaitActive, World of Warcraft
WinGet, wow1, ID
WinMinimize
WinWaitActive, World of Warcraft
WinGet, wow2, ID
WinMinimize

WinActivate, % "ahk_id " wow2
WinActivate, % "ahk_id " wow1


wow2send(theKey){
  global wow2
  global wow1
  WinActivate, % "ahk_id " wow2
  Send, %theKey%
  WinActivate, % "ahk_id " wow1
}

; -- la i envia l antes, para dejar de seguir (flecha arriba) antes de ejecutar supermacro
;<^>!i::wow2send("li")
<^>!i::wow2send("i")
<^>!o::wow2send("o")
<^>!p::wow2send("p")
<^>!l::wow2send("l")


; ---- test
;F3::
;WinActivate, % "ahk_id " wow1
;Return

;F4::
;WinActivate, % "ahk_id " wow2
;Return