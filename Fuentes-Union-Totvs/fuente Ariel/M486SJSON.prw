#INCLUDE "TOTVS.CH"
#INCLUDE "json.ch"
#include 'protheus.ch'
#include 'parmtype.ch'


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
		oJson['customerCode']	+= "|" + SF2->F2_LOJA	  //C๓digo de Cliente + Tienda
	endif

	IF oJson['name'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNOMCLI))
		oJson['name'] := TRIM(JsonCarEsp(SF2->F2_UNOMCLI))  //Raz๓n Social
	ENDIF

	IF oJson['documentTypeCode'] <> NIL .AND. !Empty(TRIM(SF2->F2_XTIPDOC))
		oJson['documentTypeCode'] := TRIM(SF2->F2_XTIPDOC)	//Tipo de Documento(Cliente)
	ENDIF

	IF oJson['documentNumber'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNITCLI))
		oJson['documentNumber'] := TRIM(SF2->F2_UNITCLI)	//NIT
	ENDIF

	IF oJson['documentComplement'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_XCLDOCI))						
		oJson['documentComplement'] := TRIM(SF2->F2_XCLDOCI)	//Complemento CI
	ENDIF

	If oJson['emailNotification'] <> NIL .AND. ( !Empty(TRIM(SF2->F2_XEMAIL)) )
		oJson['emailNotification'] := TRIM(SF2->F2_XEMAIL)   //Correo de recepci๓n
	EndIf

	//Obtener detalle de los items de la factura
	oDetalle := oJson['details']

	// recorrer oDetalle	
	if oDetalle <> NIL
		nDesTot := 0 
		FOR nPos := 1 TO LEN(oDetalle)
			//cCod 	:= DecodeUTF8(oDetalle[nPos, 'productCode'])			
			//oDetalle[nPos, 'concept'] := CFDCarEsp(TRIM(cNewDesc))
			
			if oDetalle[nPos, 'discount'] <> NIL
				// oDetalle[nPos, 'unitPrice'] := oDetalle[nPos, 'unitPrice'] - oDetalle[nPos, 'discount']				
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
	// msgalert(cJson)*/

Return cJson
