#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTBASE ³ Autor ³	Query	: Nahim Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Movimiento Por Periodo() Nahim Terrazas   					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MovxPer()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mercantil Leon SRL											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³24/08/2016³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function MovxPer()
	Local oReport
	PRIVATE cPerg   := "MOVIXPER"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oSection2
	Local oBreak
	Local NombreProg := "MOVIMIENTO POR PERIODO"

	oReport	 := TReport():New("MovxPer",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"MOVIMIENTO POR PERIODO")
	oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera
// oReport:lPrtParamPage = .F.

	oSection := TRSection():New(oReport,"SB1",{"SB1"})
// oSection2:= TRSection():New(oSection,"SB1",{"SB1"}) //"Carga"
	oSection2 := TRSection():New(oReport,"SB1",{"SB1"})
// oReport:SetTotalInLine(.F.)
/*                                                 
TRCell():New(oSection,"D2_COD"		,"SD2","Prod.",,10)
TRCell():New(oSection,"A3_NOME"		,"SA3","Vended.",,10) 
*/
//		Comienzan a elegir los campos que desean Mostrar
	oSection:SetHeaderPage()
	oSection2:SetHeaderPage()

// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
// Codigo	Descr.Espec.	Un.	Grupo	Cant. Ini.	    Cant. Fin.			Ventas   seccion 1
//			 	                        Cant.Ult.Compra	Fecha Ult. Comp	          	 seccion 2
	TRCell():New(oSection,"B1_COD"	,"SB1")
	TRCell():New(oSection,"B1_ESPECIF"	,"SB1")
	TRCell():New(oSection,"B1_UCODFAB"	,"SB1")
	TRCell():New(oSection,"B1_UM"		,"SB1")
	TRCell():New(oSection,"B1_GRUPO"	,"SB1")
	TRCell():New(oSection,"BI_CANT","SB1","Cant. Ini.")
	TRCell():New(oSection,"BI_CANTF","SB1","Cant. Fin.")
	TRCell():New(oSection,"B1_VENTAS","SB1","VENTAS")
	TRCell():New(oSection,"cantPedidos","SB1","Pedido de Venta")


	TRCell():New(oSection2,"VACIO"	,"SB1","         ",PesqPict("SB1","B1_COD") ,TamSx3("B1_COD")[1])
	TRCell():New(oSection2,"B1_UESPEC2"	,"SB1")
	TRCell():New(oSection2,"VACIO"	,"SB1","         ",PesqPict("SB1","B1_UM") ,TamSx3("B1_UM")[1])
	TRCell():New(oSection2,"VACIO"	,"SB1","         ",PesqPict("SB1","B1_GRUPO") ,TamSx3("B1_GRUPO")[1])
	TRCell():New(oSection2,"CANTULTC"		,"SB1","Cant.Ult.Compra")
	TRCell():New(oSection2,"UFecha"		,"SB1","Fecha Ult. Comp",PesqPict("SD1","D1_EMISSAO") ,)
	TRCell():New(oSection2,"PREVENT","SB1","Prevista Entrada")

	oSection2:Cell("CANTULTC"):SetLineBreak()
Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local aArea       := GetArea()
	Local aDatos      := {}
	Local cAliasQry   := GetNextAlias()
	Local cQry        := ""
	Local nCont       := 0
	//Local oSection2 := oReport:Section(1):Section(1)
	Local cFiltro  := ""

	#IFDEF TOP
		// cambios Nahim 29/03 aumento de Columna Prevista entrada
		cQry = "SELECT B1_UCODFAB,B1_COD,B1_ESPECIF,B1_UM,B1_UESPEC2,B1_GRUPO,ISNULL(J.UFECHA,'0') AS UFECHA,ISNULL(A.TOTAL,0) AS VENTAS,ISNULL(C.CANTULCOMPRA,0) AS" + CRLF
		cQry += "CANTULTC,ISNULL(W.CANTPEDIDO,0) AS CANTPEDIDOS,ISNULL(S.PREENT,0) AS PREVENT FROM" + RetSqlName("SB1") + " SB1 left join  "+ CRLF
		cQry += "(SELECT D2_COD,SUM(D2_QUANT) AS TOTAL FROM " + RetSqlName("SD2") + " SD2 WHERE  "+ CRLF
		cQry += "D2_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' AND D2_ESPECIE = 'NF' AND D_E_L_E_T_ = ' ' GROUP BY D2_COD)  A "+ CRLF
		cQry += "on A.D2_COD = B1_COD  " + " left join" + CRLF
		cQry += "(SELECT A.C7_PRODUTO,SUM(C7_QUANT) AS CANTULCOMPRA FROM " + RetSqlName("SC7") + " SC7 , (SELECT C7_PRODUTO,MAX(R_E_C_N_O_) AS UFECHA "+ CRLF
		cQry += "FROM " + RetSqlName("SC7") + " SC7 WHERE  D_E_L_E_T_ = ' ' GROUP BY C7_PRODUTO)  A WHERE  R_E_C_N_O_ = UFECHA AND SC7.C7_PRODUTO = "+ CRLF
		cQry += "A.C7_PRODUTO GROUP BY A.C7_PRODUTO)  C "+ CRLF
		cQry += "on C.C7_PRODUTO = B1_COD left join"
		cQry += "(SELECT C7_PRODUTO,MAX(C7_EMISSAO) AS UFECHA FROM " + RetSqlName("SC7") + " SC7 WHERE  "+ CRLF
		cQry += "D_E_L_E_T_ = ' ' GROUP BY C7_PRODUTO)  AS J "+ CRLF
		cQry += "on J.C7_PRODUTO = B1_COD left join "
		cQry += " (SELECT C7_PRODUTO,sum(C7_QUANT-C7_QUJE) AS PREENT " + CRLF
		cQry += " FROM " + RetSqlName("SC7") + " SC7  " + CRLF
		cQry += " WHERE  D_E_L_E_T_ = ' ' GROUP BY C7_PRODUTO) as S " + CRLF
		cQry += "on S.C7_PRODUTO = B1_COD left join"
		cQry += "(SELECT C9_PRODUTO,SUM(C9_QTDLIB) AS CANTPEDIDO FROM " + RetSqlName("SC9") + " SC9 WHERE  "+ CRLF
		cQry += "D_E_L_E_T_ = ' ' GROUP BY C9_PRODUTO) "+ CRLF
		cQry += "AS W on W.C9_PRODUTO = B1_COD"
		cQry += " where SB1.D_E_L_E_T_ = ' ' AND B1_GRUPO = '" + cvaltochar(MV_PAR03) + "'" "
		cQry += " order by VENTAS desc"

		cQry := ChangeQuery(cQry)

		cQuery:= cQry

		Aviso("query",cvaltochar(cQuery),{"si"})

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cAliasQry, .F., .T.)
		dbSelectArea(cAliasQry)
		dbGoTop()

		oSection:Init()
		oSection2:Init()
