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
ฑฑบUso       ณ ECCI                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function M486SJSON()
	Local cJson     := PARAMIXB[1]
	Local oJson     := JsonObject():new()
	Local aJDetalle	:= {}//array nuevo detalle
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

	IF oJson['name'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNOMCLI))
		oJson['name'] := TRIM(JsonCarEsp(SF2->F2_UNOMCLI))  //Raz๓n Social
	ENDIF

	IF oJson['documentNumber'] <> NIL .AND. !EMPTY(TRIM(SF2->F2_UNITCLI))
		oJson['documentNumber'] := TRIM(SF2->F2_UNITCLI)	//NIT
	ENDIF

	
	cUsuario := UPPER(UsrRetName(RETCODUSR()))
	cNota	 := "" //"NO SE ACEPTAN CAMBIOS NI DEVOLUCIONES."
	oJson['extraMesssage'] := cUsuario + "|" + cNota  //+ CRLF + cNota 

	//Obtener detalle de los items de la factura
	oDetalle := oJson['details']

	// SF2->F2_NATUREZ
	if oDetalle <> NIL
		if TRIM(SF2->F2_NATUREZ) == 'FOBR' 	// obra		
			nTotal := 0				
			FOR nPos := 1 TO LEN(oDetalle)
				nTotal += oDetalle[nPos, 'subtotal']
			NEXT

			// Buscar Descripci๓n de Obra
			// D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, R_E_C_N_O_, D_E_L_E_T_
			cIndice := xFilial("SF2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) + DecodeUTF8(oDetalle[1, 'productCode'])
			cNewDesc := GetAdvFVal("SD2","D2_UDESCLA", cIndice, 3,"")			
			oDetalle[1, 'concept'] := EncodeUtf8(ALLTRIM(cNewDesc))			

			// Crear nuevo detalle
			AADD(aJDetalle,JsonObject():new())
			aJDetalle[1]['sequence'] := 1
			aJDetalle[1]['quantity'] := 1
			aJDetalle[1]['productCode'] := oDetalle[1, 'productCode']
			aJDetalle[1]['unitPrice'] := nTotal
			aJDetalle[1]['subtotal'] := nTotal
			aJDetalle[1]['concept'] := EncodeUtf8(ALLTRIM(cNewDesc))	

			// ASIGNAMOS NUEVO DETALLE
			oJson['details']:= aJDetalle	

		ELSEIF TRIM(SF2->F2_NATUREZ) == 'FEQU' 	// EQUPO
			// Buscar Descripci๓n del equipo
			// D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, R_E_C_N_O_, D_E_L_E_T_				
			cIndice := xFilial("SF2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) 
			dbSelectArea("SD2")                   // * Itens de Venda da N.F.
			dbSetOrder(3)
			dbSeek(cIndice)
			cNewDesc := ''
			nSequence := 1
			While !eof() .AND. SF2->F2_DOC = SD2->D2_DOC .AND. SF2->F2_SERIE = SD2->D2_SERIE
				cNewDesc	:= TRIM(POSICIONE("SB1", 1, xFilial("SB1") + SD2->D2_COD, "B1_DESC"))					
				IF !EMPTY(SD2->D2_CLVL) 
					cDescCV  := GetAdvFVal("CTH", "CTH_DESC01", xFilial("CTH") + SD2->D2_CLVL, 1,"")								
					cNewDesc += IF(!EMPTY(cDescCV), " - " + trim(substr(cDescCV,1,6)), "")
				ENDIF
				cNewDesc += IF(!EMPTY(SD2->D2_UPLACA), " - " + TRIM(SD2->D2_UPLACA), "")

				// Crear nuevo detalle
				AADD(aJDetalle,JsonObject():new())
				aJDetalle[nSequence]['sequence'] := nSequence
				aJDetalle[nSequence]['quantity'] := SD2->D2_QUANT
				aJDetalle[nSequence]['productCode'] := EncodeUtf8(ALLTRIM(SD2->D2_COD))
				aJDetalle[nSequence]['unitPrice'] := SD2->D2_PRCVEN
				aJDetalle[nSequence]['subtotal'] :=  SD2->D2_TOTAL
				aJDetalle[nSequence]['concept'] := EncodeUtf8(ALLTRIM(cNewDesc))

				nSequence++
				DbSkip() 
			ENDDO

			// ASIGNAMOS NUEVO DETALLE
			oJson['details']:= aJDetalle	
			
		ELSEIF TRIM(SF2->F2_NATUREZ) == 'FMAT' 	// MATERIALES
			// Buscar Descripci๓n del equipo
			// D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM, R_E_C_N_O_, D_E_L_E_T_				
			cIndice := xFilial("SF2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA) 
			dbSelectArea("SD2")                   // * Itens de Venda da N.F.
			dbSetOrder(3)
			dbSeek(cIndice)
			cNewDesc := ''
			nSequence := 1
			While !eof() .AND. SF2->F2_DOC = SD2->D2_DOC .AND. SF2->F2_SERIE = SD2->D2_SERIE
				// Crear nuevo detalle
				AADD(aJDetalle,JsonObject():new())
				aJDetalle[nSequence]['sequence'] := nSequence
				aJDetalle[nSequence]['quantity'] := SD2->D2_QUANT
				aJDetalle[nSequence]['productCode'] := EncodeUtf8(ALLTRIM(SD2->D2_COD))
				aJDetalle[nSequence]['unitPrice'] := SD2->D2_PRCVEN
				aJDetalle[nSequence]['subtotal'] :=  SD2->D2_TOTAL
				aJDetalle[nSequence]['concept'] := EncodeUtf8(ALLTRIM(SD2->D2_UDESCLA))

				nSequence++
				DbSkip() 
			ENDDO

			// ASIGNAMOS NUEVO DETALLE
			oJson['details']:= aJDetalle	
		ELSE
			IF TRIM(SF2->F2_NATUREZ) <> 'FEST' 	// ESTANDAR
				oJson['details'] := NIL
				ALERT("La modalidad " + TRIM(SF2->F2_NATUREZ) + " no es vแlida para facturaci๓n.")
			ENDIF
		ENDIF
	else
		msgalert("Revisar datos de cabecera de factura y/o cliente.")
	Endif

	cJson := oJson:toJson()

	If FwIsAdmin() // si estแ en el grupo de administradores
		aviso("JSON OUT",cJson,{'Ok'},,,,,.t.)
	endif

Return cJson
