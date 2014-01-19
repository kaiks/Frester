;
;params:
;    filename
;    delimeter
;    message display if cannot open file
;    logical true/false to skip the first line of the file

;_ParseCSV("filename",",","message if error happens",true

Func _ParseCSV($f,$Dchar,$error,$skip)

  Local $array[500][500]
  Local $line = ""

  $i = 0
  $file = FileOpen($f,0)
  If $file = -1 Then
    MsgBox(0, "Error", $error)
    Return False
   EndIf

  ;skip 1st line
  If $skip Then $line = FileReadLine($file)

  While 1
       $i = $i + 1
       Local $line = FileReadLine($file)
       If @error = -1 Then ExitLoop
       $row_array = StringSplit($line,$Dchar)
       If $i == 1 Then $row_size = UBound($row_array) 
       If $row_size <> UBound($row_array) Then  MsgBox(0, "Error", "Row: " & $i & " has different size ")
       $row_size = UBound($row_array)
       $array = _arrayAdd_2d($array,$i,$row_array,$row_size)

  WEnd
  FileClose($file)
  $array[0][0] = $i-1 ;stores number of lines
  $array[0][1] = $row_size -1  ; stores number of data in a row (data corresponding to index 0 is the number of data in a row actually that's way the -1)
  Return $array

EndFunc
Func _arrayAdd_2d($array,$inwhich,$row_array,$row_size)
    For $i=0 To $row_size-2 Step 1
        $array[$inwhich][$i] = $row_array[$i+1]
  Next
  Return $array
   EndFunc
