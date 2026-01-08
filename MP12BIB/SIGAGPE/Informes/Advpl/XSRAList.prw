#include "protheus.ch"

#define NORDMAT	1	//Orden: Sucursal + Matric.
#define NORDCC	2	//Orden: Sucursal + C.Costo
#define NORDAP	3	//Orden: Apellido Paterno + Apellido Materno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ XSRAList ³ 				Autor ³: Denar Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Listado de funcionarios (Tabla SRA)		   					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ XSRAList()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP															³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³10/01/2020³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function XSRAList()
	Local oReport
	PRIVATE cPerg   := "XSRAList"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg := "Listado de Funcionarios"

	oReport	 := TReport():New("Lista Funcionarios",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte de Funcionarios", .T.)
	//oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Funcionarios",{"SRA"})
	oReport:SetTotalInLine(.F.)

	//TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"RA_FILIAL"	,"SRA")
	TRCell():New(oSection,"RA_MAT"		,"SRA")
	TRCell():New(oSection,"RA_NOMECMP"	,"SRA")
	TRCell():New(oSection,"RA_RG"		,"SRA")
	TRCell():New(oSection,"RA_UFCI"		,"SRA")
	TRCell():New(oSection,"RA_CIC"		,"SRA")
	TRCell():New(oSection,"RA_ADMISSA"	,"SRA")
	TRCell():New(oSection,"RA_DEMISSA"	,"SRA")
	TRCell():New(oSection,"CTT_CUSTO"	,"CTT")
	TRCell():New(oSection,"CTT_DESC01"	,"CTT", "Desc. CC")
	TRCell():New(oSection,"RJ_FUNCAO"	,"SRJ")
	TRCell():New(oSection,"RJ_DESC"		,"SRJ", "Desc. Función")
	TRCell():New(oSection,"RA_TPAFP"	,"SRA")
	TRCell():New(oSection,"R6_TURNO"	,"SR6")
	TRCell():New(oSection,"R6_DESC"		,"SR6", "Desc. Turno")
	TRCell():New(oSection,"RA_DEPTO"	,"SRA")
	TRCell():New(oSection,"DEPSUP"		,"SQB", "Dpto. Superior")
	TRCell():New(oSection,"QB_DESCRIC"	,"SQB", "Desc. Dpto.")
	TRCell():New(oSection,"RA_CARGO"	,"SRA")
	TRCell():New(oSection,"Q3_DESCSUM"	,"SQ3", "Desc. Cargo")
	TRCell():New(oSection,"RA_SEQTURN"	,"SRA")
	TRCell():New(oSection,"RA_REGRA"	,"SRA")

Return oReport

Static Function PrintReport(oReport)
	Local oSection 	:= oReport:Section(1)
	Local cSituacao	:= mv_par07
	Local cSitQuery	:= ""
	Local cCategoria:= mv_par08
	Local cCatQuery	:= ""
	Local nOrden	:= MV_PAR11
	Local cOrden	:= "% RA_FILIAL, RA_MAT %"

	For nReg:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cSituacao)
			cSitQuery += ","
		Endif
	Next nReg
	cSitQuery := "%" + cSitQuery + "%"

	For nReg:=1 to Len(cCategoria)
		cCatQuery += "'"+Subs(cCategoria,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cCategoria)
			cCatQuery += ","
		Endif
	Next nReg
	cCatQuery := "%" + cCatQuery + "%"

	If(nOrden == NORDCC)
		cOrden:= "% RA_FILIAL, RA_CC %"
	ElseIf(nOrden == NORDAP)
		cOrden:= "% RA_FILIAL, RA_PRISOBR, RA_SECSOBR %"
	EndIf

	#IFDEF TOP
	// Query
	oSection:BeginQuery()
	BeginSql alias "QRYSRA"

		SELECT CTT_CUSTO, CTT_DESC01,
		RJ_FUNCAO, RJ_DESC, R6_TURNO, R6_DESC,
		(SELECT QB_DESCRIC FROM  %Table:SQB% SQB2 WHERE SUBSTRING(SQB.QB_FILIAL, 1, 2) = SUBSTRING(SQB2.QB_FILIAL, 1, 2) AND SQB2.QB_DEPTO = SQB.QB_DEPSUP) AS 'DEPSUP', QB_DESCRIC,
		Q3_DESCSUM,
		SRA.*
		FROM %Table:SRA% SRA
		JOIN %Table:CTT% CTT ON SUBSTRING(CTT.CTT_FILIAL, 1, 2) = SUBSTRING(SRA.RA_FILIAL, 1, 2) AND CTT.CTT_CUSTO = SRA.RA_CC
		JOIN %Table:SRJ% SRJ ON SUBSTRING(SRJ.RJ_FILIAL, 1, 2) = SUBSTRING(SRA.RA_FILIAL, 1, 2) AND SRJ.RJ_FUNCAO = SRA.RA_CODFUNC
		JOIN %Table:SR6% SR6 ON SUBSTRING(SR6.R6_FILIAL, 1, 2) = SUBSTRING(SRA.RA_FILIAL, 1, 2) AND SR6.R6_TURNO = SRA.RA_TNOTRAB
		LEFT JOIN %Table:SQB% SQB ON SUBSTRING(SQB.QB_FILIAL, 1, 2) = SUBSTRING(SRA.RA_FILIAL, 1, 2) AND SQB.QB_DEPTO = SRA.RA_DEPTO
		JOIN %Table:SQ3% SQ3 ON SUBSTRING(SQ3.Q3_FILIAL, 1, 2) = SUBSTRING(SRA.RA_FILIAL, 1, 2) AND SQ3.Q3_CARGO = SRA.RA_CARGO
		WHERE SRA.RA_FILIAL BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND SRA.RA_MAT BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		AND SRA.RA_CC BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
		AND SRA.RA_SITFOLH IN (%Exp:cSitQuery%)
		AND SRA.RA_CATFUNC IN (%Exp:cCatQuery%)
		AND SUBSTRING(SRA.RA_ADMISSA,1,6) <= %Exp:mv_par09%
		AND (SRA.RA_DEMISSA = '' OR SUBSTRING(SRA.RA_DEMISSA,1,6) >= %Exp:mv_par09%)
		AND SRA.RA_PROCES = %Exp:mv_par10%
		AND SRA.%notDel%
		AND CTT.%notDel%
		AND SRJ.%notDel%
		AND SR6.%notDel%
		ORDER BY %Exp:cOrden%

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
	xPutSX1(cPerg,"01","¿De Sucursal?"	, "¿De Sucursal?"	,"¿De Sucursal?"	,"MV_CH1","C",04,0,0,"G","","SM0","","","MV_PAR01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A Sucursal?" 	, "¿A Sucursal?"	,"¿A Sucursal?"		,"MV_CH2","C",04,0,0,"G","","SM0","","","MV_PAR02",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"03","¿De Matrícula?" , "¿De Matrícula?"	,"¿De Matrícula?"	,"MV_CH3","C",06,0,0,"G","","SRA","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"04","¿A Matrícula?" 	, "¿A Matrícula?"	,"¿A Matrícula?"	,"MV_CH4","C",06,0,0,"G","NaoVazio()","SRA","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"05","¿De Centro de costo?" , "¿De Centro de costo?"	,"¿De Centro de costo?"	,"MV_CH5","C",11,0,0,"G","","CTT","004","","MV_PAR05",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"06","¿A Centro de costo?" 	, "¿A Centro de costo?"	,"¿A Centro de costo?"	,"MV_CH6","C",11,0,0,"G","NaoVazio()","CTT","004","","MV_PAR06",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"07","¿Situaciones por imprimir?" , "¿Situaciones por imprimir?"	,"¿Situaciones por imprimir?"	,"MV_CH7","C",05,0,0,"G","fSituacao()","","","","MV_PAR07",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"08","¿Categorías por imprimir?" 	, "¿Categorías por imprimir?"	,"¿Categorías por imprimir?"	,"MV_CH8","C",15,0,0,"G","fCategoria()","","","","MV_PAR08",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"09","¿Periodo (YYYYMM)?" 		, "¿Periodo (YYYYMM)?"		,"¿Periodo (YYYYMM)?"		,"MV_CH9","C",06,0,0,"G","","","","","MV_PAR09",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"10","¿Proceso?"	, "¿Proceso?"	,"¿Proceso?"	,"MV_CHA","C",05,0,0,"G","","RCJ","","","MV_PAR10",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"11","¿Orden?"	, "¿Orden?"		,"¿Orden?"		,"MV_CHB","N",01,0,0,"C","","","","","MV_PAR11","Sucursal+Matric.","Sucursal+Matric.","Sucursal+Matric.","","Sucursal+C.Costo","Sucursal+C.Costo","Sucursal+C.Costo","Apellido Paterno","Apellido Paterno","Apellido Paterno")

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
