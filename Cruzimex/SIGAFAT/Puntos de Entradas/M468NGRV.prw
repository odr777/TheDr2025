#include 'protheus.ch'
#include 'parmtype.ch'

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
	Private _nValFac
	Private _cSerieFac
	DbSelectArea("SF2")
	//ALERT(FunName())
	If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N" .or. Alltrim(FunName()) == "MATA461"
		_cDoc:=SF2->F2_DOC
		_cSerieFac:=SF2->F2_SERIE
		_cPedido:=SD2->D2_PEDIDO
		_nValFac:=SF2->F2_VALBRUT

		//ALERT(FunName())
		If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N" .OR. Alltrim(FunName()) == "MATA461"   // Generacion de Factura de Ventas
			//    If Alltrim(FunName()) = "MATA410" .OR. Alltrim(FunName()) = "MATA467N"
			iF Alltrim(FunName()) == "MATA468N" .OR. Alltrim(FunName()) == "MATA461"
				cNitCli :=  If(Empty(SC5->C5_UNITCLI),GetAdvFVal("SA1","A1_UNITFAC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)
				cNomcli := If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_UNOMFAC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)
			ELSE // factura directa
				cNitCli :=  GetAdvFVal("SA1","A1_UNITFAC",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cNomcli :=  GetAdvFVal("SA1","A1_UNOMFAC",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
			END
			iF GETNEWPAR('MV_UCAMDAT',.T.) .AND. Alltrim(FunName()) != "MATA461"
				aDatosCliente := U_SetDatosCli(cNitCli,cNomcli)
				cNitCli := STRTOKARR(aDatosCliente,'|')[1]
				cNomCli := STRTOKARR(aDatosCliente,'|')[2]
			END

			Reclock('SF2',.F.)
			SF2->F2_UNITCLI := cNitCli
			SF2->F2_UNOMCLI := cNomCli
			SF2->(MsUnlock())
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
				//  ALERT(TRANSFORM(SF3->F3_VALCONT,"@E 999,999.999"))
				SF3->F3_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
				SF3->F3_CODCTR	:= aRetCF[2]	//Codigo de Controle
				SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
				SF3->(MsUnlock())
			End

			_cDoc := SF2->F2_DOC
			_cSerieFac := SF2->F2_SERIE
			_cPedido := SD2->D2_PEDIDO
			_nValFac := SF2->F2_VALBRUT

		EndIf
		//ALERT("Imprimir m468")
		U_FACTLOCAL(_cDoc,_cDoc,_cSerieFac,1)
		//	U_FactQR()
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

//			U_OrdenFact(nDocn1,nDocFinal,SF2->F2_SERIE,1) // Nahim imprimir Orden de entrega
//			U_FACTLOCAL(nDocn1,nDocFinal,SF2->F2_SERIE,1)
			//			next
		endif
		// una vez terminado imprime el despacho
		// CODIGO DE CARGA DAK_COD
		//		AjustaSx1()
		//		U_OMSRESUM()
		//		U_OMSDETA()
	endif

	RestArea(aArea)
return

static Function AjustaSx1() // posiciona valores para query preguntas
	//	alert("Pasa AjustaSx1")
	//	alert(DAK->DAK_COD)
	cPerg :="OMR020"+Space(4)
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DAK->DAK_COD
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek(cPerg+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DAK->DAK_COD
		SX1->(MsUnlock())
	END

return nil
