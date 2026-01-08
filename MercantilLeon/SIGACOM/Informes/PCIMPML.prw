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
#Define COL_FABCAN   090
#Define COL_DESCESPE  0250
#Define COL_UMED  0395
#Define	COL_QANTIDA	0415
#Define	COL_PRECUNIT	0460
#Define COL_PRECTOTAL 0530
#Define COL_FENTREGA 0610
#Define COL_PROCES 0680

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  PCIMPML ºAutor ³ERICK ETCHEVERRY º   º Date 08/12/2019   º±±
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

User Function PCIMPML()
	LOCAL cString		:= "SC7"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Impresion del Pedido de Compra"
	LOCAL cDesc1	    := "Impresion del Pedido de Compra"
	LOCAL cDesc2	    := "conforme PE"
	LOCAL cDesc3	    := "Especifico ML"

	if SC7->C7_IMPORT== "001"
		U_POIMPML()
		return
	endif

	PRIVATE nomeProg 	:= "PCIMPML"
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
	PRIVATE cPerg   := "PCIMPML"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)	

	Processa({ |lEnd| MOVD3CONF("Impresion del Pedido de Compra")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)///configuracion impresora
	Local cFilename := 'PCIMPML'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "PCIMPML" + dToS(date()) + "_" + StrTran(time(), ':', '-')
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
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 540//570
	Private nColIni   := 010
	Private nColFin   := 730
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2
	Private cDoc

	If Select("VW_PCC7") > 0
		dbCloseArea()
	Endif

	/*
	SELECT C7_FORNECE,A2_NOME,C7_MOEDA,C7_EMISSAO,C7_CONTATO,C7_COND,E4_DESCRI,C7_UOFERTA,C7_NUMSC,C7_UCONENT,
	C7_ITEM,C7_PRODUTO,B1_UCODFAB,C7_UESPECI,C7_UESPEC2,C7_UM,C7_QUANT,C7_PRECO,C7_UPLZENT,C7_UOBSPC
	FROM SC7010 SC7
	LEFT JOIN SA2010 SA2
	ON A2_COD = C7_FORNECE AND SA2.D_E_L_E_T_ = ''
	LEFT JOIN SE4010 SE4
	ON E4_CODIGO = C7_COND AND SE4.D_E_L_E_T_ = ''
	LEFT JOIN SB1010
	ON B1_COD = C7_PRODUTO
	*/

	cQuery:= " SELECT C7_NUM,C7_FORNECE,A2_NOME,C7_MOEDA,C7_EMISSAO,C7_CONTATO,C7_COND,E4_DESCRI,C7_UOFERTA,C7_NUMSC,C7_FILENT,C7_UCONENT,C7_ITEMSC,C7_LOJA, C7_NATUREZ, "///cabecera
	cQuery+= " C7_ITEM,C7_PRODUTO,B1_UCODFAB,C7_UESPECI,C7_UESPEC2,C7_UM,C7_QUANT,C7_PRECO,C7_TOTAL,C7_DATPRF C7_UPLZENT,C7_COMPRA,Y1_NOME "///items
	cQuery+= " FROM " + RetSQLname('SC7') + " SC7 LEFT JOIN " + RetSQLname('SA2') + " SA2 ON A2_COD = C7_FORNECE AND SA2.D_E_L_E_T_ = '' "
	cQuery+= " LEFT JOIN " + RetSQLname('SE4') + " SE4 ON E4_CODIGO = C7_COND AND SE4.D_E_L_E_T_ = '' "
	cQuery+= " LEFT JOIN " + RetSQLname('SB1') + " SB1 ON B1_COD = C7_PRODUTO AND SB1.D_E_L_E_T_ = '' "
	cQuery+= " LEFT JOIN " + RetSQLname('SY1') + " SY1 ON Y1_COD = C7_COMPRA AND SY1.D_E_L_E_T_ = '' "
	cQuery+= " WHERE C7_NUM BETWEEN '" + SC7->C7_NUM + "' AND '" + SC7->C7_NUM + "' AND C7_FILIAL = '" + xfilial("SC7") + "' "
	cQuery+= " AND SC7.D_E_L_E_T_ = '' ORDER BY C7_ITEM"

	TCQuery cQuery New Alias "VW_PCC7"

	fImpCab(.t.,VW_PCC7->C7_NUM,VW_PCC7->C7_FORNECE,VW_PCC7->A2_NOME,VW_PCC7->C7_MOEDA,VW_PCC7->C7_EMISSAO,VW_PCC7->C7_NATUREZ,VW_PCC7->C7_COND,VW_PCC7->E4_DESCRI,VW_PCC7->C7_UOFERTA,VW_PCC7->C7_NUMSC,VW_PCC7->C7_UCONENT,VW_PCC7->C7_COMPRA,VW_PCC7->Y1_NOME,VW_PCC7->C7_FILENT)

	if ! VW_PCC7->(EoF())

		nTot := 0
		While ! VW_PCC7->(EoF())

			If nLinAtu + nTamLin > nLinFin
				fImpRod(.f.)//rodape
				fImpCab(.f.)//CABEC
			EndIf

			//items
			oPrint:SayAlign(nLinAtu, COL_ITEMM, VW_PCC7->C7_ITEM,     oFontDet, 030, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COD, VW_PCC7->C7_PRODUTO,     oFontDet, 270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			
			oPrint:SayAlign(nLinAtu, COL_UMED, VW_PCC7->C7_UM ,     oFontDet, 0170, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_QANTIDA,ALLTRIM(TRANSFORM(VW_PCC7->C7_QUANT,"@E 999,999,999,999.99")) ,     oFontDet, 100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_PRECUNIT,ALLTRIM(TRANSFORM(VW_PCC7->C7_PRECO,"@E 999,999,999,999.99999")) ,     oFontDet, 100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_PRECTOTAL,ALLTRIM(TRANSFORM(VW_PCC7->C7_TOTAL,"@E 999,999,999,999.99")) ,     oFontDet, 100, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_FENTREGA, POSICIONE("SC1",2,XFILIAL("SC1")+VW_PCC7->C7_PRODUTO+VW_PCC7->C7_NUMSC+VW_PCC7->C7_ITEMSC+VW_PCC7->C7_FORNECE+VW_PCC7->C7_LOJA,"C1_PEDRES"),     oFontDet, 100, nTamLin, CLR_BLACK, PAD_LEFT, 0)///pedido
			oPrint:SayAlign(nLinAtu, COL_PROCES, POSICIONE("SC1",2,XFILIAL("SC1")+VW_PCC7->C7_PRODUTO+VW_PCC7->C7_NUMSC+VW_PCC7->C7_ITEMSC+VW_PCC7->C7_FORNECE+VW_PCC7->C7_LOJA,"C1_NUMPR"),     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)////proceso

			aDescri := TexToArray(ALLTRIM(VW_PCC7->C7_UESPECI),40)
			aDescri2 := TexToArray(ALLTRIM(VW_PCC7->C7_UESPEC2),40)

			if len(aDescri) > 0
				oPrint:SayAlign(nLinAtu,COL_FABCAN,aDescri[1] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			endif

			if len(aDescri2) > 0
				oPrint:SayAlign(nLinAtu, COL_DESCESPE,aDescri2[1],     oFontDet, 200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			endif

			nLinAtu += nTamLin

			if	len(aDescri) > 1 
				oPrint:SayAlign(nLinAtu, COL_FABCAN,aDescri[2] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			endif

			if	len(aDescri2) > 1 
				oPrint:SayAlign(nLinAtu, COL_DESCESPE,aDescri2[2] ,     oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			endif

			nTot += VW_PCC7->C7_TOTAL

			nLinAtu += nTamLin
			VW_PCC7->(DbSkip())
		enddo

		nLinAtu += (nTamLin * 2)
		VW_PCC7->(DbCloseArea())
	Endif

	oPrint:Box( nLinAtu, COL_ITEMM, nLinAtu, nColFin, "-2")//sub detalle

	oPrint:SayAlign(nLinAtu, COL_QANTIDA,"Total:",     oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinAtu, COL_PRECTOTAL, ALLTRIM(TRANSFORM(nTot,"@E 999,999,999,999.99")) ,     oFontDet, 0170, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinAtu += (nTamLin * 2)

	oPrint:SayAlign(nLinAtu, COL_ITEMM, "OBSERVACION: " ,     oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinhas := MLCount(alltrim(Posicione("SC7",1,xFilial("SC7")+SC7->C7_NUM,"C7_UOBSPC")),70)
	nDesde := 70
	For nXi:= 1 To nLinhas
			cTxtLinha := MemoLine(alltrim(Posicione("SC7",1,xFilial("SC7")+SC7->C7_NUM,"C7_UOBSPC")),70,nXi)
			If !Empty(cTxtLinha)
				oPrint:SayAlign(nLinAtu , COL_ITEMM + 70, cTxtLinha ,     oFontDetN, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			EndIf
			nLinAtu+=(nTamLin*1.5)
	Next nXi
	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	//If nLinAtu <= nLinFin
	fImpRod(.t.)
	//EndIf

	//Mostrando o relatório
	oPrint:Preview()

	RestArea(aArea)

RETURN

Static Function fImpCab(lImp,cNum,cFornec,cFornome,nMoeda,dEmiss,cContac,cCond,cConddes,cOfert,cNumscc,cUconent,cYcod,cYnome,cFilen)
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFLogo := GetSrvProfString("Startpath","") + "logoML.bmp"
	Local aInfSM0 := FWLoadSM0()

	oPrint:StartPage()
	if lImp
		//Iniciando Página

		oPrint:SayBitmap(035,017, cFLogo,190,045)

		cFecha:= DTOC(STOD(dEmiss))
		//Cabeçalho

		cTexto := "PEDIDO DE COMPRA"
		oPrint:SayAlign(nLinCab, nColMeio - 180, cTexto, oFontTitt, 400, 30, , PAD_CENTER, 0)
		nLinCab += (nTamLin * 3)
		oPrint:SayAlign(nLinCab, nColMeio - 175, cNum , oFontTitt, 400, 30, , PAD_CENTER, 0)

		nLinCab += (nTamLin * 2)

		//Linha Separatória
		nLinCab += (nTamLin * 2)
		oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)

		//Cabeçalho das colunas
		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_ITEMM, "PROVEEDOR: ",     oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEMM+50, cFornec + " - " + cFornome, oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				
		oPrint:SayAlign(nLinCab, COL_QANTIDA, "MONEDA: ",     oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_QANTIDA+50, iif(nMoeda == 1,'BOLIVIANOS',"DOLARES"), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinCab, COL_FENTREGA, "FECHA: ",     oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_FENTREGA+30, cFecha, oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += (nTamLin * 1.8)
		oPrint:SayAlign(nLinCab, COL_ITEMM, "NATURALEZA:", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEMM+50, cContac, oFontDet8, 0400, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinCab, COL_QANTIDA, "CONDICION DE PAGO: ",     oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_QANTIDA+90, cCond + " - " + cConddes, oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)		

		nLinCab += (nTamLin * 1.8)
		
		oPrint:SayAlign(nLinCab, COL_ITEMM, "OFERTA PROVEEDOR: ",     oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEMM+90, cOfert, oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinCab, COL_QANTIDA, "SOLICITUD: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_QANTIDA+50, cNumscc, oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += (nTamLin * 1.8)

		cUnireq := POSICIONE("SC1",1,XFILIAL("SC1")+cNumscc,"C1_UNIDREQ")

		oPrint:SayAlign(nLinCab, COL_ITEMM, "SOLICITANTE: ",     oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEMM+70, POSICIONE("SY3",1,XFILIAL("SY3")+cUnireq,"Y3_DESC") , oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	else
		nLinCab += (nTamLin * 5)
	endif

	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	nLinCab += (nTamLin * 0.5)
	oPrint:SayAlign(nLinCab, COL_ITEMM, "ITEM",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COD, "CODIGO",     oFontDetN, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_FABCAN, "DESCRIPCION",     oFontDetN, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCESPE, "DESCRIPCION 2",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_UMED, "UN",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_QANTIDA, "CANTIDAD",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PRECUNIT, "PRECIO UNIT.",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PRECTOTAL, "PRECIO TOTAL",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_FENTREGA, "PEDIDO VENTA",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PROCES, "PROCESO",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	

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

	cTextoDir := "Página " + cValToChar(nPagAtu)
	oPrint:Line(nLinRod, nColIni, nLinRod,nColFin,CLR_BLACK,"-1")
	nLinRod += 10
	//Imprimindo os textos
	oPrint:SayAlign(nLinRod, nColMeio - 40,    "Mercantil León S.R.L - Av. Viedma N° 51", oFontRod, 400, 05, CLR_BLACK, PAD_LEFT,  0)
	nLinRod += (nTamLin * 1.4)
	oPrint:SayAlign(nLinRod, nColMeio - 70,    "Santa Cruz de la Sierra - Bolivia - TEL. (591) 3 3364244", oFontRod, 400, 05, CLR_BLACK, PAD_LEFT,  0)
	nLinRod += (nTamLin * 1.4)
	oPrint:SayAlign(nLinRod, nColMeio - 10,    "www.mercantilleon.com", oFontRod, 400, 05, CLR_BLACK, PAD_LEFT,  0)
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
