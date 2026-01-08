#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ INFNOVED ³ Autor ³ Denar Terrazas							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de apuntes detallado - SIGAPON   					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ InfNoved()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Global - SIGAPON												³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³22/07/2019³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function InfNoved()
	Local oReport
	PRIVATE cPerg   := "INFNOVED"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg := "Informe de Apuntes Detallado"

	oReport	 := TReport():New("INFNOVED",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Informe de novedades detallado")
	// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Apuntes",{"SPC"})
	//oSection2 := TRSection():New(oReport,"reaincmk",{"SN4"})
	oReport:SetTotalInLine(.F.)

	//		Comienzan a elegir los campos que desean Mostrar

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"SUCURSAL"				,"SRA","SUCURSAL")
	TRCell():New(oSection,"MATRICULA"				,"SRA","CODIGO")
	TRCell():New(oSection,"NOMBRE"					,"SRA","APELLIDO Y NOMBRE ", "", 25)
	TRCell():New(oSection,"FECHA"					,"RCG","FECHA", "", 10)
	TRCell():New(oSection,"HORA_EXTRA"				,"SPC","HORA EXTRA")
	TRCell():New(oSection,"HR_EXTRA_NOCTURNA"		,"SPC","HORA EXTRA" + CRLF + "NOCTURNA")
	TRCell():New(oSection,"HORAS_NOCTURNAS"			,"SPC","HORAS" + CRLF + "NOCTURNAS")
	TRCell():New(oSection,"FALTA_JORNADA"			,"SPC","FALTA" + CRLF + "JORNADA")
	TRCell():New(oSection,"FALTA_MEDIA_JORNADA"		,"SPC","FALTA" + CRLF + "1/2 JORNADA")
	TRCell():New(oSection,"DESCUENTO_POR_ATRASOS"	,"SPC","ATRASOS")
	TRCell():New(oSection,"SALIDA_ANTICIPADA"		,"SPC","SALIDA" + CRLF + "ANTICIPADA")
	TRCell():New(oSection,"LICENCIA"				,"SR8","LICENCIA")
	TRCell():New(oSection,"HORAS_ABONO"				,"SPC","HORAS" + CRLF + "A/J")
	TRCell():New(oSection,"DESC_ABONO"				,"SP6","DESCRIPCIÓN" + CRLF + "ABONO/JUSTIFICACIÓN")

	//
	// oBreak = TRBreak():New(oSection,oSection:Cell("N4_FILIAL"),"Sub Total Filial")
	// TRFunction():New(oSection:Cell("VALOR") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	// Imprime una linea Segun la condicion (totalizadora)
	// TRFunction():New(oSection:Cell("B1_VENTAS") ,NIL,"ONPRINT",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/{|| "" },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/,)

	//TRFunction():New(oSection:Cell("VALVENGR")	,NIL,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

Return oReport

