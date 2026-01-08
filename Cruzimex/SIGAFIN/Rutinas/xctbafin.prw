#INCLUDE "FileIO.CH"
#INCLUDE "FINA370.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "FWMVCDEF.CH"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posicao do array para controle do processamento MultThread³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE ARQUIVO			1
#DEFINE MARCA			2
#DEFINE QTD_REGISTROS	3
#DEFINE VAR_STATUS		4
#DEFINE NRECNO			1
#DEFINE NMODEL			2
#DEFINE NALIAS			3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Flag de processamento escrito no arquivo de controle ³
//³de threads                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE MSG_OK			"OK"
#DEFINE MSG_ERRO		"ERRO"

// Flags de processamento das variáveis globais --------------------------------
#DEFINE stThrError		'-1' // STATUS - Excecao: Erro de execução
#DEFINE stThrReady		 '0' // STATUS - Etapa: Variavel pronta para execução
#DEFINE stThrStart		 '1' // STATUS - Etapa: Iniciando execucao da Thread
#DEFINE stThrConnect	 '2' // STATUS - Etapa: Conexão/Ambiente estabelecidos
#DEFINE stThrTbltmp		 '3' // STATUS - Etapa: Retorno da criação da tabela temporária
#DEFINE stThrFinish		 '4' // STATUS - Etapa: Encerramento da Thread
// -----------------------------------------------------------------------------

Static __lDefTop	:= IIF( FindFunction("IfDefTopCTB"), IfDefTopCTB(), .F.)
Static __lConoutR	:= FindFunction("CONOUTR")
Static __aFinAlias	:= {}
Static __lSchedule  := FWGetRunSchedule()
Static _oCTBAFIN	:= NIL
Static _cSGBD		:= Alltrim(Upper(TCGetDB()))
Static _MSSQL7		:= _cSGBD $ "MSSQL7"
Static _cOperador	:= If(_MSSQL7,"+","||")
Static _cSpaceMark	:= ''
Static _lMvPar18    := .F.
Static _lCtbIniLan	:= FindFunction("CtbIniLan")
Static _lBlind	    := IsBlind()

Static l370E5R		:= Existblock("F370E5R" )
Static l370E5P		:= Existblock("F370E5P" )
Static l370E5T		:= Existblock("F370E5T" )
Static l370E1FIL	:= Existblock("F370E1F" )   // Criado Ponto de Entrada
Static l370E1LGC	:= Existblock("F370E1L" )   // Criado Ponto de Entrada
Static l370E2FIL	:= Existblock("F370E2F" )   // Criado Ponto de Entrada
Static l370E5FIL	:= Existblock("F370E5F" )   // Criado Ponto de Entrada
Static l370EFFIL	:= Existblock("F370EFF" )   // Criado Ponto de Entrada
Static l370EFKEY	:= Existblock("F370EFK" )   // Criado Ponto de Entrada
Static l370EUFIL	:= Existblock("F370EUF" )   // Criado Ponto de Entrada
Static lF370NATP	:= Existblock("F370NATP")   // Criado Ponto de Entrada
Static lF370E1WH	:= Existblock("F370E1W" )   // Criado Ponto de Entrada para o While do SE1
Static l370E5KEY	:= Existblock("F370E5K" )   // Criado Ponto de Entrada
Static l370BORD 	:= Existblock("F370BORD")   // Criado Ponto de Entrada
Static l370CTBUSR 	:= Existblock("F370CTBUSR")
Static lCtbPFO7		:= Existblock("CtbPFO7")
Static l370E5CON	:= Existblock("F370E5CT")	 // Ponto de entrada para filtro do SE5 na contabilização
Static __CtbFPos 	:= Existblock("CtbFPos ")    // Ponto de Entrada, acionado ap? a contabiliza?o da filial

Static cCarteira
Static cCtBaixa
Static lUsaFlag
Static lPCCBaixa
Static lPosE1MsFil
Static lPosE2MsFil
Static lPosE5MsFil
Static lPosEfMsFil
Static lPosEuMsFil
Static lSeqCorr
Static lUsaFilOri

// Init Class Implementation -----------------------------------------------------------------------
CLASS oFINTPTBL FROM LongClassName
	DATA aIndexes
	DATA aFields
	DATA cChave
	DATA cClassName
	DATA cRealName
	DATA cAlias
	DATA oFWTMPTBL

	METHOD AddIndex(cOrd,aKey)
	METHOD Create()
	METHOD Delete()
	METHOD GetAlias()
	METHOD GetRealName()
	METHOD New(cTabName,aFields) CONSTRUCTOR
	METHOD SetFields(aFields)
ENDCLASS

METHOD New(cAlias,aFields) CLASS oFINTPTBL
	::aFields		:= aFields
	::aIndexes		:= {}
	::cAlias		:= cAlias
	::cClassName	:= 'oFINTPTBL'
	::cRealName		:= ''
RETURN NIL

METHOD AddIndex(cOrd,aKey) CLASS oFINTPTBL
	AADD(::aIndexes, {cOrd, aKey})
RETURN NIL

METHOD Create() CLASS oFINTPTBL
	LOCAL nI	as Numeric

	If !_MSSQL7
		MsErase(::cAlias)	//Deleta a tabela temporaria no banco de dados, caso ja exista
		MsCreate(::cAlias,::aFields,'TOPCONN')
		Sleep(1000)
		dbUseArea(.T.,'TOPCONN',::cAlias,::cAlias,.T.,.F.)
		//Cria o Indice
		For nI := 1 To LEN(::aIndexes)
			IndRegua(::cAlias,::cAlias,::aIndexes[nI,2],,)			
		Next nI
	Else
		::Delete()			//Deleta a tabela temporaria no banco de dados, caso ja exista
		::oFWTMPTBL := FWTemporaryTable():New(::cAlias,::aFields)
		For nI := 1 To LEN(::aIndexes)
			::oFWTMPTBL:AddIndex(::aIndexes[nI,1], StrToKarr(::aIndexes[nI,2],"+"))
		Next nI
		::oFWTMPTBL:Create()
		::cRealName := ::oFWTMPTBL:GetRealName()
	EndIf

	//CONOUT('***** TEMPORARIA (RETORNO DE CRIACAO): ['+::GetRealName()+']: - Thread No ['+ALLTRIM(Str(ThreadID()))+'] *****')
RETURN NIL

METHOD Delete() CLASS oFINTPTBL
	If !EMPTY(::oFWTMPTBL)
		//CONOUT('***** TEMPORARIA (SOLICITACAO DE DELECAO): ['+::GetRealName()+']: - Thread No ['+ALLTRIM(Str(ThreadID()))+':'+TIME()+'] *****')
		::oFWTMPTBL:Delete()
		::oFWTMPTBL := NIL
		//CONOUT('***** TEMPORARIA (RETORNO SOLICIT DELECAO): ['+::GetRealName()+']: - Thread No ['+ALLTRIM(Str(ThreadID()))+':'+TIME()+'] *****')
	Else
		MsErase(::cAlias)
	EndIf
RETURN NIL

METHOD GetAlias() CLASS oFINTPTBL
RETURN ::cAlias

METHOD GetRealName() CLASS oFINTPTBL
	LOCAL cRet as Character
	cRet := If(!EMPTY(::cRealName),::cRealName,::cAlias)
RETURN cRet

METHOD SetFields(aFields) CLASS oFINTPTBL
	::aFields := ACLONE(aFields)
RETURN NIL
// End Class Implementation ------------------------------------------------------------------------


/*

Nahim Fuente modificado para uso en Bolivia con la 12.1.17.

*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CTBAFIN	³ Autor ³ Mauricio Pequim Jr	³ Data ³ 06/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de Lan‡amentos Cont beis Off-Line - TOP			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBFIN() 												  ³±±     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAFIN													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function xCTBAFIN(lDireto)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lPanelFin	  := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local nOpca		  := 0
Local aSays		  :={}
Local aButtons	  :={}
Local nNumProc	  := GetMv("MV_CFINTHR", .F., 1 )
Local cFilProcIni := cFilAnt
Local cFilProcFim := cFilAnt
Local nX		  := 0
Local lUsaLog	:= SuperGetMv("MV_FINLOG",.T.,.F.)
Local cPathLog := GetMv("MV_DIRDOC")
Local cLogArq 	:= "Fina370Log.TXT"
Local cCaminho := cPathLog + cLogArq
Local lProcCtb := SuperGetMv( "MV_CTBUPRC" , .T. , .F. ) .and. (_cSGBD $ "MSSQL7|ORACLE" ) 
Local cDescription	:= STR0010 + " " + STR0011 
Local bProcess		:= {|oSelf|nOpca:=1} //{|oSelf|F370Process(oSelf)}
Local aKeyProc		:= NIL

Private cCadastro := STR0009  //"Contabiliza‡„o Off Line"
Private LanceiCtb := .F.

SetVarNameLen(50)  //determina tamanho do nome das variaveis globais para status do progresso das threads

nNumProc := If((nNumProc > 30),30,nNumProc)

Default lDireto	  := .F.

_cSpaceMark	:= "'"+SPACE(LEN(GetMark()))+"'"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01 - Mostra Lan‡amentos Contabeis ?  1- Sim, 2- Não   ³
//³ mv_par02 - Aglutina Lan‡amentos Contabeis? 1- Sim, 2- Não   ³
//³ mv_par03 - Contabiliza Emissoes? 1-Emissao / 2-Data Base    ³
//³ mv_par04 - Data Inicio                                      ³
//³ mv_par05 - Data Fim										        ³
//³ mv_par06 - Carteira ? 1-Receber/2-Pagar/3-Cheques/4-Todas   ³
//³ mv_par07 - Contab. Baixas ? 1-Dt Baixa/2-Dt Digit/3-DtDispo ³
//³ mv_par08 - Considera filiais abaixo? 1- Sim / 2 - Nao       ³
//³ mv_par09 - Da Filial                                        ³
//³ mv_par10 - Ate a Filial                                     ³
//³ mv_par11 - Atualiza Sinteticas                              ³
//³ mv_par12 - Separa por ? (Periodo,Documento,Processo)        ³
//³ mv_par13 - Ctb Bordero - Total/Por Bordero                  ³
//³ mv_par14 - Considera Filial Original?  1- Sim, 2 - Não      ³
//³ mv_par15 - Filial de                                        ³
//³ mv_par16 - Filial Até                                       ³
//³ mv_par17 - Contab. Tit. Provisorio? 1-Sim/2-Nao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Obs: este array aRotina foi inserido apenas para permitir o
// funcionamento das rotinas internas do advanced.
Private aRotina:={ 	{ STR0012,"AxPesqui" , 0 , 1},;  //"Localizar"
					{ STR0013,"fA100Pag" , 0 , 3},;  //"Pagar"
					{ STR0014,"fA100Rec" , 0 , 3},;  //"Receber"
					{ STR0015,"fA100Can" , 0 , 5},;  //"Excluir"
					{ STR0016,"fA100Tran", 0 , 3},;  //"Transferir"
					{ STR0017,"fA100Clas", 0 , 5} }  //"Classificar"

Private lCabecalho
Private VALOR     	:= 0
Private VALOR6		:= 0
Private VALOR7		:= 0
Private nTpLog := SuperGetMv("MV_TIPOLOG",.T.,1)
Private FO1VADI := 0 

fErase(cCaminho)
/*   Se o parametro MV_CTBUPRC e for .T. NÃO  executar com multi threads */
nNumProc := If( lProcCtb, 1, nNumProc)
// Inicializa as variaveis staticas da contabilização
If FindFunction("CLEARCX105")
	ClearCx105()
Endif

// Inicia as variaveis staticas do fonte.
FinIniVar()

// Variaveis utilizadas na contabilizacao do modulo SigaFin
// declarada neste ponto, caso o acesso seja feito via SigaAdv

Debito  	:= ""
Credito 	:= ""
CustoD		:= ""
CustoC		:= ""
ItemD 		:= ""
ItemC 		:= ""
CLVLD		:= ""
CLVLC		:= ""

Conta		:= ""
Custo 		:= ""
Historico 	:= ""
ITEM		:= ""
CLVL		:= ""

Abatimento  := 0
REGVALOR    := 0
STRLCTPAD 	:= ""		//para contabilizar o historico do cheque
NUMCHEQUE 	:= ""		//para contabilizar o numero do cheque
ORIGCHEQ  	:= ""		//para contabilizar o Origem do cheque
cHist190La 	:= ""
Variacao	:= 0
dDataUser	:= MsDate()
CODFORCP  	:= ""	//para contabilizar o Codigo do Fornecedor da Compensacao
LOJFORCP 	:= ""	//para contabilizar a Loja do Fornecedor da Compensacao

If __lSchedule .or. lDireto
	BatchProcess(cCadastro, 	STR0010 + Chr(13) + Chr(10) +;
	STR0011, "FIN370",;
	{ || CTBFINProc(.T.) }, { || .F. })
	Return .T.
Endif

