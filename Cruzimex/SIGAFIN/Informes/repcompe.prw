#include "totvs.ch"
#include 'parmtype.ch'
#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTBASE ³ Autor ³	Query	: Nahim Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ejemplo Base de TREPORT() Nahim Terrazas   					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ REPOBASE()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Global														³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³24/08/2016³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function repcompe()
	Local oReport
	//PRIVATE cPerg   := "REPOBASE"   // elija el Nombre de la pregunta
	//CriaSX1(cPerg)	// Si no esta creada la crea

	//Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg := "Reporte Compensaciones a realizar"

	oReport	 := TReport():New("repcompe",NombreProg,,{|oReport| PrintReport(oReport)},"Reporte Compensaciones a realizar")
	// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection := TRSection():New(oReport,"Transferencias",{"SN4"})
	//oSection2 := TRSection():New(oReport,"reaincmk",{"SN4"})
	oReport:SetTotalInLine(.F.)

	/*
	TRCell():New(oSection,"D2_COD"		,"SD2","Prod.",,10)
	TRCell():New(oSection,"A3_NOME"		,"SA3","Vended.",,10)
	*/
	//		Comienzan a elegir los campos que desean Mostrar

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"C5_NUM"	,"SC5","Pedido Venta")
	TRCell():New(oSection,"C5_CLIENTE"	,"SC5","Cod. Cliente",,35)
	TRCell():New(oSection,"C5_UNOMCLI"	,"SC5","Nombre")
	TRCell():New(oSection,"C5_NUM"	,"SC5","Pedido Venta")
	TRCell():New(oSection,"numeroRA","SC5","Número Anticipo")
	TRCell():New(oSection,"E1_SERREC","SC5","Serie Ant.",,3)
	TRCell():New(oSection,"saldoRA"	,"SC5","Saldo R.A.")
	TRCell():New(oSection,"TITUFACTURA","SC5"	,"Cnta. Por Cobrar",,18)
	TRCell():New(oSection,"PrefixoFac"	,"SC5","Serie Factura")
	TRCell():New(oSection,"E1_SALDOTIT"	,"SC5","Saldo RA")
	TRCell():New(oSection,"monedaRA"	,"SC5","Moneda R.A")
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

		SELECT C5_NUM, CASE WHEN SE1.E1_MOEDA = 1 THEN 'Bs' ELSE 'Sus' END monedaRA ,SE1.E1_NUM numeroRA, SE1.E1_SALDO saldoRA,
		SE1.E1_VLCRUZ ,SE12.E1_NUM TITUFACTURA ,SE12.E1_SALDO E1_SALDOTIT, SE1.E1_SERREC,
		SE12.E1_PREFIXO PrefixoFac, SE1.E1_PARCELA CUOTARA , C5_LOJACLI ,C5_UNOMCLI,C5_CLIENTE,	 *
		FROM SE1010 SE1
		JOIN SC5010 SC5 ON SC5.D_E_L_E_T_ = ' ' AND C5_URECIBO = E1_NUM AND E1_SERREC = C5_USERIE
		JOIN SE1010 SE12 ON SE12.D_E_L_E_T_ = ' ' AND C5_NOTA = SE12.E1_NUM AND C5_SERIE = SE12.E1_PREFIXO AND se12.E1_SALDO >= 1
		WHERE SE1.D_E_L_E_T_  LIKE ' ' AND SE1.E1_TIPO = 'RA ' AND SE1.E1_SALDO >= 1
		order by 3

	EndSql

	oSection:EndQuery()

	#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

	oSection:Print()

	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})   usar este en esste caso cuando es BEGIN SQL
	//Aviso("query",cvaltochar(cQuery),{"si"})
	// MemoWrite("\query_ctxcbxcl.sql",cQuery[2]) usar este en esste caso cuando es BEGIN SQL
	// MemoWrite("\query_ocp.sql",cQuery) esta funcion te crea un archivo con el nombre que pongas en el parametro
Return
