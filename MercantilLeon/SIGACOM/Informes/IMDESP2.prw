#include "protheus.ch"
#include "topconn.ch"
#define DMPAPER_LETTER      1                     
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTBASE ³ Autor Mauro Welzel ³	Query	: Nahim Terrazas				³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Remito() Mauro Welzel					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ IMREM2()	                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mercantil Leon SRL											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nahim       ³24/08/2016³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

User Function IMDESP2()
	Local oReport
	PRIVATE cPerg   := "IMDESP2"   // elija el Nombre de la pregunta
	Private cHawbde := ""
	CriaSX1(cPerg)	// Si no esta creada la crea

	if funname() $ "MATA143"
		Pergunte(cPerg,.F.)
		cHawbde := DBA->DBA_HAWB
	else
		Pergunte(cPerg,.t.)
		cHawbde := MV_PAR01
	endif


	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oSection2
	Local oBreak
	Local oSection3
	Local NombreProg := "DESPACHO"
	Local oReport	 := TReport():New("IMDESP2",NombreProg,,{|oReport| PrintReport(oReport)},"DESPACHO")
    oreport:cfontbody:="Arial"
    oReport:SetLandscape()
   oReport:DisableOrientation()

	oReport:nfontbody := 11
	oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera

	oReport:HideFooter()
	
	oSection := TRSection():New(oReport,"SB1",{"SB1"})
	
	oSection2 := TRSection():New(oReport,"SB1",{"SB1"})
	oSection3 := TRSection():New(oReport,"SB1",{"SB1"})

	//		Comienzan a elegir los campos que desean Mostrar
	oSection:SetHeaderPage()
	oSection2:SetHeaderPage()
	oSection3:SetHeaderPage()


	TRCell():New(oSection,"D1_COD"	,"SD1","CODIGO",,TamSx3("D1_COD")[01])
	TRCell():New(oSection,"B1_ESPECIF"	,"SB1","DESCRIPCION",,80)

	TRCell():New(oSection,"B1_UM"		,"SB1","UN.",,TamSx3("B1_UM")[01])
   	TRCell():New(oSection,"B1_GRUPO"	,"SB1","GRUPO",,TamSx3("B1_GRUPO")[01]+4)
    TRCell():New(oSection,"B1_UCODFAB"   ,"SB1","COD. FABRICA",,TamSx3("B1_UCODFAB")[01]+3)
    
	TRCell():New(oSection2,"VACIO1"	,"SB1","       ",,TamSx3("D1_COD")[01]-1)
	TRCell():New(oSection2,"B1_UESPEC2"	,"SB1","DESCRIPCION 2",,80)

    TRCell():New(oSection2,"ZMA_DESCRI"   ,"ZMA","MARCA",,TamSx3("ZMA_DESCRI")[01],,,"LEFT",,"LEFT")/*,PesqPict("ZMA","ZMA_DESCRI") ,TamSx3("ZMA_DESCRI")[1])*/ // cambia

	oSection:Cell("B1_ESPECIF"):SetLineBreak()
	oSection2:Cell("B1_UESPEC2"):SetLineBreak()
	oSection:Cell("B1_ESPECIF"):lHeaderSize := .F.
	oSection2:Cell("B1_UESPEC2"):lHeaderSize := .F.
	oSection:Cell("D1_COD"):lHeaderSize := .F.
	oSection2:Cell("VACIO1"):lHeaderSize := .F.
	oSection2:Cell("ZMA_DESCRI"):lHeaderSize := .F.
	
	oSection:Cell("B1_UM"):lHeaderSize := .F.
	oSection:Cell("B1_UCODFAB"):lHeaderSize := .F.
	
	oBreak = TRBreak():New(oSection,oSection:Cell("D1_COD")," ")
