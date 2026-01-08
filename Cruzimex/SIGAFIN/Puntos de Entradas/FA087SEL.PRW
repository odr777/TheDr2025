#include 'protheus.ch'
#include 'parmtype.ch'

/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA087SEL  บAutor  ณTdeP Horeb SRL บ Data ณ  21/12/2018      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPUNTO DE ENTRADA DESPUES DE GRABAR EN LA TABLA SEL		  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP12BIB                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function FA087SEL()
	Local aArNAHIM := GetArea()
	Local cPediEL := ""
	//	Local cSerie := ""
	Local cTipoCob := ""
	Local nX

	if GetRemoteType() < 0 // nahim Terrazas toma en cuenta s๓lo si no es un web services
		return .T.
	endif

	//	SEL->(DBSKIP(-1)) // Nahim 18/03/2019 COMENTADO 05/02/2020

	//		(SEL->EL_RECIBO)
	//	alert(SEL->EL_TIPODOC)
	DbSelectArea("SEL")
	SEL->(DbSetOrder(7))
	SEL->(DbGoTop())
	SEL->(DbSeek(FWxFilial('SEL') +cCliente+cLoja+cRecibo+cSerie)) // Nahim Modificaci๓n para tomar la SERIE

	//	if SEL->EL_TIPODOC == 'RA'
	////		cRecibo := SEL->EL_RECIBO
	//		cClirig := SEL->EL_CLIORIG
	//		cLojorig := SEL->EL_LOJORIG
	////		cSerieEl := SEL->EL_SERIE
	//
	//
	//		SEL->(DbSetOrder(7))
	//		SEL->(DbGoTop())
	//		If SEL->(DbSeek(FWxFilial('SEL') +cClirig+cLojorig+cRecibo+cSerie)) // Nahim Modificaci๓n para tomar la SERIE
	//		If SEL->(DbSeek(FWxFilial('SEL') +cClirig+cLojorig+cRecibo+cSerieEl))
	Do While !SEL->(Eof()) .and. SEL->EL_RECIBO == cRecibo .and. cCliente == SEL->EL_CLIORIG;
	.and. cLoja == SEL->EL_LOJORIG .and. cSerie == SEL->EL_SERIE

		if SEL->EL_TIPODOC <> 'RA'
			//					cPediEL := SEL->EL_UPV
			cTipoCob := SEL->EL_TIPO
//			cSerie := SEL->EL_SERIE // TODO validar si tiene ch้que o no, es decir, si pago con cualquier ch้que
			exit
		endif

		SEL->(DBSKIP())
	ENDDO
	//	EndIf
	//	endif
	// nahim ajustando aPVSelec
	if Type("aPVSelec") == "U" // valida si es que no existe
		//		alert("sale")
		RestArea(aArNAHIM)
		cPerg := "FIN87A"
		pergunte(cPerg,.F.)
		return
	endif
	//
	nTamPedSelec := Len(aPVSelec)// tama๑o array de pedidos seleccionados
	cPedVNum := ""
	For nX := 1 to nTamPedSelec
		cPediEL := aPVSelec[nX]

		if !empty(alltrim(cPediEL))
			//		bBloco := { |nArg| nArg + 1 }
			//GetNewPar("MV_U_FACTF",.F.)  // define si utiliza venta futura
			dbSelectArea("SC5")
			dbSetOrder(1)
			MsSeek(FWxFilial('SC5') + cPediEL )
			// validaci๓n cuando es a fin de mes, deberํa facturar el pedido
			if GetNewPar("MV_U_FACTF",.F.) .and. SC5->C5_DOCGER == '3'
				if SC5->C5_DOCGER == '3'
					bBloco := { | cPediEL,cSerie| u_IncFacRA(cPediEL,cSerie) }
					EVAL(bBloco,cPediEL,cSerie)
				endif
			endif
			// termina validacion cuando es fin de m้s

			// Nahim 21/03 - adicionando por la leyenda
			IF trim(cTipoCob) == "CH" .and. SEL->EL_TPCRED == '3'// si es cheque deberia utilizar (ch้que sin cobro) NT 29/03/2019
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				RecLock("SC5",.F.)
				Replace 	C5_USTATUS      With "2"
				Replace 	C5_USERIE      With SEL->EL_SERIE
				Replace 	C5_URECIBO      With SEL->EL_RECIBO

				// nahim 22/08/2019
				if type("lBloqueoRegla") <> "U" //if lBloqueoRegla
					Replace C5_BLQ  With "1"
					Replace C5_UBLOQDE	with "Bloqueo - Anticipo menor al valor del pedido."	// nahim 05/02/2020
				endif

				Replace 	C5_URECIBO      With SEL->EL_RECIBO
				MsUnlock()
				//				DbCloseArea("SC5")
			else // s๓lo si diferente de ch้que
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				RecLock("SC5",.F.)
				Replace 	C5_USTATUS      With "1"
				Replace 	C5_USERIE      With SEL->EL_SERIE
				Replace 	C5_URECIBO      With SEL->EL_RECIBO

				// nahim 22/08/2019
				if type("lBloqueoRegla") <> "U" //if lBloqueoRegla
					Replace C5_BLQ  With "1"
					Replace C5_UBLOQDE	with "Bloqueo - Anticipo menor al valor del pedido."		// Agregando descripci๓n de Bloqueo NTP 13/02/2020
					// nahim 22/08/2019
				endif

				MsUnlock()
				//				DbCloseArea("SC5")
			endif
			// Nahim 21/03  Termina
			//			if .T. // nahim 22/08/2019 // bloqueo por regla de negocios
			if type("lBloqueoRegla") <> "U" //if lBloqueoRegla
				SC6->(DbSetOrder(1))
				SC6->(DbGoTop())
				If SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))
					While SC6->(!EOF()) .AND. SC6->C6_NUM == SC5->C5_NUM
						Reclock('SC6',.F.)
						SC6->C6_BLOQUEI := "01"
						SC6->(MsUnlock())
						SC6->(DbSkip())
					End
				End
			endif
			DbCloseArea("SC5")
		endif

	Next nX
	if type("lBloqueoRegla") <> "U" //if lBloqueoRegla
		// Nahim Terrazas 25/08/2019  borra si es que tiene bloqueo de regla
		lBloqueoRegla := NIL
		FreeObj(lBloqueoRegla)
	endif
	RestArea(aArNAHIM)

	IMPRDOC() // imprimiendo documentos Nahim 28/11/2019

	cPerg := "FIN87A"
	pergunte(cPerg,.F.)
