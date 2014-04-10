Global $ignorePolish = true

Func RemovePolish($text)
	$text = StringReplace($text, "ą", "a",0,1)
	$text = StringReplace($text, "ć", "c",0,1)
	$text = StringReplace($text, "ę", "e",0,1)
	$text = StringReplace($text, "ł", "l",0,1)
	$text = StringReplace($text, "ń", "n",0,1)
	$text = StringReplace($text, "ó", "o",0,1)
	$text = StringReplace($text, "ś", "s",0,1)
	$text = StringReplace($text, "ź", "z",0,1)
	$text = StringReplace($text, "ż", "z",0,1)
	
	$text = StringReplace($text, "Ą", "A",0,1)
	$text = StringReplace($text, "Ć", "C",0,1)
	$text = StringReplace($text, "Ę", "E",0,1)
	$text = StringReplace($text, "Ł", "L",0,1)
	$text = StringReplace($text, "Ń", "N",0,1)
	$text = StringReplace($text, "Ó", "O",0,1)
	$text = StringReplace($text, "Ś", "S",0,1)
	$text = StringReplace($text, "Ź", "Z",0,1)
	$text = StringReplace($text, "Ż", "Z",0,1)
	return $text
EndFunc

Func EqualWithoutPolish($a, $b)
	return RemovePolish($a) == RemovePolish($b)
EndFunc

Func _Min3($a, $b, $c)
	$min = $a
	if ($b < $min) then $min = $b
	if ($c < $min) then $min = $c
	
	return $min
EndFunc

Func _Levenshtein ($sString1, $sString2)
    $iStrLen1 = StringLen($sString1)
    $iStrLen2 = StringLen($sString2)

    If $iStrLen1=0 Then 
        Return ($iStrLen2)
    EndIf
    If $iStrLen2=0 Then 
        Return ($iStrLen1)
    EndIf

    If ($iStrLen1>255) Then Return (-1) ; see Note at end of function.
    If ($iStrLen2>255) Then Return (-1) ; see Note at end of function.

    #cs
    ;..........................................................................................................................................
    ; Cleanup procedures, not quite necessary, but useful.
    $sString1 = StringUpper($sString1)
    $sString1 = _StringClean($sString1,"ÄÅÃÂÁÀ","A")
    $sString1 = _StringClean($sString1,"ËÊÉÈ"  ,"E")
    $sString1 = _StringClean($sString1,"ÏÎÍÌ"  ,"I")
    $sString1 = _StringClean($sString1,"ÒÓÔÕÖ" ,"O")
    $sString1 = _StringClean($sString1,"ÜÛÚÙ"  ,"U")
    $sString1 = _StringClean($sString1,"Ç","C")
    $sString1 = _StringClean($sString1,"Ñ","N")

    $sString2 = StringUpper($sString2)
    $sString2 = _StringClean($sString2,"ÄÅÃÂÁÀ","A")
    $sString2 = _StringClean($sString2,"ËÊÉÈ"  ,"E")
    $sString2 = _StringClean($sString2,"ÏÎÍÌ"  ,"I")
    $sString2 = _StringClean($sString2,"ÒÓÔÕÖ" ,"O")
    $sString2 = _StringClean($sString2,"ÜÛÚÙ"  ,"U")
    $sString2 = _StringClean($sString2,"Ç","C")
    $sString2 = _StringClean($sString2,"Ñ","N")

    $sString1 = _StringClean($sString1,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","",2) ;OjO! aquí quito los numeros también
    $sString2 = _StringClean($sString2,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","",2) ;OjO! aquí quito los numeros también
    ;..........................................................................................................................................
    #ce
    
    ; The Levenshtein algorithm
    
    $iStrLen1 = StringLen($sString1)
    $iStrLen2 = StringLen($sString2)

    Dim $aArray [$iStrLen1+1][$iStrLen2+1]

    For $iRow=0 To $iStrLen1
       $aArray[$iRow][0] = $iRow
    Next

    For $iCol=0 To $iStrLen2
       $aArray[0][$iCol] = $iCol
    Next

    For $iRow=1 To $iStrLen1
       For $iCol=1 To $iStrLen2
          $iCost = StringMid($sString1,$iRow,1) <> Stringmid($sString2,$iCol,1)
          $iRowPrev = $iRow-1
          $iColPrev = $iCol-1
          $aArray[$iRow][$iCol] = _Min3(1+$aArray[$iRowPrev][$iCol],1+$aArray[$iRow][$iColPrev],$iCost+$aArray[$iRowPrev][$iColPrev])
	  
	  if($iRow > 1 and $iCol > 1 and StringMid($sString1,$iRow,1) = Stringmid($sString2,$iCol-1,1) and StringMid($sString1,$iRow-1,1) = Stringmid($sString2,$iCol,1)) then
                $aArray[$iRow][$iCol] = _Min3( _
                                 $aArray[$iRow][$iCol], _
				 $aArray[$iRow][$iCol], _
                                 $aArray[$iRow-2][$iCol-2] + 1)   ;transposition
	  EndIf
       Next
    Next
    $iDistance = $aArray[$iStrLen1][$iStrLen2]

    Return ($iDistance)
EndFunc

Func isTypo($word1, $word2)
	if ($ignorePolish) then
		$word1 = RemovePolish($word1)
		$word2 = RemovePolish($word2)
	endif
	
	return _Levenshtein($word1, $word2) <= 1
Endfunc
