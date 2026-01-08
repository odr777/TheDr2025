#INCLUDE "protheus.ch"
#INCLUDE "atfa110.ch"

// Simula el excauto de la funci�n de apunte de producci�n (BIEN)
// Nahim Terrazas 01/11/2019

user function AF110EXC(aValores,nRecno,cMarca,cN3Ok,lMulti)
	/*
	es necesario utilizar un array con estos valores:
	AADD(1, M->FNA_IDMOV)            AADD(Arrteste, '001')
	AADD(2, M->FNA_ITMOV)            AADD(Arrteste, '001')
	AADD(3, M->FNA_DATA)             AADD(Arrteste, '20190506')
	AADD(4, M->FNA_OCORR)            AADD(Arrteste, 'P2')
	AADD(5, M->FNA_DTPERI)           AADD(Arrteste, '20190506')
	AADD(6, M->FNA_DTPERF)           AADD(Arrteste, '20190506')
	AADD(7, M->FNA_QUANTD)           AADD(Arrteste, 3)
	AADD(8, M->FNA_CBASE)            AADD(Arrteste, 'MIG00011-2') N3_CBASE
	AADD(9, M->FNA_ITEM)             AADD(Arrteste, '0001	') N3_ITEM
	AADD(10, M->FNA_TIPO)            AADD(Arrteste, '10') N3_TIPO
	AADD(11, M->FNA_SEQ)             AADD(Arrteste, '001')
	*/
	Local aTxDepr		:= {}
	Local cTabela		:= ""
	Local aMemFNA		:= {}
	Local nX			:= 0
	Local nHdlPrv		:= 0
	Local nTotal		:= 0
	Local cArquivo		:= ""
	Local cLoteAtf		:= LoteCont("ATF")

	Private nDecQtd, nDecCoef, nDecMes, nDecAno, nDecAcm
	PRIVATE lMultMoed := .T.
	Default nRecno		:= 1
	Default cN3Ok		:= "N3_OK"
	Default lMulti		:= .F.
	Default cMarca		:= ""

	nDecQtd := nDecCoef := nDecMes := nDecAno := nDecAcm := 0

	//Monta matriz das moedas utilizadas para o calculo de exaustao
	aTxDepr := IIF(lMultMoed, AtfMultMoe(,,{|xMoeda| 0 }) , {0,0,0,0,0} )

	//Captura os decimais dos campos numιricos para os apontamentos multiplos
	dbSelectArea("SX3")
	dbSetOrder(2)		//X3_CAMPO
	dbGoTop()
	If SX3->(MsSeek("FNA_QUANTD"))
		nDecQtd := SX3->X3_DECIMAL
	EndIf
	If SX3->(MsSeek("FNA_COEFIC"))
		nDecCoef := SX3->X3_DECIMAL
	EndIf
	If SX3->(MsSeek("N3_PRODMES"))
		nDecMes := SX3->X3_DECIMAL
	EndIf
	If SX3->(MsSeek("N3_PRODANO"))
		nDecAno := SX3->X3_DECIMAL
	EndIf
	If SX3->(MsSeek("N3_PRODACM"))
		nDecAcm := SX3->X3_DECIMAL
	EndIf

	If lMulti
		//Abre a tabela temporaria
		dbSelectArea("TRB")
		dbGoTop()

		cTabela	:= "TRB"
		AADD(aMemFNA, GetSXENum("FNA", "FNA_IDMOV"))
		AADD(aMemFNA, StrZero(1,TamSX3("FNA_ITMOV")[1]))
	Else
		dbSelectArea("SN3")
		dbSetOrder(1)		//N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ
		dbGoTop()

		cTabela	:= "SN3"
	EndIf
	//	AADD(aMemFNA, aValores[1]) // M->FNA_IDMOV
	//	AADD(aMemFNA, aValores[2])// M->FNA_ITMOV)
	//AADD(aMemFNA, GetSXENum("FNA", "FNA_IDMOV"))
	//AADD(aMemFNA, StrZero(1,TamSX3("FNA_ITMOV")[1]))
	AADD(aMemFNA, aValores[1])
	AADD(aMemFNA, StrZero(1,TamSX3("FNA_ITMOV")[1]))
	AADD(aMemFNA, aValores[3]) // M->FNA_DATA) // FECHA Nahim
	AADD(aMemFNA, aValores[4]) // M->FNA_OCORR) // SIEMPRE P2   Nahim
	AADD(aMemFNA, aValores[5]) // M->FNA_DTPERI) // PERIODO INICIAL Nahim
	AADD(aMemFNA, aValores[6]) // M->FNA_DTPERF) // PERIODO FINAL Nahim
	AADD(aMemFNA, aValores[7]) // M->FNA_QUANTD) // CANTIDAD DE HORAS Nahim

	//Abre a contabilizaco
	nHdlPrv := HeadProva(cLoteAtf,"ATFA110",Substr(cUsername,1,6),@cArquivo)

	If lMulti
		While TRB->(!EoF())
			If TRB->&(cN3Ok) == cMarca
				//Grava o apontamento em todas as moedas utilizadas
				AF110GrvMoeda(cTabela,aTxDepr,aMemFNA,lMulti,@nHdlPrv,@nTotal,@cArquivo)
			EndIf
			TRB->(dbSkip())
		EndDo
	Else
		//	If SN3->(MsSeek(xFilial("SN3")+M->(FNA_CBASE+FNA_ITEM+FNA_TIPO+"0"+FNA_SEQ)))
		//  											BIEN - ITEM - TIPO Nahim -
		If SN3->(MsSeek(xFilial("SN3")+aValores[8] + aValores[9] + aValores[10] + "0" + aValores[11]))
			//Grava o apontamento em todas as moedas utilizadas
			AF110GrvMoeda(cTabela,aTxDepr,aMemFNA,lMulti,@nHdlPrv,@nTotal,@cArquivo)
		EndIf
	EndIf

	Pergunte("AFA110CONT",.F.)
	lMostra := IIF(MV_PAR01 == 1, .T., .F.)
	lAglutina := IIF(MV_PAR02 == 1, .T., .F.)

	If (nHdlPrv > 0) .And. (nTotal > 0)
		RodaProva(nHdlPrv, nTotal)
		cA100Incl(cArquivo,nHdlPrv,3,cLoteAtf,lMostra,lAglutina)
	EndIf

