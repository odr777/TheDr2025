#include 'protheus.ch'
#include 'parmtype.ch'

// NT Si devuelve 1 Libera la regla de Negocio

user function FT210OPC()
Local _cArea:=GetArea()                      
Local nPorDesc:=0
Local nPorDesMax:=0
Local nApro:=0

	nPorDesc := GetAdvFVal("SA3","A3_UPORDES",xFilial("SA3")+__CUSERID,7,0)
//	alert('FT210OPC'+SC5->C5_VEND1+' User:'+__CUSERID+' C5_NUM:'+SC5->C5_NUM)
	
	If nPorDesc > 0
		If SC5->C5_DESC1 > nPorDesc
			Alert('El Usuario tiene un Descuento de Aprobación menor al del Pedido:'+CValToChar(SC5->C5_DESC1)+'%')
		Else
			SC6->(DbSetOrder(1))
			SC6->(DbGoTop())
			If SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
				While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
				  iF SC6->C6_DESCONT > nPorDesMax
		 			nPorDesMax := SC6->C6_DESCONT
		 		  EndIf
		 		  iF SC6->C6_DESCONT > nPorDesc
		 		  	Alert('El Item:'+SC6->C6_ITEM+' del PV está con descuento es de:'+CValToChar(SC6->C6_DESCONT)+'%')
		 		  EndIF
		 		SC6->(DbSkip())
		 		End
		 	EndIf
		 	If nPorDesMax >= nPorDesc
		 		Alert('El PV está con máximo descuento del:'+CValToChar(nPorDesMax)+'%')
		 	Else
		 		nApro:=1
		 	EndIf
		EndIf
	Else
		Aviso('Aviso','El Usuario no tiene % de descuento Registrado en la tabla Vendedores',{'ok'},1)
	EndIf
RestArea(_cArea)
return nApro