#include 'protheus.ch'
#include 'parmtype.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M468NGRV  ºAutor  ³TdeP Horeb SRL  ºFecha ³  19/05/2015     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada para grabar datos en el encabezado de la  º±±
±±º          ³ factura de venta y titulo desde el pedido de ventas.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2460I
	Local aArea    := GetArea()
	Private _cSerieFac
	DbSelectArea("SF2")
	DbSelectArea("SE1")
	// MATA468N	Generación de Notas
	// MATA467N Facturación
	// MATA461  Preparar Documento de Salida
	If Alltrim(FunName()) == "MATA468N" .OR. Alltrim(FunName()) = "MATA467N" .OR. Alltrim(FunName()) = "MATA461"
		_cDoc		:= SF2->F2_DOC
		_cSerieFac	:= SF2->F2_SERIE
		_cPedido	:= SD2->D2_PEDIDO
		//Executando chamada automatica da Cobranzas Diverzas

		if	RecLock("SF2",.F.)
			Replace F2_USRREG  With SUBSTR(CUSERNAME,1,15)         //usuario que reg la factura   mod YGC
			SF2->(MsUnlock())
		END
		
		iF Alltrim(FunName()) == "MATA468N" .OR. Alltrim(FunName()) == "MATA461"
			cNitCli := If(Empty(SC5->C5_UNITCLI), GetAdvFVal("SA1","A1_CGC", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)
			cNomcli := If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)
			cObserv := SC5->C5_UOBSERV
			cCampana:= SC5->C5_CAMPANA
			cDesCampana:= SC5->C5_CAMPDES
		ELSE
			cNitCli :=  GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
			cNomcli :=  GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
		END

		Reclock('SF2',.F.)
		SF2->F2_UNITCLI := cNitCli
		SF2->F2_UNOMCLI := cNomCli
		SF2->F2_UOBSERV := cObserv
		SF2->F2_CAMPANA := cCampana
		SF2->(MsUnlock())

		Reclock('SE1',.F.)
		SE1->E1_CAMPANA := cCampana
		SE1->E1_CAMPDES := cDesCampana 
		SE1->(MsUnlock())
	END
	RestArea(aArea)
return
