#Include "Rwmake.ch"
#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA550REP ºAutor  ³TOTVS               ºFecha ³ 10/10/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada para imprimir luego de realizar una 	  º±±
±±º          ³ Reposición de caja chica 								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \ Belén                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION FA550REP()
	pergunte("REP010",.f.)
	cPregNah:="REP010"
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPregNah+Space(4)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := SEU->EU_FILIAL
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPregNah+Space(4)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := SEU->EU_FILIAL
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SEU->EU_NUM
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SEU->EU_NUM
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'05'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  dtoc(ddatabase)
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPregNah+Space(4)+'06'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := dtoc(ddatabase)
		SX1->(MsUnlock())
	END

	u_RepCch()

RETURN