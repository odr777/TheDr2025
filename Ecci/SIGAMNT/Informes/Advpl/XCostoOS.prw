#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE NFHORA	1	//Formato Hora
#DEFINE NFNUM	2	//Formato Numérico
#DEFINE NFBD	3	//Formato Base de datos

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ XCostoOS ³ Autor ³ Denar Terrazas							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de costos de las Órdenes de Servicio - SIGAMNT   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ XCostoOS()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Global - SIGAMNT												³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³22/02/2021													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function XCostoOS()
	Local oReport
	PRIVATE cPerg   := "XCostoOS"   // elija el Nombre de la pregunta

	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)

	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "Órden de Servicios"

	oReport	 := TReport():New("XCostoOS",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Informe costos Órden de Servicios")

	oSection := TRSection():New(oReport,"Órden de Servicios",{"SPL"})
	oReport:SetTotalInLine(.T.)

	//Comienzan a elegir los campos que desean Mostrar
	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"TJ_ORDEM"	,"STJ","NRO. ORDEN DE SERV.")
	TRCell():New(oSection,"TJ_CODBEM"	,"STJ","COD. BIEN")
	TRCell():New(oSection,"T9_NOME"		,"ST9","DESC. BIEN")
	TRCell():New(oSection,"TJ_DTORIGI"	,"STJ","FECHA ORIGINAL")
	TRCell():New(oSection,"TJ_DTMRINI"	,"STJ","FECHA REAL INICIAL")
	TRCell():New(oSection,"TJ_DTMRFIM"	,"STJ","FECHA REAL FINAL")
	TRCell():New(oSection,"TL_TIPOREG"	,"STL","TIPO INSUMO")
	TRCell():New(oSection,"TL_CODIGO"	,"STL","CÓDIGO")
	TRCell():New(oSection,"DESCCOD"		,"STL","DESC. CÓDIGO")
	TRCell():New(oSection,"TT9_UCDARE"	,"TT9","COD. ÁREA MNT.")
	TRCell():New(oSection,"TD_NOME"		,"STD","DESC. ÁREA MNT.")
	TRCell():New(oSection,"TL_TAREFA"	,"STL","COD. TAREA")
	TRCell():New(oSection,"TT9_DESCRI"	,"TT9","DESC. TAREA")
	TRCell():New(oSection,"TL_QUANTID"	,"STL","CANTIDAD")
	TRCell():New(oSection,"TL_UNIDADE"	,"STL","UNIDAD")
	TRCell():New(oSection,"TL_CUSTO"	,"STL","COSTO")
	TRCell():New(oSection,"TE_TIPOMAN"	,"STE","TIPO MNT.")
	TRCell():New(oSection,"TE_NOME"		,"STE","DESC. TIPO MNT.")
	TRCell():New(oSection,"ESTADO"		,"STL","ESTADO")

Return oReport

