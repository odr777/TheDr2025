#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "FINA100.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"


Static lPmsInt		:=	IsIntegTop(,.T.)
Static nMsgOpc		:= 	0
Static lPagar		:= .F.
Static lReceber		:= .F.
Static _oFINA1001
Static lFA100TRF	:= ExistBlock("FA100TRF")
Static lFA100VET	:= ExistBlock("FA100VET")
Static lEAIA100		:= FWHasEAI("FINA100", .T.,, .T.)
Static cEAIA100v	:= MsgUVer('FINA100', "BANKTRANSACTION")


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fa100tran³Autor  ³ Wagner Xavier         ³ Data ³ 03/06/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Transferencia entre bancos/agencias.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fa100tran()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function xfa100tran(cAlias,nReg,nOpc,aM,aAutoCab)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Vari veis 														  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lPanelFin 	:= IsPanelFin()
	LOCAL cBcoOrig		:= CriaVar("E5_BANCO")
	LOCAL cBcoDest		:= CriaVar("E5_BANCO")
	LOCAL cAgenOrig		:= CriaVar("E5_AGENCIA")
	LOCAL cAgenDest		:= CriaVar("E5_AGENCIA")
	LOCAL cCtaOrig		:= CriaVar("E5_CONTA")
	LOCAL cCtaDest		:= CriaVar("E5_CONTA")
	LOCAL cNaturOri		:= CriaVar("E5_NATUREZ")
	LOCAL cNaturDes		:= CriaVar("E5_NATUREZ")
	LOCAL cDocTran		:= CriaVar("E5_NUMCHEQ")
	LOCAL cHist100		:= CriaVar("E5_HISTOR")
	LOCAL nValorTran	:= 0
	LOCAL nOpcA			:= 0
	LOCAL cBenef100 	:= CriaVar("E5_BENEF")
	LOCAL oDlg			:= NIL
	LOCAL lA100BL01		:= ExistBlock("A100BL01")
	LOCAL lF100DOC		:= ExistBlock("F100DOC")
	LOCAL aValores		:= {}
	LOCAL lGrava		:= .F.
	LOCAL nA			:= 0
	LOCAL cMoedaTx		:= ""
	LOCAL lSpbInUse		:= SpbInUse()
	LOCAL aModalSPB		:=  {"1=TED","2=CIP","3=COMP"}
	LOCAL oModSPB		:= NIL
	LOCAL cModSpb		:= ""
	LOCAL aTrfPms		:= {}
	LOCAL lEstorno		:= .F.
	LOCAL aSimbMoeda	:= {}							//Array com os simbolos das moedas.
	LOCAL nPosMoeda		:= 0							//Verifica a posicao da moeda no array aSimbMoeda
	LOCAL nX			:= 0							//Contador
	LOCAL nTotMoeda		:= 0							//TotMoeda
	LOCAL lExit			:= .F. 						//Executa a rotina apenas uma vez (Painel Gestor)

	Local aValidGet		:= {}
	Local nPosAuto		:= 0
	Local lFA100Get		:= Existblock ("FA100Get")
	Local aFa100Get		:= {}
	Local nDiasDispo	:= SUPERGETMV("MV_DIASCRD",.F.,0)
	Local dDataCred		:= dDatabase + nDiasDispo
	Local dDtdisp		:= dDatabase
	Local lbFilBrw		:= .F.
	Local cGetMoeda		:= ""
	Local laTrfPan		:= .F.
	Local nPosBco		:= 0
	Local nPosAgenci	:= 0
	Local nPosConta		:= 0

	Default aAutoCab := {}

	PRIVATE oBcoOrig	:= NIL
	PRIVATE oAgenOrig	:= NIL
	PRIVATE oCtaOrig	:= NIL
	PRIVATE oBcoDest	:= NIL
	PRIVATE oAgenDest	:= NIL
	PRIVATE oCtaDest	:= NIL

	PRIVATE cCodDiario 	:= ""
	PRIVATE aDiario 	:= {}
	PRIVATE nTxEstP		:= 0
	PRIVATE nTxEstR		:= 0

	lPagar      := .F.
	lReceber    := .F.

	//Implementacao do Execauto
	lF100Auto := If(Empty(aAutoCab),.F.,.T.)

	//Se chamado do
	If Type("aTrfPanel") == "A"
		PRIVATE cLote
		PRIVATE cArquivo := " "
		LoteCont( "FIN" )
		laTrfPan := .T.
	Endif

	// rotina externa nao contabiliza (o SIGALOJA usa esta rotina
	// direto da rotina de venda rapida e neste caso
	// o parametro ‚ sempre .T.
	If Substr(Upper(FunName()),1,7) == "LOJA220"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica Permissao "Sangria/Entrada de Troco" - #5 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !LjProfile(5,,,,,.T.)
			Return(NIL)
		EndIf
		lExterno := .T.
	Endif

	PRIVATE aTxMoedas := {}
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³A moeda 1 e tambem inclusa como um dummy, nao vai ter uso,    ³
	//³mas simplifica todas as chamadas a funcao xMoeda, ja que posso³
	//³passara a taxa usando a moeda como elemento do Array atxMoedas³
	//³Exemplo xMoeda(E1_VALOR,E1_MOEDA,1,dDataBase,,aTxMoedas[E1_MOEDA][2])
	//³Bruno - Paraguay 22/08/2000                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	aAdd  (aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1")})
	For nA   := 2  To MoedFin()
		cMoedaTx := Str(nA,IIf(nA <= 9,1,2))
		cGetMoeda := GetMv("MV_MOEDA"+cMoedaTx)
		If !Empty(cGetMoeda)
			Aadd(aTxMoedas,{cGetMoeda,RecMoeda(dDataBase,nA),PesqPict("SM2","M2_MOEDA"+cMoedaTx) })
		Else
			Exit
		Endif
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Deleta a Ocorrencia "EST" no SX5 para for‡ar o usuario a uti-³
	//³ lizar a OPCAO Estorno para que o saldo bancario seja tratado ³
	//³ corretamente.                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX5")
	If dbSeek(xFilial()+"14"+"EST")
		Reclock("SX5")
		dbDelete()
		MsUnlock()
	Endif

	PRIVATE nTotal := 0
	PRIVATE cTipoTran := Space(3)

	If Type("bFiltraBrw") == "B"
		lbFilBrw := .T.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
	//³ movimentacao no financeiro    										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !DtMovFin(,,"3")
		If cPaisLoc <> "BRA" .And. lbFilBrw
			Eval( bFiltraBrw )
		Endif
		Return
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia lancamento no PCO                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoIniLan("000007")

	While .T.

		dbSelectArea("SE5")

		cBcoOrig	:= CriaVar("E5_BANCO")
		cBcoDest	:= CriaVar("E5_BANCO")
		cAgenOrig	:= CriaVar("E5_AGENCIA")
		cAgenDest	:= CriaVar("E5_AGENCIA")
		cCtaOrig	:= CriaVar("E5_CONTA")
		cCtaDest	:= CriaVar("E5_CONTA")
		cNaturOri	:= CriaVar("E5_NATUREZ")
		cNaturDes	:= CriaVar("E5_NATUREZ")
		cDocTran 	:= CriaVar("E5_NUMCHEQ")
		cHist100 	:= CriaVar("E5_HISTOR")
		nValorTran	:= 0
		cBenef100	:= CriaVar("E5_BENEF")
		cTipoTran	:= CriaVar("E5_MOEDA")
		dDataCred	:= DataValida(dDataCred)
		dDtdisp		:= DataValida(dDtdisp)
		If lSpbInUse
			cModSpb := "1"
		Endif
		nOpcA := 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recebe dados a serem digitados 										  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//Se chamado do Painel Gestor, posicionado numa determinada C/C
		//Já preenche os dados da conta de partida (saida do dinheiro)
		If laTrfPan
			SetKey (VK_F12,{|a,b| AcessaPerg("AFI100",.T.)})
			pergunte("AFI100",.F.)
			lExit := .T.
			If Len(aTrfPanel) > 0
				cBcoOrig	:= aTrfPanel[1]
				cAgenOrig   := aTrfPanel[2]
				cCtaOrig	:= aTrfPanel[3]
			Endif
		Endif

		aSize := MSADVSIZE()

		If lFA100Get
			aFa100Get:= Execblock ("FA100Get",.F.,.F.,{cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,cBcoDest,cAgenDest,cCtaDest,cNaturDes,cTipoTran,cDocTran,nValorTran,cHist100,cBenef100})
			If ValType(aFa100Get) == "A"
				cBcoOrig 	:= IIF(ValType(aFa100Get[1,1])=="C",aFa100Get[1,1],cBcoOrig)
				cAgenOrig 	:= IIF(ValType(aFa100Get[2,1])=="C",aFa100Get[2,1],cAgenOrig)
				cCtaOrig 	:= IIF(ValType(aFa100Get[3,1])=="C",aFa100Get[3,1],cCtaOrig)
				cNaturOri 	:= IIF(ValType(aFa100Get[4,1])=="C",aFa100Get[4,1],cNaturOri)
				cBcoDest 	:= IIF(ValType(aFa100Get[5,1])=="C",aFa100Get[5,1],cBcoDest)
				cAgenDest 	:= IIF(ValType(aFa100Get[6,1])=="C",aFa100Get[6,1],cAgenDest)
				cCtaDest 	:= IIF(ValType(aFa100Get[7,1])=="C",aFa100Get[7,1],cCtaDest)
				cNaturDes 	:= IIF(ValType(aFa100Get[8,1])=="C",aFa100Get[8,1],cNaturDes)
				cTipoTran 	:= IIF(ValType(aFa100Get[9,1])=="C",aFa100Get[9,1],cTipoTran)
				cDocTran 	:= IIF(ValType(aFa100Get[10,1])=="C",aFa100Get[10,1],cDocTran)
				nValorTran 	:= IIF(ValType(aFa100Get[11,1])=="N",aFa100Get[11,1],nValorTran)
				cHist100 	:= IIF(ValType(aFa100Get[12,1])=="C",aFa100Get[12,1],cHist100)
				cBenef100 	:= IIF(ValType(aFa100Get[13,1])=="C",aFa100Get[13,1],cBenef100)
			EndIf
		EndIF

		If !lF100Auto
			If lPanelFin  //Chamado pelo Painel Financeiro
				oPanelDados := FinWindow:GetVisPanel()
				oPanelDados:FreeChildren()
				aDim := DLGinPANEL(oPanelDados)
				DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )

				//----------------------------------------------------------------------
				// Observacao Importante quanto as coordenadas calculadas abaixo:
				//----------------------------------------------------------------------
				// a funcao DlgWidthPanel() retorna o dobro do valor da area do
				// painel, sendo assim este deve ser dividido por 2 antes da subtracao
				// e redivisao por 2 para a centralizacao.
				//----------------------------------------------------------------------
				nEspLarg :=	(((DlgWidthPanel(oPanelDados)/2) - 168) /2)
				nEspLin  := 1
			Else
				nEspLarg := 0
				nEspLin  := 1
				DEFINE MSDIALOG oDlg FROM  32, 113 TO 340,550 TITLE OemToAnsi(STR0009) PIXEL	// "Movimenta‡„o Banc ria"
			Endif

			oDlg:lMaximized := .F.
			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
			oPanel:Align := CONTROL_ALIGN_ALLCLIENT

			@ 000+nEspLin,004+nEspLarg TO 025+nEspLin,172+nEspLarg OF oPanel	PIXEL LABEL STR0020  // "Origem"
			@ 027+nEspLin,004+nEspLarg TO 052+nEspLin,172+nEspLarg OF oPanel	PIXEL LABEL STR0024  // "Destino"
			@ 056+nEspLin,004+nEspLarg TO 079+nEspLin,172+nEspLarg OF oPanel	PIXEL
			@ 081+nEspLin,004+nEspLarg TO 150+nEspLin,172+nEspLarg OF oPanel	PIXEL LABEL STR0025  // "Identificação"

			// Primeiro quadro - Banco Origem
			@ 005+nEspLin,008+nEspLarg SAY OemToAnsi(STR0021) 		 SIZE 19, 7 OF oPanel PIXEL	// "Banco"
			@ 005+nEspLin,042+nEspLarg SAY OemToAnsi(STR0022) 		 SIZE 25, 7 OF oPanel PIXEL	// "Agˆncia"
			@ 005+nEspLin,122+nEspLarg SAY OemToAnsi(STR0034)		 SIZE 28, 7 OF oPanel PIXEL	// "Natureza"
			@ 005+nEspLin,072+nEspLarg SAY OemToAnsi(STR0023) 		 SIZE 20, 7 OF oPanel PIXEL	// "Conta"

			@ 013+nEspLin,009+nEspLarg MSGET oBcoOrig 	VAR cBcoOrig	F3 "SA6"	Picture "@S3"	Valid CarregaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,.F.,,,@cNaturOri)	SIZE 10, 08												  OF oPanel PIXEL hasbutton
			@ 013+nEspLin,042+nEspLarg MSGET oAgenOrig	VAR cAgenOrig  				Picture "@S5"	SIZE 20, 08 OF oPanel PIXEL
			@ 013+nEspLin,072+nEspLarg MSGET oCtaOrig	VAR cCtaOrig				Picture "@S10"	SIZE 45, 08 OF oPanel PIXEL
			@ 013+nEspLin,122+nEspLarg MSGET cNaturOri					F3 "SED" 					Valid ExistCpo("SED",@cNaturOri) .AND. FinVldNat( .F., cNaturOri, 3 ) SIZE 47, 08 																		  OF oPanel PIXEL hasbutton

			// Segundo quadro - Banco Destino
			@ 032+nEspLin,008+nEspLarg SAY OemToAnsi(STR0021) 		 SIZE 23, 7 OF oPanel PIXEL	// "Banco"
			@ 032+nEspLin,042+nEspLarg SAY OemToAnsi(STR0022) 		 SIZE 27, 7 OF oPanel PIXEL	// "Agˆncia"
			@ 032+nEspLin,072+nEspLarg SAY OemToAnsi(STR0023) 		 SIZE 18, 7 OF oPanel PIXEL	// "Conta"
			@ 032+nEspLin,122+nEspLarg SAY OemToAnsi(STR0034)		 SIZE 28, 7 OF oPanel PIXEL	// "Natureza"

			@ 040+nEspLin,009+nEspLarg MSGET oBcoDest VAR cBcoDest	F3 "SA6" Picture "@S3"	Valid CarregaSa6(@cBcoDest,@cAgenDest,@cCtaDest,.F.,@cBenef100,,@cNaturDes) SIZE 10, 08 OF oPanel PIXEL hasbutton
			@ 040+nEspLin,042+nEspLarg MSGET oAgenDest VAR cAgenDest		 Picture "@S5"	SIZE 20, 08 OF oPanel PIXEL
			@ 040+nEspLin,072+nEspLarg MSGET oCtaDest VAR cCtaDest			 Picture "@S10"	Valid If( (cBcoDest+cAgenDest+cCtaDest) <> (cBcoOrig+cAgenOrig+cCtaOrig),.T.,oBcoDest:SetFocus() )	SIZE 45, 08 OF oPanel PIXEL
			@ 040+nEspLin,122+nEspLarg MSGET cNaturDes				F3 "SED"				Valid ExistCpo("SED",@cNaturDes)  .AND. FinVldNat( .F., cNaturDes, 3 ) SIZE 47, 08 OF oPanel PIXEL hasbutton

			//Terceiro Quadro - "Data de Crédito"
			@ 058+nEspLin,008+nEspLarg SAY "STR0143" SIZE 50, 7 OF oPanel PIXEL	// "Data de Crédito"
			@ 066+nEspLin,009+nEspLarg MSGET oDataCred 	VAR dDataCred	Valid F100VlDtCr(dDataCred) SIZE 60, 08	OF oPanel PIXEL hasbutton

			//Quarto Quadro	- Dados complementares do
			@ 087+nEspLin,008+nEspLarg SAY OemToAnsi(STR0026) 		 SIZE 31, 7 OF oPanel PIXEL	// "Tipo Mov."
			@ 087+nEspLin,042+nEspLarg SAY OemToAnsi(STR0027) 		 SIZE 43, 7 OF oPanel PIXEL	// "N£mero Doc."
			@ 087+nEspLin,099+nEspLarg SAY OemToAnsi(STR0028) 		 SIZE 17, 7 OF oPanel PIXEL	// "Valor"
			@ 106+nEspLin,009+nEspLarg SAY OemToAnsi(STR0029) 		 SIZE 28, 7 OF oPanel PIXEL	// "Hist¢rico"
			@ 125+nEspLin,009+nEspLarg SAY OemToAnsi(STR0030) 		 SIZE 40, 7 OF oPanel PIXEL	// "Benefici rio"

			@ 096+nEspLin,09+nEspLarg MSGET cTipoTran					F3 "14"	Picture "!!!"	Valid (!Empty(cTipoTran) .And. ExistCpo("SX5","14"+cTipoTran)) .and. ;
				Iif(cTipoTran="CH",fa050Cheque(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran),.T.) .And. ;
				Iif(cTipoTran="CH" .or. cTipoTran="TB",fa100DocTran(cBcoOrig,cAgenOrig,cCtaOrig,cTipoTran,@cDocTran),.T.) SIZE  15, 08 OF oPanel PIXEL hasbutton
			@ 096+nEspLin,042+nEspLarg MSGET cDocTran		Picture PesqPict("SE5", "E5_NUMCHEQ")	Valid !Empty(cDocTran).and.fa100doc(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran) SIZE 47, 08 OF oPanel PIXEL
			@ 096+nEspLin,099+nEspLarg MSGET nValorTran		PicTure PesqPict("SE5","E5_VALOR",18)	Valid nValorTran > 0 .and. If(cPaisLoc=="DOM",FA100V01(nValorTran,cTipoTran),.T.)    SIZE  66, 08 OF oPanel PIXEL hasbutton

			@ 114+nEspLin,009+nEspLarg MSGET cHist100		Picture "@S22"      					Valid !Empty(cHist100)        SIZE 155, 08 OF oPanel PIXEL

			If lSpbInUse
				@ 133+nEspLin,009+nEspLarg MSGET cBenef100	Picture "@S21"      					Valid !Empty(cBenef100)       SIZE 95, 08 OF oPanel PIXEL
				@ 125+nEspLin,108+nEspLarg SAY OemToAnsi(STR0048) 	 SIZE 31, 7 OF oPanel PIXEL //"Modalidade SPB"
				@ 133+nEspLin,108+nEspLarg MSCOMBOBOX oModSPB VAR cModSpb ITEMS aModalSPB SIZE 56, 16 OF oPanel PIXEL ;
					VALID SpbTipo("SE5",cModSpb,cTipoTran,"TR")
			Else
				@ 133+nEspLin,009+nEspLarg MSGET cBenef100		Picture "@S21"      				Valid !Empty(cBenef100)       SIZE 155, 08 OF oPanel PIXEL
			Endif

			If lPanelFin  //Chamado pelo Painel Financeiro
				aButtonTxt := {}
				If IntePMS().AND. !lPmsInt
					aTrfPms := {CriaVar("E5_PROJPMS"),CriaVar("E5_TASKPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_EDTPMS"),CriaVar("E5_TASKPMS")}
					AADD(aButtonTxt,{STR0062, STR0062, {||F100PmsTrf(aTrfPms)}})  // "Projetos"
				Endif

				If cPaisLoc <> "BRA"
					AADD(aButtonTxt,{STR0035,STR0035, {||Fa100SetMo()}})  //  "&Tasas"
				Endif

				oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
				ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,{||If(FinOkDiaCTB(),nOpca:=1,nOpca:=0),oDLg:End()},{||nOpca:=0,oDlg:End()},,aButtonTxt);
					VALID (If(nOpca==1,;
					If(!CarregaSa6(cBcoOrig,cAgenOrig,cCtaOrig,.T.,,.T.),(oBcoOrig:SetFocus(),.F.),.T.) .and.;
						If(!CarregaSa6(cBcoDest,cAgendest,cCtadest,.T.,,.T.),(oBcoDest:SetFocus(),.F.),.T.) .and.;
							ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig).and.;
							IF(lSpbInUse,SpbTipo("SE5",cModSpb,cTipoTran,"TR"),.T.),.T.) )

							cAlias := FinWindow:cAliasFile
							dbSelectArea(cAlias)
							FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)

						Else
							DEFINE SBUTTON FROM 10, 180 TYPE 1 ENABLE ACTION (If(FinOkDiaCTB(),nOpca:=1,nOpca:=0),oDLg:End()) OF oPanel
							DEFINE SBUTTON FROM 23, 180 TYPE 2 ENABLE ACTION (nOpca:=0,oDlg:End()) OF oPanel

							If IntePMS().AND. !lPmsInt
								aTrfPms := {CriaVar("E5_PROJPMS"),CriaVar("E5_TASKPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_EDTPMS"),CriaVar("E5_TASKPMS")}
								@ 36,180 BUTTON STR0062 SIZE 29 ,14   ACTION {||F100PmsTrf(aTrfPms)	} OF oPanel PIXEL  // "Projetos"
							EndIf

							If cPaisLoc <> "BRA"
								@ 60, 180 BUTTON OemToAnsi(STR0035) SIZE 30,15 ACTION (Fa100SetMo()) OF oPanel PIXEL   //  "&Tasas"
							ElseIf FXMultSld()
								@ 60,180 BUTTON oButSel PROMPT STR0071 SIZE 26, 12 OF oPanel ACTION ( Fa340SetMo()  ) PIXEL  // "Taxas"
							EndIf

							ACTIVATE MSDIALOG oDlg CENTERED VALID  (iif(nOpca==1 , ;
								If(!CarregaSa6(cBcoOrig,cAgenOrig,cCtaOrig,.T.,,.T.),(oBcoOrig:SetFocus(),.F.),.T.) .and.;
									If(!CarregaSa6(cBcoDest,cAgendest,cCtadest,.T.,,.T.),(oBcoDest:SetFocus(),.F.),.T.) .and.;
										IIf(cPaisLoc=="BRA",ValidHist(cHist100),.t.) .and.;
										ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig).and.;
										IIF(lSpbInUse,SpbTipo("SE5",cModSpb,cTipoTran,"TR"),.T.),.T.) )
								Endif
							Else
								//Via Execauto
								aValidGet:= {}
								If (nPosBco := ascan(aAutoCab,{|x| Upper(x[1]) == 'CBCOORIG'})) > 0
									cBcoOrig	:=	PADR(aAutoCab[nPosBco,2],TamSx3("E5_BANCO")[1])
								Else
									cBcoOrig 	:= PADR(InitPad(GetSX3Cache("E5_BANCO", "X3_RELACAO")),TamSx3("E5_BANCO")[1])
									If cBcoOrig == Nil
										cBcoOrig 	:= ""
									EndIf
								EndIf

								If (nPosAgenci  := ascan(aAutoCab,{|x| Upper(x[1]) == 'CAGENORIG'})) > 0
									cAgenOrig	:=	PADR(aAutoCab[nPosAgenci,2],TamSx3("E5_AGENCIA")[1])
								Else
									cAgenOrig	:=	PADR(InitPad(GetSX3Cache("E5_AGENCIA", "X3_RELACAO")),TamSx3("E5_AGENCIA")[1])
									If cAgenOrig == Nil
										cAgenOrig := ""
									EndIf
								EndIf

								If (nPosConta := ascan(aAutoCab,{|x| Upper(x[1]) == 'CCTAORIG'})) > 0
									cCtaOrig	:=	PADR(aAutoCab[nPosConta,2],TamSx3("E5_CONTA")[1])
								Else
									cCtaOrig	:=PADR(InitPad(GetSX3Cache("E5_CONTA", "X3_RELACAO")),TamSx3("E5_CONTA")[1])
									If cCtaOrig == Nil
										cCtaOrig := ""
									EndIf
								EndIf

								Aadd(aValidGet,{'cBcoOrig' ,cBcoOrig,"CarregaSa6('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"',.F.,,,'"+cNaturOri+"')",.T.})
								Aadd(aValidGet,{'cAgenOrig',cAgenOrig,"CarregaSa6('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"',.F.,,,'"+cNaturOri+"')",.T.})
								Aadd(aValidGet,{'cCtaOrig',cCtaOrig,"CarregaSa6('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"',.F.,,,'"+cNaturOri+"')",.T.})

								If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CNATURORI'})) > 0
									cNaturOri	:=	aAutoCab[nPosAuto,2]
									Aadd(aValidGet,{'cNaturOri' ,aAutoCab[nPosAuto,2],"ExistCpo('SED','"+cNaturOri+"')",.T.})
								EndIf

								If (nPosBco := ascan(aAutoCab,{|x| Upper(x[1]) == 'CBCODEST'})) > 0
									cBcoDest	:=	PADR(aAutoCab[nPosBco,2],TamSx3("E5_BANCO")[1])
								Else
									cBcoDest 	:= PADR(InitPad(GetSX3Cache("E5_BANCO", "X3_RELACAO")),TamSx3("E5_BANCO")[1])
									If cBcoDest == Nil
										cBcoDest := ""
									EndIf
								EndIf

								If (nPosAgenci := ascan(aAutoCab,{|x| Upper(x[1]) == 'CAGENDEST'})) > 0
									cAgenDest	:=	PADR(aAutoCab[nPosAgenci,2],TamSx3("E5_AGENCIA")[1])
								Else
									cAgenDest	:=	PADR(InitPad(GetSX3Cache("E5_AGENCIA", "X3_RELACAO")),TamSx3("E5_AGENCIA")[1])
									If cAgenDest== Nil
										cAgenDest := ""
									EndIf
								EndIf

								If (nPosConta := ascan(aAutoCab,{|x| Upper(x[1]) == 'CCTADEST'})) > 0
									cCtaDest	:=	PADR(aAutoCab[nPosConta,2],TamSx3("E5_CONTA")[1])
								Else
									cCtaDest	:=	PADR(InitPad(GetSX3Cache("E5_CONTA", "X3_RELACAO")),TamSx3("E5_CONTA")[1])
									If cCtaDest== Nil
										cCtaDest := ""
									EndIf
								EndIf

								Aadd(aValidGet,{'cBcoDest',cBcoDest,"CarregaSa6('"+cBcoDest+"','"+cAgenDest+"','"+cCtaDest+"',.F.,,,'"+cNaturDes+"')",.T.})
								Aadd(aValidGet,{'cAgenDest',cAgenDest,"CarregaSa6('"+cBcoDest+"','"+cAgenDest+"','"+cCtaDest+"',.F.,,,'"+cNaturDes+"')",.T.})
								Aadd(aValidGet,{'cCtaDest',cCtaDest,"CarregaSa6('"+cBcoDest+"','"+cAgenDest+"','"+cCtaDest+;
									"',.F.,,,'"+cNaturDes+"') .and. ( '"+cBcoDest +"' != '"+ cBcoOrig +"' .or. '"+ cAgenDest +"' != '"+;
									cAgenOrig +"' .or. '"+ cCtaDest+"' != '"+cCtaOrig+"')",.T.})

								If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CNATURDES'})) > 0
									cNaturDes	:=	aAutoCab[nPosAuto,2]
									Aadd(aValidGet,{'cNaturDes' ,aAutoCab[nPosAuto,2],"ExistCpo('SED','"+cNaturDes+"')",.T.})
								EndIf

								If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'DDATACRED'})) > 0
									dDataCred	:=	aAutoCab[nPosAuto,2]
									Aadd(aValidGet,{'dDataCred' ,aAutoCab[nPosAuto,2],"F100VlDtCr(stod('" + dtos(dDataCred) + "'))",.T.})
								EndIf

								If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CDOCTRAN'})) > 0
									cDocTran	:=	PADR(aAutoCab[nPosAuto,2],TamSx3("E5_NUMCHEQ")[1])
									Aadd(aValidGet,{'cDocTran' ,aAutoCab[nPosAuto,2],"'"+cDocTran+"'<> '"+Space(TamSx3('E5_NUMCHEQ')[1])+"' .and. fa100DocTran('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"','"+cDocTran+"') .And. fa100doc('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"','"+cDocTran+"')",.T.})
								EndIf

								If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CTIPOTRAN'})) > 0
									cTipoTran	:=	aAutoCab[nPosAuto,2]
									Aadd(aValidGet,{'cTipoTran' ,aAutoCab[nPosAuto,2],;
										"('"+cTipoTran+"'<> '"+Space(TamSx3('E5_TIPODOC')[1])+"' .And. "+;
										"ExistCpo('SX5','14'+'"+cTipoTran+"')).and. "+;
										"Iif('"+cTipoTran+"'='CH',fa050Cheque('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"','"+cDocTran+"'),.T.).And."+;
										"Iif('"+cTipoTran+"' $ 'CH#TB',fa100DocTran('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"','"+cDocTran+"'),.T.)",.T.})
								EndIf

								If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'NVALORTRAN'})) > 0
									nValorTran	:=	aAutoCab[nPosAuto,2]
									Aadd(aValidGet,{'nValorTran' ,aAutoCab[nPosAuto,2],'nValorTran > 0',.T.})
								EndIf

								If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CHIST100'})) > 0
									cHist100	:=	aAutoCab[nPosAuto,2]
									Aadd(aValidGet,{'cHist100' ,aAutoCab[nPosAuto,2],"'"+cHist100+"'<> '"+Space(TamSx3('E5_HISTOR')[1])+"'",.T.})
								EndIf

								If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CBENEF100'})) > 0
									cBenef100	:=	aAutoCab[nPosAuto,2]
									Aadd(aValidGet,{'cBenef100' ,aAutoCab[nPosAuto,2],"'"+cBenef100+"'<> '"+Space(TamSx3('E5_BENEF')[1])+"'",.T.})
								EndIf

								//Valida os campos
								If !SE5->(MsVldGAuto(aValidGet)) .or. ;
										!(CarregaSa6(cBcoOrig,cAgenOrig,cCtaOrig,.T.,,.T.) .and. ;
										ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig).and.;
										IIF(lSpbInUse,SpbTipo("SE5",cModSpb,cTipoTran,"TR"),.T.))
									nOpcA := 0
								Else
									nOpcA := 1
								EndIf
							EndIf

							IF nOpcA == 1

								Begin Transaction
									lGrava := .T.
									If lFA100TRF
										lGrava := ExecBlock("FA100TRF", .F., .F., { cBcoOrig, cAgenOrig, cCtaOrig,;
											cBcoDest, cAgenDest, cCtaDest,;
											cTipoTran, cDocTran, nValorTran,;
											cHist100, cBenef100, cNaturOri,;
											cNaturDes , cModSpb, lEstorno, ;
											dDtdisp})
									Endif

									If lF100DOC
										cDocTran := ExecBlock("F100DOC",.F.,.F.,{	cBcoOrig	, cAgenOrig	, cCtaOrig		,;
											cBcoDest	, cAgenDest	, cCtaDest		,;
											cTipoTran	, cDocTran	, nValorTran	,;
											cHist100	, cBenef100	, cNaturOri		,;
											cNaturDes 	, cModSpb	, lEstorno      ,;
											dDataCred})
									EndIf

									IF lGrava
										//Preenche o array aSimbMoeda
										nTotMoeda := MoedFin()
										For nX := 1 To nTotMoeda
											If( !(Empty(SuperGetMV("MV_MOEDA"+Alltrim(Str(nX))))))
												AAdd( aSimbMoeda,SuperGetMV("MV_SIMB"+Alltrim(Str(nX))))
											EndIf
										Next nX

										//Verifica e transacao em dinheiro e deixa fazer a transferencia entre bancos
										nPosMoeda := Ascan(aSimbMoeda,{|x| Trim(x) == Trim(cTipoTran)})
										//-----------------------------------------------------------------
										//³Permite realizar a transferencia sendo Cartao
										//-----------------------------------------------------------------
										If IsCaixaLoja(cBcoOrig) .AND. !(IsCaixaLoja(cBcoDest)) .AND. nPosMoeda == 0 .AND. !(Alltrim(cTipoTran) $ "CC|CD")
											MsgInfo(STR0065)
										Else
											fa100grava( 	cBcoOrig	,	cAgenOrig	,	cCtaOrig	,	cNaturOri	,	;
												cBcoDest	,	cAgenDest	,	cCtaDest	,	cNaturDes	,	;
												cTipoTran	,	cDocTran	,	nValorTran	,	cHist100	,	;
												cBenef100	,	lEstorno	,	cModSpb		,	aTrfPms		,   ;
						/*nTxMoeda*/, /*nRegOrigem*/, /*nRegDestino*/,	dDataCred )

										EndIf
									ENDIF
								End Transaction

								If lA100BL01
									aValores := {	cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,cBcoDest,cAgenDest,;
										cCtaDest,cNaturDes,cTipoTran,nValorTran,cDocTran,cBenef100,cHist100,cModSpb,dDataCred}

									ExecBlock("A100BL01",.F.,.F.,aValores)
								EndIf
							Endif

							//Via Execauto fecha no 1o. looping
							If lF100Auto
								lExit := .T.
							EndIf

							If nOpcA != 1 .or. lExit
								If nOpca != 1
									lExit := .F.
								Endif
								Exit
							Endif
						Enddo

						If cPaisLoc <> "BRA" .And. lbFilBrw
							Eval( bFiltraBrw )
						Endif

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Finaliza lancamento no PCO                                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						PcoFinLan("000007")

						Return lExit

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa100SetMoºAutor  ³Bruno Sobieski      º Data ³  22/08/00   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Permite corrigir as taxas das moedas para a taxa da hora.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Fa100SetMo()
	Local oDlg, nLenMoedas	:= Len(aTxMoedas)
	Local lConfirmo	:=	.F.
	Local aTxTmp   := aClone(aTxMoedas)

	If nLenMoedas > 1
		Define MSDIALOG oDlg From 200,0 TO 362,230 TITLE OemToAnsi(STR0036) PIXEL   //   "Tasas"
		@ 005,005  To 062,110 OF oDlg PIXEL
		@ 012,010 SAY  aTxMoedas[2][1]  Of oDlg PIXEL
		@ 010,060 MSGET aTxMoedas[2][2] PICTURE aTxMoedas[1][3] Of oDlg PIXEL
		If nLenMoedas > 2
			@ 024,010 SAY  aTxMoedas[3][1]  Of oDlg PIXEL
			@ 022,060 MSGET aTxMoedas[3][2] PICTURE aTxMoedas[2][3] Of oDlg PIXEL
			If nLenMoedas > 3
				@ 036,010 SAY  aTxMoedas[4][1]  Of oDlg PIXEL
				@ 034,060 MSGET aTxMoedas[4][2] PICTURE aTxMoedas[3][3] Of oDlg PIXEL
				If nLenMoedas > 4
					@ 048,010 SAY  aTxMoedas[5][1]  Of oDlg PIXEL
					@ 046,060 MSGET aTxMoedas[5][2] PICTURE aTxMoedas[4][3] Of oDlg PIXEL
				Endif
			Endif
		Endif
		DEFINE  SButton FROM 064,80 TYPE 1 Action (lConfirmo := .T. , oDlg:End() ) ENABLE OF oDlg  PIXEL
		Activate MSDialog oDlg CENTERED
		If !lConfirmo
			aTxMoedas   := aClone(aTxTmp)
		Endif

	Else
		Help("",1,"NoMoneda")
	Endif

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ValidTran³ Autor ³ J£lio Wittwer         ³ Data ³08.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida‡„o do banco / agencia / conta de destino na transf. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ValidTran(cTipo, @Banco, @agencia, @conta , @benef)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINA100																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function ValidTran(cTip,cBco,cAge,cCta,cBen,cDoc,nValTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig)

	Local lRet 		:= .T.
	Local nMoedaDes := 0
	Local nMoedaOri := 0
	Local lCxLoja	:= GetNewPar( "MV_CXLJFIN", .F. )
	Local nMoedOri	:= 0
	Local nMoedDst	:= 0

	If Empty(cTip) .or. nValTran <= 0
		lRet := .F.
	Endif

	//Verifica se Conta Origem = Conta Destino
	If cBcoOrig+cAgenOrig+cCtaOrig == cBco+cAge+cCta
		Help(" ",1,"BCO_TRF")
		lRet := .F.
	Endif

	If Empty(cNaturOri) .or. Empty(cNaturDes)
		Help(" ",1,"NATUREZA")
		lRet := .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apenas deve obrigar a digita‡„o do destino da opera‡„o ³
	//³ quando for movimenta‡„o em dinheiro                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If alltrim(cTip) $ "R$/DOC/TB"
			lRet := CarregaSa6(@cBco,@cAge,@cCta,.T.,@cBen,.T.,,.T.)
		Else
			IF !Empty(cBco + cAge + cCta)
				lRet := CarregaSa6(@cBco,@cAge,@cCta,.T.,@cBen,.T.,,.T.)
			Else
				lRet := .F.
			Endif
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Obrigar a digita‡Æo do nro do documento de transferenc.³
	//³ quando for movimenta‡„o via Doc, Cheque ou Cheque TB   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .and. Empty(cDoc)
		Help(" ",1,"NRODOC",,STR0037,1,0)	//"Numero de documento invalido"
		lRet := .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
	//³ movimentacao no financeiro    										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .and. !DtMovFin(,,"3")
		lRet := .f.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se as taxas das moedas usadas estao cadastradas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		nMoedaOri := MoedaBco(cBcoOrig,cAgenOrig,cCtaOrig)
		nMoedaDes := MoedaBco(cBco,cAge,cCta)
		If cPaisLoc <> "BRA" .or. nMoedaOri <> nMoedaDes
			If (Len(aTxMoedas) < nMoedaOri .Or. (nMoedaOri > 1 .And. aTxMoedas[nMoedaOri,2] == 0)) .Or.;
					(Len(aTxMoedas) < nMoedaDes .Or. (nMoedaDes > 1 .And. aTxMoedas[nMoedaDes,2] == 0))
				lRet := .F.
				Help(" ",1,'NoMoneda')
			Endif
		Endif
	Endif

	//Se for caixa do Loja e nao for Sangria
	//Se for caixa Financeiro
	//Não Serao admitidas transferencias em CHEQUE (CH/TB) ou DOC
	If lRet .AND. nModulo <> 12 .AND. (Alltrim(cTip) $ "CH/DOC/TB" .AND.  ( (IsCaixaLoja(cBcoOrig) .AND. !lCxLoja) .OR. IsCxFin(cBcoOrig,cAgenOrig,cCtaOrig) ) )
		Help(" ",1,"INVTRF",,STR0069,1,0)
		lRet := .F.
	Endif

	// A transferencia entre cntas correntes eh permitida apenas para:
	// 1. C/C origem em outra moeda para C/C destino em Real
	// 2. C/C origem e C/C destino com mesma moeda (Ex: US$ para US$)
	If lRet .AND. FXMultSld() .AND.  .F.
		DbSelectArea( "SA6" )
		SA6->( DbSetOrder( 1 ) )
		If SA6->( DbSeek( xFilial( "SA6" ) + cBcoOrig + cAgenOrig + cCtaOrig ) )
			nMoedOri := SA6->A6_MOEDA
		EndIf

		If SA6->( DbSeek( xFilial( "SA6" ) + cBco + cAge + cCta ) )
			nMoedDst := SA6->A6_MOEDA
		EndIf

		lRet := .F.
		If ( nMoedOri <> 1 .AND. nMoedDst == 1 ) .OR. ( nMoedOri == nMoedDst )
			lRet := .T.
		EndIf

		If !lRet
			Help(" ", 1, "BCOTRF",, STR0072, 1, 0 ) // "A transferência é permitida apenas para: 1- C/C origem em outra moeda para C/C destino em Real. 2- C/C origem e C/C destino com mesma moeda (Ex: US$ para US$)"
		EndIf
	EndIf

Return lRet

/*/{Protheus.doc} fa100grava
Realiza a gravação da transferência.
Essa função deve ser chamada dentro de uma transação.

@author  Wagner Xavier
@since   08/09/1993
/*/
STATIC Function fa100grava( cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,;
		cBcoDest,cAgenDest,cCtaDest,cNaturDes,;
		cTipoTran,cDocTran,nValorTran,cHist100,cBenef100,;
		lEstorno,cModSpb,aTrfPms,nTxMoeda,nRegOrigem,nRegDestino, dDataCred)

	Local lPadrao1:=.F.
	Local lPadrao2	:= .F.
	Local cPadrao	:= "560"
	Local lMostra,lAglutina
	Local lA100TR01	:= ExistBlock("A100TR01")
	Local lA100TR02	:= ExistBlock("A100TR02")
	Local lA100TR03	:= ExistBlock("A100TR03")
	Local lA100TRA	:= ExistBlock("A100TRA")
	Local lA100TRB	:= ExistBlock("A100TRB")
	Local lA100TRC	:= ExistBlock("A100TRC")
	Local nRegSEF 	:= 0
	Local nMoedOrig := 1
	Local nMoedTran	:=	1
	Local lSpbInUse	:= SpbInUse()
	Local cProcesso := ""
	Local aFlagCTB 	:= {}
	Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Local lFindITF 	:= If(cPaisLoc=="DOM" .and. Rtrim(cTipoTran)=="$",.F.,If(cPaisLoc=="DOM",If(lRetCkPG(3,,cBcoOrig),.T.,.F.),.T.) )
	Local nMBcoOri	:= 0										// Moeda da conta corrente origem
	Local nMBcoDst	:= 0										// Moeda da conta corrente destino
	Local lAtuSldNat:= .T.
	Local oModelMov := NIL	//FWLoadModel("FINM030")
	Local oSubFK5
	Local oSubFK9
	Local oSubFKA
	Local cLog       := ""
	Local cCamposE5  := ""
	Local cIdMovim   := ""
	Local lRet       := .T.
	Local aAreaFKs   := {}
	Local cProcFKs   := ""
	Local cMoedaBnc  := ""
	Local nValorConv := 0
	Local dDtdisp    := dDatabase
	Local aGetSED    := {}
	Local aRetInteg  := {}

	DEFAULT aTrfPms     := {}
	DEFAULT nTxMoeda    := 0
	DEFAULT nRegOrigem  := 0
	DEFAULT nRegDestino := 0
	DEFAULT dDataCred   := dDataBase
	DEFAULT lExterno    := .F.
	DEFAULT cEAIA100v 	:= "0.000"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atencao!, neste programa sera' utilizado 2 lan‡amentos padroni³
	//³ zados, pois o mesmo gera 2 registros na movimentacao bancaria³
	//³ O 1. registro para a saida  (Banco Origem ) ->Padrao "560"   ³
	//³ O 2. registro para a entrada(Banco Destino) ->Padrao "561"   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectarea("SE5")
	cProcesso	:= IIf(cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN",IIf(!lEstorno,GetSx8Num("SE5","E5_PROCTRA","E5_PROCTRA"+cEmpAnt),SE5->E5_PROCTRA),"")
	ConfirmSx8()
	dbSelectarea("SEF")

	//ITF não se aplica ao Brasil
	If cPaisLoc == "BRA"
		lFindITF := .F.
	Endif

	STRLCTPAD := " "

	If !Empty(cBcoOrig + cAgenOrig + cCtaOrig) .and. !Empty(cBcoDest + cAgenDest + cCtaDest)

		dbSelectArea( "SA6" )
		dbSetOrder( 1 )  // A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON.
		msSeek( xFilial("SA6") + cBcoDest + cAgenDest + cCtaDest )
		If lEstorno
			nMBcoDst := SA6->A6_MOEDA
		Endif
		If cPaisLoc	# "BRA"
			nMoedTran := MAX(SA6->A6_MOEDA, 1)
		Endif

		dbSelectArea( "SA6" )
		dbSetOrder( 1 )  // A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON.
		msSeek( xFilial("SA6") + cBcoOrig + cAgenOrig + cCtaOrig )
		nMBcoOri := SA6->A6_MOEDA

		cIdMovim := CriaVar("E5_IDMOVI", .T.)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza movimentacao bancaria c/referencia a saida			  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet
			//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
			cCamposE5 := "{"
			cCamposE5 += "{'E5_DTDIGIT', dDataBase}"
			cCamposE5 += ",{'E5_BENEF', '" + cBenef100 + "'}"
			cCamposE5 += ",{'E5_IDMOVI', '" + cIdMovim + "'}"
			cCamposE5 += ",{'E5_MOVFKS', 'S'}"
			cCamposE5 += "}"

			oModelMov := FWLoadModel("FINM030")
			oModelMov:SetOperation( MODEL_OPERATION_INSERT ) //Inclusao
			oModelMov:Activate()
			oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Informa se vai gravar SE5 ou não
			oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
			oModelMov:SetValue( "MASTER", "NOVOPROC", .T. ) //Informa que a inclusão será feita com um novo número de processo

			//Se for estorno, pega o processo do movimento de origem
			If lEstorno
				aAreaFKs := GetArea()
				dbSelectArea("SE5")
				SE5->(dbGoTo(nRegOrigem))
				//Pega o número do processo e define no campo virtual do Model
				cProcFKs := FINProcFKs( SE5->E5_IDORIG, "FK5" )
				If !Empty(cProcFKs)
					oModelMov:SetValue( "MASTER", "IDPROC", cProcFKs )
					oModelMov:SetValue( "MASTER", "NOVOPROC", .F. ) //Informa que a inclusão será feita vínculada à um processo já existente
				Endif
				RestArea(aAreaFKs)
			Endif

			//Dados do Processo
			oSubFKA := oModelMov:GetModel("FKADETAIL")
			oSubFKA:SetValue( "FKA_IDORIG", FWUUIDV4() )
			oSubFKA:SetValue( "FKA_TABORI", "FK5" )

			//Informacoes do movimento
			oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
			oSubFK5:SetValue( "FK5_DATA", dDataBase )
			oSubFK5:SetValue( "FK5_BANCO", cBcoOrig )
			oSubFK5:SetValue( "FK5_AGENCI", cAgenOrig )
			oSubFK5:SetValue( "FK5_CONTA", cCtaOrig )
			oSubFK5:SetValue( "FK5_RECPAG", "P" )
			oSubFK5:SetValue( "FK5_NUMCH", cDocTran )
			oSubFK5:SetValue( "FK5_HISTOR", cHist100 )
			oSubFK5:SetValue( "FK5_TPDOC", "TR" )
			oSubFK5:SetValue( "FK5_MOEDA", cTipoTran )
			oSubFK5:SetValue( "FK5_ORIGEM", FunName() )
			If cPaisLoc == "BRA"
				If lEstorno .and. nMBcoDst > nMBcoOri
					oSubFK5:SetValue( "FK5_VALOR", Round(xMoeda(nValorTran,nMBcoDst,1,dDataBase, MsDecimais(Max(SA6->A6_MOEDA,1))+1 ,nTxMoeda ), MsDecimais(Max(SA6->A6_MOEDA,1))) )
					oSubFK5:SetValue( "FK5_VLMOE2", nValorTran )
				Else
					oSubFK5:SetValue( "FK5_VALOR", nValorTran )
				Endif
			Else
				nMoedOrig		:= MAX(SA6->A6_MOEDA,1)

				// CASO A TAXA CONTRATADA TENHA SIDO INFORMADA, ESTA DEVE SER ASSUMIDA.
				If Len(aTxMoedas) > 1 .And. ntxestp > 0 .And. nMoedTran > 0
					aTxMoedas[nMoedTran][2] := ntxestp
				Endif

				If Len(aTxMoedas) > 1 .And. nTxEstR > 0 .And. nMoedOrig > 0
					aTxMoedas[nMoedOrig][2] := nTxEstR
				Endif

				oSubFK5:SetValue( "FK5_VALOR", IIf(lEstorno,Round(xMoeda(nValorTran,nMoedTran,nMoedOrig,dDataBase,MsDecimais(nMoedOrig)+1,nTxEstP,nTxEstR),MsDecimais(nMoedOrig)),nValorTran) )
				//Gravo o valor na moeda 1 para nao ter problemas na hora da conversao por casas
				//decimais perdidas na contabilidade... Bruno.
				oSubFK5:SetValue( "FK5_VLMOE2", IIf(lEstorno,xMoeda(nValorTran,nMoedTran,Iif(nMoedOrig>1 .And. (nMoedTran==1 .Or. nMoedOrig == nMoedTran),1,nMoedOrig),,,aTxMoedas[nMoedTran][2]),xMoeda(nValorTran,nMoedOrig,1,,,aTxMoedas[nMoedOrig][2])) )
				oSubFK5:SetValue( "FK5_TXMOED", aTxMoedas[nMoedOrig][2] )
			Endif
			oSubFK5:SetValue( "FK5_DTDISP", dDtdisp )
			oSubFK5:SetValue( "FK5_NATURE", cNaturOri )
			oSubFK5:SetValue( "FK5_FILORI", cFilAnt )
			If lSpbInUse
				oSubFK5:SetValue( "FK5_MODSPB", cModSpb )
			Endif
			oSubFK5:SetValue( "FK5_PROTRA", cProcesso )

			If oModelMov:VldData()
				oModelMov:CommitData()
			Else
				lRet := .F.
				cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[6])
				Help(,,"MF100GRV1",,cLog, 1, 0)
			Endif

			oModelMov:DeActivate()
			oModelMov:Destroy()
			oModelMov := NIL
		Endif

		If lRet
			If lAtuSldNat .And. cNaturOri <> cNaturDes
				SA6->( DbSetOrder(1) )
				SA6->( dbSeek( xFilial() + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA ) )

				cMoedaBnc  := StrZero( Max(SA6->A6_MOEDA, 1 ), 2)
				nValorConv := Iif (Empty(SE5->E5_TXMOEDA), SE5->E5_VALOR, SE5->E5_VALOR * SE5->E5_TXMOEDA)

				AtuSldNat(SE5->E5_NATUREZ, SE5->E5_DATA, cMoedaBnc, "3", "P", SE5->E5_VALOR, nValorConv, If(lEstorno,"-","+"),,FunName(),"SE5", SE5->(Recno()),0)
			Endif
			// Se Portugal, registra dados do Diario (movimento origem)
			If UsaSeqCor()
				AADD(aDiario,{"SE5",SE5->(RECNO()),cCodDiario,"E5_NODIA","E5_DIACTB"})
			Else
				aDiario := {}
			Endif

			If !Empty(aTrfPms) .And. !Empty(aTrfPms[1])
				nRecNo	:= SE5->(RecNo())
				cID		:= STRZERO(SE5->(RecNo()),10)
				cStart	:= "AA"
				dbSelectArea("SE5")
				dbSetOrder(9)
				While dbSeek(xFilial()+cID)
					cID := STRZERO(nRecNo,8)+cStart
					cStart := SomaIt(cStart)
				End
				SE5->(dbGoto(nRecNo))

				cCamposE5 := "{{'E5_PROJPMS', '" + cId +"'}}"
				oModelMov := FWLoadModel("FINM030")
				oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
				oModelMov:Activate()
				oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //habilita gravação de SE5
				oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5)

				//Posiciona a FKA com base no IDORIG da SE5 posicionada
				oSubFKA := oModelMov:GetModel( "FKADETAIL" )
				If oSubFKA:SeekLine( { {"FKA_FILIAL", SE5->E5_FILIAL },{"FKA_IDORIG", SE5->E5_IDORIG } } )

					//Dados de integrações
					oSubFK9 := oModelMov:GetModel( "FK9DETAIL" )
					If !oSubFK9:IsEmpty()
						oSubFK9:SetValue( "FK9_PRJPMS", cId )
					EndIf

					If oModelMov:VldData()
						oModelMov:CommitData()
					Else
						lRet := .F.
						cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
						cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
						cLog += cValToChar(oModelMov:GetErrorMessage()[6])
						Help(,,"MF100GRV2",,cLog, 1, 0 )
					Endif
				Endif
				oModelMov:DeActivate()
				oModelMov:Destroy()
				oModelMov := NIL

				If lRet
					RecLock("AJE",.T.)
					AJE->AJE_FILIAL	:= xFilial("AJE")
					AJE->AJE_VALOR 	:= SE5->E5_VALOR
					AJE->AJE_DATA	:= SE5->E5_DATA
					AJE->AJE_HISTOR	:= SE5->E5_HISTOR
					AJE->AJE_PROJET	:= aTrfPms[1]
					AJE->AJE_REVISA	:= PmsAF8Ver(aTrfPms[1])
					AJE->AJE_TAREFA	:= aTrfPms[2]
					AJE->AJE_ID		:= cID
					MsUnlock()
				EndIf
			EndIf
		Endif

		If lRet
			If (Alltrim(cTipoTran) == "TB" .or. ;
					(Alltrim(cTipoTran) == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. !lEstorno
				nRegSEF := Fa100Cheq("FINA100TRF")
			Endif

			If nModulo == 72
				KEXF030(lEstorno)
			EndIf

			If lA100TR01
				ExecBlock("A100TR01",.F.,.F.,lEstorno)
			EndIf

			If lA100TRA
				ExecBlock("A100TRA",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
					cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ So atualiza do saldo se for R$,DO,TB,TC ou se for CH e o ban-³
			//³ co origem n„o for um caixa do loja, pois este foi gerado no  ³
			//³ SE1 e somente sera atualizado na baixa do titulo.            ³
			//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
			//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
			//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ((Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC"+IIf(cPaisLoc=="BRA","","/$ ")) .or.;
					(SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. ;
					!(SUBSTR(SE5->E5_NUMCHEQ,1,1) == "*")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza saldo bancario.									 ³
				//³ Paso o E5_VALOR pois fora do Brasil a conta pode ser em moeda³
				//³ diferente da moea Oficial.                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				AtuSalBco(cBcoOrig,cAgenOrig,cCtaOrig,dDataBase,SE5->E5_VALOR,"-")
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Lacncamento orcamentario - Transferencia origem ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoDetLan("000007","01","FINA100")

			If !lExterno
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Lan‡amento Contabil - 1. registro do SE5                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lPadrao1 := VerPadrao( cPadrao )
				STRLCTPAD := cBcoDest+"/"+cAgenDest+"/"+cCtaDest

				If lPadrao1 .and. mv_par04 == 1  // On Line
					aGetSED := SED->(GETAREA())
					SED->(DbSetOrder(1))
					SED->(DbSeek(xFilial("SED") + SE5->E5_NATUREZ))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Inicializa Lancamento Contabil                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nHdlPrv := HeadProva( cLote, "FINA100" /*cPrograma*/, Substr( cUsuario, 7, 6 ), @cArquivo )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Prepara Lancamento Contabil                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
					Endif
					nTotal += DetProva( nHdlPrv, cPadrao, "FINA100" /*cPrograma*/, cLote, /*nLinha*/, /*lExecuta*/,;
					/*cCriterio*/, /*lRateio*/, /*cChaveBusca*/, /*aCT5*/, /*lPosiciona*/, @aFlagCTB,;
					/*aTabRecOri*/, /*aDadosProva*/ )
						If !lUsaFlag

						oModelMov := FWLoadModel("FINM030") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
						oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
						oModelMov:Activate()
						oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação de SE5

						//Posiciona a FKA com base no IDORIG da SE5 posicionada
						oSubFKA := oModelMov:GetModel( "FKADETAIL" )
						If oSubFKA:SeekLine( { {"FKA_FILIAL", SE5->E5_FILIAL },{"FKA_IDORIG", SE5->E5_IDORIG } } )

							//Dados Contábeis
							oSubFK5 := oModelMov:GetModel("FK5DETAIL")
							oSubFK5:SetValue( "FK5_LA", "S" )

							If oModelMov:VldData()
								oModelMov:CommitData()
							Else
								lRet := .F.
								cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
								cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
								cLog += cValToChar(oModelMov:GetErrorMessage()[6])
								Help(,,"MF100GRV3",,cLog, 1, 0 )
							Endif
						Endif
						oModelMov:DeActivate()
						oModelMov:Destroy()
						oModelMov := NIL
					Endif
					if lEstorno // caso que sea retorno no debe hacer ITF Nahim 06/09/2019
						//	If lFindITF .And. FinProcITF( nRegOrigem,1 )  .AND. lRetCkPG(3,,cBcoOrig) //.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF C/ CONTABILIZACAO Nahim Terrazas
						//	FinProcITF( nRegOrigem,5,, .F.,{ nHdlPrv, "", "", "FINA100", cLote } , @aFlagCTB )
						//	EndIf
						////////////PAULO ITF
						If lFindITF .And. FinProcITF( nRegDestino,1 )  .AND. lRetCkPG(3,,cBcoDest) //.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF C/ CONTABILIZACAO Nahim Terrazas
							FinProcITF( nRegDestino,6,, .F.,{ nHdlPrv, "", "", "FINA100", cLote } , @aFlagCTB )
						EndIf
					else
						If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .AND. lRetCkPG(3,,cBcoOrig) //.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF C/ CONTABILIZACAO Nahim Terrazas
							FinProcITF( SE5->( Recno() ),3,, .F.,{ nHdlPrv, "", "", "FINA100", cLote } , @aFlagCTB )
						EndIf
					endif
					RestArea(aGetSED)
				Else
					If lEstorno
						/*aAreaSa6:=SA6->(GetArea())
						SA6->(DbSetOrder(1))
						SA6->(dbSeek(xFilial()+ cBcoOrig+cAgenOrig+cCtaOrig ))
						If lFindITF .And. FinProcITF( Iif(nRegOrigem>0,nRegOrigem,SE5->( Recno() )),1 )  .AND. lRetCkPG(3,,cBcoOrig) //.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF S/ CONTABILIZACAO Nahim Terrazas
						FinProcITF( Iif(nRegOrigem>0,nRegOrigem,SE5->( Recno() )),6,, .F. )
						EndIf*/
						aAreaSa6:=SA6->(GetArea())
						SA6->(DbSetOrder(1))
						SA6->(dbSeek(xFilial()+cBcoDest+cAgenDest+cCtaDest))
						If lFindITF .And. FinProcITF( Iif(nRegDestino>0,nRegDestino,SE5->( Recno() )),1 )  .AND. lRetCkPG(3,,cBcoDest) //.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF S/ CONTABILIZACAO Nahim Terrazas
							nHdlPrv := HeadProva( cLote, "FINA100" /*cPrograma*/, Substr( cUsuario, 7, 6 ), @cArquivo )
							FinProcITF( Iif(nRegDestino>0,nRegDestino,SE5->( Recno() )),5,, .F. ,{ nHdlPrv, cPadrao, "", "FINA100", cLote }, @aFlagCTB)
							//	FinProcITF( SE5->( Recno() ), 6, , .F.,{ nHdlPrv, cPadrao, "", "FINA100", cLote }, @aFlagCTB)
						EndIf
						SA6->(RestArea(aAreaSa6))
					Else
						aAreaSa6:=SA6->(GetArea())
						SA6->(DbSetOrder(1))
						SA6->(dbSeek(xFilial()+ cBcoOrig+cAgenOrig+cCtaOrig ))
						If lFindITF .And. FinProcITF( Iif(nRegOrigem>0,nRegOrigem,SE5->( Recno() )),1 )  .AND. lRetCkPG(3,,cBcoOrig) //.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF S/ CONTABILIZACAO Nahim Terrazas
							nHdlPrv := HeadProva( cLote, "FINA100" /*cPrograma*/, Substr( cUsuario, 7, 6 ), @cArquivo )
							FinProcITF( Iif(nRegOrigem>0,nRegOrigem,SE5->( Recno() )),3,, .F. ,{ nHdlPrv, cPadrao, "", "FINA100", cLote }, @aFlagCTB)
						EndIf
						/*SA6->(dbSeek(xFilial()+cBcoDest+cAgenDest+cCtaDest))
						If lFindITF .And. FinProcITF( Iif(nRegDestino>0,nRegDestino,SE5->( Recno() )),1 )  .AND. lRetCkPG(3,,cBcoDest) //.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF S/ CONTABILIZACAO Nahim Terrazas
						FinProcITF( Iif(nRegDestino>0,nRegDestino,SE5->( Recno() )),6,, .F. )
						EndIf*/
						SA6->(RestArea(aAreaSa6))
					EndIf
				EndIf
			Endif
		Endif

		cNumeE5_PROCTRA := SE5->E5_PROCTRA// Nahim Terrazas 05/02/2019 - tomo porque para hacer la reversión no lo encuentra debido a que el ITF lo toma prorrateado
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza movimentacao bancaria c/referencia a entrada		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet
			dbSelectArea( "SA6" )
			dbSeek( xFilial("SA6") + cBcoDest + cAgenDest + cCtaDest )
			nMBcoDst := SA6->A6_MOEDA

			//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
			cCamposE5 := "{"
			cCamposE5 += "{'E5_DTDIGIT', dDataBase}"
			cCamposE5 += ",{'E5_BENEF', '" + cBenef100 + "'}"
			cCamposE5 += ",{'E5_IDMOVI', '" + cIdMovim + "'}"
			cCamposE5 += ",{'E5_MOVFKS', 'S'}"
			cCamposE5 += "}"

			oModelMov := FWLoadModel("FINM030")
			oModelMov:SetOperation( MODEL_OPERATION_INSERT ) //Inclusao
			oModelMov:Activate()
			oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Informa se vai gravar SE5 ou não
			oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
			oModelMov:SetValue( "MASTER", "NOVOPROC", .F. ) //Informa que a inclusão será feita com um número de processo já existente

			//Se for estorno, pega o processo do movimento de destino
			If lEstorno
				aAreaFKs := GetArea()
				dbSelectArea("SE5")
				SE5->(dbGoTo(nRegDestino))
				//Pega o número do processo e define no campo virtual do Model
				cProcFKs := FINProcFKs( SE5->E5_IDORIG, "FK5" )
				If !Empty(cProcFKs)
					oModelMov:SetValue( "MASTER", "IDPROC", cProcFKs )
					oModelMov:SetValue( "MASTER", "NOVOPROC", .F. ) //Informa que a inclusão será feita vínculada à um processo já existente
				Endif
				RestArea(aAreaFKs)
			Endif

			//Dados do Processo
			oSubFKA := oModelMov:GetModel("FKADETAIL")
			oSubFKA:SetValue( "FKA_IDORIG", FWUUIDV4() )
			oSubFKA:SetValue( "FKA_TABORI", "FK5" )

			//Informacoes do movimento
			oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )
			oSubFK5:SetValue( "FK5_DATA", dDataBase )
			oSubFK5:SetValue( "FK5_BANCO", cBcoDest )
			oSubFK5:SetValue( "FK5_AGENCI", cAgenDest )
			oSubFK5:SetValue( "FK5_CONTA", cCtaDest )
			oSubFK5:SetValue( "FK5_RECPAG", "R" )
			oSubFK5:SetValue( "FK5_DOC", cDocTran )
			oSubFK5:SetValue( "FK5_HISTOR", cHist100 )
			oSubFK5:SetValue( "FK5_TPDOC", "TR" )
			oSubFK5:SetValue( "FK5_MOEDA", cTipoTran )
			oSubFK5:SetValue( "FK5_ORIGEM", FunName() )

			If cPaisLoc == "BRA"
				If nMBcoOri > nMBcoDst
					oSubFK5:SetValue( "FK5_VALOR", Round(xMoeda(nValorTran,nMBcoOri,1,dDataBase, MsDecimais(Max(SA6->A6_MOEDA,1))+1 ,aTxMoedas[nMBcoOri][2], aTxMoedas[1][2] ), MsDecimais(Max(SA6->A6_MOEDA,1))) )
					oSubFK5:SetValue( "FK5_VLMOE2", nValorTran )
					oSubFK5:SetValue( "FK5_TXMOED", aTxMoedas[nMBcoOri][2] )
				Else
					oSubFK5:SetValue( "FK5_VALOR", nValorTran )
				Endif
			Else
				oSubFK5:SetValue( "FK5_VALOR", IIf(lEstorno,nValorTran,Round(xMoeda(nValorTran,nMoedOrig,Max(SA6->A6_MOEDA,1),dDataBase,MsDecimais(Max(SA6->A6_MOEDA,1))+1,aTxMoedas[nMoedOrig][2],aTxMoedas[Max(SA6->A6_MOEDA,1)][2]),MsDecimais(Max(SA6->A6_MOEDA,1)))) )

				//Gravo o valor na moeda 1 para nao ter problemas na hora da conversao por casas
				//decimais perdidas na contabilidade... Bruno.
				oSubFK5:SetValue( "FK5_VLMOE2", IIf(lEstorno,xMoeda(nValorTran,nMoedTran,Iif(nMoedOrig>1 .And. (nMoedTran==1 .Or. nMoedOrig == nMoedTran),1,nMoedOrig),,,aTxMoedas[nMoedTran][2]),xMoeda(nValorTran,nMoedOrig,1,,,aTxMoedas[nMoedOrig][2])) )
				oSubFK5:SetValue( "FK5_TXMOED", aTxMoedas[nMoedTran][2] )
			Endif

			oSubFK5:SetValue( "FK5_DTDISP", dDataCred )
			oSubFK5:SetValue( "FK5_NATURE", cNaturDes )
			oSubFK5:SetValue( "FK5_FILORI", cFilAnt )
			If lSpbInUse
				oSubFK5:SetValue( "FK5_MODSPB", cModSpb )
			Endif
			oSubFK5:SetValue( "FK5_PROTRA", cProcesso )

			If oModelMov:VldData()
				oModelMov:CommitData()
			Else
				lRet := .F.
				cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[6])
				Help(,,"MF100GRV4",,cLog, 1, 0 )
			Endif
			oModelMov:DeActivate()
			oModelMov:Destroy()
			oModelMov := NIL

			If lRet
				// Se Portugal, registra dados do Diario (movimento destino)
				If UsaSeqCor()
					AADD(aDiario,{"SE5",SE5->(RECNO()),cCodDiario,"E5_NODIA","E5_DIACTB"})
				Else
					aDiario := {}
				Endif

				If !Empty(aTrfPms) .And. !Empty(aTrfPms[3])
					nRecNo	:= SE5->(RecNo())
					cID		:= STRZERO(SE5->(RecNo()),10)
					cStart	:= "AA"
					dbSelectArea("SE5")
					dbSetOrder(9)
					While dbSeek(xFilial()+cID)
						cID := STRZERO(nRecNo,8)+cStart
						cStart := SomaIt(cStart)
					EndDO
					SE5->(dbGoto(nRecNo))

					cCamposE5 := "{{'E5_PROJPMS', '" + cId +"'}}"
					oModelMov := FWLoadModel("FINM030") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
					oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
					oModelMov:Activate()
					oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //habilita gravação de SE5
					oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5)

					//Posiciona a FKA com base no IDORIG da SE5 posicionada
					oSubFKA := oModelMov:GetModel( "FKADETAIL" )
					oSubFKA:SeekLine( { {"FKA_FILIAL", SE5->E5_FILIAL },{"FKA_IDORIG", SE5->E5_IDORIG } } )

					//Dados de integração
					oSubFK9 := oModelMov:GetModel("FK9DETAIL")
					If !oSubFK9:IsEmpty()
						oSubFK9:SetValue( "FK9_PRJPMS", cId )
					EndIf

					If oModelMov:VldData()
						oModelMov:CommitData()
					Else
						lRet := .F.
						cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
						cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
						cLog += cValToChar(oModelMov:GetErrorMessage()[6])
						Help(,,"MF100GRV5",,cLog, 1, 0 )
					Endif
					oModelMov:DeActivate()
					oModelMov:Destroy()
					oModelMov := NIL

					If lRet
						RecLock("AJE",.T.)
						AJE->AJE_FILIAL	:= xFilial("AJE")
						AJE->AJE_VALOR 	:= SE5->E5_VALOR
						AJE->AJE_DATA	:= SE5->E5_DATA
						AJE->AJE_HISTOR	:= SE5->E5_HISTOR
						AJE->AJE_PROJET	:= aTrfPms[3]
						AJE->AJE_REVISA	:= PmsAF8Ver(aTrfPms[3])
						AJE->AJE_EDT	:= aTrfPms[4]
						AJE->AJE_TAREFA	:= aTrfPms[5]
						AJE->AJE_ID		:= cID
						MsUnlock()
					EndIf
				EndIf
			Endif

			If lRet
				If lAtuSldNat .And. cNaturOri <> cNaturDes
					SA6->( DbSetOrder(1) )
					SA6->( dbSeek( xFilial() + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA ) )

					cMoedaBnc  := StrZero( Max(SA6->A6_MOEDA, 1 ), 2)
					nValorConv := Iif (Empty(SE5->E5_TXMOEDA), SE5->E5_VALOR, SE5->E5_VALOR * SE5->E5_TXMOEDA)

					AtuSldNat(SE5->E5_NATUREZ, SE5->E5_DATA, "01", "3", "R", SE5->E5_VALOR,, If(lEstorno,"-","+"),,FunName(),"SE5", SE5->(Recno()),0)
				Endif

				If nModulo == 72
					KEXF040(lEstorno)
				EndIf

				If lA100TR02
					ExecBlock("A100TR02",.F.,.F.,lEstorno)
				EndIf
				If lA100TRB
					ExecBlock("A100TRB",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
					cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ So atualiza do saldo se for R$,DO,TB,TC ou se for CH e o ban-³
				//³ co origem n„o for um caixa do loja, pois este foi gerado no  ³
				//³ SE1 e somente sera atualizado na baixa do titulo.            ³
				//³ O teste do caixa ‚ exatamente para o banco origem Mesmo.     ³
				//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
				//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
				//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ((Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC"+IIf(cPaisLoc=="BRA","","/$ ") ) .or. ;
				(SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig))) .and. ;
				!(SUBSTR(SE5->E5_NUMCHEQ,1,1) == "*")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza saldo bancario.									 ³
					//³ Passo o E5_VALOR pois fora do Brasil a conta pode ser em moeda³
					//³ diferente da moeda Oficial.                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AtuSalBco(cBcoDest,cAgenDest,cCtaDest,dDataBase, SE5->E5_VALOR ,"+")
					Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Lacncamento orcamentario - Transferencia destino ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000007","02","FINA100")

				If !lExterno
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Lan‡amento Contabil - 2. registro do SE5                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cPadrao   := "561"
					lPadrao2  := VerPadrao(cPadrao)
					STRLCTPAD := cBcoOrig+"/"+cAgenOrig+"/"+cCtaOrig

					IF lPadrao2 .and. !lPadrao1 .and. mv_par04 == 1
						nHdlPrv := HeadProva(cLote,"FINA100",Substr(cUsuario,7,6),@cArquivo)
					Endif

					IF lPadrao2 .and. mv_par04 == 1
						nTotal += DetProva( nHdlPrv, cPadrao,"FINA100",cLote)
					Endif

					IF ( lPadrao1 .or. lPadrao2) .and. mv_par04 == 1

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Efetiva Lan‡amento Contabil                                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lMostra	 := If( mv_par02 == 1, .T., .F. )
						lAglutina := If( mv_par01 == 1, .T., .F. )

						//				If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .and. !(lRetCkPG(3,,cBcoOrig)) .and.  lRetCkPG(3,,cBcoDest) //GERA ITF C/ CONTABILIZACAO
						if lEstorno // caso que sea retorno no debe hacer ITF Nahim 06/09/2019
							If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .and.  lRetCkPG(3,,cBcoDest) //GERA ITF C/ CONTABILIZACAO Nahim Terrazas 30/04/2019
								FinProcITF( SE5->( Recno() ),6,, .F.,{ nHdlPrv, "", "", "FINA100", cLote } , @aFlagCTB )
							EndIf
							/*		If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .and.  lRetCkPG(3,,cBcoOrig) //GERA ITF C/ CONTABILIZACAO Nahim Terrazas 30/04/2019
							FinProcITF( SE5->( Recno() ),6,, .F.,{ nHdlPrv, "", "", "FINA100", cLote } , @aFlagCTB )
						EndIf
							*/
					else
						If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .and.  lRetCkPG(3,,cBcoDest) //GERA ITF C/ CONTABILIZACAO Nahim Terrazas 30/04/2019
							FinProcITF( SE5->( Recno() ),3,, .F.,{ nHdlPrv, "", "", "FINA100", cLote } , @aFlagCTB )
						EndIf
					endif
					RodaProva( nHdlPrv,;
						nTotal )

					cA100Incl( cArquivo,;
						nHdlPrv,;
						3 /*nOpcx*/,;
						cLote,;
						lMostra /*lDigita*/,;
						lAglutina /*lAglut*/,;
						/*cOnLine*/,;
						/*dData*/,;
						/*dReproc*/,;
						@aFlagCTB,;
						/*aDadosProva*/,;
						aDiario )
					aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

					If lPadrao1 .and. nRegSEF > 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Se contabilizou a Saida, e Foi uma TB  / CH, ent„o  ³
						//³ marca no cheque que j  foi contabilizado.           ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						DbSelectArea("SEF")
						DbGoto(nRegSEF)
						Reclock("SEF")
						SEF->EF_LA := "S"
						MsUnlock()
					Endif
				Else
					If lFindITF .And. FinProcITF( SE5->( Recno() ),1 ) .and. !(lRetCkPG(3,,cBcoOrig)) .and.  lRetCkPG(3,,cBcoDest)
						FinProcITF( SE5->( Recno() ),3,, .F. ,{ nHdlPrv, cPadrao, "", "FINA100", cLote }, @aFlagCTB )
					EndIf
				Endif
			Endif
		Endif
	Endif