TRFunction():New(oSection:Cell("D1_COD") ,NIL,"ONPRINT",oBreak,/*cTitle*/,/*cPicture*/,/*uFormula*/{|| "" },.F. /*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/,)
Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	Local aArea       := GetArea()
	Local aDatos      := {}
	Local cAliasQry   := GetNextAlias()
	Local cQry        := ""
	Local nCont       := 0
	//Local oSection2 := oReport:Section(1):Section(1)
	Local cFiltro  := ""
    oFont08n := TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)  //Negrito
    oFont09n := TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)  //Negrito


	cQry += " SELECT D1_COD,B1_UESPEC2,B1_DESC, B1_UM, B1_GRUPO, B1_UMARCA,B1_UCODFAB, D1_QUANT,B1_ESPECIF, ZMA_DESCRI "
	cQry += " FROM " + RetSqlName("DBA") + " DBA JOIN "  + CRLF
	cQry += " " + RetSqlName("DBB") + " DBB ON DBA_HAWB = DBB_HAWB AND DBB_FILIAL = DBA_FILIAL AND DBB_TIPONF = '5' AND DBB.D_E_L_E_T_ ='' "  + CRLF
	cQry += " JOIN " + RetSqlName("SF1") + " SF1 ON F1_DOC = DBB_DOC AND DBB_FORNEC = F1_FORNECE AND F1_LOJA = DBB_LOJA AND DBB_FILIAL = F1_FILIAL AND  F1_SERIE IN('IMP','CLO') AND F1_ESPECIE = 'NF' AND SF1.D_E_L_E_T_ ='' "  + CRLF
	cQry += " JOIN " + RetSqlName("SD1") + " SD1 ON D1_DOC = F1_DOC AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_ESPECIE = 'NF' AND SD1.D_E_L_E_T_ ='' "  + CRLF
	cQry += " JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = D1_COD AND SB1.D_E_L_E_T_ ='' "  + CRLF
	cQry += " LEFT JOIN " + RetSqlName("ZMA") + " ZMA ON B1_UMARCA = ZMA_CODIGO  AND ZMA.D_E_L_E_T_ <> '*' "  + CRLF
	cQry += " WHERE  "
	cQry += " DBA_HAWB = '" + cHawbde + "' AND DBA_FILIAL = '" + XFILIAL("DBA") + "' "
	cQry += " AND DBA.D_E_L_E_T_ = '' "  + CRLF
	cQry += " ORDER BY D1_ITEM   "  + CRLF   

	If __CUSERID = '000000'
		Aviso("",cQry,{'ok'},,,,,.t.)
	EndIf

	cQry := ChangeQuery(cQry)

	cQuery:= cQry

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQry), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()

	oSection:Init()
	oSection2:Init()
	oSection3:Init()

	While (cAliasQry)->(! EOF())
		nCont ++

        if(nCont == 1)   
 		oSection:Cell("D1_COD"):SetValue( " " )
		oSection:Cell("B1_UM"):SetValue( " " )
		oSection:Cell("B1_ESPECIF"):SetValue( " ")
		oSection2:Cell("B1_UESPEC2"):SetValue( " " )
		oSection:Cell("B1_GRUPO"):SetValue( " " )
		oSection:Cell("B1_UCODFAB"):SetValue( " ")
        oSection2:Cell("ZMA_DESCRI"):SetValue( " ") // cambia
         
		oSection:PrintLine()
		oSection2:PrintLine()
		EndIf

		oSection:Cell("D1_COD"):SetValue( (cAliasQry)->D1_COD )
		oSection:Cell("B1_UM"):SetValue( (cAliasQry)->B1_UM )
		oSection:Cell("B1_ESPECIF"):SetValue( (cAliasQry)->B1_ESPECIF )
		oSection2:Cell("B1_UESPEC2"):SetValue( (cAliasQry)->B1_UESPEC2 )
		oSection:Cell("B1_GRUPO"):SetValue( (cAliasQry)->B1_GRUPO )
		oSection:Cell("B1_UCODFAB"):SetValue( (cAliasQry)->B1_UCODFAB )
        oSection2:Cell("ZMA_DESCRI"):SetValue( (cAliasQry)->ZMA_DESCRI ) // cambia
	
		oSection:PrintLine(,,,.T.)
		oreport:SkipLine()
		oSection2:PrintLine()
		oreport:SkipLine()

	if oReport:nrow > 1850
	oReport:EndPage()
	oReport:StartPage()
    End if

	dbSkip()
	EndDo
	
	oSection:Finish()
	oSection2:Finish()
	oSection3:Finish()
	

Return

Static Function CriaSX1(cPerg)  // Crear Preguntas

	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	// Los "mv_parEtc" son los nombres con los cuales llamamos a las preguntas en el Query, seria los datos que ingresamos
	// Cuando en el reporte ponemos la opcion (Parametros) por lo tanto es obligatorio Usar Preguntas si el Reporte esta
	// En el menú, si el reporte no esta en el menú podemos llamar al campo y se obtienen los datos de donde esta posicionado

	xPutSx1(cPerg,"01","Despacho ?","Despacho ?","Despacho ?",         "mv_ch3","C",20,0,0,"G","","DBA","","","mv_par01",""       ,""            ,""        ,""     ,"","")
return

Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica

	Local aArea          := GetArea()
	Local aCabec     := {}
	Local cChar          := chr(160) // caracter dummy para alinhamento do cabeçalho
	Local cChar2          := chr(80) // caracter dummy para alinhamento do cabeçalho
	Local titulo     := oReport:Title()
	Local page := oReport:Page()


	/*SELECT DBA_UDIM,DBB_DOC,DBA_UPOLIZ,DBA_DTHAWB,DBA_HAWB,* FROM DBA010 DBA
	JOIN DBB010 DBB ON DBA_HAWB = DBB_HAWB AND DBB_FILIAL = DBA_FILIAL AND DBB_TIPONF = '5'
	WHERE
	DBA_HAWB ='T02469              '
	AND DBA_FILIAL = '0101'*/

	///posicionar en la SF1
	cQuery:= " SELECT DBA_UDIM,DBB_DOC,DBA_UPOLIZ,DBA_DTHAWB,DBA_HAWB,DBB_SERIE,DBB_FORNEC,DBB_LOJA "
	cQuery+= " FROM "+ RetSQLname('DBA') + " DBA JOIN "+ RetSQLname('DBB') + " DBB "
	cQuery+= " ON DBA_HAWB = DBB_HAWB AND DBB_FILIAL = DBA_FILIAL AND DBB_TIPONF = '5' AND DBB.D_E_L_E_T_ != '*' "
	cQuery+= " WHERE DBA_HAWB BETWEEN '" + cHawbde + "' AND '" + cHawbde + "' "
	cQuery+= " AND DBA_FILIAL = '" + XFILIAL("DBA") + "' "
	cQuery+= " AND DBA.D_E_L_E_T_!= '*' "


	cQuery := ChangeQuery(cQuery)
	
	If !Empty(Select("DBAOK"))
		dbSelectArea("DBAOK")
		dbCloseArea()
	Endif

	TCQUERY cQuery NEW ALIAS "DBAOK"

	if DBAOK->(!Eof())

		
		cxRodape := "AV VIEDMA No 51 Z/CEMENTERIO GENERAL - SANTA CRUZ-BOLIVIA - TELF: (+591) 3 3326174 / 3 3331447 / 3 3364244 - FAX: 3 3368672"
		oReport:Say(2370,500,cxRodape,oFont08n,,,)
		rem := "PROCESO N°:" + trim(DBAOK->DBA_HAWB);"
		oReport:Say(140,2650,rem,oFont08n,,,)
		fechaD := "FECHA PROCESO:" + dtoc(stod(DBAOK->DBA_DTHAWB));"
		oReport:Say(200,2650,fechaD,oFont08n,,,)
		usuar := "USUARIO:" + cusername;"
		oReport:Say(260,2650,usuar,oFont08n,,,)	
		dtImpr := "FECHA IMPRESION:" + dtoc(ddatabase);"
		oReport:Say(320,2650,dtImpr,oFont08n,,,)	 	 
		
		cAlm := POSICIONE("SD1",1,XFILIAL("SD1")+DBAOK->DBB_DOC+DBAOK->DBB_SERIE+DBAOK->DBB_FORNECE+DBAOK->DBB_LOJA,"D1_LOCAL") // cambia

		aCabec := {     "MERCANTIL LEON SRL." ,cChar + "       " + cChar ;
		, " " + " " + "        "  ;
		, " " + "                                 DESPACHO                  " + "        "  ;
		, "ALMACEN:" + CVALTOCHAR(cAlm)       ;
		, "      " + "          " +  "      ";
		, "DIM:" + CVALTOCHAR(DBAOK->DBA_UDIM);
		, "      " + "          " +  "      ";
		, "NUM. DE FACT:"+ CVALTOCHAR(DBAOK->DBB_DOC)   ;
		, "      " + "          " +  "      ";
		, "Num. Import. :" + CVALTOCHAR(DBAOK->DBA_UPOLIZ) ; 
		, "      " + "          " +  "      "}
		
	Endif

	RestArea( aArea )
    Return (aCabec) 

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
