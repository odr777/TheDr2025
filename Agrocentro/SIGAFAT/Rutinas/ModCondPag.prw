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

User Function MODCONPAG(cCondpag,cClient,cLoja)
	Local aArea    := GetArea()
	Local cResp:=""
/*
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
*/
	//DbSelectArea(cNextAlias) // seleccionar area Area
	cCond := POSICIONE("SA1",1,XFILIAL("SA1")+cClient+cLoja,"A1_COND")	
	if cCondpag <= cCond
		//Alert("OK")
		cResp=cCondpag
	else
		Alert("Solo es permitido seleccionar una Condición de Pago menor")
		cResp=cCond
	endif
	/*(cNextAlias)->( DbGoTop() )
	nRespuesta := (cNextAlias)->TOTALMDESC
	(cNextAlias)->( dbCloseArea() )
	RestArea(aArea)
*/
RETURN cResp
