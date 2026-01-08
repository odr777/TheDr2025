#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ M460FIM ³Erick Etcheverry	 º 				   Data ³ 03/08/18º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ APOS GRAVACAO SF2						                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ registro por registro				                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BEL												      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function M460FIM()
	if Type( "aRecnoF2" ) == "U" //para luego ver como imprimir la factura por rango
		public aRecnoF2 := {}
	endif
	if ALLTRIM(upper(funname())) $ "MATA460B"
		_cDoc:=SF2->F2_DOC
		_cSerieFac:=SF2->F2_SERIE
		_cPedido:=SD2->D2_PEDIDO
		_nValFac:=SF2->F2_VALBRUT

		//Nit del cliente trae de la SC5
		cNitCli :=  If(Empty(SC5->C5_UNITCLI),GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)
		cNomcli := If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)
		//ACTUALIZA SF2
		Reclock('SF2',.F.)
		SF2->F2_UNITCLI := cNitCli
		SF2->F2_UNOMCLI := cNomCli
		SF2->(MsUnlock())
		//DADOS PARA CODIGO CONTROL
		aDados:=Array(6)
		aDados[1] := SF2->F2_SERIE
		aDados[2] := SF2->F2_ESPECIE
		aDados[3] := SF2->F2_DOC
		aDados[4] := cNitCli //If(Empty(SC5->C5_UNITCLI),Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC"),SC5->C5_UNITCLI)
		aDados[5] := DtoS(SF2->F2_EMISSAO)
		aDados[6] := xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
		//CODIGO CONTROL

		aRetCF := RetCF(aDados)
		Reclock('SF2',.F.)
		SF2->F2_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
		SF2->F2_CODCTR	:= aRetCF[2]	//Codigo de Controle
		SF2->F2_LIMEMIS	:= aRetCF[3]	//Data Limite de Emisao
		SF2->(MsUnlock())

		//POSICIONE SF3
		SF3->(DbSetOrder(6))
		If SF3->(DbSeek(xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)) )
			Reclock('SF3',.F.)
			SF3->F3_NUMAUT	:= aRetCF[1]	//Numero de Autorizacao
			SF3->F3_CODCTR	:= aRetCF[2]	//Codigo de Controle
			SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
			SF3->(MsUnlock())
		End
		//PASANDO A FACTURA PARA PRINTAR
		AADD(aRecnoF2,SF2->(Recno()))

	endif
return
