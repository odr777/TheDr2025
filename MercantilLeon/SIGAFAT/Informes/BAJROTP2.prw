#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BAJROTPR ³ 				Autor ³: Erick Etcheverry			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ BAJROTPR										   			 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ BAJROTPR()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP															³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Denar     ³ 11/03/2024³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function BAJROTP2()
	Local oReport
	PRIVATE cPerg   := "BAJROTP2"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "Reporte de productos de menor movimiento"

	oReport	 := TReport():New("Producto Meta",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte de productos de menor movimiento (ventas)", .T.)
	//oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Producto",{"SD2"})
	oReport:SetTotalInLine(.F.)

	TRCell():New(oSection,"CODIGO"		,"SB1","CODIGO ML")
	TRCell():New(oSection,"CODIGOFAB"	,"SB1","CODIGO FABRICA")
	TRCell():New(oSection,"UMEDIDA"	,"SB1","UNIDAD")
	TRCell():New(oSection,"DESCESPECIFICA"	,"SB1","DESCRIPCION 1")
	TRCell():New(oSection,"ESPECIFICA2"	,"SB1","DESCRIPCION 2")
	TRCell():New(oSection,"GRUPO"		,"SB1","GRUPO")
	TRCell():New(oSection,"ULCOMPRA"		,"SB1","FECHA ULT COMPRA",PesqPict("SB1","B1_UCOM"),TamSX3("B1_UCOM")[1])
	TRCell():New(oSection,"DEPOSITO"	,"SB1","DEPOSITO")
	TRCell():New(oSection,"CANTIDAD"	,"SD2","CANTIDAD",PesqPict("SD2","D2_QUANT"),TamSX3("D2_QUANT")[1])
	TRCell():New(oSection,"CANTMETA"	,"SD2","CANT META",PesqPict("SD2","D2_QUANT"),TamSX3("D2_QUANT")[1])
	TRCell():New(oSection,"SALDODEP"	,"SB2","SALDO DEPOSITO",PesqPict("SB2","B2_QATU"),TamSX3("B2_QATU")[1])
	TRCell():New(oSection,"TABPRECIO"	,"SB1","TABLA PRECIO")
	TRCell():New(oSection,"PRECOTAB"	,"SD2","PRECIO TABLA USD",PesqPict("SD2","D2_PRUNIT"),TamSX3("D2_PRUNIT")[1])


Return oReport

Static Function PrintReport(oReport)
	Local aArea		:= getArea()
	Local oSection 	:= oReport:Section(1)
	Local cAliasQry	:= GetNextAlias()
	///PREGUNTAS REPORTE
	Local cFechad	:= DtoS(MV_PAR01)
	Local cFechaa	:= DtoS(MV_PAR02)
	Local cGrupoDe	:= MV_PAR03
	Local cGrupoA	:= MV_PAR04
	Local cProdDe	:= MV_PAR05
	Local cProdA	:= mv_par06
	Local cDepDe	:= MV_PAR07
	Local cDepA		:= mv_par08
	Local cQtdDe	:= MV_PAR09
	Local cQtdDa	:= mv_par10
	Local cFechadd	:= DtoS(MV_PAR11)  ////fecha para poner meta
	Local cFechaaa	:= DtoS(MV_PAR12)
	Local cxFilDA1  := xFilial("DA1")


	#IFDEF TOP

		BeginSql alias cAliasQry

		SELECT B1_COD CODIGO,B1_UCODFAB CODIGOFAB,ISNULL(D2_UM,B1_UM) UMEDIDA,
		B1_ESPECIF DESCESPECIFICA,B1_UESPEC2 ESPECIFICA2,B1_GRUPO GRUPO,B1_UCOM ULCOMPRA,
		ISNULL(D2_LOCAL,B1_LOCPAD) DEPOSITO,ISNULL(SUM(D2_QUANT),0) CANTIDAD,
		ISNULL(SUM(B2_QATU)-SUM(B2_RESERVA),0) SALDODEP,ISNULL(F2_TABELA,'001') TABPRECIO,ISNULL(DA1_PRCVEN,0) PRECOTAB
		,
		(
			SELECT ISNULL(SUM(D2_QUANT),0) CANTIDAD
				FROM %Table:SB1% SB11 (NOLOCK)
				LEFT JOIN %Table:SD2% SD22 (NOLOCK) ON D2_COD = B1_COD
				AND D2_ESPECIE = 'NF'
				AND D2_EMISSAO BETWEEN %Exp:cFechadd% AND %Exp:cFechaaa%
				AND D2_LOCAL = ISNULL(SD2.D2_LOCAL,SB1.B1_LOCPAD)
				AND SD22.D_E_L_E_T_ = ' '
				AND D2_UM = ISNULL(SD2.D2_UM,SB1.B1_UM)
				LEFT JOIN %Table:SF2% SF22 (NOLOCK) ON F2_FILIAL = D2_FILIAL AND D2_DOC = F2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE 
				AND F2_LOJA = D2_LOJA and D2_ESPECIE = 'NF' AND SF22.D_E_L_E_T_ = ' ' AND F2_TABELA = ISNULL(SF2.F2_TABELA,'001')
				WHERE B1_COD = SB1.B1_COD  AND SB11.D_E_L_E_T_ = ' ' AND B1_GRUPO = SB1.B1_GRUPO
				GROUP BY B1_COD,B1_UCODFAB,B1_ESPECIF,
				B1_UESPEC2,B1_GRUPO
		) CANTMETA
		FROM %Table:SB1% SB1 (NOLOCK)
		LEFT JOIN %Table:SD2% SD2 (NOLOCK) ON D2_COD = B1_COD
		AND D2_ESPECIE = 'NF'
		AND D2_EMISSAO BETWEEN %Exp:cFechad% AND %Exp:cFechaa%
		AND D2_LOCAL BETWEEN %Exp:cDepDe% AND %Exp:cDepA%
		AND SD2.%notDel%
		LEFT JOIN %Table:SB2% SB2 (NOLOCK) ON B2_COD = B1_COD AND ISNULL(D2_LOCAL,B1_LOCPAD) = B2_LOCAL AND SB2.%notDel%
		LEFT JOIN %Table:SF2% SF2 (NOLOCK) ON F2_FILIAL = D2_FILIAL AND D2_DOC = F2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE 
		AND F2_LOJA = D2_LOJA and D2_ESPECIE = 'NF' AND SF2.%notDel%
		LEFT JOIN %Table:DA1% DA1 (NOLOCK) ON DA1_FILIAL = %Exp:cxFilDA1% AND DA1_CODTAB = ISNULL(F2_TABELA,'001') AND DA1_CODPRO = B1_COD AND DA1.%notDel%
		WHERE B1_COD BETWEEN %Exp:cProdDe% AND %Exp:cProdA% AND SB1.%notDel% AND B1_GRUPO BETWEEN %Exp:cGrupoDe% AND %Exp:cGrupoA%
		GROUP BY B1_COD,B1_UCODFAB,ISNULL(D2_UM,B1_UM),B1_ESPECIF,
		B1_UESPEC2,B1_GRUPO,B1_UCOM,ISNULL(D2_LOCAL,B1_LOCPAD),ISNULL(F2_TABELA,'001'),ISNULL(DA1_PRCVEN,0)
		HAVING ISNULL(SUM(D2_QUANT),0) BETWEEN %Exp:cQtdDe% AND %Exp:cQtdDa%
		ORDER BY CANTIDAD ASC

		EndSql

		DbSelectArea(cAliasQry)
		oSection:Init()
		while (cAliasQry)->(!Eof())
			oSection:Cell("CODIGO"):SetValue( (cAliasQry)->CODIGO )
			oSection:Cell("CODIGOFAB"):SetValue( (cAliasQry)->CODIGOFAB )
			oSection:Cell("UMEDIDA"):SetValue( (cAliasQry)->UMEDIDA )
			oSection:Cell("DESCESPECIFICA"):SetValue( (cAliasQry)->DESCESPECIFICA )
			oSection:Cell("ESPECIFICA2"):SetValue( (cAliasQry)->ESPECIFICA2 )
			oSection:Cell("GRUPO"):SetValue( (cAliasQry)->GRUPO )
			oSection:Cell("ULCOMPRA"):SetValue( (cAliasQry)->ULCOMPRA )
			oSection:Cell("DEPOSITO"):SetValue( (cAliasQry)->DEPOSITO )
			oSection:Cell("CANTIDAD"):SetValue( (cAliasQry)->CANTIDAD )
			oSection:Cell("CANTMETA"):SetValue( (cAliasQry)->CANTMETA )
			oSection:Cell("SALDODEP"):SetValue( (cAliasQry)->SALDODEP )
			oSection:Cell("TABPRECIO"):SetValue( (cAliasQry)->TABPRECIO )
			oSection:Cell("PRECOTAB"):SetValue( (cAliasQry)->PRECOTAB )

			oSection:PrintLine(,,,.T.)
			(cAliasQry)->(dbSkip())
		enddo
		oSection:Finish()

	#ELSE
		//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

	(cAliasQry)->(dbCloseArea())

	restArea(aArea)

Return

Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica

	Local aArea	:= GetArea()
	Local aCabec	:= {}
	Local cChar	:= chr(160) // caracter dummy para alinhamento do cabeçalho
	Local titulo	:= oReport:Title()
	Local page		:= oReport:Page()

	// __LOGOEMP__ imprime el logo de la empresa

	aCabec := {     "__LOGOEMP__" ,cChar + "        " + cChar + if(comparador==1," ",RptFolha+" "+cvaltochar(page));
		, " " + " " + "        " + cChar + UPPER(AllTrim(titulo)) + "        " + cChar + RptEmiss + " " + Dtoc(dDataBase);
		, "Hora: "+ cvaltochar(TIME()) ;
		, "Empresa: "+ SM0->M0_FILIAL + " " }
	RestArea( aArea )
Return aCabec

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSx1(cPerg,"01","De fecha ?","De fecha ?","De fecha ?",         "mv_ch5","D",08,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A fecha ?","A fecha ?","A fecha ?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De grupo?","De grupo?","De grupo?",         "MV_CH1","C",04,0,0,"G","","SBM","","","MV_PAR03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A grupo?","A grupo?","A grupo?",         "MV_CH2","C",04,0,0,"G","","SBM","","","MV_PAR04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De Producto ?","De Producto ?","De Producto ?","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A Producto ?","A Producto ?","A Producto ?","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De Deposito ?","De Deposito ?","De Deposito ?", "mv_ch7","C",2,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A Deposito ?","A Deposito ?","A Deposito	 ?",  "mv_ch8","C",2,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","De Cantidad ?","De Cantidad ?","De Cantidad ?", "mv_ch7","C",10,0,0,"G","","","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A Cantidad ?","A Cantidad ?","A Cantidad	 ?",  "mv_ch8","C",10,0,0,"G","","","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"11","De fecha meta?","De fecha meta?","De fecha meta?",         "mv_ch5","D",08,0,0,"G","","","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"12","A fecha meta?","A fecha meta?","A fecha meta?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par12",""       ,""            ,""        ,""     ,"","")
	
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
