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
#Define COL_BOXIN   0085
#Define COL_BOXIN2  0320
#Define COL_BOXIN3  0570
#Define COL_DESCR   00100
#Define COL_FABRIC  0160
#Define	COL_LOTE 	0190
#Define	COL_SUBLOTE		0259
#Define	COL_UBICACION	0300
#Define	COL_CANTIDAD	0350
#Define	COL_COSTO		0500
#Define	COL_TOTAL		0455
#Define COL_VALIDEZ    0510
#Define COL_FECHA 0610
#Define COL_BOXU 0120
#Define COL_BOXD 0320
#Define COL_BOXT 0520

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  MOVINT  ºAutor  ³ERICK ETCHEVERRY º   º Date 07/09/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Movimientos internos resumido                               º±±
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

User Function PLIMPGRL()
	LOCAL cString		:= "SD3"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Planilla general"
	LOCAL cDesc1	    := "Relatorio de planilla general"
	LOCAL cDesc2	    := "conforme parametro"
	LOCAL cDesc3	    := "Especifico UNION"
	PRIVATE nomeProg 	:= "PLIMPGRL"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont := "Courier New"
	Private oFontDet  := TFont():New(cNomeFont,07,07,,.F.,,,,.T.,.F.)
	Private oFontDetN := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontDetNN := TFont():New(cNomeFont,012,012,,.T.,,,,.F.,.F.)
	Private oFontDN := 	 TFont():New(cNomeFont,07,07,,.T.,,,,.F.,.F.)
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

	Processa({ |lEnd| MOVD3CONF("Impresion de movimientos internos")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'movinterno'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zTstREl_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
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
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 580
	Private nColIni   := 010
	Private nColFin   := 730
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2

	//alert("")
	If Select("VW_PIMP") > 0
		dbCloseArea()
	Endif

	cQuery := "	SELECT DBA_UFACTS DBB_DOC,DBA_DT_EMB,DBA_UFECRE,DBA_UFECAL,DBA_UFECPU,DBA_HAWB,DBB_FORNEC,DBB_LOJA,DBA_ORIGEM,MIN(DBB_EMISSA)DBB_EMISSA,'CIP SANTA CRUZ' TERMCOMPRA,SUM(DBC_TOTAL)VALMER,SUM(DBC_VALFRE)VALFLET, "
	cQuery += "	SUM(DBC_DESPES)VALGAST,SUM(DBC_SEGURO)SEGURO, SUM(DBC_TOTAL)+SUM(DBC_VALFRE)+SUM(DBC_DESPES)+SUM(DBC_SEGURO)VALTOT, "
	cQuery += "	MAX(DBB_COND) DBB_COND,'cuotas',DBA_UEMPAS,DBA_DT_ENC,DBA_UEMTRA,DBF_DESCR,DBA_UTPFLE, "
	cQuery += "	CASE DBA_UTPDCF WHEN 1 THEN 'CRT' WHEN 2 THEN 'BL' ELSE 'AWB' END AS DBA_UTPDCF, "
	cQuery += "	DBA_UPBULT,DBA_PESO_B,DBA_MT3,DBA_UEMPAS,DB9_NOME,DBA_UNROAG,DBA_UNPART,DBA_UNRDUI,DBA_DT_DTA,SUM(DBC_UVALDU)VALDUI,DBB_MOEDA, "
	cQuery += "	DBB_TXMOED,DBB_SIMBOL,SUM(DBC_TOTAL)VALFOB,'VALCIFIMP',A2_NOME,A2_UCODFAB,DBA_ORIGEM,A2_LOJA,'DBAINCOTERM',DBA_UINTER,DBD_DESCR,DBA_UADUDE,DBA_UVALCI,DBA_UNAPLS,DBA_UFPART "
	cQuery += "  FROM " + RetSqlName("DBA") + " DBA "
	cQuery += "  JOIN " + RetSqlName("DBB") + " DBB "
	cQuery += "	ON DBB_FILIAL = DBA_FILIAL AND DBA_HAWB = DBB_HAWB AND DBB.D_E_L_E_T_ = '' AND DBB_TIPONF = '5' "
	cQuery += "  JOIN " + RetSqlName("DBC") + " DBC "
	cQuery += "	ON DBC_HAWB = DBB_HAWB AND DBC_ITDOC = DBB_ITEM AND DBB_FILIAL = DBC_FILIAL AND DBC.D_E_L_E_T_ = '' "
	cQuery += "  JOIN " + RetSqlName("SE4") + " SE4 "
	cQuery += "	ON E4_CODIGO = DBB_COND AND SE4.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("DBF") + " DBF "
	cQuery += "	ON DBA_VIA_TR = DBF_VIA AND DBF.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("DB9") + " DB9 "
	cQuery += "	ON DB9_COD =DBA_DESP AND DB9.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("DBD") + " DBD "
	cQuery += "	ON DBD_SIGLA =DBA_ORIGEM AND DBD.D_E_L_E_T_ = '' "
	cQuery += " WHERE DBA_HAWB BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += " AND DBA.D_E_L_E_T_ = ' ' "
	cQuery += " AND DBA_FILIAL = '" + MV_PAR03 + "' "
	cQuery += " GROUP BY DBA_HAWB, DBB_FORNEC, DBA_ORIGEM, DBA_DT_ENC, DBF_DESCR, DBA_PESO_B, "
	cQuery += " DBA_MT3, DB9_NOME,DBA_UNPART, DBA_DT_DTA, DBB_MOEDA, DBB_TXMOED, DBB_SIMBOL, A2_NOME, A2_UCODFAB, A2_LOJA, DBA_UEMPAS,  "
	cQuery += " DBA_UTPFLE, DBA_UTPDCF, DBA_DT_EMB, DBA_UFECRE, DBA_UFECAL, DBA_UFECPU,  DBA_UFACTS,  DBA_UEMTRA, DBA_UNRDUI, DBA_UINTER, DBA_UNROAG, DBA_UPBULT, DBB_LOJA, DBD_DESCR, DBA_UADUDE, DBA_UVALCI, DBA_UNAPLS, DBA_UFPART  "
	cQuery += " ORDER BY DBA_HAWB "

	//Aviso("CPA",cQuery,{'ok'},,,,,.t.)

	TCQuery cQuery New Alias "VW_PIMP"

	if EMPTY(MV_PAR09)
		MV_PAR09 := "02"
	ENDIF

	if empty(VW_PIMP->DBA_HAWB)
		alert("No hay registro para mostrar o no existe el despacho")
		return
	endif

	fImpCab(VW_PIMP->DBA_HAWB,VW_PIMP->DBB_FORNEC,VW_PIMP->A2_NOME,VW_PIMP->A2_UCODFAB,VW_PIMP->DBA_ORIGEM)

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	Count To nTotal
	ProcRegua(nTotal)
	VW_PIMP->(DbGoTop())

	//PRINTANDO ITEMS
	cDoc := VW_PIMP->DBA_HAWB

	if ! VW_PIMP->(EoF())

		While ! VW_PIMP->(EoF())

			if VW_PIMP->DBA_HAWB != cDoc //si es otro documento salta de pagina
				fImpRod()//
				fImpCab(VW_PIMP->DBA_HAWB,VW_PIMP->DBB_FORNEC,VW_PIMP->A2_NOME,VW_PIMP->A2_UCODFAB,VW_PIMP->DBA_ORIGEM)
				cDoc := VW_PIMP->DBA_HAWB
			else
				If nLinAtu + nTamLin > nLinFin
					fImpRod()//
					fImpCab(VW_PIMP->DBA_HAWB,VW_PIMP->DBB_FORNEC,VW_PIMP->A2_NOME,VW_PIMP->A2_UCODFAB,VW_PIMP->DBA_ORIGEM)
				EndIf
				cDoc := VW_PIMP->DBA_HAWB
			endif

			//Imprimindo a linha atual
			oPrint:Box( nLinAtu, 80			  , nLinAtu+240, 255, "-2")
			oPrint:Box( nLinAtu,COL_SUBLOTE+55, nLinAtu+240, 498, "-2")
			oPrint:Box( nLinAtu,COL_COSTO+63  , nLinAtu+270, 730, "-2")

			oPrint:SayAlign(nLinAtu, COL_BOXIN,VW_PIMP->DBD_DESCR , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2,DTOC(SToD(VW_PIMP->DBA_UFECPU)) , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3, VW_PIMP->DB9_NOME,  oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "Pais Origen",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE, "Fecha OC",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "Agencia Desp",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			//cuadros tres de items

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			oPrint:SayAlign(nLinAtu, COL_BOXIN,VW_PIMP->DBB_DOC , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2,DTOC(SToD(VW_PIMP->DBA_UFECRE)) , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3,VW_PIMP->DBA_UNROAG ,  oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO,  "N° Factura",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE,"Fecha Reque",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO,  "NroPlaniAgen",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			oPrint:SayAlign(nLinAtu, COL_BOXIN,DTOC(SToD(VW_PIMP->DBB_EMISSA)) , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2,DTOC(SToD(VW_PIMP->DBA_UFECAL)) , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3,VW_PIMP->DBA_UNPART,  oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO,  "FechFactProv",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE,"FechaAlm",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO,  "NroParteRece",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			oPrint:SayAlign(nLinAtu, COL_BOXIN,VW_PIMP->DBA_UINTER , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2, VW_PIMP->DBA_UEMTRA , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3, DTOC(SToD(VW_PIMP->DBA_UFPART)) ,  oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO,  "TermCompra",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE,"EmpTrans",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO,  "FechaPartRecep",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)

			nValMer := xMoeda(VW_PIMP->VALMER, VW_PIMP->DBB_MOEDA ,2,,2,VW_PIMP->DBB_TXMOED)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			oPrint:SayAlign(nLinAtu, COL_BOXIN,ALLTRIM(TRANSFORM(nValMer,"@E 9,999,999.99")) , oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2,VW_PIMP->DBF_DESCR , oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3, VW_PIMP->DBA_UADUDE ,  oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "ValMer($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE, "ModoTransp",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "AduanaDest",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			nValFlet := xMoeda(VW_PIMP->VALFLET, VW_PIMP->DBB_MOEDA ,2,,2,VW_PIMP->DBB_TXMOED)

			oPrint:SayAlign(nLinAtu, COL_BOXIN,ALLTRIM(TRANSFORM(nValFlet,"@E 9,999,999.99")) , oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2,VW_PIMP->DBA_UTPFLE , oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3, VW_PIMP->DBA_UNRDUI ,  oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "ValFlete($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE, "NumDocFlete",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "NumDUI",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			nValSeg := xMoeda(VW_PIMP->SEGURO, VW_PIMP->DBB_MOEDA ,2,,2,VW_PIMP->DBB_TXMOED)

			oPrint:SayAlign(nLinAtu, COL_BOXIN,ALLTRIM(TRANSFORM(nValSeg,"@E 9,999,999.99")) , oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2, DTOC(SToD(VW_PIMP->DBA_DT_EMB)) , oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3, DTOC(SToD(VW_PIMP->DBA_DT_DTA)) ,  oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "ValSeguro($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE, "FechaDocFlet",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "FechaDUI",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			nValDesp := xMoeda(VW_PIMP->VALGAST, VW_PIMP->DBB_MOEDA ,2,,2,VW_PIMP->DBB_TXMOED)

			nValDui := getTributo(VW_PIMP->DBA_HAWB)

			oPrint:SayAlign(nLinAtu, COL_BOXIN,ALLTRIM(TRANSFORM(nValDesp,"@E 9,999,999.99")) , oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2,VW_PIMP->DBA_UTPDCF , oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3,ALLTRIM(TRANSFORM(nValDui,"@E 9,999,999.99")) ,  oFontDetN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "ValGastDesp($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE, "TipoDocFlete",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "ValDUI(Bs)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			nValTot := xMoeda(VW_PIMP->VALTOT, VW_PIMP->DBB_MOEDA ,2,,2,VW_PIMP->DBB_TXMOED)
			oPrint:SayAlign(nLinAtu, COL_BOXIN,ALLTRIM(TRANSFORM(nValTot,"@E 9,999,999.99")) , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2,ALLTRIM(TRANSFORM(VW_PIMP->DBA_UPBULT,"@E 9,999,999.99")) , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3, ALLTRIM(TRANSFORM(VW_PIMP->DBB_TXMOED,"@E 9,999,999.99")) ,  oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "ValTotal($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE, "NumBultos",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "TipoCambio",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			nValFob := xMoeda(VW_PIMP->VALFOB, VW_PIMP->DBB_MOEDA ,1,,2,VW_PIMP->DBB_TXMOED)
			oPrint:SayAlign(nLinAtu, COL_BOXIN, Posicione("SE4",1,xFilial("SE4")+VW_PIMP->DBB_COND,"E4_DESCRI") , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2, ALLTRIM(TRANSFORM(VW_PIMP->DBA_PESO_B,"@E 9,999,999.99")), oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3, ALLTRIM(TRANSFORM(nValFob,"@E 9,999,999.99"))  ,  oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "FormaPago($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE, "Peso(kg)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "ValFOB(Bs)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			//nValCim := xMoeda(VW_PIMP->DBA_UVALCI, VW_PIMP->DBB_MOEDA ,1,,2,VW_PIMP->DBB_TXMOED)

			oPrint:SayAlign(nLinAtu, COL_BOXIN,"DEFINIR", oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2,ALLTRIM(TRANSFORM(VW_PIMP->DBA_MT3,"@E 9,999,999.99")) , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3, ALLTRIM(TRANSFORM(VW_PIMP->DBA_UVALCI,"@E 9,999,999.99")),  oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "NumCuotas($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE, "Volumen(m3)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "ValCIFImp(Bs)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales
			oPrint:Box( nLinAtu, COL_GRUPO+65, nLinAtu, 255, "-2")
			oPrint:Box( nLinAtu, COL_SUBLOTE+55, nLinAtu, 498, "-2")
			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			oPrint:SayAlign(nLinAtu, COL_BOXIN,VW_PIMP->DBA_UEMPAS , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN2,VW_PIMP->DBA_UNAPLS , oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_BOXIN3, iif(len(alltrim(VW_PIMP->A2_NOME)) > 40,substr(VW_PIMP->A2_NOME,1,40)+"-",substr(VW_PIMP->A2_NOME,1,40)),  oFontDN, 00200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "EmpAseg",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUBLOTE, "NumAplicSeg",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "ProveedorOri",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			nLinAtu += (nTamLin * 1)

			oPrint:SayAlign(nLinAtu, COL_BOXIN3, alltrim(substr(VW_PIMP->A2_NOME,41,40)) ,  oFontDN, 00200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)
			//Lineas horizontales

			oPrint:Box( nLinAtu, COL_COSTO+63, nLinAtu, 730, "-2")

			oPrint:SayAlign(nLinAtu, COL_BOXIN3, VW_PIMP->DBB_LOJA,  oFontDN, 00150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_GRUPO, "Plan de Pago",     oFontDetNN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_COSTO, "ProvedOriLoc",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += (nTamLin * 2)

			/////////////////box pago
			oPrint:Box( nLinAtu, 15, nLinAtu+015, 470, "-2")//cuadro
			//verticales
			oPrint:Box( nLinAtu, 28, nLinAtu+015, 28, "-2")
			oPrint:Box( nLinAtu, 50, nLinAtu+015, 50, "-2")
			oPrint:Box( nLinAtu, 98, nLinAtu+015, 98, "-2")
			oPrint:Box( nLinAtu, 178, nLinAtu+015, 178, "-2")
			oPrint:Box( nLinAtu, 398, nLinAtu+015, 398, "-2")

			oPrint:SayAlign(nLinAtu, 16, "N°",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, 30, "Dias",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, 53, "Fecha",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, 100, "Monto($)",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, 180, "Comentario",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, 400, "Pagado",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			//buscar pagos y usar cuadro y lineas de arriba query y while para cxp
			/////////////////////////////////
			getFobSer(VW_PIMP->DBA_HAWB)
			if ! VW_DBSER->(EoF())

				While ! VW_DBSER->(EoF())
					getCXP(VW_DBSER->DBB_SERIE,VW_PIMP->DBB_FORNEC,VW_PIMP->DBB_LOJA,VW_DBSER->DBB_DOC,MV_PAR03)

					if ! VW_CPX->(EoF())

						While ! VW_CPX->(EoF())
							If nLinAtu + nTamLin > nLinFin
								fImpRod()//
								fImpCab(VW_PIMP->DBA_HAWB,VW_PIMP->DBB_FORNEC,VW_PIMP->A2_NOME,VW_PIMP->A2_UCODFAB,VW_PIMP->DBA_ORIGEM)
							EndIf
							nLinAtu += (nTamLin * 1.5)
							/////////////////box pago
							oPrint:Box( nLinAtu, 15, nLinAtu+015, 470, "-2")//cuadro
							//verticales
							oPrint:Box( nLinAtu, 28, nLinAtu+015, 28, "-2")
							oPrint:Box( nLinAtu, 50, nLinAtu+015, 50, "-2")
							oPrint:Box( nLinAtu, 98, nLinAtu+015, 98, "-2")
							oPrint:Box( nLinAtu, 178, nLinAtu+015, 178, "-2")
							oPrint:Box( nLinAtu, 398, nLinAtu+015, 398, "-2")

							oPrint:SayAlign(nLinAtu, 16,VW_CPX->E2_PARCELA ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
							oPrint:SayAlign(nLinAtu, 30,ALLTRIM(TRANSFORM(VW_CPX->E2_DIA,"@E 999,999"))  ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
							oPrint:SayAlign(nLinAtu, 53,DTOC(SToD(VW_CPX->E2_VENCTO)) ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
							oPrint:SayAlign(nLinAtu, 100,ALLTRIM(TRANSFORM(VW_CPX->E2_VALOR,"@E 9,999,999.99"))  ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
							oPrint:SayAlign(nLinAtu, 180,VW_CPX->E2_HIST ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
							oPrint:SayAlign(nLinAtu, 400,ALLTRIM(TRANSFORM(VW_CPX->E2_SALDO,"@E 9,999,999.99"))  ,     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

							VW_CPX->(DbSkip())
						ENDDO
						VW_CPX->(DbCloseArea())
					ENDIF
					VW_DBSER->(DbSkip())
				ENDDO
				VW_DBSER->(DbCloseArea())
			ENDIF

			nLinAtu += nTamLin

			VW_PIMP->(DbSkip())
		enddo
	Endif

	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod()
	EndIf

	//Mostrando o relatório
	oPrint:Preview()
	VW_PIMP->(DbCloseArea())
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

	nLinCab += (nTamLin * 1.8)

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
	oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_GRAY)
	nLinRod += 3

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

static function getTributo(cHawb)
	Local cQuery	:= ""

	If Select("VW_DUA") > 0
		dbSelectArea("VW_DUA")
		dbCloseArea()
	Endif

	/*SELECT 'TRIBUTO ADUANERO',DBC.DBC_DESCRI,DBB.DBB_DOC,DBB.DBB_EMISSA,DBC.DBC_TOTAL,DBB.DBB_MOEDA,DBB.DBB_SIMBOL,DBB.DBB_TXMOED FROM DBC010 DBC
	JOIN DBB010 DBB
	ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'D' AND DBB.D_E_L_E_T_ = ''
	WHERE DBC_HAWB BETWEEN 'OC/077/19/A' AND 'OC/077/19/A'
	AND DBC.DBC_QUANT = 0 AND DBC.DBC_UVALDU > 0
	AND DBC.D_E_L_E_T_ =' '*/

	cQuery := "	SELECT DBC_UVALDU,DBB_TXMOED,DBB_MOEDA "
	cQuery += "  FROM " + RetSqlName("DBC") + " DBC "
	cQuery += "  JOIN " + RetSqlName("DBB") + " DBB "
	cQuery += "  ON DBB.DBB_FILIAL = DBC.DBC_FILIAL AND DBB.DBB_HAWB = DBC.DBC_HAWB AND DBB.DBB_TIPONF = 'D' AND DBB_ITEM =DBC_ITDOC AND DBB.D_E_L_E_T_ = '' "
	cQuery += " LEFT JOIN " + RetSqlName("SA2") + " SA2 "
	cQuery += "	ON A2_COD = DBB_FORNEC AND A2_LOJA = DBB_LOJA AND SA2.D_E_L_E_T_ = '' "
	cQuery += "  WHERE DBC_HAWB BETWEEN '" + cHawb + "' AND '" + cHawb + "' "
	cQuery += "  AND DBC.DBC_QUANT = 0 AND DBC.DBC_UVALDU > 0 AND DBC.D_E_L_E_T_ =' ' AND DBC_FILIAL = '" + MV_PAR03 + "' ORDER BY DBB_ITEM"

	TCQuery cQuery New Alias "VW_DUA"

	nValDui := xMoeda(VW_DUA->DBC_UVALDU, VW_DUA->DBB_MOEDA ,1,,2,VW_DUA->DBB_TXMOED)

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return nValDui

static function getCXP(cSeriea,cForn,cLojs,cDosc,cFIlas)
	Local cQuery	:= ""

	If Select("VW_CPX") > 0
		dbSelectArea("VW_CPX")
		dbCloseArea()
	Endif

	/*SELECT E2_PARCELA,E2_VENCTO,E2_VALOR,E2_HIST,E2_VALOR - E2_SALDO E2_SALDO FROM SE2010
	WHERE 'AV' = E2_PREFIXO AND '000085' = E2_FORNECE AND '01'=E2_LOJA AND E2_NUM ='565/2019' AND E2_TIPO = 'NF'
	AND E2_FILIAL = '0105'*/

	cQuery := "	SELECT E2_PARCELA,DATEDIFF(day,E2_EMISSAO,E2_VENCTO)+1 E2_DIA,E2_VENCTO,E2_VALOR,E2_HIST,E2_VALOR - E2_SALDO E2_SALDO "
	cQuery += "  FROM " + RetSqlName("SE2") + " SE2 "
	cQuery += "  WHERE E2_PREFIXO = '" + cSeriea + "' AND E2_TIPO = 'NF' "
	cQuery += "  AND E2_FORNECE = '" + cForn + "' AND E2_LOJA = '" + cLojs + "' "
	cQuery += "  AND E2_NUM =  '" + cDosc + "' AND E2_FILIAL = '" + cFIlas + "' "

	TCQuery cQuery New Alias "VW_CPX"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getFobSer(cDoc)
	Local cQuery	:= ""

	If Select("VW_DBSER") > 0
		dbSelectArea("VW_DBSER")
		dbCloseArea()
	Endif

	/*SELECT E2_PARCELA,E2_VENCTO,E2_VALOR,E2_HIST,E2_VALOR - E2_SALDO E2_SALDO FROM SE2010
	WHERE 'AV' = E2_PREFIXO AND '000085' = E2_FORNECE AND '01'=E2_LOJA AND E2_NUM ='565/2019' AND E2_TIPO = 'NF'
	AND E2_FILIAL = '0105'*/

	cQuery := "	SELECT DBB_SERIE,DBB_DOC "
	cQuery += "  FROM " + RetSqlName("DBB") + " DBB "
	cQuery += "  WHERE DBB_FILIAL = '" + xfilial("DBB") + "' "
	cQuery += "  AND DBB_HAWB = '" + cDoc + "' "
	cQuery += "  AND DBB_TIPONF = '5' AND DBB.D_E_L_E_T_ = '' "

	TCQuery cQuery New Alias "VW_DBSER"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

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