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
Static __F100DPRM   := ExistBlock("F100DPRM")
Static lEAIA100		:= FWHasEAI("FINA100", .T.,, .T.)
Static cEAIA100v	:= PMSMSGUVER('FINA100', "BANKTRANSACTION")	//MsgUVer('FINA100', "BANKTRANSACTION")

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

User Function xfa100tran(cAlias,nReg,nOpc,aM,aAutoCab)
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
			@ 058+nEspLin,008+nEspLarg SAY STR0143 SIZE 50, 7 OF oPanel PIXEL	// "Data de Crédito"
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

								//Implementações para leitura dos parâmetros informados via ExecAuto para substituir o SX1 "AFI100" para execução da rotina
								If (nPosAuto := AScan(aAutoCab, {|campo| Upper(campo[1]) == "NAGLUTINA"})) > 0
									MV_PAR01 :=	IIf(ValType(aAutoCab[nPosAuto][2]) == "N", aAutoCab[nPosAuto][2], 2)
								EndIf

								If (nPosAuto := AScan(aAutoCab, {|campo| Upper(campo[1]) == "NCTBONLINE"})) > 0
									MV_PAR04 :=	IIf(ValType(aAutoCab[nPosAuto][2]) == "N", aAutoCab[nPosAuto][2], 2)
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
±±³ Uso		 ³ FINA100													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidTran(cTip,cBco,cAge,cCta,cBen,cDoc,nValTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig)

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
	If lRet .AND. FXMultSld() .AND. .F.
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fa100grava³ Autor ³ Wagner Xavier         ³ Data ³ 08/09/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Faz as atualizacoes para transferencia.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa100grava()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function fa100grava( cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,;
		cBcoDest,cAgenDest,cCtaDest,cNaturDes,;
		cTipoTran,cDocTran,nValorTran,cHist100,cBenef100,;
		lEstorno,cModSpb,aTrfPms,nTxMoeda,nRegOrigem,nRegDestino, dDataCred)
	Local lRet       := .T.

	lRet := StaticCall(FINA100, fa100grava, cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,cBcoDest,cAgenDest,cCtaDest,cNaturDes,cTipoTran,cDocTran,nValorTran,cHist100,cBenef100,lEstorno,cModSpb,aTrfPms,nTxMoeda,nRegOrigem,nRegDestino,dDataCred)
