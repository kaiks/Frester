#include "ParseCsv.au3"
#include "draw.au3"
#include "typo.au3"

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <GUIEdit.au3>

;Locales
$checkLabel	= "Check"
$exitLabel	= "Exit"
$scoreLabel	= "Score: "
$commentsLabel	= "Feedback"
$continueLabel	= "Continue"

$typoLabel	= "Typo. 0.5 point. Correct answer: "
$correctLabel	= "Correct! "
$pointsLabel	= " points! "

$wrongAnswerLabel = "Wrong. -0.5 point. Correct answer: "

$badEncodingLabel = "Bad file encoding detected. Ensure that input.csv is encoded using UTF-8"
$badDataLabel     = "Error during input data parsing"

$fileLabel = "File "
$dneLabel  = " doesn't exist."

;


$inputFile = "input.csv"

AssertFileUtf($inputFile)

Global $aRow	= _ParseCsv($inputFile,",",$badDataLabel,1)
$descriptionLine = FileReadLine($inputFile,1)
$descriptionInfo = StringSplit($descriptionLine, "|")
$Exercise	= $descriptionInfo[1]

AssignDefaultWeight($aRow)

Global $RowCount = $aRow[0][0]

Global $randomizeQA = $descriptionInfo[2]



#Region ### START Koda GUI section ### Form=F:\Programowanie\Autoit\Tester\v2_form.kxf
$Form1 = GUICreate("Frester", 663, 320)
GUISetFont(16, 400, 0, "Calibri")
$Question = GUICtrlCreateLabel("Question", 16, 8, 521, 78)
$Input = GUICtrlCreateEdit("", 16, 88, 633, 57, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN))
GUICtrlSetData(-1, "Input")
$hInput_Handle = GUICtrlGetHandle(-1)
$cSelAll = GUICtrlCreateDummy()
$a1 = GUICtrlCreateButton("à", 16, 152, 28, 28)
$a2 = GUICtrlCreateButton("â", 48, 152, 28, 28)
$ae = GUICtrlCreateButton("æ", 80, 152, 28, 28)
$e1 = GUICtrlCreateButton("è", 112, 152, 28, 28)
$e2 = GUICtrlCreateButton("é", 144, 152, 28, 28)
$e3 = GUICtrlCreateButton("ê", 176, 152, 28, 28)
$e4 = GUICtrlCreateButton("ë", 208, 152, 28, 28)
$i1 = GUICtrlCreateButton("î", 240, 152, 28, 28)
$i2 = GUICtrlCreateButton("ï", 16, 184, 28, 28)
$o1 = GUICtrlCreateButton("ô", 48, 184, 28, 28)
$u1 = GUICtrlCreateButton("ù", 80, 184, 28, 28)
$u2 = GUICtrlCreateButton("û", 112, 184, 28, 28)
$u3 = GUICtrlCreateButton("ü", 144, 184, 28, 28)
$c1 = GUICtrlCreateButton("ç", 176, 184, 28, 28)
$oe = GUICtrlCreateButton("œ", 208, 184, 28, 28)
$Check = GUICtrlCreateButton($checkLabel, 440, 176, 97, 33)
GUICtrlSetBkColor(-1, 0x00FF00)
$Exit = GUICtrlCreateButton($exitLabel, 544, 280, 105, 33)
$Score = GUICtrlCreateLabel($scoreLabel, 552, 8, 99, 38, $SS_RIGHT)
$Comments = GUICtrlCreateLabel($commentsLabel, 16, 216, 518, 93)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Continue = GUICtrlCreateButton($continueLabel, 544, 176, 107, 33)
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Dim $aAccelKeys[1][2]=[["^a", $cSelAll]]
GUISetAccelerators($aAccelKeys)

HotKeySet("{ENTER}","ProcessQuestion")

Global $Question_no  = -1
Global $answer = ""
Global $t = -1
Global $points = 0
Global $comment = ""

