#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462GRV   ºAutor ³Erick Etcheverry		 º Data ³ 21/04/20º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grabar CC en el remito de ventas					 	      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Union	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function M462GRV()
	Local nPosPed:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_PEDIDO"})
	Local nPosIte:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_ITEMPV"})
	Local nPosSeq:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_SEQUEN"})
	Local nPosPro:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_COD"})
	Local nPosDesc:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_UDESC"})
	Local nPosCC:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_CCUSTO"})
	Local nPosTP:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_UTIPOEN"}) //TIPO ENTREGA C5
	Local nPosUsreg:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_UCUSREG"})
	Local nPosUmoeda:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_UMOEDA"})

	Local i
	Local _cArea:=GetArea()

	SC9->(DbSetOrder(1))
	For i:= 1 to Len(aCols)
		If SC9->(DbSeek(xFilial('SC9')+aCols[i,nPosPed]+aCols[i,nPosIte]+aCols[i,nPosSeq]+aCols[i,nPosPro]))
			aCols[i,nPosCC]:= GETADVFVAL("SC6","C6_CCUSTO",xfilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO,1,"erro")
			aCols[i,nPosTP]:= SC5->C5_UTIPOEN
			aCols[i,nPosDesc]:= GETADVFVAL("SC6","C6_DESCRI",xfilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO,1,"erro")

		Endif
		aCols[i,nPosUsreg]:= SC5->C5_USRREG
		aCols[i,nPosUmoeda]:= SC5->C5_MOEDA		
	Next i

	RestArea(_cArea)
return
