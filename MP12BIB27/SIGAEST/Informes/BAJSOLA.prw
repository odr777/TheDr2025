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
#Define COL_GRUPO   0015
#Define COL_COD   0022
#Define COL_DESCR   0057
#Define COL_QFATREQ  0120
#Define COL_QFAT  0190
//#Define	COL_QRECFA 	0230
#Define	COL_PRECO	0320
#Define	COL_DESTO	0340
#Define COL_CLVL 0390
#Define COL_ITCTA 0500
#Define COL_NETO 0520
#Define COL_UNIT 0620

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  BAJSOLA ºAutor ³ERICK ETCHEVERRY º   º Date 08/12/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion de importacion FOB despacho producto              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION SRL	                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BAJSOLA()
	LOCAL cString		:= "SCP"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Impresion solicitud al almacen"
	LOCAL cDesc1	    := "Impresion solicitud al almacen"
	LOCAL cDesc2	    := "conforme PE"
	LOCAL cDesc3	    := "Especifico Bolivia"
	PRIVATE nomeProg 	:= "BAJSOLA"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont := "Courier New"
	Private oFontDet  := TFont():New(cNomeFont,07,07,,.F.,,,,.T.,.F.)
	Private oFontDetN := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontDN := 	 TFont():New(cNomeFont,07,07,,.T.,,,,.F.,.F.)
	Private oFontDetNN := TFont():New(cNomeFont,012,012,,.T.,,,,.F.,.F.)
	Private oFontRod  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTit  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTitt:= TFont():New(cNomeFont,015,015,,.T.,,,,.F.,.F.)
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 		:= 0
	PRIVATE cPerg   := "BAJSOLA"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)

	Processa({ |lEnd| MOVD3CONF("Impresion solicitud al almacen")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'BAJSOLA'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zTBARQl_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
	//Criando o objeto do FMSPrinter
	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrint, "", , , , .T.)

	//Setando os atributos necessários do relatório
	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(1)
	oPrint:SetMargin(60, 60, 60, 60)

Return Nil

Static Function fImpPres(lEnd,WnRel,cString,nReg)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local nTotal := 0
	Local lRetCF := .f.
	Local aInterna := {}
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 755
	Private nColIni   := 010
	Private nColFin   := 570
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2
	Private cDoc

	If Select("VW_F1PRD") > 0
		dbCloseArea()
	Endif

	cQuery:= " SELECT CP_NUM,CP_ITEM,CP_XDESCLV,CP_PRODUTO,CP_DATPRF,CP_UM,B1_DESC CP_DESCRI,CP_QUANT,CP_OBS,CP_SOLICIT,CP_CONTA,CP_ITEMCTA,CP_CC,CP_CLVL,B1_UCODFAB,CP_XDESCLV,CP_XDESITC "
	cQuery+= " FROM " + RetSQLname('SCP') + " SCP JOIN " + RetSQLname('SB1') + " SB1 ON "
	cQuery+= " B1_COD = CP_PRODUTO "
	cQuery+= " WHERE CP_NUM = '" + SCP->CP_NUM + "' AND CP_FILIAL = '" + xfilial("SCP") + "' ORDER BY CP_ITEM "

	//Aviso("",cQuery,{'ok'},,,,,.t.)
	TCQuery cQuery New Alias "VW_F1PRD"

	fImpCab(.t.,VW_F1PRD->CP_CC,VW_F1PRD->CP_XDESCLV,VW_F1PRD->CP_NUM,VW_F1PRD->CP_SOLICIT,VW_F1PRD->CP_DATPRF)

	//Tributo

	if ! VW_F1PRD->(EoF())

		While ! VW_F1PRD->(EoF())

			If nLinAtu + nTamLin > nLinFin
				fImpRod(.f.)//
				//cDescP := Posicione("SA2",1,xFilial("SA2")+VW_F1PRD->DBB_FORNEC+VW_F1PRD->DBB_LOJA,"A2_NOME")
				fImpCab(.f.)//CABEC
			EndIf

			oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu, nColFin, "-2")//sub detalle
			//items
			oPrint:SayAlign(nLinAtu, COL_COD, VW_F1PRD->CP_ITEM,     oFontDet, 030, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_DESCR, VW_F1PRD->CP_PRODUTO,     oFontDet, 70, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_QFATREQ, VW_F1PRD->B1_UCODFAB,     oFontDet, 70, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_PRECO,VW_F1PRD->CP_UM,     oFontDet, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_DESTO, ALLTRIM(TRANSFORM(VW_F1PRD->CP_QUANT,"@E 999,999,999,999.99")) ,     oFontDet, 0170, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_CLVL,VW_F1PRD->CP_XDESCLV, oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_ITCTA,SUBSTR(VW_F1PRD->CP_XDESITC,1,18), oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			aDescri := TexToArray(ALLTRIM(VW_F1PRD->CP_DESCRI),30)
			//aObs := TexToArray(ALLTRIM(VW_F1PRD->CP_OBS),40)

			for i := 1 to len(aDescri)//por lo menos dos
					oPrint:SayAlign(nLinAtu, COL_QFAT,aDescri[i] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					nLinAtu += nTamLin
				next i
			/*if len(aDescri) > len(aObs)
				for i := 1 to len(aDescri)//por lo menos dos
					if i > len(aObs)
						oPrint:SayAlign(nLinAtu, COL_QFAT, aDescri[i] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					else
						oPrint:SayAlign(nLinAtu, COL_QFAT,aDescri[i] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
						
					endif
					nLinAtu += nTamLin
				next i
			else
				for i := 1 to len(aObs)//por lo menos dos
					if i > len(aDescri)
						oPrint:SayAlign(nLinAtu, COL_CLVL, aObs[i] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					else
						oPrint:SayAlign(nLinAtu, COL_QFAT,aDescri[i] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
						oPrint:SayAlign(nLinAtu, COL_CLVL, aObs[i], oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					endif
					nLinAtu += nTamLin
				next i
			endif
			*/
			//Lineas verticales
			oPrint:Box( nLinAtu, COL_DESCR, nLinAtu, COL_DESCR, "-2")
			oPrint:Box( nLinAtu, COL_QFATREQ, nLinAtu, COL_QFATREQ, "-2")
			oPrint:Box( nLinAtu, COL_QFAT, nLinAtu, COL_QFAT, "-2")
			oPrint:Box( nLinAtu, COL_PRECO, nLinAtu, COL_PRECO, "-2")
			oPrint:Box( nLinAtu, COL_DESTO, nLinAtu, COL_DESTO, "-2")
			oPrint:Box( nLinAtu, COL_CLVL, nLinAtu, COL_CLVL, "-2")
			oPrint:Box( nLinAtu, COL_NETO, nLinAtu, COL_NETO, "-2")
			oPrint:Box( nLinAtu, COL_UNIT, nLinAtu, COL_UNIT, "-2")

			nLinAtu += nTamLin
			VW_F1PRD->(DbSkip())
		enddo
		nLinAtu -= nTamLin
		nLinAtu += (nTamLin * 2)
		
	Endif

	nLinAtu += nTamLin

	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod(.t.)
	EndIf

	//Mostrando o relatório
	oPrint:Preview()
	VW_F1PRD->(DbCloseArea())
	
	RestArea(aArea)

RETURN

Static Function fImpCab(lImp,cCc,cItct,cNum,cSolit,dEmis)
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFLogo := GetSrvProfString("Startpath","") + "logopr.bmp"

	if lImp
		//Iniciando Página
		oPrint:StartPage()

		//alert(cFLogo)
		oPrint:SayBitmap(020,020, cFLogo,070,045)
		//oPrint:SayBitmap( 100, 200, cFLogo, 800, 800)
		cFecha:= DTOC(STOD(dEmis))
		//Cabeçalho
		oPrint:SayAlign(020, 460, "FECHA: " + cFecha, oFontDetN, 400, 30,  , , 0)
		cTexto := "SOLICITUD AL ALMACEN"
		oPrint:SayAlign(nLinCab, nColMeio - 180, cTexto, oFontTitt, 400, 30, , PAD_CENTER, 0)
		oPrint:SayAlign(nLinCab, 460, "SOLICITUD N°: " + cNum, oFontDetN, 400, 30, , , 0)

		nLinCab += (nTamLin * 6)

		oPrint:SayAlign(nLinCab, COL_GRUPO, Alltrim(SM0->M0_NOME)+ " / "+Alltrim(SM0->M0_FILIAL)	+ " / "	+ ALLTRIM(SM0->M0_CODFIL), oFontTit, 240, 20, , PAD_LEFT, 0)

		//Linha Separatória
		nLinCab += (nTamLin * 2)
		oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)

		//Cabeçalho das colunas
		//nLinCab += nTamLin
		//oPrint:SayAlign(nLinCab, COL_GRUPO, "AREA: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		//oPrint:Box( nLinCab, 80, nLinCab+015, 270, "-2")
		//oPrint:SayAlign(nLinCab, COL_GRUPO+0170, cDoc + space(10) + cUcob + space(7) + cOrg,     oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		//recuadro

		nLinCab += (nTamLin * 1.8)
		oPrint:SayAlign(nLinCab, COL_GRUPO, "SOLICITANTE:", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:Box( nLinCab, 80, nLinCab+015, 270, "-2")
		oPrint:SayAlign(nLinCab, COL_GRUPO+70, cSolit, oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += (nTamLin * 1.8)
		oPrint:Box( nLinCab, 80, nLinCab+015, 270, "-2")
		//oPrint:Box( nLinCab, 380, nLinCab+015, 570, "-2")
		oPrint:SayAlign(nLinCab, COL_GRUPO, "PROYECTO C.C.:", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		//oPrint:SayAlign(nLinCab, 290, "APLICACION S.C.C.:", oFontDetN, 0120, nTamLin, CLR_BLACK, PAD_LEFT, 0)		
		//oPrint:SayAlign(nLinCab, 290+93, cItct , oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		IF EMPTY(cCc) 
			cGCC = alltrim(posicione("SGS",1,xFilial("SGS") + cNum, "GS_CC"))
			oPrint:SayAlign(nLinCab, COL_GRUPO+70,alltrim(posicione("CTT",1,xFilial("CTT") + cGCC, "CTT_DESC01"))  , oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		else 
			oPrint:SayAlign(nLinCab, COL_GRUPO+70,alltrim(posicione("CTT",1,xFilial("CTT") + cCc, "CTT_DESC01"))  , oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		end if
		

		//oPrint:Box( nLinCab, 80, nColMeio+015, 500, "-2")
		
	else
		nLinCab += (nTamLin * 6)
	endif

	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	nLinCab += (nTamLin * 0.5)
	oPrint:SayAlign(nLinCab, COL_COD, "N ITEM",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR, "CODIGO",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_QFATREQ, "CODIGO FABRICA",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_QFAT, "DESCRIPCION",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PRECO, "U/M",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESTO, "CANTIDAD",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	//oPrint:SayAlign(nLinCab, COL_CLVL, "OBSERVACION",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CLVL, "Equipo",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_ITCTA, "Actividad",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += (nTamLin * 1.2)
	//oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	//nLinCab += (nTamLin * 1.2)

	nLinCab += nTamLin

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod(lImp)//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin
	Local cTextoEsq := ''
	Local cTextoDir := ''

	//Linha Separatória
	//oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_GRAY)
	if lImp
		oPrint:SayAlign(nLinRod, nColIni, '____________________________', oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)
		oPrint:SayAlign(nLinRod, COL_QFAT, '____________________________', oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)
		oPrint:SayAlign(nLinRod, COL_CLVL, '____________________________', oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)

		nLinRod += 7
		oPrint:SayAlign(nLinRod, nColIni+25,"Solicitado por:"  , oFontRod, 100, 05, CLR_GRAY, , 0)
		oPrint:SayAlign(nLinRod, COL_QFAT+25,"Autorizado por:" , oFontRod, 100, 05, CLR_GRAY, , 0)
		oPrint:SayAlign(nLinRod, COL_CLVL+25,"Doc recibido por:" , oFontRod, 100, 05, CLR_GRAY, , 0)
	else
		nLinRod += 7
	endif
	nLinRod += 20

	//Dados da Esquerda e Direita
	cTextoEsq := dToC(dDataGer) + "    " + cHoraGer + "    " + FunName() + "    " + cNomeUsr
	cTextoDir := "Página " + cValToChar(nPagAtu)

	//Imprimindo os textos
	oPrint:SayAlign(nLinRod, nColIni,    cTextoEsq, oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)
	oPrint:SayAlign(nLinRod, nColFin-50, cTextoDir, oFontRod, 60, 05, CLR_GRAY, PAD_RIGHT, 0)

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

	xPutSx1(cPerg,"01","De documento ?","De documento ?","De documento ?","mv_ch1","C",17,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A documento ?","A documento ?","A documento ?","mv_ch2","C",17,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","Sucursal ?","Sucursal ?","Sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	//xPutSx1(cPerg,"04","A sucursal ?","A sucursal ?","A sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	/*xPutSx1(cPerg,"07","De fecha ?","De fecha ?","De fecha ?",         "mv_ch5","D",08,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A fecha ?","A fecha ?","A fecha ?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")*/
	xPutSX1(cPerg,"04","Moneda ?" , "Moneda ?" ,"Moneda ?" ,"MV_CH4","N",1,0,0,"C","","","","","mv_par04","Bolivianos","Bolivianos","Bolivianos","","Dolares","Dolares","Dolares")

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
