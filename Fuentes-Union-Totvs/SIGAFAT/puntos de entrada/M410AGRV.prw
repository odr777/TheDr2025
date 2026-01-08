#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPE  ณ M410AGRV บAutor  ณErick Etcheverry บFecha ณ  11/12/17 			  บฑฑ
ฑฑ						  												  นฑฑ
ฑฑบDesc.     ณ Ejecutado antes de la grabaci๓n de la informaci๓n		  บฑฑ
ฑฑบDesc.     ณ de un Pedido de Venta		 							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Totvs/UNION BONIFICACION MANUAL                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function M410AGRV()
	Local __aHeader := aHeader
	Local nCCusto 	:= aScan(__aHeader,{|x| AllTrim(x[2])=="C6_CCUSTO" })
	Local nPPrcVen := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_PRCVEN' })
	Local nPPrUnit := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_PRUNIT' })
	Local nPValor  := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_VALOR' })
	Local nDesc    := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_DESCONT' })
	Local nValDes  := aScan(__aHeader,{|x| AllTrim(x[2])=='C6_VALDESC' })
	Local nPProd    := aScan(__aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
	Local nPProDesc    := aScan(__aHeader,{|x| AllTrim(x[2])=="C6_DESCRI" })
	Local nPQtdVen  := aScan(__aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" })
	Local nPTES		:= aScan(__aHeader,{|x| AllTrim(x[2])=="C6_TES" })
	Local nTPliq	:= aScan(__aHeader,{|x| AllTrim(x[2])=="C6_UTPLIQ" })

	for i:= 1 to len(aCols)
		if aCols[i][nPTES] == "550" .and. !EMPTY(ALLTRIM(aCols[i][nTPliq]))
			aCols[i][nPPrcVen]:= 0
			aCols[i][nPPrUnit]:= 0
			aCols[i][nPValor]:= 0
			aCols[i][nDesc]:= 0
			aCols[i][nValDes]:= 0
			MSGINFO( 'Producto Bonificado: '+alltrim(aCols[i][nPProd])+" - "+alltrim(aCols[i][nPProDesc])+' , Cantidad: '+alltrim(str(aCols[i][nPQtdVen])), "Bonificaci๓n" )
		endif
	next i

return