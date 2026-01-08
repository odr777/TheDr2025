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

	if oJson['customerCode'] <> NIL
		oJson['customerCode']	+= "-" + SF2->F2_LOJA	  //Código de Cliente + Tienda
	endif

	// "externalIdInvoice":"T01000000000000000003"
	cExtInv := oJson['externalIdInvoice'] 
	cSerOri := SubStr(cExtInv,1,3)
	cDocOri := SubStr(cExtInv,4,Len(cExtInv)-3)

	//Razón Social
	IF oJson['name'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNOMCLI))
		oJson['name'] := GETADVFVAL("SF2","F2_UNOMCLI",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"erro")
	ENDIF

	IF oJson['documentTypeCode'] <> NIL .AND. !Empty(TRIM(SF2->F2_XTIPDOC))
		oJson['documentTypeCode'] := GETADVFVAL("SF2","F2_XTIPDOC",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"4")
	ENDIF

	IF oJson['documentNumber'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNITCLI))
		oJson['documentNumber'] := TRIM(GETADVFVAL("SF2","F2_UNITCLI",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"erro"))
	ENDIF

	IF oJson['documentComplement'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_XCLDOCI))						
		oJson['documentComplement'] := GETADVFVAL("SF2","F2_XCLDOCI",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"erro")
	ENDIF

	If oJson['emailNotification'] <> NIL .AND. ( !Empty(TRIM(SF2->F2_XEMAIL)) )
		oJson['emailNotification'] := TRIM(GETADVFVAL("SF2","F2_XEMAIL",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"erro"))
	EndIf

	//cCondPag := AllTrim(GETADVFVAL("SE4","E4_DESCRI", xfilial("SE4")+SF2->F2_COND,1,"N/A"))
	cUsuario := UPPER(UsrRetName(RETCODUSR()))
	//cVendedo := AllTrim(GETADVFVAL("SA3","A3_NREDUZ", xfilial("SA3")+SF2->F2_VEND1,1,"N/A"))
	cNota	 := "NO SE ACEPTAN CAMBIOS NI DEVOLUCIONES."
	oJson['extraMesssage'] := EncodeUtf8("Cond.Pago:" +  CRLF + cUsuario + " | " + SF2->F2_SERIE +  CRLF + cNota) 

	//Obtener detalle de los items de la factura
	oDetalle := oJson['details']

	// recorrer oDetalle	
	if oDetalle <> NIL
		nDesTot := 0 
		FOR nPos := 1 TO LEN(oDetalle)            
			if oDetalle[nPos, 'discountAmount'] <> NIL
				// oDetalle[nPos, 'unitPrice'] := oDetalle[nPos, 'unitPrice'] - oDetalle[nPos, 'discount']				
				oDetalle[nPos, 'subtotal'] 			+= oDetalle[nPos, 'discountAmount']	// decuento en 0
                If oDetalle[nPos, 'detailTransaction'] == 'ORIGINAL'
				    nDesTot 							+= oDetalle[nPos, 'discountAmount'] // acumulo el descuento
                Endif
				oDetalle[nPos, 'discountAmount'] 	:= 0								// monto descontado
				oDetalle[nPos, 'discount'] 			:= 0								// decuento por unidad
			endif 			
		NEXT
		oJson['discountAmount'] := nDesTot //'additionalDiscount'] := nDesTot
	else
		msgalert("Revise los datos de cabecera de la factura.") // Método de Pago. 
	Endif

	cJson := oJson:toJson()

	If FwIsAdmin() // si está en el grupo de administradores
		aviso("JSON OUT",cJson,{'Ok'},,,,,.t.)
	endif

Return cJson
