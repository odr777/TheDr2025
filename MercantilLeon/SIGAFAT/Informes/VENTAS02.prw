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

User Function VENTAS02()
	Local oReport
	PRIVATE cPerg   := "VENTAS01"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "Reporte de ventas"

	oReport	 := TReport():New("Ventas",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte de ventas", .T.)
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
	TRCell():New(oSection,"PRECO"	,"SF2","Precio lista")
	TRCell():New(oSection,"TC"	,"SF2","TC")
	TRCell():New(oSection,"MONTO2"	,"SF2","M.2")
	TRCell():New(oSection,"MONTO5"	,"SF2","M.Aux")
	TRCell():New(oSection,"DESCONTO"	,"SF2","Descuento")

	TRCell():New(oSection,"COSTO"	,"SF2","Costo $")
	TRCell():New(oSection,"PAGO"	,"SF2","Cond. Pago")
	TRCell():New(oSection,"TABLA"	,"SF2","Lista Precio")


Return oReport

Static Function PrintReport(oReport)
	Local aArea		:= getArea()
	Local oSection 	:= oReport:Section(1)
	Local cAliasQry	:= GetNextAlias()
	Local cGrupoDe	:= MV_PAR01
	Local cGrupoA	:= MV_PAR02
	Local cDeptoDe	:= MV_PAR03
	Local cDeptoA	:= MV_PAR04
	Local cFechaDe	:= MV_PAR05
	Local cFechaA	:= MV_PAR06
	Local cClientDe	:= MV_PAR07
	Local cClientA	:= MV_PAR08
	Local cVendDe	:= MV_PAR09
	Local cVendA	:= MV_PAR10
	Local nMoneda	:= MV_PAR11

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
		AA.DA1_PRCVEN,
		CASE WHEN ABS(AA.PRUNIT_M2 - AA.DA1_PRCVEN) > 0.1 THEN TC5 ELSE TC2 END TC, AA.PRUNIT_M2, AA.PRUNIT_M5,
		ROUND((1-(AA.D2_PRCVEN/AA.D2_PRUNIT))*100, 2) PORC_DESC, AA.D2_DESC, AA.D2_CUSTO2, AA.F2_TABELA, AA.F2_COND
		FROM %Table:SF2% SF2 (NOLOCK)
		JOIN %Table:SD2% SD2 (NOLOCK) ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA
		JOIN %Table:SA1% SA1 (NOLOCK) ON SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA
		JOIN %Table:SB1% SB1 (NOLOCK) ON SB1.B1_COD = SD2.D2_COD
		JOIN (SELECT ROUND(D2_PRCVEN/
  					NULLIF((SELECT MAX(M2_MOEDA2)
                   FROM SM2010
                   WHERE D_E_L_E_T_ = ' '
                     AND M2_DATA = D2_EMISSAO), 0)
                  , 2) PRCVEN_M2,
          ROUND(D2_PRUNIT/
                  NULLIF((SELECT MAX(M2_MOEDA2)
                   FROM SM2010
                   WHERE D_E_L_E_T_ = ' '
                     AND M2_DATA = D2_EMISSAO),0), 2) PRUNIT_M2,
          ROUND(D2_PRCVEN/
                  NULLIF((SELECT MAX(M2_MOEDA5)
                   FROM SM2010
                   WHERE D_E_L_E_T_ = ' '
                     AND M2_DATA = D2_EMISSAO),0), 2) PRCVEN_M5,
          ROUND(D2_PRUNIT/
                  NULLIF((SELECT MAX(M2_MOEDA5)
                   FROM SM2010
                   WHERE D_E_L_E_T_ = ' '
                     AND M2_DATA = D2_EMISSAO),0), 2) PRUNIT_M5,
			(SELECT MAX(DA1_PRCVEN) FROM %Table:SF2% SF2 (NOLOCK) , %Table:DA1% DA1 WHERE SF2.D_E_L_E_T_ = ' ' AND DA1.D_E_L_E_T_= ' '
			AND F2_TABELA = DA1_CODTAB AND F2_DOC + F2_SERIE = D2_DOC + D2_SERIE AND DA1_CODPRO = D2_COD
			AND DA1_DATVIG <= F2_EMISSAO) DA1_PRCVEN,
			(SELECT MAX(M2_MOEDA2) FROM %Table:SM2% WHERE D_E_L_E_T_ = ' ' AND M2_DATA = D2_EMISSAO) TC2,
			(SELECT MAX(M2_MOEDA5) FROM %Table:SM2% WHERE D_E_L_E_T_ = ' ' AND M2_DATA = D2_EMISSAO) TC5,
			ROUND(D2_CUSTO2/NULLIF(D2_QUANT,0), 2) D2_CUSTO2,
			D2_PRCVEN, D2_PRUNIT, D2_TOTAL, D2_DESC, D2_DESCON, D2_QUANT, D2_TOTAL/D2_QUANT TOT_D_Q, D2_CLIENTE,D2_DOC,D2_COD,D2_ITEM,D2_SERIE,D2_FILIAL,F2_TABELA,F2_COND + ' ' + E4_DESCRI F2_COND
			FROM %Table:SD2% SD22 (NOLOCK), %Table:SF2% SF2 (NOLOCK) , SE4010 SE4 (NOLOCK)
			WHERE SD22.D_E_L_E_T_ = ' ' AND SF2.D_E_L_E_T_= ' ' AND SF2.F2_DOC = SD22.D2_DOC AND SF2.F2_SERIE = SD22.D2_SERIE AND E4_CODIGO = F2_COND AND SE4.D_E_L_E_T_ = ' '
		) AA ON AA.D2_FILIAL = SD2.D2_FILIAL AND SD2.D2_COD = AA.D2_COD AND SD2.D2_DOC = AA.D2_DOC AND SD2.D2_SERIE = AA.D2_SERIE AND SD2.D2_ITEM = AA.D2_ITEM
		AND SD2.D2_CLIENTE = AA.D2_CLIENTE
		WHERE SF2.%notDel%
		AND SD2.%notDel%
		AND SA1.%notDel%
		AND SB1.%notDel%
		AND SD2.D2_TES IN ('510', '800')
		AND SD2.D2_ESPECIE = 'NF'
		AND SB1.B1_GRUPO BETWEEN %Exp:cGrupoDe% AND %Exp:cGrupoA%
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
		SB1.B1_CONV,
		AA.DA1_PRCVEN,
		AA.PRUNIT_M2, 
		AA.PRUNIT_M5,
		AA.TC5,
		AA.TC2,
		AA.D2_PRCVEN,
		AA.D2_PRUNIT,
		AA.D2_DESC,
		AA.D2_CUSTO2, AA.F2_TABELA, AA.F2_COND
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
			oSection:Cell("PRECO"):SetValue( (cAliasQry)->DA1_PRCVEN )
			oSection:Cell("TC"):SetValue( (cAliasQry)->TC )
			oSection:Cell("MONTO2"):SetValue( (cAliasQry)->PRUNIT_M2 )
			oSection:Cell("MONTO5"):SetValue( (cAliasQry)->PRUNIT_M5 )
			oSection:Cell("DESCONTO"):SetValue( (cAliasQry)->D2_DESC )
			oSection:Cell("COSTO"):SetValue( (cAliasQry)->D2_CUSTO2 )
			oSection:Cell("PAGO"):SetValue( (cAliasQry)->F2_COND )
			oSection:Cell("TABLA"):SetValue( (cAliasQry)->F2_TABELA )


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
	xPutSx1(cPerg,"01","De grupo?","De grupo?","De grupo?",         "MV_CH1","C",04,0,0,"G","","SBM","","","MV_PAR01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A grupo?","A grupo?","A grupo?",         "MV_CH2","C",04,0,0,"G","","SBM","","","MV_PAR02",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"03","De departamento?","De departamento?","De departamento?",         "MV_CH3","C",02,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A departamento?","A departamento?","A departamento?",         "MV_CH4","C",02,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"05","De fecha facturacion?","De fecha facturacion?","De fecha facturacion?",         "MV_CH5","D",08,0,0,"G","","","","","MV_PAR05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A fecha facturacion?","A fecha facturacion?","A fecha facturacion?",         "MV_CH6","D",08,0,0,"G","","","","","MV_PAR06",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"07","De cliente?","De cliente?","De cliente?",         "MV_CH7","C",06,0,0,"G","","SA1","","","MV_PAR07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A cliente?","A cliente?","A cliente?",         "MV_CH8","C",06,0,0,"G","","SA1","","","MV_PAR08",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"09","De vendedor?","De vendedor?","De vendedor?",         "MV_CH9","C",06,0,0,"G","","SA3","","","MV_PAR09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A vendedor?","A vendedor?","A vendedor?",         "MV_CHA","C",06,0,0,"G","","SA3","","","MV_PAR10",""       ,""            ,""        ,""     ,"","")

	xPutSX1(cPerg,"11","Moneda ?" , "Moneda ?" ,"Moneda ?" ,"MV_CHB","N",1,0,0,"C","","","","","MV_PAR11","Bolivianos","Bolivianos","Bolivianos","","Dolares","Dolares","Dolares")

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
