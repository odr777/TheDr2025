#include 'protheus.ch'
#include 'parmtype.ch'
#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410MNU  บAutor  ณJorge Saavedra      บFecha ณ  06/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE - Que permite adicionar aRotinas en la Pantalla de      บฑฑ
ฑฑบ          ณ Pedido de Venta.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SAGITARIO                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA410MNU
	
	//aadd(aRotina,{'Imp. Nota Venta','U_NOTAPED()' , 0 , 4,0,NIL})
	//Local aRotina2  := {{"Asignar"   ,'EXECBLOCK("ENTREGAPV",.F.,.F.,"A")',0,4},;						
		//			{"Visualizar",'EXECBLOCK("ENTREGAPV",.F.,.F.,"V")',0,2}}
					
	//AADD(AROTINA, {"Asignar Serie"   ,'EXECBLOCK("ENTREGAPV",.F.,.F.,"A")',0,4})
	//AADD(AROTINA, {"Visual. Serie"   ,'EXECBLOCK("ENTREGAPV",.F.,.F.,"V")',0,2})
	aadd(aRotina,{'Imprimir PV','U_PEDVEN()' , 0 , 2,0,NIL})
	aadd(aRotina,{'Pick List','U_PickList()' , 0 , 2,0,NIL})	
Return
