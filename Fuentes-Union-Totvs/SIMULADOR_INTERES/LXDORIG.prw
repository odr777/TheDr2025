#INCLUDE "PROTHEUS.CH"

User Function LXDORIG()

Local nPosDLoc := aScan( aHeader, { |x| Alltrim(x[2]) == "D1_XDESDEP"} )
Local nPosDES := aScan( aHeader, { |x| Alltrim(x[2]) == "D1_XDESCRI"} )
Local nItmCol := Len(aCols)
Local nPosProv  := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PROVENT"})


If Funname() $ 'MATA462DN|MATA465N'

	If nPosDES > 0
		aCols[nItmCol][nPosDES] := SD2->D2_XDESCRI
	EndIf

	If nPosDLoc > 0
		aCols[nItmCol][nPosDLoc] := Posicione("NNR",1,xFilial("NNR")+SD2->D2_LOCAL,"NNR_DESCRI")
	EndIf

	If nPosProv > 0
		aCols[nItmCol][nPosProv] := M->F1_PROVENT
	EndIF

EndIf

If Funname() $ 'MATA466N'
	acols[nItmCol][GdFieldpos("D2_XDESCRI")] := SD1->D1_XDESCRI
EndIf

If IsInCallStack("MATA462DN")
	GdFieldPut("D1_XBANDA", SD2->D2_XBANDA, nItmCol)
	GdFieldPut("D1_XCODIGO", SD2->D2_XCODIGO, nItmCol)
	GdFieldPut("D1_XDESADI", SD2->D2_XDESADI, nItmCol)
EndIf

Return(.T.)
