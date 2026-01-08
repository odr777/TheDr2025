#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"
#INCLUDE "FINA630.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao CORFIN630 ³ ³ Autor ³Erick Etcheverry  ³ 		  Data ³15.06.2018³±±
±±³ Cambio cliente en tabelas SE1 SEL SE5 SE6							   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri³ Al final actualiza clientes para acomodar los saldos			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////CAMBIO DE CLIENTE PARA COBROS DIVERSOS
///ACTUALIZA LAS TABLAS SE1 SEL SE5 SE6
user function CORFIN630()
	Local _cFilOld := cFilAnt
	Local lPanelFin := IsPanelFin()
	Local nOpcA
	Local aTit := {}
	Local aTitTran	:= {}
	Local nX
	Local nSaldo
	Local aAcho := {}
	Local cFilSe1
	Local cFilTrans	:= ""
	Local cFilOld := cFilAnt // Guarda filial atual
	Local cChave, cChave1
	Local aRecno := {}
	//Controle de abatimento
	Local lTitpaiSE1 := .T.
	Local cTitPai := ""
	Local nY := 0
	Local cParcela	:= Space(TamSx3("E1_PARCELA")[1])
	Local lSolicAb	:= (mv_par01==1)	// Apenas solicitacoes em aberto
	Local lDtMovFin := .T.
	Local lRet		:= .F.
	Local IsAuto	:= Type("lMsErroAuto")<>"U"
	Local cHist
	Local aAreaSE1	:={}
	Local aAlt      :={}
	Local cTipo 	:= ""
	Local nValBx	:= 0
	Local nRecFRY	:= 0
	Local cParcRec	:= ''
	Local cDebito	:= ""
	Local cCredit	:= ""
	Local cCCD		:= ""
	Local cCCC		:= ""
	Local cItemD	:= ""
	Local cItemC	:= ""
	Local cCLVLDB	:= ""
	Local cCLVLCR	:= ""
	Local _cEnt05D	:= "" //Entidade 05
	Local _cEnt05C	:= "" //Entidade 05
	Local _cEnt06D	:= "" //Entidade 06
	Local _cEnt06C	:= "" //Entidade 06
	Local _cEnt07D	:= "" //Entidade 07
	Local _cEnt07C	:= "" //Entidade 07
	Local _cEnt08D	:= "" //Entidade 08
	Local _cEnt08C	:= "" //Entidade 08
	Local _cEnt09D	:= "" //Entidade 09
	Local _cEnt09C	:= "" //Entidade 09
	Local cFilSe2	:= xFilial("SE2")
	Local lTrfISSf	:= GetNewPar("MV_TRFISSF",.T.)
	Local cPrefixo	:= ""
	Local lAltPref	:= .F.
	Local aMsg		:= {}
	Local aChaves 	:= {"E1_FILIAL", "E1_PREFIXO", "E1_NUM", "E1_PARCELA", "E1_TIPO"}
	Local nPos 		:= 0
	Local lCompSED	:= FwModeAccess("SED", 3) == "E"
	Local lVldFil	:= .F.

	Private lF630Auto := aRotAuto<>nil

	aAdd(aTitTran, SE1->E1_FILIAL  ) // E3_FILIAL ORIGEM
	aAdd(aTitTran, SE1->E1_NUM     ) // E3_NUM
	aAdd(aTitTran, SE1->E1_PREFIXO ) // E3_PREFIXO
	aAdd(aTitTran, SE1->E1_TIPO    ) // E3_TIPO
	aAdd(aTitTran, SE1->E1_PARCELA ) // E3_PARCELA

	If !FA630FIL(aTitTran, .T. )
		Help(" ",1, "FA630IHelp", , STR0034, 1, 0)
		Return(.F.)
	Else
		lVldFil := .T.
	Endif

	if lF630Auto ///rutina automatica
		DbSelectArea("SE6")
		DbSetorder(3)
		If (nT := ascan(aRotAuto,{|x| x[1]='E6_NUMSOL'}) ) > 0
			DbSeek(xFilial("SE6")+ Padr(aRotAuto[nT,2],TamSx3('E6_NUMSOL')[1 ]) )
		EndIf
	Endif

	// Apenas solicitacoes em aberto podem ser aprovadas.
	If SE6->E6_SITSOL != "1"
		Help(" ",1,"FIN63004",,STR0021,1,0)
		Return .F.
	Endif

	// Nao eh permitido aprovar transferencias de titulos solicitados para
	// outra filial.
	If _cFilOld != SE6->E6_FILDEB
		Help(" ",1,"FIN63006",,	STR0008 + SE6->E6_FILDEB + CHR(13)+; //"Transferência solicitada para filial: "
		STR0009 + _cFilOld, 4 , 0 ) //"Filial atual: "
		Return .F.
	Endif

	DbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SE6")
	While ! SX3->(EOF()) .And. (SX3->X3_Arquivo == "SE6")
		If X3USO(SX3->X3_Usado) .And. cNivel >= SX3->X3_NIVEL
			// Na aprovacao, o historico da rejeicao nao deve ser apresentado
			If AllTrim(SX3->X3_CAMPO) != "E6_HISREJ"
				Aadd(aAcho, X3_CAMPO)
			Endif
		Endif
		SX3->(dbSkip())
	End

	nReg := SE6->(recno())
	///ABRE TELA CON DATOS QUE SE TENIAN
	If !lF630Auto
		nOpca := AxVisual("SE6",nReg,2,aAcho,,,,,,,,,.T.)
	Else
		If ascan(aRotAuto,{|x| x[1]='E6_NUMSOL'})>0 .and. SE6->(DbSeek(xFilial("SE6")+ Padr(aRotAuto[nT,2],TamSx3('E6_NUMSOL')[1]) ))
			RegToMemory("SE6",.T.,,,)
			nOpca := 1
		EndIf
	EndIf

	If nOpcA == 1

		cFilTrans	:= SE6->E6_FILORIG
		cFilAnt 	:= SE6->E6_FILORIG
		cFilSe1 	:= xFilial("SE1")
		Posicione("SE1",1,cFilSe1+SE6->(E6_PREFIXO+E6_NUM+E6_PARCELA+E6_TIPO),"E1_CLIENTE")

		If	!IsAuto
			lMsErroAuto := .F. // variavel interna da rotina automatica
		Endif
		If SE1->(!Eof())
			BEGIN TRANSACTION
				aTit := {}
				aAreaSE1:=SE1->(GetArea())
				nAbatim := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",SE1->E1_MOEDA,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA, cFilSe1,,SE1->E1_TIPO)
				RestArea(aAreaSE1)
				nSaldo := (SE1->E1_SALDO - nAbatim)
				nSaldo += SE1->E1_SDACRES
				nSaldo -= SE1->E1_SDDECRE
				nRecNoSe1 := SE1->(Recno())
				aRecnEl := getcobro(SE1->E1_NUM,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_SERREC,SE1->E1_FILIAL)////////validamos que tenga SEL para empezar a actualizar todo devuelve un array de recnos si esta vacio no hay deposito
				if !empty(aRecnEl)

					If RecLock("SE6",.F.)
						SE6->E6_SITSOL := "2" // Solicitacao aprovada
						SE6->E6_USRAPV :=	RetCodUsr() // Aprovador
						SE6->(MsUnlock())
						cChave := cFilSe1 + SE6->(E6_PREFIXO+E6_NUM+E6_PARCELA)
						cTitPai := SE6->(E6_PREFIXO+E6_NUM+E6_PARCELA+E6_TIPO+E6_CLIENTE+E6_LOJA)
						SE1->(MsSeek(cChave))
						While ! lMsErroAuto .and. SE1->(!Eof()) .And. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA) == cChave
							// Nao eh abatimento
							If !(SE1->E1_TIPO $ "RA")
								If SE1->E1_TIPO == SE6->E6_TIPO // Titulo Principal
									Aadd(aRecno, SE1->(Recno()))
								EndIf
							ELSE
								SE1->(DbSkip())
								Loop
							Endif
							SE1->(DbSkip())
						Enddo
						aSort(aRecno)
						// Transfere todos os titulos agregados
						nY := 1
						While ! lMsErroAuto .And. nY <= Len(aRecno)
							SE1->(MsGoto(aRecno[nY]))
							aTit := {}

							AADD( aTit, {"E1_PREFIXO"   ,"TRF"  			,Nil})
							AADD( aTit, {"E1_NUM"       ,SE6->E6_NUM       	,Nil})
							AADD( aTit, {"E1_PARCELA"   ,SE1->E1_PARCELA   	,Nil})
							AADD( aTit, {"E1_TIPO"      ,"NCC"             	,Nil})
							AADD( aTit, {"E1_NATUREZ"   ,"OTROS"           	,Nil})
							AADD( aTit, {"E1_CLIENTE"   ,SE6->E6_CLIENTE   	,Nil})
							AADD( aTit, {"E1_LOJA"      ,SE6->E6_LOJA      	,Nil})
							//AADD( aTit, {"E1_NOMCLI"  ,SA1->A1_NOME    	,Nil})
							AADD( aTit, {"E1_EMISSAO"   ,dDataBase         	,Nil})
							AADD( aTit, {"E1_VENCTO"    ,dDataBase         	,Nil})
							AADD( aTit, {"E1_VENCREA"   ,dDataBase         	,Nil})
							AADD( aTit, {"E1_MOEDA"     ,SE1->E1_MOEDA   	,Nil})
							AADD( aTit, {"E1_TXMOEDA"   ,SE1->E1_TXMOEDA   	,Nil})
							AADD( aTit, {"E1_VALOR"    	,SE6->E6_VALOR      ,Nil})
							AADD( aTit, {"E1_HIST" ,"ANTICIPO TRANSFERIDO"  ,Nil})
							AADD( aTit, {"E1_ORIGEM"    ,"FINA630"         	,Nil})
							AADD( aTit, {"E1_NUMSOL"    ,SE6->E6_NUMSOL    	,Nil})
							AADD( aTit, {"E1_CREDIT"    , Posicione("SA1",1,XFILIAL("SA1") + SE6->E6_CLIENTE +SE6->E6_LOJA, "A1_UCTAANT"),Nil})

							// Grava titulo na filial de debito destino
							//If !IsAuto
							MSExecAuto({|x, y| FINA040(x, y)}, aTit, 3)
							/*Else
							FINA040(aTit, 3)
							EndIf*/
							nY ++
						End
						If lMsErroAuto
							if !IsBlind()
								MostraErro()
							EndIf
							DisarmTransaction()
							Break
						Else

							SE1->(MsGoto(nRecNoSe1))
							cFilSe1 := SE6->E6_FILORIG
							// Altera para filial do titulo de origem para fazer a baixa
							cFilAnt := cFilSe1
							aTit := {}
							AADD(aTit , {"E1_PREFIXO"	, SE6->E6_PREFIXO	, NIL})
							AADD(aTit , {"E1_NUM"		, SE6->E6_NUM		, NIL})
							AADD(aTit , {"E1_PARCELA"	, SE6->E6_PARCELA	, NIL})
							AADD(aTit , {"E1_TIPO"		, SE6->E6_TIPO		, NIL})
							AADD(aTit , {"E1_CLIENTE"	, SE1->E1_CLIENTE	, NIL})
							AADD(aTit , {"E1_LOJA"		, SE1->E1_LOJA		, NIL})
							AADD(aTit , {"AUTMOTBX"		, "TRF"				, NIL})
							AADD(aTit , {"AUTDTBAIXA"	, dDataBase			, NIL})
							AADD(aTit , {"AUTDTCREDITO", dDataBase			, NIL})
							//Ponto de entrada criado para alterar a gravação do histórico na SE5

							AADD(aTit , {"AUTHIST"		, "Baja por transferencia",NIL}) //"Bx. p/transf. da filial "###" p/"

							AADD(aTit , {"AUTVALREC"	, nSaldo				, NIL })
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Executa a Baixa do Titulo                                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !IsAuto
								MSExecAuto({|x, y| FINA070(x, y)}, aTit, 3)
							Else
								lRet	:= FINA070(aTit, 3)
							Endif
							If lMsErroAuto .or. !lRet
								If lMsErroAuto
									MostraErro()
								EndIf
								DisarmTransaction()
								Break
							Else
								// Transfere SK1 tambem.
								If SK1->(MsSeek(xFilial("SK1")+SE6->(E6_PREFIXO+E6_NUM+E6_PARCELA+E6_TIPO)))
									RecLock("SK1")
									SK1->K1_FILIAL		:= SE6->E6_FILDEB
									SK1->K1_CLIENTE		:= SE6->E6_CLIENTE
									SK1->K1_LOJA		:= SE6->E6_LOJA
									SK1->K1_FILORIG		:= SE6->E6_FILDEB
									MsUnlock()
								Endif

								If lVldFil

									aTitTran := {}
									aAdd(aTitTran, cFilTrans  ) // E3_FILIAL ORIGEM
									aAdd(aTitTran, aTit[2][2] ) // E3_NUM
									aAdd(aTitTran, aTit[1][2] ) // E3_PREFIXO
									aAdd(aTitTran, aTit[4][2] ) // E3_TIPO
									aAdd(aTitTran, aTit[3][2] ) // E3_PARCELA

									FA630FIL(aTitTran) // Função que controla a duplicidade de SE2 na transferencia de titulos
								Endif
								lRet	:= .T.
							EndIf
							If lRet
								If SE1->E1_ISS != 0 .And. lTrfISSf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Baixa tambem os registro de impostos-ISS	  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									dbSelectArea("SE2")
									dbSetOrder(1)
									If dbSeek(xFilial("SE2")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA))
										IF AllTrim(E2_NATUREZ) = Alltrim(&(GetMv("MV_ISS"))) .and. ;
										STR(SE2->E2_SALDO,17,2) == STR(SE2->E2_VALOR,17,2)

											cFilSe2 := If(!Empty(cFilSe2), SE6->E6_FILORIG,cFilSe2)
											aTit := {}
											// Altera para filial do titulo de origem para fazer a baixa
											cFilAnt := cFilSe2
											AADD(aTit , {"E2_FILIAL"	, SE2->E2_FILIAL	, NIL})
											AADD(aTit , {"E2_PREFIXO"	, SE2->E2_PREFIXO	, NIL})
											AADD(aTit , {"E2_NUM"		, SE2->E2_NUM		, NIL})
											AADD(aTit , {"E2_PARCELA"	, SE2->E2_PARCELA	, NIL})
											AADD(aTit , {"E2_TIPO"		, SE2->E2_TIPO		, NIL})
											AADD(aTit , {"E2_NATUREZ"	, SE2->E2_NATUREZ	, NIL})
											AADD(aTit , {"E2_FORNECE"	, SE2->E2_FORNECE	, NIL})
											AADD(aTit , {"E2_LOJA"		, SE2->E2_LOJA		, NIL})
											AADD(aTit , {"AUTMOTBX"		, "TRF"				, NIL})
											AADD(aTit , {"AUTDTBAIXA"	, dDataBase			, NIL})
											//Ponto de entrada criado para alterar a gravação do histórico na SE5

											IF ExistBlock("F630HIST")
												cHist:=ExecBlock("F630HIST",.f.,.f.)
												AADD(aTit , {"AUTHIST"		, cHist			,NIL})
											Else
												AADD(aTit , {"AUTHIST"		, STR0010 + SE6->E6_FILORIG + STR0011 + SE6->E6_FILDEB,NIL}) //"Bx. p/transf. da filial "###" p/"
											EndIf
											AADD(aTit , {"AUTVLRPG"	, SE2->E2_SALDO	, NIL })
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Executa a Baixa do Titulo                                         ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											If !IsAuto
												MSExecAuto({|x, y| FINA080(x, y)}, aTit, 3)
											Else
												lRet	:= FINA080(aTit, 3)
											Endif

											If lMsErroAuto
												MostraErro()
												DisarmTransaction()
												Break
											Else
												cFilAnt := cFilOld // Restaura filial atual
												lRet	:= .T.
											Endif
										EndIf
									Endif
								EndIf
							EndIf
						Endif
					Endif
				ELSE
					alert("No hay ningun deposito")
				ENDIF
			END TRANSACTION
		Endif
	Endif

	///numbor
	aadd( aAlt,{ STR0030,'','','',STR0031 +  Alltrim(cFilOld) })
	//chamada da Função que cria o Histórico de Cobrança
	FinaCONC(aAlt)

	cFilAnt := cFilOld	// Restaura filial atual
	If lSolicAb 		// Apenas solicitacoes em aberto
		SE6->(DbSetOrder(2))
		SE6->(MsSeek(xFilial("SE6")+"1")) // Posiciona na primeira solicitacao em aberto
	EndIf

