#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PE   ³ MT110END 			     ³Autor³ Erick Etcheverry ³Data 26/11/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE  Despues de accionar los botones de aprobacion de SC    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACOM                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


user function MT110END()
	Local nNumSC := PARAMIXB[1] // NUMERO DE SOLICITUD
	Local nOpca  := PARAMIXB[2]       // 1 = Aprobar; 2 = Rechazar; 3 = Bloquear //

	if nOpca == 1
		U_PMSPreRe(xFilial("AF9"),'','',SC1->C1_PRODUTO,SC1->C1_QUANT,SC1->C1_ITEMCTA,'S')
		///validar aqui adentro mauro
		//ALERT("Verificar su saldo etcccccc")
	ELSE // caso esté bloqueado o rechazado.
		private cGlosaCon := Space(50)
		dbSelectArea("SC1")
		dbSetOrder(1)
		dbSeek( xFilial("SC1") + cNumSC )
		DEFINE MSDIALOG oDlg TITLE "Justificación Rechazo / Bloqueo" From 9,0 To 20,90
		//		@ 1  ,1 SAY SA2->A2_NOME
		//		@ 2  ,1 SAY "Valor    :     "+ TransForm( SEK->EK_VALOR , "@E 999,999,999,999,999.999")
		@ 3  ,1 SAY OemToAnsi("Concepto")
		@ 3  ,5  MSGET cGlosaCon  Picture "@!" Valid !Empty(cGlosaCon)
//		CT5_FILIAL+CT5_LANPAD+CT5_SEQUEN
		// fEjecutar :=  GetAdvFVal("CT5","CT5_HIST",xFilial("CT5")+CT5->CT5_LANPAD ,1,"")
		cGlosaCon :=SC1->C1_XRECHAZ

		// cGlosaCon := &fEjecutar

		DEFINE SBUTTON FROM 5 ,166  TYPE 1 ACTION oDlg:End() ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg centered
		While SC1->C1_NUM == cNumSC

			If RecLock("SC1")
				SC1->C1_XRECHAZ := cGlosaCon // Nahim 19/06/2020
				SC1->(MsUnLock())
			EndIf
			SC1->(dbSkip())
		Enddo
	ENDIF
return