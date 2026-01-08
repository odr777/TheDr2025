#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M468NGRV  ºAutor  ³TdeP Horeb SRL  ºFecha ³  19/05/2015     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºModificaciones														  º±±
±±ºOmar Delgadillo  ³Adecuar a Facturación en Línea    ºFecha ³26/03/2024 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada para grabar datos en el encabezado de la  º±±
±±º          ³ factura de venta y titulo desde el pedido de ventas.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ M40			                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2460I 	//alert("SF2460I: " + Alltrim(FunName())) MATA461

	// ALERT ("SF2460I: "+Alltrim(FunName()))

	Local aArea    := GetArea()
	Local lEnLinea := .F.
	Private _nValFac
	Private _cSerieFac
	DbSelectArea("SF2")

	If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N" .OR.  Alltrim(FunName()) == "MATA461" 
		_cDoc:=SF2->F2_DOC
		_cSerieFac:=SF2->F2_SERIE
		_cPedido:=SD2->D2_PEDIDO
		_nValFac:=SF2->F2_VALBRUT

		lEnLinea := (GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SF2")+SF2->F2_SERIE,1,"0")=="1") .AND. (GETNEWPAR('MV_CFDUSO','0')<>"0")

		// MATA468N - Generación de Notas	| MATA467N - Facturación	| MATA461 - Preparar Doc. de Salida 
		If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N" .OR.  Alltrim(FunName()) == "MATA461"   // Generacion de Factura de Ventas
			iF Alltrim(FunName()) == "MATA468N" .OR. Alltrim(FunName()) == "MATA461"
				cTipDoc := If(Empty(SC5->C5_XTIPDOC),GetAdvFVal("SA1","A1_TIPDOC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XTIPDOC)
				cNitCli := If(Empty(SC5->C5_UNITCLI),GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)
				cClDocI := If(Empty(SC5->C5_XCLDOCI),GetAdvFVal("SA1","A1_CLDOCID",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XCLDOCI)
				cNomcli := If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)
				cEmail  := If(Empty(SC5->C5_XEMAIL), GetAdvFVal("SA1","A1_EMAIL",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XEMAIL)
			ELSE
				cTipDoc :=  GetAdvFVal("SA1","A1_TIPDOC",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cNitCli :=  GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cClDocI :=  GetAdvFVal("SA1","A1_CLDOCID",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cNomcli :=  GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cEmail  :=  GetAdvFVal("SA1","A1_EMAIL",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
			END
			iF GETNEWPAR('MV_UCAMDAT',.T.)
				aDatosCliente := U_SetDatosCli(cTipDoc, cNitCli, cClDocI, cNomcli, cEmail)
				cTipDoc := StrToArray(aDatosCliente,'|')[1]
				cNitCli := StrToArray(aDatosCliente,'|')[2]
				cClDocI := StrToArray(aDatosCliente,'|')[3]
				cNomCli := StrToArray(aDatosCliente,'|')[4]
				cEmail  := StrToArray(aDatosCliente,'|')[5]
			END

			Reclock('SF2',.F.)
			SF2->F2_XTIPDOC	:= cTipDoc
			SF2->F2_UNITCLI := cNitCli
			SF2->F2_XCLDOCI	:= cClDocI
			SF2->F2_UNOME 	:= cNomCli
			SF2->F2_XEMAIL	:= cEmail
			SF2->F2_XGLCONT := SC5->C5_UOBSERV
			SF2->(MsUnlock())

			if (lEnLinea)
				aDados:=Array(6)
				aDados[1] := SF2->F2_SERIE
				aDados[2] := SF2->F2_ESPECIE
				aDados[3] := SF2->F2_DOC
				aDados[4] := cNitCli //If(Empty(SC5->C5_UNITCLI),Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC"),SC5->C5_UNITCLI)
				aDados[5] := DtoS(SF2->F2_EMISSAO)
				aDados[6] := xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
				aRetCF := RetCF(aDados)
				Reclock('SF2',.F.)
				SF2->F2_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
				SF2->F2_CODCTR	:= aRetCF[2]	//Codigo de Controle
				SF2->F2_LIMEMIS	:= aRetCF[3]	//Data Limite de Emisao
				SF2->(MsUnlock())
				SF3->(DbSetOrder(6))
				If SF3->(DbSeek(xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)) )
					Reclock('SF3',.F.)
					SF3->F3_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
					SF3->F3_CODCTR	:= aRetCF[2]	//Codigo de Controle
					SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
					SF3->(MsUnlock())
				End
			endif

			_cDoc := SF2->F2_DOC
			_cSerieFac := SF2->F2_SERIE
			_cPedido := SD2->D2_PEDIDO
			_nValFac := SF2->F2_VALBRUT
		EndIf

	END
	RestArea(aArea)
return
