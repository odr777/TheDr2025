#include 'protheus.ch'
#include 'parmtype.ch'
#Include "MatrBolx.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³matrbolx  ³ Autor ³Jorge Saavedra   ³ Data ³ 29/09/2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³RDMAKE do Livros de Compras/Vendas IVA                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Bolivia                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user function matrbolx()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis     	                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cTitulo	:= OemToAnsi(STR0001)	//"Livro IVA de Compras/Vendas"
	Local cDescr1	:= OemToAnsi(STR0002)	//"Este programa tem como objetivo imprimir o relatorio Livro IVA de Compras/Vendas"
	Local cPerg	 	:= "MTRBO2"
	Local cNomeProg	:= "MATRBOL2"
	Local cString	:= "SF3"
	Local cOrdem	:= ""

	Private cTam	:= "G"
	Private lEnd	:= .F.
	Private aReturn	:= {STR0004, 1, STR0005, 2, 2, 1, "", 1} //"Zebrado"###"Administracao"
	Private nLastKey:= 0
	Private m_pag	:= 1
	Private wnRel	:= ""
	Private aL		:= Array(10)

	If (cPaisLoc == "BOL" .Or. (cPaisLoc == "URU" .And. GetNewPar("MV_LOCBURU",.F.))) .And. LocBol()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ajusta o Grupo de Perguntas                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AjustaSx1(cPerg)
		Pergunte(cPerg,.F.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta a interface padrao com o usuario                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		wnRel := SetPrint(cString,cNomeProg,cPerg,cTitulo,cDescr1,,,.F.,,.T.,cTam,,.T.)
		If nLastKey == 27
			Return Nil
		Endif
		SetDefault(aReturn,cString)
		If nLastKey == 27
			Return Nil
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ RPTSTATUS monta janela com a regua de processamento    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RptStatus({|| Imprime()},cTitulo)
	Endif

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Imprime    ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Rotina de Impressao do Livro de Compras IVA                  ³±±
±±³          ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Imprime()

	Local nLivro	:= mv_par01			//Livro: 1-Compras ou 2-Vendas
	Local dDtIni	:= mv_par02
	Local dDtFim	:= mv_par03
	Local cFolha	:= STR(mv_par06-1, 3)
	Local nImpExclu := mv_par07  // 1- Imprime ou 2- Nao imprime
	Local cRG		:= mv_par09
	Local cResp		:= Upper(mv_par10)

	Local cFiltro	:= ""
	Local cAlias	:= "SF3"
	Local cAlias2	:= "SF3"
	Local cAliasTel := "SF1"
	Local cEmissNF	:= ""
	Local cCondicao	:= ""
	Local cIndexSF3	:= ""
	Local cIndexTel := ""
	Local cIndex2	:= ""
	Local cDebug	:= ""
	Local cEspecie  := ""
	Local cCLIEFOR  := ""
	Local cSerieAtu := nil
	Local cSerieAnt := nil
	Local cDatNFAnt := ""
	Local cNFAtu	:= nil
	Local cRazSoc	:= ""
	Local cNIT		:= ""
	Local cFilDe    := cFilAnt
	Local cFilAte   := cFilAnt
	Local cFilOld   := cFilAnt
	Local cAutoriz  := ""
	Local cOrdem	:= ""
	Local cChaveSf3 := ""

	Local lQuery	:= .F.
	Local lVALIMP	:= .F.
	Local lNUMDES   := .F.
	Local lPassag 	:= .F.
	Local lImport   := .F.
	Local lF3TipC   := .F.
	Local lDataTel  := .F.
	Local lFistNFs  := .F.

	Local aDados	:= {}
	Local aAreaSM0  := SM0->(GetArea())
	Local aAreaSF3  := SF3->(GetArea())
	Local aImpostos	:= {}
	Local aArea   	:= {}
	Local aFistNFs  := {}
	Local aTotPar	:= {}		//Totais Parciais
	Local aTotGer	:= {}		//Totais Gerais
	Local aTotInf	:= {}		//Totais Informe
	Local nIndex	:= 0
	Local nTotalICE := 0
	Local nAuxNFAtu := 0
	Local nNFAtu2	:= nil
	Local nNFAnt	:= nil
	Local nNum      := 0
	Local nNum2     := 0
	Local nTotGer	:= 0
	Local nLin		:= 0
	Local nTotalTel := 0

	Local nx        := 0
	local nPos      := 0

	Local dDataTel  := ""

	Local cArqTrab  :=""
	Local cAliasSF3 :=""
	Local aEstrSF3  :={}
	Local cFilSF3   :=""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o LayOut do Relatorio                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LayOut(@aL)

	cFilDe  := mv_par04
	cFilAte := mv_par05
	// Processa todo o arquivo de filiais ou apenas a filial atual
	SM0->(MsSeek(cEmpAnt+cFilDe,.T.))
	aTotInf	:= {"Total Informe",0,0,0,0,0}		//Totais Gerais
	While !SM0->(Eof()) .And.;
	SM0->M0_CODIGO == cEmpAnt .And.;
	SM0->M0_CODFIL <= cFilAte

		// inicializacoes --------------------------------------------------
		nLin	 := 0
		cFiltro	 := ""
		cAlias	 := "SF3"
		cAlias2	 := "SF3"
		cAliasTel:= "SF1"
		cEmissNF := ""
		cCondicao:= ""
		cDebug	 := ""
		cEspecie := ""
		cCLIEFOR := ""
		cSerieAtu:= nil
		cSerieAnt:= nil
		cDatNFAnt:= ""
		cNFAtu	 := nil
		cRazSoc	 := ""
		cNIT     := ""
		cAutoriz := ""

		lQuery	:= .F.
		lVALIMP	:= .F.
		lNUMDES := .F.
		lF3TipC := .F.

		aDados    := {}
		aImpostos := {}
		aArea     := {}
		aFistNFs  := {}

		nIndex	  := 0
		nTotalICE := 0
		nAuxNFAtu := 0
		nNFAtu2	  := nil
		nNFAnt    := nil
		nNum      := 0
		nTotGer	  := 0
		nNUMDES   := 0
		nF1TipC   := 0
		nF2TipC   := 0

		aTotPar	:= {OemToAnsi(STR0008),0,0,0,0,0}		//Totais Parciais
		aTotGer	:= {OemToAnsi(STR0009),0,0,0,0,0}		//Totais Gerais

		lPassag := cPaisLoc == "BOL" .And. GetNewPar("MV_PASSBOL",.F.) .And.;
		SF3->(FieldPos("F3_COMPANH")) > 0 .And. ;
		SF3->(FieldPos("F3_LOJCOMP")) > 0 .And. ;
		SF3->(FieldPos("F3_PASSAGE")) > 0 .And. ;
		SF3->(FieldPos("F3_DTPASSA")) > 0 .And. ;
		SF1->(FieldPos("F1_COMPANH")) > 0 .And. ;
		SF1->(FieldPos("F1_LOJCOMP")) > 0 .And. ;
		SF1->(FieldPos("F1_PASSAGE")) > 0 .And. ;
		SF1->(FieldPos("F1_DTPASSA")) > 0

		cArqTrab  :=""
		cAliasSF3 :=""
		aEstrSF3  :={}
		cFilSF3   :=""

		cFilAnt := SM0->M0_CODFIL

		#IFDEF TOP
		If TcSrvType() <> "AS/400"
			lQuery := .T.
		Endif
		#ENDIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta aImpostos com as informacoes do IVA              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SFB")
		dbSetOrder(1)
		dbGoTop()

		AADD(aImpostos,{"IVA",""})
		While !SFB->(Eof())
			If aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]}) > 0
				aImpostos[aScan(aImpostos,{|x| SFB->FB_CODIGO $ x[1]})][2] := SFB->FB_CPOLVRO
			Endif
			dbSkip()
		Enddo
		aSort(aImpostos,,,{|x,y| x[2] < y[2]})

		AAdd(aImpostos[1],SF3->(FieldPos("F3_BASIMP"+aImpostos[1][2])))	//[3] Base de Calculo
		AAdd(aImpostos[1],SF3->(FieldPos("F3_VALIMP"+aImpostos[1][2])))	//[4] Valor do Imposto

		dbSelectArea("SF3")
		dbSetOrder(1)

		If FieldPos("F3_VALIMP"+mv_par08) == 0
			MsgAlert(STR0050 + mv_par08 + " " + STR0051)
			lVALIMP := .F.
		Else
			lVALIMP := .T.
		Endif

		If SF1->(FieldPos("F1_NUMDES")) == 0
			lNUMDES = .F.
		Else
			lNUMDES = .T.
		Endif

		If SF3->(FieldPos("F3_TIPCOMP")) == 0
			lF3TipC = .F.
		Else
			lF3TipC = .T.
		Endif

		// primeiras notas de cada serie ---------------
		If nLivro <> 1
			If lQuery
				cAlias2 := GetNextAlias()
				BeginSql Alias cAlias2
				Column F3_EMISSAO as Date
				SELECT F3_SERIE,MAX(F3_NFISCAL) as NF
				FROM %Table:SF3% SF3
				WHERE F3_FILIAL = %Exp:xFilial("SF3")% AND
				F3_EMISSAO > %Exp:dDtIni% AND
				F3_FORMUL = 'S' AND
				SF3.%NotDel%
				GROUP BY F3_SERIE
				EndSql
				cDebug := GetLastQuery()[2]		//Para debugar a query

				/*While !((cAlias2)->(Eof()))
				AADD(aFistNFs,{(cAlias2)->F3_SERIE,(cAlias2)->NF})
				(cAlias2)->(DbSkip())
				Enddo*/
			Else

				cIndex2 := CriaTrab(Nil,.F.)
				cFiltro	:= "F3_FILIAL == '"+ xFilial("SF3") + "' .And. "

				If (nLivro == 1 .And. mv_par11 == 2) .Or. nLivro == 2
					cFiltro	+= "Dtos(F3_EMISSAO) < '"+Dtos(dDtIni)+"' .AND. F3_FORMUL == 'S'"
					IndRegua(cAlias2,cIndex2,"F3_EMISSAO,F3_FILIAL,F3_NFISCAL",,cFiltro,STR0017) //"Selecionando registros..."

				Else
					cFiltro	+= "Dtos(F3_ENTRADA) < '"+Dtos(dDtIni)+"' .AND. F3_FORMUL == 'S'"
					IndRegua(cAlias2,cIndex2,"F3_ENTRADA,F3_FILIAL,F3_NFISCAL",,cFiltro,STR0017) //"Selecionando registros..."

				EndIf

				nIndex := RetIndex("SF3")
				dbSetIndex(cIndex2+OrdBagExt())
				dbSetOrder(nIndex+1)
				dbGoTop()

				// tipos de serie
				DbSelectArea("SX5")
				DbSeek (xFilial("SX5")+"01")

				While xFilial("SX5") == X5_FILIAL .AND. X5_TABELA == "01"
					AADD(aFistNFs,{SX5->X5_CHAVE,"0"})
					SX5->(DbSkip())
				Enddo

				While !((cAlias2)->(Eof()))
					conout((cAlias2)->F3_SERIE)
					For nNum:=1 to Len(aFistNFs)
						If (ALLTRIM(aFistNFs[nNum][1]) == ALLTRIM((cAlias2)->F3_SERIE) .OR. ;
						(Empty(aFistNFs[nNum][1]) .AND. Empty((cAlias2)->F3_SERIE))) .AND. VAL(aFistNFs[nNum][2]) < VAL((cAlias2)->F3_NFISCAL)
							aFistNFs[nNum][2] := (cAlias2)->F3_NFISCAL
						Endif
					Next

					(cAlias2)->(DbSkip())
				Enddo

				dbSelectArea("SF3")
				RetIndex("SF3")
				dbClearFilter()
				Ferase(cIndexSF3+OrdBagExt())
			Endif
		Endif

		If lQuery
			cCondicao := "%"
			cOrden:=""
			If nLivro == 1 //compras
				cCondicao += "((F3_TIPOMOV = 'C')" //fornecedor
				cCondicao += " OR "
				cCondicao += "(F3_TIPOMOV = 'V' AND (F3_ESPECIE IN ('NCC','NCE','NDC','NDE'))))" //cliente
				cCondicao += " AND F3_RECIBO <> '1'"
				cOrden:="%F3_SERIE, F3_EMISSAO, F3_NFISCAL%"
			Else
				cCondicao += "((F3_TIPOMOV = 'V')" //cliente
				cCondicao += " OR "
				cCondicao += "(F3_TIPOMOV = 'C' AND (F3_ESPECIE IN ('NCP','NCI','NDP','NDI'))))" //fornecedor
				cOrden:="%F3_SERIE, F3_EMISSAO, CONVERT(INT, F3_NFISCAL)%"
			Endif
			cCondicao += " AND"
			cCondicao += "%"

			cAlias := GetNextAlias()
			If (nLivro == 1 .And. mv_par11== 2) .Or. nLivro == 2

				BeginSql Alias cAlias
				Column F3_DTCANC  as Date
				Column F3_DTLANC  as Date
				Column F3_DTPASSA as Date
				Column F3_ENTRADA as Date
				Column F3_EMISSAO as Date
				SELECT *
				FROM %Table:SF3% SF3
				WHERE F3_FILIAL = %Exp:xFilial("SF3")% AND
				((F3_COMPANH  = ' ' AND F3_LOJCOMP  = ' ' AND F3_EMISSAO >= %Exp:dDtIni% AND F3_EMISSAO <= %Exp:dDtFim%) OR
				(F3_COMPANH <> ' ' AND F3_LOJCOMP <> ' ' AND F3_DTPASSA >= %Exp:dDtIni% AND F3_DTPASSA <= %Exp:dDtFim%) OR
				(F3_EMISSAO <= %Exp:dDtFim% AND F3_TIPCOMP = 'T')) AND
				%exp:cCondicao%
				SF3.%NotDel%
				ORDER BY %exp:cOrden%  //F3_SERIE, F3_EMISSAO, F3_NFISCAL //%Order:SF3%
				EndSql

			Else
				BeginSql Alias cAlias
				Column F3_DTCANC  as Date
				Column F3_DTLANC  as Date
				Column F3_DTPASSA as Date
				Column F3_ENTRADA as Date
				Column F3_EMISSAO as Date
				SELECT *
				FROM %Table:SF3% SF3
				WHERE F3_FILIAL = %Exp:xFilial("SF3")% AND
				((F3_COMPANH  = ' ' AND F3_LOJCOMP  = ' ' AND F3_ENTRADA >= %Exp:dDtIni% AND F3_ENTRADA <= %Exp:dDtFim%) OR
				(F3_COMPANH <> ' ' AND F3_LOJCOMP <> ' ' AND F3_DTPASSA >= %Exp:dDtIni% AND F3_DTPASSA <= %Exp:dDtFim%) OR
				(F3_ENTRADA <= %Exp:dDtFim% AND F3_TIPCOMP = 'T')) AND
				%exp:cCondicao%
				SF3.%NotDel%
				ORDER BY %exp:cOrden%  //F3_SERIE, F3_EMISSAO, F3_NFISCAL //%Order:SF3%
				EndSql

			EndIf

			cDebug := GetLastQuery()[2]		//Para debugar a query

		Else

			If nLivro == 1 //compras
				cCondicao := "((F3_TIPOMOV == 'C')" //fornecedor
				cCondicao += " .OR. "
				cCondicao += "(F3_TIPOMOV == 'V' .AND. (ALLTRIM(F3_ESPECIE) $ 'NCC,NCE,NDC,NDE')))" //cliente
				cCondicao += " AND F3_RECIBO <> '1'"
			Else
				cCondicao := "((F3_TIPOMOV == 'V')" //cliente
				cCondicao += " .OR. "
				cCondicao += "(F3_TIPOMOV == 'C' .AND. (ALLTRIM(F3_ESPECIE) $ 'NCP,NCI,NDP,NDI')))" //fornecedor
			Endif

			cIndexSF3 := CriaTrab(Nil,.F.)
			cFiltro	:= "F3_FILIAL == '"+ xFilial("SF3") + "' .And. "

			If nLivro == 1 .And. mv_par11 == 2
				cFiltro += "((Empty(F3_COMPANH) .AND. Empty(F3_LOJCOMP) .AND. Dtos(F3_EMISSAO) >= '"+Dtos(dDtIni)+"' .AND. Dtos(F3_EMISSAO) <= '"+Dtos(dDtFim)+"')  .OR."
				cFiltro +=  "(!Empty(F3_COMPANH).AND.!Empty(F3_LOJCOMP) .AND. Dtos(F3_DTPASSA) >= '"+Dtos(dDtIni)+"' .AND. Dtos(F3_DTPASSA) <= '"+Dtos(dDtFim)+"')) .OR. "
				cFiltro	+= "Dtos(F3_EMISSAO) <= '"+Dtos(dDtFim)+"' .AND. F3_TIPCOMP == 'T' .AND."
				cFiltro	+= cCondicao
				cOrdem := "F3_FILIAL+Dtos(F3_EMISSAO)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM)"

			Else
				cFiltro += "((Empty(F3_COMPANH) .AND. Empty(F3_LOJCOMP) .AND. Dtos(F3_ENTRADA) >= '"+Dtos(dDtIni)+"' .AND. Dtos(F3_ENTRADA) <= '"+Dtos(dDtFim)+"')  .OR."
				cFiltro +=  "(!Empty(F3_COMPANH).AND.!Empty(F3_LOJCOMP) .AND. Dtos(F3_DTPASSA) >= '"+Dtos(dDtIni)+"' .AND. Dtos(F3_DTPASSA) <= '"+Dtos(dDtFim)+"')) .OR. "
				cFiltro	+= "Dtos(F3_ENTRADA) <= '"+Dtos(dDtFim)+"' .AND. F3_TIPCOMP == 'T' .AND."
				cFiltro	+= cCondicao
				cOrdem := "F3_FILIAL+Dtos(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM)"
			EndIf

			IndRegua(cAlias,cIndexSF3,cOrdem,,cFiltro,STR0017) //"Selecionando registros..."
			nIndex := RetIndex("SF3")
			dbSetIndex(cIndexSF3+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbGoTop()
		Endif

		// arquivo temporario ---------------------------------------------------------------------------
		If nLivro == 1	//Compras
			cAliasSF3:= GetNextAlias()
			aEstrSF3 := SF3->(DbStruct())
			cArqTrab := CriaTrab(Nil,.F.)
			DbCreate(cArqTrab,aEstrSF3)
			dbUseArea(.T.,,cArqTrab,cAliasSF3,.F.,.F.)
			cFilSF3 := xFilial("SF3")

			While !((cAlias)->(Eof()))

				If lF3TipC .AND. (cAlias)->F3_TIPCOMP == 'T'

					DbSelectArea("SE5")
					Dbsetorder(7)
					DbSeek (xFilial("SE5")+(cAlias)->F3_SERIE+padr((cAlias)->F3_NFISCAL, TAMSX3("E5_NUMERO")[1]))

					nTotalTel := 0
					dDataTel  := ""
					lDataTel  := .F.

					While ((cAlias)->F3_SERIE == SE5->E5_PREFIXO .And. ;
					padr((cAlias)->F3_NFISCAL, TAMSX3("E5_NUMERO")[1]) == SE5->E5_NUMERO) .And. !SE5->(Eof())

						If (cAlias)->F3_CLIEFOR == SE5->E5_CLIFOR .And. (cAlias)->F3_LOJA == SE5->E5_LOJA .And. ;
						Dtos(SE5->E5_DATA) >= Dtos(dDtIni) .And. Dtos(SE5->E5_DATA) <= Dtos(dDtFim)

							nTotalTel += SE5->E5_VALOR

							If !lDataTel
								dDataTel := SE5->E5_DATA
								lDataTel := .T.
							Endif

						Endif

						SE5->(DbSkip())
					Enddo

					If lDataTel
						nTotalTel :=xMoeda(nTotalTel,Val(SE5->E5_MOEDA),1,SE5->E5_DATA,MsDecimais(1))

						(cAliasSF3)->(DbAppend())
						For nNum := 1 To Len(aEstrSF3)
							cCpo := aEstrSF3[nNum,1]
							(cAliasSF3)->(&cCpo) := (cAlias)->&cCpo
						Next

						// Credito IVA
						(cAliasSF3)->(&(FieldName(aImpostos[1][4]))) := (nTotalTel / (cAliasSF3)->F3_VALCONT) * (cAliasSF3)->(FieldGet(aImpostos[1][4]))
						// Valor Liquido ABC
						(cAliasSF3)->(&(FieldName(aImpostos[1][3]))) := nTotalTel - (cAliasSF3)->(FieldGet(aImpostos[1][4]))

						(cAliasSF3)->F3_EMISSAO := dDataTel
						(cAliasSF3)->F3_VALCONT := nTotalTel
						lDataTel := .F.
					Endif
				Else
					(cAliasSF3)->(DbAppend())

					For nNum := 1 To Len(aEstrSF3)
						cCpo := aEstrSF3[nNum,1]
						(cAliasSF3)->(&cCpo) := (cAlias)->&cCpo
					Next

					// deve ser impresso a data da passagem aerea e nao a emissao da mesma
					If lPassag .And. !Empty((cAlias)->F3_COMPANH) .And. !Empty((cAlias)->F3_LOJCOMP)
						(cAliasSF3)->F3_EMISSAO := (cAlias)->F3_DTPASSA
					Endif
				Endif

				(cAlias)->(DbSkip())
			Enddo
			(cAliasSF3)->(DbCreateIndex(cArqTrab + OrdBagExt(),"dtos(F3_EMISSAO)+F3_NFISCAL",{|| dtos(F3_EMISSAO)+F3_NFISCAL}))
		Else
			cAliasSF3 := cAlias
		Endif

		While !(cAliasSF3)->(Eof())

			cChaveSf3 := (cAliasSF3)->F3_FILIAL+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aborta impressao                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lEnd
				Exit
			Endif
			lImport := .F. // indica se existe uma Poliza de Importacion ou nao para que seja ou nao impressa a serie

			If lF3TipC .And. !Empty((cAliasSF3)->F3_TIPCOMP)
				If (cAliasSF3)->F3_TIPCOMP == "A"
					cAutoriz := "1"
				Else
					If (cAliasSF3)->F3_TIPCOMP == "R"
						cAutoriz := "2"
					Else
						If (cAliasSF3)->F3_TIPCOMP == "P"
							cAutoriz := "3"
						Else
							cAutoriz := (cAliasSF3)->F3_NUMAUT
						Endif
					Endif
				Endif
			Else
				cAutoriz := (cAliasSF3)->F3_NUMAUT
			Endif

			If !Empty((cAliasSF3)->F3_RAZSOC)
				cRazSoc := (cAlias)->F3_RAZSOC
				cNIT	:= (cAlias)->F3_NIT
			EndIf

			If nLivro == 1	//Compras
				cPoliza:=Replicate(" ",13)
				If alltrim((cAliasSF3)->F3_NFISCAL) $"21489"
					f:=1
				end
				//If SF1->(DbSeek((cAliasSF3)->(F3_FILIAL+PADR(F3_NFISCAL,13," ")+F3_SERIE+F3_CLIEFOR+F3_LOJA)))
				aDatosCli:= u_GetProNit((cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_CLIEFOR,(cAliasSF3)->F3_LOJA,(cAliasSF3)->f3_filial)
				iF Len(aDatosCli)>0
					cRazSoc := alltrim(aDatosCli[1])
					cNIT	   := aDatosCli[2]
					cPoliza:=  alltrim(aDatosCli[2])
					cNFAtu   := (cAliasSF3)->F3_NFISCAL
					cEmissNF := (cAliasSF3)->F3_EMISSAO
				else
					cRazSoc :=""
					cNIT:=""
				End
				if !Empty(alltrim((cAliasSF3)->F3_UNOMBRE))
					cRazSoc := alltrim((cAliasSF3)->F3_UNOMBRE)
				end
				if !Empty(alltrim((cAliasSF3)->F3_UNIT))
					cNIT := alltrim((cAliasSF3)->F3_UNIT)
				end
				If  EMPTY(cRazSoc).or. EMPTY(cNIT)

					If (cAliasSF3)->F3_TIPO == "B" .OR. (cAliasSF3)->F3_TIPOMOV = "V"
						cRazSoc := Posicione("SA1",1,xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A1_NOME")
						cNIT	:= Posicione("SA1",1,xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A1_CGC")
						If Empty(cNIT)
							cNIT := Posicione("SA1",1,xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A1_RG")
						Endif
						cNFAtu   := (cAliasSF3)->F3_NFISCAL
						cEmissNF := (cAliasSF3)->F3_EMISSAO
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se as informacoes da companhia area estao preenchidas.³
						//³Se sim, os dados no livro devem ser da companhia aerea.        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lPassag .And. !Empty((cAliasSF3)->F3_COMPANH) .And. !Empty((cAliasSF3)->F3_LOJCOMP)
							cRazSoc := Posicione("SA2",1,xFilial("SA2")+(cAliasSF3)->F3_COMPANH+(cAliasSF3)->F3_LOJCOMP,"A2_NOME")
							cNIT	:= Posicione("SA2",1,xFilial("SA2")+(cAliasSF3)->F3_COMPANH+(cAliasSF3)->F3_LOJCOMP,"A2_CGC")
							cNFAtu   := (cAliasSF3)->F3_PASSAGE
							cEmissNF := (cAliasSF3)->F3_DTPASSA
						Else
							// caso tenha uma politica de importacao ela deve ser impressa no lugar da NF
							If lNUMDES .And. !Empty(nNUMDES := Posicione("SF1",1,xFilial("SF1")+(cAliasSF3)->F3_NFISCAL,"F1_NUMDES"))
								lImport := .T.
								cRazSoc := Posicione("SA2",1,xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A2_NOME")
								cNIT	:= Posicione("SA2",1,xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A2_CGC")
								cNFAtu  := nNUMDES
								cEmissNF:= (cAliasSF3)->F3_EMISSAO
							Else
								cRazSoc := Posicione("SA2",1,xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A2_NOME")
								cNIT	:= Posicione("SA2",1,xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A2_CGC")
								cNFAtu   := (cAliasSF3)->F3_NFISCAL
								cEmissNF := (cAliasSF3)->F3_EMISSAO
							Endif
						Endif
					EndIf
				End
			Else   // vendas ----------------------------------------------------------------------------------------------

				If (cAliasSF3)->F3_TIPO == "B" .OR. (cAliasSF3)->F3_TIPOMOV = "C"
					cRazSoc := Posicione("SA2",1,xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A2_NOME")
					cNIT	:= Posicione("SA2",1,xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A2_CGC")
					cNFAtu   := (cAliasSF3)->F3_NFISCAL
					cEmissNF := (cAliasSF3)->F3_EMISSAO
				Else
					cRazSoc := ''
					/*If SF2->(DbSeek((cAliasSF3)->(F3_FILIAL+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)))
					cRazSoc := alltrim(SF2->F2_UNOMCLI)
					cNIT	   := SF2->F2_UNITCLI
					End*/
					aDatosCli:= u_GetNomNit((cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_CLIEFOR,(cAliasSF3)->F3_LOJA,(cAliasSF3)->f3_filial)
					iF Len(aDatosCli)>0
						cRazSoc := alltrim(aDatosCli[1])
						cNIT	   := aDatosCli[2]
					end
					If Empty(alltrim(cRazSoc))
						cRazSoc := alltrim(Posicione("SA1",1,xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A1_UNOMFAC"))
						cNIT	:= Posicione("SA1",1,xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A1_UNITFAC")
					END

					if(!empty((cAlias)->F3_DTCANC))
						cRazSoc:=	'A N U L A D A'
						cNit:= "0"
					end
					If Empty(alltrim(cRazSoc))
						cRazSoc := Posicione("SA1",1,xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A1_NOME")
						cNIT	:= alltrim(str(Posicione("SA1",1,xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA,"A1_CGC")))
					end

					cNFAtu   := (cAliasSF3)->F3_NFISCAL
					cEmissNF := (cAliasSF3)->F3_EMISSAO
				EndIf
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Dados da Nota Fiscal                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			// serie da nota fiscal atual
			cSerieAtu := (cAliasSF3)->F3_SERIE

			// caso tenha mudado a serie, utilizado para imprimir as notas anteriores q foram deletadas
			if (cSerieAnt <> cSerieAtu) .and. nLivro <> 1

				lFistNFs := .F.

				For nNum:=1 to Len(aFistNFs)

					If ALLTRIM(aFistNFs[nNum][1]) == ALLTRIM(cSerieAtu)
						nNFAnt := val(aFistNFs[nNum][2])
						lFistNFs := .T.
					Endif
				Next

				If !lFistNFs
					nNFAnt := Val((cAliasSF3)->F3_NFISCAL)
				Endif

			Endif

			// se a nota foi excluida
			/*	If nImpExclu == 1 .AND. nNFAnt <> nil .AND. nLivro <> 1 .AND. (cAliasSF3)->F3_FORMUL == 'S'
			nAuxNFAtu := val(cNFAtu)
			for nNum:=nNFAnt+1 to nAuxNFAtu-1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho do relatorio    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			iF nLivro == 1
			AADD(aDados,{"","",STR0052,Iif(Empty((cAliasSF3)->F3_SERIE),padr(strzero(nNum, len((cAliasSF3)->F3_NFISCAL)), len((cAliasSF3)->F3_NFISCAL)),padr(strzero(nNum, len((cAliasSF3)->F3_NFISCAL)), len((cAliasSF3)->F3_PASSAGE))+SPACE(4)),; ///-> tirar a série
			"","","","","","","","","",cChaveSf3 })
			else
			AADD(aDados,{"","",STR0052,Iif(Empty((cAliasSF3)->F3_SERIE),padr(strzero(nNum, len((cAliasSF3)->F3_NFISCAL)), len((cAliasSF3)->F3_NFISCAL)),padr(strzero(nNum, len((cAliasSF3)->F3_NFISCAL)), len((cAliasSF3)->F3_PASSAGE))+SPACE(4)),; ///-> tirar a série
			"","","","","","","","",cChaveSf3 })
			end
			next
			Endif*/

			// verifica se a nota deve ser impressa no livro escolhido
			If lImprime(nLivro, (cAliasSF3)->F3_TIPOMOV, ALLTRIM((cAliasSF3)->F3_ESPECIE))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho do relatorio    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( nLin > 56 .Or. nLin == 0 )
					If (aTotPar[2]+aTotPar[3]+aTotPar[4]+aTotPar[5]+aTotPar[6]) > 0
						FmtLin(,aL[01],,,@nLin)
						FmtLin(aTotPar,aL[04],,,@nLin)		//Parciais
						FmtLin({"",""},aL[06],,,@nLin)
						aSubTot:=aTotGer
						FmtLin(aSubTot,aL[09],,,@nLin)		//Totais
						FmtLin({"",""},aL[08],,,@nLin)
						aTotPar	:= {OemToAnsi(STR0008),0,0,0,0,0}		//Totais Parciais
					Endif
					nLin := CabecRel(nLivro,@cFolha)
				Endif
				// verifica se a nota nao foi anulada
				if empty((cAliasSF3)->F3_DTCANC)

					If Valtype(cEmissNF)=="D"
						cEmissNF := Strzero(Day(cEmissNF),2)+"/"+Strzero(Month(cEmissNF),2)+"/"+Strzero(Year(cEmissNF),4)
					ElseIf Valtype(cEmissNF)=="C"
						cEmissNF := Substr(cEmissNF,7,2)+"/"+Substr(cEmissNF,5,2)+"/"+Substr(cEmissNF,1,4)
					EndIf
					If nLivro == 1
						nPos := Ascan(aDados,{|x|x[13]==cChaveSf3})
					else
						nPos := Ascan(aDados,{|x|x[12]==cChaveSf3})
					end

					If nPos > 0
						If nLivro == 1 //compras
							aDados[nPos,08] += (cAliasSF3)->F3_VALCONT + (cAliasSF3)->F3_VALOBSE                                 				//07 Total da Nota Fiscal (A)
							//aDados[nPos,09] += 0 //Iif(lVALIMP,FieldGet(FieldPos("F3_VALIMP"+mv_par08)),0) 				//08 Total ICE. (B)
							aDados[nPos,10] += (cAliasSF3)->F3_EXENTAS + (cAliasSF3)->F3_VALOBSE													//09 Total Importes Exentos (C)

							If aImpostos[1][3] > 0 .AND. (cAlias)->F3_VALIMP5 == 0 //Importe Neto (A-B-C)
								aDados[nPos, 11] := (cAlias)->(FieldGet(aImpostos[1][3]))
							Elseif (cAlias)->F3_VALIMP5 > 0
								aDados[nPos, 11] := (cAlias)->F3_VALCONT-(cAlias)->F3_VALIMP5
							Else
								aDados[nPos, 11] := 0
							Endif

							//	aDados[nPos,10] += Iif(aImpostos[1][3] > 0,(cAliasSF3)->(FieldGet(aImpostos[1][3])),0)	//10 Importe Neto (A-B-C)
							aDados[nPos,12] += Iif(aImpostos[1][4] > 0,(cAliasSF3)->(FieldGet(aImpostos[1][4])),0)	//11 Credito Fiscal IVA
						else
							aDados[nPos,07] += (cAliasSF3)->F3_VALCONT + (cAliasSF3)->F3_VALOBSE                                 				//07 Total da Nota Fiscal (A)
							aDados[nPos,08] += Iif(lVALIMP,IIF(FieldGet(FieldPos("F3_VALIMP"+mv_par08))<> NIL,FieldGet(FieldPos("F3_VALIMP"+mv_par08)),0),0) 				//08 Total ICE. (B)
							aDados[nPos,09] += (cAliasSF3)->F3_EXENTAS + (cAliasSF3)->F3_VALOBSE													//09 Total Importes Exentos (C)

							If aImpostos[1][3] > 0 .AND. (cAlias)->F3_VALIMP5 == 0 //Importe Neto (A-B-C)
								aDados[nPos, 10] := (cAlias)->(FieldGet(aImpostos[1][3]))
							Elseif (cAlias)->F3_VALIMP5 > 0
								aDados[nPos, 10] := (cAlias)->F3_VALCONT-(cAlias)->F3_VALIMP5
							Else
								aDados[nPos, 10] := 0
							Endif

							//	aDados[nPos,10] += Iif(aImpostos[1][3] > 0,(cAliasSF3)->(FieldGet(aImpostos[1][3])),0)	//10 Importe Neto (A-B-C)
							aDados[nPos,11] += Iif(aImpostos[1][4] > 0,(cAliasSF3)->(FieldGet(aImpostos[1][4])),0)	//11 Credito Fiscal IVA
						end
					Else
						If nLivro == 1
							AADD(aDados,{Iif((MV_PAR11==1 .And. nLivro == 1),(cAliasSF3)->F3_ENTRADA,cEmissNF),; 		//01 Data
							cNIT,;                                                                 		//02 Numero de NiT
							cRazSoc,; 															   		//03 Nome Cli/For
							alltrim(Iif(lImport,padr(cNFAtu,len(SF1->F1_NUMDES)),  Iif(!Empty((cAliasSF3)->F3_SERIE),padr(cNFAtu,len((cAliasSF3)->F3_PASSAGE)) + SPACE(4),padr(cNFAtu,len((cAliasSF3)->F3_PASSAGE)))    )),; ///-> tirar a série
							cPoliza,;
							alltrim(Replicate(" ",15-LEN(AllTrim(cAutoriz))) + AllTrim(cAutoriz)),;				// 05 Numero de Autorizacao - (cAliasSF3)->F3_NUMAUT
							alltrim(Iif(!empty((cAlias)->F3_DTCANC), '0', Iif(Empty((cAliasSF3)->F3_CODCTR),Replicate(" ",14),Replicate(" ",14-LEN(AllTrim((cAliasSF3)->F3_CODCTR))) + AllTrim((cAliasSF3)->F3_CODCTR)))),;
							(cAliasSF3)->F3_VALCONT+ (cAliasSF3)->F3_VALOBSE,;													//07 Total da Nota Fiscal (A)
							Iif(lVALIMP,FieldGet(FieldPos("F3_VALIMP"+mv_par08)),0),;					//08 Total ICE. (B)
							(cAliasSF3)->F3_EXENTAS+(cAliasSF3)->F3_VALOBSE,; 													//09 Total Importes Exentos (C)
							Iif(aImpostos[1][3]>0 .And. (cAliasSF3)->F3_VALIMP5 == 0, (cAliasSF3)->(FieldGet(aImpostos[1][3])), Iif((cAliasSF3)->F3_VALIMP5 > 0, (cAliasSF3)->F3_VALCONT-(cAliasSF3)->F3_VALIMP5,0)),;	//10 Importe Neto (A-B-C)												,;
							Iif(aImpostos[1][4] > 0,(cAliasSF3)->(FieldGet(aImpostos[1][4])),0),;		//11 Credito Fiscal IVA
							cChaveSf3}) 																//12 Chave
						else
							AADD(aDados,{Iif((MV_PAR11==1 .And. nLivro == 1),(cAliasSF3)->F3_ENTRADA,cEmissNF),; 		//01 Data
							alltrim((cNIT)),;                                                                 		//02 Numero de NiT
							cRazSoc,; 															   		//03 Nome Cli/For
							Iif(lImport,padr(cNFAtu,len(SF1->F1_NUMDES)),  Iif(!Empty((cAliasSF3)->F3_SERIE),padr(cNFAtu,len((cAliasSF3)->F3_PASSAGE)) + SPACE(4),padr(cNFAtu,len((cAliasSF3)->F3_PASSAGE)))    ),; ///-> tirar a série
							Replicate(" ",15-LEN(AllTrim(cAutoriz))) + AllTrim(cAutoriz),;				// 05 Numero de Autorizacao - (cAliasSF3)->F3_NUMAUT
							Iif(!empty((cAlias)->F3_DTCANC), '0', Iif(Empty((cAliasSF3)->F3_CODCTR),Replicate(" ",14),Replicate(" ",14-LEN(AllTrim((cAliasSF3)->F3_CODCTR))) + AllTrim((cAliasSF3)->F3_CODCTR))),;
							(cAliasSF3)->F3_VALCONT+ (cAliasSF3)->F3_VALOBSE,;													//07 Total da Nota Fiscal (A)
							Iif(lVALIMP,IIF(FieldGet(FieldPos("F3_VALIMP"+mv_par08))<>NIL,FieldGet(FieldPos("F3_VALIMP"+mv_par08)),0),0),;					//08 Total ICE. (B)
							(cAliasSF3)->F3_EXENTAS+(cAliasSF3)->F3_VALOBSE,; 													//09 Total Importes Exentos (C)
							Iif(aImpostos[1][3]>0 .And. (cAliasSF3)->F3_VALIMP5 == 0, (cAliasSF3)->(FieldGet(aImpostos[1][3])), Iif((cAliasSF3)->F3_VALIMP5 > 0, (cAliasSF3)->F3_VALCONT-(cAliasSF3)->F3_VALIMP5,0)),;	//10 Importe Neto (A-B-C)												,;
							Iif(aImpostos[1][4] > 0,(cAliasSF3)->(FieldGet(aImpostos[1][4])),0),;		//11 Credito Fiscal IVA
							cChaveSf3}) 																//12 Chave
						end
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprime dados da Nota Fiscal           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//	FmtLin(aDados,aL[03],,,@nLin)
				Else // se a nota foi anulada
					If nImpExclu == 1
						AADD(aDados,{Iif((MV_PAR11==1 .And. nLivro == 1),(cAliasSF3)->F3_ENTRADA,cEmissNF),cNIT,cRazSoc, ;
						Iif(Empty((cAliasSF3)->F3_SERIE),padr(cNFAtu,len((cAliasSF3)->F3_PASSAGE)),padr(cNFAtu,len((cAliasSF3)->F3_PASSAGE))+ SPACE(4)),;   ///-> tirar a série
						"","","0","0.00","","","0.00","0.00","",cChaveSf3 })
					Endif
				Endif

				If (cAliasSF3)->F3_FORMUL == 'S'
					// na proxima rodada do while nNFAnt tera o valor da nota fiscal anterior
					nNFAnt := val(cNFAtu)
				Endif
			Else // caso a nota nao seja do livro especificado a numeracao avanca para q neste livro nao seja impressa como excluida
				If (cAliasSF3)->F3_FORMUL == 'S'
					nNFAnt := val(cNFAtu)
					nNFAnt++
				Endif
			Endif

			If (cAliasSF3)->F3_FORMUL = 'S'
				// ultima data da nota da serie anterior
				// cDatNFAnt := (cAliasSF3)->F3_EMISSAO
				// na proxima rodada do while cSerieAnt tera o valor da serie da nota fiscal anterior
				cSerieAnt := (cAliasSF3)->F3_SERIE
			Endif

			dbSelectArea(cAliasSF3)
			(cAliasSF3)->(dbSkip())
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime dados da Nota Fiscal           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx := 1 to len(aDados)
			If ( nLin > 56 .Or. nLin == 0 )
				If (aTotPar[2]+aTotPar[3]+aTotPar[4]+aTotPar[5]+aTotPar[6]) > 0
					FmtLin(,aL[01],,,@nLin)
					FmtLin(aTotPar,aL[04],,,@nLin)		//Parciais
					FmtLin({"",""},aL[06],,,@nLin)
					aSubTot:=aTotGer
					FmtLin(aSubTot,aL[09],,,@nLin)		//Totais
					FmtLin({"",""},aL[08],,,@nLin)
					aTotPar	:= {OemToAnsi(STR0008),0,0,0,0,0}		//Totais Parciais
				Endif
				nLin := CabecRel(nLivro,@cFolha)
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Aculadores Totais ( Parcial e Geral )  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLivro == 1
				//Total da Nota Fiscal
				If Valtype(aDados[nx,08])=="N"
					aTotPar[2] += aDados[nx,08]
					aTotGer[2] += aDados[nx,08]
				EndIf
				//Total ICE
				If Valtype(aDados[nx,09])=="N"
					aTotPar[3] += aDados[nx,09]
					aTotGer[3] += aDados[nx,09]
				EndIf
				//Total Importes Exentos
				If Valtype(aDados[nx,10])=="N"
					aTotPar[4] += aDados[nx,10]
					aTotGer[4] += aDados[nx,10]
				EndIf
				//Total Importe Neto
				If Valtype(aDados[nx,11])=="N"
					aTotPar[5] += aDados[nx,11]
					aTotGer[5] += aDados[nx,11]
				EndIf
				//Total Credito Fiscal IVA
				If Valtype(aDados[nx,12])=="N"
					aTotPar[6] += aDados[nx,12]
					aTotGer[6] += aDados[nx,12]
				EndIf
			else // ventas
				//Total da Nota Fiscal
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime Relatorio      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//Erick Modificado
				neto:= aDados[nx,07]-aDados[nx,08]-aDados[nx,09]
				aDados[nx,10]:= neto

				If Valtype(aDados[nx,07])=="N"
					aTotPar[2] += aDados[nx,07]
					aTotGer[2] += aDados[nx,07]
					aTotInf[2] += aDados[nx,07]
				EndIf
				//Total ICE
				If Valtype(aDados[nx,08])=="N"
					aTotPar[3] += aDados[nx,08]
					aTotGer[3] += aDados[nx,08]
					aTotInf[3] += aDados[nx,08]
				EndIf
				//Total Importes Exentos
				If Valtype(aDados[nx,09])=="N"
					aTotPar[4] += aDados[nx,09]
					aTotGer[4] += aDados[nx,09]
					aTotInf[4] += aDados[nx,09]
				EndIf
				//Total Importe Neto
				If Valtype(aDados[nx,10])=="N"
					aTotPar[5] += aDados[nx,10]
					aTotGer[5] += aDados[nx,10]
					aTotInf[5] += aDados[nx,10]

				EndIf
				//Total Credito Fiscal IVA
				If Valtype(aDados[nx,11])=="N"
					aTotPar[6] += aDados[nx,11]
					aTotGer[6] += aDados[nx,11]
					aTotInf[6] += aDados[nx,11]
				EndIf
			end

			FmtLin(aDados[nx],aL[03],,,@nLin)
		next
		If (aTotPar[2]+aTotPar[3]+aTotPar[4]+aTotPar[5]+aTotPar[6]) > 0
			FmtLin(,aL[01],,,@nLin)
			FmtLin(aTotPar,aL[04],,,@nLin)		//Parciais
			FmtLin({cRG,cResp},aL[06],,,@nLin)
			FmtLin(aTotGer,aL[07],,,@nLin)		//Totais

			FmtLin({OemToAnsi(STR0026),Upper(OemToAnsi(STR0030))},aL[08],,,@nLin)
		EndIf

		SM0->(DbSkip())
	Enddo	// end while de filiais

	SM0->(RestArea(aAreaSM0))
	cFilAnt := SM0->M0_CODFIL
	If nLivro == 2
		FmtLin(aTotInf,aL[10],,,@nLin)		//Totais
		FmtLin({cRG,cResp},aL[06],,,@nLin)
	end
	If lQuery
		//	DbSelectArea(cAlias)
		//	DbCloseArea()

		dbSelectArea(cAlias)
		dbCloseArea()
	Else

		dbSelectArea("SF3")
		RetIndex("SF3")
		dbClearFilter()
		Ferase(cIndexSF3+OrdBagExt())
	Endif

	If aReturn[5]==1
		dbCommitAll()
		Set Printer To
		OurSpool(wnRel)
	Endif

	MS_FLUSH()

	// deleta a tabela temporaria
	If nLivro == 1	//Compras
		If !Empty(cAliasSF3)
			DbSelectArea(cAliasSF3)
			DbCloseArea()
			If File(cArqTrab + GetDBExtension())
				Ferase(cArqTrab + GetDBExtension())
			EndIf
			If File(cArqTrab + OrdBagExt())
				Ferase(cArqTrab + OrdBagExt())
			EndIf
			DbSelectArea("SF3")
		EndIf
	Endif
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CabecRel   ³Autor ³ Sergio S. Fuzinaka    ³ Data ³ 25.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Cabecalho do Relatorio                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CabecRel(nLivro,cFolha)

	Local nLin		:= 0
	Local cMesini	:= StrZero(Month(mv_par02),2)
	Local cAnoini	:= StrZero(Year(mv_par02),4)
	//Local cMesfim	:= StrZero(Month(mv_par03),2)
	//Local cAnofim	:= StrZero(Year(mv_par03),4)

	nLin := 1
	If nLivro == 1	//Compras
		@ nLin, 001 PSay Upper(OemToAnsi(STR0019))+"  "+cMesini+"/"+cAnoini//+" - "+cMesfim+"/"+cAnofim
	Else
		@ nLin, 001 PSay Upper(OemToAnsi(STR0020))+"  "+cMesini+"/"+cAnoini//+" - "+cMesfim+"/"+cAnofim
	Endif
	cFolha := soma1(cFolha,3)
	@ nLin, 197 PSay Upper(OemToAnsi(STR0021))+cFolha
	nLin := (nLin+3)
	@ nLin, 001 PSay Upper(OemToAnsi(STR0022))+SM0->M0_NOMECOM
	@ nLin, 150 PSay Upper(OemToAnsi(STR0023))+SM0->M0_CGC
	nLin := (nLin+1)
	@ nLin, 001 PSay Upper(OemToAnsi(STR0024))+SM0->M0_FILIAL  //CalcXFil(cFilAnt)
	@ nLin, 025 PSay Upper(OemToAnsi(STR0025))+SM0->M0_ENDENT
	nLin := (nLin+2)
	FmtLin(,aL[02],,,@nLin)
	@ nLin, 000 PSay Upper(OemToAnsi(STR0003))
	nLin := (nLin+1)
	FmtLin(,aL[01],,,@nLin)
	if nLivro == 1	//Compras
		@ nLin, 000 PSay Upper(OemToAnsi(STR0006))
		nLin := (nLin+1)
		@ nLin, 000 PSay Upper(OemToAnsi(STR0007))
		nLin := (nLin+1)
	else
		@ nLin, 000 PSay Upper(OemToAnsi(STR0031))
		nLin := (nLin+1)
		@ nLin, 000 PSay Upper(OemToAnsi(STR0032))
		nLin := (nLin+1)
	endif
	FmtLin(,aL[01],,,@nLin)

Return( nLin )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CabecRel   ³Autor ³ Fernando Separovic    ³ Data ³ 25.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Verifica se uma nota deve ou nao ser impressa               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function lImprime(nLivro, cTipoMov, cEspecie)

	Local lImpressao := .F.

	If nLivro == 1 // compras
		If cTipoMov == "C" .AND. cEspecie <> "NCP" ;
		.AND. cEspecie <> "NCI" ;
		.AND. cEspecie <> "NDP" ;
		.AND. cEspecie <> "NDI"
			lImpressao := .T.
		Else
			If cTipoMov == "V" .AND. (cEspecie == "NCC" .OR. ;
			cEspecie == "NCE" .OR. ;
			cEspecie == "NDC" .OR. ;
			cEspecie == "NDE")
				lImpressao := .T.
			Else
				lImpressao := .F.
			Endif
		Endif
	Else
		If cTipoMov == "V" .AND. cEspecie <> "NCC" ;
		.AND. cEspecie <> "NCE" ;
		.AND. cEspecie <> "NDC" ;
		.AND. cEspecie <> "NDE"
			lImpressao := .T.
		Else
			If cTipoMov == "C" .AND. (cEspecie == "NCP" .OR. ;
			cEspecie == "NCI" .OR. ;
			cEspecie == "NDP" .OR. ;
			cEspecie == "NDI")
				lImpressao := .T.
			Else
				lImpressao := .F.
			Endif
		Endif
	Endif

return lImpressao

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CabecRel   ³Autor ³ Fernando Separovic    ³ Data ³ 25.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Transforma uma numero de uma filial de dois digitos em tres ³±±
±±³          ³digitos                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*

Static Function CalcXFil(cfilial)

Local cFistdig  := substr(cfilial,1,1)
Local cValor    := ""
Local cAuxFil   := "99"
Local nFiliais  := 99

// se a filial for menor que 99 retorna a filial
if cFistdig == "0" .OR. len(ALLTRIM(STR(VAL(cfilial)))) == 2
cValor := cfilial
else
while cAuxFil <> cfilial
cAuxFil :=	soma1(cAuxFil)
nFiliais++
enddo

cValor := ALLTRIM(str(nFiliais))
endif

Return cValor
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³LayOut     ³Autor ³ Sergio S. Fuzinaka    ³ Data ³ 25.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Layout do Relatorio                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LayOut(aL)

	aL[01] := "+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
	aL[02] := "                                                                                                                                +------------------------------------------------------------------------------------+"

	If mv_par01 == 1
		aL[03] := "|##########| ##############|##########################################|#############|#########|################| ############## |############### |############### |############### |############### |############### |"
	ELSE
		aL[03] := "| ########## | ############### | ######################################## | ################ | ############### | ############## |############### |############### |############### |############### |############### |"
	end
	aL[04] := "                                                                                                               | ############## |############### |############### |############### |############### |############### |"
	aL[05] := "                                                                                                               +-----------------------------------------------------------------------------------------------------+"
	aL[06] := " ####################   ######################################################                                 +-----------------------------------------------------------------------------------------------------+"
	aL[07] := " --------------------   ------------------------------------------------------                                 | ############## |############### |############### |############### |############### |############### |"
	aL[08] := "         ####                      ###############################                                             +-----------------------------------------------------------------------------------------------------+"
	aL[09] := "                                                                                                               | ############## |############### |############### |############### |############### |############### |"
	If mv_par01 == 2
		aL[10] := "                                                                                                               | ############## |############### |############### |############### |############### |############### |"
	end
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSx1  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.06.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Ajusta Grupo de Perguntas "MTRBO2"                           ³±±
±±³          ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1(cPerg)

	Local aHelpP  := {}
	Local aHelpE  := {}
	Local aHelpS  := {}

	// mv_par01 - Livro: Compras ou Vendas
	Aadd(aHelpP, OemToAnsi(STR0010))	//"Informe o Livro que deseja imprimir:"
	Aadd(aHelpP, OemToAnsi(STR0011))	//"Compras ou Vendas"
	Aadd(aHelpE, OemToAnsi(STR0010))
	Aadd(aHelpE, OemToAnsi(STR0011))
	Aadd(aHelpS, OemToAnsi(STR0010))
	Aadd(aHelpS, OemToAnsi(STR0011))
	PutSx1(cPerg,"01",OemToAnsi(STR0053),OemToAnsi(STR0053),OemToAnsi(STR0053),"mv_ch1","N",1,0,0,"C",,,,,"mv_par01",OemToAnsi(STR0014),OemToAnsi(STR0014),OemToAnsi(STR0014),,OemToAnsi(STR0015),OemToAnsi(STR0015),OemToAnsi(STR0015),,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par02 - Data Inicial
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0012))	//"Informe a Data Inicial para geracao do"
	Aadd(aHelpP, OemToAnsi(STR0013))	//"Livro"
	Aadd(aHelpE, OemToAnsi(STR0012))
	Aadd(aHelpE, OemToAnsi(STR0013))
	Aadd(aHelpS, OemToAnsi(STR0012))
	Aadd(aHelpS, OemToAnsi(STR0013))
	PutSx1(cPerg,"02",OemToAnsi(STR0016),OemToAnsi(STR0016),OemToAnsi(STR0016),"mv_ch2","D",8,0,0,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par03 - Data Final
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0018))	//"Informe a Data Final para geracao do"
	Aadd(aHelpP, OemToAnsi(STR0013))	//"Livro"
	Aadd(aHelpE, OemToAnsi(STR0018))
	Aadd(aHelpE, OemToAnsi(STR0013))
	Aadd(aHelpS, OemToAnsi(STR0018))
	Aadd(aHelpS, OemToAnsi(STR0013))
	PutSx1(cPerg,"03",OemToAnsi(STR0017),OemToAnsi(STR0017),OemToAnsi(STR0017),"mv_ch3","D",8,0,0,"G",,,,,"mv_par03",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par04 - Filial De ?
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0034))	//"Informe o codigo inicial do intervalo"
	Aadd(aHelpP, OemToAnsi(STR0035))	//"de filiais que deseja imprimir no relatorio"
	Aadd(aHelpE, OemToAnsi(STR0034))
	Aadd(aHelpE, OemToAnsi(STR0035))
	Aadd(aHelpS, OemToAnsi(STR0034))
	Aadd(aHelpS, OemToAnsi(STR0035))
	PutSx1(cPerg,"04",OemToAnsi(STR0033),OemToAnsi(STR0033),OemToAnsi(STR0033),"mv_ch4","C",2,0,0,"G","","","","","mv_par04",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par05 - Filial Ate ?
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0037))	//"Informe o codigo final do intervalo"
	Aadd(aHelpP, OemToAnsi(STR0035))	//"de filiais que deseja imprimir no relatorio"
	Aadd(aHelpE, OemToAnsi(STR0037))
	Aadd(aHelpE, OemToAnsi(STR0035))
	Aadd(aHelpS, OemToAnsi(STR0037))
	Aadd(aHelpS, OemToAnsi(STR0035))
	PutSx1(cPerg,"05",OemToAnsi(STR0036),OemToAnsi(STR0036),OemToAnsi(STR0036),"mv_ch5","C",2,0,0,"G","","","","","mv_par05",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par06 - Iniciar numeracao de pagina em ?
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0039))	//"Informe o numero que deseja"
	Aadd(aHelpP, OemToAnsi(STR0040))   //"iniciar a numeracao de pagina"
	Aadd(aHelpE, OemToAnsi(STR0039))
	Aadd(aHelpE, OemToAnsi(STR0040))
	Aadd(aHelpS, OemToAnsi(STR0039))
	Aadd(aHelpS, OemToAnsi(STR0040))
	PutSx1(cPerg,"06",OemToAnsi(STR0038),OemToAnsi(STR0038),OemToAnsi(STR0038),"mv_ch6","N",3,0,0,"G","(mv_par06>=1) .And. (mv_par06<=999)","","","","mv_par06",,,,"001",,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par07 - Imprime excluidos ? Sim ou Nao
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0042))	//"Informe se no relatorio seram"
	Aadd(aHelpP, OemToAnsi(STR0043))   //"impressos os documentos excluidos:"
	Aadd(aHelpP, OemToAnsi(STR0044))   //"Sim ou Nao"
	Aadd(aHelpE, OemToAnsi(STR0042))
	Aadd(aHelpE, OemToAnsi(STR0043))
	Aadd(aHelpE, OemToAnsi(STR0044))
	Aadd(aHelpS, OemToAnsi(STR0042))
	Aadd(aHelpS, OemToAnsi(STR0043))
	Aadd(aHelpS, OemToAnsi(STR0044))
	PutSx1(cPerg,"07",OemToAnsi(STR0041),OemToAnsi(STR0041),OemToAnsi(STR0041),"mv_ch7","N",1,0,0,"C",,,,,"mv_par07",OemToAnsi(STR0045),OemToAnsi(STR0045),OemToAnsi(STR0045),,OemToAnsi(STR0046),OemToAnsi(STR0046),OemToAnsi(STR0046),,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par08 - Coluna Total ICE ?
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0048))	//"Coluna do Total I.C.E. ?"
	Aadd(aHelpP, OemToAnsi(STR0049))   //"iniciar a numeracao de pagina"
	Aadd(aHelpE, OemToAnsi(STR0048))
	Aadd(aHelpE, OemToAnsi(STR0049))
	Aadd(aHelpS, OemToAnsi(STR0048))
	Aadd(aHelpS, OemToAnsi(STR0049))
	PutSx1(cPerg,"08",OemToAnsi(STR0047),OemToAnsi(STR0047),OemToAnsi(STR0047),"mv_ch8","C",1,0,0,"G",,,,,"mv_par08",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par09 - RG
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0028))	//"Informe o Numero do R.G. do Responsavel"
	Aadd(aHelpE, OemToAnsi(STR0028))
	Aadd(aHelpS, OemToAnsi(STR0028))
	PutSx1(cPerg,"09",OemToAnsi(STR0026),OemToAnsi(STR0026),OemToAnsi(STR0026),"mv_ch9","C",20,0,0,"G",,,,,"mv_par09",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par10 - Responsavel
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0029))	//"Informe o Nome Completo do Responsavel"
	Aadd(aHelpE, OemToAnsi(STR0029))
	Aadd(aHelpS, OemToAnsi(STR0029))
	PutSx1(cPerg,"10",OemToAnsi(STR0027),OemToAnsi(STR0027),OemToAnsi(STR0027),"mv_cha","C",55,0,0,"G",,,,,"mv_par10",,,,,,,,,,,,,,,,,aHelpP,aHelpE,aHelpS)

	// mv_par11 - Ordenar relatório: Entrada ou Saída
	aHelpP  := {}
	aHelpE  := {}
	aHelpS  := {}
	Aadd(aHelpP, OemToAnsi(STR0054))	//"Informe se o relatorio será ordenado por:"
	Aadd(aHelpP, OemToAnsi(STR0055))	//"Data de digitacao ou Data de emissao"
	Aadd(aHelpE, OemToAnsi(STR0054))
	Aadd(aHelpE, OemToAnsi(STR0055))
	Aadd(aHelpS, OemToAnsi(STR0054))
	Aadd(aHelpS, OemToAnsi(STR0055))
	PutSx1(cPerg,"11",OemToAnsi(STR0056),OemToAnsi(STR0056),OemToAnsi(STR0056),"mv_ch11","N",1,0,0,"C",,,,,"mv_par11",OemToAnsi(STR0057),OemToAnsi(STR0057),OemToAnsi(STR0057),,OemToAnsi(STR0058),OemToAnsi(STR0058),OemToAnsi(STR0058),,,,,,,,,,aHelpP,aHelpE,aHelpS)

Return Nil

// campo utilizados no relatorio e na tabela temporaria
/* 	AADD(aEstrSF3, {"F3_EMISSAO","D",8, 0})
AADD(aEstrSF3, {"F3_ENTRADA","D",8, 0})
AADD(aEstrSF3, {"F3_NFISCAL","C",12,0})
AADD(aEstrSF3, {"F3_SERIE"  ,"C",3, 0})
AADD(aEstrSF3, {"F3_CLIEFOR","C",6, 0})
AADD(aEstrSF3, {"F3_LOJA"   ,"C",2, 0})
AADD(aEstrSF3, {"F3_TIPO"   ,"C",1, 0})
AADD(aEstrSF3, {"F3_FORMUL" ,"C",1, 0})
AADD(aEstrSF3, {"F3_VALCONT","N",14,2})
AADD(aEstrSF3, {"F3_ESPECIE","C",5, 0})
AADD(aEstrSF3, {"F3_VALIMP" ,"N",14,2})
AADD(aEstrSF3, {"F3_VALIMP1","N",14,2})
AADD(aEstrSF3, {"F3_VALIMP2","N",14,2})
AADD(aEstrSF3, {"F3_VALIMP3","N",14,2})
AADD(aEstrSF3, {"F3_VALIMP4","N",14,2})
AADD(aEstrSF3, {"F3_VALIMP5","N",14,2})
AADD(aEstrSF3, {"F3_VALIMP6","N",14,2})
AADD(aEstrSF3, {"F3_VALIMP7","N",14,2})
AADD(aEstrSF3, {"F3_VALIMP8","N",14,2})
AADD(aEstrSF3, {"F3_VALIMP9","N",14,2})
AADD(aEstrSF3, {"F3_VALIMPA","N",14,2})
AADD(aEstrSF3, {"F3_VALIMPB","N",14,2})
AADD(aEstrSF3, {"F3_VALIMPC","N",14,2})
AADD(aEstrSF3, {"F3_VALIMPD","N",14,2})
AADD(aEstrSF3, {"F3_VALIMPE","N",14,2})
AADD(aEstrSF3, {"F3_VALIMPH","N",14,2})
AADD(aEstrSF3, {"F3_VALIMPI","N",14,2})
AADD(aEstrSF3, {"F3_TIPOMOV","C",1 ,0})
AADD(aEstrSF3, {"F3_FILIAL" ,"C",2 ,0})
AADD(aEstrSF3, {"F3_DTCANC" ,"D",8 ,0})
AADD(aEstrSF3, {"F3_EXENTAS","N",16,2})
AADD(aEstrSF3, {"F3_NUMAUT" ,"C",15,0})
AADD(aEstrSF3, {"F3_CODCTR" ,"C",14,0})
AADD(aEstrSF3, {"F3_COMPANH","C",6, 0})
AADD(aEstrSF3, {"F3_LOJCOMP","C",2, 0})
AADD(aEstrSF3, {"F3_PASSAGE","C",13,0})
AADD(aEstrSF3, {"F3_DTPASSA","D",8, 0})
AADD(aEstrSF3, {"F3_BASIMP" ,"N",14,2})
AADD(aEstrSF3, {"F3_BASIMP1","N",14,2})
AADD(aEstrSF3, {"F3_BASIMP2","N",14,2})
AADD(aEstrSF3, {"F3_BASIMP3","N",14,2})
AADD(aEstrSF3, {"F3_BASIMP4","N",14,2})
AADD(aEstrSF3, {"F3_BASIMP5","N",14,2})
AADD(aEstrSF3, {"F3_BASIMP6","N",14,2})
AADD(aEstrSF3, {"F3_BASIMP7","N",14,2})
AADD(aEstrSF3, {"F3_BASIMP8","N",14,2})        */

// foi definido que apenas seram impressas as notas excluidas da data inicial para tras
// -------------- ultimas notas excluidas da serie atual da data final
/*if cSerieAnt <> nil

cAlias2 := GetNextAlias()
BeginSql Alias cAlias2
Column F3_EMISSAO as Date
SELECT MAX(F3_NFISCAL) as NF
FROM %Table:SF3% SF3
WHERE F3_FILIAL = %Exp:xFilial("SF3")% AND
F3_EMISSAO > %Exp:cDatNFAnt% AND
F3_SERIE = %Exp:cSerieAnt% AND
%exp:cCondicao%
SF3.%NotDel%
EndSql
cDebug := GetLastQuery()[2]		//Para debugar a query

nNFAtu2 := val((cAlias2)->NF)

if nNFAtu2 == 0
aArea := GetArea()
dbSelectArea("SX5")
dbSetOrder(1)

cAlias2 := GetNextAlias()
BeginSql Alias cAlias2
SELECT X5_DESCRI
FROM %Table:SX5% SX5
WHERE X5_FILIAL = %Exp:xFilial("SX5")% AND
X5_TABELA = '01' AND
X5_CHAVE = %Exp:cSerieAnt% AND
SX5.%NotDel%
EndSql
cDebug := GetLastQuery()[2]		//Para debugar a query

nNFAtu2 := VAL((cAlias2)->X5_DESCRI)

dbCloseArea()
restArea(aArea)
endif

for nNum:=nNFAnt+1 to nNFAtu2-1    // aqui muda em relacao a parte depois do while

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nLin > 60 .Or. nLin == 0 )
If (aTotPar[2]+aTotPar[3]+aTotPar[4]+aTotPar[5]+aTotPar[6]) > 0
FmtLin(,aL[01],,,@nLin)
FmtLin(aTotPar,aL[04],,,@nLin)		//Parciais
aTotPar	:= {OemToAnsi(STR0008),0,0,0,0,0}		//Totais Parciais
FmtLin(,aL[05],,,@nLin)
Endif
nLin := CabecRel(nLivro,@nFolha)
Endif

aDados[01] := ""
aDados[02] := ""
aDados[03] := "excluida_fimH"
aDados[04] := padr(strzero(nNum, len((cAliasSF3)->F3_NFISCAL)),len((cAliasSF3)->F3_PASSAGE)) + " / " + cSerieAnt
aDados[05] := ""
aDados[06] := ""
aDados[07] := ""
aDados[08] := ""
aDados[09] := ""
aDados[10] := ""
aDados[11] := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime dados da Nota Fiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FmtLin(aDados,aL[03],,,@nLin)
next

endif
// -----------------------------------------------------
*/

// foi definido que apenas seram impressas as notas excluidas da data inicial para tras
// -------------- ultimas notas excluidas da ultima serie da data final
/*	if nLivro <> 1
cAlias2 := GetNextAlias()
BeginSql Alias cAlias2
Column F3_EMISSAO as Date
SELECT MAX(F3_NFISCAL) as NF
FROM %Table:SF3% SF3
WHERE F3_FILIAL = %Exp:xFilial("SF3")% AND
F3_EMISSAO > %Exp:cDatNFAnt% AND
F3_SERIE = %Exp:cSerieAnt% AND
%exp:cCondicao%
SF3.%NotDel%
EndSql
cDebug := GetLastQuery()[2]		//Para debugar a query

nNFAtu2 := val((cAlias2)->NF)

if nNFAtu2 == 0
aArea := GetArea()
dbSelectArea("SX5")
dbSetOrder(1)

cAlias2 := GetNextAlias()
BeginSql Alias cAlias2
SELECT X5_DESCRI
FROM %Table:SX5% SX5
WHERE X5_FILIAL = %Exp:xFilial("SX5")% AND
X5_TABELA = '01' AND
X5_CHAVE = %Exp:cSerieAnt% AND
SX5.%NotDel%
EndSql
cDebug := GetLastQuery()[2]		//Para debugar a query

nNFAtu2 := VAL((cAlias2)->X5_DESCRI)

dbCloseArea()
restArea(aArea)

endif

nAuxNFAtu := val(cNFAtu)
for nNum:=nAuxNFAtu+1 to nNFAtu2-1
aDados[01] := ""
aDados[02] := ""
aDados[03] := "excluida_fim2"
aDados[04] := padr(strzero(nNum, len((cAlias)->F3_NFISCAL)),len((cAlias)->F3_PASSAGE)) + " / " + cSerieAnt
aDados[05] := ""
aDados[06] := ""
aDados[07] := ""
aDados[08] := ""
aDados[09] := ""
aDados[10] := ""
aDados[11] := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime dados da Nota Fiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FmtLin(aDados,aL[03],,,@nLin)
next
endif

// -----------------------------------------------------
*/
