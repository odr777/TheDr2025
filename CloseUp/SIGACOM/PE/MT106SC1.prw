#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT106SC1  ºAutor  ³TdeP ºFecha ³  25/11/2019     			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada para indicar al usuario que solicitudes deº±±
±±º          ³de compras fueron generadas.								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MT106SC1()

	Local aDados := PARAMIXB[1]
	IF FUNNAME() $ "MNTA420|MNTA410|MNTA340|MNTA365" // si estoy ejecutandoló desde la rutina de Mant. Activos (Servicios)
		if PARAMIXB[1] == "SC1"
			dbselectArea("SN3") // T9_FILIAL+T9_CODBEM
			dbsetorder(1)

			If dbSeek( xFilial("SN3") + SUBSTR(ST9->T9_CODIMOB,1,10) )
				cClaseValor :=  SN3->N3_CLVL
			EndIf
			//	cDesc := "Orden servicio : " + SUBSTR(SCP->CP_OP,1,6) + " - Generada por Mant. del Bien: "  + STJ->TJ_ORDEM //+ ST9->T9_CODIMOB
			cDesc := "Orden de servicio : " + SUBSTR(STJ->TJ_ORDEM,1,6) + " - Generada por Mant. del Bien: "  + ST9->T9_CODBEM //+ ST9->T9_CODIMOB

			RecLock('SC1',.F.)
			//	Replace SCP->CP_NUMOS  With SUBSTR(SCP->CP_OP,1,6)
			Replace SC1->C1_OBS  With cDesc
			REPLACE SC1->C1_CLVL WITH cClaseValor
			//		SX1->X1_CNT01 := aRegOrPag[1][1] //SEK->EK_ORDPAGO// DTOS(CT2->CT2_DATA)
			SCP->(MsUnlock())
		ENDIF

		//			MsgInfo("Se Generó la Solicitud de compra nro: " + PARAMIXB[2])
	ENDIF

return