Endif

If lRet
	If lA100TR03
		ExecBlock("A100TR03",.F.,.F.,lEstorno)
	EndIf
	If lA100TRC
		ExecBlock("A100TRC",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
			cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
	EndIf
Endif

If lRet .and. !lExterno .and. lPadrao2 .and. mv_par04 == 1  // On Line

	oModelMov := FWLoadModel("FINM030") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
	oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
	oModelMov:Activate()
	oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravação de SE5

	//Posiciona a FKA com base no IDORIG da SE5 posicionada
	oSubFKA := oModelMov:GetModel( "FKADETAIL" )
	If oSubFKA:SeekLine( { {"FKA_FILIAL", SE5->E5_FILIAL },{"FKA_IDORIG", SE5->E5_IDORIG } } )

		//Dados do movimento
		oSubFK5 := oModelMov:GetModel("FK5DETAIL")
		oSubFK5:SetValue( "FK5_LA", "S" )

		If oModelMov:VldData()
			oModelMov:CommitData()
		Else
			lRet := .F.
			cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[6])
			Help(,,"MF100GRV6",,cLog, 1, 0 )
		Endif
	Endif
	oModelMov:DeActivate()
	oModelMov:Destroy()
	oModelMov := NIL
EndIf

// Integração EAI após a gravação da transferência bancária.
If lRet
	// Mensagem de transferência bancária apenas se versão 3.000 ou superior.
	If lEAIA100 .and. val(cEAIA100v) >= 3.000
		SetMsgOpc(If(lEstorno, 8, 7))  // 7 - Inclusão de transferência bancária / 8 - Estorno de transferência bancária.
		aRetInteg := FwIntegDef('FINA100',,,, 'FINA100')
		// Se der erro no envio da integração, então faz rollback e apresenta mensagem em tela para o usuário.
		If !aRetInteg[1]
			Help(,, "FINA100INTEG",, "STR0146" + AllTrim(aRetInteg[2]), 1, 0,,,,,, {"STR0147"}) // "O movimento bancário não será gravado pois ocorreu um erro na integração: ", "Verifique as configurações da integração EAI."
			lRet := .F.
		EndIf
	Endif
