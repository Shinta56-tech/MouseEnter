;*****************************************************************************************************************************************
; Standard Setting
;*****************************************************************************************************************************************

#Persistent
#SingleInstance, Force
#NoEnv
#UseHook
#InstallKeybdHook
#InstallMouseHook
#HotkeyInterval, 2000
#MaxHotkeysPerInterval, 200

Process, Priority, , Realtime
SendMode, Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2
SetMouseDelay -1
SetKeyDelay, -1
SetBatchLines, -1
CoordMode, Mouse, Screen

;*****************************************************************************************************************************************
; Initialize
;*****************************************************************************************************************************************

initDefault()
initRunApp()
iniMouseTyping()
initMouseGesture()

Return

^!Escape::ExitApp

;*****************************************************************************************************************************************
; Include
;*****************************************************************************************************************************************

#Include include\Default.ahk
#Include include\MouseTyping.ahk
#Include include\RunApp.ahk
#Include include\MouseGesture.ahk