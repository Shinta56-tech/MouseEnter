;*****************************************************************************************************************************************
; Initialize
;*****************************************************************************************************************************************

initDefault() {
    Gosub initDefault
}

initDefault:

    vIni := "ini\OperationFeeling.ini"

    Global LONG_PRESS_DELAY
    IniRead, LONG_PRESS_DELAY, %vIni%, OperationFeeling, LONG_PRESS_DELAY, 0.1

    Global DUBL_CLICK_DELAY
    IniRead, DUBL_CLICK_DELAY, %vIni%, OperationFeeling, DUBL_CLICK_DELAY, 300

Return