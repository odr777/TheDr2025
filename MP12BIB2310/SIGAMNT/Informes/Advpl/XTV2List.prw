#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ XTV2List ³ 				Autor ³: Denar Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Listado de actividades Partes Diarios (Tabla TV2)			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ XTV2List()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP															³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Denar     ³31/12/2020³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function XTV2List()
	Local oReport
	Private cPerg   := "XTV2List"   // elija el Nombre de la pregunta

	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local NombreProg := "Actividades Partes Diarios"

	oReport	 := TReport():New("Actividades",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte Actividades Partes Diarios", .T.)

	oSection := TRSection():New(oReport,"Actividades",{"TV1","TV2","ST9","TQR"})
	oReport:SetTotalInLine(.F.)

	//TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"RUTINA","TV1", "Rutina")
	TRCell():New(oSection,"TV1_CODBEM","TV1")
	TRCell():New(oSection,"T9_NOME   ","ST9")
	TRCell():New(oSection,"TQR_TIPMOD","TQR")
	TRCell():New(oSection,"TQR_DESMOD","TQR")
	TRCell():New(oSection,"T7_FABRICA","ST7")
	TRCell():New(oSection,"T7_NOME   ","ST7")
	TRCell():New(oSection,"TV1_OPERAD","TV1")
	TRCell():New(oSection,"TV1_NOMEOP","TV1")
	TRCell():New(oSection,"TV1_DTSERV","TV1")
	TRCell():New(oSection,"TV2_CODFRE","TV2")
	TRCell():New(oSection,"CTT_DESC01","CTT", "Descripción")
	TRCell():New(oSection,"TV2_CODATI","TV2")
	TRCell():New(oSection,"TV0_NOME  ","TV0")
	TRCell():New(oSection,"TV2_HRINI ","TV2")
	TRCell():New(oSection,"TV2_HRFIM ","TV2")
	TRCell():New(oSection,"TV2_TOTHOR","TV2")
	TRCell():New(oSection,"TV2_CONTAD","TV2")
	TRCell():New(oSection,"TV2_XCONIN","TV2")
	TRCell():New(oSection,"TV2_XCONFI","TV2")
	TRCell():New(oSection,"TV2_XTOTCO","TV2")
	TRCell():New(oSection,"TV2_SEQREL","TV2")
	TRCell():New(oSection,"TV2_UITEMC","TV2")
	TRCell():New(oSection,"TV2_UPROJE","TV2")
	TRCell():New(oSection,"TV2_UTAREF","TV2")
	TRCell():New(oSection,"AF9_DESCRI","AF9")
	TRCell():New(oSection,"T9_CODFAMI","ST9")

Return oReport

Static Function PrintReport(oReport)
	Local oSection 	:= oReport:Section(1)

	#IFDEF TOP
	// Query
	oSection:BeginQuery()
	BeginSql alias "QRYTV2"

		SELECT TV1.TV1_CODBEM, ST9.T9_NOME, TQR.TQR_TIPMOD, TQR.TQR_DESMOD, ST7.T7_FABRICA, ST7.T7_NOME, TV1.TV1_OPERAD, TV1.TV1_NOMEOP, TV1.TV1_DTSERV,
		TV2.TV2_CODFRE, COALESCE((SELECT CTT_DESC01 FROM %Table:CTT% WHERE %notDel% AND CTT_CUSTO = TV2.TV2_CODFRE), '') AS CTT_DESC01,
		TV2.TV2_CODATI, TV0.TV0_NOME, TV2.TV2_HRINI, TV2.TV2_HRFIM, TV2.TV2_TOTHOR,
		TV2.TV2_CONTAD, TV2.TV2_XCONIN, TV2.TV2_XCONFI, TV2.TV2_XTOTCO,
		TV2_SEQREL, TV2_UITEMC, TV2_UPROJE, TV2_UTAREF, COALESCE((SELECT AF9_DESCRI FROM %Table:AF9% WHERE %notDel% AND AF9_FILIAL = TV2.TV2_FILIAL AND AF9_PROJET = TV2.TV2_UPROJE AND AF9_TAREFA = TV2.TV2_UTAREF), '') AS AF9_DESCRI,
		CASE
		WHEN TV1_INDERR = '1' THEN 'Ajuste Parte Diaria'
		WHEN TV1_INDERR = '2' THEN 'Parte Diaria'
		ELSE ''
		END AS RUTINA,
		ST9.T9_CODFAMI,
		TV1.*,
		TV2.*,
		ST9.*,
		TQR.*
		FROM %Table:TV1% TV1
		JOIN %Table:TV2% TV2 ON TV1.TV1_FILIAL = TV2.TV2_FILIAL AND TV1.TV1_EMPRES = TV2.TV2_EMPRES AND TV1.TV1_CODBEM = TV2.TV2_CODBEM AND TV1.TV1_DTSERV = TV2.TV2_DTSERV
		JOIN %Table:ST9% ST9 ON ST9.T9_FILIAL = TV1.TV1_FILIAL AND ST9.T9_CODBEM = TV1.TV1_CODBEM
		JOIN %Table:TQR% TQR ON ST9.T9_FILIAL = TQR_FILIAL AND ST9.T9_TIPMOD = TQR.TQR_TIPMOD
		JOIN %Table:ST7% ST7 ON ST7.T7_FILIAL = ST9.T9_FILIAL AND ST7.T7_FABRICA = TQR.TQR_FABRIC
		JOIN %Table:TV0% TV0 ON TV0.TV0_CODATI = TV2_CODATI
		WHERE TV1.TV1_DTSERV BETWEEN %Exp:DTOS(MV_PAR01)% AND %Exp:DTOS(MV_PAR02)%
		AND TV1.TV1_CODBEM BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND TV1.TV1_OPERAD BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND TV1.%notDel%
		AND TV2.%notDel%
		AND ST9.%notDel%
		AND TQR.%notDel%
		AND ST7.%notDel%
		AND TV0.%notDel%
		ORDER BY TV1.TV1_CODBEM, TV1.TV1_DTSERV

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

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","¿De Fecha?"	, "¿De Fecha?"	,"¿De Fecha?"	,"MV_CH1","D",08,0,0,"G","","","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Fecha?" 	, "¿A Fecha?"	,"¿A Fecha?"		,"MV_CH2","D",08,0,0,"G","NaoVazio()","","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿De Bien?" , "¿De Bien?"	,"¿De Bien?"	,"MV_CH3","C",16,0,0,"G","","ST9","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Bien?" 	, "¿A Bien?"	,"¿A Bien?"	,"MV_CH4","C",16,0,0,"G","NaoVazio()","ST9","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿De Operador?" , "¿De Operador?"	,"¿De Operador?"	,"MV_CH5","C",06,0,0,"G","","SRA","","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿A Operador?" 	, "¿A Operador?"	,"¿A Operador?"	,"MV_CH6","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")

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
