#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CREDXREC ³ Autor ³ Denar Terrazas							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de Crédito Fiscal por Recuperar						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CREDXREC()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Global														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³30/08/2019³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function CREDXREC()
	Local oReport
	PRIVATE cPerg   := "CREDXREC"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg := "Informe de Crédito Fiscal por Recuperar"

	oReport	 := TReport():New("CREDXREC",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Informe de Crédito Fiscal por Recuperar")
	oReport:nfontbody:=8
	// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Crédito Fiscal",{"SF1"})
	//oSection2 := TRSection():New(oSection,"Informe",{"SF1"})
	oSection2 := TRSection():New(oReport,"DETALLE DEL INFORME",,)
	oReport:SetTotalInLine(.F.)

	//		Comienzan a elegir los campos que desean Mostrar

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"F1_FORNECE"			,"SF1","PROVEEDOR")
	TRCell():New(oSection,"A2_NOME"				,"SA2","")

	TRCell():New(oSection2,"F1_HAWB"			,"SF1","IMPORTACIÓN")
	TRCell():New(oSection2,"F1_LOJA"			,"SF1","TIENDA")
	TRCell():New(oSection2,"F1_DOC"				,"SF1","DOCUMENTO")
	TRCell():New(oSection2,"F1_SERIE"			,"SF1","SERIE")
	TRCell():New(oSection2,"F1_EMISSAO"			,"SF1","FECHA DE EMISIÓN")
	TRCell():New(oSection2,"CF_REC"				,"SF1","CF_REC")
	TRCell():New(oSection2,"CRED_FISC"			,"SF1","CRED_FISC")
	
	oBreak = TRBreak():New(oSection2,oSection:Cell("F1_FORNECE"),"Sub Total por Proveedor")
	TRFunction():New(oSection2:Cell("CF_REC") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oSection2:Cell("CRED_FISC") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)

	//
	// oBreak = TRBreak():New(oSection,oSection:Cell("N4_FILIAL"),"Sub Total Filial")
	// TRFunction():New(oSection:Cell("VALOR") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	// Imprime una linea Segun la condicion (totalizadora)
	// TRFunction():New(oSection:Cell("B1_VENTAS") ,NIL,"ONPRINT",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/{|| "" },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/,)

	//TRFunction():New(oSection:Cell("VALVENGR")	,NIL,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

Return oReport

Static Function PrintReport(oReport)
	Local oSection	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local cAliasQry	:= GetNextAlias()
	Local cQuery	:= ""
	Local cProvAnt	:= ""

	#IFDEF TOP

	cQuery:= " SELECT F1_FORNECE, F1_LOJA, F1_HAWB, F1_DOC, F1_SERIE, SF1.F1_EMISSAO, SA2.A2_NOME, "
	cQuery+= " SUM(CASE WHEN F4_GERALF='1' THEN 0 ELSE D1_VALIMP1 END) CF_REC, "
	cQuery+= " SUM(CASE WHEN F4_GERALF='1' THEN D1_VALIMP1 ELSE 0 END) CRED_FISC "
	cQuery+= " FROM " + RetSqlName("SF1") + " SF1, " + RetSqlName("SD1") + " SD1, " + RetSqlName("SF4") + " SF4, " + RetSqlName("SFC") + " SFC, " + RetSqlName("SA2") + " SA2 "
	cQuery+= " WHERE SF1.D_E_L_E_T_ = ' ' AND SD1.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' AND SFC.D_E_L_E_T_ = ' ' AND SA2.D_E_L_E_T_ = ' '          "
	cQuery+= " AND F1_FILIAL = D1_FILIAL AND F1_DOC = D1_DOC AND F1_SERIE = F1_SERIE AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA "
	cQuery+= " AND SD1.D1_TES = SF4.F4_CODIGO                                                                                                          "
	cQuery+= " AND SF4.F4_CODIGO = SFC.FC_TES                                                                                                          "
	cQuery+= " AND SF1.F1_FORNECE = SA2.A2_COD AND F1_LOJA = SA2.A2_LOJA                                                                               "
	cQuery+= " AND SFC.FC_IMPOSTO = 'IVA'                                                                                                              "
	cQuery+= " AND SF1.F1_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery+= " AND SF1.F1_FORNECE BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
	cQuery+= " AND SF1.F1_LOJA BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
	cQuery+= " AND SF1.F1_DTDIGIT BETWEEN '" + DTOS(mv_par07) + "' AND '" + DTOS(mv_par08) + "'"
	cQuery+= " AND SF1.F1_EMISSAO BETWEEN '" + DTOS(mv_par09) + "' AND '" + DTOS(mv_par10) + "'"
	cQuery+= " AND SF1.F1_HAWB BETWEEN '" + mv_par11 + "' AND '" + mv_par12 + "'"
	cQuery+= " AND SF1.F1_DOC BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "'"
	cQuery+= " AND SF1.F1_SERIE BETWEEN '" + mv_par15 + "' AND '" + mv_par16 + "'"
	cQuery+= " GROUP BY F1_FORNECE, F1_LOJA, F1_HAWB, F1_DOC, F1_SERIE, SF1.F1_EMISSAO, SA2.A2_NOME                                                    "
	cQuery+= " ORDER BY 1, 3, 4, 5, 6, 7

	cQuery:= ChangeQuery(cQuery)

	//Aviso("query",cvaltochar(cQuery),{"si"})

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()


	While (cAliasQry)->(! EOF())
		If(cProvAnt != (cAliasQry)->F1_FORNECE)
			oSection:Init()
			oSection2:Init()
			oSection:Cell("F1_FORNECE"):SetValue( (cAliasQry)->F1_FORNECE )
			oSection:Cell("A2_NOME"):SetValue( (cAliasQry)->A2_NOME )
			oSection:PrintLine(,,,.T.)
			oSection:Finish()
			cProvAnt:= (cAliasQry)->F1_FORNECE
		EndIf

		oSection2:Cell("F1_HAWB"):SetValue( (cAliasQry)->F1_HAWB )
		oSection2:Cell("F1_LOJA"):SetValue( (cAliasQry)->F1_LOJA )
		oSection2:Cell("F1_DOC"):SetValue( (cAliasQry)->F1_DOC )
		oSection2:Cell("F1_SERIE"):SetValue( (cAliasQry)->F1_SERIE )
		oSection2:Cell("F1_EMISSAO"):SetValue( DTOC(STOD((cAliasQry)->F1_EMISSAO)) )
		oSection2:Cell("CF_REC"):SetValue( (cAliasQry)->CF_REC )
		oSection2:Cell("CRED_FISC"):SetValue( (cAliasQry)->CRED_FISC )

		oSection2:PrintLine(,,,.T.)

		(cAliasQry)->(dbSkip())
		If(cProvAnt != (cAliasQry)->F1_FORNECE .OR. (cAliasQry)->(EOF()) )
			oSection2:Finish()
		EndIf

	enddo

	#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

