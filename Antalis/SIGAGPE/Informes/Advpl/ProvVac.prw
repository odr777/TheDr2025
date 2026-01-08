#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ProvVac  ³ 				Autor ³: Omar Delgadillo			³±±
±±³Fun‡…o    ³          ³ 				Query ³: 			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de provisión de vacaciones							³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tipo      ³ ProvVac()	 	                                         	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ProvVac()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Resultar														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³ 12/06/2024³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function ProvVac()
	Local oReport
	PRIVATE cPerg   := "ProvVac"   // Elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local cNomeArq := "Provision-vac-" + DTOS( DATE() )

	oReport	 := TReport():New(cNomeArq,"Provisión de Vacaciones",cPerg,{|oReport| PrintReport(oReport)},"Reporte de Provisión de Vacaciones", .F.)
	//oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Provisión de Vacaciones",{"SRD"})
	oReport:SetTotalInLine(.F.)

	//TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"FILIAL"		,"SRA", "Sucursal",,TamSX3("RA_FILIAL")[1])
	TRCell():New(oSection,"MAT"			,"SRA", "Matrícula",,TamSX3("RA_MAT")[1])
	TRCell():New(oSection,"NOME"		,"SRA", "Nombre",,TamSX3("RA_NOME")[1])
	TRCell():New(oSection,"CI"			,"SRA", "Cédula",,TamSX3("RA_RG")[1])
	TRCell():New(oSection,"EXT"			,"SRA", "Ext.",,TamSX3("RA_UFCI")[1])
	TRCell():New(oSection,"CC"			,"SRA", "Centro de Costo",,TamSX3("RA_CC")[1])
	TRCell():New(oSection,"ADMISSA"		,"SRA", "F. Ingreso",,TamSX3("RA_ADMISSA")[1])
	TRCell():New(oSection,"DEMISSA"		,"SRA", "F. Retiro",,TamSX3("RA_DEMISSA")[1])
	TRCell():New(oSection,"SALDO"		,"SRD", "Saldo Vac.",,5)
	TRCell():New(oSection,"PROMEDIO"	,"SRD", "Prom. Sueldo",,10)
	TRCell():New(oSection,"PROVISION"	,"SRD", "Provisión",,10)

Return oReport

Static Function PrintReport(oReport)
	Local oSection 	:= oReport:Section(1)

	// obtener periodo abierto
	// Local cPerAbi := getOpenPeriod(mv_par07)

	#IFDEF TOP
	// Query
	oSection:BeginQuery()
	BeginSql alias "QRYSR6"

		SELECT SRC.RC_FILIAL FILIAL, SRC.RC_MAT MAT, SRA.RA_NOME NOME, SRA.RA_RG CI, SRA.RA_UFCI AS EXT, SRA.RA_CC CC, 
				SUBSTRING(SRA.RA_ADMISSA,7,2) + '/' + SUBSTRING(SRA.RA_ADMISSA,5,2) + '/' + SUBSTRING(SRA.RA_ADMISSA,1,4) AS ADMISSA,
				SUBSTRING(SRA.RA_DEMISSA,7,2) + '/' + SUBSTRING(SRA.RA_DEMISSA,5,2) + '/' + SUBSTRING(SRA.RA_DEMISSA,1,4) AS DEMISSA,
				MAX(CASE WHEN SRC.RC_PD = '630' THEN (SRC.RC_HORAS) END) AS SALDO,
				MAX(CASE WHEN SRC.RC_PD = '629' THEN (SRC.RC_VALOR) END) AS PROMEDIO,
				MAX(CASE WHEN SRC.RC_PD = '630' THEN (SRC.RC_VALOR) END) AS PROVISION
		FROM %Table:SRC% SRC 
		INNER JOIN %Table:SRA% SRA ON SRA.RA_FILIAL = SRC.RC_FILIAL AND SRA.RA_MAT = SRC.RC_MAT 
		WHERE 	SRC.%notDel% AND SRA.%notDel%
				AND SRC.RC_FILIAL 	BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
				AND SRC.RC_MAT  	BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
				AND SRC.RC_CC		BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
				AND SRC.RC_PROCES	= %Exp:mv_par07% 
				AND SRC.RC_PERIODO	= %Exp:mv_par08% 
				AND SRC.RC_SEMANA	= %Exp:mv_par09% 
				AND SRC.RC_PD IN ('629','630')
		GROUP BY SRC.RC_FILIAL, SRC.RC_MAT, SRA.RA_NOME, SRA.RA_RG, SRA.RA_UFCI, SRA.RA_CC, SRA.RA_ADMISSA, SRA.RA_DEMISSA 
		UNION
		SELECT SRD.RD_FILIAL FILIAL, SRD.RD_MAT MAT, SRA.RA_NOME NOME, SRA.RA_RG CI, SRA.RA_UFCI AS EXT, SRA.RA_CC CC,
				SUBSTRING(SRA.RA_ADMISSA,7,2) + '/' + SUBSTRING(SRA.RA_ADMISSA,5,2) + '/' + SUBSTRING(SRA.RA_ADMISSA,1,4) AS ADMISSA,
				SUBSTRING(SRA.RA_DEMISSA,7,2) + '/' + SUBSTRING(SRA.RA_DEMISSA,5,2) + '/' + SUBSTRING(SRA.RA_DEMISSA,1,4) AS DEMISSA,
				MAX(CASE WHEN SRD.RD_PD = '630' THEN (SRD.RD_HORAS) END) AS SALDO,
				MAX(CASE WHEN SRD.RD_PD = '629' THEN (SRD.RD_VALOR) END) AS PROMEDIO,
				MAX(CASE WHEN SRD.RD_PD = '630' THEN (SRD.RD_VALOR) END) AS PROVISION
		FROM %Table:SRD% SRD 
		INNER JOIN %Table:SRA% SRA ON SRA.RA_FILIAL = SRD.RD_FILIAL AND SRA.RA_MAT = SRD.RD_MAT 
		WHERE 	SRD.%notDel% AND SRA.%notDel%
				AND SRD.RD_FILIAL 	BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
				AND SRD.RD_MAT  	BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
				AND SRD.RD_CC		BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
				AND SRD.RD_PROCES	= %Exp:mv_par07% 
				AND SRD.RD_PERIODO	= %Exp:mv_par08% 
				AND SRD.RD_SEMANA	= %Exp:mv_par09% 
				AND SRD.RD_PD IN ('629','630')
		GROUP BY SRD.RD_FILIAL, SRD.RD_MAT, SRA.RA_NOME, SRA.RA_RG, SRA.RA_UFCI, SRA.RA_CC, SRA.RA_ADMISSA, SRA.RA_DEMISSA
		ORDER BY FILIAL, MAT

	EndSql

	// Aviso("QRYSR6",GetLastQuery()[2],{"OK"},,,,,.T.)

	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
	oSection:EndQuery()

	#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

	oSection:Print()

