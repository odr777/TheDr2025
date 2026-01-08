#include "protheus.ch"
#INCLUDE "TOPCONN.CH"

#Define NNAME	1
#Define NALIAS	2
#Define NTITULO	3

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRFaltas ³ Autor ³ Denar Terrazas							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de faltas detallado - SIGAPON   					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRFaltas()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Global - SIGAPON												³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³21/10/2019³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function TRFaltas()
	Local oReport
	Private cPerg   := "TRFALTAS"   // elija el Nombre de la pregunta
	Private aCab	:= {}
	Private aDadoCab:= {}
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	aCab	:= getCalen()
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg:= "Informe de Faltas Detallado"

	oReport	 := TReport():New("TRFaltas",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Informe de Faltas detallado")
	// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Faltas",{"SPC"})
	//oSection2 := TRSection():New(oReport,"reaincmk",{"SN4"})
	oReport:SetTotalInLine(.F.)

	//		Comienzan a elegir los campos que desean Mostrar

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
	
	TRCell():New(oSection, "PC_FILIAL", "SPC", "Sucursal")
	TRCell():New(oSection, "PC_MAT", "SPC", "Matricula")
	TRCell():New(oSection, "RA_NOME", "SRA", "Nombre")
	for i:= 1 to Len(aCab)
		TRCell():New(oSection, aCab[i][NNAME], aCab[i][NALIAS],aCab[i][NTITULO])
	next i

	//
	// oBreak = TRBreak():New(oSection,oSection:Cell("N4_FILIAL"),"Sub Total Filial")
	// TRFunction():New(oSection:Cell("VALOR") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	// Imprime una linea Segun la condicion (totalizadora)
	// TRFunction():New(oSection:Cell("B1_VENTAS") ,NIL,"ONPRINT",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/{|| "" },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/,)

	//TRFunction():New(oSection:Cell("VALVENGR")	,NIL,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

Return oReport

Static Function PrintReport(oReport)
	Local aArea		:= getArea()
	Local oSection	:= oReport:Section(1)
	Local cAliasQry	:= GetNextAlias()
	Local cValida	:= ""
	Local cQuery	:= ""
	Local nRegua	:= 0

	#IFDEF TOP

	// consulta a la base de datos
	BeginSql Alias cAliasQry

		SELECT PC_FILIAL, PC_MAT, RA_NOME, PC_DATA, PC_PD, P9_CODIGO, P9_DESC, COALESCE(PK_CODABO, '') PK_CODABO, COALESCE(R8_TIPOAFA, '') R8_TIPOAFA
		FROM %table:SPC% SPC
		JOIN %table:SRA% SRA ON SPC.PC_FILIAL = SRA.RA_FILIAL AND SPC.PC_MAT = SRA.RA_MAT
		JOIN %table:SP9% SP9 ON SP9.P9_CODIGO = SPC.PC_PD
		LEFT JOIN %table:SPK% SPK ON SPK.PK_FILIAL = SPC.PC_FILIAL AND SPK.PK_MAT = SPC.PC_MAT AND SPK.PK_DATA = SPC.PC_DATA AND SPK.PK_CODEVE = SPC.PC_PD AND SPK.%notdel%
		LEFT JOIN %table:SR8% SR8 ON SR8.R8_FILIAL = SPC.PC_FILIAL AND SR8.R8_MAT = SPC.PC_MAT AND SPC.PC_DATA BETWEEN SR8.R8_DATAINI AND SR8.R8_DATAFIM AND SR8.%notdel%
		WHERE PC_FILIAL BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
		AND PC_MAT BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
		AND PC_CC BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
		AND PC_DEPTO BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08%
		AND PC_DATA BETWEEN %exp:DTOS(MV_PAR09)% AND %exp:DTOS(MV_PAR10)%
		AND P9_IDPON IN ('009N', '007N')
		AND SPC.%notdel%
		AND SP9.%notdel%
		UNION
		SELECT PH_FILIAL, PH_MAT, RA_NOME, PH_DATA, PH_PD, P9_CODIGO, P9_DESC, COALESCE(PK_CODABO, '') PK_CODABO, COALESCE(R8_TIPOAFA, '') R8_TIPOAFA
		FROM %table:SPH% SPH
		JOIN %table:SRA% SRA ON SPH.PH_FILIAL = SRA.RA_FILIAL AND SPH.PH_MAT = SRA.RA_MAT
		JOIN %table:SP9% SP9 ON SP9.P9_CODIGO = SPH.PH_PD
		LEFT JOIN %table:SPK% SPK ON SPK.PK_FILIAL = SPH.PH_FILIAL AND SPK.PK_MAT = SPH.PH_MAT AND SPK.PK_DATA = SPH.PH_DATA AND SPK.PK_CODEVE = SPH.PH_PD AND SPK.%notdel%
		LEFT JOIN %table:SR8% SR8 ON SR8.R8_FILIAL = SPH.PH_FILIAL AND SR8.R8_MAT = SPH.PH_MAT AND SPH.PH_DATA BETWEEN SR8.R8_DATAINI AND SR8.R8_DATAFIM AND SR8.%notdel%
		WHERE PH_FILIAL BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
		AND PH_MAT BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
		AND PH_CC BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
		AND PH_DEPTO BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08%
		AND PH_DATA BETWEEN %exp:DTOS(MV_PAR09)% AND %exp:DTOS(MV_PAR10)%
		AND P9_IDPON IN ('009N', '007N')
		AND SPH.%notdel%
		AND SP9.%notdel%
		ORDER BY PC_FILIAL, PC_MAT, PC_DATA

	EndSql

	DbSelectArea(cAliasQry)
	oSection:Init()
	while (cAliasQry)->(!Eof())
		cValida	:= (cAliasQry)->PC_FILIAL + (cAliasQry)->PC_MAT
		cSuc	:= (cAliasQry)->PC_FILIAL
		cMat	:= (cAliasQry)->PC_MAT
		cNome	:= (cAliasQry)->RA_NOME
		nPos	:= ASCAN(aDadoCab, (cAliasQry)->PC_DATA)
		cDesc	:= (cAliasQry)->P9_CODIGO
		If(!EMPTY((cAliasQry)->PK_CODABO))
			cDesc	:= (cAliasQry)->PK_CODABO
		ElseIf(!EMPTY((cAliasQry)->R8_TIPOAFA))
			cDesc	:= (cAliasQry)->R8_TIPOAFA
		EndIf
		(cAliasQry)->(dbSkip())
		oSection:Cell(aCab[nPos][NNAME]):SetValue( cDesc )

		If(cValida <> (cAliasQry)->PC_FILIAL + (cAliasQry)->PC_MAT)
			oSection:Cell("PC_FILIAL"):SetValue( cSuc )
			oSection:Cell("PC_MAT"):SetValue( cMat )
			oSection:Cell("RA_NOME"):SetValue( cNome )

			oSection:PrintLine(,,,.T.)
		endIf
	enddo

	oSection:Finish()

	#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

	restArea(aArea)
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

/**
*
* @author: Denar Terrazas Parada
* @since: 21/10/2019
* @description: Funcion que devuelve el calendario en un array de acuerdo a los parámetros informados
*/
static function getCalen()
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul
		SELECT RCG_DIAMES
		FROM %table:RCG% RCG
		WHERE RCG.RCG_DIAMES BETWEEN %exp:DTOS(MV_PAR09)% AND %exp:DTOS(MV_PAR10)%
		AND RCG.RCG_MODULO = 'PON'
		AND RCG.%notdel%
		ORDER BY RCG_DIAMES
	EndSql

	DbSelectArea(OrdenConsul)
	while (OrdenConsul)->(!Eof())
		AADD(aRet, { (OrdenConsul)->RCG_DIAMES, "RCG", DTOC(STOD((OrdenConsul)->RCG_DIAMES)) })
		AADD(aDadoCab, (OrdenConsul)->RCG_DIAMES)
		(OrdenConsul)->(dbSkip())
	enddo
	restArea(aArea)
return aRet

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
	xPutSX1(cPerg,"09","¿De Fecha?" 			, "¿De Fecha?"				,"¿De Fecha?"			,"MV_CH9","D",08,0,0,"G","","","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿A Fecha?" 				, "¿A Fecha?"				,"¿A Fecha?"			,"MV_CHA","D",08,0,0,"G","","","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")

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
