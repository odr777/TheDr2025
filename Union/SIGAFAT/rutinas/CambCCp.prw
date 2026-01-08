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

User Function CambCCp(cCliente)
Local aArea := GetArea()
Local nI

//ALERT(cAlmCab)
//ALERT(M->C5_CLIENTE)

If !Empty(cCliente) .AND. FUNNAME()$"MATA410"
	/*For nI := 1 To Len(aHeader)
		cCampo := Upper(AllTrim(aHeader[nI][2]))
		If cCampo == "C6_CCUSTO"
				nPosLoc   := nI			                
		EndIf	
	Next nI*/
	
	nPosloc  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'C6_CCUSTO'     } )

	For nI := 1 To Len(aCols)                            
	   	aCols[nI][nPosLoc] := cCliente
	Next nI

	oDlg := GetWndDefault()
	
	For nX := 1 To Len(oDlg:aControls)
		If ValType(oDlg:aControls[nX]) <> "U"
			oDlg:aControls[nX]:ReFresh()
		EndIf	
	Next nX

EndIf

RestArea(aArea)

Return M->C5_CLIENTE

