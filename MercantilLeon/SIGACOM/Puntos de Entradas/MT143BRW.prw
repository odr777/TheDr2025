#INCLUDE 'RWMAKE.CH'
//Punto de Entrada para Agregar un bot๓n en el Browser al PC MATA120  (Pedido de Compra)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออปอปฑฑ
ฑฑบFuno    ณ MTA143MNU  บ Autor ณ Erick Etcheverry    บ Data ณ  28/08/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนออฑฑ
ฑฑบDescrio ณMenu dentro de inclusion visualizacion modificacion del despachoบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนอนฑฑ
ฑฑบUso       ณ TdeP                                       	            	  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MT143BRW()
	aadd(aRotina,{ "Imprimir gastos" , 'u_RGtoImpMCL()', , }) //trae gastos externos
	aadd(aRotina,{ "Imprimir gastos despacho" , 'u_RGtoImport()', , }) //trae gastos externos
	aadd(aRotina,{ "Imprimir despacho" , 'u_IMDESPA()', , }) //trae gastos externos
	aadd(aRotina,{ "Imprimir despacho sin cantidad" , 'u_IMDESP2()', , }) //trae gastos externos
	AADD(AROTINA, {'Conocimiento', 	"MsDocument", 0, 4 } )
RETURN