//MemoWrite("\query_ocp.sql",cQuery) esta funcion te crea un archivo con el nombre que pongas en el parametro
//	oSection2:PrintLine()

		While (cAliasQry)->(! EOF())
			nCont ++

			oSection:Cell("B1_COD"):SetValue( (cAliasQry)->B1_COD )
			oSection:Cell("B1_ESPECIF"):SetValue( (cAliasQry)->B1_ESPECIF )
			oSection:Cell("B1_UCODFAB"):SetValue( (cAliasQry)->B1_UCODFAB )
			oSection:Cell("B1_UM"):SetValue( (cAliasQry)->B1_UM )
			oSection:Cell("B1_GRUPO"):SetValue( (cAliasQry)->B1_GRUPO )
			oSection:Cell("B1_VENTAS"):SetValue( (cAliasQry)->VENTAS )
			oSection:Cell("cantPedidos"):SetValue( (cAliasQry)->cantPedidos )
			nCantIni := 0
			nCantFin := 0
			bArea := GetArea()

			// calcula los saldos
			dbSelectArea("NNR")
			dbgotop()
			While !Eof() .And. NNR->NNR_FILIAL = xFilial("NNR")
				nCantIni := nCantIni + CalcEst((cAliasQry)->B1_COD,NNR->NNR_CODIGO,MV_PAR01)[1]
				nCantFin := nCantFin + CalcEst((cAliasQry)->B1_COD,NNR->NNR_CODIGO,MV_PAR02)[1]
				dbskip()
			endDo
			dbclosearea("NRR")

			RestArea(bArea)

			dbSelectArea(cAliasQry)

