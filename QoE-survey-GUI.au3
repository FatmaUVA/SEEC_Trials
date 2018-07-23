#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>


;======================= Create file to save results===============================

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


Survey()

Func Survey()
   #Region ### START Koda GUI section ### Form=C:\Users\harlem1\Desktop\AUtoIT-scripts\QoE-form.kxf
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
   #EndRegion ### END Koda GUI section ###

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
		 WriteToFile($sQoE)
		 ;MsgBox($MB_OK,"Info","You clicked submit")
		 ExitLoop
	  EndSelect
    WEnd

EndFunc

Func WriteToFile($sQoE)
; Append a line
FileWrite($hFilehandle, @CRLF & $sQoE)

EndFunc


