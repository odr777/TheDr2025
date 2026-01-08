#Include "Protheus.Ch"
#Include "Davinci.Ch"

Static oTmpTabLCV

/*/                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DaVinci   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Preparacao do meio-magnetico para o software DaVinci-LCV,   ³±±
±±³          ³geracao dos Livros de Compra e Vendas IVA.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER Function DaVinciV(cLivro, cFilIni, cFilFim)

	Local aArea	:= GetArea()
	Local aTpNf	:= &(GetNewPar("MV_DAVINC1","{}"))

	Local cCpoPza		:= GetNewPar("MV_DAVINC2", "")	//Campo da tabela SF1: que contem o Numero de Poliza de Importacion
	Local cCpoDta		:= GetNewPar("MV_DAVINC3", "")	//Campo da tabela SF1: que contem a Data de Poliza de Importacion
	Local lOrdem		:= GetNewPar("MV_DAVINC4", .T.)	//Indica se arquivo sera ordenado por Emissao ou Entrada sendo F=Emissao e T=Entrada
	Local lPeriodoOK	:= (FunName() <> "MATA950")
	Local lProc			:= .T.

	Default cFilIni	 := xFilial("SF3")
	Default cFilFim	 := xFilial("SF3")

	GeraTemp(cLivro)

	If lPeriodoOK .or. BOL3Periodo()

		If cPaisLoc == "BOL" .And. LocBol()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    	//³Verifica a existencia dos parametros/campos                    ³
	    	//³Caso esses itens nao existam, nao sera efetuado o processamento³
	    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If Len(aTpNf) == 0
				lProc := .F.
				Help(" ",1,"MV_DAVINC1")
			EndIf
			If Empty(cCpoPza)
				lProc := .F.
				Help(" ",1,"MV_DAVINC2")
			EndIf
			If Empty(cCpoDta)
				lProc := .F.
				Help(" ",1,"MV_DAVINC3")
			EndIf

			If lProc
				ProcLivro(cLivro,cFilIni,cFilFim)
			EndIf
		EndIf

	EndIf

	RestArea(aArea)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GeraTemp   ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Gera arquivos temporarios                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTemp(cLivro)

	Local aStru		:= {}
	Local cArq		:= ""
	Local aOrdem	:= {}

	Default cLivro := "V"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Temporario LCV - Livro de Compras e Vendas IVA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aStru, {"NUMSEQ"	, "C", 006, 0})
	aAdd(aStru, {"TIPONF"	, "C", 001, 0})
	aAdd(aStru, {"NIT"		, "C", 013, 0})
	aAdd(aStru, {"RAZSOC"	, "C", 150, 0})
	aAdd(aStru, {"NFISCAL"	, "C", 018, 0})
	aAdd(aStru, {"POLIZA"	, "C", 016, 0})
	aAdd(aStru, {"NUMAUT"	, "C", 015, 0})
	aAdd(aStru, {"EMISSAO"	, "D", 008, 0})
	aAdd(aStru, {"VALCONT"	, "N", 012, 2})
	aAdd(aStru, {"EXPORT"	, "N", 012, 2})
	aAdd(aStru, {"EXENTAS"	, "N", 012, 2})
	aAdd(aStru, {"TAXAZERO"	, "N", 012, 2})
	aAdd(aStru, {"SUBTOT"	, "N", 012, 2})
	aAdd(aStru, {"DESCONT"	, "N", 012, 2})
	aAdd(aStru, {"BASEIMP"	, "N", 012, 2})
	aAdd(aStru, {"VALIMP"	, "N", 012, 2})
	aAdd(aStru, {"STATUSNF"	, "C", 001, 0})
	aAdd(aStru, {"CODCTR"	, "C", 017, 0})
	aAdd(aStru, {"DATAORD"	, "C", 008, 0})
	aAdd(aStru, {"DTNFORI"	, "D", 008, 0})
	aAdd(aStru, {"NFORI"	, "C", 018, 0})
	aAdd(aStru, {"AUTNFORI"	, "C", 015, 0})
	aAdd(aStru, {"VALNFORI"	, "N", 012, 2})

	//Nuevos campos adicionados
	aAdd(aStru, {"FILIAL"	, "C", 004, 0})
	aAdd(aStru, {"DTDIGIT"	, "D", 008, 0})
	aAdd(aStru, {"SERIE"	, "C", 003, 0})
	aAdd(aStru, {"NODIA"	, "C", 010, 0}) // Nahim nro contabilidad

	aOrdem := {"DATAORD"}

	oTmpTabLCV := FWTemporaryTable():New("LCV")
	oTmpTabLCV:SetFields(aStru)
	oTmpTabLCV:AddIndex("IN1", aOrdem)
	oTmpTabLCV:Create()

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ProcLivro  ³ Autor ³Sergio S. Fuzinaka     ³ Data ³ 25.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Processa o Livro de Compras e Vendas IVA                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcLivro(cLivro,cFilIni,cFilFim)

	Local cNumDoc 	:= ""
	Local dDemissao := dDatabase
	
	Local aImp		:= {}
	Local aAlias	:= {"SF3", ""}
	Local cTop		:= ""
	Local cDbf		:= ""
	Local cNIT		:= ""
	Local cRazSoc	:= ""
	Local cArray	:= GetNewPar("MV_DAVINC1", "{}")	//Tipo de Factura: 1-Compras para Mercado Interno;2-Compras para Exportacoes;3-Compras tanto para o Mercado Intero como para Exportacoes
	Local aTpNf		:= &cArray
	Local cTpNf		:= "1"								//1-Compras para Mercado Interno;2-Compras para Exportacoes;3-Compras tanto para o Mercado Intero como para Exportacoes
	Local nPos		:= 0
	Local nPosIVA	:= 0
	Local cCpoPza	:= GetNewPar("MV_DAVINC2", "")		//Campo da tabela SF1: que contem o Numero de Poliza de Importacion
	Local cCpoDta	:= GetNewPar("MV_DAVINC3", "")		//Campo da tabela SF1: que contem a Data de Poliza de Importacion
	Local lOrdem	:= GetNewPar("MV_DAVINC4", .T.)     //Indica se arquivo sera ordenado por Emissao ou Entrada sendo F=Emissao e T=Entrada
	Local cChave	:= ""
	Local cArqInd	:= ""
	Local nNumSeq	:= 0
	Local nDescont	:= 0
	Local lCalcLiq	:= .F.
	Local dDtNFOri	:= CTOD("")
	Local cNFOri	:= ""
	Local cAutNFOri	:= ""
	Local nValNFOri	:= 0
	Local lProcLiv	:= .T.
	Local aCposIsen	:= {}
	Local nInd		:= 0
	local cNodia	:= ""

	// odr 26/05/2021
	Local nTamDoc := TamSX3( "F3_NFISCAL" )[ 1 ] //JLJR: 

	Local lPassag 	:= 	cPaisLoc == "BOL" .And. GetNewPar("MV_PASSBOL",.F.) .And.;
	SF3->(ColumnPos("F3_COMPANH")) > 0 .And. ;
	SF3->(ColumnPos("F3_LOJCOMP")) > 0 .And. ;
	SF3->(ColumnPos("F3_PASSAGE")) > 0 .And. ;
	SF3->(ColumnPos("F3_DTPASSA")) > 0 .And. ;
	SF1->(ColumnPos("F1_COMPANH")) > 0 .And. ;
	SF1->(ColumnPos("F1_LOJCOMP")) > 0 .And. ;
	SF1->(ColumnPos("F1_PASSAGE")) > 0 .And. ;
	SF1->(ColumnPos("F1_DTPASSA")) > 0
	Local cStatus	 := ""
	Local cBonusTes  := SuperGetMv("MV_BONUSTS")
	Default cFilIni	 := xFilial("SF3")
	Default cFilFim	 := xFilial("SF3")

	// ALERT("cLivro: "+cLivro)
	If cLivro == "C"	//Compras

		cTop := "F3_FILIAL >= '" + cFilIni + "' AND F3_FILIAL <= '" + cFilFim + "' AND SUBSTRING(F3_CFO,1,1) < '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "' AND F3_ESPECIE = 'NF'"
		cDbf := "F3_FILIAL >= '" + cFilIni + "' .And. F3_FILIAL <= '" + cFilFim + "' .And.  SUBSTRING(F3_CFO,1,1) < '5' .And. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .And. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "' .And. ALLTRIM(F3_ESPECIE) == 'NF'"

		cTop += " AND F3_RECIBO <> '1'"
		cDbf += " .And. F3_RECIBO <> '1'"
		
		// omitir TES de retenciones
		// cTop += " AND F3_TES <> '010' AND F3_TES <> '011' AND F3_TES <> '020' AND F3_TES <> '021'"
		// cDbf += " .And. F3_TES <> '010' .And. F3_TES <> '011' .And. F3_TES <> '020' .And. F3_TES <> '021'"
		cTop += " AND F3_TES NOT IN ('010', '011', '012', '020', '021', '022', '110', '111', '112', '120', '121', '123') "
		cDbf += " .And. F3_TES NOT IN ('010', '011', '012', '020', '021', '022', '110', '111', '112', '120', '121', '123') "

		SF1->(dbSetOrder(1))
		If !lOrdem
			cArqInd := CriaTrab(Nil,.F.)
			LCV->(DBSetOrder(1))
		EndIf

	ElseIf cLivro == "V"	//Vendas
		cTop := "F3_FILIAL >= '" + cFilIni + "' AND F3_FILIAL <= '" + cFilFim + "' AND SUBSTRING(F3_CFO,1,1) >= '5' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02)+ "' AND F3_ESPECIE = 'NF'"
		cDbf := "F3_FILIAL >= '" + cFilIni + "' .And. F3_FILIAL <= '" + cFilFim + "' .And.   SUBSTRING(F3_CFO,1,1) >= '5' .And. DTOS(F3_EMISSAO) >= '" + DTOS(mv_par01) + "' .And. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "' .And. ALLTRIM(F3_ESPECIE) == 'NF'"

	Else // Notas de Credito/Debito Compras
		cTop := "F3_FILIAL >= '" + cFilIni + "' AND F3_FILIAL <= '" + cFilFim + "' AND F3_EMISSAO >= '" + DTOS(mv_par01) + "' AND F3_EMISSAO <= '" + DTOS(mv_par02) + "' AND "
		cDbf := "F3_FILIAL >= '" + cFilIni + "' .And. F3_FILIAL <= '" + cFilFim + "' .And. F3_EMISSAO >= '" + DTOS(mv_par01) + "' .And. DTOS(F3_EMISSAO) <= '" + DTOS(mv_par02) + "' .And. "
		
		cTop += "F3_ESPECIE <> 'NF' AND "
		cDbf += "F3_ESPECIE <> 'NF' .And. "

		if cLivro == "CDC"	//CDC Notas de Compras Deb/Cred
			cTop += "F3_TIPOMOV = 'C'
			cDbf += "F3_TIPOMOV = 'C'
		else				//VDC Notas de Ventas Deb/Cred		
			cTop += "F3_TIPOMOV = 'V'		
			cDbf += "F3_TIPOMOV = 'V'		
		ENDIF
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta aImp com as informacoes dos impostos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SFB")
	dbSetOrder(1)
	dbGoTop()

	aAdd(aImp,{"IVA",""})
	While !SFB->(Eof())
		If Subs(SFB->FB_CODIGO,1,2) <> "IT"
			nPos := aScan(aImp,{|x| SFB->FB_CODIGO $ x[1]})
			If nPos > 0
				aImp[nPos,2] := SFB->FB_CPOLVRO
			Else
				If cLivro$"C|V"
					If Empty(aScan(aCposIsen,{|x| SFB->FB_CPOLVRO $ x[1]})) .AND. (SFB->FB_CPOLVRO # aImp[1,2])
						aAdd(aCposIsen,{SFB->FB_CPOLVRO,SF3->(FieldPos("F3_VALIMP"+SFB->FB_CPOLVRO))})
					EndIf
				EndIf
			EndIf
		EndIf
		dbSkip()
	EndDo

	aSort(aImp,,,{|x,y| x[2] < y[2]})

	nPosIVA := Ascan(aImp,{|imp| imp[1] == "IVA"})

	aAdd(aImp[nPosIVA],SF3->(FieldPos("F3_BASIMP"+aImp[nPosIVA][2])))		//Base de Calculo
	aAdd(aImp[nPosIVA],SF3->(FieldPos("F3_VALIMP"+aImp[nPosIVA][2])))		//Valor do Imposto

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria Query / Filtro                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cLivro == "V"
		SF3->(dbSetOrder(1))//F3_FILIAL+DTOS(F3_EMISSAO)+F3_NFISCAL
	elseif cLivro == "C"
		// Para Otros 13		
		SF3->(dbSetOrder(13))//F3_FILIAL+DTOS(F3_EMISSAO)+STR(F3_VALCONT, 14, 2)

		// Para Union 12
		// SF3->(dbSetOrder(12))//F3_FILIAL+DTOS(F3_EMISSAO)+STR(F3_VALCONT, 14, 2)
	else
		SF3->(dbSetOrder(1))//F3_FILIAL+DTOS(F3_EMISSAO)+STR(F3_VALCONT, 14, 2) // ntp 19/12/19	
	endif 

	// Aviso("cTop", cTop,{'ok'},,,,,.t.)
	FsQuery(aAlias,1,cTop,cDbf,SF3->(IndexKey()))
	
	// alert("antes de SF3")
	dbSelectArea("SF3")
	While !Eof()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Define estado de la factura						" ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		IF (!Empty(SF3->F3_DTCANC))
			cStatus := IIf(SF3->F3_STATUS$"EN",SF3->F3_STATUS,"A")
		ELSE
			// Si serie es manual			
			//IF (POSICIONE("SFP", 1, SF3->F3_FILIAL + SF3->F3_FILIAL + SF3->F3_SERIE, "FP_LOTE")=="1")
			//IF (POSICIONE("SFP", 1, xFilial("SFP") + SF3->F3_FILIAL + SF3->F3_SERIE, "FP_LOTE")=="1")
			
			cSFPCompartido := SFPCompartido()
			IF (&cSFPCompartido == '1')
				// SI ESTADO ES NO UTILIZADA
				IF (SF3->F3_STATUS = 'N')
					cStatus := "N"
				ELSE
					cStatus := "C"	// Contingencia
				ENDIF
			else
				cStatus := "V"	// Válida
			endif
		ENDIF

		If (cLivro $ "V|C")   // Livro de Venda e ou Compra
			lProcLiv := .T.
		ElseIf !Empty(SF3->F3_DTCANC)  // Livro de Vendas/Compras Deb/Cred Canceladas
			//lProcLiv := IIf(cLivro == "VDC",.F.,.T.)
			lProcLiv := IIf(cLivro == "VDC",.T.,.F.)
			dDtNFOri 	:= CTOD("  /  /  ")
			cNFOri		:= '0'
			cAutNFOri	:= '0'
			nValNFOri	:= 0
		Else
		
	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	        //³Pesquisa documento de origem somente para os livros de "Vendas Deb/Cre" e "Compras Deb/Cred" ³
	        //³e que nao estiverem cancelados.                                                              ³
	        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			if ( cChave <> SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA ) .AND. Empty(SF3->F3_DTCANC)   // Compras Debito/Credito				
				//lProcLiv := PesqDocOri(@dDtNFOri,@cNFOri,@cAutNFOri,@nValNFOri,cFilIni,cLivro=="CDC")
				//lProcLiv := PesqDocOri(@dDtNFOri,@cNFOri,@cAutNFOri,@nValNFOri,cFilIni,cLivro=="VDC")
				lProcLiv := PesqDocOri(@dDtNFOri,@cNFOri,@cAutNFOri,@nValNFOri,SF3->F3_FILIAL,cLivro=="VDC",@cNodia)
				if !lProcLiv
					dDtNFOri 	:= CTOD("  /  /  ")
					cNFOri		:= 'NO-REGISTRADA'
					cAutNFOri	:= '0'
					nValNFOri	:= 0
					lProcLiv := .T.
				endIf												
			EndIf											
		EndIf

		If lProcLiv

	    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    	//³Como podem existir mais de um SF3 para um mesmo documento, deve ser aglutinado³
	    	//³gerando apenas uma linha no arquivo magnetico.                                ³
	    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If Empty(cChave) .Or. cChave <> SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA
				
				// odr 31/01/2021 Se bajó a la línea 611
            	// lCalcLiq := ( Posicione("SFC",2,xFilial("SFC")+SF3->F3_TES+"IVA","FC_LIQUIDO") == "S" ) 
				
				If SF3->F3_TIPOMOV == "C"	//Compras(C)
					If !Empty(cFilIni) .AND. !Empty(SF3->F3_FILIAL)
						SF1->(dbSeek(SF3->F3_FILIAL+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
					Else
						SF1->(dbSeek(SF3->F3_FILIAL+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
					EndIf
				ElseIf SF3->F3_TIPOMOV == "V"   //Vendas
					If !Empty(cFilIni) .AND. !Empty(SF3->F3_FILIAL)
						SF2->(dbSeek(SF3->F3_FILIAL+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
						SD2->(DBSeek(SF3->F3_FILIAL+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
					Else
						SF2->(dbSeek(SF3->F3_FILIAL+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
						SD2->(DBSeek(SF3->F3_FILIAL+SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA))
					EndIf

				EndIf

				//cNumDoc:= SF3->F3_NFISCAL				
				cNumDoc:= PadL( Borrar0Izq( SF3->F3_NFISCAL ), nTamDoc ) //SF3->F3_NFISCAL //ODR 26/05/2021
				
				dDemissao:= SF3->F3_EMISSAO
				If cStatus $ "V|C"
					If !Empty(SF3->F3_NIT)
						cNIT := SF3->F3_NIT
					Else
						If SF3->F3_TIPOMOV == "C"  //Compras(C)
							cNIT := Posicione("SA2",1,xFilial("SA2")+SF3->(F3_CLIEFOR+F3_LOJA),"A2_CGC")
						Else
							cNIT := Posicione("SA1",1,xFilial("SA1")+SF3->(F3_CLIEFOR+F3_LOJA),"A1_CGC")
						EndIf
					EndIf
				Else
					cNIT :="0"
				EndIf

				If cStatus $ "V|C"
					If !Empty(SF3->F3_RAZSOC)
						cRazSoc	:= SF3->F3_RAZSOC
					Else
						If SF3->F3_TIPOMOV == "C"  //Compras(C)
							cRazSoc	:= Posicione("SA2",1,xFilial("SA2")+SF3->(F3_CLIEFOR+F3_LOJA),"A2_NOME")
						Else
							// cRazSoc	:= Posicione("SA1",1,xFilial("SA1")+SF3->(F3_CLIEFOR+F3_LOJA),"A1_NOME")
							cRazSoc	:= Posicione("SA1",1,xFilial("SA1")+SF3->(F3_CLIEFOR+F3_LOJA),"A1_UNOMFAC")
						EndIf
					EndIf
				ElseIf cStatus == "N"
					cRazSoc	:=  "NO UTILIZADA"
				else
					cRazSoc	:=  "ANULADA"
				EndIf

				If cStatus $ "V|C"
					If SF3->F3_TIPOMOV == "C" .And.  lPassag .And. !Empty(SF3->F3_COMPANH) .And. !Empty(SF3->F3_LOJCOMP)
						cNIT		:= Posicione("SA2",1,xFilial("SA2")+SF3->(F3_COMPANH+F3_LOJCOMP),"A2_CGC")
						cRazSoc		:= Posicione("SA2",1,xFilial("SA2")+SF3->(F3_COMPANH+F3_LOJCOMP),"A2_NOME")
						cNumDoc		:= SF3->F3_PASSAGE
						dDemissao	:= SF3->F3_DTPASSA
					EndIf
				EndIf

	    		//Ú Tipo de Factura ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    		//³1-Compras para Mercado Interno com destino a atividades gravadas     ³
	    		//³2-Compras para Mercado Interno com destino a atividades nao gravadas ³
	    		//³3-Compras sujeitas a proporcionalidade                               ³
	    		//³4-Compras para Exportacoes                                           ³
	    		//³3-Compras tanto para o Mercado Interno como para Exportacoes         ³
	    		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
				If (nPos := aScan(aTpNf,{|x| Alltrim(SF3->F3_SERIE) $ x[1]})) > 0
					cTpNf := aTpNf[nPos][2]
				Else
					cTpNf := "1"
				EndIf				

				// PARA LIBRO DE VENTAS // omar 30/07/2019
				IF SF3->F3_TIPOMOV == "V"
					DO CASE
						CASE cStatus $ "V|C"   //NAHIM ajuste 24/04/2019
							IF !EMPTY(TRIM(SF2->F2_UNITCLI))
								cNIT := SF2->F2_UNITCLI
							ENDIF
							cNIT := IIF(!EMPTY(TRIM(cNIT)), cNIT, "0")
							
							IF !EMPTY(TRIM(SF2->F2_UNOMCLI))
								cRazSoc	:= SF2->F2_UNOMCLI
							ENDIF
							cRazSoc	:= IIF(!EMPTY(TRIM(cRazSoc)), cRazSoc, "ANULADA")
						CASE SF3->F3_STATUS == "N"
							cNIT := "0"
							cRazSoc	:= "NO UTILIZADA"
						CASE SF3->F3_STATUS == "E"
							cNIT := "0"
							cRazSoc	:= "EXTRAVIADA"
						//CASE
						//IIf(SF3->F3_STATUS$"EN",SF3->F3_STATUS,"A")
					ENDCASE
				ENDIF

				// PARA LIBRO DE COMPRAS // omar 30/08/2019
				IF SF3->F3_TIPOMOV == "C"
					IF !EMPTY(ALLTRIM(SF1->F1_UNOMBRE))
						cNIT := IIF(EMPTY(ALLTRIM(SF1->F1_UNIT)), "0", SF1->F1_UNIT)
						cRazSoc	:= SF1->F1_UNOMBRE
					ENDIF
				ENDIF

				RecLock("LCV",.T.)

				If cLivro == "C"
					
					nDescont := xMoeda(SF1->F1_DESCONT,SF1->F1_MOEDA,1,SF1->F1_EMISSAO,,SF1->F1_TXMOEDA )

					If !lOrdem
						LCV->DATAORD := Dtos(SF3->F3_EMISSAO)
					EndIf

					If !Empty(SF1->&(cCpoPza))		//Numero da Poliza de Importacion
						LCV->POLIZA		:= SF1->&(cCpoPza)
						LCV->NFISCAL	:= "0"
					else
						LCV->POLIZA		:= "0"		// Omar: Asignar 0 cuando no es póliza
						LCV->NFISCAL	:= cNumDoc						
					EndIf

					If !Empty(SF1->&(cCpoDta))		//Data da Poliza de Importacion
						LCV->EMISSAO	:= SF1->&(cCpoDta)
					EndIf
					// busca libro de ventas / compras Nahim 24/12/2020 adicionando nro diario contable
					LCV->NODIA := SF1->F1_NODIA

				ElseIf cLivro == "V"
					// busca libro de ventas / compras Nahim 24/12/2020 adicionando nro diario contable
					LCV->NODIA := SF2->F2_NODIA

					nDescont := xMoeda(SF2->F2_DESCONT,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,SF2->F2_TXMOEDA )

					SD2->(dbSelectArea("SD2"))
					SD2->(dbSetOrder(3))
					SD2->(dbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))
					cDoc := SD2->D2_DOC
					While SD2->(!Eof()) .AND. cDoc == SD2->D2_DOC
						if AllTrim(cBonusTes) == SD2->D2_TES
							nDescont += xMoeda(SD2->D2_TOTAL,SF2->F2_MOEDA,1,SF2->F2_EMISSAO,,SF2->F2_TXMOEDA )
						endif
						SD2->(dbSkip())
						if SD2->(!Eof()) 
							if cDoc != SD2->D2_DOC
								exit
							endif
						endif
					EndDo				
				EndIf

				If Empty(SF3->F3_NUMAUT) .and. !Empty(SF1->&(cCpoPza)) 	 //Edson numero de autorizacion 10/07/2019
					LCV->NUMAUT	:= "3"
				else
					LCV->NUMAUT		:= SF3->F3_NUMAUT
				EndIf

				LCV->STATUSNF	:= cStatus

				If Empty(SF3->F3_CODCTR) .OR. LCV->STATUSNF == "A"   	 //Edson codigo de control 10/07/2019
					LCV->CODCTR	    := "0"
				else
					LCV->CODCTR		:= SF3->F3_CODCTR
				EndIf

				If (LCV->STATUSNF $ "V|C") .OR. (cLivro == "VDC" .AND. LCV->STATUSNF == "A")
					LCV->DTNFORI  := dDtNFOri
					LCV->NFORI    := cNFOri
					LCV->AUTNFORI := cAutNFOri
					LCV->VALNFORI := nValNFOri	
					if 	cLivro == "VDC" // sólo cuando es débido crédito
						LCV->NODIA	  := cNodia // Nahim Agregando serie 29/12/2020
					ENDIF
				EndIf

			Else
				RecLock("LCV",.F.)
			EndIf

			// ODR 18/10/2019		
			If cStatus $ "C|V"
				LCV->VALCONT += SF3->F3_VALCONT
			Else
				LCV->VALCONT:=0
			EndIf 
			
			If SF3->(FieldGet(aImp[nPosIVA][4])) > 0
				If cStatus $ "C|V"
					LCV->BASEIMP += SF3->(FieldGet(aImp[nPosIVA][3]))		//Base de Calculo
					LCV->VALIMP  += SF3->(FieldGet(aImp[nPosIVA][4]))		//Valor do Imposto
				Else
					LCV->BASEIMP := 0		//Base de Calculo
					LCV->VALIMP  :=0	//Valor do Imposto
				EndIf
			ElseIf cLivro == "V"
				// si columna Excento es 0, entonces es Taza Cero
				If SF3->(FieldGet(71)) = 0 
					LCV->TAXAZERO += SF3->(FieldGet(aImp[nPosIVA][3]))   //IVA com taxa zero
				Else
					LCV->TAXAZERO += 0
				EndIf
			EndIf

			If cLivro $ "C|V"
				
				For nInd:=1 To Len(aCposIsen)
					If cStatus $ "V|C"
						LCV->EXENTAS += IIf(aCposIsen[nInd][2]>0,SF3->(FieldGet(aCposIsen[nInd][2])),0)
					Else
						LCV->EXENTAS :=0
					EndIf
				Next

				If cLivro == "V" .And. Empty(SF3->(FieldGet(aImp[nPosIVA][3])))
					If cStatus $ "V|C"

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Bonificação                  		³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If AllTrim(cBonusTes)==SF3->F3_TES
							LCV->DESCONT := LCV->DESCONT + SF3->F3_VALCONT
							nDescont := nDescont + LCV->DESCONT
						Else
							LCV->EXPORT += SF3->F3_EXENTAS
						Endif
					Else
						LCV->EXPORT :=0
					EndIf
				EndIf
				
				If cLivro == "C" .And. (SF3->F3_EXENTAS > 0)
					If cStatus $ "V|C"
						LCV->EXENTAS += SF3->F3_EXENTAS
					Else
						LCV->EXENTAS :=0
					EndIf
				EndIf
			EndIf

			If cLivro$"C|V|CDC" .AND. cStatus $ "C|V"
				lCalcLiq := ( Posicione("SFC",2,xFilial("SFC")+SF3->F3_TES+"IVA","FC_LIQUIDO") == "S" ) 					

				if cLivro = "C"
					LCV->DESCONT = IIf(lCalcLiq,nDescont,0)
				else
					LCV->DESCONT += IIf(lCalcLiq,nDescont,0)
				endif
			EndIf

			cChave := SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA

			LCV->TIPONF		:= cTpNf
			LCV->NUMSEQ		:= StrZero(++nNumSeq,6)
			LCV->NIT		:= cNIT
			LCV->RAZSOC		:= cRazSoc
			//		If cLivro == "V" .OR. cLivro == "CDC" 
			If cLivro == "V" .OR. cLivro == "CDC" .or. cLivro == "VDC" // Nahim 06/01/2019
				LCV->NFISCAL	:= cNumDoc
			endIf
			LCV->EMISSAO	:= dDemissao
			LCV->FILIAL		:= SF3->F3_FILIAL	//Nuevo Campo Adicionado
			LCV->DTDIGIT	:= SF1->F1_DTDIGIT	//Nuevo Campo Adicionado
			LCV->SERIE		:= SF3->F3_SERIE	//Nuevo Campo Adicionado
			
			// dbSelectArea("SF3")
			// dbSkip()
		EndIf // Nahim 06/01/2020

		dbSelectArea("SF3")
		dbSkip()

		If lProcLiv
			If cLivro$"C|V|CDC" .AND. cChave <> SF3->F3_FILIAL + SF3->F3_NFISCAL + SF3->F3_SERIE + SF3->F3_CLIEFOR + SF3->F3_LOJA

				If cStatus $ "C|V"
					
					// ODR 26/05/2021 Se quitó, validar
					// LCV->DESCONT += IIf(lCalcLiq,nDescont,0)

					/*lCalcLiq := ( Posicione("SFC",2,xFilial("SFC")+SF3->F3_TES+"IVA","FC_LIQUIDO") == "S" ) 					
					LCV->DESCONT += IIf(lCalcLiq,nDescont,0)*/

					If cLivro == "V" .OR. cLivro == "CDC"
						LCV->VALCONT := LCV->VALCONT + LCV->DESCONT	
						LCV->SUBTOT := LCV->VALCONT-LCV->EXENTAS-LCV->EXPORT-LCV->TAXAZERO											
					ENDIF
					
					If cLivro == "C"
						LCV->VALCONT := LCV->BASEIMP+LCV->DESCONT+LCV->EXENTAS		
						LCV->SUBTOT := IIf(!Empty(LCV->BASEIMP),(LCV->VALCONT-LCV->EXENTAS),(LCV->BASEIMP+LCV->DESCONT))										
						//LCV->SUBTOT := LCV->BASEIMP+LCV->DESCONT
					endIf
					
				Else
					LCV->DESCONT := 0
					LCV->SUBTOT := 0
				EndIf
			Else
				nNumSeq--
			EndIf			
			LCV->(MsUnlock())
		//else
		//	SF3-(dbSkip())
		EndIf
		
	EndDo

	FsQuery(aAlias,2)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³PesqDocOri   ³ Autor ³ Marco Aurelio - Mano    ³ Data ³15/12/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Pesquisa a esxistencia de documento original para Notas de       ³±±
