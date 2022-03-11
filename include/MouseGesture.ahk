;*****************************************************************************************************************************************
; Initialize
;*****************************************************************************************************************************************

initMouseGesture() {
    Gosub initMouseGesture
    initMouseGesture_Gui()
}

initMouseGesture:
    Global INI_MouseGesture := "ini\MouseGesture.ini"
    Global MG_PROFILE_FOLDER_PATH := "ini\ProfileMG\"

    Global gfGestureButton := False

    Global MGLENX
    IniRead, MGLENX, %INI_MouseGesture%, SETTING, MGLENX, 150
    Global MGLENY
    IniRead, MGLENY, %INI_MouseGesture%, SETTING, MGLENY, 100
    Global MGLENV
    IniRead, MGLENV, %INI_MouseGesture%, SETTING, MGLENV, 3.3

    Global gGestureFlag := False
    Global gPriorKey, gAhkExe, gWinTitle
    Global gGestureText, gGestureName, gGestureSend
    Global gXPos, gYPos, gTPosR, gTPosL, gTPosU, gTPosD
Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

startMouseGesture() {
    gGestureText := ""
    WinGet, gAhkExe, ProcessName, A
    WinGetTitle, gWinTitle, A
    MouseGetPos, gXPos, gYPos
    gTPosR := gXPos + MGLENX
    gTPosL := gXPos - MGLENX
    gTPosU := gYPos - MGLENY
    gTPosD := gYPos + MGLENY
    SetTimer, MG_MAIN, 0
    getGesturNameSend()
    showGestureInfo()
}

endMouseGesture(pExitFlag) {
    SetTimer, MG_MAIN, Off
    ToolTip        
    If (!pExitFlag) {
        Send, % gGestureSend
    }
    gGestureName := ""
    gGestureSend := ""
}

checkLongMove(pMoveSymbol) {
    Return RegExMatch(gGestureText, "^.*(" . pMoveSymbol . "){2}$")
}

checkTargetPos() {
    vMoveSymbolR := "'R"
    vMoveSymbolL := "'L"
    vMoveSymbolD := "'D"
    vMoveSymbolU := "'U"
    If ((!checkLongMove(vMoveSymbolR)) && (gXPos > gTPosR)) {
        gGestureText .= vMoveSymbolR
        gTPosR := gXPos + (MGLENX * MGLENV)
        gTPosL := gXPos - MGLENX
        gTPosU := gYPos - MGLENY
        gTPosD := gYPos + MGLENY
    } Else If ((!checkLongMove(vMoveSymbolL)) && (gXPos < gTPosL)) { 
        gGestureText .= vMoveSymbolL
        gTPosR := gXPos + MGLENX
        gTPosL := gXPos - (MGLENX * MGLENV)
        gTPosU := gYPos - MGLENY
        gTPosD := gYPos + MGLENY
    } Else If ((!checkLongMove(vMoveSymbolU)) && (gYPos < gTPosU)) {
        gGestureText .= vMoveSymbolU
        gTPosR := gXPos + MGLENX
        gTPosL := gXPos - MGLENX
        gTPosU := gYPos - (MGLENY * MGLENV)
        gTPosD := gYPos + MGLENY
    } Else If ((!checkLongMove(vMoveSymbolD)) && (gYPos > gTPosD)) {
        gGestureText .= vMoveSymbolD
        gTPosR := gXPos + MGLENX
        gTPosL := gXPos - MGLENX
        gTPosU := gYPos - MGLENY
        gTPosD := gYPos + (MGLENY * MGLENV)
    } Else {
        Return False
    }
    Return True
}

getGesturNameSend() {
    If (gGestureText = "") {
        vGestureText := "P"
    } Else {
        vGestureText := gGestureText
    }
    If (gWinTitle<>"") {
        IniRead, vAhkExe, %MG_PROFILE_FOLDER_PATH%%gAhkExe%.ini, WinTitle, %gWinTitle%, NoWinTitle
        If (vAhkExe <> "NoWinTitle") {
            IniRead, vGNameSend, %MG_PROFILE_FOLDER_PATH%%vAhkExe%.ini, HotKey, %vGestureText%
            If (vGNameSend <> "ERROR") {
                setGestureNameSend(vGNameSend)
                Return
            } Else {
                IniRead, vGNameSend, %MG_PROFILE_FOLDER_PATH%Default.ini, HotKey, %vGestureText%
                If (vGNameSend <> "ERROR") {
                    setGestureNameSend(vGNameSend)
                    Return
                }
            }
        }
    }
    IniRead, vGNameSend, %MG_PROFILE_FOLDER_PATH%%gAhkExe%.ini, HotKey, %vGestureText%
    If (vGNameSend <> "ERROR") {
        setGestureNameSend(vGNameSend)
        Return
    } Else {
        IniRead, vGNameSend, %MG_PROFILE_FOLDER_PATH%Default.ini, HotKey, %vGestureText%
        If (vGNameSend <> "ERROR") {
            setGestureNameSend(vGNameSend)
            Return
        }
    }
    gGestureName := ""
    gGestureSend := ""
}

setGestureNameSend(pGNameSend) {
    gGestureName := RegExReplace(pGNameSend, "^.*?::", "")
    gGestureSend := RegExReplace(pGNameSend, "::.*?$", "")
}

showGestureInfo() {
    IF (gGestureText ="") {
        vToolTip := gGestureName
    } Else {
        vToolTip := gGestureText . "`n" . gGestureName
    }
    ToolTip, % vToolTip
}

addGestureCommund(pSymbol := "") {
    gGestureText .= pSymbol
    getGesturNameSend()
    showGestureInfo()
}

;*****************************************************************************************************************************************
; Label
;*****************************************************************************************************************************************

MG_MAIN:
    MouseGetPos, gXPos, gYPos
    If (checkTargetPos()) {
        getGesturNameSend()
        showGestureInfo()
    }
Return

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

#If !checkNoDesktop()

AppsKey::
    If (!gfGestureButton) {
        gfGestureButton := True
        startMouseGesture()
    }
Return

AppsKey Up::
    If (gfGestureButton) {
        endMouseGesture(False)
        gfGestureButton := False
    }
Return

#If gfGestureButton

Escape::Return

Escape Up::endMouseGesture(True)

Tab::Return

Tab Up::
    endMouseGesture(True)
    showGestureSet()
Return

CapsLock::addGestureCommund("Cap")
Space::addGestureCommund("Spc")
RShift::addGestureCommund("Rs")
RControl::addGestureCommund("Rc")
q::addGestureCommund("Q")
w::addGestureCommund("W")
e::addGestureCommund("E")
r::addGestureCommund("R")
t::addGestureCommund("T")
a::addGestureCommund("A")
s::addGestureCommund("S")
d::addGestureCommund("D")
f::addGestureCommund("F")
g::addGestureCommund("G")
z::addGestureCommund("Z")
x::addGestureCommund("X")
c::addGestureCommund("C")
v::addGestureCommund("V")
b::addGestureCommund("B")

;*****************************************************************************************************************************************
; Include
;*****************************************************************************************************************************************

#Include, include\MouseGesture_Gui.ahk