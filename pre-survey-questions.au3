
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Fatma Alali

 Script Function:
	 pre-survey questions

#ce ----------------------------------------------------------------------------
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <FontConstants.au3>
#include <AutoItConstants.au3>
#include <GuiScrollBars.au3>


Local $station = $CmdLine[1]

;============================= Create a file for results======================
; Create file in same folder as script
Global $sFileName = @ScriptDir &"\" & $station &"-pre-survey.txt"

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

; write the index user  to the begining of the result file
FileWrite($hFilehandle, $x & " ")
; ==========================first set of questions optitions==============================================
Local $text = "Please share your experience with computers and the Internet by addressing the following statements"
instructionWnd($text)

Local $r [5] = ["More than 15 times in the past year" , "Three or more times in the past year" , "ONCE or TWICE in the past year", "Not in the past year" , "Never in my life"]
;questions
Local $q [5] = ["Used a computer" , "Surfed the Internet" , "Played a computer game" , "Played a computer game on the Internet" , "Used virtual reality or augmented reality on the Internet"]

For $i = 0 To UBound($q) - 1
   $ans = questionRadio($q[$i],$r)
   FileWrite($hFilehandle," "& $ans)
Next

; ==========================second set of questions optitions==============================================
Local $text = "Please share your experience with computers and the Internet by addressing the following statements"
instructionWnd($text)

Local $r [5] = ["Within the last month" , "Within the last year" , "Not in the past year" , "More than 5 years ago" , "Never in my life"]
Local $q [7] = ["Bought a computer" , "Connected new component to a computer, e.g. plugged in a web-based camera" , "Repaired or retrofitted a computer, e.g. installed a memory card" , "Installed software on a computer" , "Updated software on a computer" , "Addressed software errors, e.g. trouble-shooting errors" , "Wrote or coded new software"]

For $i = 0 To UBound($q) - 1
   $ans = questionRadio($q[$i],$r)
   FileWrite($hFilehandle," "& $ans)
Next

;==================Third question====================================
Local $r [3] = ["Male" , "Female" , "Refuse to answer"]
$ans = gender("Are you",$r)
 FileWrite($hFilehandle," "& $ans)

; ==========================fourth question==============================================
Local $r [6] = ["Attended high school, but did not graduate" , "High school graduate" , "Attended college, but did not graduate for a 4-year college" , "Graduated from a 4-year college" , "Attended graduate or profession school, but did not graduate" , "Graduated from a graduate or professional school (e.g. MBA, MPA, JD, MD)"]
$ans = questionRadio2("What is your highest level of formal education?",$r)
 FileWrite($hFilehandle," "& $ans)

; ==========================fifth question==============================================
Local $r [8] = [ "Asian" , "Black / African American" , "Hispanic / Latino" , "Middle Eastern" , "American Indian or Alaskan or Hawaiian Native" , "White / Caucasian" , "Other" , "Refuse to answer"]
$ans = questionRadio2("For statistical purposes only, could you please tell me your race/ethnicity?",$r)
 FileWrite($hFilehandle," "& $ans & @CRLF)



