#Include 'Protheus.ch'
#INCLUDE "FINR565.CH"
#DEFINE NEGRITO chr(27)+ chr(69)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RepCch  ³ Autor ³ TdeP Horeb SRL  	    ³ Data ³ 28/03/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de Reposición de Caja Chica					        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ BOLIVIA                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RepCch()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL cDesc1 := STR0001 //"Este relatorio ir  imprimir o recibo de adiantamentos"
	LOCAL cDesc2 := STR0002 //"ou despesas efetuadas no Caixinha"
	LOCAL cDesc3 := ""
	LOCAL wnrel
	LOCAL cString:="SEU"
	LOCAL Tamanho := "P"

	PRIVATE titulo := STR0003 //"Recibo de Despesas ou Adiantamento do Caixinha"
	PRIVATE cabec1
	PRIVATE cabec2
	PRIVATE aReturn := {STR0004, 1,STR0005, 2, 2, 1, "",1 } //"Zebrado"###"Administracao"
	PRIVATE aLinha  := { },nLastKey := 0
	PRIVATE cPerg   := "REP010"
	PRIVATE lMenu := .T.   //Controla se o relatorio foi chamado do menu ou da rotina de caixinha
	PRIVATE nomeprog:= "RepCch"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                        ³
	//³ mv_par01            // Caixa De		                         ³
	//³ mv_par02            // Caixa Ate                            ³
	//³ mv_par03            // Data De                              ³
	//³ mv_par04            // Data Ate                             ³
	//³ mv_par05            // Numero do Documento De               ³
	//³ mv_par06            // Numero do Documento Ate              ³
	//³ mv_par07            // Recibos Por Pagina (1 ou 2)          ³
	//³ mv_par08            // Emissao/Reemissão/Todos			       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RepPerg()
	pergunte("REP010",.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := "RepCch"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,Tamanho,"",IIf(lMenu,.T.,.F.))

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif
	RptStatus({|lEnd| Fa565Imp(@lEnd,wnRel,cString)},titulo)

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³ FA565Imp ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 25.04.02 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Relatorio de Recibo de Adiantamentos do Caixinha	        ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ FA565Imp(lEnd,wnRel,cString)                               ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
	±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
	±±³          ³ cString - Mensagem                                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Generico                                                   ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA565Imp(lEnd,wnRel,cString)

	LOCAL CbCont
	LOCAL CbTxt

	LOCAL cChave
	Local cExtenso:= ""
	Local cExt1 := ""
	Local cExt2 := ""
	Local nTamData := 8
	Local cMoeda := GetMv("MV_SIMB1")
	Local aAreaSEU := SEU->(GetArea())
	Local lRecFirst := .T.  //Controla se estou imprimindo o primeiro ou o segundo recibo
	Local aRecno := {}
	Local nX

	#IFDEF TOP
		Local nI := 0
		Local aStru := {}
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt 	:= SPACE(10)
	cbcont	:= 0
	li 		:= 80
	m_pag 	:= 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtragem dos recibos a serem impressos. Apenas se relatorio ³
	//³ for chamado do Menu														  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//dbSelectArea("SEU")
	dbCloseArea()

	cQuery := ""
	cQuery := "SELECT *"
	cQuery += " FROM " + RetSqlName("SEU") + " SEU"
	cQuery += " WHERE EU_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery += " AND EU_NUM BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
	cQuery += " AND EU_DTDIGIT BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "'"
	cQuery += " AND EU_TIPO ='10'"
	cQuery += " AND D_E_L_E_T_ <> '*'"
	cQuery += " ORDER BY EU_NUM DESC"
	memowrite("test.txt",cQuery)
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SEU', .F., .T.)

	//aviso("",cQuery,{'ok'},,,,,.t.)

	SetRegua(RecCount())
	fr565Param()  // Imprime folha de parametos se foi chamado do menu

	While !Eof()

		IF lEnd
			@Prow()+1,001 PSAY OemToAnsi(STR0007) //"CANCELADO PELO OPERADOR"
			Exit
		EndIF

		IncRegua()
		li := 00
		/*If lMenu
			If  lRecFirst  // Se for um recibo por folha
				lRecFirst := .F.
				li := 00
			ElseIf !lRecFirst
				lRecFirst := .T.
				li := 32
			Endif
		Else
			li := 00
		Endif*/
		//TIME()
		// Cabecalho
		@ li,03 PSAY __PrtFatLine()
		li++
		@ li,03 PSAY __PrtLogo()
		li++
		@ li,03 PSAY __PrtFatLine()
		li+= 2
		//@ li,03 PSAY (NEGRITO+SM0->M0_NOME)		// Empresa
		@ li,03 PSAY __PrtRight(STR0013+DTOC(dDataBase))	// Data EmissÆo do relatorio
		li++
		@ li,03 PSAY __PrtRight("Hora : "+TIME())	// Data EmissÆo do relatorio
		li++
		@ li,03 PSAY __PrtCenter("REPOSICIÓN DE CAJA CHICA")	// Descri‡Æo do tipo de recibo
		li++
		//	IF SUBSTR(ALLTRIM(SEU->EU_TIPDEB),2,2)== 'CH'
		//		@ li,03 PSAY __PrtCenter("Cheque No.: " +EU_TITULO)	// Nro do Recibo
		//	ELSE
		//		@ li,03 PSAY __PrtCenter("No.: " +EU_TITULO)	// Nro do Recibo
		//	END
		@ li,03 PSAY __PrtCenter("Nro  " +EU_NUM)	// Nro do Recibo

		SET->(DbSetOrder(1))
		SET->(DBSeek (xFilial("SET") + SEU->EU_CAIXA))
		SA6->(DbSeek (xFilial("SA6") +SET->ET_BANCO+SET->ET_AGEBCO+SET->ET_CTABCO ))
		cMoeda:=GetMv("MV_SIMB" + StrZero(Max(1,SA6->A6_MOEDA),1))
		nTamData := Len((SEU->EU_EMISSAO))
		cBenef := ALLTRIM(SEU->EU_BENEF)
		cValor := AllTrim(Transform(SEU->EU_VALOR,PesqPict("SEU","EU_VALOR",19,1)))

		li+=2
		@ li ,03 PSAY "BANCO PARA REPOSICIÓN:" // + ALLTRIM(SET->ET_BANCO) + "   " + ALLTRIM(SET->ET_AGEBCO) + "   " + ALLTRIM(SET->ET_CTABCO)
		li+=2
		@ li ,07 PSAY "CÓDIGO DE CAJA:        " + ALLTRIM(SET->ET_BANCO)
		li+=2
		@ li ,07 PSAY "NRO DE AGENCIA:        " + ALLTRIM(SET->ET_AGEBCO)
		li+=2 
		@ li ,07 PSAY "NRO DE CUENTA:         " + ALLTRIM(SET->ET_CTABCO)
		li+=2
		cBanco:= Posicione("SA6", 1, xFilial("SA6") + SEU->EU_BCOREP + SEU->EU_AGEREP + SEU->EU_CTAREP, "SA6->A6_NOME")
		@ li ,07 PSAY "NOMBRE:                " + cBanco
		li+=2
		nValAtu:= Posicione("SA6", 1, xFilial("SA6") + SEU->EU_BCOREP + SEU->EU_AGEREP + SEU->EU_CTAREP, "SA6->A6_SALATU")
		nValAtu = nValAtu + SEU->EU_VALOR 
		@ li ,07 PSAY "SALDO ACTUAL:      "+ cMoeda + " " + cvaltochar(nValAtu)
		li+=2
		@ li ,03 PSAY "REPOSICIÓN "
		li+=2
		IF substr(ALLTRIM(SEU->EU_CAIXA),1,1)$'F'
			@ li ,07 PSAY "CÓDIGO FONDO A RENDIR: " + SEU->EU_CAIXA
		else
		@ li ,07 PSAY "CÓDIGO DE CAJA:    " +  SEU->EU_CAIXA
		End
		li+=2
		@ li ,07 PSAY "NOMBRE:            " + SET->ET_NOME
		li+=2
		@ li ,07 PSAY "VALOR ORIGINAL:    "+  cvaltochar(SET->ET_VALOR)+ " " + cMoeda 
		li+=2
		@ li ,07 PSAY "SALDO:             "+  cvaltochar(SET->ET_SALANT)+ " " + cMoeda 
		li+=2
		@ li ,07 PSAY "A REPONER:      "+cMoeda + " " +cValor
		li+=2
		@li,10 PSAY STR0008+SubStr(SEU->EU_DTDIGIT,7,2)+'/'+SubStr(SEU->EU_DTDIGIT,5,2)+'/'+SubStr(SEU->EU_DTDIGIT,1,4)+ STR0009 //"Recebi em "###" a quantia de "

		aAreaSEU := SEU->(GetArea())
		cExtenso:= Extenso( SEU->EU_VALOR,.F.,SA6->A6_MOEDA)
		RestArea(aAreaSEU)

		Fr565Exten(cExtenso,@cExt1,@cExt2)

		@li,PCOL() PSAY Alltrim(cExt1)

		If !Empty(cExt2) .or. Len(cExt1) >= 38
			li++
			@li,03 PSAY Alltrim(cExt2) +"."
		Else
			@li,PCOL()+2 PSAY "."
		Endif
		li++
		@li,03 PSAY STR0010+ALLTRIM("Reposición de Banco") + " "+ ALLTRIM(SA6->A6_NREDUZ) +"." //"Este valor refere-se a "
		li+= 4
		@li,05 PSAY (Replicate("-",25))
		@li,40 PSAY  (Replicate("-",25))
		@li+1,10 PSAY  ("SOLICITADO POR")
		@li+1,45 PSAY  ("AUTORIZADO POR")

		//Se estou imprimindo via inclusao de movimento.
		If !lMenu
			Exit
		Else
			dbSkip()
		Endif

	Enddo

	If lMenu
		#IFDEF TOP
		dbSelectArea("SEU")
		dbCloseArea()
		ChKFile("SEU")
		dbSelectArea("SEU")
		dbSetOrder(1)
		#ELSE
		dbSelectArea("SEU")
		dbClearFil()
		RetIndex( "SEU" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
		#ENDIF
	Endif
	// Atualiza flag de recibo impresso.
	dbSelectArea("SEU")
	For nX := 1 To Len(aRecno)
		DbGoto(aRecno[nX])
		RecLock("SEU")
		SEU->EU_IMPRESS := "S"
		MsUnlock()
	Next
	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		Ourspool(wnrel)
	Endif
	MS_FLUSH()
	RestArea(aAreaSEU)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fr565Param³ Autor ³ Mauricio Pequim Jr	  ³Data  ³ 24.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cabe‡alho do recibo  												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³fr565cabec() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fr565Param()
	Local cAlias
	Local nLargura := 080
	Local nLin:=0
	Local aDriver := ReadDriver()
	Local nCont:= 0
	Local cVar
	Local uVar
	Local cPicture
	Local lWin := .f.
	Local nRow
	Local nCol
	Local cNomprg:= "FINR565"
	#DEFINE INIFIELD    Chr(27)+Chr(02)+Chr(01)
	#DEFINE FIMFIELD    Chr(27)+Chr(02)+Chr(02)
	#DEFINE INIPARAM    Chr(27)+Chr(04)+Chr(01)
	#DEFINE FIMPARAM    Chr(27)+Chr(04)+Chr(02)
	lPerg := If(GetMv("MV_IMPSX1") == "S" .and. lMenu ,.T.,.F.)
	Private cSuf:=""
	If TYPE("__DRIVER") == "C"
		If "DEFAULT"$__DRIVER
			lWin := .t.
		EndIf
	EndIf
	IF aReturn[5] == 1   // imprime em disco
		lWin := .f.    // Se eh disco , nao eh windows
	Endif
	nRow := PRow()
	nCol := PCol()
	SetPrc(0,0)
	If aReturn[5] <> 2 // Se nao for via Windows manda os caracteres para setar a impressora
		If !lWin .and. __cInternet == Nil
			@ 0,0 PSAY &(aDriver[1])
		EndIf
	EndIF
	If GetMV("MV_CANSALT",,.T.) // Saltar uma página na impressão
		If GetMv("MV_SALTPAG",,"S") != "N"
			Setprc(nRow,nCol)
		EndIf
	Endif
	// Impressão da lista de parametros quando solicitada
	If lPerg .and. Substr(cAcesso,101,1) == "S"
		// Imprime o cabecalho padrao
		nLin := SendCabec(lWin, nLargura, cNomPrg, RptParam+" - "+Alltrim(Titulo), "", "", .F.)
		cAlias := Alias()
		DbSelectArea("SX1")
		DbSeek( padr( cPerg , Len( X1_GRUPO ) , " " ) )
		@ nLin+=2, 5 PSAY INIPARAM
		While !EOF() .AND. X1_GRUPO = cPerg
			cVar := "MV_PAR"+StrZero(Val(X1_ORDEM),2,0)
			@(nLin+=2),5 PSAY INIFIELD+RptPerg+" "+ X1_ORDEM + " : "+ AllTrim(X1Pergunt())+FIMFIELD
			If X1_GSC == "C"
				xStr:=StrZero(&cVar,2)
				If ( &(cVar)==1 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def01()+FIMFIELD
				ElseIf ( &(cVar)==2 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def02()+FIMFIELD
				ElseIf ( &(cVar)==3 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def03()+FIMFIELD
				ElseIf ( &(cVar)==4 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def04()+FIMFIELD
				ElseIf ( &(cVar)==5 )
					@ nLin,Pcol()+3 PSAY INIFIELD+X1Def05()+FIMFIELD
				Else
					@ nLin,Pcol()+3 PSAY INIFIELD+''+FIMFIELD
				EndIf
			Else
				uVar := &(cVar)
				If ValType(uVar) == "N"
					cPicture:= "@E "+Replicate("9",X1_TAMANHO-X1_DECIMAL-1)
					If( X1_DECIMAL>0 )
						cPicture+="."+Replicate("9",X1_DECIMAL)
					Else
						cPicture+="9"
					EndIf
					@nLin,Pcol()+3 PSAY INIFIELD+Transform(Alltrim(Str(uVar)),cPicture)+FIMFIELD
				Elseif ValType(uVar) == "D"
					@nLin,Pcol()+3 PSAY INIFIELD+DTOC(uVar)+FIMFIELD
				Else
					@nLin,Pcol()+3 PSAY INIFIELD+uVar+FIMFIELD
				EndIf
			EndIf
			DbSkip()
		Enddo
		cFiltro := Iif (!Empty(aReturn[7]),MontDescr("SEU",aReturn[7]),"")
		nCont := 1
		If !Empty(cFiltro)
			nLin+=2
			@ nLin,5  PSAY  INIFIELD+ STR0015 + Substr(cFiltro,nCont,nLargura-19)+FIMFIELD   //"Filtro      : "
			While Len(AllTrim(Substr(cFiltro,nCont))) > (nLargura-19)
				nCont += nLargura - 19
				nLin+=1
				@ nLin,19	PSAY	INIFIELD+Substr(cFiltro,nCont,nLargura-19)+FIMFIELD
			Enddo
			nLin++
		EndIf
		nLin++
		@ nLin ,00  PSAY __PrtFatLine()+FIMPARAM
		DbSelectArea(cAlias)
	EndIf
	m_pag++
	If Subs(__cLogSiga,4,1) == "S"
		__LogPages()
	EndIf
Return nLin
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr565Exten³ Autor ³ Mauricio Pequim Jr.	  ³ Data ³ 25.04.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extenso para o recibo de caixinha           					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³Fr565Exten() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static FUNCTION Fr565Exten(cExtenso,cExt1,cExt2)
	cExt1 := SubStr (cExtenso,1,39) // 1.a linha do extenso
	nLoop := Len(cExt1)
	While .T.
		If Len(cExtenso) == Len(cExt1)
			Exit
		EndIf
		If SubStr(cExtenso,Len(cExt1),1) == " "
			Exit
		EndIf
		cExt1 := SubStr( cExtenso,1,nLoop )
		nLoop --
	Enddo
	cExt2 := SubStr(cExtenso,Len(cExt1)+1,80) // 2.a linha do extenso
	IF !Empty(cExt2)
		cExt1 := StrTran(cExt1," ","  ",,39-Len(cExt1))
	Endif
Return
Static Function RepPerg()
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR("REP010",10)
	aRegs:={}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             //Número	                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aRegs,{cPerg,"01","¿De filial?"	,"¿De filial?"	,"¿De filial?"	,"mv_ch1","C",04,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"02","¿A filial?"		,"¿A filial?"	,"¿A filial?"	,"mv_ch2","C",04,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"03","¿De número?"	,"¿De número?"	,"¿De número?"	,"mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"04","¿A número?"		,"¿A número?"	,"¿A número?"	,"mv_ch4","C",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"05","¿De fecha?"		,"¿De fecha?"	,"¿De fecha?"	,"mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aadd(aRegs,{cPerg,"06","¿A fecha?"		,"¿A fecha?"	,"¿A fecha?"	,"mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		endif
	Next
	dbSelectArea(_sAlias)
Return