If !__lSchedule
	Pergunte("FIN370",.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o log de processamento                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogIni( aButtons )

AADD(aSays,STR0010) //"  Este programa tem como objetivo gerar Lan‡amentos Cont beis Off para t¡tulos"
AADD(aSays,STR0011) //"emitidos e/ou baixas efetuadas."
If lPanelFin  //Chamado pelo Painel Financeiro			
	aButtonTxt := {}			
	If Len(aButtons) > 0
		AADD(aButtonTxt,{STR0036,STR0036,aButtons[1][3]}) // Visualizar			
	Endif
	AADD(aButtonTxt,{STR0037,STR0037, {||Pergunte("FIN370",.T. )}}) // Parametros						
	FaMyFormBatch(aSays,aButtonTxt,{||nOpca :=1},{||nOpca:=0})	
Else                  			
	tNewProcess():New( "CTBAFIN", cCadastro, bProcess, cDescription, "FIN370" )
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÊ
//³Validação para multthread.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÊ
nNumProc := IIF(__lSchedule .OR. nNumProc < 1 , 1, nNumProc)

If nNumProc > 1 .And. nOpcA == 1
	If CtbValMult(.T.,MV_PAR02 == 1,MV_PAR01 == 1,MV_PAR12 )
		nOpcA := 1
	Else
		nOpcA := 0
	EndIf
EndIf

If nOpcA == 1

	If !CtbValiDt(,dDataBASE,,,,{"FIN001","FIN002"},)
		Return
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("INICIO")
	
	lMulti := nNumProc > 1 .And. CtbValMult(.F.,MV_PAR02 == 1,MV_PAR01 == 1,MV_PAR12 )
	
	
	If mv_par08 == 1      //Considera filiais abaixo? 1- Sim / 2 - Nao 
		cFilProcIni	:= mv_par09
		cFilProcFim := mv_par10		
		
		If mv_par14 == 1  //Considera Filial Original?  1- Sim, 2 - Não
			cFilProcIni	:= mv_par15
			cFilProcFim := mv_par16
		EndIf

		If A370CanProc(mv_par06, mv_par04, mv_par05,cFilProcIni,cFilProcFim)
			aKeyProc := {{'CCART',STR(mv_par06,1)},{'DTDE',DTOS(mv_par04)},{'DTATE',DTOS(mv_par05)},{'FILDE',cFilProcIni},{'FILATE',cFilProcFim}}
			If lMulti
				MsgRun( STR0038,, {|| CTBMTFIN(mv_par06,nNumProc) } ) //"Contabilizando..."
			Else
				If _lCtbIniLan
					CtbIniLan()
				EndIf
				Processa({|lEnd| CTBFINProc()})  // Chamada da funcao de Contabilizacao Off-Line
				If FindFunction("CtbFinLan")
					CtbFinLan()
				EndIf
			EndIf
		EndIf
	Else
		If A370CanProc(mv_par06, mv_par04, mv_par05)
			aKeyProc := {{'CCART',STR(mv_par06,1)},{'DTDE',DTOS(mv_par04)},{'DTATE',DTOS(mv_par05)}}
			If lMulti
				MsgRun( STR0038,, {|| CTBMTFIN(mv_par06,nNumProc) } ) //"Contabilizando..."
			Else
				If _lCtbIniLan
					CtbInilan()
				EndIf
				Processa({|lEnd| CTBFINProc()})  // Chamada da funcao de Contabilizacao Off-Line
				If FindFunction("CtbFinLan")
					CtbFinLan()
				EndIf
			EndIf
		EndIf
	EndIf
	
	//Libera o Processamento e envia mensagem no server (tempo)
	If !EMPTY(aKeyProc)
		A370FreeProc(aKeyProc)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("FIM")

Endif

// Verifico se os alias foram encerrados, se não forço o
For nX := 1 TO Len( __aFinAlias )
	If !Empty(__aFinAlias[nX]) .And. Select(__aFinAlias[nX]) > 0
		DbSelectArea(__aFinAlias[nX])	
		DbCloseArea()
		MsErase(__aFinAlias[nX])
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O codigo abaixo eh utilizado nesse ponto para garantir que tanto o alias³
//³quanto o browse serao recriados sem problemas na utilizacao do painel   ³
//|financeiro quando a rotina nao eh chamada de forma semi-automatica pois | 
//|esse tratamento eh realizado na rotina T											|
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lPanelFin //Chamado pelo Painel Financeiro			
	dbSelectArea(FinWindow:cAliasFile)			
	ReCreateBrow(FinWindow:cAliasFile,FinWindow)      	
Endif
	
If lUsaLog
	aIncons := FA370TXT(cCaminho)
	If Len(aIncons) > 0
		If nTpLog == 1
			Aviso(STR0031,STR0052+cCaminho+"'.",{'OK'},2) //"Foram gravados registros de inconsistências na tabela SE5 nesta contabilização. Favor verificar os registros no arquivo 'Fina370Log.TXT', existente na pasta '"
		ElseIf nTpLog == 2	
			FA370Rel(aIncons) //Relatório de inconsistências.
		EndIf
	EndIF
EndIf

//--------------------------------------------
// Ponto de Entrada ao final do processamento
//   para processos complementares do usuario
//--------------------------------------------
If l370CTBUSR
	Execblock("F370CTBUSR",.F.,.F.)
EndIf		

// Inicializa as variaveis staticas da contabilização
If FindFunction("CLEARCX105")
	ClearCx105()
Endif

Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³CTBFINProc³ Autor ³ Wagner Xavier 	    ³ Data ³ 24/08/94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de Lan‡amentos Cont beis Off-Line				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FINA370()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAFIN													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function CTBFINProc(lBat,lLerSE1,cAliasSE1,lLerSE2,cAliasSE2,lLerSEF,cAliasSEF,lLerSE5,cAliasSE5,lMultiThr,lLerSEU,cAliasSEU)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lPadrao,lAglut
Local nTotal		:= 0
Local nHdlPrv		:= 0
Local cArquivo		:= ""
Local cPadrao
Local nValLiq		:= 0
Local nDescont		:= 0
Local nJuros		:= 0
Local nMulta		:= 0
Local nCorrec		:= 0
Local nVl
Local nDc
Local nJr
Local nMt
Local lTitulo		:= .F.
Local dDataAnt		:= dDataIni := dDataBase
Local nPeriodo		:= 0
Local nLaco   		:= 0
Local cChave		:= ""
Local nRegSE5		:= 0
Local nRegOrigSE5	:= 0
Local lX			:= .f.
Local lAdiant 		:= .F.
Local nProxReg 		:= 0
Local lEstorno 		:= .F.
Local lEstRaNcc 	:= .F.
Local lEstPaNdf 	:= .F.
Local lEstCart2 	:= .F.
Local nValorTotal 	:= 0
Local cCondWhile	:= " "
Local nRegAnt
Local bCampo
Local nOrderSEU
Local cChaveSev
Local cChaveSeZ
Local nRecSe1
Local nRecSe2
Local cNumBor		:= ""
Local cProxBor		:= ""
Local nBordero		:= 0
Local nTotBord		:= 0
Local nBordDc		:= 0
Local nBordJr  		:= 0
Local nBordMt		:= 0
Local nBordCm  		:= 0
Local nTotDoc		:= 0
Local nTotProc 		:= 0
Local lPadraoCC
Local lSkipLct 		:= .F.
Local cSitOri  		:= " "
Local cSitCob 		:= " "
Local cSeqSE5 		:= ""
Local lPadraoCCE
Local cPadraoCC
Local lMultNat 		:= .F.
Local nRecSev
Local nRecSez
Local aFlagCTB 		:= {}
Local nPis			:= 0
Local nCofins  		:= 0
Local nCsll	   		:= 0
Local nVretPis 		:= 0
Local nVretCof 		:= 0
Local nVretCsl 		:= 0
Local aRecsSE5 		:= {}
Local nX 			:= 0
Local nI			:= 0
Local nTamDoc		:= TamSX3("E5_PREFIXO")[1]+TamSX3("E5_NUMERO")[1]+TamSX3("E5_PARCELA")[1]+TamSX3("E5_TIPO")[1]
Local nTamBor		:= TamSX3("EA_NUMBOR")[1]
Local lCtbPls 		:= .F.
Local lMulNatSE2	:= .F.
Local cProxChq		:= ""
Local cChequeAtual	:= ""
Local aStru			:= SE5->(DbStruct())
Local cSepProv		:= If("|"$MVPROVIS,"|",",") 
Local lEstCompens	:= .F.
Local cSELSerie		:= ""
Local cSELRecibo	:= ""
Local lFindITF		:= FindFunction("FinProcITF")
Local lQrySE1		:= .F.
Local aRecsSEI	:= {}
Local nJ := 0
Local dDataSEF	:= dDataBase
Local cMVSLDBXCR 	:= SuperGetMv("MV_SLDBXCR",.F.,.F.)	//Indica como sera controlado o saldo da baixa do contas a receber, somente quando o cheque for compensado, ou no momento da baixa (B,C)
Local lCtMovPa		:= SuperGetMv("MV_CTMOVPA",.T.,"1") == "2" // Indica se a Contabiliza‡?o Offline do LP513 ocorrer  pelo T¡tulo(SE2) ou Mov.Bancario(SE5) do Pagamento Antecipado. 1="SE2" / 2="SE5"
Local nRecMovPa		:= 0
Local lPAMov		:= .F.

//Variaveis para gravação do código de correlativo
Local aDiario		:= {}

Local nz			:= 0
Local lArqSEF		:= .F.
Local aLstSEF		:= {}  
Local cEF_T01		:= ""
Local bCond			:= Nil

// Quando processamento por MultiThread a função CTBMTFIN() é que controla as filiais e os registros
// Portanto, aqui assumimos o ambiente estabelecido pela Thread em execução
Local aSM0			:= IF(lMultiThr,{nil},AdmAbreSM0())	

Local nContFil		:= 0
Local __cFilAnt		:= cFilAnt
Local nPosReg		:= 0
Local dDataCtb		:= Nil // variavel de controle da contabilização.
Local aAreaATU		:= {}
Local aRecsTRF		:= {}
Local aFils			:= {}
Local lPass			:= .F.
Local lAGP			:= .F.
Local lMvAGP		:= SuperGetMv("MV_CTBAGP",.F.,.F.)
Local lF370ChkAgp	:= FindFunction("F370ChkAgp")
Local cNatTroc		:= Alltrim(IIf( cPaisLoc <> "BRA", SuperGetMV("MV_NATTROC"), GetNewPar("MV_NATTROC",'"TROCO"') ))
LOCAL lGroupDoc		:= SUPERGETMV("MV_GPDOCTB",.F.,.F.)
Local lQuebraDoc	:= .T.
Local lBxCnab 		:= SuperGetMv("MV_BXCNAB",.T.,"N") == "S"
Local lAvancaReg	:= .T.
Local aCT5			:= {}
Local cUniao		:= GetMv( "MV_UNIAO" )
Local cMunic		:= GetMv( "MV_MUNIC" )
Local cOrdLCTB		:= Alltrim(GETMV("MV_ORDLCTB"))
//1 - Contabiliza por titulo ; 2 - contabiliza por venda (somente quando possuir integração)
Local nCtbVenda		:= SuperGetMV("MV_CTBINTE",,1)
Local lRACont		:= .F.
Local lRAMov		:= .F.
Local aAreaAux		:= NIL
Local cLA			:= ""
Local cChE5Comp		:= ""

Local aAreaSE1		:= NIL
Local aAreaSE2		:= NIL
Local aAreaSEA		:= NIL
Local nVlDecresc	:= 0
Local nVlAcresc		:= 0
Local aCmpCRSE1		:= {}

// Variaveis para contabilização dos juros informados na liquidação (FO1 e FO2)
Local cNumLiq       := ""
Local nRecFO2       := 0
Local aDadosFO1     := {}
Local lHasFilOrig	:= .F.
Local cMvSimb1		:= SuperGetMV("MV_SIMB1",,"R$")						// Simbolo da moeda
Local cTipoMov		:= "DIRETO"
Local lLoop			:= .F.
Local cRecPag		:= ""
Local nSkip			:= 0

Private cCampo
Private Inclui		:= .T.
Private cLote		:= Space(4)
Private nSaveSx8Len := GetSx8Len()
Private cSeqCv4		:= ""

// Registro de LOG de inconsistências
PRIVATE nTpLog		:= IF(lMultiThr,1,SuperGetMv("MV_TIPOLOG",.T.,1))
PRIVATE cPathLog	:= GetMv("MV_DIRDOC")
PRIVATE aIncons		:= {}

DEFAULT lBat    	:= .F.
DEFAULT lLerSE5 	:= .T.
DEFAULT lLerSE1 	:= .T.
DEFAULT lLerSE2 	:= .T.
DEFAULT lLerSEF 	:= .T.
DEFAULT lLerSEU  	:= .T.
DEFAULT cAliasSE5	:= "SE5"
DEFAULT cAliasSE2 	:= "SE2"
DEFAULT cAliasSEF	:= "SEF"
DEFAULT cAliasSE1	:= "SE1"
DEFAULT cAliasSEU	:= "TRBSEU"
DEFAULT lMultiThr	:= .F.

IF SUBSTR(cPathLog,LEN(cPathLog),1) <> '\'
	cPathLog := cPathLog + '\'
	PUTMV('MV_DIRDOC',cPathLog)
ENDIF

// Processa SEF se existir ao menos um LP configurado.
If lLerSEF
    lLerSEF := VldVerPad({'559','566','567','590'}) 
EndIf

// Inicia as variaveis staticas do fonte.
FinIniVar()

If !__lSchedule
	Pergunte("FIN370",.F.)
EndIf

cSeqCv4 := GetSx8Num("CV4", "CV4_SEQUEN")

If ! CtbInUse() .And.;
	(!(mv_par04 >= GetMv("MV_DATADE") .And. mv_par04 <= GetMv("MV_DATAATE")) .Or.;
	!(mv_par05 >= GetMv("MV_DATADE") .And. mv_par05 <= GetMv("MV_DATAATE")))
	HELP(" ",1,"DATACOMPET")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento com o erro  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("ERRO","DATACOMPET",Ap5GetHelp("DATACOMPET"))
	
	Return .F.
Endif

IF Len( aSM0 ) <= 0
	Help(" ",1,"NOFILIAL")
	Return .F.
Endif

//USO APENAS PARA TOP
If __lDefTop
	If TcSrvType() == "AS/400"
		HELP(" ",1,"USEFINA370")			
		Return .F.
	Endif	
Else
	HELP(" ",1,"USEFINA370")			
	Return .F.
Endif

cFilDe  := cFilAnt
cFilAte := cFilAnt

If mv_par08 == 1
	cFilDe := mv_par09
	cFilAte:= mv_par10
Endif

If FindFunction("F370Fil")
	aFils := F370Fil(mv_par09,mv_par10) // Retorna filiais que o usuario tem acesso
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						 ³
//³ mv_par01 // Mostra Lan‡amentos Cont beis 					 ³
//³ mv_par02 // Aglutina Lan‡amentos Cont beis					 ³
//³ mv_par03 // Emissao / Data Base 							 ³
//³ mv_par04 // Data Inicio										 ³
//³ mv_par05 // Data Fim										 ³
//³ mv_par06 // Carteira : Receber / Pagar /Cheque / Ambas 		 ³
//³ mv_par07 // Baixas por Data de Emiss„o ou Digita‡„o			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nContFil := 1 to Len(aSM0)
	
	// ---------------------------------------------------------------------------------------------------------------------------
	// Quando processamento por MultiThread a função CTBMTFIN() é que controla as filiais e os registros.
	// Portanto, aqui assumimos o ambiente estabelecido pela Thread em execução
	// ---------------------------------------------------------------------------------------------------------------------------
	IF !lMultiThr
		If aSM0[nContFil][SM0_CODFIL] < cFilDe .Or. aSM0[nContFil][SM0_CODFIL] > cFilAte .Or. aSM0[nContFil][SM0_GRPEMP] != cEmpAnt  
			Loop
		EndIf
		If MV_PAR14 == 1
			If aSM0[nContFil][SM0_CODFIL] < MV_PAR15 .Or. aSM0[nContFil][SM0_CODFIL] > MV_PAR16
				Loop
			EndIf
		Endif
		cFilAnt := aSM0[nContFil][SM0_CODFIL]
	ENDIF
	// ---------------------------------------------------------------------------------------------------------------------------
	
	If !Empty(aFils) 
	    If Ascan(aFils,{|x| Alltrim(x) == Alltrim(cFilAnt)}) == 0 
	    	Loop
	    Endif
    Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a SumAbatRec para abrir alias auxiliar __SE1 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select("__SE1") == 0
		SumAbatRec("","","",1,"")
	Endif	
	
	If lLerSe5
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica qual a data a ser utilizada para baixa				 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCampo := IIF(mv_par07 == 1,"E5_DATA",Iif(mv_par07 == 2,"E5_DTDIGIT","E5_DTDISPO"))
		aRecsSE5 := {}
		lHasFilOrig := .F.

		If lMultiThr
			(cAliasSE5)->(dbGoTop())
		Else
			DbSelectArea("SE5")
			aStru  := SE5->(DbStruct())
			cQuery := ""
			aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})

			// Obtem os registros a serem processados
			cQuery := "SELECT " + SubStr(cQuery,2)
			cQuery += "     , SE5.R_E_C_N_O_ SE5RECNO "
			cQuery += "  FROM " + RetSqlName("SE5") + " SE5 "

			IF ((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))
				If lPosE5MsFil .AND. !lUsaFilOri
					cQuery += "WHERE E5_MSFIL = '"  + cFilAnt + "' AND "
				Else
					cQuery += "WHERE E5_FILORIG = '"  + cFilAnt + "' AND "
					lHasFilOrig := .T.
				Endif
			Else
				cQuery += "WHERE E5_FILIAL = '" + xFilial("SE5") + "' AND "
			EndIf
			
			If mv_par07 == 1			//DATA
				cQuery += "E5_DATA BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
				cQuery += "E5_TIPODOC IN ('PA','RA','BA','VL','V2','AP','EP','PE','RF','IF','CP','TL','ES','TR','DB','OD','LJ','E2','TE','  ','IT')  AND "
				If mv_par12 <> 2 .And. cOrdLCTB == "E"
					cChave := "E5_FILIAL+Dtos(E5_DATA)+E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+R_E_C_N_O_"
				Else
					cChave := "E5_FILIAL+Dtos(E5_DATA)+E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
				EndIf
			ElseIf mv_par07 == 2		//DATA DE DIGITACAO
				cQuery += "((E5_DTDIGIT    between '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
				cQuery += "E5_TIPODOC IN ('PA','RA','BA','VL','V2','AP','EP','PE','RF','IF','CP','TL','ES','DB','OD','LJ','E2','  ','IT')) OR
				cQuery += "(E5_DATA BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
				cQuery += "E5_TIPODOC IN ('TR','TE')))  AND "
				If mv_par12 <> 2 .And. cOrdLCTB == "E"
					cChave := "E5_FILIAL+Dtos(E5_DTDIGIT )+E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+R_E_C_N_O_"				
				Else
					cChave := "E5_FILIAL+Dtos(E5_DTDIGIT )+E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
				EndIf
			Else 							//DATA DE DISPONIBILIDADE
				cQuery += "((E5_DTDISPO    between '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
				cQuery += "E5_TIPODOC IN ('PA','RA','BA','VL','V2','AP','EP','PE','RF','IF','CP','TL','ES','DB','OD','LJ','E2','  ')) OR
				cQuery += "(E5_DATA BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
				cQuery += " (E5_TIPODOC IN ('TR','TE') OR (E5_TIPODOC = ' ' AND E5_TIPO = ' ')))) AND "
				If mv_par12 <> 2 .And. cOrdLCTB == "E"
					cChave := "E5_FILIAL+Dtos(E5_DTDISPO)+E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+R_E_C_N_O_"				
				Else
					cChave := "E5_FILIAL+Dtos(E5_DTDISPO)+E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
				Endif
			Endif

			If lHasFilOrig .AND. !EMPTY(cChave)
				cChave := STRTRAN(cChave,'E5_FILIAL','E5_FILORIG')
			EndIf
			
			cQuery += "E5_SITUACA <> 'C' AND "
			cQuery += "(E5_LA <> 'S ' OR ((E5_ORDREC || E5_SERREC) <> '' AND E5_RECPAG = 'R' AND E5_TIPODOC = 'BA')) AND E5_MOTBX NOT IN ('DSD') AND "  // Filtra registros de Recebimentos Diversos p/Contabilizacao
			cQuery += "D_E_L_E_T_ = ' ' "
			
			// Ponto de Entrada para filtrar registros do SE5.
			If l370E5FIL
				cQuery := Execblock("F370E5F",.F.,.F.,cQuery)
			EndIf
			
			// Ponto de Entrada para alterar ordenacao do SE5
			If l370E5KEY
				cChave := Execblock("F370E5K",.F.,.F.,cChave)
			EndIf
			
			// seta a ordem de acordo com a opcao do usuario
			If mv_par12 == 2
				cQuery += " ORDER BY " + SqlOrder( StrTran( cChave , "E5_DOCUMEN+" , "E5_DOCUMEN+R_E_C_N_O_+" ) )
			Else
				cQuery += " ORDER BY " + SqlOrder( cChave )
			EndIf

			If __lConoutR
				ConoutR( cQuery )
			Endif
			
			cQuery := ChangeQuery(cQuery)

			cAliasSE5 := FINNextAlias()
			
			If Select(cAliasSE5) > 0
				DbSelectArea( cAliasSE5 )
				DbCloseArea()
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSE5 , .F., .T.)

			For nI := 1 TO LEN(aStru)
				If aStru[nI][2] != "C"
					TCSetField(cAliasSE5, aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
				EndIf
			Next
			DbGoTop()
		EndIf
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Contabiliza pelo E2_EMIS1 - CONTAS PAGAR   			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (mv_par06 = 2 .Or. mv_par06 = 4) .and. lLerSe2

		If lMultiThr
			(cAliasSE2)->(dbGoTop())
		Else
			dbSelectArea("SE2")
			cChave := "E2_FILIAL+DTOS(E2_EMIS1)+E2_NUMBOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"

			aStru := SE2->(DbStruct())
			cQuery := ""
			aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})

			// Obtem os registros a serem processados 
			cQuery := "SELECT " + SubStr(cQuery,2)
			cQuery += "     , SE2.R_E_C_N_O_ SE2RECNO "
			cQuery += "  FROM " + RetSqlName("SE2") + " SE2 "

			IF ((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))							
				If lPosE2MsFil .AND. !lUsaFilOri
					cQuery += "WHERE E2_MSFIL = '"  + cFilAnt + "' AND "
				Else
					cQuery += "WHERE E2_FILORIG = '"  + cFilAnt + "' AND "
				Endif				
			Else
				cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND "
			EndIf

			cQuery += "E2_EMIS1 BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
			
			// Soh adiciona filtro na query se nao contabiliza titulos provisorios
			If mv_par17 <> 1
				cQuery += "E2_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " AND "
			EndIf
			
			cQuery += "E2_STATUS <> 'D' AND "	// Título base de desdobramento - Contabilizar pelas parcelas
			cQuery += "E2_LA <> 'S' AND E2_ORIGEM <> 'FINA677' AND "
			cQuery += "D_E_L_E_T_ = ' ' "
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para filtrar registros do SE2. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If l370E2FIL
				cQuery := Execblock("F370E2F",.F.,.F.,cQuery)
			EndIf
			
			// seta a ordem de acordo com a opcao do usuario
			cQuery += " ORDER BY " + SqlOrder(cChave)

			cQuery := ChangeQuery(cQuery)

			If __lConoutR
				ConoutR( cQuery )
			Endif

			cAliasSE2 := FINNextAlias()
			
			If Select(cAliasSE2) > 0
				DbSelectArea( cAliasSE2 )
				DbCloseArea()
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSE2, .F., .T.)
			For nI := 1 TO LEN(aStru)
				If aStru[nI][2] != "C"
					TCSetField(cAliasSE2, aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
				EndIf
			Next
			DbGoTop()
		EndIf
	Endif
	
	//SEF
	If (mv_par06 = 3 .Or. mv_par06 = 4 ) .and. lLerSef
		aStru := SEF->(DbStruct())
		cEF_T01 := aStru[SEF->(FieldPos("EF_DATA")),2]
		
		If lMultiThr
			// A Thread já enviou a tabela filtrada.
			// Apenas posicionar no inicio.
			(cAliasSEF)->(dbGoTop())
		Else
			dbSelectArea("SEF")
			cChave := "EF_FILIAL+EF_BANCO+EF_AGENCIA+DTOS(EF_DATA)"
			aStru := SEF->(DbStruct())
			
			cQuery := ""
			aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
			// Obtem os registros a serem processados
			cQuery := "SELECT " +SubStr(cQuery,2)
			cQuery += "     , SEF.R_E_C_N_O_ SEFRECNO "
			cQuery += "  FROM " + RetSqlName("SEF")+" SEF "
			
			IF ((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))
				If lPosEFMsFil .AND. !lUsaFilOri
				cQuery += "WHERE EF_MSFIL = '" + cFilAnt + "' AND "
				Else
					cQuery += "WHERE EF_FILORIG = '"  + cFilAnt + "' AND "
				Endif						
			Else
				cQuery += "WHERE EF_FILIAL = '" + xFilial("SEF") + "' AND "
			EndIf
			
			cQuery += "   EF_DATA between '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
			cQuery += "   EF_LA <> 'S' AND "
			cQuery += "	EF_LIBER = 'S ' AND "
			cQuery += "   D_E_L_E_T_ = ' ' "
			
			// Ponto de Entrada para filtrar registros do SE2.
			If l370EFFIL
				cQuery += Execblock("F370EFF",.F.,.F.,cQuery)
			EndIf
			
			// Ponto de Entrada para alterar ordenacao do SEF
			If l370EFKEY
				cChave := Execblock("F370EFK",.F.,.F.,cChave)
			EndIf
			
			// seta a ordem de acordo com a opcao do usuario
			cQuery += " ORDER BY " + SqlOrder(cChave)
			cQuery := ChangeQuery(cQuery)

			If __lConoutR
				ConoutR( cQuery )
			Endif

			cAliasSEF := FINNextAlias()
			
			If Select(cAliasSEF) > 0
				DbSelectArea( cAliasSEF )
				DbCloseArea()
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSEF, .F., .T.)

			For nI := 1 TO LEN(aStru)
				If aStru[nI][2] != "C"
					TCSetField(cAliasSEF, aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
				EndIf
			Next
			DbGoTop()
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ La‡o da contabiliza‡„o dia a dia, pela emiss„o (mv_par03 = 1)³
	//³ ou pela database.											 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par03 == 1
		nPeriodo := mv_par05 - mv_par04 + 1 // Data Final - Data inicial
		nPeriodo := Iif( nPeriodo == 0, 1, nPeriodo )
	Else
		nPeriodo := 1
	Endif
	
	dDataIni := mv_par04
	
	If ! lBat
		ProcRegua(nPeriodo)
	Endif

	For nLaco := 1 to nPeriodo
		
		If ! lBat
			IncProc()
		Endif
		dbSelectArea( "SE1" )
		
		nTotal:=0
		nHdlPrv:=0
		lCabecalho:=.F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se a contabiliza‡„o for pela data de emiss„o, altera o valor ³
		//³ da data-base e dos parƒmetros, para efetuar a contabiliza‡„o ³
		//³ e a sele‡„o dos registros respectivamente.					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par03 == 1
			dDataCtb := dDataIni + nLaco - 1

			mv_par04 := dDataCtb
			mv_par05 := dDataCtb

			// Forço a alteração do database para o periodo que estou contabilizando
			dDataBase := dDataCtb
		Endif
		
		// Verifica o Numero do Lote - SX5 Tabela 09 Chave FIN
		cLote := LoteCont("FIN")
		
		If (mv_par06 == 1 .or. mv_par06 == 4) .and. lLerSe1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contas a Receber - SE1990 										     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lMultiThr
				dbSelectArea( cAliasSE1 )
				If mv_par03 <> 1
					cCondWhile:= "'"+xFilial("SE1")+"' == "+cAliasSE1+"->E1_FILIAL .And. ( "+cAliasSE1+"->E1_EMIS1 >= mv_par04	.And. "+cAliasSE1+"->E1_EMIS1 <= mv_par05 )"
				Else
					cCondWhile:= "'"+xFilial("SE1")+"' == "+cAliasSE1+"->E1_FILIAL .And. "+cAliasSE1+"->E1_EMIS1 == mv_par04"
				Endif
			Else
				If __lDefTop
					dbSelectArea("SE1")
					lQrySE1	:= .T.

					cChave := "E1_FILIAL+E1_EMIS1+E1_NOMCLI+E1_PREFIXO+E1_NUM+E1_PARCELA"
					aStru := SE1->(DbStruct())
					
					cQuery := ""
					aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})

					// Obtem os registros a serem processados
					cQuery := "SELECT " + SubStr(cQuery,2)
					cQuery += "     , SE1.R_E_C_N_O_ SE1RECNO "
					cQuery += "  FROM " + RetSqlName("SE1") + " SE1 "

					// Filtro das filiais
					IF ((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))											
						If lPosE1MsFil .AND. !lUsaFilOri
						cQuery += " WHERE E1_MSFIL = '" + cFilAnt + "'"
					Else
							cQuery += " WHERE E1_FILORIG = '" + cFilAnt + "'"
						Endif												
					Else
						cQuery += " WHERE E1_FILIAL = '" + xFilial("SE1") + "'"
					EndIf
					
					cQuery += "  AND E1_EMIS1 BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "'"

					cQuery += "  AND E1_LA <> 'S' AND E1_ORIGEM <> 'FINA677' "

					If nCtbVenda == 2 //Contabilização por venda
						cQuery += " AND E1_ORIGEM <> 'FINI055'"
					Endif
					
					cQuery += "  AND D_E_L_E_T_ = ' ' "

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de Entrada para filtrar registros do SE1. ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If l370E1FIL
						cQuery := Execblock("F370E1F",.F.,.F.,cQuery)
					EndIf
					
					// seta a ordem de acordo com a opcao do usuario
					cQuery += " ORDER BY " + SqlOrder(cChave)
					
					cQuery := ChangeQuery(cQuery)
					
					If __lConoutR
						ConoutR( cQuery )
					Endif

					cAliasSE1 := FINNextAlias()
					
					If Select( cAliasSE1 ) > 0
						DbSelectArea(cAliasSE1)
						DbCloseArea()
					Endif
					
					dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSE1, .F., .T.)

					For nI := 1 TO LEN(aStru)
						If aStru[nI][2] != "C"
							TCSetField(cAliasSE1, aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
						EndIf
					Next
				Endif
					
				If lQrySE1
					If Select( cAliasSE1 ) > 0
						DbSelectArea(cAliasSE1)
						DbGoTop()
					Else
						UserException( 'ERRO NA BUSCA DOS DADOS DA SE1' )
						Final()
					Endif
				Else
					cAliasSE1 := "SE1"
					
					dbSelectArea( cAliasSE1 )
					dbSetOrder( 6 )
					dbSeek( cFilial+Dtos(mv_par04),.T. )
				Endif

				If lF370E1WH
					cCondWhile:= Execblock("F370E1W",.F.,.F.)
				Else
					If __lDefTop
						cCondWhile:= " .T. "
					Else
						If mv_par03 <> 1
							cCondWhile:= "'"+cFilial+"' == SE1->E1_FILIAL .And. ( SE1->E1_EMIS1 >= mv_par04	.And. SE1->E1_EMIS1 <= mv_par05 )"
						Else
							cCondWhile:= "'"+cFilial+"' == SE1->E1_FILIAL .And. SE1->E1_EMIS1 == mv_par04"
						Endif
					Endif
					
				EndIf
			EndIf
			
			DbSelectArea(cAliasSE1)
			While (cAliasSE1)->(!Eof()) .And. &cCondWhile

				If ( cAliasSE1 <> "SE1" )
					SE1->(dbGoto( (cAliasSE1)->SE1RECNO ) )
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Confirma a seleção do titulo para contabilização.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If l370E1LGC .And. ( cAliasSE1 == "SE1" )
					If !Execblock("F370E1L",.F.,.F.)
						(cAliasSE1)->(dbSkip())
						Loop
					EndIf
				EndIf
				
				cPadrao := "500"

				// Desdobramento
				If SE1->E1_DESDOBR == "1" // 1-Sim | 2-Não
					cPadrao := "504"
				EndIf
				
				dDataCtb := IF(MV_PAR03 == 1, SE1->E1_EMIS1, dDataBase)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se ser  gerado Lan‡amento Cont bil			  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SE1->E1_LA == "S" .Or. (SE1->E1_TIPO $ MVPROVIS .And. mv_par17 <> 1)
					(cAliasSE1)->( dbSkip())
					Loop
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no cliente.										  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SA1" )
				dbSeek( xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona na natureza.										  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SED" )
				dbSeek( cFilial+SE1->E1_NATUREZ )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona na SE5,se RA										  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRAMov := .F.
				If SE1->E1_TIPO $ MVRECANT
					dbSelectArea("SE5")
					dbSetOrder(2)
					lRAMov := dbSeek( xFilial()+"RA"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+DtoS(SE1->E1_EMIS1)+SE1->E1_CLIENTE+SE1->E1_LOJA)
					dbSetOrder(1)
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no banco.											  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SA6" )
				dbSetOrder(1)
				dbSeek( cFilial+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA )
				// Se for um recebimento antecipado e nao encontrou o banco
				// pelo SE1, pesquisa pelo SE5.
				IF SE1->E1_TIPO $ MVRECANT
					If SA6->(Eof())
						dbSeek( cFilial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA )
					Endif
					cPadrao:="501"
				Endif
				
				dbSelectArea("SE1")
				
				lPadrao		:= VerPadrao(cPadrao)
                lCtbPls	  	:= ( substr(SE1->E1_ORIGEM,1,3) == "PLS" .or. !empty(SE1->E1_PLNUCOB) )
				lPadraoCc 	:= VerPadrao("506") //Rateio por C.Custo de MultiNat C.Receber
				
				if lPadrao .and. !lCtbPls
				
					If !lCabecalho
						a370Cabecalho(@nHdlPrv,@cArquivo)
					Endif
					cChaveSev := RetChaveSev("SE1")
					cChaveSez := RetChaveSev("SE1",,"SEZ")
					dbSelectArea("SE1")
					nRecSe1 := Recno()
					DbSelectArea("SEV")
					// Se utiliza multiplas naturezas, contabiliza pelo SEV
					If  SE1->E1_MULTNAT == "1" .And. MsSeek(cChaveSev)

						dbSelectArea("SE1")
						nRecSe1 := Recno()
						DbGoBottom()
						DbSkip()
						DbSelectArea("SEV")
						dbSetOrder(2)
						While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
							EV_LOJA+EV_IDENT) == cChaveSev+"1" .And. SEV->(!Eof())

							If SEV->EV_LA != "S"
								dbSelectArea( "SED" )
								MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
								dbSelectArea("SEV")
								
								If SEV->EV_RATEICC == "1" .and. lPadraoCC .and. lPadrao// Rateou multinat por c.custo
									dbSelectArea("SEZ")
									dbSetOrder(4)
									MsSeek(cChaveSeZ+SEV->EV_NATUREZ) // Posiciona no arquivo de Rateio C.Custo da MultiNat
								
									While SEZ->(!Eof()) .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
										EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT) == cChaveSeZ+SEV->EV_NATUREZ+"1"
										
										If SEZ->EZ_LA != "S"

											If lUsaFlag
												aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
											EndIf

											nTotDoc	+=	DetProva(nHdlPrv,"506","FINA370",cLote,,,,,,aCT5,,@aFlagCTB)

											If LanceiCtb // Vem do DetProva
												If !lUsaFlag
													RecLock("SEZ")
													SEZ->EZ_LA    := "S"
													MsUnlock( )
												EndIf
											ElseIf lUsaFlag
												If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
													aFlagCTB := Adel(aFlagCTB,nPosReg)
													aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
												Endif
											EndIf
										Endif
										SEZ->(dbSkip())
									Enddo
									DbSelectArea("SEV")
								Else
									If lUsaFlag
										aAdd(aFlagCTB,{"EV_LA","S","SEV",SEV->(Recno()),0,0,0})
									EndIf
									nTotDoc	:= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
								Endif
								
								If LanceiCtb // Vem do DetProva
									If !lUsaFlag	
										RecLock("SEV")
										SEV->EV_LA    := "S"
										MsUnlock( )
									EndIf
								ElseIf lUsaFlag
									If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
										aFlagCTB := Adel(aFlagCTB,nPosReg)
										aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
									Endif
								Endif
								
							Endif

							DbSelectArea("SEV")
							DbSkip()
						Enddo
						nTotal  	+=	nTotDoc
						nTotProc	+=	nTotDoc // Totaliza por processo

						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						nRecSev := SEV->(Recno())
						nRecSez := SEZ->(Recno())

						dbSelectArea("SEV")
						dbGobottom()
						dbSkip()

						DbSelectArea("SEZ")
						dbGobottom()
						dbSkip()

						nTotDoc	+=	DetProva(nHdlPrv,"506","FINA370",cLote,,,,,,aCT5,,@aFlagCTB)

						If mv_par12 == 2 
							IF nTotDoc > 0 // Por documento
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
								nTotDoc := 0
							Endif
							aFlagCTB := {}
						Endif
						
						dbSelectArea("SE1")
						DbGoto(nRecSe1)
					Endif

					dbSelectArea("SEV")
					DbGoBottom()
					DbSkip()
					
					DbSelectArea("SE1")
					dbGoto(nRecSe1)
					cNumLiq := SE1->E1_NUMLIQ
					If lUsaFlag
						// Carrega em aFlagCTB os recnos ref. SE5 e FKs
						// Quando não lUsaFlag aRecsSE5 efetuará a marcação
						If lRAMov
							CTBAddFlag(aFlagCTB)
						EndIf
						aAdd(aFlagCTB,{"E1_LA","S","SE1",SE1->(Recno()),0,0,0})
					EndIf
					If !lCabecalho	// Se não houver cabeçalho aberto, abre.
						a370Cabecalho(@nHdlPrv,@cArquivo)
					EndIf

					//Posiciono FO2 e alimento variável referente ao juros informado na liquidação
					If !Empty(cNumLiq)
						dbSelectArea("FO2")
						nRecFO2 := F460PosFO2( nRecSe1 , cNumLiq )
						If nRecFO2 > 0
							FO2->(dbGoto(nRecFO2))
							JUROS3 := FO2->FO2_VLJUR
						EndIf
					EndIf					
					nTotDoc	:= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
					nTotal	+= nTotDoc
					nTotProc	+= nTotDoc //Totaliza por processo

					If mv_par12 == 2 // Por documento
						IF nTotDoc > 0
							If lSeqCorr
								aDiario := {{"SE1",SE1->(recno()),SE1->E1_DIACTB,"E1_NODIA","E1_DIACTB"}}
							EndIf
							Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
						Endif
						aFlagCTB := {}
					Endif

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza Flag de Lan‡amento Cont bil		  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If LanceiCtb
						If !lUsaFlag
							Reclock("SE1")
							REPLACE E1_LA With "S"
							MsUnlock( )
						EndIf
					ElseIf lUsaFlag
						If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE1->(Recno()) }))>0
							aFlagCTB := Adel(aFlagCTB,nPosReg)
							aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
						Endif
					EndIf
				Endif
				DbSelectArea(cAliasSE1)
				dbSkip()
			Enddo			
			
			If mv_par12 == 3 
				If nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
					nTotProc := 0
				Endif
				aFlagCTB := {}
			Endif
			
			// Encerro o temporario criado para a contabilização.
			If lQrySE1 .And. Select( cAliasSE1 ) > 0
				DbSelectArea(cAliasSE1)
				DbCloseArea()
				cAliasSE1 := "SE1"
			Endif
		Endif		

		If (mv_par06 == 2 .or. mv_par06 == 4) .and. lLerSE2

			IF Select(cAliasSE2)<=0
				If !__lSchedule
					MsAguarde( {|| Sleep( 2000 ) }, "Erro ao trazer os dados da SE2.", "CTBAFIN")
				EndIf
			
				cAliasSE2 := "SE2"
			Endif
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contas a Pagar - SE2990												  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea(cAliasSE2)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contabiliza pelo E2_EMIS1                  			  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While (cAliasSE2)->( !Eof() ) .And. (cAliasSE2)->E2_EMIS1 >= mv_par04 ;
				.And. (cAliasSE2)->E2_EMIS1 <= mv_par05
				
				If !lPass .And. lMvAGP
					While !Eof()
						If (cAliasSE2)->E2_PREFIXO == "AGP" .And. Empty((cAliasSE2)->E2_TITPAI) .And. Alltrim((cAliasSE2)->E2_ORIGEM) == "FINA378"
							lAGP := .T.
							Exit
						EndIf
						nSkip += 1
						(cAliasSE2)->(DbSkip())
					EndDo
					lPass := .T.
					If nSkip >= 1
						nSkip := 0
						(cAliasSE2)->(DbGotop())
					EndIf
				EndIf
				
				DBSelectArea("SE2")
				SE2->(dbGoto((cAliasSE2)->SE2RECNO))
				lMulNatSE2 := .F.
				lPAMov	:= .F.
				dDataCtb := IF(MV_PAR03 == 1, SE2->E2_EMIS1, dDataBase)
				                    
				// Nao contabiliza titulos de impostos aglutinados com origem na rotina FINA378
				// O parâmetro MV_CTBAGP libera a contabilização dos títulos do PCC aglutinados.
				If !lAGP // Neste caso o Parâmetro de contabilização dos impostos aglutinados inverte a operação
					If	AllTrim( Upper( SE2->E2_ORIGEM ) ) == "FINA378" .And. SE2->E2_PREFIXO == "AGP"	// Aglutinacao Pis/Cofins/Csll
						(cAliasSE2)->(dbSkip())
						Loop
					Endif
				ElseIf AllTrim(SE2->E2_CODRET) == "5952" .And. ( (SE2->E2_PREFIXO != "AGP" .Or. !Empty(SE2->E2_TITPAI)) .And. AllTrim(SE2->E2_ORIGEM) != "FINA378") .And. (lF370ChkAgp .And. F370ChkAgp())
					RecLock("SE2",.F.)
					SE2->E2_LA := 'S'
					SE2->(MsUnLock())
					(cAliasSE2)->(dbSkip())
					Loop
				EndIf

				// Contabiliza movimentacao bancaria de adiantamento - MV_CTMOVPA
				If SE2->E2_TIPO $ MVPAGANT
					If lCtMovPa
						(cAliasSE2)->(dbSkip())
						Loop
					EndIf
					nRecMovPa := F080MovPA(.T.,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA)
					lPAMov := nRecMovPa > 0
				Endif

				If	SE2->E2_TIPO $ MVTAXA+"/"+MVISS+"/"+MVINSS .And.;
					( AllTrim(SE2->E2_FORNECE) $ cUniao .Or.;
					AllTrim(SE2->E2_FORNECE) $ cMunic)
					// Contabiliza rateio de impostos em multiplas naturezas e multiplos
					// centros de custos.
					lPadrao:=VerPadrao("510")
					lPadraoCC := VerPadrao("508")  // Rateio C.Custo de MultiNat Pagar
					If lPadrao
						If SE2->E2_RATEIO != "S"
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							cChaveSev := RetChaveSev("SE2")
							cChaveSeZ := RetChaveSev("SE2",,"SEZ")
							DbSelectArea("SEV")
							// Se utiliza multiplas naturezas, contabiliza pelo SEV
							If SE2->E2_MULTNAT=="1" .And. MsSeek(cChaveSev)
								lMulNatSE2 := .F.
								dbSelectArea("SE2")
								nRecSe2 := Recno()
								DbGoBottom()
								DbSkip()

								DbSelectArea("SEV")
								dbSetOrder(2)
								While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
									EV_LOJA+EV_IDENT) == cChaveSev+"1" .And. !Eof()
									If SEV->EV_LA != "S"
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEV")
										If SEV->EV_RATEICC == "1" .and. lPadrao .and. lPadraoCC // Rateou multinat por c.custo
											dbSelectArea("SEZ")
											dbSetOrder(4)
											MsSeek(cChaveSeZ+SEV->EV_NATUREZ) // Posiciona no arquivo de Rateio C.Custo da MultiNat
											While SEZ->(!Eof()) .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
												EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT) == cChaveSeZ+SEV->EV_NATUREZ+"1"

												If SEZ->EZ_LA != "S"

													If lUsaFlag
														aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
													EndIf

													VALOR := 0
													VALOR2 := 0
													VALOR3 := 0
													VALOR4 := 0
													Do Case
														Case SEZ->EZ_TIPO $ MVTAXA
															VALOR2 := SEZ->EZ_VALOR
														Case SEZ->EZ_TIPO $ MVISS
															VALOR3 := SEZ->EZ_VALOR
														Case SEZ->EZ_TIPO $ MVINSS
															VALOR4 := SEZ->EZ_VALOR
													EndCase
													nTotDoc	+=	DetProva(nHdlPrv,"508","FINA370",cLote,,,,,,aCT5,,@aFlagCTB)

													If LanceiCtb // Vem do DetProva
														If !lUsaFlag
															RecLock("SEZ")
															SEZ->EZ_LA    := "S"
															MsUnlock( )
														EndIf
													ElseIf lUsaFlag
														If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
															aFlagCTB := Adel(aFlagCTB,nPosReg)
															aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
														Endif														
													Endif

												Endif
												SEZ->(dbSkip())
											Enddo
										Else
											VALOR := 0
											VALOR2 := 0
											VALOR3 := 0
											VALOR4 := 0
											Do Case
												Case SEV->EV_TIPO $ MVTAXA
													VALOR2 := SEV->EV_VALOR
												Case SEV->EV_TIPO $ MVISS
													VALOR3 := SEV->EV_VALOR
												Case SEV->EV_TIPO $ MVINSS
													VALOR4 := SEV->EV_VALOR
											EndCase

											If lUsaFlag
												aAdd(aFlagCTB,{"EV_LA","S","SEV",SEV->(Recno()),0,0,0})
											EndIf

											nTotDoc	+=	DetProva(nHdlPrv,"510","FINA370",cLote,,,,,,aCT5,,@aFlagCTB)

										Endif
										If LanceiCtb // Vem do DetProva
											If !lUsaFlag
												RecLock("SEV")
												SEV->EV_LA    := "S"
												MsUnlock( )
											EndIf
										ElseIf lUsaFlag
											If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
												aFlagCTB := Adel(aFlagCTB,nPosReg)
												aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
											Endif
										Endif

									Endif
									dbSelectArea("SEV")
									DbSkip()
								Enddo
								nTotal  	+=	nTotDoc
								nTotProc	+=	nTotDoc // Totaliza por processo
								nRecSev := SEV->(Recno())
								nRecSez := SEZ->(Recno())
								dbSelectArea("SEV")
								dbGobottom()
								dbSkip()
								dbSelectArea("SEV")
								dbGobottom()
								dbSkip()
								dbSelectArea("SE2")			// permite contabilizar os impostos pelo SE2
								dbGoto(nRecSe2)
								If lUsaFlag
									aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
								EndiF
								If !lCabecalho
									a370Cabecalho(@nHdlPrv,@cArquivo)
								Endif
								
								nTotDoc	+=	DetProva(nHdlPrv,"508","FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
								SEV->(dbGoto(nRecSev))
								SEZ->(dbGoto(nRecSez))
								dbSelectArea("SE2")
								DbGoto(nRecSe2)
								If mv_par12 == 2 
									If nTotDoc > 0 // Por documento
										If lF370NatP
											ExecBlock("F370NATP",.F.,.F.,{nHdlPrv,cLote})
										Endif
										If lSeqCorr
											aDiario := {{"SE2",SE2->(recno()),SE2->E2_DIACTB,"E2_NODIA","E2_DIACTB"}}
										EndIf
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
										nTotDoc := 0
									Endif
									aFlagCTB := {}
								Endif
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Flag de Lan‡amento Cont bil 	   ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If LanceiCtb
									If !lUsaFlag
										Reclock("SE2")
										Replace E2_LA With "S"
										SE2->(MsUnlock())
									EndIF
								ElseIf lUsaFlag
									If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE2->(Recno()) }))>0
										aFlagCTB := Adel(aFlagCTB,nPosReg)
										aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
									Endif
								EndIf
							Endif
						Endif
					Endif
					// Fim da contabilizacao de titulos de impostos por multiplas natureza
					// e multiplos centros de custos
					dbSelectArea( cAliasSE2 )
					If lMulNatSE2
						dbSkip()
						Loop
					Endif
				Endif
				cPadrao := "510"
				
				IF	SE2->E2_TIPO $ MVPAGANT
					cPadrao:="513"
				EndIF
				
				If	SE2->E2_RATEIO == "S"
					cPadrao := "511"
				EndIf
				
				If	SE2->E2_DESDOBR == "S"
					cPadrao := "577"
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona no fornecedor.									  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SA2" )
				dbSeek( xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona na natureza.										  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SED" )
				dbSeek( xFilial("SED")+SE2->E2_NATUREZ )

				dbSelectArea("SE2")
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona na SE5 e no Banco,se PA e SEF para Cheque ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SE2->E2_TIPO $ MVPAGANT
					
					dbSelectArea("SE5")
					dbSetOrder(1)
					If lPaMov
						SE5->( DbGoTo(nRecMovPa) )
					EndIf
					
					dbSelectArea("SEF") // Busca CHEQUE
					dbSetOrder(3)
					dbSeek(xFilial()+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_NUMBCO)
					
					dbSelectArea( "SA6" )
					dbSetOrder(1)
					If SE5->(Found()) .or. lPaMov // Busca Movimento Bancario
						dbSeek( xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
					Else
						dbSeek( xFilial()+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA)
					Endif

					SE5->( DbGoTo(0) ) // Desposiciona SE5
					dbSelectArea( "SE2" )
				Endif
				lPadrao		:= VerPadrao(cPadrao)
				lCtbPls		:= ( substr(SE2->E2_ORIGEM,1,3) == "PLS" .or. !empty(SE2->E2_PLLOTE) ) 
				lPadraoCC 	:= VerPadrao("508")  // Rateio C.Custo de MultiNat Pagar
				
				If lPadrao  .and. !lCtbPls
				
					If SE2->E2_RATEIO != "S"
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						Endif
						cChaveSev := RetChaveSev("SE2")
						cChaveSeZ := RetChaveSev("SE2",,"SEZ")
						DbSelectArea("SEV")
						// Se utiliza multiplas naturezas, contabiliza pelo SEV
						If SE2->E2_MULTNAT == "1" .And. MsSeek(cChaveSev)
							dbSelectArea("SE2")
							nRecSe2 := Recno()
							DbSelectArea("SEV")
							dbSetOrder(2)
							While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
								EV_LOJA+EV_IDENT) == cChaveSev+"1" .And. !Eof()

								If SEV->EV_LA != "S"

									dbSelectArea( "SED" )
									MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
									dbSelectArea("SEV")
									If SEV->EV_RATEICC == "1" .and. lPadrao .and. lPadraoCC // Rateou multinat por c.custo

										dbSelectArea("SEZ")
										dbSetOrder(4)
										MsSeek(cChaveSeZ+SEV->EV_NATUREZ) // Posiciona no arquivo de Rateio C.Custo da MultiNat
										While SEZ->(!Eof()) .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
												EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT) == cChaveSeZ+SEV->EV_NATUREZ+"1"

											If SEZ->EZ_LA != "S"
												If lUsaFlag
													aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
												EndiF
	
												VALOR2	:= 0
												VALOR3	:= 0
												VALOR4	:= 0
												VALOR  	:= 0
												Do Case
													Case SEZ->EZ_TIPO $ MVTAXA
														VALOR2 := SEZ->EZ_VALOR
													Case SEZ->EZ_TIPO $ MVISS
														VALOR3 := SEZ->EZ_VALOR
													Case SEZ->EZ_TIPO $ MVINSS
														VALOR4 := SEZ->EZ_VALOR
													Otherwise
														VALOR  := SEZ->EZ_VALOR
												EndCase
												nTotDoc	+=	DetProva(nHdlPrv,"508","FINA370",cLote,,,,,,aCT5,,@aFlagCTB)

												If LanceiCtb // Vem do DetProva
													If !lUsaFlag
														RecLock("SEZ")
														SEZ->EZ_LA    := "S"
														MsUnlock( )
													EndIf
												ElseIf lUsaFlag
													If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
														aFlagCTB := Adel(aFlagCTB,nPosReg)
														aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
													Endif
												Endif
											Endif

											SEZ->(dbSkip())
										Enddo
										DbSelectArea("SEV")
									Else
										VALOR  := 0
										VALOR2 := 0
										VALOR3 := 0
										VALOR4 := 0
										Do Case
											Case SEV->EV_TIPO $ MVTAXA
												VALOR2 := SEV->EV_VALOR
											Case SEV->EV_TIPO $ MVISS
												VALOR3 := SEV->EV_VALOR
											Case SEV->EV_TIPO $ MVINSS
												VALOR4 := SEV->EV_VALOR
											Otherwise
												VALOR  := SEV->EV_VALOR
										EndCase
										If lUsaFlag
											aAdd(aFlagCTB,{"EV_LA","S","SEV",SEV->(Recno()),0,0,0})
										EndIf
										nTotDoc	+= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
									Endif
									If LanceiCtb // Vem do DetProva
										If !lUsaFlag
											RecLock("SEV")
											SEV->EV_LA    := "S"
											MsUnlock( )
										EndIf
									ElseIf lUsaFlag
										If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
											aFlagCTB := Adel(aFlagCTB,nPosReg)
											aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
										Endif
									Endif

								Endif
								dbSelectArea("SEV")
								DbSkip()

								// Inicializa Variáveis
								VALOR  := 0
								VALOR2 := 0
								VALOR3 := 0
								VALOR4 := 0
								
							Enddo
							nTotal  	+=	nTotDoc
							nTotProc	+=	nTotDoc // Totaliza por processo
							
							// Desposiciona SEV
							dbSelectArea("SEV")
							DbGoBottom()
							DbSkip()							
							
							// Posiciona Título PPrincipal
							dbSelectArea("SE2")
							DbGoto(nRecSe2)
							If lUsaFlag
								aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
							Endif
							nTotDoc	+= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
							If LanceiCtb .AND. !lUsaFlag// Vem do DetProva
								RecLock("SE2")
								Replace E2_LA With "S"
								SE2->(MsUnlock())
							ElseIf !LanceiCtb .and. lUsaFlag
								If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE2->(Recno()) }))>0
									aFlagCTB := Adel(aFlagCTB,nPosReg)
									aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
								Endif
							Endif

							If mv_par12 == 2 .OR. mv_par12 == 3
								If lF370NatP
									ExecBlock("F370NATP",.F.,.F.,{nHdlPrv,cLote})
								Endif

								If mv_par12 == 2 .AND. nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE2",SE2->(recno()),SE2->E2_DIACTB,"E2_NODIA","E2_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
									nTotDoc := 0
									aFlagCTB := {}
								Endif
							Endif

 						Endif

						dbSelectArea( "SE2" )
						If !SE2->E2_LA == "S" .AND. SE2->E2_MULTNAT <> '1'
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							
							If lUsaFlag
								aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
							EndIf
							
							nTotDoc	+=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)

							nTotProc+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE2",SE2->(recno()),SE2->E2_DIACTB,"E2_NODIA","E2_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
									nTotDoc := 0
								Endif
								aFlagCTB := {}
							Endif

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza Flag de Lan‡amento Cont bil 		  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If LanceiCtb
								If !lUsaFlag
									Reclock("SE2")
									Replace E2_LA With "S"
									SE2->(MsUnlock())
								EndIf
							ElseIf lUsaFlag
								If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE2->(Recno()) }))>0
									aFlagCTB := Adel(aFlagCTB,nPosReg)
									aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
								Endif							
							EndIf
						EndIf
					Else
						If !CtbInUse()
							/// Fa370Rat já cria cabecalho contab. caso não esteja aberto
							If lUsaFlag
								aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
							EndIf
							nTotDoc	:=	Fa370Rat(AllTrim(SE2->E2_ARQRAT),@nHdlPrv,@cArquivo)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE2",SE2->(recno()),SE2->E2_DIACTB,"E2_NODIA","E2_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
								Endif
								aFlagCTB := {}
							Endif
							
							If nTotal != 0
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Flag de Lan‡amento Cont bil		  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SE2")
								If !lUsaFlag
									Reclock("SE2")
									Replace E2_LA With "S"
									SE2->(MsUnlock())
								EndIf
							Endif
						Else
							// Devido a estrutura do programa, o rateio ja eh "quebrado"
							// por documento.
							If !lCabecalho							/// Se não houver cabeçalho aberto, abre.
								a370Cabecalho(@nHdlPrv,@cArquivo)
							EndIf

							RegToMemory("SE2",.F.,.F.)

							If lUsaFlag
								aAdd(aFlagCTB,{"E2_LA","S","SE2",SE2->(Recno()),0,0,0})
							EndIf

							F370RatFin(cPadrao,"FINA370",cLote,4," ",4,,,,@nHdlPrv,@nTotDoc,@aFlagCTB)

							lCabecalho := If(nHdlPrv <= 0, lCabecalho, .T.)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc

							If mv_par12 == 2 
								If nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE2",SE2->(recno()),SE2->E2_DIACTB,"E2_NODIA","E2_DIACTB"}}
									EndIf						
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
								Endif
								aFlagCTB := {}
							Endif
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza Flag de Lan‡amento Cont bil		  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If LanceiCtb
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Flag de Lan‡amento Cont bil		  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SE2")
								If !lUsaFlag
									Reclock("SE2")
									Replace E2_LA With "S"
									SE2->(MsUnlock())
								EndIf
							ElseIf lUsaFlag
								If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SE2->(Recno()) }))>0
									aFlagCTB := Adel(aFlagCTB,nPosReg)
									aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
								Endif
							EndIf
						EndIf
					Endif
				Endif
				dbSelectArea(cAliasSE2)
				dbSkip()
				LanceiCtb := .F.
				
			Enddo

			If mv_par12 == 3 
				IF nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
					nTotProc := 0
				Endif
				aFlagCTB := {}
			Endif
			
			dbSelectArea( cAliasSE2 )
		Endif
		
		
		//Contabilizacao do SE5
 		If lLerSE5
			aRecsSE5 := {}
			aRecsTRF := {} //Registros de transferencia bancaria

			cCondFilSE5 := xFilial("SE5")

			cCondWhile:= "( (" + cAliasSE5 + "->" + cCampo + " >= mv_par04 .And. " + cAliasSE5 + "->" + cCampo + " <= mv_par05 ) .AND. "
			cCondWhile += " !(" + cAliasSE5 + "->E5_TIPODOC  $ 'TR#TE') ) .OR. "

			cCondWhile += "( ((" + cAliasSE5 + "->E5_DATA >= mv_par04 .AND. " + cAliasSE5 + "-> E5_DATA <= mv_par05) .OR. "
			cCondWhile += " (" + cAliasSE5 + "->" + cCampo + " >= mv_par04 .And. " + cAliasSE5 + "->" + cCampo + " <= mv_par05)) "
			cCondWhile += " .AND. " + cAliasSE5 + "->E5_TIPODOC $ 'TR#TE' .OR. Empty(" + cAliasSE5 + "->(E5_TIPODOC+E5_TIPO))) " //  Filtra somente as transferencias bancarias

			nValorTotal := 0 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Variaveis para suporte a Recebimentos Diversos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSELSerie	:= ""
			cSELRecibo	:= ""
			// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			
			// Controla a Contabilização distinta de Acrescimos e Decrescimos - Compensação CR
			aCmpCRSE1 := {}
			
			cRecPag := (cAliasSE5)->E5_RECPAG

			While VldDtE5(cAliasSe5,cCampo,mv_par05,ddataini)
								
				// garanto que estarei posicionado no primeiro registro da data --------- 
				If !(&cCondWhile)  
					(cAliasSE5)->( dbSkip() )
					Loop
				Endif

				dbSelectArea( "SE5" ) // ------------------------------------------------
				If MV_PAR13 == 1	// Ctb Bordero - Total/Por Bordero
					SE5->(dbSetOrder(1))	// "E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
				Else
					SE5->(dbSetOrder(10))	// "E5_FILIAL+E5_DOCUMEN"
				Endif
				
				// Emparelha as tabelas Temporária e Oficial ---------------------------- 
				SE5->(dbGoto((cAliasSE5)->(SE5RECNO)))
				dDataCtb := (cAliasSE5)->(&cCampo)
				
				// Totaliza movimento bancário DIRETO ou de TÍTULOS por processo (MV_PAR12 == 3)
				If MV_PAR12 == 3
					If		cTipoMov == "DIRETO" .and. !EMPTY((cAliasSE5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
						(cAliasSE5)->(dbSkip())
						If (cAliasSE5)->(EOF()) .and. cTipoMov == "DIRETO"
							(cAliasSE5)->(dbGOTOP())
							cTipoMov := "TITULOS"
						EndIf	
						lLoop := .T.
					ElseIf	cTipoMov == "TITULOS" .and. EMPTY((cAliasSE5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))
						(cAliasSE5)->(dbSkip())
						lLoop := .T.
					EndIf

					If !EMPTY(nTotProc) .and. cRecPag <> (cAliasSE5)->E5_RECPAG
						cRecPag := (cAliasSE5)->E5_RECPAG
						Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
						aFlagCTB := {}
						nTotProc := 0
					EndIf

					If lLoop
						lLoop := .F.
						LOOP
					EndIf
				EndIf

				// Posiciona SEA Borderô
				dbSelectArea("SEA")  // EA_FILIAL+EA_NUMBOR+EA_CART+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA
				SEA->(dbSetOrder(2)) // EA_FILORIG, EA_NUMBOR, EA_CART, EA_PREFIXO, EA_NUM, EA_PARCELA, EA_TIPO, EA_FORNECE, EA_LOJA
				SEA->(dbSeek(SE5->E5_FILORIG+PADR(SE5->E5_DOCUMEN,nTamBor)+"P"+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA)))
				// Posiciona SED Naturezas ----------------------------------------------
				dbSelectArea("SED")
				SED->(dbSetOrder(1))	// ED_FILIAL+ED_CODIGO
				SED->(dbSeek(xFilial("SED")+SE5->E5_NATUREZ))
				// Posiciona SA6 Bancos -------------------------------------------------
				dbSelectArea("SA6")
				SA6->(dbSetOrder(1))	// A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
				SA6->(dbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
				// ----------------------------------------------------------------------
				
				// Validação de ultimo registro do borderô
				aAreaSEA := SEA->(GetArea())

				cNumBor :=  SEA->EA_NUMBOR
				SEA->(dbSkip())
				cProxBor := SEA->EA_NUMBOR

				//se numero do bordero for igual mas data diferente da data de contabilizacao entao limpa cProxBor
				If ! Empty( cProxBor ) .And. ! Empty( cNumBor ) .And. ( cProxBor == cNumBor ) .And. &(cAliasSE5+"->"+cCampo) != dDataCtb
					cProxBor := " "
				Endif

				SEA->(RestArea(aAreaSEA))
				
				dbSelectArea("SE5")		// Restaura a área da tabela Oficial 

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Movimentos Bancarios e Aplicacoes/Emprestimos - SE5  		  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (SE5->E5_TIPODOC $ "  /TR/TE/DB/PA/OD/AP/RF/PE/EP/IT" .OR. Empty(SE5->(E5_TIPODOC+E5_TIPO)))
					cPadrao := ""

					lRaCont := .F. //Limpa variavel de Contabilização de Baixa de RA - LP 520
					
					If SE5->E5_RECPAG == 'R' .and. SE5->E5_TIPODOC $ "  |DB" .and. ( mv_par06 == 1 .or. mv_par06 == 4 )
						cPadrao	:= Iif( SE5->E5_SITUACA <> "E", "563", "564" )
					ElseIf SE5->E5_RECPAG == 'P' .and. ( mv_par06 == 2 .or. mv_par06 == 4 )
						If !SE5->E5_TIPODOC $ "TR#TE" .AND. SE5->E5_SITUACA <> "E"
							cPadrao := "562"
						ElseIf !SE5->E5_TIPODOC $ "TR#TE" .AND. SE5->E5_RECPAG = "P"
							cPadrao := "565"
						EndIf
					Endif

					If SE5->E5_TIPO $ MVRECANT .AND. SE5->E5_RECPAG ="P" .AND. ALLTRIM(SE5->E5_LA) <> "S"
						lRACont := .T.
						cPadrao := '520'
					Endif 

					//se for ITF utiliza lancamento especifico
					If lFindITF .And. FinProcITF( SE5->( Recno() ),2 )
						If SE5->E5_SITUACA == 'E' .Or. SE5->E5_SITUACA == 'C'
							cPadrao := "56B"
						Else
							cPadrao := "56A"
						EndIf
					EndIf
					//Tranferencias

					//Não contabiliza movimentos da carteira a receber caso esteja contabilizando apenas a carteira a pagar.
					//Não contabiliza movimentos da carteira a pagar caso esteja contabilizando apenas a carteira a receber
					If !(SE5->E5_TIPODOC $ "TR#TE")
						If (mv_par06 != 1 .and. mv_par06 !=4) .And. SE5->E5_RECPAG == 'R'
							(cAliasSE5)->( dbSkip() )

							If MV_PAR12 == 3 .AND. (cAliasSE5)->(EOF()) .and. cTipoMov == "DIRETO"
								(cAliasSE5)->(dbGOTOP())
								cTipoMov := "TITULOS"
							EndIf	

							Loop
						ElseIf (mv_par06 != 2 .and. mv_par06 !=4) .AND. SE5->E5_RECPAG == 'P'
							(cAliasSE5)->( dbSkip() )

							If MV_PAR12 == 3 .AND. (cAliasSE5)->(EOF()) .and. cTipoMov == "DIRETO"
								(cAliasSE5)->(dbGOTOP())
								cTipoMov := "TITULOS"
							EndIf	

							Loop
						EndIf						
											
						// Nao contabiliza transferencia para carteira descontada
						// Este sera feito pela Baixa do titulo
						If SE5->E5_TIPODOC $ "TR#TE" .and. !Empty(SE5->E5_NUMERO)
							(cAliasSE5)->( dbSkip() )
							Loop
						Endif
	    	        Endif

					// Nao contabiliza movimento bancario totalizador da baixa CNAB ou automatica
					// Este sera feito pela Baixa do titulo (LP530 ou LP532)
					If Empty(SE5->E5_TIPODOC) .and. !Empty(SE5->E5_LOTE)
						(cAliasSE5)->( dbSkip() )
						Loop
					Endif
					
					If SE5->E5_RECPAG == "P" .and. SE5->E5_TIPODOC $ "TR#TE" .and. MV_PAR06 == 4
						cPadrao := "560"
						AADD(aRecsTRF,{SE5->(RECNO()),"560",IIF(!Empty(SE5->E5_NUMCHEQ),SE5->E5_NUMCHEQ,SE5->E5_DOCUMEN)})
						(cAliasSE5)->(dbSkip())

						If MV_PAR12 == 3 .AND. (cAliasSE5)->(EOF()) .and. cTipoMov == "DIRETO"
							(cAliasSE5)->(dbGOTOP())
							cTipoMov := "TITULOS"
						EndIf	

						Loop
					Elseif SE5->E5_RECPAG == "R" .and. SE5->E5_TIPODOC $ "TR#TE" .and. MV_PAR06 == 4
						cPadrao := "561"
						AADD(aRecsTRF,{SE5->(RECNO()),"561",IIF(!Empty(SE5->E5_NUMCHEQ),SE5->E5_NUMCHEQ,SE5->E5_DOCUMEN)})
						(cAliasSE5)->(dbSkip())

						If MV_PAR12 == 3 .AND. (cAliasSE5)->(EOF()) .and. cTipoMov == "DIRETO"
							(cAliasSE5)->(dbGOTOP())
							cTipoMov := "TITULOS"
						EndIf	

						Loop
					EndIf

					// Contabiliza movimentacao bancaria de adiantamento - MV_CTMOVPA
					If !lCtMovPa .And. SE5->E5_RECPAG == "P" .And. SE5->E5_TIPO	$ MVPAGANT
						(cAliasSE5)->(dbSkip())
						Loop
					Endif
					
					// Nao contabiliza movimentacao bancaria de adiantamento
					// Este sera feito pelo SE1
					If SE5->E5_RECPAG == "R" .And. SE5->E5_TIPO	$ MVRECANT
						(cAliasSE5)->(dbSkip())
						Loop
					Endif

					//Aplicacoes e emprestimos
					lX			:= .F.
					SEH->(dbSetOrder(1))
					
					If SE5->E5_TIPODOC $ "AP/RF/PE/EP" .And. SEH->(MsSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8)))
						lX		:= .T.
						If SE5->E5_TIPODOC $ "AP/EP"
							If ( SE5->E5_TIPODOC=="AP" .And. SE5->E5_RECPAG=="P" ) .Or.;
								( SE5->E5_TIPODOC=="EP" .And. SE5->E5_RECPAG=="R" )
								cPadrao := "580"
							Else
								cPadrao := "581"
							EndIf
						Else
							If ( SE5->E5_TIPODOC=="RF" .And. SE5->E5_RECPAG=="R" ) .Or.;
								( SE5->E5_TIPODOC=="PE" .And. SE5->E5_RECPAG=="P" )
								cPadrao := "585"
							Else
								cPadrao := "586"
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ SEH ja esta posicionado  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RecLock("SEH")
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						SEH->EH_VALIRF := 0
						// Soh zera valor do IOF para buscar o movimento de IOF (EI_TIPODOC igual a "I2") nos casos de aplicacoes.
						If SEH->EH_APLEMP == "APL"
							SEH->EH_VALIOF := 0
						EndIf	
						SEH->EH_VALSWAP:= 0
						SEH->EH_VALISWP:= 0
						SEH->EH_VALOUTR:= 0
						SEH->EH_VALGAP := 0
						SEH->EH_VALCRED:= 0
						SEH->EH_VALJUR := 0
						SEH->EH_VALJUR2:= 0
						SEH->EH_VALVCLP:= 0
						SEH->EH_VALVCCP:= 0
						SEH->EH_VALVCJR:= 0
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						MsUnlock()
						
						dbSelectArea("SEI")
						dbSetOrder(1)
						dbSeek(xFilial("SEI")+SEH->EH_APLEMP+ Alltrim(SE5->E5_DOCUMEN))
						
						If ( !VerPadrao("581") .And. cPadrao$"581#580" .And. SEI->EI_STATUS=="C" )
							(cAliasSE5)->(dbSkip())
							Loop
						EndIf
						If ( !VerPadrao("586") .And. cPadrao$"586#585" .And. SEI->EI_STATUS=="C" )
							(cAliasSE5)->(dbSkip())
							Loop
						EndIf
						
						aRecsSEI := {}
						While ( SEI->(EI_FILIAL+EI_APLEMP+EI_NUMERO+EI_REVISAO+EI_SEQ)==;
							xFilial("SEI")+SEH->EH_APLEMP+ Alltrim(SE5->E5_DOCUMEN) )
							RecLock("SEH")
							If SEI->EI_MOTBX == "APR"
								If SEI->EI_TIPODOC == "I1"
									SEH->EH_VALIRF := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I2"
									SEH->EH_VALIOF := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I3"
									SEH->EH_VALISWP:= Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I4" 
									SEH->EH_VALOUTR:= Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "I5"
									SEH->EH_VALGAP := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "JR"
									SEH->EH_VALJUR := Abs(SEI->EI_VALOR)
									SEH->EH_VALJUR2:= Abs(SEI->EI_VLMOED2)
								EndIf
								If SEI->EI_TIPODOC == "V1"
									SEH->EH_VALVCLP := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "V2"
									SEH->EH_VALVCCP := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC == "V3"
									SEH->EH_VALVCJR := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC $ "I1/I2/I3/I4/I5/JR/V1/V2/V3"
									If lUsaFlag
										AAdd( aFlagCTB, {"EI_LA","S","SEI",SEI->(Recno()),0,0,0} )
									Else
										AAdd( aRecsSEI, SEI->(Recno()) )
									EndIf
								EndIf
							EndIf
							SEH->(MsUnLock())
							dbSelectArea("SEI")
							dbSkip()
						EndDo
						If ( VerPadrao("582") )
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							EndIf
							nTotDoc	:= DetProva(nHdlPrv,"582","FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
							If LanceiCtb // Vem do DetProva
								For nJ := 1 To Len( aRecsSEI )
									SEI->( dbGoTo( aRecsSEI[nJ] ) )
									RecLock("SEI")
									SEI->EI_LA := "S"
									SEI->( MsUnlock() )
								Next nJ	
							EndIf

							nTotProc += nTotDoc
							nTotal	+=	nTotDoc

							If mv_par12 == 2 
								IF nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
								Endif
								aFlagCTB := {}
							Endif
						EndIf
						
						dbSelectArea("SEH")
						dbSetOrder(1)
						MsSeek(xFilial("SEH")+SubStr(SE5->E5_DOCUMEN,1,8))
						RecLock("SEH")
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						SEH->EH_VALIRF := 0
						// Soh zera valor do IOF para buscar o movimento de IOF (EI_TIPODOC igual a "I2") nos casos de aplicacoes.
						If SEH->EH_APLEMP == "APL"
							SEH->EH_VALIOF := 0
						EndIf
						SEH->EH_VALSWAP:= 0
						SEH->EH_VALISWP:= 0
						SEH->EH_VALOUTR:= 0
						SEH->EH_VALGAP := 0
						SEH->EH_VALCRED:= 0
						SEH->EH_VALJUR := 0
						SEH->EH_VALJUR2:= 0
						SEH->EH_VALVCLP:= 0
						SEH->EH_VALVCCP:= 0
						SEH->EH_VALVCJR:= 0
						SEH->EH_VALREG := 0
						SEH->EH_VALREG2:= 0
						MsUnlock()
						
						dbSelectArea("SEI")
						dbSetOrder(1)
						dbSeek(xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10))
						
						aRecsSEI := {}
						While ( SEI->EI_FILIAL+SEI->EI_APLEMP+SEI->EI_NUMERO+SEI->EI_REVISAO+SEI->EI_SEQ==;
							xFilial("SEI")+SEH->EH_APLEMP+SubStr(SE5->E5_DOCUMEN,1,10) )
							RecLock("SEH")
							If SEI->EI_MOTBX == "NOR"
								If ( SEI->EI_TIPODOC == "RG" )
									SEH->EH_VALREG := Abs(SEI->EI_VALOR)
									SEH->EH_VALREG2:= Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "I1" )
									SEH->EH_VALIRF := Abs(SEI->EI_VALOR)	
								EndIf
								If ( SEI->EI_TIPODOC == "I2" )
									SEH->EH_VALIOF := Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "SW" )
									SEH->EH_VALSWAP:= Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "I3" )
									SEH->EH_VALISWP:= Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "I4" )
									SEH->EH_VALOUTR:= Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "I5" )
									SEH->EH_VALGAP := Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "VL" )
									SEH->EH_VALCRED:= Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "JR" )
									SEH->EH_VALJUR := Abs(SEI->EI_VALOR)
									SEH->EH_VALJUR2:= Abs(SEI->EI_VLMOED2)
								EndIf
								If ( SEI->EI_TIPODOC == "V1" )
									SEH->EH_VALVCLP := Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "V2" )
									SEH->EH_VALVCCP := Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "V3" )
									SEH->EH_VALVCJR := Abs(SEI->EI_VALOR)
								EndIf
								If ( SEI->EI_TIPODOC == "BL" )
									SEH->EH_VALREG := Abs(SEI->EI_VALOR)
									SEH->EH_VALREG2:= Abs(SEI->EI_VLMOED2)
								EndIf
								If ( SEI->EI_TIPODOC == "BC" )
									SEH->EH_VALREG := Abs(SEI->EI_VALOR)
									SEH->EH_VALREG2:= Abs(SEI->EI_VLMOED2)
								EndIf
								If ( SEI->EI_TIPODOC == "BJ" )
									SEH->EH_VALJUR := Abs(SEI->EI_VALOR)
									SEH->EH_VALJUR2:= Abs(SEI->EI_VLMOED2)
								EndIf
								If ( SEI->EI_TIPODOC == "BP" )
									VALOR := Abs(SEI->EI_VALOR)
								EndIf
								If SEI->EI_TIPODOC $ "I1/I2/I3/I4/I5/JR/V1/V2/V3"
									If lUsaFlag
										AAdd( aFlagCTB, {"EI_LA","S","SEI",SEI->(Recno()),0,0,0} )
									Else
										AAdd( aRecsSEI, SEI->(Recno()) )
									EndIf
								EndIf
							EndIf
							SEH->(MsUnLock())
							dbSelectArea("SEI")
							dbSkip()
						EndDo
					EndIf
					
					dbSelectArea("SE5")
					
					//-------------------------------------------------------------
					// Caracteriza-se lancamento os registros com :
					// E5_TIPODOC = brancos
					// E5_TIPODOC = "DB" // Receita Bancaria - FINA200
					// E5_TIPODOC = "OD" // Outras Despesas  - FINA200
					// E5_TIPODOC = "TR" // Transferencia Banc - FINA100
					// E5_TIPODOC = "TE" // Est. Transf Bancar - FINA100
					// E5_TIPODOC = "IT" // Movimento de ITF (Bolivia) - FINA100
					//-------------------------------------------------------------
					If !lX .and. !(SE5->E5_TIPODOC $ "DB/OD/PA/  /TR/TE/IT")
						(cAliasSE5)->(dbSkip())
						Loop
					Endif
					
					If SE5->E5_RATEIO == "S" .And. CtbInUse()
						If SE5->E5_RECPAG = "R"
							If SE5->E5_SITUACA == "E"
								cPadrao := "557"
							Else
							cPadrao := "517"
							EndIf					    
						Else
							If SE5->E5_SITUACA == "E"
								cPadrao := "558"
							Else
							cPadrao := "516"
							EndIf					    
						Endif
					EndIf

					If SE5->E5_TIPO $ MVPAGANT
						// Desposiciona SE2
						SE2->( DbGoTo(0) )
						cPadrao := "513"
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona na natureza.										  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea( "SED" )
					dbSeek(xFilial()+SE5->E5_NATUREZ)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona no banco.											  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SA6")
					dbSetOrder(1)
					dbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)
					
					dbSelectArea("SE5")
					lPadrao:=VerPadrao(cPadrao)
					
					If l370E5R .and. SE5->E5_RECPAG == "R"
						Execblock("F370E5R",.F.,.F.)
					Endif

					If l370E5P .and. SE5->E5_RECPAG == "P"
						Execblock("F370E5P",.F.,.F.)
					Endif
					
					IF lPadrao
						If SE5->E5_RATEIO != "S"
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							If lUsaFlag
								CTBAddFlag(aFlagCTB)
							EndiF
							nTotDoc	:= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)

							If cPadrao == "585" .And. LanceiCtb // Vem do DetProva
								For nJ := 1 To Len( aRecsSEI )
									SEI->( dbGoTo( aRecsSEI[nJ] ) )
									RecLock("SEI")
									SEI->EI_LA := "S"
									SEI->( MsUnlock() )
								Next nJ
							EndIf

							nTotProc	+= nTotDoc
							nTotal		+=	nTotDoc
							
							If mv_par12 == 2 
								IF nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
								Endif
								aFlagCTB := {}
							Endif
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza Flag de Lan‡amento Cont bil		  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If LanceiCtb
								AAdd(aRecsSE5,{ SE5->(Recno()),'FINM030','FK5'}) // Mov.Bancaria
							EndIf
						Else
							If CtbInUse()				// Somente para SIGACTB
								If nHdlPrv <= 0
									a370Cabecalho(@nHdlPrv,@cArquivo)
								EndIf
								RegToMemory("SE5",.F.,.F.)
								If lUsaFlag
									CTBAddFlag(aFlagCTB)
								EndIf
								// Devido a estrutura do programa, o rateio ja eh "quebrado"
								// por documento.                                                          
								F370RatFin(cPadrao,"FINA370",cLote,4," ",4,,,,@nHdlPrv,@nTotDoc,@aFlagCTB)
								lCabecalho := If(nHdlPrv <= 0, lCabecalho, .T.)
								nTotProc	+= nTotDoc
								nTotal		+=	nTotDoc
								
								If mv_par12 == 2 
									If nTotDoc > 0 // Por documento
										If lSeqCorr
											aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
										EndIf
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
									Endif
									aFlagCTB := {}
								Endif

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Flag de Lan‡amento Cont bil	   ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If LanceiCtb
									aAdd(aRecsSE5,{ SE5->(Recno()),'FINM030','FK5'}) // Mov.Bancaria
								EndIf
							EndIf
						Endif
					EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Baixas a Receber 														  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf SE5->E5_RECPAG == "R" .and. (mv_par06 == 1 .or. mv_par06 == 4)				    
		   			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Contabilizacao de Recebimentos Diversos - Tabela SEL³
					//³Executada atraves das movimentacoes no SE5          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	!Empty( SE5->(E5_ORDREC + E5_SERREC) )
							
						// Paises localizados executam a rotina FINA371
						// que contabiliza tambem Ordem de Pago.
						If	cPaisLoc == 'BRA' .and.;
							( SE5->E5_SERREC + SE5->E5_ORDREC ) <> ( cSELSerie + cSELRecibo )

							cSELSerie	:= SE5->E5_SERREC
							cSELRecibo	:= SE5->E5_ORDREC
					
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Controle de contabilizacao.              ³
							//³Percorre e contabiliza todos os registros³
							//³de um recibo.                            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							F370CTBSEL(	cSELSerie,;
												cSELRecibo,;
													@nTotDoc,;
													cLote,;
													@nHdlPrv,;
													@cArquivo,;
													lUsaFlag,;
													@aFlagCTB,;
													@aCT5;
									)

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Separa por ?                                      ³
							//³Acumuladores para a geracao do Documento Contabil.³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If mv_par12 == 1 .and. nTotDoc > 0		// Por Periodo
								nTotal += nTotDoc
							ElseIf mv_par12 == 2 
								If nTotDoc > 0	// Por Documento
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
									nTotDoc := 0 // Inicializa Variavel
								Endif
								aFlagCTB := {}
							ElseIf mv_par12 == 3					// Por Processo
								nTotProc += nTotDoc
							Endif
						EndIf
				   		If AllTrim(SE5->E5_LA) == "S"
							(cAliasSE5)->(dbSkip()) // Nestes casos a movimentacao nao eh contabilizada pelo SE5
							Loop
						EndIf
					Endif
					// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					
				
					lAdiant := .f.
					lEstorno := .F.
					lEstRaNcc := .F.
					lCompens := .F.
					lEstCompens := .F.
					VALOR := 0
					FO1VADI := 0
					aDadosFO1 := {}
   	
					If SE5->E5_TIPODOC == "ES"
						lEstorno := .T.
					Endif
					
					If SE5->E5_TIPODOC == "ES" .and. SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG
						lEstRaNcc := .T.
					Endif
					
					If SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG
						lAdiant := .T.
					Endif
					
					If  SE5->E5_TIPODOC == "BA" .and. SE5->E5_MOTBX == "CMP"
						lCompens := .T.
					Endif

					If SE5->E5_TIPODOC == "ES" .and. SE5->E5_MOTBX == "CMP"
						lEstCompens := .T.
					Endif
					
					// Registros gerados pelo SIGALOJA - Pgto Dinheiro 
					// Contabilizar apenas quando E5_TIPODOC = 'VL' e E5_MOTBX == 'NOR'
					If SE5->E5_TIPODOC == 'BA' .AND. SE5->E5_MOTBX == 'LOJ' .AND. (SE5->E5_TIPO == cMvSimb1 .OR. SE5->E5_MOEDA == cMvSimb1)
						AADD(aRecsSE5, {SE5->(RECNO()), 'FINM010' ,'FK1'} )
						(cAliasSE5)->(dbSkip())
						Loop
					EndIf
					
					// Despreza inclusao de RA que sera contabilizado pelo SE1
					If SE5->E5_TIPODOC == "RA" .and. SE5->E5_TIPO $ MVRECANT
						aAdd(aRecsSE5, {SE5->(RECNO()), 'FINM010' ,'FK1'} )
						(cAliasSE5)->(dbSkip())
						Loop
					Endif

					// Despreza baixas por compensacao do titulo principal, para nao duplicar.
					If SE5->E5_TIPODOC == "CP" .and. SE5->E5_MOTBX == "CMP"
					    lCompens := .T.
					    aAdd(aRecsSE5, {SE5->(RECNO()), 'FINM010', 'FK1'} ) //Baixas a Receber.
					    (cAliasSE5)->(dbSkip())
						 Loop
					Endif
										
  					// Despreza estorno de compensacao do titulo de antecipação, para nao duplicar.
					If SE5->E5_TIPODOC == "ES" .and. SE5->E5_MOTBX == "CMP" .and. (SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)
						aAdd(aRecsSE5, {SE5->(RECNO()), 'FINM020', 'FK2'} ) //Baixas a Pagar.
						(cAliasSE5)->(dbSkip())
						Loop
					Endif

					// Despreza movimento totalizador de Baixa Automática por Lote - (MV_BXCNAB = 'S')
					If EMPTY(SE5->(E5_PREFIXO+E5_NUMERO+E5_TIPO)) .AND. !EMPTY(E5_LOTE) .AND. E5_TIPODOC == 'VL'
						(cAliasSE5)->(dbSkip())
						LOOP
					EndIF

					If (lAdiant .or. lEstorno) .and. !lEstRaNcc
						dbSelectArea("SE2")
						dbSetOrder(1)
						If !(MsSeek(xFilial("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
								If SE5->E5_MOTBX == "CMP" .and. !(MsSeek(SE5->E5_FILORIG+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Localizada inconsistˆncia no arquivo SE5. A fun‡„o fa370conc	 ³
								//³ pergunta se o usu rio quer continuar ou abandonar.				 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !__lSchedule .And. !FA370CONC()  .And. !lMultiThr
									Return .F.
								Endif
								dbSelectArea(cAliasSE5)
								(cAliasSE5)->(dbSkip())
								Loop
							Endif
						EndIf
					Else
						dbSelectArea( "SE1" )
						dbSetOrder( 2 )
						
						cFilorig := xFilial("SE1")
						If !(MsSeek( cFilOrig +SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO ))
							If !Empty(SE5->E5_FILORIG)
								cFilOrig := SE5->E5_FILORIG
							Endif
						Endif
						
						If !(MsSeek( cFilOrig +SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO ))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Localizada inconsistˆncia no arquivo SE5. A fun‡„o fa370conc	 ³
							//³ pergunta se o usu rio quer continuar ou abandonar.				 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !lCompens .and. !(cChE5Comp == cFilOrig +SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO .and. SE5->E5_LA = cLa)	
								If !__lSchedule .And. !FA370CONC()  .And. !lMultiThr
									Return .F.
								Endif
							EndIf
							dbSelectArea(cAliasSE5)
							(cAliasSE5)->(dbSkip())
							Loop
						Else
							//Carregar variável FO1VADI
							If Alltrim(SE5->E5_MOTBX) == "LIQ"
								cNumLiq := Alltrim(SE5->E5_DOCUMEN)
								If !Empty(SE5->E5_IDORIG)
									dbSelectArea("FO0")
									dbSetOrder(2)
									dbSeek( xFilial("FO0") + cNumLiq + SE5->E5_CLIFOR + SE5->E5_LOJA )
									aDadosFO1 := F460AbFO1(FO0->FO0_PROCES,FO0->FO0_VERSAO,SE5->E5_IDORIG)
									If Len(aDadosFO1) > 0
										FO1VADI := aDadosFO1[1,2]
									EndIf
								EndIf
							EndIf
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Carrega variavies para contabilizacao dos    ³
							//³ abatimentos (impostos da lei 10925).         ³			
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						 	dbSelectArea("__SE1")
					 		dbSetOrder( 1 )
							__SE1->(MsSeek(cFilOrig +SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA)))
							While __SE1->(!EOF()) .And.;
							      __SE1->(E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA) ==;
							      (cFilOrig + SE5->(E5_PREFIXO + E5_NUMERO + E5_PARCELA))
								If __SE1->E1_TIPO == MVPIABT
									VALOR5 := __SE1->E1_VALOR			
								ElseIf __SE1->E1_TIPO == MVCFABT
									VALOR6 := __SE1->E1_VALOR
								ElseIf __SE1->E1_TIPO == MVCSABT
									VALOR7 := __SE1->E1_VALOR						
								Endif			
								__SE1->(dbSkip())
							Enddo
						Endif
					Endif
					
					nPis:=0
					nCofins:=0
					nCsll:=0
					nVretPis:=0
					nVretCof:=0
					nVretCsl:=0
					VARIACAO := 0
	
					If (lAdiant .or. lEstorno) .and. !lEstRaNcc
						nValLiq	:= SE2->E2_VALLIQ
						nDescont := SE2->E2_DESCONT
						nJuros	:= SE2->E2_JUROS
						nMulta	:= SE2->E2_MULTA
						nCorrec	:= SE2->E2_CORREC
						If lPccBaixa
							nPis		:= SE2->E2_PIS
							nCofins	:= SE2->E2_COFINS
							nCsll		:= SE2->E2_CSLL
							nVretPis := SE2->E2_VRETPIS
							nVretCof := SE2->E2_VRETCOF
							nVretCsl := SE2->E2_VRETCSL
						Endif
					Else
						nValLiq	:= SE1->E1_VALLIQ
						nDescont := SE1->E1_DESCONT
						nJuros	:= SE1->E1_JUROS
						nMulta	:= SE1->E1_MULTA
						nCorrec	:= SE1->E1_CORREC
						cSitOri  := SE1->E1_SITUACA
					Endif
					
					dbSelectArea( "SE5" )
					nVl:=nDc:=nJr:=nMt:=VARIACAO:=0
					lTitulo := .F.
					cSeq	  :=	SE5->E5_SEQ
					cBanco  := " "
					nRegSE5 := 0
					nRegOrigSE5 := 0
					nPisBx := 0
					nCofBx := 0
					nCslBx := 0
				
					dbSelectArea("SE5")
						
					If  SE5->E5_TIPODOC $ "BA|VL|V2|ES|LJ|CP"
						cBanco	:= SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA
						nRegSE5	:= SE5->(Recno())
						lMultnat:= SE5->E5_MULTNAT == "1"
						cSeqSE5	:= SE5->E5_SEQ
						nVl		:= E5_VALOR
						nDc 	:= SE5->E5_VLDESCO
						nJr		:= SE5->E5_VLJUROS
						nMt		:= SE5->E5_VLMULTA
						VARIACAO := SE5->E5_VLCORRE
						cSitCob	:= " "
						If !Empty(SE5->E5_SITCOB)
							cSitCob := SE5->E5_SITCOB
						Endif

						// Carrega as variaveis VALOR da Compensacao CR
						If lCompens
							aAreaATU := SE5->(GetArea())
							SE5->(DbSetOrder(2)) //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_DATA+E5_CLIFOR+E5_LOJA+E5_SEQ
							If SE5->(MsSeek(SE5->(E5_FILIAL+"CP"+PadR(E5_DOCUMEN,nTamDoc)+DTOS(E5_DATA)+E5_FORNADT+E5_LOJAADT+E5_SEQ))) .And. SE5->E5_SITUACA != 'C'
								
								aAreaSE1 := SE1->(GetArea())
								SE1->(DBSetOrder(1))	// "E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
								SE1->(DBSEEK(XFILIAL('SE1',SE5->E5_FILORIG)+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)))
								REGVALOR := SE1->(Recno()) // Variavel para usuario reposicionar o registro do SE1

								If ASCAN(aCmpCRSE1,{|e| e == REGVALOR}) == 0
									AADD(aCmpCRSE1,REGVALOR)
									nVlDecresc := SE1->E1_DECRESC
									nVlAcresc  := SE1->E1_ACRESC
								Else
									nVlDecresc := 0
									nVlAcresc  := 0
								EndIf
								RestArea(aAreaSE1)

								// Disposição dos valores nas variáveis difere da contabilização online
								// http://tdn.totvs.com/display/PROT/FIN0003_LPAD_Variaveis_de_contabilizacao_da_compensacao_CR
								VALOR  := SE5->E5_VALOR
								VALOR2 := SE5->E5_VRETISS
								VALOR3 := SE5->E5_VRETINS
								VALOR4 := SE5->E5_VRETIRF
								VALOR5 := SE5->E5_VRETPIS
								VALOR6 := SE5->E5_VRETCOF
								VALOR7 := SE5->E5_VRETCSL
								VALOR8 := nVlAcresc
								VALOR9 := nVlDecresc
							EndIf
							RestArea(aAreaATU)
						EndIf

						If lPccBaixa
							IF Empty(SE5->E5_PRETPIS)
								nPisBx := SE5->E5_VRETPIS
								nCofBx := SE5->E5_VRETCOF
								nCslBx := SE5->E5_VRETCSL
							Endif
						Endif

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza Flag de Lan‡amento Cont bil		  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lTitulo := .T.
						If SE5->E5_TABORI == "FK1"
							AAdd( aRecsSE5, {SE5->(Recno()),'FINM010','FK1'} ) //baixa a receber
						Else
							AAdd( aRecsSE5, {SE5->(Recno()),'FINM020','FK2'} ) //  estorno de Baixas a pagar
						Endif
						If lUsaFlag
							CTBAddFlag(aFlagCTB)
						EndIf
					Endif
					
					IF lTitulo
						IF (lAdiant .or. lEstorno) .and. !lEstRaNcc
					
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Protecao provisoria: lTitulo .T. sem SE2   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	                    	IF SE2->(!EOF()) .AND. SE2->(!BOF())
								Reclock( "SE2" )
								Replace E2_VALLIQ  With nVl
								Replace E2_DESCONT With nDc
								Replace E2_JUROS	 With nJr
								Replace E2_MULTA	 With nMt
								Replace E2_CORREC  With VARIACAO
								IF lPccBaixa
									Replace E2_PIS		With nPisBx
									Replace E2_COFINS	With nCofBx
									Replace E2_CSLL	With nCslBx
									Replace E2_VRETPIS	With nPisBx
									Replace E2_VRETCOF	With nCofBx
									Replace E2_VRETCSL	With nCslBx
								ENDIF
								SE2->(MsUnlock())
						    ENDIF

						ELSE

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Protecao provisoria: lTitulo .T. sem SE1   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	                    	IF SE1->(!EOF()) .AND. SE1->(!BOF())
								Reclock( "SE1" )
								Replace E1_VALLIQ  With nVl
								Replace E1_DESCONT With nDc
								Replace E1_JUROS   With nJr
								Replace E1_MULTA   With nMt
								Replace E1_CORREC  With VARIACAO
								If !Empty(cSitCob)
									Replace E1_SITUACA With cSitCob
								Endif
								SE1->( MsUnlock())
							ENDIF
						
						ENDIF
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona no cliente/fornecedor 						  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (lAdiant .or. lEstorno) .and. !lEstRaNcc
							dbSelectArea("SA2")
							dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
							dbSelectArea( "SED" )
							dbSeek( xFilial()+SE2->E2_NATUREZ )
						Else
							dbSelectArea( "SA1" )
							dbSeek( cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA )
							dbSelectArea( "SED" )
							dbSeek( cFilial+SE1->E1_NATUREZ )
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona no banco. 										  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea( "SA6" )
						dbSetOrder(1)
						dbSeek( xFilial("SA6")+cBanco)
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona o arquivo SE5 para que os lan‡amentos  ³
						//³ cont beis possam localizar o motivo da baixa.	  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lAdiant .and. !lEstCompens
							cPadrao := "530"
						ElseIf lEstCompens  //Estorno Compensacao Pagar
							cPadrao := "589"	
						ElseIf lEstRaNcc
							cPadrao := '527'
						Elseif lEstorno
							cPadrao := "531"
						ElseIf lCompens
							cPadrao := "596"
							VARIACAO := __SE1->E1_CORREC
						Else
							dbSelectArea( "SE1" )
							If cPaisLoc == "CHI" .And. SE5->E5_MOTBX == "DEV"
								cPadrao := "574"
							Else
								cPadrao := fa070Pad()
							EndIf
						Endif
						lPadrao 	:= VerPadrao(cPadrao)
						lCtbPls 	:= ( substr(SE1->E1_ORIGEM,1,3) == "PLS"  .or. !empty(SE1->E1_PLNUCOB) )
						lPadraoCc 	:= VerPadrao("536") //Rateio por C.Custo de MultiNat C.Receber
						lPadraoCcE 	:= VerPadrao("539") //Estorno do rateio C.Custo de MultiMat CR
						
						IF lPadrao .and. !lCtbPls
						
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							//Contabilizando estorno de C.Pagar
							If lEstorno
								cChaveSev := RetChaveSev("SE2")+"2"+cSeqSE5
								cChaveSez := RetChaveSev("SE2",,"SEZ")
							Else
								cChaveSev := RetChaveSev("SE1")+"2"+cSeqSE5
								cChaveSez := RetChaveSev("SE1",,"SEZ")
							Endif
							
							DbSelectArea("SEV")
							dbSetOrder(2)
							// Se utiliza multiplas naturezas, contabiliza pelo SEV
							If  lMultNat .And. MsSeek(cChaveSev)
								dbSelectArea("SE1")
								nRecSe1 := Recno()
								DbGoBottom()
								DbSkip()
								dbSelectArea("SE2")
								nRecSe2 := Recno()
								DbGoBottom()
								DbSkip()
								
								DbSelectArea("SEV")
								
								While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
									EV_LOJA+EV_IDENT+EV_SEQ) == cChaveSev .And. !Eof()
									
									//Se estou contabilizando um estorno, trata-se de um C. Pagar,
									//So vou contabilizar os EV_SITUACA == E
									If (lEstorno .and. !(SEV->EV_SITUACA == "E")) .or. ;
										(!lEstorno .and. (SEV->EV_SITUACA == "E"))
										//Se nao for um estorno, nao devo contabilizar o registro se
										//EV_SITUACA == E
										dbSkip()
										Loop
									ElseIf lEstorno
										//O lancamento a ser considerado passa a ser o do estorno
										lPadraoCC := lPadraoCCE
									Endif
									
									If SEV->EV_LA != "S"
										dbSelectArea( "SED" )
										MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
										dbSelectArea("SEV")
										If SEV->EV_RATEICC == "1" .and. lPadraoCC .and. lPadrao // Rateou multinat por c.custo
											dbSelectArea("SEZ")
											dbSetOrder(4)
											MsSeek(cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5) // Posiciona no arquivo de Rateio C.Custo da MultiNat
											While SEZ->(!Eof()) .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
												EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT+EZ_SEQ) == cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5
												
												//Se estou contabilizando um estorno, trata-se de um C. Pagar,
												//So vou contabilizar os EZ_SITUACA == E
												//Se nao for um estorno, nao devo contabilizar o registro se
												//EZ_SITUACA == E
												If (lEstorno .and. !(SEZ->EZ_SITUACA == "E")) .or. ;
													(!lEstorno .and. (SEZ->EZ_SITUACA == "E"))
													SEZ->(dbSkip())
													Loop
												Endif
												If SEZ->EZ_LA != "S"
		
													aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
													//O lacto padrao fica:
													//536 - Rateio multinat com c.custo C.Receber
													//539 - Estorno de Rat. Multinat C.Custo C.Pagar
													cPadraoCC := If(SEZ->EZ_SITUACA == "E","539","536")
													VALOR := SEZ->EZ_VALOR
													nTotDoc	+=	DetProva(nHdlPrv,cPadraoCC,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
	
													If LanceiCtb // Vem do DetProva
														If !lUsaFlag
															RecLock("SEZ")
															SEZ->EZ_LA    := "S"
															MsUnlock( )
														EndIf
													ElseIf lUsaFlag
														If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
															aFlagCTB := Adel(aFlagCTB,nPosReg)
															aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
														Endif
													Endif
	
												Endif
												SEZ->(dbSkip())
											Enddo
											DbSelectArea("SEV")
										Else
											If lUsaFlag
												aAdd(aFlagCTB,{"EV_LA","S","SEV",SEV->(Recno()),0,0,0})
											EndIf
				  						    nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
										Endif
										
										If LanceiCtb // Vem do DetProva
											If !lUsaFlag
												RecLock("SEV")
												SEV->EV_LA    := "S"
												MsUnlock( )
											EndIf
										ElseIf lUsaFlag
											If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
												aFlagCTB := Adel(aFlagCTB,nPosReg)
												aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
											Endif
										Endif

									Endif
									DbSelectArea("SEV")
									DbSkip()
									VALOR := 0
								Enddo
								nTotProc	+=	nTotDoc // Totaliza por processo
								nTotal  	+=	nTotDoc
								
								If mv_par12 == 2 
									If nTotDoc > 0 // Por documento
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
										nTotDoc := 0
									Endif
									aFlagCTB := {}
								Endif
						
								dbSelectArea("SE2")
								DbGoto(nRecSe2)
								
								dbSelectArea("SE1")
								DbGoto(nRecSe1)
							Else
								dbSelectArea("SEV")
								DbGoBottom()
								DbSkip()
								DbSelectArea("SE1")
								If SE1->E1_TIPO == MVPIABT
									VALOR5 := SE1->E1_VALOR			
								ElseIf SE1->E1_TIPO == MVCFABT
									VALOR6 := SE1->E1_VALOR
								ElseIf SE1->E1_TIPO == MVCSABT
									VALOR7 := SE1->E1_VALOR			
								ElseIf SE1->E1_SITUACA $ '1|H'	// Situação de Cobrança: Cobrança Simples
									VALOR := SE1->E1_VALOR
								Endif	
								If lCompens
									STRLCTPAD := SE5->E5_DOCUMEN
								EndIf

								nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
								nTotProc	+= nTotDoc
								nTotal		+=	nTotDoc
								If mv_par12 == 2 
									If nTotDoc > 0 // Por documento
										Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
									Endif
									aFlagCTB := {}
								Endif
							Endif
						Endif

						VALOR2 := 0
						VALOR3 := 0
						VALOR4 := 0
						VALOR5 := 0
						VALOR6 := 0
						VALOR7 := 0
						VALOR8 := 0
						VALOR9 := 0
						REGVALOR := 0
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Devolve a posi‡„o original do arquivo  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If nRegOrigSE5 > 0
							SE5->(dbGoTo(nRegOrigSE5))
						Endif
						If !lAdiant .and. !lEstorno
							dbSelectArea("SE1")
							If !Eof() .And. !Bof()
								Reclock( "SE1" )
								Replace E1_VALLIQ  With nValliq
								Replace E1_DESCONT With nDescont
								Replace E1_JUROS	 With nJuros
								Replace E1_MULTA	 With nMulta
								Replace E1_CORREC  With nCorrec
								Replace E1_SITUACA With cSitOri
								SE1->( MsUnlock( ) )
							EndIF
						Else
							dbSelectArea("SE2")
							If !Eof() .And. !Bof()
								Reclock( "SE2" )
								Replace E2_VALLIQ  With nValliq
								Replace E2_DESCONT With nDescont
								Replace E2_JUROS	 With nJuros
								Replace E2_MULTA	 With nMulta
								Replace E2_CORREC  With nCorrec
								If lPccBaixa
									Replace E2_PIS		With nPis
									Replace E2_COFINS	With nCofins
									Replace E2_CSLL	With nCsll
									Replace E2_VRETPIS	With nVretPis
									Replace E2_VRETCOF	With nVretCof
									Replace E2_VRETCSL	With nVretCsl
								Endif
								SE2->( MsUnlock())
							EndIf
						Endif
					Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Baixas a Pagar															  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ElseIf SE5->E5_RECPAG == "P" .and.  (mv_par06 == 2 .or. mv_par06 == 4)

					dbSelectArea( "SE5" )
					VALOR 		:= 0
					VALOR2		:= 0
					VALOR3		:= 0
					VALOR4		:= 0
					VALOR5		:= 0
					
					lAdiant		:= .F.
					lEstorno	:= .F.
					lEstPaNdf	:= .F.
					lEstCart2	:= .F.
					lCompens	:= .F.
					lEstCompens	:= .F.
					
					IF SE5->E5_TIPODOC == "ES"
						lEstorno := .T.
					Endif
						
					IF SE5->E5_TIPODOC == "E2"
						lEstCart2 := .T.
					Endif
						
					IF SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. SE5->E5_TIPODOC == "ES"
						lEstPaNdf := .T.
					Endif
						
					IF SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG
						lAdiant := .T.
					Endif
						
					If SE5->E5_TIPODOC == "ES" .and. SE5->E5_MOTBX == "CMP"
						lEstCompens := .T.
					Endif

					// Despreza baixas do titulo de antecipação, para nao duplicar.
					If SE5->E5_TIPODOC == "BA" .and. SE5->E5_MOTBX == "CMP"
						AAdd( aRecsSE5, {SE5->(Recno()),'FINM020','FK2'} ) // Baixas a pagar.
						(cAliasSE5)->(dbSkip())
						Loop
					Endif
						
					// Despreza inclusao de PA que sera contabilizado pelo SE2
					If SE5->E5_TIPODOC == "PA" .and. SE5->E5_TIPO $ MVPAGANT
						(cAliasSE5)->(dbSkip())
						Loop
					Endif

					// Contabiliza baixas do titulo principal.
					If SE5->E5_TIPODOC == "CP" .and. SE5->E5_MOTBX == "CMP"
						lCompens := .T.
					Endif

					//Nao serao contabilizadas os movimentos de troco de vendas do sigaloja
					If SE5->E5_TIPODOC $ "VL#TR" .AND. !Empty(SE5->E5_NUMERO) .and. SE5->E5_MOEDA == "TC"
			  			If Upper(AllTrim(SE5->E5_NATUREZ)) $ Upper(cNatTroc) //"Troco"  
			        		(cAliasSE5)->(dbSkip())
							Loop
						EndIf
					EndIf

					// Despreza estorno de compensacao do titulo principal, para nao duplicar.
					If SE5->E5_TIPODOC == "ES" .and. SE5->E5_MOTBX == "CMP" .and. !(SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG)
						AAdd( aRecsSE5, {SE5->(Recno()),'FINM010','FK1'} ) // Baixas a receber.
						(cAliasSE5)->(dbSkip())
						Loop
					Endif

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Apenas contabilza se :                                       ³
					//³ For realmente uma baixa de contas a PAGAR                    ³
					//³ mv_ctbaixa diferente de "C" - Cheque                         |
					//³ Ou se for igual a C e for uma baixa no banco caixa			  |
					//³______________________________________________________________|
					

					If !lAdiant .and. !lEstorno .and. !lEstCart2
						If cCtBaixa == "C" .And. SE5->E5_MOTBX == "NOR" .And.;
							If(cPaisLoc == 'BRA', Empty(SE5->E5_AGLIMP), .T.) .And.;
							!(Substr(SE5->E5_BANCO,1,2)=="CX" .or. SE5->E5_BANCO$cCarteira)
							dbSelectArea(cAliasSE5)
							(cAliasSE5)->(dbSkip())
							Loop
						Endif
					Endif
						
					// A baixa de adiantamento ou estorno de baixa a receber gera registro a pagar
						
					If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
						dbSelectArea("SE1")
						dbSetOrder(2)
						If !(MsSeek(xFilial("SE1")+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
							If SE5->E5_MOTBX == "CMP" .and. !(MsSeek(SE5->E5_FILORIG+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO))
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Localizada inconsistˆncia no arquivo SE5. A fun‡„o fa370conc	 ³
								//³ pergunta se o usu rio quer continuar ou abandonar.				 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If (!lEstCompens ) // verifica se a compensação do Adiantamento foi contabilizado RECPAG= R e TIPODOC= BA 
									If !__lSchedule .And. !FA370CONC()  .And. !lMultiThr
										Return .F.
									Endif
								Else
									cChE5Comp:= SE5->E5_FILORIG+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO
									cLA		:= SE5->E5_LA
									
								EndIf
								dbSelectArea(cAliasSE5)
								(cAliasSE5)->(dbSkip())
								Loop
							EndIf
						Endif
					Else
						dbSelectArea( "SE2" )
						dbSetOrder( 1 )
						cFilorig := xFilial("SE2")
						If !(MsSeek( cFilOrig +SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
							If !Empty(SE5->E5_FILORIG)
								cFilOrig := SE5->E5_FILORIG   
							Else
							   cFilOrig := SE5->E5_FILIAL		
							Endif
						Endif
						
						If !(MsSeek( cFilOrig +SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))
							//Se for o totalizador da baixa automatica, nao pode ser gerado mensagem
							If lBxCnab .and. AllTrim(SE5->E5_ORIGEM) $ "FINA090|FINA091|FINA300|FINA430|FINA740|FINA750" .AND. SE5->E5_TIPODOC == "VL" .AND. !Empty(SE5->E5_LOTE) .AND. Empty(SE5->E5_TIPO + SE5->E5_DOCUMEN + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_CLIFOR + SE5->E5_LOJA)
								dbSelectArea(cAliasSE5)
								(cAliasSE5)->(dbSkip())
								Loop
							EndIf
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Localizada inconsistˆncia no arquivo SE5. A fun‡„o fa370conc	 ³
							//³ pergunta se o usu rio quer continuar ou abandonar.				 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !__lSchedule .And. !FA370CONC()  .And. !lMultiThr
								Return .F.
							Endif
							dbSelectArea(cAliasSE5)
							(cAliasSE5)->(dbSkip())
							Loop
						Endif
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Nao contabiliza titulos de impostos aglutinados com origem na rotina FINA378 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lAGP .and. !lMvAGP  // Neste caso o Parâmetro de contabilização dos impostos aglutinados inverte a operação
							If	AllTrim( Upper( SE2->E2_ORIGEM ) ) == "FINA378" .And. SE2->E2_PREFIXO == "AGP"	// Aglutinacao Pis/Cofins/Csll
								(cAliasSE5)->(dbSkip())
								Loop
							Endif
						ElseIf AllTrim(SE2->E2_CODRET) == "5952" .And. ( (SE2->E2_PREFIXO != "AGP" .And. !Empty(SE2->E2_TITPAI)) .And. AllTrim(SE2->E2_ORIGEM) != "FINA378") .And. (lF370ChkAgp .And. F370ChkAgp())
							RecLock("SE5", .F.)
							SE5->E5_LA := 'S'
							SE5->(MsUnLock())
							(cAliasSE5)->(dbSkip())
							Loop
						EndIf					
					Endif
						
					nPis:=0
					nCofins:=0
					nCsll:=0
					nVretPis:=0
					nVretCof:=0
					nVretCsl:=0
					
					If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
						nValLiq	:= SE1->E1_VALLIQ
						nDescont := SE1->E1_DESCONT
						nJuros	:= SE1->E1_JUROS
						nMulta	:= SE1->E1_MULTA
						nCorrec	:= SE1->E1_CORREC
					Else
						nValLiq	:= SE2->E2_VALLIQ
						nDescont := SE2->E2_DESCONT
						nJuros	:= SE2->E2_JUROS
						nMulta	:= SE2->E2_MULTA
						nCorrec	:= SE2->E2_CORREC
						If lPccBaixa
							nPis		:= SE2->E2_PIS
							nCofins	:= SE2->E2_COFINS
							nCsll		:= SE2->E2_CSLL
							nVretPis := SE2->E2_VRETPIS
							nVretCof := SE2->E2_VRETCOF
							nVretCsl := SE2->E2_VRETCSL
						Endif
					Endif
					
					dbSelectArea( "SE5" )
					nVl:=nDc:=nJr:=nMt:=VARIACAO:=0
					lTitulo := .F.
					cSeq	  :=	SE5->E5_SEQ
					cBanco  := " "
					nRegSE5 := 0
					nRegOrigSE5 := 0
					
					STRLCTPAD := SE5->E5_DOCUMEN
					If SE5->(FieldPos("E5_FORNADT")) > 0
						CODFORCP := SE5->E5_FORNADT
						LOJFORCP := SE5->E5_LOJAADT
					EndIf
		
					dbSelectArea("SE5")
					
					nPisBx := 0
					nCofBx := 0
					nCslBx := 0
					
					If	SE5->E5_TIPODOC $ "BA/VL/V2/ES/LJ/E2/CP"
						cBanco	 := SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA
						cCheque	 := SE5->E5_NUMCHEQ          
						nRegSE5	 := SE5->(Recno())
						lMultnat := SE5->E5_MULTNAT == "1"
						cSeqSE5	 := SE5->E5_SEQ
						nVl		 := SE5->E5_VALOR
						nDc 	 := SE5->E5_VLDESCO
						nJr		 := SE5->E5_VLJUROS
						nMt		 := SE5->E5_VLMULTA
						VARIACAO := SE5->E5_VLCORRE
						
						If lCompens
							aAreaATU := SE5->(GetArea())
							SE5->(DbSetOrder(2)) //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_DATA+E5_CLIFOR+E5_LOJA+E5_SEQ
							If SE5->(MsSeek(SE5->(E5_FILIAL+"BA"+PadR(E5_DOCUMEN,nTamDoc)+DTOS(E5_DATA)+E5_FORNADT+E5_LOJAADT+E5_SEQ))) .And. SE5->E5_SITUACA != 'C'
									
								aAreaSE2 := SE2->(GetArea())
								SE2->(DBSetOrder(1))	// "E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"
								SE2->(DBSEEK(XFILIAL('SE2',SE5->E5_FILORIG)+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
								nVlDecresc := SE2->E2_DECRESC
								nVlAcresc  := SE2->E2_ACRESC
								REGVALOR := SE2->(Recno()) // Variavel para usuario reposicionar o registro do SE2
								RestArea(aAreaSE2)
	
								// Disposição dos valores nas variáveis difere da contabilização online
								// http://tdn.totvs.com/display/PROT/FIN0020_LPAD_Variaveis_de_contabilizacao_da_compensacao_CP
								VALOR  	:= SE5->E5_VALOR
								VALOR2 	:= nVlAcresc
								VALOR3 	:= nVlDecresc
								VALOR4 	:= SE5->E5_VLCORRE
								VARIACAO := SE5->E5_VLCORRE
							EndIf
							RestArea(aAreaATU)
						EndIf						

						If lPccBaixa
							IF Empty(SE5->E5_PRETPIS)
								nPisBx := SE5->E5_VRETPIS
								nCofBx := SE5->E5_VRETCOF
								nCslBx := SE5->E5_VRETCSL
							Endif
						Endif

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza Flag de Lan‡amento Cont bil		  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
						nRegAnt := SE5->(Recno())
						If (aScan(aRecsSE5,{|x| x[1]==nRegAnt}) == 0) 
							IF SE5->E5_TIPODOC $ "BA|VL|V2|ES|LJ|CP"
								If Alltrim(SE5->E5_TIPODOC) == "ES" .And. !Empty(SE5->E5_NUMCHEQ)
									AAdd( aRecsSE5, {SE5->(Recno()),'FINM030','FK5'} ) //  estorno de cheque
								Else 
									If SE5->E5_TABORI == "FK1" .OR. (SE5->E5_RECPAG == "R" .and. SE5->E5_TIPODOC <> "ES" .and. !SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG) .Or. (SE5->E5_RECPAG == "P" .and. SE5->E5_TIPODOC == "ES" .and. !SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG);
										.OR. (SE5->E5_RECPAG == "P" .and. SE5->E5_TIPODOC <> "ES" .and. SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG)  

										AAdd( aRecsSE5, {SE5->(Recno()),'FINM010','FK1'} ) //baixa a receber
									Else
										AAdd( aRecsSE5, {SE5->(Recno()),'FINM020','FK2'} ) //  estorno de Baixas a pagar
									Endif
								EndIf	
							Else
								AAdd( aRecsSE5, {SE5->(Recno()),'',''} ) //Valores acessórios
							EndIf
						Endif

						If lUsaFlag
							CTBAddFlag(aFlagCTB)
						EndIf

						// Efetuo o Skip para verificar a continuação do bordero
						If !Empty( cNumBor ) 
							(cAliasSE5)->(dbSkip())
							lAvancaReg := .F.

							If (cAliasSE5)->(!Eof()) .AND. (&cCondWhile) 
								cProxBor := If(cProxBor == ALLTRIM((cAliasSE5)->E5_DOCUMEN), cProxBor, " ")
							else
								cProxBor := " "
							EndIf
							//se numero do bordero for igual mas data diferente da data de contabilizacao entao limpa cProxBor
							If ! Empty( cProxBor ) .And. ! Empty( cNumBor ) .And. ( cProxBor == cNumBor ) .And. &(cAliasSE5+"->"+cCampo) != dDataCtb  
								cProxBor := " "
							Endif
						EndIf
						
						lTitulo := .T.
					EndIf
					
					If lTitulo
						If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Protecao provisoria: lTitulo .T. sem SE1   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	                    	IF SE1->(!EOF()) .AND. SE1->(!BOF())
								Reclock( "SE1" )
								Replace E1_VALLIQ  With nVl
								Replace E1_DESCONT With nDc
								Replace E1_JUROS	 With nJr
								Replace E1_MULTA	 With nMt
								Replace E1_CORREC  With VARIACAO
								SE1->( MsUnlock())
							ENDIF
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Protecao provisoria: lTitulo .T. sem SE2   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	                    	IF SE2->(!EOF()) .AND. SE2->(!BOF())
								Reclock( "SE2" )
								Replace E2_VALLIQ  With nVl
								Replace E2_DESCONT With nDc
								Replace E2_JUROS	 With nJr
								Replace E2_MULTA	 With nMt
								Replace E2_CORREC  With VARIACAO
								If lPccBaixa
									Replace E2_PIS		With nPisBx
									Replace E2_COFINS	With nCofBx
									Replace E2_CSLL	With nCslBx
									Replace E2_VRETPIS	With nPisBx
									Replace E2_VRETCOF	With nCofBx
									Replace E2_VRETCSL	With nCslBx
								Endif
								SE2->(MsUnlock())
							ENDIF
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona no fornecedor. 									  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
							dbSelectArea( "SA1" )
							dbSeek( cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA )
							dbSelectArea( "SED" )
							dbSeek( cFilial+SE1->E1_NATUREZ )
						Else
							dbSelectArea("SA2")
							dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
							dbSelectArea( "SED" )
							dbSeek( xFilial()+SE2->E2_NATUREZ )
							if !Empty( SE2->E2_NUMBOR )
								nValorTotal += SE2->E2_VALLIQ
							endif
						Endif
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona no banco.											  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea( "SA6" )
						dbSetOrder(1)
						dbSeek( cFilial+cBanco)
						dbSelectArea( "SE5" )
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona o arquivo SE5 para que os lan‡amentos  ³
						//³ cont beis possam localizar o motivo da baixa. 	  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							
						If lEstorno .and. lEstPaNdf
							cPadrao := "531"
						ElseIf lEstCompens  //Estorno Compensacao Receber
							cPadrao := "588"									
						ElseIf lEstorno
							cPadrao := "527"
							If SE1->E1_SITUACA $ '1|H'	// Situação de Cobrança: Cobrança Simples
								VALOR := SE1->E1_VALOR
							EndIf
						Elseif lEstCart2
							cPadrao := "540"
						ElseIf lAdiant
							dbSelectArea( "SE1" )
							cPadrao := fa070Pad()
						Elseif lCompens
							cPadrao := "597"
						Else
							cPadrao := Iif(Empty(SE5->E5_DOCUMEN) .Or. SE5->E5_MOTBX $ "PCC|LIQ|IRF" .Or. "FINA080" $ SE5->E5_ORIGEM,"530","532")
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Ponto de Entrada para validar lançamento padrão.³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If l370BORD
								cPadrao := Execblock("F370BORD",.F.,.F.,{cNumBor})
							EndIf
							
							// Totalizo por Bordero
							If cPadrao = "532" .And. mv_par13 = 2
								nBordero 	+= SE2->E2_VALLIQ
								nTotBord 	+= SE2->E2_VALLIQ
								nBordDc		+= SE2->E2_DESCONT
								nBordJr		+= SE2->E2_JUROS
								nBordMt		+= SE2->E2_MULTA
								nBordCm		+= SE2->E2_CORREC
							Endif
						
						Endif
						lPadrao 	:= VerPadrao(cPadrao)
						lCtbPls 	:= ( substr(SE2->E2_ORIGEM,1,3) == "PLS" .or. !empty(SE2->E2_PLLOTE) )
						lPadraoCc 	:= VerPadrao("537") //Rateio por C.Custo de MultiNat C.Pagar
						lPadraoCcE 	:= VerPadrao("538") //Estorno do rateio C.Custo de MultiMat CR
						
						IF  lPadrao  .and. !lCtbPls
						
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							// Se utiliza multiplas naturezas, contabiliza pelo SEV
							If  lMultNat 						
								//Contabilizando estorno de C.Receber
								If lEstorno
									cChaveSev := RetChaveSev("SE1")+"2"+cSeqSE5
									cChaveSez := RetChaveSev("SE1",,"SEZ")
								Else
									cChaveSev := RetChaveSev("SE2")+"2"+cSeqSE5
									cChaveSez := RetChaveSev("SE2",,"SEZ")
								Endif
						
								DbSelectArea("SEV")
								dbSetOrder(2)
								If MsSeek(cChaveSev)
		
									dbSelectArea("SE2")
									nValorTotal -= SE2->E2_VALLIQ							
		
									nRecSe2 := Recno()
									DbGoBottom()
									DbSkip()
									
									dbSelectArea("SE1")
									nRecSe1 := Recno()
									DbGoBottom()
									DbSkip()
									
									DbSelectArea("SEV")
			
									While xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+;
										EV_LOJA+EV_IDENT+EV_SEQ) == cChaveSev .And. !Eof()
											
										//Se estou contabilizando um estorno, trata-se de um C. Pagar,
										//So vou contabilizar os EV_SITUACA == E
										//Se nao for um estorno, nao devo contabilizar o registro se
										//EV_SITUACA == E
										If (lEstorno .and. !(SEV->EV_SITUACA == "E")) .or. ;
											(!lEstorno .and. (SEV->EV_SITUACA == "E"))
											dbSkip()
											Loop
										ElseIf lEstorno
											//O lancamento a ser considerado passa a ser o do estorno
											lPadraoCC := lPadraoCCE
										Endif
										
										If SEV->EV_LA != "S"
											dbSelectArea( "SED" )
											MsSeek( xFilial("SED")+SEV->EV_NATUREZ ) // Posiciona na natureza, pois a conta pode estar la.
											dbSelectArea("SEV")
											If SEV->EV_RATEICC == "1" .and. lPadraoCC .and. lPadrao // Rateou multinat por c.custo
												dbSelectArea("SEZ")
												dbSetOrder(4)
												MsSeek(cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5) // Posiciona no arquivo de Rateio C.Custo da MultiNat
												While SEZ->(!Eof()) .and. xFilial("SEZ")+SEZ->(EZ_PREFIXO+EZ_NUM+;
													EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_IDENT+EZ_SEQ) == cChaveSeZ+SEV->EV_NATUREZ+"2"+cSeqSE5
													
													//Se estou contabilizando um estorno, trata-se de um C. Pagar,
													//So vou contabilizar os EZ_SITUACA == E
													//Se nao for um estorno, nao devo contabilizar o registro se
													//EZ_SITUACA == E
													If (lEstorno .and. !(SEZ->EZ_SITUACA == "E")) .or. ;
														(!lEstorno .and. (SEZ->EZ_SITUACA == "E"))
														SEZ->(dbSkip())
														Loop
													Endif
													If SEZ->EZ_LA != "S"
														If lUsaFlag
															aAdd(aFlagCTB,{"EZ_LA","S","SEZ",SEZ->(Recno()),0,0,0})
														EndIf
														//O lacto padrao fica:
														//537 - Rateio multinat com c.custo C.Pagar
														//538 - Estorno de Rat. Multinat C.Custo C.Receber
														cPadraoCC := If(SEZ->EZ_SITUACA == "E","538","537")
														VALOR := SEZ->EZ_VALOR
														nTotDoc	+=	DetProva(nHdlPrv,cPadraoCC,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
														If LanceiCtb // Vem do DetProva
															If !lUsaFlag
																RecLock("SEZ")
																SEZ->EZ_LA    := "S"
																MsUnlock( )
															EndIf
														ElseIf lUsaFlag
															If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEZ->(Recno()) }))>0
																aFlagCTB := Adel(aFlagCTB,nPosReg)
																aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
															Endif
														Endif
													Endif
													SEZ->(dbSkip())
												Enddo
												DbSelectArea("SEV")
											Else
												If lUsaFlag
													aAdd(aFlagCTB,{"EV_LA","S","SEV",SEV->(Recno()),0,0,0})
												EndIf
												nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
											Endif

											If LanceiCtb // Vem do DetProva
												If !lUsaFlag
													RecLock("SEV")
													SEV->EV_LA    := "S"
													MsUnlock( )   
												EndIf
											ElseIf lUsaFlag
												If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEV->(Recno()) }))>0
													aFlagCTB := Adel(aFlagCTB,nPosReg)
													aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
												Endif			
											Endif
										Endif
										DbSelectArea("SEV")
										DbSkip()
										VALOR := 0
									Enddo
									nTotProc	+=	nTotDoc // Totaliza por processo
									nTotal  	+=	nTotDoc
									
									If mv_par12 == 2 
										IF nTotDoc > 0 // Por documento
											Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
											nTotDoc := 0
										Endif
										aFlagCTB := {}
									Endif

									VALOR  		:= 0									
									VALOR2 		:= 0
									VALOR3 		:= 0
									REGVALOR 	:= 0
									

									dbSelectArea("SE1")
									DbGoto(nRecSe1)
									dbSelectArea("SE2")
									DbGoto(nRecSe2)
								EndIf
							Else
								dbSelectArea("SEV")
								DbGoBottom()
								DbSkip()
								DbSelectArea("SE2")
								nTotDoc	:= DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
								nTotProc	+= nTotDoc
								nTotal		+=	nTotDoc
								
								If mv_par12 == 2 
									If nTotDoc > 0 // Por Documento
										If Empty( cProxBor )
											Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
											nTotDoc := 0
										Endif
									Endif
									// aFlagCTB := {}
								Endif
							Endif
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Devolve a posi‡„o original do arquivo  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (lAdiant .or. lEstorno .or. lEstCart2) .and. !lEstPaNdf
							dbSelectArea("SE1")
							If !Eof() .And. !Bof()
								Reclock( "SE1" )
								Replace E1_VALLIQ  With nValliq
								Replace E1_DESCONT With nDescont
								Replace E1_JUROS	 With nJuros
								Replace E1_MULTA	 With nMulta
								Replace E1_CORREC  With nCorrec
								SE1->( MsUnlock( ) )
							EndIF
							dbSelectArea( "SE5" )
						Else
							dbSelectArea("SE2")
							If !Eof() .And. !Bof()
								Reclock( "SE2" )
								Replace E2_VALLIQ  With nValliq
								Replace E2_DESCONT With nDescont
								Replace E2_JUROS	 With nJuros
								Replace E2_MULTA	 With nMulta
								Replace E2_CORREC  With nCorrec
								If lPccBaixa
									Replace E2_PIS		With nPis
									Replace E2_COFINS	With nCofins
									Replace E2_CSLL	With nCsll
									Replace E2_VRETPIS	With nVretPis
									Replace E2_VRETCOF	With nVretCof
									Replace E2_VRETCSL	With nVretCsl
								Endif
								SE2->( MsUnlock())
							EndIf
							dbSelectArea( "SE5" )
						Endif
					Endif
				Endif

				// Disponibilizo a Variavel VALOR com o total dos borderos aglutinados
				If nBordero > 0 .And. cProxBor <> cNumBor

					If !lCabecalho
						a370Cabecalho(@nHdlPrv,@cArquivo)
					EndIf

					VALOR 		:= nBordero
					VALOR2		:= nBordDc
					VALOR3		:= nBordJr
					VALOR4		:= nBordMt
					VALOR5		:= nBordCm
					nBordero 	:= 0.00
					nBordDc		:= 0
					nBordJr		:= 0
					nBordMt		:= 0
					nBordCm		:= 0

					// Desposicionamento de tabelas
					SE2->( dbGoTo(0) )
					If mv_par06 == 2 .Or. mv_par06 == 4
						SE1->( dbGoTo(0) )
						SE5->( dbGoTo(0) )
						FK2->( dbGoTo(0) )
						FK5->( dbGoTo(0) )
					Endif

					nTotDoc	:=	DetProva(nHdlPrv,"532","FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
					nTotProc	+= nTotDoc
					nTotal		+=	nTotDoc
					If mv_par12 == 2 
						IF nTotDoc > 0 // Por documento
							If lSeqCorr
								aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
							EndIf
							Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
						Endif
						aFlagCTB := {}
					Endif
				Endif
				
				dbSelectArea(cAliasSE5)
				If lAvancaReg
					(cAliasSE5)->(dbSkip())
				else
					lAvancaReg := .T.
				EndIf

				If (cAliasSE5)->(EOF()) .AND. MV_PAR12 == 3 .AND. cTipoMov == "DIRETO"
					(cAliasSE5)->(dbGOTOP())
					cTipoMov := "TITULOS"
				EndIf
			Enddo

			If !EMPTY(nTotProc) .and. MV_PAR12 == 3
				Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
				aFlagCTB := {}
				nTotProc := 0
			EndIf
		
			If nValorTotal > 0 .And. mv_par13 = 1
				If !lCabecalho
					a370Cabecalho(@nHdlPrv,@cArquivo)
				EndIf
				VALOR 	:= nValorTotal
				VALOR2	:= VALOR3	:= VALOR4	:= VALOR5	:= 0.00
				dbSelectArea("SE2")
				dbGobottom()
				dbSkip()
				// Se estiver contabilizando carteira a Pagar apenas,
				// desposiciona E1 tambem, pois no LP podera conter
				// E1_VALLIQ e este campo retornara um valor, duplicando
				// o LP 527. Ex. Criar um LP 527 contabilizando pelo E1_VALLIQ
				// Fazer uma Baixa e um cancelamento, contabilizar off-line
				// escolhendo apenas a carteira a Pagar
				If mv_par06 == 2 .Or. mv_par06 == 4
					dbSelectArea("SE1")
					dbGobottom()
					dbSkip()
					dbSelectArea("SE5")
					dbGobottom()
					dbSkip()
					dbSelectArea("FK2")
					dbGobottom()
					dbSkip()
					dbSelectArea("FK5")
					dbGobottom()
					dbSkip()
				Endif
				nTotDoc	:=	DetProva(nHdlPrv,"532","FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
				nTotProc	+= nTotDoc
				nTotal		+=	nTotDoc
				If mv_par12 == 2 
					IF nTotDoc > 0 // Por documento
						If lSeqCorr
							aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
						EndIf
						Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
					Endif
					aFlagCTB := {}
				Endif
			EndIF

			//Contabilizacao das transferencias
			aSort(aRecsTRF,,,{|x,y| x[3]+x[2] > y[3]+y[2]})
			For nX := 1 to Len(aRecsTRF)
				dbSelectArea("SE5") 
				dbSetOrder( 1 )
				dbGoto(aRecsTRF[nX,1])				
				SA6->(dbSetOrder( 1 ))	// A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
				SA6->(dbSeek(xFilial("SA6") + SE5->(E5_BANCO + E5_AGENCIA + E5_CONTA)))
				lPadrao:=VerPadrao(aRecsTRF[nX,2])				
				If lPadrao	
					If !lCabecalho
						a370Cabecalho(@nHdlPrv,@cArquivo)
					EndIf
					If lUsaFlag
						CTBAddFlag(aFlagCTB)
					EndIf

					nTotDoc	:= DetProva(nHdlPrv,aRecsTRF[nX,2],"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)

					nTotal		+=	nTotDoc
					nTotProc	+= nTotDoc

					If SE5->E5_TIPODOC $ 'TR#TE'
						dDataCtb := SE5->(&cCampo)
					EndIf				
					

					If mv_par12 == 2 
						If nTotDoc > 0 // Por documento
							If lSeqCorr
								aDiario := {{"SE5",SE5->(recno()),SE5->E5_DIACTB,"E5_NODIA","E5_DIACTB"}}
							EndIf

							IF lGroupDoc
								// Movimentação Bancária - Controle por documento 
								IF LEN(aRecsTRF) == nX
									lQuebraDoc := .T.
								ELSE
									lQuebraDoc := ALLTRIM(aRecsTRF[nX,3]) <> ALLTRIM(aRecsTRF[nX+1,3])
								ENDIF
							ENDIF
							
							IF lQuebraDoc
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
								aFlagCTB := {}	// Limpa a lista após a contabilização.
							Endif

						Endif
					Endif

					If LanceiCtb
						aAdd(aRecsSE5, {SE5->(RECNO()), 'FINM030', 'FK5'} ) // Movimentação bancaria.
					EndIf
				Endif
			Next
			aRecsTRF := {}
		Endif

		If Len(aRecsSE5) > 0 .and. !lUsaFlag
			dbSelectArea("SE5")
			For nX := 1 to Len(aRecsSE5)
				dbGoto(aRecsSE5[nX][NRECNO])
				CTBGrvFlag(aRecsSE5[nX])
			Next
			aRecsSE5 := {} //Limpa variavel.
		Endif
		
		If mv_par12 == 3 
			IF nTotProc > 0 // Por processo
				Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
				nTotProc := 0
			Endif
			aFlagCTB := {}
		Endif
		//Fim da contabilização do SE5				

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Contabiliza‡ao de Cheques  											  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   		If (mv_par06 = 3  .Or. mv_par06 = 4) .and. lLerSEF
		
			lArqSEF := .F.
			
   			If __lDefTop .and. !lMultiTHR
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³       *** Alteracao para ganho de performance ***            ³
				//³Caso o banco seja relacional, pesquisar apenas os titulos     ³
				//³da data que esta sendo processada. Alteracao faz com que      ³
				//³a varredura de registros na SEF limite-se ao total de titulos ³
				//³encontrados na data e nao todos os registros da tabela.       ³
				//³                                                              ³
				//³APENAS a forma de varredura foi alterado, nada foi mudado     ³
				//³nas regras de gravacoes contabeis.                            ³
				//³                                                              ³
				//³ESTUDO DE CASO :                                              ³								
				//³Cliente processa 7564 dias (nPeriodo) X 113056 registros SEF  ³
				//³Totalizando : 855.155.584 varreduras de registros no SEF      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lArqSEF := .T.
				aLstSEF := {}
				nz := 0
				nTotREGSEF := 0
				If Select(cAliasSEF) # 0
					dbSelectArea(cAliasSEF)
					dbCloseArea()
					fErase(cAliasSEF + OrdBagExt())
					fErase(cAliasSEF + GetDbExtension())
				Endif
				dbSelectArea("SEF")
				SEF->(dbSetOrder(1))
				cQuery := "SELECT EF_FILIAL, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM, EF_DATA, SEF.R_E_C_N_O_ SEFRECNO "
				cQuery += "FROM " + RetSqlName("SEF") + " SEF "
				
				IF ((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))  					
	  				If lPosEfMsFil .AND. !lUsaFilOri
	  					cQuery += "WHERE EF_MSFIL = '" + cFilAnt + "' AND (("
  					Else
  						cQuery += "WHERE EF_FILORIG = '"  + cFilAnt + "' AND ((" 
					Endif				
				Else
					cQuery += "WHERE EF_FILIAL = '" + xFilial("SEF") + "' AND (("
				EndIf				

				If cMVSLDBXCR == "C"						
					cQuery += "EF_ORIGEM IN ('FINA040','FINA191','FINA070','FINA460','FINA740') AND EF_DTCOMP BETWEEN '"  + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "') OR "
					CQuery += "(EF_ORIGEM NOT IN ('FINA040','FINA191','FINA070','FINA460','FINA740') AND "
				Endif							

				cQuery += "EF_DATA BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "')) AND " 
				cQuery += "EF_LA <> 'S' AND D_E_L_E_T_ = ' ' "

				If l370EFFIL
					cQuery += Execblock("F370EFF",.F.,.F.,cQuery)
				EndIf                           
				cQuery += "ORDER BY " + SqlOrder("EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM+DTOS(EF_DATA)")
				ChangeQuery(cQuery)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSEF, .F., .T.)
				(cAliasSEF)->(dbGoTop())
				Do While !(cAliasSEF)->(Eof())
					aAdd(aLstSEF,(cAliasSEF)->SEFRECNO)
					nTotREGSEF++
					(cAliasSEF)->(dbSkip())
				EndDo
   			ElseIf lMultiThr
   				// Utilizar a consulta enviada pela thread. 
				lArqSEF		:= .T.
				aLstSEF		:= {}
				nz			:= 0
				nTotREGSEF	:= 0
				
				Do While !(cAliasSEF)->(Eof())
				 	If (cAliasSEF)->EF_DATA >= MV_PAR04 .AND. (cAliasSEF)->EF_DATA <= MV_PAR05
				 		aAdd(aLstSEF,(cAliasSEF)->SEFRECNO)
				 		nTotREGSEF++
				 	ElseIf (cAliasSEF)->EF_DATA > MV_PAR04
				 		Exit
				 	EndIf
			 		(cAliasSEF)->(dbSkip())
				EndDo
   			Endif

			dbSelectArea("SEF")
			SEF->(dbSetOrder(1))
			SEF->(dbSeek(cFilial,.T.))
			
			If !lArqSEF
				bCond := {|| !SEF->(Eof()) .And. xFilial("SEF") == SEF->EF_FILIAL}
			Else
				bCond := {|| !Empty(nTotREGSEF) .AND. nz++ < nTotREGSEF}
			EndIf
			
			While Eval(bCond)

				LanceiCtb := .F. // Vem do DetProva
				
				If lArqSEF
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Guarda o pr¢ximo registro para IndRegua					  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					SEF->(dbGoTo(aLstSEF[nz]))
					nRegAnt := SEF->(Recno())
					cChqAnt := cChequeAtual
					dDataCTB := IF(MV_PAR03 == 1, SEF->EF_DATA, dDataBase)
					
					If nz < nTotREGSEF
						SEF->(dbGoTo(aLstSEF[nz + 1]))
						nProxReg := SEF->(Recno())
						cProxChq := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)  //Utilizado para quebra por documento
						SEF->(dbGoTo(aLstSEF[nz]))
					Else
						nProxReg := 0
						cProxChq := ""
					Endif
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Guarda o pr¢ximo registro para IndRegua				   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nRegAnt := Recno()
					dbSkip()
					nProxReg := RecNo()
					cProxChq := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)  //Utilizado para quebra por documento
					dbGoto(nRegAnt)				
				Endif
				
				// Controle de Saldo Contas a Receber - parâmetro MV_SLDBXCR
				If cMVSLDBXCR == "C" .AND. ALLTRIM(SEF->EF_ORIGEM) $ 'FINA040/FINA191/FINA070/FINA460/FINA740'
					dDtRefSEF := SEF->EF_DTCOMP
					dDataCTB := dDtRefSEF
				Else
					dDtRefSEF := If(cEF_T01="D",SEF->EF_DATA,StoD(SEF->EF_DATA))
				Endif							

				If dDtRefSEF >= mv_par04 .AND. ;
					dDtRefSEF <= mv_par05 .AND. ;
					!Empty(SEF->EF_NUM) .AND. ;
					SubStr(SEF->EF_LA,1,1) != "S" .AND. ;
					(Alltrim(SEF->EF_ORIGEM) $ "FINA050#FINA040#FINA080#FINA070#FINA190#FINA090#FINA091#FINA390TIT#FINA390AVU#FINA191#FINA460" .OR. ;
					Empty(SEF->EF_ORIGEM))
					
					If SEF->EF_LIBER == "S"
						cPadrao := "590"
					Else
						cPadrao := ""
					EndIf
					lChqSTit := .F.
					IF SEF->EF_ORIGEM == "FINA390TIT"
						cPadrao := "566"
					Endif
					IF SEF->EF_ORIGEM == "FINA390AVU"
						cPadrao := "567"
					Endif
					If Alltrim(SEF->EF_ORIGEM) == "FINA191" .OR. Alltrim(SEF->EF_ORIGEM) == "FINA070" .Or. Alltrim(SEF->EF_ORIGEM) == "FINA460"
						cPadrao := "559"  
						If cMVSLDBXCR == "C"						
							dDataSEF := SEF->EF_DTCOMP
						Else
							dDataSEF := SEF->EF_DATA
						Endif							
					EndIf
					If Alltrim(SEF->EF_ORIGEM) == "FINA040" //Cheque gerados pelo SIGALOJA ou gerados na inclusão de títulos da carteira CR.
						If cMVSLDBXCR == "C"	.and. !Empty(SEF->EF_DTCOMP)					
							dDataSEF := SEF->EF_DTCOMP
							cPadrao := "559"  
						Elseif SE1->E1_STATUS == "B" 
							dDataSEF := SEF->EF_DATA
							cPadrao := "559"  
						Else
							dbSelectArea("SEF")
							dbGoto(nProxReg)
							Loop
						Endif	
					Endif		
					If !cCtBaixa $ "AC" .and. Alltrim(SEF->EF_ORIGEM) $ "FINA050#FINA080#FINA190#FINA090#FINA091#FINA390TIT"
						dbSelectArea("SEF")
						dbGoto(nProxReg)
						Loop
					Endif
					
					// Contabilizo a emissão LP567 inclusive dos cancelados que não foram excluídos
					// A contabilização do cancelamento LP568 é online
					If SEF->EF_IMPRESS == "C" .AND. SEF->EF_LA == 'S'
						dbSelectArea("SEF")
						dbGoto(nProxReg)
						Loop
					Endif
					
					// Nao contabilizo cheques de PA nao aglutinados
					// Registro totalizador n?o tˆm preenchidos os campos EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO
					If SEF->EF_IMPRESS != "A" .and. Alltrim(SEF->EF_ORIGEM) == "FINA050" .AND. !EMPTY(SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO)) 
						dbSelectArea("SEF")
						dbGoto(nProxReg)
						Loop
					Endif
					//Não contabilizo cheque recebido que nao foram compensados
					If Empty(SEF->EF_DTCOMP) .and. Alltrim(SEF->EF_ORIGEM)=="FINA191"
						dbSelectArea("SEF")
						dbGoto(nProxReg)
						Loop
					Endif
					
					// Alimenta data de contabilizacao para cheques sem mov. bancario
					If Empty(dDataCtb)
						dDataCtb := IF(MV_PAR03 == 1, SEF->EF_DATA, dDataBase)
					EndIf

					If SEF->EF_IMPRESS $ "SNC "			// Cheque impresso ou não, ou Cancelado e não contabilizado na emissão
						VALOR     := SEF->EF_VALOR		// para lan‡amento padr„o
						STRLCTPAD := SEF->EF_HIST
						NUMCHEQUE := SEF->EF_NUM
						ORIGCHEQ  := ALLTRIM(SEF->EF_ORIGEM)
						cChequeAtual := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Desposiciona propositalmente o SEF para que APENAS a³
						//³ variavel VALOR esteja com conteudo. O reposicionamen³
						//³ to ‚ feito na volta do Looping.                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ORIGCHEQ == "FINA190" .OR.; // Jun‡Æo de cheques
							(ORIGCHEQ == "FINA050" .AND. EMPTY(SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO))) // Totalizador gerado na inclus?o de PA
							dbSelectArea("SEF")
							cChequeAtual := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)
							dbGoBottom()
							dbSkip()
							dbSelectArea("SE1")
							dbGoBottom()
							dbSkip()
							dbSelectArea("SE2")
							dbGoBottom()
							dbSkip()
							dbSelectArea("SE5")
							dbGoBottom()
							dbSkip()
						Endif
						If Alltrim(SEF->EF_ORIGEM) == "FINA080"  // Baixas a Pagar
							// Se o cheque nao foi impresso, desposiciona as tabelas para contabilizar somente com as variaveis
							If SEF->EF_IMPRESS $ "N "
								dbSelectArea("SEF")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE1")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE2")
								dbGoBottom()
								dbSkip()
								dbSelectArea("SE5")
								dbGoBottom()
								dbSkip()
							Else	// Cheque impresso
								// Posiciona SE5 na movimentação de baixa do titulo do cheque e mantem as outras tabelas posicionadas
								SE5->(dbSetOrder(2))
								If ! SE5->( MsSeek( xFilial("SE5")+"VL"+SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+IIf(cEF_T01="D",DtoS(EF_DATA),EF_DATA)+EF_FORNECE+EF_LOJA+SEF->EF_SEQUENC)))
									SE5->( MsSeek( xFilial("SE5")+"BA"+SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO+IIf(cEF_T01="D",DtoS(EF_DATA),EF_DATA)+EF_FORNECE+EF_LOJA+SEF->EF_SEQUENC)))
								EndIf
								SE5->(dbSetOrder(1))
								cChequeAtual := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)								
							EndIf
						Endif
						If Alltrim(SEF->EF_ORIGEM) == "FINA090"  // Baixa Automática de Títulos
							aAreaAux := {}
							AADD(aAreaAux,GETAREA())
							AADD(aAreaAux,SE5->(GetArea()))
							SE5->(dbSetOrder(11))	//E5_FILIAL, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_NUMCHEQ, E5_DATA, R_E_C_N_O_, D_E_L_E_T_
							SE5->(dbSeek(xFilial('SE5')+SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)))
							While !SE5->(EOF()) .and. SE5->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ) == xFilial('SE5')+SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)
								If SE5->E5_TIPODOC == 'CH'
									CTBAddFlag(aFlagCTB)
									EXIT
								EndIf
								SE5->(DbSkip())
							EndDo
							RestArea(aAreaAux[2])
							RestArea(aAreaAux[1])
						EndIf
						If Alltrim(SEF->EF_ORIGEM) == "FINA390TIT"  // Chq s/ Titulo
							dbSelectArea("SE1")
							dbGoBottom()
							dbSkip()
							dbSelectArea("SE2")
							dbGoBottom()
							dbSkip()
							VALOR     := 0
							lChqStit	:= .T.
						Endif
						If Alltrim(SEF->EF_ORIGEM) == "FINA390AVU"  // Cheque Avulso
							VALOR     := 0
							STRLCTPAD := ""
							NUMCHEQUE := ""
							ORIGCHEQ  := ""
							lChqStit	:= .T.
						Endif
					Elseif SEF->EF_IMPRESS == "A"	// Cheque Aglutinado
						VALOR     := 0
						STRLCTPAD := ""
						NUMCHEQUE := ""
						ORIGCHEQ  := ""
						cChequeAtual := SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM)
						dbSelectArea("SE5")
						dbSetOrder(2)		//posiciona no SE5
						If (dbSeek(xFilial()+"VL"+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+IIf(cEF_T01="D",DtoS(SEF->EF_DATA),SEF->EF_DATA)+SEF->EF_FORNECE+SEF->EF_LOJA+SEF->EF_SEQUENC)) .OR.;
							dbSeek(xFilial()+"BA"+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+IIf(cEF_T01="D",DtoS(SEF->EF_DATA),SEF->EF_DATA)+SEF->EF_FORNECE+SEF->EF_LOJA+SEF->EF_SEQUENC)
							If lUsaFlag
								CTBAddFlag(aFlagCTB)
							EndIf
						Endif
						dbSetOrder(1)
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona Registros                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !SEF->(Eof())
						dbSelectArea("SA6")
						dbSetOrder(1)
						dbSeek(cFilial+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA)
						If !lChqSTit
							If SEF->EF_TIPO $ MVRECANT + "/" + MV_CRNEG
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Neste caso o titulo veio de um Contas³
								//³ a Receber (SE1)                      ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SE1")
								DbSetOrder(1)
								If dbSeek(xFilial()+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
									dbSelectArea("SED")
									dbSeek(xFilial()+SE1->E1_NATUREZ)
									dbSelectArea("SA1")
									dbSeek(xFilial()+SEF->EF_FORNECE+SEF->EF_LOJA)
								Endif
							Else
								dbSelectArea( "SE2" )
								dbSetOrder(1)
								If dbSeek(xFilial("SE2")+SEF->EF_PREFIXO+SEF->EF_TITULO+;
									SEF->EF_PARCELA+SEF->EF_TIPO+;
									SEF->EF_FORNECE+SEF->EF_LOJA,.F.)
									dbSelectArea("SED")
									dbSetOrder(1)
									dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
									dbSelectArea("SA2")
									dbSetOrder(1)
									dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
								EndIf
							Endif
							If EMPTY(SEF->(EF_PREFIXO+EF_TITULO+EF_PARCELA+EF_TIPO)) .OR. Alltrim(SEF->EF_ORIGEM) == "FINA390TIT"  // Chq s/ Titulo
								dbSelectArea("SEF")
								dbGoBottom()
								dbSkip()
							Endif
						Endif
					EndIf
					dbSelectArea( "SEF" )
					
					lPadrao:=VerPadrao(cPadrao)
					IF lPadrao
						If !lCabecalho
							a370Cabecalho(@nHdlPrv,@cArquivo)
						EndIF       
						If lUsaFlag
							aAdd(aFlagCTB,{"EF_LA","S","SEF",nRegAnt,0,0,0})
						EndIf                                                                                   

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Deve passar a tabela de cheques (SEF) e Recno posicionado para gravar na CTK/CV3    ³
						//³ Assim, no momento da exclusao do lancto. pelo CTB, limpa o flag da SEF corretamente ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nTotDoc  += DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB,{"SEF",nRegAnt})

						nTotProc += nTotDoc
						nTotal   += nTotDoc
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza Flag de Lan‡amento Cont bil do cheque contabilizado  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SEF")
						dbGoto(nRegAnt)
						If LanceiCtb .And. !(SEF->(Eof()))
							If !lUsaFlag
								Reclock("SEF")
								SEF->EF_LA := "S"
								MsUnlock()
							EndIf
						EndIf
						// Por documento
						If mv_par12 == 2 
							If nTotDoc > 0 .and. cChequeAtual != cProxChq
								Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
								nTotDoc := 0							
							Endif
							If (SEF->(Eof()))
							aFlagCTB := {}
							EndIf
						Endif
					Endif
				Endif
				dbSelectArea("SEF")
				dbGoto(nProxReg)
			Enddo
			If mv_par12 == 3 
				If nTotProc > 0 // Por processo
					Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
				Endif
				aFlagCTB := {}
			Endif
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caixinha   SEU990             				     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par06 != 3 .and. lLerSEU
		
			If !lMultiTHR
			
				If Select(cAliasSEU) # 0
					dbSelectArea(cAliasSEU)
					dbCloseArea()
					fErase(cAliasSEU + OrdBagExt())
					fErase(cAliasSEU + GetDbExtension())
				Endif

				//Caso Seja Dt Baixa utilizar EU_BAIXA, se nao utilizar EU_DTDIGIT  
				If mv_par07 == 1
					cQuery := "SELECT DISTINCT EU_FILIAL, EU_CAIXA, EU_BAIXA AS DATASEU, 'OUTROS' AS TIPOMOV "
				Else
					cQuery := "SELECT DISTINCT EU_FILIAL, EU_CAIXA, EU_DTDIGIT AS DATASEU, 'OUTROS' AS TIPOMOV "
				EndIf
				
				cQuery += "FROM " + RetSqlName("SEU") + " "
				
				If ((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))  					
					If lPosEuMsFil .AND. !lUsaFilOri
						cQuery += "WHERE EU_MSFIL = '" + cFilAnt + "' AND "
					Else
						cQuery += "WHERE EU_FILORI = '"  + cFilAnt + "' AND " 
					Endif				
				Else
					cQuery += "WHERE EU_FILIAL = '" + xFilial("SEU") + "' AND "
				EndIf				
				
				If mv_par07 == 1
					cQuery += "EU_BAIXA BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND " 
				Else
					cQuery += "EU_DTDIGIT BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
				EndIf
				
				If _lMvPar18 .And. mv_par18 == 1
					cQuery += "EU_TIPO NOT IN ('01','03') AND  "
				EndIf
				
				cQuery += "EU_LA <> 'S' AND D_E_L_E_T_ = ' ' "

				If _lMvPar18 .And. mv_par18 == 1
					//Se for para considerar adiantamento de caixinha em aberto e solicitar pela baixa (mv_par07 = 1),  
					//irá filtrar pela data de digitação
					cQuery += " UNION "
					cQuery += "SELECT DISTINCT EU_FILIAL, EU_CAIXA, EU_DTDIGIT AS DATASEU, 'ADTO' AS TIPOMOV "
					cQuery += "FROM " + RetSqlName("SEU") + " "
					
					If ((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))  					
						If lPosEuMsFil .AND. !lUsaFilOri
							cQuery += "WHERE EU_MSFIL = '" + cFilAnt + "' AND "
						Else
							cQuery += "WHERE EU_FILORI = '"  + cFilAnt + "' AND " 
						Endif				
					Else
						cQuery += "WHERE EU_FILIAL = '" + xFilial("SEU") + "' AND "
					EndIf				
						
					cQuery += "EU_DTDIGIT BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
					cQuery += "EU_TIPO IN ('01','03') AND  "
					cQuery += "EU_LA <> 'S' AND D_E_L_E_T_ = ' ' "
				EndIf
				
				cQuery += "ORDER BY " + SqlOrder("EU_FILIAL+EU_CAIXA+DTOS(DATASEU)")

				ChangeQuery(cQuery)
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSEU, .F., .T.)

				TCSetField(cAliasSEU,'EU_BAIXA','D',TamSX3('EU_BAIXA')[1])
				TCSetField(cAliasSEU,'EU_DTDIGIT','D',TamSX3('EU_DTDIGIT')[1])
				TCSetField(cAliasSEU,'DATASEU','D',TamSX3('EU_DTDIGIT')[1])
			EndIf
				
			(cAliasSEU)->(dbGoTop())

			dbSelectArea( "SET" )
			SET->(dbSetOrder( 1 ))	//ET_FILIAL+ET_CODIGO 
	
			While !(cAliasSEU)->(Eof()) .And. xFilial("SEU") == (cAliasSEU)->EU_FILIAL
			
				// Localiza Caixinha 
				If SET->(dbSeek(xFilial("SET") + (cAliasSEU)->EU_CAIXA))

					nOrderSEU := IIf( mv_par07 == 1, 2, 4 ) // 2 - EU_FILIAL, EU_CAIXA, EU_BAIXA, EU_NUM // 4- EU_FILIAL+EU_CAIXA+DTOS(EU_DTDIGIT)+EU_NUM
					bCampo    := IIf( mv_par07 == 1, {|| SEU->EU_BAIXA }, {|| SEU->EU_DTDIGIT } )
					If ALLTRIM((cAliasSEU)->TIPOMOV) == 'ADTO'
						nOrderSEU := 4
						bCampo := {|| SEU->EU_DTDIGIT }
						bValAdt := {|| SEU->EU_TIPO $ '01;03'}
					ElseIf _lMvPar18 .and. mv_par18 == 1
						bValAdt := {|| !SEU->EU_TIPO $ '01;03'}	
					else
						bValAdt := {|| .T. }	
					EndIf
			
					dbSelectArea( "SEU" )
					SEU->(dbSetOrder( nOrderSEU ))
					SEU->(dbSeek( xFilial("SEU") + (cAliasSEU)->EU_CAIXA + DTOS((cAliasSEU)->DATASEU) , .F. ))
					
					While SEU->(!Eof()) .And. xFilial("SEU") == SEU->EU_FILIAL .And. SEU->EU_CAIXA == SET->ET_CODIGO .And. Eval(bCampo) <= mv_par05

						If !Eval(bValAdt)
							SEU->(DBSKIP())
							LOOP
						EndIf
						
						dDataCTB := Eval(bCampo)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Ponto de Entrada para filtrar registros do SEU. ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If l370EUFIL
							If !Execblock("F370EUF",.F.,.F.)
								SEU->(dbSkip())
								Loop
							EndIf
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se ser  gerado Lan‡amento Cont bil			  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SEU->EU_LA == "S"
							SEU->( dbSkip())
							Loop
						Endif
						
						// Tipo 00 sem Nro de adiantamento = Despesa (P)
						// Tipo 00 com Nro de adiantamento = Prestação de contas (R)
						// Tipo 01 - Adiantamento (P)
						// Tipo 02 - Devolucao de adiantamento (R)
						// Tipo 10 - Movimento Banco -> Caixinha  (R)
						// Tipo 11 - Movimento Caixinha -> Banco (P)
						
						lSkipLct := .F.
						
						//Receber
						//Verifico se eh Despesa. Se for, ignoro
						If mv_par06 == 1 .and. SEU->EU_TIPO $ "00" .AND. EMPTY(SEU->EU_NROADIA)
							lSkipLct := .T.
						Endif
						//Verifico se eh um Adiantamento ou Devolucao para o banco. Se for Ignoro
						If mv_par06 == 1 .and. SEU->EU_TIPO $ "01/03/11"
							lSkipLct := .T.
						Endif
						
						//Pagar
						//Verifico se eh Prestacao de contas de adiantamento para o caixinha.
						//Se for, ignoro pois eh movimento de entrada
						If mv_par06 == 2 .and. SEU->EU_TIPO $ "00" .and. !EMPTY(SEU->EU_NROADIA)
							lSkipLct := .T.
						Endif
						//Verifico se eh uma devolucao de dinheiro de adiantamento para o caixinha ou
						// se eh uma reposicao (Banco -> Caixinha).
						// Se for Ignoro pois eh movimento de entrada!!
						If mv_par06 == 2 .and. SEU->EU_TIPO $ "02/10"
							lSkipLct := .T.
						Endif
						
						If lSkipLct
							SEU->( dbSkip())
							Loop
						Endif
						
						//Reposicao = 10 - Devolucao de reposicao = 11
						If SEU->EU_TIPO $ "10/11"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Posiciona no banco.											  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dbSelectArea( "SA6" )
							dbSetOrder(1)
							dbSeek( xFilial("SA6")+SET->ET_BANCO+SET->ET_AGEBCO+SET->ET_CTABCO )
							cPadrao:="573"
						Else
							If SEU->EU_TIPO == '02'
								cPadrao:="579"
							Else
								cPadrao:="572"
							EndIf
						Endif
						
						dbSelectArea("SEU")
						lPadrao:=VerPadrao(cPadrao)
						IF lPadrao
							If !lCabecalho
								a370Cabecalho(@nHdlPrv,@cArquivo)
							Endif
							If lUsaFlag
								aAdd(aFlagCTB,{"EU_LA","S","SEU",SEU->(Recno()),0,0,0})
							EndIf
							nTotDoc	:=	DetProva(nHdlPrv,cPadrao,"FINA370",cLote,,,,,,aCT5,,@aFlagCTB)
							nTotProc	+= nTotDoc
							nTotal	+=	nTotDoc
	
							If mv_par12 == 2 
								IF nTotDoc > 0 // Por documento
									If lSeqCorr
										aDiario := {{"SEU",SEU->(recno()),SEU->EU_DIACTB,"EU_NODIA","EU_DIACTB"}}
									EndIf
									Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,@aDiario,dDataCtb)
								Endif
								aFlagCTB := {}
							Endif
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza Flag de Lan‡amento Cont bil		  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If LanceiCtb
								If !lUsaFlag
									Reclock("SEU")
									REPLACE EU_LA With "S"
									MsUnlock( )
								EndIf
							ElseIf lUsaFlag
								If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == SEU->(Recno()) }))>0
									aFlagCTB := Adel(aFlagCTB,nPosReg)
									aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
								Endif
							EndIf
						Endif
						SEU->(dbSkip())
					Enddo
				EndIf
				
				(cAliasSEU)->(DbSkip())
			Enddo
			
			If mv_par12 == 3 .and. nTotProc > 0	 // Por processo 
				Ca370Incl(cArquivo,@nHdlPrv,cLote,nTotal,@aFlagCTB,,dDataCtb)
				aFlagCTB := {}
				nTotProc := 0
			Endif
			
		Endif
		
		/* contabiliza os itens de viagens - nao contabiliza se a carteira escolhida é "cheques" 
		em multi-thread a propria funcao da thread executa a fctba677 
		*/
		If !lMultiThr .And. !(MV_PAR06 == 3) 
			FCTBA677(@lCabecalho,@nHdlPrv,@cArquivo,@lUsaFlag,@aFlagCTB,@cLote,@nTotal,,)
		Endif
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava Rodap‚ 													  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCabecalho .And. nTotal > 0 .And. mv_par12 == 1 // Por periodo
			RodaProva(nHdlPrv,nTotal)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Envia para Lan‡amento Cont bil 							  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lDigita:=IIF(mv_par01==1,.T.,.F.)
			lAglut :=IIF(mv_par02==1,.T.,.F.)
			cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut,,dDataCtb,,@aFlagCTB)

			aFlagCTB := {}
		Endif

		//Ponto de Entrada acionado após a contabilização da Filial
		If (__CtbFPos)
			ExecBlock("CtbFPos", .F., .F.)
		EndIf

		If Len(aRecsSE5) > 0 
			dbSelectArea("SE5")
			For nX := 1 to Len(aRecsSE5)
				dbGoto(aRecsSE5[nX][NRECNO])
				If !"S" $ SE5->E5_LA
					CTBGrvFlag(aRecsSE5[nX])
				Endif
			Next
			aRecsSE5 := {} //Limpa variavel.
		Endif

	Next 	  // final do la‡o dos dias

	IF !lMultiThr .and. Select(cAliasSE5) > 0
		dbSelectArea(cAliasSE5)
		dbCloseArea()
	Endif
	IF !lMultiThr .and. Select(cAliasSE2) > 0
		dbSelectArea( cAliasSE2 )
		dbCloseArea()
	Endif
	IF !lMultiThr .and. Select(cAliasSEF) > 0
		dbSelectArea(cAliasSEF)
		dbCloseArea()
		fErase(cAliasSEF + OrdBagExt())
		fErase(cAliasSEF + GetDbExtension())
	Endif
	IF !lMultiThr .and. Select(cAliasSEU) > 0
		dbSelectArea( cAliasSEU )
		dbCloseArea()
	Endif

	IF MV_PAR14 == 2	// Considera Filial Original?  1- Sim, 2 - Não
		If Empty(FWXFilial("SE1"))
			lLerSE1 := .F.
		Endif
		
		If Empty(FWXFilial("SE2"))
			lLerSE2 := .F.
		Endif
		
		If Empty(FWXFilial("SE5"))
			lLerSE5 := .F.
		Endif
		
		If Empty(FWXFilial("SEF"))
			lLerSEF := .F.
		Endif
		
		If Empty(FWXFilial("SEU"))
			lLerSEU := .F.
		Endif
	ENDIF

	If !lLerSE1 .and. !lLerSE2 .and. !lLerSE5 .and. !lLerSEF .And. !lLerSEU
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Data inicial precisa ser "resetada"                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mv_par04 := mv_par04 - nLaco + 2
	
