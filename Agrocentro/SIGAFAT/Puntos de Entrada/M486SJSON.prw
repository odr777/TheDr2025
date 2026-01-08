#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  M486SJSON  ºAutor  ³Omar Delgadillo ºFecha ³  20/06/2022     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada para personalizar datos de la factura de   º±±
±±º          ³venta en la facturación en línea.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Agrocentro  		                                          º±±
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
		oJson['name']               := EncodeUtf8(ALLTRIM(SF2->F2_UNOMCLI))  //Razón Social
	ENDIF

	// Aumentar comillas al NIT
	oJson['documentNumber']     := EncodeUtf8('"' + oJson['documentNumber'] + '"')

	IF SF2->F2_REFMOED == 2	
		oJson['currencyIso'] 	:= SF2->F2_REFMOED
		oJson['exchangeRate'] 	:= SF2->F2_REFTAXA
	ELSE
		nMoedTit := Posicione("SE1",1,xFilial("SE1")+SF2->(F2_SERIE+F2_DOC)+"  "+SF2->(F2_ESPECIE+F2_CLIENTE+F2_LOJA),"E1_MOEDA")
		IF nMoedTit == 2
			nTC := POSICIONE("SM2",1,SF2->F2_EMISSAO,"M2_MOEDA2")
			oJson['currencyIso'] := nMoedTit	
			oJson['exchangeRate'] :=  nTC
		ENDIF
	ENDIF

	oJson['extraMesssage'] :=  EncodeUtf8(ALLTRIM(SF2->F2_UOBSERV))	

	//Obtener detalle de los items de la factura
	oDetalle := oJson['details']

	// recorrer oDetalle
	if oDetalle <> NIL
		FOR nPos := 1 TO LEN(oDetalle)
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

Return cJson