Endif

If lRet
	If cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN"
		if !lEstorno // Nahim Terrazas 05/02/2019
			SE5->E5_PROCTRA := cNumeE5_PROCTRA	// Nahim Terrazas 05/02/2019
		endif // Nahim Terrazas 05/02/2019
		If Len(Alltrim(SE5->E5_PROCTRA)) > 0
			PutMV("MV_NPROC",SE5->E5_PROCTRA)
		Endif
	Endif
Else
	DisarmTransaction()
Endif

Return lRet /*Function fa100grava*/

Static Function lRetCkPG(n,cDebInm,cBanco,nPagar)
	Local lRetCx:=.T.
	If cPaisLoc$"PER|DOM|BOL"
		If n==3
			If cBanco $ (Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1])+"/"+GetMv("MV_CARTEIR"))  .or. IsCaixaLoja(cBanco)
				lRetCx:=.F.
			Endif
		Endif
	Endif
Return(lRetCx)

Static Function CargaSa6(cBanco,cAgencia,cConta,cDesc,lHelp,cBenef100,lValidBloq,cNatureza, cMoeda,lSitef)
	Local cAlias	:= Alias()
	Local cChave	:= cBanco + Iif(Empty(cAgencia),"",cAgencia) + Iif(Empty(cConta),"",cConta)
	Local lRet		:=.T.
	Local nTamBen	:= Iif(cBenef100=NIL,0,Len(cBenef100))
	Local lBenefi	:= .T.
	Local lFinBenef	:= Existblock ("FINBENEF")

	DEFAULT cBanco		:= ""
	DEFAULT cAgencia	:= ""
	DEFAULT cConta		:= ""
	DEFAULT lHelp		:= .T.
	DEFAULT cBenef100	:= ""
	DEFAULT lValidBloq  := .F.
	DEFAULT cMoeda		:= ""
	DEFAULT cNatureza	:= ""
	DEFAULT lSitef 		:= .F.

	cChave:= cBanco+Iif(Empty(cAgencia),"",cAgencia)+Iif(Empty(cConta),"",cConta)
	nTamBen := Len(cBenef100)

	lHelp := Iif( lHelp=Nil,.T.,lHelp)
	cFilold:= cFilAnt
	If !(FunName() $ "FINA091") .AND. !lSitef
		cFilAnt:= SM0->M0_CODFIL
	Endif
	DbSelectArea("SA6")
	DbSetOrder(1)

	If FunName() $ "FINA080|FINA750"
		If Type("oBanco") == "O"
			If oBanco:lModiFied
				cChave:=cBanco+IIF(!Empty(cAgencia),cAgencia,"")+IIF(!Empty(cConta),cConta,"")
				If DbSeek(cFilial+cChave)
					If cAgencia<>SA6->A6_AGENCIA
						cAgencia:=SA6->A6_AGENCIA
						cConta:=SA6->A6_NUMCON
					Else
						If cConta<>SA6->A6_NUMCON
							cConta:=SA6->A6_NUMCON
						EndIf
					EndIf
				Else
					cAgencia:=""
					cConta:=""
					cChave:=cBanco
				EndIf
			Endif
		EndIf
	EndIf

	If FunName() $ "FINA080|FINA750"
		If Type("oAgencia") == "O"
			If oAgencia:lModiFied
				cChave:=(cBanco+cAgencia+cConta)
				If DbSeek(cFilial+cChave)
					If cConta<>SA6->A6_NUMCON
						cConta:=SA6->A6_NUMCON
					Endif
				Else
					cConta:=""
				EndIf
			EndIf
		EndIf
	EndIf

	If !DbSeek(xFilial("SA6")+cChave)
		lRet := .F.
		If lHelp
			Help(" ",1,"FA100BCO")
		End
	Else
		cBanco		:= Iif(cBanco	== NIl .or.  Empty( cBanco ),  SA6->A6_COD,     cBanco )
		cAgencia	:= Iif(cAgencia == NIl .or. Empty( cAgencia ), SA6->A6_AGENCIA	, cAgencia )
		cConta		:= Iif(cConta   == Nil .or. Empty( cConta   ), SA6->A6_NUMCON	, cConta   )
		cDesc		:= Iif(cDesc   == Nil .or. Empty( cDesc   ), SA6->A6_NREDUZ	, cDesc   )
		If cPaisLoc == "BRA" .And. SA6->A6_MOEDA > 0
			cMoeda := SA6->A6_MOEDA
		EndIf
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega o nome do beneficiario, caso banco destino  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	// Carrega o nome do beneficiario, caso banco destino
	If	lFinBenef
		lBenefi := ExecBlock ("FINBENEF",.F.,.F.)
	Endif

	If lRet .and. cBenef100 != Nil .and. lBenefi   // FINA100
		cBenef100 := Padr(SUBSTR(SM0->M0_NOMECOM,1,nTamBen),nTamben)
	EndIf

	If lRet .And. lValidBloq
		If SA6->A6_BLOCKED == "1"  //Conta Bloqueada
			Help(" ",1,"CCBLOCKED",,"Conta corrente bloqueada para novas movimentações",1,0)
			lRet := .F.
		ElseIf FieldPos("A6_MSBLQL") > 0 .And. SA6->A6_MSBLQL == "1" // campo de bloqueio ativado e banco bloqueado
			Help(" ",1,"REGBLOQ",,,1,0)
			lRet := .F.
		Endif
	EndIf

	If lRet .and. ExistBlock("PE_LOADSA6")
		cNatureza := Execblock("PE_LOADSA6",.F.,.F.)
	EndIf
	cFilAnt:=cFilold
	DbSelectArea( cAlias )