Next nContFil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera o valor real da data base por seguranca	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dDataBase := dDataAnt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a filial original                      	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := __cFilAnt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos Dados									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsUnlockAll()

dbSelectArea( "SE1" )
dbSetOrder( 1 )
dbSeek(xFilial())
dbSelectArea( "SE2" )
dbSetOrder( 1 )
dbSeek(xFilial())
dbSelectArea("SEF")
dbSetOrder(1)
dbSeek(xFilial())
dbSelectArea( "SE5" )
Retindex("SE5")
dbClearFilter()

If !CtbInUse()
	If mv_par11 == 1			// Atualiza‡„o de Sint‚ticas
		aDataIni := DataInicio()
		aDataFim := DataFinal()
		aTabela22:= DataTabela()
		If mv_par08 == 1 		// Considera filiais De/Ate
			Cona070(.T., mv_par09, mv_par10, mv_par04, mv_par05)
		Else						// Desconsidera Filiais
			Cona070(.T., NIL , NIL , mv_par04, mv_par05)
		EndIf
	EndIf
ElSE
	If FindFunction( "ClearCx105" )
		// Efetua a limpeza dos caches utilizadas no ctba105
		ClearCx105()
	Endif
EndIf


Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Ca370Incl ³ Autor ³ Claudio D. de Souza   ³ Data ³ 12/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Envia lancamentos para contabilizade.                  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Ca370Incl													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³FINA370													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ca370Incl(cArquivo,nHdlPrv,cLote,nTotal,aFlagCTB,aDiario,dDataCtb)
Local lDigita
Local lAglut

