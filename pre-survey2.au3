#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Fatma Alali

 Script Function:
	This script is used to open the web browser and fill up the pre-survey

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
#include <GuiScrollBars.au3>

openSurvey()



Func openSurvey()
   ;open web browser

   ShellExecute("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
    Local $hApp = WinWaitActive("New Tab - Google Chrome")

   ;fill in address
   ;Send("https://docs.google.com/forms/d/e/1FAIpQLSfhyLtaMDvyn4Nj0M9U8C7hTeRXNqCpcHHAzP54w-m6En5y-A/viewform")
   Send("https://goo.gl/forms/dzvBMaoX8umCDmRi2")
   Send("{ENTER}")
   Sleep(15000)

   ;when web browser is closed exit
   Local $hApp2 = WinWaitActive("2018 Technology Trial A Novel Architecture for Secure, Energy-Efficient Community-Edge-Clouds with Application in Harlem (SEEC HARLEM) Survey - Google Chrome")

   WinWaitClose($hApp2)
   ;MsgBox($MB_OK,"","you closed Chrome")

EndFunc

Func informedConsent()

   $Form1 = GUICreate("Informed Consent", 824, 810, 320, 12)
   $Label1 = GUICtrlCreateLabel(@TAB & @TAB &"Pre-Survey Informed Consent" & @CRLF & @TAB &"2018 Technology Trial" & @CRLF & "A Novel Architecture for Secure, Energy-Efficient Community-Edge-Clouds with Application in Harlem" & @CRLF & "(SEEC HARLEM)",184, 16) ;452, 73)
   $Label1 = GUICtrlCreateLabel("Pre-Survey Informed Consent" & @CRLF & "2018 Technology Trial" & @CRLF & "A Novel Architecture for Secure, Energy-Efficient Community-Edge-Clouds with Application in Harlem" & @CRLF & "(SEEC HARLEM)",184, 16) ;452, 73)
   $Button1 = GUICtrlCreateButton("CLICK TO CONTINUE", 336, 776, 190, 25)
   $text = "You are invited to participate in a research study about computer and Internet experience in Harlem.  This study is being conducted by Dr. Rider Foley and Fatma Alali of the University of Virginia and two undergraduate research assistants, Paul Codjoe and John Eshirow.  You are invited to participate in this study because you are attending the Pop-Up Innovation Event as part of Harlem Week in Upper Manhattan, New York." & @CRLF & @CRLF & "Participation in this study is voluntary." & @CRLF & @CRLF & "If you agree to participate in this study, you will be asked to complete a short survey and one activity administered by the research assistants, here at this time. The amount of time needed to complete the survey and activities varies by individual, though we expect that completing both the survey andA one activity will take up to 45 minutes. You may skip any portion of the activity or stop participating in this study at any time.  The activity will be conducted here at this location, the LeRoy Neiman Art Center." & @CRLF & @CRLF & " If you agree to participate, your responses to the questions asked during the activity will be included in the study, and the questions do not contain personally identifying information."  & @CRLF & @CRLF & "If you elect to participate in the study, your responses will be analyzed by participating researchers, but will not be reported in a way that is individually attributable to you. " & @CRLF & @CRLF & "Participating in the activities may educate you about this research project, introduce you to photo-editing and online video conference technology, but you may benefit directly from participating.  The knowledge gained may improve how internet infrastructure is developed. We do not envision any risks related to participating in the study. "& @CRLF & @CRLF & "The information you will share with us, if you participate in this study, will be kept completely confidential to the full extent of the law.  Reports of study findings will not include any identifying information. Hard copies of documents completed by participants will be kept in the locked offices of Dr. Rider Foley.  Electronic data will not contain personally identifying information, and will be stored with on password-protected servers. Only Dr. Rider Foley and the research assistants directly involved and approved to handle human subject data will have access to the files." & @CRLF & @CRLF & "If you have questions about the study, contact:" & @CRLF & "Dr. Rider Foley Assistant Professor" & @CRLF & "Engineering and Society" & @CRLF & "University of Virginia "& @CRLF & "(480) 982-2905" & @CRLF & "rider@virginia.edu " & @CRLF & @CRLF & "To obtain more information about the study, ask questions about the research procedures, express concerns about your participation, or report illness, injury or other problems, please contact:" & @CRLF & "Tonya R. Moon, Ph.D." & @CRLF & "Chair, Institutional Review Board for the Social and Behavioral Sciences" & @CRLF & "One Morton Dr. Suite 500" & @CRLF & "University of Virginia, P.O. Box 800392" & @CRLF & "Charlottesville, VA 22908-0392" & @CRLF & "Telephone:  (434) 924-5999" & @CRLF & "Email: irbsbshelp@virginia.edu" & @CRLF & "Website: www.virginia.edu/vpr/irb/sbs"& @CRLF & @CRLF & "By clicking continue, you agree to participate and you are confirming that you are at least 18 years of age, have read and understood the Informed Consent, and consent to participate in this study."
   $Label2 = GUICtrlCreateLabel($text,16, 112, 788, 649)
   GUISetState(@SW_SHOW)
   GUICtrlSetFont($Label2, 9, $FW_NORMAL)
   GUICtrlSetFont($Button1, 10, $FW_NORMAL)
   ;_GUIScrollBars_Init($Form1)
   ;$hScroller = GUICreate("Scroller", 100, 200, 10, 10, BitOR($WS_POPUP, $WS_BORDER), $WS_EX_MDICHILD, $Form1)
   ;_GUIScrollbars_Generate($hScroller, 0, $Label2)

   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
		 Case $GUI_EVENT_CLOSE
			Exit
		 Case $Button1
			GUIDelete($Form1)
			openSurvey()
			Exit
	   EndSwitch
	WEnd
 EndFunc

Func DoneWnd ()
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

