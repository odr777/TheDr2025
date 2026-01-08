#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   ºAutor  ³Jorge Saavedra   ºFecha ³  24/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada para grabar datos en el encabezado de la  º±±
±±º          ³ factura de venta y titulo desde el pedido de ventas.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2460I

	Local aArea    := GetArea()
	Private _nValFac
	Private _cSerieFac
	DbSelectArea("SF2")
	/*if	RecLock("SF2",.F.)
		Replace F2_USRREG  With SUBSTR(CUSERNAME,1,15)         //usuario que reg la factura   mod YGC
		SF2->(MsUnlock())      
	END
	*/

	If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N"    // Generacion de Factura de Ventas
//    If Alltrim(FunName()) = "MATA410" .OR. Alltrim(FunName()) = "MATA467N"
		cNitCli :=  If(Empty(SC5->C5_UNITCLI),Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC"),SC5->C5_UNITCLI)
		cNomcli := SC5->C5_UNOMCLI
		cTipDoc	:= SC5->C5_XTIPDOC
		cCorreo	:= SC5->C5_XEMAIL
		cTelefono:= SC5->C5_XTELCLI

		iF GETNEWPAR('MV_UCAMDAT',.T.)
			aDatosCliente := U_SetDatosCli(cNitCli, cNomcli, cTipDoc, cCorreo, cTelefono)
			cNitCli := aDatosCliente[1]
			cNomCli := aDatosCliente[2]
			cTipDoc	:= aDatosCliente[3]
			cCorreo	:= aDatosCliente[4]
			cTelefono:= aDatosCliente[5]
		END
		Reclock('SF2',.F.)
		SF2->F2_UNITCLI := cNitCli
		SF2->F2_UNOMCLI := cNomCli
		SF2->F2_XTIPDOC	:= cTipDoc
		SF2->F2_XEMAIL	:= cCorreo
		SF2->F2_XTELCLI	:= cTelefono
		SF2->(MsUnlock())
		aDados:=Array(6)
		aDados[1] := SF2->F2_SERIE
		aDados[2] := SF2->F2_ESPECIE
		aDados[3] := SF2->F2_DOC
		aDados[4] := cNitCli //If(Empty(SC5->C5_UNITCLI),Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC"),SC5->C5_UNITCLI)
		aDados[5] := DtoS(SF2->F2_EMISSAO)
		aDados[6] := xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
		aRetCF := RetCF(aDados)
		SF2->F2_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
		SF2->F2_CODCTR	:= aRetCF[2]	//Codigo de Controle
		SF2->F2_LIMEMIS	:= aRetCF[3]	//Data Limite de Emisao
		SF3->(DbSetOrder(6))
		If SF3->(DbSeek(xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)) )


			Reclock('SF3',.F.)
			//  ALERT(TRANSFORM(SF3->F3_VALCONT,"@E 999,999.999"))
			SF3->F3_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
			SF3->F3_CODCTR	:= aRetCF[2]	//Codigo de Controle
			SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
			SF3->(MsUnlock())
		End

		//  End



		//Gravando correlativos para contabilidade - Ventas - 24-ABR-2011  - Se CTB ON-LINE
	/*
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	_cTipo:=Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_GERALF")                                                                                                                                                                                                                 

	RECLOCK("SF2", .F.)   
	SF2->F2_UNUMCOR := U_RetCorCtb('F',_cTipo)
	//   SF2->F2_UDTREAL := DATE()    
	*/

		//SF2->(MsUnlock())
	/*DbSelectArea("SC5")
	if	RecLock("SC5",.F.)
	Replace SC5->C5_USUFACT With SUBSTR(CUSERNAME,1,15)  // usuario que reg la factura guardar en el pedido 17/04/09
	SC5->(MsUnlock())
	EndIf      
	*/                       


		_cDoc:=SF2->F2_DOC
		_cSerieFac:=SF2->F2_SERIE
		_cPedido:=SD2->D2_PEDIDO
		_nValFac:=SF2->F2_VALBRUT
	/*If MSGYESNO("Desea imprimir la factura "+ Left(SF2->F2_SERIE,3) + " / " + SF2->F2_DOC)
	SFP->(DbSetOrder(1))
	SFP->(DbSeek(xFilial('SFP')+CFILANT+Left(SF2->F2_SERIE,3)))


	IF ALLTRIM(UPPER(Substr(SF2->F2_SERIE,1,1))) $ 'B'                      
		U_FACSINCRE(SF2->F2_DOC,Left(SF2->F2_SERIE,3),1)
	ELSE
		U_FacHPM(SF2->F2_DOC,Left(SF2->F2_SERIE,3)) 
	END

	End
	*/
	EndIf

	RestArea (aArea)

Return
