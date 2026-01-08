#include "rwmake.ch"
#include "topconn.ch"

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM468NGRV  บAutor  ณTdeP บFecha ณ  27/05/2019     			  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPunto de entrada para que no se repita la linea del  		  บฑฑ
ฑฑบ          ณpedido de venta.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP12BIB                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

User Function M410LIOK

	LOCAL nC6_PRODUTO := GdFieldPos("C6_PRODUTO", aHeader)
	//LOCAL nC6_OPER    := GdFieldPos("C6_OPER", aHeader)
	LOCAL nC6_ITEM    := GdFieldPos("C6_ITEM", aHeader)
	LOCAL nLinhaAtual := n
	LOCAL nLoop := 0

	For nLoop := 1 to Len( aCols )
		// Nใo deve validar a linha atual.
		If nLoop == nLinhaAtual
			Loop
		EndIf
		If (aCols[n,nC6_PRODUTO] == aCols[nLoop,nC6_PRODUTO])   .and. (aCols[n,len(aCols[n])] == aCols[nLoop,len(aCols[n])])
			MsgInfo("Este producto ya fue digitado en el item " + aCols[nLoop,nC6_ITEM] )
			Return(.f.)
		EndIf
	Next nLoop

Return(.t.) 