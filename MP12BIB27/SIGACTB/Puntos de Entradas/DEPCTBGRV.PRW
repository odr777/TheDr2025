#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDEPCTBGRV บAutor  ณTOTVS               บFecha ณ  / /        บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impresi๓n de los asientos contables -Online                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DEPCTBGRV()

	U_ACTTS9() // Actualiza tipo de saldo 9 a 1 cuando hay diferencia de cambio Nahim Terrazas 27/08/2021
	if GetRemoteType() < 0 // nahim Terrazas toma en cuenta s๓lo si no es un web services
		return .T.
	endif
	// Nahim Borra Glosa
	if type("cGlosaCon") <> "U"
		cGlosaCon := NIL
		FreeObj(cGlosaCon)
	endif

	If Funname()$SUPERGETMV('MV_UIMPCTB',.F.,"MATA468N|CTBANFS|MATA101N")
		//if FunName() = 'MATA468N' .and. MV_PAR11 = 2
		Return
	ENDIF
	// ImpLanc() // Imprimir asiento despues de gravar 

	// Nahim caso estemos en cobros diversos se imprimirแ el cobro diverso.
	IF(FUNNAME()$'FINA087A')
		aArea    := GetArea()

		SX1->(DbSetOrder(1))
		SX1->(DbGoTop())
		If SX1->(DbSeek('FIR087'+Space(4)+'01'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 := cRecibo
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

		// alert("FA087GRV")
		U_CFinI204()
		//U_CobrDiv()
		RestArea( aArea )
	END

Return

static Function ImpLanc()
	Local aAreactb:= SX1->(GETAREA())

	// Nahim adicionando preguntas a mano porque si no no carga
	xmv_par01  :=  mv_par01
	xmv_par02  :=  mv_par02
	xmv_par03  :=  mv_par03
	xmv_par04  :=  mv_par04
	xmv_par05  :=  mv_par05
	xmv_par06  :=  mv_par06
	xmv_par07  :=  mv_par07
	xmv_par08  :=  mv_par08
	xmv_par09  :=  mv_par09
	xmv_par10  :=  mv_par10
	xmv_par11  :=  mv_par11
	xmv_par12  :=  mv_par12
	xmv_par13  :=  mv_par13
	xmv_par14  :=  mv_par14
	xmv_par15  :=  mv_par15
	xmv_par16  :=  mv_par16
	xmv_par17  :=  mv_par17
	xmv_par18  :=  mv_par18
	xmv_par19  :=  mv_par19
	xmv_par21  :=  mv_par21
	xmv_par22  :=  mv_par22
	xmv_par23  :=  mv_par23
	xmv_par24  :=  mv_par24
	xmv_par25  :=  mv_par25
	xmv_par26  :=  mv_par26
	xmv_par27  :=  mv_par27
	xmv_par28  :=  mv_par28
	xmv_par29  :=  mv_par29
	xmv_par30  :=  mv_par30
	xmv_par31  :=  mv_par31
	xmv_par32  :=  mv_par32
	xmv_par33  :=  mv_par33
	xmv_par34  :=  mv_par34
	xmv_par35  :=  mv_par35
	xmv_par36  :=  mv_par36
	xmv_par37  :=  mv_par37
	xmv_par38  :=  mv_par38
	xmv_par39  :=  mv_par39
	xmv_par40  :=  mv_par40
	xmv_par41  :=  mv_par41
	xmv_par42  :=  mv_par42
	xmv_par43  :=  mv_par43
	xmv_par44  :=  mv_par44
	xmv_par45  :=  mv_par45
	xmv_par46  :=  mv_par46
	xmv_par47  :=  mv_par47
	xmv_par48  :=  mv_par48
	xmv_par49  :=  mv_par49
	xmv_par50  :=  mv_par50

	cPregNah:="CTR070"
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPregNah+Space(4)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DTOS(M->DDATALANC)
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPregNah+Space(4)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  DTOS(M->DDATALANC )
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  M->CLOTE
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  M->CLOTE
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'05'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  M->CDOC
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'06'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  M->CDOC
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
		SX1->X1_CNT01 :=  M->cSubLote
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'16'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  M->cSubLote
		SX1->(MsUnlock())
	END
	U_CtbcR070()
	RestArea(aAreactb)
	pergunte(SX1->X1_GRUPO,.F.)

	mv_par01  :=  xmv_par01
	mv_par02  :=  xmv_par02
	mv_par03  :=  xmv_par03
	mv_par04  :=  xmv_par04
	mv_par05  :=  xmv_par05
	mv_par06  :=  xmv_par06
	mv_par07  :=  xmv_par07
	mv_par08  :=  xmv_par08
	mv_par09  :=  xmv_par09
	mv_par10  :=  xmv_par10
	mv_par11  :=  xmv_par11
	mv_par12  :=  xmv_par12
	mv_par13  :=  xmv_par13
	mv_par14  :=  xmv_par14
	mv_par15  :=  xmv_par15
	mv_par16  :=  xmv_par16
	mv_par17  :=  xmv_par17
	mv_par18  :=  xmv_par18
	mv_par19  :=  xmv_par19
	mv_par21  :=  xmv_par21
	mv_par22  :=  xmv_par22
	mv_par23  :=  xmv_par23
	mv_par24  :=  xmv_par24
	mv_par25  :=  xmv_par25
	mv_par26  :=  xmv_par26
	mv_par27  :=  xmv_par27
	mv_par28  :=  xmv_par28
	mv_par29  :=  xmv_par29
	mv_par30  :=  xmv_par30
	mv_par31  :=  xmv_par31
	mv_par32  :=  xmv_par32
	mv_par33  :=  xmv_par33
	mv_par34  :=  xmv_par34
	mv_par35  :=  xmv_par35
	mv_par36  :=  xmv_par36
	mv_par37  :=  xmv_par37
	mv_par38  :=  xmv_par38
	mv_par39  :=  xmv_par39
	mv_par40  :=  xmv_par40
	mv_par41  :=  xmv_par41
	mv_par42  :=  xmv_par42
	mv_par43  :=  xmv_par43
	mv_par44  :=  xmv_par44
	mv_par45  :=  xmv_par45
	mv_par46  :=  xmv_par46
	mv_par47  :=  xmv_par47
	mv_par48  :=  xmv_par48
	mv_par49  :=  xmv_par49
	mv_par50  :=  xmv_par50

Return
