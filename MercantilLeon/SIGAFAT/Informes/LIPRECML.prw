#Include "RwMake.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "Colors.ch"
//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

//Colunas
#Define COL_ITEMM   0015
#Define COL_COD   0040
#Define COL_FABCAN   0100
#Define COL_DESCESPE  0170
#Define COL_UMED  0250
#Define	COL_QANTIDA	0415
#Define	COL_PRECUNIT	0480
#Define COL_PRECTOTAL 0600
#Define COL_FENTREGA 0620

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  LIPRECML ºAutor ³ERICK ETCHEVERRY º   º Date 08/12/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion del PO				 	  		                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ML SRL		                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LIPRECML()
	LOCAL cString		:= "SC7"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Impresion de lista de precios"
	LOCAL cDesc1	    := "Impresion de lista de precios"
	LOCAL cDesc2	    := "conforme PE"
	LOCAL cDesc3	    := "Especifico ML"
	PRIVATE nomeProg 	:= "LIPRECML"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont := "Courier New"
	Private oFontDet  := TFont():New(cNomeFont,07,07,,.F.,,,,.T.,.F.)
	Private oFontDet8  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontDetN := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontDN := 	 TFont():New(cNomeFont,07,07,,.T.,,,,.F.,.F.)
	Private oFontDetNN := TFont():New(cNomeFont,012,012,,.T.,,,,.F.,.F.)
	Private oFontRod  := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontTit  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTitt:= TFont():New(cNomeFont,015,015,,.T.,,,,.F.,.F.)
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 		:= 0
	PRIVATE cPerg   := "LIPRECML"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.t.)

	Processa({ |lEnd| MOVD3CONF("Impresion de listado de precios")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)///configuracion impresora
	Local cFilename := 'LIPRECML'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "LIPRECML" + dToS(date()) + "_" + StrTran(time(), ':', '-')
	//Criando o objeto do FMSPrinter
	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrint, "", , , , .T.)

	//Setando os atributos necessários do relatório
	oPrint:SetResolution(72)
	oPrint:SetLandscape()
	oPrint:SetPaperSize(1)
	oPrint:SetMargin(60, 60, 60, 60)

Return Nil

