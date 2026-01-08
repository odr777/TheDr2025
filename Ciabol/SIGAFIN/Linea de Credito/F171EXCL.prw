#include 'protheus.ch'
#include 'parmtype.ch'

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  F171EXCL  ºAutor  ³ERICK ETCHEVERRY º 	 Date 0/04/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Excluir el prestamo		                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ciabol ltda	                                  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function F171EXCL()
	SA6->(dbSetOrder(1))
	SA6->(dbGoTop())
	if SA6->(dbSeek(xfilial("SA6")+SEH->EH_XCOD+SEH->EH_XAGENCI+SEH->EH_XNUMCON))
		nValorLin := 0
		nValorOP := 0
		if SA6->A6_MOEDA == 1
			nValorLin = SA6->A6_USLDLIN + iif(SEH->EH_MOEDA == 1,SEH->EH_VALOR,SEH->EH_VLCRUZ)  //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
			nValorOP = SA6->A6_USLDOPE + iif(SEH->EH_MOEDA == 1,SEH->EH_VALOR,SEH->EH_VLCRUZ) //xMoeda(SEK->EK_VALOR,2,1,,2,SEK->EK_TXMOE02,1)
		else              //banco esta en dolares
			nValorLin = SA6->A6_USLDLIN + iif(SEH->EH_MOEDA == 2,SEH->EH_VALOR,xMoeda(SEH->EH_VALOR,1,2,SEH->EH_DATA,2) )  //xMoeda(SEK->EK_VALOR,1,2,,2,1,SEK->EK_TXMOE02)
			nValorOP = SA6->A6_USLDOPE + iif(SEH->EH_MOEDA == 2,SEH->EH_VALOR,xMoeda(SEH->EH_VALOR,1,2,SEH->EH_DATA,2) )
		endif
		RecLock("SA6", .F.)
		SA6->A6_USLDLIN = nValorLin
		SA6->A6_USLDOPE = nValorOP
		MSUnlock()
	endif
return