#include 'protheus.ch'
#include 'parmtype.ch'

USER FUNCTION LOCXPE08
	Local aArea    := GetArea()

	If aCfgNf[1] == 64
		cPerg := "TRANSENT"
		Reclock('SF1',.F.)
		SF1->F1_USRREG := SUBSTR(UPPER(CUSERNAME),1,15)
		SF1->(MsUnlock())
		IF MsgYesNo("Desea imprimir la Transferencia: "+ AllTrim(cNFiscal) + " / " + AllTrim(cSerie))

			SX1->(DbSetOrder(1))
			SX1->(DbGoTop())
			If SX1->(DbSeek(cPerg+Space(4)+'01') )
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF1->F1_FILIAL
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'02'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF1->F1_FILIAL
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'03'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := dtoc(SF1->F1_EMISSAO)
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'04'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := dtoc(SF1->F1_EMISSAO)
				SX1->(MsUnlock())
			End

			SX1->(DbSetOrder(1))
			If SX1->(DbSeek(cPerg+Space(4)+'05'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF1->F1_DOC
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'06'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF1->F1_DOC
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'07'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF1->F1_SERIE
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'08'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF1->F1_SERIE
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'09'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF1->F1_FORNECE
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'10'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF1->F1_FORNECE
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'11'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := 1
				SX1->(MsUnlock())
			End

			RestArea( aArea )

			U_TRANS2ENT()   //E: Entrada

		Endif

	Endif

	if aCfgNf[1] == 54
		cPerg := "TRANSSAL"
		Reclock('SF2',.F.)
		SF2->F2_USRREG := SUBSTR(UPPER(CUSERNAME),1,15)
		SF2->(MsUnlock())
		IF MsgYesNo("Desea imprimir la Transferencia: "+ AllTrim(cNFiscal) + " / " + AllTrim(cSerie))

			SX1->(DbSetOrder(1))
			SX1->(DbGoTop())
			If SX1->(DbSeek(cPerg+Space(4)+'01') )
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF2->F2_FILIAL
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'02'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF2->F2_FILIAL
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'03'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := dtoc(SF2->F2_EMISSAO)
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'04'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := dtoc(SF2->F2_EMISSAO)
				SX1->(MsUnlock())
			End

			SX1->(DbSetOrder(1))
			If SX1->(DbSeek(cPerg+Space(4)+'05'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF2->F2_DOC
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'06'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF2->F2_DOC
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'07'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF2->F2_SERIE
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'08'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF2->F2_SERIE
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'09'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF2->F2_CLIENTE
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'10'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := SF2->F2_CLIENTE
				SX1->(MsUnlock())
			End

			If SX1->(DbSeek(cPerg+Space(4)+'11'))
				RecLock('SX1',.F.)
				SX1->X1_CNT01 := 2
				SX1->(MsUnlock())
			End

			RestArea( aArea )

			U_TRANS2SAL()   //E: Entrada
		endif
	endif

	IF ALLTRIM(FUNNAME())="MATA101N"
		cPerg := "UC0005"
		SX1->(DbSetOrder(1))
		SX1->(DbGoTop())
		If SX1->(DbSeek(cPerg+Space(4)+'01') )
			RecLock('SX1',.F.)
			SX1->X1_CNT01 := SF1->F1_DOC
			SX1->(MsUnlock())
		End

		If SX1->(DbSeek(cPerg+Space(4)+'02'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 := SF1->F1_DOC
			SX1->(MsUnlock())
		End

		If SX1->(DbSeek(cPerg+Space(4)+'03'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 := SF1->F1_SERIE
			SX1->(MsUnlock())
		End

		If SX1->(DbSeek(cPerg+Space(4)+'04'))
			RecLock('SX1',.F.)
			SX1->X1_CNT01 := SF1->F1_FORNECE
			SX1->(MsUnlock())
		End

		IF MSGYESNO("Desea imprimir el documento "+ Left(SF1->F1_SERIE,3) + " / " + SF1->F1_DOC)
			//U_remitpe(SF1->F1_DOC,Left(SF1->F1_ESPECIE,3))
			U_remitpe()
		ENDIF

		RestArea( aArea )
	ENDIF
Return