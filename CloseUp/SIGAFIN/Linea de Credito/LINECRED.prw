#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTBASE ³ Autor ³	Query	: Nahim Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Linea de crédito 					  					    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LINECRED()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CIABOL														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³24/10/2018³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function LINECRED()
	Local oReport
	PRIVATE cPerg   := "LINECRED"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.T.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg := "Lineas de Crédito"


	oReport	 := TReport():New("LINECRED",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Lineas de Crédito")
	// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Linea Credito",{"SN4"})
	//oSection2 := TRSection():New(oReport,"reaincmk",{"SN4"})
	//oReport:SetTotalInLine(.F.)

	/*
	TRCell():New(oSection,"D2_COD"		,"SD2","Prod.",,10)
	TRCell():New(oSection,"A3_NOME"		,"SA3","Vended.",,10)
	*/
	//		Comienzan a elegir los campos que desean Mostrar

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"Banco"	,"SN1","Banco")
	TRCell():New(oSection,"AgBco"	,"SN4","Agencia B.")
	TRCell():New(oSection,"Codigo"	,"SN4")
	TRCell():New(oSection,"EntidadFinanciera","SN4")
	TRCell():New(oSection,"Nombre","SN4")
	TRCell():New(oSection,"Nro"	,"SN4")
	TRCell():New(oSection,"FechaInicio" ,"SN4","Fecha Inicio",,8)
	TRCell():New(oSection,"FechaFin" ,"SN4","Fecha Fin",,8)
	TRCell():New(oSection,"Nro"	,"SN4")
	TRCell():New(oSection,"Moneda"	,"SN4")
	TRCell():New(oSection,"Monto"	,"SN4")
	TRCell():New(oSection,"MontoDólares"	,"SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| xmoeda(MontoDólares,1,2,A6_UFCILIN)})
	//	TRCell():New(oSection2,"D2_QUANT"  ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| SD2->D2_QUANT * -1 })
	TRCell():New(oSection,"Comisión"	,"SN4")
	TRCell():New(oSection,"Tasa"	,"SN4")
	TRCell():New(oSection,"%C.Op."	,"SN4")
	TRCell():New(oSection,"MontoCOpUSD"	,"SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| xmoeda(MontoCOpUSD,1,2,A6_UFCILIN)})
	TRCell():New(oSection,"Objeto"	,"SN4")
	TRCell():New(oSection,"Descripcion"	,"SN4")
	TRCell():New(oSection,"Utilizacion"	,"SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| ( xmoeda(SUMEH_VALOR,1,2,EH_DATA) +  xmoeda(SUMZE1_VAL,1,2,ZE1_DDEP) )  - xmoeda(ZEH_VALOR,1,2,ZEH_DATA) })
	TRCell():New(oSection,"DPFsyAsfaltos"	,"SN4")
	TRCell():New(oSection,"Inmuebles"	,"SN4")
	TRCell():New(oSection,"MaqVehículos"	,"SN4")
	TRCell():New(oSection,"TotalGarantías"	,"SN4")
	TRCell():New(oSection,"Saldo"	,"SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| xmoeda(A6_UVLRLIN,1,2,A6_UFCILIN) - (xmoeda(SUMEH_VALOR,1,2,EH_DATA) + xmoeda(SUMZE1_VAL,1,2,ZE1_DDEP)) - xmoeda(ZEH_VALOR,1,2,ZEH_DATA) })
	TRCell():New(oSection,"RelacionTotLineavsGarantias","SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| xmoeda(RelacionTotLineavsGarantias,1,2,A6_UFCILIN)  })
	TRCell():New(oSection,"codTipo1"	,"SN4")
	TRCell():New(oSection,"codGrupo1"	,"SN4")
	TRCell():New(oSection,"destino1"	,"SN4")
	TRCell():New(oSection,"operación1"	,"SN4")
	TRCell():New(oSection,"codTipo2"	,"SN4")
	TRCell():New(oSection,"codGrupo2"	,"SN4")
	TRCell():New(oSection,"destino2"	,"SN4")
	TRCell():New(oSection,"operación2"	,"SN4")
	TRCell():New(oSection,"SaldoLinea"	,"SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| if(EH_UGRUPO == "PRE",( xmoeda(SUMEH_VALOR,1,2,EH_DATA) +  xmoeda(SUMZE1_VAL,1,2,ZE1_DDEP) )  - xmoeda(ZEH_VALOR,1,2,ZEH_DATA),0) })
	TRCell():New(oSection,"SaldoOtros"	,"SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| if(EH_UGRUPO == "BOL",( xmoeda(SUMEH_VALOR,1,2,EH_DATA) +  xmoeda(SUMZE1_VAL,1,2,ZE1_DDEP) )  - xmoeda(ZEH_VALOR,1,2,ZEH_DATA),0) })
	TRCell():New(oSection,"MontoRel321"	,"SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| xmoeda(MontoRel321,1,2,A6_UFCILIN)  })
	TRCell():New(oSection,"DifRel"	,"SN4")
	TRCell():New(oSection,"UtilPrestamos"	,"SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| xmoeda(SUMEH_VALOR,1,2,EH_DATA - xmoeda(ZEH_VALOR,1,2,ZEH_DATA))  })
	TRCell():New(oSection,"UtilOtros","SN4",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| xmoeda(ZEH_VALOR,1,2,ZEH_DATA)  })
	TRCell():New(oSection,"DifRel"	,"SN4")
	//TRCell():New(oSection2,"VALOR"	,"SN4","Val.Mov.M1")
	//TRCell():New(oSection2,"N4_NUMTRF"		,"SN4")
	//
	// oBreak = TRBreak():New(oSection,oSection:Cell("N4_FILIAL"),"Sub Total Filial")
	// TRFunction():New(oSection:Cell("VALOR") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	// Imprime una linea Segun la condicion (totalizadora)
	// TRFunction():New(oSection:Cell("B1_VENTAS") ,NIL,"ONPRINT",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/{|| "" },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/,)

	//TRFunction():New(oSection:Cell("VALVENGR")	,NIL,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)

Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local cFiltro  := ""
	if MV_PAR04 == 1 //boleta
		inAPLEMP :="BOL"
	elseif MV_PAR04 == 2
		inAPLEMP := "POL"
	else
		inAPLEMP := "POL','BOL"
	ENDIF
// '('POL','BOL')'
	#IFDEF TOP
	// Query
	oSection:BeginQuery()
	BeginSql alias "QRYSA1"

		SELECT
		A6_UFCILIN,
		A6_UVLRLIN,
		ZEH_DATA,
		EH_DATA,
		ZE1_DDEP,
		A6_COD  Banco,
		A6_AGENCIA      AgBco,
		A6_NUMCON  Codigo,
		A6_NREDUZ      EntidadFinanciera,
		A6_NOME          Nombre,
		isnull(EH_OPERAC,'-')       Nro,
		isnull(EH_DATA,'-')  FechaInicio,
		isnull(EH_DATARES,'-')  FechaFin,
		isnull(EH_MOEDA,0)      Moneda,
		A6_UVLRLIN      Monto,
		A6_UVLRLIN      MontoDólares ,
		isnull(EH_TARIFA,0)         Comisión,
		isnull(EH_TAXA,0)   Tasa ,
		A6_UPRPRES   '%C.Op.',
		(A6_UPRPRES/100) * A6_UVLRLIN  'MontoCOpUSD' ,
		A6_UTIPLIN       Objeto,
		CASE A6_UTIPLIN
		WHEN 'PR' THEN 'PRESTAMOS'
		WHEN 'CT' THEN 'CONTNGENCIAS'
		WHEN 'AM' THEN 'PRESTAMOS Y CONTINGENCIAS'
		ELSE 'CR'
	END Descripcion,
	isnull((SUMEH_VALOR + SUMZE1_VAL) - ZEH_VALOR,0) Utilizacion ,
	ZEH_VALOR,
	A6_USDPF          DPFsyAsfaltos,
	A6_USINMU      Inmuebles,
	A6_USMYV        MaqVehículos,   
	A6_USVEI		Vehiculos,
	A6_USDPF +A6_USINMU+A6_USMYV+A6_USVEI       TotalGarantías,
	isnull(A6_UVLRLIN -(SUMEH_VALOR + SUMZE1_VAL) - ZEH_VALOR,0)  Saldo,
	isnull(A6_UVLRLIN /nullif((A6_USDPF+A6_USINMU+A6_USMYV+A6_USVEI), 0),0)   RelacionTotLineavsGarantias  ,
	EH_UTPTRAN    codTipo1,
	EH_UGRUPO      codGrupo1,
	EH_UGRUPO,
	EH_UDESTRA      destino1,
	EH_OPERAC      operación1,
	ZEH_UTPTRA     codTipo2,
	ZEH_UGRUPO     codGrupo2,
	ZEH_UDESTR    destino2,
	ZEH_OPERAC      operación2,
	isnull(SUMZE1_VAL,0) SUMZE1_VAL,
	isnull(SUMEH_VALOR,0) SUMEH_VALOR,
	isnull(ZEH_VALOR,0) ZEH_VALOR,
	CASE isnull(EH_UGRUPO,' ')
	WHEN 'PR' THEN A6_UVLRLIN -(SUMEH_VALOR + SUMZE1_VAL) - ZEH_VALOR
	WHEN 'BOL' THEN 0
	WHEN 'POL' THEN 0
	else 0
	END SaldoLinea,
	CASE EH_UGRUPO
	WHEN 'PR' THEN 0
	WHEN 'BOL' THEN A6_UVLRLIN -(SUMEH_VALOR + SUMZE1_VAL)
	WHEN 'POL' THEN 0
	else 0
	END SaldoOtros,
	3*A6_USDPF+2*A6_USINMU+A6_USMYV+A6_USVEI MontoRel321,
	CASE isnull(EH_UGRUPO,' ')
	WHEN 'PRE' THEN A6_UVLRLIN-(3*A6_USDPF+2*A6_USINMU+A6_USMYV+A6_USVEI)
	ELSE 0
	END DifRel,
	isnull(SUMEH_VALOR - SUMZEH_VALOR,0) UtilPrestamos,
	isnull(SUMZEH_VALOR,0) as UtilOtros,
	CASE A6_BLOCKED
	WHEN '1' THEN 'NO VIGENTE'
	WHEN '2' THEN 'VIGENTE'
	END DifRel
	from %Table:SA6% SA6
	left join
	%table:SEH% SEH
	on EH_BANCO = A6_COD
	and EH_AGENCIA = A6_AGENCIA
	AND EH_CONTA = A6_NUMCON
	AND SEH.D_E_L_E_T_ = ' '
	left join
	%Table:ZE1% ZE1
	on ZE1_BANCO = A6_COD
	AND   ZE1_AGENCI = A6_AGENCIA
	AND   ZE1_CONTAB = A6_NUMCON
	AND ZE1.D_E_L_E_T_ = ' '
	AND   ZE1_NORDIC  = EH_NUMERO
	left join
	%Table:ZEH% ZEH
	on ZEH_BANCO = A6_COD
	AND   ZEH_AGENCI = A6_AGENCIA
	AND   ZEH_CONTA = A6_NUMCON
	AND ZEH.D_E_L_E_T_ = ' '
	left join (
	SELECT
	A6_COD CODBAN,A6_AGENCIA AGENCIA ,A6_NUMCON CUENTA,
	SUM(EH_VALOR) SUMEH_VALOR,
	SUM(ZE1_VAL) SUMZE1_VAL,
	SUM(ZEH_VALOR) SUMZEH_VALOR
	from %Table:SA6% SA6
	left join
	%Table:SEH% SEH
	on EH_BANCO = A6_COD
	and EH_AGENCIA = A6_AGENCIA
	AND  EH_CONTA = A6_NUMCON
	AND SEH.D_E_L_E_T_ = ' '
	left join
	%Table:ZE1% ZE1
	on ZE1_BANCO = A6_COD
	AND   ZE1_AGENCI = A6_AGENCIA
	AND   ZE1_CONTAB = A6_NUMCON
	AND   ZE1_NORDIC  = EH_NUMERO
	AND ZE1.D_E_L_E_T_ = ' '
	left join
	%Table:ZEH% ZEH
	on ZEH_BANCO = A6_COD
	AND   ZEH_AGENCI = A6_AGENCIA
	AND   ZEH_CONTA = A6_NUMCON
	AND ZEH.D_E_L_E_T_ = ' '
	group by A6_COD, A6_AGENCIA,A6_NUMCON) SUMATORIA
	on CODBAN = A6_COD
	AND   AGENCIA = A6_AGENCIA
	AND   CUENTA = A6_NUMCON
	WHERE
	SA6.D_E_L_E_T_ = ' '
	and A6_COD = %exp:MV_PAR01%
	and A6_AGENCIA = %exp:MV_PAR02%
	and A6_NUMCON = %exp:MV_PAR03%
	and EH_APLEMP = 'EMP'
	AND   ZE1_ESTADO = '3'
	and ZEH_APLEMP in (%exp:inAPLEMP%)

	EndSql

	/*
	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como
	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados
	pela funcao MakeSqlExpr para serem adicionados a query
	*/
	cQuery:= GetLastQuery()
	//Aviso("query",cvaltochar(cQuery),{"si"})
	Aviso("query",cvaltochar(cQuery[2]`````),{"si"}) //  usar este en esste caso cuando es BEGIN SQL

	oSection:EndQuery()

	#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF
	// MemoWrite("\query_ctxcbxcl.sql",cQuery[2]) usar este en esste caso cuando es BEGIN SQL
	// MemoWrite("\query_ocp.sql",cQuery) esta funcion te crea un archivo con el nombre que pongas en el parametro

	oSection:Print()

Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	//	xPutSx1(cPerg,"01","Línea de Crédito ?"  ,"Línea de Crédito" 		,"Línea de Crédito?"			,"mv_ch1","C",TamSX3("A6_COD")[1],0,0,"G","""SA6","")
	//	xPutSx1(cPerg,"02","Agencia ?","Agencia ?"	,"Agency ?"	,"mv_ch2","C",TamSX3("A6_AGENCIA")[1],0,0,"G","","mv_par02", "","","","","")
	//	xPutSx1(cPerg,"03","Conta ?"  ,"Cuenta ?"		,"From C. Account ?"	,"mv_ch3","C",TamSX3("A6_NUMCON")[1],0,0,"G","","mv_par03", "","","","","")

	xPutSx1(cPerg,"01","Do Banco ?","Línea de Crédito" 		,"From Bank ?"			,"mv_ch1","C",TamSX3("A6_COD")[1],0,0,"G","","SA6","","","mv_par01","","","","","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg,"02","Da Agencia ?","Agencia"	,"From Bank Office ?"	,"mv_ch2","C",TamSX3("A6_AGENCIA")[1],0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg,"03","Da Conta ?","Cuenta"		,"From C. Account ?"	,"mv_ch3","C",TamSX3("A6_NUMCON")[1],0,0,"G","","","","",,"mv_par03","","","","","","","","","","","","","","","","","","","","")
	xPutSX1(cPerg,"04","Tipo"        , "Tipo"  ,"Tipo" ,"MV_CH1","N",1,0,0,"C","","","","","mv_par04","Boleta de Garantía","Boleta de Garantía","Boleta de Garantía","","póliza","póliza","póliza","Ambas","Ambas","Ambas")

	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	// Los "mv_parEtc" son los nombres con los cuales llamamos a las preguntas en el Query, seria los datos que ingresamos
	// Cuando en el reporte ponemos la opcion (Parametros) por lo tanto es obligatorio Usar Preguntas si el Reporte esta
	// En el menú, si el reporte no esta en el menú podemos llamar al campo y se obtienen los datos de donde esta posicionado
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