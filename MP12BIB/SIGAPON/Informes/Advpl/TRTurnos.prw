#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TRTurnos ³ 				Autor ³: Denar Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de los Turnos de trabajo con las jornadas y horarios	³±±
±±³          ³ correspondientes                                         	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tipo      ³ TReport()	 	                                         	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRTurnos()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP															³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fecha     ³ 23/03/2020³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function TRTurnos()
	Local oReport
	PRIVATE cPerg   := "TRTurnos"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local cNomeArq := "Turnos-" + DTOS( DATE() )

	oReport	 := TReport():New(cNomeArq,"Turnos",cPerg,{|oReport| PrintReport(oReport)},"Reporte de Turnos", .F.)
	//oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Turnos",{"RFA"})
	oReport:SetTotalInLine(.F.)

	//TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"R6_TURNO"	,"SR6")
	TRCell():New(oSection,"R6_DESC"		,"SR6")
	TRCell():New(oSection,"RF2_HOR"		,"RF2")
	TRCell():New(oSection,"RF8_DESC"	,"RF8")
	TRCell():New(oSection,"RF2_SEMANA"	,"RF2")
	TRCell():New(oSection,"DIA_DESC"	,"SX5", "Dia")
	TRCell():New(oSection,"TIPODIA"		,"RF5", "Tipo de Dia")
	TRCell():New(oSection,"RF4_JORN"	,"RF4")
	TRCell():New(oSection,"RF3_DESC"	,"RF3")
	

Return oReport

Static Function PrintReport(oReport)
	Local oSection 	:= oReport:Section(1)
	Local cHorario	:= mv_par04
	Local cJornada	:= mv_par05
	Local cQryHor	:= "% RF4.RF4_HOR LIKE '%' %"
	Local cQryJor	:= "% RF3.RF3_JORN LIKE '%' %"
	
	If(!Empty(cHorario))
		cQryHor:= "% RF4.RF4_HOR = '" + cHorario + "' %"
	EndIf
	
	If(!Empty(cJornada))
		cQryJor:= "% RF3.RF3_JORN = '" + cJornada + "' %"
	EndIf

	#IFDEF TOP
	// Query
	oSection:BeginQuery()
	BeginSql alias "QRYSR6"

		SELECT SR6.R6_TURNO, SR6.R6_DESC, RF2.RF2_HOR,
		(SELECT TOP 1 RF8.RF8_DESC FROM %Table:RF8% RF8 WHERE RF8.%notDel% AND RF8.RF8_HOR = RF2.RF2_HOR) RF8_DESC,
		RF2.RF2_SEMANA, RF2.RF2_TIPOD, RF5.RF5_TPDIA,
		TIPODIA = 
		CASE RF5.RF5_TPDIA
			WHEN 'S' THEN 'Dia trabajado'
			WHEN 'N' THEN 'Dia no trabajado'
			WHEN 'D' THEN 'Descanso semanal remunerado (DSR)'
			WHEN 'C' THEN 'Dia compensado'
			ELSE ''
		END,
		RF4.RF4_DIA, IIF(RF4.RF4_DIA = '1', '8', RF4.RF4_DIA) DIA,
		(SELECT SX5.X5_DESCSPA FROM %Table:SX5% SX5 WHERE SX5.X5_TABELA = 'FQ' AND SX5.X5_CHAVE = RF4.RF4_DIA AND SX5.%notDel%) DIA_DESC,
		RF4.RF4_JORN, RF3.RF3_DESC
		FROM %Table:RF2% RF2
		INNER JOIN %Table:SR6% SR6 ON SR6.%notDel% AND RF2.RF2_FILIAL+RF2.RF2_TURNO = SR6.R6_FILIAL+SR6.R6_TURNO
		AND SR6.R6_FILIAL = %Exp:mv_par01%
		AND SR6.R6_TURNO BETWEEN %Exp:mv_par02% AND %Exp:mv_par03%
		INNER JOIN %Table:RF4% RF4 ON RF4.%notDel% AND RF2.RF2_HOR = RF4.RF4_HOR
		AND RF4.RF4_FILIAL = %Exp:mv_par01%
		AND %Exp:cQryHor%
		INNER JOIN %Table:RF3% RF3 ON RF3.%notDel% AND RF3.RF3_JORN = RF4.RF4_JORN
		AND RF3.RF3_FILIAL = %Exp:mv_par01%
		AND %Exp:cQryJor%
		INNER JOIN %Table:RF5% RF5 ON RF5.%notDel% AND RF5.RF5_TIPO = RF2.RF2_TIPOD AND RF5.RF5_DIA = RF4.RF4_DIA
		AND RF5.RF5_FILIAL = %Exp:mv_par01%
		WHERE RF2.%notDel%
		ORDER BY SR6.R6_TURNO, RF2.RF2_HOR, RF2.RF2_SEMANA, DIA

	EndSql

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
	
	xPutSX1(cPerg,"01","¿Empresa?"	, "¿Empresa?"	,"¿Empresa?"	,"MV_CH1","C",02,0,0,"G","NaoVazio()","EMP","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿De Turno?" , "¿De Turno?"	,"¿De Turno?"	,"MV_CH2","C",03,0,0,"G","","SR6","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿A Turno?" 	, "¿A Turno?"	,"¿A Turno?"	,"MV_CH3","C",03,0,0,"G","NaoVazio()","SR6","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿Horario?" 	, "¿Horario?"	,"¿Horario?"	,"MV_CH4","C",03,0,0,"G","","RF8","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿Jornada?" 	, "¿Jornada?"	,"¿Jornada?"	,"MV_CH5","C",03,0,0,"G","","RF3","","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	
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