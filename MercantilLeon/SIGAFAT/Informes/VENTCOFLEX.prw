#include "protheus.ch"

#define NORDMAT	1	//Orden: Sucursal + Matric.
#define NORDCC	2	//Orden: Sucursal + C.Costo
#define NORDAP	3	//Orden: Apellido Paterno + Apellido Materno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VENTAS01 ³ 				Autor ³: Denar Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ventas									   					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ VENTAS01()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP															³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Denar     ³ 08/07/2022³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function VENTCOFLEX()
	Local oReport
	PRIVATE cPerg   := "VENTCOFL"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "Reporte de ventas Coflex"

	oReport	 := TReport():New("VentasCoflex",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte de ventas Coflex", .T.)
	//oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Ventas",{"SF2"})
	oReport:SetTotalInLine(.F.)

	//TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"A1_EST"		,"SA1")
	TRCell():New(oSection,"A1_COD_MUN"	,"SA1")
	TRCell():New(oSection,"Z20_PROVIN"	,"Z20")
	TRCell():New(oSection,"Z20_MUNICI"	,"Z20")
	TRCell():New(oSection,"F2_CLIENTE"	,"SF2")
	TRCell():New(oSection,"F2_LOJA"		,"SF2")
	TRCell():New(oSection,"A1_NOME"		,"SA1")
	TRCell():New(oSection,"D2_PEDIDO"	,"SD2")
	TRCell():New(oSection,"F2_VEND1"	,"SF2")
	TRCell():New(oSection,"A3_NOME"		,"SA3")
	TRCell():New(oSection,"F2_DOC"		,"SF2")
	TRCell():New(oSection,"F2_SERIE"	,"SF2")
	TRCell():New(oSection,"D2_ITEM"		,"SD2")
	TRCell():New(oSection,"F2_EMISSAO"	,"SF2")
	TRCell():New(oSection,"D2_COD"		,"SD2")
	TRCell():New(oSection,"D2_UM"		,"SD2")
	TRCell():New(oSection,"D2_SEGUM"	,"SD2")
	TRCell():New(oSection,"B1_GRUPO"	,"SB1")
	TRCell():New(oSection,"B1_UCODFAB"	,"SB1")
	TRCell():New(oSection,"B1_ESPECIF"	,"SB1")
	TRCell():New(oSection,"B1_UESPEC2"	,"SB1")
	TRCell():New(oSection,"D2_TOTAL"	,"SD2")
	TRCell():New(oSection,"D2_QUANT"	,"SD2")
	TRCell():New(oSection,"D2_QTSEGUM"	,"SD2")
	TRCell():New(oSection,"F2_MOEDA"	,"SF2")

	TRCell():New(oSection,"F2_UNOMCLI"	,"SF2")
	TRCell():New(oSection,"F2_UNITCLI"	,"SF2")
	

Return oReport

Static Function PrintReport(oReport)
	Local aArea		:= getArea()
	Local oSection 	:= oReport:Section(1)
	Local cAliasQry	:= GetNextAlias()
	Local cDeptoDe	:= MV_PAR01
	Local cDeptoA	:= MV_PAR02
	Local cFechaDe	:= MV_PAR03
	Local cFechaA	:= MV_PAR04
	Local cClientDe	:= MV_PAR05
	Local cClientA	:= MV_PAR06
	Local cVendDe	:= MV_PAR07
	Local cVendA	:= MV_PAR08
	Local nMoneda	:= 1

	#IFDEF TOP

		BeginSql alias cAliasQry

		SELECT
		SA1.A1_EST,
		SA1.A1_COD_MUN,
		COALESCE((SELECT Z20_PROVIN FROM Z20010 WHERE %notDel% AND Z20_COD = SA1.A1_COD_MUN), '') AS Z20_PROVIN,
		COALESCE((SELECT Z20_MUNICI FROM Z20010 WHERE %notDel% AND Z20_COD = SA1.A1_COD_MUN), '') AS Z20_MUNICI,
		SF2.F2_CLIENTE, SF2.F2_LOJA,
		SA1.A1_NOME,
		SF2.F2_VEND1, (SELECT A3_NOME FROM SA3010 WHERE %notDel% AND A3_COD = SF2.F2_VEND1) AS A3_NOME,
		SF2.F2_DOC,
		SF2.F2_SERIE,
		SD2.D2_ITEM,
		SF2.F2_EMISSAO,
		SD2.D2_COD,
		SD2.D2_UM,
		SD2.D2_SEGUM,
		SB1.B1_GRUPO,
		SB1.B1_UCODFAB,
		SB1.B1_ESPECIF,
		SB1.B1_UESPEC2,
		SUM(SD2.D2_TOTAL) AS D2_TOTAL,
		SUM(SD2.D2_QUANT) AS D2_QUANT,
		SUM(SD2.D2_QTSEGUM) AS D2_QTSEGUM,
		SD2.D2_PEDIDO,
		SF2.F2_MOEDA
		,ROUND(SUM(SD2.D2_QUANT)*B1_CONV,2) AS D2_QUANT2,
		F2_UNOMCLI,F2_UNITCLI
		FROM %Table:SF2% SF2 (NOLOCK)
		JOIN %Table:SD2% SD2 (NOLOCK) ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA
		JOIN %Table:SA1% SA1 (NOLOCK) ON SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA
		JOIN %Table:SB1% SB1 (NOLOCK) ON SB1.B1_COD = SD2.D2_COD
		WHERE SF2.%notDel%
		AND SD2.%notDel%
		AND SA1.%notDel%
		AND SB1.%notDel%
		AND SD2.D2_TES IN ('510', '800')
		AND SD2.D2_ESPECIE = 'NF'
		AND SB1.B1_GRUPO IN('T201','T202')
		AND SA1.A1_EST BETWEEN %Exp:cDeptoDe% AND %Exp:cDeptoA%
		AND SF2.F2_EMISSAO BETWEEN %Exp:cFechaDe% AND %Exp:cFechaA%
		AND SF2.F2_CLIENTE BETWEEN %Exp:cClientDe% AND %Exp:cClientA%
		AND SF2.F2_VEND1 BETWEEN %Exp:cVendDe% AND %Exp:cVendA%
		GROUP BY
		SA1.A1_EST, SA1.A1_COD_MUN,
		SF2.F2_CLIENTE, SF2.F2_LOJA,
		SA1.A1_NOME,
		SF2.F2_VEND1,
		SF2.F2_DOC,
		SF2.F2_SERIE,
		SD2.D2_ITEM,
		SD2.D2_COD,
		SD2.D2_UM,
		SD2.D2_SEGUM,
		SB1.B1_GRUPO,
		SB1.B1_UCODFAB,
		SB1.B1_ESPECIF,
		SB1.B1_UESPEC2,
		SD2.D2_PEDIDO,
		SD2.D2_FILIAL,
		SD2.D2_TES,
		SF2.F2_EMISSAO,
		SF2.F2_MOEDA,
		SB1.B1_CONV,F2_UNOMCLI,F2_UNITCLI
		ORDER BY SF2.F2_DOC, SF2.F2_SERIE, SD2.D2_ITEM

		EndSql

		DbSelectArea(cAliasQry)
		oSection:Init()
		while (cAliasQry)->(!Eof())
			oSection:Cell("A1_EST"):SetValue( (cAliasQry)->A1_EST )
			oSection:Cell("A1_COD_MUN"):SetValue( (cAliasQry)->A1_COD_MUN )
			oSection:Cell("Z20_PROVIN"):SetValue( (cAliasQry)->Z20_PROVIN )
			oSection:Cell("Z20_MUNICI"):SetValue( (cAliasQry)->Z20_MUNICI )
			oSection:Cell("F2_CLIENTE"):SetValue( (cAliasQry)->F2_CLIENTE )
			oSection:Cell("F2_LOJA"):SetValue( (cAliasQry)->F2_LOJA )
			oSection:Cell("A1_NOME"):SetValue( (cAliasQry)->A1_NOME )
			oSection:Cell("D2_PEDIDO"):SetValue( (cAliasQry)->D2_PEDIDO )
			oSection:Cell("F2_VEND1"):SetValue( (cAliasQry)->F2_VEND1 )
			oSection:Cell("A3_NOME"):SetValue( (cAliasQry)->A3_NOME )
			oSection:Cell("F2_DOC"):SetValue( (cAliasQry)->F2_DOC )
			oSection:Cell("F2_SERIE"):SetValue( (cAliasQry)->F2_SERIE )
			oSection:Cell("D2_ITEM"):SetValue( (cAliasQry)->D2_ITEM )
			oSection:Cell("F2_EMISSAO"):SetValue( (cAliasQry)->F2_EMISSAO )
			oSection:Cell("D2_COD"):SetValue( (cAliasQry)->D2_COD )
			oSection:Cell("D2_UM"):SetValue( (cAliasQry)->D2_UM )
			oSection:Cell("D2_SEGUM"):SetValue( (cAliasQry)->D2_SEGUM )
			oSection:Cell("B1_GRUPO"):SetValue( (cAliasQry)->B1_GRUPO )
			oSection:Cell("B1_UCODFAB"):SetValue( (cAliasQry)->B1_UCODFAB )
			oSection:Cell("B1_ESPECIF"):SetValue( (cAliasQry)->B1_ESPECIF )
			oSection:Cell("B1_UESPEC2"):SetValue( (cAliasQry)->B1_UESPEC2 )
			oSection:Cell("D2_TOTAL"):SetValue( iif( nMoneda == 2 ,xMoeda((cAliasQry)->D2_TOTAL,1,2,DDATABASE),(cAliasQry)->D2_TOTAL) )
			oSection:Cell("D2_QUANT"):SetValue( (cAliasQry)->D2_QUANT )
			oSection:Cell("D2_QTSEGUM"):SetValue( IIF((cAliasQry)->D2_QTSEGUM == 0,(cAliasQry)->D2_QUANT2,(cAliasQry)->D2_QTSEGUM) )
			oSection:Cell("F2_MOEDA"):SetValue( (cAliasQry)->F2_MOEDA )

			oSection:Cell("F2_UNOMCLI"):SetValue( (cAliasQry)->F2_UNOMCLI )
			oSection:Cell("F2_UNITCLI"):SetValue( (cAliasQry)->F2_UNITCLI )

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
	//xPutSx1(cPerg,"01","De grupo?","De grupo?","De grupo?",         "MV_CH1","C",04,0,0,"G","","SBM","","","MV_PAR01",""       ,""            ,""        ,""     ,"","")
	//xPutSx1(cPerg,"02","A grupo?","A grupo?","A grupo?",         "MV_CH2","C",04,0,0,"G","","SBM","","","MV_PAR02",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"01","De departamento?","De departamento?","De departamento?",         "MV_CH3","C",02,0,0,"G","","","","","MV_PAR01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A departamento?","A departamento?","A departamento?",         "MV_CH4","C",02,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"03","De fecha facturacion?","De fecha facturacion?","De fecha facturacion?",         "MV_CH5","D",08,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A fecha facturacion?","A fecha facturacion?","A fecha facturacion?",         "MV_CH6","D",08,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"05","De cliente?","De cliente?","De cliente?",         "MV_CH7","C",06,0,0,"G","","SA1","","","MV_PAR05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A cliente?","A cliente?","A cliente?",         "MV_CH8","C",06,0,0,"G","","SA1","","","MV_PAR06",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"07","De vendedor?","De vendedor?","De vendedor?",         "MV_CH9","C",06,0,0,"G","","SA3","","","MV_PAR07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A vendedor?","A vendedor?","A vendedor?",         "MV_CHA","C",06,0,0,"G","","SA3","","","MV_PAR08",""       ,""            ,""        ,""     ,"","")

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
