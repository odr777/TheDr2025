#include "protheus.ch"

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





User Function VENXGYCL()
Local oReport
PRIVATE cPerg   := "VENXGYCL"   // elija el Nombre de la pregunta 
CriaSX1(cPerg)	// Si no esta creada la crea

Pergunte(cPerg,.F.) 
oReport := ReportDef()
oReport:PrintDialog()	

Return

Static Function ReportDef()
Local oReport
Local oSection
Local oBreak
Local NombreProg := "Ventas por grupo y cliente"

oReport	 := TReport():New("VENXGYCL",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte de ventas")
// oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

oSection := TRSection():New(oReport,"Ventas",{"SF2"})
//oSection2 := TRSection():New(oReport,"reaincmk",{"SN4"})
oReport:SetTotalInLine(.F.)


/*                                                 
TRCell():New(oSection,"D2_COD"		,"SD2","Prod.",,10)
TRCell():New(oSection,"A3_NOME"		,"SA3","Vended.",,10) 
*/
//		Comienzan a elegir los campos que desean Mostrar
 
// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

TRCell():New(oSection,"A1_COD"	,"SA1","Código")
// TRCell():New(oSection,"AOV_CODSEG","AOV","")
// TRCell():New(oSection,"AOV_CODSEG","AOV","")//,/*cPicture*/,/*Tamanho*/,/*lPixel*/,)
TRCell():New(oSection,"A1_NOME"	,"SA1","Cliente")
TRCell():New(oSection,"CONTADOBRUTO"	,"SF2","Contado bruto", "@E 999,999,999,999.99")
TRCell():New(oSection,"CONTADODESCUENTO" ,"SF2","Contado descuento", "@E 999,999,999,999.99")
TRCell():New(oSection,"CREDITOBRUTO"	,"SF2","Credito bruto", "@E 999,999,999,999.99")
TRCell():New(oSection,"CREDITODESCUENTO" ,"SF2","Credito descuento", "@E 999,999,999,999.99")
TRCell():New(oSection,"NETO","SF2" ,"Total neto", "@E 999,999,999,999.99")
TRCell():New(oSection,"DESC","SF2" ,"% desc.")
TRCell():New(oSection,"PARTIC","SF2" ,"% partic.")


/* PARA TOTALIZAR */
// oBreak = TRBreak():New(oSection,{||.T.},"Sub total")
// oReport:SetTotalInLine(.F.)
oBreak = TRBreak():New(oSection,{|| QRYSA1->AOV_CODSEG},{|| "Total segmento " + QRYSA1->AOV_CODSEG})//"Total segmento")
TRFunction():New(oSection:Cell("CONTADOBRUTO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
TRFunction():New(oSection:Cell("CONTADODESCUENTO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
TRFunction():New(oSection:Cell("CREDITOBRUTO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
TRFunction():New(oSection:Cell("CREDITODESCUENTO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
TRFunction():New(oSection:Cell("NETO") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
TRFunction():New(oSection:Cell("DESC") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
TRFunction():New(oSection:Cell("PARTIC") ,NIL,"SUM",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)

Return oReport

Static Function PrintReport(oReport)
Local oSection := oReport:Section(1)
Local cFiltro  := ""

#IFDEF TOP
// Query
	oSection:BeginQuery()
	BeginSql alias "QRYSA1"

	SELECT A1_COD,
	A1_NOME, 
	AOV_CODSEG, 
	AOV_DESSEG,
	SUM(CASE F2_COND WHEN '002' THEN F2_VALBRUT ELSE 0 END) CONTADOBRUTO, 
	SUM(CASE F2_COND WHEN '002' THEN F2_DESCONT ELSE 0 END) CONTADODESCUENTO,  
	SUM(CASE F2_COND WHEN '002' THEN 0 ELSE F2_VALBRUT END) CREDITOBRUTO, 
	SUM(CASE F2_COND WHEN '002' THEN 0 ELSE F2_DESCONT END) CREDITODESCUENTO, 
	SUM(F2_VALBRUT) - SUM(F2_DESCONT) 'NETO',
	ROUND(SUM(F2_DESCONT) * 100 / SUM(F2_VALBRUT), 1) 'DESC',
	ROUND((SUM(F2_VALBRUT) - SUM(F2_DESCONT)) * 100 /  (
		SELECT SUM(F2_VALBRUT) - SUM(F2_DESCONT) 'TOTAL NETO'
		FROM %table:SA1% SA1 
		JOIN %table:AOV% AOV ON A1_CODSEG = AOV_CODSEG 
		JOIN %table:SF2% SF2 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SF2.%notdel% 
		WHERE SA1.%notdel% 
		AND AOV.%notdel% 
		AND F2_EMISSAO BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	), 1) 'PARTIC'
	FROM %table:SA1% SA1 
	JOIN %table:AOV% AOV ON A1_CODSEG = AOV_CODSEG
	JOIN %table:SF2% SF2 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SF2.%notdel% 
	WHERE SA1.%notdel%
	AND AOV.%notdel%
	AND AOV_CODSEG BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND F2_EMISSAO BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	GROUP BY AOV_CODSEG, AOV_DESSEG, A1_COD, A1_NOME
	EndSql
	
//	cQuery := GetLastQuery()
//	Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.T.)
	
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

//cQuery:=GetLastQuery() 	
//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})   usar este en esste caso cuando es BEGIN SQL
//Aviso("query",cvaltochar(cQuery),{"si"})   
// MemoWrite("\query_ctxcbxcl.sql",cQuery[2]) usar este en esste caso cuando es BEGIN SQL
// MemoWrite("\query_ocp.sql",cQuery) esta funcion te crea un archivo con el nombre que pongas en el parametro
Return

static function getTotal(cCod, cDataDe, cDataAte)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT SUM(F2_VALBRUT) BRUTO
		FROM %table:SA1% SA1 
		JOIN %table:AOV% AOV ON A1_CODSEG = AOV_CODSEG
		JOIN %table:SF2% SF2 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND SF2.%notdel% 
		WHERE SA1.%notdel%
		AND AOV.%notdel%
		AND AOV_CODSEG = %exp:cCod%
		AND F2_EMISSAO BETWEEN %exp:cDataDe% AND %exp:cDataAte%
		GROUP BY AOV_CODSEG

	EndSql

	DbSelectArea( OrdenConsul )
	If (OrdenConsul)->(!Eof())
		AADD( aRet, (OrdenConsul)->BRUTO )
	endIf
	restArea( aArea )
return aRet

Static Function CriaSX1(cPerg)  // Crear Preguntas 

/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
especificaciones, 
*/
// Los "mv_parEtc" son los nombres con los cuales llamamos a las preguntas en el Query, seria los datos que ingresamos
// Cuando en el reporte ponemos la opcion (Parametros) por lo tanto es obligatorio Usar Preguntas si el Reporte esta
// En el menú, si el reporte no esta en el menú podemos llamar al campo y se obtienen los datos de donde esta posicionado


xPutSx1(cPerg,"01","¿De segmento?" , "¿De segmento?","¿From segment?","MV_CH1","C",6,0,0,"G","","","","","MV_PAR01",""       ,""            ,""        ,""     ,"","")     
xPutSx1(cPerg,"02","¿A segmento?" , "¿A segmento?","¿To segmento?","MV_CH1","C",6,0,0,"G","","","","","MV_PAR02",""       ,""            ,""        ,""     ,"","")
xPutSx1(cPerg,"03","¿De fecha?" , "¿De fecha?","¿From date?","MV_CH2","D",08,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,""   ,"")     
xPutSx1(cPerg,"04","¿A fecha?" , "¿A fecha?","¿To date?","MV_CH2","D",08,0,0,"G","","","","","MV_PAR04",""       ,""            ,""        ,""     ,""   ,"")

return


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

Static Function FmtoValor(cVal,nDec)
	Local cNewVal := ""
	If nDec == 2
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999.99"))
	Else
		cNewVal := AllTrim(TRANSFORM(cVal,"@E 999,999,999,999"))
	EndIf
Return cNewVal
