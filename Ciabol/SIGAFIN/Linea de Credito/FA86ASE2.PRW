#INCLUDE "TBICONN.CH"
#include "Protheus.ch"

//PE
user function FA86ASE2
	Local cEHprestamo :=""
	Local cBancox :=""
	Local cAgcix :=""
	Local cContax :=""

	DbSelectArea("SE2")
	DbSetOrder(1)

	if DbSeek(xFilial("SE2")+'PEM'+SEK->EK_NUM+SEK->EK_PARCELA+SEK->EK_TIPO+SEK->EK_FORNECE+SEK->EK_LOJA).and.(SE2->E2_PREFIXO=='PEM')
		cEHprestamo := alltrim(SE2->E2_NUM)
		cE5parcela  :=  alltrim(SE2->E2_PARCELA)

		dbSelectArea("ZE1")
		dbSetOrder(2)
		alert(xfilial("ZE1") +cEHprestamo +cE5parcela)
		if dbSeek(xfilial("ZE1") + cEHprestamo +cE5parcela)
			RecLock("ZE1", .F.)
			ZE1->ZE1_NODEP = ""
			ZE1->ZE1_DDEP = STOD(' / / ')
			ZE1->ZE1_ESTADO = '2'
			MSUnlock()
		endif

		dbSelectArea("SEH")
		dbSetOrder(1)
		if dbSeek(xFilial("SEH") + cEHprestamo).and. (SEK->EK_PREFIXO=='PEM')
			cBancox := SEH->EH_XCOD
			cAgcix:= SEH->EH_XAGENCI
			cContax:= SEH->EH_XNUMCON
		endif

		SA6->(dbSetOrder(1))
		SA6->(dbGoTop())
		if SA6->(dbSeek(xfilial("SA6")+cBancox+cAgcix+cContax))
			nValorLin := 0
			nValorOP := 0
			if SA6->A6_MOEDA == 1
				nValorLin = SA6->A6_USLDLIN - iif(SEK->EK_MOEDA == "1",SEK->EK_VALOR,SEK->EK_VLMOED1)  //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
				nValorOP = SA6->A6_USLDOPE - iif(SEK->EK_MOEDA == "1",SEK->EK_VALOR,SEK->EK_VLMOED1) //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
			else              //banco esta en dolares
				nValorLin = SA6->A6_USLDLIN - iif(SEK->EK_MOEDA == "2",SEK->EK_VALOR,xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02) )  //xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02)
				nValorOP = SA6->A6_USLDOPE - iif(SEK->EK_MOEDA == "2",SEK->EK_VALOR,xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02) )
			endif
			RecLock("SA6", .F.)
			SA6->A6_USLDLIN = nValorLin
			SA6->A6_USLDOPE = nValorOP
			MSUnlock()
		endif

	endif

return