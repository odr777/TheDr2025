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
#Define COL_DESCR   0051
#Define COL_QFATREQ  0160
#Define COL_QFAT  0225
//#Define	COL_QRECFA 	0230
#Define	COL_PRECO	0290
#Define	COL_DESTO	0380
#Define COL_BRUTO 0440
#Define COL_IVA 0440
#Define COL_NETO 0520
#Define COL_UNIT 0620

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  PIMPDEPR ºAutor ³ERICK ETCHEVERRY º   º Date 08/12/2019   º±±
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

User Function PIMPDEPR()
	LOCAL cString		:= "DBC"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Impresion detalle producto"
	LOCAL cDesc1	    := "Impresion de importacion FOB despacho"
	LOCAL cDesc2	    := "conforme parametro"
	LOCAL cDesc3	    := "Especifico UNION"
	PRIVATE nomeProg 	:= "PIMPDEPR"
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
	PRIVATE cPerg   := "IMPPERG"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.t.)

	/*If funname() == 'MATA241'
	Pergunte(cPerg,.F.)
	Else
	Pergunte(cPerg,.T.)
	Endif*/

	Processa({ |lEnd| MOVD3CONF("Impresion detalle producto")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'movinterno'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zTstRQl_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
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
	Private nLinFin   := 600
	Private nColIni   := 010
	Private nColFin   := 730
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2
	Private cDoc

	If Select("VW_F1PRD") > 0
		dbCloseArea()
	Endif

	/*
	SELECT DBB_DOC,DBB_MOEDA,DBB_SIMBOL,DBB_FORNEC,DBB_TXMOED,DBC_CODPRO,DBC_DESCRI,DBC_QUANT,DBC_PRECO,DBC_TOTAL,
	DBC_VLDESC,'CANT REC,BAJA CC','VAL REC,MOV INT SOBRANT','va alm,100%invoice',B2_CM2,B2_CM1
	FROM DBB010  DBB
	JOIN DBC010 DBC
	ON DBC_HAWB = DBB_HAWB AND DBC_FILIAL = DBB_FILIAL AND DBC.D_E_L_E_T_ = ' ' AND DBB_ITEM = DBC_ITDOC AND LEN(LTRIM(RTRIM(DBC_ITEMPC)))> 0
	LEFT JOIN SB2010 SB2
	ON B2_LOCAL = DBC_LOCAL AND DBC_CODPRO = B2_COD AND SB2.D_E_L_E_T_ = '' AND B2_FILIAL = DBC_FILIAL
	WHERE DBB_TIPONF = '5'
	AND DBB_HAWB BETWEEN 'OC/077/19/A      ' AND 'OC/077/19/A      '
	AND DBB_FILIAL = '0105'
	AND DBB.D_E_L_E_T_ = ' '
	ORDER BY DBC_ITEMPC
	*/

	cQuery:= " SELECT DBB_DOC,C1_QUANT,DBB_MOEDA,DBB_HAWB,DBB_LOJA,A2_NOME,DBB_SIMBOL,DBB_FORNEC,DBB_TXMOED,DBC_CODPRO,DBC_DESCRI,DBC_QUANT,DBC_PRECO,DBC_TOTAL, "
	cQuery+= " DBC_VLDESC,'CANT REC,BAJA CC','VAL REC,MOV INT SOBRANT','va alm,100%invoice',B2_CM2,B2_CM1,A2_UCODFAB,DBA_ORIGEM "
	cQuery+= " FROM " + RetSQLname('DBB') + " DBB JOIN " + RetSQLname('DBC') + " DBC "
	cQuery+= " ON DBC_HAWB = DBB_HAWB AND DBC_FILIAL = DBB_FILIAL AND DBC.D_E_L_E_T_ = ' ' AND DBB_ITEM = DBC_ITDOC AND LEN(LTRIM(RTRIM(DBC_ITEMPC)))> 0 "
	cQuery+= " LEFT JOIN " + RetSQLname('SB2') + " SB2 "
	cQuery+= " ON B2_LOCAL = DBC_LOCAL AND DBC_CODPRO = B2_COD AND SB2.D_E_L_E_T_ = '' AND B2_FILIAL = DBC_FILIAL "
	cQuery += " LEFT JOIN " + RetSqlName("SC7") + " SC7 "
	cQuery += "	ON DBC_PEDIDO = C7_NUM AND DBC_ITEMPC = C7_ITEM AND C7_FILIAL = DBC_FILIAL AND DBC_CODPRO = C7_PRODUTO AND SC7.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SC1") + " SC1 "
	cQuery += "	ON C7_NUMSC = C1_NUM AND C1_ITEM = C7_ITEMSC AND C7_FILIAL = C1_FILIAL AND C1_PRODUTO = C7_PRODUTO AND C7_FORNECE = C1_FORNECE AND SC7.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += " JOIN " + RetSqlName("DBA") + " DBA "
	cQuery += "	ON DBB_FILIAL = DBA_FILIAL AND DBA_HAWB = DBB_HAWB AND DBA.D_E_L_E_T_ = '' "
	cQuery+= " WHERE DBB_TIPONF = '5' AND DBB_HAWB BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'"
	cQuery+= " AND DBB_FILIAL = '" + MV_PAR03 + "' AND DBB.D_E_L_E_T_ = ' ' ORDER BY DBC_ITEMPC"

	TCQuery cQuery New Alias "VW_F1PRD"

	cDescP := VW_F1PRD->A2_NOME
	fImpCab(VW_F1PRD->DBB_HAWB,VW_F1PRD->DBB_FORNEC,cDescP,VW_F1PRD->A2_UCODFAB,VW_F1PRD->DBA_ORIGEM)

	//Tributo
	nTotFac := 0
	nTotDif := 0
	nTotRec := 0
	nTotAlm := 0
	cDoc := VW_F1PRD->DBB_HAWB
	cDesMoeda := ""
	cSymb := ""
	IF MV_PAR04 == 1
		cDesMoeda = "Bolivianos"
		cSymb := "Bs"
	else
		cDesMoeda = "Dolares"
	ENDIF

	aInterna = getInterna(VW_F1PRD->DBB_HAWB,VW_F1PRD->DBB_TXMOED)

	if ! VW_F1PRD->(EoF())

		While ! VW_F1PRD->(EoF())

			if VW_F1PRD->DBB_HAWB != cDoc //si es otro documento salta de pagina
				aInterna = {}
				fImpRod()//
				cDescP := Posicione("SA2",1,xFilial("SA2")+VW_F1PRD->DBB_FORNEC+VW_F1PRD->DBB_LOJA,"A2_NOME")
				fImpCab(VW_F1PRD->DBB_HAWB,VW_F1PRD->DBB_FORNEC,cDescP,VW_F1PRD->A2_UCODFAB,VW_F1PRD->DBA_ORIGEM)//CABEC
				aInterna = getInterna(VW_F1PRD->DBB_HAWB,VW_F1PRD->DBB_TXMOED)
				cDoc := VW_F1PRD->DBB_HAWB
			else
				If nLinAtu + nTamLin > nLinFin
					fImpRod()//
					cDescP := Posicione("SA2",1,xFilial("SA2")+VW_F1PRD->DBB_FORNEC+VW_F1PRD->DBB_LOJA,"A2_NOME")
					fImpCab(VW_F1PRD->DBB_HAWB,VW_F1PRD->DBB_FORNEC,cDescP,VW_F1PRD->A2_UCODFAB,VW_F1PRD->DBA_ORIGEM)//CABEC
				EndIf
				cDoc := VW_F1PRD->DBB_HAWB
			endif

			oPrint:Box( nLinAtu, COL_GRUPO, nLinAtu+020, nColFin, "-2")//sub detalle
			//items
			oPrint:SayAlign(nLinAtu, COL_COD, VW_F1PRD->DBC_CODPRO,     oFontDet, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_DESCR, SUBSTR(VW_F1PRD->DBC_DESCRI,1,25),     oFontDet, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_QFATREQ, ALLTRIM(TRANSFORM(VW_F1PRD->C1_QUANT,"@E 9,999,999")),     oFontDet, 50, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_QFAT, ALLTRIM(TRANSFORM(VW_F1PRD->DBC_QUANT,"@E 9,999,999")),     oFontDet, 50, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_PRECO,ALLTRIM(TRANSFORM(VW_F1PRD->DBC_PRECO,"@E 9,999,999.99")),     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_DESTO, ALLTRIM(TRANSFORM(VW_F1PRD->DBC_VLDESC,"@E 9,999,999.99")),     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BRUTO, ALLTRIM(TRANSFORM(VW_F1PRD->DBC_TOTAL,"@E 999,999,999,999.99")),     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			nValAlm := iif(MV_PAR04 == 1,(VW_F1PRD->DBC_PRECO*(VW_F1PRD->DBB_TXMOED*(aInterna[2]/100)))+(VW_F1PRD->DBC_PRECO*VW_F1PRD->DBB_TXMOED),(VW_F1PRD->DBC_PRECO*(aInterna[1]/100))+VW_F1PRD->DBC_PRECO)

			oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM(nValAlm,"@E 9,999,999.99")), oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nCostoUnit := 0

			nCostoUnit := xMoeda(nCostoUnit, VW_F1PRD->DBB_MOEDA ,MV_PAR04,,2,VW_F1PRD->DBB_TXMOED)

			oPrint:SayAlign(nLinAtu, COL_UNIT, ALLTRIM(TRANSFORM(nCostoUnit,"@E 9,999,999.99")),     oFontDet, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			//Lineas verticales
			oPrint:Box( nLinAtu, COL_DESCR, nLinAtu+020, COL_DESCR, "-2")
			oPrint:Box( nLinAtu, COL_QFATREQ, nLinAtu+020, COL_QFATREQ, "-2")
			oPrint:Box( nLinAtu, COL_QFAT, nLinAtu+020, COL_QFAT, "-2")
			oPrint:Box( nLinAtu, COL_PRECO, nLinAtu+020, COL_PRECO, "-2")
			oPrint:Box( nLinAtu, COL_DESTO, nLinAtu+020, COL_DESTO, "-2")
			oPrint:Box( nLinAtu, COL_BRUTO, nLinAtu+020, COL_BRUTO, "-2")
			oPrint:Box( nLinAtu, COL_NETO, nLinAtu+020, COL_NETO, "-2")
			oPrint:Box( nLinAtu, COL_UNIT, nLinAtu+020, COL_UNIT, "-2")

			nTotFac+= VW_F1PRD->DBC_TOTAL
			nTotRec+= nValAlm

			nLinAtu += nTamLin
			VW_F1PRD->(DbSkip())
		enddo
		nLinAtu -= nTamLin
		nLinAtu += (nTamLin * 2)
		oPrint:SayAlign(nLinAtu, COL_PRECO, "TOTALES",     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinAtu, COL_BRUTO,ALLTRIM(TRANSFORM(nTotFac,"@E 9,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_NETO, ALLTRIM(TRANSFORM(nTotRec,"@E 9,999,999.99")),     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_UNIT,cSymb,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinAtu += (nTamLin * 2)
		VW_F1PRD->(DbCloseArea())
	Endif

	nLinAtu += nTamLin

	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod()
	EndIf

	//Mostrando o relatório
	oPrint:Preview()

	RestArea(aArea)

RETURN

Static Function fImpCab(cDoc,cProv,cProvDes,cUcob,cOrg)
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFLogo := GetSrvProfString("Startpath","") + "Logo01.bmp"
	//Iniciando Página
	oPrint:StartPage()

	oPrint:SayBitmap(030,10, cFLogo,070,060)

	cDesMoeda := ""
	cSymb := ""
	IF MV_PAR04 == 1
		cDesMoeda = "Bolivianos"
		cSymb := "Bs"
	else
		cDesMoeda = "Dolares"
		cSymb := "$"
	ENDIF
	//Cabeçalho
	cTexto := "Planilla de Importaciones en " + cDesMoeda // poner moneda
	oPrint:SayAlign(nLinCab, nColMeio - 180, cTexto, oFontTitt, 400, 20, , PAD_CENTER, 0)
	nLinCab += (nTamLin * 6)
	oPrint:SayAlign(nLinCab, COL_GRUPO, Alltrim(SM0->M0_NOME)+ " / "+Alltrim(SM0->M0_FILIAL)	+ " / "	+ ALLTRIM(SM0->M0_CODFIL), oFontTit, 240, 20, , PAD_LEFT, 0)

	//Linha Separatória
	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)

	//Cabeçalho das colunas
	nLinCab += nTamLin
	oPrint:SayAlign(nLinCab, COL_GRUPO, "Numero OC",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:Box( nLinCab, 80, nLinCab+015, 450, "-2")
	oPrint:SayAlign(nLinCab, COL_GRUPO+0170, cDoc + space(10) + cUcob + space(7) + cOrg,     oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	//recuadro

	nLinCab += (nTamLin * 1.8)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "Proveedor", oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:Box( nLinCab, 80, nLinCab+015, nColFin, "-2")
	oPrint:SayAlign(nLinCab, COL_GRUPO+0170, cProv + space(20) + cProvDes, oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	nLinCab += (nTamLin * 0.5)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "Detalle de Productos", oFontDetNN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.4)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	nLinCab += (nTamLin * 1.2)

	oPrint:SayAlign(nLinCab, COL_COD, "Codigo",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR, "Descripcion",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_QFATREQ, "Cant",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_QFAT, "Cant",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PRECO, "Precio",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESTO, "Desct($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_BRUTO, "Valor",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_NETO, "Valor",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_UNIT, "Costo Unit",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += (nTamLin * 1.2)

	oPrint:SayAlign(nLinCab, COL_QFATREQ, "Req",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_QFAT, " Fact",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PRECO, "Origen($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_BRUTO, "Fact($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	//IF MV_PAR04
	oPrint:SayAlign(nLinCab, COL_NETO, "Alm("+cSymb+")",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += nTamLin
	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod()//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin
	Local cTextoEsq := ''
	Local cTextoDir := ''

	//Linha Separatória
	//oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_GRAY)

	nLinRod += 3
	/*if lTot
	oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_BLACK)
	oPrint:SayAlign(nLinRod, COL_SUBLOTE, "TOTAL GENERAL GASTOS(Bs)", oFontDetN, 0140, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinRod, COL_BRUTO, "214355",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinRod, COL_IVA, "21315344",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinRod, COL_NETO, "521414214",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	else
	oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_BLACK)
	endif
	nLinRod += 15*/
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

static function getInterna(cHawb,nMoed)
	Local aArea := GetArea()
	Local cQuery	:= ""
	Local aCpiCpa := {}

	If Select("VW_CPI") > 0
		dbSelectArea("VW_CPI")
		dbCloseArea()
	Endif

	BeginSql Alias "VW_CPI"

		SELECT 'GASTO' AS TIPO,''DBB_DOC,''DBB_EMISSA,SUM(DBC_TOTAL)DBC_TOTAL,1 DBB_MOEDA,'Bs' DBB_SYMBOL,1 DBB_TXMOED,sum(DBC_VLIMP1) DBC_VLIMP1
		FROM (SELECT CASE DBB_TIPONF WHEN 'A' THEN 'GASTO' END AS TIPO ,
		DBB_DOC,DBB_EMISSA,DBC_TOTAL*DBB_TXMOED AS DBC_TOTAL,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED,DBC_VLIMP1 * DBB_TXMOED AS DBC_VLIMP1
		FROM %table:DBC% DBC
		JOIN %table:DBB% DBB
		ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF IN ('A')
		AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.%notDel%
		WHERE DBC_HAWB BETWEEN %Exp:cHawb% AND %Exp:cHawb%
		AND DBC.%notDel%  AND DBC_TES <> 330)TB
		UNION
		SELECT 'DUA' AS TIPO ,DBB_DOC,DBB.DBB_EMISSA,SUM(DBC_UVALDU)DBC_TOTAL,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED,0
		FROM %table:DBC% DBC
		JOIN %table:DBB% DBB
		ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF IN ('D')
		AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.%notDel%
		WHERE DBC_HAWB BETWEEN %Exp:cHawb% AND %Exp:cHawb%
		AND DBC.%notDel%  AND DBC_TES <> 330
		GROUP BY DBB_DOC,DBB_EMISSA,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED
		UNION
		SELECT 'FOB' AS TIPO,DBB.DBB_DOC,DBB.DBB_EMISSA,SUM(DBC.DBC_TOTAL) DBC_TOTAL,DBB.DBB_MOEDA,DBB.DBB_SIMBOL,DBB.DBB_TXMOED,0
		FROM %table:DBC% DBC
		JOIN %table:DBB% DBB
		ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF IN ('5')
		AND DBB.DBB_ITEM = DBC.DBC_ITDOC AND DBB.%notDel%
		WHERE DBC_HAWB BETWEEN %Exp:cHawb% AND %Exp:cHawb%
		AND DBC.%notDel%  AND DBC_TES <> 330
		GROUP BY DBB_DOC,DBB_EMISSA,DBB_MOEDA,DBB_SIMBOL,DBB_TXMOED
	EndSql

	aLastQuery    := GetLastQuery()
	cLastQuery    := aLastQuery[2]

	//Aviso("CPA",cLastQuery,{'ok'},,,,,.t.)

	nTotFob := 0//$
	nTotGas := 0//BS
	nTotDua := 0//BS
	nTotIv := 0

	While ! VW_CPI->(EoF())

		if 'FOB' $ VW_CPI->TIPO
			nTotFob += VW_CPI->DBC_TOTAL
		endif
		if 'GASTO' $ VW_CPI->TIPO
			nTotGas += VW_CPI->DBC_TOTAL
			nTotIv += VW_CPI->DBC_VLIMP1
		endif
		if 'DUA' $ VW_CPI->TIPO
			nTotDua += VW_CPI->DBC_TOTAL
		endif

		VW_CPI->(DbSkip())
	EndDo

	//ALERT(nTotFob)

	//alert(nTotGas)

	//alert(nTotDua)

	//CALCULO CPI

	nGas := nTotGas

	nTotGas := (nGas + nTotDua)/nMoed

	nTotGas = nTotGas + nTotFob

	nTotGas = nTotGas/nTotFob

	nTotGas = nTotGas - 1

	nCPI = nTotGas*100 // $us CPI

	//CALCULO CPA
	
	//alert()

	nTotGas := (nGas- nTotIv)/nMoed

	nTotGas = nTotGas  + nTotFob

	nTotGas = nTotGas/nTotFob

	nTotGas = nTotGas - 1

	nCPA = nTotGas*100 // $us CPI

	AADD(aCpiCpa,nCPI)
	AADD(aCpiCpa,nCPA)

	VW_CPI->(DbCloseArea())
	RestArea(aArea)

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return aCpiCpa