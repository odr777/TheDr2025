#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M468NGRV  ºAutor  ³Jorge Saavedra  ºFecha ³  19/05/2015     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Punto de Entrada que se ejecuta al finalizar la Venta  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function M468NGRV()
	Local aArea    := GetArea()
	Private _nValFac
	Private _cSerieFac
	DbSelectArea("SF2")
	
	If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N"
		_cDoc:=SF2->F2_DOC
		_cSerieFac:=SF2->F2_SERIE
		_cPedido:=SD2->D2_PEDIDO
		_nValFac:=SF2->F2_VALBRUT

		If Alltrim(FunName()) == "MATA468N"  .OR. Alltrim(FunName()) == "MATA467N"    // Generacion de Factura de Ventas
			//    If Alltrim(FunName()) = "MATA410" .OR. Alltrim(FunName()) = "MATA467N"
			iF Alltrim(FunName()) == "MATA468N"

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
						// RecMoeda(dDatabase,nMoeda)
						//			E1_TXMOEDA - poner tasa del día
						//			E1_BASCOM1 - Multiplicar por E1_TXMOEDA
						//			E1_VLCRUZ - Multiplicar por E1_TXMOEDA
						Replace 	E1_TXMOEDA      With nTazaMoneda
						if  SF2->F2_TXMOEDA == 1 // NT 28/03/19
							Replace 	E1_VALOR      With nValE1Valor / nTazaMoneda
							Replace 	E1_SALDO      With nVSaldo / nTazaMoneda
						else
							Replace 	E1_BASCOM1      With nValorBascom / nTazaMoneda
						endif
						//				Replace 	E1_BASCOM1      With nValorBascom / nTazaMoneda
						//				Replace 	E1_VLCRUZ      With nValE1_VLCRUZ * nTazaMoneda
						MsUnlock()
						SE1->(dbSkip())
					end
					dbCloseArea()
				endif
				// Nahim adicionado para generar el título en Dólares (Nahim)

				/*cNomcli := If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)
				cTipDoc := If(Empty(SC5->C5_XTIPDOC),GetAdvFVal("SA1","A1_TIPDOC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XTIPDOC)
				cNitCli := If(Empty(SC5->C5_UNITCLI),GetAdvFVal("SA1","A1_CGC",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)		
				cClDocI := If(Empty(SC5->C5_XCLDOCI),GetAdvFVal("SA1","A1_CLDOCID",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XCLDOCI)
				cEmail	:= If(Empty(SC5->C5_XEMAIL), GetAdvFVal("SA1","A1_EMAIL",xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XEMAIL)	*/
			/*ELSE
				cNomcli :=  GetAdvFVal("SA1", "A1_NOME",   	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cTipDoc :=	GetAdvFVal("SA1", "A1_TIPDOC", 	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0") 
				cNitCli :=  GetAdvFVal("SA1", "A1_CGC",    	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")
				cClDocI := 	GetAdvFVal("SA1", "A1_CLDOCID",	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")  
				cEmail 	:=	GetAdvFVal("SA1", "A1_EMAIL", 	xFilial("SA1")+M->(F2_CLIENTE+F2_LOJA),1,"0")*/
			END

			aDados:=Array(6)
			aDados[1] := SF2->F2_SERIE
			aDados[2] := SF2->F2_ESPECIE
			aDados[3] := SF2->F2_DOC
			aDados[4] := SF2->F2_UNITCLI
			aDados[5] := DtoS(SF2->F2_EMISSAO)
			aDados[6] := xMoeda(SF2->F2_VALBRUT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO)
			aRetCF := RetCF(aDados)
			
			nEnLinea := GetAdvFVal("SFP","FP_TPTRANS", xFilial("SFP")+xFilial("SF2")+_cSerieFac,1,"0")
			if (nEnLinea <> "1")
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
			endif

			_cFil := SF2->F2_FILIAL
			_cDoc := SF2->F2_DOC
			_cSerieFac := SF2->F2_SERIE
			_cPedido := SD2->D2_PEDIDO
			_nValFac := SF2->F2_VALBRUT

		EndIf

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

	END
	RestArea(aArea)
return