Default aDiario := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Rodap‚ 									    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdlPrv > 0
	RodaProva(nHdlPrv,nTotal)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lan‡amento Cont bil 					    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lDigita:=IIF(mv_par01==1,.T.,.F.)
	lAglut :=IIF(mv_par02==1,.T.,.F.)

	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,lAglut,,dDataCtb,,@aFlagCTB,,aDiario)
	lCabecalho := .F.
	nHdlPrv := 0
Endif

aFlagCTB := {}
aDiario	:= {}

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³F370CTBSELºAutor  ³Microsiga           º Data ³  03/05/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que pesquisa e contabiliza todos os registro de um  º±±
±±º          ³ recibo gerado pelo FINA087a                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA370                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F370CTBSEL( cSerie, cRecibo, nTotal, cLote, nHdlPrv, cArquivo, lUsaFlag, aFlagCTB, aCT5 )
Local lResult		:=	.T.
Local aListArea		:=	{ GetArea() } // Atencao: A primeira deve ser restaurada por ultimo. (UEPS)
Local i				:=	0
Local cKeyImp		:=	""
Local cAlias		:=	""
Local lAchou		:=	.F.
Local nLinha		:=	1 
Local aRecSEL		:= {}

DEFAULT aCT5 := {}

lResult := VerPadrao( "575" )