// Asigna Valores a los Campos
			oSection:Cell("BI_CANT"):SetValue(nCantIni)
			oSection:Cell("BI_CANTF"):SetValue(nCantFin)
			oSection:PrintLine()

			oSection2:Cell("B1_UESPEC2"):SetValue( (cAliasQry)->B1_UESPEC2 )
			oSection2:Cell("CANTULTC"):SetValue( (cAliasQry)->CANTULTC ) // cantidad ultima compra
			if (cAliasQry)->UFecha == "0"
				//  oSection2:Cell("UFecha"):SetValue( DtoC(StoD((cAliasQry)->UFecha)))
			else
				oSection2:Cell("UFecha"):SetValue( DtoC(StoD((cAliasQry)->UFecha)))
			endif
			oSection2:Cell("PREVENT"):SetValue((cAliasQry)->PREVENT)

			oSection2:PrintLine()

			// return
			dbSkip()
		EndDo
		oSection:Finish()
		oSection2:Finish()
	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
//	oSection:EndQuery()
		//oSection2:SetParentQuery()
	#ELSE
		//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF
// oSection2:Printline()
// oSection:Print()


Return

Static Function CriaSX1(cPerg)  // Crear Preguntas

/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
especificaciones, 
*/
// Los "mv_parEtc" son los nombres con los cuales llamamos a las preguntas en el Query, seria los datos que ingresamos
// Cuando en el reporte ponemos la opcion (Parametros) por lo tanto es obligatorio Usar Preguntas si el Reporte esta
// En el menú, si el reporte no esta en el menú podemos llamar al campo y se obtienen los datos de donde esta posicionado


	PutSX1(cPerg,"01","¿De Fecha?" , "¿De Fecha?","¿De Fecha?","MV_CH1","D",08,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,""   ,"")
	PutSX1(cPerg,"02","¿A Fecha?" , "¿A Fecha?","¿A Fecha?","MV_CH2","D",08,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,""   ,"")
	PutSX1(cPerg,"03","¿Grupo?", "¿Grupo?","¿Grupo?","MV_CH3","C",4,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,"SBM","")
return


Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica

	Local aArea          := GetArea()
	Local aCabec     := {}
	Local cChar          := chr(160) // caracter dummy para alinhamento do cabeçalho
	Local cChar2          := chr(80) // caracter dummy para alinhamento do cabeçalho
	Local titulo     := oReport:Title()
	Local page := oReport:Page()

	aCabec := {     "__LOGOEMP__" ,cChar + "        " + cChar ;
		, " " + " " + "        " + cChar + UPPER(AllTrim(titulo)) + "        " + cChar ;
		, "Fecha Inicial: "+ cvaltochar(mv_par01) + "          " + cChar + "Fecha: "+ Dtoc(dDataBase)+ cChar  ;
		, "Fecha Final: "+ cvaltochar(mv_par02) +   "          " +  "Grupo: "+ cvaltochar(mv_par03) ;
		, "Depósito: **" + "          " +  "Usuario: " + substr(cUsuario,7,15) ;
		, "      " + "          " +  "      "}
	RestArea( aArea )
Return aCabec
