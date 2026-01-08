#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE 'OrdPag.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ FINR085A º Autor ³ Jose Novaes Romeu  º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao da Ordem de Pagamento                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Localizacoes                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ORDPAG()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cDesc1		:= OemToAnsi(STR0001)  //Este programa imprime as Ordens de Pagamento
	Local cDesc2		:= ""
	Local cDesc3		:= ""
	Local wnrel			:= "ORDPAG"
	Local cString		:= "SEK"
	Local cPerg			:= "FIR85A"
	Local cChave        := ""
	Local lAgregSEK	    := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento para chamada do modulo SIGACTB(Relacionamentos-CTL)³
	//³ atraves da rotina de Rastreamento de Lancamento(CTBC010).     ³
	//³ Pelo cadastro de Relacionamento pode ser configurada a chamada³
	//³ desta rotina, atraves do campo CTL_EXECUT, com a finalidade de³
	//³ rastreamento dos lancamentos contabeis                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lRastroCTB    := AllTrim(ProcName(1)) == "CTBORDPAGO"
	Local cQuery, aStru, nLoop, cFiltro, cIndice, nIndex
	Private tamanho		:= "P"
	Private limite		:= 80
	Private titulo		:= "Pago a Proveedores"
	Private aReturn		:= { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 2, 2,1,"",1 }  //Zebrado#Administracao
	Private nomeprog	:= "ORDPAG"
	Private nTipo		:= 18
	Private nLastKey	:= 0
	Private m_pag		:= 1
	Private lEnd		:= .F.
	Private cArqTrab

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                        ³
	//³ mv_par01			// Data De                              ³
	//³ mv_par02			// Data Ate                             ³
	//³ mv_par03			// De  PO                               ³
	//³ mv_par04			// Ate PO                               ³
	//³ mv_par05			// Fornecedor De                        ³
	//³ mv_par06			// Fornecedor Ate                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRastroCTB
		wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,tamanho,"",.T.)
	Else
		wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,"",.T.,tamanho,"",.T.)
	EndIf

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preparacao do arquivo de trabalho                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cString)
	dbSetOrder(3)

	lAgregSEK	:= .T.

	If lRastroCTB .And. !Empty(CTL->CTL_KEY)
		cChave    := &(CTL->CTL_KEY)
		mv_par01  := CTK->CTK_DATA
		mv_par02  := CTK->CTK_DATA
		mv_par03  := Substr(cChave,3,TamSX3("EK_ORDPAGO")[1])
		mv_par04  := Substr(cChave,3,TamSX3("EK_ORDPAGO")[1])
		mv_par05  := ""
		mv_par06  := "ZZZZZZ"

	EndIf

	#IFDEF TOP
	aStru := (cString)->(dbStruct())
	dbCloseArea()
	dbSelectArea("SA2") //Este comando eh necessario. Nao apague!!!!

	cQuery := "SELECT * FROM " + RetSQLname(cString)
	cQuery += " WHERE D_E_L_E_T_ <> '*'"
	cQuery += " AND EK_FILIAL  = '"  + xFilial(cString) + "'"
	cQuery += " AND EK_EMISSAO BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "'"
	cQuery += " AND EK_ORDPAGO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
	If !lAgregSEK
		cQuery += " AND EK_FORNECE BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "'"
	EndIf
	/*If !lRastroCTB
	cQuery += " AND EK_CANCEL <> 'T'"
	EndIf*/
	cQuery := ChangeQuery(cQuery)

	//aviso("",cQuery,{'ok'},,,,,.t.)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cString, .F., .T.)

	For nLoop := 1 to Len(aStru)
		If aStru[nLoop,2] <> "C"
			TCSetField(cString, aStru[nLoop,1], aStru[nLoop,2],;
			aStru[nLoop,3], aStru[nLoop,4])
		Endif
	Next

	dbSelectArea(cString)
	#ELSE
	cArqTrab	:= Criatrab(NIL,.F.)
	cFiltro		:= 'EK_FILIAL == "'+xFilial(cString)+'" .AND. '
	cFiltro		+= 'DTOS(EK_DTDIGIT) >= "'+DTOS(mv_par01)+'" .AND. DTOS(EK_DTDIGIT) <= "'+DTOS(mv_par02)+'" .AND.'
	cFiltro		+= 'EK_ORDPAGO >= "'+mv_par03+'" .AND. EK_ORDPAGO <= "'+mv_par04+'"'
	If !lAgregSEK
		cFiltro		+= ' .AND. EK_FORNECE >= "'+mv_par05+'" .AND. EK_FORNECE <= "'+mv_par06+'"'
	EndIf
	/*If !lRastroCTB
	cFiltro		+= ' .AND. !(EK_CANCEL)'
	EndIf*/
	cIndice		:= Indexkey()
	cIndice		:= Right(cIndice,Len(cIndice)-10)
	IndRegua(cString,cArqTrab,cIndice,,cFiltro,OemToAnsi(STR0005))  //Selecionando Registros...
	dbCommit()
	nIndex		:= RetIndex(cString)
	dbSelectArea(cString)
	dbSetIndex(cArqTrab+OrdBagExt())
	dbSetOrder(nIndex+1)
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus({|lEnd| Fa085Imp(@lEnd,wnrel,cString,lAgregSEK,lRastroCTB) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ Fa085Imp º Autor ³ Jose Novaes Romeu  º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Impressao dos detalhes do relatorio.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ORDPAG()                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa085Imp(lEnd,wnrel,cString,lAgregSEK,lRastroCTB)

	Local nLin		:= 80
	Local cbCont	:= 0
	Local cbTxt		:= Space(10)
	Local Cabec1 := Cabec2 := ""
	Local cFornece, cLoja, cOrdPago, dDtBaixa, nBaixa, nTotal,_cUsuario,_dFecha,_cHora,lEsta
	Local nBaixaMd1, nTotMd1, i, aTasas, nValorMd1
	Local aPaApl, aNFs, aChqPr, aChqTer, aPaGer, aRets,aDesp
	Local lCabec      := .F.
	Local aSX3Box
	//Local cUsuario := ""
	Local lCancelado  := .F.
	If cPaisLoc == "PTG"
		aSx3Box 	:= RetSx3Box( Posicione("SX3", 2, "EK_TPDESP", "X3CBox()" ),,, 1 )
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())

	dbGotop()

	While !Eof()

		IncRegua()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lEnd
			@Prow()+1,00 PSAY OemToAnsi(STR0006)  //CANCELADO PELO OPERADOR
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento de OP agrupada por Fornecedor³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAgregSEK .And. !Empty(EK_FORNEPG)
			If EK_FORNEPG < mv_par05 .or. EK_FORNEPG > mv_par06
				DbSkip()
				Loop
			EndIf
			cFornece	:= EK_FORNEPG
			cLoja		:= EK_LOJAPG
		Else
			cFornece	:= EK_FORNECE
			cLoja		:= EK_LOJA
		EndIf

		cOrdPago	:= EK_ORDPAGO
		dDtBaixa	:= EK_DTDIGIT
		aPaApl		:= {}
		aNFs		:= {}
		aChqPr		:= {}
		aChqTer		:= {}
		aPaGer		:= {}
		aDesp			:= {}
		aRets		:= {}
		nTotal		:= 0.00
		nTotMd1		:= 0.00
		lCabec      := .F.
		lCancelado  := EK_CANCEL
		nTotPagar := 0

		While !Eof() .and. EK_ORDPAGO == cOrdPago
			If EK_TIPODOC == "TB"
				If EK_TIPO $ MVPAGANT + "/" + MV_CPNEG
					Aadd(aPaApl,{EK_NUM,EK_VALOR,EK_MOEDA,EK_EMISSAO,EK_VLMOED1})
				Else
					nBaixa		:= EK_VALOR
					//alert(nBaixa)
					nTotal		+= nBaixa
					nBaixaMd1	:= IIf(EK_MOEDA=="1",nBaixa,xMoeda(nBaixa,Val(EK_MOEDA),1,dDtBaixa))
					nTotMd1		+= nBaixaMd1
					Aadd(aNfs,{EK_PREFIXO,EK_NUM,EK_PARCELA,nBaixa,EK_MOEDA,EK_VENCTO,nBaixaMd1,SEK->(FieldPos('EK_CANPARC')) > 0 .And.!Empty(SEK->EK_CANPARC)})
				Endif
			ElseIf EK_TIPODOC == "CP"
				nPago		:= EK_VALOR
				nTotal		+= nPago
				nPagoMoe	:= IIf(EK_MOEDA=="1",nPago,xMoeda(nPago,Val(EK_MOEDA),1,dDtBaixa))
				nTotPagar		+= nPagoMoe

				Aadd(aChqPr  ,{EK_TIPO,EK_NUM,EK_VALOR,EK_MOEDA,EK_BANCO,EK_AGENCIA,EK_CONTA,EK_VENCTO})
			ElseIf EK_TIPODOC == "CT"
				Aadd(aChqTer ,{EK_NUM,EK_VALOR,EK_MOEDA,EK_BANCO,EK_AGENCIA,EK_CONTA,EK_ENTRCLI,EK_LOJCLI,;
				EK_VLMOED1})
			ElseIf EK_TIPODOC == "PA"
				Aadd(aPaGer  ,{EK_NUM,EK_VALOR,EK_MOEDA})
			ElseIf EK_TIPODOC == "DE"
				If (nPosDesp	:=	Ascan(aSX3BOX,{|x| x[2]== EK_TPDESP})) >0
					Aadd(aDesp   ,{aSX3Box[nPosDesp,3],EK_VALOR,EK_MOEDA})
				Else
					Aadd(aDesp   ,{STR0030,EK_VALOR,EK_MOEDA})
				Endif
			EndIf

			DbSkip()
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Acumular retencoes                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc != "CHI"
			dbSelectArea("SFE")
			dbSetOrder(2)
			dbSeek(xFilial("SFE")+cOrdPago)
			While !Eof() .And. FE_ORDPAGO == cOrdPago
				If FE_RETENC > 0
					nPosRet  := Ascan(aRets,{|X| X[1]+X[3]==FE_NROCERT+FE_TIPO})
					If nPosRet ==  0
						Aadd(aRets,{FE_NROCERT,FE_RETENC,FE_TIPO})
					Else
						aRets[nPosRet][2]:=aRets[nPosRet][2]+FE_RETENC
					EndIf
				EndIf
				dbSkip()
			EndDo
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona fornecedor                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2") + cFornece + cLoja )

		If nTotal > 0
			lCabec  := .T.

			Cabec85A(cOrdpago,@nLin,Cabec1,Cabec2,dDtBaixa,lCancelado)

			nLin ++
			@ nLin, 000 PSAY OemToAnsi(STR0009)  //ORDEM DE PAGAMENTO DOS SEGUINTES DOCUMENTOS:
			nLin ++
			@ nLin, 000 PSAY Subs(OemToAnsi(STR0010)+Getmv("MV_MOEDAP1"),1,limite) //PRE/NUMERO       /PAR           VALOR PAGO  MDA   EMISSAO     VALOR EM
			For i := 1 to Len(aNfs)
				nLin ++
				@ nLin, 000 PSAY aNfs[i][1]
				@ nLin, 004 PSAY aNfs[i][2]
				@ nLin, 018 PSAY aNfs[i][3]
				@ nLin, 024 PSAY aNfs[i][4]	PICTURE PesqPict("SEK","EK_VALOR")
				@ nLin, 045 PSAY GETMV("MV_SIMB"+ STR(val(aNfs[i][5]),1))
				@ nLin, 049 PSAY aNfs[i][6]
				If aNfs[i][8]
					@ nLin, 062 PSAY STR0029
				Else
					@ nLin, 062 PSAY aNfs[i][7]	PICTURE PesqPict("SEK","EK_VLMOED1")
				Endif
				If nLin > 46
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				EndIf
			Next
			nLin ++
			If Len(aRets) > 0
				For i:= 1 to Len(aRets)
					nLin ++
					If cPaisLoc == "ARG"
						cTipoRet:=IIf(aRets[i][3]=="G",OemToAnsi(STR0011),Iif(aRets[i][3]=="B",OemToAnsi(STR0012),Iif(aRets[i][3]=="S",OemToAnsi(STR0027),OemToAnsi(STR0013))))  //LUCROS#ENT. BR.#I.V.A.#S.U.S.S.
					ElseIf cPaisLoc$"URU|BOL"
						cTipoRet:=OemToAnsi(STR0026)
					ElseIf cPaisLoc = "PTG"
						cTipoRet:=Iif(aRets[i][3]=="R",OemToAnsi('I.R.C.'),OemToAnsi(STR0013))
					EndIf
					@ nLin,000 PSAY OemToAnsi(STR0014)+cTipoRet+OemToAnsi(STR0015)+aRets[i][1]  //EMITIDO CERTIFICADO DE RETENCAO DE # NR
					@ nLin,062 PSAY (aRets[i][2] * - 1 ) PICTURE Pesqpict("SFE","FE_RETENC")
					If nLin > 46
						nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
					EndIf
				Next
				nLin++
			EndIf
		EndIf
		//Impressao do cabecalho qdo OP nao tem titulos baixados(nTotal=0). Situacao: geracao de PA
		If !lCabec
			Cabec85A(cOrdpago,@nLin,Cabec1,Cabec2,dDtBaixa,lCancelado)
		EndIf
		If Len(aPaApl) > 0
			nLin ++
			@ nLin, 000 PSAY OemToAnsi(STR0016)  //DESCONTADOS OS SEGUINTES ADIANTAMENTOS/CREDITOS:
			nLin ++
			@ nLin, 000 PSAY Subs(OemToAnsi(STR0017)+Getmv("MV_MOEDAP1"),1,limite)  //NUMERO                          VALOR PAGO  MDA   EMISSAO     VALOR EM
			For i := 1 to Len(aPaApl)
				nLin ++
				@ nLin,000 PSAY aPaApl[i][1]
				@ nLin,024 PSAY (aPaApl[i][2]* -1) PICTURE PesqPict("SEK","EK_VALOR")
				@ nLin,045 PSAY aPaApl[i][3]
				@ nLin,049 PSAY aPaApl[i][4]
				@ nLin,062 PSAY GETMV("MV_SIMB"+ aPaApl[i][3]) //(aPaApl[i][5]* -1) PICTURE PesqPict("SEK","EK_VLMOED1")
				If nLin > 46
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				EndIf
				nTotal	-= aPaApl[i][2]
				nTotMd1	-= aPaApl[i][5]
			Next
			nLin ++
		EndIf
		If len(aDesp) > 0
			nLin ++
			@ nLin,000 PSAY OemToAnsi(STR0031) //"DESPESAS DO PAGAMENTO : "
			nLin ++
			@ nLin,000 PSAY OemToAnsi(STR0032) //"TIPO DE DESPESA           VALOR PAGO  MDA "
			For i:=1  to LEN(aDesp)
				nLin ++
				@nLin,000 PSAY aDesp[i][1]
				@nLin,018 PSAY aDesp[i][2] PICTURE Pesqpict("SEK","EK_VALOR")
				@nLin,039 PSAY GETMV("MV_SIMB"+ aDesp[i][3])
				If nLin > 46
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				EndIf
			Next
			nLin ++
		Endif
		If len(aChqPr) > 0
			nLin ++
			@ nLin,000 PSAY OemToAnsi(STR0018)  //NO SEGUINTE DETALHE (CHEQUES-EFETIVO-TRANSFERENCIAS):
			nLin ++
			@ nLin,000 PSAY OemToAnsi(STR0019)  //PRE/NUMERO                VALOR PAGO  MDA  BCO  AGENCIA  CONTA          VENCTO
			For i:=1  to LEN(aChqPr)
				nLin ++
				@nLin,000 PSAY aChqPr[i][1]
				@nLin,004 PSAY aChqPr[i][2]
				@nLin,020 PSAY aChqPr[i][3] PICTURE Pesqpict("SEK","EK_VALOR")
				@nLin,041 PSAY GETMV("MV_SIMB"+ aChqPr[i][4])
				@nLin,045 PSAY aChqPr[i][5]
				@nLin,051 PSAY aChqPr[i][6]
				@nLin,059 PSAY aChqPr[i][7]
				@nLin,071 PSAY aChqPr[i][8]
				If nLin > 46
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				EndIf
			Next
			nLin ++
		Endif
		If len(aChqTer) > 0
			nLin ++
			If cPaisLoc <> "PTG"
				@ nLin,000 PSAY OemToAnsi(STR0020)  //CHEQUES DE TERCEIROS ENTREGUES:
			Else
				@ nLin,000 PSAY OemToAnsi(STR0033) //"Titulos a receber compensados"
			Endif
			nLin ++
			@ nLin,000 PSAY OemToAnsi(STR0021)  //PRE/NUMERO                VALOR PAGO  MDA  BCO  AGENCIA  CONTA          VENCTO
			For i:=1  to LEN(aChqTer)
				nLin ++
				@ nLin,000 PSAY aChqTer[i][1]
				@ nLin,014 PSAY aChqTer[i][2] PICTURE Pesqpict("SEK","EK_VALOR")
				@ nLin,036 PSAY GETMV("MV_SIMB"+ aChqTer[i][3])
				@ nLin,041 PSAY aChqTer[i][4]
				@ nLin,047 PSAY aChqTer[i][5]
				@ nLin,057 PSAY aChqTer[i][6]
				@ nLin,071 PSAY aChqTer[i][7]+"-"+aChqTer[i][8]
				If nLin > 46
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				EndIf
			Next
			nLin ++
		Endif
		If Len(aPaGer) > 0
			nLin ++
			@ nLin,000 PSAY OemToAnsi(STR0022)  //POR VERBA DE PAGAMENTO ANTECIPADO DE TITULOS:
			nLin ++
			@ nLin,000 PSAY OemToAnsi(STR0023)  //NUMERO                VALOR PAGO   MDA
			For i := 1 To Len(aPaGer)
				nLin ++
				@ nLin,000 PSAY aPaGer[i][1]
				@ nLin,014 PSAY aPaGer[i][2] PICTURE Pesqpict("SEK","EK_VALOR")
				@ nLin,036 PSAY GETMV("MV_SIMB"+ aPaGer[i][3])
				If nLin > 46
					nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
				EndIf
			Next
			nLin ++
		EndIf
		nLin := 50
		@ nLin,000		PSAY OemToAnsi(STR0024)+Alltrim(GetMv("MV_MOEDAP1"))+" : "  //TOTAL EM
		@ nLin,PCOL()+1	PSAY nTotPagar PICTURE Pesqpict("SEK","EK_VALOR")
		nLin ++
		@ nLin,000 PSAY REPLICATE("_",limite)
		If !(cPaisLoc $ "POR|EUA")
			aTasas := {}
			For i := 1  To ContaMoeda()
				Aadd(aTasas,IIf(RecMoeda(dDtBaixa,StrZero(i,1))==0,1,RecMoeda(dDtBaixa,StrZero(i,1))))
			Next
			If Len(aTasas) > 0
				nLin ++
				@ nLin,000 PSAY OemToAnsi(STR0025)+ Dtoc(SM2->M2_DATA) + " => "  //TAXAS EM
				For i:=2  to Len(aTasas)
					If i < 4
						@ nLin,IIf(i==2,25,55) PSAY Alltrim(GetMv("MV_MOEDA"+STR(i,1)))+" : "+Transform(aTasas[i],"99,999.9999")
					Else
						nLin := IIf(i==4,nLin+1,nLin)
						@ nLin,IIf(i==4,25,55) PSAY Alltrim(GetMv("MV_MOEDA"+STR(i,1)))+" : "+Transform(aTasas[i],"99,999.9999")
					Endif
				Next
			EndIf
		Endif

		nLin:=nLin+2
		//"01234567890123456790123456790123456790123456790123456790123456790123456790123456790123456790
		//           10       20       30       40       50       60       70       80       90       100
		@nLin,01 PSAY "------------------  -----------------  ----------------  -----------------"
		nLin:=nLin +  1
		@nLin,01 PSAY "  Elaborado Por       Autorizado Por         VoBo          Recibido Por "
		nLin:=nLin +  1
		@ nLin,000 PSAY REPLICATE("_",limite)
		nLin:=nLin +  1
		//@nLin,01 PSAY _cUsuario + "                                                  "+ DTOC(_dFecha) + " " + _cHora

		//	nLin:=nLin +  1
		//	@nLin,01 PSAY "                                                                 C.I:"

		dbSelectArea(cString)
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o rodape                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//IIf(nLin < 80, 	Roda(cbcont,cbtxt,tamanho),.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga indice ou consulta(Query)                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cString)
	dbCloseArea()
	#IFDEF TOP
	ChkFile(cString)
	#ELSE
	Ferase(cArqTrab+OrdBagExt())
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SET DEVICE TO SCREEN

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CABEC85A  ºAutor  ³ Jose Novaes Romeu  º Data ³  12/06/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao de cabecalho personalizado.                      º±±
±±º          ³ Para manter compatibilidade com o que ja existe.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TER031                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cabec85A(cOrdpago,nLin,Cabec1,Cabec2,dDtBaixa,lEst)
	local _cArea:=GetArea()

	nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1

	@ nLin,000 PSAY SM0->M0_NOMECOM

	@ nLin,030 PSAY OemToAnsi(STR0007) + cOrdPago + IIF(lEst," - DOC. ANULADO","")  //"ORDEM DE PGTO NR "
	nLin ++
	@ nLin,000 PSAY SM0->M0_ENDCOB
	@ nLin,070 PSAY	dDtbaixa
	nLin ++
	@ nLin,000 PSAY SM0->M0_CIDCOB
	nLin += 2
	@ nLin,000 PSAY OemToAnsi(STR0008) + SA2->A2_COD + " - " + SA2->A2_NOME  //"BENEFICIARIO: "
	nLin ++

	_cHist:=Posicione('SE2',8,XFILIAL('SE2')+cOrdPago,'E2_HIST')
	If !Empty(_cHist)
		@ nLin,000 PSAY _cHist
		nLin ++
	EndIf
	@ nLin,000 PSAY REPLICATE("_",limite)
	nLin ++

	RestArea(_cArea)
Return
