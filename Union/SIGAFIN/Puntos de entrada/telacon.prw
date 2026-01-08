#Include "Protheus.ch"

User Function TelaCon()
	Local retorno:= ParamIxb[1]
	
	IF nPanel == 1
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Permite cobros a clientes com bloqueios	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oDlgRecibo:aControls[13]:bValid := {|| xFA087aVld(cCliente,cLoja) }	//oCliente
		oDlgRecibo:aControls[15]:bValid := {|| xFA087aVld(cCliente,cLoja) }	//oLoja
		
		
		aCobra := u_obteCobr(RetCodUsr()) // obtengo el cobrador
		/*
		xDlgRec := oDlgRecibo:aControls[15]
		xDlgPan	:= oPanelTop:aControls		
		aData := ClassDataArr(xDlgRec,.T.)//cabecera movimientos inter
		Aviso("TelaCon -oPanelTop:aControls[15]",u_zArrToTxt(aData, .T.),{"Ok"},,,,,.T.)
		*/
		
		if Type("aCobra[2]") <> "U"  .and. Type("lDesdFact") == "U" // .and. Funname() <> "FINA087A"// existe Cobrador
			public lDesdFact := .T. // variable existe
			cSerie := aCobra[3] // obtengo la serie
			cCobrador := aCobra[1] // obtengo el cobrador
			dbSelectArea("SX5") // NAHIM
			DbSetOrder(1)
			DbSeek( xFilial("SX5")+"RN"+cSerie) // pone el nro
			cRecibo := ALLTRIM(SX5->X5_DESCRI)
			aCols[1][AScan(aCposSEL,"EL_PREFIXO")] := "EF"// el ultimo
			aCols[1][AScan(aCposSEL,"EL_NUMERO")] := cRecibo // el ultimo
			//		endif
			//	if type("cNombreCli") == "U"// existe variable cNombreCli
			//		public cNombreCli := Space(40) // declarando variable publica

			aBancoXUs := u_obtBanc(RetCodUsr()) // obtengo informaciónes del banco
			if !empty(aBancoXUs)
				aCols[1][AScan(aCposSEL,"EL_BANCO")] := aBancoXUs[1] // 
				aCols[1][AScan(aCposSEL,"EL_AGENCIA")] := aBancoXUs[2] // 
				aCols[1][AScan(aCposSEL,"EL_CONTA")] := aBancoXUs[3] // 
				aCols[1][AScan(aCposSEL,"EL_MOEDA")] := cvaltochar(aBancoXUs[4]) // aaumentando moneda
			endif

		endif
		if type("_nValFac") <> "U" //.and. Type("lDesdFact") == "U" // existe variable cNombreCli //
			aCols[1][AScan(aCposSEL,"EL_VALOR")] := _nValFac // el ultimo
			aCols[1][AScan(aCposSEL,"EL_UOBSTAR")] := "Venta Rápida"// marcando que es venta rápida NTP 25/09/2019
			//		aCols[1][AScan(aCposSEL,"EL_MOEDA")] := _MoedaFac // el ultimo
			//		aCols[1][AScan(aCposSEL,"EL_TIPODOC")] := "EF" // el ultimo
		endif

	endif

Return retorno

//+---------------------------------------------------------------------+
//|Validação de clientes bloqueados	| EDUAR ANDIA |09/04/2020			|
//+---------------------------------------------------------------------+
Static Function xFA087aVld(cCliente,cLoja,cNumFatAut)
Local lRet 			:= .T.
Default cNumFatAut 	:= ""

If SA1->(DbSeek(xFilial("SA1")+cCliente))
	If !Empty(cLoja)
		If SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja))
			lRet := StaticCall(FINA087A, FA087aAtuCli, cNumFatAut)
		Else
			lRet := .F.
		Endif
	Endif
Else
 	lRet := .F.
Endif

oDlgRecibo:Refresh()
Return(lRet)
