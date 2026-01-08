#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  A467GRAV  ºAutor Omar Delgadillo ³  ºFecha ³  27/09/2022     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada se ejecuta al final de incluir factura     º±±
±±º          ³Imprime Factura                                             º±±
±±º          ³Llama a cobranza rápida                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function A467GRAV()
	Local 	aArea    	:= GetArea()
	//Private	_nValFac	
	//Private	_cSerieFac	
		
	/*
	MATA468N -> Generación de Notas
	MATA467N -> Facturaciones
	MATA410  -> Pedidos de Venta
	*/

	If Alltrim(FunName()) == "MATA467N"
		DbSelectArea("SF2")
		//_cDoc		:= SF2->F2_DOC
		//_cSerieFac	:= SF2->F2_SERIE
		//_cPedido	:= SD2->D2_PEDIDO
		//_nValFac	:= SF2->F2_VALBRUT

		//Executando chamada automatica da Cobranzas Diverzas
		If GetNewPar("MV_UEXECOB",.T.) //.AND.U_VerGrpUsr(GetNewPar("MV_UGRPCOB","000000|000000"))
			If SF2->F2_COND='002' // Contado
				If MSGYESNO("Desea realizar el COBRO de la Factura: "+ Left(SF2->F2_SERIE,3) + " / " + SF2->F2_DOC)
					U_Cobro()
				EndIf
			EndIF
		EndIf

		/* Propósito DESCONOCIDO - wico2k_202209158_1016
		If	RecLock("SF2",.F.)
			Replace F2_USRREG  With SUBSTR(CUSERNAME,1,15)         //usuario que reg la factura   mod YGC
			SF2->(MsUnlock())
		End
		*/
		/*cNomcli :=  GetAdvFVal("SA1", "A1_NOME",   	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
		cTipDoc :=	GetAdvFVal("SA1", "A1_TIPDOC", 	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0") 
		cNitCli :=  GetAdvFVal("SA1", "A1_CGC",    	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
		cClDocI := 	GetAdvFVal("SA1", "A1_CLDOCID",	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")  
		cEmail 	:=	GetAdvFVal("SA1", "A1_EMAIL", 	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")

		If GETNEWPAR('MV_UCAMDAT',.T.)
			aDatosCliente := U_SetDatosCli(cNomcli, cTipDoc, cNitCli, cClDocI, cEmail)
			cNomCli := StrToArray(aDatosCliente,'|')[1]
			cTipDoc := StrToArray(aDatosCliente,'|')[2]
			cNitCli := StrToArray(aDatosCliente,'|')[3]
			cClDocI := StrToArray(aDatosCliente,'|')[4]
			cEmail 	:= StrToArray(aDatosCliente,'|')[5]
		EndIf

		Reclock('SF2',.F.)

		SF2->F2_UNOMCLI := cNomCli
		SF2->F2_XTIPDOC := cTipDoc
		SF2->F2_UNITCLI := cNitCli
		SF2->F2_XCLDOCI := cClDocI
		SF2->F2_XEMAIL 	:= cEmail
		//SF2->F2_COND := SC5->C5_CONDPAG
		//cCond:=SF2->F2_COND
		SF2->(MsUnlock())*/

		aDados:=Array(6)
		aDados[1] := SF2->F2_SERIE
		aDados[2] := SF2->F2_ESPECIE
		aDados[3] := SF2->F2_DOC
		aDados[4] := SF2->F2_UNITCLI // cNitCli //If(Empty(SC5->C5_UNITCLI),Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC"),SC5->C5_UNITCLI)
		aDados[5] := DtoS(SF2->F2_EMISSAO)
		aDados[6] := xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
		aRetCF := RetCF(aDados)

		nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SF2")+SF2->F2_SERIE,1,"0")

		// ajustres cuando no es factura en línea 
		if (nEnLinea <> "1")
			Reclock('SF2',.F.)
				SF2->F2_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
				SF2->F2_CODCTR	:= aRetCF[2]	//Codigo de Controle
				SF2->F2_LIMEMIS	:= aRetCF[3]	//Data Limite de Emisao
			SF2->(MsUnlock())
		Endif

		SF3->(DbSetOrder(6))
		If SF3->(DbSeek(xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)) )
			Reclock('SF3',.F.)
			// ajustres cuando no es factura en línea 
			if (nEnLinea <> "1")
				SF3->F3_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
				SF3->F3_CODCTR	:= aRetCF[2]	//Codigo de Controle
			Endif
			SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
			SF3->(MsUnlock())
		EndIf

		_cFil := SF2->F2_FILIAL
		_cDoc := SF2->F2_DOC
		_cSerieFac := SF2->F2_SERIE
		
		nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SF2")+_cSerieFac,1,"0")
		if (nEnLinea <> "1")
			U_FACTMEDC(_cFil,_cDoc,_cDoc,_cSerieFac,1)
		else
			//cNomArq 	:= 'l01000000000000000031nf.pdf'		
			cNomArq	:= _cSerieFac + _cDoc + TRIM(SF2->F2_ESPECIE) + '.pdf'
			cDirUsr := GetTempPath()
			cDirSrv := GetSrvProfString('startpath','')+'\cfd\facturas\'
			__CopyFile(cDirSrv+cNomArq, cDirUsr+cNomArq)
			nRet := ShellExecute("open", cNomArq, "", cDirUsr, 1 )
			If nRet <= 32
				MsgStop("No fue posible abrir el archivo " +cNomArq+ "!", "Atención")
			EndIf
		endif
		
	EndIf

	/* Propósito DESCONOCIDO - wico2k_202209158_1016
	//Gravando correlativos para contabilidade - Ventas - 24-ABR-2011  - Se CTB ON-LINE
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	_cTipo	:= Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_GERALF")

	RECLOCK("SF2", .F.)
		SF2->F2_UNUMCOR := U_RetCorCtb('F',_cTipo)
		SF2->F2_UDTREAL := DATE()
	SF2->(MsUnlock())

	DbSelectArea("SC5")
	If RecLock("SC5",.F.)
		Replace SC5->C5_USUFACT With SUBSTR(CUSERNAME,1,15)  // usuario que reg la factura guardar en el pedido 17/04/09
		SC5->(MsUnlock())
	EndIf

	_cDoc 		:= SF2->F2_DOC
	_cSerieFac	:= SF2->F2_SERIE
	_cPedido 	:= SD2->D2_PEDIDO
	_nValFac 	:= SF2->F2_VALBRUT

	alert(SF2->F2_UNITCLI)
	alert(SF2->F2_UNOMCLI)
	RestArea(aArea)
	U_GFATI301(_cDoc,_cDoc,_cSerieFac,1)
	ALERT(_cDoc)

	If MSGYESNO("Desea imprimir la factura "+ Left(SF2->F2_SERIE,3) + " / " + SF2->F2_DOC)
		SFP->(DbSetOrder(1))
		SFP->(DbSeek(xFilial('SFP')+CFILANT+Left(SF2->F2_SERIE,3)))

		IF ALLTRIM(UPPER(Substr(SF2->F2_SERIE,1,1))) $ 'B'
			U_FACSINCRE(SF2->F2_DOC,Left(SF2->F2_SERIE,3),1)
		ELSE
			U_FacHPM(SF2->F2_DOC,Left(SF2->F2_SERIE,3))
		END

	End

	U_GFATI301(_cDoc,_cDoc,_cSerieFac,1)
	U_FactQR()
	*/

	RestArea(aArea)

Return Nil
