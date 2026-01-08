#Include 'Protheus.ch'
#INCLUDE "FINR565.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o  ³ RepCch  ³ Autor ³ Erick Etcheverry	 	  . ³ Data ³ 15/05/19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Informe de cierre de Caja Chica					        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ BOLIVIA                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CerCch()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL cDesc1 := STR0001 //"Este relatorio ir  imprimir o recibo de adiantamentos"
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
	PRIVATE nomeprog:= "CerCch"

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
	//RepPerg()
	//CriaSX1(cPerg)
	pergunte(cPerg,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := "CerCch"            //Nome Default do relatorio em Disco
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
	Local aAreaSEU := GetArea()
	Local lRecFirst := .T.  //Controla se estou imprimindo o primeiro ou o segundo recibo
	Local aRecno := {}
	Local nX

	#IFDEF TOP
	Local nI := 0
	Local aStru := {}
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt 	:= SPACE(10)
	cbcont	:= 0
	li 		:= 80
	m_pag 	:= 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtragem dos recibos a serem impressos. Apenas se relatorio ³
	//³ for chamado do Menu														  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := ""
	cQuery := "SELECT EU_CAIXA,EU_NUM,EU_EMISSAO,SEU.R_E_C_N_O_ SEURECNO,EU_IMPRESS,EU_BENEF,EU_VALOR,EU_BCOREP,EU_AGEREP,EU_CTAREP,EU_DTDIGIT"
	cQuery += " FROM " + RetSqlName("SEU") + " SEU"
	cQuery += " WHERE EU_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery += " AND EU_NUM BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
	cQuery += " AND EU_DTDIGIT BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "'"
	cQuery += " AND EU_TIPO ='11'"
	cQuery += " AND SEU.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY EU_NUM DESC"
	//memowrite("test.txt",cQuery)
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'vwSEU', .F., .T.)

	SetRegua(RecCount())
	//fr565Param()  // Imprime folha de parametos se foi chamado do menu

	While !Eof()

		IF lEnd
			@Prow()+1,001 PSAY OemToAnsi(STR0007) //"CANCELADO PELO OPERADOR"
			Exit
		EndIF

		IncRegua()
		li := 00

		// Cabecalho
		@ li,03 PSAY __PrtFatLine()
		li++
		@ li,03 PSAY __PrtLogo()
		li++
		@ li,03 PSAY __PrtFatLine()
		li+= 2
		@ li,03 PSAY (SM0->M0_NOME)		// Empresa
		@ li,03 PSAY __PrtRight(STR0013+DTOC(dDataBase))	// Data EmissÆo do relatorio
		li++
		@ li,03 PSAY __PrtCenter("CIERRE DE CAJA CHICA")	// Descri‡Æo do tipo de recibo
		li++

		@ li,03 PSAY __PrtCenter("No.: " + vwSEU->EU_NUM)	// Nro do Recibo

		SET->(DbSetOrder(1))
		SET->(DBSeek (xFilial("SET") + vwSEU->EU_CAIXA))
		SA6->(DbSeek (xFilial("SA6") +SET->ET_BANCO+SET->ET_AGEBCO+SET->ET_CTABCO ))
		cMoeda:=GetMv("MV_SIMB" + StrZero(Max(1,SA6->A6_MOEDA),1))
		nTamData := Len((vwSEU->EU_EMISSAO))
		cBenef := ALLTRIM(vwSEU->EU_BENEF)
		cValor := AllTrim(Transform(vwSEU->EU_VALOR,PesqPict("SEU","EU_VALOR",19,1)))

		li+=2
		@ li ,03 PSAY "SALIDA CIERRE CAJA" // + ALLTRIM(SET->ET_BANCO) + "   " + ALLTRIM(SET->ET_AGEBCO) + "   " + ALLTRIM(SET->ET_CTABCO)
		li+=2
		@ li ,03 PSAY "CÓDIGO CAJA CHICA: " +  vwSEU->EU_CAIXA
		//@ li ,03 PSAY "CÓDIGO: " + ALLTRIM(SET->ET_BANCO) + "/" + ALLTRIM(SET->ET_AGEBCO) + "/" + ALLTRIM(SET->ET_CTABCO)
		li+=2
		cBanco:= Posicione("SA6", 1, xFilial("SA6") + SET->ET_BANCO + SET->ET_AGEBCO + SET->ET_CTABCO, "SA6->A6_NOME")
		@ li ,03 PSAY SET->ET_NOME
		li+=4
		@ li ,03 PSAY "INGRESO POR CIERRE DE CAJA "
		li+=2
		@ li ,03 PSAY "CÓDIGO: " + ALLTRIM(SET->ET_BANCO) + "/" + ALLTRIM(SET->ET_AGEBCO) + "/" + ALLTRIM(SET->ET_CTABCO)
		li+=2
		@ li ,03 PSAY cBanco
		li+=2
		@ li ,03 PSAY "VALOR: "+cValor+ " " + cMoeda
		li+=2
		@li,10 PSAY STR0008+SubStr(vwSEU->EU_DTDIGIT,7,2)+'/'+SubStr(vwSEU->EU_DTDIGIT,5,2)+'/'+SubStr(vwSEU->EU_DTDIGIT,1,4)+ STR0009 //"Recebi em "###" a quantia de "

		cExtenso:= Extenso( vwSEU->EU_VALOR,.F.,SA6->A6_MOEDA)

		Fr565Exten(cExtenso,@cExt1,@cExt2)

		@li,PCOL() PSAY Alltrim(cExt1)

		If !Empty(cExt2) .or. Len(cExt1) >= 38
			li++
			@li,03 PSAY Alltrim(cExt2) +"."
		Else
			@li,PCOL()+2 PSAY "."
		Endif
		li++
		@li,03 PSAY STR0010 + ALLTRIM("Cierre de caja chica")// + " "+ ALLTRIM(SA6->A6_NREDUZ) +"." //"Este valor refere-se a "
		li+= 7
		@li,05 PSAY (Replicate("-",25))
		@li,40 PSAY  (Replicate("-",25))
		@li+1,10 PSAY  ("SOLICITADO POR")
		@li+1,45 PSAY  ("AUTORIZADO POR")
		li++
		//@li,03 PSAY __PrtCenter(cBenef)
		@li+7,03 PSAY __PrtFatLine()

		aadd(aRecno,vwSEU->SEURECNO)

		dbSkip()

	Enddo

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
	SEU->(DBCLOSEAREA())
	vwSEU->(DBCLOSEAREA())
	RestArea(aAreaSEU)

Return

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