#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xCtbVta  บAutor  ณEDUAR ANDIA		บ Data ณ  07/04/2020  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Resumen das vendas pelo Tipo do produto 	  บฑฑ
ฑฑบ          ณ (Cuadre Contable)                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bolivia \Bel้n S.A.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xCtbVta
Local oReport

Private cPerg   := "CTBVTA"
CriaSX1(cPerg)

Pergunte(cPerg,.F.)
oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection1
	Local oBreak
	Local NombreProg := "Informe de Resumen de Ventas por Tipo"

	oReport	 := TReport():New("xCtbVta",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Ventas por Tipo")
	oReport:nFontBody := 08
	// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oSection1 := TRSection():New(oReport,"Ventas",{"SD2"})	
	oReport:SetTotalInLine(.F.)
	
	TRCell():New( oSection1, "D2_FILIAL"  	, "SD2","Filial"		/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "D2_TP"  		, "SD2","Tipo"			/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "DESCTIPO"  	, "SD2","Descripci๓n"	/*Titulo*/,/*Picture*/					,/*Tamanho*/ 30			,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "D2_TOTAL" 	, "SD2","Total"			/*Titulo*/,PesqPict("SD2","D2_TOTAL")	,/*Tamanho*/			,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "TOTAL87"  	, "SD2","87%"			/*Titulo*/,PesqPict("SD2","D2_TOTAL")	,TamSX3("D2_TOTAL")[1]	,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "D2_DESCON"  	, "SD2","Descuentos"	/*Titulo*/,PesqPict("SD2","D2_DESCON")	,/*Tamanho*/			,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "VENTAS"  		, "SD2","Cta Venta"		/*Titulo*/,PesqPict("SD2","D2_TOTAL")	,TamSX3("D2_TOTAL")[1]	,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "D2_VALIMP1"  	, "SD2","D.F."			/*Titulo*/,PesqPict("SD2","D2_TOTAL")	,/*Tamanho*/			,/*lPixel*/,/*CodeBlock*/)
	
	oBreak = TRBreak():New(oSection1,oSection1:Cell("D2_FILIAL"),"Total Filial")
	TRFunction():New(oSection1:Cell("D2_TOTAL") 	,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oSection1:Cell("TOTAL87")		,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)	
	TRFunction():New(oSection1:Cell("D2_DESCON")	,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oSection1:Cell("VENTAS")		,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
	TRFunction():New(oSection1:Cell("D2_VALIMP1")	,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
Return oReport


Static Function PrintReport(oReport)
Local oSection1	:= oReport:Section(1)
Local oSection2	//:= oReport:Section(2)
Local cAliasQry	:= GetNextAlias()
Local cQuery	:= ""	

#IFDEF TOP
	
	cQuery:= " SELECT D2_FILIAL"
	cQuery+= " 	,D2_TP"
	cQuery+= " 	,MAX(X5_DESCRI) DESCTIPO"
	cQuery+= " 	,SUM(D2_TOTAL) D2_TOTAL"
	cQuery+= " 	,SUM(D2_TOTAL)*0.87 TOTAL87"
	cQuery+= " 	,SUM(D2_DESCON) D2_DESCON"
	cQuery+= " 	,SUM(D2_DESCON) + (SUM(D2_TOTAL)*0.87) VENTAS"
	cQuery+= " 	,SUM(D2_VALIMP1) D2_VALIMP1"
	cQuery+= " FROM  " + RetSqlName("SD2") + " SD2"
	cQuery+= " LEFT JOIN   " + RetSqlName("SX5") + " SX5 ON X5_TABELA = '02' AND X5_CHAVE = D2_TP AND SX5.D_E_L_E_T_ <> '*'"
	cQuery+= " WHERE D2_ESPECIE = 'NF'"
	cQuery+= " 	AND D2_FILIAL = '"+ xFilial("SD2") +"'"
	cQuery+= " 	AND D2_DTDIGIT BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
	cQuery+= " 	AND SD2.D_E_L_E_T_ <> '*'"
	cQuery+= " GROUP BY D2_FILIAL,D2_TP"
	cQuery+= " ORDER BY D2_FILIAL,D2_TP"
	cQuery:= ChangeQuery(cQuery)

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()
	
	/*
	oSection1:BeginQuery()		
	BeginSql alias cAliasQry
	
	SELECT D2_FILIAL
		,D2_TP
		,MAX(X5_DESCRI) DESCTIPO
		,SUM(D2_TOTAL) D2_TOTAL
		,SUM(D2_TOTAL)*0.87 TOTAL87
		,SUM(D2_DESCON) D2_DESCON
		,SUM(D2_DESCON) + (SUM(D2_TOTAL)*0.87) VENTAS
		,SUM(D2_VALIMP1) D2_VALIMP1
	FROM %table:SD2% SD2
	LEFT JOIN %table:SX5% SX5 ON X5_TABELA = '02' AND X5_CHAVE = D2_TP AND SX5.%notDel%
	WHERE D2_ESPECIE = 'NF'		
		AND D2_DTDIGIT BETWEEN %exp:Dtos(mv_par01)% AND %exp:Dtos(mv_par02)%
		AND SD2.%notDel%
	GROUP BY D2_FILIAL,D2_TP
	ORDER BY D2_FILIAL,D2_TP
	
	EndSql	
	oSection1:EndQuery()
	*/
	While (cAliasQry)->(! EOF())
		
		oSection1:Init()
		
		oSection1:Cell("D2_TP"		):SetValue( (cAliasQry)->D2_TP 		)
		oSection1:Cell("DESCTIPO"	):SetValue( (cAliasQry)->DESCTIPO 	)		
		oSection1:Cell("D2_TOTAL"	):SetValue( (cAliasQry)->D2_TOTAL 	)
		oSection1:Cell("DESCTIPO"	):SetValue( (cAliasQry)->DESCTIPO 	)
		oSection1:Cell("TOTAL87"	):SetValue( (cAliasQry)->TOTAL87 	)
		oSection1:Cell("D2_DESCON"	):SetValue( (cAliasQry)->D2_DESCON 	)
		oSection1:Cell("VENTAS"		):SetValue( (cAliasQry)->VENTAS 	)
		oSection1:Cell("D2_VALIMP1"	):SetValue( (cAliasQry)->D2_VALIMP1	)
		
		oSection1:PrintLine(,,,.T.)
		
		(cAliasQry)->(dbSkip())		
	EndDo
	oSection1:Finish()

#ELSE
	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
#ENDIF

Return

//+------------------------------------------------------------------------+
//|Funci๓n que verifica si existe la Pregunta, caso no exista lo crea	   |
//+------------------------------------------------------------------------+
Static Function CriaSX1(cPerg)
Local aRegs 	:= {}
Local i			:= 0

cPerg := PADR(cPerg,10)

aAdd(aRegs,{"01","De Fecha ? :"			,"mv_ch1","D",TamSx3("D2_EMISSAO")[1],0,1,"G","mv_par01",""       ,""            ,""        ,""     ,""		,""})
aAdd(aRegs,{"02","A Fecha ?  :"			,"mv_ch2","D",TamSx3("D2_EMISSAO")[1],0,1,"G","mv_par02",""       ,""            ,""        ,""     ,""		,""})

DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aRegs)
   dbSeek(cPerg+aRegs[i][1])
   If !Found()
      RecLock("SX1",!Found())
         SX1->X1_GRUPO    := cPerg
         SX1->X1_ORDEM    := aRegs[i][01]
         SX1->X1_PERSPA   := aRegs[i][02]
         SX1->X1_VARIAVL  := aRegs[i][03]
         SX1->X1_TIPO     := aRegs[i][04]
         SX1->X1_TAMANHO  := aRegs[i][05]
         SX1->X1_DECIMAL  := aRegs[i][06]
         SX1->X1_PRESEL   := aRegs[i][07]
         SX1->X1_GSC      := aRegs[i][08]
         SX1->X1_VAR01    := aRegs[i][09]
         SX1->X1_DEFSPA1  := aRegs[i][10]
         SX1->X1_DEFSPA2  := aRegs[i][11]
         SX1->X1_DEFSPA3  := aRegs[i][12]
         SX1->X1_DEFSPA4  := aRegs[i][13]
         SX1->X1_F3       := aRegs[i][14]
         SX1->X1_VALID    := aRegs[i][15]         
      MsUnlock()
   Endif
Next i
Return
