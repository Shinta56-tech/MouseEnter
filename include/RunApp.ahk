;*****************************************************************************************************************************************
; Initialize
;*****************************************************************************************************************************************

initRunApp() {
    initPassLib()
}

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

runOrSetAppkey(pButtonName) {
    vIni := "ini/RunApp.ini"
    vLongPressTime := LONG_PRESS_DELAY * 5
    KeyWait, %pButtonName%, T%vLongPressTime%
    If (ErrorLevel) {
        WinGet, PID, PID, A
        FullEXEPath := getModuleFileNameEx( PID )
        IniWrite, %FullEXEPath%, %vIni%, RUNAPP, %pButtonName%
        KeyWait, %pButtonName%
    } Else {
        IniRead, AppPath, %vIni%, RUNAPP, %pButtonName%
        If (AppPath <> "ERROR" ) {
        	Run, open %AppPath%
        }
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

#If gfShiftSC

1::showGuiPasswordLibrary()

q::runOrSetAppkey("Q")
w::runOrSetAppkey("W")
e::runOrSetAppkey("E")
r::runOrSetAppkey("R")
t::runOrSetAppkey("T")
a::runOrSetAppkey("A")
s::runOrSetAppkey("S")
d::runOrSetAppkey("D")
f::runOrSetAppkey("F")
g::runOrSetAppkey("G")
z::runOrSetAppkey("Z")
x::runOrSetAppkey("X")
c::runOrSetAppkey("C")
v::runOrSetAppkey("V")
b::runOrSetAppkey("B")

;*****************************************************************************************************************************************
; Include
;*****************************************************************************************************************************************

#Include include\PassLib.ahk