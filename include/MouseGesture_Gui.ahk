;*****************************************************************************************************************************************
; Initialize
;*****************************************************************************************************************************************

initMouseGesture_Gui() {

    Gosub initMouseGesture_Gui

    Gui, MG_SET:New
    Gui, MG_SET:Add, Button, gBAdd Section, Add
    Gui, MG_SET:Add, Button, gBUpdate yp+0 x+20, Update
    Gui, MG_SET:Add, Button, gBDelete yp+0 x+20, Delete
    Gui, MG_SET:Add, Button, gBPlofiles yp+0 x+40, Plofiles
    Gui, MG_SET:Add, Tab2, w600 h300 vTabs gTabChange AltSubmit xm+5 Section, Gesture|Move Plofile|Default Gesture
    Gui, MG_SET:Tab, 1
    Gui, MG_SET:Add, ListView, r14 w550 xs+10 ys+30 Sort vgLv1, Gesture|Hotkey|Text
    Gui, MG_SET:Tab, 2
    Gui, MG_SET:Add, ListView, r14 w550 xs+10 ys+30 Sort vgLv2, WinTitle|Profile
    Gui, MG_SET:Tab, 3
    Gui, MG_SET:Add, ListView, r14 w550 xs+10 ys+30 Sort vgLv3, Gesture|Hotkey|Text
    Gui, MG_SET:Tab
    Gui, MG_SET:ListView, Lv1
    Gui, MG_SET:Submit, NoHide

    Gui, MG_REG:New
    Gui, MG_REG:Add, Text, Section, Col1
    Gui, MG_REG:Add, Edit, xs+50 yp+0 w300 vgEditCol1
    Gui, MG_REG:Add, Text, xs+0 y+10, Col2
    Gui, MG_REG:Add, Edit, xs+50 yp+0 w300 vgEditCol2
    Gui, MG_REG:Add, Text, xs+0 y+10, Col3
    Gui, MG_REG:Add, Edit, xs+50 yp+0 w300 vgEditCol3
    Gui, MG_REG:Add, Button, w200 gBOkAdd xm+80 y+10 Section, Add
    Gui, MG_REG:Add, Button, w200 gBOkUpd xs+0 ys+0, Update
}

initMouseGesture_Gui:
    Global gLv1, gLv2, gLv3
    Global gEditCol1, gEditCol2, gEditCol3, gOkAdd, gOkUpd
    Global gBefoEditCol1
Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

showGestureSet() {
    Gui, MG_SET:Default

    Gui, MG_SET:ListView, gLv1
    LV_Delete()
    IniRead, iHotKeys, %MG_PROFILE_FOLDER_PATH%%gAhkExe%.ini, HotKey
    Loop, Parse, iHotKeys, `n
    {

        If (RegExMatch(A_LoopField, "^(.*)=(.*)`::(.*)$", found)) {
            LV_Add(, found1, found2, found3)
        }
    }
    LV_ModifyCol()

    Gui, MG_SET:ListView, gLv2
    LV_Delete()
    IniRead, iHotKeys, %MG_PROFILE_FOLDER_PATH%%gAhkExe%.ini, WinTitle
    Loop, Parse, iHotKeys, `n
    {

        If (RegExMatch(A_LoopField, "^(.*)=(.*)$", found)) {
            LV_Add(, found1, found2)
        }
    }
    LV_ModifyCol()

    Gui, MG_SET:ListView, gLv3
    LV_Delete()
    IniRead, iHotKeys, %MG_PROFILE_FOLDER_PATH%Default.ini, HotKey
    Loop, Parse, iHotKeys, `n
    {

        If (RegExMatch(A_LoopField, "^(.*)=(.*)`::(.*)$", found)) {
            LV_Add(, found1, found2, found3)
        }
    }
    LV_ModifyCol()

    Gui, MG_SET:Show, , %gAhkExe% Gesture Setting
    WinSet, AlwaysOnTop, On, %gAhkExe% Gesture Setting
}

;*****************************************************************************************************************************************
; Label
;*****************************************************************************************************************************************

TabChange:
    Gui, Submit, NoHide
    Gui, ListView, gLv%Tabs%
Return

BPlofiles:
    Run, %MG_PROFILE_FOLDER_PATH%
Return

BAdd:
    If (Tabs == 2) {
        GuiControl, MG_REG:Text, gEditCol1, %gWinTitle%
    } Else {
        GuiControl, MG_REG:Text, gEditCol1, %gGestureText%
    }
    GuiControl, MG_REG:Text, gEditCol2,
    GuiControl, MG_REG:Text, gEditCol3,
    GuiControl, MG_REG:Show, gBOkAdd
    GuiControl, MG_REG:Hide, gBOkUpd
    Gui, MG_REG:Show, , Mouse Gesture Rigister
    WinSet, AlwaysOnTop, On, Mouse Gesture Rigister
