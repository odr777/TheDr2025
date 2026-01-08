#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPE  ³ MT410ALT ºAutor  			  									  º±±
±±						   Nahim Terrazas 	 Fecha    29/04/19			  ¹±±
±±ºDesc.     ³ Ejecutado después de la Alteración de la información		  º±±
±±ºDesc.     ³ de un Pedido de Venta		 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Totvs                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function MT410ALT()
	Local aArea := GetArea()

	// Nahim Incluyendo para sumar el valor en C5_UTOTPED
	nTotalPEdVis := U_GETPEDTOT(SC5->C5_NUM,SC5->C5_CLIENTE)
	RecLock("SC5",.F.)
		Replace 	C5_UTOTPED      With nTotalPEdVis
	MsUnlock()
	// Nahim Incluyendo para sumar el valor en C5_UTOTPED
	
	RecLock("SC5",.F.)
//	If EMPTY(SC5->C5_URECIBO) Nahim Terrazas 19/12/2019 
	If funname() == "MATA467N"// En caso se modifique luego de que el cliente esté revirtiendo y haya devuelto la venta
		Replace C5_BLQ  With "1"
		Replace C5_URECIBO  With " "
		Replace C5_USERIE  With " "
		Replace C5_USTATUS  With " "
		Replace C5_UBLOQDE	with "Pedido de venta Devuelto por el cliente"		// Agregando descripción de Bloqueo NTP 03/02/2020
	Endif
	If !EMPTY(SC5->C5_URECIBO) .AND. funname() == "MATA410"// En caso se modifique luego de que el cliente haya pagado o se esté revirtiendo
		Replace C5_BLQ  With "1"
		Replace C5_UBLOQDE	with "Modificado luego de haber realizado una venta"		// Agregando descripción de Bloqueo NTP 03/02/2020
	Endif
//	IF M->C5_CONDPAG $ '002|501|502' AND !EMPTY(SC5->C5_URECIBO)   // Modificando cuando existe un pago ya realizado Nahim 03/02/20
//		Replace C5_BLQ  With "1"
//		Replace C5_UBLOQDES	with "Modificado luego de haber realizado una venta"		// Agregando descripción de Bloqueo NTP 03/02/2020
//	Endif
	If M->C5_BLQ == "1"  .AND. funname() == "MATA410"// si es que se está modificando uno que estaba en azul debería mantenerse el bloqueo NTP 23/12/2019
		Replace C5_BLQ  With "1"
		Replace C5_UBLOQDE with M->C5_UBLOQDE		// Agregando descripción de Bloqueo NTP 03/02/2020
	Endif
	MsUnlock()
	// caso se esté modificando un pedido que teng


	RestArea(aArea)
return