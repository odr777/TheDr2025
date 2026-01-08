#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  M486SJSON  ºAutor  ³Omar Delgadillo ºFecha ³  14/01/2022     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada para personalizar datos de la factura de   º±±
±±º          ³venta en la facturación en línea.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ M40                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M486SJSON()
    Local cJson     := PARAMIXB[1]  
    Local oJson     := JsonObject():new()
    Local ret       := oJson:fromJson(cJson)
    LOCAL nPos      := 0

    If ValType(ret) == "U"
        Conout("JsonObject creado con éxito.")
    Else
        Conout("Falla al crear el JsonObject. Error " + ret)
    Endif

   	If FwIsAdmin() .AND. UPPER(funname()) == 'MATA486' // si está en el grupo de administradores
		aviso("JSON STD",cJson,{'Ok'},,,,,.t.)
	endif 
 
    // *********************************
    //  Modificar Contenido de la Factura
    // *********************************

    /*IF (TRIM(SF2->F2_XTIPDOC)   <> '', oJson['documentTypeCode']    := TRIM(SF2->F2_XTIPDOC),)
    IF (TRIM(SF2->F2_UNITCLI)   <> '', oJson['documentNumber']      := TRIM(SF2->F2_UNITCLI),)
    IF (TRIM(SF2->F2_XCLDOCI)   <> '', oJson['documentComplement']  := TRIM(SF2->F2_XCLDOCI),)
    IF (TRIM(SF2->F2_UNOME)     <> '', oJson['name']                := TRIM(SF2->F2_UNOME),)
    IF (TRIM(SF2->F2_XEMAIL)    <> '', oJson['emailNotification']   := TRIM(SF2->F2_XEMAIL),)*/
    
    cObs := SF2->F2_XGLCONT
	cNota	 := " - - - "
	oJson['extraMesssage'] := EncodeUtf8(cObs +  CRLF + cNota) 

    //Obtener detalle de los items de la factura
    oDetalle := oJson['details']
    
    // recorrer oDetalle
    if oDetalle <> NIL
        FOR nPos := 1 TO LEN(oDetalle)
			oDetalle[nPos, 'quantity'] := ROUND(oDetalle[nPos, 'quantity'],2)
            oDetalle[nPos, 'unitPrice'] := ROUND(oDetalle[nPos, 'unitPrice'],2)            
			oDetalle[nPos, 'subtotal'] := ROUND(oDetalle[nPos, 'quantity']*oDetalle[nPos, 'unitPrice'],2)

            /*cNewDesc := TRIM(POSICIONE("SB1", 1, xFilial("SB1") + oDetalle[nPos, 'productCode'], "B1_ESPECIF"))
            cNewDesc += ' '
            cNewDesc += TRIM(POSICIONE("SB1", 1, xFilial("SB1") + oDetalle[nPos, 'productCode'], "B1_UESPEC2"))
            oDetalle[nPos, 'concept'] := cNewDesc*/
        NEXT 
    endif 

    cJson := oJson:toJson()

   	If FwIsAdmin() .AND. UPPER(funname()) == 'MATA486' // si está en el grupo de administradores
		aviso("JSON STD",cJson,{'Ok'},,,,,.t.)
	endif 
Return cJson
