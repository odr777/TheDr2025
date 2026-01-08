#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M468NGRV  ºAutor  ³TdeP ºFecha ³  12/09/2017     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada que se ejecuta al finalizar la Venta  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function M468NGRV()
	Local aArea    := GetArea()
	public _nValFac
	public _MoedaFac
	public nTotBsFac := 0
	Private _cSerieFac	

	DbSelectArea("SF2")
	//	ALERT(FunName())
	If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N" .or. Alltrim(FunName()) == "MATA461"
		_cDoc:=SF2->F2_DOC
		_cSerieFac:=SF2->F2_SERIE
		_cPedido:=SD2->D2_PEDIDO
		_nValFac := GETADVFVAL("SE1", "E1_VALOR", XFILIAL("SE1")+_cSerieFac+_cDoc,1,0)
		//_nValFac:=SF2->F2_VALFAT  //SF2->F2_VALBRUT
		_MoedaFac:=SF2->F2_MOEDA
		_SD2codigo := SD2->D2_COD

		If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N" .OR. Alltrim(FunName()) == "MATA461"   // Generacion de Factura de Ventas
			cUsgrv:= ""
			iF Alltrim(FunName()) == "MATA468N" .OR. Alltrim(FunName()) == "MATA461"
				cNitCli := If(Empty(SC5->C5_UNITCLI), GetAdvFVal("SA1","A1_UNITFAC", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)
				cNomcli := If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_UNOMFAC", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)
				cTipDoc := If(Empty(SC5->C5_XTIPDOC), GetAdvFVal("SA1","A1_TIPDOC",  xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XTIPDOC)
				cComDoc := If(Empty(SC5->C5_XCLDOCI), GetAdvFVal("SA1","A1_CLDOCID", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XCLDOCI)
				cEmail 	:= If(Empty(SC5->C5_XEMAIL),  GetAdvFVal("SA1","A1_EMAIL", 	 xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XEMAIL)
				cUsgrv 	:= SC5->C5_USRREG
			ELSE
				cNitCli := GetAdvFVal("SA1","A1_UNITFAC", xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cNomcli := GetAdvFVal("SA1","A1_UNOMFAC", xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cTipDoc := GetAdvFVal("SA1","A1_TIPDOC",  xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cComDoc := GetAdvFVal("SA1","A1_CLDOCID", xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cEmail 	:= GetAdvFVal("SA1","A1_EMAIL",   xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
			END
			iF GETNEWPAR('MV_UCAMDAT',.T.) .AND. Alltrim(FunName()) != "MATA461"
				aDatosCliente := U_SetDatosCli(cNitCli,cNomcli)
				cNitCli := StrToArray(aDatosCliente,'|')[1]
				cNomCli := StrToArray(aDatosCliente,'|')[2]
			END
			Reclock('SF2',.F.)
			SF2->F2_UNITCLI := cNitCli
			SF2->F2_UNOMCLI := cNomCli
			SF2->F2_XTIPDOC := cTipDoc
			SF2->F2_XCLDOCI := cComDoc
			SF2->F2_XEMAIL  := cEmail
			SF2->F2_USRREG := If(Empty(cUsgrv), SUBSTR(UPPER(CUSERNAME),1,15) ,cUsgrv)
			SF2->(MsUnlock())

			// si factura es en dolar "SFV", NO facturación en línea
			if SF2->F2_MOEDA == 2
				nTotBsFac := ROUND(xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO), 2)

				/*Posicione("SD2", 3, SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA), "D2_ITEM")
				while SD2->(!Eof()) .AND. SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
					nQuant		:= ROUND(SD2->D2_QUANT, 2)
					nPreUni		:= ROUND(xMoeda(SD2->D2_PRCVEN, SF2->F2_MOEDA, 1, SF2->F2_EMISSAO), 2)
					nDesc		:= ROUND(xMoeda(SD2->D2_DESCON, SF2->F2_MOEDA, 1, SF2->F2_EMISSAO), 2)
					nTotBsFac 	+= ROUND((nQuant * nPreUni), 2)
					//nTotBsFac 	+= ROUND((nQuant * nPreUni - nDesc), 2)
					SD2->(DbSkip())
				endDO*/
			ELSE
				nTotBsFac := SF2->F2_VALBRUT
			ENDIF		
			
			aDados:=Array(6)
			aDados[1] := SF2->F2_SERIE
			aDados[2] := SF2->F2_ESPECIE
			aDados[3] := SF2->F2_DOC
			aDados[4] := cNitCli //If(Empty(SC5->C5_UNITCLI),Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC"),SC5->C5_UNITCLI)
			aDados[5] := DtoS(SF2->F2_EMISSAO)
			aDados[6] := nTotBsFac
			aRetCF := RetCF(aDados)

			Reclock('SF2',.F.)
			SF2->F2_UVLTOBS := nTotBsFac
			// SF2->F2_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
			SF2->F2_CODCTR	:= aRetCF[2]	//Codigo de Controle
			SF2->F2_LIMEMIS	:= aRetCF[3]	//Data Limite de Emisao
			SF2->(MsUnlock()) 

			SF3->(DbSetOrder(6))
			If SF3->(DbSeek(xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)) )
				// ODR 31/12/2019
				// Se adiciona el While, para recorrer las facturas que tengan más de 1 TES
				while SF3->(!Eof()) .AND. SF3->(F3_FILIAL+F3_NFISCAL+F3_SERIE)==xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)
					Reclock('SF3',.F.)
					// SF3->F3_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
					// SF3->F3_NUMAUT	:= SF2->F2_NUMAUT
					SF3->F3_CODCTR	:= aRetCF[2]	//Codigo de Controle

					/*IF SF2->F2_MOEDA == 2
						SF3->F3_VALCONT := nTotBsFac
						SF3->F3_VALMERC := nTotBsFac
						SF3->F3_BASIMP1 := nTotBsFac
						SF3->F3_BASIMP2 := nTotBsFac
					ENDIF*/
					
					nValIVA := getIVAprc(SF3->F3_TES)//iva
					nValIT := getalITR(SF3->F3_TES)//it

					if nValIVA > 0 .and. nValIT > 0 .AND. !SF3->F3_TES == ALLTRIM(SuperGetMv("MV_BONUSTS"))
						nAlic1 = round(SF3->F3_BASIMP1 * (nValIVA/100),2) ///IVA FACTURA
						nAlic2 = round(SF3->F3_BASIMP1 * (nValIT/100),2) // IT FACTURA

						SF3->F3_VALIMP1	:= nAlic1	//Numero de Autorizacao
						SF3->F3_VALIMP2	:= nAlic2	//Codigo de Controle
					endif

					// ODR 31/12/2019
					// Condición para colocar el CERO el valor de un producto bonificado
					IF SF3->F3_TES == ALLTRIM(SuperGetMv("MV_BONUSTS"))
						SF3->F3_VALCONT := 0
					END
					SF3->(MsUnlock())
					SF3->(DbSkip())
				endDO
			End

			_cDoc := SF2->F2_DOC
			_cSerieFac := SF2->F2_SERIE
			_cPedido := SD2->D2_PEDIDO
			_nValFac := GETADVFVAL("SE1", "E1_VALOR", XFILIAL("SE1")+_cSerieFac+_cDoc,1,0)
			//_nValFac := SF2->F2_VALFAT //SF2->F2_VALBRUT
			_MoedaFac:=SF2->F2_MOEDA

		EndIf
		nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SFP")+SF2->F2_SERIE,1,"0")
		if (nEnLinea <> "1")
			imprFat(_cDoc,_cSerieFac)
		else
			//cNomArq 	:= 'l01000000000000000031nf.pdf'		
			cNomArq	:= SF2->F2_SERIE + SF2->F2_DOC + TRIM(SF2->F2_ESPECIE) + '.pdf'
			cDirUsr := GetTempPath()
			cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
			__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
			nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
			If nRet <= 32
				MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atención")
			EndIf

			U_CPICK(_cDoc,_cSerieFac,"ORIGINAL")
			U_CPICK(_cDoc,_cSerieFac,"COPIA")
		endif
	END

	// Nahim adicionando para imprimir las facturas de WMS
	If Alltrim(FunName()) == "MATA460B"
		if !Empty(aRecnoF2)
			//			For nX := 1 to len(aRecnoF2)
			DbSelectArea("SF2")
			dbGoTo(aRecnoF2[1])
			nDocn1 :=	SF2->F2_DOC // nro de factura del primer item
			dbGoTo(aRecnoF2[len(aRecnoF2)])
			nDocFinal :=	SF2->F2_DOC // nro de factura del primer item

			U_OrdenFact(nDocn1,nDocFinal,SF2->F2_SERIE,1) // Nahim imprimir Orden de entrega
			U_FACTLOCAL(nDocn1,nDocFinal,SF2->F2_SERIE,1)
			//			next
		endif
	endif
	// quitando la pregunta y sólamente cobrar si es al contado
	//	IF MSGYESNO("Desea realizar el COBRO de la Factura: "+ Left(SF2->F2_SERIE,3) + " / " + SF2->F2_DOC)

	if type("cCondiPago") <> "U"  // venta directa
		IF cCondiPago == "001"// caso que sea al contado
			// CASO QUE SI DEBERIA EJECUTAR LA COBRANZA (MOVIENDO A )
			PUBLIC renSE1 := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) // CREO EL RECNO
			// Fina087A(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))
		eND
	endif
	RestArea(aArea)
return

static FUNCTION imprFat(_cDoc,_cSerieFac)

	local cTemp			:= getNextAlias()
	Local cQuery	    := ""
	Local nlote := '0' // Nahim inicializando para no dar error 2020
	Local nvalidez

	local valor := SF2->F2_BASIMP1
	local nMoneda := SF2->F2_MOEDA

	If nMoneda == 1

		valortotal := ROUND(valor,2)

		if valortotal >= 50000

			MSGINFO("Esta a punto de emitir una factura igual o mayor a Bs. 50.000 !!!!!! Por favor, exigir el pago mediante : Cheque, Deposito bancario, transferencia, tarjeta de credito." , "AVISO:"  )

		endif

	elseIF nMoneda == 2

		valorImporteBS := ROUND(xMoeda(valor,2,1,SF2->F2_EMISSAO,3,0,SF2->F2_REFTAXA),2)

		if valorImporteBS >= 50000
			MSGINFO("Esta a punto de emitir una factura igual o mayor a Bs. 50.000 !!!!!! Por favor, exigir el pago mediante : Cheque, Deposito bancario, transferencia, tarjeta de credito." , "AVISO:"  )

		endif

	endif

	cQuery+= "SELECT FP_LOTE , FP_DTAVAL "
	cQuery+= "FROM " + RetSqlName("SF2") + " F2 "
	cQuery+= "JOIN " + RetSqlName("SFP") + " FP "
	cQuery+= "ON F2.F2_SERIE = FP.FP_SERIE "
	cQuery+= "AND F2.F2_FILIAL = FP.FP_FILIAL "
	cQuery+= "AND F2.F2_DOC = '"+ _cDoc +"' "
	cQuery+= "AND F2.F2_SERIE = '"+ _cSerieFac +"' "

	cQuery:= ChangeQuery(cQuery)

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cTemp, .F., .T.)
	dbSelectArea(cTemp)
	dbGoTop()

	While (cTemp)->(!EOF())

		nlote := (cTemp)->FP_LOTE
		nvalidez := (cTemp)->FP_DTAVAL

		(cTemp)->(dbSkip())
	enddo

	if( val(nlote) == 1)

		MSGINFO( "No es permitido imprimir Factura manual" , "AVISO:"  )

	else

		U_FACTLOCAL(_cDoc,_cDoc,_cSerieFac,1,"ORIGINAL")
		U_FACTLOCAL(_cDoc,_cDoc,_cSerieFac,1,"COPIA")
		U_CPICK(_cDoc,_cSerieFac,"ORIGINAL")
		U_CPICK(_cDoc,_cSerieFac,"COPIA")

	endif

return

static FUNCTION getCodigo()

	local cTemp			:= getNextAlias()
	Local cQuery	    := ""
	Local nD2_COD
	local resp := .F.

	cQuery := " SELECT D2_COD "
	cQuery += " FROM " + RetSqlName("SF2")
	cQuery += " LEFT JOIN " + RetSqlName("SD2") + " SD2 "
	cQuery += " ON (D2_FILIAL = F2_FILIAL "
	cQuery += " AND D2_DOC = F2_DOC "
	cQuery += " AND D2_SERIE = F2_SERIE "
	cQuery += " AND D2_LOJA = F2_LOJA "
	cQuery += " AND SF2010.D_E_L_E_T_ = ' ' "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ') "
	cQuery += " JOIN "+ RetSqlName("SB1")
	cQuery += " ON D2_FILIAL  = '"+xFilial("SC6")+"' "
	cQuery += " AND  D2_PEDIDO = '"+SC5->C5_NUM+"' "
	cQuery += " AND B1_COD = D2_COD "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN "+ RetSqlName("SC6") +" SC6 "
	cQuery += " ON (C6_FILIAL = D2_FILIAL "
	cQuery += " AND D2_PEDIDO = C6_NUM "
	cQuery += " AND D2_ITEMPV = C6_ITEM) "
	cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY D2_COD"

	cQuery:= ChangeQuery(cQuery)

	//	Aviso("",cQuery,{'ok'},,,,,.t.)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cTemp, .F., .T.)
	dbSelectArea(cTemp)
	dbGoTop()

	While (cTemp)->(!EOF())

		SB1->(dbSeek(xFilial("SB1")+(cTemp)->D2_COD))

		nD2_COD := (cTemp)->D2_COD

		//		alert(nD2_COD)
		//		alert(SB1->B1_UTIPOPR)

		if(SB1->B1_UTIPOPR = '003')

			resp := .T.
			return resp

		endif

		(cTemp)->(dbSkip())
	enddo

return resp

///trae iva e it
static function getalITR(cTes)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	// Local aValAlic := {}
	// Local cIvaCod := GetNewPar("MV_IVAALIC","IVA")//IVA CODIGO
	Local cITcod := GetNewPar("MV_ITRALIC","ITR")//IT CODIGO
	Local nValITR := 0
	/*
	SELECT FC_IMPOSTO,FC_TES,FB_ALIQ FROM SF4010 SF4
	LEFT JOIN SFC010 SFC
	ON FC_TES = F4_CODIGO AND FC_IMPOSTO IN('IVA','ITR') AND SFC.D_E_L_E_T_ = ''
	LEFT JOIN SFB010 SFB
	ON FB_CODIGO = FC_IMPOSTO AND SFB.D_E_L_E_T_ = ''
	WHERE  F4_CODIGO = '510' AND SF4.D_E_L_E_T_ = ''
	ORDER BY FC_IMPOSTO*/
	If Select("QRY_FB") > 0
		dbCloseArea()
	Endif

	cQuery := " SELECT FC_IMPOSTO,FC_TES,FB_ALIQ "
	cQuery += " FROM "
	cQuery += "   "+RetSQLName("SF4")+" SF4 "
	cQuery += " JOIN "
	cQuery += "   "+RetSQLName("SFC")+" SFC "
	cQuery += " ON FC_TES = F4_CODIGO AND FC_IMPOSTO IN('"+cITcod+"') AND SFC.D_E_L_E_T_ = '' "
	cQuery += " JOIN "
	cQuery += "   "+RetSQLName("SFB")+" SFB "
	cQuery += " ON FB_CODIGO = FC_IMPOSTO AND SFB.D_E_L_E_T_ = '' "
	cQuery += " WHERE  F4_CODIGO = '" + cTes + "' AND SF4.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY FC_IMPOSTO "

	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery New Alias "QRY_FB"

	if !QRY_FB->(EoF())

		nValITR = QRY_FB->FB_ALIQ

	endif
	///posicion 1 es el it posicion dos es el iva

	QRY_FB->(DbCloseArea())
	RestArea(aArea)
return nValITR

static function getIVAprc(cTes)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	// Local aValAlic := {}
	Local cIvaCod := GetNewPar("MV_IVAALIC","IVA")//IVA CODIGO
	// Local cITcod := GetNewPar("MV_ITRALIC","ITR")//IT CODIGO
	Local nValIV := 0

	If Select("QRY_SEL") > 0
		dbCloseArea()
	Endif
	/*
	SELECT FC_IMPOSTO,FC_TES,FB_ALIQ FROM SF4010 SF4
	LEFT JOIN SFC010 SFC
	ON FC_TES = F4_CODIGO AND FC_IMPOSTO IN('IVA','ITR') AND SFC.D_E_L_E_T_ = ''
	LEFT JOIN SFB010 SFB
	ON FB_CODIGO = FC_IMPOSTO AND SFB.D_E_L_E_T_ = ''
	WHERE  F4_CODIGO = '510' AND SF4.D_E_L_E_T_ = ''
	ORDER BY FC_IMPOSTO*/

	cQuery := " SELECT FC_IMPOSTO,FC_TES,FB_ALIQ "
	cQuery += " FROM "
	cQuery += "   "+RetSQLName("SF4")+" SF4 "
	cQuery += " JOIN "
	cQuery += "   "+RetSQLName("SFC")+" SFC "
	cQuery += " ON FC_TES = F4_CODIGO AND FC_IMPOSTO IN('"+cIvaCod+"') AND SFC.D_E_L_E_T_ = '' "
	cQuery += " JOIN "
	cQuery += "   "+RetSQLName("SFB")+" SFB "
	cQuery += " ON FB_CODIGO = FC_IMPOSTO AND SFB.D_E_L_E_T_ = '' "
	cQuery += " WHERE  F4_CODIGO = '" + cTes + "' AND SF4.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY FC_IMPOSTO "

	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery New Alias "QRY_SEL"

	if !QRY_SEL->(EoF())
		nValIV = QRY_SEL->FB_ALIQ
	endif
	///posicion 1 es el it posicion dos es el iva

	QRY_SEL->(DbCloseArea())
	RestArea(aArea)
return nValIV
