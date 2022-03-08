;*****************************************************************************************************************************************
; Initialize
;*****************************************************************************************************************************************

iniMouseTyping() {
    Gosub, iniMouseTyping
}

iniMouseTyping:
    Global gfRButton := False
    Global gfLButton := False
    Global gfRContorl := False
    Global gfRShift := False
    Global gfSpace := False
    Global gfRAlt := False

    Global gfShiftCS := False
    Global gfShiftSC := False
Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

checkNoDesktop() {
    vIni := "ini\NoDesktop.ini"
    WinGetClass, vAhkClass, A
    IniRead, vResult, %vIni%, ahk_class, %vAhkClass%, OnDesktop
    Return vResult <> "OnDesktop"
}

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

#If

*RButton::
    If (!checkNoDesktop()) {
        gfRButton := True
        KeyWait, RButton, T%LONG_PRESS_DELAY%
        If (!ErrorLevel) & (A_PriorKey = "RButton") {
            Send, {Blind}{RButton}
        }
    } Else {
        Send, {Blind}{RButton Down}
        KeyWait, RButton
        Send, {Blind}{RButton Up}
    }
Return
*RButton Up::
    gfRButton := False
Return

#RButton::Send, ^#{Right}

#If !checkNoDesktop()

*RShift::
    If (!gfRShift) {
        gfRShift := True
        If (GetKeyState("RControl", "P")) {
            Send, {Blind}{LControl Up}{LAlt Down}{Tab}
            gfShiftCS := True
            KeyWait, RShift
            gfShiftCS := False
            Send, {LAlt Up}
        } Else If (A_PriorKey="RShift") & (A_TimeSincePriorHotkey < DUBL_CLICK_DELAY) {
            Send, {LWin Down}
            KeyWait, RShift
            Send, {LWin Up}
        } Else {
            Send, {LShift Down}
		    KeyWait, RShift
		    Send, {LShift Up}
        }
    }
Return
*RShift Up::
    If (gfRShift) {
        gfRShift := False
    }
Return

*RControl::
    If (!gfRControl) {
        gfRControl := True
        If (GetKeyState("RShift", "P")) {
            Send, {Blind}{LShift Up}
            gfShiftSC := True
            KeyWait, RControl, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorKey="RControl") {
                Send, ^{Space}
            } Else {
                KeyWait, RControl
            }
            gfShiftSC := False
        } Else If (A_PriorKey="RControl") & (A_TimeSincePriorHotkey < DUBL_CLICK_DELAY) {
            Send, {LAlt Down}
            KeyWait, RControl
            Send, {LAlt Up}
        } Else {
            Send, {LControl Down}
		    KeyWait, RControl
		    Send, {LControl Up}
        }
    }
Return
*RControl Up::
    If (gfRControl) {
        gfRControl := False
    }
Return

#If !checkNoDesktop() &&  !gfRButton && !gfLButton

*Space::
    If (!gfSpace) {
        gfSpace := True
        KeyWait, Space, T%LONG_PRESS_DELAY%
        If (!ErrorLevel) & (A_PriorKey="Space") {
            Send, {Blind}{Space}
        }
    }
Return
*Space Up::
    If (gfSpace) {
        gfSpace := False
    }
Return

*RAlt::
    If (!gfRAlt) {
        gfRAlt := True
        KeyWait, RAlt, T%LONG_PRESS_DELAY%
        If (!ErrorLevel) & (A_PriorKey="RAlt") {
            Send, {Blind}{Backspace}
        }
    }
Return
*RAlt Up::
    If (gfRAlt) {
        gfRAlt := False
    }
Return

#If GetKeyState("RButton", "P")

*MButton::WinMinimize, A

#If gfRButton

*LButton::
    gfLButton := True
Return

*WheelUp::WheelLeft
*WheelDown::WheelRight

#If gfLButton

*LButton Up::
    gfLButton := False
Return

#If gfShiftCS

*RButton::Send, {Tab}
*LButton::Send, +{Tab}

#If gfShiftSC

*RButton::XButton2
*LButton::XButton1
*WheelUp::PgUp
*WheelDown::PgDn
*MButton::Send, !{F4}
*Tab::WinSet, AlwaysOnTop, Toggle, A

#If gfRButton && !gfLButton

q::Return
w::u
e::i
r::o 
t::Return
a::y
s::n
d::k
f::m
g::h
z::q
x::p
c::l
v::j
b::Return

Space::Enter
RAlt::Delete

#If gfRButton && gfLButton

q::Return
w::vkBD ; \|
e::vkBB ; ;+
r::vkDC ; -=
t::Return
a::vkBA ; :*
s::vkDE ; ^~
d::vkDB ; [{
f::vkDD ; ]}
g::Return
z::vkBC ; ,<
x::vkBE ; .>
c::vkBF ; /?
v::vkC0 ; @`
b::vkE2 ; \_

Space::Escape
RAlt::Tab

#If !gfRButton && gfLButton

q::F12
w::F7
e::F8
r::F9
t::Return
a::F11
s::F4
d::F5
f::F6
g::F11
z::Return
x::F1
c::F2
v::F3
b::F10

#If gfRAlt

q::Home
w::Up
e::End
r::Return
t::Return
a::Left
s::Down
d::Right
f::Return
g::Return
z::PgUp
x::Return
c::PgDn
v::Return
b::Return

#If gfSpace && !GetKeyState("a", "P")

q::Return
w::7
e::8
r::9
t::Return
a::Return
s::4
d::5
f::6
g::Return
z::0
x::1
c::2
v::3
b::Return

#If gfSpace && GetKeyState("a", "P")

q::Return
w::Return
e::Send, ^{PgUp}
r::Return
t::Return
a::Return
s::Send, ^#{Left}
d::Send, ^{PgDn}
f::Send, ^#{Right}
g::Return
z::Return
x::Return
c::Return
v::Return
b::Return