Return lRet
 /*Function fa100grava*/





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


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA100Est	³ Autor ³ Alessandro B. Freire  ³		³ 02/07/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Estorna movimentos bancarios										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³fa100Est()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ FINA100  ³ 																			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User FUNCTION xFa100Est(aAutoCab)

	Local lPanelFin 	:= IsPanelFin()
	LOCAL cBcoOrig 		:= ""                 // Banco a ser estornado
	LOCAL cAgenOrig		:= ""                 // Ag.   "  "     "
	LOCAL cCtaOrig 		:= ""                 // Cta.  "  "     "
	LOCAL cNatOrig    	:= ""
	LOCAL cMoedaTran  	:= ""						 // Numerario da Transferencia original
	LOCAL cBcoDest 		:= ""                 // Banco estornante
	LOCAL cAgenDest		:= ""                 // Ag.      "
	LOCAL cCtaDest 		:= ""                 // Cta.     "
	LOCAL cNatDest    	:= ""
	LOCAL cHist100		:= STR0033 // "Estorno de transferencia."
	LOCAL cBenef100		:= ""
	LOCAL cDoc			:= ""
	LOCAL cModSpb		:= "1"
	LOCAL nVlrEstorno 	:= 0						 // Valor a ser estornado.
	LOCAL nRegOrigem	:= 0
	LOCAL nRegDestino 	:= 0
	LOCAL nTamTit		:= TamSx3("E5_PREFIXO")[1]+TamSx3("E5_NUMERO")[1]+TamSx3("E5_PARCELA")[1]+TamSx3("E5_TIPO")[1]
	LOCAL nT			:= 0
	LOCAL nPos			:= 0
	LOCAL nTimeOut		:= SuperGetMv("MV_FATOUT",,900)*1000 // Estabelece 15 minutos para que o usuarios selecione
	LOCAL aAreaSE5		:= SE5->(GetArea())  // Ordem original do SE5 no inicio da operacao.
	LOCAL aEstornante	:= {} 					 // Array contendo dados do banco estornante.
	LOCAL aEstornado	:= {} 					 // Array contendo dados do banco estornante.
	LOCAL aTam			:= {}
	LOCAL lGrava		:= .T.
	LOCAL lSpbInUse		:= SpbInUse()
	LOCAL lBlocked		:= .F.
	LOCAL lEstorno		:= .T.
	LOCAL lMarca		:= .F.
	Local oOk			:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo			:= LoadBitmap( GetResources(), "LBNO" )
	LOCAL oPanel		:= NIL
	LOCAL oPanel1		:= NIL
	LOCAL oFnt			:= NIL
	Local oTimer		:= NIL
	Local lPergunte 	:= .F.
	Local aArea			:= {}
	Local cProcesso		:= ''
	Local nOrdPTrans	:= OrdProcTransf()
	LOCAL nA			:= 0
	LOCAL nI			:= 0
	LOCAL cMoedaTx		:= ""
	Local nPosAuto		:= 0
	Local lBxConc		:= GetNewPar("MV_BXCONC","2") == "1"
	Local nTxMoeda		:= 0
	Local oModelMov 	:= NIL //FWLoadModel("FINM030")
	Local oSubFK5		:= NIL
	Local oSubFKA		:= NIL
	Local oSubFK8		:= NIL
	Local oSubFK9		:= NIL
	Local cLog 			:= ""
	Local cCamposE5 	:= ""
	Local cProcFKs 		:= ""
	Local nDiasDispo	:= SUPERGETMV("MV_DIASCRD",.F.,0)
	Local dDataCred		:= dDatabase + nDiasDispo
	Local lbFilBrw   	:= .F.
	Local cGetMoeda		:= ""

	Default aAutoCab := {}

	PRIVATE nTotal		:= 0
	PRIVATE nTxEstR		:= 0
	PRIVATE nTxEstP		:= 0
	PRIVATE cCodDiario	:= ""
	PRIVATE aDiario		:= {}
	PRIVATE aTxMoedas 	:= {}

	lPagar   := .F.
	lReceber := .F.

//--------------------------------------------------------------------------
// A moeda 1 e tambem inclusa como um dummy, nao vai ter uso,
// mas simplifica todas as chamadas a funcao xMoeda, ja que posso
// passara a taxa usando a moeda como elemento do Array atxMoedas
// Exemplo xMoeda(E1_VALOR,E1_MOEDA,1,dDataBase,,aTxMoedas[E1_MOEDA][2])
// Bruno - Paraguay 22/08/2000
//--------------------------------------------------------------------------
	aAdd  (aTxMoedas,{"",1,PesqPict("SM2","M2_MOEDA1")})
	For nA   := 2  To MoedFin()
		cMoedaTx := Str(nA,IIf(nA <= 9,1,2))
		cGetMoeda	:= GetMv("MV_MOEDA"+cMoedaTx)
		If !Empty(cGetMoeda)
			Aadd(aTxMoedas,{cGetMoeda,RecMoeda(dDataBase,nA),PesqPict("SM2","M2_MOEDA"+cMoedaTx) })
		Else
			Exit
		Endif
	Next

	If Type("bFiltraBrw") == "B"
		lbFilBrw := .T.
	Endif

	DEFINE FONT oFnt NAME "Arial" SIZE 10,14 BOLD

//--------------------------------------------------------------------------
// Parametros da funcao:
// mv_par01 = N£mero do documento a estornar
// mv_par02 = Data da Movimentacao
// mv_par03 = Banco
// mv_par04 = Agencia
// mv_par05 = Conta
//--------------------------------------------------------------------------
	If !lF100Auto
		If lPanelFin
			lPergunte := PergInPanel("FA100E",.T.)
		Else
			lPergunte := pergunte("FA100E",.T.)
		Endif

		If !lPergunte
			// Restaura pergunta principal
			pergunte("AFI100",.F.)
			If cPaisLoc <> "BRA" .And. lbFilBrw
				Eval( bFiltraBrw )
			Endif
			Return(.F.)
		EndIf

	Else //Via rotina automatica

		// Restaura pergunta principal
		Pergunte("AFI100",.F.)

		//Substitui as variaveis pelos conteudos do ExecAuto
		If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'AUTNRODOC'})) > 0
			mv_par01 :=	Padr(aAutoCab[nPosAuto,2],TamSx3("E5_NUMCHEQ")[1])
		EndIf

		If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'AUTDTMOV'})) > 0
			mv_par02 :=	aAutoCab[nPosAuto,2]
		EndIf

		If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'AUTBANCO'})) > 0
			mv_par03 :=	Padr(aAutoCab[nPosAuto,2],TamSx3("E5_BANCO")[1])
		EndIf

		If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'AUTAGENCIA'})) > 0
			mv_par04 :=	Padr(aAutoCab[nPosAuto,2],TamSx3("E5_AGENCIA")[1])
		EndIf

		If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'AUTCONTA'})) > 0
			mv_par05 :=	Padr(aAutoCab[nPosAuto,2],TamSx3("E5_CONTA")[1])
		EndIf

	EndIf

