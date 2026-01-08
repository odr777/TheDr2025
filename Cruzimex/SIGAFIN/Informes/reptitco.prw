#include "totvs.ch"
#include 'parmtype.ch'
#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ reptitco ³ Autor ³	Query	: Nahim Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ reporte título contado  					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ reptitco()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Global														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³24/08/2016³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function reptitco()
	Local oReport
	PRIVATE cPerg   := "REPCOMPC"   // elija el Nombre de la pregunta
	//	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg := "Reporte títulos por cobrar Contado "

	if mv_par03 == 1 //
		NombreProg += " Bs."
	else
		NombreProg += " USD."
	endif
	criasx1(cPerg)
	oReport	 := TReport():New("repcompe",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte Compensaciones a realizar")
	// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Compensaciones",{"SN4"})
	//oSection2 := TRSection():New(oReport,"reaincmk",{"SN4"})
	oReport:SetTotalInLine(.F.)

	/*
	TRCell():New(oSection,"D2_COD"		,"SD2","Prod.",,10)
	TRCell():New(oSection,"A3_NOME"		,"SA3","Vended.",,10)
	*/
	//		Comienzan a elegir los campos que desean Mostrar

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"E1_CLIENTE"	,"SE1","Cod. Cliente")
	TRCell():New(oSection,"E1_NOMCLI"	,"SE1","Nombre Cliente",,40)
	TRCell():New(oSection,"E1_NUM"	,"SE1","Nro. titulo")
	TRCell():New(oSection,"E1_PREFIXO"	,"SE1","Serie")
	TRCell():New(oSection,"E1_VALOR","SE1","Valor", /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| xMoeda(E1_VALOR,E1_MOEDA,MV_PAR03,DDATABASE) })
	TRCell():New(oSection,"E1_SALDO","SE1","Saldo", /*Picture*/, /*Tamanho*/, /*lPixel*/, {|| xMoeda(E1_SALDO,E1_MOEDA,MV_PAR03,DDATABASE) })
	TRCell():New(oSection,"E1_VENCTO","SE1","Fecha de Venc")
	//	TRCell():New(oMovBanc,"E5_DTDISPO" ,"SE5",STR0025	,/*Picture*/,13,/*lPixel*/,{|| DtoC(E5_DTDISPO)}) //"DATA"
	//	TRCell():New(oSection,"FechaRA"	,"SE1","Fecha")
	//	TransForm( ,PesqPict("SEK","EK_VALOR"))
	//	TRCell():New(oSection,"MontoRA"	,"SE1","Monto Anticipo")
	//	TRCell():New(oSection,"numeroRA","SC5","Número Anticipo")
	//	TRCell():New(oSection,"E1_SERREC","SC5","Serie Ant.",,3)
	//	TRCell():New(oSection,"saldoRA"	,"SC5","Saldo R.A.")
	//	TRCell():New(oSection,"TITUFACTURA","SC5"	,"Cnta. Por Cobrar",,18)
	//	TRCell():New(oSection,"PrefixoFac"	,"SC5","Serie Factura")
	//	TRCell():New(oSection,"E1_SALDOTIT"	,"SC5","Saldo RA")
	//	TRCell():New(oSection,"monedaRA"	,"SC5","Moneda R.A")
	//TRCell():New(oSection,"MOV" ,"SN4","Movimiento",,16)
	//TRCell():New(oSection,"VALOR"	,"SN4","Val.Mov.M1")
	//TRCell():New(oSection,"N4_NUMTRF"		,"SN4")
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

	#IFDEF TOP
	// Query
	oSection:BeginQuery()
	BeginSql alias "QRYSA1"

		SELECT E1_CLIENTE, E1_LOJA,E1_NOMCLI, E1_NUM, E1_PREFIXO, E1_VALOR, E1_SALDO, E1_VENCTO, E1_MOEDA FROM SE1010 SE1 WHERE E1_EMISSAO = E1_VENCTO
		AND D_E_L_E_T_ LIKE '' AND E1_SALDO <> 0 AND E1_TIPO LIKE 'NF'
		AND SE1.E1_VENCTO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%

	EndSql

	oSection:EndQuery()

	#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

	oSection:Print()

	If __CUSERID = '000000'
			cQuery:=GetLastQuery()
		Aviso("query",cvaltochar(cQuery[2]`````),{"si"})  //  usar este en esste caso cuando es BEGIN SQL
	endif
	//Aviso("query",cvaltochar(cQuery),{"si"})
	// MemoWrite("\query_ctxcbxcl.sql",cQuery[2]) usar este en esste caso cuando es BEGIN SQL
	// MemoWrite("\query_ocp.sql",cQuery) esta funcion te crea un archivo con el nombre que pongas en el parametro
Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSx1(cPerg,"01","De fecha ?","De fecha ?","De fecha ?",         "mv_ch1","D",10,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A fecha ?","A fecha ?","A fecha ?",         "mv_ch2","D",10,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","Moneda","Moneda","Moneda",         "mv_ch3","N",02,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")

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
