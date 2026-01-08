#Include "PROTHEUS.Ch"
#Include "RwMake.ch"
#Include "TopConn.ch"
#INCLUDE "REPORT.CH"
#INCLUDE "COLORS.CH"
#Include "uctbr070.ch"

#DEFINE CENTRO_CUSTO	1
#DEFINE ITEM_CONTABIL	2
#DEFINE CLASSE_VALOR 	3
#DEFINE VALOR_DEBITO 	4
#DEFINE VALOR_CREDITO	5
#DEFINE CODIGO_HP    	6
#DEFINE HISTORICO    	7
#define TAM_CEL			18

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CtbcR070	³ Autor ³ Pilar S Albaladejo	³ Data ³ 12.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferencia de Digitacao 			MODIF  12/04/17		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CtbcR070()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CtbcR070(nOrigen)
	PRIVATE titulo		:= ""
	Private nomeprog	:= "UCTBR070"
	Private iCondBol      := .F.
	default nOrigen:= 2	// 1=Visualizar ;  2=Browser
	private ndTOtDlCred	 	:= 0// total crédito dólar Nahim 27/09/2019
	private ndTOtDlDeb	 	:= 0// total debito dólar Nahim 27/09/2019

	//	If FindFunction("TRepInUse") .And. TRepInUse()
	UCTBR070R4(nOrigen)
	//Else
	//Return UCTBR070R3(iCondBol)
	//	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR070R4 ³ Autor³ Daniel Sakavicius		³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferencia de Digitacao - R4           	 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR070R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function UCTBR070R4(nOrigen)

	PRIVATE CPERG	   	:= "CTR070"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//UCTR070SX1()
	//alert(nOrigen)
	//alert(M->CDOC)
	if(nOrigen == 2)
		AjustaSx1()
	endif
	Pergunte( CPERG, .F. )
	oReport := ReportDef()

	IF ValType( oReport ) == "O"
		if funname() == "CTBA102"
			oReport :PrintDialog()
		else
			oReport :Print()
		end
	ENDIF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 20/07/06 ³±±
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
	Local oReport
	local aArea	   		:= GetArea()
	Local cReport		:= "UCTBR"
	Local cTitulo		:= STR0004				   			// "Conferencia de Digitacao - Modelo 1"
	Local cDesc			:= STR0001+STR0002			  		// "Este programa ira imprimir o Relatorio para Conferencia"
	Local cDifDC  		:= ""
	Local cDifIF		:= ""
	Local cDiger		:= ""
	Local cCredito		:= ""
	Local cDebito		:= ""
	Local cCorrel		:= ""

	Local aTamConta		:= TAMSX3("CT1_CONTA")
	Local cSayItem		:= CtbSayApro("CTD")
	Local cSayCC		:= CtbSayApro("CTT")
	Local cSayCV		:= CtbSayApro("CTH")
	PRIVATE cPerg		:= "CTR070"
	Private cPictVal  := PesqPict("CT2","CT2_VALOR")

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

	If cPaisLoc == "BOL"
		cReport := cReport + cValToChar(Randomize( 100, 999 ))
		oReport	:= TReport():New( cReport,cTitulo,cPerg, { |oReport| RPrintBol( oReport ) }, cDesc )
		// nahim cambios
		oreport:nfontbody:= 8 // 7
		oreport:cfontbody:="Arial"
		iCondBol := .T.
		oReport:ShowParamPage()
		oReport:lParamPage := .F.
	Else
		cReport := cReport + cValToChar(Randomize( 100, 999 ))
		// nahim cambios Terrazas 1
		oReport	:= TReport():New( cReport,cTitulo,cPerg, { |oReport| ReportPrint( oReport ) }, cDesc )
		//oReport:ShowParamPage()
		//oReport:lParamPage := .F.
		oreport:nfontbody:= 8
		oreport:cfontbody:="Arial"
	EndIf

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
	oSection0  := TRSection():New( oReport, STR0032, {"CTC"},, .F., .F. )	//"Resumido"

	TRCell():New( oSection0, "CTC_DATA"  , "CTC",STR0036/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)  //DATA
	TRCell():New( oSection0, "CTC_LOTE"  , "CTC",STR0037/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)  //LOTE
	TRCell():New( oSection0, "CTC_SBLOTE", "CTC",STR0038/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)  //SUB LOTE
	TRCell():New( oSection0, "CTC_DOC"   , "CTC",STR0039/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)   //DOCUMENTO
	//TRCell():New( oSection0, "CTC_INF"   , "CTC",STR0040+" "+STR0041/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)   //TOTAL INFORMADO
	TRCell():New( oSection0, "CTC_DEBITO", "CTC",STR0042/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")  //VALOR A DEBITO
	TRCell():New( oSection0, "CTC_CREDIT", "CTC",STR0043/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")  //VALOR A CREDITO
	//TRCell():New( oSection0, "CDIFDC"    ,,STR0044,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")  //DIFERENCA
	TRCell():New( oSection0, "CTC_DIG"   , "CTC",STR0040+" "+STR0045/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)  //TOTAL DIGITADO
	//TRCell():New( oSection0, "CDIFIF"    ,,STR0046,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")  //"DIFERENCA INF/DIG"

	oSection1  := TRSection():New( oReport, STR0033, {"CT2"},, .F., .F. )	//"Completo"

	TRCell():New( oSection1, "CT2_DATA"  , "CT2",STR0012/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "CT2_LOTE"  , "CT2",STR0013/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "CT2_SBLOTE", "CT2",STR0017/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "CT2_DOC"   , "CT2",STR0014/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "CFISCAL"   , ,STR0055/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
	TRCell():New( oSection1, "CCORREL"   , ,STR0054/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)

	oSection11  := TRSection():New( oSection1, STR0034, {"CT2"},, .F., .F. )	//"Lancamentos Contabeis"

	//oPrn:Box( nLinInicial + 785 , 80 ,  2560 , 2370 )
	//oPrn:Box( nLinInicial + 155 , 1600 ,  325 , 2370 )

	If iCondBol
		//TRCell():New( oSection11, "CT2_LINHA" 	, "CT2",STR0047/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		//TRCell():New( oSection11, "CT2_DC"    	, "CT2",STR0048/*Titulo*/,/*Picture*/,4/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		//	TRCell():New( oSection11, "CCONTA"		, ,STR0049,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		//	TRCell():New( oSection11, "CCONTAD"		, ,STR0049+" "+STR0010,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		//	TRCell():New( oSection11, "CCONTAC"		, ,STR0049+" "+STR0011,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		//	TRCell():New( oSection11, "CNCONTA"		, ,STR0053,/*Picture*/,-10/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)	//Nombre de cuenta

		//	TRCell():New( oSection11, "CT2_HIST"  	, "CT2",STR0052/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		//TRCell():New( oSection11, "CCUSTO" 		, ,cSayCC/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		//TRCell():New( oSection11, "CITEM" 		, ,cSayItem/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		//TRCell():New( oSection11, "CCLASSE"		, ,cSayCV/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		//	TRCell():New( oSection11, "CDEBITO" 	, ,STR0050+" "+STR0010,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
		//	TRCell():New( oSection11, "CCREDITO" 	, ,STR0050+" "+STR0011,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
		//TRCell():New( oSection11, "CT2_HP" 		, ,STR0051,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
	Else
		TRCell():New( oSection11, "CT2_LINHA" 	, "CT2",STR0047/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		TRCell():New( oSection11, "CT2_DC"    	, "CT2",STR0048/*Titulo*/,/*Picture*/,4/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		TRCell():New( oSection11, "CCONTA"		, ,STR0049,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		TRCell():New( oSection11, "CCONTAD"		, ,STR0049+" "+STR0010,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		TRCell():New( oSection11, "CCONTAC"		, ,STR0049+" "+STR0011,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		TRCell():New( oSection11, "CNCONTA"		, ,STR0053,/*Picture*/,-10/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)	//Nombre de cuenta
		TRCell():New( oSection11, "CCUSTO" 		, ,cSayCC/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		TRCell():New( oSection11, "CITEM" 		, ,cSayItem/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		TRCell():New( oSection11, "CCLASSE"		, ,cSayCV/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		TRCell():New( oSection11, "CDEBITO" 	, ,STR0050+" "+STR0010,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
		TRCell():New( oSection11, "CCREDITO" 	, ,STR0050+" "+STR0011,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
		///TRCell():New( oSection11, "CT2_HP" 		, ,STR0051,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
		TRCell():New( oSection11, "CT2_HIST"  	, "CT2",STR0017/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)

	Endif
	oSection11:SetHeaderPage(.T.)

	oSection2  := TRSection():New( oReport, STR0035,,, .F., .F. )	//"Totais"

	TRCell():New( oSection2, "TOT_DESCRI" ,,,,64/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)	//Total Debito
	TRCell():New( oSection2, "TOT_DEBITO" ,,OemToAnsi(STR0010),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//Total Debito
	TRCell():New( oSection2, "TOT_CREDITO",,OemToAnsi(STR0011),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//Total Credito

	If mv_par22 == 1
		TRCell():New( oSection2, "TOT_INF"    ,,OemToAnsi(STR0025),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//"Total Informado"
		TRCell():New( oSection2, "TOT_DIG"    ,,OemToAnsi(STR0026),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//"Total "
		TRCell():New( oSection2, "TOT_DIFINF" ,,OemToAnsi(STR0027),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//"Diferenca:"
	Endif

	oSection2:Cell("TOT_DESCRI"):HideHeader()
	oSection2:Cell("TOT_DEBITO"):HideHeader()
	oSection2:Cell("TOT_CREDITO"):HideHeader()

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 20/07/06 ³±±
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
Static Function ReportPrint( oReport )

	Local oSection0 	:= oReport:Section(1)
	Local oSection1 	:= oReport:Section(2)
	Local oSection11 	:= oReport:Section(2):Section(1)
	Local oSection2 	:= oReport:Section(3)
	Local lTotal		:= (mv_par13 == 1)
	Local lTot123 		:= If( cPaisLoc = "CHI", mv_par24 == 1, mv_par22 == 1)
	Local lResumo		:= (mv_par17 == 1)
	Local cMoeda		:= mv_par07
	Local cQuery		:= "CT2"
	Local n				:= 0
	Local cLote			:= ""
	Local cSubLote		:= ""
	Local cDoc      	:= ""
	Local cLoteRes      := ""
	Local cSubRes		:= ""
	Local cDocRes    	:= ""
	Local nTotalDeb	 	:= 0
	Local nTotalCrd	 	:= 0
	Local nTotLotDeb	:= 0
	Local nTotLotCrd 	:= 0
	Local nTotGerDeb 	:= 0
	Local nTotGerCrd 	:= 0
	Local nTotGerInf 	:= 0
	Local nTotGerDig 	:= 0
	Local nDifInf	 	:= 0
	Local cDebit	 	:= "1"
	Local cCredit	 	:= "2"
	Local cPdobr	 	:= "3"
	Local nStr		 	:= 0
	Local cFilUser	 	:= ".T."
	Local lAllSL		:= If(Empty(mv_par11) .or. mv_par11=="*",.T.,.F.)

	If lResumo
		oSection1:Disable()
		oSection11:Disable()
		oSection2:Disable()

		cQuery	:= "CTC"
	Else
		oSection0:Disable()

		cQuery	:= "CT2"
	Endif

	If mv_par09 == 1
		lCusto := .T.
	Else
		oSection11:Cell("CCUSTO"):Disable()
		lCusto := .F.
	Endif

	If mv_par10 == 1
		lItem := .T.
	Else
		oSection11:Cell("CITEM"):Disable()
		lItem := .F.
	Endif

	If mv_par14 == 1
		lCV := .T.
	Else
		oSection11:Cell("CCLASSE"):Disable()
		lCV := .F.
	Endif

	aCtbMoeda  	:= CtbMoeda(mv_par07)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		Set Filter To
		Return
	Endif

	cDescMoeda 	:= Alltrim(aCtbMoeda[2])

	If mv_par17 == 1		// Resumido
		Titulo := STR0004+STR0022+cDescMoeda
	Else
		Titulo	:= STR0004+STR0030+cDescMoeda

	EndIf

	oReport:SetCustomText({|| CtCGCCabTR(,,,,,dDataBase,Titulo,,,,,oReport)} )

	//If lTot123
	//	oReport:SetLandScape(.T.)
	//Else
	//	oReport:SetPortrait(.T.)
	//EndIf

	oReport:SetLandscape(.F.)
	oReport:SetPortrait(.T.)
	oReport:nFontBody			:= 12
	oReport:cFontBody			:= "Times new roman"

	If lResumo // se imprimir no modo resumido
		cFilter := "CTC->CTC_FILIAL == '"+xFilial('CTC')+"' .and. "
		cFilter += "DTOS(CTC->CTC_DATA) >=  '"+DTOS(mv_par01)+"' .and. "
		cFilter += "DTOS(CTC->CTC_DATA) <=  '"+DTOS(mv_par02)+"' .and. "
		cFilter += "CTC->CTC_LOTE >= '"+mv_par03+"' .and. "
		cFilter += "CTC->CTC_LOTE <= '"+mv_par04+"' .and. "
		cFilter += "CTC->CTC_DOC >= '"+mv_par05+"' .and. "
		cFilter += "CTC->CTC_DOC <= '"+mv_par06+"' .and. "
		cFilter += "CTC->CTC_MOEDA  =  '"+mv_par07+"' .and. "
		cFilter += "CTC->CTC_CREDIT + CTC->CTC_DEBITO + CTC->CTC_DIG +  CTC->CTC_INF <> 0 "

		CTC->(DbSetOrder(1))
		CTC->(DbSeek(xFilial('CTC')+DTOS(mv_par01)+mv_par03+mv_par15+mv_par05))

		oSection0:SetFilter( cFilter )

		If mv_par12 == 1 //Lote
			oBreak2 := TRBreak():New( oSection0, {|| CTC->(Dtos(CTC_DATA)+CTC_LOTE) } )
			oBreak2:SetPageBreak(.T.)

		ElseIf mv_par12 == 2 //Documento
			oBreak2 := TRBreak():New( oSection0, {|| CTC->(Dtos(CTC_DATA)+CTC_LOTE+CTC_SBLOTE+CTC_DOC) } )
			oBreak2:SetPageBreak(.T.)

		Endif

		If lTotal
			oBreak1 := TRBreak():New( oSection0, {|| CTC->(eof()) }, STR0019 )

			TRFunction():New(oSection0:Cell("CTC_INF"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CTC_DEBITO"), ,"SUM",oBreak1/*oBreak */,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CTC_CREDIT"), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CDIFDC"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CTC_DIG"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CDIFIF"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
		Endif

		oSection0:Cell("CDIFDC"):SetBlock( { || CTC->CTC_CREDIT - CTC->CTC_DEBITO } )
		oSection0:Cell("CDIFIF"):SetBlock( { || CTC->CTC_DIG - CTC->CTC_INF } )

		oSection0:Print()

	Else

		#IFDEF TOP
		If TcSrvType() <> "AS/400"

			oReport:NoUserFilter()

			cFilUser := oSection1:GetSqlExp()

			cQuery := "SELECT * FROM " + RetSqlName("CT2")     + " "
			cQuery += "WHERE CT2_FILIAL  = '" + xFilial("CT2") + "' AND "
			cQuery +=       "CT2_DATA   >= '" + DTOS(mv_par01) + "' AND "
			cQuery += 	    "CT2_DATA   <= '" + DTOS(mv_par02) + "' AND "
			cQuery += 	    "CT2_LOTE   >= '" + mv_par03 	   + "' AND "
			cQuery += 	    "CT2_LOTE   <= '" + mv_par04 	   + "' AND "
			cQuery += 	    "CT2_SBLOTE >= '" + mv_par15 	   + "' AND "
			cQuery += 		"CT2_SBLOTE <= '" + mv_par16 	   + "' AND "
			cQuery +=   	"CT2_DOC    >= '" + mv_par05 	   + "' AND "
			cQuery += 		"CT2_DOC    <= '" + mv_par06 	   + "' AND "
			cQuery += 		"CT2_MOEDLC = '"+ mv_par07 + "' AND "
			//	cQuery += 		"CT2_CLVLDB = '0"+ alltrim(str(mv_par24)) + "' AND "
			If !lAllSL
				cQuery += 		"CT2_TPSALD = '"+ mv_par11 + "' AND "
			EndIf
			cQuery += 		"CT2_DC <> '4' AND "

			If !Empty(cFilUser)
				cQuery += cFilUser + " AND "
			EndIf
			cQuery +=       "D_E_L_E_T_ = '' "
			cQuery += "ORDER BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA"

			cQuery := ChangeQuery(cQuery)
			/////INGRESADO
			If Select("cArqCT2") > 0
				dbSelectArea("cArqCT2")
				dbCloseArea()
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)

			aStrSTRU := CT2->(dbStruct())      //// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM

			For nStr := 1 to Len( CT2->(dbStruct()) )        //// LE A ESTRUTURA DA TABELA
				If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
					TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
				EndIf
			Next

			dbSelectArea("cArqCT2")
			cAliasCT2 := "cArqCT2"

			TRPosition():New(oSection1,"CT2",1,;
			{|| xFilial("CT2")+(cAliasCT2)->(DtoS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC) })

		Else
			#ENDIF
			dbSelectArea("CT2")
			dbSetOrder(1)
			dbSeek(xFilial()+DTOS(mv_par01)+mv_par03+mv_par15+mv_par05,.T.)

			cAliasCT2 := "CT2"

			cFilUser := oSection1:GetAdvplExpr()
			If !Empty(cFilUser)
				oSection1:SetFilter(cFilUser)
			EndIf

			#IFDEF TOP
		EndIf
		#ENDIF

		// section 1
		oSection1:Cell( "CT2_DATA"   ):SetBlock( { || (cAliasCT2)->CT2_DATA	} )
		oSection1:Cell( "CT2_LOTE"   ):SetBlock( { || (cAliasCT2)->CT2_LOTE	} )
		oSection1:Cell( "CT2_SBLOTE" ):SetBlock( { || (cAliasCT2)->CT2_SBLOTE	} )
		oSection1:Cell( "CT2_DOC"    ):SetBlock( { || (cAliasCT2)->CT2_DOC 	} )
		//	oSection1:Cell( "CFISCAL"    ):SetBlock( { || aFiscal 	} )
		//	oSection1:Cell( "CCORREL"    ):SetBlock( { || aCorrAsiento 	} )

		If (CT2->CT2_LP=="575",Titulo:="COMPROBANTE DE INGRESO",If((cAliasCT2)->CT2_LP=="570",Titulo:="COMPROBANTE DE EGRESO",Titulo:="COMPROBANTE DE TRASPASO"))

		// section 11
		oSection11:Cell( "CT2_LINHA" ):SetBlock( { || (cAliasCT2)->CT2_LINHA	} )
		oSection11:Cell( "CT2_DC"    ):SetBlock( { || (cAliasCT2)->CT2_DC		} )
		///oSection11:Cell( "CT2_HP"    ):SetBlock( { || (cAliasCT2)->CT2_HP 		} )
		cGloss :=  (cAliasCT2)->CT2_HIST
		cGloss +=  iif(!empty((cAliasCT2)->CTT_DESC01)," - " + (cAliasCT2)->CTT_DESC01 ,"")
		cGloss +=  iif(!empty((cAliasCT2)->CTH_DESC01)," - " + (cAliasCT2)->CTH_DESC01 ,"")
		cGloss +=  iif(!empty((cAliasCT2)->CV0_DESC)," - " + (cAliasCT2)->CV0_DESC ,"")
		TRCell():New( oSection2:Cell( "CT2_HIST"  ):SetBlock( { || cGloss	} ))
		//		TRCell():New( oSection2,oSection11:Cell( "CT2_HIST"  ):SetBlock( { || (cAliasCT2)->CT2_HIST	} ))

		//	If lCusto .And. lItem .And. lCv //Se imprime C.C, Item E Cl.Valores
		oSection11:Cell( "CCONTAD" ):Disable()
		oSection11:Cell( "CCONTAC" ):Disable()
		/*	Else
		oSection11:Cell( "CCONTA" ):Disable()
		EndIf*/

		//imprimiendo titulo

		dbselectarea( cAliasCT2 )
		oReport:SetMeter( RecCount() )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define bloco de codigo com as variaveis para impressao das celulas de totais  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof() .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") .And. (cAliasCT2)->CT2_DATA <= mv_par02 .And. !oReport:Cancel()

			oReport:IncMeter()

			If oReport:Cancel()
				Exit
			EndIf

			#IFNDEF TOP
			If UCtr070Skip(cAliasCT2,lAllSL)
				Loop
			EndIf
			#ELSE
			If TcSrvType() == "AS/400"
				If UCtr070Skip(cAliasCT2,lAllSL)
					Loop
				EndIf
			EndIf
			#ENDIF

			cLote 		:= (cAliasCT2)->CT2_LOTE
			cSubLote 	:= (cAliasCT2)->CT2_SBLOTE
			cDoc		:= (cAliasCT2)->CT2_DOC
			dData 		:= (cAliasCT2)->CT2_DATA
			//		aFiscal     := Posicione("CTC",1,(cAliasCT2)->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_MOEDLC+CT2_TPSALD),"CTC_UTIPOF")
			//		aCorrAsiento := Posicione("CTC",1,(cAliasCT2)->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_MOEDLC+CT2_TPSALD),"CTC_USECAS")

			lFirst:= .T.
			nTotalDeb := 0
			nTotalCrd := 0

			oSection1:Init()
			oSection1:PrintLine()
			oSection1:Finish()

			oSection11:Init()

			While (cAliasCT2)->(!Eof()) .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") 	.And.;
			Dtos((cAliasCT2)->CT2_DATA) == Dtos(dData) 	.And.;
			(cAliasCT2)->CT2_LOTE == cLote 				.And.;
			(cAliasCT2)->CT2_SBLOTE == cSubLote 		.And.;
			(cAliasCT2)->CT2_DOC == cDoc

				oReport:IncMeter()

				If oReport:Cancel()
					Exit
				EndIf

				#IFNDEF TOP
				If UCtr070Skip(cAliasCT2,lAllSL)
					Loop
				EndIf
				#ELSE
				If TcSrvType() == "AS/400"
					If UCtr070Skip(cAliasCT2,lAllSL)
						Loop
					EndIf
				EndIf
				#ENDIF

				oSection11:Cell( "CT2_LINHA" ):SetBlock( { || (cAliasCT2)->CT2_LINHA	} )

				///If lCusto .And. lItem .And. lCv //Se imprime C.C, Item E Cl.Valores
				If (cAliasCT2)->CT2_DC = "1"

					oSection11:Cell("CT2_DC"):SetBlock( { || cDebit } )
					oSection11:Cell("CCONTA"):SetBlock( { || (cAliasCT2)->CT2_DEBITO } )
					oSection11:Cell("CNCONTA"):SetBlock( { || Posicione("CT1",1,xFilial("CT1")+(cAliasCT2)->CT2_DEBITO,'CT1_DESC01') } )

					If mv_par09 == 1
						oSection11:Cell("CCUSTO"):SetBlock( { || UCtr070CTT((cAliasCT2)->CT2_CCD) } )
					Endif

					If mv_par10 == 1
						oSection11:Cell("CITEM"):SetBlock( { || UCtr070CTD((cAliasCT2)->CT2_ITEMD) } )
					Endif
					If mv_par14 == 1
						oSection11:Cell("CCLASSE"):SetBlock( { || Ctr070CTH((cAliasCT2)->CT2_CLVLDB) } )
					Endif
					oSection11:Cell("CDEBITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )

					///oSection11:Cell( "CT2_HP"    ):SetBlock( { || (cAliasCT2)->CT2_HP 		} )
					//					TRCell():New( oSection2:Cell( "CT2_HIST"  ):SetBlock( { || (cAliasCT2)->CT2_HIST	} )) NTP 20190805
					cGloss :=  (cAliasCT2)->CT2_HIST
					cGloss +=  iif(!empty((cAliasCT2)->CTT_DESC01)," - " + (cAliasCT2)->CTT_DESC01 ,"")
					cGloss +=  iif(!empty((cAliasCT2)->CTH_DESC01)," - " + (cAliasCT2)->CTH_DESC01 ,"")
					cGloss +=  iif(!empty((cAliasCT2)->CV0_DESC)," - " + (cAliasCT2)->CV0_DESC ,"")
					TRCell():New( oSection2:Cell( "CT2_HIST"  ):SetBlock( { || cGloss	} ))

					oSection11:PrintLine()
					//					alert("if")

					nTotalDeb += (cAliasCT2)->CT2_VALOR
					nTotGerDeb+= (cAliasCT2)->CT2_VALOR
					nTotLotDeb+= (cAliasCT2)->CT2_VALOR
					(cAliasCT2)->( DbSkip() )

				ElseIf (cAliasCT2)->CT2_DC = "2"
					oSection11:Cell("CT2_DC"):SetBlock( { || cCredit } )
					oSection11:Cell("CCONTA"):SetBlock( { || (cAliasCT2)->CT2_CREDITO } )
					oSection11:Cell("CNCONTA"):SetBlock( { || Posicione("CT1",1,xFilial("CT1")+(cAliasCT2)->CT2_CREDITO,'CT1_DESC01') } )
					If mv_par09 == 1
						oSection11:Cell("CCUSTO"):SetBlock( { || UCtr070CTT((cAliasCT2)->CT2_CCC) } )
					Endif
					If mv_par10 == 1
						oSection11:Cell("CITEM"):SetBlock( { || UCtr070CTD((cAliasCT2)->CT2_ITEMC) } )
					Endif
					If mv_par14 == 1
						oSection11:Cell("CCLASSE"):SetBlock( { || UCtr070CTH((cAliasCT2)->CT2_CLVLCR) } )
					Endif

					oSection11:Cell("CCREDITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )

					///oSection11:Cell( "CT2_HP"    ):SetBlock( { || (cAliasCT2)->CT2_HP 		} )
					cGloss :=  (cAliasCT2)->CT2_HIST
					cGloss +=  iif(!empty((cAliasCT2)->CTT_DESC01)," - " + (cAliasCT2)->CTT_DESC01 ,"")
					cGloss +=  iif(!empty((cAliasCT2)->CTH_DESC01)," - " + (cAliasCT2)->CTH_DESC01 ,"")
					cGloss +=  iif(!empty((cAliasCT2)->CV0_DESC)," - " + (cAliasCT2)->CV0_DESC ,"")
					//					oSection2:Cell( "CT2_HIST"  ):SetBlock( { || (cAliasCT2)->CT2_HIST	} ) NTP 20190805
					oSection2:Cell( "CT2_HIST"  ):SetBlock( { || cGloss	} )

					oSection11:PrintLine()

					nTotalCrd += (cAliasCT2)->CT2_VALOR
					nTotGerCrd+= (cAliasCT2)->CT2_VALOR
					nTotLotCrd+= (cAliasCT2)->CT2_VALOR

					(cAliasCT2)->( DbSkip() )

				ElseIf (cAliasCT2)->CT2_DC = "3"
					// Imprime quando for Partida dobrada

					For n := 1 TO 2
						dbSelectArea( cAliasCT2 )

						oSection11:Cell( "CT2_LINHA" ):SetBlock( { || (cAliasCT2)->CT2_LINHA	} )
						oSection11:Cell( "CT2_DC" ):SetBlock( { || iif( n == 1 , '1' , '2' ) } )

						If mv_par08 == 2
							dbSelectArea("CT1")

							If n == 1
								dbSeek( xFilial( "CT1" ) + (cAliasCT2)->CT2_DEBITO)
							Else
								dbSeek( xFilial( "CT1" ) + (cAliasCT2)->CT2_CREDIT)
							Endif

							oSection11:Cell("CCONTA"):SetBlock( { || CT1->CT1_RES} )

							dbSelectArea( cAliasCT2 )
						Else
							oSection11:Cell("CCONTA"):SetBlock( { || iif( n == 1 , (cAliasCT2)->CT2_DEBITO , (cAliasCT2)->CT2_CREDIT )})
						Endif

						If mv_par09 == 1
							oSection11:Cell("CCUSTO"):SetBlock( { || iif( n == 1 , UCtr070CTT((cAliasCT2)->CT2_CCD) , UCtr070CTT((cAliasCT2)->CT2_CCC) )})
						Endif

						If mv_par10 == 1
							oSection11:Cell("CITEM"):SetBlock( { || iif( n == 1 , UCtr070CTD((cAliasCT2)->CT2_ITEMD) , UCtr070CTD((cAliasCT2)->CT2_ITEMC) )})
						Endif

						If mv_par14 == 1
							oSection11:Cell("CCLASSE"):SetBlock( { || iif( n == 1 , UCtr070CTH((cAliasCT2)->CT2_CLVLDB),UCtr070CTH((cAliasCT2)->CT2_CLVLCR))})
						Endif

						nValor	:= (cAliasCT2)->CT2_VALOR

						If n == 1
							oSection11:Cell("CDEBITO"):SetBlock( { || nValor } )
							oSection11:Cell("CCREDITO"):SetBlock( { || 0 } )

							nTotalDeb += nValor
							nTotGerDeb+= nValor
							nTotLotDeb+= nValor
						Else
							oSection11:Cell("CDEBITO"):SetBlock( { || 0 } )
							oSection11:Cell("CCREDITO"):SetBlock( { || nValor } )

							nTotalCrd += nValor
							nTotGerCrd+= nValor
							nTotLotCrd+= nValor
						Endif

						If n == 1
							IF mv_par21 == 1
								///oSection11:Cell( "CT2_HP"    ):SetBlock( { || (cAliasCT2)->CT2_HP 		} )
								oSection2:Cell( "CT2_HIST"  ):SetBlock( { || (cAliasCT2)->CT2_HIST	} )
							EndIf

							oSection11:PrintLine()

							If mv_par21 == 1
								RpPrintHist( cAliasCT2 , oSection11 ) // faz a impressao do historico detalhado
							EndIf
						Endif
					Next

					(cAliasCT2)->( DbSkip() )
				Endif
				/*Else
				oSection11:Cell("CCONTA" ):Disable()

				oSection11:Cell("CCONTAD"):SetBlock( { || (cAliasCT2)->CT2_DEBITO } )
				oSection11:Cell("CCONTAC"):SetBlock( { || (cAliasCT2)->CT2_CREDIT } )

				If (cAliasCT2)->CT2_DC = "1"
				oSection11:Cell("CT2_DC"):SetBlock( { || cDebit } )
				oSection11:Cell("CDEBITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )
				oSection11:Cell("CCREDITO"):SetBlock( { || 0 } )

				If mv_par09 == 1
				oSection11:Cell("CCUSTO"):SetBlock( { || UCtr070CTT((cAliasCT2)->CT2_CCD) } )
				Endif

				If mv_par10 == 1
				oSection11:Cell("CITEM"):SetBlock( { || UCtr070CTD((cAliasCT2)->CT2_ITEMD) } )
				Endif

				If mv_par14 == 1
				oSection11:Cell("CCLASSE"):SetBlock( { || UCtr070CTH((cAliasCT2)->CT2_CLVLDB) } )
				Endif

				nTotalDeb += (cAliasCT2)->CT2_VALOR
				nTotGerDeb+= (cAliasCT2)->CT2_VALOR
				nTotLotDeb+= (cAliasCT2)->CT2_VALOR

				ElseIf (cAliasCT2)->CT2_DC = "2"

				oSection11:Cell("CT2_DC"):SetBlock( { || cCredit } )
				oSection11:Cell("CDEBITO"):SetBlock( { || 0 } )
				oSection11:Cell("CCREDITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )

				If mv_par09 == 1
				oSection11:Cell("CCUSTO"):SetBlock( { || UCtr070CTT((cAliasCT2)->CT2_CCC) } )
				Endif

				If mv_par10 == 1
				oSection11:Cell("CITEM"):SetBlock( { || UCtr070CTD((cAliasCT2)->CT2_ITEMC) } )
				Endif

				If mv_par14 == 1
				oSection11:Cell("CCLASSE"):SetBlock( { || UCtr070CTH((cAliasCT2)->CT2_CLVLCR) } )
				Endif

				nTotalCrd += (cAliasCT2)->CT2_VALOR
				nTotGerCrd+= (cAliasCT2)->CT2_VALOR
				nTotLotCrd+= (cAliasCT2)->CT2_VALOR
				Else
				oSection11:Cell("CT2_DC"):SetBlock( { || cPdobr })
				oSection11:Cell("CDEBITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )
				oSection11:Cell("CCREDITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )

				If mv_par09 == 1
				oSection11:Cell("CCUSTO"):SetBlock( { || UCtr070CTT((cAliasCT2)->CT2_CCC) } )
				Endif

				If mv_par10 == 1
				oSection11:Cell("CITEM"):SetBlock( { || UCtr070CTD((cAliasCT2)->CT2_ITEMC) } )
				Endif

				If mv_par14 == 1
				oSection11:Cell("CCLASSE"):SetBlock( { || UCtr070CTH((cAliasCT2)->CT2_CLVLCR) } )
				Endif

				nTotalDeb += (cAliasCT2)->CT2_VALOR
				nTotGerDeb+= (cAliasCT2)->CT2_VALOR
				nTotLotDeb+= (cAliasCT2)->CT2_VALOR
				nTotalCrd += (cAliasCT2)->CT2_VALOR
				nTotGerCrd+= (cAliasCT2)->CT2_VALOR
				nTotLotCrd+= (cAliasCT2)->CT2_VALOR
				Endif

				oSection11:PrintLine()
				Endif*/

				///oSection11:Cell( "CT2_HP"    ):SetBlock( { || (cAliasCT2)->CT2_HP 		} )
				///oSection11:Cell( "CT2_HIST"  ):SetBlock( { || (cAliasCT2)->CT2_HIST	} )
				///oSection11:PrintLine()

				// faz a impressao do historico detalhado
				RpPrintHist( cAliasCT2 , oSection11 ) // IMPRIME EL 4

				oReport:IncMeter()
			Enddo

			oSection11:Finish()

			If lTotal
				oSection2:Cell( "TOT_DESCRI" ):SetBlock( { || STR0018 } )	// "TOTAL DOCUMENTO"
				oSection2:Cell( "TOT_DEBITO" ):SetBlock( { || Transform(nTotalDeb,Tm(nTotalDeb, 17) ) } )
				oSection2:Cell( "TOT_CREDITO"):SetBlock( { || Transform(nTotalCrd,Tm(nTotalCrd, 17) ) } )
				/*If lTot123
				CTC->(DbSetOrder(1))
				CTC->(MsSeek(xFilial("CTC")+dtos(dData)+cLote+cSubLote+cDoc+cMoeda))
				nTotGerInf += CTC->CTC_INF
				nTotGerDig += CTC->CTC_DIG
				oSection2:Cell( "TOT_INF"    ):SetBlock( { || Transform(CTC->CTC_INF, Tm(CTC->CTC_INF, 17) ) } )
				oSection2:Cell( "TOT_DIG"    ):SetBlock( { || Transform(CTC->CTC_DIG, Tm(CTC->CTC_DIG, 17) ) } )
				oSection2:Cell( "TOT_DIFINF" ):SetBlock( { || Transform(CTC->CTC_DIG - CTC->CTC_INF, Tm(CTC->CTC_DIG, 17) ) } )
				Endif*/

				oSection2:Init()
				oSection2:PrintLine()
				oSection2:Finish()

				If mv_par12 == 2
					oReport:EndPage()
				EndIf

				nTotalDeb := 0
				nTotalCrd := 0

				If	cLote <> (cAliasCT2)->CT2_LOTE .Or.;
				cSubLote <> (cAliasCT2)->CT2_SBLOTE .Or.;
				DtoS(dData) <> DtoS((cAliasCT2)->CT2_DATA)
					oSection2:Cell( "TOT_DESCRI" ):SetBlock( { || STR0020 } )	// "TOTAL LOTE"
					oSection2:Cell( "TOT_DEBITO" ):SetBlock( { || Transform( nTotLotDeb, Tm(nTotLotDeb, 17) ) } )
					oSection2:Cell( "TOT_CREDITO"):SetBlock( { || Transform( nTotLotCrd, Tm(nTotLotCrd, 17) ) } )
					If lTot123
						CT6->(DbSetOrder(1))
						CT6->(MsSeek(xFilial("CT6")+dtos(dData)+cLote+cSubLote+cMoeda))
						oSection2:Cell( "TOT_INF"    ):SetBlock( { || Transform( CT6->CT6_INF, Tm( CT6->CT6_INF, 17 ) ) } )
						oSection2:Cell( "TOT_DIG"    ):SetBlock( { || Transform( CT6->CT6_DIG, Tm( CT6->CT6_DIG, 17 ) ) } )
						oSection2:Cell( "TOT_DIFINF" ):SetBlock( { || Transform( CT6->CT6_DIG - CT6->CT6_INF, Tm( CT6->CT6_DIG, 17 ) ) } )
					Endif

					oSection2:Init()
					oSection2:PrintLine()
					oSection2:Finish()

					If mv_par12 == 1
						oReport:EndPage()
					EndIf

					nTotLotDeb := 0
					nTotLotCrd := 0

				Endif

			Endif

		Enddo

	Endif

	If lTotal

		oSection2:Cell( "TOT_DESCRI" ):SetBlock( { || STR0019 } ) // "TOTAL GERAL"
		oSection2:Cell( "TOT_DEBITO" ):SetBlock( { || Transform( nTotGerDeb, Tm( nTotGerDeb, 17 ) ) } )
		oSection2:Cell( "TOT_CREDITO"):SetBlock( { || Transform( nTotGerCrd, Tm( nTotGerCrd, 17 ) ) } )

		If lTot123
			oSection2:Cell( "TOT_INF"    ):SetBlock( { || Transform( nTotGerInf, Tm(nTotGerInf, 17) ) } )
			oSection2:Cell( "TOT_DIG"    ):SetBlock( { || Transform( nTotGerDig, Tm(nTotGerDig, 17) ) } )
			oSection2:Cell( "TOT_DIFINF" ):SetBlock( { || Transform( nTotGerDig - nTotGerInf, Tm(nTotGerInf, 17) ) } )
		Endif

		oSection2:Init()
		oSection2:PrintLine()
		oSection2:Finish()

	Endif

Return

/////////////////////////////////
////////////////////////////////
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RPrintBol³ Autor ³ Ramiro Queso Cusi	³ Data ³ 17/04/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RPrintBol(oReport)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RPrintBol( oReport )

	Local oSection0 	:= oReport:Section(1)
	Local oSection1 	:= oReport:Section(2)
	Local oSection11 	:= oReport:Section(2):Section(1)
	Local oSection2 	:= oReport:Section(3)
	Local lTotal		:= (mv_par13 == 1)
	Local lTot123 		:= If( cPaisLoc = "CHI", mv_par24 == 1, mv_par22 == 1)
	Local lResumo		:= (mv_par17 == 1)
	Local cMoeda		:= mv_par07
	Local cQuery		:= "CT2"
	Local n				:= 0
	Local cLote			:= ""
	Local cSubLote		:= ""
	Local cDoc      	:= ""
	Local cLoteRes      := ""
	Local cSubRes		:= ""
	Local cDocRes    	:= ""
	Local cGlosa  		:= ""
	Local cDetalle  	:= ""
	Local cMesN  		:= ""
	Local nLinea		:= 0
	Local nTotalDeb	 	:= 0
	Local nTotalCrd	 	:= 0
	Local nTotLotDeb	:= 0
	Local nTotLotCrd 	:= 0
	Local nTotGerDeb 	:= 0
	Local nTotGerCrd 	:= 0
	Local nTotGerInf 	:= 0
	Local nTotGerDig 	:= 0
	Local nDifInf	 	:= 0
	Local cDebit	 	:= "1"
	Local cCredit	 	:= "2"
	Local cPdobr	 	:= "3"
	Local nStr		 	:= 0
	Private cSequencial    := ""
	Private cTipoCambio   := ""
	Private cTipoSus := ""
	Private cTipoUfv := ""
	Private SubTitulo     := ""
	Private cFilUser	 	:= ".T."
	Private lAllSL		:= If(Empty(mv_par11) .or. mv_par11=="*",.T.,.F.)
	Private lCabecera		:= .T.
	Private nPagina := 0
	oFont10T  := TFont():New("Times New Roman",,10,,.F.)
	oFont12T  := TFont():New("Times New Roman",,12,,.F.)
	oFont10TN := TFont():New("Times New Roman",,10,,.T.)
	oFont12TN := TFont():New("Times New Roman",,12,,.T.)
	oFont13TN := TFont():New("Times New Roman",,13,,.T.)
	oFont14TN := TFont():New("Times New Roman",,14,,.T.)
	oFont18TN := TFont():New("Times New Roman",,18,,.T.)
	oFont10T  := TFont():New("Arial",,9,,.F.)

	If lResumo
		oSection1:Disable()
		oSection11:Disable()
		oSection2:Disable()

		cQuery	:= "CTC"
	Else
		oSection0:Disable()

		cQuery	:= "CT2"
	Endif

	If mv_par09 == 1
		lCusto := .T.
	Else
		//oSection11:Cell("CCUSTO"):Disable()
		lCusto := .F.
	Endif

	If mv_par10 == 1
		lItem := .T.
	Else
		//oSection11:Cell("CITEM"):Disable()
		lItem := .F.
	Endif

	If mv_par14 == 1
		lCV := .T.
	Else
		//oSection11:Cell("CCLASSE"):Disable()
		lCV := .F.
	Endif

	aCtbMoeda  	:= CtbMoeda(mv_par07)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		Set Filter To
		Return
	Endif

	cDescMoeda 	:= Alltrim(aCtbMoeda[2])

	If mv_par17 == 1		// Resumido
		Titulo := STR0004+STR0022+cDescMoeda
	Else
		Titulo	:= STR0004+STR0030+cDescMoeda

	EndIf

	oReport:lParamPage := .F.
	////////////////////////////encabezado anulado
	oReport:lHeaderVisible  := .F.
	oReport:lFooterVisible  := .F.
	//If lTot123
	//	oReport:SetLandScape(.T.)
	//Else
	//	oReport:SetPortrait(.T.)
	//EndIf
	oReport:SetLandscape(.F.)
	oReport:SetPortrait(.T.)
	oReport:nFontBody			:= 10
	oReport:cFontBody			:= "Arial"

	If lResumo // se imprimir no modo resumido
		cFilter := "CTC->CTC_FILIAL == '"+xFilial('CTC')+"' .and. "
		cFilter += "DTOS(CTC->CTC_DATA) >=  '"+DTOS(mv_par01)+"' .and. "
		cFilter += "DTOS(CTC->CTC_DATA) <=  '"+DTOS(mv_par02)+"' .and. "
		cFilter += "CTC->CTC_LOTE >= '"+mv_par03+"' .and. "
		cFilter += "CTC->CTC_LOTE <= '"+mv_par04+"' .and. "
		cFilter += "CTC->CTC_DOC >= '"+mv_par05+"' .and. "
		cFilter += "CTC->CTC_DOC <= '"+mv_par06+"' .and. "
		cFilter += "CTC->CTC_MOEDA  =  '"+mv_par07+"' .and. "
		cFilter += "CTC->CTC_CREDIT + CTC->CTC_DEBITO + CTC->CTC_DIG +  CTC->CTC_INF <> 0 "

		CTC->(DbSetOrder(1))
		CTC->(DbSeek(xFilial('CTC')+DTOS(mv_par01)+mv_par03+mv_par15+mv_par05))

		oSection0:SetFilter( cFilter )

		If mv_par12 == 1 //Lote
			oBreak2 := TRBreak():New( oSection0, {|| CTC->(Dtos(CTC_DATA)+CTC_LOTE) } )
			oBreak2:SetPageBreak(.T.)

		ElseIf mv_par12 == 2 //Documento
			oBreak2 := TRBreak():New( oSection0, {|| CTC->(Dtos(CTC_DATA)+CTC_LOTE+CTC_SBLOTE+CTC_DOC) } )
			oBreak2:SetPageBreak(.T.)

		Endif

		If lTotal
			oBreak1 := TRBreak():New( oSection0, {|| CTC->(eof()) }, STR0019 )

			TRFunction():New(oSection0:Cell("CTC_INF"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CTC_DEBITO"), ,"SUM",oBreak1/*oBreak */,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CTC_CREDIT"), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CDIFDC"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CTC_DIG"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
			TRFunction():New(oSection0:Cell("CDIFIF"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
		Endif

		oSection0:Cell("CDIFDC"):SetBlock( { || CTC->CTC_CREDIT - CTC->CTC_DEBITO } )
		oSection0:Cell("CDIFIF"):SetBlock( { || CTC->CTC_DIG - CTC->CTC_INF } )
		oSection0:Print()

	Else

		#IFDEF TOP
		If TcSrvType() <> "AS/400"

			oReport:NoUserFilter()

			cFilUser := oSection1:GetSqlExp()
			/*
			cQuery := "SELECT * FROM " + RetSqlName("CT2")     + " "
			cQuery += "WHERE CT2_FILIAL  = '" + xFilial("CT2") + "' AND "
			cQuery +=       "CT2_DATA   >= '" + DTOS(mv_par01) + "' AND "
			cQuery += 	    "CT2_DATA   <= '" + DTOS(mv_par02) + "' AND "
			cQuery += 	    "CT2_LOTE   >= '" + mv_par03 	   + "' AND "
			cQuery += 	    "CT2_LOTE   <= '" + mv_par04 	   + "' AND "
			cQuery += 	    "CT2_SBLOTE >= '" + mv_par15 	   + "' AND "
			cQuery += 		"CT2_SBLOTE <= '" + mv_par16 	   + "' AND "
			cQuery +=   	"CT2_DOC    >= '" + mv_par05 	   + "' AND "
			cQuery += 		"CT2_DOC    <= '" + mv_par06 	   + "' AND "
			cQuery += 		"CT2_MOEDLC = '"+ mv_par07 + "' AND "*/
			//			cQuery := "SELECT isnull(VAL,0) VALOR," nahim 2019-08-14
			cQuery := "SELECT CASE	WHEN CT2_DC = 4 THEN 4 ELSE 0 END ORDEN," // Nahim  2019-09-26
			cQuery += "isnull(VAL,0) VALOR,"
			cQuery += "LEN(CT2_DEBITO) DEBITO,"
			//			cQuery += "CT21.*,CT22.*,isnull(CTH_DESC01,'') CTH_DESC01,isnull(CTT_DESC01,'') CTT_DESC01,isnull(CV0_DESC,'') CV0_DESC " Nahim 08/01/2020
			cQuery += "CT21.*,CT22.*,RTRIM(CT2_CLVLDB) + RTRIM(CT2_CLVLCR) + ' ' + isnull(CTH_DESC01,'') CTH_DESC01,"
			cQuery += "RTRIM(CT2_CCC) + RTRIM(CT2_CCD) + ' ' + isnull(CTT_DESC01,'') CTT_DESC01,"
			cQuery += "isnull(CV0_DESC,'') CV0_DESC, "
			cQuery += "RTRIM(CT2_ITEMC) + RTRIM(CT2_ITEMD) + ' ' + isnull(CTD_DESC01, '') CTD_DESC01"
			cQuery += " FROM " + RetSqlName("CT2") + " CT21 "
			cQuery += "LEFT JOIN "
			cQuery += "("
			cQuery += " SELECT CT2_VALOR VAL,CT2_FILIAL FILI, CT2_DATA DATA, CT2_LOTE LOTE, CT2_SBLOTE SBLOTE , CT2_DOC DOCUM, CT2_MOEDLC MONEDA, CT2_DC DC,CT2_TPSALD TPSAL,CT2_LINHA linha"
			cQuery += " from  "  + RetSqlName("CT2")  +" "
			cQuery += "WHERE CT2_FILIAL  = '" + xFilial("CT2") + "' AND "
			cQuery +=       "CT2_DATA   >= '" + DTOS(mv_par01) + "' AND "
			cQuery += 	    "CT2_DATA   <= '" + DTOS(mv_par02) + "' AND "
			cQuery += 	    "CT2_LOTE   >= '" + mv_par03 	   + "' AND "
			cQuery += 	    "CT2_LOTE   <= '" + mv_par04 	   + "' AND "
			cQuery += 	    "CT2_SBLOTE >= '" + mv_par15 	   + "' AND "
			cQuery += 		"CT2_SBLOTE <= '" + mv_par16 	   + "' AND "
			cQuery +=   	"CT2_DOC    >= '" + mv_par05 	   + "' AND "
			cQuery +=       "D_E_L_E_T_ LIKE '' AND "
			cQuery +=	   	"CT2_MOEDLC = '02'                      AND "
			cQuery += 		"CT2_DOC    <= '" + mv_par06 	   + "' ) CT22 On "
			cQuery += "   CT21.CT2_DATA   =  CT22.DATA   and   	"
			cQuery += "   CT21.CT2_LOTE   =  CT22.LOTE   and   	"
			cQuery += "   CT21.CT2_SBLOTE =  CT22.SBLOTE and   	"
			cQuery += "   CT21.CT2_DOC    =  CT22.DOCUM    and 	"
			cQuery += "   CT21.CT2_TPSALD =  CT22.TPSAL and    	"
			cQuery += "   CT21.CT2_DC     =  CT22.DC AND       	"
			cQuery += "   CT21.CT2_LINHA     =  CT22.Linha     	"
			cQuery += "  LEFT JOIN "  + RetSqlName("CTH")  +" CTH ON    	"
			cQuery += "  (CTH.CTH_CLVL = CT21.CT2_CLVLDB OR CTH.CTH_CLVL = CT21.CT2_CLVLCR)  	"
			cQuery += "  AND CTH.D_E_L_E_T_ =''    		"
			cQuery += "  LEFT JOIN "  + RetSqlName("CTT")  +" CTT ON     	"
			cQuery += "  (CTT.CTT_CUSTO = CT21.CT2_CCD OR CTT.CTT_CUSTO = CT21.CT2_CCC )  	"
			cQuery += "  AND CTT.D_E_L_E_T_ =''			"
			cQuery += "  LEFT JOIN "  + RetSqlName("CV0")  +" CV0 ON 	"
			cQuery += "  (CV0.CV0_CODIGO = CT21.CT2_EC05DB OR CV0.CV0_CODIGO = CT21.CT2_EC05CR ) "
			cQuery += "  AND CV0.D_E_L_E_T_ ='' and CV0_CODIGO <> '' "
			cQuery += "  LEFT JOIN "  + RetSqlName("CTD")  +" CTD ON 	"
			cQuery += "  (CTD.CTD_ITEM = CT21.CT2_ITEMC OR CTD.CTD_ITEM = CT21.CT2_ITEMD)  "
			cQuery += "  AND CTD.D_E_L_E_T_ ='' and CTD_ITEM <> '' "
			cQuery += "WHERE CT2_FILIAL  = '" + xFilial("CT2") + "' AND "
			cQuery +=       "CT2_DATA   >= '" + DTOS(mv_par01) + "' AND "
			cQuery += 	    "CT2_DATA   <= '" + DTOS(mv_par02) + "' AND "
			cQuery += 	    "CT2_LOTE   >= '" + mv_par03 	   + "' AND "
			cQuery += 	    "CT2_LOTE   <= '" + mv_par04 	   + "' AND "
			cQuery += 	    "CT2_SBLOTE >= '" + mv_par15 	   + "' AND "
			cQuery += 		"CT2_SBLOTE <= '" + mv_par16 	   + "' AND "
			cQuery +=   	"CT2_DOC    >= '" + mv_par05 	   + "' AND "
			cQuery += 		"CT2_DOC    <= '" + mv_par06 	   + "' AND "
			cQuery += 		"CT2_MOEDLC = '"+ mv_par07 + "' AND "

			//	cQuery += 		"CT2_CLVLDB = '0"+ alltrim(str(mv_par24)) + "' AND "
			If !lAllSL
				//				cQuery += 		"CT2_TPSALD = '"+ mv_par11 + "' AND " quitando TP_SALD NAHIM T 29/07/2019
			EndIf
			//			cQuery += 		"CT2_DC <> '4' AND "

			If !Empty(cFilUser)
				cQuery += cFilUser + " AND "
			EndIf
			cQuery +=       "CT21.D_E_L_E_T_ = '' "
			//			cQuery += "ORDER BY 1,CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA" Nahim 2019/08/14
			//			cQuery += "ORDER BY  1 ASC,3 DESC, CT2_VALOR desc,CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC"
			cQuery += "ORDER BY 1 DESC,3 DESC, CT2_VALOR desc,CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC" // Nahim 2019/09/26

			If __CUSERID = '000000'
				Aviso("",cQuery,{'ok'},,,,,.t.)
			endif
			cQuery := ChangeQuery(cQuery)
			/////INGRESADO
			If Select("cArqCT2") > 0
				dbSelectArea("cArqCT2")
				dbCloseArea()
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)

			aStrSTRU := CT2->(dbStruct())      //// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM

			For nStr := 1 to Len( CT2->(dbStruct()) )        //// LE A ESTRUTURA DA TABELA
				If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
					TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
				EndIf
			Next

			dbSelectArea("cArqCT2")
			cAliasCT2 := "cArqCT2"

			TRPosition():New(oSection1,"CT2",1,;
			{|| xFilial("CT2")+(cAliasCT2)->(DtoS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC) })

		Else
			#ENDIF
			dbSelectArea("CT2")
			dbSetOrder(1)
			dbSeek(xFilial()+DTOS(mv_par01)+mv_par03+mv_par15+mv_par05,.T.)

			cAliasCT2 := "CT2"

			cFilUser := oSection1:GetAdvplExpr()
			If !Empty(cFilUser)
				oSection1:SetFilter(cFilUser)
			EndIf

			#IFDEF TOP
		EndIf
		#ENDIF

		// section 1
		oSection1:Cell( "CT2_DATA"   ):SetBlock( { || (cAliasCT2)->CT2_DATA	} )
		oSection1:Cell( "CT2_LOTE"   ):SetBlock( { || (cAliasCT2)->CT2_LOTE	} )
		oSection1:Cell( "CT2_SBLOTE" ):SetBlock( { || (cAliasCT2)->CT2_SBLOTE	} )
		oSection1:Cell( "CT2_DOC"    ):SetBlock( { || (cAliasCT2)->CT2_DOC 	} )
		//	oSection1:Cell( "CFISCAL"    ):SetBlock( { || aFiscal 	} )
		//	oSection1:Cell( "CCORREL"    ):SetBlock( { || aCorrAsiento 	} )

		// section 11
		//oSection11:Cell( "CT2_LINHA" ):SetBlock( { || (cAliasCT2)->CT2_LINHA	} )
		//oSection11:Cell( "CT2_DC"    ):SetBlock( { || (cAliasCT2)->CT2_DC		} )
		///oSection11:Cell( "CT2_HP"    ):SetBlock( { || (cAliasCT2)->CT2_HP 		} )
		//oSection11:Cell( "CT2_HIST"  ):SetBlock( { || (cAliasCT2)->CT2_HIST	} )

		//	If lCusto .And. lItem .And. lCv //Se imprime C.C, Item E Cl.Valores
		//oSection11:Cell( "CCONTAD" ):Disable()
		//oSection11:Cell( "CCONTAC" ):Disable()
		/*	Else
		oSection11:Cell( "CCONTA" ):Disable()
		EndIf*/

		dbselectarea( cAliasCT2 )
		oReport:SetMeter( RecCount() )

		clancPadr :=(cAliasCT2)->CT2_LP // Nahim 18/05/2020
		nContInd = 1// Nahim 18/05/2020 sólo para que tome el valor del segundo item
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define bloco de codigo com as variaveis para impressao das celulas de totais  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		While !Eof() .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") .And. (cAliasCT2)->CT2_DATA <= mv_par02 .And. !oReport:Cancel()
			lCabecera := .T.
			If ((cAliasCT2)->CT2_LP=="575",Titulo:="COMPROBANTE DE INGRESO",If((cAliasCT2)->CT2_LP=="570",Titulo:="COMPROBANTE DE EGRESO",Titulo:="COMPROBANTE DE TRASPASO"))
			If (cAliasCT2)->CT2_TPSALD=="9"
				Titulo:= "BORRADOR"
			ENDIF
			nPagina := 0

			/*Titulo := "COMPROBANTE DE "
			If Substr((cAliasCT2)->CT2_SEGOFI,1,2) == "06"
			Titulo += "CONTABILIDAD"
			ElseIf Substr((cAliasCT2)->CT2_SEGOFI,1,2) == "07"
			Titulo += "INGRESO"
			ElseIf Substr((cAliasCT2)->CT2_SEGOFI,1,2) == "08"
			Titulo += "EGRESO"
			ElseIf Substr((cAliasCT2)->CT2_SEGOFI,1,2) == "09"
			Titulo += "TRASPASO"
			Endif*/
			//		alert(cMoeda)
			//		if !Empty(cmoeda)
			//		cmoeda := substr(cmoeda,2,1)
			cmoeda := substr((cAliasCT2)->CT2_MOEDLC,2,1)
			//		cmoeda:= (cAliasCT2)->CT2_MOEDLC
			//	        SubTitulo := "(Expresado en "  + cvaltochar(GetMV("MV_MOEDAP"+)+")"
			SubTitulo := "(Expresado en "  + cvaltochar(GetMV("MV_MOEDAP"+cMoeda))+ ")"

			/*//CAJAS
			oReport:Box( 550,80,2450,2370)	//Recuadro
			oReport:Box( 550,80,650,2370)	// Recuadro Titulos
			oReport:Box( 2330,80,2450,2370)	// Recuadro Totales
			oReport:Box( 2550,80,3000,2370)	// Recuadro Firmas

			oReport:SAY(580, 110, "Código", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
			oReport:SAY(580, 310, "Cuenta", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
			oReport:SAY(580, 930, "Glosa", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
			oReport:SAY(580, 1530, "Debe", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
			oReport:SAY(580, 1830, "Haber", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
			oReport:SAY(580, 2120, "Cheque", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos

			oReport:Box( 550,300,2330,300)		//Linea Vertical
			oReport:Box( 550,920,2330,920)		//Linea Vertical
			//		oReport:Box( 550,1100,2560,1100)	//Linea Vertical
			oReport:Box( 550,1500,2450,1500)	//Linea Vertical
			oReport:Box( 550,1800,2450,1800)	//Linea Vertical
			oReport:Box( 550,2100,2450,2100)	//Linea Vertical

			oReport:Box( 2550,843,3000,843)		//Linea Vertical firmas
			oReport:Box( 2550,1606,3000,1606)	//Linea Vertical firmas

			oReport:Box( 2900,110,2900,810)		//Linea Horizontal firmas
			oReport:Box( 2900,873,2900,1573)	//Linea Horizontal firmas
			oReport:Box( 2900,1636,2900,2336)	//Linea Horizontal firmas
			*/

			//	    else
			//
			//	    SubTitulo := "(Expresado en "  + cvaltochar(GetMV("MV_MOEDAP"+(cAliasCT2)->CT2_DOC))+ ")
			//		endif
			//cSucursal	:= (cAliasCT2)->CT2_FILIAL

			dFecha      := (cAliasCT2)->CT2_DATA
			nDia 		:= DAY(dFecha)
			cMes 		:= dFechaToMes(dFecha)
			cMesN		:= MONTH(dFecha)
			nAnio		:= YEAR(dFecha)
			cLote 		:= (cAliasCT2)->CT2_LOTE
			cSubLote 	:= (cAliasCT2)->CT2_SBLOTE
			cDoc		:= (cAliasCT2)->CT2_DOC

			//cSequencial := CT2_SEQUEN + 0
			cSequencial := cValToChar(AllTrim((cAliasCT2)->CT2_SEGOFI))+" - "+cValToChar(cMesN)+" - "+cValToChar(nAnio)
			//			cDocumento	:= "Doc:"+cLote+" "+cSubLote+" "+cDoc
			cDocumento	:= "Doc:"+cLote+" "+cSubLote+" " // Nahim Quitando el nro de doc de lote.
			//imprimiendo titulo

			//MODIFICADO
			//oReport:PrintText(" ")	;	oReport:SkipLine(5) //avanza 5 lineas
			//oReport:SAY(oReport:Row(), 1050, Titulo, oFont14TN	,1000,CLR_BLACK ,CLR_BLACK )			//oReport:SkipLine(01)
			//oReport:SAY(oReport:Row(), 1980, cSequencial, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(02)
			//oReport:SAY(oReport:Row(), 1050, SubTitulo, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(05)

			//buscando la moneda
			dbSelectArea( "SM2" )
			dbSetOrder(1)
			dbSeek(DTOS(dFecha),.T.)
			cTipoSUS := SM2->M2_MOEDA2
			cTipoUFV := SM2->M2_MOEDA3
			//cTextFilial := cFilAnt
			//cFilAnt    //Filial actual
			//cNumEmp    //Empresa actua
			//cTextFilial := xfilial("CT2")

			cTextFecha  := "FECHA: " +alltrim(SM0->M0_FILIAL)+","+AllTrim(Str(nDia))+" "+cMes+" "+AllTrim(Str(nAnio))

			//oReport:SAY(oReport:Row(), 210, cTextFecha, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )
			//oReport:SAY(oReport:Row(), 1650, "TIPO CAMBIO: "+CValToChar(cTipoCambio), oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(02)

			//oReport:SkipLine(06)

			oReport:IncMeter()

			If oReport:Cancel()
				Exit
			EndIf

			#IFNDEF TOP
			If UCtr070Skip(cAliasCT2,lAllSL)
				Loop
			EndIf
			#ELSE
			If TcSrvType() == "AS/400"
				If UCtr070Skip(cAliasCT2,lAllSL)
					Loop
				EndIf
			EndIf
			#ENDIF

			cLote 		:= (cAliasCT2)->CT2_LOTE
			cSubLote 	:= (cAliasCT2)->CT2_SBLOTE
			cDoc		:= (cAliasCT2)->CT2_DOC
			dData 		:= (cAliasCT2)->CT2_DATA
			//		aFiscal     := Posicione("CTC",1,(cAliasCT2)->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_MOEDLC+CT2_TPSALD),"CTC_UTIPOF")
			//		aCorrAsiento := Posicione("CTC",1,(cAliasCT2)->(CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_MOEDLC+CT2_TPSALD),"CTC_USECAS")

			lFirst:= .T.
			nTotalDeb := 0
			nTotalCrd := 0
			//No IMPRIME LA SECTION1
			//oSection1:Init()
			//oSection1:PrintLine()
			//oSection1:Finish()

			oSection11:Init()

			While (cAliasCT2)->(!Eof()) .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") 	.And.;
			Dtos((cAliasCT2)->CT2_DATA) == Dtos(dData) 	.And.;
			(cAliasCT2)->CT2_LOTE == cLote 				.And.;
			(cAliasCT2)->CT2_SBLOTE == cSubLote 		.And.;
			(cAliasCT2)->CT2_DOC == cDoc
				If (lCabecera)
					fCabec()
					//impCuadro()
					/*				nPagina++
					oReport:PrintText(" ")	;	oReport:SkipLine(5) //avanza 5 lineas
					oReport:SAY(oReport:Row(), 1050, Titulo, oFont14TN	,1000,CLR_BLACK ,CLR_BLACK )			//oReport:SkipLine(01)
					oReport:SAY(oReport:Row(), 1980, cSequencial, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(02)
					oReport:SAY(oReport:Row(), 1050, SubTitulo, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )
					oReport:SAY(oReport:Row(), 1980, "Pagina: "+cValToChar(nPagina), oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(05)
					oReport:SAY(oReport:Row(), 210, cTextFecha, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )
					oReport:SAY(oReport:Row(), 1650, "TIPO CAMBIO DOLAR: "+CValToChar(cTipoCambio), oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(02)
					oReport:SAY(oReport:Row(), 1650, "TIPO CAMBIO UFV: "+CValToChar(cTipoCambio2), oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(02)
					oReport:SkipLine(04)
					lCabecera := .F.
					*/
				EndIf

				if nContInd == 2
					cIndiceSf1 :=(cAliasCT2)->CT2_KEY // Nahim 18/05/2020
					//					ALERT(cIndiceSf1)
				endif
				nContInd++

				//			oReport:PrintText("Nahim - " + cvaltochar(oReport:Row()),oReport:Row(),1500,CLR_BLACK)
				//			If(empty( cGlosa ))
				//				cGlosa := (cAliasCT2)->CT2_HIST NTP 20190805
				cGlosa :=  (cAliasCT2)->CT2_HIST
				cGlosa +=  iif(!empty((cAliasCT2)->CTT_DESC01)," - CC: " + (cAliasCT2)->CTT_DESC01 ,"")
				cGlosa +=  iif(!empty((cAliasCT2)->CTH_DESC01)," - CV: " + (cAliasCT2)->CTH_DESC01 ,"")
				cGlosa +=  iif(!empty((cAliasCT2)->CV0_DESC)," - " + (cAliasCT2)->CV0_DESC ,"")
				//				cGlosa +=  iif(!empty((cAliasCT2)->CTD_DESC01)," - " + (cAliasCT2)->CTD_DESC01 ,"")//(cAliasCT2)->CTD_DESC01
				cGlosa +=  iif(!empty((cAliasCT2)->CTD_DESC01)," - " + 'GND',"")//(cAliasCT2)->CTD_DESC01
				//				alert(cGlosa)
				//			EndIf
				oReport:IncMeter()

				If oReport:Cancel()
					Exit
				EndIf

				#IFNDEF TOP
				If UCtr070Skip(cAliasCT2,lAllSL)
					Loop
				EndIf
				#ELSE
				If TcSrvType() == "AS/400"
					If UCtr070Skip(cAliasCT2,lAllSL)
						Loop
					EndIf
				EndIf
				#ENDIF

				//oSection11:Cell( "CT2_LINHA" ):SetBlock( { || (cAliasCT2)->CT2_LINHA	} )

				///If lCusto .And. lItem .And. lCv //Se imprime C.C, Item E Cl.Valores
				If (cAliasCT2)->CT2_DC = "1"
					//oReport:PrintText( (cAliasCT2)->CT2_LOTE,oReport:Row(),120)
					//oReport:PrintText( CvALtOcHAR(OrEPORT:row()),oReport:Row(),120)
					oReport:PrintText( (cAliasCT2)->CT2_DEBITO,oReport:Row(),110)	//Codigo
					//oReport:PrintText( Posicione("CT1",1,xFilial("CT1")+(cAliasCT2)->CT2_DEBITO,'CT1_DESC01'),oReport:Row(),330)	//Cuenta
					oReport:PrintText( "Bs.",oReport:Row(),1755)	//Nahim agregando Debe detalle

					oReport:PrintText( Transform((cAliasCT2)->CT2_VALOR, Tm((cAliasCT2)->CT2_VALOR, 17)),oReport:Row(),1800)	//Debe detalle

					ArrayDetalle := CabToArray(Posicione("CT1",1,xFilial("CT1")+(cAliasCT2)->CT2_DEBITO,'CT1_DESC01'),40)
					ArrayTexto :=  CabToArray(cGlosa,40) // toma el array
					//		oReport:skipLine(1)
					//oReport:nFontBody			:= 32
					//oReport:cFontBody			:= "Times new roman"

					if (Len( ArrayTexto) > Len(ArrayDetalle))
						nMax := Len( ArrayTexto)
					else
						nMax := Len(ArrayDetalle)
					endif
					nPrimerLinea := .T.
					For i := 1 to nMax // for each de un array
						//         oReport:SAY(oReport:Row(), 400, ArrayTexto[i],oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
						//		alert(ArrayTexto[i])
						if (i <= Len( ArrayTexto))
							oReport:PrintText(ArrayTexto[i],oReport:Row(),1050,CLR_BLACK) //
						endif

						if (i <= Len(ArrayDetalle))
							oReport:PrintText( ArrayDetalle[i],oReport:Row(),330,CLR_BLACK)
						endif

						oReport:skipLine(1)
						if nPrimerLinea
							oReport:PrintText( "Us.", oReport:Row() ,1755)	//Nahim agregando Debe detalle
							//				oReport:PrintText(  Transform(round(xMoeda((cAliasCT2)->CT2_VALOR,1,2,dFecha),2), Tm((cAliasCT2)->CT2_VALOR, 17)), oReport:Row() ,1800) 	// Nahim agregando Debe detalle
							nDolarMost := IIF((cAliasCT2)->VALOR <> 0 ,(cAliasCT2)->VALOR,round(xMoeda((cAliasCT2)->CT2_VALOR,1,2,dFecha),2))// 27/09/2019
							oReport:PrintText(  Transform(nDolarMost,Tm((cAliasCT2)->CT2_VALOR, 17)), oReport:Row() ,1800) 	// Nahim agregando Debe detalle
							ndTOtDldeb += nDolarMost
							nPrimerLinea := .F.
						endif
						//		oSection11:PrintLine()
					next
					//oReport:PrintText( cGlosa,oReport:Row(),930)	//Glosa
					//				oReport:PrintText( "historial" ,oReport:Row(),1000)

					oReport:SkipLine(1)
					if nPrimerLinea
						oReport:PrintText( "Us.", oReport:Row() ,1755)	//Nahim agregando Debe detalle
						//						oReport:PrintText(  Transform(round(xMoeda((cAliasCT2)->CT2_VALOR,1,2,dFecha),2), Tm((cAliasCT2)->CT2_VALOR, 17)), oReport:Row() ,1800) 	// Nahim agregando Debe detalle
						nDolarMost := IIF((cAliasCT2)->VALOR <> 0 ,(cAliasCT2)->VALOR,round(xMoeda((cAliasCT2)->CT2_VALOR,1,2,dFecha),2))// 27/09/2019
						oReport:PrintText( Transform( nDolarMost,Tm((cAliasCT2)->CT2_VALOR, 17)) , oReport:Row() ,1800) 	// Nahim agregando Debe detalle
						ndTOtDldeb += nDolarMost
						nPrimerLinea := .F.
					endif

					nTotalDeb += (cAliasCT2)->CT2_VALOR
					nTotGerDeb+= (cAliasCT2)->CT2_VALOR
					nTotLotDeb+= (cAliasCT2)->CT2_VALOR
					//(cAliasCT2)->( DbSkip() )
				ElseIf (cAliasCT2)->CT2_DC = "2"
					// cambio de fuentes nahim
					//oReport:SAY(oReport:Row(), 400, ArrayTexto[i],oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
					//				oReport:PrintText( (cAliasCT2)->CT2_LOTE,oReport:Row(),120) //denar
					//oReport:PrintText( CvALtOcHAR(OrEPORT:row()),oReport:Row(),120)
					oReport:PrintText( (cAliasCT2)->CT2_CREDITO,oReport:Row(),110)	//Codigo
					//oReport:PrintText( Posicione("CT1",1,xFilial("CT1")+(cAliasCT2)->CT2_CREDITO,'CT1_DESC01'),oReport:Row(),330)	//Cuenta
					oReport:PrintText( "Bs.",oReport:Row(),2055)	//Nahim agregando detalle haber bs
					oReport:PrintText( Transform((cAliasCT2)->CT2_VALOR, Tm((cAliasCT2)->CT2_VALOR, 17)),oReport:Row(),2100)	//Haber
					ArrayDetalle := CabToArray(Posicione("CT1",1,xFilial("CT1")+(cAliasCT2)->CT2_CREDITO,'CT1_DESC01'),35)
					ArrayTexto :=  CabToArray(cGlosa,40) // toma el array

					if (Len( ArrayTexto) > Len(ArrayDetalle))
						nMax := Len( ArrayTexto)
					else
						nMax := Len(ArrayDetalle)
					endif
					nPrimerLinea := .T.
					For i := 1 to nMax // for each de un array
						//         oReport:SAY(oReport:Row(), 400, ArrayTexto[i],oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
						//		alert(ArrayTexto[i])
						if (i <= Len( ArrayTexto))
							oReport:PrintText(ArrayTexto[i],oReport:Row(),1050,CLR_BLACK) //
						endif

						if (i <= Len(ArrayDetalle))
							oReport:PrintText( ArrayDetalle[i],oReport:Row(),330,CLR_BLACK)
						endif

						oReport:skipLine(1)
						if nPrimerLinea
							oReport:PrintText( "Us.", oReport:Row() ,2055)	//Nahim agregando Debe detalle
							//							oReport:PrintText(  Transform(round(xMoeda((cAliasCT2)->CT2_VALOR,1,2,dFecha),2), Tm((cAliasCT2)->CT2_VALOR, 17)), oReport:Row() ,2100) 	// Nahim agregando Debe detalle
							nDolarMost :=IIF((cAliasCT2)->VALOR <> 0 ,(cAliasCT2)->VALOR,round(xMoeda((cAliasCT2)->CT2_VALOR,1,2,dFecha),2)) // NAHIM 27/09/2019
							oReport:PrintText( Transform( nDolarMost,Tm((cAliasCT2)->CT2_VALOR, 17)) , oReport:Row() ,2100) 	// Nahim agregando Debe detalle
							ndTOtDlcred += nDolarMost
							// round(xMoeda((cAliasCT2)->CT2_VALOR,1,2,dFecha),2)
							nPrimerLinea := .F.
						endif

					next
					//				oReport:PrintText( cGlosa,oReport:Row(),930)	//Glosa
					// Nahim Terrazas 26/10/2016 historial mueve abajo e impresion mas larga
					//				oReport:PrintText( "historial",oReport:Row(),1000)

					oReport:SkipLine(1)
					if nPrimerLinea
						oReport:PrintText( "Us.", oReport:Row() ,2055)	//Nahim agregando Debe detalle
						//						oReport:PrintText(  Transform(round(xMoeda((cAliasCT2)->CT2_VALOR,1,2,dFecha),2), Tm((cAliasCT2)->CT2_VALOR, 17)), oReport:Row() ,2100) 	// Nahim agregando Debe detalle
						nDolarMost := IIF((cAliasCT2)->VALOR <> 0 ,(cAliasCT2)->VALOR,round(xMoeda((cAliasCT2)->CT2_VALOR,1,2,dFecha),2))
						oReport:PrintText(Transform( nDolarMost, Tm((cAliasCT2)->CT2_VALOR, 17)) , oReport:Row() ,2100) 	// Nahim agregando Debe detalle
						ndTOtDlcred += nDolarMost
						nPrimerLinea := .F.
					endif

					nTotalCrd += (cAliasCT2)->CT2_VALOR
					nTotGerCrd+= (cAliasCT2)->CT2_VALOR
					nTotLotCrd+= (cAliasCT2)->CT2_VALOR
					//(cAliasCT2)->( DbSkip() )
				ElseIf (cAliasCT2)->CT2_DC = "3"
					// Imprime quando for Partida dobrada

					For n := 1 TO 2
						dbSelectArea( cAliasCT2 )
						If mv_par08 == 2
							dbSelectArea("CT1")
							If n == 1
								dbSeek( xFilial( "CT1" ) + (cAliasCT2)->CT2_DEBITO)
							Else
								dbSeek( xFilial( "CT1" ) + (cAliasCT2)->CT2_CREDIT)
							Endif
							oReport:PrintText( CT1->CT1_RES,oReport:Row(),320)
							dbSelectArea( cAliasCT2 )
						Else
							dbSelectArea("CT1")
							If n == 1
								dbSeek( xFilial( "CT1" ) + (cAliasCT2)->CT2_DEBITO)
							Else
								dbSeek( xFilial( "CT1" ) + (cAliasCT2)->CT2_CREDIT)
							Endif
							//						oReport:PrintText( (cAliasCT2)->CT2_LOTE,oReport:Row(),120)
							oReport:PrintText( iif( n == 1 , (cAliasCT2)->CT2_DEBITO , (cAliasCT2)->CT2_CREDIT ),oReport:Row(),110)	//Codigo
							oReport:PrintText( CT1->CT1_DESC01,oReport:Row(),330)	//Cuenta

							ArrayTexto :=  CabToArray(cGlosa,40) // toma el array
							//		oReport:skipLine(1)
							//oReport:nFontBody			:= 32
							//oReport:cFontBody			:= "Times new roman"

							//						oReport:PrintText( cGlosa,oReport:Row(),930)	//Glosa
							//						oReport:PrintText( "historial",oReport:Row(),1000)

						Endif

						nValor	:= (cAliasCT2)->CT2_VALOR

						If n == 1
							oReport:PrintText( Transform(nValor, Tm(nValor, 17)),oReport:Row(),1760)	//Debe detalle
							oReport:PrintText( Transform(0, Tm(0, 17)),oReport:Row(),2060)	//Haber detalle

							nTotalDeb += nValor
							nTotGerDeb+= nValor
							nTotLotDeb+= nValor
						Else
							oReport:PrintText( Transform(0, Tm(0, 17)),oReport:Row(),1760)		//Debe detalle
							oReport:PrintText( Transform(nValor, Tm(nValor, 17)),oReport:Row(),2060)	//Haber detalle

							nTotalCrd += nValor
							nTotGerCrd+= nValor
							nTotLotCrd+= nValor
						Endif
						oReport:SkipLine(1)
						For i := 1 to Len( ArrayTexto) // for each de un array
							//         oReport:SAY(oReport:Row(), 400, ArrayTexto[i],oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
							//		alert(ArrayTexto[i])
							oReport:PrintText(ArrayTexto[i],oReport:Row(),1050,CLR_BLACK) //
							oReport:skipLine(1)
							//		oSection11:PrintLine()
						next

						If n == 1
							/*    IF mv_par21 == 1
							oReport:PrintText( (cAliasCT2)->CT2_HIST,oReport:Row(),1000)
							EndIf

							If mv_par21 == 1*/
							RpPrintHist( cAliasCT2 , oSection11 ) // faz a impressao do historico detalhado
							//EndIf
						Endif

						nLinea := oReport:Row()
						If (nLinea >= 3005)
							impCuadro()
							//impresion del encabezado
							oReport:EndPage()
							oReport:StartPage()
							//							alert("Pasa 1" + cvaltochar(oReport:Row()))
							lCabecera := .T.
							// Nahim deberia imprimir // cabecera
							fCabec()
							impCuadro()
						EndIf
					Next
					//(cAliasCT2)->( DbSkip() )
				Endif
				// faz a impressao do historico detalhado
				//				RpPrintHist( cAliasCT2 , oSection11 )
				//oReport:IncMeter()
				nLinea := oReport:Row()
				If (nLinea >= 3005)
					impCuadro()
					//impresion del encabezado
					oReport:EndPage()
					oReport:StartPage()
					//					alert("Pasa 2: " + cvaltochar(oReport:Row()))
					lCabecera := .T.
				EndIf
				//(cAliasCT2)->( DbSkip() )
				(cAliasCT2)->( DbSkip() )
			Enddo

			nLinea := oReport:Row()
			If (nLinea >= 2200)
				impCuadro()
				//impresion del encabezado
				oReport:EndPage()
				oReport:StartPage()
				//lCabecera := .T.

				fCabec()
				impBoxTotales()
			else
				//fCabec()
				impBoxTotales()
			EndIf

			oSection11:Finish()

			If lTotal
				impBoxFirma()//Imprime Cuadros para firmas
				/////////////////////////////////////
				//FIN DE PAGINA
				cFila 		:= 2340
				cTtalDeb	:= Transform(nTotalDeb, Tm(nTotalDeb, 17))
				cTtalCrd	:= Transform(nTotalCrd, Tm(nTotalCrd, 17))
				//TRANSFORM(nTotalCrd ,"@E 999,999,999.99")
				//definiciones locales
				lQuantid 	:= .F.
				nMoeda 		:= 1	//Identifica em que moeda se dara o retorno.
				cPrefixo	:= ""
				cIdioma		:= "2"	//.(1=Port.2=Espa.3=Ingl)
				lCent		:= .T.
				lFrac		:= .T.

				//oReport	:PrintText("TOTAL BS : "			,cFila,1800)
				cTotalStr 	:= Extenso(nTotalDeb,lQuantid,nMoeda,,cIdioma,lCent,lFrac)

				//oReport	:PrintText("Son : "				,cFila,150)

				oReport:SAY(cFila, 190, cTotalStr+ " Bolivianos" , oFont10T	,1000,CLR_BLACK ,CLR_BLACK )//;	oReport:SkipLine(02)

				oReport:SAY(cFila, 1780, cTtalDeb, oFont10T	,1000,CLR_BLACK ,CLR_BLACK )	//Total Debe
				oReport:SAY(cFila, 2080, cTtalCrd, oFont10T	,1000,CLR_BLACK ,CLR_BLACK )	//Total Haber
				//convirtiendo la moneda
				/*
				nahim cambio 27/09/2019 agregando valor en dólares total
				nVM3 := xMoeda(nTotalDeb,1,2,dFecha)
				cTotalStrM3	:= Extenso(nVM3,lQuantid,nMoeda,,cIdioma,lCent,lFrac)
				cVM3	:= Transform(nvm3, Tm(nVM3, 17))
				//TRANSFORM(nVM3 ,"@E 999,999,999.99")
				cFila       := 2400
				oReport:SAY(cFila, 190, cTotalStrM3+ " Dolares" , oFont10T	,1000,CLR_BLACK ,CLR_BLACK )//;	oReport:SkipLine(02)
				oReport:SAY(cFila, 1780, cVM3, oFont10T	,1000,CLR_BLACK ,CLR_BLACK ) // nahim cambio 1800 por 1840	//Total Dolar Debe
				oReport:SAY(cFila, 2080, cVM3, oFont10T	,1000,CLR_BLACK ,CLR_BLACK )                                //Total Dolar Haber
				*/
				nVM3 := ndTOtDlDeb // xMoeda(nTotalDeb,1,2,dFecha)
				cTotalStrM3	:= Extenso(nVM3,lQuantid,nMoeda,,cIdioma,lCent,lFrac)
				cVM3	:= Transform(nvm3, Tm(nVM3, 17))
				cCredDl2:= Transform(ndTOtDlcred, Tm(nVM3, 17))
				//TRANSFORM(nVM3 ,"@E 999,999,999.99")
				cFila       := 2400
				oReport:SAY(cFila, 190, cTotalStrM3+ " Dólares" , oFont10T	,1000,CLR_BLACK ,CLR_BLACK )//;	oReport:SkipLine(02)
				oReport:SAY(cFila, 1780, cVM3, oFont10T	,1000,CLR_BLACK ,CLR_BLACK ) // nahim cambio 1800 por 1840	//Total Dolar Debe
				oReport:SAY(cFila, 2080, cCredDl2, oFont10T	,1000,CLR_BLACK ,CLR_BLACK )                                //Total Dolar Haber
				//impresion de la glosa
				cFila		:= 2500

				//				ALERT(clancPadr)
				if clancPadr $ "650|655"
					//obtengo el subs
					cIndSF1 :=  SUBSTR(cIndiceSf1,1,33) //
					//					alert(cIndSF1)
					dbSelectArea("SF1")
					dbSetOrder(1)
					If dbSeek(cIndSF1)
						//						alert(SF1->F1_ESPECIE)
						if ALLTRIM(SF1->F1_ESPECIE) $ "NF|NDP|NCC"
							// IMPRESIÓN
							cNomFor :=  GetAdvFVal("SA2","A2_NOME"	,XFilial("SA2")+SF1->F1_FORNECE	 + SF1->F1_LOJA,1,"")
							cInfo := SF1->F1_FORNECE + " - " + ALLTRIM(cNomFor) + " | Nro. Factura: "+ alltrim(SF1->F1_DOC) +" , "+ DTOC(SF1->F1_EMISSAO) + " - " + CVALTOCHAR(SF1->F1_VALBRUT)
							if !empty(SF1->F1_NUMAUT)
								cInfo +=  " | Nro. Aut.: " + alltrim(SF1->F1_NUMAUT)
							endif
							//							ALERT(cInfo)
							oReport:SAY(cFila, 150, cInfo , oFont10T ,1000,CLR_BLACK ,CLR_BLACK )//;	oReport:SkipLine(02)
						endif
					else
						//						alert("no encontró por indice")
					endif
					dbCloseArea("SF1")
				endif
				//			oReport:SAY(cFila, 200, cGlosa, oFont10T	,1000,CLR_BLACK ,CLR_BLACK )

				//impresion de la revision
				cFila		:= 2920
				/*oReport:SAY(cFila, 350, "ELABORADO POR", oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
				oReport:SAY(cFila, 1100, "REVISADO POR", oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
				oReport:SAY(cFila, 1900, "APROBADO POR", oFont10T	,1000,CLR_BLACK ,CLR_BLACK )*/
				//cFila 		:= 2500
				//cTotalStr 	:= Extenso(nTotalDeb,lQuantid,nMoeda,,cIdioma,lCent,lFrac)

				//oReport	:PrintText("Son : "				,cFila,150)

				//oReport:SAY(cFila, 320, cTotalStr, oFont10T	,1000,CLR_BLACK ,CLR_BLACK )//;	oReport:SkipLine(02)

				//If mv_par12 == 2
				oReport:EndPage()
				//EndIf

				//			nTotalDeb := 0
				//			nTotalCrd := 0

				If	cLote <> (cAliasCT2)->CT2_LOTE .Or.;
				cSubLote <> (cAliasCT2)->CT2_SBLOTE .Or.;
				DtoS(dData) <> DtoS((cAliasCT2)->CT2_DATA)
					oSection2:Cell( "TOT_DESCRI" ):SetBlock( { || STR0020 } )	// "TOTAL LOTE"
					oSection2:Cell( "TOT_DEBITO" ):SetBlock( { || Transform( nTotLotDeb, Tm(nTotLotDeb, 17) ) } )
					oSection2:Cell( "TOT_CREDITO"):SetBlock( { || Transform( nTotLotCrd, Tm(nTotLotCrd, 17) ) } )
					If lTot123
						CT6->(DbSetOrder(1))
						CT6->(MsSeek(xFilial("CT6")+dtos(dData)+cLote+cSubLote+cMoeda))
						oSection2:Cell( "TOT_INF"    ):SetBlock( { || Transform( CT6->CT6_INF, Tm( CT6->CT6_INF, 17 ) ) } )
						oSection2:Cell( "TOT_DIG"    ):SetBlock( { || Transform( CT6->CT6_DIG, Tm( CT6->CT6_DIG, 17 ) ) } )
						oSection2:Cell( "TOT_DIFINF" ):SetBlock( { || Transform( CT6->CT6_DIG - CT6->CT6_INF, Tm( CT6->CT6_DIG, 17 ) ) } )
					Endif

					//oSection2:Init()
					//oSection2:PrintLine()
					//oSection2:Finish()

					If mv_par12 == 1
						oReport:EndPage()
					EndIf

					nTotLotDeb := 0
					nTotLotCrd := 0
					cGlosa := ""

				Endif
			Endif
		Enddo

	Endif

	If lTotal

		oSection2:Cell( "TOT_DESCRI" ):SetBlock( { || STR0019 } ) // "TOTAL GERAL"
		oSection2:Cell( "TOT_DEBITO" ):SetBlock( { || Transform( nTotGerDeb, Tm( nTotGerDeb, 17 ) ) } )
		oSection2:Cell( "TOT_CREDITO"):SetBlock( { || Transform( nTotGerCrd, Tm( nTotGerCrd, 17 ) ) } )

		If lTot123
			oSection2:Cell( "TOT_INF"    ):SetBlock( { || Transform( nTotGerInf, Tm(nTotGerInf, 17) ) } )
			oSection2:Cell( "TOT_DIG"    ):SetBlock( { || Transform( nTotGerDig, Tm(nTotGerDig, 17) ) } )
			oSection2:Cell( "TOT_DIFINF" ):SetBlock( { || Transform( nTotGerDig - nTotGerInf, Tm(nTotGerInf, 17) ) } )
		Endif

		//oSection2:Init()
		//oSection2:PrintLine()
		//oSection2:Finish()

	Endif

Return

/////////////////////////////////
////////////////////////////////

/*
-------------------------------------------------------- RELEASE 3 -------------------------------------------------------------
*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr070	³ Autor ³ Pilar S Albaladejo	³ Data ³ 12.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferencia de Digitacao               	 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr070()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function UCtbr070R3(iCondBol)
	Local aCtbMoeda		:= {}
	LOCAL cDesc1 		:= STR0001	//"Este programa ira imprimir o Relatorio para Conferencia"
	LOCAL cDesc2 		:= STR0002   //"de Digitacao - Modelo 1. Ideal para Plano de Contas "
	//LOCAL cDesc3		:= STR0003   //"que possuam codigos nao muito extensos.            "
	LOCAL wnrel
	LOCAL cString		:= "CT2"
	Local titulo 		:= STR0004 	//"Conferencia de Digitacao - Modelo 1"
	Local lRet			:= .T.
	Local lCusto 		:= .F.
	Local lItem 		:= .F.
	Local lCV	 		:= .F.
	Local Limite		:= 132
	Local cDescMoeda	:= ""

	PRIVATE Tamanho		:="12"
	PRIVATE nLastKey 	:= 0
	PRIVATE cPerg	 	:= "CTR070"
	PRIVATE aReturn 	:= { STR0005, 1,STR0006, 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
	PRIVATE aLinha		:= {}
	PRIVATE nomeProg  := "CTBR070"

	Private lTot123
	li 		:= 80
	m_pag	:= 1
	UCTR070SX1()

	Pergunte("CTR070",.F.)

	If mv_par17 == 1		// Resumido
		Titulo += STR0022
	EndIf

	If mv_par09 == 1
		lCusto := .T.
	Else
		lCusto := .F.
	Endif

	If mv_par10 == 1
		lItem := .T.
	Else
		lItem := .F.
	Endif

	If mv_par14 == 1
		lCV := .T.
	Else
		lCV := .F.
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros						 	³
	//³ mv_par01				// Data Inicial                  	 	³
	//³ mv_par02				// Data Final                         	³
	//³ mv_par03				// Lote  Inicial                        ³
	//³ mv_par04				// Lote  Final  						³
	//³ mv_par05				// Documento Inicial                    ³
	//³ mv_par06				// Documento Final			    		³
	//³ mv_par07				// Moeda?						     	³
	//³ mv_par08				// Cod Conta? Normal / Reduzido 		³
	//³ mv_par09				// Imprime C. Custo? Sim / Nao	    	³
	//³ mv_par10				// Imprime Item? Sim / Nao			    ³
	//³ mv_par11				// Imprime Lcto? Realiz. / Orcado / Pre ³
	//³ mv_par12				// Quebra Pagina por?Lote/Doc/Nao Quebra³
	//³ mv_par13				// Totaliza    ? Sim / Nao			    ³
	//³ mv_par14				// Imprime Classe de Valores? Sim / Nao ³
	//³ mv_par15				// Sub-Lote Inicial                  	³
	//³ mv_par16				// Sub-Lote Final  						³
	//³ mv_par17				// Imprime? Resumido / Completo			³
	//³ mv_par18				// Cod C.C. ? Normal / Reduzido			³
	//³ mv_par19				// Cod Item ? Normal / Reduzido 		³
	//³ mv_par20				// Cod Cl.Vlr? Normal / Reduzido 		³
	//³ mv_par21				// Impr. Compl. Part. Dobrada? Sim/Não  ³
	//³ SE FOR PARA O CHILE							               	 	³
	//³ mv_par22				// Do Corrrelativo               	 	³
	//³ mv_par23				// Ate Correlativo                    	³
	//³ mv_par24				// Imp.Tot.Inf/Dig/Dif?           	 	³
	//³ SE NAO FOR PARA O CHILE        				              	 	³
	//³ mv_par22				// Imp.Tot.Inf/Dig/Dif?           	 	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel	:= "CTBR070"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

	If mv_par09 == 1
		lCusto := .T.
	Else
		lCusto := .F.
	Endif

	If mv_par10 == 1
		lItem := .T.
	Else
		lItem := .F.
	Endif

	If mv_par14 == 1
		lCV := .T.
	Else
		lCV := .F.
	Endif

	lTot123 := If( cPaisLoc = "CHI", mv_par24, mv_par22)

	If nLastKey == 27
		Set Filter To
		Return
	Endif

	If lRet
		aCtbMoeda  	:= CtbMoeda(mv_par07)
		If Empty(aCtbMoeda[1])
			Help(" ",1,"NOMOEDA")
			Set Filter To
			Return
		Endif
	Endif

	cDescMoeda 	:= Alltrim(aCtbMoeda[2])

	Titulo	+= STR0030 + cDescMoeda

	// Somente caso imprima dois tipos juntos envio como 220 colunas
	If (mv_par17 == 2) .And. ((lCusto .And. lItem) .Or. (lItem .And. lCv) .Or. (lCusto .And. lCv) .Or.;
	(lCusto .And. lItem .And. lCv)) .Or. ( mv_par17 = 1 .And. lTot123 == 1)
		tamanho := "G"
		Limite  := 220
	Endif

	SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))

	If nLastKey == 27
		Set Filter To
		Return
	Endif
	if iCondBol
		RptStatus({|lEnd| CTR070IBO(@lEnd,wnRel,cString,Titulo,lCusto,lItem,lCV,Limite)})
	Else
		RptStatus({|lEnd| CTR070Imp(@lEnd,wnRel,cString,Titulo,lCusto,lItem,lCV,Limite)})
	EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR070IMP ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Conferencia Digitacao Modelo 1        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR070Imp(lEnd,WnRel,cString,Titulo,lCusto,lItem,lCV)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³          ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³          ³ ExpC2   - Mensagem                                         ³±±
±±³          ³ ExpC3   - Titulo                                           ³±±
±±³          ³ ExpL1   - Define se imprime o centro de custo              ³±±
±±³          ³ ExpL2   - Define se imprime o item                         ³±±
±±³          ³ ExpL3   - Define se imprime a classe de valor              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR070Imp(lEnd,WnRel,cString,Titulo,lCusto,lItem,lCV,Limite)

	LOCAL CbTxt		:= Space(10)
	Local CbCont	:= 0
	Local cabec1  	:= ""
	Local cabec2  	:= " "

	Local aColunas		:= {}
	Local cLote
	Local cSubLote
	Local cDoc
	Local cMoeda		:= mv_par07
	Local cSayItem		:= CtbSayApro("CTD")
	Local cSayCC		:= CtbSayApro("CTT")
	Local cSayCV		:= CtbSayApro("CTH")
	Local cLoteRes
	Local cSubRes
	Local cDocRes
	Local dDataRes		:= CTOD("  /  /  ")
	Local dData
	Local lTotal		:= Iif(mv_par13 == 1,.T.,.F.)
	Local lResumo	    := Iif(mv_par17 == 1,.T.,.F.)
	Local lPrimPag		:= .T.
	Local lQuebraDoc	:= .F.
	Local cSEGOFI		:= "" //Correlativo para o Chile
	Local nTotalDeb		:= 0
	Local nTotalCrd		:= 0
	Local nTotLotDeb	:= 0
	Local nTotLotCrd	:= 0
	Local nTotGerDeb	:= 0
	Local nTotGerCrd	:= 0
	Local nTotGerInf	:= nTotGerDig := 0
	Local nDif			:= 0
	Local nCol
	Local n
	Local nStr
	Local lAllSL		:= If(Empty(mv_par11) .or. mv_par11=="*",.T.,.F.)

	If !lResumo
		If !lCusto .And. !lItem .And. !lCV //So imprime a conta
			Cabec1 := STR0007+space(19)+STR0015
		Else

			/*

			LI TP CONTA                C CUSTO              ITEM CONTA           COD CL VAL                   VALOR DEB        VALOR CRED  HP HIST

			12345678901234567890 12345678901234567890 12345678901234567890 12345678901234567890 12345678901234567 12345678901234567 123 1234567890123456789012345678901234567890

			LI TP CONTA                ITEM CONTA           COD CL VAL                   VALOR DEB        VALOR CRED  HP HIST

			12345678901234567890 12345678901234567890 12345678901234567890 12345678901234567 12345678901234567 123 1234567890123456789012345678901234567890

			LI TP CONTA                COD CL VAL                   VALOR DEB        VALOR CRED  HP HIST
			12345678901234567890         VALOR DEB        VALOR CRED  HP HIST

			12345678901234567890 12345678901234567890 12345678901234567 12345678901234567 123 1234567890123456789012345678901234567890
			*/

			Cabec1 := STR0008
			If lCusto .And. lItem .And. lCv
				aColunas := { 027, 048, 069, 090, 108, 126, 130 }
			ElseIf (lCusto .And. lItem)
				aColunas := { 027, 048, 000, 069, 087, 105, 109 }
			ElseIf (lCusto .And. lCv)
				aColunas := { 027, 000, 048, 069, 087, 105, 109 }
			ElseIf (lItem .And. lCv)
				aColunas := { 000, 027, 048, 069, 087, 105, 109 }
			ElseIf lCusto
				aColunas := { 027, 000, 000, 048, 066, 084, 088 }
			ElseIf lItem
				aColunas := { 000, 027, 000, 048, 066, 084, 088 }
			Else
				aColunas := { 000, 000, 027, 048, 066, 084, 088 }
			Endif
			If lCusto
				Cabec1 += Upper(Left(cSayCC + Space(21), 21))
			Endif
			If lItem
				Cabec1 += Upper(Left(cSayItem + Space(21), 21))
			Endif
			If lCv
				Cabec1 += Upper(Left(cSayCv + Space(21), 21))
			Endif
			Cabec1 += STR0016
		EndIf
	Else
		If lTot123 == 1
			Cabec1 := STR0021
		Else
			Cabec1 := STR0031
		EndIF

		CTC->(DbSetOrder(1))
		/*
		DATA          LOTE      SUBLOTE    DOCUMENTO      TOTAL INFORMADO       VALOR A DEBITO      VALOR A CREDITO           DIFERENCA                        TOTAL DIGITADO    DIFERENCA INF/DIG
		***********************************************************************************************************************************************************************************************************
		10/06/2002    008850        001       000001             2.500,00             2.500,00             2.500,00                0,00    1234567890123             2.500,00                 0,00    1234567890123
		*/
	EndIf

	#IFDEF TOP
	If TcSrvType() <> "AS/400"

		cQuery := "SELECT * FROM " + RetSqlName("CT2")     + " "
		cQuery += "WHERE CT2_FILIAL  = '" + xFilial("CT2") + "' AND "
		cQuery +=       "CT2_DATA   >= '" + DTOS(mv_par01) + "' AND "
		cQuery += 	    "CT2_DATA   <= '" + DTOS(mv_par02) + "' AND "
		cQuery += 	    "CT2_LOTE   >= '" + mv_par03 	   + "' AND "
		cQuery += 	    "CT2_LOTE   <= '" + mv_par04 	   + "' AND "
		cQuery += 	    "CT2_SBLOTE >= '" + mv_par15 	   + "' AND "
		cQuery += 		"CT2_SBLOTE <= '" + mv_par16 	   + "' AND "
		cQuery +=   	"CT2_DOC    >= '" + mv_par05 	   + "' AND "
		cQuery += 		"CT2_DOC    <= '" + mv_par06 	   + "' AND "
		cQuery += 		"CT2_MOEDLC = '"+ mv_par07 + "' AND "
		cQuery += 		"CT2_CLVLDB = '0"+ alltrim(str(mv_par24)) + "' AND "
		If !lAllSL
			cQuery += 		"CT2_TPSALD = '"+ mv_par11 + "' AND "
		EndIf
		cQuery += 		"CT2_DC <> '4' AND "
		cQuery +=       "D_E_L_E_T_ = '' "
		cQuery += "ORDER BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA"

		cQuery := ChangeQuery(cQuery)

		If Select("cArqCT2") > 0
			dbSelectArea("cArqCT2")
			dbCloseArea()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)

		aStrSTRU := CT2->(dbStruct())      //// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM

		For nStr := 1 to Len( CT2->(dbStruct()) )        //// LE A ESTRUTURA DA TABELA
			If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
				TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
			EndIf
		Next

		dbSelectArea("cArqCT2")
		cAliasCT2 := "cArqCT2"
	Else
		#ENDIF

		dbSelectArea("CT2")
		dbSetOrder(1)
		dbSeek( xFilial("CT2") + DTOS( mv_par01 ) + mv_par03 + mv_par15 + mv_par05 ,.T.)

		cAliasCT2 := "CT2"

		#IFDEF TOP
	EndIf
	#ENDIF

	SetRegua(RecCount())

	While !Eof() .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") .And.;
	(cAliasCT2)->CT2_DATA <= mv_par02

		// Tratando o filtro que o usuario informou para o relatorio
		If ! Empty( aReturn[7] )
			If ! &(aReturn[7])
				(cAliasCT2)->( DbSkip() )
				Loop
			EndIf
		EndIf

		If lEnd
			@Prow()+1,0 PSAY STR0009   //"***** CANCELADO PELO OPERADOR *****"
			Exit
		EndIF

		#IFNDEF TOP
		If UCtr070Skip(cAliasCT2,lAllSL)
			Loop
		EndIf
		#ELSE
		If TcSrvType() == "AS/400"
			If UCtr070Skip(cAliasCT2,lALLSL)
				Loop
			EndIf
		EndIf
		#ENDIF

		IncRegua()

		cLote 		:= (cAliasCT2)->CT2_LOTE
		cSubLote 	:= (cAliasCT2)->CT2_SBLOTE
		cDoc		:= (cAliasCT2)->CT2_DOC
		dData 		:= (cAliasCT2)->CT2_DATA

		cLoteRes 	:= (cAliasCT2)->CT2_LOTE
		cSubRes		:= (cAliasCT2)->CT2_SBLOTE
		cDocRes		:= (cAliasCT2)->CT2_DOC
		dDataRes	:= (cAliasCT2)->CT2_DATA

		If cPaisLoc == "CHI"
			cSegOfi := (cAliasCT2)->CT2_SEGOFI
		EndIf
		lFirst:= .T.
		nTotalDeb := 0
		nTotalCrd := 0

		lQuebraDoc := Iif(mv_par12==2,.T.,.F.)
		While (cAliasCT2)->(!Eof()) .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") 	.And.;
		Dtos((cAliasCT2)->CT2_DATA) == Dtos(dData) 	.And.;
		(cAliasCT2)->CT2_LOTE == cLote 				.And.;
		(cAliasCT2)->CT2_SBLOTE == cSubLote 		.And.;
		(cAliasCT2)->CT2_DOC == cDoc

			// Tratando o filtro que o usuario informou para o relatorio
			If ! Empty( aReturn[7] )
				If ! &(aReturn[7])
					(cAliasCT2)->( DbSkip() )
					Loop
				EndIf
			EndIf

			#IFNDEF TOP
			If UCtr070Skip(cAliasCT2,lAllSL)
				Loop
			EndIf
			#ELSE
			If TcSrvType() == "AS/400"
				If UCtr070Skip(cAliasCT2,lAllSL)
					Loop
				EndIf
			EndIf
			#ENDIF

			IncRegua()

			IF (!lResumo .And. li > 62) .Or. lQuebraDoc
				CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
				If lQuebraDoc .Or. lPrimPag
					lPrimPag	:= .F.
				EndIf
				lQuebraDoc := .F.
			EndIf

			If lFirst .And. !lResumo
				@ li,00 PSAY Replicate("-",Limite)
				li++
				@ li,000 PSAY STR0012
				@ li,007 PSAY DTOC(dData)
				@ li,019 PSAY STR0013
				@ li,027 PSAY cLote
				@ li,038 PSAY STR0017 //"Sub-Lote"
				@ li,049 PSAY cSubLote
				@ li,058 PSAY STR0014
				@ li,064 PSAY cDoc
				If cPaisLoc == "CHI"
					@ Li,80 PSAY STR0029 + cSegOfi
				EndIf
				lFirst := .F.
				li ++
				@ li,00 PSAY Replicate("-",Limite)
				li++
			EndIf

			If !lResumo			// Imprime o relatorio detalhado
				If ! lCusto .And. ! lItem .And. ! lCv //Se nao imprime C.C, Item E Cl.Valores
					@ li, 000 PSAY (cAliasCT2)->CT2_LINHA
					@ li, 004 PSAY (cAliasCT2)->CT2_DC
					If mv_par08 == 2
						dbSelectArea("CT1")
						dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_DEBITO)
						@ li, 006 PSAY CT1->CT1_RES
						dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_CREDIT)
						@ li, 027 PSAY CT1->CT1_RES
						dbSelectArea(cAliasCT2)
					Else
						@ li, 006 PSAY (cAliasCT2)->CT2_DEBITO
						@ li, 027 PSAY (cAliasCT2)->CT2_CREDIT
					Endif

					nValor	:= (cAliasCT2)->CT2_VALOR

					If (cAliasCT2)->CT2_DC == "1" .Or. (cAliasCT2)->CT2_DC == "3"
						@ li, 049 PSAY nValor Picture Tm(nValor,17)
						nTotalDeb += nValor
						nTotGerDeb+= nValor
						nTotLotDeb+= nValor
					Endif
					If (cAliasCT2)->CT2_DC == "2" .Or. (cAliasCT2)->CT2_DC == "3"
						@ li, 070 PSAY nValor Picture Tm(nValor,17)
						nTotalCrd += nValor
						nTotGerCrd+= nValor
						nTotLotCrd+= nValor
					Endif
					@ li, 088 PSAY (cAliasCT2)->CT2_HP
					@ li, 092 PSAY (cAliasCT2)->CT2_HIST
					/*If lAllSL					/// necessario tratar coluna e tamanho do relatório (P, M ou G)
					@ li, 133 PSAY (cAliasCT2)->CT2_TPSALD    /// seria bom, ao imprimir "todos" os saldo, indicar o tipo de saldo no relatorio.
					EndIf*/

				Else //Se imprime C.C ou Item ou Cl. Valores os lanc. tipo '3' serao desdobrados
					If (cAliasCT2)->CT2_DC == '1' .Or. (cAliasCT2)->CT2_DC =='2'//Se o lancamento e tipo '1' ou '2'
						@ li, 000 PSAY (cAliasCT2)->CT2_LINHA
						@ li, 004 PSAY (cAliasCT2)->CT2_DC
						If mv_par08 == 2
							dbSelectArea("CT1")
							If (cAliasCT2)->CT2_DC == '1'
								dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_DEBITO)
								@ li, 006 PSAY CT1->CT1_RES
							ElseIf (cAliasCT2)->CT2_DC == '2'
								dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_CREDIT)
								@ li, 006 PSAY CT1->CT1_RES
							Endif
							dbSelectArea(cAliasCT2)
						Else
							If (cAliasCT2)->CT2_DC == '1'
								@ li, 006 PSAY (cAliasCT2)->CT2_DEBITO
							ElseIf (cAliasCT2)->CT2_DC == '2'
								@ li, 006 PSAY (cAliasCT2)->CT2_CREDIT
							Endif
						Endif

						nValor := (cAliasCT2)->CT2_VALOR
						If (cAliasCT2)->CT2_DC == '1'
							If lCusto
								@ li,aColunas[CENTRO_CUSTO] PSAY UCtr070CTT((cAliasCT2)->CT2_CCD)
							Endif
							If lItem
								@ li,aColunas[ITEM_CONTABIL] PSAY UCtr070CTD((cAliasCT2)->CT2_ITEMD)
							Endif
							If lCv
								@ li,aColunas[CLASSE_VALOR] PSAY UCtr070CTH((cAliasCT2)->CT2_CLVLDB)
							Endif
							@ li,aColunas[VALOR_DEBITO] PSAY nValor Picture Tm(nValor,17)
							nTotalDeb += nValor
							nTotGerDeb+= nValor
							nTotLotDeb+= nValor
						ElseIf (cAliasCT2)->CT2_DC =='2'
							If lCusto
								@ li,aColunas[CENTRO_CUSTO] PSAY UCtr070CTT((cAliasCT2)->CT2_CCC)
							Endif
							If lItem
								@ li,aColunas[ITEM_CONTABIL] PSAY UCtr070CTD((cAliasCT2)->CT2_ITEMC)
							Endif
							If lCv
								@ li,aColunas[CLASSE_VALOR] PSAY UCtr070CTH((cAliasCT2)->CT2_CLVLCR)
							Endif
							@ li,aColunas[VALOR_CREDITO] PSAY nValor Picture Tm(nValor,17)
							nTotalCrd += nValor
							nTotGerCrd+= nValor
							nTotLotCrd+= nValor
						Endif
						@ li, aColunas[CODIGO_HP] PSAY (cAliasCT2)->CT2_HP
						@ li, aColunas[HISTORICO] PSAY (cAliasCT2)->CT2_HIST

					Elseif (cAliasCT2)->CT2_DC == '3' //Se o lancamento e tipo '3', e desdobrado
						For n:=1 to 2
							@ li, 000 PSAY (cAliasCT2)->CT2_LINHA
							If n == 1
								@ li, 004 PSAY '1'
							Else
								@ li, 004 PSAY '2'
							Endif
							If mv_par08 == 2
								dbSelectArea("CT1")
								If n==1
									dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_DEBITO)
									@ li, 006 PSAY CT1->CT1_RES
								Else
									dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_CREDIT)
									@ li, 006 PSAY CT1->CT1_RES
								Endif
								dbSelectArea(cAliasCT2)
							Else
								If n==1
									@ li, 006 PSAY (cAliasCT2)->CT2_DEBITO
								Else
									@ li, 006 PSAY (cAliasCT2)->CT2_CREDIT
								Endif
							Endif

							nValor	:= (cAliasCT2)->CT2_VALOR
							If n == 1
								If lCusto
									@ li,aColunas[CENTRO_CUSTO] PSAY UCtr070CTT((cAliasCT2)->CT2_CCD)
								Endif
								If lItem
									@ li,aColunas[ITEM_CONTABIL] PSAY UCtr070CTD((cAliasCT2)->CT2_ITEMD)
								Endif
								If lCv
									@ li,aColunas[CLASSE_VALOR] PSAY UCtr070CTH((cAliasCT2)->CT2_CLVLDB)
								Endif
								@ li,aColunas[VALOR_DEBITO] PSAY nValor Picture Tm(nValor,17)
								nTotalDeb += nValor
								nTotGerDeb+= nValor
								nTotLotDeb+= nValor
							Else
								If lCusto
									@ li,aColunas[CENTRO_CUSTO] PSAY UCtr070CTT((cAliasCT2)->CT2_CCC)
								Endif
								If lItem
									@ li,aColunas[ITEM_CONTABIL] PSAY UCtr070CTD((cAliasCT2)->CT2_ITEMC)
								Endif
								If lCv
									@ li,aColunas[CLASSE_VALOR] PSAY UCtr070CTH((cAliasCT2)->CT2_CLVLCR)
								Endif
								@ li,aColunas[VALOR_CREDITO] PSAY nValor Picture Tm(nValor,20)
								nTotalCrd += nValor
								nTotGerCrd+= nValor
								nTotLotCrd+= nValor
							Endif
							@ li, aColunas[CODIGO_HP]	PSAY (cAliasCT2)->CT2_HP
							@ li,aColunas[HISTORICO] 	PSAY (cAliasCT2)->CT2_HIST

							If n == 1 .and. mv_par21 == 1
								// Procura pelo complemento de historico
								cSeq 	:= (cAliasCT2)->CT2_SEQLAN
								cEmpOri	:= (cAliasCT2)->CT2_EMPORI
								cFilOri	:= (cAliasCT2)->CT2_FILORI
								nReg := Recno()
								dbSelectArea("CT2")
								dbSetOrder(10)
								If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeq+cEmpOri+cFilOri)
									dbSkip()
									If CT2->CT2_DC == "4"
										While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
										CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
										CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_EMPORI == cEmpOri .And. ;
										CT2->CT2_FILORI == cFilOri 	.And. ;
										DTOS(CT2->CT2_DATA) == DTOS(dData)

											If CT2->CT2_DC == "4"
												li++
												IF li > 62
													/*Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
													Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))*/
													CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
												EndIf
												If !lCusto .And. !lItem .And. !lCV
													@ li, 000 PSAY CT2->CT2_LINHA
													@ li, 004 PSAY CT2->CT2_DC
													@ li, 097 PSAY CT2->CT2_HIST
												Else
													@ li, 000 PSAY CT2->CT2_LINHA
													@ li, 004 PSAY CT2->CT2_DC
													@ li, aColunas[HISTORICO] PSAY CT2->CT2_HIST
												EndIf
											EndIf
											dbSkip()
										EndDo
									EndIf
								EndIf
								dbSelectArea("CT2")
								dbSetOrder(1)
								dbGoto(nReg)

								dbSelectArea(cAliasCT2)
								li++
							ElseIf n == 1
								li++
							EndIf
						Next
					Endif
				EndIf

				// Procura pelo complemento de historico
				cSeq 	:= (cAliasCT2)->CT2_SEQLAN
				cEmpOri	:= (cAliasCT2)->CT2_EMPORI
				cFilOri	:= (cAliasCT2)->CT2_FILORI
				nReg := Recno()
				dbSelectArea("CT2")
				dbSetOrder(10)
				If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeq+cEmpOri+cFilOri)
					dbSkip()
					If CT2->CT2_DC == "4"
						While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
						CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
						CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_EMPORI == cEmpOri .And. ;
						CT2->CT2_FILORI == cFilOri 	.And. ;
						DTOS(CT2->CT2_DATA) == DTOS(dData)

							If CT2->CT2_DC == "4"
								li++
								IF li > 62
									/*Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
									Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))*/
									CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
								EndIf
								If !lCusto .And. !lItem .And. !lCV
									//@ li, 000 PSAY CT2->CT2_LINHA
									//@ li, 004 PSAY CT2->CT2_DC
									@ li, 097 PSAY CT2->CT2_HIST
								Else
									//@ li, 000 PSAY CT2->CT2_LINHA
									//@ li, 004 PSAY CT2->CT2_DC
									@ li, aColunas[HISTORICO] PSAY CT2->CT2_HIST
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf
				EndIf
				dbSetOrder(1)

				dbSelectArea(cAliasCT2)
				dbGoto(nReg)
				dbSkip()
				li++
				IF li > 62
					CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
					/*Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
					Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))*/
				EndIf
			Else						// Armazena valores para impressa resumida
				cLoteRes 	:= (cAliasCT2)->CT2_LOTE
				cSubRes		:= (cAliasCT2)->CT2_SBLOTE
				cDocRes		:= (cAliasCT2)->CT2_DOC
				dDataRes	:= (cAliasCT2)->CT2_DATA
				If (cAliasCT2)->CT2_DC == "1" .Or. (cAliasCT2)->CT2_DC == "3"
					nValor := (cAliasCT2)->CT2_VALOR
					nTotalDeb += nValor
					nTotGerDeb+= nValor
					nTotLotDeb+= nValor
				EndIf
				If (cAliasCT2)->CT2_DC == "2" .Or. (cAliasCT2)->CT2_DC == "3"
					nValor := (cAliasCT2)->CT2_VALOR
					nTotalCrd += nValor
					nTotGerCrd+= nValor
					nTotLotCrd+= nValor
				EndIf
				dbSkip()
			EndIf
		EndDO

		/*	If lTotal .And. !lResumo			// Relatorio Completo
		li++
		@ li,02 PSAY STR0018
		//		CTC->(MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+cDoc+"01"))
		CTC->(MsSeek(xFilial("CTC")+dtos(dData)+cLote+cSubLote+cDoc+cMoeda))
		nTotGerInf += CTC->CTC_INF
		nTotGerDig += CTC->CTC_DIG
		If !lCusto .And. !lItem  .And. !lCV
		@ li, 049 		PSAY nTotalDeb Picture Tm(nTotalDeb,17)
		@ li, 070 		PSAY nTotalCrd Picture Tm(nTotalCrd,17)
		Else
		@ li, aColunas[VALOR_DEBITO] 	PSAY nTotalDeb Picture Tm(nTotalDeb,17)
		@ li, aColunas[VALOR_CREDITO] 	PSAY nTotalCrd Picture Tm(nTotalCrd,17)
		Endif

		If lTot123 == 1	//Se imprime total informado, digitado e diferenca
		If limite = 132
		nCol := If(Len(aColunas) > 0, aColunas[HISTORICO], 097)
		@ li ++, nCol	PSAY STR0025 + 	Trans(CTC->CTC_INF, Tm(CTC->CTC_INF,17)) //"INFORMADO"
		@ li   , nCol	PSAY STR0026 + 	Trans(CTC->CTC_DIG, Tm(CTC->CTC_DIG,17)) //"DIGITADO "
		If Round(NoRound(CTC->CTC_DIG - CTC->CTC_INF, 2), 2) # 0
		li ++
		@ li,nCol PSAY STR0027 + Trans(Abs(CTC->CTC_DIG - CTC->CTC_INF),; //"DIFERENCA"
		Tm(CTC->CTC_DIG,17))
		Endif
		Else
		@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(CTC->CTC_INF,; //"INFORMADO "
		Tm(CTC->CTC_INF,17)) +;
		Space(4) + STR0026 +; //"DIGITADO "
		Trans(CTC->CTC_DIG, Tm(CTC->CTC_DIG,17)) +;
		Space(4) + STR0027 +; //"DIFERENCA"
		Trans(	Abs(CTC->CTC_DIG-CTC->CTC_INF),;
		Tm(CTC->CTC_DIG,17))
		Endif
		EndIf
		li++
		nTotalDeb := 0
		nTotalCrd := 0

		// TOTALIZA O LOTE
		If cLote != (cAliasCT2)->CT2_LOTE 				.Or.;
		cSubLote != (cAliasCT2)->CT2_SBLOTE 			.Or.;
		Dtos(dData) != Dtos((cAliasCT2)->CT2_DATA)
		li++
		@ li,02 PSAY STR0020
		//	CT6->(MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+"01"))
		CT6->(MsSeek(xFilial("CT6")+dtos(dData)+cLote+cSubLote+cMoeda))
		If !lCusto .And. !lItem  .And. !lCV
		@ li, 049 PSAY nTotLotDeb Picture Tm(nTotLotDeb,17)
		@ li, 070 PSAY nTotLotCrd Picture Tm(nTotLotCrd,17)
		Else
		@ li, aColunas[VALOR_DEBITO] 	PSAY nTotLotDeb Picture Tm(nTotLotDeb,17)
		@ li, aColunas[VALOR_CREDITO] 	PSAY nTotLotCrd Picture Tm(nTotLotCrd,17)
		Endif
		If lTot123 == 1	//Se imprime total informado, digitado e diferenca
		If limite = 132
		nCol := If(Len(aColunas) > 0, aColunas[HISTORICO], 097)
		@ li ++, nCol PSAY STR0025 + 	Trans(CT6->CT6_INF,; //"INFORMADO"
		Tm(CT6->CT6_INF,17))
		@ li   , nCol PSAY STR0026 + 	Trans(CT6->CT6_DIG,; //"DIGITADO "
		Tm(CT6->CT6_DIG,17))
		If Round(NoRound(CT6->CT6_DIG - CT6->CT6_INF, 2), 2) # 0
		li ++
		@ li,nCol PSAY STR0027 + 	Trans(Abs(CT6->CT6_DIG -; //"DIFERENCA"
		CT6->CT6_INF), Tm(CT6->CT6_DIG,17))
		Endif
		Else
		@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(CT6->CT6_INF,; //"INFORMADO "
		Tm(CT6->CT6_INF,17)) +;
		Space(4) + STR0026 +; //"DIGITADO "
		Trans(CT6->CT6_DIG, Tm(CT6->CT6_DIG,17)) +;
		Space(4) + STR0027 +;  //"DIFERENCA"
		Trans(	Abs(CT6->CT6_DIG-CT6->CT6_INF),;
		Tm(CT6->CT6_DIG,17))
		Endif
		EndIf
		li++
		nTotLotDeb := 0
		nTotLotCrd := 0
		EndIf
		ElseiF lResumo       			// Relatorio Resumido
		IF li > 62
		CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
		EndIf
		nDif := Round(NoRound(nTotalDeb - nTotalCrd, 2), 2)
		//		CTC->(MsSeek(xFilial()+dtos(dDataRes)+cLoteRes+cSubRes+cDocRes+"01"))

		CTC->(MsSeek(xFilial("CTC")+dtos(dDataRes)+cLoteRes+cSubRes+cDocRes+cMoeda))

		@ li,000 PSAY DTOC(dDataRes)
		@ li,014 PSAY cLoteRes
		@ li,028 PSAY cSubRes
		@ li,038 PSAY cDocRes
		If lTot123 == 1
		@ li,048 PSAY CTC->CTC_INF 	Picture Tm(CTC->CTC_INF,17)
		@ li,069 PSAY nTotalDeb 	Picture Tm(nTotalDeb,17)
		@ li,090 PSAY nTotalCrd 	Picture Tm(nTotalCrd,17)
		@ li,110 PSAY Abs(nDif)		Picture Tm(Abs(nDif),17)
		If nDif > 0
		@ li,131 PSAY STR0023 		// "DIF A DEBITO"
		ElseIf nDif < 0
		@ li,131 PSAY STR0024		// "DIF A CREDITO"
		EndIf
		@ li,148 PSAY CTC->CTC_DIG 	Picture Tm(CTC->CTC_DIG,17)

		nTotGerDig += CTC->CTC_DIG
		nTotGerInf += CTC->CTC_INF

		nDif := Round(NoRound(CTC->CTC_DIG - CTC->CTC_INF, 2), 2)
		@ li,169 PSAY Abs(nDif)		Picture Tm(nDif,17)
		Else
		@ li,069 PSAY nTotalDeb 	Picture Tm(nTotalDeb,17)
		@ li,090 PSAY nTotalCrd 	Picture Tm(nTotalCrd,17)
		EndIf
		li++
		nTotalDeb 	:= 0
		nTotalCrd 	:= 0
		Endif
		*/
		// Impressao do Cabecalho
		If mv_par12 == 1			// Quebra pagina quando for lote diferente
			#IFNDEF TOP
			If	cLote != (cAliasCT2)->CT2_LOTE 				.Or.;
			cSubLote != (cAliasCT2)->CT2_SBLOTE 			.Or.;
			Dtos(dData) != Dtos((cAliasCT2)->CT2_DATA)   .And. UCtr070Skip(cAliasCT2,lAllSL)
				CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			EndIf
			#ELSE
			If	cLote != (cAliasCT2)->CT2_LOTE 				.Or.;
			cSubLote != (cAliasCT2)->CT2_SBLOTE 			.Or.;
			Dtos(dData) != Dtos((cAliasCT2)->CT2_DATA)   .And. (If(TcSrvType() == "AS/400", UCtr070Skip(cAliasCT2,lAllSL),.T.))
				CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			EndIf
			#ENDIF

		ElseIF li > 62
			CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
		EndIf
	EndDo

	If li != 80
		If lTotal
			IF li > 62
				CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			EndIf
			li+=2
			@ li,00 PSAY Replicate("-",Limite)
			li++
			@ li,02 PSAY STR0019
			If !lResumo
				If !lCusto .And. !lItem  .And. !lCV
					@ li, 049 PSAY nTotGerDeb Picture Tm(nTotGerDeb,17)
					@ li, 070 PSAY nTotGerCrd Picture Tm(nTotGerCrd,17)
				Else
					@ li, aColunas[VALOR_DEBITO] 	PSAY nTotGerDeb Picture Tm(nTotGerDeb,17)
					@ li, aColunas[VALOR_CREDITO] 	PSAY nTotGerCrd Picture Tm(nTotGerCrd,17)
				Endif
				If lTot123 == 1
					If limite = 132
						nCol := If(Len(aColunas) > 0, aColunas[HISTORICO], 097)
						@ li ++, nCol  	PSAY STR0025 + 	Trans(nTotGerInf, Tm(nTotGerInf,17)) //"INFORMADO"
						@ li   , nCol	PSAY STR0026 + 	Trans(nTotGerDig, Tm(nTotGerDig,17)) //"DIGITADO "
						If Round(NoRound(nTotGerDig - nTotGerInf, 2), 2) # 0
							li ++
							@ li,nCol	PSAY STR0027 + 	Trans(Abs(nTotGerDig - nTotGerInf),; //"DIFERENCA"
							Tm(nTotGerDig,17))
						Endif
					Else
						@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(nTotGerInf,; //"INFORMADO "
						Tm(nTotGerInf,17)) +;
						Space(4) + STR0026 +; //"DIGITADO "
						Trans(nTotGerDig, Tm(nTotGerDig,17)) +;
						Space(4) + STR0027 +;  //"DIFERENCA"
						Trans(	Abs(nTotGerDig-nTotGerInf),;
						Tm(nTotGerDig,17))
					Endif
				EndIf
			Else
				If lTot123 == 1
					nDif := nTotGerDeb - nTotGerCrd

					@ li,048 PSAY nTotGerInf 	Picture Tm(nTotGerInf,17)
					@ li,069 PSAY nTotGerDeb 	Picture Tm(nTotGerDeb,17)
					@ li,090 PSAY nTotGerCrd 	Picture Tm(nTotGerCrd,17)
					@ li,110 PSAY Abs(nDif)		Picture Tm(Abs(nDif),17)
					@ li,148 PSAY nTotGerDig 	Picture Tm(nTotGerDig,17)

					nDif := Round(NoRound(nTotGerDig - nTotGerInf, 2), 2)
					@ li,169 PSAY Abs(nDif)		Picture Tm(nDif,17)
				Else
					@ li,069 PSAY nTotGerDeb 	Picture Tm(nTotGerDeb,17)
					@ li,090 PSAY nTotGerCrd 	Picture Tm(nTotGerCrd,17)
				EndIf
			Endif
			li++
			@ li,00 PSAY Replicate("-",Limite)
		EndIf
		roda(cbcont,cbtxt,"M")
		Set Filter To
	EndIf

	If aReturn[5] = 1
		Set Printer To
		Commit
		Ourspool(wnrel)
	EndIf

	MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ctr070Skip³ Autor ³ Pilar S Albaladejo	³ Data ³ 02.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica condicoes para pular os registros			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctr070Skip(cAlias) 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias = Se for TOP, receberá o ALIAS da query gerada.      ±±
±±           ³          O Default será "CT2".                              ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function UCtr070Skip(cAlias,lAllSL)

	DEFAULT cAlias := "CT2"
	DEFAULT lAllSL := .F.

	If !lAllSL
		If mv_par11 <> (cAlias)->CT2_TPSALD
			(cAlias)->( DbSkip() )
			Return .T.
		Endif
	EndIf

	If ! ( ( cAlias )->CT2_LOTE >= mv_par03 .And. (cAlias)->CT2_LOTE <= mv_par04 )
		MsSeek( Soma1( xFilial("CT2")+DTOS((cAlias)->CT2_DATA)+(cAlias)->CT2_LOTE )+mv_par15+mv_par05, .T.)
		Return .T.
	Endif

	If ! ( (cAlias)->CT2_DOC >= mv_par05 .And. (cAlias)->CT2_DOC <= mv_par06 )
		MsSeek( Soma1( xFilial("CT2")+DTOS((cAlias)->CT2_DATA)+(cAlias)->CT2_LOTE+(cAlias)->CT2_SBLOTE+(cAlias)->CT2_DOC ), .T.)
		Return .T.
	Endif

	If ! ( (cAlias)->CT2_SBLOTE >= mv_par15 .And. (cAlias)->CT2_SBLOTE <= mv_par16 )
		MsSeek( Soma1( xFilial("CT2")+DTOS((cAlias)->CT2_DATA)+(cAlias)->CT2_LOTE+(cAlias)->CT2_SBLOTE )+mv_par05, .T.)
		Return .T.
	Endif

	If (cAlias)->CT2_MOEDLC <> mv_par07
		(cAlias)->( DbSkip() )
		Return .T.
	Endif

	If (cAlias)->CT2_DC = "4"
		(cAlias)->( DbSkip() )
		Return .T.
	EndIf

	If cPaisLoc == "CHI" .And. ! ( (cAlias)->CT2_SEGOFI >= mv_par22 .And. (cAlias)->CT2_SEGOFI <= mv_par23 )
		(cAlias)->( DbSkip() )
		Return .T.
	EndIf

Return .F.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ctr070Ctt ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 17.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a troca para impressao de codigo reduzido de acordo com ³±±
±±³          ³mv_par15 = 2                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctr070Ctt(cCC)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cCC = Conteudo a Ser impresso                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ctbr070                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCc = Centro de custo a ser substituido (se for o caso)    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function UCtr070Ctt(cCc)

	Local aSaveArea := GetArea()

	If mv_par18 = 2
		dbSelectArea("CTT")
		dbSetOrder(1)
		MsSeek(xFilial() + cCC)
		cCC := CTT->CTT_RES
	Endif

	RestArea(aSaveArea)
Return cCC

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ctr070Ctd ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 17.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a troca para impressao de codigo reduzido de acordo com ³±±
±±³          ³mv_par16 = 2                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctr070Ctd(cItem)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cItem = Conteudo a Ser impresso                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ctbr070                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cItem = Item a ser substituido (se for o caso)    	      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function UCtr070Ctd(cItem)

	Local aSaveArea := GetArea()

	If mv_par19 = 2
		dbSelectArea("CTD")
		dbSetOrder(1)
		MsSeek(xFilial() + cItem)
		cItem := CTD->CTD_RES
	Endif

	RestArea(aSaveArea)
Return cItem

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ctr070Cth ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 17.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a troca para impressao de codigo reduzido de acordo com ³±±
±±³          ³mv_par17 = 2                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctr070Cth(cClVl)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cItem = Conteudo a Ser impresso                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ctbr070                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cClVl = Classe de valor a ser substituida (se for o caso)  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function UCtr070Cth(cClVl)

	Local aSaveArea := GetArea()

	If mv_par20 = 2
		dbSelectArea("CTH")
		dbSetOrder(1)
		MsSeek(xFilial() + cCLVL)
		cCLVL := CTH->CTH_RES
	Endif

	RestArea(aSaveArea)
Return cCLVL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTR070SX1    ³Autor ³  Lucimara Soares     ³Data³ 25/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria as perguntas do relatório Ctr070                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function UCTR070SX1()

	Local aSaveArea 	:= GetArea()
	Local cMvPar		:= ""
	Local cMvCh			:= ""

	aPergs := {}

	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}

	If cPaisLoc == "CHI"
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ATENCAO                                                                ³
		³Caso haja a necessidade de adicao de novos parametros entrar em contato³
		³com o departamento de Localizacoes.          						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

		PutSx1(cPerg, "22","Do Correlativo ?","¿De Correlativo ?","From Correlative?","mv_chm","C",10,0,0,;
		"G",""," ","","","MV_PAR22"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",;
		" "," ",{"Informe o numero do correlativo.s"},{"Inform the correlative  number."},{"Informe el numero del correlativo."})

		PutSx1(cPerg, "23","Ate Correlativo ?","¿Hasta Correlativo ?","To Correlative?","mv_chn","C",10,0,0,;
		"G","","","","","MV_PAR23"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",;
		" "," ",{"Informe o numero do correlativo.s"},{"Inform the correlative  number."},{"Informe el numero del correlativo."})

		cMvPar	:= "24"
		cMvCh	:= "o"
	Else
		cMvPar	:= "22"
		cMvCh	:= "m"
	EndIf

	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}
	Aadd(aHelpPor,"Informe se deseja imprimir o total ")
	Aadd(aHelpPor,"informado,digitado e a diferenca.")

	Aadd(aHelpSpa,"Informe si desea imprimir el total ")
	Aadd(aHelpSpa,"informado, registrado y la diferencia.")

	Aadd(aHelpEng,"Inform if you wish to print the ")
	Aadd(aHelpEng,"entered total,typed total and ")
	Aadd(aHelpEng,"the difference.")

	Aadd(aPergs,{  "Imp.Tot.Inf/Dig/Dif?","¨Imp.Tot.Inf/Reg/Dif?","Print.Ent./typ/Diff Tot.?","mv_ch"+cMvCh,"N",1,0,0,"C","","mv_par"+cMvPar,"Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa})

	AjustaSx1("CTR070", aPergs)

	RestArea(aSaveArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RpPrintHistºAutor ³Renato F. Campos    º Data ³  02/16/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão do historico detalhado do lançamento contabil    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ R4                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RpPrintHist( cAliasCT2 , oSection11 )

	Local cLote 	:= (cAliasCT2)->CT2_LOTE
	Local cSubLote 	:= (cAliasCT2)->CT2_SBLOTE
	Local cDoc		:= (cAliasCT2)->CT2_DOC
	Local dData 	:= (cAliasCT2)->CT2_DATA
	Local cSeq 		:= (cAliasCT2)->CT2_SEQLAN
	Local cEmpOri	:= (cAliasCT2)->CT2_EMPORI
	Local cFilOri	:= (cAliasCT2)->CT2_FILORI
	Local nReg		:= 0

	Default cAliasCT2 := 'CT2'

	//oSection11:Cell( "CT2_LINHA"	):SetBlock( { || '' } )
	//oSection11:Cell( "CCONTA"  	 	):SetBlock( { || '' } )
	//oSection11:Cell( "CCONTAD"		):SetBlock( { || '' } )
	//oSection11:Cell( "CCONTAC"		):SetBlock( { || '' } )

	//oSection11:Cell( "CCUSTO"		):SetBlock( { || '' } )
	//oSection11:Cell( "CITEM"		):SetBlock( { || '' } )
	//oSection11:Cell( "CCLASSE"		):SetBlock( { || '' } )
	//oSection11:Cell( "CDEBITO"		):SetBlock( { || 0  } )
	//oSection11:Cell( "CCREDITO"		):SetBlock( { || 0  } )

	///oSection11:Cell( "CT2_HP"   	):SetBlock( { || '' } )
	//oSection11:Cell( "CT2_HIST" 	):SetBlock( { || '' } )
	//oReport:SkipLine(1)

	/*oReport:PrintText( "",oReport:Row(),320)
	oReport:PrintText( "",oReport:Row(),500)
	oReport:PrintText( "",oReport:Row(),1000)
	oReport:PrintText( "",oReport:Row(),1700)
	oReport:PrintText( "",oReport:Row(),1940)
	*/

	// Procura pelo complemento de historico
	dbSelectArea( cAliasCT2 )
	nReg := Recno()

	dbSelectArea("CT2")
	dbSetOrder( 10 )

	//oSection11:Cell( "CT2_DC" ):SetBlock( { || '4' } )

	If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeq+cEmpOri+cFilOri)
		// nahim
		cTexto		:= CT2->CT2_HIST
		dbSkip()

		If CT2->CT2_DC == "4"
			While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
			CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
			CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_EMPORI == cEmpOri .And. ;
			CT2->CT2_FILORI == cFilOri 	.And. ;
			DTOS(CT2->CT2_DATA) == DTOS(dData)
				//			    alert(CT2->CT2_HIST)
				If CT2->CT2_DC == "4"

					//oSection11:Cell( "CT2_LINHA" ):SetBlock( { || CT2->CT2_LINHA	} )
					///oSection11:Cell( "CT2_HP"    ):SetBlock( { || CT2->CT2_HP 		} )
					//oSection11:Cell( "CT2_HIST"  ):SetBlock( { || CT2->CT2_HIST	} )
					//oReport:skipLine(1)
					//				oReport:PrintText( CT2->CT2_HIST,oReport:Row(),400) // Denar 19/10/2016
					//                oReport:skipLine(1)

					cTexto := Alltrim(cTexto) + alltrim(CT2->CT2_HIST)
					//oSection11:PrintLine()
					//		    		alert(CT2->CT2_HIST)
				EndIf
				dbSkip()
			EndDo
			// nahim
			//CabToArray(cTexto,nTamLine)
			ArrayTexto :=  CabToArray(cTexto,80) // toma el array
			//		oReport:skipLine(1)
			//oReport:nFontBody			:= 32
			//oReport:cFontBody			:= "Times new roman"

			For i := 1 to Len( ArrayTexto) // for each de un array
				//         oReport:SAY(oReport:Row(), 400, ArrayTexto[i],oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
				//		alert(ArrayTexto[i])
				oReport:PrintText(ArrayTexto[i],oReport:Row(),400,CLR_BLACK) //
				oReport:skipLine(1)
				//		oSection11:PrintLine()
			next
			//		oReport:skipLine(1)
		Endif
	EndIf

	oReport:skipLine(2) //Denar

	dbSelectArea("CT2")
	dbSetOrder(1)

	dbSelectArea(cAliasCT2)
	dbGoto( nReg )
return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR070IBO ³ Autor ³ Ramiro Queso Cusi     ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Conferencia Digitacao Modelo 1        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR070IBO(lEnd,WnRel,cString,Titulo,lCusto,lItem,lCV)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³          ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³          ³ ExpC2   - Mensagem                                         ³±±
±±³          ³ ExpC3   - Titulo                                           ³±±
±±³          ³ ExpL1   - Define se imprime o centro de custo              ³±±
±±³          ³ ExpL2   - Define se imprime o item                         ³±±
±±³          ³ ExpL3   - Define se imprime a classe de valor              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR070IBO(lEnd,WnRel,cString,Titulo,lCusto,lItem,lCV,Limite)

	LOCAL CbTxt		:= Space(10)
	Local CbCont	:= 0
	Local cabec1  	:= ""
	Local cabec2  	:= " "

	Local aColunas		:= {}
	Local cLote
	Local cSubLote
	Local cDoc
	Local cMoeda		:= mv_par07
	Local cSayItem		:= CtbSayApro("CTD")
	Local cSayCC		:= CtbSayApro("CTT")
	Local cSayCV		:= CtbSayApro("CTH")
	Local cLoteRes
	Local cSubRes
	Local cDocRes
	Local dDataRes		:= CTOD("  /  /  ")
	Local dData
	Local lTotal		:= Iif(mv_par13 == 1,.T.,.F.)
	Local lResumo	    := Iif(mv_par17 == 1,.T.,.F.)
	Local lPrimPag		:= .T.
	Local lQuebraDoc	:= .F.
	Local cSEGOFI		:= "" //Correlativo para o Chile
	Local nTotalDeb		:= 0
	Local nTotalCrd		:= 0
	Local nTotLotDeb	:= 0
	Local nTotLotCrd	:= 0
	Local nTotGerDeb	:= 0
	Local nTotGerCrd	:= 0
	Local nTotGerInf	:= nTotGerDig := 0
	Local nDif			:= 0
	Local nCol
	Local n
	Local nStr
	Local lAllSL		:= If(Empty(mv_par11) .or. mv_par11=="*",.T.,.F.)
	Local oReportN

	If !lResumo

		If !lCusto .And. !lItem .And. !lCV //So imprime a conta
			Cabec1 := STR0007+space(19)+STR0015
		Else

			/*

			LI TP CONTA                C CUSTO              ITEM CONTA           COD CL VAL                   VALOR DEB        VALOR CRED  HP HIST

			12345678901234567890 12345678901234567890 12345678901234567890 12345678901234567890 12345678901234567 12345678901234567 123 1234567890123456789012345678901234567890

			LI TP CONTA                ITEM CONTA           COD CL VAL                   VALOR DEB        VALOR CRED  HP HIST

			12345678901234567890 12345678901234567890 12345678901234567890 12345678901234567 12345678901234567 123 1234567890123456789012345678901234567890

			LI TP CONTA                COD CL VAL                   VALOR DEB        VALOR CRED  HP HIST
			12345678901234567890         VALOR DEB        VALOR CRED  HP HIST

			12345678901234567890 12345678901234567890 12345678901234567 12345678901234567 123 1234567890123456789012345678901234567890
			*/

			Cabec1 := STR0008
			If lCusto .And. lItem .And. lCv
				aColunas := { 027, 048, 069, 090, 108, 126, 130 }
			ElseIf (lCusto .And. lItem)
				aColunas := { 027, 048, 000, 069, 087, 105, 109 }
			ElseIf (lCusto .And. lCv)
				aColunas := { 027, 000, 048, 069, 087, 105, 109 }
			ElseIf (lItem .And. lCv)
				aColunas := { 000, 027, 048, 069, 087, 105, 109 }
			ElseIf lCusto
				aColunas := { 027, 000, 000, 048, 066, 084, 088 }
			ElseIf lItem
				aColunas := { 000, 027, 000, 048, 066, 084, 088 }
			Else
				aColunas := { 000, 000, 027, 048, 066, 084, 088 }
			Endif
			If lCusto
				Cabec1 += Upper(Left(cSayCC + Space(21), 21))
			Endif
			If lItem
				Cabec1 += Upper(Left(cSayItem + Space(21), 21))
			Endif
			If lCv
				Cabec1 += Upper(Left(cSayCv + Space(21), 21))
			Endif
			Cabec1 += STR0016
		EndIf
	Else
		If lTot123 == 1
			Cabec1 := STR0021
		Else
			Cabec1 := STR0031
		EndIF

		CTC->(DbSetOrder(1))
		/*
		DATA          LOTE      SUBLOTE    DOCUMENTO      TOTAL INFORMADO       VALOR A DEBITO      VALOR A CREDITO           DIFERENCA                        TOTAL DIGITADO    DIFERENCA INF/DIG
		***********************************************************************************************************************************************************************************************************
		10/06/2002    008850        001       000001             2.500,00             2.500,00             2.500,00                0,00    1234567890123             2.500,00                 0,00    1234567890123
		*/
	EndIf

	#IFDEF TOP
	If TcSrvType() <> "AS/400"

		cQuery := "SELECT * FROM " + RetSqlName("CT2")     + " "
		cQuery += "WHERE CT2_FILIAL  = '" + xFilial("CT2") + "' AND "
		cQuery +=       "CT2_DATA   >= '" + DTOS(mv_par01) + "' AND "
		cQuery += 	    "CT2_DATA   <= '" + DTOS(mv_par02) + "' AND "
		cQuery += 	    "CT2_LOTE   >= '" + mv_par03 	   + "' AND "
		cQuery += 	    "CT2_LOTE   <= '" + mv_par04 	   + "' AND "
		cQuery += 	    "CT2_SBLOTE >= '" + mv_par15 	   + "' AND "
		cQuery += 		"CT2_SBLOTE <= '" + mv_par16 	   + "' AND "
		cQuery +=   	"CT2_DOC    >= '" + mv_par05 	   + "' AND "
		cQuery += 		"CT2_DOC    <= '" + mv_par06 	   + "' AND "
		cQuery += 		"CT2_MOEDLC = '"+ mv_par07 + "' AND "
		cQuery += 		"CT2_CLVLDB = '0"+ alltrim(str(mv_par24)) + "' AND "
		If !lAllSL
			cQuery += 		"CT2_TPSALD = '"+ mv_par11 + "' AND "
		EndIf
		cQuery += 		"CT2_DC <> '4' AND "
		cQuery +=       "D_E_L_E_T_ = '' "
		cQuery += "ORDER BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA"

		cQuery := ChangeQuery(cQuery)

		If Select("cArqCT2") > 0
			dbSelectArea("cArqCT2")
			dbCloseArea()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)

		aStrSTRU := CT2->(dbStruct())      //// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM

		For nStr := 1 to Len( CT2->(dbStruct()) )        //// LE A ESTRUTURA DA TABELA
			If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
				TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
			EndIf
		Next

		dbSelectArea("cArqCT2")
		cAliasCT2 := "cArqCT2"
	Else
		#ENDIF

		dbSelectArea("CT2")
		dbSetOrder(1)
		dbSeek( xFilial("CT2") + DTOS( mv_par01 ) + mv_par03 + mv_par15 + mv_par05 ,.T.)

		cAliasCT2 := "CT2"

		#IFDEF TOP
	EndIf
	#ENDIF

	SetRegua(RecCount())

	While !Eof() .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") .And.;
	(cAliasCT2)->CT2_DATA <= mv_par02

		// Tratando o filtro que o usuario informou para o relatorio
		If ! Empty( aReturn[7] )
			If ! &(aReturn[7])
				(cAliasCT2)->( DbSkip() )
				Loop
			EndIf
		EndIf

		If lEnd
			@Prow()+1,0 PSAY STR0009   //"***** CANCELADO PELO OPERADOR *****"
			Exit
		EndIF

		#IFNDEF TOP
		If UCtr070Skip(cAliasCT2,lAllSL)
			Loop
		EndIf
		#ELSE
		If TcSrvType() == "AS/400"
			If UCtr070Skip(cAliasCT2,lALLSL)
				Loop
			EndIf
		EndIf
		#ENDIF

		IncRegua()

		cLote 		:= (cAliasCT2)->CT2_LOTE
		cSubLote 	:= (cAliasCT2)->CT2_SBLOTE
		cDoc		:= (cAliasCT2)->CT2_DOC
		dData 		:= (cAliasCT2)->CT2_DATA

		cLoteRes 	:= (cAliasCT2)->CT2_LOTE
		cSubRes		:= (cAliasCT2)->CT2_SBLOTE
		cDocRes		:= (cAliasCT2)->CT2_DOC
		dDataRes	:= (cAliasCT2)->CT2_DATA

		If cPaisLoc == "CHI"
			cSegOfi := (cAliasCT2)->CT2_SEGOFI
		EndIf
		lFirst:= .T.
		nTotalDeb := 0
		nTotalCrd := 0

		lQuebraDoc := Iif(mv_par12==2,.T.,.F.)
		While (cAliasCT2)->(!Eof()) .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") 	.And.;
		Dtos((cAliasCT2)->CT2_DATA) == Dtos(dData) 	.And.;
		(cAliasCT2)->CT2_LOTE == cLote 				.And.;
		(cAliasCT2)->CT2_SBLOTE == cSubLote 		.And.;
		(cAliasCT2)->CT2_DOC == cDoc

			// Tratando o filtro que o usuario informou para o relatorio
			If ! Empty( aReturn[7] )
				If ! &(aReturn[7])
					(cAliasCT2)->( DbSkip() )
					Loop
				EndIf
			EndIf

			#IFNDEF TOP
			If UCtr070Skip(cAliasCT2,lAllSL)
				Loop
			EndIf
			#ELSE
			If TcSrvType() == "AS/400"
				If UCtr070Skip(cAliasCT2,lAllSL)
					Loop
				EndIf
			EndIf
			#ENDIF

			IncRegua()

			IF (!lResumo .And. li > 62) .Or. lQuebraDoc
				Cabec( Titulo, Cabec1, Cabec2, dDataBase, Tamanho,"")

				//			CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
				If lQuebraDoc .Or. lPrimPag
					lPrimPag	:= .F.
				EndIf
				lQuebraDoc := .F.
			EndIf

			/*		If lFirst .And. !lResumo
			@ li,00 PSAY Replicate("-",Limite)
			li++
			@ li,000 PSAY STR0012
			@ li,007 PSAY DTOC(dData)
			@ li,019 PSAY STR0013
			@ li,027 PSAY cLote
			@ li,038 PSAY STR0017 //"Sub-Lote"
			@ li,049 PSAY cSubLote
			@ li,058 PSAY STR0014
			@ li,064 PSAY cDoc
			If cPaisLoc == "CHI"
			@ Li,80 PSAY STR0029 + cSegOfi
			EndIf
			lFirst := .F.
			li ++
			@ li,00 PSAY Replicate("-",Limite)
			li++
			EndIf
			*/

			If !lResumo			// Imprime o relatorio detalhado
				If ! lCusto .And. ! lItem .And. ! lCv //Se nao imprime C.C, Item E Cl.Valores
					@ li, 000 PSAY (cAliasCT2)->CT2_LINHA
					@ li, 004 PSAY (cAliasCT2)->CT2_DC
					If mv_par08 == 2
						dbSelectArea("CT1")
						dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_DEBITO)
						@ li, 006 PSAY CT1->CT1_RES
						dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_CREDIT)
						@ li, 027 PSAY CT1->CT1_RES
						dbSelectArea(cAliasCT2)
					Else
						@ li, 006 PSAY (cAliasCT2)->CT2_DEBITO
						@ li, 027 PSAY (cAliasCT2)->CT2_CREDIT
					Endif

					nValor	:= (cAliasCT2)->CT2_VALOR

					If (cAliasCT2)->CT2_DC == "1" .Or. (cAliasCT2)->CT2_DC == "3"
						@ li, 049 PSAY nValor Picture Tm(nValor,17)
						nTotalDeb += nValor
						nTotGerDeb+= nValor
						nTotLotDeb+= nValor
					Endif
					If (cAliasCT2)->CT2_DC == "2" .Or. (cAliasCT2)->CT2_DC == "3"
						@ li, 070 PSAY nValor Picture Tm(nValor,17)
						nTotalCrd += nValor
						nTotGerCrd+= nValor
						nTotLotCrd+= nValor
					Endif
					@ li, 088 PSAY (cAliasCT2)->CT2_HP
					@ li, 092 PSAY (cAliasCT2)->CT2_HIST
					/*If lAllSL					/// necessario tratar coluna e tamanho do relatório (P, M ou G)
					@ li, 133 PSAY (cAliasCT2)->CT2_TPSALD    /// seria bom, ao imprimir "todos" os saldo, indicar o tipo de saldo no relatorio.
					EndIf*/

				Else //Se imprime C.C ou Item ou Cl. Valores os lanc. tipo '3' serao desdobrados
					If (cAliasCT2)->CT2_DC == '1' .Or. (cAliasCT2)->CT2_DC =='2'//Se o lancamento e tipo '1' ou '2'
						@ li, 000 PSAY (cAliasCT2)->CT2_LINHA
						@ li, 004 PSAY (cAliasCT2)->CT2_DC
						If mv_par08 == 2
							dbSelectArea("CT1")
							If (cAliasCT2)->CT2_DC == '1'
								dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_DEBITO)
								@ li, 006 PSAY CT1->CT1_RES
							ElseIf (cAliasCT2)->CT2_DC == '2'
								dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_CREDIT)
								@ li, 006 PSAY CT1->CT1_RES
							Endif
							dbSelectArea(cAliasCT2)
						Else
							If (cAliasCT2)->CT2_DC == '1'
								@ li, 006 PSAY (cAliasCT2)->CT2_DEBITO
							ElseIf (cAliasCT2)->CT2_DC == '2'
								@ li, 006 PSAY (cAliasCT2)->CT2_CREDIT
							Endif
						Endif

						nValor := (cAliasCT2)->CT2_VALOR
						If (cAliasCT2)->CT2_DC == '1'
							If lCusto
								@ li,aColunas[CENTRO_CUSTO] PSAY UCtr070CTT((cAliasCT2)->CT2_CCD)
							Endif
							If lItem
								@ li,aColunas[ITEM_CONTABIL] PSAY UCtr070CTD((cAliasCT2)->CT2_ITEMD)
							Endif
							If lCv
								@ li,aColunas[CLASSE_VALOR] PSAY UCtr070CTH((cAliasCT2)->CT2_CLVLDB)
							Endif
							@ li,aColunas[VALOR_DEBITO] PSAY nValor Picture Tm(nValor,17)
							nTotalDeb += nValor
							nTotGerDeb+= nValor
							nTotLotDeb+= nValor
						ElseIf (cAliasCT2)->CT2_DC =='2'
							If lCusto
								@ li,aColunas[CENTRO_CUSTO] PSAY UCtr070CTT((cAliasCT2)->CT2_CCC)
							Endif
							If lItem
								@ li,aColunas[ITEM_CONTABIL] PSAY UCtr070CTD((cAliasCT2)->CT2_ITEMC)
							Endif
							If lCv
								@ li,aColunas[CLASSE_VALOR] PSAY UCtr070CTH((cAliasCT2)->CT2_CLVLCR)
							Endif
							@ li,aColunas[VALOR_CREDITO] PSAY nValor Picture Tm(nValor,17)
							nTotalCrd += nValor
							nTotGerCrd+= nValor
							nTotLotCrd+= nValor
						Endif
						@ li, aColunas[CODIGO_HP] PSAY (cAliasCT2)->CT2_HP
						@ li, aColunas[HISTORICO] PSAY (cAliasCT2)->CT2_HIST

					Elseif (cAliasCT2)->CT2_DC == '3' //Se o lancamento e tipo '3', e desdobrado
						For n:=1 to 2
							@ li, 000 PSAY (cAliasCT2)->CT2_LINHA
							If n == 1
								@ li, 004 PSAY '1'
							Else
								@ li, 004 PSAY '2'
							Endif
							If mv_par08 == 2
								dbSelectArea("CT1")
								If n==1
									dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_DEBITO)
									@ li, 006 PSAY CT1->CT1_RES
								Else
									dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_CREDIT)
									@ li, 006 PSAY CT1->CT1_RES
								Endif
								dbSelectArea(cAliasCT2)
							Else
								If n==1
									@ li, 006 PSAY (cAliasCT2)->CT2_DEBITO
								Else
									@ li, 006 PSAY (cAliasCT2)->CT2_CREDIT
								Endif
							Endif

							nValor	:= (cAliasCT2)->CT2_VALOR
							If n == 1
								If lCusto
									@ li,aColunas[CENTRO_CUSTO] PSAY UCtr070CTT((cAliasCT2)->CT2_CCD)
								Endif
								If lItem
									@ li,aColunas[ITEM_CONTABIL] PSAY UCtr070CTD((cAliasCT2)->CT2_ITEMD)
								Endif
								If lCv
									@ li,aColunas[CLASSE_VALOR] PSAY UCtr070CTH((cAliasCT2)->CT2_CLVLDB)
								Endif
								@ li,aColunas[VALOR_DEBITO] PSAY nValor Picture Tm(nValor,17)
								nTotalDeb += nValor
								nTotGerDeb+= nValor
								nTotLotDeb+= nValor
							Else
								If lCusto
									@ li,aColunas[CENTRO_CUSTO] PSAY UCtr070CTT((cAliasCT2)->CT2_CCC)
								Endif
								If lItem
									@ li,aColunas[ITEM_CONTABIL] PSAY UCtr070CTD((cAliasCT2)->CT2_ITEMC)
								Endif
								If lCv
									@ li,aColunas[CLASSE_VALOR] PSAY UCtr070CTH((cAliasCT2)->CT2_CLVLCR)
								Endif
								@ li,aColunas[VALOR_CREDITO] PSAY nValor Picture Tm(nValor,17)
								nTotalCrd += nValor
								nTotGerCrd+= nValor
								nTotLotCrd+= nValor
							Endif
							@ li, aColunas[CODIGO_HP]	PSAY (cAliasCT2)->CT2_HP
							@ li,aColunas[HISTORICO] 	PSAY (cAliasCT2)->CT2_HIST

							If n == 1 .and. mv_par21 == 1
								// Procura pelo complemento de historico
								cSeq 	:= (cAliasCT2)->CT2_SEQLAN
								cEmpOri	:= (cAliasCT2)->CT2_EMPORI
								cFilOri	:= (cAliasCT2)->CT2_FILORI
								nReg := Recno()
								dbSelectArea("CT2")
								dbSetOrder(10)
								If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeq+cEmpOri+cFilOri)
									dbSkip()
									If CT2->CT2_DC == "4"
										While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
										CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
										CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_EMPORI == cEmpOri .And. ;
										CT2->CT2_FILORI == cFilOri 	.And. ;
										DTOS(CT2->CT2_DATA) == DTOS(dData)

											If CT2->CT2_DC == "4"
												li++
												IF li > 62
													/*Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
													Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))*/
													CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
												EndIf
												If !lCusto .And. !lItem .And. !lCV
													@ li, 000 PSAY CT2->CT2_LINHA
													@ li, 004 PSAY CT2->CT2_DC
													@ li, 097 PSAY CT2->CT2_HIST
												Else
													@ li, 000 PSAY CT2->CT2_LINHA
													@ li, 004 PSAY CT2->CT2_DC
													@ li, aColunas[HISTORICO] PSAY CT2->CT2_HIST
												EndIf
											EndIf
											dbSkip()
										EndDo
									EndIf
								EndIf
								dbSelectArea("CT2")
								dbSetOrder(1)
								dbGoto(nReg)

								dbSelectArea(cAliasCT2)
								li++
							ElseIf n == 1
								li++
							EndIf
						Next
					Endif
				EndIf

				// Procura pelo complemento de historico
				cSeq 	:= (cAliasCT2)->CT2_SEQLAN
				cEmpOri	:= (cAliasCT2)->CT2_EMPORI
				cFilOri	:= (cAliasCT2)->CT2_FILORI
				nReg := Recno()
				dbSelectArea("CT2")
				dbSetOrder(10)
				If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeq+cEmpOri+cFilOri)
					dbSkip()
					If CT2->CT2_DC == "4"
						While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
						CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
						CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_EMPORI == cEmpOri .And. ;
						CT2->CT2_FILORI == cFilOri 	.And. ;
						DTOS(CT2->CT2_DATA) == DTOS(dData)

							If CT2->CT2_DC == "4"
								li++
								IF li > 62
									/*Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
									Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))*/
									CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
								EndIf
								If !lCusto .And. !lItem .And. !lCV
									@ li, 000 PSAY CT2->CT2_LINHA
									@ li, 004 PSAY CT2->CT2_DC
									@ li, 097 PSAY CT2->CT2_HIST
								Else
									@ li, 000 PSAY CT2->CT2_LINHA
									@ li, 004 PSAY CT2->CT2_DC
									@ li, aColunas[HISTORICO] PSAY CT2->CT2_HIST
								EndIf
							EndIf
							dbSkip()
						EndDo
					EndIf
				EndIf
				dbSetOrder(1)

				dbSelectArea(cAliasCT2)
				dbGoto(nReg)
				dbSkip()
				li++
				IF li > 62
					CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
					/*Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
					Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))*/
				EndIf
			Else						// Armazena valores para impressa resumida
				cLoteRes 	:= (cAliasCT2)->CT2_LOTE
				cSubRes		:= (cAliasCT2)->CT2_SBLOTE
				cDocRes		:= (cAliasCT2)->CT2_DOC
				dDataRes	:= (cAliasCT2)->CT2_DATA
				If (cAliasCT2)->CT2_DC == "1" .Or. (cAliasCT2)->CT2_DC == "3"
					nValor := (cAliasCT2)->CT2_VALOR
					nTotalDeb += nValor
					nTotGerDeb+= nValor
					nTotLotDeb+= nValor
				EndIf
				If (cAliasCT2)->CT2_DC == "2" .Or. (cAliasCT2)->CT2_DC == "3"
					nValor := (cAliasCT2)->CT2_VALOR
					nTotalCrd += nValor
					nTotGerCrd+= nValor
					nTotLotCrd+= nValor
				EndIf
				dbSkip()
			EndIf
		EndDO

		/*	If lTotal .And. !lResumo			// Relatorio Completo
		li++
		@ li,02 PSAY STR0018
		//		CTC->(MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+cDoc+"01"))
		CTC->(MsSeek(xFilial("CTC")+dtos(dData)+cLote+cSubLote+cDoc+cMoeda))
		nTotGerInf += CTC->CTC_INF
		nTotGerDig += CTC->CTC_DIG
		If !lCusto .And. !lItem  .And. !lCV
		@ li, 049 		PSAY nTotalDeb Picture Tm(nTotalDeb,17)
		@ li, 070 		PSAY nTotalCrd Picture Tm(nTotalCrd,17)
		Else
		@ li, aColunas[VALOR_DEBITO] 	PSAY nTotalDeb Picture Tm(nTotalDeb,17)
		@ li, aColunas[VALOR_CREDITO] 	PSAY nTotalCrd Picture Tm(nTotalCrd,17)
		Endif

		If lTot123 == 1	//Se imprime total informado, digitado e diferenca
		If limite = 132
		nCol := If(Len(aColunas) > 0, aColunas[HISTORICO], 097)
		@ li ++, nCol	PSAY STR0025 + 	Trans(CTC->CTC_INF, Tm(CTC->CTC_INF,17)) //"INFORMADO"
		@ li   , nCol	PSAY STR0026 + 	Trans(CTC->CTC_DIG, Tm(CTC->CTC_DIG,17)) //"DIGITADO "
		If Round(NoRound(CTC->CTC_DIG - CTC->CTC_INF, 2), 2) # 0
		li ++
		@ li,nCol PSAY STR0027 + Trans(Abs(CTC->CTC_DIG - CTC->CTC_INF),; //"DIFERENCA"
		Tm(CTC->CTC_DIG,17))
		Endif
		Else
		@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(CTC->CTC_INF,; //"INFORMADO "
		Tm(CTC->CTC_INF,17)) +;
		Space(4) + STR0026 +; //"DIGITADO "
		Trans(CTC->CTC_DIG, Tm(CTC->CTC_DIG,17)) +;
		Space(4) + STR0027 +; //"DIFERENCA"
		Trans(	Abs(CTC->CTC_DIG-CTC->CTC_INF),;
		Tm(CTC->CTC_DIG,17))
		Endif
		EndIf
		li++
		nTotalDeb := 0
		nTotalCrd := 0

		// TOTALIZA O LOTE
		If cLote != (cAliasCT2)->CT2_LOTE 				.Or.;
		cSubLote != (cAliasCT2)->CT2_SBLOTE 			.Or.;
		Dtos(dData) != Dtos((cAliasCT2)->CT2_DATA)
		li++
		@ li,02 PSAY STR0020
		//	CT6->(MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+"01"))
		CT6->(MsSeek(xFilial("CT6")+dtos(dData)+cLote+cSubLote+cMoeda))
		If !lCusto .And. !lItem  .And. !lCV
		@ li, 049 PSAY nTotLotDeb Picture Tm(nTotLotDeb,17)
		@ li, 070 PSAY nTotLotCrd Picture Tm(nTotLotCrd,17)
		Else
		@ li, aColunas[VALOR_DEBITO] 	PSAY nTotLotDeb Picture Tm(nTotLotDeb,17)
		@ li, aColunas[VALOR_CREDITO] 	PSAY nTotLotCrd Picture Tm(nTotLotCrd,17)
		Endif
		If lTot123 == 1	//Se imprime total informado, digitado e diferenca
		If limite = 132
		nCol := If(Len(aColunas) > 0, aColunas[HISTORICO], 097)
		@ li ++, nCol PSAY STR0025 + 	Trans(CT6->CT6_INF,; //"INFORMADO"
		Tm(CT6->CT6_INF,17))
		@ li   , nCol PSAY STR0026 + 	Trans(CT6->CT6_DIG,; //"DIGITADO "
		Tm(CT6->CT6_DIG,17))
		If Round(NoRound(CT6->CT6_DIG - CT6->CT6_INF, 2), 2) # 0
		li ++
		@ li,nCol PSAY STR0027 + 	Trans(Abs(CT6->CT6_DIG -; //"DIFERENCA"
		CT6->CT6_INF), Tm(CT6->CT6_DIG,17))
		Endif
		Else
		@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(CT6->CT6_INF,; //"INFORMADO "
		Tm(CT6->CT6_INF,17)) +;
		Space(4) + STR0026 +; //"DIGITADO "
		Trans(CT6->CT6_DIG, Tm(CT6->CT6_DIG,17)) +;
		Space(4) + STR0027 +;  //"DIFERENCA"
		Trans(	Abs(CT6->CT6_DIG-CT6->CT6_INF),;
		Tm(CT6->CT6_DIG,17))
		Endif
		EndIf
		li++
		nTotLotDeb := 0
		nTotLotCrd := 0
		EndIf
		ElseiF lResumo       			// Relatorio Resumido
		IF li > 62
		CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
		EndIf
		nDif := Round(NoRound(nTotalDeb - nTotalCrd, 2), 2)
		//		CTC->(MsSeek(xFilial()+dtos(dDataRes)+cLoteRes+cSubRes+cDocRes+"01"))

		CTC->(MsSeek(xFilial("CTC")+dtos(dDataRes)+cLoteRes+cSubRes+cDocRes+cMoeda))

		@ li,000 PSAY DTOC(dDataRes)
		@ li,014 PSAY cLoteRes
		@ li,028 PSAY cSubRes
		@ li,038 PSAY cDocRes
		If lTot123 == 1
		@ li,048 PSAY CTC->CTC_INF 	Picture Tm(CTC->CTC_INF,17)
		@ li,069 PSAY nTotalDeb 	Picture Tm(nTotalDeb,17)
		@ li,090 PSAY nTotalCrd 	Picture Tm(nTotalCrd,17)
		@ li,110 PSAY Abs(nDif)		Picture Tm(Abs(nDif),17)
		If nDif > 0
		@ li,131 PSAY STR0023 		// "DIF A DEBITO"
		ElseIf nDif < 0
		@ li,131 PSAY STR0024		// "DIF A CREDITO"
		EndIf
		@ li,148 PSAY CTC->CTC_DIG 	Picture Tm(CTC->CTC_DIG,17)

		nTotGerDig += CTC->CTC_DIG
		nTotGerInf += CTC->CTC_INF

		nDif := Round(NoRound(CTC->CTC_DIG - CTC->CTC_INF, 2), 2)
		@ li,169 PSAY Abs(nDif)		Picture Tm(nDif,17)
		Else
		@ li,069 PSAY nTotalDeb 	Picture Tm(nTotalDeb,17)
		@ li,090 PSAY nTotalCrd 	Picture Tm(nTotalCrd,17)
		EndIf
		li++
		nTotalDeb 	:= 0
		nTotalCrd 	:= 0
		Endif
		*/
		// Impressao do Cabecalho
		If mv_par12 == 1			// Quebra pagina quando for lote diferente
			#IFNDEF TOP
			If	cLote != (cAliasCT2)->CT2_LOTE 				.Or.;
			cSubLote != (cAliasCT2)->CT2_SBLOTE 			.Or.;
			Dtos(dData) != Dtos((cAliasCT2)->CT2_DATA)   .And. UCtr070Skip(cAliasCT2,lAllSL)
				CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			EndIf
			#ELSE
			If	cLote != (cAliasCT2)->CT2_LOTE 				.Or.;
			cSubLote != (cAliasCT2)->CT2_SBLOTE 			.Or.;
			Dtos(dData) != Dtos((cAliasCT2)->CT2_DATA)   .And. (If(TcSrvType() == "AS/400", UCtr070Skip(cAliasCT2,lAllSL),.T.))
				CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			EndIf
			#ENDIF

		ElseIF li > 62
			CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
		EndIf
	EndDo

	If li != 80
		If lTotal
			IF li > 62
				CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			EndIf
			li+=2
			@ li,00 PSAY Replicate("-",Limite)
			li++
			@ li,02 PSAY STR0019
			If !lResumo
				If !lCusto .And. !lItem  .And. !lCV
					@ li, 049 PSAY nTotGerDeb Picture Tm(nTotGerDeb,17)
					@ li, 070 PSAY nTotGerCrd Picture Tm(nTotGerCrd,17)
				Else
					@ li, aColunas[VALOR_DEBITO] 	PSAY nTotGerDeb Picture Tm(nTotGerDeb,17)
					@ li, aColunas[VALOR_CREDITO] 	PSAY nTotGerCrd Picture Tm(nTotGerCrd,17)
				Endif
				If lTot123 == 1
					If limite = 132
						nCol := If(Len(aColunas) > 0, aColunas[HISTORICO], 097)
						@ li ++, nCol  	PSAY STR0025 + 	Trans(nTotGerInf, Tm(nTotGerInf,17)) //"INFORMADO"
						@ li   , nCol	PSAY STR0026 + 	Trans(nTotGerDig, Tm(nTotGerDig,17)) //"DIGITADO "
						If Round(NoRound(nTotGerDig - nTotGerInf, 2), 2) # 0
							li ++
							@ li,nCol	PSAY STR0027 + 	Trans(Abs(nTotGerDig - nTotGerInf),; //"DIFERENCA"
							Tm(nTotGerDig,17))
						Endif
					Else
						@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(nTotGerInf,; //"INFORMADO "
						Tm(nTotGerInf,17)) +;
						Space(4) + STR0026 +; //"DIGITADO "
						Trans(nTotGerDig, Tm(nTotGerDig,17)) +;
						Space(4) + STR0027 +;  //"DIFERENCA"
						Trans(	Abs(nTotGerDig-nTotGerInf),;
						Tm(nTotGerDig,17))
					Endif
				EndIf
			Else
				If lTot123 == 1
					nDif := nTotGerDeb - nTotGerCrd

					@ li,048 PSAY nTotGerInf 	Picture Tm(nTotGerInf,17)
					@ li,069 PSAY nTotGerDeb 	Picture Tm(nTotGerDeb,17)
					@ li,090 PSAY nTotGerCrd 	Picture Tm(nTotGerCrd,17)
					@ li,110 PSAY Abs(nDif)		Picture Tm(Abs(nDif),17)
					@ li,148 PSAY nTotGerDig 	Picture Tm(nTotGerDig,17)

					nDif := Round(NoRound(nTotGerDig - nTotGerInf, 2), 2)
					@ li,169 PSAY Abs(nDif)		Picture Tm(nDif,17)
				Else
					@ li,069 PSAY nTotGerDeb 	Picture Tm(nTotGerDeb,17)
					@ li,090 PSAY nTotGerCrd 	Picture Tm(nTotGerCrd,17)
				EndIf
			Endif
			li++
			@ li,00 PSAY Replicate("-",Limite)
		EndIf
		roda(cbcont,cbtxt,"M")
		Set Filter To
	EndIf

	If aReturn[5] = 1
		Set Printer To
		Commit
		Ourspool(wnrel)
	EndIf

	MS_FLUSH()

Static Function dFechaToMes(dFecha)
	nMes :=  Val(AllTrim(SubStr(DTOC(dFecha),4,5)))
	cMes := ""
	Do Case
		Case nMes==01 	; cMes := "enero"
		Case nMes==02	; cMes := "febrero"
		Case nMes==03   ; cMes := "marzo"
		Case nMes==04	; cMes := "abril"
		Case nMes==05	; cMes := "mayo"
		Case nMes==06	; cMes := "junio"
		Case nMes==07	; cMes := "julio"
		Case nMes==08	; cMes := "agosto"
		Case nMes==09	; cMes := "septiembre"
		Case nMes==10	; cMes := "octubre"
		Case nMes==11	; cMes := "noviembre"
		Case nMes==12	; cMes := "diciembre"
	EndCase
Return(cMes)

Static function fCabec()
	nPagina++
	//	alert(cvaltochar(oReport:Row()))
	cFLogo := GetSrvProfString("Startpath","") + "Logo.bmp"	//Logo de la empresa
	oReport:SayBitmap(185,80, cFLogo,350,200)				//Logo de la empresa

	oReport:PrintText(" ")	;	oReport:SkipLine(5) //avanza 5 lineas
	//				oReport:SAY(380, 80, "" ,oFont14TN	,1000,CLR_BLACK ,CLR_BLACK )	//Nombre de la empresa
	// nahim centrando titulo
	oReport:SAY(oReport:Row(), 935, Titulo, oFont14TN	,1000,CLR_BLACK ,CLR_BLACK )			//oReport:SkipLine(01)
	oReport:SAY(oReport:Row(), 1850, cSequencial, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(02)
	oReport:SAY(oReport:Row(), 1050, SubTitulo, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )
	oReport:SAY(oReport:Row(), 1850, cDocumento, oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(03)
	oReport:SAY(oReport:Row(), 1850, "Pagina: "+cValToChar(nPagina), oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(3,5)
	oReport:SAY(oReport:Row(), 210, cTextFecha, oFont13TN	,1000,CLR_BLACK ,CLR_BLACK )
	// 09/10/2019
	//	oReport:SkipLine(3,5) Nahim Log de Registro (codigo de usuario)
	oReport:SAY(oReport:Row(), 1850,FWLeUserlg("CT2_USERGA"), oFont13TN	,1000,CLR_BLACK ,CLR_BLACK )
	// 09/10/2019

	//	if (cAliasCT2)->CT2_DC == '4'  // nahim 20/07/2019 imprime glosa
	//		oReport:SAY(500, 210, "CONCEPTO: " + (cAliasCT2)->CT2_HIST, oFont13TN	,1000,CLR_BLACK ,CLR_BLACK )
	//		oReport:SAY(500, 300, (cAliasCT2)->CT2_HIST, oFont13TN	,1000,CLR_BLACK ,CLR_BLACK )
	/*if ((cAliasCT2)->CT2_LP=="575")
	oReport:SAY(500, 210, "RECIBIDO DE: " , oFont13TN	,1000,CLR_BLACK ,CLR_BLACK )
	ElseIf ((cAliasCT2)->CT2_LP=="570")
	oReport:SAY(500, 210, "PAGADO A: " , oFont13TN	,1000,CLR_BLACK ,CLR_BLACK )
	Else
	oReport:SAY(500, 210, "CONCEPTO: " , oFont13TN	,1000,CLR_BLACK ,CLR_BLACK )
	Endif*/
	if !empty((cAliasCT2)->CT2_HIST) .and. (cAliasCT2)->CT2_DC == "4"
		oReport:SAY(500, 210, "CONCEPTO: " , oFont13TN	,1000,CLR_BLACK ,CLR_BLACK )
		oReport:SAY(500, 500, (cAliasCT2)->CT2_HIST, oFont13TN	,1000,CLR_BLACK ,CLR_BLACK )
	endif

	//	oReport:SAY(oReport:Row(), 1650, "TIPO CAMBIO DOLAR: "+CValToChar(cTipoSUS), oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(02)
	//	oReport:SAY(oReport:Row(), 1650, "TIPO CAMBIO UFV: "+CValToChar(cTipoUFV), oFont12TN	,1000,CLR_BLACK ,CLR_BLACK )		;	oReport:SkipLine(02)
	oReport:SkipLine(04)
	oReport:SkipLine(04)
	/*	oReport:SkipLine(03)
	oReport:SAY(oReport:Row(), 120, "LOTE", oFont10TN	,100,CLR_BLACK ,CLR_BLACK )
	oReport:SAY(oReport:Row(), 250, "CUENTA", oFont10TN	,100,CLR_BLACK ,CLR_BLACK )
	oReport:SAY(oReport:Row(), 400, "DESCRIPCION", oFont10TN	,100,CLR_BLACK ,CLR_BLACK )
	oReport:SAY(oReport:Row(), 1000, "HISTORICO", oFont10TN	,100,CLR_BLACK ,CLR_BLACK )
	oReport:SAY(oReport:Row(), 1930, "DEBITO", oFont10TN	,100,CLR_BLACK ,CLR_BLACK )
	oReport:SAY(oReport:Row(), 2190, "CREDITO", oFont10TN	,100,CLR_BLACK ,CLR_BLACK )

	oReport:SkipLine(2)*/
	lCabecera := .F.

return nil
Static Function CabToArray(cTexto,nTamLine)
	Local aTexto := {}
	Local aText2 := {}
	Local cToken := " "
	Local nX
	Local nTam  := 0
	Local cAux  := ""

	aTexto := STRTOKARR ( cTexto , cToken )
	cToken := cToken + cToken

	For nX := 1 To Len(aTexto)
		nTam := Len(cAux) + Len(aTexto[nX])
		If nTam <= nTamLine
			cAux += aTexto[nX] + IIF((nTam+2) <= nTamLine, cToken,"")
		Else
			AADD(aText2,cAux)
			cAux := aTexto[nX] + cToken
		Endif
	Next nX

	If !Empty(cAux)
		AADD(aText2,cAux)
	Endif
Return(aText2)
Static Function impCuadro()
	//CAJAS
	oReport:Box( 550,80,3150,2370)	//Recuadro
	oReport:Box( 550,80,650,2370)	// Recuadro Titulos
	//oReport:Box( 2330,80,2450,2370)	// Recuadro Totales

	oReport:SAY(580, 120, "Código", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	oReport:SAY(580, 330, "Cuenta", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	oReport:SAY(580, 1030, "Glosa", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	oReport:SAY(580, 1780, "Debe", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	oReport:SAY(580, 2080, "Haber", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	//oReport:SAY(580, 2120, "Cheque", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos

	oReport:Box( 550,300,3150,300)		//Linea Vertical
	oReport:Box( 550,1000,3150,1000)		//Linea Vertical
	//		oReport:Box( 550,1100,2560,1100)	//Linea Vertical
	//		oReport:Box( 550,1750,2450,1450)	//Linea Vertical
	oReport:Box( 550,2050,3150,1750)	//Linea Vertical
	//oReport:Box( 550,2100,2450,2100)	//Linea Vertical

return
/**
*
* @author: Denar Terrazas Parada
* @since: 13/10/2020
* @description: Función para imprimir los cuadros de los items y de los totales.
*
*/
Static Function impBoxTotales()
	//CAJAS
	oReport:Box( 550,80,2450,2370)	//Recuadro
	oReport:Box( 550,80,650,2370)	// Recuadro Titulos
	oReport:Box( 2330,80,2450,2370)	// Recuadro Totales

	oReport:SAY(580, 120, "Código", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	oReport:SAY(580, 330, "Cuenta", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	oReport:SAY(580, 1030, "Glosa", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	oReport:SAY(580, 1780, "Debe", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	oReport:SAY(580, 2080, "Haber", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos
	//oReport:SAY(580, 2120, "Cheque", oFont10TN	,1000,CLR_BLACK ,CLR_BLACK ) //Titulos

	oReport:Box( 550,300,2330,300)		//Linea Vertical
	oReport:Box( 550,1000,2330,1000)		//Linea Vertical
	//		oReport:Box( 550,1100,2560,1100)	//Linea Vertical
	//		oReport:Box( 550,1750,2450,1450)	//Linea Vertical
	oReport:Box( 550,2050,2450,1750)	//Linea Vertical
	//oReport:Box( 550,2100,2450,2100)	//Linea Vertical

return
/**
*
* @author: Denar Terrazas Parada
* @since: 13/10/2020
* @description: Función para imprimir los cuadros para las firmas
*
*/
Static Function impBoxFirma()
	oReport:Box( 2550,80,3000,2370)	// Recuadro Firmas

	oReport:Box( 2550,843,3000,843)		//Linea Vertical firmas
	oReport:Box( 2550,1606,3000,1606)	//Linea Vertical firmas

	oReport:Box( 2900,110,2900,810)		//Linea Horizontal firmas
	oReport:Box( 2900,873,2900,1573)	//Linea Horizontal firmas
	oReport:Box( 2900,1636,2900,2336)	//Linea Horizontal firmas

	oReport:SAY(2920, 350, "ELABORADO POR", oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
	oReport:SAY(2920, 1100, "REVISADO POR", oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
	oReport:SAY(2920, 1900, "APROBADO POR", oFont10T	,1000,CLR_BLACK ,CLR_BLACK )
return
static Function AjustaSx1() // posiciona valores para query preguntas
	//alert("Pasa AjustaSx1")

	SX1->(DbSetOrder(1))
	If SX1->(DbSeek(cPerg+Space(4)+'01'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 := DTOS(CT2->CT2_DATA)
		SX1->(MsUnlock())
	End
	If SX1->(DbSeek(cPerg+Space(4)+'02'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  DTOS(CT2->CT2_DATA )
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'03'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  CT2->CT2_LOTE
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'04'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  CT2->CT2_LOTE
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'05'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  CT2->CT2_DOC
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'06'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  CT2->CT2_DOC
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'07'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  '01'
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'12'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  '3'
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'15'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  CT2->CT2_SBLOTE
		SX1->(MsUnlock())
	END
	If SX1->(DbSeek(cPerg+Space(4)+'16'))
		RecLock('SX1',.F.)
		SX1->X1_CNT01 :=  CT2->CT2_SBLOTE
		SX1->(MsUnlock())
	END

return nil