Return

BUpdate:
    Gui, MG_SET:Default
    Gui, MG_SET:ListView, gLv%Tabs%
    If (LV_GetNext() = 0) {
        Return
    }
    LV_GetText(vCol1, LV_GetNext(), 1)
    LV_GetText(vCol2, LV_GetNext(), 2)
    LV_GetText(vCol3, LV_GetNext(), 3)
    Gui, MG_REG:Default
    gBefoEditCol1 := vCol1
    If (Tabs == 2) {
        GuiControl, MG_REG:Text, gEditCol1, %vCol1%
        GuiControl, MG_REG:Text, gEditCol2, %vCol2%
        GuiControl, MG_REG:Text, gEditCol3, 
    } Else {
        GuiControl, MG_REG:Text, gEditCol1, %vCol1%
        GuiControl, MG_REG:Text, gEditCol2, %vCol2%
        GuiControl, MG_REG:Text, gEditCol3, %vCol3%
    }
    GuiControl, MG_REG:Hide, gBOkAdd
    GuiControl, MG_REG:Show, gBOkUpd
    Gui, MG_REG:Show, , Mouse Gesture Rigister
    WinSet, AlwaysOnTop, On, Mouse Gesture Rigister
Return

BDelete:
    Gui, MG_SET:Submit, NoHide
    If (Tabs == 1) {
        vCateg := "HotKey"
        vInifile := gAhkExe . ".ini"
    } Else If (Tabs == 2) {
        vCateg := "WinTitle"
        vInifile := gAhkExe . ".ini"
    } Else If (Tabs == 3) {
        vCateg := "HotKey"
        vInifile := "Default.ini"
    }
    Gui, MG_SET:Default
    Gui, MG_SET:ListView, gLv%Tabs%
    LV_GetText(vKey, LV_GetNext())
    IniDelete, %MG_PROFILE_FOLDER_PATH%%vInifile%, %vCateg%, %vKey%
    LV_Delete(LV_GetNext())
    LV_ModifyCol()
Return

BOkAdd:
    Gui, MG_REG:Submit, NoHide
    Gui, MG_REG:Hide
    If (Tabs == 1) {
        vInput := gEditCol2 . "`::" . gEditCol3
        vRegex := "^(.+)=(.+)`::(.+)$"
        vCateg := "HotKey"
        vInifile := gAhkExe . ".ini"
    } Else If (Tabs == 2) {
        vInput := gEditCol2
        vRegex := "^(.+)=(.+)$"
        vCateg := "WinTitle"
        vInifile := gAhkExe . ".ini"
    } Else If (Tabs == 3) {
        vInput := gEditCol2 . "`::" . gEditCol3
        vRegex := "^(.+)=(.+)`::(.+)$"
        vCateg := "HotKey"
        vInifile := "Default.ini"
    }
    vValue := gEditCol1 . "=" . vInput
    If (RegExMatch(vValue, vRegex)) {
        Gui, MG_SET:Default
        Gui, MG_SET:ListView, gLv%Tabs%
        LV_Add(, gEditCol1, gEditCol2, gEditCol3)
        LV_ModifyCol()
        IniWrite, %vInput%, %MG_PROFILE_FOLDER_PATH%%vInifile%, %vCateg%, %gEditCol1%
    }
Return

BOkUpd:
    Gui, MG_REG:Submit, NoHide
    Gui, MG_REG:Hide
    If (Tabs == 1) {
        vInput := gEditCol2 . "`::" . gEditCol3
        vRegex := "^(.+)=(.+)`::(.+)$"
        vCateg := "HotKey"
        vInifile := gAhkExe . ".ini"
    } Else If (Tabs == 2) {
        vInput := gEditCol2
        vRegex := "^(.+)=(.+)$"
        vCateg := "WinTitle"
        vInifile := gAhkExe . ".ini"
    } Else If (Tabs == 3) {
        vInput := gEditCol2 . "`::" . gEditCol3
        vRegex := "^(.+)=(.+)`::(.+)$"
        vCateg := "HotKey"
        vInifile := "Default.ini"
    }
    vValue := gEditCol1 . "=" . vInput
    If (RegExMatch(vValue, vRegex)) {
        Gui, MG_SET:Default
        Gui, MG_SET:ListView, gLv%Tabs%
        vRowNum := LV_GetNext()
        LV_Modify(vRowNum, , gEditCol1, gEditCol2, gEditCol3)
        LV_ModifyCol()
        IniDelete, %MG_PROFILE_FOLDER_PATH%%vInifile%, %vCateg%, %gBefoEditCol1%
        IniWrite, %vInput%, %MG_PROFILE_FOLDER_PATH%%vInifile%, %vCateg%, %gEditCol1%
    }
Return