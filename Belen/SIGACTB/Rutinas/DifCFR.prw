#Include 'Protheus.ch'
#Include 'Parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DifCFR  ºAutor  ³EDUAR ANDIA			º Data ³ 17/08/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica Diferencia Cambiaria T.C. de factura de entrada   º±±
±±º          ³ vs T.C. Actual (SM2)                            		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \ Belén 		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DifCFR(nPerc)
Local nRet 		:= 0
Local nVlrItm	:= 0
Local nDifCmb	:= 0
Default nPerc 	:= 100

If SF1->F1_MOEDA==2
	If SF1->F1_TXMOEDA <> RecMoeda(SF1->F1_EMISSAO,2)
		nVlrItm := SD1->D1_TOTAL-SD1->D1_VALDESC+SD1->D1_SEGURO+SD1->D1_DESPESA+SD1->D1_VALFRE
		nFat1 	:= xMoeda(nVlrItm,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,RecMoeda(SF1->F1_EMISSAO,2))	//6.96
		nFat2 	:= xMoeda(nVlrItm,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,4,SF1->F1_TXMOEDA)				//6.86
		nDifCmb := nFat1 - nFat2
		nRet 	:= (nDifCmb * nPerc) /100
	Endif
Endif

Return(nRet)
