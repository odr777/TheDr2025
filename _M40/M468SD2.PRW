#Include 'Protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M468SD2   ºAutor  ³Nahim Terrazas P    º Data ³  11/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³en generacion de facturas para traer datos desde el pedido  º±±
±±º          ³o desde el remito en todo caso			                  º±±
±±																          ¹±±
±±ºUso       ³ M40                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M468SD2()
	Local _aArea := GetArea()
	//Local aAreaSD2 := SD2->(GetArea())
	//Local cCentroCosto := ""
	//Local cClaValor := ""
	//Local cItemCuenta := ""
	Dbselectarea("SC6")
	Dbsetorder(1)
	Dbgotop()
	Dbseek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
	If Found() // ENCUENTRA EL PEDIDO DE VENTA

		If Reclock("SD2",.F.)
			// Replace SD2->D2_CCUSTO  With SC6->C6_CCUSTO
			Replace SD2->D2_ITEMCC  With SC6->C6_ITEMCTA
			// Replace SD2->D2_CLVL  	With SC6->C6_UCLVL

			Replace SD2->D2_PRCVEN	With ROUND(SD2->D2_PRCVEN,2)
			Replace SD2->D2_TOTAL	With ROUND(SD2->D2_QUANT * SD2->D2_PRCVEN,2)
		Endif
	ELSE // verificamos si es un Remito
		/*dbSelectArea("SD2")
		SD2->(dbSetOrder(3))
//		D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		If SD2->(dbseek(xFilial("SD2") + SD2->D2_REMITO + SD2->D2_SERIREM + SF2->F2_CLIENTE + SF2->F2_LOJA + SD2->D2_COD + SD2->D2_ITEMREM))
			cCentroCosto := SD2->D2_CCUSTO
			cItemCuenta  := SD2->D2_ITEMCC
			cClaValor:= SD2->D2_CLVL
		EndIf
		SD2->(RestArea(aAreaSD2))
		Reclock("SD2",.F.)
			Replace SD2->D2_CCUSTO With cCentroCosto
			Replace SD2->D2_CLVL With cClaValor
			Replace SD2->D2_ITEMCC With cItemCuenta
		MsUnlock()*/
	Endif

	RestArea(_aArea)

Return

