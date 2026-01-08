#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ getInPed ³ Autor ³ Nahim Terrazas					  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtiene el total del pedido de venta para mostrarlo visualmente³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GETPEDTOT(cNumPed,cClient)
	Local aArea    := GetArea()
	Local cNextAlias := GetNextAlias()

	BeginSQL Alias cNextAlias
		SELECT
		(SELECT sum(C6_VALOR) TOTVAL
		FROM  %Table:SC6% SC6
		WHERE C6_NUM =(%exp:cNumPed%)  AND C6_CLI = (%exp:cClient%) AND SC6.D_E_L_E_T_!='*'
		group by C6_CLI
		) - C5_DESCONT TOTALMDESC
		FROM  %Table:SC5% SC5
		WHERE C5_NUM = %exp:cNumPed%  AND C5_CLIENTE = %exp:cClient% AND SC5.D_E_L_E_T_!='*'
	EndSQL

	DbSelectArea(cNextAlias) // seleccionar area Area
	cMoedPed := POSICIONE('SC5',1,XFILIAL('SC5')+cNumPed,'C5_MOEDA')
	if cMoedPed == 1
		cMoneda := " Bs."
	else
		cMoneda := " Usd."
	endif
	(cNextAlias)->( DbGoTop() )
	nRespuesta := (cNextAlias)->TOTALMDESC
	(cNextAlias)->( dbCloseArea() )
	RestArea(aArea)

RETURN nRespuesta