Return

Static Function AF110GrvMoeda(cTabela,aTxDepr,aMemFNA,lMulti,nHdlPrv,nTotal,cArquivo)

	Local nX			:= 0
	Local nY			:= 0
	Local cIDMov  		:= ""
	Local aFatorDep		:= {}
	Local nTamMoeda		:= TamSX3("FNA_MOEDA")[1]
	Local nRecFNA		:= 0
	Local aRecFNA		:= {}
	Local dUltDepr		:= GetNewPar("MV_ULTDEPR", STOD("19800101"))
	Local nProdMes		:= 0
	Local cPadrao		:= ""
	Local lPadrao
	Local cTipoFiscal	:= ATFXTpBem(1)
	Local cTipoGerenc	:= ATFXTpBem(2)
	Local aValDepr		:= {}
	Local aDadosComp	:= {}
	Local nTaxaMedia	:= 0
	Local cN5_TIPO		:= ""
	Local lGerouMov		:= .F.
	Local cLoteAtf		:= LoteCont("ATF")
	Local aAptoEst		:= {}
	Local lGerouEst		:= .F.
	Local nMoedaEst		:= 1
	Local aAptos		:= {}
	Local nUltApto		:= 0
	Local nQtdEst		:= 0
	Local nRecEst		:= 0
	Local lEstExaust	:= .F.
	Local nProdAcm		:= 0
	Local aVrdMes		:= {}
	Local aVrdAcm		:= {}
	Local lOnOff		:= .T.
	Local cTipDepr		:= ""

	Default cTabela		:= "SN3"
	Default aTxDepr		:= IIF(lMultMoed, AtfMultMoe(,,{|xMoeda| 0 }) , {0,0,0,0,0} )
	Default lMulti		:= .F.

	Pergunte("AFA110CONT",.F.)
	lOnOff := MV_PAR03 == 1

	//Calcula a taxa de depreciaco
	If aMemFNA[4] $ "P2|P3|P4|"
		aFatorDep := {}
		aFatorDep := AF110Coefic( @aTxDepr,cTabela,aMemFNA[7],aMemFNA[3],IIF(aMemFNA[4] == "P3", .T., .F.) )
	EndIf

	//Verifica se existe
	dbSelectArea("FNA")
	dbSetOrder(1)		//FNA_FILIAL+FNA_IDMOV+FNA_ITMOV+FNA_MOEDA+FNA_OCORR

	//Grava o apontamento para todas as moedas utilizadas
	For nX := 1 To Len(aTxDepr)
		RecLock("FNA", .T.)
		FNA->FNA_FILIAL	:= (cTabela)->N3_FILIAL
		FNA->FNA_IDMOV	:= aMemFNA[1]
		FNA->FNA_ITMOV	:= aMemFNA[2]
		FNA->FNA_CBASE	:= (cTabela)->N3_CBASE
		FNA->FNA_ITEM	:= (cTabela)->N3_ITEM
		FNA->FNA_TIPO	:= (cTabela)->N3_TIPO
		FNA->FNA_SEQ	:= (cTabela)->N3_SEQ
		FNA->FNA_SEQREA	:= (cTabela)->N3_SEQREAV
		FNA->FNA_TPSALD	:= (cTabela)->N3_TPSALDO
		FNA->FNA_TPDEPR	:= (cTabela)->N3_TPDEPR
		FNA->FNA_DATA	:= aMemFNA[3]
		FNA->FNA_OCORR	:= aMemFNA[4]
		FNA->FNA_DTPERI	:= aMemFNA[5]
		FNA->FNA_DTPERF	:= aMemFNA[6]
		FNA->FNA_QUANTD	:= aMemFNA[7]
		FNA->FNA_ESTORN	:= '2'

		If aMemFNA[4] $ "P2|P3|P4|"
			FNA->FNA_COEFIC	:= Round( NoRound( aFatorDep[nX] , nDecCoef+1 ) , nDecCoef )
		EndIf
		If !(aMemFNA[4] $ "P1|P8|")
			FNA->FNA_MOEDA	:= cValToChar(nX) + Space(nTamMoeda - nX) //Temp
		EndIf
		MsUnlock()

		If nX == 1
			//Salva o registro atual
			nRecFNA := FNA->(Recno())

			//Salva os dados do bem
			aRecFNA := Array(9)
			aRecFNA[1] := FNA->FNA_FILIAL
			aRecFNA[2] := FNA->FNA_CBASE
			aRecFNA[3] := FNA->FNA_ITEM
			aRecFNA[4] := FNA->FNA_TIPO
			aRecFNA[5] := FNA->FNA_SEQ
			aRecFNA[6] := FNA->FNA_SEQREA
			aRecFNA[7] := FNA->FNA_TPSALD
			aRecFNA[8] := FNA->FNA_MOEDA
			aRecFNA[9] := FNA->FNA_DATA

			//Produco
			nProdMes := 0
			aVrdMes := IIF(lMultMoed, AtfMultMoe(,,{|xMoeda| 0 }) , {0,0,0,0,0} )
			nProdAcm := 0
			aVrdAcm := IIF(lMultMoed, AtfMultMoe(,,{|xMoeda| 0 }) , {0,0,0,0,0} )

			//Apontamento estornado
			aAptoEst := {}

			//Quantidade estornada
			nQtdEst := 0

			dbSelectArea("SN3")
			dbSetOrder(1)		//N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ
			dbGoTop()

			dbSelectArea("SN4")
			dbSetOrder(1)		//N4_FILIAL+N4_CBASE+N4_ITEM+N4_TIPO+DTOS(N4_DATA)+N4_OCORR+N4_SEQ
			dbGoTop()

			//Atualiza os registros da tabela SN3
			dbSelectArea("FNA")
			dbSetOrder(1)		//FNA_FILIAL+FNA_IDMOV+FNA_ITMOV+FNA_MOEDA+FNA_OCORR
			dbGoTop()

			Do Case
				Case aMemFNA[4] == "P1"		//Apont. de revisao de estimativa de produco
				//Restaura o νndice e registro atual
				FNA->(dbSetOrder(1))		//FNA_FILIAL+FNA_IDMOV+FNA_ITMOV+FNA_MOEDA+FNA_OCORR
				FNA->(dbGoTo(nRecFNA))

				If SN3->(MsSeek(FNA->FNA_FILIAL+FNA->FNA_CBASE+FNA->FNA_ITEM+FNA->FNA_TIPO+"0"+FNA->FNA_SEQ))
					RecLock("SN3",.F.)
					SN3->N3_PRODANO	:= NoRound( FNA->FNA_QUANTD , nDecAno+1 )
					MsUnlock()
					//Lanηamento padrao
					cPadrao := "871"		//Apontamento de revisao da estimativa de produco

					//Verifica se o lanηamento padrao esta configurado
					lPadrao := VerPadrao(cPadrao)

					IF lPadrao .And. lOnOff
						nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
					EndIf

					//Altera a varνavel de controle do laηo, para nao gravar apontamentos para todas as moedas
					nX := Len(aTxDepr)
				EndIf
				Case aMemFNA[4] $ "P2|P3|P4|"		//Apont. de produco e estorno
				//Verifica todos os apontamentos realizados no mκs
				FNA->(dbSetOrder(2))		//FNA_FILIAL+FNA_CBASE+FNA_ITEM+FNA_TIPO+FNA_SEQ+FNA_SEQREA+FNA_TPSALD+DTOS(FNA_DATA)
				If FNA->(MsSeek(aRecFNA[1]+aRecFNA[2]+aRecFNA[3]+aRecFNA[4]+aRecFNA[5]+aRecFNA[6]+aRecFNA[7]))
					While FNA->(!EoF())	.And. (FNA->(FNA_FILIAL+FNA_CBASE+FNA_ITEM+FNA_TIPO+FNA_SEQ+FNA_SEQREA+FNA_TPSALD)) == aRecFNA[1]+aRecFNA[2]+aRecFNA[3]+aRecFNA[4]+aRecFNA[5]+aRecFNA[6]+aRecFNA[7]
						If FNA->FNA_OCORR $ "P2|P3|P4|" .And. FNA->FNA_ESTORN != "1"
							//Atualiza a variavel que acumula a depreciaco total
							aVrdAcm[Val(FNA->FNA_MOEDA)] += FNA->FNA_VALOR
							//Verifica a moeda do apontamento
							If FNA->FNA_MOEDA == aRecFNA[8]
								//Atualiza a variavel que acumula a produco total
								nProdAcm += FNA->FNA_QUANTD
							EndIf
							If (FNA->FNA_DATA > dUltDepr .And. FNA->FNA_DATA <= LastDay(dUltDepr+1))
								//Atualiza a variavel que acumula a depreciaco total
								aVrdMes[Val(FNA->FNA_MOEDA)] += FNA->FNA_VALOR
								//Verifica a moeda do apontamento
								If FNA->FNA_MOEDA == aRecFNA[8]
									//Atualiza a variavel que acumula a produco mensal
									nProdMes += FNA->FNA_QUANTD
								EndIf
							EndIf
						EndIf
						FNA->(dbSkip())
					EndDo
				EndIf

				//Restaura o νndice e registro atual
				FNA->(dbSetOrder(1))		//FNA_FILIAL+FNA_IDMOV+FNA_ITMOV+FNA_MOEDA+FNA_OCORR
				FNA->(dbGoTo(nRecFNA))

				//Atualiza os campos do bem
				If SN3->(MsSeek(FNA->FNA_FILIAL+FNA->FNA_CBASE+FNA->FNA_ITEM+FNA->FNA_TIPO+"0"+FNA->FNA_SEQ))
					If aMemFNA[4] $ "P2|P3" .And. cPaisLoc <> "BOL"
						Do Case
							Case SN3->N3_TPDEPR $ "4|5|8|"		//Exaustao linear
							If lMultMoed
								aValDepr := AtfMultMoe(,,{|xMoeda| IIF( SN3->&("N3_VORIG"+cValToChar(xMoeda)) > 0, (SN3->&("N3_VORIG"+cValToChar(xMoeda)) + SN3->&("N3_AMPLIA"+cValToChar(xMoeda))) * FNA->FNA_COEFIC, 0 ) })
							Else
								aValDepr := {0,0,0,0,0}
								For nY := 1 To 5
									aValDepr[nY] := IIF(SN3->&("N3_VORIG"+cValToChar(nY)) > 0, (SN3->&("N3_VORIG"+cValToChar(nY)) + SN3->&("N3_AMPLIA"+cValToChar(nY))) * FNA->FNA_COEFIC, 0 )
								Next nY
							EndIf
							Case SN3->N3_TPDEPR == "9"		//Exaustao por saldo residual
							If lMultMoed
								//aValDepr := AtfMultMoe(,,{|xMoeda| IIF( SN3->&("N3_VORIG"+cValToChar(xMoeda)) > 0, (((SN3->&("N3_VORIG"+cValToChar(xMoeda)) + SN3->&("N3_AMPLIA"+cValToChar(xMoeda))) - SN3->N3_PRODACM) * FNA->FNA_COEFIC), 0 ) })
								aValDepr := AtfMultMoe(,,{|xMoeda| IIF( SN3->&("N3_VORIG"+cValToChar(xMoeda)) > 0, (((SN3->&("N3_VORIG"+cValToChar(xMoeda)) + SN3->&("N3_AMPLIA"+cValToChar(xMoeda))) - SN3->&("N3_VRDACM"+cValToChar(xMoeda))) * FNA->FNA_COEFIC), 0 ) })
							Else
								aValDepr := {0,0,0,0,0}
								For nY := 1 To 5
									//aValDepr[nY] := IIF( SN3->&("N3_VORIG"+cValToChar(nY)) > 0, (((SN3->&("N3_VORIG"+cValToChar(nY)) + SN3->&("N3_AMPLIA"+cValToChar(nY))) - SN3->N3_PRODACM) * FNA->FNA_COEFIC), 0 )
									aValDepr[nY] := IIF( SN3->&("N3_VORIG"+cValToChar(nY)) > 0, (((SN3->&("N3_VORIG"+cValToChar(nY)) + SN3->&("N3_AMPLIA"+cValToChar(nY))) - SN3->&("N3_VRDACM"+cValToChar(nY))) * FNA->FNA_COEFIC), 0 )
								Next nY
							EndIf
						EndCase

						//Atualiza os arrays de valor da depreciaco mensal e acumulada
						For nY := 1 To Len(aValDepr)
							aVrdAcm[nY] += aValDepr[nY]
							aVrdMes[nY] += aValDepr[nY]
						Next nY

						//Atualiza depreciacao acumulada
						RecLock("SN3",.F.)
						If cPaisLoc <> "BOL"
							For nY := 1 To Len(aValDepr)
								If SN3->(FieldPos("N3_VRDMES"+cValToChar(nY)) > 0)
									SN3->&("N3_VRDMES"+cValToChar(nY)) := aVrdMes[nY]
								EndIf

								If SN3->(FieldPos("N3_VRDACM"+cValToChar(nY)) > 0)
									SN3->&("N3_VRDACM"+cValToChar(nY)) := aVrdAcm[nY]
								EndIf
							Next nY
						Endif

						//Atualiza Producao acumulada
						SN3->N3_PRODMES	:= Round( NoRound( nProdMes , nDecQtd+1 ) , nDecMes )
						SN3->N3_PRODACM	:= Round( NoRound( (SN3->N3_PRODACM + aMemFNA[7]) , nDecQtd+1 ) , nDecAcm )

						//Caso a produco acumulada seja igual a prevista, o bem tem depreciacao finalizada.
						If STR(SN3->N3_PRODACM,17,2) == STR(SN3->N3_PRODANO,17,2) .and. cPaisLoc <> "BOL"
							For nY := 1 To Len(aValDepr)
								If  SN3->(FieldPos("N3_VRDMES"+cValToChar(nY)) > 0) .and. SN3->(FieldPos("N3_VRDACM"+cValToChar(nY)) > 0)
									nDifDepr := (SN3->&("N3_VORIG"+cValToChar(nY)) - SN3->&("N3_VRDMES"+cValToChar(nY)))
									SN3->&("N3_VRDMES"+cValToChar(nY)) += nDifDepr
									SN3->&("N3_VRDACM"+cValToChar(nY)) += nDifDepr
								EndIf
							Next nY
						EndIf
						If aMemFNA[4] == "P3"
							SN3->N3_DEXAUST	:= aRecFNA[9]
							SN3->N3_FIMDEPR	:= aRecFNA[9]
						EndIf
						MsUnlock()

						//Dados complementares a movimentaco
						aDadosComp := ATFXCompl(nTaxaMedia, FNA->FNA_COEFIC,/*cMotivo*/,/*cCodBaix*/,/*cFilOrig*/,/*cSerie*/,/*cNota*/,/*nVenda*/,/*cLocal*/, SN3->N3_PRODMES )

						//-----------------------------------------------------------------
						// Avalia o tipo de depreciaco que ocorrera (Fiscal ou Gerencial)
						//-----------------------------------------------------------------
						If SN3->N3_TIPO $ cTipoFiscal
							cTipDepr := "06" //Depreciaco fiscal
						ElseIf SN3->N3_TIPO $ cTipoGerenc
							cTipDepr := "20" //Depreciaco gerencial
						EndIf

						If cPaisLoc <> "BOL"
							//Gravaco na tabela SN4 da conta Depreciaco Acumulada
							ATFXMOV(SN3->N3_FILIAL,@cIDMOV,FNA->FNA_DATA,cTipDepr,SN3->N3_CBASE,SN3->N3_ITEM,SN3->N3_TIPO,SN3->N3_BAIXA,SN3->N3_SEQ,SN3->N3_SEQREAV,"4",0,SN3->N3_TPSALDO,/*aEntidades*/,aValDepr,aDadosComp,,,,,lOnOff,cPadrao)

							//Lanηamento padrao
							Do Case
								Case aMemFNA[4] == "P2"
								cPadrao := "872"		//Apontamento de produco
								Case aMemFNA[4] == "P3"
								cPadrao := "873"
							EndCase
						EndIf

						//Verifica se o lanηamento padrao esta configurado
						lPadrao := VerPadrao(cPadrao)

						If lPadrao .And. lOnOff
							nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
						EndIf

						If cPaisLoc <> "BOL"
							//Gravaco na tabela SN4 da conta Despesa de Depreciaco
							ATFXMOV(SN3->N3_FILIAL,@cIDMOV,FNA->FNA_DATA,cTipDepr,SN3->N3_CBASE,SN3->N3_ITEM,SN3->N3_TIPO,SN3->N3_BAIXA,SN3->N3_SEQ,SN3->N3_SEQREAV,"3",0,SN3->N3_TPSALDO,/*aEntidades*/,aValDepr,aDadosComp,,,,,lOnOff,cPadrao)

							//Lanηamento padrao
							Do Case
								Case aMemFNA[4] == "P2"
								If (SN3->N3_RATEIO == "1")
									//Contabiliza o rateio da despesa de depreciaco
									cPadrao := "87A"
									ATFRTMOV(	SN3->N3_FILIAL,;
									SN3->N3_CBASE,;
									SN3->N3_ITEM,;
									SN3->N3_TIPO,;
									SN3->N3_SEQ,;
									SN4->N4_DATA,;
									SN4->N4_IDMOV,;
									aValDepr,;
									.T.,;
									"1",;
									nHdlPrv,;
									cLoteATF,;
									@nTotal,;
									"0",;
									"ATFA110",;
									cPadrao,lOnOff				)
								Else
									cPadrao := "872"
								EndIf

								If cPadrao == "872"
									//Verifica se o lanηamento padrao esta configurado
									lPadrao := VerPadrao(cPadrao)

									If lPadrao .And. lOnOff
										nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
									EndIf
								EndIf

								Case aMemFNA[4] == "P3"
								cPadrao := "873"

								//Verifica se o lanηamento padrao esta configurado
								lPadrao := VerPadrao(cPadrao)

								If lPadrao .And. lOnOff
									nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
								EndIf
							EndCase

							//Verifica o tipo de saldo a ser atualizado
							Do case
								Case SN3->N3_TIPO $ cTipoFiscal
								cN5_TIPO := "4"
								Case SN3->N3_TIPO $ cTipoGerenc
								cN5_TIPO := "Y"
								Case SN3->N3_TIPO == "08"
								cN5_TIPO := "K"
								Case SN3->N3_TIPO == "09"
								cN5_TIPO := "L"
								OtherWise
								cN5_TIPO := "4"
							EndCase

							//Gravaco na tabela SN5 da conta Despesa de Depreciaco
							AtfSaldo(SN3->N3_CDEPREC,FNA->FNA_DATA,cN5_TIPO,aValDepr[1],aValDepr[2],aValDepr[3],aValDepr[4],aValDepr[5],"+",FNA->FNA_COEFIC,SN3->N3_SUBCDEP,,SN3->N3_CLVLDEP,SN3->N3_CCDESP,"3",aValDepr)

							//Gravaco na tabela SN5 da conta Depreciaco Acumulada
							AtfSaldo(SN3->N3_CCDEPR,FNA->FNA_DATA,cN5_TIPO,aValDepr[1],aValDepr[2],aValDepr[3],aValDepr[4],aValDepr[5],"+",FNA->FNA_COEFIC,SN3->N3_SUBCCDE,,SN3->N3_CLVLCDE,SN3->N3_CCCDEP,"4",aValDepr)
						EndIf

						//Controla a gravaco dos valores dos movimentos para atualizar o apontamento
						lGerouMov := .T.
					Else
						//Lanηamento padrao
						cPadrao := "874"		//Apontamento de complemento de produco

						//Atualizo a producao mensal e acumulada
						RecLock("SN3",.F.)
						SN3->N3_PRODMES	:= Round( NoRound( nProdMes , nDecQtd+1 ) , nDecMes )
						SN3->N3_PRODACM	:= Round( NoRound( (SN3->N3_PRODACM + aMemFNA[7]) , nDecQtd+1 ) , nDecAcm )
						MsUnlock()

						//Verifica se o lanηamento padrao esta configurado
						lPadrao := VerPadrao(cPadrao)

						If lPadrao .And. lOnOff
							nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
						EndIf
					EndIf
				EndIf
				Case aMemFNA[4] == "P8"		//Estorno de revisao de estim. de produco
				//Array utilizado para salvar todos os apontamentos de estimativa e revisao de estimativa de produco
				aAptos := {}

				FNA->(dbSetOrder(2))		//FNA_FILIAL+FNA_CBASE+FNA_ITEM+FNA_TIPO+FNA_SEQ+FNA_SEQREA+FNA_TPSALD+DTOS(FNA_DATA)
				If FNA->(MsSeek( aRecFNA[1]+aRecFNA[2]+aRecFNA[3]+aRecFNA[4]+aRecFNA[5]+aRecFNA[6]+aRecFNA[7] ))
					While FNA->(!EoF())	.And. (FNA->(FNA_FILIAL+FNA_CBASE+FNA_ITEM+FNA_TIPO+FNA_SEQ+FNA_SEQREA+FNA_TPSALD)) == aRecFNA[1]+aRecFNA[2]+aRecFNA[3]+aRecFNA[4]+aRecFNA[5]+aRecFNA[6]+aRecFNA[7]
						If (FNA->FNA_DATA <= LastDay(dUltDepr+1)) .And. (FNA->FNA_OCORR $ "P0|P1|") .And. (FNA->FNA_ESTORN != "1")
							AADD(aAptos, { FNA->FNA_FILIAL, FNA->FNA_IDMOV, FNA->FNA_ITMOV, FNA->FNA_CBASE, FNA->FNA_ITEM, FNA->FNA_TIPO, FNA->FNA_SEQ, FNA->FNA_SEQREA, FNA->FNA_TPSALD, DTOS(FNA->FNA_DATA) })
						EndIf
						FNA->(dbSkip())
					EndDo

					nUltApto := Len(aAptos)

					//Altera o campo de controle de estorno
					If FNA->(MsSeek(aAptos[nUltApto,1]+aAptos[nUltApto,4]+aAptos[nUltApto,5]+aAptos[nUltApto,6]+aAptos[nUltApto,7]+aAptos[nUltApto,8]+aAptos[nUltApto,9]+aAptos[nUltApto,10]))
						RecLock("FNA",.F.)
						FNA->FNA_ESTORN := "1"
						MsUnlock()

						cPadrao := "876"		//Estorno de apontamento de revisao de estimativa de produco

						//Verifica se o lanηamento padrao esta configurado
						lPadrao := VerPadrao(cPadrao)

						If lPadrao .And. lOnOff
							nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
						EndIf

						//Quantidade estornada
						nQtdEst := FNA->FNA_QUANTD
					EndIf

					//Verifica o apontamento de revisao de estimativa de produco que sera posto em vigor
					nUltApto := Len(aAptos)-1

					//Altera o campo de controle de estorno
					If nUltApto > 0 .and. FNA->(MsSeek(aAptos[nUltApto,1]+aAptos[nUltApto,4]+aAptos[nUltApto,5]+aAptos[nUltApto,6]+aAptos[nUltApto,7]+aAptos[nUltApto,8]+aAptos[nUltApto,9]+aAptos[nUltApto,10]))
						//Atualiza os campos do bem
						If SN3->(MsSeek(FNA->FNA_FILIAL+FNA->FNA_CBASE+FNA->FNA_ITEM+FNA->FNA_TIPO+"0"+FNA->FNA_SEQ))
							RecLock("SN3",.F.)
							SN3->N3_PRODANO	:= Round( NoRound( FNA->FNA_QUANTD , nDecQtd+1 ) , nDecAcm )
							MsUnlock()
						EndIf
					EndIf

					//Restaura o νndice e registro atual
					FNA->(dbSetOrder(1))		//FNA_FILIAL+FNA_IDMOV+FNA_ITMOV+FNA_MOEDA+FNA_OCORR
					FNA->(dbGoTo(nRecFNA))

					RecLock("FNA",.F.)
					FNA->FNA_QUANTD := nQtdEst
					MsUnlock()
				EndIf

				//Altera a varνavel de controle do laηo, para nao gravar apontamentos para todas as moedas
				nX := Len(aTxDepr)

				Case aMemFNA[4] == "P9" //Estorno de apontamentos de produco
				//Array utilizado para salvar os dados do apontamento estornado
				aAptoEst := Array(Len(aTxDepr),6)

				//Array utilizado para salvar os valores do apontamento estornado
				aValDepr := Array(Len(aTxDepr))

				FNA->(dbSetOrder(2))		//FNA_FILIAL+FNA_CBASE+FNA_ITEM+FNA_TIPO+FNA_SEQ+FNA_SEQREA+FNA_TPSALD+DTOS(FNA_DATA)
				If FNA->(MsSeek( aRecFNA[1]+aRecFNA[2]+aRecFNA[3]+aRecFNA[4]+aRecFNA[5]+aRecFNA[6]+aRecFNA[7]+DTOS(aRecFNA[9]) ))
					While FNA->(!EoF())	.And. (FNA->(FNA_FILIAL+FNA_CBASE+FNA_ITEM+FNA_TIPO+FNA_SEQ+FNA_SEQREA+FNA_TPSALD)+DTOS(FNA->FNA_DATA)) == aRecFNA[1]+aRecFNA[2]+aRecFNA[3]+aRecFNA[4]+aRecFNA[5]+aRecFNA[6]+aRecFNA[7]+DTOS(aRecFNA[9])
						If FNA->FNA_OCORR $ "P2|P3|P4|"
							RecLock("FNA",.F.)
							FNA->FNA_ESTORN := "1"
							MsUnlock()

							//Moeda do apontamento estornado
							nMoedaEst := Val(FNA->FNA_MOEDA)

							If nMoedaEst == 1
								nRecEst := FNA->(Recno())
							EndIf

							//Salva os dados do apontamento estornado
							aAptoEst[nMoedaEst,1] := FNA->FNA_DTPERI
							aAptoEst[nMoedaEst,2] := FNA->FNA_DTPERF
							aAptoEst[nMoedaEst,3] := FNA->FNA_QUANTD
							aAptoEst[nMoedaEst,4] := FNA->FNA_COEFIC
							aAptoEst[nMoedaEst,5] := FNA->FNA_VALOR
							aAptoEst[nMoedaEst,6] := FNA->FNA_MOEDA

							lGerouEst := .T.

							//Salva os valores a subtrair do saldo das contas
							aValDepr[nMoedaEst] := FNA->FNA_VALOR
						EndIf
						FNA->(dbSkip())
					EndDo

					//Contabiliza o apontamento estornado
					FNA->(dbGoTo(nRecEst))

					If FNA->FNA_OCORR $ "P2|P3|" .and. cPaisLoc <> "BOL"
						If SN3->(MsSeek(FNA->FNA_FILIAL+FNA->FNA_CBASE+FNA->FNA_ITEM+FNA->FNA_TIPO+"0"+FNA->FNA_SEQ))
							If  SN3->N3_TIPO $ cTipoFiscal
								nOcorr := "06"
							Elseif SN3->N3_TIPO $ cTipoGerenc
								nOcorr := "20"
							Endif
							If SN4->(MsSeek( FNA->(FNA_FILIAL+FNA_CBASE+FNA_ITEM+FNA_TIPO+DTOS(FNA_DATA))+nOcorr+FNA->FNA_SEQ ))
								While SN4->(!EoF())	;
								.And. SN4->(N4_FILIAL+N4_CBASE+N4_ITEM+N4_TIPO+DTOS(N4_DATA)+N4_OCORR+N4_SEQ)	;
								== FNA->(FNA_FILIAL+FNA_CBASE+FNA_ITEM+FNA_TIPO+DTOS(FNA_DATA))+nOcorr+FNA->FNA_SEQ
									Do Case
										Case FNA->FNA_OCORR == "P2"
										If SN4->N4_TIPOCNT == "3"
											If (SN3->N3_RATEIO == "1")
												//Contabiliza o rateio da despesa de depreciaco
												cPadrao := "87B"
												ATFRTMOV(	SN3->N3_FILIAL,;
												SN3->N3_CBASE,;
												SN3->N3_ITEM,;
												SN3->N3_TIPO,;
												SN3->N3_SEQ,;
												SN4->N4_DATA,;
												SN4->N4_IDMOV,;
												,;
												.T.,;
												"2",;
												nHdlPrv,;
												cLoteATF,;
												@nTotal,;
												"0",;
												"ATFA110",;
												cPadrao,lOnOff				)
											Else
												cPadrao := "877"		//Estorno de apontamento de produco

												//Verifica se o lanηamento padrao esta configurado
												lPadrao := VerPadrao(cPadrao)

												If lPadrao .And. lOnOff
													nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
												EndIf
											EndIf

										Else
											cPadrao := "877"		//Estorno de apontamento de produco

											//Verifica se o lanηamento padrao esta configurado
											lPadrao := VerPadrao(cPadrao)

											If lPadrao .And. lOnOff
												nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
											EndIf
										EndIf
										Case FNA->FNA_OCORR == "P3"
										//Controla se ira apagar as datas de exaustao
										lEstExaust := .T.

										cPadrao := "878"		//Estorno de apontamento de encerramento de produco

										//Verifica se o lanηamento padrao esta configurado
										lPadrao := VerPadrao(cPadrao)

										If lPadrao .And. lOnOff
											nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
										EndIf
									EndCase

									RecLock("SN4",.F.)
									dbDelete()
									MsUnlock()
									SN4->(dbSkip())

								EndDo
							EndIf

							//Verifica o tipo de saldo a ser atualizado
							Do case
								Case SN3->N3_TIPO $ cTipoFiscal
								cN5_TIPO := "4"
								Case SN3->N3_TIPO $ cTipoGerenc
								cN5_TIPO := "Y"
								Case SN3->N3_TIPO == "08"
								cN5_TIPO := "K"
								Case SN3->N3_TIPO == "09"
								cN5_TIPO := "L"
								OtherWise
								cN5_TIPO := "4"
							EndCase

							//Gravaco na tabela SN5 da conta Despesa de Depreciaco
							AtfSaldo(SN3->N3_CDEPREC,FNA->FNA_DATA,cN5_TIPO,aValDepr[1],aValDepr[2],aValDepr[3],aValDepr[4],aValDepr[5],"-",FNA->FNA_COEFIC,SN3->N3_SUBCDEP,,SN3->N3_CLVLDEP,SN3->N3_CCDESP,"3",aValDepr)

							//Gravaco na tabela SN5 da conta Depreciaco Acumulada
							AtfSaldo(SN3->N3_CCDEPR,FNA->FNA_DATA,cN5_TIPO,aValDepr[1],aValDepr[2],aValDepr[3],aValDepr[4],aValDepr[5],"-",FNA->FNA_COEFIC,SN3->N3_SUBCCDE,,SN3->N3_CLVLCDE,SN3->N3_CCCDEP,"4",aValDepr)
						EndIf
					ElseIf cPaisLoc <> "BOL"
						cPadrao := "879"		//Estorno de apontamento de complemento de produco

						//Verifica se o lanηamento padrao esta configurado
						lPadrao := VerPadrao(cPadrao)

						If lPadrao .and. lOnOff
							nTotal += DetProva(nHdlPrv,cPadrao,"ATFA110",cLoteAtf)
						EndIf
					EndIf
				EndIf

				If FNA->(MsSeek( aRecFNA[1]+aRecFNA[2]+aRecFNA[3]+aRecFNA[4]+aRecFNA[5]+aRecFNA[6]+aRecFNA[7] ))
					While FNA->(!EoF())	.And. (FNA->(FNA_FILIAL+FNA_CBASE+FNA_ITEM+FNA_TIPO+FNA_SEQ+FNA_SEQREA+FNA_TPSALD)) == aRecFNA[1]+aRecFNA[2]+aRecFNA[3]+aRecFNA[4]+aRecFNA[5]+aRecFNA[6]+aRecFNA[7]
						If FNA->FNA_OCORR $ "P2|P3|P4|" .And. FNA->FNA_ESTORN != "1"
							//Atualiza a variavel que acumula a depreciaco total
							aVrdAcm[Val(FNA->FNA_MOEDA)] += FNA->FNA_VALOR
							//Verifica a moeda do apontamento
							If FNA->FNA_MOEDA == aRecFNA[8]
								//Atualiza a variavel que acumula a produco total
								nProdAcm += FNA->FNA_QUANTD
							EndIf
							If (FNA->FNA_DATA > dUltDepr .And. FNA->FNA_DATA <= LastDay(dUltDepr+1))
								//Atualiza a variavel que acumula a depreciaco total
								aVrdMes[Val(FNA->FNA_MOEDA)] += FNA->FNA_VALOR
								//Verifica a moeda do apontamento
								If FNA->FNA_MOEDA == aRecFNA[8]
									//Atualiza a variavel que acumula a produco mensal
									nProdMes += FNA->FNA_QUANTD
								EndIf
							EndIf
						EndIf
						FNA->(dbSkip())
					EndDo

					//Restaura o νndice e registro atual
					FNA->(dbSetOrder(1))		//FNA_FILIAL+FNA_IDMOV+FNA_ITMOV+FNA_MOEDA+FNA_OCORR
					FNA->(dbGoTo(nRecFNA))

					If SN3->(MsSeek(FNA->FNA_FILIAL+FNA->FNA_CBASE+FNA->FNA_ITEM+FNA->FNA_TIPO+"0"+FNA->FNA_SEQ))
						RecLock("SN3",.F.)
						If cPaisLoc <> "BOL"
							For nY := 1 To Len(aVrdMes)
								If SN3->(FieldPos("N3_VRDMES"+cValToChar(nY)) > 0)
									SN3->&("N3_VRDMES"+cValToChar(nY)) := aVrdMes[nY]
								EndIf
							Next nY

							For nY := 1 To Len(aVrdAcm)
								If SN3->(FieldPos("N3_VRDACM"+cValToChar(nY)) > 0)
									SN3->&("N3_VRDACM"+cValToChar(nY)) := aVrdAcm[nY]
								EndIf
							Next nY

							If lEstExaust
								SN3->N3_DEXAUST := CtoD("//")
								SN3->N3_FIMDEPR := CtoD("//")
							EndIf
						EndIf
						SN3->N3_PRODMES	:= Round( NoRound( nProdMes , nDecQtd+1 ) , nDecMes )
						SN3->N3_PRODACM	:= Round( NoRound( nProdAcm , nDecQtd+1 ) , nDecAcm )
						MsUnlock()
					EndIf
				EndIf
			EndCase
		EndIf

		If lGerouMov
			RecLock("FNA",.F.)
			FNA->FNA_VALOR := SN4->&("N4_VLROC"+cValToChar(nX))
			Msunlock()
		EndIf

		If lGerouEst
			RecLock("FNA",.F.)
			FNA->FNA_DTPERI := aAptoEst[nX,1]
			FNA->FNA_DTPERF := aAptoEst[nX,2]
			FNA->FNA_QUANTD := aAptoEst[nX,3]
			FNA->FNA_COEFIC := aAptoEst[nX,4]
			FNA->FNA_VALOR  := aAptoEst[nX,5]
			Msunlock()
		EndIf

	Next nX

	//Incrementa o IT. Mov. do apontamento
	aMemFNA[2] := Soma1(aMemFNA[2])

