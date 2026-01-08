#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462FIM   ºAutor  ³Jorge Saavedra    ºFecha ³  22/07/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada que permite replicar datos desde el pedidoº±±
±±º          ³de ventas hacia el remito de vtas al momento de generar el  º±±
±±º          ³proceso de remision    automatica                           º±±
±±º          ³       SC5 ---> SD2 (arrastra el tipo de venta            º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M462FIM()

Local _aArea :=	GetArea()
Local aAmbSC5 := SC5->(GetArea())
Local aAmbSC6 := SC6->(GetArea())
Local aAmbSF2 := SF2->(GetArea())
Local aAmbSD2 := SD2->(GetArea())
Local aRem := ParamIxb[1]
Local nPedido := SC5->C5_NUM


///MSGSTOP("ENTRE EN M462FIM")
/*
For nrem := 1 to Len(aRem)
	Dbselectarea("SF2")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("SF2")+aRem[nrem,2]+aRem[nrem,1])
	If Found()    
		dbselectarea("SD2")
		DbsetOrder(3)
		DbGotop()
		DbSeek(xFilial("SD2")+aRem[nrem,2]+aRem[nrem,1])
		If Found()
			nPedido := SD2->D2_PEDIDO
				
			
			DbSelectArea("SD2")
			Do While !EOF() .and. alltrim(aRem[nrem,2]) == alltrim(SD2->D2_DOC) .and. alltrim(SD2->D2_SERIE) == alltrim(aRem[nrem,1])
				dbselectArea("SC6")
				DBsetorder(1)
				DbGotop()
				DbSeek(xFilial("SC6")+nPedido+SD2->D2_ITEM)
				If Found()
					dbselectArea("SD2")
					If Reclock("SD2",.F.)
						Replace SD2->D2_CCUSTO with SC6->C6_CC, SD2->D2_ITEMCC with SC6->C6_ITEMCTA
						MsUnlock()
					Endif
				endif
				dbselectarea("SD2")
				DbSkip()
			Enddo
		Endif 
	Endif
next nrem              
*/
RestArea(aAmbSF2)
RestArea(aAmbSD2)
RestArea(aAmbSC6)
RestArea(_aArea) 
Return {aRem}