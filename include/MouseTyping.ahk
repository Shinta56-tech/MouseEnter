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

#If !checkNoDesktop()

*RButton::
    gfRButton := True
    KeyWait, RButton, T%LONG_PRESS_DELAY%
    If (!ErrorLevel) & (A_PriorKey = "RButton") {
        Send, {Blind}{RButton}
    }
Return

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

#If !checkNoDesktop() && !gfRButton && !gfLButton

*Space::
    If (!gfSpace) {
        gfSpace := True
        KeyWait, Space, T%LONG_PRESS_DELAY%
        If (!ErrorLevel) & (A_PriorKey="Space") {
            Send, {Blind}{Space}
        }
    }
Return

CapsLock::BackSpace
vkF0::BackSpace

#If gfRButton

*RButton Up::
    gfRButton := False
Return

#If gfRShift

*RShift Up::
    gfRShift := False
Return

#If gfRControl

*RControl Up::
    gfRControl := False
Return

#If gfSpace

*Space Up::
    gfSpace := False
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

#If gfRButton && !gfLButton && !gfSpace

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
CapsLock::Delete
vkF0::Delete
Tab::BackSpace

#If gfRButton && gfLButton && !gfSpace

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
CapsLock::Tab
vkF0::Tab
Tab::Delete

#If !gfRButton && gfLButton && !gfSpace

q::Return
w::Home
e::Up
r::End
t::Return
a::Return
s::Left
d::Down
f::Right
g::Return
z::Return
x::PgUp
c::Return
v::PgDn
b::Return

#If !gfRButton && !gfLButton && gfSpace

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

#If gfRButton && !gfLButton && gfSpace

q::F12
w::F7
e::F8
r::F9
t::Return
a::F11
s::F4
d::F5
f::F6
g::Return
z::F10
x::F1
c::F2
v::F3
b::Return