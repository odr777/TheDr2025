#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   ºAutor  ³Omar Delgadillo ºFecha ³ 26/09/22        º±±
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

	Local aArea		:= GetArea()
	Local cGarante	:= ""
	Private _nValFac
	Private _cSerieFac
	DbSelectArea("SF2")

	/*
	MATA468N -> Generación de Notas
	MATA467N -> Facturaciones
	MATA410  -> Pedidos de Venta
	*/	

	If Alltrim(FunName()) == "MATA468N" .OR. Alltrim(FunName()) == "MATA467N" .OR. Alltrim(FunName()) == "MATA410"    // Generacion de Factura de Ventas

		If Alltrim(FunName()) == "MATA468N" .OR. Alltrim(FunName()) == "MATA410"
			cNomcli := GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,1)
			cTipDoc	:= GetAdvFVal("SA1","A1_TIPDOC",xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,1)
			cNitCli := GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,1)
			cClDocI	:= GetAdvFVal("SA1","A1_CLDOCID",xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,1)
			cCorreo	:= GetAdvFVal("SA1","A1_EMAIL",xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,1)

			cNomcli := IF(!EMPTY(SC5->C5_UNOMCLI),SC5->C5_UNOMCLI,cNomcli)
			cTipDoc	:= IF(!EMPTY(SC5->C5_XTIPDOC),SC5->C5_XTIPDOC,cTipDoc)
			cNitCli := IF(!EMPTY(SC5->C5_UNITCLI),SC5->C5_UNITCLI,cNitCli)
			cClDocI	:= IF(!EMPTY(SC5->C5_XCLDOCI),SC5->C5_XCLDOCI,cClDocI)
			cCorreo	:= IF(!EMPTY(SC5->C5_XEMAIL),SC5->C5_XEMAIL,cCorreo)
			cGarante:= SC5->C5_XGARANT
		EndIf

		IF Alltrim(FunName()) == "MATA467N"
			cNomcli := GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+M->F2_CLIENTE+M->F2_LOJA,1)
			cTipDoc	:= GetAdvFVal("SA1","A1_TIPDOC",xFilial("SA1")+M->F2_CLIENTE+M->F2_LOJA,1)
			cNitCli := GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+M->F2_CLIENTE+M->F2_LOJA,1)
			cClDocI	:= GetAdvFVal("SA1","A1_CLDOCID",xFilial("SA1")+M->F2_CLIENTE+M->F2_LOJA,1)
			cCorreo	:= GetAdvFVal("SA1","A1_EMAIL",xFilial("SA1")+M->F2_CLIENTE+M->F2_LOJA,1)

			cNomcli := IF(!EMPTY(M->F2_UNOMCLI),M->F2_UNOMCLI,cNomcli)
			cTipDoc	:= IF(!EMPTY(M->F2_XTIPDOC),M->F2_XTIPDOC,cTipDoc)
			cNitCli := IF(!EMPTY(M->F2_UNITCLI),M->F2_UNITCLI,cNitCli)
			cClDocI	:= IF(!EMPTY(M->F2_XCLDOCI),M->F2_XCLDOCI,cClDocI)
			cCorreo	:= IF(!EMPTY(M->F2_XEMAIL),M->F2_XEMAIL,cCorreo)
		ENDIF

		iF GETNEWPAR('MV_UCAMDAT',.T.)
			aDatosCliente := U_SetDatosCli(cNomcli, cTipDoc, cNitCli, cClDocI, cCorreo)
			cNomCli := aDatosCliente[1]
			cTipDoc	:= aDatosCliente[2]
			cNitCli := aDatosCliente[3]
			cClDocI	:= aDatosCliente[4]
			cCorreo	:= aDatosCliente[5]
		END

		Reclock('SF2',.F.)
		SF2->F2_UNOMCLI := cNomCli
		SF2->F2_XTIPDOC	:= cTipDoc
		SF2->F2_UNITCLI := cNitCli
		SF2->F2_XCLDOCI	:= cClDocI
		SF2->F2_XEMAIL	:= cCorreo
		If(!Empty(cGarante))
			SF2->F2_XGARANT	:= cGarante
		EndIf
		SF2->(MsUnlock())

		nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SF2")+SF2->F2_SERIE,1,"0")
		if (nEnLinea <> "1")
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
		ENDIF
	EndIf

	RestArea (aArea)

Return
