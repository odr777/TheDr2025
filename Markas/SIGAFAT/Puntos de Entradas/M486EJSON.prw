#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  M486SJSON  บAutor  ณOmar Delgadillo บFecha ณ  26/09/2022     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPunto de Entrada para personalizar datos de la NOTA DE      บฑฑ
ฑฑบ          ณCREDITO en la facturaci๓n en lํnea.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Markas                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M486EJSON()
    Local cJson     := PARAMIXB[1]
    Local oJson     := JsonObject():new()
    // Local nPos      := 0
    Local ret       := oJson:fromJson(cJson)
 
    If ValType(ret) == "U"
        Conout("JsonObject creado con ้xito.")
    Else
        Conout("Falla al crear el JsonObject. Error: " + ret)
    Endif

	If FwIsAdmin() // si estแ en el grupo de administradores
		aviso("JSON STD",cJson,{'Ok'},,,,,.t.)
	endif

    // *********************************
	//  Modificar Contenido de la NOTA DE CRษDITO
	// *********************************

	// "externalIdInvoice":"T01000000000000000003"
	cExtInv := oJson['externalIdInvoice'] 
	cSerOri := SubStr(cExtInv,1,3)
	cDocOri := SubStr(cExtInv,4,Len(cExtInv)-3)

	// Tipo de Documento
	IF oJson['documentTypeCode'] <> NIL .AND. !Empty(TRIM(SF2->F2_XTIPDOC))
		oJson['documentTypeCode'] := GETADVFVAL("SF2","F2_XTIPDOC",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"4")
	ENDIF

	// Nit 
	IF oJson['documentNumber'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNITCLI))
		oJson['documentNumber'] := TRIM(GETADVFVAL("SF2","F2_UNITCLI",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"erro"))
	ENDIF

	//Raz๓n Social
	IF oJson['name'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNOMCLI))
		oJson['name'] := GETADVFVAL("SF2","F2_UNOMCLI",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"erro")
	ENDIF

	// Complemento
	IF oJson['documentComplement'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_XCLDOCI))						
		oJson['documentComplement'] := GETADVFVAL("SF2","F2_XCLDOCI",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"erro")
	ENDIF

	// Email
	If oJson['emailNotification'] <> NIL .AND. ( !Empty(TRIM(SF2->F2_XEMAIL)) )
		oJson['emailNotification'] := TRIM(GETADVFVAL("SF2","F2_XEMAIL",XFILIAL("SF1")+cDocOri+cSerOri+SF1->(F1_FORNECE+F1_LOJA),1,"erro"))
	EndIf

	//Obtener detalle de los items de la factura
	oDetalle := oJson['details']

	// recorrer oDetalle	
	/*if oDetalle <> NIL
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
		msgalert("Revise los datos de cabecera de la factura.") // M้todo de Pago. 
	Endif*/

	cJson := oJson:toJson()

	If FwIsAdmin() // si estแ en el grupo de administradores
		aviso("JSON OUT",cJson,{'Ok'},,,,,.t.)
	endif

Return cJson
