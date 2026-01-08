#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A085ATIT  ºAutor  ³Walter C Silva(Boli)º Data ³ 25/MAR/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada após gravacao da Ordem de Pago.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 - GUC                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A085ATIT()
	Local aArea 	:= GetArea()
	Local _lPA		:= .F.
	Private _lSai	:= .F.
	
	i 		:= 0
	nOpca 	:= 0
	cRot 	:= UPPER(AllTrim(ProcName(i)))
	While !Empty(cRot)
		If cRot $ "A085APGADI"         //Pago Antecipado
			_lPA:=.T.
			Exit
		Else
			i := i + 1
			cRot := UPPER(AllTrim(ProcName(i)))
		Endif
	EndDo

	//Glosa ************************************************************************************
	If _lPA .AND. 'GENERAR PA' $ CCADASTRO  // NAHIM BOTÓN DE GENERAR PA y es un pa
		PUBLIC cGlosaCon
		DEFINE MSDIALOG oDlgVCan FROM 05,10 TO 170,270 TITLE "Orden de Pago" PIXEL
		cGlosaCon := Space(Len(SE2->E2_HIST))

		@03,04 TO 62,128 LABEL "Glosa" OF oDlgVcan PIXEL
		@12,08 GET cGlosaCon PICTURE "@!" SIZE C(090),C(009) VALID .T. Object oGt

		DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan

		ACTIVATE MSDIALOG oDlgVCan CENTER //VALID Cancela()

		If nOpca == 1
			RecLock("SE2",.F.)
			SE2->E2_HIST := cGlosaCon
			SE2->(MsUnlock())
		EndIf
			If nOpca == 1
			Reclock("SEK",.F.)
			EK_UGLOSA := cGlosaCon
			SEK->(MsUnlock())
		EndIf
		
		saveGlSE5(SEK->EK_ORDPAGO) // Llama a la funcion que grava en la SE5

	elseif 	!_lPA // Pago normal
		if type("cGlosaCon") == "U"
			DEFINE MSDIALOG oDlgVCan TITLE "Concepto - Glosa" From 9,0 To 20,90
			PUBLIC cGlosaCon := Space(Len(SE2->E2_HIST))
			// cGlosaCon :=  "Pago "  + ALLTRIM(SA2->A2_NREDUZ) + " / " // TamSX3('CT2_DOC')[1]
			cGlosaCon := PadR(cGlosaCon,TamSx3("E2_HIST")[1]," ")
			@ 3  ,1 SAY OemToAnsi("Concepto")
			@ 3  ,5  MSGET cGlosaCon  Picture "@!" Valid !Empty(cGlosaCon)
			DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan
			// TamSX3('CT2_DOC')[1]
			ACTIVATE MSDIALOG oDlgVCan CENTER //VALID Cancela()
		ENDIF
		// If nOpca == 1
		// 	RecLock("SE2",.F.)
		// 	SE2->E2_HIST := cGlosaCon
		// 	SE2->(MsUnlock())
		// EndIf
		If nOpca == 1
			Reclock("SEK",.F.)
			EK_UGLOSA := cGlosaCon
			SEK->(MsUnlock())
		EndIf	
		
	EndIf

		
	//Numero de pedido de compra
	/*If _lPA
		DEFINE MSDIALOG oDlgVCan FROM 05,10 TO 170,270 TITLE "Orden de Pago" PIXEL
		cPC := Space(Len(SE2->E2_UPC))

		@03,04 TO 62,128 LABEL "Numero de Pedido de Compra" OF oDlgVcan PIXEL
		@15,08 MsGet cPC PICTURE "@!" Size C(050),C(009) VALID .T.  COLOR CLR_BLACK PIXEL OF oDlgVcan

		DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan

		ACTIVATE MSDIALOG oDlgVCan CENTER //VALID Cancela()

		If nOpca == 1
			RecLock('SE2',.F.)
			SE2->E2_UPC := cPC
			SE2->(MsUnlock())

			RecLock('SEK',.F.)
			SEK->EK_UPC := cPC
			SEK->(MsUnlock())
		EndIf		
	EndIf
	*/
	RestArea( aArea )
Return

Static Function Cancela(cGlosaCon,oDlgVCan)
	If Empty(cGlosaCon)
		MSGBOX("Debe-se informar Glosa.","ALERT")
	Else
		_lSai := .T.
		// oDlgVCan:End()
	endif
Return(_lSai )

/**
* @author: Denar Terrazas Parada
* @since: 01/08/2022
* @description: Función que graba la glosa en la tabla SE5
*/
Static Function saveGlSE5(cOrdPago)
	Local aArea     := GetArea()
	Local CTIPPAGO  := "P"//Indica que es un pago(P)

	DbSelectArea("SE5")
	SE5->( DbSetOrder(8) )//E5_FILIAL+E5_ORDREC+E5_SERREC
	If(SE5->( DbSeek(xFilial("SE5") + cOrdPago) ))
		
		iif (Empty(SE5->E5_PROCTRA),,SaveGlITF(SE5->E5_PROCTRA)) // VERIFICA LOS ITF  

		While !EOF() .AND. SE5->E5_FILIAL == xFilial("SEK") .AND. SE5->E5_ORDREC == cOrdPago			
			If( TRIM(SE5->E5_RECPAG) == CTIPPAGO )//Si es pago
				Reclock("SE5",.F.)
				E5_UGLOSA := cGlosaCon
				MsUnlock()
			EndIf
			SE5->(DBSkip())			
		Enddo

	EndIf
	SE5->(DbCloseArea())

	RestArea( aArea )
Return

Static Function SaveGlITF(cProcTra)
	Local aArea     := GetArea()
	cUpdate := "UPDATE " + "SE5010" + " SET " + "E5_UGLOSA" + " = '" + cGlosaCon + "' WHERE E5_PROCTRA = '" + cProcTra + "'AND E5_BANCO= '" + cBanco + "' AND E5_AGENCIA= '" + cAgencia + "' AND E5_CONTA= '" + cConta + "'AND E5_TIPODOC='IT' AND D_E_L_E_T_='' "    						
	If TcSqlExec(cUpdate) < 0 
		//conout("ERRO AO ATUALIZAR:["+cUpdate+']')
		aLERT ('No actualizo Glosa ITF')
	EndIf


	RestArea( aArea )
Return

