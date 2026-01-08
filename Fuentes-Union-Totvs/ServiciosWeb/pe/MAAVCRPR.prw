#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAAVCRPR  บAutor  ณNahim Terrazas		     Data ณ 11/04/17บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Punto de Entrada para personalizaciones en 		         ฑฑ
ฑฑบ          ณ Analisis de Creditoบ                 				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Union Agronegocios                                         บฑฑ
ฑฑ Este punto de entrada hace que no se bloquee el pedido cuando 		  บฑฑ
ฑฑ la condicion es al contado 						        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑ Modificacion: Nahim Terrazas    01/10/18    Condicion de pago igual a 0 ฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MAAVCRPR()
	Local _lRet:= PARAMIXB[7]
	Local _cArea:=GetArea()

	//ParamIxb[1]=C๓digo do cliente
	//ParamIxb[2]=C๓digo da filial
	//ParamIxb[3]=Valor da venda
	//ParamIxb[4]=Moeda da venda
	//ParamIxb[5]=Considera acumulados de Pedido de Venda do SA1
	//ParamIxb[6]=Tipo de cr้dito (“L” - C๓digo cliente + Filial; “C” - c๓digo do cliente)
	//ParamIxb[7]=Indica se o credito serแ liberado ( L๓gico )
	//ParamIxb[8]=Indica o c๓digo de bloqueio do credito ( Caracter )

	If FunName() <> 'TECA300'
		//E4_FILIAL+E4_CODIGO
		If Posicione('SE4',1,xFilial('SE4')+SC5->C5_CONDPAG,'E4_TIPO') == '1'
			If AllTrim(SE4->E4_COND) == '0' //AL CONTADO
				_lRet:=.T.
			End
		End
	End

	RestArea(_cArea)
Return(_lRet)
