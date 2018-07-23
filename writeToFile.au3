#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

; Create file in same folder as script
$sFileName = @ScriptDir &"\video-QoE.txt"

; Open file
$hFilehandle = FileOpen($sFileName, $FO_APPEND)

; Prove it exists
If FileExists($sFileName) Then
    MsgBox($MB_SYSTEMMODAL, "File", "Exists")
Else
    MsgBox($MB_SYSTEMMODAL, "File", "Does not exist")
EndIf



; Write a line
FileWrite($hFilehandle, "This is line 1")

; Read it
MsgBox($MB_SYSTEMMODAL, "File Content", FileRead($sFileName))

; Append a line
FileWrite($hFilehandle, @CRLF & "Thisi is line 2")

; read it
MsgBox($MB_SYSTEMMODAL, "File Content", FileRead($sFileName))

; Close the file handle
FileClose($hFilehandle)

; Tidy up by deleting the file
;FileDelete($sFileName)
