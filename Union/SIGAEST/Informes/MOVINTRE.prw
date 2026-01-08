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
#Define COL_DESCR   00100
#Define COL_FABRIC  0160
#Define	COL_LOTE 	0190
#Define	COL_SUBLOTE		0290
#Define	COL_UBICACION	0300
#Define	COL_CANTIDAD	0350
#Define	COL_COSTO		0400
#Define	COL_TOTAL		0455
#Define COL_VALIDEZ    0540
#Define COL_FECHA 0610

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

User Function MOVINTRE()
	LOCAL cString		:= "SD3"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Movimientos internos resumido"
	LOCAL cDesc1	    := "Relatorio de mov. Internos resumen"
	LOCAL cDesc2	    := "conforme parametro"
	LOCAL cDesc3	    := "Especifico UNION"
	PRIVATE nomeProg 	:= "MOVINT"
	PRIVATE lEnd        := .F.
	Private oPrint
	PRIVATE lFirstPage  := .T.
	Private cNomeFont := "Courier New"
	Private oFontDet  := TFont():New(cNomeFont,07,07,,.F.,,,,.T.,.F.)
	Private oFontDetN := TFont():New(cNomeFont,08,08,,.T.,,,,.F.,.F.)
	Private oFontRod  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	Private oFontTit  := TFont():New(cNomeFont,08,08,,.F.,,,,.T.,.F.)
	PRIVATE cContato    := ""
	PRIVATE cNomFor     := ""
	Private nReg 			:= 0
	PRIVATE cPerg   := "MOVINTRE"   // elija el Nombre de la pregunta
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
	cArquivo  := "zTstRel_a" + dToS(date()) + "_" + StrTran(time(), ':', '-')
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
	Private nLinFin   := 585
	Private nColIni   := 010
	Private nColFin   := 750
	Private dDataGer  := Date()
	Private cHoraGer  := Time()
	Private nPagAtu   := 1
	Private cNomeUsr  := UsrRetName(RetCodUsr())
	Private nColMeio  := (nColFin-nColIni)/2

	//alert("")
	If Select("VW_D3") > 0
		dbCloseArea()
	Endif

	cTm := ""
	if MV_PAR10 == 1
		cTm = "D" //ENTRADA
	elseif MV_PAR10 == 2
		cTm = "R"//SALIDA
	elseif MV_PAR10 == 3
		cTm = "P"//PRODUCCION
	endif

	cQuery := "	SELECT D3_CC,SUM(D3_CUSTO1) D3_CUSTO1,D3_CF,D3_DOC, D3_USUARIO,D3_TM,D3_FILIAL, "
	cQuery += " SUM(D3_QUANT) D3_QUANT,D3_EMISSAO,SUM(D3_CUSTO2) D3_CUSTO2,D3_UOBSERV "
	cQuery += "  FROM " + RetSqlName("SD3") + " SD3 "
	cQuery += "  JOIN " + RetSqlName("SF5") + " SF5 "
	cQuery += "  ON F5_CODIGO = D3_TM AND F5_TIPO = '" + cTm +"'"
	cQuery += "  WHERE D3_EMISSAO BETWEEN '" + DtoS(MV_PAR07) + "' AND '" + DtoS(MV_PAR08) + "' "
	cQuery += "  AND SD3.D_E_L_E_T_ = ' ' "
	cQuery += "  AND D3_FILIAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQuery += "  AND D3_DOC BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
	cQuery += "  AND D3_NUMSERI BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	cQuery += " GROUP BY D3_DOC,D3_CC,D3_CF,D3_USUARIO,D3_TM,D3_FILIAL,D3_EMISSAO,D3_UOBSERV "
	cQuery += "  ORDER BY D3_DOC "

	TCQuery cQuery New Alias "VW_D3"

	if EMPTY(MV_PAR09)
		MV_PAR09 := "02"
	ENDIF

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	Count To nTotal
	ProcRegua(nTotal)
	VW_D3->(DbGoTop())
	nAtual := 0

	fImpCab()
	//PRINTANDO ITEMS
	cDoc := VW_D3->D3_DOC
	//totales
	nTotQuant := 0
	nTotCusto := 0

	While ! VW_D3->(EoF())

		nAtual++

		//Imprimindo a linha atual
		oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_D3->D3_DOC , oFontDet, 00200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_DESCR, VW_D3->D3_TM,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_FABRIC, VW_D3->D3_CC,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		cCcusto:= ""
		dbSelectArea("CTT")
		dbSetOrder(1)
		If MsSeek(xFilial("CTT")+VW_D3->D3_CC)
			cCcusto := CTT->CTT_DESC01
		ENDIF
		cVar   := VW_D3->D3_UOBSERV
		oPrint:SayAlign(nLinAtu, COL_LOTE, cCcusto,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu,COL_UBICACION , ALLTRIM(DTOC(STOD(VW_D3->D3_EMISSAO))),  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

		oPrint:SayAlign(nLinAtu, COL_CANTIDAD, ALLTRIM(TRANSFORM(VW_D3->D3_QUANT,"@E 9,999,999")) ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		_nValor := iif(MV_PAR09 == 1,VW_D3->D3_CUSTO1,VW_D3->D3_CUSTO2)//xMoeda(iif(empty(nCusto),SD3->D3_CUSTO2,nCusto),2,MV_PAR09,VW_D3->D3_EMISSAO)
		oPrint:SayAlign(nLinAtu, COL_COSTO, ALLTRIM(TRANSFORM(_nValor,"@E 9,999,999.99")),  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_TOTAL, ALLTRIM(TRANSFORM((_nValor * VW_D3->D3_QUANT),"@E 999,999,999.99")),  oFontDet, 0250, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		oPrint:SayAlign(nLinAtu, COL_VALIDEZ, cVar ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
		//TOTALIZANDO
		nTotQuant += VW_D3->D3_QUANT
		nTotCusto += _nValor

		nLinAtu += nTamLin

		VW_D3->(DbSkip())

	EndDo

	if nAtual == 0
		return
	endif
	//Se ainda tiver linhas sobrando na página, imprime o rodapé final
	If nLinAtu <= nLinFin
		fImpRod(nTotQuant,nTotCusto,.t.)
	EndIf
	IF lRetCF
		alert("Hay documentos que NO son movimientos internos")
	endif
	//Mostrando o relatório
	oPrint:Preview()
	VW_D3->(DbCloseArea())
	RestArea(aArea)

RETURN

Static Function fImpCab()
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540

	//Iniciando Página
	oPrint:StartPage()

	//Cabeçalho
	cTexto := "Movimientos internos"
	oPrint:SayAlign(nLinCab, nColMeio - 120, cTexto, oFontTit, 240, 20, CLR_GRAY, PAD_CENTER, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, Alltrim(SM0->M0_NOME)+" / "+Alltrim(SM0->M0_FILIAL)	+ " / "	+ ALLTRIM(SM0->M0_CODFIL), oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, "Usuario:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, nDetCab, ALLTRIM(VW_D3->D3_USUARIO) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
	//derecha
	oPrint:SayAlign(nLinCab, nDerCab, "Fecha:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_FECHA, DTOC(SToD(VW_D3->D3_EMISSAO)) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
	//Linha Separatória
	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab, nColFin, CLR_GRAY)

	//Cabeçalho das colunas
	nLinCab += nTamLin
	oPrint:SayAlign(nLinCab, COL_GRUPO, "DOCUMENTO",     oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_DESCR, "TPMOVIMIENTO", oFontDetN, 0080, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_FABRIC,"CENTRO COSTO", oFontDetN, 0090, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	//oPrint:SayAlign(nLinCab, COL_LOTE, "CCOSTO", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_UBICACION, "EMISION", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab,COL_VALIDEZ , "OBSERVACION", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CANTIDAD, "CANTIDAD", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_COSTO, "COSTO", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_TOTAL, "TOTAL", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)

	nLinCab += nTamLin

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3
Return

Static Function fImpRod(nTotQuant,nTotCusto,lTotaliz)//RODAPE PIE PAGINA
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
	if lTotaliz
		//Imprimindo os textos
		oPrint:SayAlign(nLinRod, COL_CANTIDAD, ALLTRIM(TRANSFORM(nTotQuant,"@E 999,999,999")) , oFontRod, 200, 05, CLR_GRAY, ,  0)
		oPrint:SayAlign(nLinRod, COL_COSTO, ALLTRIM(TRANSFORM(nTotCusto,"@E 9,999,999.99")), oFontRod, 0200, 05, CLR_GRAY, , 0)
		oPrint:SayAlign(nLinRod, COL_TOTAL, ALLTRIM(TRANSFORM(nTotQuant * nTotCusto,"@E 9,999,999.99")), oFontRod, 0200, 05, CLR_GRAY, , 0)

		nLinRod += 10
	endif
	//Imprimindo os textos
	oPrint:SayAlign(nLinRod, nColIni,    cTextoEsq, oFontRod, 200, 05, CLR_GRAY, PAD_LEFT,  0)
	oPrint:SayAlign(nLinRod, nColFin-50, cTextoDir, oFontRod, 60, 05, CLR_GRAY, PAD_RIGHT, 0)

	//Finalizando a página e somando mais um
	oPrint:EndPage()
	nPagAtu++
Return

Static Function ffechalarga(sfechacorta)
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

	xPutSx1(cPerg,"01","De documento ?","De documento ?","De documento ?","mv_ch1","C",18,0,0,"G","","","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","A documento ?","A documento ?","A documento ?","mv_ch2","C",18,0,0,"G","","","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","De sucursal ?","De sucursal ?","De sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","A sucursal ?","A sucursal ?","A sucursal ?",         "mv_ch3","C",4,0,0,"G","","SM0","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","De serie ?","De serie ?","De serie ?",         "mv_ch3","C",20,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","A serie ?","A serie ?","A serie ?",         "mv_ch4","C",20,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","De fecha ?","De fecha ?","De fecha ?",         "mv_ch5","D",08,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","A fecha ?","A fecha ?","A fecha ?",         "mv_ch6","D",08,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	//xPutSx1(cPerg,"09","Moneda ?","Moneda ?","Moneda ?",         "mv_ch6","C",2,0,0,"G","","SM2","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"09","Moneda ?" , "Moneda ?" ,"Moneda ?" ,"MV_CH9","N",1,0,0,"C","","","","","mv_par09","Bolivianos","Bolivianos","Bolivianos","","Dolares","Dolares","Dolares")
	xPutSX1(cPerg,"10","Tipo Movimiento ?" , "Tipo Movimiento ?" ,"Tipo Movimiento ?" ,"MV_CH9","N",1,0,0,"C","","","","","mv_par09","Entrada","Entrada","Entrada","","Salida","Salida","Salida","Produccion","Produccion","Produccion")

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