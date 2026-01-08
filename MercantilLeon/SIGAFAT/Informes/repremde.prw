#include "totvs.ch"
#include 'parmtype.ch'
#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reporte de Remitos Nahim Terrazas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ML															³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function repremde()
	Local oReport
	PRIVATE cPerg   := "REPREMDE"   // elija el Nombre de la pregunta
	criasx1(cPerg)

	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg := "Reporte de remitos"

	pergunte(cperg, .F.)
	oReport	 := TReport():New("repremde",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte de remitos")

	oSection := TRSection():New(oReport,"Ventas",{"SN4"})
	oReport:SetTotalInLine(.F.)

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"C6_PRODUTO"	,"SC6","Produc")
	TRCell():New(oSection,"B1_ESPECIF"	,"SB1","Descr.Espec.",,35)
	TRCell():New(oSection,"B1_UESPEC2"	,"SB1","Descr.Espec2",,10)
	TRCell():New(oSection,"B1_GRUPO"	,"SB1","Grupo")
	TRCell():New(oSection,"C6_UM"		,"SC6","UM")
	TRCell():New(oSection,"C6_QTDVEN"	,"SC6","Ctd.Remito",PesqPict("SC6","C6_QTDVEN"))
	TRCell():New(oSection,"D2_QUANT"	,"SD2","Ctd. Factur.",PesqPict("SD2","D2_QUANT"))
	TRCell():New(oSection,"C6_DESCONT"	,"SC6","Descuen.",PesqPict("SC6","C6_DESCONT"))
	TRCell():New(oSection,"D2_TOTAL"	,"SD2","Valor Total",PesqPict("SD2","D2_TOTAL"))
	TRCell():New(oSection,"C6_TES"		,"SC6","Tipo Salida")
	TRCell():New(oSection,"C6_SEGUM"	,"SC6","Segunda UM")
	TRCell():New(oSection,"B1_CONV"		,"SB1","Fact. Mult.",PesqPict("SB1","B1_CONV"))
	TRCell():New(oSection,"D2_QTVSEGUM"	,"SD2","Ctd.Rem 2aUM",PesqPict("SD2","D2_TOTAL"))
	TRCell():New(oSection,"D2_QTSEGUM"	,"SD2","Ctd.Fac 2aUM",PesqPict("SD2","D2_TOTAL"))

	//TRCell():New(oSection2,"F2_DESCONT","SF2","Dcto($)",PesqPict("SF2","F2_VALMERC"),TamSX3("F2_VALMERC")[1])

Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local cFiltro  := ""
	Local aDados[17]

	oSection:Cell("C6_PRODUTO"):SetBlock( { || aDados[1] })
	oSection:Cell("B1_ESPECIF"):SetBlock( { || aDados[2] })
	oSection:Cell("B1_UESPEC2"):SetBlock( { || aDados[3] })
	oSection:Cell("B1_GRUPO"):SetBlock( { || aDados[4] })
	oSection:Cell("C6_UM"):SetBlock( { || aDados[5] })
	oSection:Cell("C6_QTDVEN"):SetBlock( { || aDados[6] })
	oSection:Cell("D2_QUANT"):SetBlock( { || aDados[7] })
	oSection:Cell("C6_DESCONT"):SetBlock( { || aDados[8] })
	oSection:Cell("D2_TOTAL"):SetBlock( { || aDados[9] })
	oSection:Cell("C6_TES"):SetBlock( { || aDados[10] })
	oSection:Cell("C6_SEGUM"):SetBlock( { || aDados[11] })
	oSection:Cell("B1_CONV"):SetBlock( { || aDados[12] })
	oSection:Cell("D2_QTVSEGUM"):SetBlock( { || aDados[13] })
	oSection:Cell("D2_QTSEGUM"):SetBlock( { || aDados[14] })

	#IFDEF TOP

	// Query
	oSection:Init()
	aFill(aDados,nil)

	BeginSql alias "QRYSA1"

		SELECT
		C6_PRODUTO,
		B1_DESC,
		B1_UESPEC2,
		B1_ESPECIF,
		B1_GRUPO,
		C6_UM,
		SUM(C6_QTDVEN)
	    AS C6_QTDVEN,
	ISNULL(SUM(D2_QUANT),0) D2_QUANT, SUM(C6_DESCONT) C6_DESCONT, SUM(C6_VALOR) C6_VALOR, ISNULL(SUM(D2_TOTAL),0) D2_TOTAL, C6_TES, MAX(C6_SEGUM)C6_SEGUM, B1_CONV,
	case  WHEN B1_TIPCONV = 'M' THEN  ISNULL(B1_CONV * SUM(D2_QUANT),0) ELSE ISNULL(SUM(D2_QUANT)/ NULLIF(B1_CONV,0),0) END D2_QTSEGUM,
	case  WHEN B1_TIPCONV = 'M'
	THEN
		Sum(C6_QTDVEN)* B1_CONV
	ELSE
		ISNULL(Sum(C6_QTDVEN)/ NULLIF(B1_CONV,0),0)
	END D2_QTVSEGUM

	FROM
	%table:SC6% SC6
	LEFT JOIN
	%table:SB1% SB1
	ON B1_COD = C6_PRODUTO
	AND SB1.%notdel%
	LEFT JOIN
	%table:SC5% SC5
	ON C5_NUM = C6_NUM
	AND C6_CLI = C5_CLIENTE
	AND C6_LOJA = C5_LOJACLI
	AND C5_FILIAL = C6_FILIAL
	AND SC5.%notdel%
	JOIN
	(SELECT SUM(D2_QUANT) D2_QUANT, SUM(D2_TOTAL) D2_TOTAL, D2_QTSEGUM,D2_ESPECIE, D2_COD, D2_PEDIDO, D2_EST, D2_ITEMPV , D2_CLIENTE, D2_LOJA , D2_EMISSAO,D2_DOC,D2_SERIE
	FROM %table:SD2% SD2
	WHERE SD2.%notdel%
	GROUP BY D2_COD, D2_TOTAL, D2_QTSEGUM,D2_ESPECIE ,D2_COD, D2_PEDIDO, D2_EST, D2_ITEMPV,D2_CLIENTE, D2_LOJA, D2_EMISSAO ,D2_DOC,D2_SERIE ) SD2
	ON D2_PEDIDO = C6_NUM
	AND D2_COD = C6_PRODUTO
	AND D2_EST BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
	AND D2_EMISSAO BETWEEN %exp:dtos(MV_PAR14)% AND %exp:dtos(MV_PAR15)%
	AND SD2.D2_ITEMPV = C6_ITEM
	AND SD2.D2_ESPECIE = 'RFN'
	AND D2_CLIENTE+D2_LOJA = C6_CLI+C6_LOJA
	WHERE
	SC6.%notdel%
	AND B1_GRUPO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND C5_EMISSAO BETWEEN %exp:dtos(MV_PAR03)% AND %exp:dtos(MV_PAR04)%
	AND C5_CLIENTE BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08%
	AND C5_VEND1 BETWEEN %exp:MV_PAR09% AND %exp:MV_PAR10%
	AND C6_TES BETWEEN %exp:MV_PAR11% AND %exp:MV_PAR12%	
	GROUP BY
	C6_PRODUTO, B1_DESC, B1_UESPEC2,B1_ESPECIF, B1_GRUPO, C6_UM, C6_TES , B1_CONV,B1_TIPCONV//, C6_ITEM,C6_NUM,C6_SEGUM
	EndSql

	/*
	LEFT JOIN
	(
	SELECT MAX(EL_NUMERO) EL_NUMERO,EL_PREFIXO,EL_EMISSAO
	FROM %table:SEL% SEL
	WHERE SEL.%notdel%
	GROUP BY EL_NUMERO,
				EL_PREFIXO,
				EL_EMISSAO
	) SEL ON EL_NUMERO = D2_DOC
	AND EL_PREFIXO = D2_SERIE

	AND ISNULL(EL_EMISSAO,%exp:dtos(MV_PAR16)%) BETWEEN %exp:dtos(MV_PAR16)% AND %exp:dtos(MV_PAR17)%
	*/

	oSection:EndQuery()
	cQuery:=GetLastQuery()

	If __CUSERID = '000000'
		aviso("",cvaltochar(cQuery[2]`````),{'ok'},,,,,.t.)
	EndIf
	
	nTot:= 0
	nTotDes := 0
	nCanTV := 0
	nCanTF := 0
	nQtvum := 0
	nQtfaseg := 0

	While QRYSA1->(!Eof())
		aDados[1]:= QRYSA1->C6_PRODUTO
		aDados[2]:= QRYSA1->B1_ESPECIF
		aDados[3]:= QRYSA1->B1_UESPEC2
		aDados[4]:= QRYSA1->B1_GRUPO
		aDados[5]:= QRYSA1->C6_UM
		aDados[6]:= QRYSA1->C6_QTDVEN
		aDados[7]:= QRYSA1->D2_QUANT

		aDados[8]:= iif( MV_PAR13 == 2 ,xMoeda(QRYSA1->C6_DESCONT,1,2,DDATABASE),QRYSA1->C6_DESCONT)
		aDados[9]:= iif( MV_PAR13 == 2 ,xMoeda(QRYSA1->D2_TOTAL,1,2,DDATABASE),QRYSA1->D2_TOTAL)
		aDados[10]:= QRYSA1->C6_TES
		aDados[11]:= QRYSA1->C6_SEGUM
		aDados[12]:= QRYSA1->B1_CONV
		aDados[13]:= QRYSA1->D2_QTVSEGUM
		aDados[14]:= QRYSA1->D2_QTSEGUM

		nTot+= iif( MV_PAR13 == 2 ,xMoeda(QRYSA1->D2_TOTAL,1,2,DDATABASE),QRYSA1->D2_TOTAL)
		nTotDes += iif( MV_PAR13 == 2 ,xMoeda(QRYSA1->C6_DESCONT,1,2,DDATABASE),QRYSA1->C6_DESCONT)

		nCanTV +=  QRYSA1->C6_QTDVEN
		nCanTF += QRYSA1->D2_QUANT
		nQtvum += QRYSA1->D2_QTVSEGUM
		nQtfaseg += QRYSA1->D2_QTSEGUM

		oSection:PrintLine()
		aFill(aDados,nil)
		QRYSA1->(DbSkip())

	enddo

	//sub final
	cLinha := Replicate("_",400)
	nRow := oReport:Row()
	oReport:PrintText(cLinha, nRow, 20)
	oReport:SkipLine()

	//////total general
	aDados[2] := "Total general: "
	
	aDados[6]:= nCanTV
	aDados[7]:= nCanTF

	aDados[8] := nTotDes
	aDados[9] := nTot

	aDados[13]:= nQtvum
	aDados[14]:= nQtfaseg

	oSection:PrintLine()
	aFill(aDados,nil)
	oReport:SkipLine()

	#ELSE

	//Transforma parametros do tipo Range em expressao ADVPL para ser utilizada no filtro
	#ENDIF

	oSection:Finish()

	QRYSA1->(dbCloseArea())

	oReport:EndPage()

	oSection:Print()

Return

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/

	xPutSx1(cPerg,"01","De grupo?","De grupo?","De grupo?",         "mv_ch1","C",04,0,0,"G","","SBM","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A grupo?","A grupo?","A grupo?",         "mv_ch2","C",04,0,0,"G","","SBM","","","mv_par02",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"03","De fecha pedido?","De fecha pedido?","De fecha pedido?",         "mv_ch1","D",08,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A fecha pedido?","A fecha pedido?","A fecha pedido?",         "mv_ch2","D",08,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"05","De departamento?","De departamento?","De departamento?",         "mv_ch1","C",02,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A departamento?","A departamento?","A departamento?",         "mv_ch2","C",02,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"07","De cliente?","De cliente?","De cliente?",         "mv_ch1","C",06,0,0,"G","","SA1","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A cliente?","A cliente?","A cliente?",         "mv_ch2","C",06,0,0,"G","","SA1","","","mv_par08",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"09","De vendedor?","De vendedor?","De vendedor?",         "mv_ch1","C",06,0,0,"G","","SA3","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A vendedor?","A vendedor?","A vendedor?",         "mv_ch2","C",06,0,0,"G","","SA3","","","mv_par10",""       ,""            ,""        ,""     ,"","")

	xPutSx1(cPerg,"11","De tes?","De tes?","De tes?",         "mv_ch1","C",03,0,0,"G","","SF4","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"12","A tes?","A tes?","A tes?",         "mv_ch2","C",03,0,0,"G","","SF4","","","mv_par12",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"13","Moneda ?" , "Moneda ?" ,"Moneda ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par13","Bolivianos","Bolivianos","Bolivianos","","Dolares","Dolares","Dolares")

	xPutSx1(cPerg,"14","De fecha facturacion?","De fecha facturacion?","De fecha facturacion?",         "mv_ch1","D",08,0,0,"G","","","","","mv_par14",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"15","A fecha facturacion?","A fecha facturacion?","A fecha facturacion?",         "mv_ch2","D",08,0,0,"G","","","","","mv_par15",""       ,""            ,""        ,""     ,"","")

	/*xPutSx1(cPerg,"16","De fecha emision?","De fecha emision?","De fecha emision?",         "mv_ch1","D",08,0,0,"G","","","","","mv_par16",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"17","A fecha emision?","A fecha emision?","A fecha emision?",         "mv_ch2","D",08,0,0,"G","","","","","mv_par17",""       ,""            ,""        ,""     ,"","")
	*/	
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
