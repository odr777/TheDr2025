#Include "Protheus.Ch"
#include "rwmake.ch"
#include "topconn.ch"
#Include "Colors.ch"
#Define BOLD		.T.
#Define ITALIC		.T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ISIMPCH  ³ Autor ³ Nahim Terrazas 		³ Data ³ 10.02.20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna el total de pedidos en tránsito en moneda Bs. (1)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Exclusivo:  Industrias Belén SRL							  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user Function GETTOTCLI(cClient)
	Local aArea    := GetArea()
	Local cNextAlias := GetNextAlias()

	BeginSQL Alias cNextAlias

		SELECT ISNULL(SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN),0) TOTALPD FROM %Table:SC6% SC6
		JOIN %Table:SC5% SC5 ON C6_NUM = C5_NUM AND C5_URECIBO <> '' AND C5_USERIE <> '' AND SC5.D_E_L_E_T_ LIKE ''
		WHERE SC6.D_E_L_E_T_ LIKE '' AND C6_CLI = (%exp:cClient%) AND SC6.C6_BLQ NOT IN ('R')

	EndSQL
	(cNextAlias)->( DbGoTop() )
	nRespuesta := (cNextAlias)->TOTALPD
	(cNextAlias)->( dbCloseArea() )
	if SA1->A1_SALDUP - nRespuesta < 1
		alert("Cliente tiene registrado un anticipo")
	endif
	RestArea(aArea)

RETURN SA1->A1_COND	