Return

Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica

	Local aArea          := GetArea()
	Local aCabec     := {}
	Local cChar          := chr(160) // caracter dummy para alinhamento do cabeçalho
	Local titulo     := oReport:Title()
	Local page := oReport:Page()

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
	/*
	Código del proveedor Inicial y Final (F1_FORNECE)
	Tienda del Proveedor Inicial y final (F1_LOJA)
	Fecha de digitación Inicial y Final (F1_DTDIGIT)
	Fecha de emisión Inicial y Final (F1_EMISSAO)
	Importación Inicial y Final (F1_HAWB)
	Nro de Documento Inicial y Final (F1_DOC)
	Serie del Doc Inicial y Final (F1_SERIE)
	*/

	xPutSX1(cPerg,"01","¿De Sucursal?"		, "¿De Sucursal?"		,"¿De Sucursal?"	,"MV_CH1","C",04,0,0,"G","","SM0","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Sucursal?" 		, "¿A Sucursal?"		,"¿A Sucursal?"		,"MV_CH2","C",04,0,0,"G","","SM0","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿De Proveedor?"		, "¿De Proveedor?"		,"¿De Proveedor?"	,"MV_CH3","C",06,0,0,"G","","FOR","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Proveedor?" 		, "¿A Proveedor?"		,"¿A Proveedor?"	,"MV_CH4","C",06,0,0,"G","","FOR","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿De Tienda?" 		, "¿De Tienda?"			,"¿De Tienda?"		,"MV_CH5","C",02,0,0,"G","","","","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿A Tienda?" 		, "¿A Tienda?"			,"¿A Tienda?"		,"MV_CH6","C",02,0,0,"G","NaoVazio()","","","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿De Fecha de Digitación?" 	, "¿De Fecha de Digitación?"	,"¿De Fecha de Digitación?"		,"MV_CH7","D",08,0,0,"G","","","","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿A Fecha de Digitación?" 	, "¿A Fecha de Digitación?"		,"¿A Fecha de Digitación?"		,"MV_CH8","D",08,0,0,"G","","","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿De Fecha de Emisión?" 		, "¿De Fecha de Emisión?"		,"¿De Fecha de Emisión?"		,"MV_CH9","D",08,0,0,"G","","","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿A Fecha de Emisión?" 		, "¿A Fecha de Emisión?"		,"¿A Fecha de Emisión?"			,"MV_CHA","D",08,0,0,"G","","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿De Importación?" 	, "¿De Importación?"	,"¿De Importación?"	,"MV_CHB","C",17,0,0,"G","","","","","MV_PAR11",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"12","¿A Importación?" 	, "¿A Importación?"		,"¿A Importación?"	,"MV_CHC","C",17,0,0,"G","NaoVazio()","","","","MV_PAR12",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"13","¿De Documento?" 	, "¿De Documento?"		,"¿De Documento?"	,"MV_CHD","C",18,0,0,"G","","","","","MV_PAR13",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"14","¿A Documento?" 		, "¿A Documento?"		,"¿A Documento?"	,"MV_CHE","C",18,0,0,"G","NaoVazio()","","","","MV_PAR14",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"15","¿De Serie?" 		, "¿De Serie?"			,"¿De Serie?"		,"MV_CHF","C",03,0,0,"G","","","","","MV_PAR15",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"16","¿A Serie?" 			, "¿A Serie?"			,"¿A Serie?"		,"MV_CHG","C",03,0,0,"G","NaoVazio()","","","","MV_PAR16",""       ,""            ,""        ,""     ,""   ,"")

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
