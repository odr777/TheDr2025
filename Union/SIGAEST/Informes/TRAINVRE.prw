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
#Define COL_SERIE   0150
#Define	COL_PROVEEDOR 	0245
#Define	COL_NOME		0320
#Define	COL_LOJA	0390
#Define	COL_EMISSAO	0470
#Define	COL_CANTIDAD	0530
#Define	COL_SUCURSAL	0630
#Define	COL_UBICACION	0570
#Define	COL_VALIDEZ		0670
#Define	COL_ALDER		0650

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³  MOVINT  ºAutor  ³ERICK ETCHEVERRY º   º Date 07/09/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±Descripcion Impresion de transferencia resumido                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION SRL	                                          	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º MV_PAR01 ³ Descricao da pergunta1 do SX1                              º±±
±±º MV_PAR02 ³ Descricao da pergunta2 do SX1                              º±±
±±º MV_PAR03 ³ Descricao do pergunta3 do SX1                              º±±
±±º MV_PAR04 ³ Descricao do pergunta4 do SX1                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TRAINVRE()
	LOCAL cString		:= "SF1"
	Local titulo 		:= ""
	LOCAL wnrel		 	:= "Transferencia"
	LOCAL cDesc1	    := "Relatorio de transferencias"
	LOCAL cDesc2	    := "conforme parametro"
	LOCAL cDesc3	    := "Especifico UNION"
	PRIVATE nomeProg 	:= "TRAINVII"
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
	PRIVATE cPerg   := "TRAINVRE"   // elija el Nombre de la pregunta
	Public _cTipoOp
	CriaSX1(cPerg)	// Si no esta creada la crea

	Pergunte(cPerg,.t.)

	Processa({ |lEnd| MOVD3CONF("Impresion de transferencias")},"Imprimiendo , aguarde...")
	Processa({|lEnd| fImpPres(@lEnd,wnRel,cString,nReg)},titulo)

Return

