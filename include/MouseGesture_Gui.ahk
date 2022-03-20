;*****************************************************************************************************************************************
; Initialize
;*****************************************************************************************************************************************

initMouseGesture_Gui() {

    Gosub initMouseGesture_Gui

    Gui, MG_SET:New
    Gui, MG_SET:Add, Button, gBAdd Section, Add
    Gui, MG_SET:Add, Button, gBUpdate yp+0 x+20, Update
    Gui, MG_SET:Add, Button, gBCopy yp+0 x+20, Copy
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

    Gui, MG_ADD:New
    Gui, MG_ADD:Add, Text, Section, Col1
    Gui, MG_ADD:Add, Edit, xs+50 yp+0 w300 vgEditColAdd1
    Gui, MG_ADD:Add, Text, xs+0 y+10, Col2
    Gui, MG_ADD:Add, Edit, xs+50 yp+0 w300 vgEditColAdd2
    Gui, MG_ADD:Add, Text, xs+0 y+10, Col3
    Gui, MG_ADD:Add, Edit, xs+50 yp+0 w300 vgEditColAdd3
    Gui, MG_ADD:Add, Button, w200 vgOkAdd gBOkAdd xm+80 y+10, Add

    Gui, MG_UPD:New
    Gui, MG_UPD:Add, Text, Section, Col1
    Gui, MG_UPD:Add, Edit, xs+50 yp+0 w300 vgEditColUpd1
    Gui, MG_UPD:Add, Text, xs+0 y+10, Col2
    Gui, MG_UPD:Add, Edit, xs+50 yp+0 w300 vgEditColUpd2
    Gui, MG_UPD:Add, Text, xs+0 y+10, Col3
    Gui, MG_UPD:Add, Edit, xs+50 yp+0 w300 vgEditColUpd3
    Gui, MG_UPD:Add, Button, w200 vgOkUpd gBOkUpd xm+80 y+10, Update
}

initMouseGesture_Gui:
    Global gLv1, gLv2, gLv3
    Global gEditColAdd1, gEditColAdd2, gEditColAdd3, gOkAdd
    Global gEditColUpd1, gEditColUpd2, gEditColUpd3, gOkUpd
    Global gBefoEditCol1
Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

showGestureSet() {
    Gui, MG_SET:Default

    Gui, MG_SET:ListView, gLv1
    initListView(MG_PROFILE_FOLDER_PATH . gAhkExe . ".ini", "HotKey")

    Gui, MG_SET:ListView, gLv2
    initListView(MG_PROFILE_FOLDER_PATH . gAhkExe . ".ini", "WinTitle")

    Gui, MG_SET:ListView, gLv3
    initListView(MG_PROFILE_FOLDER_PATH . "Default.ini", "HotKey")

    Gosub, TabChange

    Gui, MG_SET:Show, , %gAhkExe% Gesture Setting
    WinSet, AlwaysOnTop, On, %gAhkExe% Gesture Setting
}

initListView(pIniPath, pSection) {
    LV_Delete()
    IniRead, iHotKeys, %pIniPath%, %pSection%
    Loop, Parse, iHotKeys, `n
    {

        If (RegExMatch(A_LoopField, "^(.*)=(.*)`::(.*)$", found)) {
            LV_Add(, found1, found2, found3)
        } Else If (RegExMatch(A_LoopField, "^(.*)=(.*)$", found)) {
            LV_Add(, found1, found2)
        }
    }
    LV_ModifyCol()
}

;*****************************************************************************************************************************************
; Label
;*****************************************************************************************************************************************

TabChange:
    Gui, MG_SET:Default
    Gui, MG_SET:Submit, NoHide
    Gui, MG_SET:ListView, gLv%Tabs%
Return

BPlofiles:
    Run, %MG_PROFILE_FOLDER_PATH%
Return

BAdd:
    If (Tabs == 2) {
        GuiControl, MG_ADD:Text, gEditColAdd1, %gWinTitle%
    } Else {
        GuiControl, MG_ADD:Text, gEditColAdd1, %gGestureText%
    }
    GuiControl, MG_ADD:Text, gEditColAdd2,
    GuiControl, MG_ADD:Text, gEditColAdd3,
    Gui, MG_ADD:Show, , Mouse Gesture Rigister
    WinSet, AlwaysOnTop, On, Mouse Gesture Rigister
