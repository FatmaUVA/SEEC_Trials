
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





; ============================ Parameters initialization ====================

Local $videoDir = "C:\Users\harlem1\Desktop\AUtoIT-scripts\"
Local $vdieoName= "COSMOS02.mp4"
Local $model = "Model3"
Local $timeInterval = 70000 ;unit ms
$station = "B3"

;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = @ScriptDir &"\" &$model & "-video-QoE.txt"

; Open file
Global $hFilehandle = FileOpen($sFileName, $FO_APPEND)

; Prove it exists
If FileExists($sFileName) Then
   ; MsgBox($MB_SYSTEMMODAL, "File", "Exists")
Else
    MsgBox($MB_SYSTEMMODAL, "File", "Does not exist")
 EndIf

;=========================== Read the user index to write results===================
;create a file to hold user index number (asociated with the pre-survey number
Global $indexFile = @ScriptDir &"\video-" & $station & ".txt"

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


;================================= task description ==========================
TaskDesc()

;================================ Start activity =========================
;open the video
;ShellExecute("C:\Users\harlem1\Desktop\AUtoIT-scripts\COSMOS.mp4")
ShellExecute($videoDir & $vdieoName)
Local $hApp = WinWaitActive($vdieoName & " - VLC media player")

Sleep($timeInterval)

;close the app
WinClose($hApp)

; QoE survey
Local $sQoE = survey()

;write results to File
FileWrite($hFilehandle, $sQoE & @CRLF)

;close app and file
;close the File
FileClose($hFilehandle)


; Thank you window
ThankYou()


Func MoveToNextStation()

   $msg = "Please move to the next station"

   $Form1 = GUICreate("Tank You", 700, 220,-1,-1)
   $Label1 = GUICtrlCreateLabel($msg, 16, 24, 680, 100)
   $Button1 = GUICtrlCreateButton("Ok", 260, 130, 163, 33)

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


Func ThankYou()

   $msg = "Would you like to continue with the 2018 Technology Trial, if so please click continue. If not, thank you for volunteering to participate in our study, click Exit to leave"

   $Form1 = GUICreate("Tank You", 886, 288, -1,-1)
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
			  GuiDelete($Form1)
			  MoveToNextStation()
			  ExitLoop
		   Case $Button2
			  GuiDelete($Form1)
			  LastThankYou()
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


;============================ Task Description ===================================
Func TaskDesc()

   $taskDesc = "During this task you will watch a 70 seconds video about the internet research that is ongoing in Harlem. When the video ends, a window will appear and ask you a question.  The question will ask you to rate your experience from bad (1) to excellent (5). Please rate your experience based on the quality of the video and audio and not the content of the video."
   $Form1 = GUICreate("Task Description", 971, 442, -1,-1)
   $Label1 = GUICtrlCreateLabel($taskDesc, 32, 32, 916, 313)
   $Button1 = GUICtrlCreateButton("Ok", 424, 384, 147, 33)

   ; setup the font size
   GUICtrlSetFont($Label1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
    WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on to

   GUISetState(@SW_SHOW)
   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
		 Case $GUI_EVENT_CLOSE
			ExitLoop
		 Case $Button1
			ExitLoop
	   EndSwitch
	WEnd
   GuiDelete($Form1)
EndFunc

; ============================QoE Survey GUI====================================
Func survey()
   $Form1 = GUICreate("Quality of Experience Survey", 671, 184, -1, -1)
   Global $Radio1 = GUICtrlCreateRadio("1 (Bad)", 40, 64, 113, 17)
   Global $Radio2 = GUICtrlCreateRadio("2 (Poor)", 153, 64, 113, 17)
   Global $Radio3 = GUICtrlCreateRadio("3 (Fair)", 266, 64, 113, 17)
   Global $Radio4 = GUICtrlCreateRadio("4 (Good)", 393, 64, 113, 17)
   Global $Radio5 = GUICtrlCreateRadio("5 (Excellent)", 535, 64, 113, 17)
   Global $Group1 = GUICtrlCreateGroup("How do you rate your experience?", 32, 32, 601, 65)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   Global $Button1 = GUICtrlCreateButton("Submit", 304, 128, 75, 25)
   GUISetState(@SW_SHOW)
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on top
   GUICtrlSetFont($Group1, 15, $FW_NORMAL)
   GUICtrlSetFont($Radio1, 12, $FW_NORMAL)
   GUICtrlSetFont($Radio2, 12, $FW_NORMAL)
   GUICtrlSetFont($Radio3, 12, $FW_NORMAL)
   GUICtrlSetFont($Radio4, 12, $FW_NORMAL)
   GUICtrlSetFont($Radio5, 12, $FW_NORMAL)
   GUICtrlSetFont($Button1, 12, $FW_NORMAL)


    ; Loop until the user clicks submit
    While 1
	  $idMsg = GUIGetMsg() ;Polls the GUI to see if any events have occurred.
	  Select
	  Case $idMsg = $GUI_EVENT_CLOSE
		 MsgBox($MB_OK,"Info","Please click <Submit> after you make your choice")
	  Case ($idMsg = $Button1) And (GUICtrlRead($Radio1) = 1 Or GUICtrlRead($Radio2) = 1 or GUICtrlRead($Radio3) = 1 or GUICtrlRead($Radio4) = 1 or GUICtrlRead($Radio5) = 1)
		 If GUICtrlRead($Radio1) = 1 Then
		   $sQoE = 1
		 ElseIf GUICtrlRead($Radio2) = 1 Then
		   $sQoE = 2
		 ElseIf GUICtrlRead($Radio3) = 1 Then
		   $sQoE = 3
		 ElseIf GUICtrlRead($Radio4) = 1 Then
		   $sQoE = 4
		 ElseIf GUICtrlRead($Radio5) = 1 Then
		   $sQoE = 5
		 EndIf
		 ;WriteToFile($sQoE)
		 ;MsgBox($MB_OK,"Info","You clicked submit")
		 ExitLoop
	  EndSelect
   WEnd
   GuiDelete($Form1)
   Return $sQoE

EndFunc
