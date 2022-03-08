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
    Global gfLShift := False

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

*Space::
    If (!gfSpace) {
        gfSpace := True
        KeyWait, Space, T%LONG_PRESS_DELAY%
        If (!ErrorLevel) & (A_PriorKey="Space") {
            If (gfRButton && !gfLButton) {
                Send, {Blind}{Enter}
            } Else If (gfRButton && gfLButton) {
                Send, {Blind}{Escape}
            } Else If (!gfRButton && gfLButton) {
                Send, {Blind}{vk1D} ; 無変換
            } Else {
                Send, {Blind}{Space}
            }
        } Else {
            KeyWait, Space
        }
    }
Return
*Space Up::
    If (gfSpace) {
        gfSpace := False
    }
Return

*LShift::
    If (!gfLShift) {
        gfLShift := True
        Send, {LShift Down}
        KeyWait, LShift, T%LONG_PRESS_DELAY%
        If (!ErrorLevel) & (A_PriorKey="LShift") {
            If (gfRButton && !gfLButton) {
                Send, {Blind}{Delete}
            } Else If (gfRButton && gfLButton) {
                Send, {Blind}{Tab}
            } Else If (!gfRButton && gfLButton) {
                
            } Else {
                Send, {Blind}{Backspace}
            }
        }
    }
Return
*LShift Up::
    If (gfLShift) {
        gfLShift := False
        Send, {LShift Up}
    }
Return

#If gfRButton

*LButton::
    gfLButton := True
Return

*WheelUp::WheelLeft
*WheelDown::WheelRight
*MButton::WinMinimize, A

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
*Space::Send, #{d}

#If GetKeyState("LAlt") && gfRControl

*RButton::Send, {LAlt Up}^{PgDn}{LAlt Down}
*LButton::Send, {LAlt Up}^{PgUp}{LAlt Down}

#If GetKeyState("LWin") && gfRShift

*RButton::Send, ^{Right}
*LButton::Send, ^{Left}

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

#If !gfRButton && gfLButton

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

#If gfSpace

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