// Verifica se data do movimento não é menor que data limite de movimentacao no financeiro.
// Antes verificavamos a data do movimento original (mv_par02), porem como se trata de uma Transferencia
// precisamos realizar a verificação na data em que o estorno ocorrerá.
	If !DtMovFin(dDataBase,,"3")
		// Restaura pergunta principal
		pergunte("AFI100",.F.)
		If cPaisLoc <> "BRA" .And. lbFilBrw
			Eval( bFiltraBrw )
		Endif
		Return
	Endif

//Estorno de movimento futuro nao eh permitido
	If dDataBase < mv_par02
		// Restaura pergunta principal
		Help(" ",1,"DTESTINV",, STR0042 +; // "Data do estorno inválida!"
		Chr(10)  + STR0043 + DTOC(mv_par02) +; // "Data da movimentação: "
		Chr(10)  + STR0044 + DTOC(dDataBase), 4, 0) // "Data do estorno: "
		pergunte("AFI100",.F.)
		If cPaisLoc <> "BRA" .And. lbFilBrw
			Eval( bFiltraBrw )
		Endif
		Return
	Endif

//Verifico transferencias com mesmas caracteristicas
	aAreaSE5:= SE5->(GetArea())
	dbSelectArea("SE5")
	dbSetOrder(2) //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ

	If MSSeek( xFilial("SE5")+"TR"+Space(nTamTit)+DTOS(mv_par02))

		While ! Eof()								.And. ;
				( SE5->E5_FILIAL == xFilial("SE5")) .And. ;
				( SE5->E5_DATA == mv_par02 )			.And. ;
				( SE5->E5_TIPODOC == "TR" )
			//Nao permito cancelamento de baixa se a mesma foi conciliada e se
			//o parametro MV_BXCONC estiver como 2(Padrao) - Nao permite
			If !Empty(SE5->E5_RECONC) .And. !lBxConc
				SE5->(dbSkip())
				Loop
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  Verifica se o registro corresponde aos parametros informados. ³
			//³  Caso afirmativo, encontrou o banco estornante.				   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Alltrim(SE5->E5_NUMCHEQ) == 	Alltrim(mv_par01)   .And.;
					SE5->E5_BANCO	== 	mv_par03   .And.;
					SE5->E5_AGENCIA	== 	mv_par04   .And.;
					SE5->E5_CONTA	== 	mv_par05   .And.;
					SE5->E5_RECPAG 	== 	"P"

				//Array para tela de opcoes
				If cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN" .And. nOrdPTrans > 0
					If FA100ProcT(Alltrim(SE5->E5_PROCTRA)) // Funcao que verifica se esse registro ja fora estornado antes
						dbSkip()
						Loop
					Else
						nT := Ascan(aEstornante,{|x|x[11]== SE5->E5_MOEDA+AllTrim(SE5->E5_NUMCHEQ)+AllTrim(SE5->E5_PROCTRA)})
					Endif
				Else
					nT := Ascan(aEstornante,{|x|x[11]== SE5->E5_MOEDA+AllTrim(SE5->E5_NUMCHEQ)})
				Endif

				If nT > 0
					aEstornante[nT,1]:= Dtoc(E5_DATA)				//Data
					aEstornante[nT,2]:= SE5->E5_BANCO				//Banco Origem
					aEstornante[nT,3]:= SE5->E5_AGENCIA				//Agencia Origem
					aEstornante[nT,4]:= SE5->E5_CONTA           //Conta Origem
					aEstornante[nT,5]:= SE5->E5_NUMCHEQ         //Documento
					aEstornante[nT,6]:= SE5->E5_MOEDA           //Tipo de transferencia
					aEstornante[nT,7]:= Transf(E5_VALOR,"@E 9999,999,999.99") //valor

					aEstornante[nT,12] := SE5->(RECNO())
					nPos := nT

				Else

					Aadd(aEstornante,{Dtoc(E5_DATA),SE5->E5_BANCO,SE5->E5_AGENCIA,;
						SE5->E5_CONTA,SE5->E5_NUMCHEQ,SE5->E5_MOEDA,;
						Transf(E5_VALOR,"@E 9999,999,999.99"),; 				//Chave do movimento de saida
					"","","",; 														//Banco, Agencia e Conta do movimento de entrada
					iif(cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN" .And. nOrdPTrans > 0,SE5->E5_MOEDA+ALLTRIM(SE5->E5_NUMCHEQ)+AllTrim(SE5->E5_PROCTRA) , SE5->E5_MOEDA+ALLTRIM(SE5->E5_NUMCHEQ)),;				//Amarracao entre saida e entrada
					SE5->(RECNO()),;												//Registro do movimento de saida
					0 })																//Registro do movimento de entrada
					nPos := Len(aEstornante)

				Endif

				If cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN" .And. nOrdPTrans > 0
					aArea := GetArea()
					cProcesso := SE5->E5_PROCTRA
					dbSetOrder(nOrdPTrans)
					dbSeek(xFilial("SE5")+cProcesso,.T.)
					While ! Eof() .And. SE5->E5_PROCTRA == cProcesso
						If Alltrim(SE5->E5_TIPODOC) == "TE" .And. Alltrim(SE5->E5_RECPAG) == "P" .And. Alltrim(SE5->E5_NUMCHEQ) == 	Alltrim(mv_par01)
							Exit
						EndIF
						If Alltrim(SE5->E5_TIPODOC) == "TR" .And. Alltrim(SE5->E5_RECPAG) == "R" .And. Alltrim(SE5->E5_DOCUMEN) == 	Alltrim(mv_par01)
							aEstornante[nPos,13] := SE5->(RECNO())
							Exit
						Endif
						dbSkip()
					Enddo
					RestArea(aArea)
				Endif

			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³  O documento ser  o estornado caso for um movimento a receber  ³
			//³  com o numero informado e no mesmo dia.						   ³
			//³  Procura pelo N§ do Doc em E5_DOCUMEN   					   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AllTrim(SE5->E5_DOCUMEN) == AllTrim(mv_par01) .And.;
					SE5->E5_RECPAG	== "R" .And.;
					SE5->E5_BANCO	== 	mv_par03   .And.;
					SE5->E5_AGENCIA	== 	mv_par04   .And.;
					SE5->E5_CONTA	== 	mv_par05   .And.;
					SE5->E5_DATA	== mv_par02

				If cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN" .And. nOrdPTrans > 0
					If FA100ProcT(Alltrim(SE5->E5_PROCTRA)) // Funcao que verifica se esse registro ja fora estornado antes
						dbSkip()
						Loop
					Else
						nT := Ascan(aEstornante,{|x|x[11]== SE5->E5_MOEDA+AllTrim(SE5->E5_DOCUMEN)+Alltrim(SE5->E5_PROCTRA) })
					Endif
				Else
					nT := Ascan(aEstornante,{|x|x[11]== SE5->E5_MOEDA+AllTrim(SE5->E5_DOCUMEN) })
				Endif

				If nT > 0
					aEstornante[nT,8]	:= SE5->E5_BANCO
					aEstornante[nT,9]	:= SE5->E5_AGENCIA
					aEstornante[nT,10] := SE5->E5_CONTA
					aEstornante[nT,13] := SE5->(RECNO())
				Else
					Aadd(aEstornante,{"","","","","","","",;					//Chave do movimento de saida
					SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,;		//Banco, Agencia e Conta do movimento de entrada
					iif(cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN" .And. nOrdPTrans > 0,SE5->E5_MOEDA+ALLTRIM(SE5->E5_DOCUMEN)+AllTrim(SE5->E5_PROCTRA) , SE5->E5_MOEDA+ALLTRIM(SE5->E5_DOCUMEN)),;	//Amarracao entre saida e entrada
					0,;													//Registro do movimento de saida
					SE5->(RECNO()) })									//Registro do movimento de entrada
					nT := Len(aEstornante)
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se jah encontrou o banco estornante, nao continua a procura pelo documento a receber no mesmo dia. ³
				//³ Isto evita que selecione o mesmo documento, no mesmo dia, porem de outro banco.                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(aEstornante[nT,2]+aEstornante[nT,3]+aEstornante[nT,4])
					Exit
				EndIf

				If cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN" .And. nOrdPTrans > 0
					aArea := GetArea()
					cProcesso := SE5->E5_PROCTRA
					dbSetOrder(nOrdPTrans)
					dbSeek(xFilial("SE5")+cProcesso,.T.)
					While ! Eof() .And. SE5->E5_PROCTRA == cProcesso
						If Alltrim(SE5->E5_TIPODOC) == "TR" .And. Alltrim(SE5->E5_RECPAG) == "P"
							aEstornante[nT,12] := SE5->(RECNO())
							// Adiciona os dados do Banco Origem, para que apareçam na proxima tela
							aEstornante[nT,1]:= Dtoc(E5_DATA)			//Data
							aEstornante[nT,2]:= SE5->E5_BANCO			//Banco Origem
							aEstornante[nT,3]:= SE5->E5_AGENCIA			//Agencia Origem
							aEstornante[nT,4]:= SE5->E5_CONTA           //Conta Origem
							aEstornante[nT,5]:= SE5->E5_NUMCHEQ         //Documento
							aEstornante[nT,6]:= SE5->E5_MOEDA           //Tipo de transferencia
							aEstornante[nT,7]:= Transf(E5_VALOR,"@E 9999,999,999.99") //valor
							Exit
						Endif
						dbSkip()
					Enddo
					RestArea(aArea)
				Endif

			EndIf
			dbSkip()
		EndDo
	Endif

//Nao achou registros de transferencia
	If Len (aEstornante) == 0
		HELP(" ",1,"RECNO",, ; // "Não existem registros no arquivo em pauta "
		Chr(10)  + STR0077, 4, 0) //"Ou o(s) registro(s) se encontra(m) conciliado(s). "

		pergunte("AFI100",.F.)
		dbSelectArea("SE5")
		SE5->(RestArea(aAreaSE5))
		If cPaisLoc <> "BRA" .And. lbFilBrw
			Eval( bFiltraBrw )
		Endif
		Return .F.
	EndIf

//Tela para escolher o a transferencia a ser estornada
//se houverem transferencias com mesmo documento no mesmo dia, mas de moedas diferentes
//Exemplo
// TRF1 - 02/03/07 - CH - 123456
// TRF1 - 02/03/07 - R$ - 123456
// TRF1 - 02/03/07 - DC - 123456

//Monto as strings para a tela de selecao
	For nT := 1 to Len(aEstornante)
		//Se uma das pontas da transferencia não for encontrada, desprezo
		//Se nao estiver marcado, desprezo
		If aEstornante[nT,12] > 0 .and. ;	//Registro original de saida
			aEstornante[nT,13] > 0 			//Registro original de entrada

			AADD(aEstornado,{	aEstornante[nT,1],aEstornante[nT,2],aEstornante[nT,3],;
				aEstornante[nT,4],aEstornante[nT,5],aEstornante[nT,6],;
				aEstornante[nT,7],aEstornante[nT,8],aEstornante[nT,9],;
				aEstornante[nT,10],lMarca,aEstornante[nT,12],aEstornante[nT,13]})


		Endif
	Next

//Nao achou registros de transferencia
	If Len (aEstornado) == 0
		HELP(" ",1,"RECNO" )
		pergunte("AFI100",.F.)
		dbSelectArea("SE5")
		SE5->(RestArea(aAreaSE5))
		If cPaisLoc <> "BRA" .And. lbFilBrw
			Eval( bFiltraBrw )
		Endif
		Return .F.
	EndIf

//Tela de selecao de transferencias a estornar
	nTrfCanc := 0
	aSize := MsAdvSize(,.F.,400)

	If !lF100Auto
		DEFINE MSDIALOG oDlg TITLE STR0033 From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		oDLg:lMaximized := .T.
		oTimer:= TTimer():New(nTimeOut,{|| oDlg:End() },oDlg) // Ativa timer
		oTimer:Activate()

		//---
		oPanel:= TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel:Align := CONTROL_ALIGN_TOP


		If Len(aEstornante) > 1
			//"Foram encontradas transferências bancárias semelhantes. Selecione as transferências a serem estornadas."
			@ 004, 005 Say STR0066	FONT oFnt COLOR CLR_HRED	PIXEL Of oPanel
		Else
			//"Confirme o estorno da transferência"
			@ 004, 005 Say STR0067	FONT oFnt COLOR CLR_HRED	PIXEL Of oPanel
		Endif

		//---
		@005,010 LISTBOX oBrw FIELDS TITLE "",;
			Rtrim(RetTitle("E5_DATA")) ,;		//"Data"   	,;
			STR0021+" "+STR0020	,;				//"Banco Origem"
		STR0022+" "+STR0020	,;				//"Agencia Origem"
		STR0023+" "+STR0020	,;				//"Conta Origem"
		STR0027					,;				//"Documento"
		STR0026					,;				//"Tipo Transf."
		STR0028					,;				//"Valor"
		STR0021+" "+STR0024	,;				//"Banco Destino"
		STR0022+" "+STR0024	,;				//"Agencia Destino"
		STR0023+" "+STR0024	 ;				//"C/C Destino"
		SIZE 370,100 OF oDlg PIXEL ;
			ON DBLCLICK (aEstornado[oBrw:nAt,11] := !aEstornado[oBrw:nAt,11],oBrw:Refresh()) NOSCROLL

		oBrw:SetArray( aEstornado )
		oBrw:bLine := {|| { If(aEstornado[oBrw:nAt,11],oOk,oNo),;
			aEstornado[oBrw:nAt,1],aEstornado[oBrw:nAt,2], ;
			aEstornado[oBrw:nAt,3],aEstornado[oBrw:nAt,4], ;
			aEstornado[oBrw:nAt,5],aEstornado[oBrw:nAt,6], ;
			aEstornado[oBrw:nAt,7],aEstornado[oBrw:nAt,8], ;
			aEstornado[oBrw:nAt,9],aEstornado[oBrw:nAt,10] }}

		oBrw:bHeaderClick := {|oObj,nCol| If( nCol==1, fMarkAll(@aEstornado),Nil), oBrw:Refresh()}

		oBrw:Align := CONTROL_ALIGN_ALLCLIENT
		oBrw:Refresh(.f.)

		//---
		oPanel1:= TPanel():New(0,0,'',oDlg, oDlg:oFont, .T., .T.,, ,20,20,.T.,.T. )
		oPanel1:Align := CONTROL_ALIGN_BOTTOM

		If lPanelFin  //Chamado pelo Painel Financeiro
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
				{|| If(FinOkDiaCTB(),nTrfCanc:=1,nTrfCanc:=0),oDlg:End()},;
				{||nTrfCanc := 0,oDlg:End()})
		Else
			DEFINE SBUTTON FROM 4,325 TYPE 1 ACTION (If(FinOkDiaCTB(),nTrfCanc:=1,nTrfCanc:=0),oDlg:End())  ENABLE OF oPanel1 PIXEL
			DEFINE SBUTTON FROM 4,360 TYPE 2 ACTION (nTrfCanc := 0,oDlg:End())  ENABLE OF oPanel1 PIXEL
			ACTIVATE MSDIALOG oDlg VALID (oTimer:End(),.T.) CENTERED
		Endif
	Else
		//Via execauto estorna todos os movimentos
		For nI := 1 To Len(aEstornado)
			aEstornado[nI,11] := .T.
		Next nI

		nTrfCanc := 1
	EndIf

	If nTrfCanc == 0
		// Restaura pergunta principal
		pergunte("AFI100",.F.)
		If cPaisLoc <> "BRA" .And. lbFilBrw
			Eval( bFiltraBrw )
		Endif
		Return
	Endif

	If nTrfCanc == 1

		//Inicia lancamento no PCO m
		PcoIniLan("000007")

		For nPos := 1 to Len(aEstornado)

			nRegOrigem	:= aEstornado[nPos,12]		//Registro original de saida
			nRegDestino	:= aEstornado[nPos,13]		//Registro original de entrada
			lContinua := .T.

			//Se uma das pontas da transferencia não for encontrada, desprezo
			//Se nao estiver marcado, desprezo
			If nRegOrigem == 0 .or. nRegDestino == 0 .or. !aEstornado[nPos,11]
				lContinua := .F.
			Endif

			If lContinua
				//posicionar SE5 no Regitro original de saida
				SE5->(dbGoto(nRegOrigem))

				// Se foi criado um cheque para esta transferencia, o mesmo deve ser cancelado,
				// uma vez que o valor ser  estornado.	  	 ³
				If nRegOrigem > 0 .and. SE5->E5_MOEDA $ "CH|TB"
					dbSelectArea("SEF")
					dbSetOrder(1)
					If dbSeek( xFilial("SEF")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SE5->E5_NUMCHEQ )
						RecLock("SEF",.F.)

						If (__F100DPRM)
							ExecBlock("F100DPRM",.F.,.F.)
						EndIf

						If EF_IMPRESS == "S"
							Replace EF_IMPRESS With "C"
						Else
							dbDelete()
						Endif
						MsUnlock()
					EndIf
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ O beneficiario sera o banco estornante.				  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SA6->(dbSetOrder(1))
				SA6->(MSSeek( xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA ))
				cBenef100	:= SA6->A6_NOME

				//posicionar SE5 no Regitro original de saida
				dbSelectArea("SE5")
				SE5->(dbGoto(nRegOrigem))
				cBcoDest 	:= SE5->E5_BANCO
				cAgenDest	:= SE5->E5_AGENCIA
				cCtaDest 	:= SE5->E5_CONTA
				cNatDest 	:= SE5->E5_NATUREZ
				cMoedaTran  := SE5->E5_MOEDA
				cModSpb		:= IIF(lSpbInUse, SE5->E5_MODSPB, cModSpb)
				cDoc		:= SE5->E5_NUMCHEQ
				nVlrEstorno := SE5->E5_VALOR
				nTxEstP     := SE5->E5_VLMOED2/SE5->E5_VALOR

				//posicionar SE5 no Regitro original de ENTRADA
				dbSelectArea("SE5")
				SE5->(dbGoto(nRegDestino))
				cBcoOrig 	:= SE5->E5_BANCO
				cAgenOrig	:= SE5->E5_AGENCIA
				cCtaOrig 	:= SE5->E5_CONTA
				cNatOrig 	:= SE5->E5_NATUREZ
				nTxEstR		:= SE5->E5_VLMOED2/SE5->E5_VALOR
				nTxMoeda	:= SE5->E5_TXMOEDA
				dDataCred	:= If(SE5->E5_DTDISPO > dDataCred, SE5->E5_DTDISPO, dDataCred )
				dDataCred	:= DataValida(dDataCred)

				// Valida estorno da transferencia
				If lFA100VET
					If ! ExecBlock("FA100VET", .F., .F., { nRegOrigem , nRegDestino } )
						pergunte("AFI100",.F.)
						dbSelectArea("SE5")
						SE5->(RestArea(aAreaSE5))
						If cPaisLoc <> "BRA" .And. lbFilBrw
							Eval( bFiltraBrw )
						Endif
						Exit
					Endif
				Endif

				// Restaura pergunta principal (necessaria para verificar contabilizacao etc)
				pergunte("AFI100",.F.)
				lGrava := .T.
				If lFA100TRF
					lGrava := ExecBlock("FA100TRF", .F., .F., { cBcoOrig, cAgenOrig, cCtaOrig,;
						cBcoDest, cAgenDest, cCtaDest,;
						cMoedaTran, cDoc, nVlrEstorno,;
						cHist100, cBenef100, cNatOrig,;
						cNatDest,cModSpb,lEstorno, dDataCred })
				Endif

				//Verifica se alguma das contas está bloqueada
				If CCBLOCKED(cBcoOrig,cAgenOrig,cCtaOrig) .or. CCBLOCKED(cBcoDest,cAgenDest,cCtaDest)
					lBlocked := .T.
				Endif

				If !lBlocked
					IF lGrava
						Begin Transaction
							If fa100grava(	cBcoOrig,cAgenOrig,cCtaOrig,cNatOrig,;
									cBcoDest,cAgenDest,cCtaDest,cNatDest,;
									cMoedaTran,cDoc,nVlrEstorno,cHist100,;
									cBenef100,lEstorno, cModSpb,,nTxMoeda, ;
									nRegOrigem, nRegDestino, dDataCred )

								//Seto a variável abaixo para que, caso seja necessária a migração do registro original, o model o faça.
								//Esta variável é setada .T. na função acima, correetamente.
								//Mas para a migração no carregamento do model FINM030 é necessário que ela esteja com .F.
								INCLUI := .F.

								//------------------------------------------------------------------------
								// Grava tipodoc com TE indicando o estorno da transferencia.
								// REGISTRO ORIGEM
								//------------------------------------------------------------------------
								dbSelectArea("SE5")
								dbGoto(nRegOrigem)
								RecLock("SE5")
								SE5->E5_TIPODOC := 'TE'
								SE5->(MsUnlock())

								FK5->(dbSetOrder(1))
								If FK5->(MsSeek(xFilial("FK5",SE5->E5_FILORIG)+ SE5->E5_IDORIG ))
									RecLock("FK5")
									FK5->FK5_TPDOC := 'TE'
									FK5->(MsUnlock())
								EndIf

								//------------------------------------------------------------------------
								// Grava tipodoc com TE indicando o estorno da transferencia.
								// REGISTRO DESTINO
								//------------------------------------------------------------------------
								dbSelectArea("SE5")
								dbGoto(nRegDestino)
								RecLock("SE5")
								SE5->E5_TIPODOC := 'TE'
								SE5->(MsUnlock())

								FK5->(dbSetOrder(1))
								If FK5->(MsSeek(xFilial("FK5",SE5->E5_FILORIG)+ SE5->E5_IDORIG ))
									RecLock("FK5")
									FK5->FK5_TPDOC := 'TE'
									FK5->(MsUnlock())
								EndIf
							Endif
						End Transaction

						dbSelectArea("SE5")

						//Restaura pergunta do processo
						Pergunte( "FA100E", .F. )
					Endif
				Endif
			Endif
		Next

		//Finaliza lancamento no PCO
		PcoFinLan("000007")
	Endif

	SE5->(RestArea(aAreaSE5))
	pergunte("AFI100",.F.)
	If cPaisLoc <> "BRA" .And. lbFilBrw
		Eval( bFiltraBrw )
	Endif

	If !lF100Auto
		If lPanelFin  //Chamado pelo Painel Financeiro
			dbSelectArea(FinWindow:cAliasFile)
			FinVisual(FinWindow:cAliasFile,FinWindow,(FinWindow:cAliasFile)->(Recno()),.T.)
		Endif
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA100ProcTºAutor  ³Clóvis Magenta      º Data ³  11/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que irá verificar se o registro da SE5 ja foi estor-º±±
±±º          ³ nado. Caso ja tenha sido, nao podera ser estornado denovo  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA100ProcT(cProctra)
	Local lEstornado 	:= .F.
	Local	aArea			:= GetArea()
	Local nOrdPTrans := OrdProcTransf()

	DEFAULT cProctra := ""

	dbselectArea("SE5")
	dbSetOrder(nOrdPTrans) //E5_FILIAL+E5_PROCTRA
	dbSeek(xFilial("SE5")+cProctra)
	While !SE5->(Eof()) .and. SE5->(E5_FILIAL+E5_PROCTRA) == xFilial("SE5")+cProctra
		If E5_TIPODOC = "TE"
			lEstornado := .T.
			EXIT
		Endif
		dbSkip()
	EndDo

	RestArea(aArea)

Return lEstornado



/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o	 ³fMarkAll	 ³ Autor ³ Mauricio Pequim Jr   ³ Data ³ 03/03/07 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Inverter marcacao dos registros da ListBox	                 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe	 ³fMarkAll(aTit)								 							  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ ExpA1 = Array Utilizado na Listbox								  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ FINA100            										 			  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fMarkAll(aTit)

	Local nI := 0

	If Len(aTit) > 0
		For nI := 1 to Len(aTit)
			If aTit[nI][11]
				aTit[nI][11] := .F.
			Else
				aTit[nI][11] := .T.
			EndIf
		Next
	EndIf

Return .T.
