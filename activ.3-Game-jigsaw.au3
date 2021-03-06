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
Local $aRTT[3] = [0,50,150]
Local $aLoss[2] = [0,1] ;packet loss rate, unit is %
Local $interval = 20000;time intervalbefore each QoE survey
Local $videoDir = "C:\Users\Harlem5\Desktop\SEEC_Trials\"
Local $appName= "C:\Users\harlem1\Desktop\Jigsaw Puzzle Premium.lnk"
Local $winTitle = "Jigsaw Puzzle Premium"
Local $station = "A3"
Local $activity = "jigsaw"

;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = @ScriptDir &"\" & $station &"-"& $activity &"-QoE-results.txt"

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
Global $indexFile = @ScriptDir &"\" & $station & "-user-index.txt"

; Open the file for reading and store the handle to a variable.
Local $hIndexFile = FileOpen($indexFile, $FO_READ)

; Read the contents of the file using the handle returned by FileOpen.
Local $x = FileRead($hIndexFile)

; Close the handle returned by FileOpen.
FileClose($hIndexFile)


;================================= task description ==========================
TaskDesc()
ClumsyWndInfo()
;================================ Start activity =========================

;open the app
ShellExecute($appName)
$hApp = WinWaitActive($winTitle)
;$hApp2 = WinGetHandle($winTitle)

;show window to start the activity
Sleep(1500)
instruction(1)
;MsgBox($MB_OK,"Info","Click on Your Free Puzzles to start playing")
Sleep(2000)
instruction(2)
;MsgBox($MB_OK,"Info","Choose a picture")
Sleep(6000)
instruction(3)
;MsgBox($MB_OK,"Info","When you successfully assemble the puzzle, click Quit (on the upper right corner) and choose another puzzle to assemble")
Sleep(1000)
instruction(4)
;MsgBox($MB_OK,"Info","Keep playing! When the test is done, you will be informed by a Thank you window")



;sleep for 10 sec
;sleep($interval)

;ask about experiance
;Local $sQoE = survey()

;write results to File
;FileWrite($hFilehandle, $x & " "& "0 0 " & $sQoE & @CRLF)

;change configuration with clumsy
;First start clumsy and set basic parameters
Local $hWnd = OpenClumsy()

For $i = 0 To UBound($aRTT) - 1
   For $j = 0 To UBound($aLoss) - 1

	  ;start clumsy
	  ChangeNetwork($hWnd, $aRTT[$i], $aloss[$j])

	  ;activate app window
	  WinActivate($hApp)

	  ;sleep for xx sec
	  Sleep($interval)

	  ;Survey
	  $sQoE = Survey()

	  ;Write results to the File
	  FileWrite($hFilehandle, $x &" "&  $aRTT[$i] & " " & $aLoss[$j] & " " & $sQoE & @CRLF)

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

$taskDesc = "During this task you will play a game called jigsaw puzzle. Assemble the jigsaw puzzles by dragging and dropping the pieces. This game lasts for 3 minutes. During the game, you will be asked to rate your experience from bad (1) to excellent (5). Please rate your experience based on the quality of the image and sound and not the content of the game."
   $Form1 = GUICreate("Task Description", 971, 442);, 237, 118)
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
   ;ControlClick($hWnd, "","Button2", "left", 1,8,8)

   ;set delay
   ControlSetText($hWnd,"", "Edit2", $RTT)

   ;add packet drop
   ControlSetText($hWnd,"", "Edit3", $loss)

   ;start
   ControlClick($hWnd, "","Button2", "left", 1,8,8)

EndFunc

Func instruction ($case)
   If $case == 1 Then
	  $text = "Click on Your Free Puzzles to start playing"
   ElseIf $case == 2 Then
	  $text = "Choose a picture"
   ElseIf $case == 3 Then
	  $text = "When you successfully assemble the puzzle, click Quit (on the upper right corner) and choose another puzzle to assemble"
   ElseIf $case == 4 Then
	  $text = "Keep playing! When the test is done, you will be informed by a Thank you window"
   EndIf


   $Form1 = GUICreate("Info", 434, 164)
   $Label1 = GUICtrlCreateLabel($text, 8, 16, 420, 81)
   $Button1 = GUICtrlCreateButton("Ok", 192, 120, 75, 25)
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

Func ClumsyWndInfo() ; function to tell people not to touch clumsy window

   $taskDesc = "The window shown below will appear temporarily during the activity. Do not click on any of the buttons."
   $Form1 = GUICreate("Task Description", 971, 600,-1,-1)
   $Label1 = GUICtrlCreateLabel($taskDesc, 32, 32, 916, 100)
   Local $pic = GUICtrlCreatePic("C:\Users\Harlem1\Desktop\AUtoIT-scripts\clumsy-wnd.jpg",230,100,575,420)
   $Button1 = GUICtrlCreateButton("Ok", 424, 550, 147, 33)
0

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
