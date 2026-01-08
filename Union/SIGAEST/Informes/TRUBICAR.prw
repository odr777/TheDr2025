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

User Function trubicar()
	Local oReport
	PRIVATE cPerg   := "TRUBICAR"   // elija el Nombre de la pregunta
	criasx1(cPerg)
	
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local NombreProg := "Reporte ubicaciones"
	
	pergunte(cperg, .F.)
	oReport	 := TReport():New("trubicar",NombreProg,cPerg,{|oReport| PrintReport(oReport)},"Reporte de ubicaciones")
	
	oSection := TRSection():New(oReport,"trubicar",{"SN4"})
	oReport:SetTotalInLine(.F.)

	// TRCell():New(oParent,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)

	TRCell():New(oSection,"DA_FILIAL"	,"SDA","Sucursal")
	TRCell():New(oSection,"DA_PRODUTO"	,"SDA","Codigo de producto")
	TRCell():New(oSection,"B1_DESC"		,"SB1","Producto")
	TRCell():New(oSection,"B1_UFABRIC"	,"SB1","Fabricante")
	TRCell():New(oSection,"DB_QUANT"	,"SDA","Cantidad de stock")
	TRCell():New(oSection,"DA_LOCAL"	,"SDA","Deposito")
	TRCell():New(oSection,"DA_LOTECTL"	,"SDA","Lote")
	TRCell():New(oSection,"B8_DTVALID"	,"SDA","Vencimiento")
	TRCell():New(oSection,"DB_LOCALIZ"	,"SDA","Ubicacion")
	
Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local cFiltro  := ""

	#IFDEF TOP
	// Query
	oSection:BeginQuery()
	BeginSql alias "QRYSA1"
	
		SELECT DA_FILIAL,
			DA_PRODUTO,
			B1_DESC,
			B1_UFABRIC,
			DB_QUANT,
			DA_LOCAL,
			DA_LOTECTL,
			B8_DTVALID, 
			DB_LOCALIZ
		FROM %table:SDA% SDA
		JOIN %table:SB1% SB1 ON DA_PRODUTO = B1_COD
		JOIN %table:SB8% SB8 ON DA_FILIAL = B8_FILIAL 
			AND B8_PRODUTO = DA_PRODUTO 
			AND B8_LOCAL = DA_LOCAL 
			AND B8_LOTECTL = DA_LOTECTL 
			AND DA_NUMLOTE = B8_NUMLOTE
		JOIN %table:SDB% SDB ON DA_FILIAL = DB_FILIAL 
			AND DA_DOC = DB_DOC 
			AND DA_PRODUTO = DB_PRODUTO 
			AND DA_LOCAL = DB_LOCAL 
			AND DA_LOTECTL = DB_LOTECTL 
			AND DA_LOJA = DB_LOJA 
			AND DA_CLIFOR = DB_CLIFOR 
			AND DA_NUMSEQ = DB_NUMSEQ 
			AND DA_ORIGEM = DB_ORIGEM 
			AND DB_ESTORNO = ''
		WHERE SDA.%notdel%
		AND SDB.%notdel%
		AND SB1.%notdel%
		AND SB8.%notdel%
		AND DA_FILIAL BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
		AND DA_PRODUTO BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
		AND DA_LOCAL BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
		AND DA_LOTECTL BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08%
		AND DB_LOCALIZ BETWEEN %exp:MV_PAR09% AND %exp:MV_PAR10%
		ORDER BY DA_FILIAL, DA_PRODUTO

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
 
	xPutSx1(cPerg,"01","De sucursal?","De sucursal?","De sucursal?",         "mv_ch1","C",04,0,0,"G","","SM0","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A sucursal?","A sucursal?","A sucursal?",         "mv_ch2","C",04,0,0,"G","","SM0","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	
	xPutSx1(cPerg,"03","De producto?","De producto?","De producto?",         "mv_ch1","C",30,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A producto?","A producto?","A producto?",         "mv_ch2","C",30,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	
	xPutSx1(cPerg,"05","De deposito?","De deposito?","De deposito?",         "mv_ch1","C",02,0,0,"G","","NNR","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A deposito?","A deposito?","A deposito?",         "mv_ch2","C",02,0,0,"G","","NNR","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	
	xPutSx1(cPerg,"07","De lote?","De lote?","De lote?",         "mv_ch1","C",10,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A lote?","A lote?","A lote?",         "mv_ch2","C",10,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	
	xPutSx1(cPerg,"09","De ubicacion?","De ubicacion?","De ubicacion?",         "mv_ch1","C",15,0,0,"G","","SBE","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A ubicacion?","A ubicacion?","A ubicacion?",         "mv_ch2","C",15,0,0,"G","","SBE","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	
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
