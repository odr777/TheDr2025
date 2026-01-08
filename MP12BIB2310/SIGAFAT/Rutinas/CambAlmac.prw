#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³CambAlmac ºAuthor ³TdeP º Date ³  05/03/2017                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que cambia automaticamente el Almacen de los items º±±
±±º          ³ en el Presupuesto o Pedido de Venta recibiendo como        º±±
±±º          ³ parametro el Almacen de la Cabecera                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CambAlmac(cAlmCab)
	Local lRet:= .T.
	Local aArea		:= GetArea()
	Local aAreaTmp1:= TMP1->(GetArea())
	Local nX
	nPosPre  := Ascan(aHeader, { |x| Upper(AllTrim(x[2]))=="CK_LOCAL" })

	If !Empty(cAlmCab) .AND. FUNNAME()$"MATA415"

		dbSelectArea("TMP1")
		dbGotop()
		While (!Eof())
			TMP1->CK_LOCAL:= cAlmCab
			dbSelectArea("TMP1")
			dbSkip()
		EndDo

		RestArea(aAreaTmp1)

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

	EndIf
	RestArea(aAreaTmp1)
	RestArea( aArea )
Return cAlmCab


User Function CambAlmP(cAlmCab)
	Local aArea := GetArea()
	Local nI
	local nX
	If !Empty(cAlmCab) .AND. FUNNAME()$"MATA410"
		For nI := 1 To Len(aHeader)
			cCampo := Upper(AllTrim(aHeader[nI][2]))
			If cCampo == "C6_LOCAL"
				nPosLoc   := nI
			EndIf
		Next nI

		For nI := 1 To Len(aCols)
			aCols[nI][nPosLoc] := cAlmCab
		Next nI

		oDlg := GetWndDefault()

		For nX := 1 To Len(oDlg:aControls)
			If ValType(oDlg:aControls[nX]) <> "U"
				oDlg:aControls[nX]:ReFresh()
			EndIf
		Next nX

	EndIf

	RestArea(aArea)

Return cAlmCab

