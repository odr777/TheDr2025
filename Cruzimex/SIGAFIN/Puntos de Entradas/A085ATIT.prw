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
	If _lPA
		DEFINE MSDIALOG oDlgVCan FROM 05,10 TO 170,270 TITLE "Orden de Pago" PIXEL
		cObs := Space(Len(SE2->E2_HIST))

		@03,04 TO 62,128 LABEL "Glosa" OF oDlgVcan PIXEL
		@12,08 GET cObs PICTURE "@!" SIZE C(090),C(009) VALID .T. Object oGt

		DEFINE SBUTTON FROM 65,100 TYPE 1 ACTION (nOpca := 1,oDlgVCan:End()) ENABLE OF oDlgVCan

		ACTIVATE MSDIALOG oDlgVCan CENTER //VALID Cancela()

		If nOpca == 1
			RecLock("SE2",.F.)
			SE2->E2_HIST := cObs
			SE2->(MsUnlock())
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

Static Function Cancela()
	If Empty(cOBS)
		MSGBOX("Debe-se informar Glosa.","ALERT")
	Else
		_lSai := .T.
		oDlgVCan:End()
	endif
Return(_lSai )