#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M462GRV   ºAutor ³Nahimº Data ³ 11/11/19			 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada en la Grabacion del Remito de Ventas.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ toma valores contables del P.V. para el remito de salida	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function M462GRV()
	Local _nPosPed:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_PEDIDO"})
	Local _nPosIte:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_ITEMPV"})
	Local _nPosCC:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_CCUSTO"})
	Local _nPosITCC:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_ITEMCC"})
	Local _nPosCLVL:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_CLVL"})
	Local nPosDesc:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_UDESC"})
	Local _nCont
	Local _cArea:=GetArea()
	//C6_FILIAL+C6_NUM+C6_ITEM
	SC6->(DbSetOrder(1))
	For _nCont:=1 to Len(aCols)
		If SC6->(DbSeek(xFilial('SC6') + aCols[_nCont,_nPosPed] + aCols[_nCont,_nPosIte]))
			aCols[_nCont,_nPosCC]:=   SC6->C6_CCUSTO
			aCols[_nCont,_nPosITCC]:= SC6->C6_UITEM
			aCols[_nCont,_nPosCLVL]:= SC6->C6_UCLVL
			aCols[_nCont,nPosDesc]:= Posicione("SB1",1,xFilial("SB1")+ SC6->C6_PRODUTO ,"B1_DESC")
		End
	Next _nCont
	RestArea(_cArea)
return
