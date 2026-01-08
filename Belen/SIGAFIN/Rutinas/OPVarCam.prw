#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OPVarCam    ºAutor  ³EDUAR ANDIA       º Data ³  06/03/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Diferencia en Cambio en Orden de Pago                      º±±
±±º          ³ Baja de Título                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia\Unión                                      		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OPVarCam
Local aArea 	:= GetArea()
Local aAreaSE2  := SE2->(GetArea())
Local nVlDifCb 	:= 0
Local nxVlHoy 	:= 0
Local nTxTitulo := 0

DbSelectArea("SE2")
SE2->(DbSetOrder(1))
If SE2->(DbSeek(xFilial("SE2")+SEK->EK_PREFIXO+SEK->EK_NUM+SEK->EK_PARCELA+SEK->EK_TIPO+SEK->EK_FORNECE+SEK->EK_LOJA))
	
	If ALLTRIM(SEK->EK_TIPODOC) $ "TB" .AND. ALLTRIM(SEK->EK_TIPO) $ "NF|NDP|NCP|PA" .AND. SEK->EK_MOEDA=="2"
		nxVlHoy := SEK->EK_VLMOED1
		
		/*** Verifica la Última Diferencia en Cálculo ***/
		If SE2->E2_TXMDCOR > 0
			If SE2->E2_DTVARIA <> SEK->EK_EMISSAO
				nVUltCor := SEK->EK_VALOR * SE2->E2_TXMDCOR
				nVlDifCb := nxVlHoy - nVUltCor
			Endif
		Else
			/*** No tiene corrección cambiaria ***/
			nTxTitulo := SE2->E2_TXMOEDA
			If nTxTitulo==0
				nTxTitulo := RecMoeda(SE2->E2_EMISSAO,SE2->E2_MOEDA)			
			Endif
			
			nVlDifCb 	:= nxVlHoy - (SEK->EK_VALOR * nTxTitulo)
		Endif
	Endif
Endif

If nVlDifCb <> 0
	nVlDifCb := ROUND( nVlDifCb, 2 )
Endif

RestArea(aAreaSE2)
RestArea(aArea)

Return(nVlDifCb)
