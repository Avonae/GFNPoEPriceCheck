#include <AutoItConstants.au3>
#include <ClipBoard.au3>
#include <String.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
Global $searchString = '"ty":"is","ibi":1,"s":"'
Global $sUserName = @UserName
Global $sDirPath = "C:\Users\" & $sUserName & "\Documents\My Games\Path of Exile"
Global $sIniFile = $sDirPath & "\POEGFNconfig.ini"
Global $aKoordinaten = 0
Global $counter = 0 
;Global $counterwindow = 300
Global $sURL = 0
Global $URLau3 = "https://github.com/KloppstockBw/GFNPoEPriceCheck/blob/main/GFNPoEPriceCheck.au3"
Global $VersionL = "20231026A"
Global $updateChecked = False
Global $WEBSITE, $UPDATE
Global $ty = "thanks and good luck"

	HotKeySet("{F6}", "copyItem") 		; Price check on current ITEM
	HotKeySet("{F5}", "gotoHideout")	; Goto HO
	HotKeySet("{F9}", "lasty")				; Sends thanks and good luck in local chat
	HotKeySet("{F11}", "ExitScript")	; Force stop script

Updater()
AutorunAwakened()
awakenedrunning()
configMaus()
ConfigURL()
Setup()

While 1
Sleep(100)
If $counterwindow = 300 Then
WindowRename()
$counterwindow = 0
EndIf
 $counterwindow = $counterwindow + 1
WEnd

Func Setup()
Local $SetupStatus = 0
If IniRead($sIniFile, "Setup Done", "Status", $SetupStatus) = 1 Then
Return
Else
MsgBox(48, "You are ready to go!", "Setup is done and you can start playing now!" & @CRLF &  @CRLF &"Press in PoE GFN the Hotkey:" & @CRLF & @CRLF &  "F5 - go to hideout "& @CRLF &  "F6 - price check of item"& @CRLF &  "F9 - write " & $ty & " in local chat" & @CRLF &  "F11 - Force Close script" & @CRLF & @CRLF & "If you face any issues then please delete the config file at:"& @CRLF &$sIniFile)
IniWrite($sIniFile, "Setup Done", "Status", 1)
EndIf
EndFunc	

