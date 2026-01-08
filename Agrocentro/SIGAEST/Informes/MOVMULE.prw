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
#Define COL_ITEM   0015
#Define COL_COD   0040
#Define COL_COFAB   00100
#Define COL_DESCR  0136
#Define COL_UMED  0265
#Define	COL_CANTIDAD	0285
#Define	COL_CLVL	0315
#Define COL_PROY 0370
#Define COL_OPERA 0465

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  MOVMULE ºAutor ³ERICK ETCHEVERRY º   º Date 08/12/2019    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion de movimientos multiples	                  	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ECCI NNN		                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MOVMULE()
	LOCAL cString		:= "SCP"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Impresion solicitud al almacen"
	LOCAL cDesc1	    := "Impresion solicitud al almacen"
	LOCAL cDesc2	    := "conforme PE"
	LOCAL cDesc3	    := "Especifico ECCI"
	PRIVATE nomeProg 	:= "MOVMULE"
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

	Processa({ |lEnd| MOVD3CONF("Impresion solicitud al almacen")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'MOVMULE'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zTMov_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
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
	LOCAL i	:= 1
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 750
	Private nColIni   := 010
	Private nColFin   := 580
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2

	/*SELECT D3_NUMSERI,D3_DOC,D3_LOTECTL,D3_NUMLOTE,D3_TM,D3_FILIAL,
	D3_QUANT,D3_LOCAL,D3_EMISSAO,D3_DTVALID,D3_CUSTO2,D3_USUARIO,D3_OBSERVA
	FROM SD3010
	WHERE D3_DOC BETWEEN '' AND ''
	AND D3_FILIAL BETWEEN '' AND ''
	AND D3_EMISSAO BETWEEN '' AND ''
	AND D3_NUMSERI BETWEEN '' AND ''*/

	If Select("VW_D3") > 0
		dbCloseArea()
	Endif

	cQuery := "	SELECT D3_CC,D3_NUMSERI,D3_CUSTO1,D3_CF,D3_DOC,D3_TM+'-'+F5_TEXTO D3_TMDES,D3_NUMSA CUSUR, D3_COD,D3_LOTECTL,D3_LOCALIZ,D3_NUMLOTE,D3_TM,D3_FILIAL,D3_CLVL,D3_NUMSA,D3_ITEMCTA, "
	cQuery += " D3_UASIGNA,D3_UPROY,D3_QUANT,D3_LOCAL,D3_EMISSAO,D3_DTVALID,D3_CUSTO2,D3_UOBSERV D3_OBSERVA,CTH_DESC01,CTT_DESC01,B1_DESC,D3_OP,'ABC' B1_UCODFAB,D3_UM,NNR_DESCRI,D3_UPROV + '-' + A2_NOME D3_UPROV "
	cQuery += "  FROM " + RetSqlName("SD3") + " SD3 "
	cQuery += "  LEFT JOIN " + RetSqlName("CTH") + " CTH ON CTH_CLVL = D3_CLVL AND CTH.D_E_L_E_T_ = ' '"
	cQuery += "  LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT_CUSTO = D3_CC AND CTT.D_E_L_E_T_ = ' '"
	cQuery += "  LEFT JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = D3_COD AND SB1.D_E_L_E_T_ = ' '"
	cQuery += "  LEFT JOIN " + RetSqlName("NNR") + " NNR ON NNR_CODIGO = D3_LOCAL AND NNR_FILIAL = D3_FILIAL AND NNR.D_E_L_E_T_ = ' '"
	cQuery += "  LEFT JOIN " + RetSqlName("SF5") + " SF5 ON F5_CODIGO = D3_TM AND SF5.D_E_L_E_T_ = ' '"
	cQuery += "  LEFT JOIN " + RetSqlName("SA2") + " SA2 ON A2_COD = D3_UPROV AND SA2.D_E_L_E_T_ = ' '"
	cQuery += "  WHERE D3_EMISSAO BETWEEN '" + DtoS(SD3->D3_EMISSAO) + "' AND '" + DtoS(SD3->D3_EMISSAO) + "' "
	cQuery += "  AND SD3.D_E_L_E_T_ = ' ' "
	cQuery += "  AND D3_FILIAL BETWEEN '" + xfilial("SD3") + "' AND '" + xfilial("SD3") + "' "
	cQuery += "  AND D3_DOC BETWEEN '" + SD3->D3_DOC + "' AND '" + SD3->D3_DOC + "' "
	cQuery += "  ORDER BY D3_DOC "

	TCQuery cQuery New Alias "VW_D3"

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	Count To nTotal
	ProcRegua(nTotal)
	VW_D3->(DbGoTop())

	cCust := quitZero(alltrim(VW_D3->D3_CC)) 

	fImpCab(.t.,cCust + "-" +VW_D3->CTT_DESC01,VW_D3->CTH_DESC01,VW_D3->D3_DOC,VW_D3->D3_TMDES,VW_D3->D3_EMISSAO, iif(!empty(VW_D3->D3_OP),VW_D3->D3_OP,VW_D3->D3_NUMSA), Alltrim(VW_D3->D3_LOCAL) + "-" + alltrim(VW_D3->NNR_DESCRI),VW_D3->D3_OBSERVA,VW_D3->CUSUR,VW_D3->D3_UPROV,VW_D3->D3_TM)

	nItem:= 0

	While ! VW_D3->(EoF())
		nItem++

		If nLinAtu + nTamLin > nLinFin
			fImpRod(.f.)//
			fImpCab(.f.)//CABEC
		EndIf
		
		

		//LINEAS VERTICALES
		oPrint:Box( nLinAtu, COL_ITEM - 5, nLinAtu + 10,  COL_ITEM - 5, "-2")
		oPrint:Box( nLinAtu, COL_COD-3, nLinAtu + 10, COL_COD-3, "-2")
		oPrint:Box( nLinAtu, COL_COFAB-3, nLinAtu + 10, COL_COFAB-3, "-2")
		oPrint:Box( nLinAtu, COL_DESCR-3, nLinAtu + 10, COL_DESCR-3, "-2")
		oPrint:Box( nLinAtu, COL_UMED-3, nLinAtu + 10, COL_UMED-3, "-2")
		oPrint:Box( nLinAtu, COL_CANTIDAD-3, nLinAtu + 10, COL_CANTIDAD-3, "-2")
		oPrint:Box( nLinAtu, COL_CLVL-3, nLinAtu + 10, COL_CLVL-3, "-2")
		oPrint:Box( nLinAtu, COL_PROY-3, nLinAtu + 10, COL_PROY-3, "-2")
		oPrint:Box( nLinAtu, COL_OPERA-3, nLinAtu + 10, COL_OPERA-3, "-2")
		oPrint:Box( nLinAtu, nColFin , nLinAtu + 10, nColFin , "-2")

		//Imprimindo a linha atual ITEMS
		oPrint:SayAlign(nLinAtu, COL_ITEM, cValtochar(nItem) , oFontDet, 00200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_COD, VW_D3->D3_COD,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_COFAB, VW_D3->B1_UCODFAB,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)		
		oPrint:SayAlign(nLinAtu, COL_UMED, VW_D3->D3_UM,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_CANTIDAD, ALLTRIM(TRANSFORM(VW_D3->D3_QUANT,"@E 999,999,999")) ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_CLVL, SUBSTR(Posicione("CTH",1,xFilial("CTH")+VW_D3->D3_CLVL,"CTH_DESC01"),1,15)  ,  oFontDet, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_PROY, SUBSTR(Posicione("CTD",1,xFilial("CTD")+VW_D3->D3_ITEMCTA ,"CTD_DESC01"),1,20)  ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_OPERA, SUBSTR(Posicione("SRA",1,xFilial("SRA")+VW_D3->D3_UASIGNA,"RA_NOME"),1,20) ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		
		aDescri := TexToArray(ALLTRIM(VW_D3->B1_DESC),32)

		for i := 1 to len(aDescri)//por lo menos dos
			
			oPrint:Box( nLinAtu, COL_ITEM - 5, nLinAtu + 10,  COL_ITEM - 5, "-2")
			oPrint:Box( nLinAtu, COL_COD -3, nLinAtu + 10, COL_COD-3, "-2")
			oPrint:Box( nLinAtu, COL_COFAB-3, nLinAtu + 10, COL_COFAB-3, "-2")
			oPrint:Box( nLinAtu, COL_DESCR-3, nLinAtu + 10, COL_DESCR-3, "-2")
			oPrint:Box( nLinAtu, COL_UMED-3, nLinAtu + 10, COL_UMED-3, "-2")
			oPrint:Box( nLinAtu, COL_CANTIDAD-3, nLinAtu + 10, COL_CANTIDAD-3, "-2")
			oPrint:Box( nLinAtu, COL_CLVL-3, nLinAtu + 10, COL_CLVL-3, "-2")
			oPrint:Box( nLinAtu, COL_PROY-3, nLinAtu + 10, COL_PROY-3, "-2")
			oPrint:Box( nLinAtu, COL_OPERA-3, nLinAtu + 10, COL_OPERA-3, "-2")
			oPrint:Box( nLinAtu, nColFin , nLinAtu + 10, nColFin , "-2")

			oPrint:SayAlign(nLinAtu, COL_DESCR, aDescri[i] ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			if len(aDescri) > 1

				oPrint:Box( nLinAtu, COL_ITEM - 5, nLinAtu + 10,  COL_ITEM - 5, "-2")
				oPrint:Box( nLinAtu, COL_COD-3, nLinAtu + 10, COL_COD-3, "-2")
				oPrint:Box( nLinAtu, COL_COFAB-3, nLinAtu + 10, COL_COFAB-3, "-2")
				oPrint:Box( nLinAtu, COL_DESCR-3, nLinAtu + 10, COL_DESCR-3, "-2")
				oPrint:Box( nLinAtu, COL_UMED-3, nLinAtu + 10, COL_UMED-3, "-2")
				oPrint:Box( nLinAtu, COL_CANTIDAD-3, nLinAtu + 10, COL_CANTIDAD-3, "-2")
				oPrint:Box( nLinAtu, COL_CLVL-3, nLinAtu + 10, COL_CLVL-3, "-2")
				oPrint:Box( nLinAtu, COL_PROY-3, nLinAtu + 10, COL_PROY-3, "-2")
				oPrint:Box( nLinAtu, COL_OPERA-3, nLinAtu + 10, COL_OPERA-3, "-2")
				oPrint:Box( nLinAtu, nColFin , nLinAtu + 10, nColFin , "-2")
				nLinAtu += nTamLin
				
			endif
		next i

		oPrint:Line(nLinAtu, nColIni, nLinAtu,nColFin)

		nLinAtu += nTamLin		

		VW_D3->(DbSkip())

	EndDo

	oPrint:Line(nLinAtu, nColIni, nLinAtu,nColFin)

	nLinAtu += nTamLin

	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod(.t.)
	EndIf

	VW_D3->(dbCloseArea())
	//Mostrando o relatório
	oPrint:Preview()

	RestArea(aArea)

RETURN

Static Function fImpCab(lImp,cCc,cItct,cNum,cSolit,dEmis,cOp,cLocal,cObserv,cSolUsu,cProvx,cxTM)
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFLogo := GetSrvProfString("Startpath","") + "logopr.bmp"

	oPrint:StartPage()

	if lImp

		oPrint:SayBitmap(020,020, cFLogo,070,045)

		oPrint:Box( 0 , 110 ,  81 , 110 )	

		oPrint:Box( 0 , 450 ,  81 , 450 )

		nLinCab += (nTamLin * 1.2)
		cFecha:= DTOC(STOD(dEmis))
		//Cabeçalho
		oPrint:SayAlign(020, 460, "FECHA: " + cFecha, oFontDetN, 400, 30,  , , 0)
		
		oPrint:SayAlign(nLinCab, nColMeio - 180, iif(val(cxTM) >= 500 ,"REGISTRO DE SALIDA","REGISTRO DE INGRESO") , oFontTitt, 400, 30, , PAD_CENTER, 0)
		oPrint:SayAlign(nLinCab, 460, "NOTA N°.: " + cNum, oFontDetN, 400, 30, , , 0)
		nLinCab += (nTamLin * 1.4)
		//alert(SD3->D3_ESTORNO)
		If !empty(SD3->D3_ESTORNO) 
			oPrint:SayAlign(nLinCab, nColMeio - 180, "R E V E R T I D O", oFontDetNN, 400, 30, , PAD_CENTER, 0)
		else
			oPrint:SayAlign(nLinCab, nColMeio - 180, "Movimiento Multiple", oFontDetNN, 400, 30, , PAD_CENTER, 0)
		ENDIF
		nLinCab += (nTamLin * 0.8)
		oPrint:SayAlign(nLinCab, 460, "DOC.ORIG: " + cOp, oFontDetN, 400, 30, , , 0)

		//oPrint:Box( nLinCab, 80, nLinCab+015, 270, "-2")

		nLinCab += (nTamLin * 1.7)
		oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)
		
		//Cabeçalho das colunas
		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_ITEM, "          ALMACEN: ",     oFontDetN, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:Box( nLinCab, 100, nLinCab+015, 300, "-2") ///que linea //empiezo  /// grosor  ///termino
		oPrint:SayAlign(nLinCab, COL_ITEM+95, cLocal, oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)		
		
		oPrint:SayAlign(nLinCab, COL_PROY+ 10, "         TM:", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:Box( nLinCab, 450, nLinCab+015, 580, "-2")
		oPrint:SayAlign(nLinCab, COL_PROY+88, alltrim(cSolit), oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += (nTamLin * 1.8)
				 	 	 	 	 	 	    
		oPrint:SayAlign(nLinCab, COL_ITEM, "    PROYECTO C.C.:", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:Box( nLinCab, 100, nLinCab+015, 300, "-2")
		oPrint:SayAlign(nLinCab, COL_ITEM+95, cCc , oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinCab, COL_PROY+ 10, "  PROVEEDOR:", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:Box( nLinCab, 450, nLinCab+015, 580, "-2")
		oPrint:SayAlign(nLinCab, COL_PROY+88, SUBSTR(cProvx,1,50), oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += (nTamLin * 1.8)

		oPrint:SayAlign(nLinCab, COL_ITEM, "      SOLICITANTE:", oFontDetN, 0120, nTamLin, CLR_BLACK, PAD_LEFT, 0)		
		oPrint:Box( nLinCab, 100, nLinCab+015, 300, "-2")
		oPrint:SayAlign(nLinCab, COL_ITEM+95, POSICIONE("SCP",1,XFILIAL("SCP")+cSolUsu,"CP_SOLICIT"), oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += (nTamLin * 1.8)
		oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)
		oPrint:SayAlign(nLinCab, COL_ITEM, "OBSERVACION", oFontDetN, 0120, nTamLin, CLR_BLACK, PAD_LEFT, 0)		
		oPrint:SayAlign(nLinCab, COL_ITEM+70, cObserv , oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += (nTamLin * 2.5)
		oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)
	else
		nLinCab += (nTamLin * 5)
	endif

	oBrush := TBrush():New(,Rgb(254,242,203))
	oBrush2 := TBrush():New(,Rgb(254,242,203))
	
	//LINEA VERTICAL oPrn:Box( nLinInicial + 680 , 1500 ,  1030 , 1500 )

	nLinCab += (nTamLin * 1.3)

	oPrint:FillRect({nLinCab+0.45, COL_ITEM -5 , nLinCab + 24, COL_CLVL-3}, oBrush)

	oPrint:FillRect({nLinCab+0.45, COL_CLVL-3 , nLinCab + 24, COL_OPERA-3}, oBrush2)

	oPrint:FillRect({nLinCab+0.45, COL_OPERA-3 , nLinCab + 24, nColFin}, oBrush)

	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1") ///linea
	//verticales cabecera items
	oPrint:Box( nLinCab, COL_ITEM - 5, nLinCab + 12.5,  COL_ITEM - 5, "-2")
	oPrint:Box( nLinCab, COL_COD -3, nLinCab + 12.5, COL_COD-3, "-2")
	oPrint:Box( nLinCab, COL_COFAB-3, nLinCab + 12.5, COL_COFAB-3, "-2")
	oPrint:Box( nLinCab, COL_DESCR-3, nLinCab + 12.5, COL_DESCR-3, "-2")
	oPrint:Box( nLinCab, COL_UMED-3, nLinCab + 12.5, COL_UMED-3, "-2")
	oPrint:Box( nLinCab, COL_CANTIDAD-3, nLinCab + 12.5, COL_CANTIDAD-3, "-2")
	oPrint:Box( nLinCab, COL_CLVL-3, nLinCab + 12.5, COL_CLVL-3, "-2")
	oPrint:Box( nLinCab, COL_PROY-3, nLinCab + 12.5, COL_PROY-3, "-2")
	oPrint:Box( nLinCab, COL_OPERA-3, nLinCab + 12.5, COL_OPERA-3, "-2")

	oPrint:Box( nLinCab, nColFin , nLinCab + 12.5, nColFin , "-2")

	oPrint:SayAlign(nLinCab, COL_ITEM, "  N°",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COD, "CODIGO",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COFAB, "CODIGO",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR, "DESCRIPCION",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_UMED, "U/M",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CANTIDAD, "CANT.",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CLVL, "CLVL",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PROY, "ACTIVIDAD",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_OPERA, "ASIGNACION",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += (nTamLin * 1.2) ///separacion

	//verticales cabecera items
	oPrint:Box( nLinCab, COL_ITEM - 5, nLinCab + 12.5,  COL_ITEM - 5, "-2")
	oPrint:Box( nLinCab, COL_COD -3, nLinCab + 12.5, COL_COD-3, "-2")
	oPrint:Box( nLinCab, COL_COFAB-3, nLinCab + 12.5, COL_COFAB-3, "-2")
	oPrint:Box( nLinCab, COL_DESCR-3, nLinCab + 12.5, COL_DESCR-3, "-2")
	oPrint:Box( nLinCab, COL_UMED-3, nLinCab + 12.5, COL_UMED-3, "-2")
	oPrint:Box( nLinCab, COL_CANTIDAD-3, nLinCab + 12.5, COL_CANTIDAD-3, "-2")
	oPrint:Box( nLinCab, COL_CLVL-3, nLinCab + 12.5, COL_CLVL-3, "-2")
	oPrint:Box( nLinCab, COL_PROY-3, nLinCab + 12.5, COL_PROY-3, "-2")
	oPrint:Box( nLinCab, COL_OPERA-3, nLinCab + 12.5, COL_OPERA-3, "-2")
	oPrint:Box( nLinCab, nColFin , nLinCab + 12.5, nColFin , "-2")

	oPrint:SayAlign(nLinCab, COL_ITEM, "ITEM",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COFAB, "FABRICA",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += (nTamLin * 1.2)

	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)

	nLinAtu := nLinCab
Return

Static Function fImpRod(lImp)//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin
	Local cTextoEsq := ''
	Local cTextoDir := ''

	//Linha Separatória

	if lImp
		oPrint:SayAlign(nLinRod, nColIni, '____________________________', oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)
		oPrint:SayAlign(nLinRod, COL_PROY, '____________________________', oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)

		nLinRod += 7
		oPrint:SayAlign(nLinRod, nColIni+30,"Entregado por:"  , oFontRod, 100, 05, CLR_GRAY, , 0)
		oPrint:SayAlign(nLinRod, COL_PROY+30,"Recibido por:" , oFontRod, 100, 05, CLR_GRAY, , 0)

		nLinRod += 7
		oPrint:SayAlign(nLinRod, nColIni+10,"Nombre Completo y firma"  , oFontRod, 100, 05, CLR_GRAY, , 0)
		oPrint:SayAlign(nLinRod, COL_PROY+10,"Nombre Completo y firma" , oFontRod, 100, 05, CLR_GRAY, , 0)

	else
		nLinRod += 7
	endif
	
	nLinRod += 20

	/*//Dados da Esquerda e Direita
	cTextoEsq := dToC(dDataGer) + "    " + cHoraGer + "    " + FunName() + "    " + cNomeUsr
	cTextoDir := "Página " + cValToChar(nPagAtu)

	//Imprimindo os textos
	oPrint:SayAlign(nLinRod, nColIni,    cTextoEsq, oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)
	oPrint:SayAlign(nLinRod, nColFin-50, cTextoDir, oFontRod, 60, 05, CLR_GRAY, PAD_RIGHT, 0)*/

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

static Function quitZero(cTexto)
	private aArea     := GetArea()
	private cRetorno  := ""
	private lContinua := .T.

	cRetorno := Alltrim(cTexto)

	While lContinua

		If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
			lContinua := .f.
		EndIf

		If lContinua
			cRetorno := Substr(cRetorno, 2, Len(cRetorno))
		EndIf
	EndDo

	RestArea(aArea)

Return cRetorno
