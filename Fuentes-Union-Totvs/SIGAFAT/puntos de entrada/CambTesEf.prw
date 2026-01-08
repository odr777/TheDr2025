#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³CambTesEf ºAuthor ³Widen EGv º Date ³  01/09/2020           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcion que cambia automaticamente la Test 530 de entrega  º±±
±±º          ³ futura en los items en el Pedido de Venta                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CambTesEf()
Local aArea := GetArea()
Local nI
Local cContenido:=&(ReadVar())

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
	nPoscod  	:= Ascan( aHeader, { |x| Alltrim( x[2] ) == 'C6_PRODUTO'     } )
	
	IF M->C5_DOCGER='3'
		For nI := 1 To Len(aCols)                            
			aCols[nI][nPosLoc] := '530'
		Next nI
	else
		//IF M->C5_CONDPAG<>'000'
		IF !M->C5_CONDPAG $'000|00 '
			For nI := 1 To Len(aCols)
		    	//POSICIONE("SB1",1,XFILIAL("SB1")+aCols[nI][nPoscod],"B1_TS")
				//aCols[nI][nPosLoc] := '510'
				aCols[nI][nPosLoc] := POSICIONE("SB1",1,XFILIAL("SB1")+aCols[nI][nPoscod],"B1_TS")
			Next nI
		else
			For nI := 1 To Len(aCols)                            
				aCols[nI][nPosLoc] := '560'
			Next nI
		EndIf
	endif

	oDlg := GetWndDefault()
	
	For nX := 1 To Len(oDlg:aControls)
		If ValType(oDlg:aControls[nX]) <> "U"
			oDlg:aControls[nX]:ReFresh()
		EndIf	
	Next nX

EndIf

RestArea(aArea)

//Return M->C5_CONDPAG
Return cContenido
