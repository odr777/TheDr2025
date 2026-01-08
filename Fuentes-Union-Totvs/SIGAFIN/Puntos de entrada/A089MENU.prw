#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³A089MENU  ºAuthor ³Erick Etcheverry	   Date ³  02/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para adicionar menu a la arotina FINA089          º±±
±±º        LLAMADO https://totvssuporte.zendesk.com/agent/tickets/5636591 º±±                                             			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB  UNION                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function A089MENU()
	Local aRotina := ParamIXB[1]
	aadd(aRotina,{ "Imp.Liq Cheque" , 'u_cchperca()', , })
return aRotina

user function cchperca()

	cPerg:="CHCOPAOR"
	Dbselectarea("SX1")
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg+Space(2)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DTOS(SE1->E1_EMISSAO)//DTOS(M->DDATALANC)
		SX1->(MsUnlock())
	Endif
	If SX1->(DbSeek(cPerg+Space(2)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  DTOS(SE1->E1_EMISSAO)
		SX1->(MsUnlock())
	ENDif
	If SX1->(DbSeek(cPerg+Space(2)+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SE1->E1_NUM
		SX1->(MsUnlock())
	ENDif
	If SX1->(DbSeek(cPerg+Space(2)+'04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SE1->E1_NUM
		SX1->(MsUnlock())
	ENDif
	If SX1->(DbSeek(cPerg+Space(2)+'05'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SE1->E1_PORTADO
		SX1->(MsUnlock())
	ENDif
	If SX1->(DbSeek(cPerg+Space(2)+'06'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SE1->E1_PORTADO
		SX1->(MsUnlock())
	ENDif
	SX1->(dbclosearea())
	u_CHCOPAOR()
return