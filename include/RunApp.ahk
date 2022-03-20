;*****************************************************************************************************************************************
; Initialize
;*****************************************************************************************************************************************

initRunApp() {
    Gosub, initRunApp
    initPassLib()
}

initRunApp:
    Global INI_RUNAPP := "ini/RunApp.ini"
Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

setApp(pB) {
    WinGet, PID, PID, A
    FullEXEPath := getModuleFileNameEx( PID )
    IniWrite, %FullEXEPath%, %INI_RUNAPP%, RUNAPP, %pB%
    MsgBox, % "Set App !`nKey:" . pB . "`nPath:" . FullEXEPath
}

runApp(pB) {
    IniRead, AppPath, %INI_RUNAPP%, RUNAPP, %pB%
    If (AppPath <> "ERROR" ) {
        Run, open %AppPath%
    } Else {
        MsgBox, No App
    }
}

getModuleFileNameEx(p_pid) {
    h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )
    if ( ErrorLevel or h_process = 0 )
        return
    name_size = 255
    VarSetCapacity( name, name_size )
    result := DllCall( "psapi.dll\GetModuleFileNameEx", "uint", h_process, "uint", 0, "Str"
    , name, "uint", name_size )
    DllCall( "CloseHandle", h_process )
    return name
}

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

#If !checkNoDesktop() && GetKeyState("RControl", "P") && GetKeyState("RShift", "P") && !GetKeyState("RButton", "P")

q::runApp("Q")
w::runApp("W")
e::runApp("E")
r::runApp("R")
t::runApp("T")
a::runApp("A")
s::runApp("S")
d::runApp("D")
f::runApp("F")
g::runApp("G")
z::runApp("Z")
x::runApp("X")
c::runApp("C")
v::runApp("V")
b::runApp("B")

1::runPassLib()
2::Return
3::Return
4::Return
5::Return

#If !checkNoDesktop() && GetKeyState("RControl", "P") && GetKeyState("RShift", "P") && GetKeyState("RButton", "P")

q::setApp("Q")
w::setApp("W")
e::setApp("E")
r::setApp("R")
t::setApp("T")
a::setApp("A")
s::setApp("S")
d::setApp("D")
f::setApp("F")
g::setApp("G")
z::setApp("Z")
x::setApp("X")
c::setApp("C")
v::setApp("V")
b::setApp("B")

#If checkNoDesktop() && GetKeyState("RControl", "P") && GetKeyState("RShift", "P") && GetKeyState("LShift", "P")

1::runPassLib()
2::Return
3::Return
4::Return
5::Return

;*****************************************************************************************************************************************
; Include
;*****************************************************************************************************************************************

#Include, include\RunApp_PassLib.ahk
