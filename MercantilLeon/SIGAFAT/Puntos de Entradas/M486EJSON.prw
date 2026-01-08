#INCLUDE "TOTVS.CH"
 
User Function M486EJSON()
    Local cJson     := PARAMIXB[1]
    Local oJson     := JsonObject():new()
    Local nPos      := 0
    Local ret       := oJson:fromJson(cJson)
 
    If ValType(ret) == "U"
        Conout("JsonObject creado con éxito.")
    Else
        Conout("Falla al crear el JsonObject. Error: " + ret)
    Endif

	If FwIsAdmin() // si está en el grupo de administradores
		aviso("JSON STD",cJson,{'Ok'},,,,,.t.)
	endif

    // *********************************
	//  Modificar Contenido de la NOTA DE CRÉDITO
	// *********************************

	// "id": "NCC000000000000000001"
	/*cExtInv := oJson['id'] 
	cSerNcc := SubStr(cExtInv,1,3)
	cDocNcc := SubStr(cExtInv,4,Len(cExtInv)-3)*/	

	cCodCli	:= oJson['customerCode']

	// "externalIdInvoice":"T01000000000000000003"	
	// numeroFactura	TamSX3("F2_DOC")[1]			
	nLarDoc := TamSX3("F2_DOC")[1]
	cExtInv := oJson['externalIdInvoice'] 
	cSerFac := SubStr(cExtInv,1,Len(cExtInv)-nLarDoc)
	cDocFac := Replicate("0", nLarDoc - Len(cValToChar(oJson['invoiceNumber']))) + cValToChar(oJson['invoiceNumber'])
	
/*
	//Razón Social
	IF oJson['name'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNOMCLI))
		oJson['name'] := GETADVFVAL("SF2","F2_UNOMCLI",XFILIAL("SF1")+cDocFac+cSerFac+SF1->(F1_FORNECE+F1_LOJA),1,"erro")
	ENDIF

	
	IF oJson['documentNumber'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNITCLI))
		oJson['documentNumber'] := TRIM(GETADVFVAL("SF2","F2_UNITCLI",XFILIAL("SF1")+cDocFac+cSerFac+SF1->(F1_FORNECE+F1_LOJA),1,"erro"))
	ENDIF
	*/

	oJson['documentNumber'] := LTRIM(cValToChar(oJson['documentNumber']))

	// hardcode de la últimoa nota
	/*
	oJson['documentNumber'] := "1015213026"
	oJson ['invoiceEmissionDate'] := "2024-07-26T12:22:00.249-04:00" //SF2->F2_FECTIMB+"T"+SF2->F2_HORATRM // "2021-12-15T15:41:35.938-04:00", */
	cDataAut := DTOS(POSICIONE("SF2", 1, xFilial("SF2") + cDocFac + cSerFac, "F2_FECTIMB"))
	cTimeAut := cValToChar(POSICIONE("SF2", 1, xFilial("SF2") + cDocFac + cSerFac, "F2_HORATRM"))

	/*cJson += Iif(Empty(cTimeAut) .or. Len(cTimeAut) < 18 ,"00:00:01.000-00:00", cTimeAut)
	cTimeAut := cTimeAut + ".000-04:00"
	cED := Substr(cDataAut,1,4) + "-" + Substr(cDataAut,5,2) + "-" + Substr(cDataAut,7,2)
	cED += "T"
	cED += cTimeAut
	oJson ['invoiceEmissionDate'] := cED */

	if (Empty(cTimeAut) .or. Len(cTimeAut) < 18 )
		// hpardcode de la hora temporal 
		if cValToChar(oJson['invoiceNumber']) = '24412' 
			oJson ['invoiceEmissionDate'] := "2025-04-29T09:22:04.508-04:00"
		endif

		if cValToChar(oJson['invoiceNumber']) = '24421' 
			oJson ['invoiceEmissionDate'] := "2025-04-29T09:31:26.909-04:00"
		endif
		ALERT("El valor del campo F2_HORATRM no es correcto, debe tener el formato 09:31:26.909-04:00")
	endif

	// ALERT(cED)

	//Obtener detalle de los items de la factura
	oDetalle := oJson['details']
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

			/*If oDetalle[nPos, 'detailTransaction'] == 'RETURNED' //NCC 
				//oDetalle[nPos, 'unitPrice'] := GETADVFVAL("SD1","D1_VUNIT",XFILIAL("SD1")+cDocNcc+cSerNcc+SF1->(F1_FORNECE+F1_LOJA)+cCod,1,"0")
				//oDetalle[nPos, 'subtotal'] := GETADVFVAL("SD1","D1_TOTAL",XFILIAL("SD1")+cDocNcc+cSerNcc+SF1->(F1_FORNECE+F1_LOJA)+cCod,1,"0")
			Endif

			If oDetalle[nPos, 'detailTransaction'] == 'ORIGINAL' //FAC
				//oDetalle[nPos, 'unitPrice'] := GETADVFVAL("SD2","D2_PRCVEN",XFILIAL("SD2")+cDocFac+cSerFac+SF1->(F1_FORNECE+F1_LOJA)+cCod,3,"0")
				//oDetalle[nPos, 'subtotal'] :=  GETADVFVAL("SD2","D2_TOTAL",XFILIAL("SD2")+cDocFac+cSerFac+SF1->(F1_FORNECE+F1_LOJA)+cCod,3,"0")
			Endif	*/
			oDetalle[nPos, 'unitPrice'] := oDetalle[nPos, 'subtotal'] / oDetalle[nPos, 'quantity']
			oDetalle[nPos, 'discountAmount'] := 0
		NEXT
	else
		msgalert("Revise los datos de cabecera de la factura.") // Método de Pago. 
	Endif

	cJson := oJson:toJson()

	If FwIsAdmin() // si está en el grupo de administradores
		aviso("JSON OUT",cJson,{'Ok'},,,,,.t.)
	endif

Return cJson
