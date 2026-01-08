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
#Define COL_DESCR   0110
#Define COL_FABRIC  0160
#Define	COL_LOTE 	0230
#Define	COL_UBICACION	0360
#Define	COL_VALIDEZ		0410
#Define	COL_SERIE		0500
#Define	COL_CANTIDAD	0580
#Define	COL_COSTO		0645
#Define	COL_TOTAL		0690

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  COMPCAR  ºAutor  ³ERICK ETCHEVERRY º   º Date 07/09/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion de compensacion entre cartera                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AGROCENTRO SRL	                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COMPCAR()
	LOCAL cString		:= "SD3"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Movimientos internos"
	LOCAL cDesc1	    := "Relatorio de mov. Internos"
	LOCAL cDesc2	    := "conforme parametro"
	LOCAL cDesc3	    := "Especifico AGROCENTRO"
	PRIVATE nomeProg 	:= "COMPCAR"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont 	:= "Courier New"
	Private oFontDet  	:= TFont():New(cNomeFont,11,11,,.F.,,,,.T.,.F.)
	Private oFontDetN 	:= TFont():New(cNomeFont,11,11,,.T.,,,,.F.,.F.)
	Private oFontRod 	 := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTit  	:= TFont():New(cNomeFont,11,11,,.F.,,,,.T.,.F.)
	Private oFontTit2  	:= TFont():New(cNomeFont,11,11,,.T.,,,,.F.,.F.)
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 		:= 0

	PRIVATE cPerg   := "COMPCAR"   // elija el Nombre de la pregunta
	CriaSX1(cPerg)	// Si no esta creada la crea

	If funname() == 'FINA450'
		cxPar01 := SE5->E5_IDENTEE
		cxPar02 := SE5->E5_IDENTEE
		cxPar03 := SE5->E5_FILIAL
		cxPar04 := SE5->E5_FILIAL
		cxPar05 := SE5->E5_DATA
		cxPar06 := SE5->E5_DATA
	Else
		Pergunte(cPerg,.T.)
		cxPar01 := MV_PAR01
		cxPar02 := MV_PAR02
		cxPar03 := MV_PAR03
		cxPar04 := MV_PAR04
		cxPar05 := MV_PAR05
		cxPar06 := MV_PAR06
	Endif

	Processa({ |lEnd| MOVD3CONF("Impresion de compensacion entre cartera")},"Imprimiendo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'compcarte'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := cFilename+"Rel_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
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
	Private nLinAtu   := 000
	Private nTamLin   := 010
	Private nLinFin   := 565
	Private nColIni   := 010
	Private nColFin   := 750
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2

	/*SELECT  E5_FILIAL,E5_IDENTEE,E5_DATA,E5_TIPO,E5_MOEDA,E5_VALOR,E5_RECPAG,E5_CLIFOR,E5_BENEF,E5_HISTOR,E5_PREFIXO,
E5_NUMERO,E5_TABORI,*
FROM SE5010 SE5
WHERE
E5_MOTBX = 'CEC' AND
E5_IDENTEE >= '' AND
E5_IDENTEE <= 'ZZZZZZ' AND
E5_IDENTEE <> '      ' AND
E5_DATA BETWEEN '' AND 'ZZZZZZZZ' AND
E5_TIPODOC = 'BA' AND
SE5.D_E_L_E_T_ = ' '*/
	//alert("")

	If Select("VW_CMPE5") > 0
		dbCloseArea()
	Endif

	cQuery := "	SELECT  E5_FILIAL,E5_IDENTEE,E5_DATA,E5_TIPO,E5_MOEDA,E5_VALOR,case E5_RECPAG when 'R' THEN 'CXC' WHEN 'P' THEN 'CXP' END E5_ORIGEN "
	cQuery += " ,E5_CLIFOR,E5_BENEF,E5_HISTOR,E5_PREFIXO,E5_NUMERO,E5_TABORI,E5_UGLOSA "
	cQuery += "  FROM " + RetSqlName("SE5") + " SE5 "
	cQuery += "  WHERE E5_DATA BETWEEN '" + DtoS(cxPar05) + "' AND '" + DtoS(cxPar06) + "' "
	cQuery += "  AND SE5.D_E_L_E_T_ = ' ' "
	cQuery += "  AND E5_FILIAL BETWEEN '" + cxPar03 + "' AND '" + cxPar04 + "' "
	cQuery += "  AND E5_IDENTEE BETWEEN '" + cxPar01 + "' AND '" + cxPar02 + "' AND E5_MOTBX = 'CEC' "
	cQuery += "  AND E5_TIPODOC = 'BA' AND E5_IDENTEE <> '      ' "
	cQuery += "  ORDER BY E5_IDENTEE, E5_TABORI "

	TCQuery cQuery New Alias "VW_CMPE5"

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	Count To nTotal
	ProcRegua(nTotal)
	VW_CMPE5->(DbGoTop())
	nAtual := 0

	fImpCab()
	//PRINTANDO ITEMS
	cDoc := VW_CMPE5->E5_IDENTEE
	//totales
	nTotQuant := 0
	nTotCusto := 0
	nTotTot := 0

	While ! VW_CMPE5->(EoF())

		nAtual++
		
		if VW_CMPE5->E5_IDENTEE != cDoc //si es otro documento salta de pagina
			fImpRod(nTotQuant,nTotCusto,nTotTot,.t.)//
			fImpCab()//CABEC
			nTotQuant := 0
			nTotCusto := 0
			nTotTot := 0
			
			cDoc := VW_CMPE5->E5_IDENTEE
		else
			If nLinAtu + nTamLin > nLinFin
				fImpRod(,,,.f.)//
				fImpCab()//CABEC
			EndIf
			cDoc := VW_CMPE5->E5_IDENTEE
		endif

		//Imprimindo a linha atual
		oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_CMPE5->E5_NUMERO , oFontDet, 00200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_DESCR, VW_CMPE5->E5_PREFIXO,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_FABRIC, VW_CMPE5->E5_CLIFOR,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_LOTE, VW_CMPE5->E5_BENEF,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_UBICACION, VW_CMPE5->E5_MOEDA,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_VALIDEZ, ALLTRIM(TRANSFORM(ROUND(VW_CMPE5->E5_VALOR,2),"@E 999,999,999.99")) ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_SERIE, VW_CMPE5->E5_TIPO ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_CANTIDAD, VW_CMPE5->E5_ORIGEN ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		//oPrint:SayAlign(nLinAtu, COL_TOTAL, ALLTRIM(TRANSFORM(_nValor,"@E 999,999,999.99")),  oFontDet, 0400, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		//oPrint:SayAlign(nLinAtu, COL_SERIE, VW_CMPE5->D3_LOCAL+"-"+POSICIONE("NNR",1,VW_CMPE5->D3_FILIAL+VW_CMPE5->D3_LOCAL,"NNR_DESCRI"),  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		//TOTALIZANDO
		nTotQuant += 0
		nTotCusto += 0

		nLinAtu += nTamLin

		VW_CMPE5->(DbSkip())

	EndDo

	if nAtual == 0
		return
	endif
	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod(nTotQuant,nTotCusto,nTotTot,.t.)
	EndIf

	//Mostrando o relatório
	oPrint:Preview()
	VW_CMPE5->(DbCloseArea())
	RestArea(aArea)

RETURN

Static Function fImpCab()
	Local cTexto   := ""
	Local nLinCab  := 050
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local aEmp 			:= U_SM0Cab(cEmpAnt,cFilAnt)

	
	//Iniciando Página
	oPrint:StartPage()

	oPrint:SayBitmap(0040,0015,aEmp[01][02],0120,050 )

	//Cabeçalho
	cTexto := "COMPENSACION CARTERA"   //Compensacion Cartera
	oPrint:SayAlign(nLinCab, nColMeio - 120, cTexto, oFontTit2, 240, 20, CLR_BLACK, PAD_CENTER, 0)
	nLinCab += (nTamLin * 4.1)
	oPrint:SayAlign(nLinCab, COL_GRUPO, Alltrim(SM0->M0_NOME)+" / "+Alltrim(SM0->M0_FILIAL)	+ " / "	+ ALLTRIM(SM0->M0_CODFIL), oFontTit, 400, 20, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "Nro. Comp. Cartera: ", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, nDetCab + 50, ALLTRIM(VW_CMPE5->E5_IDENTEE) , oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	//derecha
	oPrint:SayAlign(nLinCab, nDerCab, "Fecha:", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COSTO, DTOC(SToD(VW_CMPE5->E5_DATA)) , oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "Observacion: ", oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, nDetCab + 50, ALLTRIM(VW_CMPE5->E5_UGLOSA) , oFontTit, 240, 20, CLR_BLACK, PAD_LEFT, 0)
	
	//Linha Separatória
	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab, nColFin, CLR_GRAY)

	//Cabeçalho das colunas
	nLinCab += nTamLin
	oPrint:SayAlign(nLinCab, COL_GRUPO, "NUMERO",     oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR, "SERIE", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_FABRIC,"COD.CLI/PROV", oFontDetN, 0100, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_LOTE, "CLI/PROV", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_UBICACION, "MONEDA", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_VALIDEZ, "VALOR", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_SERIE, "TIPO", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CANTIDAD, "ORIGEN", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	/*oPrint:SayAlign(nLinCab, COL_COSTO, "COSTO", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_TOTAL, "TOTAL", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)*/

	nLinCab += nTamLin

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod(nTotQuant,nTotCusto,nTotTot,lTotaliz)//RODAPE PIE PAGINA
	Local nLinRod   := nLinFin + nTamLin
	Local cTextoEsq := ''
	Local cTextoDir := ''

	//Linha Separatória
	//oPrint:Line(nLinRod, nColIni, nLinRod, nColFin, CLR_GRAY)
	if lTotaliz

		oPrint:SayAlign(550, COL_SERIE, "_____________" , oFontRod, 200, 05, CLR_BLACK, ,  0)
		oPrint:SayAlign(550, COL_DESCR, "_____________", oFontRod, 0250, 05, CLR_BLACK, , 0)
			//Imprimindo os textos
		oPrint:SayAlign(560, COL_SERIE, "Elaborado por" , oFontRod, 200, 05, CLR_BLACK, ,  0)
		oPrint:SayAlign(560, COL_DESCR, "Revisado por", oFontRod, 0250, 05, CLR_BLACK, , 0)

	endif

	oPrint:Line(590, nColIni, 585, nColFin, CLR_BLACK)

	//Dados da Esquerda e Direita
	cTextoEsq := dToC(dDataGer) + "    " + cHoraGer + "    " + FunName() + "    " + cNomeUsr
	cTextoDir := "Página " + cValToChar(nPagAtu)

	//Imprimindo os textos
	oPrint:SayAlign(592, nColIni,    cTextoEsq, oFontRod, 200, 05, CLR_BLACK, PAD_LEFT,  0)
	oPrint:SayAlign(592, nColFin-70, cTextoDir, oFontRod, 60, 05, CLR_BLACK, PAD_RIGHT, 0)

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

	xPutSx1(cPerg,"01","De documento ?","De documento ?","De documento ?","mv_ch1","C",6,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A documento ?","A documento ?","A documento ?","mv_ch2","C",6,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De sucursal ?","De sucursal ?","De sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A sucursal ?","A sucursal ?","A sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De fecha ?","De fecha ?","De fecha ?",         "mv_ch5","D",08,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A fecha ?","A fecha ?","A fecha ?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")

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
