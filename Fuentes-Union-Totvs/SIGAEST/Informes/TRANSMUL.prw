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
#Define COL_DESCR   0050
#Define COL_FABRIC  0200
#Define	COL_UM 		0265
#Define	COL_CANTIDAD	0285
#Define	COL_LOTE		0345
#Define	COL_SERIE		0410
#Define	COL_UBICACION	0475
#Define	COL_COSTO		0545

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  TRANSMUL  ºAutor  ³ERICK ETCHEVERRY º   Date 13/10/2021   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion de transferencia multiple                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION SRL	                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TRANSMUL()
	LOCAL cString		:= "SD3"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Transferencia Multiple"
	PRIVATE nomeProg 	:= "TRANSMUL"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont 	:= "Courier New"
	Private oFontDet  	:= TFont():New(cNomeFont,09,09,,.F.,,,,.T.,.F.)
	Private oFontDetN 	:= TFont():New(cNomeFont,10,10,,.T.,,,,.F.,.F.)
	Private oFontRod 	 := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTitN  	:= TFont():New(cNomeFont,11,11,,.T.,,,,.T.,.F.)//Negrita o Bold
	Private oFontTit  	:= TFont():New(cNomeFont,11,11,,.F.,,,,.T.,.F.)
	Private oFontTit2  	:= TFont():New(cNomeFont,14,14,,.T.,,,,.F.,.F.)
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 		:= 0
	PRIVATE cPerg   := "TRANSMUL"   // elija el Nombre de la pregunta
	//CriaSX1(cPerg)	// Si no esta creada la crea

	/*If funname() == 'MATA241'
	Pergunte(cPerg,.F.)
	Else
	Pergunte(cPerg,.T.)
	Endif*/
	
	Processa({ |lEnd| MOVD3CONF("Impresion de transferencia multiple")},"Imprimiendo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)
	

Return

Static Function MOVD3CONF(Titulo)

	cCaminho  := GetTempPath()
	cArquivo  := "zTstRel_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
	//Criando o objeto do FMSPrinter
	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrint, "", , , , .T.)

	//Setando os atributos necessários do relatório
	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(DMPAPER_LETTER)
	//oPrint:SetMargin(60, 60, 60, 60)

Return Nil

Static Function fImpPres(lEnd,WnRel,cString,nReg)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local nTotal := 0
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 585
	Private nColIni   := 010
	Private nColFin   := 750
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
	//alert("")
	If Select("VW_D3TRANS") > 0
		dbCloseArea()
	Endif

	cQuery := "	SELECT SD3OUT.D3_FILIAL D3_FILIAL,SD3OUT.D3_DOC D3_DOC,SD3OUT.D3_LOCAL LOCALE,NNROUT.NNR_DESCRI LOCALDESC, "
	cQuery += " SD3IN.D3_LOCAL LOCALDES,NNRIN.NNR_DESCRI LOCALDESCDES,SD3OUT.D3_EMISSAO,SD3OUT.D3_USUARIO,SD3OUT.D3_UOBSERV, "
	cQuery += " SD3OUT.D3_COD,B1_DESC,B1_FABRIC,SD3OUT.D3_UM,SD3OUT.D3_QUANT,SD3OUT.D3_LOTECTL LOTE,SD3IN.D3_LOTECTL LOTEDES, "
	cQuery += " SD3OUT.D3_LOCALIZ UBICACION,SD3IN.D3_LOCALIZ UBICACIONDES "	
	cQuery += "  FROM " + RetSqlName("SD3") + " SD3OUT "
	cQuery += "  JOIN " + RetSqlName("SD3") + " SD3IN "
	cQuery += "  ON SD3OUT.D3_FILIAL = SD3IN.D3_FILIAL AND SD3IN.D3_DOC = SD3OUT.D3_DOC AND SD3IN.D3_CF = 'DE4' "
	cQuery += "  AND SD3IN.D3_NUMSEQ = SD3OUT.D3_NUMSEQ  AND SD3IN.D3_TM = '499' AND SD3IN.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SB1") + " SB1 ON B1_FILIAL = '"+ xFilial("SB1")+"' AND B1_COD = SD3OUT.D3_COD AND SB1.D_E_L_E_T_ = ' ' " 
	cQuery += "  LEFT JOIN " + RetSqlName("NNR") + " NNRIN ON NNRIN.NNR_FILIAL = SD3IN.D3_FILIAL AND SD3IN.D3_LOCAL = NNRIN.NNR_CODIGO AND NNRIN.D_E_L_E_T_ = ' ' " 
	cQuery += "  LEFT JOIN " + RetSqlName("NNR") + " NNROUT ON NNROUT.NNR_FILIAL = SD3OUT.D3_FILIAL AND SD3OUT.D3_LOCAL = NNROUT.NNR_CODIGO AND NNROUT.D_E_L_E_T_ = ' ' " 
	cQuery += "  WHERE SD3OUT.D3_FILIAL = '" + xFilial("SD3")+"' "
	cQuery += "  AND SD3OUT.D3_DOC = '" + SD3->D3_DOC + "' "
	cQuery += "  AND SD3OUT.D3_TM = '999' AND SD3OUT.D3_CF = 'RE4' "
	cQuery += "  AND SD3OUT.D_E_L_E_T_ = ' ' "

	TCQuery cQuery New Alias "VW_D3TRANS"

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	Count To nTotal
	ProcRegua(nTotal)
	VW_D3TRANS->(DbGoTop())

	fImpCab()

	While ! VW_D3TRANS->(EoF())		
		
		If nLinAtu + nTamLin > nLinFin
			fImpRod()//
			fImpCab()//CABEC
		EndIf

		oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_D3TRANS->D3_COD , oFontDet, 00200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		cProdu := POSICIONE("SB1",1,XFILIAL("SB1")+VW_D3TRANS->D3_COD,"B1_DESC")
		oPrint:SayAlign(nLinAtu, COL_DESCR, cProdu,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_FABRIC, VW_D3TRANS->B1_FABRIC,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_UM, VW_D3TRANS->D3_UM,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_CANTIDAD, ALLTRIM(TRANSFORM(VW_D3TRANS->D3_QUANT,"@E 999,999,999.99")) ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_LOTE, VW_D3TRANS->LOTE,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_SERIE, VW_D3TRANS->LOTEDES,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_UBICACION, VW_D3TRANS->UBICACION,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_COSTO, VW_D3TRANS->UBICACIONDES,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)		

		nLinAtu += nTamLin

		VW_D3TRANS->(DbSkip())

	EndDo

	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod(.T.,nLinAtu)
	EndIf

	//Mostrando o relatório
	oPrint:Preview()
	VW_D3TRANS->(DbCloseArea())
	RestArea(aArea)

