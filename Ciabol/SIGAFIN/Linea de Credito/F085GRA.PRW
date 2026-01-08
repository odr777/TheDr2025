#INCLUDE "TBICONN.CH"
#include "Protheus.ch"

//PE
user function F085GRA
	Local cE5hist := "Debito CC"
	Local cEHprestamo :=""
	Local cBancox :=""
	Local cAgcix :=""
	Local cContax :=""

	dbSelectArea("SEK")
	dbSetOrder(1)

	if dbSeek(xFilial("SEK") + SEK->EK_ORDPAGO+'TB'+'PEM') //.and. (SEK->EK_PREFIXO=='INT'.or.SEK->EK_PREFIXO=='PEM')

		dbSelectArea("SE2")
		dbSetOrder(1)
		if dbSeek(xFilial("SE2") + SEK->EK_PREFIXO+SEK->EK_NUM+SEK->EK_PARCELA+SEK->EK_TIPO+SEK->EK_FORNECE+SEK->EK_LOJA).and. (SEK->EK_PREFIXO=='PRE'.or.SEK->EK_PREFIXO=='PEM')
			cE5hist := SE2->E2_HIST
			cE5parcela := alltrim(SE2->E2_PARCELA)
			cEHprestamo := alltrim(SE2->E2_NUM)
		endif

		//Buscar prestamo y obtener datos de tipo uso y grupo
		dbSelectArea("SEH")
		dbSetOrder(1)
		if dbSeek(xFilial("SEH") + cEHprestamo).and. (SEK->EK_PREFIXO=='PEM')
			cE5utpmov := "COP" //SEH->EH_UTPTRAN
			cE5udestin :="  " //SEH->EH_UDESTRA
			cE5ugrupo  := "PR"  //SEH->EH_UGRUPO
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
				nValorLin = SA6->A6_USLDLIN + iif(SEK->EK_MOEDA == "1",SEK->EK_VALOR,SEK->EK_VLMOED1)  //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
				nValorOP = SA6->A6_USLDOPE + iif(SEK->EK_MOEDA == "1",SEK->EK_VALOR,SEK->EK_VLMOED1) //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
			else              //banco esta en dolares
				nValorLin = SA6->A6_USLDLIN + iif(SEK->EK_MOEDA == "2",SEK->EK_VALOR,xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02) )  //xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02)
				nValorOP = SA6->A6_USLDOPE + iif(SEK->EK_MOEDA == "2",SEK->EK_VALOR,xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02) )
			endif
			RecLock("SA6", .F.)
			SA6->A6_USLDLIN = nValorLin
			SA6->A6_USLDOPE = nValorOP
			MSUnlock()
		endif

		dbSelectArea("ZE1")
		dbSetOrder(2)

		if dbSeek(xfilial("ZE1") + cEHprestamo +cE5parcela)
			RecLock("ZE1", .F.)
			ZE1->ZE1_NODEP = SEK->EK_ORDPAGO
			ZE1->ZE1_DDEP = SEK->EK_EMISSAO
			ZE1->ZE1_ESTADO = '3'
			MSUnlock()
		endif

	endif

return