±±³          ³Debito/Credito                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³PesqDocOri(ExpD1,ExpC1,ExpC2,ExpC3)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpD1 = Data de emissao do documento original                    ³±±
±±³          ³ExpC1 = Numero do documento original                             ³±±
±±³          ³ExpC2 = Numero de autorizacao do documento original              ³±±
±±³          ³ExpC3 = Valor da do documento original                           ³±±
±±³          ³ExpC4 = Codigo da filial inical selecionada nos parametros       ³±±
±±³          ³ExpL4 = Determina a tabela a ser considerada de acordo com       ³±±
±±³          ³        o Livro a ser impresso ou gerado                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Livros - Bolivia                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
Static Function PesqDocOri(dDtNFOri, cNFOri, cAutNFOri, nValNFOri, cFilIni, lTabSF2,cNodia)

	Local cQuery	:= ""    // Auxiliar para execucao de query para insercao de registros
	Local lRet		:= .F.   // Conteudo de retorno
	Local cArqTmp	:= GetNextAlias()
	Local cFilSD1	:= ""
	Local cFilSF2	:= ""

	/*cFilSF1 := IIf(!Empty(cFilIni) .AND. !Empty(xFilial("SF1")),SF3->F3_FILIAL,xFilial("SF2"))
	cFilSF2 := IIf(!Empty(cFilIni) .AND. !Empty(xFilial("SF2")),SF3->F3_FILIAL,xFilial("SF2"))
	cFilSD1 := IIf(!Empty(cFilIni) .AND. !Empty(xFilial("SD1")),SF3->F3_FILIAL,xFilial("SD1"))
	cFilSD2 := IIf(!Empty(cFilIni) .AND. !Empty(xFilial("SD2")),SF3->F3_FILIAL,xFilial("SD1"))*/

	cFilSF1 := cFilIni
	cFilSF2 := cFilIni
	cFilSD1 := cFilIni
	cFilSD2 := cFilIni

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Colunas a serem exibidas como resultado da query ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lTabSF2
		cQuery := "SELECT F2_DOC, F2_EMISSAO, F2_NUMAUT, F2_VALFAT, F2_MOEDA, F2_TXMOEDA, F2_UNOMCLI, F2_NODIA FROM "
	Else
		cQuery := "SELECT F1_DOC, F1_EMISSAO, F1_NUMAUT, F1_VALBRUT, F1_MOEDA, F1_TXMOEDA, F1_UNOMBRE, F1_NODIA FROM "
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tabela do filtro ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If AllTrim(SF3->F3_ESPECIE) $ "NCC|NDE|NDP|NCI"
		cQuery += RetSqlName("SD1") + " SD1 " // Tabela de Itens de Compra
	
