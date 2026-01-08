#include 'protheus.ch'
#include 'parmtype.ch'

user function MYPEPO()
	Local aDuiPos:= {}
	/*Aviso("Array IVA",u_zArrToTxt(aCols, .T.),{'ok'},,,,,.t.)
	Aviso("Array IVA",u_zArrToTxt(aCols1, .T.),{'ok'},,,,,.t.)
	Aviso("Array IVA",u_zArrToTxt(aCols2, .T.),{'ok'},,,,,.t.)
	Aviso("Array IVA",u_zArrToTxt(aColsIt, .T.),{'ok'},,,,,.t.)*/
	for i:= 1 to len(aCols1) // si tiene dua al otro lado
		if aCols1[i][4] == "D"
			aadd(aDuiPos,i)
		endif
	next i

	if len(aDuiPos) > 0  //actualizamos los items por el dua al otro lado en que posicion
		for z := 1 to len(aDuiPos)
			aColsIt[aDuiPos[z]][1][15] := "311"
		next z
	endif
	
	if aCols[n][3] == "DUA" ///siempre en la descripcion tiene dua para asegurarnos
		aCols[n][15] := "311"
	endif

	eval(bGDRefresh)
	eval(bFolderRefresh)
	eval(bRefresh)
	eval(bListRefresh)
	
	if aCols[n][3] == "DUA"
		aCols[n][15] := "311"
	endif

return ""