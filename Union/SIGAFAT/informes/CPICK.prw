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
#Define COL_COD   0027
#Define COL_UM	060
#Define COL_DESCR   080
#Define COL_FAB 0220
#Define COL_QUANT	0250
#Define COL_PUNIT 0280
#Define COL_TOTA 0330
#Define COL_LOTE 0380
#Define COL_VALZ 0440
#Define COL_CENT 0500
#Define COL_LOLIZ 0530

/*
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ  CPICK  บAutor  ณERICK ETCHEVERRY บ 	 Date 17/06/2020  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑDescripcion Nota de entrega					                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ UNION SRL	                                          	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ MV_PAR01 ณ Descricao da pergunta1 do SX1                              บฑฑ
ฑฑบ MV_PAR02 ณ Descricao da pergunta2 do SX1                              บฑฑ
ฑฑบ MV_PAR03 ณ Descricao do pergunta3 do SX1                              บฑฑ
ฑฑบ MV_PAR04 ณ Descricao do pergunta4 do SX1                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function CPICK(cDocu,cSeriea,cTitulo)
	//Local oReport
	//Local nOpcAviso
	Private cNota := ""
	Private cSerieNo  := ""
	If (cDocu <> Nil )
		cNota := cDocu
		cSerieNo := cSeriea
	Endif

	IMPNOTA(cTitulo)
return

static Function IMPNOTA(cTitulo)
	LOCAL cString		:= "SCP"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Impresion nota de entrega"
	//LOCAL cDesc1	    := "Impresion nota de entrega"
	//LOCAL cDesc2	    := "conforme PE"
	//LOCAL cDesc3	    := "Especifico Belen"
	PRIVATE nomeProg 	:= "BAJNOTA"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont := "Courier New"
	Private oFontDet  := TFont():New(cNomeFont,07,07,,.F.,,,,.T.,.F.)
	Private oFontDet8  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontDetN := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontDN := 	 TFont():New(cNomeFont,07,07,,.T.,,,,.F.,.F.)
	Private oFontRod  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTitt:= TFont():New(cNomeFont,09,09,,.T.,,,,.F.,.F.)
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 		:= 0
	private cArquivo
	//PRIVATE cPerg   := "BAJNOTA"   // elija el Nombre de la pregunta
	///CriaSX1(cPerg)	// Si no esta creada la crea

	//Pergunte(cPerg,.F.)

	Processa({ |lEnd| MOVD3CONF("Impresion nota de entrega")},"Imprimindo , aguarde...")

	if getfFAQuan(cNota,cSerieNo) != getAcFaQuan(cNota,cSerieNo)
		MSGALERT( "Cantidades diferentes de ubicacion, notificar al administrador del sistema", "ATENCION" )
		VW_OTRR->(dbCloseArea())
		VW_FAACT->(dbCloseArea())
		return
	else
		VW_OTRR->(dbCloseArea())
		VW_FAACT->(dbCloseArea())
		Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg,cTitulo)},titulo)
	endif

Return

Static Function MOVD3CONF(Titulo)
	//Local cFilename := 'BAJNOTA'
	//Local i 	 := 1
	//Local x 	 := 0

	cCaminho  := GetTempPath()

	cArquivo  := "znotgra" + dToS(date()) + "_" + alltrim(SUBSTR(TIME(), 1, 2))+ alltrim(SUBSTR(TIME(), 4, 2)) + alltrim(SUBSTR(TIME(), 7, 2)) + cvaltochar(Randomize( 1, 100 )) + cvaltochar(Randomize( 1, 100 ))
	//cArquivo  := "znotgra" + dToS(date()) + "_" + StrTran(time(), ':', '-') + cvaltochar(Randomize( 1, 100 )) + cvaltochar(Randomize( 1, 100 ))
	//Criando o objeto do FMSPrinter
	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrint, "", , , , .T.)
	oPrint:cPathPDF := cCaminho

	//Setando os atributos necessแrios do relat๓rio
	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(1)
	oPrint:SetMargin(60, 60, 60, 60)

Return Nil

Static Function fImpPres(lEnd,WnRel,cString,nReg,cTitula)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	//Local nTotal := 0
	//Local lRetCF := .f.
	//Local aInterna := {}
	//Local cNreduz	:= ""
	Local nX := 1
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
	private valorBonificacion := 0.0
	private nDescPor := 0.0
	private cBonusTes  := SuperGetMv("MV_BONUSTS")
	private nValfat
	private nDescont
	private nBasimpl
	private nUtaten
	Private cNum     := 0

	If Select("VW_NOTA") > 0
		dbCloseArea()
	Endif

	cQuery := " SELECT DISTINCT SD2.R_E_C_N_O_, D2_PEDIDO,CASE isnull(DB_QUANT,0)  WHEN 0 THEN D2_QUANT ELSE DB_QUANT END D2_QUANT, D2_FILIAL,D2_UTPLIQ, "   //D2_UTPLIQ,
	cQuery += " D2_COD, D2_LOCAL, D2_NUMSEQ, D2_DOC,D2_SERIE,D2_ITEM,DB_LOCALIZ, "
	
	//Utilizado para el orden del query
	cQuery += "SUBSTRING(DB_LOCALIZ, 1, 2) BLOQUE, "
	cQuery += "SUBSTRING(DB_LOCALIZ, 3, 2) FILA, "
	cQuery += "SUBSTRING(DB_LOCALIZ, 5, 2) COLUMNA, "
	cQuery += "SUBSTRING(DB_LOCALIZ, 7, 2) LADO, "

	cQuery += " D2_LOTECTL, D2_POTENCI,D2_PRCVEN,D2_PRUNIT,ROUND((CASE isnull(DB_QUANT,0)  WHEN 0 THEN D2_QUANT ELSE DB_QUANT END*SD2.D2_PRUNIT),2) D2_TOTAL,D2_NUMLOTE, D2_DTVALID, D2_LOCALIZ , D2_LOJA , D2_UDESC, "
	cQuery += " D2_DESCON, ROUND(F2_DESCONT, 2) F2_DESCONT,F2_VALBRUT F2_VALFAT, F2_BASIMP1 , F2_UCTATEN , D2_TES, B1_UFABRIC, C6_BLQ, F2_EMISSAO"
	cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
	cQuery += " LEFT JOIN " + RetSqlName("SD2") + " SD2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_LOJA = F2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = D2_COD
	cQuery += " LEFT JOIN " + RetSqlName("SC6") + " SC6 ON C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN " + RetSqlName("SDB") + " SDB ON SDB.DB_FILIAL = SD2.D2_FILIAL AND SDB.DB_PRODUTO = SD2.D2_COD AND SDB.DB_LOCAL = SD2.D2_LOCAL "
	cQuery += " AND SDB.DB_LOTECTL = SD2.D2_LOTECTL AND SDB.DB_ESTORNO <> 'S' "
	cQuery += " AND SDB.DB_DOC = "
	cQuery += " CASE WHEN SD2.D2_REMITO <> '' "
	cQuery += " THEN SD2.D2_REMITO "
	cQuery += " ELSE SD2.D2_DOC "
	cQuery += " END "
	cQuery += " AND SDB.DB_SERIE = "
	cQuery += " CASE WHEN SD2.D2_SERIREM <> '' "
	cQuery += " THEN SD2.D2_SERIREM "
	cQuery += " ELSE SD2.D2_SERIE "
	cQuery += " END "
	cQuery += " AND SDB.DB_NUMSEQ = "
	cQuery += " CASE WHEN SD2.D2_SERIREM = '' "
	cQuery += " THEN SD2.D2_NUMSEQ "
	cQuery += " ELSE (SELECT SD22.D2_NUMSEQ FROM " + RetSqlName("SD2") + " SD22 WHERE SD22.D_E_L_E_T_='' "
	cQuery += " AND SD22.D2_FILIAL=SD2.D2_FILIAL AND SD22.D2_ESPECIE='RFN' AND SD22.D2_SERIE=SD2.D2_SERIREM "
	cQuery += " AND SD22.D2_DOC=SD2.D2_REMITO AND SD22.D2_COD=SD2.D2_COD AND SD22.D2_ITEM=SD2.D2_ITEMREM) "
	cQuery += " END "
	cQuery += " AND SDB.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE SD2.D2_FILIAL  = '" + xfilial("SD2") + "' "
	cQuery += " AND SD2.D2_DOC = '"+cNota+"' AND D2_SERIE = '" +cSerieNo +"' "
	cQuery += " AND SD2.D2_ESPECIE = 'NF' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY BLOQUE, COLUMNA, LADO, FILA "
	cQuery:= ChangeQuery(cQuery)
	//Aviso("GTAPRECG",cQuery,{'ok'},,,,,.t.)
	TCQuery cQuery New Alias "VW_NOTA"
	fImpCab(.t.,getCabec(),cTitula)
	//pie
	nBasimpl := VW_NOTA->F2_BASIMP1
	nValfat := VW_NOTA->F2_VALFAT
	nDescont := VW_NOTA->F2_DESCONT
	if ! VW_NOTA->(EoF())
		nNum := 0
		While ! VW_NOTA->(EoF())
			If nLinAtu + nTamLin > nLinFin
				fImpRod(nLinAtu,.f.)
				fImpCab(.F.)//CABEC
			EndIf
			//items
			Ccodigo := VW_NOTA->D2_COD
			SB1->(dbSeek(xFilial("SB1")+VW_NOTA->D2_COD))
			cFechadez   := 		alltrim(VW_NOTA->D2_DTVALID)
			cAnho			:= 		SubStr(cFechadez, 1,4 )
			cMes			:= 		SubStr(cFechadez, 5,2 )
			cDia			:= 		SubStr(cFechadez, 7,2 )
			cFechadez	:= 		cDia + "/" + cMes + "/" + cAnho
			cUnit := VW_NOTA->D2_PRUNIT
			cCant := VW_NOTA->D2_QUANT
			nValor := round( (cUnit * cCant ), 2)
			if( VW_NOTA->D2_TES == cBonusTes)
				valorBonificacion  +=  nValor
				nDescPor += VW_NOTA->D2_DESCON
			endif
			cUM := SB1->B1_UM
			cProducto   := SB1->B1_DESC  // DESCRIPCION
			nNum++
			//items
			oPrint:SayAlign(nLinAtu, COL_ITEM, 	cvaltochar(nNum),		oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COD, 	alltrim(Ccodigo),		oFontDet8, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_UM, 	cUM,     				oFontDet8, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_DESCR, SUBSTR(cProducto,1,31),	oFontDet8, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_FAB, 	VW_NOTA->B1_UFABRIC,	oFontDet8, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_QUANT,	cValToChar(VW_NOTA->D2_QUANT),     oFontDet8, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_PUNIT,	ALLTRIM(TRANSFORM(VW_NOTA->D2_PRUNIT,"@E 9,999,999,999.99")) ,     oFontDet8, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_TOTA,	ALLTRIM(TRANSFORM(nValor,"@E ,999,999,999.99")) ,     oFontDet8, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_LOTE, 	VW_NOTA->D2_LOTECTL,	oFontDet8, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_VALZ, 	cFechadez,				oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_CENT, 	VW_NOTA->D2_UTPLIQ,     oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_LOLIZ,	Trim(VW_NOTA->DB_LOCALIZ), oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			nLinAtu += nTamLin

			// odr 30/05/22 si la descripci๓n es mแs de 1 lํnea
			if len(cProducto)>31
				oPrint:SayAlign(nLinAtu, COL_DESCR, SUBSTR(cProducto,32,len(cProducto)-31),	oFontDet8, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nLinAtu += nTamLin
			endif

			VW_NOTA->(DbSkip())
		enddo
		nLinAtu -= nTamLin
		nLinAtu += (nTamLin * 1)
	Endif
	VW_NOTA->(DbCloseArea())
	//Se ainda tiver linhas sobrando na pแgina, imprime o rodap้ final
	If nLinAtu <= nLinFin
		fImpRod(nLinAtu,.t.)
	EndIf
	//Mostrando o relat๓rio
	oPrint:Preview()
	For nX := 1 to 10
		If ! File(cArquivo)
			Sleep(400)
		EndIf
	Next nX
	RestArea(aArea)
RETURN

Static Function fImpCab(lImp,aCabec,cTip)
	Local cTexto   := ""
	Local nLinCab  := 030
	//Local nLinInCab := 015
	//Local nDetCab := 090
	//Local nDerCab := 0540
	//Local cFLogo := GetSrvProfString("Startpath","") + "Logo01.bmp"
	Local aDescri:= {"",""}
	if lImp
		//Iniciando Pแgina
		oPrint:StartPage()
		//oPrint:SayBitmap(025,017, cFLogo,090,045)
		//Cabe็alho
		if !empty(ALLTRIM(aCabec[21]))			
			aDescri := TexToArray(ALLTRIM(aCabec[21]),50)
		endif
		cTexto := "NOTA DE ENTREGA (" + cTip + ")"
		oPrint:SayAlign(nLinCab, nColMeio - 180, cTexto, oFontTitt, 400, 30, , PAD_CENTER, 0)
		nLinCab += (nTamLin * 2)
		cTexto := "Precios expresados en " + IIf(aCabec[24] == 1, "Bolivianos", "D๓lares")
		oPrint:SayAlign(nLinCab, nColMeio - 180, cTexto, oFontTitt, 400, 30, , PAD_CENTER, 0)
		//nLinCab += (nTamLin * 1)
		//oPrint:SayAlign(nLinCab, nColMeio - 180, cTip, oFontTitt, 400, 30, , PAD_CENTER, 0)
		nLinCab += (nTamLin * 1)
		//Cabe็alho das colunas
		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_ITEM, "Pedido: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEM+60, aCabec[1], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_DESCR+110, "Tipo Cliente: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_DESCR+170, aCabec[2], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, "Fecha Impresion: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,aCabec[3]  , oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM, "Cliente: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEM+60, aCabec[7], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, "Sucursal: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,aCabec[5], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM, "N. Fantasia: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEM+60, aCabec[8], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, "TC.: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,cvaltochar(aCabec[6]), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM, "Direccion: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEM+60, aCabec[9], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, "Fecha de Emision: ",     oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,aCabec[10], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM, "Telf.: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_ITEM+60, aCabec[13], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, "Factura: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,aCabec[14], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM, "Tipo Entrega: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEM+60, aCabec[11], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_DESCR+65, "Fecha Entrega: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_DESCR+125,aCabec[12], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, "Tipo Vendedor: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,aCabec[16], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM, "Vendedor: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEM+60, aCabec[15], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, "Tipo Remito: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,aCabec[18], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM, "Reg. Por: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEM+60, alltrim(aCabec[17]), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, "Cond. de Pago: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,aCabec[20], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM, "Impreso Por: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEM+60, aCabec[19], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, "Fecha Vencto: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,aCabec[22], oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM, 		 "Observacion: ",     					oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ITEM+60, 	 aDescri[1], 							oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_TOTA, 		 "Bodega: ",     						oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_TOTA+75,aCabec[23], 							oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1)
		oPrint:SayAlign(nLinCab, COL_ITEM+60,	 iif(len(aDescri) > 1 ,aDescri[2],""), 	oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += (nTamLin * 2)
	else
		oPrint:StartPage()
		nLinCab += (nTamLin * 2)
	endif
	oPrint:SayAlign(nLinCab, COL_ITEM, "#",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COD, "Codigo",     oFontDetN, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_UM, "UM",     oFontDetN, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR, "Descripcion",     oFontDetN, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_FAB, "Fab",     oFontDetN, 0270, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_QUANT, "Cant",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PUNIT, "P/Unit",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_TOTA, "Total",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_LOTE, "Lote",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_VALZ, "Validez",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CENT, "TP/Liq",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_LOLIZ, "Ubicacion",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	//nLinCab += (nTamLin * 1.2)
	//Atualizando a linha inicial do relat๓rio
	nLinAtu := nLinCab
Return

Static Function fImpRod(nContin,lImp)//RODAPE PIE PAGINA
	Local nLinRod   := nContin + 10
	Local cTextoEsq := ''
	Local cTextoDir := ''
	if lImp
		oPrint:Line(nLinRod, 10, nLinRod,nColFin,CLR_BLACK,"-1")

		// valorLiteral := "Son: " + Extenso(NOROUND(nBasimpl,2)) + IIf(SF2->F2_MOEDA == 1, " Bolivianos ", " Dolares")

		nTC := POSICIONE("SM2",1,SC5->C5_EMISSAO,"M2_MOEDA2")
		nTotMon2 := nBasimpl		
		If SF2->F2_MOEDA == 1
			nTotMon2 := NOROUND(nTotMon2/nTC,2)
			valorLiteral := "Son: " + Extenso(nTotMon2) + " D๓lares"
		else
			valorLiteral := "Son: " + Extenso(NOROUND(nTotMon2,2)) + " D๓lares"
		endif

		cRecrgo :=  cValToChar(TRANSFORM(SC5->(C5_DESPESA+C5_SEGURO+C5_FRETE),"@E 99,999,999.99"))
		nSubtotal  := nValfat
		nDescuento := nDescont + valorBonificacion
		nDescuento := nDescuento - nDescPor
		nTotGral   := Round(nSubtotal+nDescuento,2)
		nLinRod += 7
		oPrint:SayAlign(nLinRod, COL_ITEM, "Recargo:  " + cRecrgo,     oFontDet8, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinRod, COL_PUNIT, "Sub Total:",     oFontDet8, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinRod, COL_LOTE,  cValToChar(TRANSFORM(nTotGral,"@E 99,999,999.99")) ,     oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinRod += 7
		oPrint:SayAlign(nLinRod, COL_PUNIT, "Descuentos:",     oFontDet8, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinRod, COL_LOTE, cValToChar(TRANSFORM( nDescuento ,"@E 99,999,999.99")) ,     oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinRod += 7
		//oPrint:SayAlign(nLinRod, COL_ITEM, valorLiteral ,     oFontDet8, 200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		If SF2->F2_MOEDA == 1
			oPrint:SayAlign(nLinRod, COL_PUNIT, "Total Bs.:" ,     oFontDet8, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)			
		else
			oPrint:SayAlign(nLinRod, COL_PUNIT, "Total $us.:" ,     oFontDet8, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		endif
		oPrint:SayAlign(nLinRod, COL_LOTE, cValToChar(TRANSFORM(nBasimpl,"@E 99,999,999.99")),     oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinRod += 7
		oPrint:SayAlign(nLinRod, COL_ITEM, "Monto Total en D๓lares:" ,     oFontDetN, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinRod, COL_DESCR + 20, cValToChar(TRANSFORM(nTotMon2,"@E 99,999,999.99")),     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinRod += 7
		oPrint:SayAlign(nLinRod, COL_ITEM, valorLiteral ,     oFontDetN, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinRod += 7
		oPrint:SayAlign(nLinRod + 30, COL_UM, '____________________________', oFontTitt, 400, 05, CLR_GRAY, PAD_LEFT,  0)
		oPrint:SayAlign(nLinRod + 30, COL_TOTA, '____________________________', oFontTitt, 400, 05, CLR_GRAY, PAD_LEFT,  0)
		nLinRod += 7
		oPrint:SayAlign(nLinRod + 35, COL_UM,"Recibido conforme "  , oFontTitt, 100, 05, CLR_GRAY, , 0)
		oPrint:SayAlign(nLinRod + 35, COL_TOTA,"Entregado Por" , oFontTitt, 100, 05, CLR_GRAY, , 0)
		nLinRod += 7
		oPrint:SayAlign(nLinRod + 40, COL_UM,"Nombre: "  , oFontTitt, 100, 05, CLR_GRAY, , 0)
		oPrint:SayAlign(nLinRod + 40, COL_TOTA,"Nombre: "  , oFontTitt, 100, 05, CLR_GRAY, , 0)
		//Dados da Esquerda e Direita
		nLinRod += 15
	endif
	cTextoEsq := dToC(dDataGer) + "    " + cHoraGer + "    " + FunName() + "    " + cNomeUsr
	cTextoDir := "Pแgina " + cValToChar(nPagAtu)
	//Imprimindo os textos
	oPrint:SayAlign(nLinFin+20, nColIni,    cTextoEsq, oFontRod, 400, 05, CLR_GRAY, PAD_LEFT,  0)
	oPrint:SayAlign(nLinFin+20, nColFin-50, cTextoDir, oFontRod, 60, 05, CLR_GRAY, PAD_RIGHT, 0)
	//Finalizando a pแgina e somando mais um
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
	/*Local aRegs		:= {}
	Local aHelp 	:= {}
	Local aHelpE 	:= {}
	Local aHelpI 	:= {}
	Local cHelp		:= ""*/
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
	// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
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

