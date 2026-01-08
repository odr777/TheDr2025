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
#Define COL_ITEM 0060
#Define COL_COD   0070
#Define COL_DESCR   0200
#Define COL_CLVL  0260
#Define COL_CONTA  0310
#Define COL_QUANT	0425
#Define COL_UM	0470
#Define COL_LOLIZ 0500

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  BAJNOTA ºAutor ³ERICK ETCHEVERRY º   º Date 08/12/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion linea de credito SA6		  		              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BELEN MATA185 SRL	                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPLINC()
	LOCAL cString		:= "SA6"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Impresion de linea de credito"
	LOCAL cDesc1	    := "Impresion de linea de credito"
	LOCAL cDesc2	    := "conforme PE"
	LOCAL cDesc3	    := "Especifico ciabol"
	PRIVATE nomeProg 	:= "IMPLINC"
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
	PRIVATE cPerg   := "IMPLINC"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.F.)

	if	SA6->A6_ULINEA == '3'
		alert("Debe seleccionar un banco con linea")
		return
	endif
	Processa({ |lEnd| MOVD3CONF("Impresion de linea de credito")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'IMPLINC'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zTBlince_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
	//Criando o objeto do FMSPrinter
	oPrint := FWMSPrinter():New(cArquivo, IMP_PDF, .F., "", .T., , @oPrint, "", , , , .T.)

	//Setando os atributos necessários do relatório
	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(1)//letter
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
	Private nLinFin   := 745
	Private nColIni   := 010
	Private nColFin   := 570
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2
	Private cDoc

	If Select("VW_LCOP") > 0
		dbCloseArea()
	Endif

	/*SELECT A6_UVLRLIN VALORLINEA,(A6_UPRPRES*A6_UVLRLIN)/100 PRESTAMO	,(A6_UPRCONT*A6_UVLRLIN)/100 CONTINGENCIA,A6_NOME NLINEACRED,
	A6_UFCILIN INICIO,A6_UFCFLIN FIN,MAX(ZEH_TAXA)COMISION	,MAX(EH_TAXA) INTERES,A6_USDASFA ASFALTOS,A6_USDPF DPFS,A6_USINMU INMUEBLES,
	A6_USMYV MAQUINARIA,A6_USVEI VEHICULOS,A6_USDASFA+A6_USDPF+A6_USINMU+A6_USMYV+A6_USVEI/A6_UVLRLIN RELOPER
	FROM SA6010
	LEFT JOIN SEH010 ON A6_ULINEA = EH_ULINEA AND A6_COD = EH_XCOD AND EH_XAGENCI = A6_AGENCIA AND EH_XNUMCON = A6_NUMCON
	LEFT JOIN ZEH010 ON A6_ULINEA = ZEH_ULINEA AND A6_COD = ZEH_BANCO AND ZEH_AGENCI = A6_AGENCIA AND ZEH_CONTA = A6_NUMCON
	WHERE A6_COD = '045' AND A6_AGENCIA = '00001' AND A6_NUMCON = 'LCBIS001  '
	GROUP BY A6_UVLRLIN,A6_UPRCONT,A6_UPRPRES,A6_NOME,
	A6_UFCILIN,A6_UFCFLIN,A6_USDASFA,A6_USDPF,A6_USINMU,
	A6_USMYV,A6_USVEI*/

	cQuery:= " SELECT A6_ULINEA,A6_XCOD,A6_XAGENCI,A6_XNUMCON,A6_NUMCON,A6_MOEDA,A6_UVLRLIN VALORLINEA,(A6_UPRPRES*A6_UVLRLIN)/100 PRESTAMO	,(A6_UPRCONT*A6_UVLRLIN)/100 CONTINGENCIA,A6_NOME NLINEACRED, "
	cQuery+= " A6_UFCILIN INICIO,A6_UFCFLIN FIN,MAX(ZEH_TAXA)COMISION	,MAX(EH_TAXA) INTERES,A6_USDASFA ASFALTOS,A6_USDPF DPFS,A6_USINMU INMUEBLES, "
	cQuery+= " A6_USMYV MAQUINARIA,A6_USVEI VEHICULOS,(A6_USDASFA+A6_USDPF+A6_USINMU+A6_USMYV+A6_USVEI)/NULLIF(A6_UVLRLIN,0) RELOPER,A6_USLDOPE,A6_USLDLIN "
	cQuery+= " FROM " + RetSQLname('SA6') + " SA6 "
	cQuery+= " LEFT JOIN " + RetSQLname('SEH') + " SEH "
	cQuery+= " ON A6_ULINEA = EH_ULINEA AND A6_COD = EH_XCOD AND EH_XAGENCI = A6_AGENCIA AND EH_XNUMCON = A6_NUMCON AND SEH.D_E_L_E_T_ = '' "
	cQuery+= " LEFT JOIN " + RetSQLname('ZEH') + " ZEH "
	cQuery+= " ON A6_ULINEA = ZEH_ULINEA AND A6_COD = ZEH_BANCO AND ZEH_AGENCI = A6_AGENCIA AND ZEH_CONTA = A6_NUMCON AND ZEH.D_E_L_E_T_ = ''"
	cQuery+= " WHERE A6_COD = '" + SA6->A6_COD + "' AND A6_AGENCIA = '" + SA6->A6_AGENCIA + "' AND A6_NUMCON = '" + SA6->A6_NUMCON + "' AND SA6.D_E_L_E_T_ = ''  "
	cQuery+= " GROUP BY A6_ULINEA,A6_XCOD,A6_XAGENCI,A6_XNUMCON,A6_NUMCON,A6_MOEDA,A6_UVLRLIN,A6_UPRCONT,A6_UPRPRES,A6_NOME,A6_UFCILIN,A6_UFCFLIN,A6_USDASFA,A6_USDPF,A6_USINMU,A6_USMYV,A6_USVEI,A6_USLDOPE,A6_USLDLIN "

	TCQuery cQuery New Alias "VW_LCOP"

	fImpCab(.t.)

	if ! VW_LCOP->(EoF())

		While ! VW_LCOP->(EoF())

			If nLinAtu + nTamLin > nLinFin
				fImpRod()//
				//cDescP := Posicione("SA2",1,xFilial("SA2")+VW_LCOP->DBB_FORNEC+VW_LCOP->DBB_LOJA,"A2_NOME")
				fImpCab(.f.)//CABEC
			EndIf

			getPrestamo(VW_LCOP->A6_ULINEA,SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON)

			If ! VW_DESP->(EoF())
				oPrint:SayAlign(nLinAtu, COL_GRUPO, "PRESTAMOS",     oFontDetn, 0250, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nLinAtu += nTamLin
				oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)
				oPrint:SayAlign(nLinAtu, COL_GRUPO, "Nombre",     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nLinAtu += nTamLin
				oPrint:SayAlign(nLinAtu, COL_GRUPO, "No Operacion" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_COD, "Descripcion" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu,COL_DESCR,  "Fecha inicio" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_CLVL, "Fecha fin" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_CONTA, "Destino" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_UM, "Moneda" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_LOLIZ, "Importe" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				nLinAtu += nTamLin
				oPrint:SayAlign(nLinAtu, COL_GRUPO,GETADVFVAL("SA6","A6_NOMEAGE",XFILIAL("SA6")+SA6->A6_XCOD+SA6->A6_XAGENCI+SA6->A6_XNUMCON,1,"SN"),     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)
				nLinAtu += nTamLin
				nTotBol := 0
				While ! VW_DESP->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab(.f.)//CABEC
					EndIf

					oPrint:SayAlign(nLinAtu, COL_GRUPO,VW_DESP->EH_OPERAC  ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)//posicione
					oPrint:SayAlign(nLinAtu, COL_COD, AllTrim(Posicione("SX5",1,xFilial("SX5")+"Z1"+VW_DESP->EH_UTPTRAN,"X5_DESCRI"))  ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)//posicione
					oPrint:SayAlign(nLinAtu,COL_DESCR,DTOC(SToD(VW_DESP->EH_DATA))  ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_CLVL,DTOC(SToD(VW_DESP->EH_UDTFIN))   ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_UM, cvaltochar(VW_DESP->EH_MOEDA),     oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_LOLIZ,ALLTRIM(TRANSFORM( VW_DESP->EH_VALOR,"@E 999,999,999.99"))  ,     oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nTotBol += xMoeda(VW_DESP->EH_VALOR,VW_DESP->EH_MOEDA,SA6->A6_MOEDA,VW_DESP->EH_DATA)  //XMOEDA(VW_DESP->EH_VALOR)

					aExtenso := TexToArray(AllTrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+VW_DESP->EH_UDESTRA,"X5_DESCRI")),35)
					for i := 1 to len(aExtenso)
						if i <= 1
							oPrint:SayAlign(nLinAtu, COL_CONTA, ALLTRIM(aExtenso[i])  ,     oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
						else
							nLinAtu += nTamLin
							oPrint:SayAlign(nLinAtu, COL_CONTA, ALLTRIM(aExtenso[i])  ,     oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
						endif
					next i

					nLinAtu += nTamLin
					VW_DESP->(DbSkip())
				enddo
				nLinAtu += (nTamLin * 2)
				nLinAtu += nTamLin

				oPrint:SayAlign(nLinAtu, COL_CONTA, "TOTALES PRESTAMOS",     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				oPrint:SayAlign(nLinAtu, COL_LOLIZ,ALLTRIM(TRANSFORM(nTotBol,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				nLinAtu += (nTamLin * 2)

				VW_DESP->(dbCloseArea())
			Endif

			////////////boletas
			getPoliBol(VW_LCOP->A6_ULINEA,SA6->A6_COD,SA6->A6_AGENCIA,SA6->A6_NUMCON)

			If ! VW_POLZ->(EoF())
				oPrint:SayAlign(nLinAtu, COL_GRUPO, "BOLETAS/POLIZAS",     oFontDetn, 0250, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nLinAtu += nTamLin
				oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)
				oPrint:SayAlign(nLinAtu, COL_GRUPO, "Nombre",     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				nLinAtu += nTamLin
				oPrint:SayAlign(nLinAtu, COL_GRUPO, "No Operacion" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_COD, "Descripcion" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu,COL_DESCR,  "Fecha inicio" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_CLVL, "Fecha fin" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_CONTA, "Destino" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_UM, "Moneda" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:SayAlign(nLinAtu, COL_LOLIZ, "Importe" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				nLinAtu += nTamLin
				oPrint:SayAlign(nLinAtu, COL_GRUPO,GETADVFVAL("SA6","A6_NOMEAGE",XFILIAL("SA6")+SA6->A6_XCOD+SA6->A6_XAGENCI+SA6->A6_XNUMCON,1,"SN") ,     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
				oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)
				nLinAtu += nTamLin
				nTotPres := 0
				While ! VW_POLZ->(EoF())
					If nLinAtu + nTamLin > nLinFin
						fImpRod()//
						fImpCab(.f.)//CABEC
					EndIf

					oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_POLZ->ZEH_OPERAC ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_COD,AllTrim(Posicione("SX5",1,xFilial("SX5")+"Z1"+VW_POLZ->ZEH_UTPTRA,"X5_DESCRI"))  ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu,COL_DESCR,  DTOC(SToD(VW_POLZ->ZEH_DATA))  ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_CLVL, DTOC(SToD( VW_POLZ->ZEH_DATARE))  ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_UM, CVALTOCHAR(VW_POLZ->ZEH_MOEDA) ,     oFontDet8, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
					oPrint:SayAlign(nLinAtu, COL_LOLIZ,ALLTRIM(TRANSFORM(VW_POLZ->ZEH_VALOR,"@E 999,999,999.99"))  ,     oFontDet8, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nTotPres+= xMoeda(VW_POLZ->ZEH_VALOR,VW_POLZ->ZEH_MOEDA,SA6->A6_MOEDA,VW_POLZ->ZEH_DATA) //VW_POLZ->ZEH_VALOR

					aExtenso := TexToArray(AllTrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+VW_POLZ->ZEH_UDESTR,"X5_DESCRI")),35)
					for i := 1 to len(aExtenso)
						if i <= 1
							oPrint:SayAlign(nLinAtu, COL_CONTA, ALLTRIM(aExtenso[i])  ,     oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
						else
							nLinAtu += nTamLin
							oPrint:SayAlign(nLinAtu, COL_CONTA, ALLTRIM(aExtenso[i])  ,     oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
						endif
					next i

					nLinAtu += nTamLin

					VW_POLZ->(DbSkip())
				enddo
				nLinAtu += (nTamLin * 2)
				nLinAtu += nTamLin

				oPrint:SayAlign(nLinAtu, COL_CONTA, "TOTAL BOLETA/POLIZA",    oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				oPrint:SayAlign(nLinAtu, COL_LOLIZ,ALLTRIM(TRANSFORM(nTotPres,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

				nLinAtu += (nTamLin * 2)
				VW_POLZ->(dbCloseArea())
			Endif

			nLinAtu += nTamLin
			VW_LCOP->(DbSkip())
		enddo

		nLinAtu -= nTamLin
		nLinAtu += (nTamLin * 2)
		VW_LCOP->(DbCloseArea())
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

Static Function fImpCab(lImp)
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFLogo := GetSrvProfString("Startpath","") + "lgrl01.bmp"

	if lImp
		//Iniciando Página
		oPrint:StartPage()

		//alert(cFLogo)
		oPrint:SayBitmap(025,017, cFLogo,090,045)
		//oPrint:SayBitmap( 100, 200, cFLogo, 800, 800)
		cFecha:= DTOC(ddatabase)
		//Cabeçalho

		oPrint:SayAlign(020, 460, "FECHA: " + cFecha, oFontDetN, 400, 30,  , , 0)
		oPrint:SayAlign(nLinCab, nColMeio - 180, VW_LCOP->NLINEACRED, oFontTitt, 400, 30, , PAD_CENTER, 0)
		nLinCab += (nTamLin * 3)
		oPrint:SayAlign(nLinCab, nColMeio - 120, "Expresado en " + iif(VW_LCOP->A6_MOEDA == 1,"Bolivianos","Dolares"), oFontDetN, 500, 30, , PAD_CENTER, 0)

		nLinCab += (nTamLin * 2)

		oPrint:SayAlign(nLinCab, COL_GRUPO, Alltrim(SM0->M0_NOME)+ " / "+Alltrim(SM0->M0_FILIAL)	+ " / "	+ ALLTRIM(SM0->M0_CODFIL), oFontDetN, 240, 20, , PAD_LEFT, 0)

		//Linha Separatória
		nLinCab += (nTamLin * 2)
		oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)

		//Cabeçalho das colunas
		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_GRUPO, "Valor de linea: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_GRUPO+70,ALLTRIM(TRANSFORM(VW_LCOP->VALORLINEA,"@E 999,999,999.99")) , oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinCab, COL_UM, "Fecha inicio: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_UM+55,DTOC(SToD(VW_LCOP->INICIO)), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_GRUPO, "Limite capital: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_GRUPO+70,ALLTRIM(TRANSFORM(VW_LCOP->PRESTAMO,"@E 999,999,999.99")), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinCab, COL_UM, "Fecha Fin: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_UM+55, DTOC(SToD(VW_LCOP->FIN)), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_GRUPO, "Nro Linea: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_GRUPO+70, VW_LCOP->A6_NUMCON, oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinCab, COL_UM, "% Comision: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_UM+55,ALLTRIM(TRANSFORM(VW_LCOP->COMISION,"@E 999,999,999.99")), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_GRUPO, "% Interes: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_GRUPO+70,ALLTRIM(TRANSFORM(VW_LCOP->INTERES,"@E 999,999,999.99")), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinCab, COL_UM, "Saldo Linea: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_UM+55,ALLTRIM(TRANSFORM(VW_LCOP->A6_USLDLIN,"@E 999,999,999.99")), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_GRUPO, "Saldo Capital: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_GRUPO+70,ALLTRIM(TRANSFORM(VW_LCOP->A6_USLDOPE,"@E 999,999,999.99")), oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_GRUPO, "Tipos de garantia",     oFontDetN, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinCab += nTamLin
		oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")

		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_GRUPO, "Asfaltos: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_GRUPO+70,ALLTRIM(TRANSFORM(VW_LCOP->ASFALTOS,"@E 999,999,999.99")) , oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_UM, "DPFS: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_UM+55, ALLTRIM(TRANSFORM(VW_LCOP->DPFS,"@E 999,999,999.99")) , oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_GRUPO, "Inmuebles: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_GRUPO+70,ALLTRIM(TRANSFORM(VW_LCOP->INMUEBLES,"@E 999,999,999.99")) , oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_UM, "Maquinaria: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_UM+55,ALLTRIM(TRANSFORM(VW_LCOP->MAQUINARIA,"@E 999,999,999.99")) , oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinCab += nTamLin
		oPrint:SayAlign(nLinCab, COL_GRUPO, "Vehiculos: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_GRUPO+70,ALLTRIM(TRANSFORM(VW_LCOP->VEHICULOS,"@E 999,999,999.99")) , oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_UM, "Relacion: ",     oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab + 2, COL_UM+55,ALLTRIM(TRANSFORM(VW_LCOP->RELOPER,"@E 999,999,999.99")) , oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	else
		nLinCab += (nTamLin * 5)
	endif

	nLinCab += (nTamLin * 2)

	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin,CLR_BLACK,"-1")
	//nLinCab += (nTamLin * 1.2)

	nLinCab += nTamLin

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod()//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin
	Local cTextoEsq := ''
	Local cTextoDir := ''

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

static function getPrestamo(cLinea,cCodb,cAgen,cConta)
	Local cQuery	:= ""

	If Select("VW_DESP") > 0
		VW_DESP->(dbCloseArea())
	Endif
	/*
	SELECT EH_OPERAC,EH_UTPTRAN,EH_DATA,EH_DATA,EH_UDTFIN,EH_UDESTRA,EH_VALOR,EH_MOEDA FROM SEH010 SEH
	WHERE EH_ULINEA = '1' AND EH_XCOD = '045' AND EH_XAGENCI = '00001' AND EH_XNUMCON = 'LCBIS001  '
	AND SEH.D_E_L_E_T_ = ''*/

	cQuery := "	SELECT EH_OPERAC,EH_UTPTRAN,EH_DATA,EH_DATA,EH_UDTFIN,EH_UDESTRA,EH_VALOR,EH_MOEDA "
	cQuery += " FROM " + RetSqlName("SEH") + " SEH "
	cQuery += " WHERE EH_ULINEA = '" + cLinea + "' "
	cQuery += " AND EH_XCOD = '" + cCodb + "' "
	cQuery += " AND EH_XAGENCI = '" + cAgen + "' "
	cQuery += " AND EH_XNUMCON = '" + cConta + "' "
	cQuery += " AND SEH.D_E_L_E_T_ <> '*' "

	TCQuery cQuery New Alias "VW_DESP"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return

static function getPoliBol(cLinea,cCodb,cAgen,cConta)
	Local cQuery	:= ""
	
	if cLinea == '1' .or. cLinea == '2'
		cLinea = '1'
	endif
	
	If Select("VW_POLZ") > 0
		VW_POLZ->(dbCloseArea())
	Endif
	/*
	SELECT ZEH_OPERAC,ZEH_UTPTRA,ZEH_DATA,ZEH_DATARE,ZEH_UDESTR,ZEH_VALOR,ZEH_MOEDA FROM ZEH010 ZEH
	WHERE ZEH_ULINEA = '1' AND ZEH_BANCO = '045' AND ZEH_AGENCI = '00001' AND ZEH_CONTA = 'LCBIS001  '
	AND ZEH.D_E_L_E_T_ = '' AND ZEH_STATUS = 'A'*/

	cQuery := "	SELECT ZEH_OPERAC,ZEH_UTPTRA,ZEH_DATA,ZEH_DATARE,ZEH_UDESTR,ZEH_VALOR,ZEH_MOEDA "
	cQuery += " FROM " + RetSqlName("ZEH") + " ZEH "
	cQuery += " WHERE ZEH_ULINEA = '" + cLinea + "' "
	cQuery += " AND ZEH_BANCO = '" + cCodb + "' "
	cQuery += " AND ZEH_AGENCI = '" + cAgen + "' "
	cQuery += " AND ZEH_CONTA = '" + cConta + "' "
	cQuery += " AND ZEH.D_E_L_E_T_ = '' AND ZEH_STATUS = 'A'"

	TCQuery cQuery New Alias "VW_POLZ"

	//Aviso("",cQuery,{'ok'},,,,,.t.)
return
