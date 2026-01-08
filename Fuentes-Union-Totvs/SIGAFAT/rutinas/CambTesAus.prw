#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³CambAlmac ºAuthor ³TdeP º Date ³  05/03/2017                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que cambia automaticamente la Test auspicio 560 de º±±
±±º          ³ los items en el Presupuesto o Pedido de Venta recibiendo   º±±
±±º          ³ como parametro el Almacen de la Cabecera                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CambTesAus()
Local aArea := GetArea()
Local nI

//ALERT(cAlmCab)
//ALERT(M->C5_CLIENTE)

//If !Empty(cCliente) .AND. FUNNAME()$"MATA410"
If FUNNAME()$"MATA410"
	/*For nI := 1 To Len(aHeader)
		cCampo := Upper(AllTrim(aHeader[nI][2]))
		If cCampo == "C6_CCUSTO"
				nPosLoc   := nI			                
		EndIf	
	Next nI*/
	
	nPosloc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'C6_TES'     } )
	IF M->C5_CONDPAG='000'
		For nI := 1 To Len(aCols)                            
			aCols[nI][nPosLoc] := '560'
		Next nI
	else
		For nI := 1 To Len(aCols)                            
			aCols[nI][nPosLoc] := '510'
		Next nI
	endif

	oDlg := GetWndDefault()
	
	For nX := 1 To Len(oDlg:aControls)
		If ValType(oDlg:aControls[nX]) <> "U"
			oDlg:aControls[nX]:ReFresh()
		EndIf	
	Next nX

EndIf

RestArea(aArea)

Return M->C5_CONDPAG

