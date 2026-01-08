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
	cExtInv := oJson['id'] 
	cSerNcc := SubStr(cExtInv,1,3)
	cDocNcc := SubStr(cExtInv,4,Len(cExtInv)-3)

	// "externalIdInvoice":"T01000000000000000003"
	cExtInv := oJson['externalIdInvoice'] 
	cSerFac := SubStr(cExtInv,1,3)
	cDocFac := SubStr(cExtInv,4,Len(cExtInv)-3)

	//Razón Social
	IF oJson['name'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNOMCLI))
		oJson['name'] := GETADVFVAL("SF2","F2_UNOMCLI",XFILIAL("SF1")+cDocFac+cSerFac+SF1->(F1_FORNECE+F1_LOJA),1,"erro")
	ENDIF

	IF oJson['documentNumber'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNITCLI))
		oJson['documentNumber'] := TRIM(GETADVFVAL("SF2","F2_UNITCLI",XFILIAL("SF1")+cDocFac+cSerFac+SF1->(F1_FORNECE+F1_LOJA),1,"erro"))
	ENDIF

	//oJson ['invoiceEmissionDate'] := "2022-07-28T11:56:31.49-04:00"

	//Obtener detalle de los items de la factura
	oDetalle := oJson['details']
	if oDetalle <> NIL
		FOR nPos := 1 TO LEN(oDetalle)            
			cProdCod := oDetalle[nPos, 'productCode']

			If oDetalle[nPos, 'detailTransaction'] == 'RETURNED' //NCC 
				oDetalle[nPos, 'unitPrice'] := GETADVFVAL("SD1","D1_VUNIT",XFILIAL("SD1")+cDocNcc+cSerNcc+SF1->(F1_FORNECE+F1_LOJA)+cProdCod,1,"0")
				oDetalle[nPos, 'subtotal'] := GETADVFVAL("SD1","D1_TOTAL",XFILIAL("SD1")+cDocNcc+cSerNcc+SF1->(F1_FORNECE+F1_LOJA)+cProdCod,1,"0")
			Endif

			If oDetalle[nPos, 'detailTransaction'] == 'ORIGINAL' //FAC
				oDetalle[nPos, 'unitPrice'] := GETADVFVAL("SD2","D2_PRCVEN",XFILIAL("SD2")+cDocFac+cSerFac+SF1->(F1_FORNECE+F1_LOJA)+cProdCod,3,"0")
				oDetalle[nPos, 'subtotal'] :=  GETADVFVAL("SD2","D2_TOTAL",XFILIAL("SD2")+cDocFac+cSerFac+SF1->(F1_FORNECE+F1_LOJA)+cProdCod,3,"0")
			Endif			
		NEXT
	else
		msgalert("Revise los datos de cabecera de la factura.") // Método de Pago. 
	Endif

	cJson := oJson:toJson()

	If FwIsAdmin() // si está en el grupo de administradores
		aviso("JSON OUT",cJson,{'Ok'},,,,,.t.)
	endif

Return cJson
