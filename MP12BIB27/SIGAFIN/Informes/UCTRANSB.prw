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
#Define COL_ITEM 0220
#Define COL_DESCR   0270
#Define COL_CLVL  0330
#Define COL_CONTA  0420
#Define COL_LOLIZ 0500

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  UCTRANSB ºAutor ³ERICK ETCHEVERRY º   º Date 20/05/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion de transferencia bancaria			              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION 		 SRL	                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function UCTRANSB(_hNumero)
	LOCAL cString		:= "SCP"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Impresion transferencia bancaria"
	LOCAL cDesc1	    := "Impresion transferencia bancaria"
	LOCAL cDesc2	    := "conforme PE"
	// LOCAL cDesc3	    := "Especifico Union"
	PRIVATE nomeProg 	:= "UCTRANSB"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont := "Arial"
	Private oFontDet  := TFont():New(cNomeFont,07,07,,.F.,,,,.T.,.F.)
	Private oFontDet8  := TFont():New(cNomeFont,10,10,,.F.,,,,.T.,.F.)
	Private oFontDetN := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontDetNN := TFont():New(cNomeFont,10,10,,.T.,,,,.F.,.F.)
	Private oFontDN := 	 TFont():New(cNomeFont,07,07,,.T.,,,,.F.,.F.)
	Private oFontRod  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontRodn := 	 TFont():New(cNomeFont,10,10,,.T.,,,,.F.,.F.)
	Private oFontTitt:= TFont():New(cNomeFont,11,11,,.T.,,,,.F.,.F.)
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 		:= 0
	PRIVATE cPerg   := "UC0020"   // elija el Nombre de la pregunta

	CriaSX1(cPerg)
	PERGUNTE(cPerg,.F.)

	If Empty(_hNumero)
		PERGUNTE(cPerg,.t.)
		cDocDe	:=mv_par01
		cDocA	:=mv_par02

	Else
		cDocDe	:=_hNumero
		cDocA	:=_hNumero
	Endif

	Processa({ |lEnd| MOVD3CONF("Impresion nota de entrega")},"Imprimindo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

	Pergunte("AFI100",.F.)
Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'BAJNOTA'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zTtransb_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
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
	Private nLinFin   := 325
	Private nColIni   := 010
	Private nColFin   := 570
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2
	Private cDoc

	If Select("QRY") > 0
		dbCloseArea()
	Endif

	cQuery := "SELECT E5_DTDIGIT,E5_NUMCHEQ,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_VALOR,E5_HISTOR,E5_BENEF,E5_XCORREL "
	cQuery += " FROM "+ RetSqlName("SE5") + " SE5 "
	cQuery += " WHERE E5_FILIAL = '"+xFilial("SE5")+"'"
	cQuery += " AND E5_NUMCHEQ BETWEEN '"+cDocDe+"' AND '" + cDocA + "'"
	cQuery += " AND SE5.D_E_L_E_T_ <> '*'  AND E5_RECPAG = 'P' ORDER BY E5_NUMCHEQ"

	TCQuery cQuery New Alias "QRY"

	If Select("QRY2") > 0
		dbCloseArea()
	Endif

	cQuery2 := "SELECT E5_DTDIGIT,E5_NUMCHEQ,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_VALOR,E5_XCORREL "
	cQuery2 += " FROM "+ RetSqlName("SE5") + " SE5 "
	cQuery2 += " WHERE E5_FILIAL = '"+xFilial("SE5")+"'"
	cQuery2 += " AND E5_DOCUMEN BETWEEN '"+cDocDe+"' AND '" + cDocA + "'"
	cQuery2 += " AND SE5.D_E_L_E_T_ <> '*' AND E5_RECPAG = 'R' ORDER BY E5_DOCUMEN"

	TCQuery cQuery2 New Alias "QRY2"

	if ! QRY->(EoF())

		While ! QRY->(EoF())
			fImpCab()
			//fImpRod()
			QRY->(DbSkip())
			QRY2->(DbSkip())
		enddo

	Endif

	//Mostrando o relatório
	oPrint:Preview()

	QRY->(DbCloseArea())
	QRY2->(DbCloseArea())

	RestArea(aArea)

RETURN

Static Function fImpCab()//   //QRE5->E5_RECPAG //QRE5->E5_FILIAL
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local cFLogo := GetSrvProfString("Startpath","") + "logo.bmp"
	Local cNombCom := ""

	//Iniciando Página
	oPrint:StartPage()

	//alert(cFLogo)
	oPrint:SayBitmap(025,017, cFLogo,090,045)
	//oPrint:SayBitmap( 100, 200, cFLogo, 800, 800)
	cFecha:= DTOC(DDATABASE)
	//Cabeçalho

	cCidade := alltrim(SM0->M0_NOMECOM)
	oPrint:SayAlign(020, 460, "Fecha Imp: " + cFecha, oFontDetN, 400, 30,  , , 0)
	cTexto := "TRANSFERENCIA BANCARIA"

	oPrint:SayAlign(nLinCab, nColMeio - 180, cTexto, oFontTitt, 400, 30, , PAD_CENTER, 0)

	nLinCab += (nTamLin * 2)
	nLinCab += (nTamLin * 2)
	oPrint:SayAlign(nLinCab, COL_GRUPO	 , cCidade+", "+dtoc( STOD(QRY->E5_DTDIGIT)) , oFontDetN, 500, 30, , PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.2)
	oPrint:SayAlign(nLinCab, COL_GRUPO	 , "Documento: "+Alltrim(QRY->E5_NUMCHEQ) , oFontDetN, 500, 30, , PAD_LEFT, 0)
	IF !empty(alltrim(QRY->E5_XCORREL))
		nLinCab += (nTamLin * 1.2)
		oPrint:SayAlign(nLinCab, COL_GRUPO	 , "NRO: "+Alltrim(QRY->E5_XCORREL) , oFontDetN, 500, 30, , PAD_LEFT, 0)
	endif
	nLinCab += (nTamLin * 3)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)
	nLinCab += (nTamLin * 1.2)
	oPrint:SayAlign(nLinCab, COL_GRUPO	 , "BANCO ORIGEN", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_ITEM	 , "CODIGO", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR	 , "AGENCIA", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CLVL	 , "CUENTA", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CONTA	 , "MONEDA", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_LOLIZ	 , "VALOR", oFontDetNN, 500, 30, , PAD_LEFT, 0)

	nLinCab += (nTamLin * 1.2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)
	nLinCab += (nTamLin * 2)

	SA6->(dbSetOrder(1))
	SA6->(dbGoTop())
	SA6->(dbSeek(xFILIAL("SA6")+QRY->E5_BANCO+QRY->E5_AGENCIA+QRY->E5_CONTA))   //FILIAL+COD+AGENCIA+NUMCON

	oPrint:SayAlign(nLinCab, COL_GRUPO, ALLTRIM(SA6->A6_NOME),     oFontDet8, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_ITEM, alltrim(QRY->E5_BANCO),     oFontDet8, 0150, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR, QRY->E5_AGENCIA,     oFontDet8, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CLVL,QRY->E5_CONTA,     oFontDet8, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CONTA, cvaltochar(SA6->A6_MOEDA) ,     oFontDet8, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_LOLIZ,  ALLTRIM(TRANSFORM(QRY->E5_VALOR ,"@E 999,999,999,999.99")),     oFontDet8, 0170, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 2)
	nLinCab += (nTamLin * 1.2)

	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)
	nLinCab += (nTamLin * 1.2)
	oPrint:SayAlign(nLinCab, COL_GRUPO	 , "BANCO DESTINO", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_ITEM	 , "CODIGO", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR	 , "AGENCIA", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CLVL	 , "CUENTA", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CONTA	 , "MONEDA", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_LOLIZ	 , "VALOR", oFontDetNN, 500, 30, , PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.2)
	oPrint:Line(nLinCab, nColIni, nLinCab,nColFin)
	nLinCab += (nTamLin * 2)

	SA6->(dbSetOrder(1))
	SA6->(dbGoTop())
	SA6->(dbSeek(xFILIAL("SA6")+QRY2->E5_BANCO+QRY2->E5_AGENCIA+QRY2->E5_CONTA))   //FILIAL+COD+AGENCIA+NUMCON

	oPrint:SayAlign(nLinCab, COL_GRUPO	 ,  ALLTRIM(SA6->A6_NOME) , oFontDet8, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_ITEM	 , alltrim(QRY2->E5_BANCO) , oFontDet8, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR	 , QRY2->E5_AGENCIA , oFontDet8, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CLVL	 , QRY2->E5_CONTA , oFontDet8, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CONTA	 ,  cvaltochar(SA6->A6_MOEDA) , oFontDet8, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_LOLIZ	 ,  ALLTRIM(TRANSFORM(QRY2->E5_VALOR ,"@E 999,999,999,999.99"))  , oFontDet8, 500, 30, , PAD_LEFT, 0)

	nLinCab += (nTamLin * 2)
	nLinCab += (nTamLin * 2)
	oPrint:SayAlign(nLinCab, COL_GRUPO	 ,  "Historial: "+Alltrim(QRY->E5_HISTOR) , oFontDetN, 500, 30, , PAD_LEFT, 0)
	nLinCab += (nTamLin * 2)
	oPrint:SayAlign(nLinCab, COL_GRUPO	 ,  "Beneficiario: "+Alltrim(QRY->E5_BENEF) , oFontDetN, 500, 30, , PAD_LEFT, 0)
	nLinCab += (nTamLin * 2)
	nLinCab += (nTamLin * 2)
	nLinCab += (nTamLin * 2)
	oPrint:SayAlign(nLinCab, COL_GRUPO	 ,  "___________________________" , oFontDetN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, 390	 ,  "___________________________" , oFontDetN, 500, 30, , PAD_LEFT, 0)
	nLinCab += (nTamLin * 2)
	oPrint:SayAlign(nLinCab, COL_GRUPO	+40 ,  "Emitido por" , oFontDetN, 500, 30, , PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, 390 +40 ,  "Retirado por" , oFontDetN, 500, 30, , PAD_LEFT, 0)

	nLinCab += nTamLin

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod()//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin
	Local cTextoEsq := ''
	Local cTextoDir := ''

	nLinRod += (nTamLin * 2)
	oPrint:SayAlign(nLinRod, nColIni, 'EMITIDO POR:', oFontRodn, 400, 05, CLR_BLACK, PAD_LEFT,  0)
	oPrint:SayAlign(nLinRod, COL_DESCR+30, 'BENEFICIARIO:', oFontRodn, 400, 05, CLR_BLACK, PAD_LEFT,  0)
	oPrint:SayAlign(nLinRod, COL_CONTA+30, 'AUTORIZADO POR:', oFontRodn, 400, 05, CLR_BLACK, PAD_LEFT,  0)

	nLinRod += 7
	oPrint:SayAlign(nLinRod, nColIni+27,CUSERNAME  , oFontRodn, 100, 05, CLR_BLACK, , 0)
	nLinRod += 20
	oPrint:Box( nLinRod, COL_GRUPO, 5, nColFin, "-2")//sub detalle
	nLinRod += 7
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

Static Function CriaSX1(cPerg)  // Crear Preguntas
	/*Esta funcion al ejecutarse crea los registro en la tabla SX1, asi de esta manera podemos utilizar los parametros
	Tomar en cuanta que deben cambiar los parametros segun el caso, se debe indicar cada uno las preguntas con toda las
	especificaciones,
	*/
	xPutSX1(cPerg,"01","¿De documento?"	, "¿De documento?"		,"¿De documento?"	,"MV_CH1","C",20,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,""   ,"")
	xPutSX1(cPerg,"02","¿A documento?" 	, "¿A documento?"		,"¿A documento?"	,"MV_CH2","C",20,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,""   ,"")
	//xPutSX1(cPerg,"03","¿Serie?" 		, "¿Serie?"			,"¿Serie?"		,"MV_CH3","C",03,0,0,"G","","","","","mv_par03",""       ,""            ,""        ,""     ,""   ,"")
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