Static Function PrintReport(oReport)
	Local oSection	:= oReport:Section(1)
	Local cAliasQry	:= GetNextAlias()
	Local cValida	:= ""
	Local cQuery	:= ""
	
	Local cSuc		:= ""
	Local cMat		:= ""
	Local cNome		:= ""
	Local cDate		:= ""
	Local cAdmissa	:= ""
	Local cDemissa	:= ""
	Local nHExtra	:= 0
	Local nHENoct	:= 0
	Local nNocturn	:= 0
	Local nFaltaJ	:= 0
	Local nFaltaMJ	:= 0
	Local nDescXAt	:= 0
	Local nSalidaA	:= 0
	Local cLicencia	:= ""
	Local nHrAbono	:= 0
	Local cAbono	:= ""
	
	#IFDEF TOP

	cQuery+= "SELECT RA_FILIAL 'SUCURSAL', RA_MAT 'MATRICULA', RA_ADMISSA, RA_DEMISSA, RA_NOME 'NOMBRE', RCG_DIAMES 'FECHA',"
	cQuery+= " COALESCE([028A], 0) 'HORA_EXTRA', COALESCE([037A], 0) 'HR_EXTRA_NOCTURNA' , COALESCE([004A], 0) 'HORAS_NOCTURNAS',"
	cQuery+= " COALESCE([009N], 0) 'FALTA_JORNADA', COALESCE([007N], 0) 'FALTA_MEDIA_JORNADA', "
	cQuery+= " COALESCE([011N], 0) 'DESCUENTO_POR_ATRASOS', COALESCE([013N], 0) 'SALIDA_ANTICIPADA', "
	cQuery+= " COALESCE(LICENCIA, '') 'LICENCIA', COALESCE(PK_HRSABO, 0) 'HORAS_ABONO', COALESCE(P6_DESC, '') 'DESC_ABONO'" 
	cQuery+= " FROM ( "
	cQuery+= " SELECT TC.RA_FILIAL, TC.RA_MAT, TC.RA_NOME, TC.RA_ADMISSA, TC.RA_DEMISSA, SP9.P9_IDPON, (SPC.PC_QUANTC- SPK.PK_HRSABO) PC_QUANTC, TC.RCG_DIAMES, "
	cQuery+= "		TC.LICENCIA, SP6.P6_DESC, SPK.PK_HRSABO "
	cQuery+= " FROM " + RetSqlName("SPC") + " SPC "
	cQuery+= " JOIN " + RetSqlName("SP9") + " SP9 ON SPC.PC_PD = SP9.P9_CODIGO AND SP9.D_E_L_E_T_ <> '*' "
	cQuery+= " LEFT JOIN " + RetSqlName("SPK") + " SPK ON SPK.PK_FILIAL = SPC.PC_FILIAL AND SPK.PK_MAT = SPC.PC_MAT AND SPK.PK_DATA = SPC.PC_DATA AND SPK.PK_CODEVE = SPC.PC_PD AND SPK.D_E_L_E_T_ <> '*'"
	cQuery+= " LEFT JOIN " + RetSqlName("SP6") + " SP6 ON SP6.P6_CODIGO = SPK.PK_CODABO AND SP6.D_E_L_E_T_ <> '*'  "
	cQuery+= " RIGHT JOIN (SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_ADMISSA, SRA.RA_DEMISSA, SRA.RA_NOME, RCG.RCG_DIAMES, "
	cQuery+= " 		(SELECT RCM.RCM_DESCRI "
	cQuery+= " 		FROM " + RetSqlName("SR8") + " SR8 "
	cQuery+= " 		JOIN " + RetSqlName("RCM") + " RCM ON RCM.RCM_TIPO = SR8.R8_TIPOAFA "
	cQuery+= " 		WHERE R8_PER = '" + mv_par09 + "'"
	cQuery+= " 		AND R8_FILIAL = SRA.RA_FILIAL "
	cQuery+= " 		AND R8_MAT = SRA.RA_MAT "
	cQuery+= " 		AND RCG_DIAMES BETWEEN R8_DATAINI AND R8_DATAFIM "
	cQuery+= " 		AND SR8.D_E_L_E_T_ <> '*' "
	cQuery+= " 		AND RCM.D_E_L_E_T_ <> '*') AS LICENCIA "
	cQuery+= " FROM " + RetSqlName("RCG") + " RCG, " + RetSqlName("SRA") + " SRA "
	cQuery+= " WHERE SRA.RA_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cQuery+= " AND (SRA.RA_SITFOLH NOT IN ('T', 'D') OR (SRA.RA_SITFOLH = 'D' AND SUBSTRING(SRA.RA_DEMISSA, 1, 6) = '" + mv_par09 + "')) "
	cQuery+= " AND SRA.RA_MAT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cQuery+= " AND SRA.RA_CC BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	cQuery+= " AND SRA.RA_DEPTO BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' "
	cQuery+= " AND RCG.RCG_PER = '" + mv_par09 + "'"
	cQuery+= " AND RCG.RCG_DIAMES BETWEEN '" + DTOS(mv_par11) + "' AND '" + DTOS(mv_par12) + "' "
	cQuery+= " AND RCG.RCG_MODULO = 'PON' "
	cQuery+= " AND RCG.D_E_L_E_T_ <> '*' "
	cQuery+= " AND SRA.D_E_L_E_T_ <> '*' "
	cQuery+= " ) TC ON SPC.PC_DATA = TC.RCG_DIAMES "
	cQuery+= " AND SPC.PC_PERIODO = '" + mv_par09 + "'"
	cQuery+= " AND SPC.PC_FILIAL = TC.RA_FILIAL "
	cQuery+= " AND SPC.PC_MAT = TC.RA_MAT "
	cQuery+= " AND SPC.PC_NUMPAG = '" + mv_par10 + "'"
	cQuery+= " AND SPC.PC_DATA BETWEEN '" + DTOS(mv_par11) + "' AND '" + DTOS(mv_par12) + "' "
	cQuery+= " AND SPC.D_E_L_E_T_ <> '*' "
	cQuery+= " ) AS ABC "
	cQuery+= " PIVOT( SUM(PC_QUANTC) FOR P9_IDPON in ( [028A], [037A], [004A], [009N], [007N], [011N], [013N])) AS pivote "
	cQuery+= " ORDER BY RA_MAT, RCG_DIAMES DESC "
	cQuery:= ChangeQuery(cQuery)
	
	//Aviso("query",cvaltochar(cQuery),{"si"})
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()
	
	oSection:Init()
	While (cAliasQry)->(! EOF())
		/*If(STOD((cAliasQry)->RA_ADMISSA) <= STOD((cAliasQry)->FECHA))
			If(EMPTY((cAliasQry)->RA_DEMISSA) .OR. STOD((cAliasQry)->RA_DEMISSA) >= STOD((cAliasQry)->FECHA))
				
			EndIf
		EndIf*/
		cValida	:= (cAliasQry)->SUCURSAL + (cAliasQry)->MATRICULA + DTOC(STOD((cAliasQry)->FECHA))
		cSuc	:= (cAliasQry)->SUCURSAL
		cMat	:= (cAliasQry)->MATRICULA
		cNome	:= (cAliasQry)->NOMBRE
		cDate	:= DTOC(STOD((cAliasQry)->FECHA))
		cAdmissa:= (cAliasQry)->RA_ADMISSA
		cDemissa:= (cAliasQry)->RA_DEMISSA
		nHExtra		+= (cAliasQry)->HORA_EXTRA
		nHENoct		+= (cAliasQry)->HR_EXTRA_NOCTURNA
		nNocturn	+= (cAliasQry)->HORAS_NOCTURNAS
		nFaltaJ		+= (cAliasQry)->FALTA_JORNADA
		nFaltaMJ	+= (cAliasQry)->FALTA_MEDIA_JORNADA
		nDescXAt	+= (cAliasQry)->DESCUENTO_POR_ATRASOS
		nSalidaA	+= (cAliasQry)->SALIDA_ANTICIPADA
		cLicencia	+= (cAliasQry)->LICENCIA
		nHrAbono	+= (cAliasQry)->HORAS_ABONO
		cAbono		+= TRIM(IIF(EMPTY(cAbono), (cAliasQry)->DESC_ABONO, IIF(EMPTY((cAliasQry)->DESC_ABONO), cAbono, cAbono + ", " + (cAliasQry)->DESC_ABONO)))
		
		(cAliasQry)->(dbSkip())
		
		If(cValida <> (cAliasQry)->SUCURSAL + (cAliasQry)->MATRICULA + DTOC(STOD((cAliasQry)->FECHA)) .AND. ((STOD(cAdmissa) <= CTOD(cDate)) .AND. ((EMPTY(cDemissa) .OR. STOD(cDemissa) >= CTOD(cDate)))) )
		
			/*cHrExtr		:= STRTRAN(cValToChar(nHExtra), ".", ":")
			cHrExtrN	:= STRTRAN(cValToChar(nHENoct), ".", ":")
			cNocturn	:= STRTRAN(cValToChar(nNocturn), ".", ":")
			cFaltaJ		:= STRTRAN(cValToChar(nFaltaJ), ".", ":")
			cFaltaMJ	:= STRTRAN(cValToChar(nFaltaMJ), ".", ":")
			cDescXAt	:= STRTRAN(cValToChar(nDescXAt), ".", ":")
			cSalidaA	:= STRTRAN(cValToChar(nSalidaA), ".", ":")
			cHrAbono	:= STRTRAN(cValToChar(nHrAbono), ".", ":")*/
			
			oSection:Cell("SUCURSAL"):SetValue( cSuc )
			oSection:Cell("MATRICULA"):SetValue( cMat )
			oSection:Cell("NOMBRE"):SetValue( cNome )
			oSection:Cell("FECHA"):SetValue( cDate )
			oSection:Cell("HORA_EXTRA"):SetValue( nHExtra )
			oSection:Cell("HR_EXTRA_NOCTURNA"):SetValue( nHENoct )
			oSection:Cell("HORAS_NOCTURNAS"):SetValue( nNocturn )
			oSection:Cell("FALTA_JORNADA"):SetValue( nFaltaJ )
			oSection:Cell("FALTA_MEDIA_JORNADA"):SetValue( nFaltaMJ )
			oSection:Cell("DESCUENTO_POR_ATRASOS"):SetValue( nDescXAt )
			oSection:Cell("SALIDA_ANTICIPADA"):SetValue( nSalidaA )
			oSection:Cell("LICENCIA"):SetValue( cLicencia )
			oSection:Cell("HORAS_ABONO"):SetValue( nHrAbono )
			oSection:Cell("DESC_ABONO"):SetValue( cAbono )
			
			oSection:PrintLine(,,,.T.)
			nHExtra		:= 0
			nHENoct		:= 0
			nNocturn	:= 0
			nFaltaJ		:= 0
			nFaltaMJ	:= 0
			nDescXAt	:= 0
			nSalidaA	:= 0
			cLicencia	:= ""
			nHrAbono	:= 0
			cAbono		:= ""
		endIf
	enddo
	
	oSection:Finish()
	
