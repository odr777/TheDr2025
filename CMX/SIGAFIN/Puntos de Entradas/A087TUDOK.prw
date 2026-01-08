#include 'protheus.ch'
#include 'parmtype.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A087TUDOK  ºAutor ³TdeP Horeb SRL º Data ³  21/12/2019      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
A±ºDesc.     ³PUNTO DE ENTRADA que valida cada salto de pantalla en		  º±±
±±º           cobros diversos FINA087A      							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB -BELEN											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A087TUDOK()
	Local lRet := .T.
	Local nX,i
	//local cNomCliTit	:= cNome

	if GetRemoteType() < 0 // nahim Terrazas toma en cuenta sólo si no es un web services
		return .T.
	endif

	If nPanel == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida o tamanho do campo EL_RECIBO     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If !Empty(cRecibo)
			If Len(AllTrim(cRecibo))< TamSX3("EL_RECIBO")[1]
				Aviso("F087ACOB","El Tamaño del campo debe ser de " + AllTrim(Str(TamSX3("EL_RECIBO")[1]))+ " caracteres",{"OK"})
				lRet := .F.
				Return(lRet)
			Endif
		Endif
	Endif

	if nPanel == 1 // cuando es panel uno va a validar el pedido
		//
		nTotPag := (aLinMoed[2][2] * aLinMoed[2][3]) + (aLinMoed[1][2] * aLinMoed[1][3])
		IF nTotPag > 0 // si está compensado
			U_checkped()
		ELSE
			return .T.
		endif
		nPedVent := AScan(aCposSEL,"EL_UPV") // posición pedido de venta
		nUltimo := LEN(aCols) // el último del array de pagos
		while nUltimo >= 1// mientras sea mayor a 1
			if nUltimo == 1 // si es el
				//				cPedVNum := aCols[nUltimo][nPedVent] // obtengo el pedido de venta

				nTamPedSelec := Len(aPVSelec)// tamaño array de pedidos seleccionados
				cPedVNum := ""
				For nX := 1 to nTamPedSelec
					if nX == nTamPedSelec // si es el último
						cPedVNum += aPVSelec[nX]
					else // si es uno de los primeros
						cPedVNum += aPVSelec[nX] +"','"
					endif
				Next nX
				Return (U_getInPed(cPedVNum,cCliente,nTotPag))
				// aCols[nUltimo][200]
				exit
			endif
			nUltimo--
		enddo
	elseif nPanel == 4 //.AND. nTotalBx > 0 // valida solo cuando el panel es el último y cuando estoy pagando cuentas
		// validando si la cuenta es efectivo
		
		// Edson 07/09 incluye el nombre de la persona que recibe
//		alert("borra cNombreCli")
		if type("cNombreCli") == "U" // NAHIM 20190813
			for i:= 1 to len(aCols)
	//			aCols[i][AScan(aCposSEL,"EL_UNOMD")] := cNombreCli // el ultimo
				aCols[i][AScan(aCposSEL,"EL_UNOMD")] := nil // el ultimo
			next i
		endif
		// Edson termina
		cNombreCli := NIL
		// agora sim limpa o objeto ou , limpa a instancia usando freeobj()
		FreeObj(cNombreCli)	

		nPTipoPago := AScan(aCposSEL,"EL_TIPODOC") // posición del cambio
		nUltimo := LEN(aCols) // el último del array de pagos
		nCambioCobro := -1 // el cobro que recibe el cambio
		while nUltimo >= 1// mientras sea mayor a 1
			if aCols[nUltimo][nPTipoPago] == "EF" // sólo si es efectivo
				nCambioCobro := nUltimo
				Exit
			endif
			nUltimo--
		enddo
		if nUltimo == 0 .or. nTotal <= 0 // no encontró Efectivo o no hay cambio
			return .T.
		endif

		if nTotal > 0 // si estoy pagando de más
			nPCambio := AScan(aCposSEL,"EL_UCAMBIO") // posición del cambio
			nPValoraPagar := AScan(aCposSEL,"EL_VALOR") // posición del valor a pagar
			nPMoneda := AScan(aCposSEL,"EL_MOEDA") // obtiene la moneda el último pago
			// Nahim Terrazas busca el pedido de venta
			//			nPedVent := AScan(aCposSEL,"EL_UPV") // posición del cambio
			//	cPedVNum := aCols[nCambioCobro][nPedVent]

			if empty(aPVSelec) // si no hay pedido
				if nTotalBx == 0 // no está bajando nigún título
					return .t.
				endif
				lGerNCC := MsgYesNo("Desea dar cambio?","saldo")
				if !lGerNCC // si es que dice que no, termina
					return .t.
				endif
				//	nUltimo := LEN(aCols) // el último del array de pagos