Static Function PrintReport(oReport)
	Local oSection	:= oReport:Section(1)
	Local cAliasQry	:= GetNextAlias()
	Local cQuery	:= ""
	Local cFiltro	:= "" //Utilizado en el query para los insumos

	//Parametros
	Local cDeOS		:= MV_PAR01
	Local cAOS		:= MV_PAR02
	Local cDeCC		:= MV_PAR03
	Local cACC		:= MV_PAR04
	Local cDeFchMnt	:= MV_PAR05
	Local cAFchMnt	:= MV_PAR06
	Local cDeBien	:= MV_PAR07
	Local cABien	:= MV_PAR08
	Local nConsP	:= MV_PAR09 // Considera Producto (P)?
	Local cDeProd	:= MV_PAR10
	Local cAProd	:= MV_PAR11
	Local nConsH	:= MV_PAR12 // Considera Herramienta (F)?
	Local cDeHerr	:= MV_PAR13
	Local cAHerr	:= MV_PAR14
	Local nConsE	:= MV_PAR15 // Considera Especialidad (E)?
	Local cDeEspec	:= MV_PAR16
	Local cAEspec	:= MV_PAR17
	Local nConsM	:= MV_PAR18 // Considera Mano de Obra (M)?
	Local cDeManoOb	:= MV_PAR19
	Local cAManoOb	:= MV_PAR20
	Local nConsT	:= MV_PAR21 // Considera Terceros (T)?
	Local cDeTercer	:= MV_PAR22
	Local cATercer	:= MV_PAR23
	Local cDeAreaMnt:= MV_PAR24
	Local cAAreaMnt	:= MV_PAR25
	Local cDeTarea	:= MV_PAR26
	Local cATarea	:= MV_PAR27
	Local cDeProved	:= MV_PAR28
	Local cAProved	:= MV_PAR29
	Local cDeTienda	:= MV_PAR30
	Local cATienda	:= MV_PAR31

	#IFDEF TOP

		cQuery+= " SELECT STJ.TJ_ORDEM, STJ.TJ_CCUSTO,"
		cQuery+= " STJ.TJ_CODBEM, (SELECT T9_NOME FROM " + RetSqlName("ST9") + " WHERE D_E_L_E_T_ = ' ' AND T9_FILIAL = STJ.TJ_FILIAL AND T9_CODBEM = STJ.TJ_CODBEM) AS T9_NOME,"
		cQuery+= " STJ.TJ_DTORIGI, TJ_DTMRINI, TJ_DTMRFIM,"
		cQuery+= " STL.TL_TIPOREG, STL.TL_CODIGO,"
		cQuery+= " TT9.TT9_UCDARE, (SELECT TD_NOME FROM " + RetSqlName("STD") + " WHERE D_E_L_E_T_ = ' ' AND TD_FILIAL = STL.TL_FILIAL AND TD_CODAREA = TT9.TT9_UCDARE) AS TD_NOME,"
		cQuery+= " STL.TL_TAREFA, TT9.TT9_DESCRI,"
		cQuery+= " STL.TL_QUANTID, STL.TL_UNIDADE, STL.TL_CUSTO,"
		cQuery+= " STE.TE_TIPOMAN, STE.TE_NOME,"
		cQuery+= " CASE"
		cQuery+= " 	WHEN STL.TL_REPFIM = 'S' THEN 'EJECUTADO'"
		cQuery+= " 	WHEN STL.TL_REPFIM = ' ' THEN 'PREVISTO'"
		cQuery+= " END AS ESTADO"
		cQuery+= " FROM " + RetSqlName("STJ") + " STJ"
		cQuery+= " JOIN " + RetSqlName("STL") + " STL ON STJ.TJ_FILIAL = STL.TL_FILIAL AND  STJ.TJ_ORDEM = STL.TL_ORDEM AND STJ.TJ_PLANO = STL.TL_PLANO"
		cQuery+= " JOIN " + RetSqlName("TT9") + " TT9 ON TT9.TT9_FILIAL = STL.TL_FILIAL AND TT9.TT9_TAREFA = STL.TL_TAREFA"
		cQuery+= " LEFT JOIN " + RetSqlName("ST4") + " ST4 ON STJ.TJ_FILIAL = ST4.T4_FILIAL AND STJ.TJ_SERVICO = ST4.T4_SERVICO AND ST4.D_E_L_E_T_ = ' '"
		cQuery+= " LEFT JOIN " + RetSqlName("STE") + " STE ON ST4.T4_FILIAL = STE.TE_FILIAL AND ST4.T4_TIPOMAN = STE.TE_TIPOMAN AND STE.D_E_L_E_T_ = ' '"
		cQuery+= " WHERE STJ.D_E_L_E_T_ = ' '"
		cQuery+= " AND STL.D_E_L_E_T_ = ' '"
		cQuery+= " AND TT9.D_E_L_E_T_ = ' '"
		cQuery+= " AND STJ.TJ_ORDEM BETWEEN '" + cDeOS + "' AND '" + cAOS + "'"
		cQuery+= " AND STJ.TJ_CCUSTO BETWEEN '" + cDeCC + "' AND '" + cACC + "'"
		cQuery+= " AND"
		cQuery+= " 	(CASE "
		cQuery+= " 		WHEN STJ.TJ_SITUACA IN ('L', 'S') THEN STJ.TJ_DTMPINI"
		cQuery+= " 		ELSE STJ.TJ_DTMRFIM"
		cQuery+= " 	END)"
		cQuery+= " BETWEEN '" + DTOS(cDeFchMnt) + "' AND '" + DTOS(cAFchMnt) + "'"
		cQuery+= " AND STJ.TJ_CODBEM BETWEEN '" + cDeBien + "' AND '" + cABien + "'"

		//Filtro para los INSUMOS
		If(nConsP == 1 .AND. nConsH == 1 .AND. nConsE == 1 .AND. nConsM == 1 .AND. nConsT == 1)
			If(nConsP == 1)
				cFiltro:= "(STL.TL_TIPOREG = 'P' AND STL.TL_CODIGO BETWEEN '" + cDeProd + "' AND '" + cAProd + "')"
			EndIf

			If(nConsH == 1)
				If(EMPTY(ALLTRIM(cFiltro)))
					cFiltro:= "(STL.TL_TIPOREG = 'F' AND STL.TL_CODIGO BETWEEN '" + cDeHerr + "' AND '" + cAHerr + "')"
				Else
					cFiltro+= "OR (STL.TL_TIPOREG = 'F' AND STL.TL_CODIGO BETWEEN '" + cDeHerr + "' AND '" + cAHerr + "')"
				EndIf
			EndIf

			If(nConsE == 1)
				If(EMPTY(ALLTRIM(cFiltro)))
					cFiltro:= "(STL.TL_TIPOREG = 'E' AND STL.TL_CODIGO BETWEEN '" + cDeEspec + "' AND '" + cAEspec + "')"
				Else
					cFiltro+= "OR (STL.TL_TIPOREG = 'E' AND STL.TL_CODIGO BETWEEN '" + cDeEspec + "' AND '" + cAEspec + "')"
				EndIf
			EndIf

			If(nConsM == 1)
				If(EMPTY(ALLTRIM(cFiltro)))
					cFiltro:= "(STL.TL_TIPOREG = 'M' AND STL.TL_CODIGO BETWEEN '" + cDeManoOb + "' AND '" + cAManoOb + "')"
				Else
					cFiltro+= "OR (STL.TL_TIPOREG = 'M' AND STL.TL_CODIGO BETWEEN '" + cDeManoOb + "' AND '" + cAManoOb + "')"
				EndIf
			EndIf

			If(nConsT == 1)
				If(EMPTY(ALLTRIM(cFiltro)))
					cFiltro:= "(STL.TL_TIPOREG = 'T' AND STL.TL_CODIGO BETWEEN '" + cDeTercer + "' AND '" + cATercer + "')"
				Else
					cFiltro+= "OR (STL.TL_TIPOREG = 'T' AND STL.TL_CODIGO BETWEEN '" + cDeTercer + "' AND '" + cATercer + "')"
				EndIf
			EndIf

			cFiltro:= " AND (" + cFiltro + ")"

			// Debería quedar de la siguiente manera:
			// (
			// (STL.TL_TIPOREG = 'P' AND STL.TL_CODIGO BETWEEN '' AND 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ') OR
			// (STL.TL_TIPOREG = 'F' AND STL.TL_CODIGO BETWEEN '' AND 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ') OR
			// (STL.TL_TIPOREG = 'E' AND STL.TL_CODIGO BETWEEN '' AND 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ') OR
			// (STL.TL_TIPOREG = 'M' AND STL.TL_CODIGO BETWEEN '' AND 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ') OR
			// (STL.TL_TIPOREG = 'T' AND STL.TL_CODIGO BETWEEN '' AND 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ')
			// )

		EndIf
		cQuery+= cFiltro

		//Si NO se toman encuenta los insumos
		If(nConsP <> 1)
			cQuery+= " AND STL.TL_TIPOREG <> 'P'"
		EndIf
		If(nConsH <> 1)
			cQuery+= " AND STL.TL_TIPOREG <> 'F'"
		EndIf
		If(nConsE <> 1)
			cQuery+= " AND STL.TL_TIPOREG <> 'E'"
		EndIf
		If(nConsM <> 1)
			cQuery+= " AND STL.TL_TIPOREG <> 'M'"
		EndIf
		If(nConsT <> 1)
			cQuery+= " AND STL.TL_TIPOREG <> 'T'"
		EndIf

		cQuery+= " AND TT9.TT9_UCDARE BETWEEN '" + cDeAreaMnt + "' AND '" + cAAreaMnt + "'"
		cQuery+= " AND STL.TL_TAREFA BETWEEN '" + cDeTarea + "' AND '" + cATarea + "'"

		cQuery+= " AND STL.TL_FORNEC BETWEEN '" + cDeProved + "' AND '" + cAProved + "'"
		cQuery+= " AND STL.TL_LOJA BETWEEN '" + cDeTienda + "' AND '" + cATienda + "'"

		cQuery+= " ORDER BY STJ.TJ_FILIAL, STJ.TJ_ORDEM, STL.TL_CODIGO, STL.TL_TAREFA"

		cQuery:= ChangeQuery(cQuery)

		//Aviso("query",cvaltochar(cQuery),{"Ok"},,,,,.T.)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
		dbSelectArea(cAliasQry)
		dbGoTop()

		oSection:Init()
		While (cAliasQry)->(! EOF())

			oSection:Cell("TJ_ORDEM"):SetValue( (cAliasQry)->TJ_ORDEM )
			oSection:Cell("TJ_CODBEM"):SetValue( (cAliasQry)->TJ_CODBEM )
			oSection:Cell("T9_NOME"):SetValue( (cAliasQry)->T9_NOME )
			oSection:Cell("TJ_DTORIGI"):SetValue( DTOC(STOD((cAliasQry)->TJ_DTORIGI)) )
			oSection:Cell("TJ_DTMRINI"):SetValue( DTOC(STOD((cAliasQry)->TJ_DTMRINI)) )
			oSection:Cell("TJ_DTMRFIM"):SetValue( DTOC(STOD((cAliasQry)->TJ_DTMRFIM)) )
			oSection:Cell("TL_TIPOREG"):SetValue( (cAliasQry)->TL_TIPOREG )

			oSection:Cell("TL_CODIGO"):SetValue( (cAliasQry)->TL_CODIGO )
			cDescCod:= NOMINSBRW((cAliasQry)->TL_TIPOREG,(cAliasQry)->TL_CODIGO)//Función estándar de Totvs
			oSection:Cell("DESCCOD"):SetValue( cDescCod )

			oSection:Cell("TT9_UCDARE"):SetValue( (cAliasQry)->TT9_UCDARE )
			oSection:Cell("TD_NOME"):SetValue( (cAliasQry)->TD_NOME )
			oSection:Cell("TL_TAREFA"):SetValue( (cAliasQry)->TL_TAREFA )
			oSection:Cell("TT9_DESCRI"):SetValue( (cAliasQry)->TT9_DESCRI )

			oSection:Cell("TL_QUANTID"):SetPicture(PesqPict( 'STL', 'TL_QUANTID' ))
			oSection:Cell("TL_QUANTID"):SetValue( (cAliasQry)->TL_QUANTID )

			oSection:Cell("TL_UNIDADE"):SetValue( (cAliasQry)->TL_UNIDADE )

			oSection:Cell("TL_CUSTO"):SetPicture(PesqPict( 'STL', 'TL_CUSTO' ))
			oSection:Cell("TL_CUSTO"):SetValue( (cAliasQry)->TL_CUSTO )

			oSection:Cell("TE_TIPOMAN"):SetValue( (cAliasQry)->TE_TIPOMAN )
			oSection:Cell("TE_NOME"):SetValue( (cAliasQry)->TE_NOME )

			oSection:Cell("ESTADO"):SetValue( (cAliasQry)->ESTADO )

			(cAliasQry)->(dbSkip())

			oSection:PrintLine(,,,.T.)
		enddo

		oSection:Finish()

	#ELSE
		//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","De Ordem Servico ?"		, "¿De orden de servicio?"	,"From Service Order?"	,"MV_CH1","C",06,0,0,"G","If(empty(mv_par01),.t.,ExistCpo('STJ',mv_par01))","STJ","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","Ate Ordem Servico ?"	, "¿A orden de servicio?"	,"To Service Order?"	,"MV_CH2","C",06,0,0,"G","If(atecodigo('STJ',mv_par01,mv_par02,6),.t.,.f.)","STJ","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"03","De  Centro de Custo ?" 	, "¿De centro de costo?"	,"From Cost Center?"	,"MV_CH3","C",11,0,0,"G","If(empty(mv_par03),.t.,ExistCpo('SI3',mv_par03))","CTT","004","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","Ate  Centro de Custo ?" , "¿A centro de costo?"		,"To Cost Center?"		,"MV_CH4","C",11,0,0,"G","If(atecodigo('SI3',mv_par03,mv_par04,9),.t.,.f.)","CTT","004","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"05","De  Data Manutencao ?"	, "¿De Fch. Mantenimiento?"	,"From Maintenance Date?"	,"MV_CH5","D",08,0,0,"G","NaoVazio()","","","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","Ate  Data Manutencao ?"	, "¿A Fch. Mantenimiento?"	,"To Maintenance Date?"		,"MV_CH6","D",08,0,0,"G","(mv_par06 >= mv_par05)","","","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"07","Do  Bem ?" 				, "¿De bien?"				,"From Asset?"			,"MV_CH7","C",16,0,0,"G","If(empty(mv_par07),.t.,ExistCpo('ST9',mv_par07))","ST9","","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","Ate  Bem ?" 			, "¿A bien?"				,"To Asset?"			,"MV_CH8","C",16,0,0,"G","If(atecodigo('ST9',mv_par07,mv_par08,16),.t.,.f.)","ST9","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"09","Considerar Produto ?"	, "¿Considerar producto?"	,"Consider Product?"	,"MV_CH9","N",01,0,0,"C","MNT86SB1V(1)","","","","MV_PAR09","Sim","Si","Yes","","Nao","No","No")
	xPutSX1(cPerg,"10","De Produto ?" 			, "¿De producto?"			,"From Product?"		,"MV_CHA","C",30,0,0,"G","MNT86SB1V(2)","SB1","030","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","Ate Produto ?" 			, "¿A producto?"			,"To Product?"			,"MV_CHB","C",30,0,0,"G","MNT86SB1V(3)","SB1","030","","MV_PAR11",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"12","Considerar Ferramen ?"	, "¿Considerar Herram.?"	,"Consider Tool?"		,"MV_CHC","N",01,0,0,"C","MNT86SH4V(1)","","","","MV_PAR12","Sim","Si","Yes","","Nao","No","No")
	xPutSX1(cPerg,"13","De Ferramenta ?" 		, "¿De herramienta?"		,"From Tool?"			,"MV_CHD","C",06,0,0,"G","MNT86SH4V(2)","SH4","","","MV_PAR13",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"14","Ate Ferramenta ?" 		, "¿A herramienta?"			,"To Tool?"				,"MV_CHE","C",06,0,0,"G","MNT86SH4V(3)","SH4","","","MV_PAR14",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"15","Considerar Especialidade ?"	, "¿Considerar Especialidad?"	,"Consider Specialty?"	,"MV_CHF","N",01,0,0,"C","","","","","MV_PAR15","Sim","Si","Yes","","Nao","No","No")
	xPutSX1(cPerg,"16","De Especialidade ?" 	, "¿De Especialidad?"		,"From Specialty?"		,"MV_CHG","C",03,0,0,"G","","ST0","","","MV_PAR16",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"17","Ate Especialidade ?" 	, "¿A Especialidad?"		,"To Specialty?"		,"MV_CHH","C",03,0,0,"G","","ST0","","","MV_PAR17",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"18","Considerar Mao-Obra ?"	, "¿Considerar mano de obra?"	,"Consider Labor ?"	,"MV_CHI","N",01,0,0,"C","MNT86ST1V(1)","","","","MV_PAR18","Sim","Si","Yes","","Nao","No","No")
	xPutSX1(cPerg,"19","De Mao-Obra ?" 			, "¿De mano de obra?"		,"From labor?"			,"MV_CHJ","C",06,0,0,"G","MNT86ST1V(2)","ST1","121","","MV_PAR19",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"20","Ate Mao-Obra ?" 		, "¿A mano de obra?"		,"To labor?"			,"MV_CHK","C",06,0,0,"G","MNT86ST1V(3)","ST1","121","","MV_PAR20",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"21","Considerar Terceiro ?"	, "¿Considerar tercero?"	,"Consider Third Party?","MV_CHL","N",01,0,0,"C","","","","","MV_PAR21","Sim","Si","Yes","","Nao","No","No")
	xPutSX1(cPerg,"22","De Terceiro ?" 			, "¿De Tercero?"			,"From Third Party?"	,"MV_CHM","C",06,0,0,"G","","SA2","001","","MV_PAR22",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"23","Ate Terceiro ?" 		, "¿A Tercero?"				,"To Third Party?"		,"MV_CHN","C",06,0,0,"G","","SA2","001","","MV_PAR23",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"24","De Area Mnt. ?" 		, "¿De Área Mnt.?"			,"¿De Área Mnt.?"		,"MV_CHO","C",06,0,0,"G","","STD","","","MV_PAR24",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"25","Ate Area Mnt.?" 		, "¿A Área Mnt.?"			,"¿A Área Mnt.?"		,"MV_CHP","C",06,0,0,"G","","STD","","","MV_PAR25",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"26","De Tarefas ?" 			, "¿De Tareas?"				,"¿De Tareas?"			,"MV_CHQ","C",06,0,0,"G","","TT9","","","MV_PAR26",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"27","Ate Tarefas ?" 			, "¿A Tareas?"				,"¿A Tareas?"			,"MV_CHR","C",06,0,0,"G","","TT9","","","MV_PAR27",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"28","De Fornecedor ?" 		, "¿De Proveedor?"			,"From Provider?"		,"MV_CHS","C",06,0,0,"G","","SA2","","","MV_PAR28",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"29","Ate Fornecedor ?" 		, "¿A Proveedor?"			,"To Provider?"			,"MV_CHT","C",06,0,0,"G","","SA2","","","MV_PAR29",""       ,""            ,""        ,""     ,""   ,"")

	xPutSX1(cPerg,"30","De Loja ?" 				, "¿De Tienda?"				,"From Store?"			,"MV_CHU","C",02,0,0,"G","","","","","MV_PAR30",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"31","Ate Loja ?" 			, "¿A Tienda?"				,"To Store?"			,"MV_CHV","C",02,0,0,"G","","","","","MV_PAR31",""       ,""            ,""        ,""     ,""   ,"")

return

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
		cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
		cF3, cGrpSxg,cPyme,;
		cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
		cDef02,cDefSpa2,cDefEng2,;
		cDef03,cDefSpa3,cDefEng3,;
		cDef04,cDefSpa4,cDefEng4,;
		cDef05,cDefSpa5,cDefEng5,;
		aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return
