/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Punto E.  ¦    ¦ Autor ¦ Nahim Terrazas ¦ Data ¦ 28.11.19 	  ¦¦¦
¦¦¦----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ P.E  permite incluir novas linhas na tela de consulta à Posiçao de Clientes	  ¦¦¦
¦¦+. O ponto de entrada é executado após clicar no botão Consultar da rotina FINC010.		  +¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function FC010LIST()

	Local aCols := paramixb
	// adicionando saldo disponible
	nTotalEnPedido := 	GETTOTCLI2(SA1->A1_COD)
	//debería sumar al disponible porque ya vendió más
	//	cValSald := StrTran( "4.396,04", ".", "" )
	cValSald := StrTran( aCols[2][2], ",", "" )
//	cValSald := StrTran( aCols[2][2], ".", "" ) // PRD
//	cValSald := StrTran(cValSald,".",",")
	nDisponible := val(cValSald) + nTotalEnPedido // tra en bs.
	
	// Saldo utilizado Belén 15/01/2020
	// preparando datos
	cSald := 	StrTran( alltrim(aCols[1][2]),",", "" )
	nSaldoLinea := val(cSald)
	// utilizado Real
	Aadd(aCols,{"Saldo Utilizado LC",TRansform(Round(Noround(nDisponible,2),MsDecimais(1)),PesqPict("SA1","A1_MSALDO",14,1)),;
	TRansform(xMoeda(nDisponible,1,2),PesqPict("SA1","A1_MSALDO",14,1))," ","-","-"})
	// Saldo disponible de la línea de crédito  NTP 15/01/2020
	Aadd(aCols,{"Saldo Disponible", TRansform(Round(Noround(nSaldoLinea - nDisponible,2),MsDecimais(1)) ,PesqPict("SA1","A1_MSALDO",14,1)),;
	TRansform(xMoeda(nSaldoLinea - nDisponible,1,2),PesqPict("SA1","A1_MSALDO",14,1))," ","-","-"})
	
Return aCols

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ getInPed ³ Autor ³ Nahim Terrazas					  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Obtiene el total los pedido de ventas 						³±±
±±		      comprometidos con el cliente 								  ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function GETTOTCLI2(cClient)
	Local aArea    := GetArea()
	Local cNextAlias := GetNextAlias()

	BeginSQL Alias cNextAlias

		SELECT ISNULL(SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN),0) TOTALPD FROM %Table:SC6% SC6
		JOIN %Table:SC5% SC5 ON C6_NUM = C5_NUM AND C5_URECIBO <> '' AND C5_USERIE <> '' AND SC5.D_E_L_E_T_ LIKE ''
		WHERE SC6.D_E_L_E_T_ LIKE '' AND C6_CLI = (%exp:cClient%) AND SC6.C6_BLQ NOT IN ('R')

	EndSQL

	//	DbSelectArea(cNextAlias) // seleccionar area Area
	//	cMoedPed := POSICIONE('SC5',1,XFILIAL('SC5')+cNumPed,'C5_MOEDA')
	//	if cMoedPed == 1
	//		cMoneda := " Bs."
	//	else
	//		cMoneda := " Usd."
	//	endif
	(cNextAlias)->( DbGoTop() )
	nRespuesta := (cNextAlias)->TOTALPD
	(cNextAlias)->( dbCloseArea() )
	RestArea(aArea)

RETURN nRespuesta