//		If AllTrim(SF3->F3_ESPECIE) $ "NCC|NDE|NDP|NCI"
			If lTabSF2
				cQuery += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON D1_FILIAL = '" + cFilSF2 + "' AND F2_CLIENTE = D1_FORNECE AND F2_LOJA = D1_LOJA AND F2_DOC = D1_NFORI AND F2_SERIE = D1_SERIORI AND SF2.D_E_L_E_T_ <> '*'"
			Else
				cQuery += "INNER JOIN " + RetSqlName("SF1") + " SF1 ON D1_FILIAL = '" + cFilSF1 + "' AND F1_FORNECE = D1_FORNECE AND F1_LOJA = D1_LOJA AND F1_DOC = D1_NFORI AND F1_SERIE = D1_SERIORI AND SF1.D_E_L_E_T_ <> '*'"
			EndIf
	
	Else
		cQuery += RetSqlName("SD2") + " SD2 " // Tabela de Itens de Saida

		If lTabSF2
			cQuery += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON D2_FILIAL = '" + cFilSF2 + "' AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND F2_DOC = D2_NFORI AND F2_SERIE = D2_SERIORI AND SF2.D_E_L_E_T_ <> '*'"
		Else
			cQuery += "INNER JOIN " + RetSqlName("SF1") + " SF1 ON D2_FILIAL = '" + cFilSF1 + "' AND F1_FORNECE = D2_CLIENTE AND F1_LOJA = D2_LOJA AND F1_DOC = D2_NFORI AND F1_SERIE = D2_SERIORI AND SF1.D_E_L_E_T_ <> '*'"
		EndIf

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Condicoes para filtro ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(SF3->F3_ESPECIE) $ "NCC|NDE|NDP|NCI"
		cQuery += "WHERE "
		cQuery += "D1_FILIAL = '" + cFilSD1 + "' AND "
		cQuery += "D1_FORNECE = '" + SF3->F3_CLIEFOR + "' AND "
		cQuery += "D1_LOJA = '" + SF3->F3_LOJA + "' AND "
		cQuery += "D1_DOC = '" + SF3->F3_NFISCAL + "' AND "
		cQuery += "D1_SERIE = '" + SF3->F3_SERIE + "' AND "
		cQuery += "D1_NFORI <> ' ' AND "
		cQuery += "SD1.D_E_L_E_T_ = ' ' "
	Else
		cQuery += "WHERE "
		cQuery += "D2_FILIAL = '" + cFilSD2 + "' AND "
		cQuery += "D2_CLIENTE = '" + SF3->F3_CLIEFOR + "' AND "
		cQuery += "D2_LOJA = '" + SF3->F3_LOJA + "' AND "
		cQuery += "D2_DOC = '" + SF3->F3_NFISCAL + "' AND "
		cQuery += "D2_SERIE = '" + SF3->F3_SERIE + "' AND "
		cQuery += "D2_NFORI <> ' ' AND "
		cQuery += "SD2.D_E_L_E_T_ = ' ' "
	EndIf

	// Aviso("Ver cQuery",cQuery,{'ok'},,,,,.t.)
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqTmp,.T.,.T.)

	If lTabSF2
		TcSetField(cArqTmp, "F2_EMISSAO", "D", 8, 0)
		TCSetField(cArqTmp, "F2_VALFAT"	, "N", TamSX3("F2_VALFAT")[1], TamSX3("F2_VALFAT")[2])
	Else
		TcSetField(cArqTmp, "F1_EMISSAO", "D", 8, 0)
		TCSetField(cArqTmp, "F1_VALBRUT", "N", TamSX3("F1_VALBRUT")[1], TamSX3("F1_VALBRUT")[2])
	EndIf

	(cArqTmp)->(dbGoTop())

	If !(cArqTmp)->(EOF())

		lRet := .T.

		If lTabSF2
			dDtNFOri  := (cArqTmp)->F2_EMISSAO
			cNFOri    := (cArqTmp)->F2_DOC
			cAutNFOri := (cArqTmp)->F2_NUMAUT
