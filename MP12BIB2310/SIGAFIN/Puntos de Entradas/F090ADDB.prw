#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³F090ADDB  ºAuthor ³Erick Etcheverry	   Date ³  02/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para adicionar menu a la arotina FINA090          º±±
±±º          ³                                               			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP12BIB  UNION                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function F090ADDB()
	Local aRotina := ParamIXB[1]
	AADD(aRotina,{"Re Impresion de cheque",'u_reimpcheq()',,})
	//AADD(aRotina,{"Impresion Desc.Cheq",'u_cchpIrca()',,})
return aRotina

user function reimpcheq()
	Private aOrdPag := {}

	if SE2->E2_SALDO > 0

		AADD(aOrdPag,{SE2->E2_ORDPAGO,SE2->E2_ORDPAGO,SE2->E2_BCOCHQ,SE2->E2_AGECHQ,SE2->E2_CTACHQ,SE2->E2_NUM})

		u_IMPCHEAUT(aOrdPag)

	ELSE

		MsgInfo ( "No se puede imprimir un cheque que ya ha sido cobrado" , "Cheque ya debitado" )

	endif
return

/*user function cchpIrca()

cPerg:="CHCOPAOR"
Dbselectarea("SX1")
SX1->(DbSetOrder(1))
If SX1->(DbSeek(cPerg+Space(2)+'01'))
RecLock('SX1',.F.)
SX1->X1_CNT01 := DTOS(SE2->E2_EMISSAO)//DTOS(M->DDATALANC)
SX1->(MsUnlock())
Endif
If SX1->(DbSeek(cPerg+Space(2)+'02'))
RecLock('SX1',.F.)
SX1->X1_CNT01 :=  DTOS(SE2->E2_EMISSAO)
SX1->(MsUnlock())
ENDif
If SX1->(DbSeek(cPerg+Space(2)+'03'))
RecLock('SX1',.F.)
SX1->X1_CNT01 :=  SE2->E2_NUM
SX1->(MsUnlock())
ENDif
If SX1->(DbSeek(cPerg+Space(2)+'04'))
RecLock('SX1',.F.)
SX1->X1_CNT01 :=  SE2->E2_NUM
SX1->(MsUnlock())
ENDif
If SX1->(DbSeek(cPerg+Space(2)+'05'))
RecLock('SX1',.F.)
SX1->X1_CNT01 :=  SE2->E2_PORTADO
SX1->(MsUnlock())
ENDif
If SX1->(DbSeek(cPerg+Space(2)+'06'))
RecLock('SX1',.F.)
SX1->X1_CNT01 :=  SE2->E2_PORTADO
SX1->(MsUnlock())
ENDif
SX1->(dbclosearea())
u_CHPAPAOR()
return*/
