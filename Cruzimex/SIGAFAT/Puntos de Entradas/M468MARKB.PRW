#INCLUDE "PROTHEUS.CH"
/**********************************************************************
* BELEN	18-12-2018					 Autor: Nahim Terrazas
--------------------------------------------------------------------
No permite seleccionar el pedido si no tiene un RA 
----------------------------------------------------------------------*/

USER FUNCTION M468MARKB()

	Local nRecord := RecNo()
	Local lRet	 	:=.T.
	Local cFormFat	:= ""
	Local cMarca := ThisMark()
	Local cNumCnt := ""
	Local cNumMed := ""
	Local cNumPla := ""
	Local cNumRev := ""
	Local cAliasOri := Alias()
	Local aArea := GetArea()
	Local aAreaCND := CND->(GetArea())
	Local aAreaCNA := CNA->(GetArea())
	Local lHayPedido := Type('lPedidos') == 'L' .and. lPedidos

	//If lHayPedido
	//	cNumCnt := Posicione("SC5",1,xFilial("SC5")+TRB->C9_PEDIDO,"C5_MDCONTR")
	//	cNumMed := Posicione("SC5",1,xFilial("SC5")+TRB->C9_PEDIDO,"C5_MDNUMED")
	//	cNumPla := Posicione("SC5",1,xFilial("SC5")+TRB->C9_PEDIDO,"C5_MDPLANI")
	//	nMoedOri := Posicione("SC5",1,xFilial("SC5")+TRB->C9_PEDIDO,"C5_MOEDA")
	//	dFechaEnt := TRB->C9_DATENT
	//Else
	//	cNumCnt := TRB->D2_XCONTRA
	//	If Empty(cNumCnt)
	//		cNumCnt := Posicione("SC5",1,xFilial("SC5")+TRB->D2_PEDIDO,"C5_MDCONTR")
	//	EndIf
	//	cNumMed := TRB->D2_XMEDICI
	//	If Empty(cNumMed)
	//		cNumMed := Posicione("SC5",1,xFilial("SC5")+TRB->D2_PEDIDO,"C5_MDNUMED")
	//    EndIf
	//	cNumPla := TRB->D2_XPLANIL
	//	If Empty(cNumPla)
	//		cNumPla := Posicione("SC5",1,xFilial("SC5")+TRB->D2_PEDIDO,"C5_MDPLANI")
	//	EndIf
	//	nMoedOri := Posicione("SC5",1,xFilial("SC5")+SD2->D2_PEDIDO,"C5_MOEDA")
	//	dFechaEnt := Posicione("SC9",1,xFilial("SC5")+TRB->(D2_PEDIDO+D2_ITEMPV),"C9_DATENT")
	//EndIf

	//	alert(TRB->C9_PEDIDO)
	cTemp:= getNextAlias()
	BeginSql alias cTemp
		Select
		sum(EL_VLMOED1) SUMVAL,EL_UPV
		from
		%table:SEL% SEL
		where
		SEL.%notDel%
		and EL_UPV = %exp:TRB->C9_PEDIDO%
		GROUP BY EL_UPV
	EndSql
	dbSelectArea( cTemp )
	(cTemp)->(dbGotop())
	ntotal := (cTemp)->SUMVAL // suma en Bs delpago

	cPedidosQ:= getNextAlias()
	BeginSql alias cPedidosQ
		SELECT DISTINCT C5_FILIAL,C5_NUM,C5_CLIENTE,C5_EMISSAO,C5_CONDPAG,
		C5_LIBEROK, C5_NOTA, C5_BLQ,
		(SELECT
		CASE
		WHEN C5_MOEDA > 1
		THEN SUM(SC62.C6_VALOR) * C5_TXMOEDA
		ELSE SUM(SC62.C6_VALOR)
	END AS TOTAL
	FROM %table:SC6% SC62 WHERE SC62.C6_NUM = SC5.C5_NUM AND SC62.%notDel%) TOTAL,
	C5_TXMOEDA,C5_MOEDA
	FROM %table:SC5% SC5
	JOIN %table:SC6% SC6 ON C5_NUM=C6_NUM and C5_FILIAL=C6_FILIAL
	WHERE
	C5_NUM = %exp:TRB->C9_PEDIDO%
	EndSql
	dbSelectArea( cPedidosQ )
	(cPedidosQ)->(dbGotop())
	ntotPedido := (cPedidosQ)->TOTAL // suma en Bs del pedido

	if ntotal < ntotPedido // si el total del pago es menor
//		alert(ntotal)
//		alert(ntotPedido)
		alert("El pedido no tiene RA")
		lRet := .f.
	endif

Return(lRet)