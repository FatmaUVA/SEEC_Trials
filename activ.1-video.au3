#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	This activity includes playing a video with VLC

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

#RequireAdmin ; this required for clumsy to work properlys

; ============================ Parameters initialization ====================
; QoS
Local $aRTT[3] = [5,20, 50]
Local $aLoss[3] = [0,0.001,0.1] ;packet loss rate, unit is %
Local $videoDir = "C:\Users\harlem1\Desktop\AUtoIT-scripts\"
;Local $vdieoName = "Fast Five Stealing The Vault Scene.mp4"
Local $vdieoName= "COSMOS.mp4"
Local $timeInterval = 30000 ;in ms

;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = @ScriptDir &"\video-QoE.txt"

; Open file
Global $hFilehandle = FileOpen($sFileName, $FO_APPEND)

; Prove it exists
If FileExists($sFileName) Then
   ; MsgBox($MB_SYSTEMMODAL, "File", "Exists")
Else
    MsgBox($MB_SYSTEMMODAL, "File", "Does not exist")
 EndIf


;================================= task description ==========================
TaskDesc()

;================================ Start activity =========================
;open the video
;ShellExecute("C:\Users\harlem1\Desktop\AUtoIT-scripts\COSMOS.mp4")
ShellExecute($videoDir & $vdieoName)
;Local $hApp = WinWaitActive("COSMOS.mp4 - VLC media player")
Local $hApp = WinWaitActive($vdieoName & " - VLC media player")

;sleep for 10 sec
sleep($timeInterval)

; pause video
Send("{SPACE}")

;ask about experiance
Local $sQoE = survey()

;write results to File
FileWrite($hFilehandle, "0 0 " & $sQoE & @CRLF)

;change configuration with clumsy
;First start clumsy and set basic parameters
Local $hWnd = OpenClumsy()

For $i = 0 To UBound($aRTT) - 1
   For $j = 0 To UBound($aLoss) - 1

	  ;start clumsy
	  ChangeNetwork($hWnd, $aRTT[$i], $aloss[$j])

	  ;activate app window
	  WinActivate($hApp)

	  ;resume video
	  Send("{SPACE}")
	  ;sleep for xx sec
	  Sleep($timeInterval)

	  ;pause video
	  Send("{SPACE}")

	  ;Survey
	  $sQoE = Survey()

	  ;Write results to the File
	  FileWrite($hFilehandle, $aRTT[$i] & " " & $aLoss[$j] & " " & $sQoE & @CRLF)

   Next
Next

;stop network emulator
WinClose($hWnd)

;close the File
FileClose($hFilehandle)

;close the app
WinClose($hApp)
;============================ Task Description ===================================
Func TaskDesc()
   ;MsgBox($MB_OK,"Task Description"," During this task you will be asked to watch a 5 minutes video about the internet research that is ongoing in Harlem. The video will pause every 30 seconds and a window will appear and ask you a question.  The question will ask you to rate your experience so far from bad (1) to excellent (5). Please rate your experience based on the quality of the video and audio and not the content of the video.")
   $taskDesc = "During this task you will be asked to watch a 5 minutes video about the internet research that is ongoing in Harlem. The video will pause every 30 seconds and a window will appear and ask you a question.  The question will ask you to rate your experience so far from bad (1) to excellent (5). Please rate your experience based on the quality of the video and audio and not the content of the video."
   $Form1 = GUICreate("Task Description", 971, 442)
   $Label1 = GUICtrlCreateLabel($taskDesc, 32, 32, 916, 313)
   $Button1 = GUICtrlCreateButton("Ok", 424, 384, 147, 33)

   ; setup the font size
   GUICtrlSetFont($Label1, 20, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Button1, 15, $FW_NORMAL)

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
   Global $Radio2 = GUICtrlCreateRadio("2", 153, 64, 113, 17)
   Global $Radio3 = GUICtrlCreateRadio("3", 266, 64, 113, 17)
   Global $Radio4 = GUICtrlCreateRadio("4", 393, 64, 113, 17)
   Global $Radio5 = GUICtrlCreateRadio("5 (Excellent)", 535, 64, 113, 17)
   Global $Group1 = GUICtrlCreateGroup("How do you rate your experience?", 32, 32, 601, 65)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   Global $Button1 = GUICtrlCreateButton("Submit", 304, 128, 75, 25)
   GUISetState(@SW_SHOW)
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on top

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

Func WriteToFile($sQoE)
; Append a line
FileWrite($hFilehandle, @CRLF & $sQoE)
EndFunc

Func OpenClumsy()
   ShellExecute("C:\Users\harlem1\Downloads\clumsy-0.2-win64\clumsy.exe")
   Local $hWnd = WinWaitActive("clumsy 0.2")
   ;basic setup
   ; clear the filter text filed
   ControlSetText($hWnd,"", "Edit1", "outbound")

   ; set check box for lag (delay)
   ControlClick($hWnd, "","Button4", "left", 1,8,8) ;1 click 8,8 coordinate

   ;set check box for drop
   ControlClick($hWnd, "","Button7", "left", 1,8,8)

   Return $hWnd
EndFunc

Func ChangeNetwork($hWnd, $RTT, $loss)

   ;make sure it is active
   WinActivate($hWnd)

   ;stop clumsy
   ControlClick($hWnd, "","Button2", "left", 1,8,8)

   ;set delay
   ControlSetText($hWnd,"", "Edit2", $RTT)

   ;add packet drop
   ControlSetText($hWnd,"", "Edit3", $loss)

   ;start
   ControlClick($hWnd, "","Button2", "left", 1,8,8)

EndFunc
