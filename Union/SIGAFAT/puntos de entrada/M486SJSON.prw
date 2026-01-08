#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  M486SJSON  บAutor  ณOmar Delgadillo บFecha ณ  14/01/2022     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPunto de Entrada para personalizar datos de la factura de   บฑฑ
ฑฑบ          ณventa en la facturaci๓n en lํnea.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ UNION                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M486SJSON()
	Local cJson     := PARAMIXB[1]
	Local oJson     := JsonObject():new()
	Local ret       := oJson:fromJson(cJson)
	LOCAL nPos      := 0

	If ValType(ret) == "U"
		Conout("JsonObject creado con ้xito.")
	Else
		Conout("Falla al crear el JsonObject. Error " + ret)
	Endif

	If FwIsAdmin() // si estแ en el grupo de administradores
		aviso("JSON STD",cJson,{'Ok'},,,,,.t.)
	endif

	// *********************************
	//  Modificar Contenido de la Factura
	// *********************************

	if oJson['customerCode'] <> NIL
		oJson['customerCode']	+= "-" + SF2->F2_LOJA	  //C๓digo de Cliente + Tienda
	endif

	//Raz๓n Social
	IF oJson['name'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNOMCLI))		//JsonCarEsp()	CFDCarEsp()	DecodeUTF8()
		oJson['name'] := EncodeUtf8(ALLTRIM(SF2->F2_UNOMCLI)) // JsonCarEsp(ALLTRIM(SF2->F2_UNOMCLI))
	ENDIF

	IF oJson['documentTypeCode'] <> NIL .AND. !Empty(TRIM(SF2->F2_XTIPDOC))
		oJson['documentTypeCode'] := TRIM(SF2->F2_XTIPDOC)	//Tipo de Documento(Cliente)
	ENDIF

	IF oJson['documentNumber'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNITCLI))
		oJson['documentNumber'] := TRIM(SF2->F2_UNITCLI)	//NIT
	ENDIF

	IF !EMPTY(TRIM(SF2->F2_XCLDOCI))						
		oJson['documentComplement'] := TRIM(SF2->F2_XCLDOCI)	//Complemento CI
	ENDIF

	If !Empty(TRIM(SF2->F2_XEMAIL))
		oJson['emailNotification'] := TRIM(SF2->F2_XEMAIL)   //Correo de recepci๓n
	EndIf

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

	cCondPag := AllTrim(GETADVFVAL("SE4","E4_DESCRI", xfilial("SE4")+SF2->F2_COND,1,"N/A"))
	cUsuario := UPPER(UsrRetName(RETCODUSR()))
	cVendedo := AllTrim(GETADVFVAL("SA3","A3_NREDUZ", xfilial("SA3")+SF2->F2_VEND1,1,"N/A"))
	cNota	 := "NO SE ACEPTAN CAMBIOS NI DEVOLUCIONES."
	oJson['extraMesssage'] := EncodeUtf8("Cond.Pago:" + cCondPag +  CRLF + cUsuario + " | " + cVendedo + " | " + SF2->F2_SERIE +  CRLF + cNota) // CFDCarEsp("Cond.Pago:" + cCondPag +  CRLF + cUsuario + " | " + cVendedo + " | " + SF2->F2_SERIE +  CRLF + cNota)

	//Obtener detalle de los items de la factura
	oDetalle := oJson['details']

	// recorrer oDetalle	
	if oDetalle <> NIL
		nDesTot := 0 
		FOR nPos := 1 TO LEN(oDetalle)
			//cCod 	:= DecodeUTF8(oDetalle[nPos, 'productCode'])			
			//oDetalle[nPos, 'concept'] := CFDCarEsp(TRIM(cNewDesc))
			
			if oDetalle[nPos, 'discount'] <> NIL
				oDetalle[nPos, 'subtotal'] 			+= oDetalle[nPos, 'discountAmount']	// decuento en 0
				nDesTot 							+= oDetalle[nPos, 'discountAmount'] // acumulo el descuento
				oDetalle[nPos, 'discountAmount'] 	:= 0								// monto descontado
				oDetalle[nPos, 'discount'] 			:= 0								// decuento por unidad
			endif 			
		NEXT
		oJson['additionalDiscount'] := nDesTot
	else
		msgalert("Revise los datos de cabecera de la factura.") // M้todo de Pago. 
	Endif

	cJson := oJson:toJson()

	If FwIsAdmin() // si estแ en el grupo de administradores
		aviso("JSON OUT",cJson,{'Ok'},,,,,.t.)
	endif

Return cJson