Return

BUpdate:
    If (LV_GetNext() = 0) {
        Return
    }
    LV_GetText(vCol1, LV_GetNext(), 1)
    LV_GetText(vCol2, LV_GetNext(), 2)
    LV_GetText(vCol3, LV_GetNext(), 3)
    gBefoEditCol1 := vCol1
    Gui, MG_UPD:Default
    GuiControl, MG_UPD:Text, gEditColUpd1, %vCol1%
    GuiControl, MG_UPD:Text, gEditColUpd2, %vCol2%
    GuiControl, MG_UPD:Text, gEditColUpd3, %vCol3%
    Gui, MG_UPD:Show, , Mouse Gesture Update
    WinSet, AlwaysOnTop, On, Mouse Gesture Update
Return

BCopy:
    If (LV_GetNext() = 0) {
        Return
    }
    LV_GetText(vCol1, LV_GetNext(), 1)
    LV_GetText(vCol2, LV_GetNext(), 2)
    LV_GetText(vCol3, LV_GetNext(), 3)
    LV_Add(, "! " . vCol1, vCol2, vCol3)
    LV_ModifyCol()
    vValue := vCol2
    If (vCol3<>"") {
        vValue := vValue . "`::" . vCol3
    }
    If (Tabs == 1) {
        vIniPath := MG_PROFILE_FOLDER_PATH . gAhkExe . ".ini"
        vSection := "HotKey"
    } Else If (Tabs == 2) {
        vIniPath := MG_PROFILE_FOLDER_PATH . gAhkExe . ".ini"
        vSection := "WinTitle"
    } Else If (Tabs == 3) {
        vIniPath := MG_PROFILE_FOLDER_PATH . "Default.ini"
        vSection := "HotKey"
    }
    IniWrite, %vValue%, %vIniPath%, %vSection%, % "! " . vCol1
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
    Gui, MG_ADD:Submit, NoHide
    Gui, MG_ADD:Hide
    If (Tabs == 1) {
        vIniPath := MG_PROFILE_FOLDER_PATH . gAhkExe . ".ini"
        vSection := "HotKey"
    } Else If (Tabs == 2) {
        vIniPath := MG_PROFILE_FOLDER_PATH . gAhkExe . ".ini"
        vSection := "WinTitle"
    } Else If (Tabs == 3) {
        vIniPath := MG_PROFILE_FOLDER_PATH . "Default.ini"
        vSection := "HotKey"
    }
    Gui, MG_SET:Default
    Gui, MG_SET:ListView, gLv%Tabs%
    LV_Add(, gEditColAdd1, gEditColAdd2, gEditColAdd3)
    LV_ModifyCol()
    vValue := gEditColAdd2
    If (gEditColAdd3<>"") {
        vValue := vValue . "`::" . gEditColAdd3
    }
    IniWrite, %vValue%, %vIniPath%, %vSection%, %gEditColAdd1%
Return

BOkUpd:
    Gui, MG_UPD:Submit, NoHide
    Gui, MG_UPD:Hide
    If (Tabs == 1) {
        vIniPath := MG_PROFILE_FOLDER_PATH . gAhkExe . ".ini"
        vSection := "HotKey"
    } Else If (Tabs == 2) {
        vIniPath := MG_PROFILE_FOLDER_PATH . gAhkExe . ".ini"
        vSection := "WinTitle"
    } Else If (Tabs == 3) {
        vIniPath := MG_PROFILE_FOLDER_PATH . "Default.ini"
        vSection := "HotKey"
    }
    Gui, MG_SET:Default
    Gui, MG_SET:ListView, gLv%Tabs%
    vRowNum := LV_GetNext()
    LV_Modify(vRowNum, , gEditColUpd1, gEditColUpd2, gEditColUpd3)
    LV_ModifyCol()
    IniDelete, %vIniPath%, %vSection%, %gBefoEditCol1%
    vValue := gEditColUpd2
    If (gEditColUpd3<>"") {
        vValue := vValue . "`::" . gEditColUpd3
    }
    IniWrite, %vValue%, %vIniPath%, %vSection%, %gEditColUpd1%
Return