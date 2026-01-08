#include 'protheus.ch'
#Include "Parmtype.ch"
#Include "RWMAKE.CH"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410BLCO  ºAutor  ³ERICK ETCHEVERRY   ºFecha ³  07/08/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE - Que permite alterar a linha do acols referente a      º±±
±±º          ³ bonificacação no Pedido de Venda. Producto bonificado      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \Unión Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A410BLCO
	Local __aHeader := PARAMIXB[1]
	Local __aCols	:= PARAMIXB[2]////solo trae el bonificado por linea
	Local nCCusto 	:= aScan(__aHeader,{|x| AllTrim(x[2])=="C6_CCUSTO" })
	Local nPPrcVen := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_PRCVEN' })
	Local nPPrUnit := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_PRUNIT' })
	Local nPValor  := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_VALOR' })
	Local nDesc    := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_DESCONT' })
	Local nValDes  := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_VALDES' })
	Local nPrcList := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_PRUNIT' })
	Local nPProd    := aScan(__aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
	Local nPProDesc    := aScan(__aHeader,{|x| AllTrim(x[2])=="C6_DESCRI" })
	Local nPQtdVen  := aScan(__aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" })
	Local nPTES		:= aScan(__aHeader,{|x| AllTrim(x[2])=="C6_TES" })
	Local aBonus := {}

	//Aviso("Array IVA",u_zArrToTxt(aCols, .T.),{'ok'},,,,,.t.)

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	If SA1->(DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
		__aCols[nCCusto] := SA1->A1_UCCC
	Endif

	nDesc:=__aCols[nDesc]

	if nDesc> 0
		__aCols[nDesc]:=0 			//C6_DESCONT
		__aCols[nValDes]:=0 			//C6_VALDES
	endif

	__aCols[nPPrcVen] := 0
	__aCols[nPPrUnit] := 0
	__aCols[nPValor ] := 0

	MSGINFO( 'Producto Bonificado: '+alltrim(__aCols[nPProd])+" - "+alltrim(__aCols[nPProDesc])+' , Cantidad: '+alltrim(str(__aCols[nPQtdVen])), "Bonificación" )

Return (__aCols)