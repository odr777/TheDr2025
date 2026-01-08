#include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  LOCXPE08  ºAutor  ³ERICK ETCHEVERRY	   º Data ³  26/09/19 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ actualiza campos adicionales en los lotes SD5 y SB8 		  º±±
±±º          ³ 				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MT261TDOK
	Local _aArea	:= GetArea()
	Local cFilSB8		:= xFilial("SB8")

	dbSelectArea('SD3')
	dbSetOrder(2)
	dbSeek(xFilial()+cDocumento)

	While SD3->(!Eof()).AND. SD3->D3_FILIAL+SD3->D3_DOC==xFilial()+cDocumento

		if Rastro(SD3->D3_COD) .AND. SD3->D3_XGERULT > 0

			nOrd  := 3
			cSeek := (cFilSB8+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL)
			cCondSB8 := "B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL=="
			cCondSB8 +="xFilial('SB8')+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL"
			nQtdEmp	:=	SD3->D3_QUANT

			DbSelectArea("SB8")
			DbSetOrder(nOrd)
			If DbSeek(cSeek)
				While !Eof() .AND. &(cCondSB8) .AND. nQtdEmp >	0  //EJECUTA &

					RecLock("SB8",.F.)
					SB8->B8_XGERULT := SD3->D3_XGERULT
					MsUnlock()

					SB8->(dbSkip())

				ENDDO
			endif

			///ACTUALIZAMOS MOVIMIENTO DE LOTE
			aAreaSD5 := SD5->(GetArea())
			SD5->(dbSetOrder(3))

			cSeekSD5:=xFilial('SD5')+SD3->D3_NUMSEQ+SD3->D3_COD+SD3->D3_LOCAL+SD3->D3_LOTECTL

			If SD5->(MsSeek(cSeekSD5, .F.))
				RecLock("SD5",.F.)
				SD5->D5_XGERULT := SD3->D3_XGERULT
				MsUnlock()
			ENDIF

		ENDIF

		SD3->(DBSKIP())
	ENDDO

	RestArea(_aArea)

return
