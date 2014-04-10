#include <Array.au3>

Global $weightColumn = 3

Func NonEmptyElementCount(Const ByRef $array)
	$sum = 1
	For $i = 1 to UBound($array) - 1
		If ($array[$i][0] <> "") Then
			$sum = $sum + 1
		EndIf
	Next
	return $sum
EndFunc

Func RecountArray(ByRef $array)
	$array[0][0] = NonEmptyElementCount($array)
	$array[0][1] = 0
	For $r = 1 To $array[0][0] - 1
		$array[0][$weightColumn] += $array[$r][$weightColumn]
	Next
EndFunc

Func UpdateArray(ByRef $array)
	RecountArray($array)
	
	;Sort array by second column from second element, ascending
	;_ArraySort(ByRef $avArray [, $iDescending = 0 [, $iStart = 0 [, $iEnd = 0 [, $iSubItem = 0]]]])
	_ArraySort($array, 0, 1, $array[0][0] - 1, $weightColumn)
EndFunc

;The idea is that elements in an array store their weights.

;We interpret these weights as intervals on a line, with the length of weight.
;Then we pick any point on the line and see on which interval it is.
;We can check that by summing the value of every item and stopping when:
;	Sum so far + Value of item >= Randomly picked point
Func DrawElementIndex(Const ByRef $array)

	$random_val = Random(0, $array[0][$weightColumn])
	$sum_so_far = 0
	
	For $r = 1 To $array[0][0] - 1
		if ($sum_so_far + $array[$r][$weightColumn] >= $random_val) then
			return $r
		else
			$sum_so_far = $sum_so_far + $array[$r][$weightColumn]
		endif
	Next
EndFunc

Func AssignDefaultWeight(ByRef $array, $value = 1.0)
	$array[0][0] = NonEmptyElementCount($array)
	For $r = 1 To $array[0][0] - 1
		$array[$r][$weightColumn] = $value
	Next
	RecountArray($array)
Endfunc

Func UpdateElementWeight(ByRef $array, $index, $newvalue, $byPercentage = 1)
	$oldvalue = $array[$index][$weightColumn]
	If ($byPercentage = 1) Then
		$array[$index][$weightColumn] = $oldvalue * $newvalue
	Else
		$array[$index][$weightColumn] = $newvalue
	EndIf
	$array[0][$weightColumn] = $array[0][$weightColumn] - $oldvalue + $newvalue
Endfunc

;dim $data[6][2] = [ [0.0], ["unlikely", 0.1], ["kind of likely", 0.5], ["likely", 3], ["impossibru", 0.0] ]
;UpdateArray($data)