return

///POSICIONA EN EL COBRO en la tabela SEL
static function getcobro(cRecib,cCliold,cLojold,cSerr,cFila)
	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local aRecnos := {}
	Local lEncontro := .f.

	/*SELECT 1 FROM SEL010 WHERE EL_RECIBO = '000190' AND EL_CLIORIG = 'OO2222' AND EL_LOJA = '01' AND EL_SERIE = 'VR' AND EL_TIPO = 'TF'
	UNION
	SELECT R_E_C_N_O_ FROM SEL010 WHERE EL_RECIBO = '000190' AND EL_CLIORIG = 'OO2222' AND EL_LOJA = '01' AND EL_SERIE = 'VR'*/

	///el query busca si hay el tipo TF que es el deposito y todos sus registros
	cQuery := " SELECT 0 recnoe"
	cQuery += " FROM "
	cQuery += "   "+RetSQLName("SEL")+" SEL "
	cQuery += " WHERE "
	cQuery += " EL_RECIBO = '" + cRecib + "' AND"
	cQuery += " EL_CLIORIG = '" + cCliold + "' AND"
	cQuery += " EL_LOJA = '" + cLojold + "' AND"
	cQuery += " EL_SERIE = '" + cSerr + "' AND"
	cQuery += " EL_TIPO = 'TF' AND"
	cQuery += " EL_FILIAL = '" + cFila + "' AND"
	cQuery += " SEL.D_E_L_E_T_ = '' "
	cQuery += " UNION "
	cQuery += " SELECT R_E_C_N_O_ recnoe"
	cQuery += " FROM "
	cQuery += "   "+RetSQLName("SEL")+" SEL "
	cQuery += " WHERE "
	cQuery += " EL_RECIBO = '" + cRecib + "' AND"
	cQuery += " EL_CLIORIG = '" + cCliold + "' AND"
	cQuery += " EL_LOJA = '" + cLojold + "' AND"
	cQuery += " EL_SERIE = '" + cSerr + "' AND"
	cQuery += " EL_FILIAL = '" + cFila + "' AND"
	cQuery += " SEL.D_E_L_E_T_ = '' "

	//Aviso("Array IVA",cQuery,{'ok'},,,,,.t.)

	cQuery := ChangeQuery(cQuery)

	TCQuery cQuery New Alias "QRY_SEL"

	if !QRY_SEL->(EoF())
		if QRY_SEL->recnoe == 0
			QRY_SEL->(dbskip())
			while !QRY_SEL->(EoF())
				aadd(aRecnos,recnoe)
				QRY_SEL->(dbskip())
			enddo
		endif
	endif

	//Aviso("Array IVA",u_zArrToTxt(aRecnos, .T.),{'ok'},,,,,.t.)

	QRY_SEL->(DbCloseArea())
	RestArea(aArea)
return aRecnos