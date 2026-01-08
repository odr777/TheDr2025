#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ getInPed ³ Autor ³ Nahim Terrazas					  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³indica si el valor del pedido total es correcto 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function getInPed(cNumPed,cClient,nTotal)
	Local aArea    := GetArea()
	Local cNextAlias := GetNextAlias()
	local lPasaRA := .T.
	BeginSQL Alias cNextAlias
		SELECT C6_CLI,sum(C6_VALOR) TOTVAL
		FROM  %Table:SC6% SC6
		WHERE C6_NUM IN (%exp:cNumPed%)  AND C6_CLI = %exp:cClient% AND SC6.D_E_L_E_T_!='*'
		group by C6_CLI
	EndSQL

	DbSelectArea(cNextAlias) // seleccionar area Area
	cMoedPed := POSICIONE('SC5',1,XFILIAL('SC5')+cNumPed,'C5_MOEDA')
	if cMoedPed == 1
		cMoneda := " Bs."
	else
		cMoneda := " Usd."
	endif
	(cNextAlias)->( DbGoTop() )

	if nTotal <> nil .and. !empty(cNumPed) .and. !empty(cMoedPed)
		// si el monto menor según el parámetro
		nDiferencia := SuperGetMV("MV_MAXDIFA", NIL, "0" )
		//		if nTotal <> (cNextAlias)->TOTVAL
		if nTotal + nDiferencia <= (cNextAlias)->TOTVAL
			alert("El valor ("+cvaltochar(ntotal) + ") es menor al de los pedidos seleccionados - " + cvaltochar(TOTVAL) + " " + cMoneda)
			//			lPasaRA := .f. // nahim deja pasar
			public lBloqueoRegla := .T.
		else
			lBloqueoRegla := NIL
			FreeObj(lBloqueoRegla)
		endif
	endif
	(cNextAlias)->( dbCloseArea() )
	RestArea(aArea)

RETURN lPasaRA
