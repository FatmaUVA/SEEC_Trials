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
Local $aRTT[1] = [0]
Local $aLoss[3] = [0,5,10] ;packet loss rate, unit is %
Local $videoDir = "C:\Users\Harlem5\Desktop\SEEC_Trials\"
;Local $vdieoName = "Fast Five Stealing The Vault Scene.mp4"
Local $vdieoName= "zootopia-cut-1080p-36-sec.mkv"
Local $timeInterval = 36000 ;24000 ;in ms
Local $station = $CmdLine[1]
;Local $station = "A33" ;A for protocol A nad B for Protocol B
Local $activity = "video"
Global $clumsyDir = "C:\Users\Harlem5\Downloads\"
Local $winTitle = "Movies & TV"

;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = @ScriptDir &"\" & $station &"-"& $activity &"-QoE-results-new.txt"

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


;change configuration with clumsy
;First start clumsy and set basic parameters
Local $hClumsy = Clumsy("", "open")
;Local $hWnd = OpenClumsy()

ShellExecute($videoDir & $vdieoName)
Local $hApp = WinWaitActive($winTitle)

Sleep($timeInterval)

;Survey
$sQoE = Survey()

;Write results to the File
FileWrite($hFilehandle, $x & " "& $aRTT[0] & " " & $aLoss[0] & " " & $sQoE & @CRLF)


For $i = 0 To UBound($aRTT) - 1
   For $j = 1 To UBound($aLoss) - 1

	  ;start clumsy
	  ;ChangeNetwork($hWnd, $aRTT[$i], $aloss[$j])
	  ;start clumsy
	  Clumsy($hClumsy, "configure",$aRTT[$i], $aloss[$j])
	  Clumsy($hClumsy, "start")
	  WinSetState($hClumsy, "", @SW_MINIMIZE)

	  ;activate app window
	  WinActivate($hApp)

	  ;replay video
	  MouseClick($MOUSE_CLICK_LEFT,500,500,2) ; to make it full screen
	  Send("{SPACE}")
	  ;MouseClick($MOUSE_CLICK_LEFT,500,500,2) ;to quit full screen, because in full screen mode QoS survey won't show

	  ;sleep for xx sec
	  Sleep($timeInterval)

	   MouseClick($MOUSE_CLICK_LEFT,500,500,2) ; quit full screen
	  ;Survey
	  $sQoE = Survey()

	  ;Write results to the File
	  FileWrite($hFilehandle, $x & " "& $aRTT[$i] & " " & $aLoss[$j] & " " & $sQoE & @CRLF)

	  ;WinActivate($hClumsy)

	  ;stop clumsy
	  Clumsy($hClumsy, "stop")

   Next
Next

;stop network emulator
WinClose($hClumsy)

;close the File
FileClose($hFilehandle)

;close the app
WinClose($hApp)
;============================ Task Description ===================================
Func TaskDesc()
   ;MsgBox($MB_OK,"Task Description"," During this task you will be asked to watch a 5 minutes video about the internet research that is ongoing in Harlem. The video will pause every 30 seconds and a window will appear and ask you a question.  The question will ask you to rate your experience so far from bad (1) to excellent (5). Please rate your experience based on the quality of the video and audio and not the content of the video.")
   ;$taskDesc = "During this task you will be asked to watch a 5 minutes video about the internet research that is ongoing in Harlem. The video will pause every 30 seconds and a window will appear and ask you a question.  The question will ask you to rate your experience so far from bad (1) to excellent (5). Please rate your experience based on the quality of the video and audio and not the content of the video."
   $taskDesc = "Please put on the headset on the desk, you are about to watch a 35 seconds video. The video will be replayed for three times and after each time a window will appear and ask you a question.  The question will ask you to rate your experience so far from bad (1) to excellent (5). Please rate your experience based on the quality of the video and audio and not the content of the video."
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

Func ClumsyWndInfo() ; function to tell people not to touch clumsy window

   $taskDesc = "The window shown below will appear temporarily during the activity. Do not click on any of the buttons."
   $Form1 = GUICreate("Task Description", 971, 600,-1,-1)
   $Label1 = GUICtrlCreateLabel($taskDesc, 32, 32, 916, 100)
   Local $pic = GUICtrlCreatePic( @ScriptDir & "\clumsy-wnd.jpg",230,100,575,420)
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



Func Clumsy($hWnd, $cmd, $RTT=0, $loss=0)

   If $cmd = "open" Then
	  ShellExecute($clumsyDir & "clumsy-0.2-win64\clumsy.exe")
	  $hWnd = WinWaitActive("clumsy 0.2")

	  Sleep(500)

	  ;basic setup
	  ; clear the filter text filed
	  ;Local $filter = "outbound and ip.DstAddr==" & $clinetIPAddress & " and udp.DstPort != "& $udpPort
	  Local $filter = "outbound"
	  ControlSetText($hWnd,"", "Edit1", $filter)

	  ; set check box for lag (delay)
	  ControlClick($hWnd, "","Button4", "left", 1,8,8) ;1 click 8,8 coordinate

	  ;set check box for drop
	  ControlClick($hWnd, "","Button7", "left", 1,8,8)
	  Return $hWnd

   ElseIf $cmd = "configure" Then
	  ;make sure it is active
	  WinActivate($hWnd)

	  ;set delay
	  ControlSetText($hWnd,"", "Edit2", $RTT)

	  ;add packet drop
	  ControlSetText($hWnd,"", "Edit3", $loss)

   ElseIf $cmd = "start" Then
	  ;click the start button
	  ControlClick($hWnd, "","Button2", "left", 1,8,8)

   ElseIf $cmd = "stop" Then
	  ;click the start button
	  ControlClick($hWnd, "","Button2", "left", 1,8,8)

   EndIf
EndFunc