#include "protheus.ch"
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

User Function IMREM2()
	Local oReport
	PRIVATE cPerg   := "IMREM2"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

Pergunte(cPerg,.F.)
	oReport := ReportDef()
	oReport:PrintDialog()

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oSection2
	Local oBreak
	Local oSection3
	Local NombreProg := "REMITO"
	Local oReport	 := TReport():New("IMREM2",NombreProg,,{|oReport| PrintReport(oReport)},"REMITO")
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
	TRCell():New(oSection,"B1_ESPECIF"	,"SB1","Descripcion",,80)

	TRCell():New(oSection,"B1_UM"		,"SB1","UN.",,TamSx3("B1_UM")[01])
   	TRCell():New(oSection,"B1_GRUPO"	,"SB1","GRUPO",,TamSx3("B1_GRUPO")[01]+4)
    TRCell():New(oSection,"B1_UCODFAB"   ,"SB1","COD. FABRICA",,TamSx3("B1_UCODFAB")[01]+3)
    
	TRCell():New(oSection2,"VACIO1"	,"SB1","       ",,TamSx3("D1_COD")[01]-1)
	TRCell():New(oSection2,"B1_UESPEC2"	,"SB1","Descripcion 2",,80)

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
    
	#IFDEF TOP
	cQry += " SELECT D1_COD,B1_UESPEC2,B1_DESC, B1_UM, B1_GRUPO, B1_UMARCA,B1_UCODFAB, D1_QUANT,B1_ESPECIF, ZMA_DESCRI "

	cQry += " FROM " + RetSqlName("SB1") + " SB1 left join "  + CRLF
	cQry += " " + RetSqlName("ZMA") + " ZMA on  B1_UMARCA = ZMA_CODIGO  AND ZMA.D_E_L_E_T_ <> '*' ,  "  + CRLF
	cQry += " " + RetSqlName("SF1") + " SF1 ,"  + CRLF
	cQry += " " + RetSqlName("SD1") + " SD1 "  + CRLF
	cQry += "where F1_DOC = D1_DOC and B1_COD = D1_COD and F1_ESPECIE = 'RCN' "
	cQry += "and D1_ESPECIE = 'RCN' AND F1_DOC = '" + CVALTOCHAR(SF1->F1_DOC) + "' AND  sf1.D_E_L_E_T_ <> '*' AND "
	cQry += "SB1.D_E_L_E_T_ <> '*'  AND "  + CRLF
	cQry += "SD1.D_E_L_E_T_ <> '*'  "  + CRLF 
	// cQry += "ZMA.D_E_L_E_T_ <> '*'   "  + CRLF 
	cQry += "ORDER BY D1_ITEM   "  + CRLF  


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
	#ENDIF

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

	PutSX1(cPerg,"01","¿De Fecha?" , "¿De Fecha?","¿De Fecha?","MV_CH1","D",08,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,""   ,"")
	PutSX1(cPerg,"02","¿A Fecha?" , "¿A Fecha?","¿A Fecha?","MV_CH2","D",08,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,""   ,"")
	PutSX1(cPerg,"03","¿Grupo?", "¿Grupo?","¿Grupo?","MV_CH3","C",4,0,0,"G","","","","","MV_PAR03",""       ,""            ,""        ,""     ,"SBM","")
return
Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica
	Local aArea          := GetArea()
	Local aCabec     := {}
	Local cChar          := chr(160) // caracter dummy para alinhamento do cabeçalho
	Local cChar2          := chr(80) // caracter dummy para alinhamento do cabeçalho
	Local titulo     := oReport:Title()
	Local page := oReport:Page()
	 
	cxRodape := "AV VIEDMA No 51 Z/CEMENTERIO GENERAL - SANTA CRUZ-BOLIVIA - TELF: (+591) 3 3326174 / 3 3331447 / 3 3364244 - FAX: 3 3368672"
	oReport:Say(2370,500,cxRodape,oFont08n,,,)
	rem := "REMITO N°:" + trim(SF1->F1_UCORREL);"
	oReport:Say(140,2700,rem,oFont08n,,,)
	fechaD := "FECHA:" + CVALTOCHAR(SF1->F1_EMISSAO);"
	oReport:Say(180,2700,fechaD,oFont08n,,,)
	usuar := "USUARIO:" + CVALTOCHAR(SF1->F1_USRREG);"
	oReport:Say(220,2700,usuar,oFont08n,,,)
	
	 
	cAlm := POSICIONE("SD1",1,XFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"D1_LOCAL") // cambia
	aCabec := {     "MERCANTIL LEON SRL." ,cChar + "       " + cChar ;
	, " " + " " + "        "  ;
	, " " + "                            REMITO DE ENTRADA                  " + "        "  ;
	, "ALMACEN:" + CVALTOCHAR(cAlm)       ;
	, "NATURALEZA:" + CVALTOCHAR(SF1->F1_NATUREZ);
	, "NUM. DE DOC:"+ CVALTOCHAR(SF1->F1_DOC)   ;
	, "Num. Import. :" + CVALTOCHAR(SF1->F1_UPOLIZA) ; 
	, "      " + "          " +  "      "}
	
	RestArea( aArea )
    Return (aCabec) 