Return

/**
* @author: Denar Terrazas Parada
* @since: 31/01/2022
* @description: Función que obtiene el periodo abierto de FOL
**********************************
* @modificado: Omar Delgadillo
* @since: 15/05/2024
* @description: Agregar parámetro Proceso
*/

Static Function getOpenPeriod(cProceso)
	Local aArea			:= getArea()
	Local cRet			:= ""
	Local cNextAlias:= GetNextAlias()

	// consulta a la base de datos
	BeginSql Alias cNextAlias

    SELECT TOP 1 RCH_PER
    FROM %table:RCH%
    WHERE RCH_FILIAL = %exp:xFilial("RCH")%
    AND RCH_ROTEIR = 'FOL'
    AND RCH_PERSEL = '1'
	AND RCH_PROCES = %exp:cProceso%
    AND %notdel%

	EndSql
	DbSelectArea(cNextAlias)
	If (cNextAlias)->(!Eof())
		cRet:= TRIM((cNextAlias)->RCH_PER)
	endIf

	restArea(aArea)

Return cRet

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

	xPutSX1(cPerg,"01","¿De Sucursal?"			, "¿De Sucursal?"			,"¿De Sucursal?"		,"MV_CH1","C",04,0,0,"G","","SM0","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Sucursal?" 			, "¿A Sucursal?"			,"¿A Sucursal?"			,"MV_CH2","C",04,0,0,"G","","SM0","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿De Matrícula?" 		, "¿De Matrícula?"			,"¿De Matrícula?"		,"MV_CH3","C",06,0,0,"G","","SRA","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Matrícula?" 			, "¿A Matrícula?"			,"¿A Matrícula?"		,"MV_CH4","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿De Centro de costo?" 	, "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH5","C",11,0,0,"G","","CTT","004","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿A Centro de costo?" 	, "¿A Centro de costo?"		,"¿A Centro de costo?"	,"MV_CH6","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿Proceso?"				, "¿Proceso?"				,"¿Proceso?"			,"MV_CH7","C",05,0,0,"G","","RCJ","","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿Periodo?" 				, "¿Periodo?"				,"¿Periodo?"			,"MV_CH8","C",06,0,0,"G","","RCH","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿Número de Pago?" 		, "¿Número de Pago?"		,"¿Número de Pago?"		,"MV_CH9","C",02,0,0,"G","","","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")

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
