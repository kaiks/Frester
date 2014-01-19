#include "ParseCsv.au3"

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <SQLite.au3>
#include <SQLite.dll.au3>

$inputFile="input.csv"
AssertFileUtf($inputFile)

Global $aRow = _ParseCsv($inputFile,",","Error parsing input file",1)
$Exercise=FileReadLine($inputFile,1)

HotKeySet("{ENTER}","ProcessQuestion")


Global $RowCount = $aRow[0][0]


#Region ### START Koda GUI section ###
$Form1 = GUICreate("Frester", 615, 235, 192, 124)
$Question = GUICtrlCreateLabel("Question", 16, 8, 470, 49)
$Input = GUICtrlCreateEdit("", 16, 64, 593, 57, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN))
GUICtrlSetData(-1, "Input")
$a1 = GUICtrlCreateButton("à", 16, 136, 27, 25)
$a2 = GUICtrlCreateButton("â", 48, 136, 27, 25)
$ae = GUICtrlCreateButton("æ", 80, 136, 27, 25)
$e1 = GUICtrlCreateButton("è", 112, 136, 27, 25)
$e2 = GUICtrlCreateButton("é", 144, 136, 27, 25)
$e3 = GUICtrlCreateButton("ê", 176, 136, 27, 25)
$e4 = GUICtrlCreateButton("ë", 208, 136, 27, 25)
$i1 = GUICtrlCreateButton("î", 240, 136, 27, 25)
$i2 = GUICtrlCreateButton("ï", 16, 160, 27, 25)
$o1 = GUICtrlCreateButton("ô", 48, 160, 27, 25)
$u1 = GUICtrlCreateButton("ù", 80, 160, 27, 25)
$u2 = GUICtrlCreateButton("û", 112, 160, 27, 25)
$u3 = GUICtrlCreateButton("ü", 144, 160, 27, 25)
$c1 = GUICtrlCreateButton("ç", 176, 160, 27, 25)
$oe = GUICtrlCreateButton("œ", 208, 160, 27, 25)
$Check = GUICtrlCreateButton("Check", 400, 136, 97, 33)
GUICtrlSetBkColor(-1, 0x00FF00)
$Exit = GUICtrlCreateButton("Exit", 504, 192, 105, 33)
$Score = GUICtrlCreateLabel("Score", 496, 8, 112, 49)
$Comments = GUICtrlCreateLabel("Comments", 16, 192, 477, 33)
$Continue = GUICtrlCreateButton("Continue", 504, 136, 107, 33)
GUICtrlSetState(-1, $GUI_DISABLE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

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

Func InsertCharacter($character)
	$CurrentInput = GuiCtrlRead($Input)
	GuiCtrlSetState($Input,$GUI_FOCUS)
	GuiCtrlSetData($Input,$CurrentInput&$character)
EndFunc

Func GenerateQuestion()
	$Question_no = Random(0,$RowCount-1,1)+1
	;_SQLite_QuerySingleRow(-1, "SELECT * FROM questions WHERE id="&$Question_no,$aRow)
	
	$t = Random(0,1,1)
	;MsgBox(0,@error,$Question&$aRow[1+$t])
	$answer = $aRow[$Question_no][1-$t]
	$comment = $aRow[$Question_no][2]
	GUICtrlSetData($Question,$Exercise&@CRLF&$aRow[$Question_no][$t])
	GuiCtrlSetData($Input,"")
	
	GuiCtrlSetData($Comments,"")
	GUICtrlSetBkColor($Comments, 0xF4F4F4)
	
	GUICtrlSetState($Continue, $GUI_DISABLE)
	GuiCtrlSetBkColor($Continue, 0xE4E4E4)
	
	GuiCtrlSetData($Score,"Score: "&$points)
	
	GUICTRLSetBkColor($Check, 0x00FF00)
	GUICtrlSetState($Check, $GUI_ENABLE)
EndFunc

Func ProcessQuestion()
	If BitAnd(GUICtrlGetState($Continue),$GUI_ENABLE) Then
		GenerateQuestion()
	Else
		GUICTRLSetBkColor($Continue, 0x00FF00)
		GUICtrlSetState ($Continue, $GUI_ENABLE)
		if GuiCtrlRead($Input)==$answer Then
			GUICtrlSetBkColor($Comments,0x00FF00)
			$points = $points + 1
			GuiCtrlSetData($Comments,"Correct! "&$points&" points! "&@CRLF&$comment)
			;Sleep(3000)
			;GenerateQuestion()
		Else
			GUICTRLSetBkColor($Check, 0xF4F4F4)
			GUICtrlSetState($Check, $GUI_DISABLE)
			GUICTRLSetBkColor($Continue, 0xFF0000)
			GUICtrlSetBkColor($Comments,0xFF0000)
			$points = $points - 0.5
			GuiCtrlSetData($Comments,"Wrong, -0.5 point. Correct answer: "&$answer&". "&@CRLF&$comment)
		EndIf
	EndIf
EndFunc

Func AssertFileUtf($file)
	If (FileExists($file) == 0) Then
		MsgBox(0x10,"","File "&$file&" does not exist")
		Exit
	Else
		$fileFormat = FileGetEncoding($file)
		if ($fileFormat <> 128 and $fileFormat <> 256) Then
			MsgBox(0x10,"","Bad input file encoding detected. Please set it to UTF-8")
			Exit
		EndIf
	EndIf
EndFunc