Func instructionWnd($text)
   ;$Form1 = GUICreate("Pre-survey", 596, 199)
   $Form1 = GUICreate("Pre-Survey", 528, 382)
   $Label1 = GUICtrlCreateLabel($text, 32, 40, 532, 65)
   ;$Button1 = GUICtrlCreateButton("Next", 256, 144, 75, 25)
   $Button1 = GUICtrlCreateButton("Next", 216, 336, 99, 25)

   GUICtrlSetFont($Label1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
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

Func questionRadio($question,$r)
   $Form1 = GUICreate("Pre-Survey", 528, 382)
   $Button1 = GUICtrlCreateButton("Next", 216, 336, 99, 25)
   ;$Group1 = GUICtrlCreateGroup($question, 16, 32, 489, 289)
   $Label1 = GUICtrlCreateLabel($question, 24, 24, 476, 49)
   $Radio1 = GUICtrlCreateRadio($r[0], 40, 72, 441, 33)
   $Radio2 = GUICtrlCreateRadio($r[1], 40, 128, 441, 33)
   $Radio3 = GUICtrlCreateRadio($r[2], 40, 176, 441, 33)
   $Radio4 = GUICtrlCreateRadio($r[3], 40, 224, 441, 41)
   $Radio5 = GUICtrlCreateRadio($r[4], 40, 272, 441, 41)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   GUICtrlSetFont($Label1, 14, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Button1, 15, $FW_NORMAL)
   GUICtrlSetFont($Radio1, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio2, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio3, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio4, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio5, 11, $FW_NORMAL)

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
		 ;MsgBox($MB_OK,"Info","You clicked submit")
		 ExitLoop
	  EndSelect
   WEnd
   GuiDelete($Form1)
   Return $sQoE

EndFunc

Func questionRadio2($question,$r)
   $Form1 = GUICreate("Pre-survey", 530, 412)
   $Button1 = GUICtrlCreateButton("Next", 200, 376, 99, 25)
   ;$Group1 = GUICtrlCreateGroup($question, 16, 32, 489, 289)
   $Label1 = GUICtrlCreateLabel($question, 24, 24, 476, 49)
   $Radio1 = GUICtrlCreateRadio($r[0], 40, 72, 441, 33)
   $Radio2 = GUICtrlCreateRadio($r[1], 40, 128, 441, 33)
   $Radio3 = GUICtrlCreateRadio($r[2], 40, 176, 441, 33)
   $Radio4 = GUICtrlCreateRadio($r[3], 40, 224, 441, 41)
   $Radio5 = GUICtrlCreateRadio($r[4], 40, 272, 441, 41)
   $Radio6 = GUICtrlCreateRadio($r[5], 40, 320, 441, 41)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   GUICtrlSetFont($Label1, 14, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Button1, 15, $FW_NORMAL)
   GUICtrlSetFont($Radio1, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio2, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio3, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio4, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio5, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio6, 11, $FW_NORMAL)

   GUISetState(@SW_SHOW)
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on top

    ; Loop until the user clicks submit
    While 1
	  $idMsg = GUIGetMsg() ;Polls the GUI to see if any events have occurred.
	  Select
	  Case $idMsg = $GUI_EVENT_CLOSE
		 MsgBox($MB_OK,"Info","Please click <Submit> after you make your choice")
	  Case ($idMsg = $Button1) And (GUICtrlRead($Radio1) = 1 Or GUICtrlRead($Radio2) = 1 or GUICtrlRead($Radio3) = 1 or GUICtrlRead($Radio4) = 1 or GUICtrlRead($Radio5) = 1 or GUICtrlRead($Radio6) = 1)
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
		 ElseIf GUICtrlRead($Radio6) = 1 Then
		   $sQoE = 6
		 EndIf
		 ExitLoop
	  EndSelect
   WEnd
   GuiDelete($Form1)
   Return $sQoE
EndFunc

Func gender($question,$r)
   $Form1 = GUICreate("Pre-Survey", 528, 382)
   $Button1 = GUICtrlCreateButton("Next", 216, 336, 99, 25)
   $Group1 = GUICtrlCreateGroup($question, 16, 32, 489, 289)
   $Radio1 = GUICtrlCreateRadio($r[0], 40, 72, 441, 33)
   $Radio2 = GUICtrlCreateRadio($r[1], 40, 128, 441, 33)
   $Radio3 = GUICtrlCreateRadio($r[2], 40, 176, 441, 33)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   GUICtrlSetFont($Group1, 15, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Button1, 15, $FW_NORMAL)
   GUICtrlSetFont($Radio1, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio2, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio3, 11, $FW_NORMAL)


   GUISetState(@SW_SHOW)
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on top

    ; Loop until the user clicks submit
    While 1
	  $idMsg = GUIGetMsg() ;Polls the GUI to see if any events have occurred.
	  Select
	  Case $idMsg = $GUI_EVENT_CLOSE
		 MsgBox($MB_OK,"Info","Please click <Submit> after you make your choice")
	  Case ($idMsg = $Button1) And (GUICtrlRead($Radio1) = 1 Or GUICtrlRead($Radio2) = 1 or GUICtrlRead($Radio3) = 1)
		 If GUICtrlRead($Radio1) = 1 Then
		   $sQoE = 1
		 ElseIf GUICtrlRead($Radio2) = 1 Then
		   $sQoE = 2
		 ElseIf GUICtrlRead($Radio3) = 1 Then
		   $sQoE = 3
		 EndIf
		 ;MsgBox($MB_OK,"Info","You clicked submit")
		 ExitLoop
	  EndSelect
   WEnd
   GuiDelete($Form1)
   Return $sQoE

EndFunc

Func questionRadio3($question,$r)
   $Form1 = GUICreate("Pre-survey", 530, 412)
   $Button1 = GUICtrlCreateButton("Submit", 200, 376, 99, 25)
   ;$Group1 = GUICtrlCreateGroup($question, 16, 32, 489, 289)
   $Label1 = GUICtrlCreateLabel($question, 24, 24, 476, 49)
   $Radio1 = GUICtrlCreateRadio($r[0], 40, 72, 441, 33)
   $Radio2 = GUICtrlCreateRadio($r[1], 40, 128, 441, 33)
   $Radio3 = GUICtrlCreateRadio($r[2], 40, 176, 441, 33)
   $Radio4 = GUICtrlCreateRadio($r[3], 40, 224, 441, 41)
   $Radio5 = GUICtrlCreateRadio($r[4], 40, 272, 441, 41)
   $Radio6 = GUICtrlCreateRadio($r[5], 40, 320, 441, 33)
   GUICtrlCreateGroup("", -99, -99, 1, 1)

   GUICtrlSetFont($Label, 14, $FW_NORMAL) ; Set the font of the controlID stored in $iLabel2.
   GUICtrlSetFont($Button1, 15, $FW_NORMAL)
   GUICtrlSetFont($Radio1, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio2, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio3, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio4, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio5, 11, $FW_NORMAL)
   GUICtrlSetFont($Radio6, 9, $FW_NORMAL)

   GUISetState(@SW_SHOW)
   WinSetOnTop($Form1,"",$WINDOWS_ONTOP);to make the window always on top

    ; Loop until the user clicks submit
    While 1
	  $idMsg = GUIGetMsg() ;Polls the GUI to see if any events have occurred.
	  Select
	  Case $idMsg = $GUI_EVENT_CLOSE
		 MsgBox($MB_OK,"Info","Please click <Submit> after you make your choice")
	  Case ($idMsg = $Button1) And (GUICtrlRead($Radio1) = 1 Or GUICtrlRead($Radio2) = 1 or GUICtrlRead($Radio3) = 1 or GUICtrlRead($Radio4) = 1 or GUICtrlRead($Radio5) = 1 or GUICtrlRead($Radio6) = 1 or GUICtrlRead($Radio7) = 1 or GUICtrlRead($Radio8) = 1)
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
		 ElseIf GUICtrlRead($Radio6) = 1 Then
		   $sQoE = 6
		 ElseIf GUICtrlRead($Radio7) = 1 Then
		   $sQoE = 7
		 ElseIf GUICtrlRead($Radio8) = 1 Then
		   $sQoE = 8
		EndIf
		ExitLoop
	  EndSelect
   WEnd
   GuiDelete($Form1)
   Return $sQoE
EndFunc