return

STATIC FUNCTION IMPRDOC()

	// imprime documentos contables y/o Nahim 28/11/2019
	SX1->(DbSetOrder(1))
	SX1->(DbGoTop())
	If SX1->(DbSeek('FIR087'+Space(4)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=cRecibo
		SX1->(MsUnlock())
	End

	If SX1->(DbSeek('FIR087'+Space(4)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := cRecibo
		SX1->(MsUnlock())
	End

	SX1->(DbSetOrder(1))
	SX1->(DbGoTop())
	If SX1->(DbSeek('FIR087'+Space(4)+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := cSerie
		SX1->(MsUnlock())
	End
	U_CFinI204()
	// imprime asiento contable
	// Nahim Termina de imprimir documentos 28/11/2019

	If type("aImpLancC") <> "U"
		//		alert("ENTRO")
		cPregNah:="CTR070"
		SX1->(DbSetOrder(1))
		If SX1->(DbSeek(cPregNah+Space(4)+'01'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 := DTOS(aImpLancC[1])
			SX1->(MsUnlock())
		End
		If SX1->(DbSeek(cPregNah+Space(4)+'02'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  DTOS(aImpLancC[1])
			SX1->(MsUnlock())
		END
		If SX1->(DbSeek(cPregNah+Space(4)+'03'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  aImpLancC[2]
			SX1->(MsUnlock())
		END
		If SX1->(DbSeek(cPregNah+Space(4)+'04'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  aImpLancC[2]
			SX1->(MsUnlock())
		END
		If SX1->(DbSeek(cPregNah+Space(4)+'05'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  aImpLancC[3]
			SX1->(MsUnlock())
		END
		If SX1->(DbSeek(cPregNah+Space(4)+'06'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  aImpLancC[3]
			SX1->(MsUnlock())
		END
		If SX1->(DbSeek(cPregNah+Space(4)+'07'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  '01'
			SX1->(MsUnlock())
		END
		If SX1->(DbSeek(cPregNah+Space(4)+'12'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  '3'
			SX1->(MsUnlock())
		END
		If SX1->(DbSeek(cPregNah+Space(4)+'15'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  aImpLancC[4]
			SX1->(MsUnlock())
		END
		If SX1->(DbSeek(cPregNah+Space(4)+'16'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 :=  aImpLancC[4]
			SX1->(MsUnlock())
		END
		U_CtbcR070()
		aImpLancC := NIL
		FreeObj(aImpLancC)
	else
		//		alert("no entr๓")
	Endif

RETURN