#INCLUDE "FIVEWIN.CH"
#INCLUDE "GPER710.CH"
#INCLUDE "REPORT.CH"
#INCLUDE "PROTHEUS.CH"

#Define TIPOCOT1 "1234"	//1: Dependiente o Asegurado con Pensión del SIP < 65 años que aporta (RA_AFPOPC)
#Define TIPOCOT2 "12*4"	//8: Dependiente o Asegurado con Pensión del SIP > 65 años que aporta (RA_AFPOPC)
#Define TIPOCOTC "1*34"	//C: Asegurado con Pensión del SIP < 65 años que NO aporta (RA_AFPOPC)
#Define TIPOCOTD "1**4"	//D: Asegurado con Pensión del SIP > 65 años que NO aporta (RA_AFPOPC)

#Define NVAL13	13000
#Define NVAL25	25000
#Define NVAL35	35000

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER710    ºAutor   ³Erika Kanamori      º Data  ³  03/19/08     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geração da Planilla de Aportes AFP´s                             º±±
±±º          ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                              º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS      ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|Luciana     |03/08/09|18153/2009 |Ajuste no Relatorio Aportes AFP para      |±±
±±|            |        |           |considerar os dias proporcionais em caso  |±±
±±|            |        |           |admissao e demissao no mes que esta sendo |±±
±±|            |        |           |gerado o relatorio                        |±±
±±|Luciana     |21/09/09|22681/2009 |Tratamento para considerar os dias propor-|±±
±±|            |        |           |cionais em caso de faltas sem justificati-|±±
±±|            |        |           |vas.                                      |±±
±±|Luciana     |04/12/09|28462/2009 |Tratamento para considerar os dias propor-|±±
±±|            |        |           |cionais baseados no campo R9_Desc da tabe-|±±
±±|            |        |           |la SR9 nos casos de admissao e demissao.  |±±
±±|Alex        |29/12/09|30658/2009 |Adaptação para a Gestão corporativa       |±±
±±|            |        |           |respeitar o grupo de campos de filiais.   |±±
±±|L.Trombini  |20/06/11|006600/2011|Inclusao e ajustes de colunas de acordo   |±±
±±|            |        |           |com o novo layout do relatorio            |±±
±±|Claudinei S.|09/01/12|022252/2011|Ajuste para a padronização da impressão em|±±
±±|            |        |     TDPBYP|paisagem e do cabeçalho em Ano/Mes/Dia.   |±±
±±|Claudinei S.|31/10/12|027383/2012|Ajuste nas colunas 21,22,23 e 24 conforme |±±
±±|            |        |     TG2014|leiaute.                                  |±±
±±|M.Silveira  |19/02/13|     TGJFA1|Ajustes p/disponibilizar os campos NUA/CUA|±±
±±|            |        |           |EXT e DEPTO que sao exigidos por lei.     |±±
±±³            ³        ³           ³                                          ³±±
±±³Jonathan Glz³06/05/15³ PCREQ-4256³Se elimina la funcion AjustaSX1T,la cual  ³±±
±±³            ³        ³           ³realiza la modificacion aldiccionario de  ³±±
±±³            ³        ³           ³datos(SX1) por motivo de adecuacion  nueva³±±
±±³            ³        ³           ³estructura de SXs para version 12         ³±±
±±³            ³        ³           ³Se cambia grupo de preguntas a GPR710A    ³±±
±±³Denar T.    ³14/08/19³           ³Se modifica el query para tomar datos del ³±±
±±³            ³        ³           ³periodo abierto en caso corresponda       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TRAFP715()

	Private oReport

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Define Variaveis Private(Basicas)                            ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Private aReturn 	:={ , 1,, 2, 2, 1,"",1 }
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis Utilizadas na funcao IMPR                          ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Private Titulo	    := STR0024		//"Planilla de Aportes AFP´s"
	Private cSubTitulo  := ""
	Private nTipo		:= 1
	Private cFilialDe   := ""
	Private cFilialAte  := ""
	Private cMes 		:= ""
	Private cAno		:= ""
	Private cMatDe      := ""
	Private cMatAte     := ""
	Private cCustoDe    := ""
	Private cCustoAte   := ""
	Private cNomeDe     := ""
	Private cNomeAte    := ""
	Private cSit        := ""
	Private cCat        := ""
	Private nQtdDias	:= 0
	Private cQrySRA := "SRA"
	Private cQrySRD	:= "SRD"
	Private cXRoteir	:= ""
	Private cWhSRD		:= ""
	Private cWhSRC		:= ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis de Acesso do Usuario                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private cAcessaSRA	:= &( " { || " + ChkRH( "GPER710" , "SRA" , "2" ) + " } " )

	//Private nBaseCot	:= 0 Mudança de Layout gravado por coluna
	//Private nTotBaseCot := 0  Mudança de Layout gravado por coluna

	//variaveis para impressão
	Private nFunc 		:= 0
	Private cNOVEDAD 	:= ""
	Private cFechNovedad:= ""
	Private cTipoCI		:= ""
	Private cNumNua		:= ""
	Private nVCol21     := 0
	Private nCol21Tot   := 0
	Private	lReg		:= .F.
	Private aSR9    	:= {}  // Centro de Custo
	Private lValidFil   := .T.
	Private nVCol22     := 0
	Private nVCol23     := 0
	Private nVCol24     := 0

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis utilizadas para parametros                         ³
	³ mv_par01        //  Tipo de Relatorio(AFP Prevision ou Futuro³
	³ mv_par02        //  Filial De						           ³
	³ mv_par03        //  Filial Ate					           ³
	³ mv_par04        //  Mes/Ano Competencia Inicial?             |
	³ mv_par05        //  Matricula De                             ³
	³ mv_par06        //  Matricula Ate                            ³
	³ mv_par07        //  Centro de Custo De                       ³
	³ mv_par08        //  Centro de Custo Ate                      ³
	³ mv_par09        //  Nome De                                  ³
	³ mv_par10        //  Nome Ate                                 ³
	³ mv_par11        //  Situações a imp?                         ³
	³ mv_par12        //  Categorias a imp?                        ³
	³ mv_par13        //  Quantidade de dias cotados?              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	nOrdem   := aReturn[8]

	Pergunte("GPR710A",.T.)

	nTipo 		:= mv_par01
	cFilialDe 	:= mv_par02
	cFilialAte  := mv_par03
	cMes	 	:= Left(mv_par04,02)
	cAno		:= Right(mv_par04,04)
	cMatDe		:= mv_par05
	cMatAte     := mv_par06
	cCustoDe    := mv_par07
	cCustoAte   := mv_par08
	cNomeDe     := mv_par09
	cNomeAte    := mv_par10
	cSit        := mv_par11
	cCat        := mv_par12
	cMesAno		:= mv_par04

	cXRoteir:= U_F3ROTEIR(cAno + cMes)//Funcion para seleccionar un Procedimiento de cálculo si es que existe retroactivo en el periodo
	If(!Empty(cXRoteir))
		cWhSRC:= " AND RC_ROTEIR = '" + cXRoteir + "' "
		cWhSRD:= " AND RD_ROTEIR = '" + cXRoteir + "' "
	EndIf

	//-- Interface de impressao

	cSubTitulo := STR0007+ cAno+"/"+cMes+"/"+Transform(f_UltDia(CtoD("01/"+cMes+"/"+cAno)),"99") //"GESTION/MES/DIA : "
	Titulo := IIf(nTipo==1, STR0022  + " - " + cSubTitulo , STR0021 + " - " + cSubTitulo )//"Planilla de Aportes AFP´s Previsión"
	//ou "Planilla de Aportes AFP´s Futuro de Bolivia"
	oReport := ReportDef(@oReport)
	oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ R.H. - Tatiane Matias ³ Data ³ 30.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do relatorio                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef(oReport)

	Local oSection1
	Local cDesc2 		:= STR0002		//"Se imprimira de acuerdo con los parametros solicitados por el usuario."
	Local cDesc3 		:= STR0003		//"Obs.: Debe imprimirse un Formulario Mensual para cada Filial."
	Local cString		:= "SRA"        // alias do arquivo principal (Base)
	Local aOrd      	:= {STR0004,STR0005,STR0006}		//"Sucursal + Matricula"###"Sucursal + C. Costo"###"Sucural + Nombre"
	Local cApelPat	:= ""
	Local cApelMat	:= ""
	Local cApelCas	:= ""
	Local cPriNom	:= ""
	Local cSegNom	:= ""

	//-- Relatorio
	oReport:= TReport():New("GPER710",OemToAnsi("Hoja1"/*Titulo*/),/*"GPR710A"*/,{|oReport| GR710Imp(oReport)}, Titulo)

	oReport:SetTotalInLine(.F.)
	oReport:PageTotalInLine(.T.)
	oReport:PageTotalBefore(.T.)
	oReport:HideParamPage()
	oReport:HideHeader()

	//-- Section 1
	//--
	//-- ------------------------------------------------------------
	//--
	oSection1:= TRSection():New(oReport,"",{},aOrd)
	oSection1:SetTotalInLine(.F.)
	//oSection1:SetHeaderSection( .F. )
	//-- Celulas
	if(nTipo == 1)//Prevision
		TRCell():New(oSection1, "RA_TIPODOC",	cString, "TIPO DOC."			,, 25  ,,,"CENTER", , , , , .T. , , , .T.)   //"TIPO"
		TRCell():New(oSection1, "RA_RG",		cString, "NUMERO DOCUMENTO"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)   //"NUMERO"
		TRCell():New(oSection1, "RA_ALFANUM",	cString, "ALFANUMERICO DEL DOCUMENTO"	,, 25  ,,,"CENTER", , , , , .T. , , , .T.)  //"EXT"
		TRCell():New(oSection1, "RA_NRNUA",		cString, "NUA/CUA"				,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"NUA/CUA"
		TRCell():New(oSection1, "RA_PRISOBR",	cString, "AP. PATERNO"			,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"APELLIDO PATERNO"
		TRCell():New(oSection1, "RA_SECSOBR",	cString, "AP. MATERNO"			,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"APELLIDO MATERNO"
		TRCell():New(oSection1, "RA_APELIDO",	cString, "AP. CASADA"			,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"APELLIDO DE CASADA"
		TRCell():New(oSection1, "RA_PRINOME",	cString, "PRIMER NOMBRE"		,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"PRIMEIRO NOME"
		TRCell():New(oSection1, "RA_SECNOME",	cString, "SEG. NOMBRE"			,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"SEGUNDO NOME"
		TRCell():New(oSection1, "NOVEDAD",		cString, "NOVEDAD"				,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"NOVEDAD"
		TRCell():New(oSection1, "FECHNOVEDAD",	cString, "FECHA NOVEDAD"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"FECH-NOVEDAD"
		TRCell():New(oSection1, "DIAS-COT",		cString, "DIAS"					,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"DIAS-COT"
		TRCell():New(oSection1, "nVCol21",		cString, "TOTAL GANADO"			,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //Total Ganado (21) RD_VALOR
		TRCell():New(oSection1, "TIPOCOT",		cString, "TIPO COTIZANTE"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"TP Cotizante"
		TRCell():New(oSection1, "RA_TPSEGUR",	cString, "TIPO ASEGURADO"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"TP Segurado"
	else//Futuro
		TRCell():New(oSection1, "nFunc",		cString, "No"		,, 5  ,,,"CENTER", , , , , .T. , , , .T.)   //"NUMERO"
		TRCell():New(oSection1, "RA_TIPODOC",	cString, "(13) TIPO"			,, 25  ,,,"CENTER", , , , , .T. , , , .T.)   //"TIPO"
		TRCell():New(oSection1, "RA_RG",		cString, "(14) No"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)   //"NUMERO"
		TRCell():New(oSection1, "RA_NATURAL",	cString, "EXTENSIÓN"	,, 25  ,,,"CENTER", , , , , .T. , , , .T.)  //"EXT"
		TRCell():New(oSection1, "RA_NRNUA",		cString, "(15) NUA/CUA"				,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"NUA/CUA"
		TRCell():New(oSection1, "RA_PRISOBR",	cString, "(A) 1er. APELLIDO (PATERNO)"			,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"APELLIDO PATERNO"
		TRCell():New(oSection1, "RA_SECSOBR",	cString, "(B) 2do. APELLIDO (MATERNO)"			,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"APELLIDO MATERNO"
		TRCell():New(oSection1, "RA_APELIDO",	cString, "(C) APELLIDO CASADA"			,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"APELLIDO DE CASADA"
		TRCell():New(oSection1, "RA_PRINOME",	cString, "(D) PRIMER NOMBRE"		,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"PRIMEIRO NOME"
		TRCell():New(oSection1, "RA_SECNOME",	cString, "(E) SEGUNDO NOMBRE"			,, 100 ,,,"CENTER", , , , , .T. , , , .T.)  //"SEGUNDO NOME"
		TRCell():New(oSection1, "RA_ESTADO",	cString, "(17) DEPARTAMENTO"			,, 25 ,,,"CENTER", , , , , .T. , , , .T.)  //"DEPARTAMENTO"
		TRCell():New(oSection1, "NOVEDAD",		cString, "(18) NOVEDAD I/R/L/S"				,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"NOVEDAD"
		TRCell():New(oSection1, "FECHNOVEDAD",	cString, "(19) FECHA NOVEDAD dd/mm/aaaa"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"FECH-NOVEDAD"
		TRCell():New(oSection1, "DIAS-COT",		cString, "(20) DIAS COTIZADOS"					,, 50  ,,,"CENTER", , , , , .T. , , , .T.)  //"DIAS-COT"
		TRCell():New(oSection1, "nVCol21",		cString, "(21) TOTAL GANADO SOLIDARIO SIN CONSIDERAR TOPE DE 60 SALARIOS MINIMOS NACIONALES"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)
		TRCell():New(oSection1, "nVCol22",		cString, "(22) TOTAL GANADO SOLIDARIO MENOS BS. 13000 (SI LA DIFERENCIA ES POSITIVA)"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)
		TRCell():New(oSection1, "nVCol23",		cString, "(23) TOTAL GANADO SOLIDARIO MENOS BS. 25000 (SI LA DIFERENCIA ES POSITIVA)"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)
		TRCell():New(oSection1, "nVCol24",		cString, "(24) TOTAL GANADO SOLIDARIO MENOS BS. 35000 (SI LA DIFERENCIA ES POSITIVA)"		,, 50  ,,,"CENTER", , , , , .T. , , , .T.)
	endIf

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPFUT    ºAutor  ³Erika Kanamori      º Data ³  03/19/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GR710Imp(oReport)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis Locais (Programa)                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//-- Objeto
	Local oSection1 	:= oReport:Section(1)
	local cInicio		:= ""
	Local cFim 			:= ""
	Local nSavRec
	Local nSavOrdem
	Local aPerAberto 	:= {}
	Local aPerFechado	:= {}
	Local aPerTodos		:= {}
	Local aCodFol		:= {}
	Local cFilAnt 		:= ""
	Local cFilAux
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis para controle em ambientes TOP.                    ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Local cAlias   	:= ""
	Local cQuery
	Local aStruct  	:= {}
	Local lQuery  	:= .F.
	lOCAL lVerba	:= .F.
	Local cCateg  	:= ""
	Local cSitu   	:= ""
	Local nAux
	Local cPeriodos
	Local nDiasProp := 0
	Local nDias 	:= 0
	Local nTotDias	:= 0
	Local dAdmissa	:= ""
	Local dDemissa	:= ""
	Local cAliasSR9 := "QSR9"
	Local cTipoCot	:= ""

	//Inicializa o mnemonico que ira armazenar as verbas de faltas a serem consideradas no tratamento.
	SetMnemonicos(NIL,NIL,.T.,"P_DESCFALT")
	cAcessaSRA	:= &( " { || " + ChkRH( "GPERFUT" , "SRA" , "2" ) + " } " )

	#IFDEF TOP
	lQuery := .T.
	#ELSE
	cQrySRA:= "SRA"
	dbSelectArea("SRA")
	nSavRec   := RecNo()
	nSavOrdem := IndexOrd()
	#ENDIF

	If nOrdem == 1
		If lQuery
			cQueryOrd := "RA_FILIAL, RA_MAT"
		Else
			dbSetOrder(1)
			SRA->( dbSeek( cFilialDe + cMatDe, .T. ) )
		Endif
		cInicio  := "(cQrySRA)->RA_FILIAL + (cQrySRA)->RA_MAT"
		cFim     := cFilialAte + cMatAte
	Else
		If nOrdem == 2
			If lQuery
				cQueryOrd := "RA_FILIAL, RA_CC, RA_MAT"
			Else
				dbSetOrder(2)
				SRA->( dbSeek( cFilialDe + cCustoDe + cMatDe, .T. ) )
			Endif
			cInicio  := "(cQrySRA)->RA_FILIAL + (cQrySRA)->RA_CC + (cQrySRA)->RA_MAT"
			cFim     := cFilialAte + cCustoAte + cMatAte
		Elseif nOrdem == 3
			If lQuery
				cQueryOrd := "RA_FILIAL + RA_NOME + RA_MAT"
			Else
				dbSetOrder(3)
				SRA->( dbSeek( cFilialDe + cNomeDe + cMatDe, .T.) )
			Endif
			cInicio	:= "(cQrySRA)->RA_FILIAL + (cQrySRA)->RA_NOME + (cQrySRA)->RA_MAT"
			cFim	:= cFilialAte + cNomeAte + cMatAte
		Endif
	Endif

	If lQuery
		//Filtra do SRA: filial, matricula de/ate, centro de custo de/ate, categoria e situacoes
		cAlias := "SRA"
		cQrySRA := "QSRA"

		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Buscar Situacao e Categoria em formato para SQL              ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		cSitu   := "("
		For nAux := 1 To (Len( cSit )-1)
			cSitu += "'" + Substr( cSit, nAux, 1) + "',"
		Next nAux
		cSitu 	+= "'" + Substr( cSit, len(cSit)-1, 1) + "')"

		cCateg   := "("
		For nAux := 1 To (Len( cCat )-1)
			cCateg += "'" + Substr( cCat, nAux, 1) + "',"
		Next nAux
		cCateg	+= "'" + Substr( cCat, len(cCat)-1, 1) + "')"

		//montagem da query
		cQuery := "SELECT "
		cQuery += " RA_FILIAL, RA_MAT, RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME, RA_ESTADO, RA_NOME, RA_RG, RA_TIPODOC, RA_NRNUA, RA_NATURAL, RA_ALFANUM,"
		cQuery += " RA_ADMISSA, RA_DEMISSA, RA_NASC, RA_TPAFP, RA_AFPOPC, RA_HRSMES, RA_CATFUNC, RA_JUBILAC, RA_TPSEGUR, RA_APELIDO"
		cQuery += " FROM " + RetSqlName(cAlias)
		cQuery += " WHERE "
		cQuery += " RA_FILIAL BETWEEN '" + cFilialDe + "' AND '" + cFilialAte + "'"
		cQuery += "  AND "
		cQuery += " RA_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
		cQuery += "  AND "
		cQuery += " RA_NOME BETWEEN '" + cNomeDe + "' AND '" + cNomeAte + "'"
		cQuery += "  AND "
		cQuery += " RA_CC BETWEEN '" + cCustoDe + "' AND '" + cCustoAte + "'"
		cQuery += "  AND "
		cQuery += " RA_TPAFP = '" + iif(nTipo == 1, "1", "2") + "'"
		cQuery += "  AND "
		cQuery += " RA_SITFOLH IN " + cSitu
		cQuery += "  AND "
		cQuery += " RA_CATFUNC IN " + cCateg
		cQuery += " AND "
		cQuery += " D_E_L_E_T_ <> '*'
		cQuery += " ORDER BY " + cQueryOrd

		cQuery := ChangeQuery(cQuery)
		aStruct := (cAlias)->(dbStruct())

		If  MsOpenDbf(.T.,"TOPCONN",TcGenQry(, ,cQuery),cQrySRA,.T.,.T.)
			For nAux := 1 To Len(aStruct)
				If ( aStruct[nAux][2] <> "C" )
					TcSetField(cQrySRA,aStruct[nAux][1],aStruct[nAux][2],aStruct[nAux][3],aStruct[nAux][4])
				EndIf
			Next nAux                                   '
		Endif

		dbSelectArea(cQrySRA)
		(cQrySRA)->(dbGoTop())
	Endif

	oReport:IncMeter()

	While (cQrySRA)->( !Eof() .And. &cInicio <= cFim )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta Regua de Processamento                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If oReport:Cancel()
			Exit
		EndIf

		cFil	:= (cQrySRA)->RA_FILIAL
		cMat	:= (cQrySRA)->RA_MAT
		dAdmissa :=(cQrySRA)->RA_ADMISSA
		dDemissa :=(cQrySRA)->RA_DEMISSA

		If cFilAnt <> (cQrySRA)->RA_FILIAL      //se a filial eh diferente da q acabou de imprimir, imprime rodape e
			// seta nLinha para imprimir as informacoes em uma nova folha

			//carrega periodo da competencia selecionada
			cFilAux:= (cQrySRA)->RA_FILIAL
			fRetPerComp( cMes , cAno , , , , @aPerAberto , @aPerFechado , @aPerTodos )
			/*If len(aPerFechado) < 1
			cFilAux:= Space(FwGetTamFilial)
			fRetPerComp( cMes , cAno , cFilAux , , , @aPerAberto , @aPerFechado , @aPerTodos )
		Endif
		If len(aPerFechado) < 1        //Relatório só pode contemplar periodos fechados
			Return
		Endif*/

		If len(aPerFechado) < 1        //Relatório só pode contemplar periodos fechados
				aPerFechado:= aPerAberto
		Endif

			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Carrega Variaveis Codigos Da Folha                           ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If !fP_CodFol(@aCodFol,(cQrySRA)->RA_FILIAL)
				Return
		Endif

			//		nTotBaseCot := 0
			nCol21Tot   :=0
			nFunc:= 0
			cFilAnt := (cQrySRA)->RA_FILIAL

	Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao do Intervalo de Impressao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If  !lQuery .And. ((SRA->RA_MAT < cMatDe)   .Or. (SRA->RA_MAT > cMatAte)    .Or. ;
		(SRA->RA_CC  < cCustoDe) .Or. (SRA->RA_CC  > cCustoAte)  .Or. ;
		(SRA->RA_NOME < cNomeDe) .Or. (SRA->RA_NOME > cNomeAte)  .Or. ;
		!(SRA->RA_CATFUNC $ cCat) .Or. !(SRA->RA_SITFOLH $ cSit))
			SRA->(dbSkip(1))
			Loop
		EndIf

		//-- Buscar a maior data dos registros para retornar os registros
		cDelet := Iif(TcSrvType() != "AS/400", "%D_E_L_E_T_ = ' '%", "%@DELETED@ = ' '%" )
	BeginSql ALIAS cAliasSR9
			SELECT R9_FILIAL, R9_MAT, R9_CAMPO, R9_DESC
			FROM %table:SR9%
			WHERE R9_FILIAL = %exp:cFil%
			AND R9_MAT = %exp:cMat%
			AND ( R9_CAMPO = 'RA_ADMISSA' OR R9_CAMPO = 'RA_DEMISSA')
			AND %exp:cDelet%

	EndSql

	aSR9 := {}
	While (cAliasSR9)-> (!EOF())
		rFil	:= (cAliasSR9)->R9_FILIAL
		rMat	:= (cAliasSR9)->R9_MAT
		dCampo	:= (cAliasSR9)->R9_CAMPO
		dData	:= cTod(Substr((cAliasSR9)->R9_DESC,1,2)+"/"+Substr((cAliasSR9)->R9_DESC,4,2)+"/"+Substr((cAliasSR9)->R9_DESC,7,4))

		Aadd (aSR9,{rFil,rMat,dCampo,dData})

		(cAliasSR9)-> (dbSkip())
	Enddo
	(cAliasSR9)->(DbCloseArea())

	For nAux = 1 to Len(aSR9)
		If MesAno(aSR9[nAux][4]) == cAno+cMes
			If aSR9[nAux][3] == "RA_ADMISSA"
				dAdmissa := aSR9[nAux][4]
			Endif
			If aSR9[nAux][3] == "RA_DEMISSA"
				dDemissa := aSR9[nAux][4]
			Endif
		Endif
	Next nAux
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Consiste Filiais e Acessos                                             ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF !( (cQrySRA)->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
			dbSelectArea(cQrySRA)
			(cQrySRA)->( dbSkip() )
			Loop
	Endif

		//zera variaveis para cada funcionario
		//		nBaseCot	:= 0
		nDiasProp	:= 0
		nTotDias	:= 0
		nVCol21     := 0

		//quantidade de dias padrao para todos os funcionarios
		nQtdDias:= 30

	If lQuery
			cAlias := "SRD"
			cQrySRD := "QSRD"

			//busca periodos para formato Query
			cPeriodos   := "("
		For nAux:= 1 to (len(aPerFechado)-1)
				cPeriodos += "'" + aPerFechado[nAux][1] + "',"
		Next nAux
			cPeriodos += "'" + aPerFechado[len(aPerFechado)][1]+"')"

			//montagem da query
			cQuery := "SELECT "
			cQuery += " RD_FILIAL, RD_MAT, RD_PROCES, RD_ROTEIR, RD_PERIODO, RD_SEMANA, RD_HORAS, RD_VALOR, RD_PD, RD_TIPO1 "
			cQuery += " FROM " + RetSqlName(cAlias)
			cQuery += " WHERE "
			cQuery += " RD_FILIAL = '" + cFilAnt + "'"
			cQuery += " AND "
			cQuery += " RD_MAT ='" + (cQrySRA)->RA_MAT + "'"
			cQuery += " AND "
			cQuery += " RD_PERIODO IN " + cPeriodos
			cQuery += " AND "
			cQuery += " D_E_L_E_T_ <> '*' "
			cQuery += cWhSRD

			cQuery += " UNION "

			cQuery += " SELECT "
			cQuery += " RC_FILIAL, RC_MAT, RC_PROCES, RC_ROTEIR, RC_PERIODO, RC_SEMANA, RC_HORAS, RC_VALOR, RC_PD, RC_TIPO1 "
			cQuery += " FROM " + RetSqlName("SRC")
			cQuery += " WHERE "
			cQuery += " RC_FILIAL = '" + cFilAnt + "'"
			cQuery += " AND "
			cQuery += " RC_MAT ='" + (cQrySRA)->RA_MAT + "'"
			cQuery += " AND "
			cQuery += " RC_PERIODO IN " + cPeriodos
			cQuery += " AND "
			cQuery += " D_E_L_E_T_ <> '*' "
			cQuery += cWhSRC

			cQuery += " ORDER BY RD_FILIAL, RD_MAT, RD_PROCES, RD_ROTEIR, RD_PERIODO, RD_SEMANA"

			cQuery := ChangeQuery(cQuery)
			aStruct := (cAlias)->(dbStruct())
		If  MsOpenDbf(.T.,"TOPCONN",TcGenQry(, ,cQuery),cQrySRD,.T.,.T.)
			For nAux := 1 To Len(aStruct)
				If ( aStruct[nAux][2] <> "C" )
						TcSetField(cQrySRD,aStruct[nAux][1],aStruct[nAux][2],aStruct[nAux][3],aStruct[nAux][4])
				EndIf
			Next nAux
		Endif
	Else
			dbSelectArea(cQrySRD)
			dbSetOrder(5)
	Endif

		nIdade := 0
	For nAux:=1 to Len(aPerFechado)
			(cQrySRD)->(dbGoTop())
		If !lQuery
				dbSeek((cQrySRA)->(RA_FILIAL+RA_MAT)+ aPerFechado[nAux][7])
		Else
			While (cQrySRD)->(!Eof()) .And. !((cQrySRA)->(RA_FILIAL+RA_MAT)+aPerFechado[nAux][7]== (cQrySRD)->(RD_FILIAL+RD_MAT+RD_PROCES))
					(cQrySRD)->(dbSkip())
			End
		Endif
			nIdade:= Calc_Idade( aPerFechado[len(aPerfechado)][6] , (cQrySRA)->RA_NASC )
		While (cQrySRD)->(!Eof()) .And.  (cQrySRA)->(RA_FILIAL+RA_MAT)+aPerFechado[nAux][7]== (cQrySRD)->(RD_FILIAL+RD_MAT+RD_PROCES)

				/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³Contribuinte de APF o campo RA_APFOPC=1 e obrigatorio, nao sendo aposentado a opcao 2 tambem se torna   ³
				³obrigatoria, sendo <65 vai para a coluna 21                ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			If(!Empty(cXRoteir) .AND. cXRoteir $ 'RE1|RE2|RE3|RE4')
					lVerba := (cQrySRD)->RD_PD == aCodFol[730,1]
			Else
					lVerba := (cQrySRD)->RD_PD == aCodFol[731,1]//Estandar
			EndIf

			If lVerba
					nVCol21 := (cQrySRD)->RD_VALOR
				if(nVCol21 > NVAL13)
						lReg	:= .T.
				endIf
			EndIf

			If  Month(dAdmissa) == Val(cMes) .OR. Month(dDemissa)== Val(cMes)  .And. Year(dAdmissa) == Val(cAno) .Or. Year(dDemissa) == Val(cAno)
				If (cQrySRD)->RD_PD == aCodFol[0031,1]   //=Tratamento para mensalistas admissao
						nDiasProp := (cQrySRD)->RD_HORAS
				Elseif (cQrySRD)->RD_PD == aCodFol[0032,1] //=Tratamento para horistas admissao
						nDias:= (cQrySRA)->RA_HRSMES / 30
						nDiasProp := (cQrySRD)->RD_HORAS / nDias
				Elseif (cQrySRD)->RD_PD == aCodFol[0048,1] //=Tratamento para mensalistas e horistas na rescisao
						nDiasProp := (cQrySRD)->RD_HORAS
				Elseif (cQrySRD)->RD_PD == aCodFol[0165,1] .OR. (cQrySRA)->RA_CATFUNC == "C"  //=Tratamento para comissionados admissao e rescisao
					If Month(dAdmissa) == Val(cMes)
							nDiasProp := ( f_UltDia(aPerFechado[nAux][6]) -  Day(dAdmissa) + 1 )
					Else
							nDiasProp := Day( dDemissa )
					Endif
				Endif
			Endif
				//Verifica se a verba esta contida no mnemonico que armazena as verbas de Falta
			If (cQrySRD)->RD_PD $ P_DESCFALT
				If  (cQrySRD)->RD_TIPO1 $ "VD"
						nTotDias :=  (cQrySRD)->RD_HORAS
						nQtdDias := 30 - nTotDias
				Else
						nDias:= (cQrySRA)->RA_HRSMES / 30
						nTotDias := ((cQrySRD)->RD_HORAS / nDias )
						nQtdDias := 30 - nTotDias
				Endif
				If nDiasProp > 0
						nQtdDias := nDiasProp - nTotDias
				Endif
			Endif
				(cQrySRD)->(dbSkip())
		End
	Next nAux
		(cQrySRD)->(dbCloseArea())

	If lReg
			nFunc+=1
			nCol21Tot +=  nVCol21

			cTipoCI := If( Empty((cQrySRA)->RA_TIPODOC) .Or. (cQrySRA)->RA_TIPODOC=="1", "CI", "CE" )
			cNumNua := (cQrySRA)->RA_NRNUA

			oSection1:Init(.F.)
			oReport:IncMeter()

		If oReport:Cancel()
				Exit
		EndIf

			//Funcionarios admitidos e demitidos no Mes/Ano de referencia
		If ( Month(dDemissa)== Val(cMes) .And.  Year(dDemissa) == Val(cAno) ) .And. ( Month(dAdmissa) == Val(cMes) .And. Year(dAdmissa) == Val(cAno) )
				cNOVEDAD:= "R"
				cFechNovedad:= DtoC(dDemissa)
				nQtdDias := nDiasProp
				//Funcionarios admitidos no Mes/Ano de referencia
		ElseIf Month(dAdmissa) == Val(cMes) .And. Year(dAdmissa) == Val(cAno)
				cNOVEDAD := "I"
				cFechNovedad:= DtoC(dAdmissa)
				nQtdDias := nDiasProp
				//Funcionarios demitidos no Mes/Ano de referencia
		Elseif Month(dDemissa)== Val(cMes) .And.  Year(dDemissa) == Val(cAno)
				cNOVEDAD:= "R"
				cFechNovedad:= DtoC(dDemissa)
				nQtdDias := nDiasProp
		Else
				fBuscaAutrz(cFil, cMat , CtoD("01/"+cMes+"/"+cAno), LastDate(CtoD("01/"+cMes+"/"+cAno)))
		Endif

			/*cApelPat := SubStr((cQrySRA)->RA_PRISOBR,1,10)
			cApelMat := SubStr((cQrySRA)->RA_SECSOBR,1,10)
			cApelCas := SubStr((cQrySRA)->RA_APELIDO,1,10)
			cPriNom	 := SubStr((cQrySRA)->RA_PRINOME,1,10)
			cSegNom	 := SubStr((cQrySRA)->RA_SECNOME,1,10)*/

			cApelPat := ALLTRIM((cQrySRA)->RA_PRISOBR)
			cApelMat := ALLTRIM((cQrySRA)->RA_SECSOBR)
			cApelCas := ALLTRIM((cQrySRA)->RA_APELIDO)
			cPriNom	 := ALLTRIM((cQrySRA)->RA_PRINOME)
			cSegNom	 := ALLTRIM((cQrySRA)->RA_SECNOME)

			oSection1:Cell("RA_TIPODOC"):SetValue(cTipoCI)  //"TIPO"
			oSection1:Cell("RA_RG"):SetValue((cQrySRA)->RA_RG)    	//"NUMERO"

			oSection1:Cell("RA_NRNUA"):SetValue(cNumNua)  	//"NUA/CUA"
			oSection1:Cell("RA_PRISOBR"):SetValue(cApelPat)  //"APELLIDO PATERNO"
			oSection1:Cell("RA_SECSOBR"):SetValue(cApelMat)  //"APELLIDO MATERNO"
			oSection1:Cell("RA_APELIDO"):SetValue(cApelCas)  //"APELLIDO DE CASADA"
			oSection1:Cell("RA_PRINOME"):SetValue(cPriNom)  //"PRIMEIRO NOME"
			oSection1:Cell("RA_SECNOME"):SetValue(cSegNom)  //"SEGUNDO NOME"
			oSection1:Cell("NOVEDAD"):SetValue(cNOVEDAD)  			//"NOVEDAD"
			oSection1:Cell("FECHNOVEDAD"):SetValue(cFechNovedad)//"FECH-NOVEDAD"
			oSection1:Cell("DIAS-COT"):SetValue(Transform(nQtdDias,"99"))  //"DIAS-COT"

		if(nTipo == 2)//Futuro
				oSection1:Cell("RA_NATURAL"):SetValue((cQrySRA)->RA_NATURAL)  //"EXT"
				oSection1:Cell("RA_ESTADO"):SetValue(TRIM(fDesc("SX5","12"+(cQrySRA)->RA_ESTADO,"X5_DESCRI")))
				oSection1:Cell("nFunc"):SetValue(cValToChar(nFunc))
				oSection1:Cell("nVCol21"):SetValue(nVCol21)	//Total Ganado (21) RD_VALOR
				oSection1:Cell("nVCol22"):SetValue(nVCol21 - NVAL13)
				oSection1:Cell("nVCol23"):SetValue(0)
				oSection1:Cell("nVCol24"):SetValue(0)
			if((nVCol21 - NVAL25) > 0)
					oSection1:Cell("nVCol23"):SetValue(nVCol21 - NVAL25)
			endIf
			if((nVCol21 - NVAL35) > 0)
					oSection1:Cell("nVCol24"):SetValue(nVCol21 - NVAL35)
			endIf
		else//Prevision
				oSection1:Cell("RA_ALFANUM"):SetValue((cQrySRA)->RA_ALFANUM)
				oSection1:Cell("nVCol21"):SetValue(nVCol21)  //Total Ganado (21) RD_VALOR
			IF((cQrySRA)->RA_AFPOPC == TIPOCOT1)
					cTipoCot:= "1"
			elseIf((cQrySRA)->RA_AFPOPC == TIPOCOT2)
					cTipoCot:= "2"
			elseIf((cQrySRA)->RA_AFPOPC == TIPOCOTC)
					cTipoCot:= "C"
			elseIf((cQrySRA)->RA_AFPOPC == TIPOCOTD)
					cTipoCot:= "D"
			endIf
				oSection1:Cell("TIPOCOT"):SetValue(cTipoCot)  //"TP Cotizante"
				oSection1:Cell("RA_TPSEGUR"):SetValue((cQrySRA)->RA_TPSEGUR)  //"TP Segurado"
		endIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime a linha                                        		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSection1:PrintLine()
			oSection1:Finish()

			lReg:= .F.
	Endif
		cNOVEDAD:= ""
		cFechNovedad:= ""
		(cQrySRA)->(dbSkip())
End
If !lQuery
		dbSelectArea("SRA")
		dbSetOrder(nSavOrdem)
		dbGoTo(nSavRec)
Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna o alias padrao                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	If Select(cQrySRA) > 0
			(cQrySRA)->(dbCloseArea())
	Endif
EndIf

Return

Static Function fBuscaAutrz(cFil, cMat ,  dDtaini, dDtafim)

	Local cAliasAnt  := Alias()
	Local cQuery8	:= ""
	Local cAliasSr8	 := "SR8"
	Local cDtaIni	:= dtos(dDtaini)
	Local cDtaFim	:= dtos(dDtafim)

	Static cFilRCM

	DEFAULT cFilRCM	 := FwxFilial("RCM")

	cAliasSr8 	:= "QrySR8"
	cQuery8 	:= "SELECT * "
	cQuery8 	+= "FROM "+RetSqlName("SR8")+" SR8 "
	cQuery8 	+= "WHERE SR8.R8_FILIAL='"+cMat+"' AND "
	cQuery8 	+= "SR8.R8_MAT='"+cMat+"' AND "
	cQuery8 	+= "SR8.R8_DATAINI >='" + cDtaIni + "' AND SR8.R8_DATAFIM <='" + cDtaFim + "' "
	cQuery8 	+= "AND SR8.D_E_L_E_T_ = ' ' "
	cQuery8 	+= "ORDER BY "+SqlOrder(SR8->(IndexKey()))

	If Select(cAliasSr8) > 0
		(cAliasSr8)->( dbCloseArea() )
	Endif

	cQuery8 		:= ChangeQuery(cQuery8)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery8),cAliasSr8)

	dbSelectArea(cAliasSr8)
	(cAliasSr8)->(dbgotop())

	dbSelectArea( "SR8" )
	dbSeek( cFil + cMat)

	While (!Eof() .And. (cAliasSr8)->( R8_FILIAL + R8_MAT ) == (cFil + cMat))

		DbSelectArea( "RCM" )
		DbSetOrder( RetOrder( "RCM", "RCM_FILIAL+RCM_TIPO" ) )
		DbSeek( cFilRCM + (cAliasSr8)->R8_TIPOAFA, .F. )

		If RCM->RCM_TPIMSS $ "C/A/P"
			/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			| La clave para hacer la busca en las ausencias es el campo R8_DTBLEG, el importante es la  |
			| fecha en el mes selecionado. Ej: caso tenga una ausencia con fecha inicio y fecha fin     |
			| dentro del mes 02, pero la fecha de autori. es en mes 03, esa ausencia debera salir en el |
			| 03.																						  ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			If (cAliasSr8)->R8_DTBLEG >= Dtos(dDtaini) .And. (cAliasSr8)->R8_DTBLEG <= Dtos(dDtaFim)
				// Qdo la Ausencia esta com fecha anterior al mes buscado informa el primero dia del mes
				If (cAliasSr8)->R8_DATAINI < DtoS(dDtaini)
					cFechNovedad:= DtoC(dDtaini)
					nQtdDias    := 30
					cNOVEDAD		:="S"
				Else
					cFechNovedad:= DtoC(dDtaini)
					nQtdDias    := 30 - (day(dDtaini))
					cNOVEDAD		:="S"
				Endif
			Endif
		Else//verifica se posui Ausencia No Remunerada durante todo el periodo pesquisado
			If RCM->RCM_TPIMSS == "L"
				If (cAliasSr8)->R8_DATAFIM >= DtoS(dDtafim) .And. (cAliasSr8)->R8_DATAINI <= DtoS(dDtaini)
					cNOVEDAD		:="L"
					cFechNovedad:= DtoC(dDtaini)
					nQtdDias	:= (cAliasSr8)->R8_DURACAO
				EndIf
			EndIf
		Endif

		dbSelectArea(cAliasSr8)
		dbSkip()

	Enddo

	If Select(cAliasSr8) > 0
		(cAliasSr8)->( dbCloseArea() )
	Endif

	If !EMPTY(cAliasAnt)
		dbSelectArea(cAliasAnt)
	EndIf

Return()

