#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAAVCRPR  ºAutor  ³Nahim Terrazas			   Data ³ 11/04/17º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada para personalizaciones en 				   ±±
±±º          ³ Analisis de Creditoº                 					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Mercantil Leon                                             º±±
±±È Este punto de entrada hace que no se bloquee el pedido cuando la condicion ¼±±
±± es al contado 													±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MAAVCRPR()                                          
Local _lRet:=PARAMIXB[7]
Local _cArea:=GetArea()

//ParamIxb[1]=Código do cliente 
//ParamIxb[2]=Código da filial 
//ParamIxb[3]=Valor da venda 
//ParamIxb[4]=Moeda da venda 
//ParamIxb[5]=Considera acumulados de Pedido de Venda do SA1 
//ParamIxb[6]=Tipo de crédito (“L” - Código cliente + Filial; “C” - código do cliente) 
//ParamIxb[7]=Indica se o credito será liberado ( Lógico ) 
//ParamIxb[8]=Indica o código de bloqueio do credito ( Caracter )


//       alert(SC5->C5_CONDPAG)
If FunName() <> 'TECA300'                                       
	If Posicione('SE4',1,xFilial('SE4')+SC5->C5_CONDPAG,'E4_TIPO') == '1'
       If AllTrim(SE4->E4_COND) $ '00/0 ' //AL CONTADO	
//       alert("retornara true")
		   _lRet:=.T.         
	   End	   
	End                      
End

//MATA440 
//alert("Condicion "+ cvaltochart(SC5->C5_CONDPAG))
/* Comentado por Nain por ser Campo Personalizado
Reclock('SC5',.F.)
SC5->C5_UBLQCRE:=If(_lRet,'N','S')
SC5->(MsUnlock())
*/

RestArea(_cArea)
Return(_lRet)