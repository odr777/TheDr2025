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
#Define COL_COD   095
#Define COL_DESCR   0150
#Define COL_CLVL  0180
#Define COL_CONTA  0370
#Define COL_UM	0430
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

User Function IMPGARA()
	LOCAL cString		:= "SA6"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Impresion de garantias"
	LOCAL cDesc1	    := "Impresion de garantias"
	LOCAL cDesc2	    := "conforme PE"
	LOCAL cDesc3	    := "Especifico ciabol"
	PRIVATE nomeProg 	:= "IMPGARA"
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
	PRIVATE cPerg   := "IMPGARA"   // elija el Nombre de la pregunta
	private cArquivo := ""
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.t.)

	Processa({ |lEnd| MOVD3CONF("Impresion de garantias")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'IMPGARA'
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

	cNomeAlin := ""
	cNoPolz:= ""
	nMoedTit  := ""

	cQuery:= "SELECT N1_GRUPO,N1_CBASE,'2020' ANIO,N1_DESCRIC,CONVERT(varchar,N1_UDTAVAL,23) as AVALUO,N1_VLCOMER,N1_UVLHIPO "
	cQuery+= " FROM " + RetSQLname('SN1') + " SN1 "

	if FunName() $ "MATA070"
		cQuery+= " WHERE (N1_ULINEA1 = '" + SA6->A6_NUMCON + "' or N1_ULINEA2 = '" + SA6->A6_NUMCON + "') AND N1_FILIAL = '" + xfilial("SN1") + "' AND SN1.D_E_L_E_T_ = ''  "
		cNomeAlin = SA6->A6_NOME
		cNoPolz = SA6->A6_NUMCON
		nMoedTit = SA6->A6_MOEDA

	else
		cQuery+= " WHERE (N1_UBOLPO1 = '" + ZEH->ZEH_NUMERO + "' AND N1_UBOLPO2 = '" + ZEH->ZEH_NUMERO + "') AND N1_FILIAL = '" + xfilial("SN1") + "' AND SN1.D_E_L_E_T_ = ''  "
		cNomeAlin = Posicione("SA2",1,xFilial("SA2")+ZEH->ZEH_FORNEC,"A2_NOME")
		cNoPolz = ZEH->ZEH_NUMERO
		nMoedTit = ZEH->ZEH_MOEDA

	ENDIF

	if !empty(alltrim(mv_par01))
		cQuery+= " and N1_GRUPO  LIKE '" + substr(mv_par01,1,1) +"%' "
	endif

	cQuery+= " ORDER BY N1_GRUPO"

	TCQuery cQuery New Alias "VW_LCOP"

	fImpCab(.t.,cNomeAlin,nMoedTit)

	if ! VW_LCOP->(EoF())

		oPrint:SayAlign(nLinAtu, COL_GRUPO, "Garantias",     oFontDetn, 0250, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinAtu += nTamLin
		oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)
		oPrint:SayAlign(nLinAtu, COL_GRUPO, "Nombre de entidad",     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_CLVL, "Codigo de la poliza",     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		nLinAtu += nTamLin
		oPrint:SayAlign(nLinAtu, COL_GRUPO, "Grupo" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_COD, "Activo" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu,COL_DESCR,  "Año" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_CLVL, "Nombre" ,     oFontDetn, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_CONTA, "Fecha avaluo" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_UM, "Vlr. Comercial" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_LOLIZ, "Vlr. Hipotecario" ,     oFontDetn, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinAtu += nTamLin
		oPrint:SayAlign(nLinAtu, COL_GRUPO,cNomeAlin,     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_CLVL,cNoPolz,     oFontDetn, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:Line(nLinAtu, nColIni, nLinAtu, nColFin, CLR_BLACK)
		nLinAtu += nTamLin

		nTotBolCom := 0
		nTotBolHip := 0

		nSubtotComer := 0
		nSubtotHipo := 0

		cDPF := substr(VW_LCOP->N1_GRUPO,4,4)
		cNgrupo := substr(VW_LCOP->N1_GRUPO,1,1)

		While ! VW_LCOP->(EoF())

			If nLinAtu + nTamLin > nLinFin
				fImpRod()//
				//cDescP := Posicione("SA2",1,xFilial("SA2")+VW_LCOP->DBB_FORNEC+VW_LCOP->DBB_LOJA,"A2_NOME")
				fImpCab(.f.)//CABEC
			EndIf

			if substr(VW_LCOP->N1_GRUPO,1,1) != cNgrupo //si es otro documento salta de pagina

				cGaspdf = substr(VW_LCOP->N1_GRUPO,4,4)
				cGrupo = substr(VW_LCOP->N1_GRUPO,1,1)

				cNomeGrupo := ""
				DO CASE

					CASE cGrupo = '1' //inmueble
					cNomeGrupo := "INMUEBLES"
					CASE cGrupo = '2'//inmueble
					cNomeGrupo := "INMUEBLES"
					CASE cGrupo = '4'  //equipo y maquinaria
					cNomeGrupo := "EQUIPO/MAQUINARIA"
					CASE cGrupo = '6'  // vehiculos
					cNomeGrupo := "VEHICULOS"
					CASE cGrupo = '9' .and. cGaspdf = '7' //Pignorados
					cNomeGrupo := "PIGNORADOS"
					CASE cGrupo = '9' .and. cGaspdf = '8' //DPFs
					cNomeGrupo := "DPFS"
					CASE cGrupo = '9' .and. cGaspdf = '9' //asfaltos
					cNomeGrupo := "ASFALTOS"
					OTHERWISE
				ENDCASE

				if substr(VW_LCOP->N1_GRUPO,4,4) != cDPF
					nLinAtu += (nTamLin * 1.5)

					oPrint:SayAlign(nLinAtu, COL_CLVL, "Suma " + cNomeGrupo,     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_UM,ALLTRIM(TRANSFORM(nSubtotComer,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_LOLIZ,ALLTRIM(TRANSFORM(nSubtotHipo,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nLinAtu += (nTamLin * 1.5)

					cDPF = substr(VW_LCOP->N1_GRUPO,4,4)
					cNgrupo = substr(VW_LCOP->N1_GRUPO,1,1)
				else
					nLinAtu += (nTamLin * 1.5)

					oPrint:SayAlign(nLinAtu, COL_CLVL, "Suma " + cNomeGrupo,     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_UM,ALLTRIM(TRANSFORM(nSubtotComer,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					oPrint:SayAlign(nLinAtu, COL_LOLIZ,ALLTRIM(TRANSFORM(nSubtotHipo,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

					nLinAtu += (nTamLin * 1.5)

					cNgrupo = substr(VW_LCOP->N1_GRUPO,1,1)
				endif

				nSubtotComer = 0
				nSubtotHipo = 0
			endif

			cGaspdf = substr(VW_LCOP->N1_GRUPO,4,4)
			cGrupo = substr(VW_LCOP->N1_GRUPO,1,1)

			cNomeGrupo := ""
			DO CASE

				CASE cGrupo = '1' //inmueble
				cNomeGrupo := "INMUEBLES"
				CASE cGrupo = '2'//inmueble
				cNomeGrupo := "INMUEBLES"
				CASE cGrupo = '4'  //equipo y maquinaria
				cNomeGrupo := "EQUIPO/MAQUINARIA"
				CASE cGrupo = '6'  // vehiculos
				cNomeGrupo := "VEHICULOS"
				CASE cGrupo = '9' .and. cGaspdf = '7' //Pignorados
				cNomeGrupo := "PIGNORADOS"
				CASE cGrupo = '9' .and. cGaspdf = '8' //DPFs
				cNomeGrupo := "DPFS"
				CASE cGrupo = '9' .and. cGaspdf = '9' //asfaltos
				cNomeGrupo := "ASFALTOS"
				OTHERWISE
			ENDCASE

			oPrint:SayAlign(nLinAtu, COL_GRUPO,cNomeGrupo ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)//posicione
			oPrint:SayAlign(nLinAtu, COL_COD, VW_LCOP->N1_CBASE  ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)//posicione
			oPrint:SayAlign(nLinAtu,COL_DESCR, VW_LCOP->ANIO  ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_CLVL, VW_LCOP->N1_DESCRIC   ,     oFontDet8, 150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_CONTA, VW_LCOP->AVALUO,     oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_UM,ALLTRIM(TRANSFORM( VW_LCOP->N1_VLCOMER,"@E 999,999,999.99"))  ,     oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_LOLIZ,ALLTRIM(TRANSFORM( VW_LCOP->N1_UVLHIPO,"@E 999,999,999.99"))  ,     oFontDet8, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			//nTotBol += xMoeda(VW_LCOP->EH_VALOR,VW_LCOP->EH_MOEDA,SA6->A6_MOEDA,VW_LCOP->EH_DATA)  //XMOEDA(VW_LCOP->EH_VALOR)

			/*aExtenso := TexToArray(AllTrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+VW_LCOP->EH_UDESTRA,"X5_DESCRI")),35)
			for i := 1 to len(aExtenso)
			if i <= 1
			oPrint:SayAlign(nLinAtu, COL_CONTA, ALLTRIM(aExtenso[i])  ,     oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			else
			nLinAtu += nTamLin
			oPrint:SayAlign(nLinAtu, COL_CONTA, ALLTRIM(aExtenso[i])  ,     oFontDet8, 0300, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			endif
			next i*/
			nSubtotComer += VW_LCOP->N1_VLCOMER
			nSubtotHipo += VW_LCOP->N1_UVLHIPO
			nTotBolCom += VW_LCOP->N1_VLCOMER
			nTotBolHip += VW_LCOP->N1_UVLHIPO

			nLinAtu += nTamLin
			VW_LCOP->(DbSkip())
		enddo

		nLinAtu += (nTamLin * 1.5)
		oPrint:SayAlign(nLinAtu, COL_CLVL, "Suma " + cNomeGrupo,     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinAtu, COL_UM,ALLTRIM(TRANSFORM(nSubtotComer,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinAtu, COL_LOLIZ,ALLTRIM(TRANSFORM(nSubtotHipo,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinAtu += (nTamLin * 1.5)
		nLinAtu += nTamLin

		oPrint:SayAlign(nLinAtu, COL_CLVL, "TOTALES",     oFontDetN, 0130, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinAtu, COL_UM,ALLTRIM(TRANSFORM(nTotBolCom,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinAtu, COL_LOLIZ,ALLTRIM(TRANSFORM(nTotBolHip,"@E 999,999,999.99")) ,     oFontDN, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		nLinAtu += (nTamLin * 2)
		VW_LCOP->(DbCloseArea())
	Endif

	nLinAtu += nTamLin

	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod()
	EndIf

	For nX := 1 to 10

		If ! File(cArquivo)

			Sleep(500)

		EndIf

	Next nX
	//Mostrando o relatório
	oPrint:Preview()

	RestArea(aArea)

RETURN

Static Function fImpCab(lImp,cNomLinea,nMoedTit)
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
		oPrint:SayAlign(nLinCab, nColMeio - 180, cNomLinea, oFontTitt, 400, 30, , PAD_CENTER, 0)
		nLinCab += (nTamLin * 3)
		oPrint:SayAlign(nLinCab, nColMeio - 120, "Expresado en " + iif(nMoedTit == 1,"Bolivianos","Dolares"), oFontDetN, 500, 30, , PAD_CENTER, 0)

		nLinCab += (nTamLin * 2)

		oPrint:SayAlign(nLinCab, COL_GRUPO, Alltrim(SM0->M0_NOME)+ " / "+Alltrim(SM0->M0_FILIAL)	+ " / "	+ ALLTRIM(SM0->M0_CODFIL), oFontDetN, 240, 20, , PAD_LEFT, 0)

		//Linha Separatória
		/*nLinCab += (nTamLin * 2)
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
		*/
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

	xPutSX1(cPerg,"01","Grupo ?" , "Grupo ?" ,"Grupo ?" ,"MV_CH1","C",4,0,0,"G","","SN1GR","","","mv_par01","","","","","","","","")

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
