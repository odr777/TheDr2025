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

	//Glosa
	If _lPA .AND. 'GENERAR PA' $ CCADASTRO  // NAHIM BOTÓN DE GENERAR PA y es un pa
		// DEFINE MSDIALOG oDlgVCan FROM 05,10 TO 170,270 TITLE "Orden de Pago" PIXEL
		// DEFINE MSDIALOG oDlgVCan FROM 05,10 TO 170,330 TITLE "Orden de Pago" PIXEL
		if type("cobsOrdP") == "U"
			DEFINE MSDIALOG oDlgVCan TITLE "Concepto - Glosa" From 9,0 To 20,90
			public cobsOrdP := Space(Len(SE2->E2_HIST))
			// cobsOrdP :=  "Anticipo "  + ALLTRIM(SA2->A2_NREDUZ) + " / " // TamSX3('CT2_DOC')[1]
			// @03,04 TO 62,128 LABEL "Glosa" OF oDlgVcan PIXEL
			// @12,08 GET cobsOrdP PICTURE "@!" SIZE C(090),C(009) VALID .T. Object oGt
			cobsOrdP := PadR(cobsOrdP,TamSx3("E2_HIST")[1]," ")
			@ 3  ,1 SAY OemToAnsi("Concepto")
			@ 3  ,5  MSGET cobsOrdP  Picture "@!" Valid !Empty(cobsOrdP)
			DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan
			// TamSX3('CT2_DOC')[1]
			ACTIVATE MSDIALOG oDlgVCan CENTER Valid Cancela(@cobsOrdP,@oDlgVCan)
		ENDIF
		// DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan

		// ACTIVATE MSDIALOG oDlgVCan CENTER //VALID Cancela()

		// If nOpca == 1
			RecLock("SE2",.F.)
			SE2->E2_HIST := cobsOrdP
			SE2->(MsUnlock())
		// EndIf
		// If nOpca == 1
			Reclock("SEK",.F.)
			EK_UGLOSA := cobsOrdP
			SEK->(MsUnlock())
		// EndIf
	elseif 	!_lPA // Pago normal
		if type("cobsOrdP") == "U"
			DEFINE MSDIALOG oDlgVCan TITLE "Concepto - Glosa" From 9,0 To 20,90
			PUBLIC cobsOrdP := Space(Len(SE2->E2_HIST))
			// cobsOrdP :=  "Pago "  + ALLTRIM(SA2->A2_NREDUZ) + " / " // TamSX3('CT2_DOC')[1]
			cobsOrdP := PadR(cobsOrdP,TamSx3("E2_HIST")[1]," ")
			@ 3  ,1 SAY OemToAnsi("Concepto")
			@ 3  ,5  MSGET cobsOrdP  Picture "@!" Valid !Empty(cobsOrdP)
			DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan
			// TamSX3('CT2_DOC')[1]
			ACTIVATE MSDIALOG oDlgVCan CENTER //VALID Cancela()
		ENDIF
		// If nOpca == 1
		// 	RecLock("SE2",.F.)
		// 	SE2->E2_HIST := cobsOrdP
		// 	SE2->(MsUnlock())
		// EndIf
		If nOpca == 1
			Reclock("SEK",.F.)
			EK_UGLOSA := cobsOrdP
			SEK->(MsUnlock())
		EndIf	
	EndIf

	//Numero de pedido de compra
	If _lPA
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
	
	RestArea( aArea )
Return

Static Function Cancela(cobsOrdP,oDlgVCan)
	If Empty(cobsOrdP)
		MSGBOX("Debe-se informar Glosa.","ALERT")
	Else
		_lSai := .T.
		// oDlgVCan:End()
	endif
Return(_lSai )