If lResult .and. !lCabecalho
	a370Cabecalho( @nHdlPrv, @cArquivo )
	
	If nHdlPrv <= 0
		Help( " ", 1, "A100NOPROV" )
		lResult := .F.
	EndIf
EndIf

If lResult
	GetDBArea( "SEL", @aListArea )
	SEL->( DBSetOrder( 8 ) )	// EL_FILIAL+EL_SERIE+EL_RECIBO+EL_TIPODOC+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO
	SEL->( DBSeek( xFilial("SEL") + cSerie + cRecibo ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera Lancamento Contab. para RECIBO.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do while	!SEL->( EOF() ) .and.;
		( SEL->EL_SERIE == cSerie ) .and.;
		( SEL->EL_RECIBO == cRecibo ) .and.;
		( SEL->EL_LA <> 'S' )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Guarda Registro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD( aRecSEL, SEL->(RECNO()) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona Banco.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GetDBArea( "SA6", @aListArea )
		SA6->( DbsetOrder( 1 ) )
		SA6->( DbSeek( xFilial("SA6") + SEL->EL_BANCO + SEL->EL_AGENCIA + SEL->EL_CONTA, .F.) )
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se tem titulo vinculado.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GetDBArea( "SE1", @aListArea )
		SE1->( DbsetOrder( 2 ) )
		SE1->( DbSeek(	xFilial("SE1") +;
		SEL->EL_CLIORIG +;
		SEL->EL_LOJORIG +;
		SEL->EL_PREFIXO +;
		SEL->EL_NUMERO +;
		SEL->EL_PARCELA +;
		SEL->EL_TIPO, .F.) )
		
		If !SE1->( EOF() )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona na Natureza do Titulo .³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			GetDBArea( "SED", @aListArea )
			SED->( DbsetOrder( 1 ) )
			SED->( DbSeek(	xFilial("SED") +;
			SE1->E1_NATUREZ, .F.) )
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona Cliente.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GetDBArea( "SA1", @aListArea )
		SA1->( DbsetOrder( 1 ) )
		SA1->( DbSeek( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, .F.) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona no cabecalho da NF vinculada.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case ( Alltrim( SEL->EL_TIPO ) == Alltrim( GetSESnew("NCC") ) )
				cAlias := "SF1"
			Case ( Alltrim( SEL->EL_TIPO ) == Alltrim( GetSESnew("NDE") ) )
				cAlias := "SF1"
			Otherwise
				cAlias := "SF2"
		EndCase
		cKeyImp := 	xFilial(cAlias)	+;
		SE1->E1_NUM		+;
		SE1->E1_PREFIXO	+;
		SE1->E1_CLIENTE	+;
		SE1->E1_LOJA
		
		If ( cAlias == "SF1" )
			cKeyImp += SE1->E1_TIPO
		Endif
		
		Posicione( cAlias, 1, cKeyImp, "F" + SubStr( cAlias, 3, 1 ) + "_VALIMP1" )
		lAchou := .F.
		
		GetDBArea( "SEL", @aListArea )
		If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
			aAdd( aFlagCTB, {"EL_LA", "S", "SEL", SEL->( Recno() ), 0, 0, 0} )
		Endif
		
		nTotal += DetProva( nHdlPrv,;
		"575" /*cPadrao*/,;
		"FINA087a" /*cPrograma*/,;
		cLote,;
		nLinha,;
		/*lExecuta*/,;
		/*cCriterio*/,;
		/*lRateio*/,;
		/*cChaveBusca*/,;
		aCT5,;
		/*lPosiciona*/,;
		@aFlagCTB,;
		/*aTabRecOri*/,;
		/*aDadosProva*/ )
		
		SEL->( DbSkip() )
	EndDo
	
	If !lUsaFlag .and. ( Len( aRecSEL ) > 0 )
		For i := 1 To Len( aRecSEL )
			SEL->( DBGoTo( aRecSEL[ i ] ) )
			RecLock( "SEL", .F. )
			Replace EL_LA With "S"
			MsUnLock()
		Next i
	EndIf
	
EndIf

// Restaura todas as areas.
// A ultima area a ser restaurada sera a area ativa no momento da chamada a esta funcao.
for i := Len( aListArea	 ) to 1 Step -1 // UEPS
	RestArea( aListArea[ i ] )
Next i

Return lResult

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetDBArea ºAutor  ³Microsiga           º Data ³  03/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona uma area de dados, armazena a area numa lista    º±±
±±º          ³ para permitir a restauracao porterior.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA370                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GetDBArea( cAlias, aListGetArea )
Default cAlias			:= Alias()
Default aListGetArea	:= {}

DBSelectArea( cAlias )
// Pesquisa para evitar duplicidade.
If ASCAN( aListGetArea, { | aVal | aVal[ 1 ] == cAlias } ) == 0
	AADD( aListGetArea, (cAlias)->( GetArea() ) )
Endif

Return NIL /*Function GetDBArea*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PROCESSAMENTO MULTITHREAD³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBMTFIN  ºAutor  ³Marcos Justo        º Data ³  12/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contabilização do Financeiro - Multi Thread                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBMTFIN(nCarteira,nNumProc)
Local aArea 	  := GetArea()
Local aSM0 		  := AdmAbreSM0()
Local nContFil	  := 0
Local cFilIni	  := cFilAnt
Local lRet		  := .T.
Local cFilDe	  := cFilAnt
Local cFilAte	  := cFilAnt
Local nX		  := 0

If mv_par08 == 1	//Considera filiais abaixo? 1- Sim / 2 - Nao 
	cFilDe := mv_par09
	cFilAte:= mv_par10
Endif

If mv_par14 == 1	// Considera Filial Original?  1- Sim, 2 - Não
	cFilDe := MV_PAR15
	cFilAte:= MV_PAR16
Endif

For nContFil := 1 to Len(aSM0)
	If aSM0[nContFil][SM0_CODFIL] < cFilDe .Or. aSM0[nContFil][SM0_CODFIL] > cFilAte .Or. aSM0[nContFil][SM0_GRPEMP] != cEmpAnt
		Loop
	EndIf
	cFilAnt := aSM0[nContFil][SM0_CODFIL]
	
	If lRet .And. ( nCarteira == 1 .Or.  nCarteira == 4)
		// Verifica se vai usar filial origem e valida se cFilAnt est  dentro das op‡?es informadas.
		IF (MV_PAR14 == 2) .OR.;
			((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16)) 
			lRet := CtbMRec(nNumProc)
		EndIf
	EndIf
	
	If lRet .And. ( nCarteira == 2 .Or.  nCarteira == 4)
		// Verifica se vai usar filial origem e valida se cFilAnt est  dentro das op‡?es informadas.
		IF (MV_PAR14 == 2) .OR.;
			((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))
			lRet := CtbMPag(nNumProc)
		EndIf
	EndIf
	
	If lRet .And. ( nCarteira == 3 .Or.  nCarteira == 4)
		// Processa SEF se existir ao menos um LP configurado.
		If VldVerPad({'559','566','567','590'})
			// Verifica se vai usar filial origem e valida se cFilAnt est  dentro das op‡?es informadas.
			IF (MV_PAR14 == 2) .OR.;
				((MV_PAR14 == 1) .AND. lPosEfMsFil .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16)) .OR.;
				((MV_PAR14 == 1) .AND. !lPosEfMsFil)
				lRet := CtbMCheq(nNumProc)
			EndIf
		EndIf
	EndIf
	
	If lRet
		For nX := 1 to 2
			// Verifica se vai usar filial origem e valida se cFilAnt est  dentro das op‡?es informadas.
			IF (MV_PAR14 == 2) .OR.;
				((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))
				lRet := lRet .And. CtbMMov(nNumProc, nX == 1,'TRBMV'+CVALTOCHAR(nX))
			ENDIF
		Next
	EndIf
	
	If lRet
		// Verifica se vai usar filial origem e valida se cFilAnt est  dentro das op‡?es informadas.
		IF (MV_PAR14 == 2) .OR.;
			((MV_PAR14 == 1) .AND. (cFilAnt >= MV_PAR15) .AND. (cFilAnt <= MV_PAR16))
			lRet := CtbMCaix(nNumProc)	// Caixinha: SET/SEU
		EndIf
	EndIf
	
	If lRet .And. !(nCarteira == 3)
		lRet := CtbMViag(nNumProc)
	Endif
	
	If !lRet
		EXIT
	EndIf
	
Next nContFil

cFilAnt := cFilIni
CTBClean()
RestArea(aArea)

Return lRet

/*/{Protheus.doc} CtbMTProc()
//Chama função de contabilização offline 
@author norbertom
@since 10/02/2019
@version undefined
@param cAlias,cTabCtb
@return return, return_description
CtbMTProc(cAlias,cTabCtb)
(examples)
@see (links_or_references)
/*/
Static Function CtbMTProc(cAlias,cTabCtb)
Local aArea		:= GetArea()
Local lRet		:= .T.

Local lBat		:= .T.
Local lMultiThr	:= .T.

Local cAliasSE1	:= NIL
Local cAliasSE2	:= NIL
Local cAliasSE5	:= NIL
Local cAliasSEF	:= NIL
Local cAliasSEU	:= NIL

Local lLerSE1	:= .F. 
Local lLerSE2	:= .F.
Local lLerSE5	:= .F.
Local lLerSEF	:= .F.
Local lLerSEU	:= .F.

DEFAULT cAlias := ''
DEFAULT cTabCTB := ''

If		lLerSE1 := cAlias == 'SE1'
	cAliasSE1 := cTabCTB
ElseIf	lLerSE2 := cAlias == 'SE2'
	cAliasSE2 := cTabCTB
ElseIf	lLerSE5 := cAlias == 'SE5'
	cAliasSE5 := cTabCTB
ElseIf	lLerSEF := cAlias == 'SEF'
	cAliasSEF := cTabCTB
ElseIf	lLerSEU := cAlias == 'SEU'
	cAliasSEU := cTabCTB
EndIf
conout('Thread: ' + alltrim(str(ThreadID())) + ' <> [' + cAlias + '][' + cTabCTB + ']')
If !EMPTY(cAlias) .AND. !EMPTY(cTabCTB)
	(cTabCtb)->(dbGoTop())
	CTBFINProc(lBat,lLerSE1,cAliasSE1,lLerSE2,cAliasSE2,lLerSEF,cAliasSEF,lLerSE5,cAliasSE5,lMultiThr,lLerSEU,cAliasSEU)
EndIf

RestArea(aArea)
Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CtbMViag()
Divide os registros selecionados de prestação de contas de viagens para
multi-processamento (multi-threads).

@author Marcello Gabriel
@since 18/08/2016
@version 12.1.7

@param nNumProc, número de processos
/*/
Static Function CtbMViag(nNumProc)
Local aArea 		:= GetArea()
Local lRet			:= .T.
Local nX			:= 0
Local aProcs 		:= {}
Local cTabMult		:= ""// Tabela fisica para o processamento multi thread
Local cPadraoItem	:= "8B3"
Local cPadraoCabec	:= "8B5"
Local nTotalReg		:= 0
Local cRaizNome		:= 'CTBFINPROC'
Local aStruSQL		:= {}
Local cTabJob		:= "TRBFLF"
Local cPerg 		:= "FIN370"
Local cChave		:= ''

If VerPadrao(cPadraoItem) .Or. VerPadrao(cPadraoCabec)
	If !__lSchedule
		Pergunte(cPerg,.F.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o arquivo de trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CtbGrvViag(.T.,,@cTabMult)
	
	(cTabMult)->(dbGoTop())
	(cTabMult)->(dbEval({|| nTotalReg++ }))
	(cTabMult)->(dbGoTop())
	
	If nTotalReg > 0
		
		aStruSQL := (cTabMult)->( DbStruct() )
		aProcs := CTBPrepFIN(@nNumProc,cTabMult,nTotalReg,"CTBFLAG",cRaizNome,"")
		
		If  nTotalReg >= nNumProc .And. nNumProc > 1 // MultiThread
			
			//Inicializa as Threads Transação controlada nas Threads
			For nX := 1 to Len(aProcs)
				StartJob("JOBCTBVIAG", GetEnvServer(), .F., cEmpAnt,cFilAnt,aProcs[nX][MARCA],aProcs[nX][ARQUIVO],"CTBFLAG",cTabMult,aStruSQL,cTabJob,cValToChar(nX),aProcs[nX][VAR_STATUS],"",__cUserId,cUserName,cAcesso,cUsuario)
				Sleep(6000)
			Next nX
			
			//NAO RETIRAR A INSTRUCAO DO SLEEP
			//Esperar 30 segundos antes de monitorar para dar tempo das threads criar arquivo de semaforo
			Sleep(30000)
			//Realiza o controle das Threads
			lRet := FINMonitor(aProcs,4)
		ElseIf nNumProc == 1
			cTabJob	 := SelFINJob(NIL,cTabMult,aStruSQL,"CTBFLAG",aProcs[nNumProc][MARCA],cTabJob,cChave,cTabMult)
			lRet := FCTBA677(,,,,,,,cTabJob,.T.)
			If Select(cTabJob) > 0
				(cTabJob)->(dbCloseArea())
			EndIf
		EndIf
	EndIf
	
	If Select(cTabMult) > 0
		(cTabMult)->( dbCloseArea() )
	Endif

	MsErase(cTabMult)
	RestArea(aArea)

Endif
Return(lRet)


//-------------------------------------------------------------------
/*/{Protheus.doc} CtbGrvViag()
Seleciona os registros de prestação de contas de viagens e os divide
para multi-processamento (multi-threads).

@author Marcello Gabriel
@since 18/08/2016
@version 12.1.7

@param lTabTemp, indica a geração da tabela temporária 
@param cQuery, passado por referência, receberá o texto da consulta 
@param cTabTemp, passado por referência, receberá o nome da tabela temporária (quando gerada)
/*/
Static Function CtbGrvViag(lTabTemp,cQuery,cTabTemp)
Local aStruSQL		:= {}
Local lMsFil		:= .F.
Local lFlfLA		:= .F.

Default lTabTemp	:= .F.
Default cTabTemp	:= ""
Default cQuery		:= ""


lMsFil := (FLF->(ColumnPos("FLF_MSFIL")) > 0)
lFlfLA	:= (FLF->(ColumnPos('FLF_LA')) > 0 )

cQuery := "select R_E_C_N_O_ REGFLF from " + RetSQLName("FLF") + " FLF " 

If MV_PAR14 == 1 .And. lMsFil
	cQuery += " where FLF.FLF_MSFIL BETWEEN '" + mv_par15 + "' and '" + mv_par16 + "'"
Else
	cQuery += " where FLF.FLF_FILIAL ='" + xFilial("FLF") + "'"
Endif

cQuery += " and FLF.FLF_STATUS = '7'"
If lFlfLa
	cQuery += " and FLF.FLF_LA = ' '"
Endif
cQuery += " and FLF.D_E_L_E_T_= ' '"


cQuery += " and  FLF.FLF_PRESTA IN ("
	cQuery += " SELECT FO7_PRESTA FROM " + RetSQLName("FO7") + " FO7 "
	
	
	If MV_PAR06 == 1 .OR. MV_PAR06 == 4
		cQuery += " JOIN " + RetSQLName("SE1") + " SE1 ON"
		cQuery += " FO7.FO7_FILIAL = SE1.E1_FILIAL AND "
		cQuery += " FO7.FO7_PREFIX = SE1.E1_PREFIXO AND "
		cQuery += " FO7.FO7_TITULO = SE1.E1_NUM AND "
		cQuery += " FO7.FO7_PARCEL = SE1.E1_PARCELA AND "
		cQuery += " FO7.FO7_TIPO = SE1.E1_TIPO AND "
		cQuery += " FO7.FO7_CLIFOR = SE1.E1_CLIENTE AND "
		cQuery += " FO7.FO7_LOJA = SE1.E1_LOJA AND "
		If mv_par12 == 1
			cQuery += " SE1.E1_EMIS1 ='"+DTOS(mv_par04)+"' AND" 
		Else
			cQuery += " SE1.E1_EMIS1 BETWEEN '"+DTOS(mv_par04)+"' AND '"+DTOS(mv_par05)+"' AND "
		Endif
		cQuery += " SE1.D_E_L_E_T_= ' ' "
		cQuery += " WHERE FO7.FO7_FILIAL =FLF.FLF_FILIAL AND FO7.FO7_PRESTA = FLF.FLF_PRESTA AND FO7.D_E_L_E_T_= ' ' "
		cQuery += "AND FO7.FO7_RECPAG='R')"
	Endif
	If MV_PAR06 == 4
		cQuery += " UNION "
		cQuery += "select R_E_C_N_O_ REGFLF from " + RetSQLName("FLF") + " FLF " 
	
		If MV_PAR14 == 1 .And. lMsFil
			cQuery += " where FLF.FLF_MSFIL BETWEEN '" + mv_par15 + "' and '" + mv_par16 + "'"
		Else
			cQuery += " where FLF.FLF_FILIAL ='" + xFilial("FLF") + "'"
		Endif
		If MV_PAR06 == 1
			cQuery += " and FLF.FLF_RECPAG = 'R'"
		ElseIf MV_PAR06 == 2 
			cQuery += " and FLF.FLF_RECPAG = 'P'"
		Endif
		cQuery += " and FLF.FLF_STATUS = '7'"
		If lFlfLa
			cQuery += " and FLF.FLF_LA = ' '"
		Endif
		cQuery += " and FLF.D_E_L_E_T_= ' '"
		
		cQuery += " and  FLF.FLF_PRESTA IN ("
		cQuery += " SELECT FO7_PRESTA FROM " + RetSQLName("FO7") + " FO7 "
	EndIf
	
	If MV_PAR06 == 2 .OR. MV_PAR06 == 4
		cQuery += " JOIN " + RetSQLName("SE2") + " SE2 ON"
		cQuery += " FO7.FO7_FILIAL = SE2.E2_FILIAL AND "
		cQuery += " FO7.FO7_PREFIX = SE2.E2_PREFIXO AND "
		cQuery += " FO7.FO7_TITULO = SE2.E2_NUM AND "
		cQuery += " FO7.FO7_PARCEL = SE2.E2_PARCELA AND "
		cQuery += " FO7.FO7_TIPO = SE2.E2_TIPO AND "
		cQuery += " FO7.FO7_CLIFOR = SE2.E2_FORNECE AND "
		cQuery += " FO7.FO7_LOJA = SE2.E2_LOJA AND "
		If mv_par12 == 1
			cQuery += " SE2.E2_EMIS1 = '"+DTOS(mv_par04)+"' AND"
		Else
			cQuery += " SE2.E2_EMIS1 BETWEEN '"+DTOS(mv_par04)+"' AND '"+DTOS(mv_par05)+"' AND "
		Endif
		cQuery += " SE2.D_E_L_E_T_= ' ' "
		cQuery += " WHERE FO7.FO7_FILIAL =FLF.FLF_FILIAL AND FO7.FO7_PRESTA = FLF.FLF_PRESTA AND FO7.D_E_L_E_T_= ' ' "
		cQuery += "AND FO7.FO7_RECPAG='P')"
	Endif
	
		cQuery += " UNION "
		cQuery += "select R_E_C_N_O_ REGFLF from " + RetSQLName("FLF") + " FLF " 
	
		If MV_PAR14 == 1 .And. lMsFil
			cQuery += " where FLF.FLF_MSFIL BETWEEN '" + mv_par15 + "' and '" + mv_par16 + "'"
		Else
			cQuery += " where FLF.FLF_FILIAL ='" + xFilial("FLF") + "'"
		Endif
		cQuery += " and FLF.FLF_STATUS = '8'"
		If lFlfLa
			cQuery += " and FLF.FLF_LA = ' '"
		Endif
		cQuery += " and FLF.D_E_L_E_T_= ' '"
		
		cQuery += " and  FLF.FLF_PRESTA IN ("
		cQuery += "  SELECT FLN_PRESTA FROM " + RetSQLName("FLN") + " FLN "
		cQuery += " WHERE FLN.FLN_FILIAL =FLF.FLF_FILIAL AND "
		cQuery += " FLN.FLN_TIPO = FLF.FLF_TIPO AND "
		cQuery += " FLN.FLN_PARTIC = FLF.FLF_PARTIC AND " 
		cQuery += " FLN.FLN_STATUS = '2' AND " 
		If mv_par12 == 1
			cQuery += " FLN.FLN_DTAPRO ='"+DTOS(mv_par04)+"' AND" 
		Else
			cQuery += " FLN.FLN_DTAPRO BETWEEN '"+DTOS(mv_par04)+"' AND '"+DTOS(mv_par05)+"' AND "
		Endif
		cQuery += " FLN.D_E_L_E_T_= ' ')"

If lTabTemp
	cTabTemp := FINNextAlias()
	aStruSQL := {}
	AADD(aStruSQL,{"REGFLF" ,"N",10,00})
	AADD(aStruSQL,{"CTBFLAG","C",02,00})

	MsErase(cTabTemp)
	MsCreate(cTabTemp, aStruSQL, 'TOPCONN' )
	Sleep(1000)
	DbUseArea( .T., 'TOPCONN', cTabTemp, cTabTemp, .T., .F. )
	SqlToTrb(cQuery, aStruSQL, cTabTemp)
Endif
Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} JobCtbViag()
Executa o job para os registros de prestação de contas de viagens.

@author Marcello Gabriel
@since 18/08/2016
@version 12.1.7
/*/
static Function JOBCTBViag(cEmpX,cFilX,cMarca,cFileLck,cCpoFlag,cTabMaster,aStructTab,cTabJob,cId,cVarStatus,cChave,cXUserId,cXUserName,cXAcesso,cXUsuario)
Local nHandle	 := 0
Local lRet		 := .T.

Private lMsErroAuto 
Private lMsHelpAuto 
Private lAutoErrNoFile 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre o arquivo de Lock parao controle externo das threads³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := FINLock(cFileLck)

// STATUS 1 - Iniciando execucao do Job
PutGlbValue(cVarStatus,stThrStart)

//Seta job para nao consumir licensas
RpcSetType(3)
RpcClearEnv()
// Seta job para empresa filial desejada
RpcSetEnv( cEmpX,cFilX,,,,,)

// STATUS 2 - Conexao efetuada com sucesso
PutGlbValue(cVarStatus,stThrConnect)

//Set o usuário para buscar as perguntas do profile
lMsErroAuto := .F.
lMsHelpAuto := .T. 
lAutoErrNoFile := .T.

__cUserId := cXUserId 
cUserName := cXUserName
cAcesso   := cXAcesso
cUsuario  := cXUsuario

cTabJob	 := SelFINJob(cVarStatus,cTabMaster,aStructTab,cCpoFlag,cMarca,cTabJob,cChave)

// Realiza o processamento
lRet := FCTBA677(,,,,,,,cTabJob,.T.)

JOBFINEnd(cVarStatus,nHandle,lRet)

If Select(cTabJob) > 0
	(cTabJob)->(dbCloseArea())
EndIf

Return()


//MOVIMENTAÇÃO BANCARIA
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbMMov   ºAutor  ³Alvaro Camillo Neto º Data ³  31/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Contabilização de movimentacao bancaria                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbMMov(nNumProc,lMovNorm,cTabJOB)
Local aArea 		:= GetArea()
Local lRet			:= .T.
Local nX			:= 0
Local aProcs 		:= {}
Local cTabMult		:= ""// Tabela fisica para o processamento multi thread
Local cChave		:= ""
Local nTotalReg		:= 0
Local cRaizNome		:= 'CTBFINPROC'
Local aStruSQL		:= {}
Local cPerg			:= "FIN370"
Local nMaxReg		:= SuperGetMv("MV_CTBNMRB",.T.,0)	// Numero Maximo de registros a contabilizar. (Tratamento para evitar estouro na TEMPDB)
Local nSaldoReg		:= 0

If !__lSchedule
	Pergunte(cPerg,.F.)
EndIf
If mv_par07 == 1 //DATA
	cChave := "E5_FILIAL+E5_DATA+E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
ElseIf mv_par07 == 2		//DATA DE DIGITACAO
	cChave := "E5_FILIAL+E5_DTDIGIT+E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
Else 							//DATA DE DISPONIBILIDADE
	cChave := "E5_FILIAL+E5_DTDISPO+E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ"
Endif

If !lMovNorm
	cChave := StrTran(cChave,'E5_RECPAG+E5_NUMCHEQ+E5_DOCUMEN','E5_PROCTRA+E5_RECPAG')
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTabMult := CtbGrvMov(lMovNorm,cChave,@nTotalReg)
nMaxReg := If(EMPTY(nMaxReg),nTotalReg,nMaxReg)	// Se não informado pelo parâmetro assume a quantidade total como padrão

If !Empty(cTabMult) .And. (cTabMult)->(!EOF())
	
	While lRet .and. nTotalReg > 0

		If nTotalReg >= nMaxReg
			nSaldoReg := (nTotalReg - nMaxReg)	// Continua no Laço While
		Else
			nSaldoReg := 0
		EndIf
		
		aStruSQL := (cTabMult)->( DbStruct() )
		aProcs := CTBPrepFIN(@nNumProc,cTabMult,MIN(nMaxReg,nTotalReg),"CTBFLAG",cRaizNome, IIF(lMovNorm , "", "E5_DOCUMEN" ) )
	
		If  nTotalReg >= nNumProc .And. nNumProc > 1 // MultiThread
			nTotalReg := nSaldoReg
			
			//Inicializa as Threads Transação controlada nas Threads
			For nX := 1 to Len(aProcs)
				StartJob("JOBCTBMOV", GetEnvServer(), .F., cEmpAnt,cFilAnt,aProcs[nX][MARCA],aProcs[nX][ARQUIVO],"CTBFLAG",cTabMult,aStruSQL,cTabJob,cValToChar(nX),aProcs[nX][VAR_STATUS],cChave,__cUserId,cUserName,cAcesso,cUsuario,_oCTBAFIN:GETREALNAME())
				Sleep(6000)
			Next nX
			
			//NAO RETIRAR A INSTRUCAO DO SLEEP
			//Esperar 30 segundos antes de monitorar para dar tempo das threads criar arquivo de semaforo
			Sleep(30000)
			//Realiza o controle das Threads
			lRet := FINMonitor(aProcs,4)
		ElseIf nNumProc == 1
			cTabJob	 := SelFINJob(NIL,cTabMult,aStruSQL,"CTBFLAG",aProcs[nNumProc][MARCA],cTabJob,cChave,_oCTBAFIN:GETREALNAME())
			lRet 	 := CtbMTProc('SE5',cTabJob)
			If Select(cTabJob) > 0
				(cTabJob)->(dbCloseArea())
			EndIf
				
			nTotalReg := 0	//  Deve sair do laço While
		EndIf
		
	EndDo	
EndIf

If Select(cTabMult) > 0
	(cTabMult)->( dbCloseArea() )
Endif

CTBClean()
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbGrvMov  ºAutor  ³Alvaro Camillo Netoº Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava arquivo temporario das movimentacoes bancarias        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbGrvMov(lMovNorm,cChave, nTotalReg)
Local cPerg 	 	:= "FIN370"
Local aStruSQL		:= {}
Local cTab			:= ""
Local cQuery		:= ""
Local cQuery2		:= ""
Local cCamposSel	:= ''
Local cCamposIns	:= ''
Local aStruSE5   	:= {}
Local cAliasCNT		:= ''
Local l370E5FIL := Existblock("F370E5F")   // Criado Ponto de Entrada

Default nTotalReg	:= 0

If !__lSchedule
	Pergunte(cPerg,.F.)
EndIf

dbSelectArea("SE5")
dbSetOrder(1)

// Montagem da estrtura do arquivo
aStruSE5  := SE5->(DbStruct())
aStruSQL := aClone(aStruSE5)
AADD(aStruSQL,{"SE5RECNO"   	,"N",15,00})
AADD(aStruSQL,{"CTBFLAG" 		,"C",02,00})

// Cria tabela temporaria
cTab := CriaTMP('SE5',aStruSQL,cChave) 

// Montagem da Query
cCamposSel := ''
cCamposIns := ''
aEval(aStruSE5,{|e,i| cCamposIns += If(i==1,'',",")+AllTrim(e[1])})
cCamposSel := cCamposIns
If !_MSSQL7
	cCamposIns += ',SE5RECNO,CTBFLAG,R_E_C_N_O_'
Else
	cCamposIns += ',SE5RECNO,CTBFLAG'
EndIf 

cQuery := "SELECT " + cCamposSel
If !_MSSQL7
	cQuery += ",SE5.R_E_C_N_O_ SE5RECNO," + _cSpaceMark + " CTBFLAG,SE5.R_E_C_N_O_"
Else
	cQuery += ",SE5.R_E_C_N_O_ SE5RECNO," + _cSpaceMark + " CTBFLAG"
EndIf 
cQuery += "  FROM " + RetSqlName("SE5") + " SE5 "

If mv_par14 == 1
	If lPosE5MsFil .AND. !lUsaFilOri
	cQuery += "WHERE E5_MSFIL = '"  + cFilAnt + "' AND "
	Else
		cQuery += "WHERE E5_FILORIG = '"  + cFilAnt + "' AND "
	Endif
Else
	cQuery += "WHERE E5_FILIAL = '" + xFilial("SE5") + "' AND "
EndIf

If mv_par07 == 1			//DATA
	cQuery += "E5_DATA BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
ElseIf mv_par07 == 2		//DATA DE DIGITACAO
	cQuery += "E5_DTDIGIT    between '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
Else 							//DATA DE DISPONIBILIDADE
	cQuery += "E5_DTDISPO    between '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
Endif

cQuery += "E5_TIPODOC IN ('PA','RA','BA','VL','V2','AP','EP','PE','RF','IF','CP','TL','ES','TR','DB','OD','LJ','E2','TE','  ')  AND "
cQuery += "E5_SITUACA <> 'C' AND "
cQuery += "(E5_LA <> 'S ' OR ((E5_ORDREC " + _cOperador + " E5_SERREC) <> '' AND E5_RECPAG = 'R' AND E5_TIPODOC = 'BA'))  AND "  // Filtra registros de Recebimentos Diversos p/Contabilizacao

If lMovNorm
	cQuery += " (E5_DOCUMEN = ' ' AND E5_NUMCHEQ = ' ') AND "
Else
	cQuery += " (E5_DOCUMEN <> ' ' OR E5_NUMCHEQ <> ' ') AND "
EndIf

cQuery += "D_E_L_E_T_ = ' ' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para filtrar registros do SE5. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l370E5FIL
	cQuery := Execblock("F370E5F",.F.,.F.,cQuery)
EndIf

// seta a ordem de acordo com a opcao do usuario
cQuery += " ORDER BY " + SqlOrder(cChave)

//Inicio do bloco que substitui SqlToTrb
cQuery2 := " INSERT "
If _cSGBD == "ORACLE"
	cQuery2 += " /*+ APPEND */ "
Endif
cQuery2 += " INTO " + _oCTBAFIN:GETREALNAME() + " ("+cCamposIns+") " + cQuery

If cQuery2 = ''
	MsgAlert(STR0060)  //Erro de Parse no Insert
Endif
If TcSqlExec(cQuery2) <> 0
	MsgAlert(STR0061) // "Erro no Insert"
EndIf

cQuery := "SELECT COUNT(*) QUANT "
cQuery += "  FROM " + _oCTBAFIN:GETREALNAME() + " TAB "
cQuery := ChangeQuery( cQuery )

cAliasCNT := GetNextAlias()
dbUseArea( .T. , "TOPCONN" , TCGenQry(,,cQuery) , cAliasCNT )
(cAliasCNT)->(DbGoTop())
nTotalReg := (cAliasCNT)->QUANT
(cAliasCNT)->(dbCloseArea())

//tiro o arquivo de eof
DbSelectArea(cTab)
(cTab)->(dbGoTop())
//Fim do bloco que substitui SqlToTrb

RETURN cTab
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JOBCTBMov ºAutor  ³Alvaro Camillo Neto º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job da contabilização de movimentacoes bancarias           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function JOBCTBMov(cEmpX,cFilX,cMarca,cFileLck,cCpoFlag,cTabMaster,aStructTab,cTabJob,cId,cVarStatus,cChave,cXUserId,cXUserName,cXAcesso,cXUsuario,cFWTMP)
Local nHandle	 := 0
Local lRet		 := .T.

Private lMsErroAuto 
Private lMsHelpAuto 
Private lAutoErrNoFile 

DEFAULT cFWTMP	:= ''

cFilAnt := cFilX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre o arquivo de Lock parao controle externo das threads³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := FINLock(cFileLck)

If  nHandle >= 0
	PutGlbValue(cVarStatus,stThrStart)

	//Seta job para nao consumir licensas
	RpcSetType(3)
	RpcClearEnv()
	// Seta job para empresa filial desejada
	RpcSetEnv( cEmpX,cFilX,,,,,)

	PutGlbValue(cVarStatus,stThrConnect)

	//Set o usuário para buscar as perguntas do profile
	lMsErroAuto := .F.
	lMsHelpAuto := .T. 
	lAutoErrNoFile := .T.

	__cUserId := cXUserId 
	cUserName := cXUserName
	cAcesso   := cXAcesso
	cUsuario  := cXUsuario
	
	//cria temporario de contabilizacao no banco de dados e otimiza validacao do lancamento
	If _lCtbIniLan
		CtbIniLan()
	EndIf
	
	cTabJob	 := SelFINJob(cVarStatus,cTabMaster,aStructTab,cCpoFlag,cMarca,cTabJob,cChave,cFWTMP)

	// Realiza o processamento
	lRet := CtbmtProc('SE5',cTabJob)

	JOBFINEnd(cVarStatus,nHandle,lRet)

	If Select(cTabJob) > 0
		(cTabJob)->(dbCloseArea())
	EndIf

	//exclui temporario de contabilizacao utilizado para otimizacao validacao do lancamento
	If FindFunction("CtbFinLan")
		//FINALIZA E APAGA ARQUIVO TMP NO BANCO
		CtbFinLan()
	EndIf
	
Else
	PutGlbValue(cVarStatus,stThrError)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbProcMov ºAutor  ³Alvaro Camillo Netoº Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     Processa a contabilização                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbProcMov(cTabCtb)
Local aArea := GetArea()
Local lRet := .T.

(cTabCtb)->(dbGoTop())
CTBFINProc(.T.,.F.,Nil,.F.,Nil,.F.,Nil,.T.,cTabCtb,.T.,.F.,Nil)

RestArea(aArea)
Return lRet

// CAIXINHA

/*/{Protheus.doc} CtbMCaix
//Consulta, prepara e executa a contabilização do caixinha.
@author norbertom
@since 10/02/2019
@version P!@
@param nNumProc, numeric, description
@return return, return_description
@example
CtbMCaix(nNumProc)
@see (links_or_references)
/*/
Static Function CtbMCaix(nNumProc)
Local aArea 		:= GetArea()
Local lRet			:= .T.
Local nX			:= 0
Local aProcs 		:= {}
Local cTabMult		:= ""// Tabela fisica para o processamento multi thread
Local cChave        := ""

Local nTotalReg	:= 0
Local cRaizNome	:= 'CTBFINPROC'
Local aStruSQL	:= {}
Local cTabJob	:= "TRBSEU"

cChave := "EU_FILIAL+EU_CAIXA+DATASEU"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTabMult := CtbGrvCaix(cChave,@nTotalReg)

If !Empty(cTabMult) .And. (cTabMult)->(!EOF())
	
	aStruSQL := (cTabMult)->( DbStruct() )
	aProcs := CTBPrepFIN(@nNumProc,cTabMult,nTotalReg,"CTBFLAG",cRaizNome)

	If  nTotalReg >= nNumProc .And. nNumProc > 1 // MultiThread
		
		//Inicializa as Threads Transação controlada nas Threads
		For nX := 1 to Len(aProcs)
			StartJob("JOBCTBCAIX", GetEnvServer(), .F., cEmpAnt,cFilAnt,aProcs[nX][MARCA],aProcs[nX][ARQUIVO],"CTBFLAG",cTabMult,aStruSQL,cTabJob,cValToChar(nX),aProcs[nX][VAR_STATUS],cChave,__cUserId,cUserName,cAcesso,cUsuario,_oCTBAFIN:GETREALNAME())
			Sleep(6000)
		Next nX
		
		//NAO RETIRAR A INSTRUCAO DO SLEEP
		//Esperar 30 segundos antes de monitorar para dar tempo das threads criar arquivo de semaforo
		Sleep(30000)  
		//Realiza o controle das Threads
		lRet := FINMonitor(aProcs,3)
	ElseIf nNumProc == 1
		cTabJob	 := SelFINJob(NIL,cTabMult,aStruSQL,"CTBFLAG",aProcs[nNumProc][MARCA],cTabJob,cChave,_oCTBAFIN:GETREALNAME())
		lRet 	 := CtbMTProc('SEU',cTabJob)
		If Select(cTabJob) > 0
			(cTabJob)->(dbCloseArea())
		EndIf
	EndIf
EndIf

If Select(cTabMult) > 0
	(cTabMult)->( dbCloseArea() )
Endif

CTBClean()
RestArea(aArea)
Return lRet 

/*/{Protheus.doc} CtbMCheq
//Monta a consulta e cria a tabela temporária.
@author norbertom
@since 10/02/2019
@version undefined
@param nNumProc, numeric, description
@return return, return_description
@example
CtbGrvCaix(cChave,nTotalReg)
@see (links_or_references)
/*/
Static Function CtbGrvCaix(cChave,nTotalReg)
Local cPerg 	 	:= "FIN370"
Local aStruSQL		:= {}
Local cTab			:= ""
Local cQuery		:= ""
Local cQuery2		:= ""
Local cCamposSel	:= ''
Local cCamposAux	:= ''
Local cCamposIns	:= ''
Local aStruAux		:= {}
Local aStruSEU   	:= {}
Local cAliasCNT		:= NIL
Local nI			:= NIL

Default cChave		:= ''
Default nTotalReg	:= 0

If !__lSchedule
	Pergunte(cPerg,.F.)
EndIf

If mv_par07 == 1
	cCamposSel := "EU_FILIAL,EU_CAIXA,EU_BAIXA AS DATASEU, 'OUTROS' AS TIPOMOV "
Else
	cCamposSel := "EU_FILIAL,EU_CAIXA,EU_DTDIGIT AS DATASEU, 'OUTROS' AS TIPOMOV "
EndIf

// Montagem da estrtura do arquivo
dbSelectArea("SEU")
SEU->(dbSetOrder(1))
aStruAux := SEU->(dbStruct())
For nI := 1 TO LEN(aStruAux)
	If ALLTRIM(aStruAux[nI][1]) $ cCamposSel
		If ALLTRIM(aStruAux[nI][1])$"EU_BAIXA/EU_DTDIGIT"
			AADD(aStruSEU,{"DATASEU"   	,"D",8,00})	
		Else
			AADD(aStruSEU,aStruAux[nI])
		EndIf
	EndIf
Next nI
aStruSQL := aClone(aStruSEU)

AADD(aStruSQL,{"TIPOMOV"   	,"C",10,00})
AADD(aStruSQL,{"SEURECNO"   ,"N",15,00})
AADD(aStruSQL,{"CTBFLAG" 	,"C",02,00})

// Cria tabela temporaria
cTab := CriaTMP('SEU',aStruSQL,cChave) 

// Montagem da Query
aEval(aStruSEU,{|e,i| cCamposIns += If(i==1,'',",")+AllTrim(e[1])})
cCamposAux := cCamposIns

If !_MSSQL7
	cCamposIns += ", TIPOMOV,CTBFLAG,R_E_C_N_O_"
Else
	cCamposIns += ", TIPOMOV,CTBFLAG "
EndIf 

cQuery := "SELECT DISTINCT " + cCamposSel

If !_MSSQL7
	cQuery += "," + _cSpaceMark + " CTBFLAG,SEU.R_E_C_N_O_"
Else
	cQuery += "," + _cSpaceMark + " CTBFLAG"
EndIf 

cQuery += "  FROM " + RetSqlName("SEU")+" SEU "

If mv_par14 == 1
	If lPosEfMsFil .AND. !lUsaFilOri
		cQuery += "WHERE SEU.EU_MSFIL = '"  + cFilAnt + "' AND "
	Else
		cQuery += "WHERE SEU.EU_FILORI = '"  + cFilAnt + "' AND "
	Endif		
Else
	cQuery += "WHERE SEU.EU_FILIAL = '" + xFilial("SEU") + "' AND "
EndIf
If mv_par07 == 1
	cQuery += " SEU.EU_BAIXA   between '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
Else
	cQuery += " SEU.EU_DTDIGIT between '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
EndIf

If _lMvPar18 .And. mv_par18 == 1
	cQuery += "EU_TIPO NOT IN ('01','03') AND  "
EndIf

cQuery += " SEU.EU_LA <> 'S' AND "
cQuery += " SEU.D_E_L_E_T_ = ' ' "

If _lMvPar18 .And. mv_par18 == 1
	cQuery += " UNION "
						
	cQuery += "SELECT DISTINCT EU_FILIAL, EU_CAIXA, EU_DTDIGIT AS DATASEU, 'ADTO' AS TIPOMOV "
	If !_MSSQL7
		cQuery += "," + _cSpaceMark + " CTBFLAG,SEU.R_E_C_N_O_"
	Else
		cQuery += "," + _cSpaceMark + " CTBFLAG"
	EndIf 
	cQuery += "  FROM " + RetSqlName("SEU")+" SEU "

	If mv_par14 == 1
		If lPosEfMsFil .AND. !lUsaFilOri
			cQuery += "WHERE SEU.EU_MSFIL = '"  + cFilAnt + "' AND "
		Else
			cQuery += "WHERE SEU.EU_FILORI = '"  + cFilAnt + "' AND "
		Endif		
	Else
		cQuery += "WHERE SEU.EU_FILIAL = '" + xFilial("SEU") + "' AND "
	EndIf
	cQuery += " SEU.EU_DTDIGIT BETWEEN '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
	cQuery +=  "SEU.EU_TIPO IN ('01','03') AND "
	cQuery += " SEU.EU_LA <> 'S' AND "
	cQuery += " SEU.D_E_L_E_T_ = ' ' "
EndIf

// seta a ordem de acordo com a opcao do usuario
cQuery += " ORDER BY " + SqlOrder(cChave)

//Inicio do bloco que substitui SqlToTrb
cQuery2 := " INSERT "
If _cSGBD == "ORACLE"
	cQuery2 += " /*+ APPEND */ "
Endif
cQuery2 += " INTO " + _oCTBAFIN:GETREALNAME() + " ("+cCamposIns+") " + cQuery

if cQuery2 = ''
	MsgAlert(STR0060) //"Erro de Parse no Insert"
Endif
If TcSqlExec(cQuery2) <> 0
	MsgAlert(STR0061) //"Erro no Insert"
EndIf

cQuery := "SELECT COUNT(*) QUANT "
cQuery += "  FROM " + _oCTBAFIN:GETREALNAME() + " TAB "
cQuery := ChangeQuery( cQuery )

cAliasCNT := GetNextAlias()
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasCNT )
(cAliasCNT)->(DbGoTop())
nTotalReg := (cAliasCNT)->QUANT
(cAliasCNT)->(dbCloseArea())

//tiro o arquivo de eof
DbSelectArea(cTab)
(cTab)->(dbGoTop())
//Fim do bloco que substitui SqlToTrb

RETURN cTab

/*/{Protheus.doc} JOBCTBCaix
// Lançador das threads Caixinha.
@author norbertom
@since 10/02/2019
@version undefined
@param nNumProc, numeric, description
@return return, return_description
@example
JOBCTBCaix(cEmpX,cFilX,cMarca,cFileLck,cCpoFlag,cTabMaster,aStructTab,cTabJob,cId,cVarStatus,cChave,cXUserId,cXUserName,cXAcesso,cXUsuario,cFWTMP)
@see (links_or_references)
/*/
static Function JOBCTBCaix(cEmpX,cFilX,cMarca,cFileLck,cCpoFlag,cTabMaster,aStructTab,cTabJob,cId,cVarStatus,cChave,cXUserId,cXUserName,cXAcesso,cXUsuario,cFWTMP)
Local nHandle	 := 0
Local lRet		 := .T.

Private lMsErroAuto 
Private lMsHelpAuto 
Private lAutoErrNoFile 

DEFAULT cFWTMP	:= ''

cFilAnt := cFilX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre o arquivo de Lock parao controle externo das threads³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := FINLock(cFileLck)

If  nHandle >= 0
	PutGlbValue(cVarStatus,stThrStart)

	//Seta job para nao consumir licensas
	RpcSetType(3)
	RpcClearEnv()
	// Seta job para empresa filial desejada
	RpcSetEnv( cEmpX,cFilX,,,,,)

	PutGlbValue(cVarStatus,stThrConnect)

	//Set o usuário para buscar as perguntas do profile
	lMsErroAuto := .F.
	lMsHelpAuto := .T. 
	lAutoErrNoFile := .T.

	__cUserId := cXUserId 
	cUserName := cXUserName
	cAcesso   := cXAcesso
	cUsuario  := cXUsuario

	//cria temporario de contabilizacao no banco de dados e otimiza validacao do lancamento
	If _lCtbIniLan
		CtbIniLan()
	EndIf
	
	cTabJob	 := SelFINJob(cVarStatus,cTabMaster,aStructTab,cCpoFlag,cMarca,cTabJob,cChave,cFWTMP)

	// Realiza o processamento
	lRet := CtbMTProc('SEU',cTabJob)

	JOBFINEnd(cVarStatus,nHandle,lRet)

	If Select(cTabJob) > 0
		(cTabJob)->(dbCloseArea())
	EndIf

	//exclui temporario de contabilizacao no banco de dados utilizado para otimizacao validacao do lancamento
	If FindFunction("CtbFinLan")
		//FINALIZA E APAGA ARQUIVO TMP NO BANCO
		CtbFinLan()
	EndIf
	
Else
	PutGlbValue(cVarStatus,stThrError)
EndIf

Return

/*/{Protheus.doc} CtbProcCheq()
//Função de contabilização chamada a partir da thread
@author norbertom
@since 10/02/2019
@version undefined
@param nNumProc, numeric, description
@return return, return_description
@example
CtbProcCheq(cTabCtb)
@see (links_or_references)
/*/
Static Function CtbProcCaix(cTabCtb)
Local aArea := GetArea()
Local lRet := .T.

(cTabCtb)->(dbGoTop())
CTBFINProc(.T.,.F.,Nil,.F.,Nil,.F.,Nil,.F.,Nil,.T.,.T.,cTabCTB)

RestArea(aArea)
Return lRet

//CHEQUES

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbMCheq   ºAutor  ³Alvaro Camillo Neto º Data ³  31/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Contabilização de cheques                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbMCheq(nNumProc)
Local aArea 		:= GetArea()
Local lRet			:= .T.
Local nX			:= 0
Local aProcs 		:= {}
Local cTabMult		:= ""// Tabela fisica para o processamento multi thread
Local cChave        := "EF_FILIAL+EF_DATA+EF_BANCO+EF_AGENCIA+EF_CONTA"

Local nTotalReg	:= 0
Local cRaizNome	:= 'CTBFINPROC'
Local aStruSQL	:= {}
Local cTabJob	:= "TRBSEF"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTabMult := CtbGrvCheq(cChave,@nTotalReg)

If !Empty(cTabMult) .And. (cTabMult)->(!EOF())
	
	aStruSQL := (cTabMult)->( DbStruct() )
	aProcs := CTBPrepFIN(@nNumProc,cTabMult,nTotalReg,"CTBFLAG",cRaizNome)

	If  nTotalReg >= nNumProc .And. nNumProc > 1 // MultiThread
		
		//Inicializa as Threads Transação controlada nas Threads
		For nX := 1 to Len(aProcs)
			StartJob("JOBCTBCHEQ", GetEnvServer(), .F., cEmpAnt,cFilAnt,aProcs[nX][MARCA],aProcs[nX][ARQUIVO],"CTBFLAG",cTabMult,aStruSQL,cTabJob,cValToChar(nX),aProcs[nX][VAR_STATUS],cChave,__cUserId,cUserName,cAcesso,cUsuario,_oCTBAFIN:GETREALNAME())
			Sleep(6000)
		Next nX
		
		//NAO RETIRAR A INSTRUCAO DO SLEEP
		//Esperar 30 segundos antes de monitorar para dar tempo das threads criar arquivo de semaforo
		Sleep(30000)  
		//Realiza o controle das Threads
		lRet := FINMonitor(aProcs,3)
	ElseIf nNumProc == 1
		cTabJob	 := SelFINJob(NIL,cTabMult,aStruSQL,"CTBFLAG",aProcs[nNumProc][MARCA],cTabJob,cChave,_oCTBAFIN:GETREALNAME())
		lRet 	 := CtbMTProc('SEF',cTabJob)
		If Select(cTabJob) > 0
			(cTabJob)->(dbCloseArea())
		EndIf
	EndIf
EndIf

If Select(cTabMult) > 0
	(cTabMult)->( dbCloseArea() )
Endif

CTBClean()
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbGrvCheq  ºAutor  ³Alvaro Camillo Netoº Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava arquivo temporario dos cheques                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbGrvCheq(cChave,nTotalReg)
Local cPerg 	 	:= "FIN370"
Local aStruSQL		:= {}
Local cTab			:= ""
Local cQuery		:= ""
Local cQuery2		:= ""
Local cCamposSel	:= ''
Local cCamposIns	:= ''
Local aStruSEF   	:= {}
Local cAliasCNT
Local l370EFFIL 	:= Existblock("F370EFF")   // Criado Ponto de Entrada

Default nTotalReg	:= 0

If !__lSchedule
	Pergunte(cPerg,.F.)
EndIf

dbSelectArea("SEF")
dbSetOrder(1)

// Montagem da estrtura do arquivo
aStruSEF  := SEF->(dbStruct())
aStruSQL := aClone(aStruSEF)
AADD(aStruSQL,{"SEFRECNO"   	,"N",15,00})
AADD(aStruSQL,{"CTBFLAG" 		,"C",02,00})

// Cria tabela temporaria
cTab := CriaTMP('SEF',aStruSQL,cChave) 

// Montagem da Query
cCamposSel := ''
cCamposIns := ''
aEval(aStruSEF,{|e,i| cCamposIns += If(i==1,'',",")+AllTrim(e[1])})
cCamposSel := cCamposIns
If !_MSSQL7
	cCamposIns += ',SEFRECNO,CTBFLAG,R_E_C_N_O_'
Else
	cCamposIns += ',SEFRECNO,CTBFLAG'
EndIf 

cQuery := "SELECT " + cCamposSel
If !_MSSQL7
	cQuery += ",SEF.R_E_C_N_O_ SEFRECNO," + _cSpaceMark + " CTBFLAG,SEF.R_E_C_N_O_"
Else
	cQuery += ",SEF.R_E_C_N_O_ SEFRECNO," + _cSpaceMark + " CTBFLAG"
EndIf 

cQuery += "  FROM " + RetSqlName("SEF")+" SEF "

If mv_par14 == 1
	If lPosEfMsFil .AND. !lUsaFilOri
		cQuery += "WHERE EF_MSFIL = '"  + cFilAnt + "' AND "
	Else
		cQuery += "WHERE EF_FILORIG = '"  + cFilAnt + "' AND "
	Endif		
Else
	cQuery += "WHERE EF_FILIAL = '" + xFilial("SEF") + "' AND "
EndIf
cQuery += " EF_DATA    between '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "
cQuery += " EF_LA <> 'S' AND "
cQuery += " D_E_L_E_T_ = ' ' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para filtrar registros do SE2. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l370EFFIL
	cQuery += Execblock("F370EFF",.F.,.F.,cQuery)
EndIf

// seta a ordem de acordo com a opcao do usuario
cQuery += " ORDER BY " + SqlOrder(cChave)

//Inicio do bloco que substitui SqlToTrb
cQuery2 := " INSERT "
If _cSGBD == "ORACLE"
	cQuery2 += " /*+ APPEND */ "
Endif
cQuery2 += " INTO " + _oCTBAFIN:GETREALNAME() + " ("+cCamposIns+") " + cQuery

if cQuery2 = ''
	MsgAlert(STR0060) //"Erro de Parse no Insert"
Endif
If TcSqlExec(cQuery2) <> 0
	MsgAlert(STR0061) //"Erro no Insert"
EndIf

cQuery := "SELECT COUNT(*) QUANT "
cQuery += "  FROM " + _oCTBAFIN:GETREALNAME() + " TAB "
cQuery := ChangeQuery( cQuery )

cAliasCNT := GetNextAlias()
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasCNT )
(cAliasCNT)->(DbGoTop())
nTotalReg := (cAliasCNT)->QUANT
(cAliasCNT)->(dbCloseArea())

//tiro o arquivo de eof
DbSelectArea(cTab)
(ctab)->(dbGoTop())
//Fim do bloco que substitui SqlToTrb

RETURN ctab
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JOBCTBCheq  ºAutor  ³Alvaro Camillo Netoº Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job da contabilização de cheques                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function JOBCTBCheq(cEmpX,cFilX,cMarca,cFileLck,cCpoFlag,cTabMaster,aStructTab,cTabJob,cId,cVarStatus,cChave,cXUserId,cXUserName,cXAcesso,cXUsuario,cFWTMP)
Local nHandle	 := 0
Local lRet		 := .T.

Private lMsErroAuto 
Private lMsHelpAuto 
Private lAutoErrNoFile 

DEFAULT cFWTMP	:= ''

cFilAnt := cFilX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre o arquivo de Lock parao controle externo das threads³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := FINLock(cFileLck)

If  nHandle >= 0
	PutGlbValue(cVarStatus,stThrStart)

	//Seta job para nao consumir licensas
	RpcSetType(3)
	RpcClearEnv()
	// Seta job para empresa filial desejada
	RpcSetEnv( cEmpX,cFilX,,,,,)

	PutGlbValue(cVarStatus,stThrConnect)

	//Set o usuário para buscar as perguntas do profile
	lMsErroAuto := .F.
	lMsHelpAuto := .T. 
	lAutoErrNoFile := .T.

	__cUserId := cXUserId 
	cUserName := cXUserName
	cAcesso   := cXAcesso
	cUsuario  := cXUsuario

	//cria temporario de contabilizacao no banco de dados e otimiza validacao do lancamento
	If _lCtbIniLan
		CtbIniLan()
	EndIf
	
	cTabJob	 := SelFINJob(cVarStatus,cTabMaster,aStructTab,cCpoFlag,cMarca,cTabJob,cChave,cFWTMP)

	// Realiza o processamento
	lRet := CtbMTProc('SEF',cTabJob)

	JOBFINEnd(cVarStatus,nHandle,lRet)

	If Select(cTabJob) > 0
		(cTabJob)->(dbCloseArea())
	EndIf

	//exclui temporario de contabilizacao no banco de dados utilizado para otimizacao validacao do lancamento
	If FindFunction("CtbFinLan")
		//FINALIZA E APAGA ARQUIVO TMP NO BANCO
		CtbFinLan()
	EndIf
	
Else
	PutGlbValue(cVarStatus,stThrError)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbProcCheq ºAutor  ³Alvaro Camillo Netoº Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     Processa a contabilização                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbProcCheq(cTabCtb)
Local aArea := GetArea()
Local lRet := .T.

(cTabCtb)->(dbGoTop())
CTBFINProc(.T.,.F.,Nil,.F.,Nil,.T.,cTabCtb,.F.,Nil,.T.,.F.,NIL)

RestArea(aArea)
Return lRet

//CONTAS A PAGAR

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbMPag   ºAutor  ³Alvaro Camillo Neto º Data ³  31/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Contabilização do titulos a pagar                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbMPag(nNumProc)
Local aArea 		:= GetArea()
Local lRet			:= .T.
Local nX			:= 0
Local aProcs 		:= {}
Local cTabMult		:= ""// Tabela fisica para o processamento multi thread
Local cChave 		:= "E2_FILIAL+E2_EMIS1+E2_NUMBOR+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"

Local nTotalReg	:= 0
Local cRaizNome	:= 'CTBFINPROC'
Local aStruSQL	:= {}
Local cTabJob	:= "TRBSE2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTabMult := CtbGrvPag(cChave,@nTotalReg)

If !Empty(cTabMult) .And. (cTabMult)->(!EOF())
	
	aStruSQL := (cTabMult)->( DbStruct() )
	aProcs := CTBPrepFIN(@nNumProc,cTabMult,nTotalReg,"CTBFLAG",cRaizNome)

	If  nTotalReg >= nNumProc .And. nNumProc > 1 // MultiThread
		
		//Inicializa as Threads Transação controlada nas Threads
		For nX := 1 to Len(aProcs)
			StartJob("JOBCTBPAG", GetEnvServer(), .F., cEmpAnt,cFilAnt,aProcs[nX][MARCA],aProcs[nX][ARQUIVO],"CTBFLAG",cTabMult,aStruSQL,cTabJob,cValToChar(nX),aProcs[nX][VAR_STATUS],cChave,__cUserId,cUserName,cAcesso,cUsuario,_oCTBAFIN:GETREALNAME())
			Sleep(6000)
		Next nX
		
		//NAO RETIRAR A INSTRUCAO DO SLEEP
		//Esperar 30 segundos antes de monitorar para dar tempo das threads criar arquivo de semaforo
		Sleep(30000)
		//Realiza o controle das Threads
		lRet := FINMonitor(aProcs,2)
	ElseIf nNumProc == 1
		cTabJob	 := SelFINJob(NIL,cTabMult,aStruSQL,"CTBFLAG",aProcs[nNumProc][MARCA],cTabJob,cChave,_oCTBAFIN:GETREALNAME())
		lRet 	 := CtbMTProc('SE2',cTabJob)
		If Select(cTabJob) > 0
			(cTabJob)->(dbCloseArea())
		EndIf
	EndIf
EndIf

If Select(cTabMult) > 0
	(cTabMult)->( dbCloseArea() )
Endif
CTBClean()
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbGrvPag  ºAutor  ³Alvaro Camillo Netoº Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava arquivo temporario dos titulos a Pagar                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbGrvPag(cChave,nTotalReg)
Local cPerg 	 := "FIN370"
Local aStruSQL		:= {}
Local cTab			:= ""
Local cQuery		:= ""
Local cQuery2		:= ""
Local cCamposSel	:= ''
Local cCamposIns	:= ''
Local aStruSE2		:= {}
Local cSepProv		:= If("|"$MVPROVIS,"|",",")
Local cAliasCNT		:= ''

Static l370E2FIL	:= Existblock("F370E2F")   // Criado Ponto de Entrada

Default nTotalReg	:= 0

If !__lSchedule
	Pergunte(cPerg,.F.)
EndIf
dbSelectArea("SE2")
dbSetOrder(1)

// Montagem da estrtura do arquivo
aStruSE2  := SE2->(dbStruct())
aStruSQL := aClone(aStruSE2)
AADD(aStruSQL,{"SE2RECNO"    	,"N",15,00})
AADD(aStruSQL,{"CTBFLAG" 		,"C",02,00})

// Cria tabela temporaria
cTab := CriaTMP('SE2',aStruSQL,cChave) 

// Montagem da Query
cCamposSel := ''
cCamposIns := ''
aEval(aStruSE2,{|e,i| cCamposIns += If(i==1,'',",")+AllTrim(e[1])})
cCamposSel := cCamposIns
If !_MSSQL7
	cCamposIns += ',SE2RECNO,CTBFLAG,R_E_C_N_O_'
Else
	cCamposIns += ',SE2RECNO,CTBFLAG'
EndIf 

cQuery := "SELECT " + cCamposSel
If !_MSSQL7
	cQuery += ",SE2.R_E_C_N_O_ SE2RECNO," + _cSpaceMark + " CTBFLAG,SE2.R_E_C_N_O_"
Else
	cQuery += ",SE2.R_E_C_N_O_ SE2RECNO," + _cSpaceMark + " CTBFLAG"
EndIf 
cQuery += "  FROM " + RetSqlName("SE2")+" SE2 "

If mv_par14 == 1	
	If lPosE2MsFil .AND. !lUsaFilOri
	cQuery += "WHERE E2_MSFIL = '"  + cFilAnt + "' AND "
Else
		cQuery += "WHERE E2_FILORIG = '"  + cFilAnt + "' AND "
	Endif	
Else
	cQuery += "WHERE E2_FILIAL = '" + xFilial("SE2") + "' AND "
EndIf

cQuery += "E2_EMIS1 between '" + DTOS(mv_par04) + "' AND '" + DTOS(mv_par05) + "' AND "

// Soh adiciona filtro na query se nao contabiliza titulos provisorios
If mv_par17 <> 1
	cQuery += "E2_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " AND "
EndIf

cQuery += " E2_LA <> 'S' AND E2_ORIGEM <> 'FINA677' AND "
cQuery += " D_E_L_E_T_ = ' ' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para filtrar registros do SE2. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If l370E2FIL
	cQuery := Execblock("F370E2F",.F.,.F.,cQuery)
EndIf

// seta a ordem de acordo com a opcao do usuario
cQuery += " ORDER BY " + SqlOrder(cChave)

//Inicio do bloco que substitui SqlToTrb
cQuery2 := " INSERT "
If _cSGBD == "ORACLE"
	cQuery2 += " /*+ APPEND */ "
Endif
cQuery2 += " INTO " + _oCTBAFIN:GETREALNAME() + " ("+cCamposIns+") " + cQuery

if cQuery2 = ''
	MsgAlert(STR0060) //"Erro de Parse no Insert"
Endif
If TcSqlExec(cQuery2) <> 0
	MsgAlert(STR0061) //"Erro no Insert"
EndIf

// Obtem a Contagem de Registros a processar.
cQuery := "SELECT COUNT(*) QUANT "
cQuery += "  FROM " + _oCTBAFIN:GETREALNAME() + " TAB "
cQuery := ChangeQuery( cQuery )

cAliasCNT := GetNextAlias()
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasCNT )
(cAliasCNT)->(DbGoTop())
nTotalReg := (cAliasCNT)->QUANT
(cAliasCNT)->(dbCloseArea())

//tiro o arquivo de eof
DbSelectArea(cTab)
(ctab)->(dbGoTop())
//Fim do bloco que substitui SqlToTrb

RETURN ctab
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JOBCTBPag ºAutor  ³Alvaro Camillo Neto º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job da contabilização do titulo a pagar                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function JOBCTBPag(cEmpX,cFilX,cMarca,cFileLck,cCpoFlag,cTabMaster,aStructTab,cTabJob,cId,cVarStatus,cChave,cXUserId,cXUserName,cXAcesso,cXUsuario,cFWTMP)
Local nHandle	 := 0
Local lRet		 := .T.

Private lMsErroAuto 
Private lMsHelpAuto 
Private lAutoErrNoFile 

DEFAULT cFWTMP	:= ''

cFilAnt := cFilX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre o arquivo de Lock parao controle externo das threads³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := FINLock(cFileLck)

If  nHandle >= 0
	PutGlbValue(cVarStatus,stThrStart)

	//Seta job para nao consumir licensas
	RpcSetType(3)
	RpcClearEnv()
	// Seta job para empresa filial desejada
	RpcSetEnv( cEmpX,cFilX,,,,,)

	PutGlbValue(cVarStatus,stThrConnect)

	//Set o usuário para buscar as perguntas do profile
	lMsErroAuto := .F.
	lMsHelpAuto := .T. 
	lAutoErrNoFile := .T.

	__cUserId := cXUserId 
	cUserName := cXUserName
	cAcesso   := cXAcesso
	cUsuario  := cXUsuario

	//cria temporario de contabilizacao no banco de dados e otimiza validacao do lancamento
	If _lCtbIniLan
		CtbIniLan()
	EndIf
	
	cTabJob	 := SelFINJob(cVarStatus,cTabMaster,aStructTab,cCpoFlag,cMarca,cTabJob,cChave,cFWTMP)

	// Realiza o processamento
	lRet := CtbMTProc('SE2',cTabJob)

	JOBFINEnd(cVarStatus,nHandle,lRet)

	If Select(cTabJob) > 0
		(cTabJob)->(dbCloseArea())
	EndIf

	//exclui temporario de contabilizacao no banco de dados utilizado para otimizacao validacao do lancamento
	If FindFunction("CtbFinLan")
		//FINALIZA E APAGA ARQUIVO TMP NO BANCO
		CtbFinLan()
	EndIf
	
Else
	PutGlbValue(cVarStatus,stThrError)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbProcPag ºAutor  ³Alvaro Camillo Netoº Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     Processa a contabilização                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbProcPag(cTabCtb)
Local aArea := GetArea()
Local lRet := .T.

(cTabCtb)->(dbGoTop())
CTBFINProc(.T.,.F.,Nil,.T.,cTabCtb,.F.,Nil,.F.,Nil,.T.,.F.,NIL)

RestArea(aArea)
Return lRet

// CONTAS A RECEBER

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbMRec   ºAutor  ³Alvaro Camillo Neto º Data ³  31/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Contabilização do titulos a receber                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbMRec(nNumProc)
Local aArea 		:= GetArea()
Local lRet			:= .T.
Local nX			:= 0
Local aProcs 		:= {}
Local cTabMult		:= ""// Tabela fisica para o processamento multi thread
Local cChave 		:= "E1_FILIAL+E1_EMIS1+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA"

Local nTotalReg	:= 0
Local cRaizNome	:= 'CTBFINPROC'
Local aStruSQL	:= {}
Local cTabJob	:= "TRBSE1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o arquivo de trabalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTabMult := CtbGrvRec(cChave,@nTotalReg)

If !Empty(cTabMult) .And. (cTabMult)->(!EOF())
	
	aStruSQL := (cTabMult)->( DbStruct() )
	aProcs := CTBPrepFIN(@nNumProc,cTabMult,nTotalReg,"CTBFLAG",cRaizNome)

	If  nTotalReg >= nNumProc .And. nNumProc > 1 // MultiThread
		
		//Inicializa as Threads Transação controlada nas Threads
		For nX := 1 to Len(aProcs)
			StartJob("JOBCTBREC", GetEnvServer(), .F., cEmpAnt,cFilAnt,aProcs[nX][MARCA],aProcs[nX][ARQUIVO],"CTBFLAG",cTabMult,aStruSQL,cTabJob,cValToChar(nX),aProcs[nX][VAR_STATUS],cChave,__cUserId,cUserName,cAcesso,cUsuario,_oCTBAFIN:GETREALNAME())
			Sleep(6000)
		Next nX
		
		//NAO RETIRAR A INSTRUCAO DO SLEEP
		//Esperar 30 segundos antes de monitorar para dar tempo das threads criar arquivo de semaforo
		Sleep(30000)  
		//Realiza o controle das Threads
		lRet := FINMonitor(aProcs,1)
	ElseIf nNumProc == 1
		cTabJob	 := SelFINJob(NIL,cTabMult,aStruSQL,"CTBFLAG",aProcs[nNumProc][MARCA],cTabJob,cChave,_oCTBAFIN:GETREALNAME())
		lRet 	 := CtbMTProc('SE1',cTabJob)
		If Select(cTabJob) > 0	
			(cTabJob)->(dbCloseArea())
		EndIf
	EndIf
EndIf

If Select(cTabMult) > 0
	(cTabMult)->( dbCloseArea() )
Endif

CTBClean()
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbGrvRec ºAutor  ³Alvaro Camillo Neto º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Grava arquivo temporario dos titulos a receber              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbGrvRec(cChave, nTotalReg)
Local cPerg 	 := "FIN370"
Local aStruSQL		:= {}
Local cTab			:= ""
Local cQuery		:= ""
Local cQuery2		:= ""
Local cCamposSel	:= ''
Local cCamposIns	:= ''
Local aStruSE1   	:= {}
Local cAliQry       := ""
Local nCtbVenda		:= SuperGetMV("MV_CTBINTE",,1) // 1 - Contabiliza por titulo ; 2 - contabiliza por venda (somente quando possuir integração)
Local cAliasCNT		:= ''

//Static lCFINE1FFIL 	:= Existblock("CFINE1F")   // Criado Ponto de Entrada

Default nTotalReg   := 0
cAliQry       := cTab + "_1" 
If !__lSchedule
	Pergunte(cPerg,.F.)
EndIf
dbSelectArea("SE1")
dbSetOrder(1)

// Montagem da estrtura do arquivo
aStruSE1  := SE1->(dbStruct())
aStruSQL := aClone(aStruSE1)
AADD(aStruSQL,{"SE1RECNO"    	,"N",15,00})
AADD(aStruSQL,{"CTBFLAG" 		,"C",02,00})

// Cria tabela temporaria
cTab := CriaTMP('SE1',aStruSQL,cChave) 

// Montagem da Query
cCamposSel := ''
cCamposIns := ''
aEval(aStruSE1,{|e,i| cCamposIns += IF(i==1,'',',')+AllTrim(e[1])})
cCamposSel := cCamposIns
If !_MSSQL7
	cCamposIns += ',SE1RECNO,CTBFLAG,R_E_C_N_O_'
Else
	cCamposIns += ',SE1RECNO,CTBFLAG'
EndIf 

cQuery := "SELECT " + cCamposSel
If !_MSSQL7
	cQuery += ",SE1.R_E_C_N_O_ SE1RECNO," + _cSpaceMark + " CTBFLAG,SE1.R_E_C_N_O_"
Else
	cQuery += ",SE1.R_E_C_N_O_ SE1RECNO," + _cSpaceMark + " CTBFLAG"
EndIf 
cQuery += "  FROM " + RetSqlName("SE1")+" SE1 "

If mv_par14 == 1
	If lPosE1MsFil .AND. !lUsaFilOri
		cQuery += "WHERE E1_MSFIL = '"  + cFilAnt + "'"
Else
		cQuery += "WHERE E1_FILORIG = '"  + cFilAnt + "'"
	Endif	
Else
	cQuery += "WHERE E1_FILIAL = '" + xFilial("SE1") + "'"
EndIf

cQuery += " AND SE1.E1_EMIS1 BETWEEN '"+DTOS(mv_par04)+"' AND '"+DTOS(mv_par05)+"'"
cQuery += " AND SE1.E1_LA <> 'S' AND E1_ORIGEM <> 'FINA677'  "       

If nCtbVenda == 2 //Contabilização por venda
	cQuery += " AND E1_ORIGEM <> 'FINI055'"
Endif

cQuery += " AND D_E_L_E_T_ = ' ' "

/*	Avaliar
// Ponto de Entrada para filtrar registros do SE1.
If lCFINE1FFIL
	cQuery := Execblock("CFINE1F",.F.,.F.,cQuery)

    //esta query somente para pegar estrutura pois em algum cliente os campos não estao na ordem de criacao da tabela temporaria
    //efetuado somente neste ponto de entrada pois tem que colocar na query o campo , SE1.R_E_C_N_O_ R_E_C_N_O_ no caso da tabela SE1
    //pode ser necessario fazer nos outros pontos de manipulacao da query do filtro ( sob demanda )
    cCampos := ''
	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery+" AND R_E_C_N_O_ = 1 ") , cAliQry , .T. , .T. )
	aStruQry	:= (cAliQry)->(dbStruct())
	(cAliQry)->( dbCloseArea() ) 
	aEval(aStruQry,{|e,i| cCampos += If(i==1,'',',')+AllTrim(e[1])})
EndIf
*/

cQuery += " ORDER BY " + SqlOrder(cChave)

//Inicio do bloco que substitui SqlToTrb
cQuery2 := " INSERT "
If _cSGBD == "ORACLE"
	cQuery2 += " /*+ APPEND */ "
Endif
cQuery2 += " INTO " + _oCTBAFIN:GETREALNAME() + " ("+cCamposIns+") " + cQuery

If cQuery2 = ''
	MsgAlert(STR0060) //"Erro de Parse no Insert"
Endif
If TcSqlExec(cQuery2) <> 0
	MsgAlert(STR0061) //"Erro no Insert"
EndIf

// Obtem a Contagem de Registros a processar.
cQuery := "SELECT COUNT(*) QUANT "
cQuery += "  FROM " + _oCTBAFIN:GETREALNAME() + " TAB "
cQuery := ChangeQuery( cQuery )

cAliasCNT := GetNextAlias()
dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cAliasCNT )
(cAliasCNT)->(DbGoTop())
nTotalReg := (cAliasCNT)->QUANT
(cAliasCNT)->(dbCloseArea())

