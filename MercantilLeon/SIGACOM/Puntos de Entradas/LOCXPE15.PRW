#INCLUDE "RWMAKE.CH"
#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³LOCXPE15  ºAuthor ³Nain Terrazas º Date ³  22/04/2017       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Punto de Entrada despues de Guardar SD1 Y SD2   Por Item  º±±
±±º          ³  Deshabilita los datos de Origen para las NCP para el 	  º±±
±±º          ³  Recálculo de Costo medio no ponga en 0 x el estándar 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MERCANTIL LEON                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LOCXPE15

/////Actualizar almacen solicitud

// OD 10/08/2022
// Se quitó - lógica no correspponde a ML, no existen los campos D2_USCPNUM, D2_UITEMSA 

/*If (aCfgNf[1]== 54)
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

	EndIf*/

// Nota de Crédito  Proveedor 

// OD 10/08/2022
// Se quitó - no se idenficó el motivo porqué se limpia el campo D2_NFORI := " "
/*If FUNNAME() == "MATA466N"  .and. aCfgNf[1]==7
	// Actualiza los datos de ORIGEN D2_NFORI = ' '
	If !empty(SD2->D2_NFORI)
		SD2->D2_NFORI := " "
     Endif
EndIf*/
    

Return