Static Function fImpPres(lEnd,WnRel,cString,nReg)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local nTotal := 0
	Local lRetCF := .f.
	Local aInterna := {}
	Local cParam18Grupo:= "" //Utilizado para digitar los grupos, ejemplo: T016,T017,T018
	Local i
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 520//570
	Private nColIni   := 010
	Private nColFin   := 730
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2
	Private cDoc

	If Select("VW_B1PRD") > 0
		dbCloseArea()
	Endif

	cParam18Grupo	:= ALLTRIM(MV_PAR18)

	cQuery:= " SELECT B1_COD,B1_UCODFAB,ISNULL((SELECT ZMA_DESCRI FROM " + RetSQLname('ZMA') + " ZMA WHERE ZMA_CODIGO = B1_UMARCA AND ZMA.D_E_L_E_T_ = ''), '') ZMA_DESCRI,B1_ESPECIF,B1_UESPEC2,B1_UM,DA1_MOEDA, "///cabecera
	cQuery+= " CASE DA1_MOEDA WHEN 1 "
	cQuery+= "   THEN CASE "+ cvaltochar(MV_PAR16) + " WHEN 1 THEN isnull(DA1_PRCVEN,0) "
	cQuery+= "   ELSE isnull(DA1_PRCVEN,0)/M2_MOEDA2 END "
	cQuery+= " WHEN 2  "
	cQuery+= "   THEN CASE DA1_MOEDA WHEN "+ cvaltochar(MV_PAR16) + " THEN isnull(DA1_PRCVEN,0)  "
	cQuery+= "   ELSE isnull(DA1_PRCVEN,0)*M2_MOEDA2 END  "
	cQuery+= " ELSE 0 END DA1_PRCVEN,B1_BITMAP "
	cQuery+= " FROM " + RetSQLname('SB1') + " SB1 LEFT JOIN " + RetSQLname('DA1') + " DA1 ON B1_COD = DA1_CODPRO AND DA1_CODTAB = '"+ MV_PAR15 +"' AND DA1.D_E_L_E_T_ = '' "
	cQuery+= " JOIN " + RetSQLname('SM2') + " SM2 ON M2_DATA = '" + DTOS(dDataBase) + "' AND SM2.D_E_L_E_T_ = '' "
	cQuery+= " WHERE B1_UGRPNUE BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery+= " AND B1_TIPO BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery+= " AND B1_UMARCA BETWEEN '" + MV_PAR09 + "' AND '" + MV_PAR10 + "' "
	cQuery+= " AND B1_UTIPNUE BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
	cQuery+= " AND B1_UM BETWEEN '" + MV_PAR11 + "' AND '" + MV_PAR12 + "' "
	cQuery+= " AND B1_PROC BETWEEN '" + MV_PAR13 + "' AND '" + MV_PAR14 + "' AND SB1.D_E_L_E_T_ = '' "

	If(EMPTY(cParam18Grupo))//Si no hay datos en el parámetro 18, utilizar los parámetros De/A Grupo(MV_PAR01 y MV_PAR02)
		cQuery+= " AND B1_GRUPO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	Else
		cParam18Grupo:= getGrupoInFormat(cParam18Grupo)
		If(!Empty(cParam18Grupo))
			cQuery+= " AND B1_GRUPO IN (" + cParam18Grupo + ")"
		else
			return
		EndIf
	EndIf

	//


	TCQuery cQuery New Alias "VW_B1PRD"

	fImpCab(.t.) ///

	if ! VW_B1PRD->(EoF())

		nTot := 1
		While ! VW_B1PRD->(EoF())

			If nLinAtu + nTamLin > nLinFin
				fImpRod(.f.)//rodape
				fImpCab(.f.)//CABEC
			EndIf

			//items
			oPrint:SayAlign(nLinAtu, COL_ITEMM,cValToChar(nTot),     oFontDet, 030, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COD, VW_B1PRD->B1_COD,     oFontDet, 270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_FABCAN,VW_B1PRD->B1_UCODFAB,     oFontDet, 100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_DESCESPE, VW_B1PRD->ZMA_DESCRI ,     oFontDet, 0170, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_QANTIDA,ALLTRIM(TRANSFORM(VW_B1PRD->DA1_PRCVEN-(VW_B1PRD->DA1_PRCVEN *(mv_par17/100)),"@E 999,999,999,999.99")) ,     oFontDet, 100, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_PRECUNIT, VW_B1PRD->B1_UM ,     oFontDet, 100, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			if !empty(VW_B1PRD->B1_BITMAP)
				cFile := RepositArq(VW_B1PRD->B1_BITMAP)//trae imagen repositorio

				oPrint:SayBitmap(nLinAtu,COL_PRECTOTAL - 30, GetSrvProfString("Startpath","") +alltrim(cFile),60,60)

				FErase(GetSrvProfString("Startpath","") +alltrim(cFile))

				//oPrint:SayBitmap(nLinAtu,COL_PRECTOTAL, GetSrvProfString("Startpath","") +"20210406_01-44-5012806imgtemp.jpg",200,200)

			endif
			aDescri := TexToArray(ALLTRIM(VW_B1PRD->B1_ESPECIF),40)

			nLinFor := nLinAtu

			for i := 1 to len(aDescri)//por lo menos dos

				oPrint:SayAlign(nLinFor, COL_UMED,aDescri[i] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				nLinFor += nTamLin
			next i

			aDescri := TexToArray(ALLTRIM(VW_B1PRD->B1_UESPEC2),40)

			nLinFor2 := nLinFor

			for i := 1 to len(aDescri)//por lo menos dos

				oPrint:SayAlign(nLinFor2, COL_UMED,aDescri[i] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				nLinFor2 += nTamLin
			next i

			nTot += 1

			nLinAtu += nTamLin + 55
			VW_B1PRD->(DbSkip())
		enddo

		nLinAtu += (nTamLin * 2)
		VW_B1PRD->(DbCloseArea())
	Endif

	fImpRod(.t.)

//Mostrando o relatório
	oPrint:Preview()

	RestArea(aArea)

RETURN

Static Function fImpCab(lImp)
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFLogo := GetSrvProfString("Startpath","") + "logoML.bmp"

	oPrint:StartPage()
	if lImp
		//Iniciando Página

		oPrint:SayBitmap(035,017, cFLogo,190,045)

		//Cabeçalho
		oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)

		cTexto := "LISTA DE PRECIO"


		nLinCab += (nTamLin * 3)

		oPrint:SayAlign(nLinCab, nColMeio - 180, cTexto, oFontTitt, 400, 30, , PAD_CENTER, 0)

		nLinCab += (nTamLin * 2.5)
		//Linha Separatória


	else
		nLinCab += (nTamLin * 5)

	endif

	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	nLinCab += (nTamLin * 0.5)
	oPrint:SayAlign(nLinCab, COL_ITEMM, "ITEM",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COD, "CODIGO ML",     oFontDetN, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_FABCAN, "COD PROVEEDOR",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCESPE, "MARCA",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_UMED, "DESCRIPCION",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_QANTIDA, "PRECIO " + IIF(MV_PAR16 == 1,"Bs","$us"),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PRECUNIT, "UM",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PRECTOTAL, "FOTO",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += (nTamLin * 1.4)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")

	nLinCab += nTamLin

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod(lImp)//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin + 20
	Local cTextoEsq := ''
	Local cTextoDir := ''

	cFecha:= DTOC(dDataBase)

	cTextoDir := "Página " + cValToChar(nPagAtu) + " " + cFecha + "-PRC"+cValToChar(mv_par17)
	oPrint:Line(nLinRod, nColIni, nLinRod,nColFin,CLR_BLACK,"-1")
	nLinRod += 10
	//Imprimindo os textos
	oPrint:SayAlign(nLinRod, nColMeio - 40,    "Mercantil León S.R.L - Av. Viedma N° 51", oFontRod, 400, 05, CLR_BLACK, PAD_LEFT,  0)
	nLinRod += (nTamLin * 1.4)
	oPrint:SayAlign(nLinRod, nColMeio - 70,    "Santa Cruz de la Sierra - Bolivia - TEL. (591) 3 3364244", oFontRod, 400, 05, CLR_BLACK, PAD_LEFT,  0)
	nLinRod += (nTamLin * 1.4)
	oPrint:SayAlign(nLinRod, nColMeio - 10,    "www.mercantilleon.com", oFontRod, 400, 05, CLR_BLACK, PAD_LEFT,  0)
	oPrint:SayAlign(nLinRod, nColFin-165, cTextoDir, oFontRod, 200, 05, CLR_GRAY, PAD_RIGHT, 0)
	//Finalizando a página e somando mais um
	oPrint:EndPage()
	nPagAtu++
Return

Static Function ffechalarga(sfechacorta)

	//20101105

	Local sFechalarga:=""
	Local descmes := ""
	Local sdia:=substr(sfechacorta,7,2)
	Local smes:=substr(sfechacorta,5,2)
	Local sano:=substr(sfechacorta,0,4)

	if smes=="01"
		descmes :="Enero"
	endif
	if smes=="02"
		descmes :="Febrero"
	endif
	if smes=="03"
		descmes :="Marzo"
	endif
	if smes=="04"
		descmes :="Abril"
	endif
	if smes=="05"
		descmes :="Mayo"
	endif
	if smes=="06"
		descmes :="Junio"
	endif
	if smes=="07"
		descmes :="Julio"
	endif
	if smes=="08"
		descmes :="Agosto"
	endif
	if smes=="09"
		descmes :="Septiembre"
	endif
	if smes=="10"
		descmes :="Octubre"
	endif
	if smes=="11"
		descmes :="Noviembre"
	endif
	if smes=="12"
		descmes :="Diciembre"
	endif

	sFechalarga := sdia + " de " + descmes + " de " + sano

Return(sFechalarga)

Static Function CriaSX1(cPerg)  // Crear Preguntas
	Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= ""

	xPutSx1(cPerg,"01","De Grupo ?","De Grupo ?","De Grupo ?","mv_ch1","C",4,0,0,"G","","SBM","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A Grupo ?","A Grupo ?","A Grupo ?","mv_ch2","C",4,0,0,"G","","SBM","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De Grupo nuevo?","De Grupo nuevo ?","De Grupo nuevo ?",         "mv_ch3","C",4,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A Grupo nuevo?","A Grupo nuevo ?","A Grupo nuevo ?",         "mv_ch3","C",4,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De Tipo?","De Tipo ?","De Tipo ?",         "mv_ch3","C",2,0,0,"G","","02","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A Tipo ?","A Tipo ?","A Tipo ?",         "mv_ch3","C",2,0,0,"G","","02","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De Tipo nuevo ?","De Tipo nuevo ?","De Tipo nuevo ?",         "mv_ch3","C",2,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A Tipo nuevo ?","A Tipo nuevo ?","A Tipo nuevo ?",         "mv_ch3","C",2,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","De Marca ?","De Marca ?","De Marca ?",         "mv_ch3","C",3,0,0,"G","","ZMA","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","A Marca ?","A Marca ?","A Marca ?",         "mv_ch3","C",3,0,0,"G","","ZMA","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"11","De Unidad de medida ?","De Unidad de medida ?","De Unidad de medida ?",         "mv_ch3","C",2,0,0,"G","","SAH","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"12","A Unidad de medida ?","A Unidad de medida ?","A Unidad de medida ?",         "mv_ch3","C",2,0,0,"G","","SAH","","","mv_par12",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"13","De Proveedor ?","De Proveedor ?","De Proveedor ?",         "mv_ch3","C",6,0,0,"G","","SA2","","","mv_par13",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"14","A Proveedor ?","A Proveedor ?","A Proveedor ?",         "mv_ch3","C",6,0,0,"G","","SA2","","","mv_par14",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"15","Lista de precio ?","Lista de precio ?","Lista de precio ?",         "mv_ch3","C",3,0,0,"G","","DA0","","","mv_par15",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"16","Moneda ?" , "Moneda ?" ,"Moneda ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par16","Bolivianos","Bolivianos","Bolivianos","","Dolares","Dolares","Dolares")
	xPutSX1(cPerg,"17","Descuento % ?" , "Descuento % ?" ,"Descuento % ?" ,"MV_CH4","N",3,0,0,"C","","","","","mv_par17","","","","","","","")
	xPutSx1(cPerg,"18","Grupos?","Grupos?","Grupos?",         "mv_chi","C",24,0,0,"G","","","","","mv_par18",""       ,""            ,""        ,""     ,"","")

	//xPutSx1(cPerg,"08","A fecha ?","A fecha ?","A fecha ?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")*/

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

Static Function TexToArray(cTexto,nTamLine)
	Local aTexto	:= {}
	Local aText2	:= {}
	Local cToken	:= " "
	Local nX
	Local nTam		:= 0
	Local cAux		:= ""

	aTexto := STRTOKARR ( cTexto , cToken )

	For nX := 1 To Len(aTexto)
		nTam := Len(cAux) + Len(aTexto[nX])
		If nTam <= nTamLine
			cAux += aTexto[nX] + IIF((nTam+1) <= nTamLine, cToken,"")
		Else
			AADD(aText2,cAux)
			cAux := aTexto[nX] + cToken
		Endif
	Next nX

	If !Empty(cAux)
		AADD(aText2,cAux)
	Endif

Return(aText2)

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  RepositArq  ºAutor  ³Erick Etcheverry    Fecha 07/11/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion³ EXTRAE IMAGEN REPOSITORIO		            			  º±±
±±º          ³ 				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GLOBAL                                             		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC function RepositArq(cBitma)
	Local cArquivo  := dToS(date()) + "_" + StrTran(time(), ':', '-')
	Local nRam := Randomize(1,34000)
	cFile := cArquivo+cValToChar(nRam)+"imgtemp.jpg"
	If RepExtract(alltrim(cBitma),cFile) //CAMPO BITMAP Q CONTIENE BINARIO IMAGEN RUTA DONDE GUARDAR
		// If RepExtract(OrdenesCom->T9_BITMAP,cFile) //CAMPO BITMAP Q CONTIENE BINARIO IMAGEN RUTA DONDE GUARDAR
		//alert("Extração realizada")
	Else
		//alert("Extração nao realizada")
	EndIF
Return cFile

/**
* @author: Denar Terrazas Parada
* @since: 03/12/2021
* @description: Función que convierte el parámetro MV_PAR18 de los Grupos para poder realizar un IN en sentencia SQL
* @parameters: codigos de grupos de productos separados por comas -> T010,T011,T012
* @return: texto
*/
Static Function getGrupoInFormat(cParam)
	Local cRet	:= ""
	Local lOk	:= .T.
	Local aArray:= {}
	Local i

	If( (";" $ cParam) .OR. ("." $ cParam) .OR. ("/" $ cParam) .OR. ("'" $ cParam) .OR. (",," $ cParam))
		alert("Los Grupos deben estar separadas comas(,). Por favor revisar el parámetro.")
		lOk:= .F.
	EndIf

	if(lOk)
		aArray:= StrTokArr(cParam, ",")
		for i:= 1 to Len(aArray)
			cRet+= "'" + aArray[i] + "'"
			if(i < Len(aArray))
				cRet+= ", "
			EndIf
		next i
	EndIf

Return cRet