//			nValNFOri := Round(NoRound(xMoeda((cArqTmp)->F2_VALFAT,(cArqTmp)->F2_MOEDA,1,(cArqTmp)->F2_EMISSAO,,(cArqTmp)->F2_TXMOEDA )),2)
			nValNFOri := Round(xMoeda((cArqTmp)->F2_VALFAT,(cArqTmp)->F2_MOEDA,1),2)
			If !Empty((cArqTmp)->F2_UNOMCLI)			
				cRazSoc	  := (cArqTmp)->F2_UNOMCLI	
			EndIf
			cNodia := (cArqTmp)->F2_NODIA
		Else
			dDtNFOri  := (cArqTmp)->F1_EMISSAO
			cNFOri    := (cArqTmp)->F1_DOC
			cAutNFOri := (cArqTmp)->F1_NUMAUT
//			nValNFOri := Round(NoRound(xMoeda((cArqTmp)->F1_VALBRUT,(cArqTmp)->F1_MOEDA,1,(cArqTmp)->F1_EMISSAO,,(cArqTmp)->F1_TXMOEDA )),2)
			nValNFOri := Round(xMoeda((cArqTmp)->F1_VALBRUT,(cArqTmp)->F1_MOEDA,1),2)
			If !Empty((cArqTmp)->F1_UNOMBRE)
				cRazSoc	  := (cArqTmp)->F1_UNOMBRE	
			EndIf			
			cNodia := (cArqTmp)->F1_NODIA
		EndIf
	EndIf

	(cArqTmp)->(dbCloseArea())

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±?rograma  ?avinciDel ?Autor ?arco A. Gonzalez R.   ?echa ?10/01/17 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±?escricao ?ierra y elimina archivo temporal LCV                        ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
user Function DavinciDel()

	If oTmpTabLCV <> Nil
		oTmpTabLCV:Delete()
		oTmpTabLCV := Nil
	EndIf

Return

STATIC Function SFPCompartido()
	Local aArea	:= getArea()	
	Local cRet := "";

	dbSelectArea("Sx2")
	SX2->( dbSeek("SFP") )
	IF (SX2->X2_MODO == 'C')
		cRet := 'POSICIONE("SFP", 1, xFilial("SFP") + SF3->F3_FILIAL + SF3->F3_SERIE, "FP_LOTE")'
	else
		cRet := 'POSICIONE("SFP", 1, SF3->F3_FILIAL + SF3->F3_FILIAL + SF3->F3_SERIE, "FP_LOTE")'
	ENDIF

	restArea(aArea)
Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Borrar0IzqºAutor  ³EDUAR ANDIA         ºFecha ³  08/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Función que quita los '0' de la izquierda de un número     º±±
±±º          ³ utilizado para convertir el Num. Doc. de la Factura        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Borrar0Izq(cString)
	Local cCadena 	:= AllTrim(cString)
	cString 	:= AllTrim(cString)
	For nI 			:= 1 To Len(cString)
		cChar		:= Substr(cString,nI,1)
		If cChar $"0"
			cCadena := Substr(cString,nI+1,Len(cString))
		Else
			Return ( cCadena )
		Endif
	Next nI
Return ( cCadena )