GenerateQuestion()
While 1
	Sleep(10)
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cSelAll
            _SelAll()
		Case $Check
			ProcessQuestion()
		Case $Exit
			Exit
		Case $Continue
			GenerateQuestion()
		Case $a1
			InsertCharacter(GuiCtrlRead($a1))
		Case $a2
			InsertCharacter(GuiCtrlRead($a2))
		Case $ae
			InsertCharacter(GuiCtrlRead($ae))
		Case $e1
			InsertCharacter(GuiCtrlRead($e1))
		Case $e2
			InsertCharacter(GuiCtrlRead($e2))
		Case $e3
			InsertCharacter(GuiCtrlRead($e3))
		Case $e4
			InsertCharacter(GuiCtrlRead($e4))
		Case $i1
			InsertCharacter(GuiCtrlRead($i1))
		Case $i2
			InsertCharacter(GuiCtrlRead($i2))
		Case $o1
			InsertCharacter(GuiCtrlRead($o1))
		Case $u1
			InsertCharacter(GuiCtrlRead($u1))
		Case $u2
			InsertCharacter(GuiCtrlRead($u2))
		Case $u3
			InsertCharacter(GuiCtrlRead($u3))
		Case $c1
			InsertCharacter(GuiCtrlRead($c1))
		Case $oe
			InsertCharacter(GuiCtrlRead($oe))
	EndSwitch
WEnd

Func _SelAll()
    Switch _WinAPI_GetFocus()
        Case $hInput_Handle
            _GUICtrlEdit_SetSel($hInput_Handle, 0, -1)
            Return
    EndSwitch
EndFunc   ;==>_SelAll

Func InsertCharacter($character)
	$CurrentInput = GuiCtrlRead($Input)
	GuiCtrlSetState($Input,$GUI_FOCUS)
	GuiCtrlSetData($Input,$CurrentInput&$character)
EndFunc

Func GenerateQuestion()
	$Question_no = DrawElementIndex($aRow)
	
	$t = Random(0,$randomizeQA,1)
	;MsgBox(0,@error,$Question&$aRow[1+$t])
	$answer = $aRow[$Question_no][1-$t]
	$comment = $aRow[$Question_no][2]
	GUICtrlSetData($Question,$Exercise&@CRLF&$aRow[$Question_no][$t])
	GuiCtrlSetData($Input,"")
	
	GuiCtrlSetData($Comments,"")
	GUICtrlSetBkColor($Comments, 0xF4F4F4)
	
	GUICtrlSetState($Continue, $GUI_DISABLE)
	GuiCtrlSetBkColor($Continue, 0xE4E4E4)
	
	GuiCtrlSetData($Score,$scoreLabel&$points)
	
	GUICTRLSetBkColor($Check, 0x00FF00)
	GUICtrlSetState($Check, $GUI_ENABLE)
EndFunc

Func ProcessQuestion()
	If WinActive("Frester","") Then
		If BitAnd(GUICtrlGetState($Continue),$GUI_ENABLE) Then
			GenerateQuestion()
		Else
			$userAnswer = GuiCtrlRead($Input)
			GUICTRLSetBkColor($Continue, 0x00FF00)
			GUICtrlSetState ($Continue, $GUI_ENABLE)
			if EqualWithoutPolish($userAnswer,$answer) Then
				GUICtrlSetBkColor($Comments,0x00FF00)
				$points = $points + 1
				GuiCtrlSetData($Comments,$correctLabel&$points&$pointsLabel&@CRLF&$comment)
				UpdateElementWeight($aRow, $Question_no, 0.1)
				;Sleep(3000)
				;GenerateQuestion()
			ElseIf isTypo($userAnswer,$answer) Then
				GUICTRLSetBkColor($Check, 0xF4F4F4)
				GUICtrlSetState($Check, $GUI_DISABLE)
				GUICTRLSetBkColor($Continue, 0xFFFF00)
				GUICtrlSetBkColor($Comments,0xFFFF00)
				$points = $points + 0.5
				GuiCtrlSetData($Comments,$typoLabel & $answer & ". " &@CRLF&$comment)
			Else
				GUICTRLSetBkColor($Check, 0xF4F4F4)
				GUICtrlSetState($Check, $GUI_DISABLE)
				GUICTRLSetBkColor($Continue, 0xFF0000)
				GUICtrlSetBkColor($Comments,0xFF0000)
				$points = $points - 0.5
				GuiCtrlSetData($Comments,$wrongAnswerLabel & $answer&". "&@CRLF&$comment)
				UpdateElementWeight($aRow, $Question_no, 5.0)
			EndIf
		EndIf
	Else
		HotKeySet("{ENTER}")
		Send("{Enter}")
		HotKeySet("{ENTER}","ProcessQuestion")
	EndIf
EndFunc

Func AssertFileUtf($file)
	If (FileExists($file) == 0) Then
		MsgBox(0x10,"",$fileLabel&$file&$dneLabel)
		Exit
	Else
		$fileFormat = FileGetEncoding($file)
		if ($fileFormat <> 128 and $fileFormat <> 256) Then
			MsgBox(0x10,"",$badEncodingLabel)
			Exit
		EndIf
	EndIf
EndFunc