//				ALERT("TOTAL + "+ nTotal )
				nCambio := nTotal // obtengo el 'cambio'
				if val(aCols[nCambioCobro][nPMoneda]) == 2  // si la moneda es igual dólares
					aCols[nCambioCobro][nPCambio] := Round(nCambio / aTaxa[2],2) // el ultimo
					aCols[nCambioCobro][nPValoraPagar] := aCols[nCambioCobro][nPValoraPagar] - Round(nCambio / aTaxa[2],2) //aCols[nUltimo][nPValoraPagar] - nCambio // el valor a pagar.
				else // "1 " Bs
					aCols[nCambioCobro][nPCambio] := nCambio // el ultimo
					aCols[nCambioCobro][nPValoraPagar] := aCols[nCambioCobro][nPValoraPagar] - nCambio //aCols[nUltimo][nPValoraPagar] - nCambio // el valor a pagar.
				endif
				cInformaciones := "Cambio en Bolivianos : " + cValtochar(nCambio)+ Chr(13) + Chr(10)
				cInformaciones += 	 "Cambio en Dólares : " + cValtochar(Round(nCambio / aTaxa[2],2))
				// "string linha1" + Chr(13) + Chr(10) + "string linha2"
				AVISO("Cambio del Cliente", cInformaciones, { "cerrar"}, 2)
			else // si es un pedido de venta
				//				dbSelectArea("SC5")
				//				dbSetOrder(1)
				//				MsSeek(FWxFilial('SC5') + cPedVNum ) // me posiciono en el pedido
				nTamPedSelec := Len(aPVSelec)// tamaño array de pedidos seleccionados
				cPedVNum := ""
				For nX := 1 to nTamPedSelec
					if nX == nTamPedSelec // si es el último
						cPedVNum += aPVSelec[nX]
					else // si es uno de los primeros
						cPedVNum += aPVSelec[nX] +"','"
					endif
				Next nX

				cNextAlias := GetNextAlias()

				BeginSQL Alias cNextAlias
					SELECT sum(C6_VALOR) TOTVAL
					FROM  %Table:SC6% SC6
					WHERE C6_NUM IN (%exp:cPedVNum%)  AND C6_CLI = %exp:CCLIENTE% AND SC6.D_E_L_E_T_!='*'
					group by C6_CLI
				EndSQL

				DbSelectArea(cNextAlias) // seleccionar area Area
				// nahim si es que es me
				if nTotal < (cNextAlias)->TOTVAL // si el monto del pedido es mayor a lo que pago debería retornar
					return .t.
				endif

				if nTotal != (cNextAlias)->TOTVAL // si iguales pregunta por el cambio
					lGerNCC := MsgYesNo("Desea dar cambio?","saldo")
					if !lGerNCC // si es que dice que no, termina
						return .t.
					endif
				endif
				//(cNextAlias)->TOTVAL // valor total del pedido
				nCambio :=  nTotal - (cNextAlias)->TOTVAL // nTotal // obtengo el 'cambio'
				ntotal := (cNextAlias)->TOTVAL //
				if val(aCols[nCambioCobro][nPMoneda]) == 2  // si la moneda es igual dólares
					aCols[nCambioCobro][nPCambio] := Round(nCambio / aTaxa[2],2) // el ultimo
					aCols[nCambioCobro][nPValoraPagar] := aCols[nCambioCobro][nPValoraPagar] - Round(nCambio / aTaxa[2],2) //aCols[nUltimo][nPValoraPagar] - nCambio // el valor a pagar.
				else // "1 " Bs
					aCols[nCambioCobro][nPCambio] := nCambio // el ultimo
					aCols[nCambioCobro][nPValoraPagar] := aCols[nCambioCobro][nPValoraPagar] - nCambio //aCols[nUltimo][nPValoraPagar] - nCambio // el valor a pagar.
				endif
				cInformaciones := "Cambio en Bolivianos : " + cValtochar(nCambio)+ Chr(13) + Chr(10)
				cInformaciones += "Cambio en Dólares : " 	+ cValtochar(Round(nCambio / aTaxa[2],2))
				if aLinMoed[2][2] > 0 .and. aLinMoed[1][3] == 0 // sólo pago en Dólares
					aLinMoed[2][3] := aCols[nCambioCobro][nPValoraPagar]	//(cNextAlias)->TOTVAL - aLinMoed[2][2] * aLinMoed[2][3] // resta los dólares también.
					aLinMoed[2][4] := aCols[nCambioCobro][nPValoraPagar]	//(cNextAlias)->TOTVAL - aLinMoed[2][2] * aLinMoed[2][3] // resta los dólares también.
				elseif aLinMoed[2][3] > 0 // si tiene pagos en dólares y en Bs
					aLinMoed[1][3] := (cNextAlias)->TOTVAL - aLinMoed[2][2] * aLinMoed[2][3] // resta los dólares también.
					aLinMoed[1][4] := (cNextAlias)->TOTVAL - aLinMoed[2][2] * aLinMoed[2][3] // resta los dólares también.
				else  // sino tiene pagos en dólares
					aLinMoed[1][3] := (cNextAlias)->TOTVAL
					aLinMoed[1][4] := (cNextAlias)->TOTVAL
				endif
				//	StaticCall( Fina087a, Refdata, 4 )
				// "string linha1" + Chr(13) + Chr(10) + "string linha2"
				AVISO("Cambio del Cliente", cInformaciones, { "cerrar"}, 2)
			endif
		endif

	endif


return .T.