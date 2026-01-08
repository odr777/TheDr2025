#include 'protheus.ch'
//#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M468NGRV  ºAutor  ³Erick Etcheverry ºFecha ³  08/04/2020    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada que se ejecuta en la generacion de Nota   º±±
±±º          ³ despues de Generar Nota                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M468SD2()
	Local aAreaSD2 := SD2->(GetArea())
	Local cCUSTO := ""
	Local cDescPro := ""
	Local cUtpLiq := ""

	Dbselectarea("SC6") // nahim busqueda del 
	Dbsetorder(1)
	Dbgotop()
	Dbseek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD) // BUSCA EL PEDIDO DE VENTA 
	If Found() // ENCUENTRA EL PEDIDO DE VENTA

		If Reclock("SD2",.F.)
			Replace SD2->D2_CCUSTO  With SC6->C6_CCUSTO
			Replace SD2->D2_ITEMCC  With SC6->C6_UITEM
			// Replace SD2->D2_CLVL   With SC6->C6_UCLVL
			Replace SD2->D2_UDESC With Posicione("SB1",1,xFilial("SB1")+ SD2->D2_COD ,"B1_DESC")
		Endif
	endif

	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))
	If SD2->(msSeek(xFilial("SD2") + SD2->D2_REMITO + SD2->D2_SERIREM + SF2->F2_CLIENTE + SF2->F2_LOJA + SD2->D2_COD + SD2->D2_ITEMREM))
		cCUSTO := SD2->D2_CCUSTO
		cDescPro:=SD2->D2_UDESC
		cUtpLiq := SD2->D2_UTPLIQ
	EndIf
	SD2->(RestArea(aAreaSD2))

	If !Empty(cCusto)
		Reclock("SD2",.F.)
		Replace SD2->D2_CCUSTO With cCUSTO
		MsUnlock()
	EndIf

	If !Empty(cDescPro)
		Reclock("SD2",.F.)
		Replace SD2->D2_UDESC With cDescPro
		MsUnlock()
	EndIf

	///EET REMITO SI NO PEDIDO
	If !Empty(cUtpLiq)
		Reclock("SD2",.F.)
		Replace SD2->D2_UTPLIQ With cUtpLiq

		MsUnlock()
	else
		Reclock("SD2",.F.)
		Replace SD2->D2_UTPLIQ With Posicione("SC6",1,xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD,"C6_UTPLIQ")
		MsUnlock()
	EndIf

	if ALLTRIM(SuperGetMv("MV_BONUSTS")) <> SD2->D2_TES
		Reclock('SD2',.F.)
		SD2->D2_VALIMP2 := ROUND ((SD2->D2_BASIMP2*SD2->D2_ALQIMP2/100),4)
		SD2->D2_VALIMP1 := ROUND ((SD2->D2_BASIMP1*SD2->D2_ALQIMP1/100),4)
		MsUnlock()
	endif

Return
