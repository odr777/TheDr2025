#INCLUDE "RWMAKE.CH"
#INCLUDE "MATA103.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE LINHAS 999

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A462TN ³ Autor ³ Erick Etcheverry         ³ Data ³26.09.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Tela de importacao de Solicitud de almacen.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³MTA462TN transferencia de almacen                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MTA462TN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function XLxA462TN(lUsaFiscal)

	Local nSldPed		:= 0
	Local nOpc			:= 0
	Local nCntFor		:= 0
	Local naCols        := 0
	Local nPosQUANT		:= 0
	Local nPosVUNIT		:= 0
	Local nPosTOTAL		:= 0
	Local cSavScr		:= ""
	Local cSavCur		:= ""
	Local cSavCor		:= ""
	Local cQuery        := ""
	Local cAliasSC7     := "SCP"
	Local lClass		:= .F.
	Local lQuery        := .F.
	Local bSavSetKey
	Local bSavKeyF5
	Local bSavKeyF6
	Local bSavKeyF7
	Local bSavKeyF8
	Local bSavKeyF9
	Local bSavKeyF10
	Local bSavKeyF11
	Local bWhile
	Local cVariavel		:= ReadVar()
	Local cChave		:= ""
	Local cCadastro		:= ""
	Local aArea			:= GetArea()
	Local aAreaSA2		:= SA2->(GetArea())
	Local aAreaSC7		:= SCP->(GetArea())
	Local aCopia		:= aClone(aCols[1])
	Local aStruSC7      := SCP->(dbStruct())
	Local aF4For		:= {}
	Local nF4For		:= 0
	Local oOk			:= LoadBitMap(GetResources(), "LBOK")
	Local oNo			:= LoadBitMap(GetResources(), "LBNO")
	Local aButtons		:= { {'PESQUISA',{||U_A105Visual(,,,aRecSC7[oListBox:nAt],aF4For[oListBox:nAt])},OemToAnsi(STR0059)} } //"Visualiza Pedido"

	Local oDlg,oListBox,cListBox
	Local cNomeFor		:= ''
	Local aRecSC7		:= {}
	Local lZeraCols		:= .T.
	Local cItem			:= StrZero(1,Len(SD1->D1_ITEM))
	Local aTitCampos    := {}
	Local aConteudos    := {}
	Local aUsCont       := {}
	Local aUsTitu       := {}
	Local bLine         := { || .T. }
	Local cLine         := ""
	Local lMa103F4I     := ExistBlock('MA103F4I')
	Local lMa103F4H     := ExistBlock('MA103F4H')
	Local nLoop         := 0
	Local nX			:= 0
	Local nI			:= 0
	Local lMt103Vpc     := ExistBlock("MT103VPC")
	Local lRet103Vpc    := .T.
	Local lContinua     := .T.
	Local lMoedaIgual	:= .T.
	Local aMoedaAux		:= {}
	Local cFiltraQry    := ""
	Local lFiltraQry    := .F.
	Local aPrvEnt		:= {}
	Local _xfilial       := M->F2_FILDEST //XFILIAL("SCP")
	cPeT := LocxPET(43)
	cPe	:=	LocxPE(43)
	lFiltraQry := If(!Empty(cPe) .Or. !Empty(cPet),.T.,.F.)
	Private lUsaFiscal	:= .T.

	ca100for:="      " //MV_PAR01
	cLoja   :="  " //MV_PAR02


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Type("InConPad") == "L"
		lContinua := !InConPad
	EndIf

	If lContinua

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o aCols esta vazio, se o Tipo da Nota e'     ³
		//³ normal e se a rotina foi disparada pelo campo correto    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		dbSelectArea("SCP")

		lQuery    := .T.
		cAliasSC7 := "QRYSC7"

		cQuery := "SELECT SCP.*,SCP.R_E_C_N_O_ RECSC7 FROM "
		cQuery += RetSqlName("SCP") + " SCP "
		//cQuery += "WHERE CP_PREREQU ='S' "  // 	and CP_STATSA = 'L'	 AND CP_OK = 'LQ'
		cQuery += "WHERE CP_QUJE < CP_QUANT AND CP_STATUS <> 'E'"
		cQuery += " AND CP_FILIAL = '" + _xfilial + "'   

		//Aviso("Array IVA",cQuery,{'ok'},,,,,.t.)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)

		if ! EMPTY((cAliasSC7)->CP_FILIAL)
			For nX := 1 To Len(aStruSC7)

				TcSetField(cAliasSC7,aStruSC7[nX,1],aStruSC7[nX,2],aStruSC7[nX,3],aStruSC7[nX,4])

			Next nX

			bWhile := {|| (cAliasSC7)->(!Eof())}

			While Eval(bWhile)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o Saldo do Pedido de Compra                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSldPed := (cAliasSC7)->CP_QUJE //-(cAliasSC7)->C7_QTDACLA
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se nao h  residuos, se possui saldo em abto e   ³
				//³ se esta liberado por alcadas se houver controle.         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				nF4For := aScan(aF4For,{|x|x[2]==(cAliasSC7)->CP_FILIAL .And. x[3]==(cAliasSC7)->CP_NUM})

				If ( nF4For == 0 )
					/// ventana de seleccion de solicitud paso de dados de items

					aConteudos := {}
					aAdd(aConteudos, .F.) //-- 01
					aAdd(aConteudos, (cAliasSC7)->CP_FILIAL) //-- 02
					aAdd(aConteudos, (cAliasSC7)->CP_NUM) //-- 03
					aAdd(aConteudos, DtoC((cAliasSC7)->CP_EMISSAO)) //-- 04

					aAdd(aF4For , aConteudos)
					aAdd(aRecSC7, If(lQuery, (cAliasSC7)->RECSC7, Recno()))
				EndIf

				(cAliasSC7)->(dbSkip())
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exibe os dados na Tela                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			aTitCampos := {}
			aAdd(aTitCampos, ' ') //-- 01
			aAdd(aTitCampos, 'Filial') //"Loja" //-- 02
			aAdd(aTitCampos, 'Sol.Alm') //"Pedido" //-- 03
			aAdd(aTitCampos, OemToAnsi(STR0039)) //"Emissao" //-- 04

			// arma ventana y param
			cLine := '{' //-- >>Inicio da String

			cLine += 'If(aF4For[oListBox:nAt, 01], oOk, oNo)' //-- 01
			cLine += ', aF4For[oListBox:nAT, 02]' //-- 02
			cLine += ', aF4For[oListBox:nAT, 03]' //-- 03
			cLine += ', aF4For[oListBox:nAT, 04]' //-- 04

			cLine += ' }' //-- <<Final da String

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta dinamicamente o bline do CodeBlock                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			bLine := &( "{ || " + cLine + " }" )

			DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE OemToAnsi(STR0024+" - <F5> ") Of oMainWnd PIXEL //"Selecionar Pedido de Compra"

			oListBox := TWBrowse():New( 30,4,243,80,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oListBox:SetArray(aF4For)
			oListBox:bLDblClick := { || aF4For[oListBox:nAt,1] := !aF4For[oListBox:nAt,1] }
			oListBox:bLine := bLine

			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,aButtons)

			If ( nOpc == 1 )

				For nx	:= 1 to Len(aF4For)
					If aF4For[nx][1]
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona Fornecedor                                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SA2")
						dbSetOrder(1)
						MsSeek(xFilial()+cA100For+cLoja)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona Pedido de Compra                               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SCP")

						dbSetOrder(1)

						
						cSeek := ""

						cSeek += xFilial()

						cSeek += aF4For[nx][3]+"01"

						MsSeek(cSeek)
						If lZeraCols
							aCols		:= {}
							lZeraCols	:= .F.
							MaFisClear()
						EndIf

						dbSelectArea("SCP")

						dbSetOrder(1)

						While ( !Eof() .And. SCP->CP_FILIAL+SCP->CP_NUM+"01"==;
						cSeek )
							U_LxA103SCPToaCols(SCP->(RecNo()),,nSlDPed,cItem) // pasando item para gravar en la tela
							cItem := Soma1(cItem)
							dbSelectArea("SCP")
							dbSkip()
						EndDo
					EndIf
				Next
				If lUsaFiscal
					Eval(bListRefresh)
					Eval(bDoRefresh)
				EndIf
			EndIf
		ELSE
			Help(NIL, NIL, "Help TOTVS", NIL, "No hay solicitudes aptas para transferencia", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Verificar su solicitud de almacen"})
		ENDIF
	Else
		Help('   ',1,'A103CAB')
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura a Integrida dos dados de Entrada                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lQuery
		dbSelectArea(cAliasSC7)
		dbCloseArea()
		dbSelectArea("SCP")
	Endif

	AtuLoadQt(.T.)

	RestArea(aAreaSA2)
	RestArea(aAreaSC7)
	RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103SCPToaCols³ Autor ³ Erick Etcheverry  ³ Data ³27.09.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Carrega os dados do Pedido no item especificado.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Void A103SCPToaCols(ExpN1,ExpC1)                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 : Numero do registro do SC7                           ³±±
±±³          ³ExpN2 : Item da NF                                          ³±±
±±³          ³ExpN3 : Saldo do Pedido                                     ³±±
±±³          ³ExpC4 : Item a ser carregado no aCols ( D1_ITEM )           ³±±
±±³          ³ExpL5 : Indica se os dados da Pre-Nota devem ser preservados³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LxA103SCPToaCols(nRecSC7,nItem,nSalPed,cItem,lPreNota,aRateio)

	Local aArea		:= GetArea()
	Local aAreaSC7	:= SCP->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local aRefSC7   := MaFisSXRef("SCP")
	Local nX        := 0
	Local nCntFor	:= 0
	Local nValItem	:= 0
	Local nTaxaNf	:= 0
	Local nTaxaPed	:= 0
	Private lPreNota := .F.
	Private aRateio  := {0,0,0}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existencia do item                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nItem == Nil .Or. nItem > Len(aCols)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a montagem de uma linha em branco no aCols.              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aadd(aCols,Array(Len(aHeader)+1))
		For nX := 1 to Len(aHeader)
			If Trim(aHeader[nX][2]) == "D2_ITEM"
				aCols[Len(aCols)][nX] 	:= IIF(cItem<>Nil,cItem,StrZero(1,Len(SD1->D2_ITEM)))
			ElseIf ( aHeader[nX][10] <> "V") .Or. Trim(aHeader[nX][2]) == "D2_ITEMMED"
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2],.T.)
			EndIf
			aCols[Len(aCols)][Len(aHeader)+1] := .F.
		Next nX
		nItem := Len(aCols)
	EndIf

	oGetDados:lNewLine:=.F.
	dbSelectArea("SCP")
	MsGoto(nRecSC7)

	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+SCP->CP_PRODUTO)

	If SCP->(!Eof())

		If MaFisFound()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicia a Carga do item nas funcoes MATXFIS  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisIniLoad(nItem)

			If M->F2_MOEDA==1
												
				nValItem:= ROUND(POSICIONE("SB2", 1, xFilial("SB2")+SCP->CP_PRODUTO+'01', "B2_CM1"), 2)
			Else

				nValItem:= ROUND(POSICIONE("SB2", 1, xFilial("SB2")+SCP->CP_PRODUTO+'01', "B2_CM2"), 2)
			endif

		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza os demais campos do SOL.ALM                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To Len(aHeader)
			Do Case
				Case Trim(aHeader[nCntFor,2]) == "D2_COD"
				aCols[nItem,nCntFor] := SCP->CP_PRODUTO
				Case Trim(aHeader[nCntFor,2]) == "D2_TES" //.And. !Empty(SC7->C7_TES)
				aCols[nItem,nCntFor] := GETNEWPAR("MV_UTESSAL", "750") //SC7->C7_TES
				Case Trim(aHeader[nCntFor,2]) == "D2_TESENT" //.And. !Empty(SC7->C7_TESENT)
				aCols[nItem,nCntFor] := GETNEWPAR("MV_UTESENT", "250") //"301" //SC7->C7_TESENT
				Case Trim(aHeader[nCntFor,2]) == "D2_LOCALIZ" //NUEVO
				IF SF2->F2_FILDEST > '29'
					aCols[nItem,nCntFor] := "GENERICO"
				ENDIF
				Case Trim(aHeader[nCntFor,2]) == "D2_LOCZDES" //NUEVO
				IF M->F2_FILDEST > '29'
					aCols[nItem,nCntFor] := "GENERICO"
				ENDIF
				Case Trim(aHeader[nCntFor,2]) == "D2_PRCVEN"
				aCols[nItem,nCntFor]:= nValItem
				Case Trim(aHeader[nCntFor,2]) == "D2_QUANT"
				aCols[nItem,nCntFor] := SCP->CP_QUANT - SCP->CP_QUJE
				Case Trim(aHeader[nCntFor,2]) == "D2_TOTAL"
				aCols[nItem,nCntFor]:= (SCP->CP_QUANT - SCP->CP_QUJE)* nValItem
				Case Trim(aHeader[nCntFor,2]) == "D2_UDESC"
				aCols[nItem,nCntFor] := SB1->B1_DESC
				Case Trim(aHeader[nCntFor,2]) == "D2_UITEMSA"
				aCols[nItem,nCntFor] := SCP->CP_ITEM
				Case Trim(aHeader[nCntFor,2]) == "D2_LOCAL"
				aCols[nItem,nCntFor] := SCP->CP_LOCAL
				Case Trim(aHeader[nCntFor,2]) == "D2_CC"
				aCols[nItem,nCntFor] := SCP->CP_CC
				Case Trim(aHeader[nCntFor,2]) == "D2_ITEMCTA"			// Item Contabil
				aCols[nItem,nCntFor] := Iif( Empty(SCP->CP_ITEMCTA), SB1->B1_ITEMCC, SCP->CP_ITEMCTA )
				Case Trim(aHeader[nCntFor,2]) == "D2_CONTA"				// Conta Contabil
				aCols[nItem,nCntFor] := Iif( Empty(SCP->CP_CONTA), SB1->B1_CONTA, SCP->CP_CONTA )
				Case Trim(aHeader[nCntFor,2]) == "D2_CLVL"				// Classe de Valor
				aCols[nItem,nCntFor] := Iif( Empty(SCP->CP_CLVL), SB1->B1_CLVL, SCP->CP_CLVL )
				Case Trim(aHeader[nCntFor,2]) == "D2_UM"
				aCols[nItem,nCntFor] := SCP->CP_UM
				Case Trim(aHeader[nCntFor,2]) == "D2_SEGUM"
				aCols[nItem,nCntFor] := SCP->CP_SEGUM
				Case Trim(aHeader[nCntFor,2]) == "D2_QTSEGUM"
				aCols[nItem,nCntFor] := SCP->CP_QTSEGUM
				Case Trim(aHeader[nCntFor,2]) == "D2_CODGRP"
				aCols[nItem,nCntFor] := SB1->B1_GRUPO
				Case Trim(aHeader[nCntFor,2]) == "D2_CODITE"
				aCols[nItem,nCntFor] := SB1->B1_CODITE
				Case Trim(aHeader[nCntFor,2]) == "D2_USCPNUM"
				aCols[nItem,nCntFor] := SCP->CP_NUM
			EndCase

		Next nCntFor

		// 1 - utilização a associação automática com o PMS
		// 2 - não utiliza a associação automática com o PMS

		// default: não utilizar a associação automática
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizar os arrays do Fiscal (Matxfis)                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaColsToFis(aHeader,aCols,nItem,"MT100",.T.)
	Eval(bDoRefresh) //Atualiza o folder financeiro.
	Eval(bListRefresh)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Produto possui TE Padrao                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RestArea(aAreaSB1)
	RestArea(aAreaSC7)
	RestArea(aArea)
Return .T.

//Funcion para visualizar una solicitud de almacen Erick Etcheverry

USER Function A105Visual(cAlias,nReg,nOpcx,aArec,aAfor)

	LOCAL cExprFilTop   := "CP_NUM = '"+ aAfor[3] + "'"

	PRIVATE cAlias   := 'SCP'

	PRIVATE cCadastro := "Solicitud de almacen"

	PRIVATE aRotina     := { }

	AADD(aRotina, { "Visualizar", "AxVisual" , 0, 2 })

	dbSelectArea("SCP")

	dbSetOrder(1)

	MBrowse( 6 , 1 , 22 , 75 , "SCP" , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL;
	, NIL , NIL , NIL , NIL , NIL , cExprFilTop )

Return