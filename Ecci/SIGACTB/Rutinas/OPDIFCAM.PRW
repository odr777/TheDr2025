#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OPVarCam    ºAutor  ³Nahim Terrazas     º Data ³  27/01/2021º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Diferencia en Cambio en Orden de Pago                      º±±
±±º          ³ Banco tipo de cambio menor cuando se paga una CXC          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia\Unión                                      		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OPDIFCam(nMoeda)
Local nVlDifCb 	:= 0
// Local nxVlHoy 	:= 0
// Local nTxTitulo := 0


// RecMoeda(E5->E2_EMISSAO,SE2->E2_MOEDA) //

If ALLTRIM(SEK->EK_TIPODOC) $ "TB" .AND. ALLTRIM(SEK->EK_TIPO) $ "NF|NDP|NCP|PA" .AND. SEK->EK_MOEDA=="1"// si es baja y paga en bolivianos
    ntaxaNormal := RecMoeda(SEK->EK_EMISSAO,2)
    if RecMoeda(SEK->EK_EMISSAO,2) <> SEK->EK_TXMOE02 // SI LA TASA DE LA MONEDA ES DIFERENTE 
        nValTasaNormal :=  SEK->EK_VALOR  /ntaxaNormal   // normal 
        nValBancoTasa  :=  SEK->EK_VALOR / SEK->EK_TXMOE02  // tasa banco (Menor)
        if (nValBancoTasa - nValTasaNormal ) > 0
            nVlDifCb := round(nValBancoTasa - nValTasaNormal,2) 
            if nMoeda == 1 // dólar
                nVlDifCb = round(nVlDifCb * ntaxaNormal,2)
            endif
        endif
    ENDIF
endif

// DbSelectArea("SE2")
// SE2->(DbSetOrder(1))
// If SE2->(DbSeek(xFilial("SE2")+SEK->EK_PREFIXO+SEK->EK_NUM+SEK->EK_PARCELA+SEK->EK_TIPO+SEK->EK_FORNECE+SEK->EK_LOJA))
	
// 	If ALLTRIM(SEK->EK_TIPODOC) $ "TB" .AND. ALLTRIM(SEK->EK_TIPO) $ "NF|NDP|NCP|PA" .AND. SEK->EK_MOEDA=="2"
// 		nxVlHoy := SEK->EK_VLMOED1
		
// 		/*** Verifica la Última Diferencia en Cálculo ***/
// 		If SE2->E2_TXMDCOR > 0
// 			If SE2->E2_DTVARIA <> SEK->EK_EMISSAO
// 				nVUltCor := SEK->EK_VALOR * SE2->E2_TXMDCOR
// 				nVlDifCb := nxVlHoy - nVUltCor
// 			Endif
// 		Else
// 			/*** No tiene corrección cambiaria ***/
// 			nTxTitulo := SE2->E2_TXMOEDA
// 			If nTxTitulo==0
// 				nTxTitulo := RecMoeda(SE2->E2_EMISSAO,SE2->E2_MOEDA)			
// 			Endif
			
// 			nVlDifCb 	:= nxVlHoy - (SEK->EK_VALOR * nTxTitulo)
// 		Endif
// 	Endif
// Endif

// If nVlDifCb <> 0
// 	nVlDifCb := ROUND( nVlDifCb, 2 )
// Endif

// RestArea(aAreaSE2)
// RestArea(aArea)

Return(nVlDifCb)