Return lRet



/*/{Protheus.doc} MsgUVer
Função que verifica a versão de uma mensagem única cadastrada no adapter EAI.

Essa função deverá ser EXCLUÍDA e substituída pela função FwAdapterVersion()
após sua publicação na Lib de 2019.

@param cRotina		Rotina que possui a IntegDef da Mensagem Unica
@param cMensagem	Nome da Mensagem única a ser pesquisada

@author		Felipe Raposo
@version	P12
@since		23/11/2018
@return		xVersion - versão da mensagem única cadastrada. Se não encontrar, retorna nulo.
/*/
Static Function MsgUVer(cRotina, cMensagem)

	Local aArea    := GetArea()
	Local aAreaXX4 := XX4->(GetArea())
	Local xVersion

	If FindFunction("FwAdapterVersion")
		xVersion := FwAdapterVersion(cRotina, cMensagem)
	ElseIf XX4->(FieldPos('XX4_SNDVER')) > 0
		cMensagem := Padr(cMensagem, Len(XX4->XX4_MODEL))
		cRotina   := Padr(cRotina,   Len(XX4->XX4_ROTINA))
		XX4->(dbSetOrder(1))
		If XX4->(msSeek(xFilial() + cRotina + cMensagem, .F.) .and. !empty(XX4_SNDVER))
			xVersion := AllTrim(XX4->XX4_SNDVER)
		Endif
	Endif

	RestArea(aAreaXX4)
	RestArea(aArea)

Return xVersion