//tiro o arquivo de eof
DbSelectArea(cTab)
(ctab)->(dbGoTop())
//Fim do bloco que substitui SqlToTrb

RETURN ctab

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JOBCTBREC ºAutor  ³Alvaro Camillo Neto º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job da contabilização do titulo a receber                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function JOBCTBREC(cEmpX,cFilX,cMarca,cFileLck,cCpoFlag,cTabMaster,aStructTab,cTabJob,cId,cVarStatus,cChave,cXUserId,cXUserName,cXAcesso,cXUsuario,cFWTMP)
Local nHandle	 := 0
Local lRet		 := .T.   

Private lMsErroAuto 
Private lMsHelpAuto 
Private lAutoErrNoFile 

DEFAULT cFWTMP	:= ''

cFilAnt := cFilX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre o arquivo de Lock parao controle externo das threads³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := FINLock(cFileLck)

If  nHandle >= 0
	PutGlbValue(cVarStatus,stThrStart)

	//Seta job para nao consumir licensas
	RpcSetType(3)
	RpcClearEnv()
	// Seta job para empresa filial desejada
	RpcSetEnv( cEmpX,cFilX,,,,,)

	PutGlbValue(cVarStatus,stThrConnect)

	//Set o usuário para buscar as perguntas do profile
	lMsErroAuto := .F.
	lMsHelpAuto := .T. 
	lAutoErrNoFile := .T.

	__cUserId := cXUserId 
	cUserName := cXUserName
	cAcesso   := cXAcesso
	cUsuario  := cXUsuario

	//cria temporario de contabilizacao no banco de dados e otimiza validacao do lancamento
	If _lCtbIniLan
		CtbIniLan()
	EndIf
	
	cTabJob	 := SelFINJob(cVarStatus,cTabMaster,aStructTab,cCpoFlag,cMarca,cTabJob,cChave,cFWTMP)

	// Realiza o processamento
	lRet := CtbMTProc('SE1',cTabJob)
		
	JOBFINEnd(cVarStatus,nHandle,lRet)

	If Select(cTabJob) > 0
		(cTabJob)->(dbCloseArea())
	EndIf

	//exclui temporario de contabilizacao no banco de dados utilizado para otimizacao validacao do lancamento
	If FindFunction("CtbFinLan")
		//FINALIZA E APAGA ARQUIVO TMP NO BANCO
		CtbFinLan()
	EndIf
	
