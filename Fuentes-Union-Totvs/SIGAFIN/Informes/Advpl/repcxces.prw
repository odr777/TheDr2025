#include "totvs.ch"
#include 'parmtype.ch'
#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTBASE ³ Autor ³	Query	: Nicolas						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cuentas por cobrar											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ repcxces()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Union														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			 ³27/27/2019³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function repcxces()
	Local oReport
	PRIVATE cPerg   := "REPCXCES"   // elija el Nombre de la pregunta

	Pergunte(cPerg,.T.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg := "Situación Títulos por cobrar"
	PUBLIC SUMA := 0
	PUBLIC prevCli := "" // previous client
	PUBLIC prevLoj := "" // previous Loj
	criasx1(cPerg)

	oReport	 := TReport():New("repcompe",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Situación Títulos por cobrar")
	oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Situación Títulos por cobrar",{"SE1"})
	oReport:SetTotalInLine(.F.)

	//Comienzan a elegir los campos que desean Mostrar

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"E1_CLIENTE"	,"SE1","CODCLI",,TamSX3("E1_CLIENTE")[1])
	TRCell():New(oSection,"E1_LOJA"		,"SE1","TDA",,TamSX3("E1_LOJA")[1])
	TRCell():New(oSection,"A1_NOME"		,"SA1","Nombre",,20)
	TRCell():New(oSection,"A1_NREDUZ"	,"SA1","Nombre fantasía",,20)
	TRCell():New(oSection,"A3_NREDUZ"		,"SA3","VEND",,7)
	TRCell():New(oSection,"E1_PREFIXO"	,"SE1","Pref",,TamSX3("E1_PREFIXO")[1])
	TRCell():New(oSection,"E1_TIPO"		,"SE1","tipo",,TamSX3("E1_TIPO")[1])
	TRCell():New(oSection,"E1_NUM"		,"SE1","Título",,6)
	TRCell():New(oSection,"E1_PARCELA"	,"SE1","Co",,TamSX3("E1_PARCELA")[1])
	TRCell():New(oSection,"E1_EMISSAO"	,"SE1","Fecha de emisión",,TamSX3("E1_EMISSAO")[1])
	TRCell():New(oSection,"E1_VENCTO"	,"SE1"	,"Vencimiento",,TamSX3("E1_EMISSAO")[1])
	TRCell():New(oSection,"Atraso"		,"SE1","Atraso",/*Picture*/,7/*Tamanho*/,/*lPixel*/,{||cvaltochar(ddatabase - QRYSA1->E1_VENCTO )  })
	TRCell():New(oSection,"E1_VALOR"	,"SE1","Monto",/*Picture*/,TamSX3("E1_VALOR")[1],/*lPixel*/,{|| xMoeda(QRYSA1->E1_VALOR,QRYSA1->E1_MOEDA,MV_PAR07,DDATABASE) })
	TRCell():New(oSection,"ABONO"		,"SE1","Abono",,,/*lPixel*/,{||  xMoeda(QRYSA1->ABONO   ,QRYSA1->E1_MOEDA,MV_PAR07,DDATABASE) })
	TRCell():New(oSection,"E1_SALDO"	,"SE1","Saldo",/*Picture*/,TamSX3("E1_VALOR")[1],/*lPixel*/,{||  xMoeda(QRYSA1->E1_SALDO,QRYSA1->E1_MOEDA,MV_PAR07,DDATABASE) })
	TRCell():New(oSection,"ACUMULADO"	,"SE1","Acumulado","@E 99,999,999.99",TamSX3("E1_VALOR")[1],/*lPixel*/,{|| getAcumulated() })

	oBreakStore = TRBreak():New(oSection,oSection:Cell("E1_LOJA"),"Total tienda")
	TRFunction():New(oSection:Cell("E1_VALOR") ,NIL,"SUM",oBreakStore,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oSection:Cell("E1_SALDO") ,NIL,"SUM",oBreakStore,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)

	oBreak = TRBreak():New(oSection,oSection:Cell("E1_CLIENTE"),"Total Cliente")
	TRFunction():New(oSection:Cell("E1_VALOR") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,{||getTotal()},.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oSection:Cell("E1_SALDO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oSection:Cell("ATRASO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/"TOT:" + GETMV("MV_SIMB" + ALLTRIM(CVALTOCHAR(MV_PAR07))),/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)

Return oReport

Static function getAcumulated()
	if prevCli == ""
		prevCli = QRYSA1->E1_CLIENTE
	endif
	if prevLoj == "" // adicionando tienda Nahim 26/03/2020
		prevLoj = QRYSA1->E1_LOJA
	endif

	if QRYSA1->E1_CLIENTE != prevCli .or. QRYSA1->E1_LOJA != prevLoj //si el cliente o loja es diferente
		prevCli = QRYSA1->E1_CLIENTE
		prevLoj = QRYSA1->E1_LOJA// adicionando tienda
		SUMA := 0
	endif
	if (ddatabase - QRYSA1->E1_VENCTO) >= 0 // SI EL TÍTULO ESTÁ VENCIDO LO SUMA
		SUMA := xMoeda(QRYSA1->E1_SALDO,QRYSA1->E1_MOEDA,MV_PAR07,DDATABASE) + SUMA
	else
		return "-----------"
	ENDIF
return SUMA

static function getTotal()
return xMoeda(E1_VALOR,QRYSA1->E1_MOEDA,MV_PAR07,DDATABASE) - xMoeda(ABONO,QRYSA1->E1_MOEDA,MV_PAR07,DDATABASE)

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local cFiltro  := ""

	#IFDEF TOP
		// Query
		oSection:BeginQuery()
		BeginSql alias "QRYSA1"

		SELECT  A3_NREDUZ,E1_CLIENTE,E1_LOJA,E1_NOMCLI, E1_PREFIXO, + SUBSTRING(E1_NUM, PATINDEX('%[^0]%', E1_NUM+'.'), LEN(E1_NUM)) E1_NUM, E1_PARCELA, E1_TIPO, A1_NOME, A1_NREDUZ,
		E1_MOEDA,E1_EMISSAO, E1_VENCTO,
		/*
		CASE E1_TIPO WHEN 'RA' THEN -E1_VALOR ELSE E1_VALOR END E1_VALOR,
		CASE E1_TIPO WHEN 'RA' THEN -(E1_VALOR - E1_SALDO) ELSE E1_VALOR - E1_SALDO END "ABONO","ATRASO" ATRASO,
		CASE E1_TIPO WHEN 'RA' THEN -E1_SALDO ELSE E1_SALDO END E1_SALDO
		*/
		
		CASE WHEN E1_TIPO IN ('RA','NCC') THEN -E1_VALOR ELSE E1_VALOR END E1_VALOR,		
		CASE WHEN E1_TIPO IN ('RA','NCC') THEN -(E1_VALOR - E1_SALDO) ELSE E1_VALOR - E1_SALDO END "ABONO","ATRASO" ATRASO,		
		CASE WHEN E1_TIPO IN ('RA','NCC') THEN -E1_SALDO ELSE E1_SALDO END E1_SALDO
		
		FROM SE1010 SE1
		JOIN SA1010 SA1 ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA
		LEFT JOIN SA3010 SA3 ON E1_VEND1 = A3_COD AND SA3.D_E_L_E_T_ LIKE '' 
		WHERE E1_CLIENTE BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR03%
		AND E1_LOJA BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR04%
		AND E1_EMISSAO BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
		AND SE1.D_E_L_E_T_ LIKE ''
		AND SA1.D_E_L_E_T_ LIKE ''
		AND E1_SALDO > 0
		ORDER BY E1_CLIENTE, E1_LOJA, E1_VENCTO ASC

		EndSql

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

	xPutSx1(cPerg,"01","De cliente?","De cliente?","De cliente?",         "mv_ch1","C",06,0,0,"G","","SA1","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","De tienda?","De tienda?","De tienda?",         "mv_ch1","C",02,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"03","A cliente?","A cliente?","A cliente?",         "mv_ch2","C",06,0,0,"G","","SA1","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A tienda?","A tienda?","A tienda?",         "mv_ch2","C",02,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"05","De fecha?","De fecha ?","De fecha ?",         "mv_ch1","D",08,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A fecha?","A fecha ?","A fecha ?",         "mv_ch2","D",08,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"07","Qual Moeda?"   ,"¿Que Moneda?" ,"Which Currency?"   ,"MV_CH2","N",1,0,0,"C","","","","" ,"MV_PAR07","Moeda 1","Moneda 1","Currency 1","","Moeda 2","Moneda 2","Currency 2")

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

Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica

	Local aArea          := GetArea()
	Local aCabec     := {}
	Local cChar          := chr(160) // caracter dummy para alinhamento do cabeçalho
	Local titulo     := oReport:Title()
	Local page := oReport:Page()
	currency := GETMV("MV_MOEDA" + ALLTRIM(CVALTOCHAR(MV_PAR07)))

	// __LOGOEMP__ imprime el logo de la empresa

	aCabec := {     "__LOGOEMP__" ,cChar + "        " + cChar ; // + if(comparador==1," ",RptFolha+" "+cvaltochar(page));
		, " " + " " + "        " + cChar + UPPER(AllTrim(titulo)) + "        " + currency + "        " + cChar + RptEmiss + " " + Dtoc(dDataBase);
		, "Hora: "+ cvaltochar(TIME()) ;
		, " " }
	RestArea( aArea )
Return aCabec
