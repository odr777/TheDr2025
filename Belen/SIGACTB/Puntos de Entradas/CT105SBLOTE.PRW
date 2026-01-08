#Include "Protheus.ch"
#Include "parmtype.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³ CT105SBLOTE   ºAuthor ³EDUAR ANDIA    º Date ³  09/07/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para alterar o sub lote de um lançamento contábil de    º±±
±±º          ³ integração antes da sua gravação. 			  			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ Bolivia \Belén SRL.									      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT105SBLOTE
	Local cSbLoteExec 	:= PARAMIXB[1]		//No lo Carga
	Local __cLp			:= CT5->CT5_LANPAD

	If Empty(__cLp)
		__cLp := CTK->CTK_LP
	Endif

	If !Empty(__cLp)

		Do Case
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Factura de Entrada					³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case (__cLp =="650")
			If AllTrim(SF1->F1_ESPECIE) $ "NF"
				If !Empty(SF1->F1_HAWB) .OR. SF1->F1_TIPODOC $ "13|14"
					cSbLoteExec := "IMP"
				Else
					cCaixa 	:= POSICIONE("SEU",7,xFilial("SF1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,"EU_CAIXA")
					If !Empty(cCaixa)
						cSbLoteExec := "CCH"
					Else
						//Respeta config. CT5_SBLOTE
					Endif
				Endif
			Endif

			If AllTrim(SF1->F1_ESPECIE) $ "NDP"
				cSbLoteExec := "NDP"
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Factura de Salida					³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case (__cLp =="610")
			If AllTrim(SF2->F2_ESPECIE) $ "NCP"
				cSbLoteExec := "NCP"
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ ITF					³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Case (__cLp =="56A")
			/*
			If AllTrim(FUNNAME()) $ "XFINA371"
				cSbLoteExec := "COB"
			Endif
			*/
			If AllTrim(SE5->E5_ORIGEM) $ "FINA087A"
				cSbLoteExec := "COB"
			Endif
		
			If AllTrim(SE5->E5_ORIGEM) $ "FINA085A"
				cSbLoteExec := "PAG"
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contabilizar Finiquito				³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			/*Case (__cLp =="001")
				IF SRA->RA_DEMISSA <> SToD("//")
					cSbLoteExec := "FIN"	
				ENDIF
			*/
			OtherWise
			//Respeta config. CT5_SBLOTE
		EndCase

	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Contabilizar Finiquito				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Alltrim(Funname()) == "GPEM110"
		IF SRA->RA_DEMISSA <> SToD("//")
			cSbLoteExec := "FIN"	
		ENDIF
	ENDIF

Return (cSbLoteExec)