static function getCabec()
	Local aData := {}
	Posicione("SC5",1,xFilial("SC5")+VW_NOTA->D2_PEDIDO,"C5_CONDPAG")
	SB1->(dbSeek(xFilial("SB1")+VW_NOTA->D2_COD))
	nfecha_impresion :=  cValToChar(dtoc(DATE())) +" "+ cValToChar(Time())
	nhora_impresion :=  cValToChar(Time())
	nPedido := AllTrim(SC5->C5_NUM) + " " +  IIf(SC5->C5_MOEDA == 1, "(en Bolivianos)", "(en Dolar)")
	nTipo_Cliente := alltrim(IIF(SC5->C5_TIPOCLI $ '1|2|3','GRAN CONT.',IIF(SC5->C5_TIPOCLI=='6','EXENTO','')))
	nSucursal	:= AllTrim(SM0->M0_FILIAL)
	nCliente	:= cValToChar(SC5->C5_CLIENTE+"-"+SC5->C5_LOJACLI + " " + Alltrim(Posicione("SA1",1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_NOME")))
	cNreduz		:= AllTrim(SA1->A1_NREDUZ)
	nTC :=  STR(POSICIONE("SM2",1,SC5->C5_EMISSAO,"M2_MOEDA2"))
	nDireccion := alltrim(Posicione("SA1",1,xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_END"))
	nFecha_Emision := cValToChar(DTOC(stod(VW_NOTA->F2_EMISSAO)))
	nTipoEntrega := alltrim(IIF(SC5->C5_UTIPOEN == '1','Ent. Rapida',IIF(SC5->C5_UTIPOEN=='2','Ent. Sala',IIF(SC5->C5_UTIPOEN=='3','Ent. V. Mayor-ENC',IIF(SC5->C5_UTIPOEN=='4','Desp. Local',IIF(SC5->C5_UTIPOEN=='5','Desp. Provincial',IIF(SC5->C5_UTIPOEN=='6','Kardex',IIF(SC5->C5_UTIPOEN=='7','Delivery',IIF(SC5->C5_UTIPOEN=='8','ECOMMERCE',IIF(SC5->C5_UTIPOEN=='9','URGENTE',''))))))))))
	if(empty(nTipoEntrega))
		nTipoEntrega := "         "
	endif
	auxTel := alltrim(POSICIONE('SA1',1,XFILIAL('SE4')+SC5->C5_CLIENTE,"A1_TEL"))
	if(empty(auxTel))
		auxTel := "00"
	endif
	nTipo_Entrega := nTipoEntrega
	nFecha_Entrega := dtoc(SC5->C5_FECENT)
	ntelefono := auxTel
	nFactura := alltrim(VW_NOTA->D2_SERIE) + "/" + quitZero(alltrim(VW_NOTA->D2_DOC))
	nVendedor :=  alltrim(Posicione("SA3",1,xFilial('SA3')+SC5->C5_VEND1,"A3_COD")) +" "+ alltrim(Posicione("SA3",1,xFilial('SA3')+SC5->C5_VEND1,"A3_NOME"))
	nTipo_Vendedor :=  Iif(SC5->C5_DOCGER == '1',"Ciudad",Iif(SC5->C5_DOCGER == '2',"Provincia","Entrega Futura"))
	nReg_Por := SC5->C5_USRREG
	nTipo_Remito := getRemito(SC5->C5_TIPOREM)
	nUsuarioA := Substr(CUsuario,7,15)
	nImpreso_Por := Upper(nUsuarioA)
	nCond_Pago := POSICIONE('SE4',1,XFILIAL('SE4')+SC5->C5_CONDPAGO,'E4_DESCRI')
	nObservacion :=  alltrim(SC5->C5_UOBSERV)
	nFecha_Vencto := dtoc(POSICIONE("SE1",1,xFilial("SE1")+VW_NOTA->D2_SERIE+VW_NOTA->D2_DOC,"E1_VENCTO"))
	nMonTit	:= POSICIONE("SF2",1,xFilial("SF2")+VW_NOTA->D2_DOC+VW_NOTA->D2_SERIE+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"F2_MOEDA")
	nBodega :=  SC5->C5_ULOCAL + " " + POSICIONE('NNR',1,xFilial('NNR')+SC5->C5_ULOCAL,'NNR_DESCRI')
	aadd(aData,nPedido)   //1
	aadd(aData,nTipo_Cliente) //2
	aadd(aData,nfecha_impresion)
	aadd(aData,nhora_impresion)
	aadd(aData,nSucursal)
	aadd(aData,val(nTC))
	aadd(aData,nCliente)
	aadd(aData,cNreduz)
	aadd(aData,nDireccion)
	aadd(aData,nFecha_Emision)
	aadd(aData,nTipo_Entrega)
	aadd(aData,nFecha_Entrega)
	aadd(aData,ntelefono)
	aadd(aData,nFactura)  ///
	aadd(aData,nVendedor)
	aadd(aData,nTipo_Vendedor)
	aadd(aData,nReg_Por)
	aadd(aData,cValToChar(nTipo_Remito))
	aadd(aData,nImpreso_Por)
	aadd(aData,nCond_Pago)
	aadd(aData,nObservacion)
	aadd(aData,nFecha_Vencto)
	aadd(aData,nBodega)
	aadd(aData,nMonTit)
return aData

static function getRemito(valor)
	local nRemito := valor
	local Resp
	if nRemito == "0"
		Resp := "Ventas"
	elseif nRemito == "A"
		Resp := "Consignacion"
	endif
return Resp

static Function quitZero(cTexto)
	local aArea     := GetArea()
	local cRetorno  := ""
	local lContinua := .T.
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

/////factura cantidad actual con localizacion
static function getAcFaQuan(cNota,cSerieNo)
	Local cQuery	:= ""
	If Select("VW_FAACT") > 0
		dbSelectArea("VW_FAACT")
		dbCloseArea()
	Endif

	cQuery := " SELECT SUM(DB_QUANT) D2_QUANT
	cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
	cQuery += " LEFT JOIN " + RetSqlName("SD2") + " SD2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_LOJA = F2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN " + RetSqlName("SC6") + " SC6 ON C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN " + RetSqlName("SDB") + " SDB ON SDB.DB_FILIAL = SD2.D2_FILIAL AND SDB.DB_PRODUTO = SD2.D2_COD AND SDB.DB_LOCAL = SD2.D2_LOCAL "
	cQuery += " AND SDB.DB_LOTECTL = SD2.D2_LOTECTL AND SDB.DB_ESTORNO <> 'S' "
	cQuery += " AND SDB.DB_DOC = "
	cQuery += " CASE WHEN SD2.D2_REMITO <> '' "
	cQuery += " THEN SD2.D2_REMITO "
	cQuery += " ELSE SD2.D2_DOC "
	cQuery += " END "
	cQuery += " AND SDB.DB_SERIE = "
	cQuery += " CASE WHEN SD2.D2_SERIREM <> '' "
	cQuery += " THEN SD2.D2_SERIREM "
	cQuery += " ELSE SD2.D2_SERIE "
	cQuery += " END "
	cQuery += " AND SDB.DB_NUMSEQ = "
	cQuery += " CASE WHEN SD2.D2_SERIREM = '' "
	cQuery += " THEN SD2.D2_NUMSEQ "
	cQuery += " ELSE (SELECT SD22.D2_NUMSEQ FROM " + RetSqlName("SD2") + " SD22 WHERE SD22.D_E_L_E_T_='' "
	cQuery += " AND SD22.D2_FILIAL=SD2.D2_FILIAL AND SD22.D2_ESPECIE='RFN' AND SD22.D2_SERIE=SD2.D2_SERIREM "
	cQuery += " AND SD22.D2_DOC=SD2.D2_REMITO AND SD22.D2_COD=SD2.D2_COD AND SD22.D2_ITEM=SD2.D2_ITEMREM) "
	cQuery += " END "
	cQuery += " AND SDB.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE SD2.D2_FILIAL  = '" + xfilial("SD2") + "' "
	cQuery += " AND SD2.D2_DOC = '"+cNota+"' AND D2_SERIE = '" +cSerieNo +"' "
	cQuery += " AND SD2.D2_ESPECIE = 'NF' "
	cQuery += " AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY D2_FILIAL,D2_SERIE,D2_DOC "
	cQuery:= ChangeQuery(cQuery)
	If __CUSERID = '000000'
		//Aviso("GTAPRECG",cQuery,{'ok'},,,,,.t.)
	EndIf
	TCQuery cQuery New Alias "VW_FAACT"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return VW_FAACT->D2_QUANT

//////factura cantidad actual sin localizacion
static function getfFAQuan(cNota,cSerieNo)
	Local cQuery	:= ""

	If Select("VW_OTRR") > 0
		dbSelectArea("VW_OTRR")
		dbCloseArea()
	Endif

	cQuery := "	SELECT SUM(SD2.D2_QUANT) quant "
	cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
	cQuery += " JOIN " + RetSqlName("SD2") + " SD2 "
	cQuery += " ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_LOJA = F2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN " + RetSqlName("SC6") + " SC6 "
	cQuery += " ON C6_FILIAL = D2_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += " LEFT JOIN " + RetSqlName("SB1") + " SB1 ON D2_COD = B1_COD  AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE D2_DOC BETWEEN '" + cNota + "' AND '" + cNota + "' "
	cQuery += " AND D2_SERIE BETWEEN '" + cSerieNo + "' AND '" + cSerieNo + "' "
	cQuery += " AND SB1.B1_LOCALIZ <> 'N' AND SD2.D2_ESPECIE = 'NF' AND SF2.D_E_L_E_T_ = ' '  "
	cQuery += " GROUP BY  SD2.D2_DOC,SD2.D2_SERIE,D2_FILIAL "

	TCQuery cQuery New Alias "VW_OTRR"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return VW_OTRR->quant
