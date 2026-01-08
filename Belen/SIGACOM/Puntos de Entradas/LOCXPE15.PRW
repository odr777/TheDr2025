#INCLUDE "RWMAKE.CH"
#Include 'Protheus.ch'
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³LOCXPE15  ºAuthor ³Erick Etcheverry    º Date ³  01/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Punto de Entrada despues de Guardar SD1 Y SD2   Por Item  º±±
±±º Actualiza SCP campos para el proceso de transferencia de almac        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ GENERI                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
[15] - Apos a gravação do SD1 
*/

User Function LOCXPE15

	// Transferencia Entre Sucursales - Salida
	If (aCfgNf[1]== 54)
		// Actualizamos la Tabla de Solicitudes a Almacen

		If !empty(SD2->D2_USCPNUM)
			SCP->(dbSelectArea("SCP"))
			SCP->(DbSetOrder(1))

			If SCP->(DbSeek(xFilial('SCP') + SD2->D2_USCPNUM + SD2->D2_UITEMSA))
				RecLock("SCP",.F.)
				SCP->CP_QUJE := SCP->CP_QUJE  + SD2->D2_QUANT
				If SCP->CP_QUJE == SCP->CP_QUANT
					SCP->CP_PREREQU  := "S"
					SCP->CP_STATUS = 'E'
				EndIf
				SCP->(MsUnlock())
			EndIf
		Endif

	EndIf

	//Alert("Finalizó LOCXPE15")
	
Return