Static Function MOVD3CONF(Titulo)
	Local cFilename := 'transferencia'
	Local i 	 := 1
	Local x 	 := 0

	cCaminho  := GetTempPath()
	cArquivo  := "zTstRal_" + dToS(date()) + "_" + StrTran(time(), ':', '-')
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
	Local _aAreaSM0 := {}
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
	Private cDoc
	Private cTitulo

	dbSelectArea("SM0")
	_aAreaSM0 := SM0->(GetArea())

	_cTipoOp := iif (MV_PAR12 == 1,'E','S')

	If Select("VW_TRANS") > 0
		dbCloseArea()
	Endif

	If _cTipoOp=='E'
		cQuery := "SELECT F1_DOC,F1_LOJA,D1_FILIAL,F1_FORNECE,F1_EMISSAO,F1_FILORIG,F1_FILIAL,F1_MOEDA,F1_SERIE,F1_USRREG,A2_NOME ,SUM(D1_QUANT) D1_QUANT "//B2_QATU,B2_CM1  "
		cQuery += " from " + RetSqlName("SF1") + " SF1 "
		cQuery += " inner Join " + RetSqlName("SD1") + " SD1 on F1_DOC=D1_DOC and F1_FILIAL=D1_FILIAL and F1_SERIE=D1_SERIE and D1_TIPODOC='64' AND D1_FORNECE=F1_FORNECE AND SD1.D_E_L_E_T_!='*'"
		cQuery += " inner Join " + RetSqlName("SA2") + " SA2 ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA AND SA2.D_E_L_E_T_ = ' ' "
		cQuery += " LEFT Join " + RetSqlName("NNR") + " NNR on NNR.NNR_CODIGO=D1_LOCAL and F1_FILIAL=NNR.NNR_FILIAL AND NNR.D_E_L_E_T_!='*' "
		cQuery += " WHERE "
		cQuery += " F1_FILORIG BETWEEN '"+trim(mv_par02)+"' AND '"+trim(mv_par03)+"'  AND F1_FILIAL = '"+trim(mv_par01)+"'"
		cQuery += " and F1_EMISSAO Between '"+DTOS(mv_par04)+"' and '"+DTOS(mv_par05)+"'"
		cQuery += " and F1_DOC Between '"+trim(mv_par06)+"' and '"+trim(mv_par07)+"'"
		cQuery += " and F1_SERIE Between '"+trim(mv_par08)+"' and '"+trim(mv_par09)+"'"
		cQuery += " AND SF1.D_E_L_E_T_!='*' AND F1_ESPECIE = 'RTE' "
		cQuery += " and F1_FORNECE Between '"+trim(mv_par10)+"' and '"+trim(mv_par11)+"' "
		cQuery += " GROUP BY F1_DOC,D1_FILIAL,F1_LOJA,F1_EMISSAO, F1_FORNECE,F1_FILORIG,F1_FILIAL, F1_MOEDA, F1_SERIE,F1_USRREG,A2_NOME"
		cQuery += " order by F1_DOC"
	Else
		cQuery := "select F2_FILIAL,D2_FILIAL,F2_LOJA,F2_DOC,F2_EMISSAO,F2_FILDEST, A2_NOME,Max(A2_NOME)AS cli1,Min(A2_NOME)AS cli2,SUM(D2_QUANT)D2_QUANT,F2_MOEDA,F2_SERIE,F2_USRREG,F2_CLIENTE  "//c6_num,
		cQuery += "from " + RetSqlName("SF2") + " SF2 "
		cQuery += "inner Join " + RetSqlName("SD2") + " SD2 on F2_DOC=D2_DOC and F2_FILIAL=D2_FILIAL and F2_SERIE=D2_SERIE and D2_TIPODOC='54' and SD2.D_E_L_E_T_=' ' "
		cQuery += "left outer Join " + RetSqlName("SA2") + " SA2 on A2_COD=F2_CLIENTE and F2_LOJA=A2_LOJA and SA2.D_E_L_E_T_=' ' "
		cQuery += " WHERE SF2.D_E_L_E_T_=' '   "//and sb1.d_e_l_e_t_=' ' "
		cQuery += " and F2_FILDEST BETWEEN '"+trim(mv_par02)+"' and '"+trim(mv_par03)+"' AND F2_FILIAL = '"+trim(mv_par01)+"'"
		cQuery += " and F2_EMISSAO Between '"+DTOS(mv_par04)+"' and '"+DTOS(mv_par05)+"'"
		cQuery += " and F2_DOC Between '"+trim(mv_par06)+"' and '"+trim(mv_par07)+"'"
		cQuery += " and F2_SERIE Between '"+trim(mv_par08)+"' and '"+trim(mv_par09)+"' AND F2_ESPECIE = 'RTS' "
		cQuery += " and F2_CLIENTE Between '"+trim(mv_par10)+"' and '"+trim(mv_par11)+"' "
		cQuery += " group by F2_FILIAL,D2_FILIAL,F2_LOJA,F2_DOC,F2_EMISSAO,F2_FILDEST,F2_MOEDA,A2_NOME,F2_SERIE, F2_USRREG,F2_CLIENTE "//,c6_num,
		cQuery += " order by F2_DOC "
	Endif

	TCQuery cQuery New Alias "VW_TRANS"

	//Aviso("",cQuery,{'ok'},,,,,.t.)

	Count To nTotal
	ProcRegua(nTotal)
	VW_TRANS->(DbGoTop())
	nAtual := 0

	fImpCab()
	//PRINTANDO ITEMS
	if _cTipoOp == 'E'   // SI ES ENTRADA
		While ! VW_TRANS->(EoF())

			OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
			dbSelectArea("SM0") //Abro la SM0
			SM0->(dbSetOrder(1))
			SM0->(dbSeek("01"+VW_TRANS->F1_FILORIG,.T.)) //Posiciona  empresa-grupo empresa
			cNomeSuc := SM0->M0_NOMECOM
			SM0->(DBCloseArea())

			//Imprimindo a linha atual
			oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_TRANS->F1_DOC , oFontDet, 00200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SERIE, VW_TRANS->F1_SERIE,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_PROVEEDOR, VW_TRANS->F1_FORNECE,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_NOME, VW_TRANS->A2_NOME,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_LOJA, VW_TRANS->F1_LOJA ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_EMISSAO,ALLTRIM(DTOC(STOD(VW_TRANS->F1_EMISSAO))),  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_CANTIDAD,ALLTRIM(TRANSFORM(VW_TRANS->D1_QUANT,"@E 9,999,999.99")),  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			oPrint:SayAlign(nLinAtu, COL_SUCURSAL,VW_TRANS->F1_FILORIG +" "+cNomeSuc,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += nTamLin

			VW_TRANS->(DbSkip())

		EndDo

		//Se ainda tiver linhas sobrando na página, imprime o rodapé final
		If nLinAtu <= nLinFin
			fImpRod(.t.)
		EndIf

		//Mostrando o relatório
		oPrint:Preview()
		VW_TRANS->(DbCloseArea())
	ELSE  //// TRANSFERENCIA DE SALIDA
		While ! VW_TRANS->(EoF())
			OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
			dbSelectArea("SM0") //Abro la SM0
			SM0->(dbSetOrder(1))
			SM0->(dbSeek("01"+VW_TRANS->F2_FILDEST,.T.)) //Posiciona  empresa-grupo empresa
			cNomeSuc := SM0->M0_NOMECOM
			SM0->(DBCloseArea())
			oPrint:SayAlign(nLinAtu, COL_GRUPO, VW_TRANS->F2_DOC , oFontDet, 00200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SERIE,VW_TRANS->F2_SERIE ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_PROVEEDOR, VW_TRANS->F2_CLIENTE,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_NOME, VW_TRANS->A2_NOME,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_LOJA, VW_TRANS->F2_LOJA ,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_EMISSAO,ALLTRIM(DTOC(STOD(VW_TRANS->F2_EMISSAO))),  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_CANTIDAD,ALLTRIM(TRANSFORM(VW_TRANS->D2_QUANT,"@E 9,999,999.99")),  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)
			oPrint:SayAlign(nLinAtu, COL_SUCURSAL,VW_TRANS->F2_FILDEST+" "+cNomeSuc,  oFontDet, 0200, nTamLin, CLR_BLACK, PAD_LEFT, 0)

			nLinAtu += nTamLin

			VW_TRANS->(DbSkip())

		EndDo

		//Se ainda tiver linhas sobrando na página, imprime o rodapé final
		If nLinAtu <= nLinFin
			fImpRod(.t.)
		EndIf

		//Mostrando o relatório
		oPrint:Preview()
		VW_TRANS->(DbCloseArea())
	ENDIF

	OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(RestArea(_aAreaSM0))//restaura al area original
	RestArea(aArea)

RETURN

Static Function fImpCab()
	Local cTexto   := ""
	Local nLinCab  := 030
	Local nLinInCab := 015
	Local nDetCab := 090
	Local nDerCab := 0540
	Local _aAreaSM0 := {}

	_cTipoOp := iif (MV_PAR12 == 1,'E','S')

	If _cTipoOp=='E'
		cDoc := VW_TRANS->F1_DOC
		cTitulo := "ENTRADA"
	ELSE
		cDoc := VW_TRANS->F2_DOC
		cTitulo := "SALIDA"
	ENDIF

	dbSelectArea("SM0")
	_aAreaSM0 := SM0->(GetArea())

	//Iniciando Página
	oPrint:StartPage()

	//Cabeçalho
	cTexto := "TRANSFERENCIA DE STOCK DE ("+cTitulo+")"
	oPrint:SayAlign(nLinCab, nColMeio - 120, cTexto, oFontTit, 240, 20, CLR_GRAY, PAD_CENTER, 0)
	nLinCab += (nTamLin * 1.7)
	oPrint:SayAlign(nLinCab, COL_GRUPO, Alltrim(SM0->M0_NOME)+" / "+Alltrim(SM0->M0_FILIAL)	+ " / "	+ ALLTRIM(SM0->M0_CODFIL), oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
	nLinCab += (nTamLin * 1.7)

	If _cTipoOp=='E'
		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+VW_TRANS->F1_FILORIG,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := SM0->M0_NOMECOM
		SM0->(DBCloseArea())

		/*oPrint:SayAlign(nLinCab, COL_GRUPO, "DOCUMENTO: ", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, nDetCab, ALLTRIM(VW_TRANS->F1_DOC) + " ", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)*/
		//derecha
		oPrint:SayAlign(nLinCab, nDerCab, "FECHA", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ALDER, DTOC(SToD(VW_TRANS->F1_EMISSAO)), oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1.7)

		oPrint:SayAlign(nLinCab, COL_GRUPO, "SUCURSAL ORIGEN:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, nDetCab, + VW_TRANS->F1_FILORIG  + " " + alltrim(cNomeSuc) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		//derecha
		/*oPrint:SayAlign(nLinCab, nDerCab, "DEPOSITO ORIGEN:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ALDER, alltrim(POSICIONE('NNR',1,XFILIAL('NNR')+ Posicione("SD2",3,OrdenesCom->F1_FILORIG+OrdenesCom->(D1_NFORI+D1_SERIORI);
		,"D2_LOCAL"),'NNR_DESCRI')) + " - " + alltrim(Posicione("SD2",3,;
		VW_TRANS->F1_FILORIG+VW_TRANS->(D1_NFORI+D1_SERIORI),"D2_LOCAL")) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)*/

		nLinCab += (nTamLin * 1.7)

		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+VW_TRANS->F1_FILIAL,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := SM0->M0_NOMECOM
		SM0->(DBCloseArea())

		oPrint:SayAlign(nLinCab, COL_GRUPO, "SUCURSAL DESTINO: ", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, nDetCab, VW_TRANS->F1_FILIAL + " " + alltrim(cNomeSuc), oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		//derecha
		/*oPrint:SayAlign(nLinCab, nDerCab, "DEPOSITO DESTINO:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ALDER,alltrim(VW_TRANS->almdes) ;
		+ " - " +alltrim(VW_TRANS->D1_LOCAL) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)*/
		nLinCab += (nTamLin * 1.7)

		oPrint:SayAlign(nLinCab, COL_GRUPO, "REGISTRADO POR: ", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, nDetCab, ALLTRIM(VW_TRANS->F1_USRREG), oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		//derecha
		oPrint:SayAlign(nLinCab, nDerCab, "Impreso por:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ALDER, SUBSTR(CUSERNAME,1,15) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
	ELSE

		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+VW_TRANS->F2_FILIAL,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := SM0->M0_NOMECOM
		SM0->(DBCloseArea())

		/*oPrint:SayAlign(nLinCab, COL_GRUPO, "DOCUMENTO: ", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, nDetCab, ALLTRIM(VW_TRANS->F2_DOC) + " ", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)*/
		//derecha
		oPrint:SayAlign(nLinCab, nDerCab, "FECHA", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ALDER, DTOC(SToD(VW_TRANS->F2_EMISSAO)), oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		nLinCab += (nTamLin * 1.7)

		oPrint:SayAlign(nLinCab, COL_GRUPO, "SUCURSAL ORIGEN:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, nDetCab, VW_TRANS->F2_FILIAL  + " " + alltrim(cNomeSuc) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		//derecha
		/*oPrint:SayAlign(nLinCab, nDerCab, "DEPOSITO ORIGEN:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ALDER, alltrim(VW_TRANS->almdes);
		+ " - " + alltrim(VW_TRANS->D2_LOCAL) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)*/
		nLinCab += (nTamLin * 1.7)

		OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
		dbSelectArea("SM0") //Abro la SM0
		SM0->(dbSetOrder(1))
		SM0->(dbSeek("01"+VW_TRANS->F2_FILDEST,.T.)) //Posiciona  empresa-grupo empresa
		cNomeSuc := SM0->M0_NOMECOM
		SM0->(DBCloseArea())

		oPrint:SayAlign(nLinCab, COL_GRUPO, "SUCURSAL DESTINO: ", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, nDetCab,VW_TRANS->F2_FILDEST + " " + alltrim(cNomeSuc), oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		//derecha
		/*oPrint:SayAlign(nLinCab, nDerCab, "DEPOSITO DESTINO:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ALDER, alltrim(POSICIONE('NNR',1,XFILIAL('NNR')+ VW_TRANS->D2_LOCDEST,'NNR_DESCRI'));
		+ " - " + alltrim(VW_TRANS->D2_LOCDEST) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)*/
		nLinCab += (nTamLin * 1.7)

		oPrint:SayAlign(nLinCab, COL_GRUPO, "REGISTRADO POR: ", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, nDetCab, ALLTRIM(VW_TRANS->F2_USRREG), oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		//derecha
		oPrint:SayAlign(nLinCab, nDerCab, "Impreso por:", oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
		oPrint:SayAlign(nLinCab, COL_ALDER, SUBSTR(CUSERNAME,1,15) , oFontTit, 240, 20, CLR_GRAY, PAD_LEFT, 0)
	ENDIF

	//Linha Separatória
	nLinCab += (nTamLin * 2)
	oPrint:Line(nLinCab, nColIni, nLinCab, nColFin, CLR_GRAY)

	//Cabeçalho das colunas
	nLinCab += nTamLin
	oPrint:SayAlign(nLinCab, COL_GRUPO, "DOCUMENTO",     oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_SERIE, "SERIE", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_PROVEEDOR, "CODPROVEEDOR", oFontDetN, 0070, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_NOME, "PROVEEDOR", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_LOJA, "TIENDA", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_EMISSAO, "EMISION", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_CANTIDAD, "CANTIDAD", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_SUCURSAL, "CANTIDAD", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	/*oPrint:SayAlign(nLinCab, COL_UBICACION, "UBICACION", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)
	oPrint:SayAlign(nLinCab, COL_VALIDEZ, "VALIDEZ", oFontDetN, 0050, nTamLin, CLR_BLACK, PAD_LEFT, 0)*/

	nLinCab += nTamLin

	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 3

	OpenSM0() //Abrir tabla SM0 (Empresa/Filial)
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	SM0->(RestArea(_aAreaSM0))//restaura al area original
Return

Static Function fImpRod(lFirma)//RODAPE PIE PAGINA
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
	oPrint:SayAlign(nLinRod, nColIni,    cTextoEsq, oFontRod, 200, 05, CLR_GRAY, PAD_LEFT,  0)
	oPrint:SayAlign(nLinRod, nColFin-50, cTextoDir, oFontRod, 60, 05, CLR_GRAY, PAD_RIGHT, 0)

	if lFirma
		nLinRod += 13
		//Imprimindo os textos
		oPrint:SayAlign(nLinRod, COL_NOME, "Realizado por " , oFontRod, 200, 05, CLR_GRAY, ,  0)
		oPrint:SayAlign(nLinRod, COL_UBICACION, "Firma autorizada", oFontRod, 0200, 05, CLR_GRAY, , 0)

	endif
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

	xPutSx1(cPerg,"01","De sucursal fija ?","De sucursal fija ?","De sucursal fija ?","mv_ch1","C",4,0,0,"G","","SM0","","","mv_par01",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"02","De Sucursal ?","De Sucursal ?","De Sucursal ?","mv_ch2","C",4,0,0,"G","","SM0","","","mv_par02",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"03","A Sucursal ?","A Sucursal ?","A Sucursal ?","mv_ch2","C",4,0,0,"G","","SM0","","","mv_par03",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"04","De fecha ?","De fecha ?","De fecha ?",         "mv_ch3","D",08,0,0,"G","","","","","mv_par04",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"05","A fecha ?","A fecha ?","A fecha ?",         "mv_ch4","D",08,0,0,"G","","","","","mv_par05",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"06","De Nro. Documento ?","De Nro. Documento ?","De Nro. Documento ?",         "mv_ch5","C",18,0,0,"G","","","","","mv_par06",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"07","A Nro. Documento ?","A Nro. Documento ?","A Nro. Documento ?",         "mv_ch6","C",18,0,0,"G","","","","","mv_par07",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"08","De serie ?","De serie ?","De serie ?",         "mv_ch7","C",3,0,0,"G","","","","","mv_par08",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"09","A serie ?","A serie ?","A serie ?",         "mv_ch8","C",3,0,0,"G","","","","","mv_par09",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"10","De Proveedor ?","De Proveedor ?","De Proveedor ?", "mv_ch9","C",6,0,0,"G","","","","","mv_par10",""       ,""            ,""        ,""     ,"","")
	xPutSx1(cPerg,"11","A Proveedor ?","A Proveedor ?","A Proveedor ?",         "mv_ch10","C",6,0,0,"G","","","","","mv_par11",""       ,""            ,""        ,""     ,"","")
	xPutSX1(cPerg,"12","Tipo transferencia" , "Tipo transferencia" ,"Tipo transferencia" ,"MV_CH11","N",1,0,0,"C","","","","","mv_par12","Entrada","Entrada","Entrada","","Salida","Salida","Salida")

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