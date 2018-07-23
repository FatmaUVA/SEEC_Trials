
; manipulate Clumsy
#RequireAdmin ; for some reasons, it will only work if I set this flag!

ChangeNetwork()

Func ChangeNetwork()
   ShellExecute("C:\Users\harlem1\Downloads\clumsy-0.2-win64\clumsy.exe")
   Local $hWnd = WinWaitActive("clumsy 0.2")
   Local $aRTT[3] = [10, 50, 100]
   Local $aLoss[3] = [0,0.1,1] ;packet loss rate, unit is %


   ; clear the filter text filed
   ControlSetText($hWnd,"", "Edit1", "inbound")

   ; set check box for lag (delay)
   ControlClick($hWnd, "","Button4", "left", 1,8,8) ;1 click 8,8 coordinate

   ;set check box for drop
   ControlClick($hWnd, "","Button7", "left", 1,8,8)

   For $i = 0 To UBound($aRTT) - 1
	  For $j = 0 To UBound($aLoss) - 1

		 ;make sure it is active
		 WinActivate($hWnd)

		 ;Sleep(500)

		 ;set delay
		 ControlSetText($hWnd,"", "Edit2", $aRTT[$i])
		 ;Sleep(500)

		 ; add packet drop
		 ControlSetText($hWnd,"", "Edit3", $aLoss[$j])
		 ;Sleep(500)

		 ;start
		 ControlClick($hWnd, "","Button2", "left", 1,8,8)

		 Sleep(3000)

		 ;stop clumsy
		 ControlClick($hWnd, "","Button2", "left", 1,8,8)

	  Next
   Next
EndFunc