Return

Static Function AF110Coefic(aTxDepr,cTabela,nQuant,dDtMov,lEncerra)

	Local aParam		:= Array(9)
	Local aCoefic		:= {}

	Default aTxDepr 	:= IIF(lMultMoed, AtfMultMoe(,,{|xMoeda| 0 }) , {0,0,0,0,0} )
	Default cTabela		:= "SN3"
	Default nQuant		:= 0
	Default dDtMov		:= dDataBase	//Temp
	Default lEncerra	:= .F.

	aParam[1] := (cTabela)->N3_VORIG1
	aParam[2] := (cTabela)->N3_VRDACM1
	aParam[3] := (cTabela)->N3_TPDEPR
	aParam[4] := (cTabela)->N3_VMXDEPR
	aParam[5] := (cTabela)->N3_PERDEPR
	aParam[6] := (cTabela)->N3_VLSALV1
	aParam[7] := IIF(lEncerra, ((cTabela)->N3_PRODANO - (cTabela)->N3_PRODACM) , nQuant )
	aParam[8] := (cTabela)->N3_PRODANO
	aParam[9] := (cTabela)->N3_FIMDEPR

	aCoefic := AFatorCalc(aTxDepr, (cTabela)->N3_DINDEPR, dDtMov, (cTabela)->N3_TPDEPR, , , aParam)

Return(aCoefic)