Func AutorunAwakened()
	If Not FileExists($sIniFile) Or IniRead($sIniFile, "AwakenedPath", "ExePath", "") = "" Then
		Local $iResponse = MsgBox($MB_YESNO, "Auto Start Awakened POE Trade", "Do you want me to start Awakened PoE Trade automatically when the script is executed?")
		If $iResponse = $IDYES Then
			Local $sFile = FileOpenDialog("Choose Awakened PoE Trade.exe", "C:\Users\" & $sUserName & "\AppData\Local\Programs\Awakened PoE Trade", "Awakened PoE Trade.exe (*.exe)", $FD_FILEMUSTEXIST)
			If @error Then
				MsgBox($MB_SYSTEMMODAL, "Cancel", "You will be reasked on next script start")
			Else
				IniWrite($sIniFile, "AwakenedPath", "ExePath", $sFile)
				Local $sFile = IniRead($sIniFile, "AwakenedPath", "ExePath", "")
				If StringRight($sFile, 4) = ".exe" Then Run($sFile)
			EndIf
		Else
			MsgBox($MB_SYSTEMMODAL, "", "No Autostart of Awakened. If you change your mind check the config at: " & @CRLF & $sIniFile)
			IniWrite($sIniFile, "AwakenedPath", "ExePath", "You dont want to start awakened automatically. Remove this line if you changed your mind and rerun the script")
		EndIf
	EndIf

Local $sFile = IniRead($sIniFile, "AwakenedPath", "ExePath", "")
If StringRight($sFile, 4) = ".exe" Then Run($sFile)
Sleep(200)
EndFunc

Func awakenedrunning()
	While True
		Local $awakenedrunning = "Awakened PoE Trade"
		Local $processList = ProcessList()
		For $i = 1 To $processList[0][0]
			If StringInStr($processList[$i][0], $awakenedrunning) Then Return
		Next
		MsgBox(0, "Status", "Please start 'Awakened PoE Trade' before running this script")
		Exit
	Wend
EndFunc

Func WindowRename()
While 1
    Local $hWnd = WinGetHandle("[REGEXPTITLE:(?i)(.*Path of Exile.*GeForce.*)]")
    If $hWnd <> 0 Then
        If WinSetTitle($hWnd, "", "Path of Exile") Then ExitLoop
    EndIf
    Sleep(100)
WEnd
EndFunc

Func; configMaus()
If Not FileExists($sDirPath) Then DirCreate($sDirPath)
	$sMausKoordinaten = IniRead($sIniFile, "AwakenedPasteWindow", "Koordinaten", "-1,-1")
	$aKoordinaten = StringSplit($sMausKoordinaten, ',')
	If $sMausKoordinaten = "-1,-1" Or ($aKoordinaten[1] = 0 And $aKoordinaten[2] = 0) Then
		Opt("GUIOnEventMode", 1) ;
		$Form1 = GUICreate("Path of Exile", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP)
		GUISetState(@SW_SHOWMAXIMIZED)
		Sleep(200)
		;Send("+{SPACE}")
		;WinActivate($Form1)
                MsgBox(0, "Show me where the Awakened PoE Trade Field is", "Now you have to show me where to put the item details in Awakened PoE Trade, unfortunately I can't read that information." & @CRLF & @CRLF & "Click with the left mouse button in the upper left corner on the input field where it says" & @CRLF & @CRLF & "Price Check (Ctrl + V)." & @CRLF & @CRLF & "It starts as soon as you click on ok.")
		WinActivate($Form1)
		Sleep(50)
		Send("+{SPACE}")
		Sleep(100)
    If WinActive("Awakened PoE Trade") Then
        While 1
            If _IsPressed("01") Then
                ExitLoop
            EndIf
            Sleep(20)
        WEnd
    EndIf
		$aMausPosition = MouseGetPos()
		$sMausKoordinaten = $aMausPosition[0] & "," & $aMausPosition[1]
		IniWrite($sIniFile, "AwakenedPasteWindow", "Koordinaten", $sMausKoordinaten)
		GUISetState(@SW_HIDE, $Form1) 
		MsgBox($MB_SYSTEMMODAL, "Coordinates Saved", "Coodinates saved to config file at " & $sIniFile & @CRLF & "X: " & $aMausPosition[0] & @CRLF & "Y: " & $aMausPosition[1])
	EndIf
	Sleep(100)
	$aKoordinaten = StringSplit(IniRead($sIniFile, "AwakenedPasteWindow", "Koordinaten", "-1,-1"), ',')		
EndFunc

Func configMaus()
	$sMausKoordinaten = IniRead($sIniFile, "AwakenedPasteWindow", "Koordinaten", "-1,-1")
	If $sMausKoordinaten = "-1,-1" Then
		Opt("GUIOnEventMode", 1)
		$Form1 = GUICreate("Path of Exile", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP)
		GUISetState(@SW_SHOWMAXIMIZED)
		Sleep(200)
		MsgBox(0, "Show me where the Awakened PoE Trade Field is", "Now you have to show me where to put the item details in Awakened PoE Trade, unfortunately I can't read that information." & @CRLF & @CRLF & "Click with the left mouse button in the upper left corner on the input field where it says" & @CRLF & @CRLF & "Price Check (Ctrl + V)." & @CRLF & @CRLF & "It starts as soon as you click on ok.")
		WinActivate($Form1)
		Sleep(50)
		Send("+{SPACE}")
		Sleep(100)
    If WinActive("Awakened PoE Trade") Then
        While 1
            If _IsPressed("01") Then
                ExitLoop
            EndIf
            Sleep(20)
        WEnd
    EndIf
		$aMausPosition = MouseGetPos()
		$sMausKoordinaten = $aMausPosition[0] & "," & $aMausPosition[1]
		IniWrite($sIniFile, "AwakenedPasteWindow", "Koordinaten", $sMausKoordinaten)
		GUISetState(@SW_HIDE, $Form1) 
		MsgBox($MB_SYSTEMMODAL, "Coordinates Saved", "Coordinates saved to config file at " & $sIniFile & @CRLF & "X: " & $aMausPosition[0] & @CRLF & "Y: " & $aMausPosition[1])
	EndIf
	Sleep(100)	
EndFunc


Func _IsPressed($sHexKey)
    Local $aResult = DllCall("user32.dll", "short", "GetAsyncKeyState", "int", '0x' & $sHexKey)
    If Not @error And BitAND($aResult[0], 0x8000) Then
        Return 1
    EndIf
    Return 0
EndFunc

Func ConfigURL()
    Local $sURL = IniRead($sIniFile, "docsGoogleURL", "URL", "")
    While $sURL = "" Or $sURL = "https://docs.google.com *** /edit"
        $input = InputBox("docs.google URL", "Please enter your docs.google URL here" & @CRLF & @CRLF & "Please make sure that anyone can edit this document because you can't log in to Google in GeForce NOW. Keep the link private!", "https://docs.google.com *** /edit")
        If @error = 1 Then ; User pressed the Cancel button
			MsgBox(16, "Missing URL input", "You must enter a valid URL. Script will close now!")
            Exit ; Beende das Script, wenn der Benutzer "Cancel" drückt.
        ElseIf StringRight($input, 4) = "edit" Then
            IniWrite($sIniFile, "docsGoogleURL", "URL", $input)
            $sURL = $input
        EndIf
    WEnd
EndFunc

Func Updater()
    If $updateChecked Then Return
    Local $updateLater = False
    Local $hGUI
    Local $sContent2 = ""
    Local $iPID2 = Run(@ComSpec & ' /c curl -s -k "' & $URLau3 & '"', "", @SW_HIDE, $STDOUT_CHILD)
    If $iPID2 = 0 Then
    MsgBox($MB_SYSTEMMODAL, "Error", "Error starting curl.")
    Exit
    EndIf
    While 1
        $sContent2 &= StdoutRead($iPID2)
        If @error Then ExitLoop
    WEnd
    ProcessClose($iPID2)
    If StringLen($sContent2) > 0 Then
        Local $sSearchText2 = '$VersionL = \"'
        Local $iStartPos2 = StringInStr($sContent2, $sSearchText2)
        If $iStartPos2 > 0 Then
            $VersionG = StringMid($sContent2, $iStartPos2 + StringLen($sSearchText2), 9)
        Else
            MsgBox($MB_SYSTEMMODAL, "Error", "Text 'RelVersion:' not found.")
        EndIf
    Else
        MsgBox($MB_SYSTEMMODAL, "Error", "Error retrieving webpage content.")
    EndIf
    If $VersionL = $VersionG Then
    Else
        $updateLater = True
        $hGUI = CreateGUI()
    EndIf
    If $updateLater Then
        While 1
            $imsg = GUIGetMsg()
            Switch $imsg
                Case $GUI_EVENT_CLOSE
                    Exit
                Case $WEBSITE
                    ShellExecute("https://github.com/KloppstockBw/GFNPoEPriceCheck/")
                    Exit
                Case $UPDATE
                    ExitLoop
            EndSwitch
        WEnd
    EndIf
    GUIDelete($hGUI)
    $updateChecked = True
EndFunc

Func CreateGUI() ; FUNKTION INTEGIEREN?
    Local $hGUI = GUICreate("Update Available", 400, 100)
    GUICtrlCreateLabel("There is a new version for the script on Github." & @CRLF & "Do you want to download the latest version?", 10, 10, 380, 50)
    $WEBSITE = GUICtrlCreateButton("Open Github", 50, 55, 150, 30)
    $UPDATE = GUICtrlCreateButton("Update Later", 210, 55, 150, 30)
    GUISetState()
    Return $hGUI
EndFunc

; Macros   
	
	Func ExitScript()
		Exit
	EndFunc

	Func lasty()
		If Not WinActive("Path of Exile") Then Return
		Send("^{ENTER}")
		Send("^a")
		Sleep(20)
		Send($ty)
		Send("{ENTER}")
	EndFunc

	Func gotoHideout()
		If Not WinActive("Path of Exile") Then Return
		Send("{ENTER}")
		Send("/hideout")
		Send("{ENTER}")
	EndFunc

	Func copyItem()
		If Not WinActive("Path of Exile") Then Return
		If $sURL = 0 Then $sURL = IniRead($sIniFile, "docsGoogleURL", "URL", "")
		$savedMousePos = MouseGetPos()
		Opt("SendKeyDelay", 150)
		Sleep(50)
		Send("!^c")
		Send("{F7}")
		Sleep(150)
		If $counter < 1 Then 
		MsgBox($MB_SYSTEMMODAL, "Waiting for google.docs", "Wait until you see the docs.google document is loaded. "& @CRLF & @CRLF &"Then press OK and repeat {F6} Price check on item.")
		Sleep(80)
		Send("{ESC}")
		$counter += 1
		Return
		EndIf
		Send("^a")
		Send("^v")
		Send("{ESC}")
		Local $i = 0
		While 1
		Local $iPID = Run("curl -s -k " & $sURL, "", @SW_HIDE, $STDOUT_CHILD)
		ProcessWaitClose($iPID)
		
		;;;;;;
		Local $output = StdoutRead($iPID)
		;ClipPut($output)
		$startPos = StringInStr($output, $searchString) + StringLen($searchString)
		$extractedText = StringMid($output, $startPos)
		$position = StringInStr($extractedText, '"},{"ty')
		$ClipboardText = StringLeft($extractedText, $position - 1)
		$clipboardText = StringReplace($clipboardText, "\u0027", "'") 
		$clipboardText = StringReplace($clipboardText, "â€”", "—")
		$clipboardText = StringReplace($clipboardText, '\"', '"')
		$clipboardText = StringReplace($clipboardText, "\n", @CRLF)
		ClipPut($clipboardText)
		;;;;
		Local $output = StdoutRead($iPID)
$startPos = StringInStr($output, $searchString) + StringLen($searchString)
$extractedText = StringMid($output, $startPos)
$position = StringInStr($extractedText, '"},{"ty')
$ClipboardText = StringLeft($extractedText, $position - 1)
$clipboardText = StringReplace(StringReplace(StringReplace(StringReplace($ClipboardText, "\u0027", "'"), "â€”", "—"), '\"', '"'), "\n", @CRLF)
ClipPut($clipboardText)

		
		If StringLeft($clipboardText, 4) = "ITEM" Then ExitLoop
		$i += 1
		If $i >= 50 Then
        MsgBox(16, "Fehler", "Item Copy failed from docs.google!"& @CRLF &" Is this the correct docs.google site and anyone can write in it?: "& $sURL & @CRLF & @CRLF &"If yes, please contact KloppstockBW via github or reddit")
        Return
		EndIf
		Sleep(100)
		WEnd
		Send("+{SPACE}")
		MouseMove($aKoordinaten[1],$aKoordinaten[2], 0)
		MouseClick("left", $aKoordinaten[1],$aKoordinaten[2])
		Sleep(100)
		Send("^v")
		MouseMove($savedMousePos[0], $savedMousePos[1],0)
		Opt("SendKeyDelay", 0)
		
EndFunc