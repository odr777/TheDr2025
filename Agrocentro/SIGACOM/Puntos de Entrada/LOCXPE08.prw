#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  LOCXPE08  ºAutor  ³ERICK ETCHEVERRY	   º Data ³  26/09/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ actualiza campos adicionales en los lotes         		  º±±
±±º          ³ 				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOCXPE08
	Local _aArea	:= GetArea()
    Local cFilSB8		:= xFilial("SB8")

	//If alltrim(FunName()) $ "MATA102N" .AND. INCLUI

	DbSelectArea("SD1")
	DbSetOrder(3)

	DbSeek(XFILIAL('SD1')+SF1->(DTOS(F1_EMISSAO)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) ) //posicionamos la SD1

	While SD1->(!Eof()).AND. SF1->(DTOS(F1_EMISSAO)+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)==SD1->(DTOS(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)

		///producto tiene rastro
		if Rastro(SD1->D1_COD)

			/////ACTULIZAMOS EL MAESTRO DEL LOTE
			nOrd  := 3
			cSeek := (cFilSB8+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_LOTECTL)
			cCondSB8 := "B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL=="
			cCondSB8 +="xFilial('SB8')+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_LOTECTL"
			nQtdEmp	:=	SD1->D1_QUANT

			DbSelectArea("SB8")
			DbSetOrder(nOrd)
			If DbSeek(cSeek)
				While !Eof() .AND. &(cCondSB8) .AND. nQtdEmp >	0  //EJECUTA &

					RecLock("SB8",.F.)
					SB8->B8_XGRADO := SD1->D1_XGRADO
					SB8->B8_XPESO := SD1->D1_XPESO
					SB8->B8_XGERULT := SD1->D1_XGERULT
					MsUnlock()

					SB8->(dbSkip())

				ENDDO
			endif

			///ACTUALIZAMOS MOVIMIENTO DE LOTE
			aAreaSD5 := SD5->(GetArea())
			SD5->(dbSetOrder(3))

			cSeekSD5:=xFilial('SD5')+SD1->D1_NUMSEQ+SD1->D1_COD+SD1->D1_LOCAL+SD1->D1_LOTECTL

			If SD5->(MsSeek(cSeekSD5, .F.))
				RecLock("SD5",.F.)
				SD5->D5_XGERULT := SD1->D1_XGERULT
				MsUnlock()
			ENDIF

		endif

		SD1->(DbSkip())

	enddo

	//ENDIF

	RestArea(_aArea)

Return
