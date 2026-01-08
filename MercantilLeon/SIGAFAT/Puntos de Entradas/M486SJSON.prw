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
±±ºUso       ³ Mercantil Leon                                             º±±
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

	//msgalert(cJson)
	If FwIsAdmin() // si está en el grupo de administradores
		aviso("JSON STD",cJson,{'Ok'},,,,,.t.)
	endif

	// *********************************
	//  Modificar Contenido de la Factura
	// *********************************

	IF( !EMPTY(TRIM(SF2->F2_UNITCLI)) )
		oJson['documentNumber']     := TRIM(SF2->F2_UNITCLI)	//NIT
		//oJson['name']               := TRIM(CFDCarEsp(SF2->F2_UNOMCLI))  //Razón Social	
		//oJson['name']               := TRIM((SF2->F2_UNOMCLI))  //Razón Social
		oJson['name']               := EncodeUtf8(ALLTRIM(SF2->F2_UNOMCLI))  //Razón Social
		//oJson['']                   := SF2->F2_XTELCLI  //Teléfono de recepción
	ENDIF

	IF( !Empty(TRIM(SF2->F2_XTIPDOC)) )
		oJson['documentTypeCode']   := TRIM(SF2->F2_XTIPDOC)	//Tipo de Documento(Cliente)
	ENDIF

	If( !Empty(TRIM(SF2->F2_XEMAIL)) )
		oJson['emailNotification']  := EncodeUtf8(ALLTRIM(SF2->F2_XEMAIL)) //TRIM(JsonCarEsp(SF2->F2_XEMAIL)) //TRIM(SF2->F2_XEMAIL)   //Correo de recepción
	EndIf

	oJson['extraCustomerAddress'] :=  ' '//

	// oJson['extraMesssage'] :=  EncodeUtf8(ALLTRIM(SF2->F2_OBSERB))

	//Obtener detalle de los items de la factura
	oDetalle := oJson['details']

	// recorrer oDetalle
	if oDetalle <> NIL
		FOR nPos := 1 TO LEN(oDetalle)
			cCod 	:= DecodeUTF8(oDetalle[nPos, 'productCode'])
			//cCod 	:= oDetalle[nPos, 'productCode']
			cNewDesc:= TRIM(POSICIONE("SB1", 1, xFilial("SB1") + cCod, "B1_ESPECIF"))
			cDesc2 	:= TRIM(POSICIONE("SB1", 1, xFilial("SB1") + cCod, "B1_UESPEC2"))
			cCod 	:= EncodeUtf8(ALLTRIM(oDetalle[nPos, 'productCode'])) // DecodeUTF8(oDetalle[nPos, 'productCode'])
			//cCod 	:= EncodeUtf8(ALLTRIM(cCod))
			
			if cDesc2 <> ""
				cNewDesc += CRLF
				cNewDesc += cDesc2 
			endif

			oDetalle[nPos, 'concept'] := EncodeUtf8(TRIM(cNewDesc)) //JsonCarEsp(TRIM(cNewDesc))
			if oDetalle[nPos, 'discount'] <> NIL
				oDetalle[nPos, 'unitPrice'] := ROUND(ROUND(oDetalle[nPos, 'unitPrice'],2) - ROUND(oDetalle[nPos, 'discount'],2),2)
				oDetalle[nPos, 'discountAmount'] := 0
				oDetalle[nPos, 'discount'] := 0
			endif 
		NEXT
	else
		// msgalert(cJson)
	Endif

	cJson := oJson:toJson()

	If FwIsAdmin() // si está en el grupo de administradores
		aviso("JSON OUT",cJson,{'Ok'},,,,,.t.)
	endif
	// msgalert(cJson)
Return cJson
