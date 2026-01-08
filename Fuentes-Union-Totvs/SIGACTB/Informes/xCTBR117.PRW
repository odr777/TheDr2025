#Include "CTBR117.Ch"
#Include "PROTHEUS.Ch"
// 17/08/2009 -- Filial com mais de 2 caracteres
// 09/09/2011 - Alterado tradução das colunas de Debito e Credito para Pais Mexico

Static lIsRedStor := FindFunction("IsRedStor") .and. IsRedStor() //Used to check if the Red Storn Concept used in russia is active in the system | Usada para verificar se o Conceito Red Storn utilizado na Russia esta ativo no sistema | Se usa para verificar si el concepto de Red Storn utilizado en Rusia esta activo en el sistema
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBR117  ³ Autor ³ Getulio A. Oliveira   ³ Data ³ 28/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Diario Geral                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR117(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function xCTBR117()
	Local cFilIni		:= cFilAnt
	PRIVATE titulo		:= ""
	Private nomeprog	:= "CTBR117"
	Private l1StQb		:= .T.
	Private nTransC	:= 0
	Private nTransD	:= 0
	Private aSelFil	:= {}
	CTBR117R4()
	cFilAnt := cFilIni
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR117R4 ³ Autor³ Getulio A. Oliveira	³ Data ³ 28/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Diario Geral - R4                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR117R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTBR117R4()
	PRIVATE oReport
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Variaveis utilizadas para parametros                                 |
	//| mv_par01  	        //  Data Inicial                                |
	//| mv_par02              // Data Final                                  |
	//| mv_par03              // Moeda?                                      |
	//| mv_par04				 // Set Of Books			    		             |
	//| mv_par05			     // Tipo Lcto? Real / Orcad / Gerenc / Pre      |
	//| mv_par06  	      	 // Pagina Inicial                              |
	//| mv_par07         	 // Pagina Final                                |
	//| mv_par08         	 // Pagina ao Reiniciar                         |
	//| mv_par09         	 // So Livro/Livro e Termos/So Termos           |
	//| mv_par10         	 // Imprime Balancete                           |
	//| mv_par11         	 // Imprime Plano de contas                     |
	//| mv_par12         	 // Imprime Valor 0.00	                        |
	//| mv_par13         	 // Impr Cod(Normal/Reduz/Cod.Impressao)         |  /// CT1_CODIMP
	//| mv_par14             //  Num.linhas p/ o diario?				          |
	//| mv_par15             //  Salta linha entre contas?                   |
	//| mv_par16             //  Descricao na Moeda?                         |
	//| mv_par17             //  Balancete Modelo?
	//| mv_par18			    // Imprime correlativo						          |
	//| mv_par19             //  Seleciona Filiais?							   |
	//| mv_par20             //  Mostrar(Normal/Só Cabeçalho/ So Informações |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	IF Valtype( oReport ) == 'O'
		If !Empty( oReport:uParam )
			Pergunte( oReport:uParam, .F. )
		EndIf

		oReport:PrintDialog()
	Endif
	oReport := Nil
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Getulio A. Oliveira	³ Data ³ 28/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
	Local aArea	   		:= GetArea()
	Local CREPORT		:= "CTBR117"
	Local CTITULO		:= OemToAnsi(STR0006)				// Emissao do Diario Geral
	Local CDESC			:= OemToAnsi(STR0001)+OemToAnsi(STR0002)+OemToAnsi(STR0003)	// "Este programa ir  imprimir o Diário Geral Modelo 1"
	Local cPerg		   	:= "XCTR117"
	Local CVALDEB		:= ""
	Local CVALCRED		:= ""
	Local cSeparador    := ""
	Local cMoeda		:= ""
	Local aCtbMoeda		:= {}
	Local lRet		 	:= .T.
	Local cQuery
	Local cFilCt1		:= ""
	Local cFilCt2		:= ""
	Local cFilCtt		:= ""
	Local nSize
	Public cMascara		:= ""
	Public cDescMoeda 	:= ""
	Public cPicture		:= ""
	Public nDecimais		:= 0
	Public aTamVal		:= TAMSX3("CT2_VALOR")
	Public nTamQuebra	:= 0
	Public nTamConta	:= 25
	Public nTamHist		:= 40

	private TMP
	DEFAULT aSelFil		:= {}
	If !Pergunte( 'XCTR117' , .T. )
		lRet := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
	//³ Gerencial -> montagem especifica para impressao)		     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// faz a validação do livro
	if lRet .And. !Empty( mv_par04 )
		if ! VdSetOfBook( mv_par04 , .F. )
			lRet := .F.
		endif
	Endif
	IF lRet
		// seta o livro
		aSetOfBook := CTBSetOf(mv_par04)

		// seta a moeda
		aCtbMoeda	:= CtbMoeda(mv_par03)
		If Empty(aCtbMoeda[1])
			Help(" ",1,"NOMOEDA")
			lRet := .F.
		EndIf
	Endif
	If lRet .And. mv_par19 == 1 .And. Len( aSelFil ) <= 0
		aSelFil := AdmGetFil()
		If Len( aSelFil ) <= 0
			lRet := .F.
		EndIf
	Else
		aSelFil := {cFilAnt}
	EndIf

	If !lRet
		Set Filter To
		Return
	EndIf
	cMoeda		:= mv_par03
	cDescMoeda 	:= aCtbMoeda[2]
	nDecimais 	:= DecimalCTB(aSetOfBook,cMoeda)
	If Empty(aSetOfBook[2])
		cMascara := GetMv("MV_MASCARA")
	Else
		cMascara := RetMasCtb(aSetOfBook[2],@cSeparador)
	EndIf
	// mascara do valor
	cPicture 	:= aSetOfBook[4]
	If Empty( cPicture ) .Or. cPicture == Nil
		cPicture := "@E " + TmContab(CT2->CT2_VALOR,aTamVal[1],nDecimais)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao do componente de impressao                                      ³
	//³                                                                        ³
	//³TReport():New                                                           ³
	//³ExpC1 : Nome do relatorio                                               ³
	//³ExpC2 : Titulo                                                          ³
	//³ExpC3 : Pergunte                                                        ³
	//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
	//³ExpC5 : Descricao                                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//"Este programa tem o objetivo de emitir o Cadastro de Itens Classe de Valor "
	//"Sera impresso de acordo com os parametros solicitados pelo"
	//"usuario"
	oReport	:= TReport():New( CREPORT,CTITULO,, { |oReport| ReportPrint( oReport, cPicture, nDecimais, cMascara, cSeparador, cDescMoeda ) }, CDESC )

	oReport:SetTotalInLine(.F.)
	oReport:EndPage(.T.)
	oReport:SetPortrait(.T.)
	oReport:SetEdit(.T.)// Habilita opcao de personalizacao do R4, a personalizacao deve estar sempre habilitada
	//  independentemente do valor do parametro MV_CTBPOFF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da secao utilizada pelo relatorio                               ³
	//³                                                                        ³
	//³TRSection():New                                                         ³
	//³ExpO1 : Objeto TReport que a secao pertence                             ³
	//³ExpC2 : Descricao da seçao                                              ³
	//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
	//³        sera considerada como principal para a seção.                   ³
	//³ExpA4 : Array com as Ordens do relatório                                ³
	//³ExpL5 : Carrega campos do SX3 como celulas                              ³
	//³        Default : False                                                 ³
	//³ExpL6 : Carrega ordens do Sindex                                        ³
	//³        Default : False                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nTamQuebra := (TamSX3("CT2_DATA")[1]+TamSX3("CT1_CONTA")[1]+TamSX3("CT1_DESC01")[1])
	oSection1  := TRSection():New( oReport, STR0007, {"TMP"},,.F.,.F.,,,,,,,,,,.F./*AutoAjuste*/,)    //"Totalizadores Doc / Geral"
	TRCell():New( oSection1, "Documento"    , /*Alias*/, /*Titulo*/, /*Picture*/,nTamQuebra)
	TRCell():New( oSection1, "CDEBITO"		, 	   ,/*STR0022*/   ,/*Picture*/,aTamVal[1]	,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")		//"Vlr.Debito"
	TRCell():New( oSection1, "CCREDITO"		,	   ,/*STR0023*/	  ,/*Picture*/,aTamVal[1]	,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")		//"Vlr.Credito"
	oSection1:Cell("CDEBITO"):lHeaderSize	:= .F.
	oSection1:Cell("CCREDITO"):lHeaderSize	:= .F.
	oSection1:SetHeaderSection(.F.)
	oSection1:SetReadOnly()
	oSection2  := TRSection():New( oReport, STR0008 , {"TMP"},, .F., .F.,,,,,,,,,,.F./*AutoAjuste*/, )    //"Lancamentos Contabeis"
	TRCell():New( oSection2, "CT2_DC"		, "TMP"	,"DC"			, /*Picture*/,TamSX3("CT2_DC")[1])
	TRCell():New( oSection2, "CT2_LINHA"    , "TMP"	,"LIN"			, /*Picture*/,TamSX3("CT2_LINHA")[1])
	TRCell():New( oSection2, "DOCTO"    	, 		,"DOCUMENTO"	, /*Picture*/,TamSX3("CT2_LOTE")[1] + TamSX3("CT2_SBLOTE")[1] + TamSX3("CT2_SEGOFI")[1]+3)
	TRCell():New( oSection2, "DATA"	  		, ""	,/*Titulo*/		, /*Picture*/,TamSX3("CT2_DATA")[1]+3	,/*lPixel*/,/*CodeBlock*/,/*"LEFT"*/	,	,"LEFT")
	TRCell():New( oSection2, "CT1_CONTA"    , "TMP"	,"CONTA"		, /*Picture*/,TamSX3("CT1_CONTA")[1])
	TRCell():New( oSection2, "CT1_DESC01"   , "TMP"	,"DESC. CONTA"	, /*Picture*/,30 /*TamSX3("CT1_DESC01")[1]*/	,/*lPixel*/,/*CodeBlock*/,/*"LEFT"*/	,.T.,"LEFT")
	TRCell():New( oSection2, "CVALDEB"		, ""	,STR0010		, PesqPict("CT2","CT2_VALOR"),aTamVal[1]				,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/	,	,"RIGHT")		//"Vlr.Debito"
	TRCell():New( oSection2, "CVALCRED"		, ""	,STR0011		, PesqPict("CT2","CT2_VALOR"),aTamVal[1]				,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/	,	,"RIGHT")		//"Vlr.Credito"

	TRCell():New( oSection2, "CT2_HIST"     , "TMP"	,"HISTORIAL"	, /*Picture*/,nTamHist					,/*lPixel*/,/*CodeBlock*/,/*"LEFT"*/	,.T.,"LEFT")
	TRCell():New( oSection2, "CTT_CUSTO"    , "TMP"	,"CCUSTO"		, /*Picture*/,TamSX3("CTT_CUSTO")[1])
	oSection2:Cell("DATA"):lHeaderSize  	:= .F.
	oSection2:Cell("CT1_CONTA"):lHeaderSize := .F.
	oSection2:Cell("CT1_DESC01"):lHeaderSize:= .F.
	oSection2:Cell("CVALDEB"):lHeaderSize  	:= .F.
	oSection2:Cell("CVALCRED"):lHeaderSize 	:= .F.
	oSection2:Cell("CT2_HIST"):lHeaderSize 	:= .F.
	oSection2:Cell("CTT_CUSTO"):lHeaderSize := .F.
	oSection2:SetReadOnly()

	oSection3  := TRSection():New( oReport, STR0009, ,, .F., .F.,,,,,,,,,,.F./*AutoAjuste*/,)    //"Transporte"
	TRCell():New( oSection3, "Transporte", /*Alias*/, /*Titulo*/, /*Picture*/,nTamQuebra)
	TRCell():New( oSection3, "CDEBTRANSP"	, 	   ,STR0010   ,/*Picture*/,aTamVal[1]	,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")		//"Vlr.Debito"
	TRCell():New( oSection3, "CCREDTRANSP"	,	   ,STR0011	  ,/*cPicture*/,aTamVal[1]	,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")		//"Vlr.Credito"
	oSection3:Cell("CDEBTRANSP"):lHeaderSize  := .F.
	oSection3:Cell("CCREDTRANSP"):lHeaderSize := .F.
	oSection3:SetHeaderSection(.F.)
	oSection3:SetReadOnly()
	nSize := oSection2:Cell("CT2_DC"):GetSize()
	nSize += oSection2:Cell("CT2_LINHA"):GetSize()
	nSize += oSection2:Cell("DOCTO"):GetSize()
	nSize += oSection2:Cell("DATA"):GetSize()
	nSize += oSection2:Cell("CT1_CONTA"):GetSize()
	nSize += oSection2:Cell("CT1_DESC01"):GetSize()
	nSize += oSection2:Cell("CT2_HIST"):GetSize()
	nSize += oSection2:Cell("CTT_CUSTO"):GetSize()
	oSection1:Cell("DOCUMENTO"):SetSize(nSize+5)
	oSection3:Cell("Transporte"):SetSize(nSize+5)
	If mv_par20 == 2
		oSection2:SetHeaderSection(.F.)
		oSection1:Cell("DOCUMENTO"):Hide()

		oSection1:Cell("CDEBITO"):Hide()
		oSection1:Cell("CCREDITO"):Hide()

		oSection2:Cell("CT2_DC"):Hide()
		oSection2:Cell("CT2_LINHA"):Hide()
		oSection2:Cell("DOCTO"):Hide()
		oSection2:Cell("DATA"):Hide()
		oSection2:Cell("CT1_CONTA"):Hide()
		oSection2:Cell("CT1_DESC01"):Hide()
		oSection2:Cell("CVALDEB"):Hide()
		oSection2:Cell("CVALCRED"):Hide()

		oSection3:Cell("Transporte"):Hide()
		oSection3:Cell("CDEBTRANSP"):Hide()
		oSection3:Cell("CCREDTRANSP"):Hide()
		oSection2:Cell("CT2_HIST"):Hide()
		oSection2:Cell("CTT_CUSTO"):Hide()

		oReport:OnPageBreak( { || oReport:SkipLine(6)})

	Elseif mv_par20 == 3
		oReport:HideHeader()
		oReport:OnPageBreak( { || oReport:SkipLine(6)})
	Endif
Return(oReport)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Getulio A. Oliveira	³ Data ³ 28/10/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport, cPicture, nDecimais, cMascara, cSeparador, cDescMoeda )
	Local oSection1 	:= oReport:Section(1)
	Local oSection2 	:= oReport:Section(2)
	Local oSection3 	:= oReport:Section(3)
	Local lPula			:= Iif(mv_par10==1,.T.,.F.)
	Local lImpLivro		:=.t.
	Local lImpTermos	:=.f.
	Local cMSGT			:= SubStr(STR0012,3,25)
	Local i				:= 0
	Local nLinReport    := 8
	Local nMaxLin		:= mv_par14
	Local lSalLin 		:= Iif(MV_PAR15==1,.T.,.F.)
	Local lResetPag		:= .T.
	Local m_pag			:= 1 // controle de numeração de pagina
	Local l1StQb		:= .T.
	Local nPagIni		:= mv_par06
	Local nPagFim		:= mv_par07
	Local nReinicia		:= mv_par08
	Local nBloco		:= 0
	Local nBlCount		:= 1
	Local nPaginas      := mv_par06
	Local dData
	Local lNovoDoc		:= .T.
	Local nToDocC		:= 0
	Local nToDocD		:= 0
	Local nGeralC		:= 0
	Local nGeralD		:= 0
	Local lFim			:= .F.
	Local nK				:= 0
	Local cFilOld	    := cFilAnt
	Local aArea			:= GetArea()
	Local aAreaSM0		:= SM0->(GetArea())
	Local cDoc			:= ""
	Local aDC			:={"D","C","P","H"}
	Local cTmpCT1Fil
	Local cTmpCT2Fil
	Local cTmpCTTFil
	Local lColDbCr 		:= lIsRedStor // Disconsider cTipo in ValorCTB function, setting cTipo to empty
	Local lTotal		:= .T.	//(mv_par13 == 1)

	Public lPrintZero	:= Iif(mv_par12 == 1,.T.,.F.)
	lTotal := .T.
	If lTotal
		oBreak1 := TRBreak():New( oSection2, oSection2:Cell("DOCTO"), "Total asiento" )
		TRFunction():New(oSection2:Cell("CVALDEB") , ,"SUM",oBreak1/*oBreak */,,PesqPict("CT2","CT2_VALOR") /*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
		TRFunction():New(oSection2:Cell("CVALCRED"), ,"SUM",oBreak1/*oBreak*/ ,,PesqPict("CT2","CT2_VALOR") /*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
	Endif
	TMP := GetNextAlias()
	cFilCt1  := " CT1_FILIAL " + GetRngFil( aSelFil, "CT1", .T., @cTmpCT1Fil )
	cFilCt2  := " CT2_FILIAL " + GetRngFil( aSelFil, "CT2", .T., @cTmpCT2Fil )
	cFilCtt  := " CTT_FILIAL " + GetRngFil( aSelFil, "CTT", .T., @cTmpCTTFil )
	cQuery := " SELECT "
	cQuery += " CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_SEGOFI, CT2_DATA, CT1_CONTA, CT2_DEBITO, CT2_CREDIT, CT1_DESC01, CT1_RES, CT1_CODIMP, CT2_VALOR, CT2_DC, CT2_LINHA, 'DB' CT2_ID_DC, CT2_HIST, CTT_CUSTO "
	cQuery += " FROM " + RetSqlName('CT2') + " CT2"
	cQuery += " LEFT JOIN " + RetSqlName('CT1') + " CT1 ON (CT2_DEBITO = CT1_CONTA) AND " + cFilCt1 + " AND CT1.D_E_L_E_T_ <> '*'"
	cQuery += " LEFT JOIN " + RetSqlName('CTT') + " CTT ON (CT2_CCD    = CTT_CUSTO) AND " + cFilCtt + " AND CTT.D_E_L_E_T_ <> '*'"
	cQuery += " WHERE " + cFilCt1 + " AND " + cFilCt2
	cQuery += " AND CT2_DATA BETWEEN '" + DTOS( mv_par01 ) + "' AND '" + DTOS ( mv_par02 ) + "' "
	cQuery += " AND CT2_MOEDLC = '" + mv_par03 + "' "
	cQuery += " AND CT2_TPSALD = '" + mv_par05 + "' "
	cQuery += " AND CT2_DC IN ('1','3') "
	If !Empty(mv_par21)
		cQuery += " AND CT2_LOTE = '" + mv_par21 + "' "
	Endif
	If !Empty(mv_par22)
		cQuery += " AND CT2_SBLOTE = '" + mv_par22 + "' "
	Endif
	cQuery += " AND CT2.D_E_L_E_T_ <> '*' " +CRLF
	cQuery += " UNION ALL " +CRLF
	cQuery += " SELECT "
	cQuery += " CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_SEGOFI, CT2_DATA, CT1_CONTA, CT2_DEBITO, CT2_CREDIT, CT1_DESC01, CT1_RES, CT1_CODIMP, CT2_VALOR, CT2_DC, CT2_LINHA, 'CR' CT2_ID_DC, CT2_HIST, CTT_CUSTO "
	cQuery += " FROM " + RetSqlName('CT2') + " CT2"
	cQuery += " LEFT JOIN " + RetSqlName('CT1') + " CT1 ON (CT2_CREDIT = CT1_CONTA) AND " + cFilCt1 + " AND CT1.D_E_L_E_T_ <> '*'"
	cQuery += " LEFT JOIN " + RetSqlName('CTT') + " CTT ON (CT2_CCC    = CTT_CUSTO) AND " + cFilCtt + " AND CTT.D_E_L_E_T_ <> '*'"
	cQuery += " WHERE " + cFilCt1 + " AND " + cFilCt2
	cQuery += " AND CT2_DATA BETWEEN '" + DTOS( mv_par01 ) + "' AND '" + DTOS ( mv_par02 ) + "' "
	cQuery += " AND CT2_MOEDLC = '" + mv_par03 + "' "
	cQuery += " AND CT2_TPSALD = '" + mv_par05 + "' "
	cQuery += " AND CT2_DC IN ('2','3') "
	If !Empty(mv_par21)
		cQuery += " AND CT2_LOTE = '" + mv_par21 + "' "
	Endif
	If !Empty(mv_par22)
		cQuery += " AND CT2_SBLOTE = '" + mv_par22 + "' "
	Endif
	cQuery += " AND CT2.D_E_L_E_T_ <> '*'"
	If MV_PAR18 == 1
		cQuery += " ORDER BY CT2_LOTE, CT2_SBLOTE, CT2_SEGOFI, CT2_LINHA, CT2_DATA "
	Else
		cQuery += " ORDER BY CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA, CT2_DATA "
	EndIf

	cQuery := ChangeQuery(cQuery)
	//Aviso("cQuery",cQuery,{"OK"},,,,,.T.)
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'TMP', .T., .F. )
	DbSelectArea('TMP')
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao de Termo / Livro                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		Case mv_par09 == 1 ; lImpLivro := .T. ; lImpTermos := .F.
		Case mv_par09 == 2 ; lImpLivro := .T. ; lImpTermos := .T.
		Case mv_par09 == 3 ; lImpLivro := .F. ; lImpTermos := .T.
	EndCase
	aSetOfBook := CTBSetOf(mv_par04)
	cPicture 	:= aSetOfBook[4]
	If Empty( cPicture ) .Or. cPicture == Nil
		cPicture := "@E " + TmContab(CT2->CT2_VALOR,aTamVal[1],nDecimais)
	Endif

	For nK := 1 to Len(aSelFil)
		cFilAnt := aSelFil[nK]
		SM0->(DbSeek(cEmpAnt+cFilAnt))

		If lImpLivro
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//| titulo do relatorio                                          |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			titulo		:= 	OemToAnsi(STR0013) + DTOC(mv_par01) + OemToAnsi(STR0014) + DTOC(mv_par02) + OemToAnsi(STR0015) + cDescMoeda + CtbTitSaldo(mv_par05)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//| cabeçalho do relatorio                                       |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			oReport:SetCustomText( {|| (Pergunte("XCTR117",.F.),CtCGCCabTR(,,,,,mv_par02,titulo,,,,,oReport,.T.,@lResetPag,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb)) } )

			oReport:SetMeter( RecCount() )

			oSection1:OnPrintLine( {|| CTR117Maxl( nMaxLin, @nLinReport, cPicture )} )
			oSection2:OnPrintLine( {|| CTR117Maxl( nMaxLin, @nLinReport, cPicture )} )
			If MV_PAR18 == 1
				oSection2:Cell("DOCTO"):SetBlock( { || (TMP->CT2_LOTE+TMP->CT2_SBLOTE+"-"+TMP->CT2_SEGOFI) })
			Else
				oSection2:Cell("DOCTO"):SetBlock( { || (TMP->CT2_LOTE+TMP->CT2_SBLOTE+TMP->CT2_DOC) })
			EndIf

			oSection2:Cell("CT2_DC"):SetBlock({|| aDC[val(TMP->CT2_DC)] })

			oSection2:Cell("CT2_LINHA"):SetBlock({|| TMP->CT2_LINHA })

			oSection2:Cell("CVALDEB" ):SetBlock( { || ValorCTB( if( TMP->CT1_CONTA == TMP->CT2_DEBITO,TMP->CT2_VALOR , 0 ) ,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr)})
			oSection2:Cell("CVALCRED"):SetBlock( { || ValorCTB( if( TMP->CT1_CONTA == TMP->CT2_CREDITO,TMP->CT2_VALOR ,0 ) ,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr)})

			oSection2:Cell("DATA"):SetBlock( { || stod(tmp->ct2_Data) } )

			If MV_PAR13 == 2	       /// Impressao do Codigo Reduzido

				oSection2:Cell("CT1_CONTA" ):SetBlock( { || EntidadeCTB(TMP->CT1_RES,0 ,00,nTamConta,.F.,cMascara,cSeparador,,,,,.F.) } )

			ElseIf MV_PAR13 == 3 	/// Impressao do Codigo de Impressao (se o campo existir)

				oSection2:Cell("CT1_CONTA" ):SetBlock( { || EntidadeCTB(TMP->CT1_CODIMP,0,0,nTamConta,.F.,cMascara,cSeparador,,,,,.F.) } )
			Else   					/// Impressao do Codigo Normal
				oSection2:Cell("CT1_CONTA" ):SetBlock( { || EntidadeCTB(TMP->CT1_CONTA,0,0,nTamConta,.F.,cMascara,cSeparador,,,,,.F.) } )

			Endif

			If MV_PAR18 == 1
				oSection1:Cell("DOCUMENTO"):SetBlock( { || Iif( lFim, STR0016,  Iif (lNovoDoc, STR0017 + TMP->CT2_LOTE+TMP->CT2_SBLOTE+"-"+TMP->CT2_SEGOFI, STR0018))})
			Else
				oSection1:Cell("DOCUMENTO"):SetBlock( { || Iif( lFim, STR0016, Iif (lNovoDoc, STR0017 +  TMP->CT2_LOTE+TMP->CT2_SBLOTE+TMP->CT2_DOC, STR0018))})
			EndIf

			oSection1:Cell("CDEBITO"):SetBlock( { || Iif( lFim, ValorCTB( nGeralD,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr), Iif(lNovoDoc, nil,;
			ValorCTB( nToDocD,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr)))})

			oSection1:Cell("CCREDITO"):SetBlock( { || Iif( lFim, ValorCTB( nGeralC,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr), Iif(lNovoDoc, nil,;
			ValorCTB( nToDocC,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr)))})

			oSection3:Cell("CDEBTRANSP"):SetBlock( { || ValorCTB( nTransD,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.,lColDbCr)})
			oSection3:Cell("CCREDTRANSP"):SetBlock( { || ValorCTB( nTransC,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.,lColDbCr)})
			oSection3:Cell("TRANSPORTE"):SetBlock( { || Iif(nLinReport == 11, STR0012, STR0019)})

			While TMP->(!Eof())

				cDoc := TMP->(CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA)
				lNovoDoc := .T.
				nToDocC  := 0
				nToDocD  := 0
				nTransC  := 0
				nTransD  := 0
				/*
				oSection1:Init()
				oSection1:PrintLine()
				oSection1:Finish()
				*/
				oSection2:Init()

				While TMP->(CT2_DATA+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA) == cDoc
					If oReport:Cancel()
						Exit
					EndIf

					lNovoDoc := .F.

					oSection2:PrintLine()
					oReport:IncMeter()

					If TMP->CT2_ID_DC == 'DB'
						nToDocD += TMP->CT2_VALOR
						nTransD += TMP->CT2_VALOR
						nGeralD += TMP->CT2_VALOR
					EndIf

					If TMP->CT2_ID_DC == 'CR'
						nToDocC += TMP->CT2_VALOR
						nTransC += TMP->CT2_VALOR
						nGeralC += TMP->CT2_VALOR
					EndIf

					TMP->(dbSkip())
				EndDo

				//oSection2:Finish()	//<----- EA 16/10/2019

				//oSection1:Init()
				//oSection1:PrintLine()
				//oSection1:Finish()
				nLinReport := nLinReport + 1;

			EndDo
			lFim := .T.
			//oSection1:Init()
			//oSection1:PrintLine()
			//oSection1:Finish()

			oSection2:Finish()		//EA Se adicionó
		Endif
		//oReport:EndPage()
	Next
	nGeralD := 0
	nGeralC	:= 0
	lFim := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressão do Balancete Modelo 1                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1
		If MV_PAR17 == 1
			Ctbr040R4()
		ElseIf	MV_PAR17 == 2
			Ctbr043R4()
		EndIf
		Pergunte( "XCTR117" , .F. )
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressão do Plano de Contas                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par11 == 1
		Ctbr010R4( mv_par03 )
	Endif
	If lImpTermos 							// Impressao dos Termos
		oReport:HideHeader()
		oSection2:Hide()
		Pergunte( "XCTR117", .F. )

		cArqAbert:=GetMv("MV_LDIARAB")
		cArqEncer:=GetMv("MV_LDIAREN")
		dbSelectArea("SM0")
		aVariaveis:={}
		For i:=1 to FCount()
			If FieldName(i)=="M0_CGC"
				AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
			Else
				If FieldName(i)=="M0_NOME"
					Loop
				EndIf
				AADD(aVariaveis,{FieldName(i),FieldGet(i)})
			Endif
		Next
		dbSelectArea("SX1")
		dbSeek( padr( "XCTR117" , Len( X1_GRUPO ) , ' ' ) + "01" )
		While ! Eof() .And. SX1->X1_GRUPO  == padr( "XCTR117" , Len( X1_GRUPO ) , ' ' )
			AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
			dbSkip()
		End
		dbSelectArea( "CVB" )
		CVB->(dbSeek( xFilial( "CVB" ) ))
		For i:=1 to FCount()
			If FieldName(i)=="CVB_CGC"
				AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
			ElseIf FieldName(i)=="CVB_CPF"
				AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 999.999.999-99")})
			Else
				AADD(aVariaveis,{FieldName(i),FieldGet(i)})
			Endif
		Next
		AADD(aVariaveis,{"M_DIA",StrZero(Day(dDataBase),2)})
		AADD(aVariaveis,{"M_MES",MesExtenso()})
		AADD(aVariaveis,{"M_ANO",StrZero(Year(dDataBase),4)})
		If !File(cArqAbert)
			aSavSet:=__SetSets()
			cArqAbert:=CFGX024(,"Diario Geral.") // Editor de Termos de Livros
			__SetSets(aSavSet)
			Set(24,Set(24),.t.)
		Endif
		If !File(cArqEncer)
			aSavSet:=__SetSets()
			cArqEncer:=CFGX024(,"Diario Geral.") // Editor de Termos de Livros
			__SetSets(aSavSet)
			Set(24,Set(24),.t.)
		Endif
		If cArqAbert#NIL
			oReport:EndPage()
			ImpTerm2(cArqAbert,aVariaveis,,,,oReport)
		Endif
		If cArqEncer#NIL
			oReport:EndPage()
			ImpTerm2(cArqEncer,aVariaveis,,,,oReport)
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| cabeçalho do relatorio                                       |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport:EndPage()
		oReport:ShowHeader()
		oSection2:Show()
	Endif
	cFilAnt := cFilOld
	RestArea(aAreaSM0)
	RestArea(aArea)
	TMP->(DbCloseArea())
	CtbTmpErase(cTmpCT1Fil)
	CtbTmpErase(cTmpCT2Fil)
	CtbTmpErase(cTmpCTTFil)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |CTR117MaxL    ºAutor ³ Renato F. Campos º Data ³ 01/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz a quebra de pagina de acordo com o parametro passado   º±±
±±º          ³ no relatorio.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Numero maximo de linhas definido no relatorio      º±±
±±º          ³ EXPL2 - Contador de linhas impressas no relatorio          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nil                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Diario Geral                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTR117MaxL(nMaxLin,nLinReport, cPicture )
	Local oSection1 := oReport:Section(1)
	Local oSection3 := oReport:Section(3)
	Local nMaxLin1
	nMaxLin1 := nMaxLin
	If oSection1:Printing()
		nLinReport += 2
	Else
		nLinReport++
	Endif
	If nLinReport > nMaxLin1 - 2
		If nTransC > 0 .OR. nTransD > 0

			oSection3:Init()
			oSection3:Printline()
			oSection3:Finish()

			oReport:EndPage()
			nLinReport := 11
			oSection3:Init()
			oSection3:Printline()
			oSection3:Finish()
			oReport:Skipline()

		Else

			nLinReport := 9

			oReport:EndPage()

		EndIf
	Else
	EndIf
Return Nil

static Function ValorCtb(	nSaldo,nLin,nCol,nTamanho,nDecimais,lSinal,cPicture,;
	cTipo,cConta,lGraf,oPrint,cTipoSinal, cIdentifi,lPrintZero,lSay,lColDbCr,lCharSinal)

	Local aSaveArea	:= GetArea()
	Local cImpSaldo := 0
	Local cPicAux	:= ""
	Local lDifZero	:= .T.
	Local lInformada:= .T.
	Local cCharSinal:= ""

	Local lRedStorn	:= cPaisLoc == "RUS" .And. SuperGetMV("MV_REDSTOR",.F.,.F.) // CAZARINI - 20/06/2017 - Parameter to activate Red Storn

	lPrintZero := Iif(lPrintZero==Nil,.T.,lPrintZero)

	// Nao imprime o valor 0,00
	If !lPrintZero
		If (Int(nSaldo*100)/100) == 0
			lDifZero := .F.			// O saldo nao eh diferente de zero
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipo D -> Default (D/C)												  ³
	//³ Tipo S -> Imprime saldo com sinal									  ³
	//³ Tipo P -> Imprime saldo entre parenteses (qdo. negativo)	  ³
	//³ Tipo C -> So imprime "C" (o "D" nao e impresso)              ³
	//³ Tipo N -> Imprime saldo com sinal (-) se o saldo for credor³
	//³ Tipo R -> Default Red Storno: Imprime natureza da conta  (C/D) e saldo relativo a ela	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFAULT cTipoSinal := SuperGetMV("MV_TPVALOR")       // Assume valor default

	DEFAULT lSay := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ lColDbCr .F. -> Consider account normal according with cTipo ³
	//³ lColDbCr .T. -> Disconsider cTipo, setting cTipo to empty    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFAULT lColDbCr	:= .F.
	DEFAULT lCharSinal	:= .T.

	cTipo 		:= Iif(cTipo == Nil, Space(1), cTipo)
	nDecimais	:= Iif(nDecimais==Nil,SuperGetMV("MV_CENT"),nDecimais)

	dbSelectArea("CT1")
	dbSetOrder(1)

	If lRedStorn
		cTipoSinal	:=	"R"
		If lColDbCr
			lSinal	:=	.T.
			cTipo := Space(1)
		Else
			If !Empty(cConta) .And. Empty(cTipo)
				If MsSeek(cFilial+cConta)
					cTipo := CT1->CT1_NORMAL
				Endif
			EndIf

			If Empty(cTipo)
				cTipo := "2"
			Endif
		Endif
	Endif

	If !Empty(cConta) .And. Empty(cTipo)
		If MsSeek(cFilial+cConta)
			cTipo := CT1->CT1_NORMAL
		Endif
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna a picture. Caso nao exista espaco, retira os pontos  ³
	//³ separadores de dezenas, centenas e milhares 					  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cPicture)
		If cTipoSinal $ "D/C" .Or. (cPaisLoc == "RUS" .And. cTipoSinal == "R")
			cPicture := TmContab(Abs(nSaldo),nTamanho,nDecimais)
		Else
			cPicture := TmContab(nSaldo,nTamanho,nDecimais)
		EndIf
		lInformada  := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³* Alguns valores, apesar de  terem sinal devem ser impressos  ³
	//³ sem sinal (lSinal). Ex: valores de colunas Debito e Credito  ³
	//³* Se estiver com a opcao de lingua estrangeira (lEstrang) a   ³
	//³ picture sera invertida para exibir valores: 999,999,999.99   ³
	//³* O tipo de sinal "D" - default nao leva em consideracao a    ³
	//³ a natureza da conta. Dessa forma valores negativos serao	  ³
	//³ impressos sem sinal, e ao seu lado "D" (Devedor) e valores   ³
	//³ positivos terao um "C" (Credito) impresso ao seu lado.       ³
	//³* O tipo de Sinal "P" - Parenteses, imprimira valores de saldo³
	//³  invertidos da condicao normal da conta entre parenteses.	  ³
	//³* O tipo de Sinal "S" - Sinal, imprimira valores de saldo in- ³
	//³  vertidos da condicao normal da conta com sinal - 			  ³
	//³EXEMPLOS  -  EXEMPLOS  -  EXEMPLOS	-	EXEMPLOS  - EXEMPLOS   ³
	//³Cond Normal 	Saldo 	Default      Sinal   Parenteses		  ³
	//³	D			   -1000	   1000 D 		 1000		 1000			  	  ³
	//³	D				 1000 	1000 C		-1000 	(1000)			  ³
	//³	C				-1000 	1000 D		-1000 	(1000)			  ³
	//³	C				 1000 	1000 C		 1000 	 1000 			  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	// So imprime valor se for diferente de zero!
	If lDifZero
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Neste caso (Default), nao importa a natureza da conta! Saldos³
		//³ devedores serao impressos com "D" e credores com "C".        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Neste caso, nao importa a natureza da conta!!
		If cTipoSinal == "D" .Or. cTipoSinal == "C" .Or. cTipoSinal == "N"			// D(Default) ou C(so Credito)
			If !lInformada
				cPicture := "@E " + cPicture
			Endif
			If lSinal
				If lRedStorn
					If cTipo == "1"	// debit account
						nSaldo := nSaldo * (-1) // consider account normal
					Endif
				Endif
				If nSaldo < 0
					If lGraf
						If cTipoSinal == "D"
							cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
						EndIf
					Else
						// No Tipo C -> so sao impressos os "C´s"
						If cTipoSinal == "D"
							cCharSinal := Iif(cPaisLoc<>"MEX","D","C")
						EndIf
					Endif
				ElseIf nSaldo > 0
					If lGraf
						If cIdentifi # Nil .And. cIdentifi $ "34"
							If cTipoSinal == "D"
								cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
							EndIf
						Else
							cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
						Endif
					Else
						cCharSinal := Iif(cPaisLoc<>"MEX","C","A")
					Endif
				EndIf
				cCharSinal := " "+cCharSinal
			EndIf

			//Se o parametro MV_TPVALOR == "N" => nao considera a condicao normal da conta.
			//So imprime sinal (-) se o saldo for credor.
			If cTipoSinal == "N"
				If lSinal
					cImpSaldo := nSaldo*(-1)// Transform(nSaldo*(-1),cPicture)
				Else
					cImpSaldo :=  ABS(nSaldo) // Transform(ABS(nSaldo),cPicture)
				EndIf
			Else
				cImpSaldo :=  Abs(nSaldo)//Transform(Abs(nSaldo),cPicture)+cCharSinal
			EndIf

			If lGraf
				If cIdentifi # Nil .And. cIdentifi $ "34"
					If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
						oPrint:Say(nLin,nCol,Transform(Abs(nSaldo),cPicture)+cCharSinal,oCouNew08N)
					Else
						oPrint:Say(nLin,nCol,Transform(Abs(nSaldo),cPicture)+cCharSinal,oCouNew08S)
					EndIf
				Else
					oPrint:Say(nLin,nCol,Transform(Abs(nSaldo),cPicture)+cCharSinal,oFont08)
				Endif
			ElseIf lSay
				@ nLin, nCol pSay Transform(Abs(nSaldo),cPicture)+cCharSinal
			Endif
		Else
			//Utiliza conceito de conta estourada e a conta eh redutora.
			If Select("cArqTmp") > 0 .And. cArqTmp->(FieldPos("ESTOUR")) <> 0 .And.  cArqTmp->ESTOUR == "1"
				If cTipo == "1" 								// Conta Devedora
					If cTipoSinal == "S"              			// Sinal
						If !lSinal
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf
						If lGraf
							cImpSaldo := nSaldo//  Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Else
							cImpSaldo := nSaldo//Transform(nSaldo,cPicture)
						Endif
					ElseIf (cTipoSinal) == "P"              	// Parenteses
						If !lSinal
							nSaldo := Abs(nSaldo)
						EndIf

						If !lInformada
							If (Len(cPicture) + 2) > nTamanho
								cPicture := SubStr(cPicture,(Len(cPicture) + 3)-nTamanho,Len(cPicture))
							EndIf
							cPicture := "@E( " + cPicture

						ElseIf nSaldo < 0
							IF AT("@E", cPicture) > 0
								cPicAux  := SubStr(cPicture,AT(" ",cPicture),Len(cPicture))
								If (Len(cPicAux) + 2) > nTamanho
									cPicAux := SubStr(cPicAux,(Len(cPicture) + 3)-nTamanho,Len(cPicture))
								EndIf
								cPicture := "@E( " + cPicAux
							Else
								cPicture := "@E( " + cPicture
							EndIf

						EndIf

						If lGraf
							cImpSaldo := nSaldo// Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol pSay nSaldo Picture cPicture
						Else
							cImpSaldo := Transform(nSaldo,cPicture)
						Endif
					EndIf
				Else
					If (cTipoSinal) == "S"                  	// Sinal
						If lSinal
							nSaldo := nSaldo * (-1)
						Else
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf
						If lGraf
							cImpSaldo := nSaldo//Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Else
							cImpSaldo := nSaldo//Transform(nSaldo,cPicture)
						Endif
					ElseIf (cTipoSinal) == "P"              // Parenteses
						If lSinal
							nSaldo := nSaldo * (-1)
						Else
							nSaldo := Abs(nSaldo)
						EndIf

						If !lInformada
							If (Len(cPicture) + 2) > nTamanho
								cPicture := SubStr(cPicture,(Len(cPicture) + 3)-nTamanho,Len(cPicture))
							EndIf
							cPicture := "@E( " + cPicture

						ElseIf nSaldo < 0
							IF AT("@E", cPicture) > 0
								cPicAux  := SubStr(cPicture,AT(" ",cPicture),Len(cPicture))
								If (Len(cPicAux) + 2) > nTamanho
									cPicAux := SubStr(cPicAux,(Len(cPicture) + 3)-nTamanho,Len(cPicture))
								EndIf
								cPicture := "@E( " + cPicAux
							Else
								cPicture := "@E( " + cPicture
							EndIf

						EndIf

						If lGraf
							cImpSaldo := nSaldo// Transform(nSaldo,cPicture)			// Debito
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol pSay nSaldo Picture cPicture
						Else
							cImpSaldo := nSaldo//Transform(nSaldo,cPicture)
						Endif
					EndIf
				EndIf
			Else	//Se nao utiliza conceito de conta estourada
				If cTipo == "1" 								// Conta Devedora
					If cTipoSinal == "S"              			// Sinal
						If lSinal
							nSaldo := nSaldo * (-1)
						Else
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf
						If lGraf
							cImpSaldo := nSaldo// Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Else
							cImpSaldo := nSaldo// Transform(nSaldo,cPicture) ///Transform(nSaldo,cPicture) eet
						Endif
					ElseIf (cTipoSinal) == "P"              	// Parenteses
						If lSinal
							nSaldo := nSaldo * (-1) 		  		// a Picture so exibe parenteses para numeros negativos
						Else
							nSaldo := Abs(nSaldo)
						EndIf

						If !lInformada
							If (Len(cPicture) + 2) > nTamanho
								cPicture := SubStr(cPicture,(Len(cPicture) + 3)-nTamanho,Len(cPicture))
							EndIf
							cPicture := "@E( " + cPicture

						ElseIf nSaldo < 0
							IF AT("@E", cPicture) > 0
								cPicAux  := SubStr(cPicture,AT(" ",cPicture),Len(cPicture))
								If (Len(cPicAux) + 2) > nTamanho
									cPicAux := SubStr(cPicAux,(Len(cPicture) + 3)-nTamanho,Len(cPicture))
								EndIf
								cPicture := "@E( " + cPicAux
							Else
								cPicture := "@E( " + cPicture
							EndIf

						EndIf

						If lGraf
							cImpSaldo := nSaldo//Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture) /*cImpSaldo*/,oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,cImpSaldo,oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol pSay nSaldo Picture cPicture
						Else
							cImpSaldo := nSaldo//Transform(nSaldo,cPicture)
							//cImpSaldo := PADL(STRTRAN(cImpSaldo,' ',''),len(cImpSaldo))
						Endif
					EndIf
				Else
					If (cTipoSinal) == "S"                  	// Sinal
						If !lSinal .And. cTipo == "2" 			// Conta Credora
							nSaldo := Abs(nSaldo)
						EndIf
						If !lInformada
							cPicture := "@E " + cPicture
						EndIf
						If lGraf
							cImpSaldo := nSaldo //Transform(nSaldo,cPicture)
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol PSAY nSaldo Picture cPicture
						Else
							cImpSaldo := nSaldo //Transform(nSaldo,cPicture)
						Endif
					ElseIf (cTipoSinal) == "P"              // Parenteses
						If !lSinal .And. cTipo == "2" 			// Conta Credora
							nSaldo := Abs(nSaldo)
						EndIf

						If !lInformada
							If (Len(cPicture) + 2) > nTamanho
								cPicture := SubStr(cPicture,(Len(cPicture) + 3)-nTamanho,Len(cPicture))
							EndIf
							cPicture := "@E( " + cPicture

						ElseIf nSaldo < 0
							IF AT("@E", cPicture) > 0
								cPicAux  := SubStr(cPicture,AT(" ",cPicture),Len(cPicture))
								If (Len(cPicAux) + 2) > nTamanho
									cPicAux := SubStr(cPicAux,(Len(cPicture) + 3)-nTamanho,Len(cPicture))
								EndIf
								cPicture := "@E( " + cPicAux
							Else
								cPicture := "@E( " + cPicture
							EndIf

						EndIf

						If lGraf
							cImpSaldo := nSaldo//Transform(nSaldo,cPicture)			// Debito
							If cIdentifi # Nil .And. cIdentifi $ "34"
								If cIdentifi == "3" .And. Type("oCouNew08N") <> "U"
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08N)
								Else
									oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oCouNew08S)
								EndIf
							Else
								oPrint:Say(nLin,nCol,Transform(nSaldo,cPicture),oFont08)
							Endif
						ElseIf lSay
							@ nLin, nCol pSay nSaldo Picture cPicture
						Else
							cImpSaldo := nSaldo//Transform(nSaldo,cPicture)
						Endif
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	RestArea(aSaveArea)

	If lSay
		Return
	Else
		If Empty( cImpSaldo )
			If lPrintZero
				cImpSaldo := nSaldo//Transform(nSaldo,cPicture)
			EndIf
		EndIf
		Return cImpSaldo
	EndIf

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DecimalCTB ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 15.12.99 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica o numero de decimais                               			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³DecimalCTB(aSetOfBook,cMoeda)										     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³nDecimais                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array ref. aSetOfBook             	                 		 ³±±
±±³          ³ ExpC1 = Moeda                                             		     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function DecimalCTB(aSetOfBook,cMoeda)

	Local aSaveArea := GetArea()
	Local nDecimais := 0

	//Se nao estiver usando configuracao de livros, considera o numero de casas decimais do cadastro
	//de moedas
	If Empty(aSetOfBook[1])
		dbSelectArea("CTO")
		dbSetOrder(1)
		If MsSeek(xFilial()+cMoeda) .And. nDecimais <> CTO->CTO_DECIM
			nDecimais := CTO->CTO_DECIM
		EndIf
	Else
		//Se a picture nao estiver preenchida, considera o numero de casas decimais da configuracao de
		//livros. Se a picture estiver preenchida, ira considerar as casas decimais da picture.
		If Empty(aSetOfBook[4])
			nDecimais	:= aSetOfBook[3]
		EndIf
	EndIf

	RestArea(aSaveArea)

Return nDecimais