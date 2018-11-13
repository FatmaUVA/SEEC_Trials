
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

Global $station = "A1"
;Local $activity1 [3] = ["imageView-trial.au3", "Insta360-trial.au3", "skype.au3" ];["activ.1-video.au3" , "activ.3-Game.au3"];["activ.1-video.au3", "activ.3-Game-jigsaw.au3"];, "A-360player.au3"];[ "activ.3-Game-jigsaw.au3","activ.1-video.au3"]; ,"activ.4-GIMP.au3","activ.3-Game.au3"]
Local $dir = "C:\Users\Harlem5\Desktop\SEEC_Trials\"


;=========================== Read the randomize number for activities order===================

Global $indexFile = $dir & $station & "-random-num.txt"
; Open the file for reading and store the handle to a variable.
Local $hIndexFile = FileOpen($indexFile, $FO_READ)

; Read the contents of the file using the handle returned by FileOpen.
Local $userIndex = FileRead($hIndexFile)

; Close the handle returned by FileOpen.
FileClose($hIndexFile)
;MsgBox($MB_SYSTEMMODAL, "", "Contents of the file:" & @CRLF & $userIndex)

$ranNo=Number($userIndex)
$x = Mod($ranNo + 1,6); six combination based on 0, 1,2,3,4,5
;MsgBox($MB_SYSTEMMODAL, "", "Contents of the file after addition:" & @CRLF & $x)
;Open file again to write the new index
Global $hIndexFile = FileOpen($indexFile, $FO_OVERWRITE)
FileWrite($hIndexFile,$x)
FileClose($hIndexFile)

;=========================== Define activities based on station and random number ====================
If $station == "A1" Then
   Local $activity1 [3] = ["imageView-trial.au3", "Insta360-trial.au3", "skype.au3" ]
ElseIf $station == "A2" Then
   Local $activity1 [3] = ["imageView-trial.au3", "Insta360-trial.au3", "activ.1-video.au3" ]
EndIf

If $ranNo == 0 Then
   Local $activity [3] = [$activity1[0], $activity1[1], $activity1[2]]
ElseIf  $ranNo == 1 Then
	Local $activity [3] = [$activity1[1], $activity1[0], $activity1[2]]
ElseIf  $ranNo == 2 Then
	Local $activity [3] = [$activity1[2], $activity1[0], $activity1[1]]
ElseIf  $ranNo == 3 Then
	Local $activity [3] = [$activity1[2], $activity1[1], $activity1[0]]
ElseIf  $ranNo == 4 Then
	Local $activity [3] = [$activity1[0], $activity1[2], $activity1[1]]
ElseIf  $ranNo == 5 Then
	Local $activity [3] = [$activity1[1], $activity1[2], $activity1[0]]
 EndIf


;=========================== Read the user index to write results===================
;create a file to hold user index number (asociated with the pre-survey number
;Global $indexFile = @ScriptDir &"\" & $station & "-user-index.txt"
Global $indexFile = $dir & $station & "-user-index.txt"
; Open the file for reading and store the handle to a variable.
Local $hIndexFile = FileOpen($indexFile, $FO_READ)

; Read the contents of the file using the handle returned by FileOpen.
Local $userIndex = FileRead($hIndexFile)

; Close the handle returned by FileOpen.
FileClose($hIndexFile)
;MsgBox($MB_SYSTEMMODAL, "", "Contents of the file:" & @CRLF & $userIndex)

$x=Number($userIndex)+1
;MsgBox($MB_SYSTEMMODAL, "", "Contents of the file after addition:" & @CRLF & $x)
;Open file again to write the new index
Global $hIndexFile = FileOpen($indexFile, $FO_OVERWRITE)
FileWrite($hIndexFile,$x)
FileClose($hIndexFile)

;===========start=================

;informed consent pre-survey
;$dir = "C:\Users\harlem1\Desktop\AUtoIT-scripts\"
$scriptName = "pre-survey.au3"
RunWait(@AutoItExe & " /AutoIt3ExecuteScript "& $dir & $scriptName)

;pre-survey
$scriptName = "pre-survey-questions.au3" ;
RunWait(@AutoItExe & " /AutoIt3ExecuteScript "& $dir & $scriptName &" " & $station)


$count=0
For $i = 0 To UBound($activity) - 1

   ;start activity
   $scriptName = $activity[$i]
   RunWait(@AutoItExe & " /AutoIt3ExecuteScript "& $dir & $scriptName & " " & $station)

   $count = $count + 1

   ; if this is the last activity don't show the ThankYou window
   If $count < UBound($activity) Then
	  ;Thank you window
	  ThankYou()
   EndIf

Next

LastThankYou()

Func ThankYou()

   $msg = "Would you like to continue with the 2018 Technology Trial, if so please click continue. If not, thank you for volunteering to participate in our study, click Exit to leave"

   $Form1 = GUICreate("Thank You", 886, 288) ;, 288, 177)
   $Label1 = GUICtrlCreateLabel($msg, 16, 24, 852, 177)
   $Button1 = GUICtrlCreateButton("Continue", 232, 232, 163, 33)
   $Button2 = GUICtrlCreateButton("Exit", 504, 232, 163, 33)

   ; setup the font size
   GUICtrlSetFont($Label1, 20, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Button1,15, $FW_NORMAL)
   GUICtrlSetFont($Button2, 15, $FW_NORMAL)
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on top

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
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on top

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