RETURN

Static Function fImpCab()
	Local cFLogo	:= GetSrvProfString("Startpath","") + "logo_union.bmp"
	Local cTexto	:= ""
	Local nLinCab	:= 010
	Local nDerCab	:= 400

	//Iniciando Página
	oPrint:StartPage()

	cVar   := VW_D3TRANS->D3_UOBSERV

	//Cabeçalho
	oPrint:SayBitmap(nLinCab,COL_GRUPO,cFLogo,150,50)

	cTexto := "TRANSFERENCIA MULTIPLE"
	oPrint:SayAlign(nLinCab + (nTamLin * 1.7), nColMeio - 180, cTexto, oFontTit2, 240, 20, CLR_BLACK, PAD_CENTER, 0)
	nLinCab += (nTamLin * 5.1)//Tres saltos de linea de 1.7
	oPrint:SayAlign(nLinCab, COL_GRUPO, ALLTRIM(SM0->M0_CODFIL) + " " + Alltrim(SM0->M0_FILIAL), oFontTitN, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "DOCUMENTO:", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_GRUPO + 55, ALLTRIM(VW_D3TRANS->D3_DOC) , oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	//derecha
	oPrint:SayAlign(nLinCab, nDerCab, "FECHA:", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, nDerCab + 32, DTOC(SToD(VW_D3TRANS->D3_EMISSAO)), oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "DEPOSITO DE ORIGEN:", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_GRUPO + 100, VW_D3TRANS->LOCALE + "-"+ VW_D3TRANS->LOCALDESC, oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	//derecha
	oPrint:SayAlign(nLinCab, nDerCab, "IMPRESO POR:", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab,  nDerCab + 65, cusername , oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "DEPOSITO DE DESTINO:", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_GRUPO + 105, VW_D3TRANS->LOCALDES + "-"+ VW_D3TRANS->LOCALDESCDES , oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	//derecha
	oPrint:SayAlign(nLinCab, nDerCab, "FECHA DE IMPRESION:", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab,  nDerCab + 100, DTOC(ddatabase) , oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "REGISTRADO POR:", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_GRUPO + 80, ALLTRIM(VW_D3TRANS->D3_USUARIO), oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "OBSERVACIONES:", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_GRUPO + 75, cVar, oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	
	//Linha Separatória
	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab + 11, nColIni, nLinCab + 11, nColFin, CLR_GRAY)

	//Cabeçalho das colunas
	nLinCab += nTamLin
	oPrint:SayAlign(nLinCab, COL_GRUPO, "CODIGO",     oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR, "DESCRIPCION", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_FABRIC,"FABRICANTE", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_UM, "UM", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CANTIDAD, "CANTIDAD", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_LOTE, "LOTE", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_SERIE, "LOT.DESTINO", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_UBICACION, "UBICACION", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COSTO, "UBIC.DESTINO", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += nTamLin

	//Linha Separatória
	oPrint:Line(nLinCab + 4, nColIni, nLinCab + 4, nColFin, CLR_GRAY)

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod(lTot,nLinFir)//RODAPE PIE PAGINA

	if lTot
		nLinFir += 60
		oPrint:Line(nLinFir, nColIni, nLinFir, nColIni + 180, CLR_BLACK)
		oPrint:Line(nLinFir, COL_SERIE, nLinFir, COL_SERIE + 180, CLR_BLACK)
		oPrint:SayAlign(nLinFir, COL_DESCR+25, cUsername, oFontDet, 240, 20, , PAD_LEFT, 0)
		oPrint:SayAlign(nLinFir, COL_UBICACION , "Firma Autorizada", oFontDet, 240, 20, , PAD_LEFT, 0)
	endif

	//Finalizando a página e somando mais um
	oPrint:EndPage()
	nPagAtu++
Return
