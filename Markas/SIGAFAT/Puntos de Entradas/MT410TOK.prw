#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT410TOK  บAutor  ณJorge Saavedra        บFecha ณ  04/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE - Que permite realizar validaciones por TODO el     บฑฑ
ฑฑบ          ณ Pedido de Venta                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIMA                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function MT410TOK()
Local lRet		:= .T.
Local nPosProd 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" 	})
Local nl
	
  For nl := 1 To Len(aHeader)
      If aHeader[nl, 2] == "C6_PRODUTO"
      	 nPosProd := nl
      	 Exit
      EndIf
  Next


   For nl := 1 To Len(aCols)
      
      cProdCom := GetAdvFVal("SB1","B1_UCOMPLE",xFilial("SB1")+aCols[nl,nPosProd],1,"")
      lProdCom:= .T.  
      IF !Empty(cProdCom) .and.!GdDeleted(nl)
      	For nk := 1 To Len(aCols)
      		IF aCols[nk,nPosProd] $ cProdCom .and.!GdDeleted(nk)
      			lProdCom:= .F.
      			Exit
      		End
      	Next
      	If lProdCom
      		 lRet		:= .F.
      		 Aviso("Validaci๓n Pedido de Ventas",'El Producto: '+ aCols[nl,nPosProd] + ' NO tiene su producto Complementario: '+ cProdCom,{"Ok"},,"Atencion")
      	end
      END
  Next
return lRet