Else
	PutGlbValue(cVarStatus,stThrError)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbProcRECºAutor  ³Alvaro Camillo Neto º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     Processa a contabilização                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbProcREC(cTabCtb)
Local aArea := GetArea()
Local lRet := .T.

(cTabCtb)->(dbGoTop())
CTBFINProc(.T.,.T.,cTabCtb,.F.,Nil,.F.,Nil,.F.,Nil,.T.,.F.,Nil)

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINMonitorºAutor  ³Alvaro Camillo Neto º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsavel por monitorar as threads de processamen º±±
±±º          ³ to                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FINMonitor(aProcs,nTipo)
Local lRet			:= .T.
Local nX			:= 0
Local nHandle		:= 0
Local cMsg			:= ""
Local cRotErro		:= ""
Local cTipoErro		:= ""
Local cMsgErro		:= ""
Local aErros		:= {}
Local cMarkSem		:= "***"
Local nMarkSem		:= 0
Local cArqSem		:= ""
Local cOrigem		:= ""
Local nTMPGerado	:= 0
Local aTMPGerado	:= ARRAY(LEN(aProcs))

DEFAULT nTipo := 0

AFILL(aTMPGerado,.F.)

Do Case
	Case nTipo == 1 //Contas a receber
		cOrigem := 'CTBREC'
	Case nTipo == 2 //Contas a pagar
		cOrigem := 'CTBPAG'
	Case nTipo == 3 //Cheque
		cOrigem := 'CTBCHQ'
	Case nTipo == 4 //Movimentacao
		cOrigem := 'CTBMOV'
EndCase

While .T.
	For nX := 1 to Len(aProcs)
		//CONOUT('***** CONTROLE PARA LIBERACAO MONITOR: ['+ALLTRIM(STR(nX))+']: - Thread No ['+ALLTRIM(Str(ThreadID()))+'] *****')
		//CONOUT('***** STATUS: ['+aProcs[nX][VAR_STATUS]+']['+GETGlbValue(aProcs[nX][VAR_STATUS])+']-['+TIME()+'] *****')
		If nTMPGerado < Len(aProcs)
			If !aTMPGerado[nX] .and. GetGlbValue(aProcs[nX][VAR_STATUS]) >= '3'
				aTMPGerado[nX] := .T.
				nTMPGerado++
				//CONOUT('***** CONTROLE PARA LIBERACAO TEMPORARIA: ['+ALLTRIM(STR(nTMPGerado))+']: - Thread No ['+ALLTRIM(Str(ThreadID()))+'] *****')
			EndIf
			
			If nTMPGerado == Len(aProcs)
				CTBClean()
			EndIf
		EndIf
		
		If aScan(aProcs,{|aItem| aItem[1] == cMarkSem + aProcs[nX][1]} ) == 0
			//espera 15 segundos antes de tentar lockar o arquivo
			Sleep(15000) 
			nHandle := FINLock(aProcs[nX][1])
			If  nHandle >= 0
				FClose(nHandle)
				aProcs[nX][1] := cMarkSem + aProcs[nX][1]
				nMarkSem++
			EndIf
		EndIf
	Next
	If nMarkSem >= Len(aProcs)
		Exit
	EndIF

	Sleep(5000)  //espera +5 segundos antes de entrar novamente no laco FOR....NEXT

End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se todas a threads foram processadas corretamente³
//³libera o recurso e apaga o arquivo                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len(aProcs)
	cArqSem := STRTRAN(aProcs[nX][1],"*","")
	
	FT_FUse(cArqSem)
	FT_FGoTop()
	cMsg := FT_FReadLn()
	FT_FUse()
	fErase(cArqSem)
	
	If lRet .And. ALLTRIM(cMsg) != MSG_OK
		lRet := .F.
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica quais threads deram erro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lRet
	Do Case
		Case nTipo == 1 //Contas a receber
			cRotErro := STR0039	//" Erro no processamento Contas a receber: "
		Case nTipo == 2 //Contas a pagar
			cRotErro := STR0040	//" Erro no processamento Contas a pagar: "
		Case nTipo == 3 //Cheque
			cRotErro := STR0041	//" Erro no processamento Cheques: "
		Case nTipo == 4 //Movimentacao
			cRotErro := STR0042	//" Erro no processamento Movimentação bancária: "
		Otherwise
			cRotErro := STR0046	//"Erro no Processamento"
	EndCase
	
	For nX := 1 to Len(aProcs)
		cStatus := GetGlbValue(aProcs[nX][VAR_STATUS])
		If cStatus != '3' // Concluido com sucesso
			Do Case
				Case cStatus == "1" // Erro na Conexão
					cTipoErro := STR0043//" Erro na inicialização do processo"
				Case cStatus == "2" // Erro no Processamento
					cTipoErro := STR0044 //" Erro no processo de contabilização"
			EndCase
			cMsgErro := cRotErro + cTipoErro + STR0045 + cValTochar(nX) //" processo numero "
			ProcLogAtu("ERRO",STR0046,cMsgErro)//"Erro no Processamento"
			aAdd(aErros,cMsgErro)
		EndIf
	Next nX
EndIf

// Limpa Variáveis Globais
For nX := 1 TO LEN(aProcs)
	ClearGlbValue(aProcs[nX][VAR_STATUS])
Next nX

If !lRet
	If __lSchedule .or. MsgYesNo(STR0047)//"Ocorreram inconsistencia no processo, deseja imprimir o relatorio de erros?"
		CtRConOut(aErros)
	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SelFINJob ºAutor  ³Alvaro Camillo Neto º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seleciona os registros para o processamento da Thread      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SelFINJob(cArqSem,cTabMaster,aStructTab,cCpoFlag,cMarca,cTabJob,cChave,cFWTMP)
Local cQuery	:= ""
Local nX		:= 0

Default cArqSem	:= ''
Default cTabJob	:= FINNextAlias()
Default cFWTMP	:= cTabMaster
Default cChave	:= ""
 
cQuery += " SELECT "

For nX := 1 to Len(aStructTab)
	cQuery += " "+aStructTab[nX][1]+"  ,"
Next nX

cQuery := Left(cQuery,Len(cQuery)-1)
cQuery +=" FROM " + cFWTMP + " "
cQuery +=" WHERE " + cCpoFlag + " = '"+cMarca+"' "

If !Empty(cChave) 
	cQuery += " ORDER BY " + SqlOrder(cChave)
EndIf
 
cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cTabJob, .F., .T.)

IF !(cTabJob)->(EOF())
	For nX := 1 to Len(aStructTab)
		If aStructTab[nX][2] <> "C"
			TcSetField(cTabJob ,aStructTab[nX][1],aStructTab[nX][2],aStructTab[nX][3],aStructTab[nX][4])
		EndIf
	Next nX
	(cTabJob)->(dbGotop())
ENDIF

If !EMPTY(cArqSem)
	//CONOUT('***** STATUS PRE: ['+cArqSem+']['+GETGlbValue(cArqSem)+']-['+TIME()+'] - Thread No ['+ALLTRIM(Str(ThreadID()))+'] *****')
	PutGlbValue(cArqSem,stThrTbltmp)
	//CONOUT('***** CONSULTA CONCLUIDA COM SUCESSO: ['+cFWTMP+']: - Thread No ['+ALLTRIM(Str(ThreadID()))+'] *****')
	//CONOUT('***** STATUS POS: ['+cArqSem+']['+GETGlbValue(cArqSem)+']-['+TIME()+'] - Thread No ['+ALLTRIM(Str(ThreadID()))+'] *****')
EndIf

Return cTabJob

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FINUnLock ³ Autor ³Controladoria          ³ Data ³ 15/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Encerra a trava                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FINUnLock(nHandle,lOk)
DEFAULT nHandle := -1
DEFAULT lOk := .T.

IF nHandle >= 0
	FWRITE(nHandle,IF(lOk,MSG_OK,MSG_ERRO))
	FCLOSE(nHandle)
ENDIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FINLock   |Autor  ³Alvaro Camillo Neto    | Data ³ 15/04/10 |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cria arquivo para travar processos e garantir que sao unicos³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FINLock(cFile)
Local nHJob := -1
If File(cFile)
	nHJob := FOPEN(cFile,2)
Else
	nHJob := FCREATE(cFile)
EndIf
Return nHJob

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBPrepFINºAutor  ³Alvaro Camillo Neto º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Prepara as informacoes para o processamento multithread     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBPrepFIN(nNumProc,cTabTemp,nTotalReg,cCpoFlag,cRaizNome,cCpoCond)
Local aProcs 		:= NIL
Local nX		 	:= 0
Local cDirSem  		:= "\Semaforo\"
Local cNomeArq		:= ""
Local cMarca  		:= ""
Local nRegAProc		:= 0 // Registros a processar
Local nRegJProc		:= 0 // Total de registros já processados
Local cVarStatus	:= ""
Local nMxRcTHR		:= 200	// Nº mínimo de registros por thhread

Default cCpoCond := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria a pasta do semaforo caso não exista³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ExistDir(cDirSem)
	MontaDir(cDirSem)
EndIf

//Realizar calculo da quantidade de registros por thread.
//Está definido que deve haver um mínimo de 200 registros por thread
While nNumProc > 1
	IF (nTotalReg / nNumProc) >= nMxRcTHR
		EXIT
	ENDIF
	nNumProc := nNumProc - 1
EndDo

aProcs := Array(nNumProc)

For nX := 1 to Len(aProcs)
	cNomeArq 	:= cDirSem + cRaizNome +cEmpAnt + cFilAnt +cValtoChar(nX)+cValtoChar(INT(Seconds())) + '.lck'
	cNomeArq 	:= STRTRAN(cNomeArq,' ','_')
	cMarca		:= GetMark()
	nRegAProc	:= IIf( nX == Len(aProcs), nTotalReg-nRegJProc, Int(nTotalReg / nNumProc) )
	nRegJProc	+= nRegAProc
	cVarStatus  :="cFINP"+cEmpAnt+cFilAnt+StrZero(nX,2)+cMarca
	cVarStatus := STRTRAN(cVarStatus,' ','_')
	aProcs[nX]	:= {cNomeArq ,cMarca,nRegAProc,cVarStatus }
	PutGlbValue(cVarStatus,stThrReady)
	Sleep( nX+1000 ) //espera no minimo por 1 segundo para Seconds() retornar numero diferente
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza o Update dos campos de flag setando quais registros³
//³cada thread irá processar.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FINFlag(cTabTemp,aProcs,cCpoFlag,cCpoCond)

Return aProcs

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINFlag   ºAutor  ³ALvaro Camillo Neto º Data ³  15/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza o Update dos campos de flag setando quais registros º±±
±±º          ³cada thread irá processar.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FINFlag(cTabMult,aProcs,cCpoFlag,cCpoCond)
Local nX		:= 1
Local nY		:= 0
Local cChave	:= ""
Local cCompar	:= ""
Local nQuant	:= 0
Local lOK		:= .T.
Local nCont		:= 0
Local cNumCMP	:= ''
Local cRecnoI	:= ''
Local cRecnoF	:= ''
Local cLista	:= ''

// Campos que serão utilizados para definir a condição de divisão dos registros
// Enquanto a expressão estiver na tabela esse conjunto ficara com a mesma marca.
Default cCpoCond := ''
//?¨
//?Descobre o Recno M ximo e Minimo de cada ?
//?intervalo                                ?
//??
nY := Len(aProcs)
IF (nY > 0)
	
(cTabMult)->(dbGoTop())

	// Utilizado aninhamento de WHILE em substitui‡?o ao aninhamento FOR/WHILE pois 
	// o comando EXIT no nivel mais interno fazia sair dos dois niveis de uma vez.
		While (cTabMult)->(!EOF())
			
		nCont := aProcs[nX][QTD_REGISTROS]
		nQuant := 0
		lOK := .T.

		WHILE lOK

			If !EMPTY((cTabMult)->&(cCpoFlag)) .AND. ((cTabMult)->&(cCpoFlag) <> aProcs[nX][MARCA])
				(cTabMult)->(dbSkip())
				LOOP
			EndIf
		
			nQuant++	// Controle da quantidade de registros para cada Thread
			If nQuant == 1 
				cRecnoI := CVALTOCHAR((cTabMult)->(RECNO()))
			EndIf
			
			// Campo para avalia‡?o de grupo de registros .
			If !Empty(cCpoCond)
				cCompar := ALLTRIM((cTabMult)->&(cCpoCond))
				
				// Tratamento para as transferˆncias banc rias onde o sistema relaciona 
				// a saida no campo E5_NUMCHEQ e a entrada no campo E5_DOCUMEN
				IF (cCpoCond == 'E5_DOCUMEN') .AND. EMPTY(cCompar)
					cCompar := ALLTRIM((cTabMult)->E5_NUMCHEQ)
				ENDIF
				
				// Tratamento para as transa‡?es de Compensa‡?o
				IF E5_MOTBX == 'CMP'
					cNumCMP := (cTabMult)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
				ENDIF
			EndIf
			
			// cCpoCond tem como objetivo n?o separar registros cujo conteudo seja identico.
			// Portanto este criterio pode inplicar um numero maior de registros marcados
			// do que o informado em aProcs.
			If (nQuant <= nCont) .OR. (!Empty( cCpoCond ) .AND. (cChave == ALLTRIM( cCompar ) .OR. cChave == cNumCMP))
				cRecnoF := CVALTOCHAR((cTabMult)->(RECNO()))
				If !_MSSQL7
					If EMPTY(cLista)
						cLista := '(' + ALLTRIM(STR((cTabMult)->(RECNO())))
					Else
						cLista += ',' + ALLTRIM(STR((cTabMult)->(RECNO())))
					EndIf
					
					If Len(cLista) >= 999
						cLista += ')'
						cUpdate := "UPDATE " + cTabMult + " SET " + cCpoFlag + " = '" + aProcs[nX][MARCA] + "' WHERE R_E_C_N_O_ IN " + cLista
						
						If TcSqlExec(cUpdate) < 0 
							conout("ERRO AO ATUALIZAR:["+cUpdate+']')
						EndIf
						
						cLista := "" 
												
					Endif 
					
				EndIf
			Else
				lOK := .F.
			EndIf
			
			If !Empty(cCpoCond)
				cChave := ALLTRIM((cTabMult)->&(cCpoCond))
				
				// Tratamento para as transferˆncias banc rias onde o sistema relaciona 
				// a saida no campo E5_NUMCHEQ e a entrada no campo E5_DOCUMEN
				IF (cCpoCond == 'E5_DOCUMEN') .AND. EMPTY(cChave)
					cChave := (cTabMult)->E5_NUMCHEQ
			EndIf
			
			EndIf

			IF lOK			
			(cTabMult)->(dbSkip())
				IF (cTabMult)->(EOF())
					EXIT
				ENDIF
			ENDIF
		EndDo

		If !Empty(cLista)
			cLista += ')'
			cUpdate := "UPDATE " + cTabMult + " SET " + cCpoFlag + " = '" + aProcs[nX][MARCA] + "' WHERE R_E_C_N_O_ IN " + cLista
		ElseIf !Empty(cRecnoI+cRecnoF) .AND. _MSSQL7
			If FwIsInCallStack("CtbMViag")
				cUpdate := "UPDATE " + cTabMult + " SET " + cCpoFlag + " = '" + aProcs[nX][MARCA] + "' WHERE R_E_C_N_O_ BETWEEN '"+cRecnoI+"' AND '"+cRecnoF+"' "
			Else
				cUpdate := "UPDATE " + _oCTBAFIN:GETREALNAME() + " SET " + cCpoFlag + " = '" + aProcs[nX][MARCA] + "' WHERE R_E_C_N_O_ BETWEEN '"+cRecnoI+"' AND '"+cRecnoF+"' "
			EndIf
		EndIf

		If TcSqlExec(cUpdate) < 0 
			conout("ERRO AO ATUALIZAR:["+cUpdate+']')
		EndIf	

		cLista := "" 
		
		// Permite incremento somente ate o tamanho de elementos de aProcs
		IF (nX < nY)
			nX++
		ELSE
			EXIT
		ENDIF

	EndDo

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINNextAliasºAutor  ³Alvaro Camillo Neto º Data ³  15/04/10 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Proteção para retornar o próximo alias disponivel no Banco  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FINNextAlias()
Local cNextAlias := ""
Local aArea := GetArea()

