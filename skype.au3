#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	This activity includes viewing different images

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

Opt("WinTitleMatchMode",-2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase ;used for WInWaitActive title matching

; ============================ Parameters initialization ====================
; QoS
Local $aRTT[1] = [0]
Local $aLoss[3] = [0,3,5] ;packet loss rate, unit is %
;Local $appName  = "C:\Program Files (x86)\Insta360 Player\Insta360Player.exe"
;Local $winTitle = "Insta360Player"
Local $station = "A1"
Local $activity = "Skype"
Local $interval = 3000 ;40000 ;time interval before each QoE survey
Local $appName = "C:\Users\Harlem5\Desktop\Skype.lnk"
Global $clumsyDir = "C:\Users\Harlem5\Downloads\"



;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = @ScriptDir &"\" & $station &"-"& $activity  &"-QoE-results.txt"

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

;change network
;First start clumsy and set basic parameters
Local $hClumsy = Clumsy("", "open")

;open Skype
ShellExecute($appName, "", @SW_MAXIMIZE)
$hApp = WinWaitActive("Skype")

Sleep(3000)

;make Skype call
sleep(2000)
MouseClick("left", 126, 241)
sleep(2000)
MouseClick("left", 1544, 75)

MsgBox($MB_OK, "Calling", "Please click 'Ok' when your call connects.")


For $i = 0 To UBound($aRTT) - 1
   For $j = 0 To UBound($aLoss) - 1

	  ;start clumsy
	  Clumsy($hClumsy, "configure",$aRTT[$i], $aloss[$j])
	  Clumsy($hClumsy, "start")
	  WinSetState($hClumsy, "", @SW_MINIMIZE)
	  ;ChangeNetwork($hWnd, $aRTT[$i], $aloss[$j])

	  ;wait 40 seconds
	  sleep($interval)
	  $sQoE = Survey()

	  ;Write results to the File
	  FileWrite($hFilehandle,  $x & " "& $aRTT[$i] & " " & $aLoss[$j] & " " & $sQoE & @CRLF)

	  ;stop clumsy
	  Clumsy($hClumsy, "stop")

   Next
Next


;close clumsyr
WinClose($hClumsy)

MsgBox($MB_OK, "Info", "The call will end in 3 seconds.")
Sleep(3000)

;close the app (the directory)
WinKill($hApp) ;WinKill is used instead of WInCLose to force it to close since Skype will ask if you really want to end the call

;close the File
FileClose($hFilehandle)


;============================ Task Description ===================================
Func TaskDesc()

   $taskDesc = "Please put on the headset on the desk. You are about to take part in a Skype call that will last for approximately 3 minutes with a researcher next door. Every forty seconds, you will be asked to rate your experience from bad (1) to excellent (5). Please rate your experience based on the quality of the video."
   $Form1 = GUICreate("Task Description", 971, 442,-1,-1)
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

Func InfoWnd ($text)
   If $text == 1 Then
	  $infoText = "Click on the first image (1.jpg). Use the keyboard right arrow to navigate between images. When you reach the last imgae, click on the right down corner button which will appear in few seconds (rate your experiance)"
   ElseIf $text == 2 Then
	  $infoText = "Zoom-in and out by rolling the mouse ball and click and drag to explore the photo"
   Else
	  $infoText = "Move the cursor to the middle of the left side of the image, an arrow will appear, click on it to move to the next photo."
   EndIf

   $Form1 = GUICreate("Info",1044, 205, 351, 2) ;width [, height [, left = -1 [, top = -1 222
   $Label1 = GUICtrlCreateLabel($infoText, 24, 16, 1012, 129)
   ;$Button1 = GUICtrlCreateButton("Button1", 496, 168, 75, 25)

   ; setup the font size
   ;GUICtrlSetFont($Button1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Label1, 15, $FW_NORMAL)
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on top

   GUISetState(@SW_SHOW)
   If  $text == 1 or $text == 2 Then
	  ;Sleep($interval)
	  DoneWnd ($Form1)
   Else
	  arrowWnd($Form1)
   EndIf

EndFunc


