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
Local $aRTT[3] = [100,100, 50]
Local $aLoss[3] = [1,2,0.1] ;packet loss rate, unit is %
Local $videoDir = "C:\Users\harlem1\Desktop\AUtoIT-scripts\"
Local $appName  = "C:\Program Files (x86)\Insta360 Player\Insta360Player.exe"
Local $winTitle = "Insta360Player"
Local $station = "A1"
Local $activity = "360player"
Local $interval = 10000;time interval before each QoE survey



;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = @ScriptDir &"\" & $station &"-"& $activity &"-QoE-results.txt"

; Open file
Global $hFilehandle = FileOpen($sFileName, $FO_APPEND)
Global $hFilehandle = FileOpen($sFileName, $FO_APPEND)

; Prove it exists
If FileExists($sFileName) Then
   ; MsgBox($MB_SYSTEMMODAL, "File", "Exists")
Else
    MsgBox($MB_SYSTEMMODAL, "File", "Does not exist")
 EndIf

;=========================== Read the user index to write results===================
;create a file to hold user index number (asociated with the pre-survey number
Global $indexFile = @ScriptDir &"\" & $station & "-user-index.txt"

; Open the file for reading and store the handle to a variable.
Local $hIndexFile = FileOpen($indexFile, $FO_READ)

; Read the contents of the file using the handle returned by FileOpen.
Local $x = FileRead($hIndexFile)

; Close the handle returned by FileOpen.
FileClose($hIndexFile)


;================================= task description ==========================
TaskDesc()

;================================ Start activity =========================

;change network
;change configuration with clumsy
;First start clumsy and set basic parameters
Local $hWnd = OpenClumsy()
ChangeNetwork($hWnd, $aRTT[0], $aLoss[0])


;open the app
ShellExecute($appName)
$hApp = WinWaitActive($winTitle)


;show window to start the activity
InfoWnd(1)

InfoWnd(2)
;sleep for xx sec
sleep($interval)

;ask about experiance
Local $sQoE = survey()

;write results to File
FileWrite($hFilehandle, $x & " "& "0 0 " & $sQoE & @CRLF)

;change configuration with clumsy
;First start clumsy and set basic parameters
;Local $hWnd = OpenClumsy()

For $i = 0 To UBound($aRTT) - 1
   For $j = 0 To UBound($aLoss) - 1

	  ;start clumsy
	  ChangeNetwork($hWnd, $aRTT[$i], $aloss[$j])

	  ;activate app window
	  WinActivate($hApp)

	  InfoWnd(3)

	   InfoWnd(2)
	  ;sleep for xx sec
	  Sleep($interval)
	  InfoWnd(2)

	  ;Survey
	  $sQoE = Survey()

	  ;Write results to the File
	  FileWrite($hFilehandle,  $x & " "& $aRTT[$i] & " " & $aLoss[$j] & " " & $sQoE & @CRLF)

   Next
Next


;close file and all app
;WinClose($hWnd) ;didn't work, so kill process from ShellExecute
RunWait("taskkill /IM Insta360Player.exe")

;stop network emulator
WinClose($hWnd)

;close the File
FileClose($hFilehandle)

#comments-end
;============================ Task Description ===================================
Func TaskDesc()

   $taskDesc = "During this task you will explore six 360-degree photos. Click and drag to move around the photo. Prompts will direct you on how to change photos. In between each photo a window will appear and ask you a question.  The question will ask you to rate your experience so far from bad (1) to excellent (5). Please rate your experience based on the responsiveness of the software and the image quality and not the content of the image"
   $Form1 = GUICreate("Task Description", 971, 442)
   $Label1 = GUICtrlCreateLabel($taskDesc, 32, 32, 916, 313)
   $Button1 = GUICtrlCreateButton("Ok", 424, 384, 147, 33)

   ; setup the font size
   GUICtrlSetFont($Label1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP)

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
	  $infoText = "To open the first imgage click on: File -> Open -> Pictures (from the leftside bar) -> 3601." & @CRLF &"Click (Ok) when done."
   ElseIf $text == 2 Then
	  $infoText = "You have 15 sec to explore the photo, Zoom-in and out or click and drag to move around the photo. Click (Ok) to start."
   Else
	  $infoText = "Move the cursor to the middle of the left side of the image, an arrow will appear, click on it to move to the next photo." & @CRLF & "Click (Ok) when done."
   EndIf

   $Form1 = GUICreate("Info", 850, 164,500,10)
   $Label1 = GUICtrlCreateLabel($infoText, 8, 16, 845, 81)
   $Button1 = GUICtrlCreateButton("Ok", 370, 120, 75, 25)

   ; setup the font size
   GUICtrlSetFont($Button1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Label1, 15, $FW_NORMAL)
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on top

   GUISetState(@SW_SHOW)
   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
		   Case $GUI_EVENT_CLOSE
			   MsgBox($MB_OK,"Info","Click Ok")
		   Case $Button1
			  ExitLoop
	   EndSwitch
   WEnd
   GuiDelete($Form1)
EndFunc

