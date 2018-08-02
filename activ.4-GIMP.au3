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
Local $aRTT[3] = [50,10, 50]
Local $aLoss[3] = [0.5,0.001,0.1] ;packet loss rate, unit is %
Local $videoDir = "C:\Users\harlem1\Desktop\AUtoIT-scripts\"
Local $appName= "gimp-2.10.exe"
Local $winTitle = "GNU Image Manipulation Program"

;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = @ScriptDir &"\gimp-QoE.txt"

; Open file
Global $hFilehandle = FileOpen($sFileName, $FO_APPEND)
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

;change network
;change configuration with clumsy
;First start clumsy and set basic parameters
Local $hWnd = OpenClumsy()
ChangeNetwork($hWnd, $aRTT[0], $aLoss[0])


;open the app
ShellExecute("C:\Program Files\GIMP 2\bin\gimp-2.10.exe")
$hApp = WinWaitActive($winTitle)
;$hApp2 = WinGetHandle($winTitle)

;show window to start the activity
InfoWnd(1)

;#comments-start
;show done window
DoneWnd()

;#comments-start
;QoE survey
Local $sQoE = survey()

;write results
FileWrite($hFilehandle, $aRTT[0] &" " & $aLoss[0] & " " & $sQoE & @CRLF)

;stop network emulator
WinActivate($hWnd)
ControlClick($hWnd, "","Button2", "left", 1,8,8)

;change network
ChangeNetwork($hWnd, $aRTT[1], $aLoss[1])
;minimize clumsy window
 WinSetState($hWnd, "", @SW_MINIMIZE)

;show window to start second activity
;activate GIMP window
WinActivate($hApp) ; this is not working, not sure why, spent so much time debugging but no luck!
;MsgBox($MB_OK,"Info","Follow the instructions in the provided sheet to edit the photo. When you finish, click on the Done button which will show up in the lower right corner")
InfoWnd(2)

;show done window
DoneWnd()


;QOE survey
Local $sQoE = survey()

;write results
FileWrite($hFilehandle, $aRTT[1] &" " & $aLoss[1] & " " & $sQoE & @CRLF)

;close file and all app
WinClose($hWnd) ;didn't work, so kill process from ShellExecute
RunWait("taskkill /IM gimp-2.10.exe")
;discard changes
Sleep(700)
Send("^d") ;send CTRL+D to discard changes in GIMP
WinClose($hApp)
;close the File
FileClose($hFilehandle)

;#comments-end

;============================ Task Description ===================================
Func TaskDesc()

   ;$taskDesc = "During this task you will be asked to edit an image using Adobe Photo Shop by performing two steps:" & @CRLF & "   (i) The first step will be to change the background color on the picture. Prompts will direct you on how to change the background using the tools provided in the table on the right-side of the screen. After finishingthe first step click the “done” button, which is on the right lower corner of the screen. The second step will be to use the smudge tool. First select the smudge tool and the click the mouse and drag the cursor across the screen. Prompts will direct you on how to select and use the smudge tool. In between the two steps a window will appear and ask you a question.  The question will ask you to rate your experience so far from bad (1) to excellent (5). Please rate your experience based on the responsiveness of the software and the image quality and not the ease or difficulty of the task"
   $taskDesc = "During this task you will be asked to edit an image using GIMP by performing two steps:" & @CRLF & @CRLF & "(i) The first step will be to change the background color on the picture. Prompts will direct you on how to change the background using the tools provided in the table on the right-side of the screen. After finishing the first step click the “done” button, which is on the right lower corner of the screen." &@CRLF & @CRLF & "(ii) The second step will be to use the smudge tool. First select the smudge tool and the click the mouse and drag the cursor across the screen. Prompts will direct you on how to select and use the smudge tool." &@CRLF & @CRLF & "In between the two steps a window will appear and ask you a question.  The question will ask you to rate your experience so far from bad (1) to excellent (5). Please rate your experience based on the responsiveness of the software and the image quality and not the ease or difficulty of the task."
   $Form1 = GUICreate("Task Description", 971, 442)
   $Label1 = GUICtrlCreateLabel($taskDesc, 32, 32, 916, 313)
   $Button1 = GUICtrlCreateButton("Ok", 424, 384, 147, 33)

   ; setup the font size
   GUICtrlSetFont($Label1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.

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

   GUICtrlSetFont($Button1, 11, $FW_NORMAL)
   GUICtrlSetFont($Group1, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio1, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio2, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio3, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio4, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio5, 11, $FW_NORMAL)

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
   ;ControlClick($hWnd, "","Button2", "left", 1,8,8)

   ;set delay
   ControlSetText($hWnd,"", "Edit2", $RTT)

   ;add packet drop
   ControlSetText($hWnd,"", "Edit3", $loss)

   ;start
   ControlClick($hWnd, "","Button2", "left", 1,8,8)

EndFunc

Func DoneWnd ()
   $Form1 = GUICreate("Info", 434, 164,1240,820);1450, 770);high,width,left,top
   $Label1 = GUICtrlCreateLabel("Click Done ONLY when you finish the photo editing activity ", 8, 16, 420, 81)
   $Button1 = GUICtrlCreateButton("Done", 192, 120, 75, 25)
   ; setup the font size
   GUICtrlSetFont($Label1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Button1, 18, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.

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

Func DoneWnd1 ()
   ; this is a done window without any text
   $Form1 = GUICreate("", 195, 68, 1230, 755)
   $Button1 = GUICtrlCreateButton("Done", 16, 8, 155, 41)
   ; setup the font size
   GUICtrlSetFont($Button1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.

   GUISetState(@SW_SHOW)
   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
		   Case $GUI_EVENT_CLOSE
			   MsgBox($MB_OK,"Info","Click Done to rate your experience")

		   Case $Button1
			  ExitLoop
	   EndSwitch
   WEnd
   GuiDelete($Form1)
EndFunc

Func InfoWnd ($text)
   If $text == 1 Then
	  $infoText = "﻿Follow the instructions in the provided sheet to edit the photo. When you finish, click on the Done button which will show up in the lower right corner"
   Else
	  $infoText = "﻿Follow the instructions in the second sheet to edit the photo. When you finish, click on the Done button which will show up in the lower right corner"
   EndIf
   $Form1 = GUICreate("Info", 500, 164)
    $Label1 = GUICtrlCreateLabel($infoText, 8, 16, 470, 81)
   $Button1 = GUICtrlCreateButton("Ok", 192, 120, 75, 25)
   ; setup the font size
   GUICtrlSetFont($Button1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Label1, 15, $FW_NORMAL)

   GUISetState(@SW_SHOW)
   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
		   Case $GUI_EVENT_CLOSE
			   MsgBox($MB_OK,"Info","Click Done to rate your experience")

		   Case $Button1
			  ExitLoop
	   EndSwitch
   WEnd
   GuiDelete($Form1)
EndFunc

