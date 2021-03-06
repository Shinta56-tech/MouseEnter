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

setMousePosAWin(pSleep) {
    Sleep, %pSleep%
    WinGetPos, vWX, vWY, vWW, vWH, A
    vMX := vWX + (vWW / 2)
    vMY := vWY + (vWH / 2)
    MouseMove, %vMX%, %vMY%
    Send, {LControl}
}

moveWinNextMonitor() {
    WinGetPos, vWX, vWY, vWW, vWH, A
    vWCX := vWX + (vWW / 2)
    vWCY := vWY + (vWH / 2)
    SysGet, MonCount, MonitorCount
    Loop, %MonCount% {
        SysGet, Mon, Monitor, %A_Index%
        ; Check Log
        ;Msgbox Left--%MonLeft%, Right--%MonRight%, Bottom--%MonBottom%, Top--%MonTop%, X%vWX% Y%vWY%
        If ( (MonLeft <= vWCX) & (MonRight >= vWCX) & (MonBottom >= vWCY) & (MonTop <= vWCY) ) {
            vRWX := vWX - MonLeft
            vRWY := vWY - MonTop
            If (A_Index <> MonCount) {
                vNextMonNum := A_Index + 1
            } Else {
                vNextMonNum := 1
            }
            SysGet, Mon, Monitor, %vNextMonNum%
            vTWX := MonLeft + vRWX
            vTWY := MonTop + vRWY
            WinMove, A, , %vTWX%, %vTWY%
            Break
        }
    }
}

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

;---
; Default Hotkey

    #If GetKeyState("RButton", "P")

        MButton::WinMinimize, A

;---
; Shift Hotkey

    #If gfShiftSC

        *RButton::XButton2
        *LButton::XButton1
        WheelUp::PgUp
        WheelDown::PgDn
        MButton::Send, !{F4}
        Tab::WinSet, AlwaysOnTop, Toggle, A

    #If gfShiftCS

        *RButton::Send, {Tab}
        *LButton::Send, +{Tab}
    
    #If  gfRButton && !gfLButton

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
        RAlt::Delete
        Tab::BackSpace

        LButton::
            gfLButton := True
            KeyWait, LButton, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorHotKey = "LButton") {
                moveWinNextMonitor()
                setMousePosAWin(0)
            } Else {
                KeyWait LButton
            }
            gfLButton := False
        Return

        WheelUp::WheelLeft
        WheelDown::WheelRight

    #If  gfRButton &&  gfLButton

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
        RAlt::Tab
        Tab::Delete

    #If !gfRButton &&  gfLButton

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
        
        Space::vk1D

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
;---
; Shift Button

    #If gfRButton

        *RButton Up::gfRButton := False

    #If gfRShift

        *RShift Up::
            If (gfShiftCS) {
                gfShiftCS := False
                Send, {LAlt Up}
                setMousePosAWin(70)
            } Else If (GetKeyState("LWin")) {
                Send, {LWin Up}
            } Else {
                Send, {LShift Up}
            }
            gfRShift := False
        Return

    #If gfRControl

        *RControl Up::
            If (gfShiftSC) {
                gfShiftSC := False
            } Else If (GetKeyState("LAlt")) {
                Send, {LAlt Up}
            } Else {
                Send, {LControl Up}
            }
            gfRControl := False
        Return
    
    #If gfSpace

        *Space Up::gfSpace := False

    #If !checkNoDesktop()

        *RButton::
            gfRButton := True
            KeyWait, RButton, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorKey = "RButton") {
                Send, {Blind}{RButton}
            }
        Return

        CapsLock::BackSpace
        vkF0::BackSpace

    #If !checkNoDesktop() && !gfRShift

        *RShift::
            gfRShift := True
            If (GetKeyState("RControl", "P")) {
                gfShiftCS := True
                gfRControl := False
                Send, {LControl Up}{LAlt Down}{Tab}                
            } Else If (A_PriorKey="RShift") & (A_TimeSincePriorHotkey < DUBL_CLICK_DELAY) {
                Send, {LWin Down}                
            } Else {
                Send, {LShift Down}
            }
        Return

    #If !checkNoDesktop() && !gfRControl

        *RControl::
            gfRControl := True
            If (GetKeyState("RShift", "P")) {
                gfRShift := True
                Send, {LShift Up}
                gfShiftSC := True
                KeyWait, RControl, T%LONG_PRESS_DELAY%
                If (!ErrorLevel) & (A_PriorKey="RControl") {
                    Send, ^{Space}
                }
            } Else If (A_PriorKey="RControl") & (A_TimeSincePriorHotkey < DUBL_CLICK_DELAY) {
                Send, {LAlt Down}
            } Else {
                Send, {LControl Down}
            }
        Return

    #If !checkNoDesktop() && !gfSpace

        *Space::
            gfSpace := True
            KeyWait, Space, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorKey="Space") {
                Send, {Blind}{Space}
            }
        Return