//	If Select("QRY") > 0
//		Dbselectarea("QRY")
//		QRY->(DbClosearea())
//	EndIf
//
//	TcQuery cQuery New Alias "QRY"
//
//	oSection:BeginQuery()
//	oSection:EndQuery({{"QRY"},cQuery})
//	oSection:Print()
	
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
	xPutSX1(cPerg,"01","¿De Sucursal?"			, "¿De Sucursal?"			,"¿De Sucursal?"		,"MV_CH1","C",04,0,0,"G","","SM0","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Sucursal?" 			, "¿A Sucursal?"			,"¿A Sucursal?"			,"MV_CH2","C",04,0,0,"G","","SM0","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿De Matrícula?" 		, "¿De Matrícula?"			,"¿De Matrícula?"		,"MV_CH3","C",06,0,0,"G","","SRA","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Matrícula?" 			, "¿A Matrícula?"			,"¿A Matrícula?"		,"MV_CH4","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿De Centro de costo?" 	, "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH5","C",11,0,0,"G","","CTT","004","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿A Centro de costo?" 	, "¿A Centro de costo?"		,"¿A Centro de costo?"	,"MV_CH6","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿De Departamento?" 		, "¿De Departamento?"		,"¿De Departamento?"	,"MV_CH7","C",09,0,0,"G","","SQB","","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿A Departamento?" 		, "¿A Departamento?"		,"¿A Departamento?"		,"MV_CH8","C",09,0,0,"G","NaoVazio()","SQB","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿Periodo?" 				, "¿Periodo?"				,"¿Periodo?"			,"MV_CH9","C",06,0,0,"G","","RCH","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿Número de Pago?" 		, "¿Número de Pago?"		,"¿Número de Pago?"		,"MV_CHA","C",02,0,0,"G","","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿De Fecha?" 			, "¿De Fecha?"				,"¿De Fecha?"			,"MV_CHB","D",08,0,0,"G","","","","","MV_PAR11",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"12","¿A Fecha?" 				, "¿A Fecha?"				,"¿A Fecha?"			,"MV_CHC","D",08,0,0,"G","","","","","MV_PAR12",""       ,""            ,""        ,""     ,""   ,"")

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
