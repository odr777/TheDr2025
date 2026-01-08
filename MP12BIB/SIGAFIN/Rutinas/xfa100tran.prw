#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "FINA100.CH"
#INCLUDE "FWMVCDEF.CH"

Static lPmsInt		:=	IsIntegTop(,.T.)
Static nMsgOpc		:= 	0
Static lPagar		:= .F.
Static lReceber		:= .F.
Static lFA100TRF	:= ExistBlock("FA100TRF")
Static lFA100VET	:= ExistBlock("FA100VET")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ xfa100tran³Autor  ³ Nahim Terrazas       ³ Data ³ 02/05/19 ³±±
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
	//³ Define Vari veis 											 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lPanelFin 	:= IsPanelFin()
	LOCAL cBcoOrig		:= CriaVar("E5_BANCO")
	LOCAL cBcoDest		:= CriaVar("E5_BANCO")
	LOCAL cAgenOrig		:= CriaVar("E5_AGENCIA")
	LOCAL cAgenDest		:= CriaVar("E5_AGENCIA")
	LOCAL cCtaOrig		:= CriaVar("E5_CONTA")
	LOCAL cCtaDest		:= CriaVar("E5_CONTA")
	LOCAL cDescOrig		:= CriaVar("E5_BANCO")
	LOCAL cDescDest		:= CriaVar("E5_BANCO")
	LOCAL cNaturOri		:= CriaVar("E5_NATUREZ")
	LOCAL cNaturDes		:= CriaVar("E5_NATUREZ")
	LOCAL cDocTran		:= CriaVar("E5_NUMCHEQ")
	LOCAL cHist100		:= CriaVar("E5_HISTOR")
	LOCAL nValorTran	:= 0
	LOCAL nOpcA			:= 0
	LOCAL cBenef100 	:= CriaVar("E5_BENEF")
	LOCAL oDlg
	LOCAL lA100BL01		:= ExistBlock("A100BL01")
	LOCAL lF100DOC		:= ExistBlock("F100DOC")
	LOCAL aValores		:= {}
	LOCAL lGrava
	LOCAL nA,cMoedaTx
	LOCAL lSpbInUse		:= SpbInUse()
	LOCAL aModalSPB		:= {"1=TED","2=CIP","3=COMP"}
	LOCAL oModSpb
	LOCAL cModSpb
	LOCAL aTrfPms		:= {}
	LOCAL lEstorno		:= .F.
	LOCAL oBcoOrig
	LOCAL oBcoDest
	LOCAL aSimbMoeda	:= {}							//Array com os simbolos das moedas.
	LOCAL nPosMoeda		:= 0							//Verifica a posicao da moeda no array aSimbMoeda
	LOCAL nX			:= 0							//Contador
	LOCAL nTotMoeda		:= 0							//TotMoeda
	LOCAL lExit			:= .F. 							//Executa a rotina apenas uma vez (Painel Gestor)
	LOCAL oAgenOrig
	LOCAL oCtaOrig
	Local aValidGet 	:= {}
	Local nPosAuto  	:= 0
	Local lFA100Get 	:= Existblock("FA100Get")
	Local aFa100Get 	:= {}

	Default aAutoCab 	:= {}

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

	//If cPaisLoc <> "BRA"
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
		If !Empty(GetMv("MV_MOEDA"+cMoedaTx))
			Aadd(aTxMoedas,{GetMv("MV_MOEDA"+cMoedaTx),RecMoeda(dDataBase,nA),PesqPict("SM2","M2_MOEDA"+cMoedaTx) })
		Else
			Exit
		Endif
	Next

	//Endif

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

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
	//³ movimentacao no financeiro    										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !DtMovFin(,,"3")
		If cPaisLoc <> "BRA" .And. Type("bFiltraBrw") == "B"
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
		cTipoTran 	:= CriaVar("E5_MOEDA")
		If lSpbInUse
			cModSpb := "1"
		Endif
		nOpcA := 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recebe dados a serem digitados 										  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//Se chamado do Painel Gestor, posicionado numa determinada C/C
		//Já preenche os dados da conta de partida (saida do dinheiro)
		If Type("aTrfPanel") == "A"
			Set Key VK_F12 To fA100Perg()
			pergunte("AFI100",.F.)
			lExit := .T.
			If Len(aTrfPanel)>0
				cBcoOrig	:= aTrfPanel[1]
				cAgenOrig:= aTrfPanel[2]
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
				// descripcion origen
				cBcoDest 	:= IIF(ValType(aFa100Get[5,1])=="C",aFa100Get[5,1],cBcoDest)
				cAgenDest 	:= IIF(ValType(aFa100Get[6,1])=="C",aFa100Get[6,1],cAgenDest)
				cCtaDest 	:= IIF(ValType(aFa100Get[7,1])=="C",aFa100Get[7,1],cCtaDest)
				cNaturDes 	:= IIF(ValType(aFa100Get[8,1])=="C",aFa100Get[8,1],cNaturDes)
				// descripcion destino
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

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³
				//³ -------------------------------------------------------------- ³
				//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
				//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
				//³ tracao e redivisao por 2 para a centralizacao. 					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nEspLarg :=	(((DlgWidthPanel(oPanelDados)/2) - 168) /2) // quite 60
				nEspLin  := 0
			Else
				nEspLarg := 0
				nEspLin  := 0
				DEFINE MSDIALOG oDlg FROM  32, 113 TO 272,630 TITLE OemToAnsi(STR0009) PIXEL	// "Movimenta‡„o Banc ria"
			Endif

			oDlg:lMaximized := .F.
			oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
			oPanel:Align := CONTROL_ALIGN_ALLCLIENT

			@ 000+nEspLin,004+nEspLarg TO 025+nEspLin,220+nEspLarg OF oPanel	PIXEL LABEL STR0020
			@ 027+nEspLin,004+nEspLarg TO 052+nEspLin,220+nEspLarg OF oPanel	PIXEL LABEL STR0024
			@ 054+nEspLin,004+nEspLarg TO 117+nEspLin,220+nEspLarg OF oPanel	PIXEL LABEL STR0025

			// Primeiro quadro
			@ 005+nEspLin,008+nEspLarg SAY OemToAnsi(STR0021) 		 SIZE 19, 7 OF oPanel PIXEL	// "Banco"
			@ 005+nEspLin,042+nEspLarg SAY OemToAnsi(STR0022) 		 SIZE 25, 7 OF oPanel PIXEL	// "Agência"
			@ 005+nEspLin,122+nEspLarg SAY OemToAnsi(STR0034)		 SIZE 28, 7 OF oPanel PIXEL	// "Natureza"
			@ 005+nEspLin,072+nEspLarg SAY OemToAnsi(STR0023) 		 SIZE 20, 7 OF oPanel PIXEL	// "Conta"
			@ 005+nEspLin,170+nEspLarg SAY "Descripcion"	 		 SIZE 40, 7 OF oPanel PIXEL

			@ 013+nEspLin,009+nEspLarg MSGET oBcoOrig  VAR cBcoOrig	F3 "SA6"	Picture "@S3"  Valid CargaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,@cDescOrig,.F.,,,@cNaturOri)	SIZE 10, 08												  	OF oPanel PIXEL hasbutton
			@ 013+nEspLin,042+nEspLarg MSGET oAgenOrig VAR cAgenOrig  							Picture "@S5"	Valid CargaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,@cDescOrig,.F.,,,@cNaturOri)	SIZE 20, 08 								OF oPanel PIXEL
			@ 013+nEspLin,072+nEspLarg MSGET oCtaOrig  VAR cCtaOrig								Picture "@S10"	Valid If(CargaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,@cDescOrig,.F.,,.T.,@cNaturOri),.T.,oBcoOrig:SetFocus()) SIZE 45, 08 	OF oPanel PIXEL
			@ 013+nEspLin,122+nEspLarg MSGET cNaturOri				F3 "SED"  					Valid ExistCpo("SED",@cNaturOri) .AND. FinVldNat( .F., cNaturOri, 3 ) SIZE 47, 08 												OF oPanel PIXEL hasbutton
			@ 013+nEspLin,170+nEspLarg MSGET oDesOrig VAR cDescOrig  							Picture "@S5"	Valid CargaSa6(@cBcoOrig,@cAgenOrig,@cCtaOrig,@cDescOrig,.F.,,,@cNaturOri)	SIZE 47, 08 								OF oPanel PIXEL

			// Segundo quadro
			@ 32+nEspLin,008+nEspLarg SAY OemToAnsi(STR0021) 		 SIZE 23, 7 OF oPanel PIXEL	// "Banco"
			@ 32+nEspLin,042+nEspLarg SAY OemToAnsi(STR0022) 		 SIZE 27, 7 OF oPanel PIXEL	// "Agˆncia"
			@ 32+nEspLin,072+nEspLarg SAY OemToAnsi(STR0023) 		 SIZE 18, 7 OF oPanel PIXEL	// "Conta"
			@ 32+nEspLin,122+nEspLarg SAY OemToAnsi(STR0034)		 SIZE 28, 7 OF oPanel PIXEL	// "Natureza"
			@ 32+nEspLin,170+nEspLarg SAY "Descripcion"	 			 SIZE 40, 7 OF oPanel PIXEL

			@ 40+nEspLin,009+nEspLarg MSGET oBcoDest VAR cBcoDest	F3 "SA6" Picture "@S3"	Valid CargaSa6(@cBcoDest,@cAgenDest,@cCtaDest,@cDescDest,.F.,,,@cNaturDes) SIZE 10, 08 														OF	oPanel PIXEL hasbutton
			@ 40+nEspLin,042+nEspLarg MSGET cAgenDest						Picture "@S5"	Valid CargaSa6(@cBcoDest,@cAgenDest,@cCtaDest,@cDescDest,.F.,,,@cNaturDes) SIZE 20, 08 														OF oPanel PIXEL
			@ 40+nEspLin,072+nEspLarg MSGET cCtaDest						Picture "@S10"	Valid IF(CargaSa6(@cBcoDest,@cAgenDest,@cCtaDest,@cDescDest,.F.,@cBenef100,.T.,@cNaturDes) .and. ;
			( cBcoDest != cBcoOrig .or. cAgenDest != cAgenOrig .or.	cCtaDest != cCtaOrig),.T.,oBcoDest:SetFocus())	SIZE 45, 08 			OF oPanel PIXEL
			@ 40+nEspLin,122+nEspLarg MSGET cNaturDes				F3 "SED"				Valid ExistCpo("SED",@cNaturDes)  .AND. FinVldNat( .F., cNaturDes, 3 ) SIZE 47, 08 													OF oPanel PIXEL hasbutton
			@ 40+nEspLin,170+nEspLarg MSGET oDesDest VAR cDescDest					Picture "@S5"	Valid CargaSa6(@cBcoDest,@cAgenDest,@cCtaDest,@cDescDest,.F.,,,@cNaturDes) SIZE 47, 08 														OF oPanel PIXEL

			//Terceiro Quadro
			@ 059+nEspLin,008+nEspLarg SAY OemToAnsi(STR0026) 		 SIZE 31, 7 OF oPanel PIXEL	// "Tipo Mov."
			@ 059+nEspLin,042+nEspLarg SAY OemToAnsi(STR0027) 		 SIZE 43, 7 OF oPanel PIXEL	// "N£mero Doc."
			@ 059+nEspLin,099+nEspLarg SAY OemToAnsi(STR0028) 		 SIZE 17, 7 OF oPanel PIXEL	// "Valor"
			@ 078+nEspLin,009+nEspLarg SAY OemToAnsi(STR0029) 		 SIZE 28, 7 OF oPanel PIXEL	// "Hist¢rico"
			@ 096+nEspLin,009+nEspLarg SAY OemToAnsi(STR0030) 		 SIZE 40, 7 OF oPanel PIXEL	// "Benefici rio"

			@ 067+nEspLin,09+nEspLarg MSGET cTipoTran				F3 "14"	Picture "!!!"	Valid (!Empty(cTipoTran) .And. ExistCpo("SX5","14"+cTipoTran)) .and. ;
			Iif(cTipoTran="CH",fa050Cheque(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran),.T.) .And. ;
			Iif(cTipoTran="CH" .or. cTipoTran="TB",fa100DocTran(cBcoOrig,cAgenOrig,cCtaOrig,cTipoTran,@cDocTran),.T.) SIZE  15, 08 OF oPanel PIXEL hasbutton
			@ 067+nEspLin,042+nEspLarg MSGET cDocTran		Picture PesqPict("SE5", "E5_NUMCHEQ")	Valid !Empty(cDocTran).and.fa100doc(cBcoOrig,cAgenOrig,cCtaOrig,cDocTran) SIZE 47, 08 				OF oPanel PIXEL
			@ 067+nEspLin,099+nEspLarg MSGET nValorTran		PicTure PesqPict("SE5","E5_VALOR",18)	Valid nValorTran > 0 .and. If(cPaisLoc=="DOM",FA100V01(nValorTran,cTipoTran),.T.)    SIZE  66, 08 	OF oPanel PIXEL hasbutton

			@ 086+nEspLin,009+nEspLarg MSGET cHist100		Picture "@S22"      							Valid !Empty(cHist100)        SIZE 155, 08 OF oPanel PIXEL

			If lSpbInUse
				@ 104+nEspLin,009+nEspLarg MSGET cBenef100		Picture "@S21"      							Valid !Empty(cBenef100)       SIZE 95, 08 OF oPanel PIXEL
				@ 096+nEspLin,108+nEspLarg SAY OemToAnsi(STR0048) 	 SIZE 31, 7 OF oPanel PIXEL //"Modalidade SPB"
				@ 104+nEspLin,108+nEspLarg MSCOMBOBOX oModSPB VAR cModSpb ITEMS aModalSpb SIZE 56, 47 OF oPanel PIXEL ;
				VALID SpbTipo("SE5",cModSpb,cTipoTran,"TR")

			Else
				@ 104+nEspLin,009+nEspLarg MSGET cBenef100		Picture "@S21"      							Valid !Empty(cBenef100)       SIZE 155, 08 OF oPanel PIXEL
			Endif

			If lPanelFin  //Chamado pelo Painel Financeiro
				aButtonTxt := {}
				If IntePMS().AND. !lPmsInt
					aTrfPms := {CriaVar("E5_PROJPMS"),CriaVar("E5_TASKPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_EDTPMS"),CriaVar("E5_TASKPMS")}
					AADD(aButtonTxt,{"Projetos","Projetos", {||F100PmsTrf(aTrfPms)}})
				Endif

				If cPaisLoc <> "BRA"
					AADD(aButtonTxt,{STR0035,STR0035, {||Fa100SetMo()}})  //  "&Tasas"
				Endif

				oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])
				ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
				{||If(FinOkDiaCTB(),nOpca:=1,nOpca:=0),oDLg:End()},{||nOpca:=0,oDlg:End()},,aButtonTxt);
				VALID (iif(nOpca==1,;
				CargaSa6(cBcoOrig,cAgenOrig,cCtaOrig,cDescOrig,.T.,,.T.) .and. ;
				ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig).and.;
				IIF(lSpbInUse,SpbTipo("SE5",cModSpb,cTipoTran,"TR"),.T.),.T.) )

				cAlias := FinWindow:cAliasFile
				dbSelectArea(cAlias)
				FinVisual(cAlias,FinWindow,(cAlias)->(Recno()),.T.)

			Else
				DEFINE SBUTTON FROM 10, 230 TYPE 1 ENABLE ACTION (If(FinOkDiaCTB(),nOpca:=1,nOpca:=0),oDLg:End()) OF oPanel
				DEFINE SBUTTON FROM 23, 230 TYPE 2 ENABLE ACTION (nOpca:=0,oDlg:End()) OF oPanel

				If FXMultSld()
					@ 60,180 BUTTON oButSel PROMPT STR0071 SIZE 26, 12 OF oPanel ACTION ( Fa340SetMo()  ) PIXEL  // "Taxas"
				EndIf

				If IntePMS().AND. !lPmsInt
					aTrfPms := {CriaVar("E5_PROJPMS"),CriaVar("E5_TASKPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_PROJPMS"),CriaVar("E5_EDTPMS"),CriaVar("E5_TASKPMS")}
					@ 36,180 BUTTON "Projetos..." SIZE 29 ,14   ACTION {||F100PmsTrf(aTrfPms)	} OF oPanel PIXEL
				EndIf

				If cPaisLoc <> "BRA"
					@ 60, 180 BUTTON OemToAnsi(STR0035) SIZE 30,15 ACTION (Fa100SetMo()) OF oPanel PIXEL   //  "&Tasas"
				Endif

				ACTIVATE MSDIALOG oDlg CENTERED VALID  (iif(nOpca==1 , ;
				CargaSa6(cBcoOrig,cAgenOrig,cCtaOrig,cDescOrig,.T.,,.T.) .and. IIf(cPaisLoc=="BRA",ValidHist(cHist100),.t.) .and.;
				ValidTran(cTipoTran,cBcoDest,cAgenDest,cCtaDest,cBenef100,cDocTran,nValorTran,cNaturOri,cNaturDes,cBcoOrig,cAgenOrig,cCtaOrig).and.;
				IIF(lSpbInUse,SpbTipo("SE5",cModSpb,cTipoTran,"TR"),.T.),.T.) )
			Endif
		Else
			//Via Execauto

			aValidGet:= {}
			If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CBCOORIG'})) > 0
				cBcoOrig	:=	PADR(aAutoCab[nPosAuto,2],TamSx3("E5_BANCO")[1])
				// 	 		Aadd(aValidGet,{'cBcoOrig' ,aAutoCab[nPosAuto,2],"CarregaSa6('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"',.F.,,,'"+cNaturOri+"')",.T.})
			EndIf

			If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CAGENORIG'})) > 0
				cAgenOrig	:=	PADR(aAutoCab[nPosAuto,2],TamSx3("E5_AGENCIA")[1])
				Aadd(aValidGet,{'cAgenOrig',aAutoCab[nPosAuto,2],"CargaSa6('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"','"+cDescOrig+"',.F.,,,'"+cNaturOri+"')",.T.})
			EndIf

			If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CCTAORIG'})) > 0
				cCtaOrig	:=	PADR(aAutoCab[nPosAuto,2],TamSx3("E5_CONTA")[1])
				Aadd(aValidGet,{'cCtaOrig',aAutoCab[nPosAuto,2],"CargaSa6('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"','"+cDescOrig+"',.F.,,,'"+cNaturOri+"')",.T.})
			EndIf

			If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CNATURORI'})) > 0
				cNaturOri	:=	aAutoCab[nPosAuto,2]
				Aadd(aValidGet,{'cNaturOri' ,aAutoCab[nPosAuto,2],"ExistCpo('SED','"+cNaturOri+"')",.T.})
			EndIf

			If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CBCODEST'})) > 0
				cBcoDest	:=	PADR(aAutoCab[nPosAuto,2],TamSx3("E5_BANCO")[1])
				Aadd(aValidGet,{'cBcoDest',aAutoCab[nPosAuto,2],"CargaSa6('"+cBcoDest+"','"+cAgenDest+"','"+cCtaDest+"','"+cDescDest+"',.F.,,,'"+cNaturDes+"')",.T.})
			EndIf

			If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CAGENDEST'})) > 0
				cAgenDest	:=	PADR(aAutoCab[nPosAuto,2],TamSx3("E5_AGENCIA")[1])
				Aadd(aValidGet,{'cAgenDest',aAutoCab[nPosAuto,2],"CargaSa6('"+cBcoDest+"','"+cAgenDest+"','"+cCtaDest+"','"+cDescDest+"',.F.,,,'"+cNaturDes+"')",.T.})
			EndIf

			If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CCTADEST'})) > 0
				cCtaDest	:=	PADR(aAutoCab[nPosAuto,2],TamSx3("E5_CONTA")[1])
				Aadd(aValidGet,{'cCtaDest',aAutoCab[nPosAuto,2],"CargaSa6('"+cBcoDest+"','"+cAgenDest+"','"+cCtaDest+;
				"','"+cDescDest+"',.F.,,,'"+cNaturDes+"') .and. ( '"+cBcoDest +"' != '"+ cBcoOrig +"' .or. '"+ cAgenDest +"' != '"+;
				cAgenOrig +"' .or. '"+ cCtaDest+"' != '"+cCtaOrig+"')",.T.})
			EndIf

			If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CNATURDES'})) > 0
				cNaturDes	:=	aAutoCab[nPosAuto,2]
				Aadd(aValidGet,{'cNaturDes' ,aAutoCab[nPosAuto,2],"ExistCpo('SED','"+cNaturDes+"')",.T.})
			EndIf

			If (nPosAuto := ascan(aAutoCab,{|x| Upper(x[1]) == 'CDOCTRAN'})) > 0
				cDocTran	:=	PADR(aAutoCab[nPosAuto,2],TamSx3("E5_NUMCHEQ")[1])
				Aadd(aValidGet,{'cDocTran' ,aAutoCab[nPosAuto,2],"'"+cDocTran+"'<> '"+Space(TamSx3('E5_NUMCHEQ')[1])+"' .and. fa100DocTran('"+cBcoOrig+"','"+cAgenOrig+"','"+cCtaOrig+"','"+cDocTran+"')",.T.})
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
			!(CargaSa6(cBcoOrig,cAgenOrig,cCtaOrig,cDescOrig,.T.,,.T.) .and. ;
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
				If ExistBlock("FA100TRF")
					lGrava := ExecBlock("FA100TRF", .F., .F., { cBcoOrig, cAgenOrig, cCtaOrig,;
					cBcoDest, cAgenDest, cCtaDest,;
					cTipoTran, cDocTran, nValorTran,;
					cHist100, cBenef100,cNaturOri,;
					cNaturDes , cModSpb, lEstorno})
				Endif

				If lF100DOC
					cDocTran := ExecBlock("F100DOC",.F.,.F.,{	cBcoOrig	, cAgenOrig	, cCtaOrig		,;
					cBcoDest	, cAgenDest	, cCtaDest		,;
					cTipoTran	, cDocTran	, nValorTran	,;
					cHist100	, cBenef100	, cNaturOri		,;
					cNaturDes 	, cModSpb	, lEstorno})
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
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Permite realizar a transferencia sendo Cartao - Bops 123731³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If IsCaixaLoja(cBcoOrig) .AND. !(IsCaixaLoja(cBcoDest)) .AND. nPosMoeda == 0 .AND. !(Alltrim(cTipoTran) $ "CC|CD")
						MsgInfo(STR0065)
					Else
						fa100grava( 	cBcoOrig	,	cAgenOrig	,	cCtaOrig	,	cNaturOri	,	;
						cBcoDest	,	cAgenDest	,	cCtaDest	,	cNaturDes	,	;
						cTipoTran	,	cDocTran	,	nValorTran	,	cHist100	,	;
						cBenef100	,				,	cModSpb		,	aTrfPms		)
					EndIf
				ENDIF
			End Transaction

			If lA100BL01
				aValores := {	cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,cBcoDest,cAgenDest,;
				cCtaDest,cNaturDes,cTipoTran,nValorTran,cDocTran,cBenef100,cHist100,cModSpb}

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

	If cPaisLoc <> "BRA" .And. Type("bFiltraBrw") == "B"
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
	Local nMoeddst	:= 0

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
	If lRet .and. cPaisLoc <> "BRA"
		nMoedaOri := MoedaBco(cBcoOrig,cAgenOrig,cCtaOrig)
		nMoedaDes := MoedaBco(cBco,cAge,cCta)
		If (Len(aTxMoedas) < nMoedaOri .Or. (nMoedaOri > 1 .And. aTxMoedas[nMoedaOri,2] == 0)) .Or.;
		(Len(aTxMoedas) < nMoedaDes .Or. (nMoedaDes > 1 .And. aTxMoedas[nMoedaDes,2] == 0))
			lRet := .F.
			Help(" ",1,'NoMoneda')
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
			Help( " ", 1, "BCOTRF",, STR0072, 1, 0 ) // "A transferência é permitida apenas para: 1- C/C origem em outra moeda para C/C destino em Real. 2- C/C origem e C/C destino com mesma moeda (Ex: US$ para US$)"
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
STATIC Function fa100grava(cBcoOrig,cAgenOrig,cCtaOrig,cNaturOri,;
	cBcoDest,cAgenDest,cCtaDest,cNaturDes,;
	cTipoTran,cDocTran,nValorTran,cHist100,;
	cBenef100,lEstorno,cModSpb,aTrfPms,nTxMoeda,nRegOrigem,nRegDestino)

	Local lPadrao1:=.F.
	Local lPadrao2:=.F.
	Local cPadrao:="560"
	Local lMostra,lAglutina
	Local lA100TR01	:= ExistBlock("A100TR01")
	Local lA100TR02	:= ExistBlock("A100TR02")
	Local lA100TR03	:= ExistBlock("A100TR03")
	Local lA100TRA	:= ExistBlock("A100TRA")
	Local lA100TRB	:= ExistBlock("A100TRB")
	Local lA100TRC	:= ExistBlock("A100TRC")
	Local nRegSEF := 0
	Local nMoedOrig   := 1
	Local nMoedTran	:=	1
	Local lSpbInUse	:= SpbInUse()
	Local cProcesso := ""
	Local aFlagCTB := {}
	Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Local lFindITF := If(cPaisLoc=="DOM" .and. Rtrim(cTipoTran)=="$",.F.,If(cPaisLoc=="DOM",If(lRetCkPG(3,,cBcoOrig),.T.,.F.),.T.) )

	Local nMBcoOri	:= 0										// Moeda da conta corrente origem
	Local nMBcoDst	:= 0										// Moeda da conta corrente destino
	Local lAtuSldNat := .T.

	Local oModelMov := NIL	//FWLoadModel("FINM030")
	Local oSubFK5
	Local oSubFK9
	Local oSubFKA
	Local cLog := ""
	Local cCamposE5 := ""
	Local lRet := .T.
	Local aAreaFKs := {}
	Local cProcFKs := ""

	lEstorno := IIF (lEstorno == NIL , .F., lEstorno)

	dbSelectarea("SE5")
	cProcesso	:= IIf(cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN",IIf(!lEstorno,GetSx8Num("SE5","E5_PROCTRA","E5_PROCTRA"+cEmpAnt),SE5->E5_PROCTRA),"")
	ConfirmSx8()
	dbSelectarea("SEF")

	DEFAULT aTrfPms	:= {}
	DEFAULT nTxMoeda	:= 0
	DEFAULT lExterno  := .F.
	DEFAULT nRegOrigem := 0
	DEFAULT nRegDestino := 0

	//ITF não se aplica ao Brasil
	If cPaisLoc == "BRA"
		lFindITF := .F.
	Endif

	STRLCTPAD := " "
	If !(Empty(cBcoDest+cAgenDest+cCtaDest)) .and. lEstorno
		dbSelectArea( "SA6" )
		dbSeek( xfilial("SA6")+ cBcoDest + cAgenDest + cCtaDest )

		nMBcoDst	:= SA6->A6_MOEDA
	ENDIF

	If !(Empty(cBcoOrig+cAgenOrig+cCtaOrig))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atencao!, neste programa sera' utilizado 2 lan‡amentos padroni³
		//³ zados, pois o mesmo gera 2 registros na movimentacao bancaria³
		//³ O 1. registro para a saida  (Banco Origem ) ->Padrao "560"   ³
		//³ O 2. registro para a entrada(Banco Destino) ->Padrao "561"   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc	# "BRA"
			dbSelectArea( "SA6" )
			dbSeek( xFilial("SA6") + cBcoDest + cAgenDest + cCtaDest )
			nMoedTran	:=	MAX(SA6->A6_MOEDA,1)
		Endif
		dbSelectArea( "SA6" )
		dbSeek(  xFilial("SA6") + cBcoOrig + cAgenOrig + cCtaOrig )

		nMBcoOri	:= SA6->A6_MOEDA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza movimentacao bancaria c/referencia a saida			  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
		cCamposE5 := "{"
		cCamposE5 += "{'E5_DTDIGIT', dDataBase}"
		cCamposE5 += ",{'E5_BENEF', '" + cBenef100 + "'}"
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
			If nMBcoDst > nMBcoOri  .and. lEstorno
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
		oSubFK5:SetValue( "FK5_DTDISP", dDataBase )
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

			If !lF100Auto  //Se não for rotina automatica
				Help( ,,"MF100GRV1",,cLog, 1, 0 )
			Endif
		Endif

		oModelMov:DeActivate()
		oModelMov:Destroy()
		oModelMov:NIL

		If lAtuSldNat .And. cNaturOri <> cNaturDes
			AtuSldNat(SE5->E5_NATUREZ, SE5->E5_DATA, "01", "3", "P", SE5->E5_VALOR,, If(lEstorno,"-","+"),,FunName(),"SE5", SE5->(Recno()),0)
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

			oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
			oModelMov:Activate()
			oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //habilita gravação de SE5

			//Posiciona a FKA com base no IDORIG da SE5 posicionada
			oSubFKA := oModelMov:GetModel( "FKADETAIL" )
			If oSubFKA:SeekLine( { {"FKA_FILIAL", SE5->E5_FILIAL },{"FKA_IDORIG", SE5->E5_IDORIG } } )

				//Dados de integrações
				oSubFK9 := oModelMov:GetModel( "FK9DETAIL" )
				oSubFK9:SetValue( "FK9_PRJPMS", cId )

				If oModelMov:VldData()
					oModelMov:CommitData()
				Else
					lRet := .F.
					cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
					cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
					cLog += cValToChar(oModelMov:GetErrorMessage()[6])

					If !lF100Auto
						Help( ,,"MF100GRV2",,cLog, 1, 0 )
					Endif
				Endif
			Endif
			oModelMov:DeActivate()
			oModelMov:Destroy()
			oModelMov:NIL

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

							If !lF100Auto  //Se não for rotina automatica
								Help( ,,"MF100GRV3",,cLog, 1, 0 )
							Endif
						Endif
					Endif
					oModelMov:DeActivate()
					oModelMov:Destroy()
					oModelMov:NIL

				Endif
				if lEstorno // caso que sea retorno no debe hacer ITF Nahim 06/09/2019
					alert("lEstorno cBcoOrig: "+ cBcoOrig +"  RECNO: " + cvaltochar(SE5->(Recno())) )
					If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .AND. lRetCkPG(3,,cBcoOrig)//(lRetCkPG(3,,cBcoOrig) .or. lRetCkPG(3,,cBcoDest) )//.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF C/ CONTABILIZACAO Nahim Terrazas
						ALERT("entra cBcoOrig")
						FinProcITF( SE5->( Recno() ),5,, .F.,{ nHdlPrv, "", "", "FINA100", cLote } , @aFlagCTB )
					EndIf
				else
					If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .AND. lRetCkPG(3,,cBcoOrig) //.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF C/ CONTABILIZACAO Nahim Terrazas
						FinProcITF( SE5->( Recno() ),3,, .F.,{ nHdlPrv, "", "", "FINA100", cLote } , @aFlagCTB )
					EndIf
				endif
			Else
			alert("ELSE")
				If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .AND. lRetCkPG(3,,cBcoOrig) //.and. (lRetCkPG(3,,cBcoOrig) <> lRetCkPG(3,,cBcoDest)) //GERA ITF S/ CONTABILIZACAO Nahim Terrazas
					FinProcITF( SE5->( Recno() ),3,, .F. )
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
			//³ Conforme situação do parâmetro abaixo, integra com o SIGAGSP ³
			//³             MV_SIGAGSP - 0-Não / 1-Integra                   ³
			//³ e-mail de Fernando Mazzarolo de 08/11/2004                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
			If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
				// Inclusão de FindFunction pois a rotina nao foi encontrada
				// no repositorio.
				If FindFunction("GSPF380")
					GSPF380(3)
				EndIf
			EndIf
		Endif
	Endif
	cNumeE5_PROCTRA := SE5->E5_PROCTRA// Nahim Terrazas 05/02/2019 - tomo porque para hacer la reversión no lo encuentra debido a que el ITF lo toma prorrateado
	If !(Empty(cBcoDest+cAgenDest+cCtaDest))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza movimentacao bancaria c/referencia a entrada		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( "SA6" )
		dbSeek( xfilial("SA6")+ cBcoDest + cAgenDest + cCtaDest )

		nMBcoDst	:= SA6->A6_MOEDA

		//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
		cCamposE5 := "{"
		cCamposE5 += "{'E5_DTDIGIT', dDataBase}"
		cCamposE5 += ",{'E5_BENEF', '" + cBenef100 + "'}"
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

		oSubFK5:SetValue( "FK5_DTDISP", dDataBase )
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

			If !lF100Auto  //Se não for rotina automatica
				Help( ,,"MF100GRV4",,cLog, 1, 0 )
			Endif
		Endif
		oModelMov:DeActivate()
		oModelMov:Destroy()
		oModelMov:NIL

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

			oModelMov := FWLoadModel("FINM030") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
			oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
			oModelMov:Activate()
			oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //habilita gravação de SE5

			//Posiciona a FKA com base no IDORIG da SE5 posicionada
			oSubFKA := oModelMov:GetModel( "FKADETAIL" )
			oSubFKA:SeekLine( { {"FKA_FILIAL", SE5->E5_FILIAL },{"FKA_IDORIG", SE5->E5_IDORIG } } )

			//Dados de integração
			oSubFK9 := oModelMov:GetModel("FK9DETAIL")
			oSubFK9:SetValue( "FK9_PRJPMS", cId )

			If oModelMov:VldData()
				oModelMov:CommitData()
			Else
				lRet := .F.
				cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[6])

				If !lF100Auto
					Help( ,,"MF100GRV5",,cLog, 1, 0 )
				Endif
			Endif
			oModelMov:DeActivate()
			oModelMov:Destroy()
			oModelMov:NIL

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

		If lAtuSldNat .And. cNaturOri <> cNaturDes
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
			cPadrao :="561"
			lPadrao2 := VerPadrao(cPadrao)
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
				alert("lEstorno cBcoDest: "+ cBcoDest +"  RECNO: " + cvaltochar(SE5->(Recno())) )
					If lFindITF .And. FinProcITF( SE5->( Recno() ),1 )  .and.  lRetCkPG(3,,cBcoDest) //GERA ITF C/ CONTABILIZACAO Nahim Terrazas 30/04/2019
						alert("entra cBcoDest")
						FinProcITF( SE5->( Recno() ),5,, .F.,{ nHdlPrv, "", "", "FINA100", cLote } , @aFlagCTB )
					EndIf
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
				alert("ELSE 2")
				If lFindITF .And. FinProcITF( SE5->( Recno() ),1 ) .and. !(lRetCkPG(3,,cBcoOrig)) .and.  lRetCkPG(3,,cBcoDest)
					FinProcITF( SE5->( Recno() ),3,, .F. )
				EndIf
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-Ä¿
			//³ Conforme situação do parâmetro abaixo, integra com o SIGAGSP ³
			//³             MV_SIGAGSP - 0-Não / 1-Integra                   ³
			//³ e-mail de Fernando Mazzarolo de 08/11/2004                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ-ÄÄÙ
			If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
				// Inclusão de FindFunction pois a rotina nao foi encontrada
				// no repositorio.
				If FindFunction("GSPF380")
					GSPF380(4)
				EndIf
			EndIf
		Endif
	Endif

	If lA100TR03
		ExecBlock("A100TR03",.F.,.F.,lEstorno)
	EndIf
	If lA100TRC
		ExecBlock("A100TRC",.F.,.F.,{lEstorno, cBcoOrig,  cBcoDest,  cAgenOrig, cAgenDest, cCtaOrig,;
		cCtaDest, cNaturOri, cNaturDes, cDocTran,  cHist100})
	EndIf

	IF !lExterno .and. lPadrao2 .and. mv_par04 == 1  // On Line

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

				If !lF100Auto  //Se não for rotina automatica
					Help( ,,"MF100GRV6",,cLog, 1, 0 )
				Endif
			Endif
		Endif
		oModelMov:DeActivate()
		oModelMov:Destroy()
		oModelMov:NIL

	EndIf

	If cPaisLoc $ "ANG|ARG|AUS|BOL|BRA|CHI|COL|COS|DOM|EQU|EUA|HAI|MEX|PAD|PAN|PAR|PER|POR|PTG|SAL|URU|VEN"

		if !lEstorno // Nahim Terrazas 05/02/2019
			SE5->E5_PROCTRA := cNumeE5_PROCTRA	// Nahim Terrazas 05/02/2019
		endif // Nahim Terrazas 05/02/2019

		If Len(Alltrim(SE5->E5_ProcTra)) > 0
			PutMV("MV_NPROC",SE5->E5_ProcTra)
		Endif
	Endif

Return /*Function fa100grava*/

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
user FUNCTION xFa100Est(aAutoCab)

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
	carregaPerg()
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
	//E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ
	//	alert("fUERA")
	If MSSeek( xFilial("SE5")+"TR"+Space(nTamTit)+DTOS(mv_par02))
		//	alert("ENTRA")
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
			SE5->E5_DOCUMEN
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
	While !SE5->(Eof()) .and. SE5->(E5_FILIAL+E5_Proctra) == xFilial("SE5")+cProctra
		If E5_TIPODOC = "TE"
			lEstornado := .T.
			EXIT
		Endif
		dbSkip()
	EndDo

	RestArea(aArea)

Return lEstornado

static function carregaPerg()
	cPerg:="FA100E"
	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg+Space(4)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := SE5->E5_NUMCHEQ
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPerg+Space(4)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  DTOS(SE5->E5_DATA)
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SE5->E5_BANCO
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SE5->E5_AGENCIA
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'05'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  SE5->E5_CONTA
		SX1->(MsUnlock())
	END
return

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