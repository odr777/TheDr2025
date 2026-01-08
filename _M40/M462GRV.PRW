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
	local aHeadSF2 := PARAMIXB[1] ///acols
	Local aSf2Cont  := PARAMIXB[2] // Contenido
	Local _nPosPed:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_PEDIDO"})
	Local _nPosIte:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_ITEMPV"})
	// Local _nPosCC:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_CCUSTO"})
	// Local _nPosITCC:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_ITEMCC"})
	// Local _nPosCLVL:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_CLVL"})
	Local _nPosPrUnit:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_PRUNIT"})
	Local _nPosPrven:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_PRCVEN"})
	Local _nPosTotal:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_TOTAL"})
	Local _nPosQuant:=Ascan(aHeader,{|x| Alltrim(x[2])=="D2_QUANT"})
	
	Local _nCont
	Local _cArea:=GetArea()
	//C6_FILIAL+C6_NUM+C6_ITEM
	Local _nPosMRem:=Ascan(aHeadSF2,{|x| Alltrim(x)=="F2_MOEDA"}) // moneda remito
	local nMoedaPed := Posicione("SC5",1,xFilial("SC5")+aCols[1,_nPosPed],"C5_MOEDA") // BUSCO LA MONEDA DEL PEDIDO DE VENTA
	local cDescGlosaC := SC5->C5_XGLCONT // Nahim busco la descrición del remito Glosa
	local ntotSF2 := 0
	SC6->(DbSetOrder(1))
	For _nCont:=1 to Len(aCols)
		If SC6->(DbSeek(xFilial('SC6') + aCols[_nCont,_nPosPed] + aCols[_nCont,_nPosIte]))
			// aCols[_nCont,_nPosCC]:=   SC6->C6_CCUSTO
			// aCols[_nCont,_nPosITCC]:= SC6->C6_UITEM
			// aCols[_nCont,_nPosCLVL]:= SC6->C6_UCLVL
			// Nahim Cambios 
			// if 
			if  nMoedaPed == 2 .and. aSf2Cont[1,_nPosMRem] == 1  // pedido dólares y remito bs.
				aCols[_nCont,_nPosTotal]:= ROUND(SC6->C6_VALOR * SC5->C5_TXMOEDA,2)
				aCols[_nCont,_nPosPrUnit]:=  aCols[_nCont,_nPosTotal] / aCols[_nCont,_nPosQuant] // ROUND(SC6->C6_PRUNIT * SC5->C5_TXMOEDA,2)
				aCols[_nCont,_nPosPrven]:=  aCols[_nCont,_nPosTotal] / aCols[_nCont,_nPosQuant]  // ROUND(SC6->C6_PRCVEN * SC5->C5_TXMOEDA,2)
				ntotSF2 +=aCols[_nCont,_nPosTotal]
			endif
		End
	Next _nCont
	if  nMoedaPed == 2 .and. aSf2Cont[1,_nPosMRem] == 1  // pedido dólares y remito bs. cambia valor en totales
			aSF2[1][ Ascan(aHeadSF2,{|x| Alltrim(x)=="F2_VALMERC"}) ] := ntotSF2
			aSF2[1][ Ascan(aHeadSF2,{|x| Alltrim(x)=="F2_VALBRUT"}) ] := ntotSF2
	endif 
	aSF2[1][ Ascan(aHeadSF2,{|x| Alltrim(x)=="F2_XGLCONT"}) ] := cDescGlosaC // ADICIONANDO LA DESCRIPCIÓN DE LA GLOSA AL REMITO.
	
	RestArea(_cArea)
return