While .T.
	cNextAlias := CriaTrab(NIL, .F.)
	If !TCCanOpen(cNextAlias) .And. Select(cNextAlias) == 0
		Exit
	EndIf
EndDo

// adiciono o alias para forçar a limpeza no final.
Aadd( __aFinAlias , cNextAlias )

RestArea(aArea)

Return cNextAlias

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbValMultºAutor  ³Alvaro Camillo Neto º Data ³  05/19/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se o processamento será feito MultiThread           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbValMult(lMostraHelp,lAglutina,lMostraLanc,nTipo)
Local lRet 		:= .T.
Local nHelp		:= 1
Default lMostraHelp := .F.
Default nTipo 		:= 1
Default lMostraLanc := .F.

If lMostraHelp .And. !__lSchedule
	nHelp := 1
Else
	nHelp := 0
EndIf


If lRet .And. nTipo != 2
	If lMostraHelp .And. !__lSchedule
		lRet := MsgYesNo(STR0048,STR0049)//"O processamento Multithread está disponivel apenas para processamento por documento, o processamento será feito sem multithread. Concorda com operação?"##"Atenção"
	Else
		lRet := .F.
	EndIf
EndIf

If lRet .And. lAglutina
	If lMostraHelp .And. !__lSchedule
		lRet := MsgYesNo(STR0050,STR0049)//"O processamento Multithread está disponivel apenas para processamento sem aglutinação, o processamento será feito sem multithread. Concorda com operação?" ##"Atenção"
	Else
		lRet := .F.
	EndIf
EndIf

If lRet
	If FindFunction("CTBINTRAN")
		lCtbInTran := CTBINTRAN(nHelp,lMostraLanc)
	Else
		lCtbInTran := .F.
	EndIf
	
	If !lCtbInTran
		If lMostraHelp .And. !_lBlind
			lRet := MsgYesNo(STR0051,STR0049)//"O processamento será feito sem multithread. Concorda com operação?" ##"Atenção"
		Else
			lRet := .F.
		EndIf
	EndIf
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JOBFINEnd ºAutor  ³Microsiga           º Data ³  06/21/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Finaliza a Thread verificando se ocorrer help (erro)      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function JOBFINEnd(cVarStatus,nHandle,lRet)
Local nX	:= 0
Local aLog  := {}
Local cMsg	:= ""

aLog  := GETAUTOGRLOG()

If !Empty(aLog)
	For nX := 1 to Len(aLog)
		cMsg := aLog[nX] 	
	Next
	If __lConoutR
		ConoutR( "Error CTBAFIN - " + cMsg )
	Endif
	UserException( "Error CTBAFIN- " + cMsg )
	PutGlbValue(cVarStatus,stThrError)
Else
	PutGlbValue(cVarStatus,stThrFinish)
	FINUnLock(nHandle,lRet)
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FinIniVar ºAutor  ³Microsiga           º Data ³  06/21/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inicializa as variaveis staticas da contabilização         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FinIniVar()
Local cPerg    := "FIN370"
Local aAreaSX1 := NIL

If TYPE("cCarteira") == 'U' .or. cCarteira == Nil
	cCarteira	:= GetMV("MV_CARTEIR")
EndIf

If TYPE("cCtBaixa") == 'U' .or. cCtBaixa == Nil
	cCtBaixa	:= Getmv("MV_CTBAIXA")
EndIf

If TYPE("lUsaFlag") == 'U' .or. lUsaFlag == Nil
	lUsaFlag	:= CtbInUse() .And. GetNewPar("MV_CTBFLAG",.F.)
EndIf

If TYPE("lPCCBaixa") == 'U' .or. lPCCBaixa == Nil 
	lPCCBaixa	:= SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ;
						!Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
						!Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
						!Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
EndIf

If lPosE1MsFil == Nil
	lPosE1MsFil	:= !Empty( SE1->( FieldPos( "E1_MSFIL" ) ) )
EndIf

If lPosE2MsFil == Nil
	lPosE2MsFil	:= !Empty( SE2->( FieldPos( "E2_MSFIL" ) ) )
EndIf

If lPosE5MsFil == Nil
	lPosE5MsFil	:= !Empty( SE5->( FieldPos( "E5_MSFIL" ) ) )
EndIf

If lPosEfMsFil == Nil
	lPosEfMsFil	:= !Empty( SEF->( FieldPos( "EF_MSFIL" ) ) )
EndIf

If lPosEuMsFil == Nil
	lPosEuMsFil	:= !Empty( SEU->( FieldPos( "EU_MSFIL" ) ) )
EndIf

If lSeqCorr == Nil
	lSeqCorr	:= FindFunction( "UsaSeqCor" ) .And. UsaSeqCor("SE1/SE2/SE5/SEH/SEK/SEL/SET/SEU")
EndIf

If lUsaFilOri == Nil
	lUsaFilOri	:= SuperGetMv("MV_CTMSFIL",.F.,.F.)
EndIf		

aAreaSX1 := SX1->(GetArea())
SX1->(DbSetOrder(1)) 
If SX1->(DBSEEK(PADR(cPerg, LEN(SX1->X1_GRUPO), ' ') + '18')) 
	_lMvPar18 := .T.
EndIf
RestArea(aAreaSX1)

Return



//-------------------------------------------------------------------
/*/{Protheus.doc} FCTBA677()
Gera Lançamento contabil off line pela Prestação de Contas.

@author Antonio Florêncio Domingos Filho
@since 11/05/2015
@version 12.1.6
/*/

static Function FCTBA677(lCabecalho,nHdlPrv,cArquivo,lUsaFlag,aFlagCTB,cLoteCtb,nTotal,cAliasFLF,lMultThr)
Local lRet			:= .T.
Local lPadraoItem	:= .F.
Local lPadraoCabec	:= .F.
Local cPadraoItem	:= "8B3"		/* prestacao por item */
Local cPadraoCabec	:= "8B5"		/* prestacao por cabecalho */
Local aGetArea  	:= GetArea()
Local nTotDoc		:= 0
Local nValLanc		:= 0
Local nPosReg		:= 0
Local cQuery		:= ""
Local cAliasFL		:= ""
Local cFilFLE		:= ""
Local lMsFil		:= .F.
Local aTabRecOri	:= {'',0}	// aTabRecOri[1]-> Tabela Origem ; aTabRecOri[2]-> RecNo
Local lFlfLa	:= .F.
Local aCT5       := {}

Default lCabecalho	:= .F.
Default nHdlPrv		:= 0
Default nTotal		:= 0
Default cArquivo	:= ""
Default lUsaFlag	:= SuperGetMV("MV_CTBFLAG",.T.,.F.)
Default aFlagCTB 	:= {}
Default cLoteCTB   	:= LoteCont("FIN")
Default cAliasFLF	:= ""
Default lMultThr	:= .F.

lMsFil := (FLF->(ColumnPos("FLF_MSFIL")) > 0)
lFlfLa := (FLF->(ColumnPos('FLF_LA')) > 0) 
cLote  := If(cLote=NIL,Space(TamSX3("CT2_LOTE")[1]),cLote)    

lPadraoItem  := VerPadrao(cPadraoItem)                                               
lPadraoCabec := VerPadrao(cPadraoCabec)                                               

FLE->(DbSetOrder(1))
FO7->(DbSetOrder(2))

If !lCabecalho
	a370Cabecalho(@nHdlPrv,@cArquivo)
Endif
		
if lPadraoItem .Or. lPadraoCabec
	If lMultThr .And. Select(cAliasFLF) > 0
	 	cAliasFL := cAliasFLF
	Else
		CtbGrvViag(.F.,@cQuery)	
		cAliasFL := FINNextAlias()
		DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasFL,.F.,.T.)
	Endif

	While !((cAliasFL)->(eof()))
		FLF->(DbGoTo((cAliasFL)->REGFLF))

		If !(mv_par12 == 1) .And. nHdlPrv == 0
			a370Cabecalho(@nHdlPrv,@cArquivo)
		Endif
		
		If FLF->FLF_STATUS <> '8'
			If lCtbPFO7
				Execblock("CtbPFO7",.F.,.F.)
			Else
				If MV_PAR14 == 1 .And. lMsFil
					FO7->(DbSeek(xFilial("FO7",FLF->FLF_MSFIL) + FLF->FLF_TIPO + FLF->FLF_PRESTA))
				Else
					FO7->(DbSeek(xFilial("FO7") + FLF->FLF_TIPO + FLF->FLF_PRESTA))
				Endif
			Endif
			If mv_par03 == 1 
				
				If FO7->FO7_RECPAG == "R"
					dbSelectArea("SE1")
					SE1->(Dbsetorder(2))
					If SE1->(MsSeek(xFilial("SE1",FO7->FO7_FILIAL)+FO7->(FO7_CLIFOR+FO7_LOJA+FO7_PREFIX+FO7_TITULO+FO7_PARCEL+FO7_TIPO)))
						dDataBase := SE1->E1_EMISSAO
					EndIf
				Else
					DBSelectArea("SE2")
					SE2->(dbSetOrder(1))
					If SE2->(MsSeek(xFilial("SE2",FO7->FO7_FILIAL)+FO7->(FO7_PREFIX+FO7_TITULO+FO7_PARCEL+FO7_TIPO+FO7_CLIFOR+FO7_LOJA)))
						dDataBase := SE2->E2_EMISSAO
					EndIf	
				EndIf
			Endif
		Else
			DBSelectArea("FLN")
			FLN->(DbSetOrder(1))//FLN_FILIAL+FLN_TIPO+FLN_PRESTA+FLN_PARTIC+FLN_SEQ+FLN_TPAPR
			If MSSEEK(xFilial("FLN", FLF->FLF_FILIAL)+FLF->FLF_TIPO+ FLF->FLF_PRESTA+ FLF->FLF_PARTIC)
				While FLN->(!Eof()) .And. xFilial("FLN", FLF->FLF_FILIAL)+FLF->FLF_TIPO+ FLF->FLF_PRESTA+ FLF->FLF_PARTIC == FLN->(FLN_FILIAL+FLN_TIPO+FLN_PRESTA+FLN_PARTIC)
					If FLN->FLN_STATUS <> "2"
						FLN->(DbSkip())
					Else
						dDataBase := FLN->FLN_DTAPRO
						Exit
					EndIf		
				EndDo
			Endif
		EndIf

		If lPadraoCabec
			If lUsaFlag .and. lFlfLa
				aAdd(aFlagCTB,{"FLF_LA","S","FLF",FLF->(Recno()),0,0,0})
			EndIf
			
			aTabRecOri := { 'FLF', FLF->( RECNO() ) }
			
			nValLanc := DetProva(nHdlPrv,cPadraoCabec,"FINA370",cLoteCTB,,,,,,aCT5,,@aFlagCTB, aTabRecOri)
			nTotal += nValLanc
			nTotDoc += nValLanc
			If LanceiCtb // Vem do DetProva
				If !lUsaFlag .and. lFlfLa
					RecLock("FLF")
					FLF->FLF_LA := "S"
					MsUnlock( )
				EndIf
			ElseIf lUsaFlag
				If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == FLF->(Recno()) }))>0
					aFlagCTB := Adel(aFlagCTB,nPosReg)
					aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
				Endif
			EndIf
		Endif
		If lPadraoItem
			DbSelectArea("FLE")
			If MV_PAR14 == 1 .And. lMsFil
				cFilFLE := xFilial("FLE",FLF->FLF_MSFIL)
			Else
				cFilFLE := xFilial("FLE")
			Endif
			FLE->(DbSeek(cFilFLE + FLF->FLF_TIPO + FLF->FLF_PRESTA + FLF->FLF_PARTIC))
			While FLE->FLE_FILIAL == cFilFLE .And. FLE->FLE_TIPO == FLF->FLF_TIPO .And. FLE->FLE_PRESTA == FLF->FLF_PRESTA .And. FLE->FLE_PARTIC == FLF->FLF_PARTIC
				If !(FLE->FLE_LA == "S")
					If lUsaFlag
						aAdd(aFlagCTB,{"FLE_LA","S","FLE",FLE->(Recno()),0,0,0})
					EndIf
					aTabRecOri := { 'FLE', FLE->( RECNO() ) }
					
					nValLanc := DetProva(nHdlPrv,cPadraoItem,"FINA370",cLoteCTB,,,,,,aCT5,,@aFlagCTB, aTabRecOri)
					nTotal += nValLanc
					nTotDoc += nValLanc
					If LanceiCtb // Vem do DetProva
						If !lUsaFlag
							RecLock("FLE")
							FLE->FLE_LA := "S"
							MsUnlock( )
						EndIf
					ElseIf lUsaFlag
						If (nPosReg  := aScan(aFlagCTB,{ |x| x[4] == FLE->(Recno()) }))>0
							aFlagCTB := Adel(aFlagCTB,nPosReg)
							aFlagCTB := aSize(aFlagCTB,Len(aFlagCTB)-1)
						Endif
					EndIf
				Endif
				FLE->(DbSkip())
			Enddo
		Endif
		
		If !(mv_par12 == 1) 
			If nTotDoc > 0
				Ca370Incl(cArquivo,@nHdlPrv,cLoteCtb,nTotal,@aFlagCTB,,dDataBase)
			Endif
			nTotDoc := 0
			aFlagCTB := {}
		Endif
		
		DbSelectArea(cAliasFL)
		(cAliasFL)->(DbSkip())
	Enddo
	If Select(cAliasFL)>0
		DbSelectArea(cAliasFL)
		DbCloseArea()
		MsErase(cAliasFL)
	Endif
Endif


RestArea(aGetArea)
Return(lRet)

/*/{Protheus.doc} SchedDef
Uso - Execucao da rotina via Schedule.

Permite usar o botao Parametros da nova rotina de Schedule
para definir os parametros(SX1) que serao passados a rotina agendada.

@return  aParam
/*/
Static Function SchedDef(aEmp)
Local aParam := {}

aParam := {	"P"			,;	//Tipo R para relatorio P para processo
				"FIN370"	,;	//Nome do grupo de perguntas (SX1)
				Nil			,;	//cAlias (para Relatorio)
				Nil			,;	//aArray (para Relatorio)
				Nil			}	//Titulo (para Relatorio)

Return aParam

/*/{Protheus.doc} VldVerPad 
Valida a existencia de Lan‡amentos Padr?o. 
@author norbertom 
@since 13/09/2017 
@version 1.0 
@param aLstLP, array, Lista de Lan‡amentos Padr?o para validar na fun‡?o VerPadrao(). 
@return  lRet, logico, Verdadeiro se existir 1 ou mais Lps cadastrados e ativos, sen?o Falso. 
/*/ 
STATIC Function VldVerPad(aLstLP) 
Local lRet := .T. 
Local nI := 0 
DEFAULT aLstLP := {} 
	
	For nI := 1 To Len(aLstLP) 
		lRet := VerPadrao(aLstLP[nI]) 
		If lRet 
			Exit 
		EndIf 
	Next nI 

Return lRet

/*/{Protheus.doc} CTBClean

Limpa o objeto da temporarytable
 
@Author	Leonardo Castro
@since	08/02/2018
/*/
Static Function CTBClean()

If _oCTBAFIN <> Nil
	_oCTBAFIN:Delete()
	_oCTBAFIN := Nil
Endif

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CTBGrvFlag
Efetua validações para a gravação do Flags 
@author  Norberto M de Melo
@since   23/02/201
@version P12
/*/
//-------------------------------------------------------------------
STATIC FUNCTION CTBGrvFlag(aIdFlag as Array)
	/**Declaração */
	LOCAL nI		as Numeric
	LOCAL aAreas	as Array
	LOCAL cTab		as Character
	LOCAL aFKRec	as Array

	/**Inicialização */
	DEFAULT aIdFlag	:= {} 
	nI		:= 0
	aAreas	:= {}
	cTab	:= ''
	aFKRec	:= {}

	/**Implementação */
	AADD(aAreas, GETAREA())

	IF !SE5->(EOF())
		CTBAddFlag(aFKRec)

		For nI := 1 To Len(aFKRec)
			(aFKRec[nI,3])->(dbGoTo(aFKRec[nI,4]))

			IF !(aFKRec[nI,3])->(EOF())
				Reclock(aFKRec[nI,3],.F.)
				&(aFKRec[nI,1]) := 'S'
				MsUnlock()
			EndIf
		Next nI
	ENDIF

	// restaura as areas utilizadas da última para a primeira - Sistema UEPS ou LIFO
	FOR nI := LEN(aAreas) TO 1 Step -1
		RestArea(aAreas[nI])
	NEXT nI

RETURN NIL

//-------------------------------------------------------------------
/*/{Protheus.doc} CTBAddFlag
Adiciona os recnos do relacionamento do registro SE5 atual e seus registros FKs
@author  Norberto M de Melo
@since   23/02/201
@version P12
/*/
//-------------------------------------------------------------------
STATIC FUNCTION CTBAddFlag(aCTBFlags as Array) as Array
/**Declaração */
	LOCAL aAreas		as Array
	LOCAL nI 			as Numeric
	LOCAL cKeyIDProc	as Character

/**Inicialização */
	//DEFAULT aCTBFlags := {}
	aAreas		:= {}
	nI			:= 0
	cKeyIDProc	:= ''

/**Implementação */
	AAdd(aAreas,GETAREA())

	// Adiciona o Recno do registro SE5 Atual 
	AAdd(aCTBFlags,{"E5_LA","S","SE5",SE5->(Recno()),0,0,0})

	// Inicia Pesquisa do relacionamento com as FKs
	If !EMPTY(SE5->(E5_TABORI+E5_IDORIG))
		AADD(aAreas,FKA->(GetArea()))
		dbSelectArea('FKA')
		FKA->(dbSetOrder(3))		//FKA_FILIAL+FKA_TABORI+FKA_IDORIG

		If FKA->(dbSeek(SE5->(E5_FILORIG+E5_TABORI+E5_IDORIG)))
			FKA->(dbSetOrder(2))	//FKA_FILIAL+FKA_IDPROC+FKA_IDORIG+FKA_TABORI
			cKeyIDProc := SE5->E5_FILORIG+FKA->FKA_IDPROC
			IF FKA->(DBSeek(cKeyIDProc))
				While !FKA->(EOF()) .AND. cKeyIDProc == FKA->(FKA_FILIAL+FKA_IDPROC)
					If SUBSTR(FKA->FKA_TABORI,1,2) <> 'FK'
						FKA->(DbSkip())
						Loop
					EndIf

					If ASCAN(aAreas,{|e|e[1]==FKA->FKA_TABORI}) == 0
						AADD(aAreas,(FKA->FKA_TABORI)->(GetArea()))
					EndIf

					dbSelectArea(FKA->FKA_TABORI)
					(FKA->FKA_TABORI)->(dbSetOrder(01))
					If (FKA->FKA_TABORI)->(dbSeek(SE5->E5_FILORIG+FKA->FKA_IDORIG))
						AAdd(aCTBFlags,{FKA->FKA_TABORI+"_LA","S",FKA->FKA_TABORI,(FKA->FKA_TABORI)->(Recno()),0,0,0})
					EndiF
					FKA->(DbSkip())
				EndDo
			EndIf
		Endif
	EndIf

	// restaura as areas utilizadas da última para a primeira - Sistema UEPS ou LIFO
	For nI := LEN(aAreas) To 1 Step -1
		RestArea(aAreas[nI])
	Next nI
RETURN ACLONE(aCTBFlags)

//-------------------------------------------------------------------
/*/{Protheus.doc} CriaTMP
Criação de tabela Temporária
@author  Norberto M de Melo
@since   06/03/2018
@version P12
/*/
//-------------------------------------------------------------------
STATIC FUNCTION CriaTMP(cAlias as Character, aStruSQL as Array, cChave as Character) as Character
	/**Declaração */
	LOCAL cTab as Character
	LOCAL aArea as Array

	/**Inicialização */
	DEFAULT cAlias		:= ''
	DEFAULT aStruSQL	:= {}
	DEFAULT cChave		:= ''
	cTab	:= FINNextAlias()
	aArea	:= GetArea()

	/**Implementação */
	If !EMPTY(cAlias) .AND. !EMPTY(aStruSQL)
		dbSelectArea(cAlias)
		(cAlias)->(dbSetOrder(1))
		If EMPTY(cChave)
			cChave := (cAlias)->(INDEXKEY())
		EndIf

		_oCTBAFIN := oFINTPTBL():New(cTab)
		_oCTBAFIN:SetFields(aStruSQL)
		_oCTBAFIN:AddIndex('1',cChave)
		_oCTBAFIN:Create()
	EndIf

	RestArea(aArea)
Return cTab

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A370FREEPRºAutor  ³Marcos S. Lobo      º Data ³  06/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Libera registro alocado no semaforo de processamento.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP Contabilizacao Off-Line Financeiro                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A370FreeProc(aKeyProc)

Local cFile 	:= "CTB370"+AllTrim(cEmpAnt)
Local nER		:= 0
Local nI		:= NIL
Local lTRBEmpty := .F.

DEFAULT aKeyProc := NIL

If !( MsFile(cFile,,"TOPCONN") )
	Return
EndIf

If Select("SEM370") <= 0
	Return
EndIf

While !LockByName("FINA370LOCKPROC"+cEmpAnt,.T.,.T.,.T.)
    nER++
	If !_lBlind
		MsAguarde({|| Sleep(1000) }, STR0026+ALLTRIM(STR(nER)), STR0029)//"Semaforo de processamento... tentativa "#"Aguarde, arquivo sendo criado por outro usuário."
	Else
		Sleep(5000)		
	EndIf
	If nER > 5	/// A PARTIR DA QUINTA TENTATIVA
		If !_lBlind
			If Aviso(STR0028,STR0029,{STR0030,STR0034},2) == 2//"Gravacao de Semaforo de processamento."#"Não foi possivel acesso exclusivo para gravar o semaforo de processamento."#"Repetir"#"Fechar"
				If Funname() == "FINA370" .and. !_lBlind
					oSelf:Savelog("ERRO",STR0031,STR0032+STR0033)	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
					//³do log no CV8 quando do uso da classe tNewProcess que    ³
					//³grava o LOG no SXU (FNC 00000028259/2009)                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("ERRO",STR0031,STR0032+STR0033)	
				Else	
					ProcLogAtu("ERRO",STR0031,STR0032+STR0033)	
				EndIf
				
				Return
			Else
				nER := 0
			EndIf		
		ElseIf nER >= 30
			If Funname() == "FINA370" .and. !_lBlind
				oSelf:Savelog("ERRO",STR0031,STR0032+STR0033)	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
				//³do log no CV8 quando do uso da classe tNewProcess que    ³
				//³grava o LOG no SXU (FNC 00000028259/2009)                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ProcLogAtu("ERRO",STR0031,STR0032+STR0033)	
			Else	
				ProcLogAtu("ERRO",STR0031,STR0032+STR0033)	
			EndIf
			Return
		EndIf
    EndIf
EndDo

If !EMPTY(aKeyProc)
	cEval := ''
	For nI := 1 To Len(aKeyProc)
		cEval += "SEM370->" + aKeyProc[nI][1] + " =='" + aKeyProc[nI][2] + "' "
		If nI < Len(aKeyProc)
			cEval += " .and. "
		EndIf
	Next nI
	bEval := {|| &cEval }
Else
	bEval := {|| .T.}
EndIf

dbSelectArea("SEM370")
SEM370->(dbGoTop())
While !SEM370->(Eof()) 
	If Eval(bEval) .and. SEM370->(RLock())
		Field->HORAF	:= Time()
		Field->DATAF	:= DTOS(Date())
		MsUnlock()
		RecLock("SEM370",.F.)
		SEM370->(dbDelete())
		MsUnlock()
	EndIf
	SEM370->(DBSKIP())
EndDo

SEM370->(DBCLOSEAREA())
dbUseArea(.T.,'TOPCONN',cFile,"SEM370",.T.,.F.)
lTRBEmpty := SEM370->(EOF())
SEM370->(DBCLOSEAREA())

If lTRBEmpty
	MSERASE(cFile,,"TOPCONN")
Endif

UnLockByName("FINA370LOCKPROC"+cEmpAnt,.T.,.T.,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A370CanProºAutor  ³Marcos S. Lobo      º Data ³  06/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria Semaforo de processamento e verIfica concorrencia com  º±±
±±º          ³base nos intervalos de parametros                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Contabilizacao Off-Line Financeiro                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A370CanProc(nCart, dDtVldDe, dDtVldAte, cFilDe, cFilAte,oSelf)
Local lRet		:= .F.
Local nEr		:= 0 
Local cFile		:= ""
Local cUserCTB	:= PADR('SCHED',15)

Default cFilDe := cFilAnt
Default cFilAte:= cFilAnt

If !IsBlind()
	cUserCTB := cUserName
EndIf
 
While !LockByName("FINA370LOCKPROC"+cEmpAnt,.T.,.T.,.T.)
    nER++
	If !_lBlind
		MsAguarde({|| Sleep(1000) }, STR0026+ALLTRIM(STR(nER)), STR0027) //"Semaforo de processamento... tentativa "#"Aguarde, arquivo sendo criado por outro usuário."
	Else
		Sleep(5000)		
	EndIf
	If nER > 5	/// A PARTIR DA QUINTA TENTATIVA
		If !_lBlind
			If Aviso(STR0028,STR0029,{STR0030,STR0034},2) == 2//"Criação de Semaforo de processamento."#"Não foi possivel acesso exclusivo para criar o semaforo de processamento."#"Repetir"#"Fechar"
				If Funname() == "FINA370" .and. !_lBlind
					oSelf:Savelog("ERRO",STR0031,STR0032+STR0033)	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
					//³do log no CV8 quando do uso da classe tNewProcess que    ³
					//³grava o LOG no SXU (FNC 00000028259/2009)                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("ERRO",STR0031,STR0032+STR0033)						
				Else	
					ProcLogAtu("ERRO",STR0031,STR0032+STR0033)	
				EndIf	
				Return lRet
			Else
				nER := 0
			EndIf		
		ElseIf nER >= 30
			If Funname() == "FINA370" .and. !_lBlind
				oSelf:Savelog("ERRO",STR0031,STR0032+STR0033)	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
				//³do log no CV8 quando do uso da classe tNewProcess que    ³
				//³grava o LOG no SXU (FNC 00000028259/2009)                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ProcLogAtu("ERRO",STR0031,STR0032+STR0033)		
			Else	
				ProcLogAtu("ERRO",STR0031,STR0032+STR0033)	
			EndIf	
			Return lRet
		EndIf
    EndIf
EndDo

//MakeDir("\SEMAFORO\")
cFile := "CTB370"+AllTrim(cEmpAnt)

lCriaTrab := !(MsFile(cFile,,"TOPCONN"))

If !lCriaTrab
	If Select("SEM370") <= 0
		dbUseArea(.T.,'TOPCONN',cFile,"SEM370",.T.,.F.)
	EndIf
	If (lCriaTrab := VALTYPE(SEM370->DTDE) == 'D')
		SEM370->(DBCLOSEAREA())
		MSERASE(cFile,,"TOPCONN")
	Endif
EndIf

If lCriatrab
	aStruct  := {}
	AAdd( aStruct, { "FILDE"	, "C", Len( cFilAnt )	, 0 } )
	AAdd( aStruct, { "FILATE"	, "C", Len( cFilAnt )	, 0 } )
	AAdd( aStruct, { "DTDE"		, "C", 8 				, 0 } )
	AAdd( aStruct, { "DTATE"	, "C", 8 				, 0 } )
	AAdd( aStruct, { "CCART"	, "C", 1				, 0 } )
	AAdd( aStruct, { "CUSER"	, "C", Len( cUserCTB )	, 0 } )
	AAdd( aStruct, { "HORAI"	, "C", Len(Time())		, 0 } )
	AAdd( aStruct, { "DATAI"	, "C", 8				, 0 } )
	AAdd( aStruct, { "HORAF"	, "C", Len(Time())		, 0 } )
	AAdd( aStruct, { "DATAF"	, "C", 8				, 0 } )
	MsCreate( cFile , aStruct , 'TOPCONN' )
EndIf

If Select("SEM370") <= 0
	dbUseArea(.T.,'TOPCONN',cFile,"SEM370",.T.,.F.)
EndIf

dbSelectArea("SEM370")			
dbGoTop()

lSai		:= .F.
lRet1		:= .T.
lRet2		:= .T.
lRet3		:= .T.	

While !lSai .and. SEM370->(!Eof())
	        
	If cFilDe <= SEM370->FILDE .and. cFilAte >= SEM370->FILATE
		lRet1 := .F.
	ElseIf cFilDe >= SEM370->FILDE .and. cFilDe <= SEM370->FILATE
		lRet1 := .F.
	ElseIf cFilAte >= SEM370->FILDE .and. cFilAte <= SEM370->FILATE
		lRet1 := .F.
	ElseIf cFilDe > cFilAte
		lRet1 := .F.		
	EndIf	    

	If DTOS(dDtVldDe) <= SEM370->DTDE .and. DTOS(dDtVldAte) >= SEM370->DTATE
		lRet2 := .F.
	ElseIf DTOS(dDtVldDe) >= SEM370->DTDE .and. DTOS(dDtVldDe) <= SEM370->DTATE
		lRet2 := .F.
	ElseIf DTOS(dDtVldAte) >= SEM370->DTDE .and. DTOS(dDtVldAte) <= SEM370->DTATE
		lRet2 := .F.
	ElseIf DTOS(dDtVldDe) > DTOS(dDtVldAte)
		lRet2 := .F.		
	EndIf
	
	If nCart == 4 .or. SEM370->CCART == "4"
		lRet3 := .F.
	ElseIf Str(nCart,1) == SEM370->CCART	
		lRet3 := .F.	
	EndIf
	
	If !lRet1 .and. !lRet2 .and. !lRet3
		/// SE LOCALIZOU NO MESMO PERIODO E NAS MESMAS FILIAIS E MESMA CARTEIRA

		If SEM370->(RLock())			/// SE CONSEGUIR ALOCAR 	
			SEM370->(dbDelete())		/// NAO TEM CONCORRENCIA
			SEM370->(MsUnlock())
		Else		
			If !_lBlind
				Aviso(STR0031,STR0032+Alltrim(SEM370->CUSER)+" "+SEM370->HORAI+" "+STR0033,{STR0034},2) //"Atenção!"###"Este processo esta sendo utilizado com parametros conflitantes ( mesmo periodo ou carteiras ) por outro usuário ( "###" ) no momento. Verifique o período e os parametros selecionados para o processamento ou tente novamente mais tarde."###"Fechar"
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o log de processamento com o erro  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Funname() == "FINA370" .and. !_lBlind
					If ValType(oSelf) == "O"
						oSelf:Savelog("ERRO",STR0031,STR0032+Alltrim(SEM370->CUSER)+STR0033)
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Utilizacao da funcao ProcLogAtu para permitir a gravacao ³
					//³do log no CV8 quando do uso da classe tNewProcess que    ³
					//³grava o LOG no SXU (FNC 00000028259/2009)                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ProcLogAtu("ERRO",STR0031,STR0032+AllTrim(SEM370->CUSER)+STR0033)	
				Else	
    				ProcLogAtu("ERRO",STR0031,STR0032+Alltrim(SEM370->CUSER)+STR0033)
    			EndIf	
			lSai		:= .T.
		EndIf
	EndIf
	SEM370->(dbSkip())
EndDo

If !lSai
	RecLock("SEM370",.T.)
	SEM370->FILDE	:= PADR(cFilDe,LEN(cFilAnt))
	SEM370->FILATE	:= PADR(cFilAte,LEN(cFilAnt))
	SEM370->DTDE	:= DTOS(dDtVldDe)
	SEM370->DTATE	:= DTOS(dDtVldAte)
	SEM370->CCART	:= Str(nCart,1)
	SEM370->CUSER	:= cUserCTB
	SEM370->HORAI	:= Time()
	SEM370->DATAI	:= DTOS(Date())
	MsUnlock()	
	RecLock("SEM370",.F.)	// DEIXA REGISTRO ALOCADO
	lRet := .T.				// PROCESSAMENTO PODE SER EFETUADO
EndIf

UnLockByName("FINA370LOCKPROC"+cEmpAnt,.T.,.T.,.T.)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA370CONC³ Autor ³ Vinicius Barreira	  ³ Data ³ 24/08/95	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela de Aviso de Falha na consistˆncia do SE5			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FA370CONC() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAFIN													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA370CONC()
Local lRet		:= .F.
Local lUsaLog	:= SuperGetMv("MV_FINLOG",.T.,.F.)
Local cTexto	:= ""
Local cDate		:= DtoC(date())
Local cHour		:= substr(time(),1,5)
Local cPathLog	:= GetMv("MV_DIRDOC")
Local cLogArq	:= "Fina370Log.TXT"
Local cCaminho	:= cPathLog + cLogArq
Local lCtbafin	:= FwIsInCallStack("CTBAFIN")

If valtype("nTpLog") == "U"
	nTpLog := 1
EndIf

If !IsBlind()
	If lUsaLog
		cTexto += "*** "+cDate+" "+cHour+"--> "+ STR0025 + "PREF. + NUM + PARC + TIP"+chr(13)+chr(10) // "Dados do título:"
		cTexto += SE5->E5_PREFIXO+"-"+SE5->E5_NUMERO+"-"+SE5->E5_PARCELA+"-"+SE5->E5_TIPO + chr(13)+chr(10)
		cTexto += STR0035 + ": " + ALLTRIM(STR(SE5->(RECNO()))) +chr(13)+chr(10)    //"Registro SE5 ->"
		cTexto += "*** ---------------------- ***"

		If lCtbafin .Or. nTpLog == 1  
			FinLog( cCaminho, cTexto ) 
		ElseIf nTpLog == 2
			aAdd(aIncons, cTexto )
		EndIf

		lGerouTxt := .T.
		lRet := .T.

	Else
		lRet := MsgYesNo (STR0020+chr(13)+chr(10)+;
							chr(13)+chr(10)+ STR0024 + Iif(SE5->E5_RECPAG=="R",STR0014,STR0013)+;
							chr(13)+chr(10)+ STR0025 + SE5->E5_PREFIXO+"-"+SE5->E5_NUMERO+"-"+SE5->E5_PARCELA+"-"+SE5->E5_TIPO +;
							 chr(13)+chr(10)+ STR0035 + STR(SE5->(RECNO())),cCadastro)
	EndIf

Else 
	If lUsaLog
		cTexto += "*** "+cDate+" "+cHour+"--> "+ STR0025 + "PREF. + NUM + PARC + TIP"+chr(13)+chr(10) // "Dados do título:"
		cTexto += SE5->E5_PREFIXO+"-"+SE5->E5_NUMERO+"-"+SE5->E5_PARCELA+"-"+SE5->E5_TIPO + chr(13)+chr(10)
		cTexto += STR0035 + ": " + ALLTRIM(STR(SE5->(RECNO()))) +chr(13)+chr(10)    //"Registro SE5 ->"
		cTexto += "*** ---------------------- ***"

		If lCtbafin .Or. nTpLog == 1  
			FinLog( cCaminho, cTexto ) 
		ElseIf nTpLog == 2
			aAdd(aIncons, cTexto )
		EndIf
		
		lGerouTxt := .T.
		lRet := .T.
	EndIf
EndIf
Return lRet

//--------------------------------------------------------------------------
/*/{Protheus.doc} VldDtE5()
Condicional While para validação se o a data do Movimento Bancario 
está no range selecionado. 

@Param cAliasSe5 	Alias da tabela temporaria SE5
@Param cCampo 		Data Utilizada "E5_DATA","E5_DTDIGIT" ou "E5_DTDISPO"
@Param dPar05 		Pergunte F12 = ( mv_par05 - Data Fim)	
@Param dDataIni 	Data Inicial 

@author Luiz Henrique
@since 22/01/2020
@version 12.1.27
/*/
//---------------------------------------------------------------------------

Static Function VldDtE5(cAliasSe5,cCampo,dPar05,dDataIni)

	Local lRet 			:= .F.

	Default cAliasSe5 	:= "" 
	Default cCampo	  	:= ""
	Default dPar05		:= dDataBase
	Default dDataIni	:= dDataBase

	If !Empty(cAliasSe5) .AND. (cAliasSE5)->(!Eof()) 
		If (cAliasSE5)->E5_TIPODOC $ 'TR#TE' .OR. Empty((cAliasSE5)->(E5_TIPODOC+E5_TIPO)) 		
			If(cAliasSE5)->E5_DATA >= dDataIni .AND. (cAliasSE5)->E5_DATA <= dPar05
				lRet := .T.
			ElseIf (cAliasSE5)->(&cCampo) <= dPar05			
				lRet := .T.
			EndIf
		ElseIf (cAliasSE5)->(&cCampo) <= dPar05
			lRet := .T.
		EndIf
	EndIf

Return lRet