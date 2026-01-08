#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProgram ณGetStockNeg บAuthor ณAmby Arteaga Rivero บ Date ณ 11/06/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que Comprueba si el Stock del Producto es Negativoบฑฑ
ฑฑบ          ณ en base a la al valor del campo B1_UNEGATI				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUse       ณ Mercantil LEON S.R.L.                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GetStockNeg(cProducto,cLocal, nCantVen)

	nCantidad := nCantVen
	nCantActual := GetAdvFVal("SB2","B2_QATU",xFilial("SB2") + cProducto + cLocal,1,"")
	nCantReserv := GetAdvFVal("SB2","B2_QPEDVEN",xFilial("SB2") + cProducto + cLocal,1,"")
	nCantStock := nCantActual - nCantReserv
	nCant := nCantStock - nCantVen
	cUNegati := GetAdvFVal("SB1","B1_UNEGATI",xFilial("SB1") + cProducto,1,"")
	
	If nCant < 0 .AND. cUNegati=="N" 
		If FUNNAME()$"MATA415"
			aviso("ALERTA","Cantidad Actual en Stock: " + CValToChar(nCantActual) + " - Cantidad Actual en Pedido de Venta: " + CValToChar(nCantReserv) + " = Cantidad Disponible en Stock: " + CValToChar(nCantStock) + " ... Este producto NO permite Stock Negativo. Sin embargo le permitirแ grabar el Presupuesto",{'ok'},,,,,.t.)
			nCantidad := nCantVen
		Else
			If FUNNAME()$"MATA410" .OR. FUNNAME()$"MATA467N"
				If (M->C5_DOCGER <> "3")
					aviso("ALERTA","Cantidad Actual en Stock: " + CValToChar(nCantActual) + " - Cantidad Actual en Pedido de Venta: " + CValToChar(nCantReserv) + " = Cantidad Disponible en Stock: " + CValToChar(nCantStock) + " ... Este producto NO permite Stock Negativo, Favor modificar la cantidad o seleccionar otro producto",{'ok'},,,,,.t.)
					nCantidad := 0
				Else
					aviso("ALERTA","Cantidad Actual en Stock: " + CValToChar(nCantActual) + " - Cantidad Actual en Pedido de Venta: " + CValToChar(nCantReserv) + " = Cantidad Disponible en Stock: " + CValToChar(nCantStock) + " ... Este producto NO permite Stock Negativo. Sin embargo le permitirแ grabar el Pedido con Entrega Futura",{'ok'},,,,,.t.)
					nCantidad := nCantVen
				EndIf
			Else
				nCantidad := nCantVen
			EndIf
		EndIf
	EndIf

Return nCantidad
