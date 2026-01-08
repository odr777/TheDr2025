
#include 'protheus.ch'
#include 'parmtype.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M468NGRV  �Autor  �TdeP �Fecha �  12/09/2017     ���
�������������������������������������������������������������������������͹��
���Desc.     �Punto de Entrada que se ejecuta al finalizar la Venta  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������͹��
���Uso       � MP12BIB                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function M468NGRV()
	Local aArea    := GetArea()

	If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA461"
		_cDoc:=SF2->F2_DOC
		_cSerieFac:=SF2->F2_SERIE
		_cPedido:=SD2->D2_PEDIDO
		_nValFac:=SF2->F2_VALBRUT
		cCond:=SF2->F2_COND


		/*If GetNewPar("MV_UEXECOB",.T.) .AND.U_VerGrpUsr(GetNewPar("MV_UGRPCOB","000000|000000"))
			IF MSGYESNO("Desea realizar el COBRO de la Factura: "+ Left(SF2->F2_SERIE,3) + " / " + SF2->F2_DOC)
				U_Cobro()
			eNDif
		ENDif*/

		iF Alltrim(FunName()) == "MATA468N"
			cNitCli :=  If(Empty(SC5->C5_UNITCLI),GetAdvFVal("SA1","A1_UNITFAC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)
			cNomcli := If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_UNOMFAC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)
		ELSE
			cNitCli :=  GetAdvFVal("SA1","A1_UNITFAC",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
			cNomcli :=  GetAdvFVal("SA1","A1_UNOMFAC",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
		ENDif
		If Empty(cNitCli)
			cNitCli := GetAdvFVal("SA1","A1_UNITFAC",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
			cNomcli :=  GetAdvFVal("SA1","A1_UNOMFAC",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
		EndIf
		If Empty(cNitCli)
			cNitCli := '9999999999999'
			cNomcli :=  'NOMBRE A FACTURAR'
		EndIf
		iF GETNEWPAR('MV_UCAMDAT',.T.)
			aDatosCliente := U_SetDatosCli(cNitCli,cNomcli)
			cNitCli := StrToArray(aDatosCliente,'|')[1]
			cNomCli := StrToArray(aDatosCliente,'|')[2]
		ENDif

		Reclock('SF2',.F.)
		SF2->F2_UNITCLI := cNitCli
		SF2->F2_UNOMCLI := cNomCli
		SF2->F2_USRREG := SUBSTR(CUSERNAME,1,15)
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
		Endif
		U_FactLocal(_cDoc,_cDoc,_cSerieFac,1)
	endif
	RestArea(aArea)
return
