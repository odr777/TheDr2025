#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DEPCTBGRV 	ºAutor  ³Jorge Cardona   ºFecha ³  23/09/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Impresión de los asientos contables -Online           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Colombia                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DEPCTBGRV
Local aAreaCtb	:= GetArea()
Local cTpSaldo	:= CT2->CT2_TPSALD
Local cDebito	:= CT2->CT2_DEBITO
Local cCredito	:= CT2->CT2_CREDIT
Local nValor	:= CT2->CT2_VALOR
Local cSequen	:= CT2->CT2_SEQUEN
Local cLp		:= CT2->CT2_LP
Local cSegofi	:= CT2->CT2_SEGOFI
Local cSublote	:= CT2->CT2_SBLOTE
Local dData		:= CT2->CT2_DATA
Local cxFilial	:= CT2->CT2_FILIAL

If ALLTRIM(cLp)== "" .AND. cTpSaldo=="9"

	dbSelectArea("CT2")
	DbSetOrder(12)
	If dbSeek(cxFilial+cSegofi+cSublote)
		If CT2->CT2_LP == "610" 
			cEsFat := "T"
		Else
			cEsFat := "F"
		EndIf 
		
		While CT2->(!Eof()) .and. (cxFilial+cSegofi+cSublote == CT2->CT2_FILIAL+CT2->CT2_SEGOFI+CT2->CT2_SBLOTE)
			
			cTpSaldo	:= CT2->CT2_TPSALD
			cDebito		:= CT2->CT2_DEBITO
			cCredito	:= CT2->CT2_CREDIT
			nValor		:= CT2->CT2_VALOR
			cSequen		:= CT2->CT2_SEQUEN
			cLp			:= CT2->CT2_LP
			cSegofi		:= CT2->CT2_SEGOFI
			cSublote	:= CT2->CT2_SBLOTE
			dData		:= CT2->CT2_DATA
			If ALLTRIM(CT2->CT2_LP)<> ""
				If CT2->CT2_DC == "1"
					cCostoD		:= CT2->CT2_CCD
				EndIf
				If CT2->CT2_DC == "2"
					cCostoC		:= CT2->CT2_CCC
				EndIf
				If CT2->CT2_DC == "3"
					cCostoD		:= CT2->CT2_CCD
					cCostoC		:= CT2->CT2_CCC
				EndIf
				
			EndIf
			
			//AVISO("Tipo de Saldo", "El tipo de saldo :"+" "+cTpSaldo, { "Aceptar" }, 1)
			//AVISO("Tipo de Saldo", "El tipo de saldo :"+" "+cSequen, { "Aceptar" }, 1)
			//AVISO("Tipo de Saldo", "El tipo de saldo :"+" "+cDebito, { "Aceptar" }, 1)
			//AVISO("VALOR", "VALOR :"+cvaltochar(transform(nValor,"99,999,999.99")), { "Aceptar" }, 1)
			
			RecLock("CT2",.F.)
				CT2->CT2_TPSALD := "1"
				If ALLTRIM(cLp)== "" .AND. cEsFat == "T"
					If CT2->CT2_DC == "1"
						CT2->CT2_CCD := cCostoD
					ElseIf CT2->CT2_DC == "2"
						CT2->CT2_CCC := cCostoC
					ElseIf CT2->CT2_DC == "3"
						CT2->CT2_CCD := cCostoD
						CT2->CT2_CCC := cCostoC
					EndIF
					
				EndIf
			CT2->(MsUnlock())
			
			dbSkip()
		EndDO
	EndIF

EndIf
	


RestArea(aAreaCtb)
Return
