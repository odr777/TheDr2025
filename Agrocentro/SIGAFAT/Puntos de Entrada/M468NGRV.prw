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

	// MATA468N	Generación de Notas
	// MATA467N Facturación
	// MATA461  Preparar Documento de Salida
	If Alltrim(FunName()) == "MATA468N" .OR. Alltrim(FunName()) == "MATA467N" .OR. Alltrim(FunName()) == "MATA461"
		_cDoc:=SF2->F2_DOC
		_cSerieFac:=SF2->F2_SERIE
		_cPedido:=SD2->D2_PEDIDO
		_nValFac:=SF2->F2_VALBRUT

		// Nahim adicionado para generar el título en Dólares
		if SC5->C5_MOEDTIT == 2 // sólo si la moneda del título es 2
			_cDoc:=SF2->F2_DOC
			_cSerieFac:=SF2->F2_SERIE
			nTazaMoneda := RecMoeda(dDatabase,2)
			dbSelectArea("SE1")
			SE1->(dbSetOrder(1))
			SE1->(dbSeek(xFilial("SE1")+_cSerieFac+_cDoc))
			While !EOF() .And. _cDoc == SE1->E1_NUM .And. _cSerieFac == SE1->E1_PREFIXO
				nValorBascom := SE1->E1_BASCOM1
				nValE1_VLCRUZ := SE1->E1_VLCRUZ
				nValE1Valor:= SE1->E1_VALOR
				nVSaldo := SE1->E1_SALDO
				RecLock("SE1",.F.)
				
				Replace 	E1_MOEDA      With 2
				
				Replace 	E1_TXMOEDA      With nTazaMoneda
				if  SF2->F2_TXMOEDA == 1 // NT 28/03/19
					Replace 	E1_VALOR      With nValE1Valor / nTazaMoneda
					Replace 	E1_SALDO      With nVSaldo / nTazaMoneda
				else
					Replace 	E1_BASCOM1      With nValorBascom / nTazaMoneda
				endif
	
				MsUnlock()
				SE1->(dbSkip())
			end
			dbCloseArea()
		endif

		nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SF2")+SF2->F2_SERIE,1,"0")

		// ajustes anteriores a la facturación electrónica
		if (nEnLinea <> "1")
			aDados:=Array(6)
			aDados[1] := SF2->F2_SERIE
			aDados[2] := SF2->F2_ESPECIE
			aDados[3] := SF2->F2_DOC
			aDados[4] := If(Empty(SC5->C5_UNITCLI),Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC"),SC5->C5_UNITCLI)
			aDados[5] := DtoS(SF2->F2_EMISSAO)
			aDados[6] := xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
			aRetCF := RetCF(aDados)

			Reclock('SF2',.F.)
			SF2->F2_CODCTR	:= aRetCF[2]	//Codigo de Controle
			SF2->F2_LIMEMIS	:= aRetCF[3]	//Data Limite de Emisao
			SF2->(MsUnlock())			

			SF3->(DbSetOrder(6))
			If SF3->(DbSeek(xFilial('SF3')+SF2->(F2_DOC+F2_SERIE)) )
				Reclock('SF3',.F.)
				SF3->F3_CODCTR	:= aRetCF[2]	//Codigo de Controle
				SF3->F3_VALCONT	:= xMoeda(SF3->F3_VALCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
				SF3->(MsUnlock())
			End
			_cDoc := SF2->F2_DOC
			_cSerieFac := SF2->F2_SERIE
			_cPedido := SD2->D2_PEDIDO
			_nValFac := SF2->F2_VALBRUT
		endif

		// Imprimir Factura		
		if (nEnLinea <> "1")
			// Ajustar al formato del cliente
			//U_FACTLOCAL(_cDoc,_cDoc,_cSerieFac,1,"ORIGINAL")
			//U_FACTLOCAL(_cDoc,_cDoc,_cSerieFac,1,"COPIA")				
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

	END
	RestArea(aArea)
return
