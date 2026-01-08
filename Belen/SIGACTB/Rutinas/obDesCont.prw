#Include "RwMake.ch"
#Include "TopConn.ch"
/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  RPPRE01  ºAutor  ³	Nahim Terrazas			 º 17/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion ³ calcula el descuento por item de cada factura			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Belen SRL			      			                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//					 SD2->D2_PRODUTO	SD2->D2_DOC SD2->D2_SERIE
/*
1 - nDescuento C5_DESC4
2 - nDescuento C5_DESC1
3 - nDescuentoEspecial
*/

User Function obDesCont(nDescuento)

	Local aArea    := GetArea()
	Local cQuerDes		:= getNextAlias()
	local cQuerTem2
	local nRespNt := 0
	If Select("cQuerDes") > 0  //En uso
			(cQuerDes)->(DbCloseArea())
	Endif

	BeginSql alias cQuerDes
		SELECT
		round(C5_DESCONT / C5_UTOTPED * D2_TOTAL,2) DESCONT,
		ROUND((C5_DESC4 * C6_PRUNIT * D2_QUANT / 100) + ((C5_DESC4 * C6_PRUNIT * D2_QUANT / 100)  * C5_DESPESA / C5_UTOTPED),2 ) DESCUENTO4,
		ROUND(((C6_PRUNIT * D2_QUANT) - (C6_PRCVEN * D2_QUANT)) - (((C5_DESC4 * C6_PRUNIT * D2_QUANT / 100)+((C5_DESC4 * C6_PRUNIT * D2_QUANT / 100)  * C5_DESPESA / C5_UTOTPED))),2) DESCUENTO1,C6_NUM,
		ROUND(C6_PRUNIT * D2_QUANT * SC6.C6_DESCONT / 100 ,2) DESCUENTOPRODUCTO,
	   	ROUND(((C6_PRUNIT * D2_QUANT) - ROUND(C6_PRUNIT * D2_QUANT * SC6.C6_DESCONT / 100 ,2)) * C5_DESC1 / 100,2) DESCUENTOMAYORISTA
		FROM %table:SC5% SC5
		JOIN %table:SC6% SC6
		ON SC5.C5_NUM = SC6.C6_NUM
		AND C6_PRODUTO = %exp:SD2->D2_COD%
		AND SC6.D_E_L_E_T_ = ''
		JOIN %table:SD2% SD2
		ON D2_PEDIDO = C6_NUM
		AND D2_ITEMPV = C6_ITEM
		AND D2_ITEM = %exp: SD2->D2_ITEM %
		and	SD2.D_E_L_E_T_ = ''
		WHERE
		D2_DOC = %exp:SD2->D2_DOC%  AND
		D2_SERIE = %exp:SD2->D2_SERIE%
		AND SC5.D_E_L_E_T_ = '' ORDER BY 1,2
	EndSql
	//	cQuery := GetLastQuery()
	//	Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.T.)
		// FACTURACION -DESCUENTO -LINEA     1      
		// FACTURACION -DESCUENTO -MAYORISTA   2      
		// FACTURACION -DESCUENTO -AJUSTE        3  

	dbSelectArea( cQuerDes )

	if nDescuento == 1 // descuento nro 1 // CONSULTA LINEA
		if (cQuerDes)->DESCUENTOPRODUCTO > 0
			nRespNt :=  (cQuerDes)->DESCUENTOPRODUCTO
		else
			nRespNt :=  (cQuerDes)->DESCUENTO4
		endif
	elseif nDescuento == 2 // descuento 2 // descuento mayorista
		// nRespNt :=  (cQuerDes)->DESCUENTO1
		nRespNt :=  (cQuerDes)->DESCUENTOMAYORISTA
	elseif nDescuento == 3 // descuento 3 // descuento especial
		nRespNt :=  (cQuerDes)->DESCONT
	endif

	if  SD2->D2_ITEM == '01' // caso sea el primer item va a calcular la diferencia

		// calculo la suma
		cQuerTem2		:= getNextAlias()
		
		If Select("cQuerTem2") > 0  //En uso
			(cQuerTem2)->(DbCloseArea())
		Endif

		BeginSql alias cQuerTem2
			SELECT sum(
			CASE WHEN DESCUENTO1 < 0 THEN 0   ELSE   DESCUENTO1  end
			 + DESCUENTO4 + DESCONT) SUMADESC
			FROM (
			SELECT 
			round(C5_DESCONT/C5_UTOTPED*D2_TOTAL,2) DESCONT,
			ROUND((C5_DESC4 * C6_PRUNIT * D2_QUANT / 100) + ((C5_DESC4 * C6_PRUNIT * D2_QUANT / 100)  * C5_DESPESA / C5_UTOTPED),2 ) DESCUENTO4,
			ROUND(((C6_PRUNIT * D2_QUANT) - (C6_PRCVEN * D2_QUANT)) - (((C5_DESC4 * C6_PRUNIT * D2_QUANT / 100)+((C5_DESC4 * C6_PRUNIT * D2_QUANT / 100)  * C5_DESPESA / C5_UTOTPED))),2) DESCUENTO1,
			ROUND(C6_PRUNIT * D2_QUANT * SC6.C6_DESCONT / 100 ,2) DESCUENTOPRODUCTO,
			ROUND(((C6_PRUNIT * D2_QUANT) - ROUND(C6_PRUNIT * D2_QUANT * SC6.C6_DESCONT / 100 ,2)) * C5_DESC1 / 100,2) DESCUENTOMAYORISTA

			FROM %table:SC5% SC5
			JOIN %table:SC6% SC6
			ON SC5.C5_NUM = SC6.C6_NUM
			AND SC6.D_E_L_E_T_ = ''
			JOIN %table:SD2% SD2
			ON D2_PEDIDO = C6_NUM
			AND D2_ITEMPV = C6_ITEM
			and	SD2.D_E_L_E_T_ = ''
			WHERE
			D2_DOC = %exp:SD2->D2_DOC%  AND
			D2_SERIE = %exp:SD2->D2_SERIE%

			AND SC5.D_E_L_E_T_ = '') RESUL
			
		EndSql
		dbSelectArea(cQuerTem2 )
		if (cQuerDes)->DESCUENTOPRODUCTO > 0.00 // debo aumentar al 1
			if nDescuento == 1 // caso sea el nro 1 el buscado aumenta la diferencia
				nRespNt -=  ((cQuerTem2)->SUMADESC - SF2->F2_DESCONT) // sumando la diferencia
			endif
		elseif (cQuerDes)->DESCUENTOMAYORISTA > 0.00  // debo aumentar al segundo
			if nDescuento == 2
				nRespNt -= ((cQuerTem2)->SUMADESC - SF2->F2_DESCONT)  // sumando la diferencia
//				alert("diferencia" +  cvaltochar(((cQuerTem2)->SUMADESC - SF2->F2_DESCONT)) + " - "+SF2->F2_DOC)
			endif
		elseif (cQuerDes)->DESCONT > 0.00 // debo aumentar al tercero
			if nDescuento == 3
				nRespNt -= ((cQuerTem2)->SUMADESC - SF2->F2_DESCONT)  // sumando la diferencia
			endif
		ENDIF
		(cQuerTem2)->(DbCloseArea()) //dbCloseArea(cQuerTem2)
	ENDIF
	(cQuerDes)->(DbCloseArea()) //dbCloseArea( cQuerDes )
	RestArea(aArea)
IF nRespNt <> 0
	conout(nRespNt)
//	cNahim := "salkm"
endif

return nRespNt
