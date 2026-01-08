#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Punto de entrada³ F087ABXOK ³ Autor 			Nahim Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripción ³Punto de entrada que valida que no se pueda utilizar un RA	³±±
±± Que tenga un RA Relacionado												 ±±
±±³Sintaxe   ³ F087ABXOK()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Industrias Belén	SRL											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³23/10/2019³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

user function F087ABXOK()
	Local aArea    := GetArea()
	Local cNextAlias := GetNextAlias()
	local lPasaRA := .T.
	//ALERT("F087ABXOK")
	//ALERT("F087ABXOK")
	//	ALERT(alinSE1[oLBSE1:nAt][(AScan(aCposSE1,"E1_NUM"))])
	BeginSQL Alias cNextAlias
		SELECT C5_NUM,SE1DEUDA.E1_NUM FROM %Table:SE1% SE1
		JOIN %Table:SEL% SEL ON SE1.E1_FILIAL = EL_FILIAL AND SE1.E1_NUM = EL_RECIBO AND SE1.E1_CLIENTE = EL_CLIENTE
		AND EL_PARCELA = SE1.E1_PARCELA
		AND EL_LOJA = E1_LOJA AND EL_TIPO = E1_TIPO AND SEL.D_E_L_E_T_ LIKE ''
		AND SE1.E1_EMISSAO = SEL.EL_EMISSAO
		JOIN %Table:SC5% SC5 ON SC5.C5_URECIBO = SEL.EL_RECIBO AND SC5.C5_USERIE = SEL.EL_SERIE AND 
		(SC5.D_E_L_E_T_ <> '' OR SC5.C5_NOTA <> '')
		LEFT JOIN %Table:SE1% SE1DEUDA ON
		SE1DEUDA.E1_NUM = SC5.C5_NOTA AND SE1DEUDA.E1_PREFIXO = SC5.C5_SERIE AND SE1DEUDA.D_E_L_E_T_ LIKE '' 
		AND SE1DEUDA.E1_SALDO > 1 AND SE1DEUDA.D_E_L_E_T_ LIKE ''
		WHERE SE1.E1_NUM LIKE %exp:alinSE1[oLBSE1:nAt][(AScan(aCposSE1,"E1_NUM"))]%
		AND SE1.E1_CLIENTE = %exp:alinSE1[oLBSE1:nAt][(AScan(aCposSE1,"E1_CLIENTE"))]%
		AND SE1.E1_PARCELA = %exp:alinSE1[oLBSE1:nAt][(AScan(aCposSE1,"E1_PARCELA"))]%
		AND SE1.D_E_L_E_T_ LIKE ''
		GROUP BY C5_NUM,SE1DEUDA.E1_NUM
	EndSQL

	cQuery:=GetLastQuery()
//	Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.T.) //  usar este en esste caso cuando es BEGIN SQL

	DbSelectArea(cNextAlias) // seleccionar area Area
	(cNextAlias)->( DbGoTop() )
	if !(cNextAlias)->(eof()) // si está vacio signfica que Ok.
		//		alert("OK")
		While !(cNextAlias)->(eof()) .and. cSerie != 'CMP' // siempre que no sea compensación.
			alert("RA está relacionado con el Pedido: " + (cNextAlias)->C5_NUM + ", si desea utilizarlo es necesario eliminar el pedido por residuo")
			(cNextAlias)->(dbskip())
			lPasaRA := .F.
		enddo
	endif

	(cNextAlias)->( dbCloseArea() )
	RestArea(aArea)
return lPasaRA