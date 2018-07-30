
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Fatma Alali

 Script Function:
	This script

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <FontConstants.au3>
#include <AutoItConstants.au3>

;#pragma compile(AutoItExecuteAllowed, true)
#RequireAdmin

Local $activity [3] = ["activ.4-GIMP.au3"];["activ.1-video.au3"]; ,"activ.4-GIMP.au3","activ.3-Game (2).au3"]

;informed consent pre-survey
$dir = "C:\Users\harlem1\Desktop\AUtoIT-scripts\"
$scriptName = "pre-survey2.au3"
;RunWait(@AutoItExe & ' /AutoIt3ExecuteScript "C:\Users\harlem1\Desktop\AUtoIT-scripts\pre-survey.au3"')
RunWait(@AutoItExe & " /AutoIt3ExecuteScript "& $dir & $scriptName)

For $i = 0 To 0 ;UBound($activity) - 1

   ;start activity
   $scriptName = $activity [$i]
   RunWait(@AutoItExe & " /AutoIt3ExecuteScript "& $dir & $scriptName)

   ;Thank you window
   ThankYou()

Next

LastThankYou()

Func ThankYou()

   $msg = "Would you like to continue with the 2018 Technology Trial, if so please click continue. If not, thank you for volunteering to participate in our study, click Exit to leave"

   $Form1 = GUICreate("Tank You", 886, 288, 288, 177)
   $Label1 = GUICtrlCreateLabel($msg, 16, 24, 852, 177)
   $Button1 = GUICtrlCreateButton("Continue", 232, 232, 163, 33)
   $Button2 = GUICtrlCreateButton("Exit", 504, 232, 163, 33)

   ; setup the font size
   GUICtrlSetFont($Label1, 20, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Button1,15, $FW_NORMAL)
   GUICtrlSetFont($Button2, 15, $FW_NORMAL)

   GUISetState(@SW_SHOW)
   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
		   Case $GUI_EVENT_CLOSE
			   MsgBox($MB_OK,"Info","Please click on Continue or Exit to leave")
		   Case $Button1
			  ExitLoop
		   Case $Button2
			  Exit
	   EndSwitch
   WEnd
   GuiDelete($Form1)
EndFunc

;Last Thank you window
Func LastThankYou()

   $msg = "Thank you for volunteering to participate in our study."

   $Form1 = GUICreate("Tank You", 700, 220)
   $Label1 = GUICtrlCreateLabel($msg, 16, 24, 680, 100)
   $Button1 = GUICtrlCreateButton("Exit", 260, 130, 163, 33)

   ; setup the font size
   GUICtrlSetFont($Label1, 20, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Button1,15, $FW_NORMAL)

   GUISetState(@SW_SHOW)

   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
			Case $GUI_EVENT_CLOSE
			   Exit
			Case $Button1
			   Exit
	   EndSwitch
   WEnd
   GuiDelete($Form1)
EndFunc





