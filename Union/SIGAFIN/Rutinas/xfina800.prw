#INCLUDE "fina800.ch"
#INCLUDE "PROTHEUS.CH"

#DEFINE CUSTO 		1
#DEFINE VENCDE 	2
#DEFINE VENCATE	3
#DEFINE NATDE 		4
#DEFINE NATATE 	5
#DEFINE RISCDE    6
#DEFINE RISCATE   7
#DEFINE mcEMP 1
#DEFINE mcUNG 2
#DEFINE mcFIL 3

Static lFWCodFil := .T.
STATIC lFinc24 := IsIncallStack("FINC024")
Static aLSTBMDAC := {}
Static lLookShare := .T. //If(ExistBlock('FA800LS'),ExecBlock('FA800LS', .F., .F.),.F.) 

/* FINXATU */
Static lFASLDNAT
Static nTamNatur
Static __lFivAbati
Static __lFiwAbati
Static __lExistFJV

/*/{Protheus.doc} FINA800
Programa de recalculo de Saldos de Naturezas

@Author Unknow
@Since 25/05/2010
@Param lDireto
@Param lAutomato
@Version 11.80
/*/
User Function XFINA800(lDireto,lAutomato)
Local nOpca			:= 0
Local aSays			:= {}
Local aButtons		:= {}
Local cProcessa		:= ""
Local cFunction		:= "FINA800"
Local cTitle		:= STR0001 		//"Recálculo de Saldos de Naturezas Financeiras"
Local cDescricao	:= STR0002 +;	//"Este programa tem por objetivo recalcular e atualizar os saldos das "
					   STR0003 +;	//"naturezas financeiras."
					   STR0004 +;	//"Utilizar para a carga inicial dos arquivos de saldos de naturezas   "
					   STR0005		//"financeiras ou em caso de defasagem nos saldos das naturezas."
Local bProcess
Local cPerg			:= "AFI800"
Local lGestCorp		:= .F.
Local lPrjCni 		:= ValidaCNI()
Local cModoFilial 	:= ""
Local cModoUnNeg	:= ""

Default lDireto		:= .F.
Default lAutomato   := .F.

Private cCadastro := STR0001 //"Recálculo de Saldos de Naturezas Financeiras"
/*
 * Verifica se o ambiente trabalha com a Gestão Corporativa
 */
lGestCorp := FWSizeFilial() > 2

/*
 * Validação do compartilhamento das tabelas do fluxo de caixa por natureza financeira.
 * Compartilhamento de tabelas deve ser o mesmo para as seguintes tabelas:
 *
 * - FIV - Movimentos Diários Fluxo de Caixa por Natureza Financeira
 * - FIW - Movimentos Mensais Fluxo de Caixa por Natureza Financeira
 * - FIX - Cabeçalho Histórico Fluxo de Caixa por Natureza Financeira
 * - FIY - Itens Histórico Fluxo de Caixa por Natureza Financeira
 */

cModoUnNeg  := GetTpShare("FIV",mcUNG)
cModoFilial	:= GetTpShare("FIV",mcFIL)

If lPrjCni
	// Todas as tabelas do fluxo de caixa e a de naturezas financeiras com o compartilhamento "EXCLUSIVO"
	If GetTpShare("FIV",mcUNG) == "E" .AND. GetTpShare("FIV",mcFIL) == "E" .AND.;
	   GetTpShare("FIW",mcUNG) == "E" .AND. GetTpShare("FIW",mcFIL) == "E" .AND.;
	   GetTpShare("FIX",mcUNG) == "E" .AND. GetTpShare("FIX",mcFIL) == "E" .AND.;
	   GetTpShare("FIY",mcUNG) == "E" .AND. GetTpShare("FIY",mcFIL) == "E"
	   lProcessa := .T.
	// Todas as tabelas do fluxo de caixa e a de naturezas financeiras com o compartilhamento "COMPARTILHADO"
	ElseIf GetTpShare("FIV",mcUNG) == "C"  .AND. GetTpShare("FIV",mcFIL) == "C"	.AND.;
	   GetTpShare("FIW",mcUNG)     == "C"  .AND. GetTpShare("FIW",mcFIL) == "C" .AND.;
	   GetTpShare("FIX",mcUNG)     == "C"  .AND. GetTpShare("FIX",mcFIL) == "C" .AND.;
	   GetTpShare("FIY",mcUNG)     == "C"  .AND. GetTpShare("FIY",mcFIL) == "C"
	   lProcessa := .T.
	// Se o Compartilhamento não atende a forma correta, não permite execução
	Else
		lProcessa := .F.	
	EndIf
Else
	If  GetTpShare("FIW",mcUNG) == cModoUnNeg  .AND. GetTpShare("FIX",mcUNG) == cModoUnNeg  .AND. GetTpShare("FIY",mcUNG) == cModoUnNeg .AND. ; 
		GetTpShare("FIW",mcFIL) == cModoFilial .AND. GetTpShare("FIX",mcFIL) == cModoFilial .AND. GetTpShare("FIY",mcFIL) == cModoFilial
		lProcessa := .T.
	Else
		//-----------------------------------------------------------
		// Se o Compartilhamento não atende a forma correta, não permite execução
		//-----------------------------------------------------------
		lProcessa := .F.
	EndIf
EndIf

// Se o Compartilhamento não atende a forma correta, não permite execução
If !lProcessa
	Help(" ",1,"RECALSLDFC",,STR0017,1,0) //"Compartilhamento incorreto de tabelas do fluxo de caixa. Consulte o administrador de banco de dados."
	Return()
EndIf

//Verifica se o ambiente eh Top
If !IfDefTop()
	HELP(" ",1,"ONLYTOP")
	Return .F.
Endif

//====================================================================================================
// Grupo - AFI800
//----------------------------------------------------------------------------------------------------
// MV_PAR01 - Seleciona Filiais
// MV_PAR02 - Filial De
// MV_PAR03 - Filial Ate
// MV_PAR04 - Data De
// MV_PAR05 - Data Ate
// MV_PAR06 - Natureza De
// MV_PAR07 - Natureza Ate
// MV_PAR08 - Tipo de saldo a recalcular (1 = Todos / 2 = Orcados / 3 = Previstos / 4 = Realizados)
//====================================================================================================

Pergunte("AFI800",.F.)

If !lAutomato
	tNewProcess():New( cFunction, cTitle, {|oSelf| FA800FIL( MV_PAR02, MV_PAR03, oSelf, lGestCorp ) }, cDescricao, cPerg )
Else
	FA800FIL( MV_PAR02, MV_PAR03, , lGestCorp, lAutomato )
EndIf

Return .T.

/*/{Protheus.doc} FA800Fil
Executa o processamento para cada filial

@Author Mauricio Pequim Jr.
@Since 21/09/2009
@Param cFilDe
@Param cFilAte
@Param oSelf
@Param lGestCorp
@Param lAutomato
@Version 11.80
/*/
Static Function FA800Fil(cFilDe,cFilAte,oSelf,lGestCorp,lAutomato)
Local cFilIni 	:= cFIlAnt
Local aArea		:= GetArea()
Local nInc		:= 0
Local nProcess	:= 0
Local lSelecFil	:= .F.

Private aSM0      := AdmAbreSM0()
Default lGestCorp := .F.
DEFAULT lAutomato := .F.

nProcess	:= Len( aSM0 )

If !lAutomato
	oSelf:Savelog("INICIO")
	oSelf:SetRegua1(nProcess)
EndIf

lSelecFil := MV_PAR01 == 1

If !lSelecFil
	If lGestCorp
		cFilde := FWGETCODFILIAL
		cFiate := cFilde
	Else
		cFilde := xFilial("FIV" )
		cFiate := cFilde
	EndIf
EndIf

For nInc := 1 To nProcess
	If aSM0[nInc][1] == cEmpAnt .AND. IIf(lSelecFil,aSM0[nInc][2] >= cFilDe .AND. aSM0[nInc][2] <= cFilAte,aSM0[nInc][2] == cFilDe)
		cFilAnt  := aSM0[nInc][2]
		If !lAutomato
			oSelf:SaveLog( STR0006 + cFilAnt) //"MENSAGEM: Executando a apuracao da filial  "
			oSelf:IncRegua1(STR0008 + cFilAnt) //"Executando a apuracao da filial "
		EndIf

		If !FA800Proc(oSelf, nInc)
			Exit
		EndIf

	EndIf
Next

//Executa função somente uma vez apos realizar todo o processamento, para ambientes (FIV) compartilhados
If GetTpShare("FIV",mcFIL) == "C" .AND. nProcess > 0 .AND. nInc = nProcess+1 
	F800SNMES(oSelf ,nInc,"C")
EndIf

If !lAutomato
	oSelf:Savelog("FIM")
EndIf

cFIlAnt := cFilIni
RestArea(aArea)

Return

/*/{Protheus.doc} AdmAbreSM0
Retorna um array com as informações das filias das empresas

@Author Orizio
@Since 22/01/2010
@Version 11.80
@Return aRetSM0
/*/
Static Function AdmAbreSM0()
Local aArea			:= SM0->( GetArea() )
Local aAux			:= {}
Local aRetSM0		:= {}
Local lFWLoadSM0	:= .T.
Local lFWCodFilSM0 	:= .T.
Local nX			:= 1

If lFWLoadSM0
	aRetSM0	:= FWLoadSM0()
	nX := aScan(aRetSM0,{|x| x[1] == cEmpAnt}) // Busca somente as filiais do grupo de empresa logado.
	While nX != 0 .And. nX <= Len(aRetSM0) .And. aRetSM0[nX][1] == cEmpAnt
		aAdd(aAux,aRetSM0[nX])
		nX++
	EndDo
	aRetSM0 := aClone(aAux)
Else
	DbSelectArea( "SM0" )
	SM0->( DbGoTop() )
	While SM0->( !Eof() )
		aAux := { 	SM0->M0_CODIGO,;
					IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
					"",;
					"",;
					"",;
					SM0->M0_NOME,;
					SM0->M0_FILIAL }

		aAdd( aRetSM0, aClone( aAux ) )
		SM0->( DbSkip() )
	End
EndIf

RestArea( aArea )

Return aRetSM0

/*/{Protheus.doc} Fa800Proc
Recalcula os saldos das naturezas

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function Fa800Proc( oSelf, nInc)
Local lParamJur :=  SuperGetMv( "MV_JURXFIN" ,,.F.) // Habilita integração entre os módulos SIGAFIN x SIGAPFS (.T. Sim; .F. Não)

DEFAULT oSelf := NIL


//Excluir as naturezas de cada data (diario)
F800DelSND(oSelf ,nInc)

//Excluir as naturezas de cada data (mensal)
F800DelSNM(oSelf ,nInc)

//Excluir as naturezas de cada data (mensal) FJV - Analitico
F800DelFJV(oSelf ,nInc)

//Calculo dos saldos Orcados
//SE7 - Orcamentos por Naturezas
If mv_par08 < 3
	If  !F800VLDSE7(oSelf ,nInc)
		Return(.F.)
	EndIf
	F800SOSE7(oSelf ,nInc)
Endif

//Calculo dos saldos Previstos - DIARIO
If mv_par08 == 1 .or. mv_par08 == 3

	//Calculo dos saldos Previstos - Receber (SE1 exceto Multinatureza)
	F800SPSE1(oSelf ,nInc)

	//Calculo dos saldos Previstos - Pagar (SE2 exceto Multinatureza)
	F800SPSE2(oSelf ,nInc)

	//Calculo dos saldos Previstos - Multinaturezas Receber Emissao
	F800SPSEV(oSelf ,nInc)

	//Calculo dos saldos Previstos - Comissoes
	F800SPSE3(oSelf ,nInc)

Endif

//Calculo dos saldos Realizados - DIARIO
If mv_par08 == 1 .or. mv_par08 == 4

	//Calculo dos saldos Realizados / Aplicacao / Emprestimo
	F800SRSE5(oSelf ,nInc)

	//Calculo dos saldos Realizados - Movimentos bancarios manuais
	F800SRMOV(oSelf ,nInc)

	//Calculo dos saldos Realizados - Multinaturezas Receber Baixas
	F800SRSEV(oSelf ,nInc)

	If lParamJur
		//Calculo dos saldos Realizados - Multinaturezas lançamentos jurídicos
		JURSLDOHB(oSelf ,nInc)
	EndIf

Endif

//Calculo dos saldos - MENSAIS - Apenas para ambientes exclusivos
If GetTpShare("FIV",mcFIL) == "E" 
	F800SNMES(oSelf ,nInc,"E")
EndIf

Return .T.

/*/{Protheus.doc} F800SOSE7
Reprocessa Saldos Orçados

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function F800SOSE7(oSelf ,nInc, aPerguntes)
Local aArea		:= GetArea()
Local cQuery	:= ""
Local cFilSE7   := ""
Local cAliasQry	:= "TRB800C"
Local dData		:= CTOD("")
Local nMes		:= 0
Local aValores	:= {}
Local lFinc24 	:= IsIncallStack("FINC024")
Local lProcessa	:= .F.

Default aPerguntes := {}
DEFAULT oSelf := NIL

If lFinc24
	lProcessa := .T.
	cFilSE7 := xFilial("SE7")
ElseIf GetTpShare("SE7",mcFIL) == "C" 
	If nInc = 1
		lProcessa := .T.
		cFilSE7   := xFilial("SE7")
	EndIf
Else
	lProcessa := .T.
	cFilSE7   := cFilAnt
EndIf

dbSelectArea("SE7")
dbSetOrder(1)

If oSelf <> nil
	oSelf:SetRegua2(RecCount())
EndIf

If lProcessa

	cQuery := "SELECT R_E_C_N_O_ RECNO FROM " + RetSQLTab('SE7')
	cQuery += " WHERE "
	cQuery += " E7_FILIAL   = '" + cFilSE7 + "' AND "
	cQuery += " E7_ANO     >= '" + If(lFinc24,RIGHT(STR(YEAR(aPerguntes[2])),4) ,RIGHT(STR(YEAR(mv_par04)),4)) + "' AND "
	cQuery += " E7_ANO     <= '" + If(lFinc24,RIGHT(STR(YEAR(aPerguntes[3])),4) ,RIGHT(STR(YEAR(mv_par05)),4)) + "' AND "
	cQuery += " E7_NATUREZ >= '" + If(lFinc24,aPerguntes[4]	,mv_par06 ) + "' AND "
	cQuery += " E7_NATUREZ <= '" + If(lFinc24,aPerguntes[5] ,mv_par07 ) + "' AND "

	If lFinc24
		If(!Empty(aPerguntes[1]),cQuery += " E7_CCUSTO IN (" +  aPerguntes[1] + ") AND ", Nil)
	EndIf
	
	cQuery += " SE7.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	dbSelectArea(cAliasQry)
	SED->(DbSetOrder(1))
	DbGotop()
	If !EOF() .AND. !BOF()
		While !(cAliasQry)->(Eof())

			If oSelf <> nil
				oSelf:IncRegua2(STR0011) //"Atualizando saldos Orçados das naturezas..."
			EndIf

			//Controle de Saldo de Naturezas
			SE7->(dbGoto( (cAliasQry)->RECNO ) )
			SED->(MsSeek(xFilial("SED") + SE7->E7_NATUREZ ))
			aValores	:= {	SE7->E7_VALJAN1,;
								SE7->E7_VALFEV1,;
								SE7->E7_VALMAR1,;
								SE7->E7_VALABR1,;
								SE7->E7_VALMAI1,;
								SE7->E7_VALJUN1,;
								SE7->E7_VALJUL1,;
								SE7->E7_VALAGO1,;
								SE7->E7_VALSET1,;
								SE7->E7_VALOUT1,;
								SE7->E7_VALNOV1,;
								SE7->E7_VALDEZ1}

			For nMes := 1 to 12
				//Ultimo dia do mes (data do Orcado)
				dData := (LastDay(Ctod("01"+"/"+StrZero(nMes,2)+"/"+SE7->E7_ANO, "ddmmyy")))

				If lFinc24
					FC24SldNat(/*cAliasQry*/, 'SE7', If(SED->ED_COND=="D","P",SED->ED_COND), "+",0, aValores[nMes], SED->ED_CODIGO, dData)
				Else
					//Atualizo o valor atual para o saldo da natureza
					AtuSldNat(SE7->E7_NATUREZ,;
							dData,;
							SE7->E7_MOEDA,;
							"1",;
							If(SED->ED_COND=="D","P",SED->ED_COND),;
							aValores[nMes],;
							aValores[nMes],;
							"+",;
							,;
							FunName(),;
							"SE7",;
							SE7->(Recno()),;
							"",;
							"",;
							0,;
							cFilAnt)
				EndIf
			Next

			dbSelectArea(cAliasQry)
			dbSkip()
		EndDo
	Endif

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE7")
Endif

RestArea(aArea)

Return .T.

/*/{Protheus.doc} F800SPSE1
Reprocessa Saldos Previstos - Receber

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function F800SPSE1(oSelf ,nInc, aPerguntes)
Local aArea			:= GetArea()
Local cQuery		:= ""
Local cAliasQry		:= "TRB800D"
Local lNRastDSD		:= SuperGetMV("MV_NRASDSD",.T.,.F.)
Local lFinc24		:= IsIncallStack("FINC024")

Default aPerguntes	:= {}
DEFAULT oSelf := NIL

dbSelectArea("SE1")
dbSetOrder(1)

If oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

cQuery := " SELECT E1_VENCREA, E1_TIPO , E1_NATUREZ, E1_MOEDA, "
cQuery += " SUM(E1_VALOR) NVALOR, SUM(E1_VLCRUZ) NVLCRUZ  "
cQuery += " FROM " + RetSQLTab('SE1')

//Filtra A1_RISCO caso seja chamado pelo FINC024.
If lFinc24
	cQuery += " JOIN " + RetSQLTab('SA1') + " ON A1_COD = E1_CLIENTE AND "
	cQuery += " A1_LOJA = E1_LOJA "
EndIf

cQuery += " WHERE "

If GetTpShare("SE1",mcFIL) == "C"
	cQuery += " E1_FILORIG = '" + cFilAnt + "' AND "
Else
	cQuery += " E1_FILIAL  = '" + cFilAnt + "' AND "
Endif

cQuery += 	" E1_VENCREA >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04))	+ "' AND "
cQuery += 	" E1_VENCREA <='" + If(lFinc24,DTOS(aPerguntes[3]),DTOS(mv_par05))	+ "' AND "
cQuery += 	" E1_NATUREZ >='" + If(lFinc24,aPerguntes[4] 	,mv_par06)			+ "' AND "
cQuery += 	" E1_NATUREZ <='" + If(lFinc24,aPerguntes[5] ,mv_par07)			    + "' AND "
cQuery += 	" E1_MULTNAT <> '1'  AND "
cQuery +=	" E1_TIPOFAT = '   ' AND "  	// Desconsidera títulos utilizados em geração de faturas a receber
cQuery +=	" E1_TIPOLIQ = '   ' AND "  	// Desconsidera títulos utilizados em geração de títulos de liquidação a receber
cQuery +=	" E1_FLUXO 	<> 'N'   AND "  	// Considera apenas os documentos com o campo Fluxo de caixa = Sim e campos em branco

If !lNRastDSD
	cQuery += " NOT (E1_STATUS = 'B' AND E1_DESDOBR = '1' AND E1_EMIS1 = '') AND "  
Endif 	

cQuery += " E1_TIPO <>  'RA' AND "  	// Não considera RA, pois já vai pro saldo realizado

If lFinc24
	If (!Empty(aPerguntes[1]),cQuery += " E1_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
	cQuery += " A1_RISCO >='" + aPerguntes[6] + "' AND "
	cQuery += " A1_RISCO <='" + aPerguntes[7] + "' AND "
EndIf

cQuery += " SE1.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY E1_VENCREA, E1_TIPO, E1_NATUREZ ,E1_MOEDA"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
TcSetField(cAliasQry, "E1_VENCREA" , "D")
dbSelectArea(cAliasQry)
DbGotop()
If !EOF() .AND. !BOF()
	While !(cAliasQry)->(Eof())

		If oSelf <> nil
			oSelf:IncRegua2(STR0012) //"Atualizando saldos Previstos CR das naturezas..."
		EndIf

		If lFinc24
			FC24SldNat(cAliasQry, 'SE1', 'R', If((cAliasQry)->E1_TIPO $ MVABATIM,"-","+"))
		Else
			//Atualizo o valor atual para o saldo da natureza
			AtuSldNat(	(cAliasQry)->E1_NATUREZ,;
						(cAliasQry)->E1_VENCREA,;
						(cAliasQry)->E1_MOEDA,;
						If((cAliasQry)->E1_TIPO $ MVRECANT+"/"+MV_CRNEG,"3","2"),;
						"R",;
						(cAliasQry)->NVALOR,;
						(cAliasQry)->NVLCRUZ,;
						If((cAliasQry)->E1_TIPO $ MVABATIM,"-","+"),;
						"D",;
						FunName(),;
						cAliasQry,;
						0,;
						"",;
						"",;
						0,;
						cFilAnt)
			dbSelectArea(cAliasQry)
		Endif
		dbSkip()
	EndDo
Endif

dbSelectArea(cAliasQry)
dbCloseArea()
fErase(cAliasQry + OrdBagExt())
fErase(cAliasQry + GetDbExtension())

dbSelectArea("SE1")

RestArea(aArea)

Return .T.

/*/{Protheus.doc} F800SPSE2
Reprocessa Saldos Previstos - Pagar

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function F800SPSE2(oSelf ,nInc,aPerguntes)	//Function
Local aArea			:= GetArea()
Local cQuery		:= ""
Local cAliasQry		:= "TRB800E"
Local lNRastDSD		:= SuperGetMV("MV_NRASDSD",.T.,.F.)
Local lFinc24		:= IsIncallStack("FINC024")  

Default oSelf		:= NIL
Default aPerguntes	:= {}

dbSelectArea("SE2")
dbSetOrder(1)

If oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

cQuery := " SELECT E2_VENCREA, E2_TIPO, E2_NATUREZ, E2_MOEDA, "
cQuery += " SUM(E2_VALOR) NVALOR, SUM(E2_VLCRUZ) NVLCRUZ  "
cQuery += " FROM " + RetSQLTab('SE2')
cQuery += " WHERE "
	
If GetTpShare("SE2",mcFIL) == "C"
	cQuery += " E2_FILORIG = '" + cFilAnt + "' AND "
Else
	cQuery += " E2_FILIAL  = '" + cFilAnt + "' AND "
Endif
	
cQuery += 	" E2_VENCREA >='" + If(lFinc24,DTOS(aPerguntes[2])  ,DTOS(mv_par04))	+ "' AND "
cQuery +=	" E2_VENCREA <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05))	    + "' AND "
cQuery += 	" E2_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06)					+ "' AND "
cQuery += 	" E2_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07)					+ "' AND "
cQuery += 	" E2_MULTNAT <> '1'  AND "
cQuery +=	" E2_TIPOFAT = '   ' AND " // Desconsidera títulos utilizados em geração de Faturas a Pagar
cQuery +=	" E2_TIPOLIQ = '   ' AND " // Desconsidera títulos utilizados em geração de títulos de Liquidação a Pagar
cQuery +=	" E2_FLUXO 	<> 'N' AND "  	// Considera apenas os documentos com o campo Fluxo de caixa diferente de N
cQuery +=	" E2_TIPO NOT IN ('PA') AND "

If !lNRastDSD
	cQuery += " NOT (E2_STATUS = 'B' AND E2_DESDOBR = 'S' AND E2_EMISSAO = E2_VENCTO) AND " 
Endif

If lFinc24
	If(!Empty(aPerguntes[1]),cQuery += " E2_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
EndIf

cQuery += " SE2.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY E2_VENCREA, E2_TIPO, E2_NATUREZ ,E2_MOEDA"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
TcSetField(cAliasQry, "E2_VENCREA" , "D")

dbSelectArea(cAliasQry)
DbGotop()
If !EOF() .AND. !BOF()
	While !(cAliasQry)->(Eof())

		If oSelf <> nil
			oSelf:IncRegua2(STR0013) //"Atualizando saldos Previstos C.PAGAR das naturezas..."
		EndIf

		If lFinc24
			FC24SldNat(cAliasQry, 'SE2', 'P', If((cAliasQry)->E2_TIPO $ MVABATIM,"-","+"))
		Else
			//Atualizo o valor atual para o saldo da natureza
			AtuSldNat(	(cAliasQry)->E2_NATUREZ,;
						(cAliasQry)->E2_VENCREA,;
						(cAliasQry)->E2_MOEDA,;
						If((cAliasQry)->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,"3","2"),;
						"P",;
						(cAliasQry)->NVALOR,;
						(cAliasQry)->NVLCRUZ,;
						If((cAliasQry)->E2_TIPO $ MVABATIM,"-","+"),;
						"D",;		// Atualiza ambas tabelas (FIV e FIW)
						FunName(),;
						cAliasQry,;
						0,;
						"",;
						"",;
						0,;
						cFilAnt)
		EndIf

		dbSkip()

	EndDo
Endif

dbSelectArea(cAliasQry)
dbCloseArea()
fErase(cAliasQry + OrdBagExt())
fErase(cAliasQry + GetDbExtension())

dbSelectArea("SE2")

RestArea(aArea)

Return .T.

/*/{Protheus.doc} F800SPSEV
Reprocessa Saldos Previstos - MultiNaturezas Receber

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function F800SPSEV(oSelf ,nInc,aPerguntes)
Local aArea			:= GetArea()
Local cQuery		:= ""
Local cTpSE1        := GetTpShare("SE1",mcFIL)
Local cTpSE2        := GetTpShare("SE2",mcFIL)
Local cTpSEV        := GetTpShare("SEV",mcFIL)
Local cAliasQry		:= "TRB800F"
Local lFinc24		:= IsIncallStack("FINC024")

DEFAULT oSelf		:= NIL
Default aPerguntes	:= {}

dbSelectArea("SEV")
dbSetOrder(2)

If oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

cQuery := " SELECT EV_NATUREZ, E1_VENCREA EV_VENCREA, EV_TIPO, E1_MOEDA MOEDA, EV_IDENT IDENT, 'R' CARTEIRA, "
cQuery += " SUM(EV_VALOR) NVALOR, SUM(E1_VLCRUZ * EV_PERC) NVLCRUZ "
cQuery += " FROM " + RetSQLTab('SEV')
cQuery += " JOIN " + RetSQLTab('SE1') + " ON "

If cTpSEV + cTpSE1 == "EE" .OR. cTpSEV + cTpSE1 == "CC" 
	cQuery += " SEV.EV_FILIAL = SE1.E1_FILIAL AND "
ElseIf cTpSEV + cTpSE1 == "EC"
	cQuery += " SEV.EV_FILIAL = SE1.E1_FILORIG AND "
EndIf	

cQuery += "      SEV.EV_PREFIXO = SE1.E1_PREFIXO AND "
cQuery += "      SEV.EV_NUM	    = SE1.E1_NUM AND "
cQuery += "      SEV.EV_PARCELA = SE1.E1_PARCELA AND "
cQuery += "      SEV.EV_TIPO	= SE1.E1_TIPO AND "
cQuery += "      SEV.EV_CLIFOR  = SE1.E1_CLIENTE AND "
cQuery += "      SEV.EV_LOJA	= SE1.E1_LOJA "
cQuery += " WHERE "

If cTpSE1 == "C"
	cQuery += " E1_FILORIG = '" + cFilAnt + "' AND "
Else
	cQuery += " E1_FILIAL  = '" + cFilAnt + "' AND "
Endif

cQuery += 	" E1_VENCREA >='" + If(lFinc24,DTOS(aPerguntes[2]) , DTOS(mv_par04)) + "' AND "
cQuery += 	" E1_VENCREA <='" + If(lFinc24,DTOS(aPerguntes[3]) , DTOS(mv_par05)) + "' AND "
cQuery += 	" EV_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06)		+ "' AND "
cQuery += 	" EV_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07)		+ "' AND "
cQuery += 	" EV_IDENT	= '1' AND "
cQuery += 	" EV_RECPAG	= 'R' AND "
cQuery += 	" E1_FATURA	= '" + Space(TamSx3("E1_FATURA")[1]) + "' AND "

If lFinc24
	cQuery += " EV_RATEICC = '2' AND "  //Rateio por centro de custo é filtrado na função F800SRSEZ
	If(!Empty(aPerguntes[1]), cQuery += " E1_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
EndIf
	
cQuery += " SE1.D_E_L_E_T_ = ' ' AND "
cQuery += " SEV.D_E_L_E_T_ = ' '     "
cQuery += " GROUP BY EV_NATUREZ, E1_VENCREA, EV_TIPO, E1_MOEDA, EV_IDENT "

cQuery += " UNION ALL "

cQuery += " SELECT EV_NATUREZ, E2_VENCREA EV_VENCREA, EV_TIPO, E2_MOEDA MOEDA, EV_IDENT IDENT, 'P' CARTEIRA, "
cQuery += " SUM(EV_VALOR) NVALOR, SUM(E2_VLCRUZ * EV_PERC) NVLCRUZ "
cQuery += " FROM " + RetSQLTab('SEV')
cQuery += " JOIN " + RetSQLTab('SE2') + " ON "

If cTpSEV + cTpSE2 == "EE" .OR. cTpSEV + cTpSE2 == "CC" 
	cQuery += "      SEV.EV_FILIAL  = SE2.E2_FILIAL AND "
ElseIf cTpSEV + cTpSE2 == "EC"
	cQuery += "      SEV.EV_FILIAL  = SE2.E2_FILORIG AND "
EndIf

cQuery += "      SEV.EV_PREFIXO = SE2.E2_PREFIXO AND "
cQuery += "      SEV.EV_NUM	    = SE2.E2_NUM AND "
cQuery += "      SEV.EV_PARCELA = SE2.E2_PARCELA AND "
cQuery += "      SEV.EV_TIPO	= SE2.E2_TIPO AND "
cQuery += "      SEV.EV_CLIFOR  = SE2.E2_FORNECE AND "
cQuery += "      SEV.EV_LOJA	= SE2.E2_LOJA "
cQuery += " WHERE "

If cTpSE2 == "C"
	cQuery += " E2_FILORIG = '" + cFilAnt + "' AND "
Else
	cQuery += " E2_FILIAL  = '" + cFilAnt + "' AND "
Endif
	
cQuery += " E2_VENCREA >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
cQuery += " E2_VENCREA <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
cQuery += " EV_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
cQuery += " EV_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
cQuery += " EV_IDENT	= '1' AND "
cQuery += " EV_RECPAG	= 'P' AND "

If lFinc24
	cQuery +=  "EV_RATEICC = '2' AND " //Rateio por centro de custo é filtrado na função F800SRSEZ
	If (!Empty(aPerguntes[1]),cQuery += " E2_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
EndIf
	
cQuery += " SE2.D_E_L_E_T_ = ' ' AND "
cQuery += " SEV.D_E_L_E_T_ = ' '     "
cQuery += " GROUP BY EV_NATUREZ, E2_VENCREA, EV_TIPO, E2_MOEDA, EV_IDENT "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
TcSetField(cAliasQry, "EV_VENCREA" , "D")

dbSelectArea(cAliasQry)
DbGotop()
If !EOF() .AND. !BOF()
	While !(cAliasQry)->(Eof())

		If oSelf <> nil
			oSelf:IncRegua2(STR0014) //"Atualizando Saldos Previstos Multinaturezas..."
		EndIf

		If lFinc24
			FC24SldNat(cAliasQry, 'SEV', (cAliasQry)->CARTEIRA, If((cAliasQry)->EV_TIPO $ MVABATIM,"-","+"))
		Else
			//Atualizo o valor atual para o saldo da natureza
			AtuSldNat(	(cAliasQry)->EV_NATUREZ,;
						(cAliasQry)->EV_VENCREA,;
						(cAliasQry)->MOEDA,;
						If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"3","2"),;
						(cAliasQry)->CARTEIRA,;
						(cAliasQry)->NVALOR,;
						(cAliasQry)->NVLCRUZ,;
						"+",;
						"D",;
						FunName(),;
						cAliasQry,;
						0,;
						"",;
						"",;
						0,;
						cFilAnt,;
						.T.)
			dbSelectArea(cAliasQry)
		EndIf
		dbSkip()

	EndDo
Endif

dbSelectArea(cAliasQry)
dbCloseArea()
fErase(cAliasQry + OrdBagExt())
fErase(cAliasQry + GetDbExtension())

dbSelectArea("SE1")

RestArea(aArea)

Return .T.

/*/{Protheus.doc} F800SPSE3
Reprocessa Saldos Previstos - Comissões

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function F800SPSE3(oSelf ,nInc, aPerguntes)
Local lPrjCni		:= ValidaCNI()
Local aArea			:= GetArea()
Local cQuery		:= ""
Local cFilSE3       := ""
Local cAliasQry		:= GetNextAlias()
Local cNatComis		:= STRTRAN(GetNewPar("MV_NATCOM",""),'"',"")
Local lFinc24		:= IsIncallStack("FINC024")
Local nMoedaSE3		:= 1
Local lProcessa     := .F.

DEFAULT oSelf		:= NIL
Default aPerguntes	:= {}

If lFinc24
	lProcessa := .T.
	cFilSE3 := xFilial("SE3")
ElseIf GetTpShare("SE3",mcFIL) == "C" 
	If nInc = 1
		lProcessa := .T.
		cFilSE3   := xFilial("SE3")
	EndIf
Else
	lProcessa := .T.
	cFilSE3   := cFilAnt
EndIf

dbSelectArea("SE3")
SE3->(dbSetOrder(1)) // Filial + Prefixo + Número + Parcela + Sequência + Vendedor

If oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

If lProcessa .AND. If(lFinc24,aPerguntes[4],mv_par06) <= cNatComis .AND. cNatComis <= If(lFinc24,aPerguntes[5],mv_par07)
	cQuery := " SELECT "
	cQuery += " SE3.E3_COMIS "
	cQuery += " , SE3.E3_VENCTO "
	cQuery += " , SE3.E3_DATA "
	cQuery += " , SE3.E3_MOEDA "

	If lFinc24
		cQuery += ",COALESCE(A1_RISCO,'') A1_RISCO "
	EndIf
	
	cQuery += " , SE3.E3_EMISSAO "
	cQuery += " FROM " + RetSQLTab('SE3') + " "

	If lFinc24
		cQuery += " LEFT JOIN " + RetSQLTab('SA1') + " ON E3_CODCLI = A1_COD "
		cQuery += " AND A1_RISCO >= '" + aPerguntes[6] + "' "
		cQuery += " AND A1_RISCO <= '" + aPerguntes[7] + "' "
	EndIf

	cQuery += " WHERE "

	cQuery += " SE3.E3_FILIAL  = '" + cFilSE3 + "' AND "
	cQuery += " SE3.E3_VENCTO >= '" + If(lFinc24,DTOS(aPerguntes[2]),DTOS(mv_par04)) + "' AND "
	cQuery += " SE3.E3_VENCTO <= '" + If(lFinc24,DTOS(aPerguntes[3]),DTOS(mv_par05)) + "' AND "
	
	If lFinc24
		If (!Empty(aPerguntes[1]), cQuery += " E3_CCUSTO IN (" +  aPerguntes[1] + ") AND ", Nil)
	EndIf

	cQuery += " SE3.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "E3_EMISSAO" , "D")
	TcSetField(cAliasQry, "E3_VENCTO" , "D")
	TcSetField(cAliasQry, "E3_DATA" , "D")

	dbSelectArea(cAliasQry)
	DbGotop()
	If !EOF() .AND. !BOF()
		While !(cAliasQry)->(Eof())

			If oSelf <> nil
				oSelf:IncRegua2(STR0012) //"Atualizando saldos Previstos CR das naturezas..."
			EndIf

			//Atualizo o valor atual para o saldo da natureza
			nMoedaSE3 := Val( (cAliasQry)->E3_MOEDA )
			If lPrjCni
			
				AtuSldNat(	cNatComis,;
					(cAliasQry)->E3_VENCTO,;
					nMoedaSE3,;
					"2",; // Previsto
					"P",; // Carteira = Pagar
					(cAliasQry)->E3_COMIS,;
					If(nMoedaSE3 > 1,NOROUND(XMOEDA((cAliasQry)->E3_COMIS,1,nMoedaSE3,(cAliasQry)->E3_EMISSAO)),(cAliasQry)->E3_COMIS),; 
					"+",;
					"D",;
					FunName(),;
					"SE3",;
					0,;
					"",;
					"",;
					0,;
					cFilAnt)

				If !EMPTY((cAliasQry)->E3_DATA)
					AtuSldNat(cNatComis,;
						(cAliasQry)->E3_VENCTO,;
						nMoedaSE3,;
						"3",; // Realizado
						"P",; // Carteira = Pagar
						(cAliasQry)->E3_COMIS,;
						(cAliasQry)->E3_COMIS,;
						"+",;
						"D",;
						FunName(),;
						"SE3",;
						0,;
						"",;
						"",;
						0,;
						cFilAnt)
				EndIf
			
			Else
			
				If lFinc24
					If !Empty((cAliasQry)->A1_RISCO)
						FC24SldNat(cAliasQry, 'SE3',"P")
					EndIf
				Else
					AtuSldNat(	cNatComis,;
						(cAliasQry)->E3_VENCTO,;
						nMoedaSE3,;
						"2",; // Previsto
						"P",; // Carteira = Pagar
						(cAliasQry)->E3_COMIS,;
						If(nMoedaSE3 > 1,NOROUND(XMOEDA((cAliasQry)->E3_COMIS,1,nMoedaSE3,(cAliasQry)->E3_EMISSAO)),(cAliasQry)->E3_COMIS),; 
						"+",;
						"D",;
						FunName(),;
						,;
						0,;
						"",;
						"",;
						0,;
						cFilAnt)
				EndIf
				
				If !EMPTY((cAliasQry)->E3_DATA)
					If lFinc24
						If !Empty((cAliasQry)->A1_RISCO)
							FC24SldNat(cAliasQry, 'SE3',"P")
						EndIf
					Else
						AtuSldNat(cNatComis,;
							(cAliasQry)->E3_VENCTO,;
							nMoedaSE3,;
							"3",; // Realizado
							"P",; // Carteira = Pagar
							(cAliasQry)->E3_COMIS,;
							(cAliasQry)->E3_COMIS,;
							"+",;
							"D",;
							FunName(),;
							,;
							0,;
							"",;
							"",;
							0,;
							cFilAnt)
					EndIf
					
				EndIf
			
			EndIf
			dbSelectArea(cAliasQry)
			dbSkip()
		EndDo
	Endif

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE3")

Endif

RestArea(aArea)

Return .T.

/*/{Protheus.doc} F800SRSE5
Reprocessa Saldos Realizados - Receber

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function F800SRSE5(oSelf ,nInc, aPerguntes)
Local aArea			:= GetArea()
Local cQuery		:= ""
Local cAliasQry		:= "TRB800G"
Local cCliVazio		:= Space(TamSx3("E1_CLIENTE")[1])
Local cDb			:= UPPER(AllTrim(TcGetDb()))
Local cFuncao		:= ""
Local lPrjCni		:= ValidaCNI()
Local lFinc24		:= IsIncallStack("FINC024")
Local lOrcaleDb2	:= .F.
Local lProcessa     := .T.
Local nValForeing	:= 0
Local cTpSE1        := GetTpShare("SE1",mcFIL)
Local cTpSE2        := GetTpShare("SE2",mcFIL)
Local cTpSE5        := GetTpShare("SE5",mcFIL)
Local cTpE1E5       := cTpSE1 + cTpSE5
Local cTpE2E5       := cTpSE2 + cTpSE5

DEFAULT oSelf		:= NIL
Default aPerguntes	:= {}

dbSelectArea("SE5")
dbSetOrder(1)

If oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

//Tratamento da função SUBSTRING() no SQL para adequação com os bancos de dados possíveis.
//Ex.: DB2, SQL Server, Oracle
 If cDb $ "DB2|ORACLE|INFORMIX"
	cFuncao := "SUBSTR"
	lOrcaleDb2 := .T.
Else
	cFuncao := "SUBSTRING"
EndIf

If lProcessa
	
	//Baixas por Contas a Receber
	If lPrjCni
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO,E5_TIPODOC, E5_RECPAG, E1_MOEDA MOEDA, 'R' CARTEIRA, "
 	Else
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E1_MOEDA MOEDA, E5_MOEDA MOEDABX, E5_RECPAG CARTEIRA, E5_TXMOEDA TXMOEDA, SUM(0) ABATI, "
		If lFinc24
			cQuery += " COALESCE(A1_RISCO,' ') RISCO, "
		EndIf
	EndIf
	cQuery += " SUM(E5_VLMOED2) NVALOR, SUM(E5_VALOR) NVLCRUZ  " 	
	cQuery += " FROM " + RetSQLTab('SE5')
	
	cQuery += " JOIN " + RetSQLTab('SE1') + " ON "

	//Compara o modo de compartilhamento de SE5 e SE1. Se ambas forem Exclusivas - considera-se a filial
	If cTpE1E5 == "EE"
		cQuery += " SE5.E5_FILIAL  = SE1.E1_FILIAL  AND "
	Else
		cQuery += " SE5.E5_FILORIG = SE1.E1_FILORIG AND "
	EndIf
	
	cQuery += " SE5.E5_PREFIXO = SE1.E1_PREFIXO	AND "
	cQuery += " SE5.E5_NUMERO  = SE1.E1_NUM		AND "
	cQuery += " SE5.E5_PARCELA = SE1.E1_PARCELA AND "
	cQuery += " SE5.E5_TIPO	   = SE1.E1_TIPO    AND "
	cQuery += " SE5.E5_CLIFOR  = SE1.E1_CLIENTE AND "
	cQuery += " SE5.E5_LOJA	   = SE1.E1_LOJA "

	If lFinc24
		cQuery += " LEFT JOIN " + RetSQLTab('SA1') + " ON E5_CLIFOR = A1_COD AND E5_RECPAG = 'R' "
		cQuery += " AND A1_RISCO >= '" + aPerguntes[6] + "'"
		cQuery += " AND A1_RISCO <= '" + aPerguntes[7] + "'"
	EndIf

	cQuery += " WHERE "

	If cTpSE5 == "C" 
		cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
	Else
		cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
	Endif 	

	cQuery += " E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
	cQuery += " E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
	cQuery += " E5_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
	cQuery += " E5_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
	cQuery += " E5_SITUACA <> 'C' AND "
	cQuery += " E5_MULTNAT <> '1' AND "
	cQuery += " E5_MOTBX NOT IN ('FAT','LIQ','CMP') AND " // Desconsidera movimentos por geração de Fatura/Liquidação a Receber
	cQuery += " E5_TIPODOC NOT IN ('BA','V2','JR','MT','DC') AND "

	If lFinc24
		If (!Empty(aPerguntes[1]),cQuery += " E5_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
	EndIf
	
	cQuery += " E5_CLIENTE	<> '" + cCliVazio + "' AND "
	cQuery += " NOT EXISTS (SELECT A.E5_NUMERO FROM " + RetSqlName("SE5") + " A "
   	cQuery += " WHERE "
	cQuery += " A.E5_FILIAL  = SE5.E5_FILIAL  AND "
	cQuery += " A.E5_PREFIXO = SE5.E5_PREFIXO AND "
	cQuery += " A.E5_NUMERO  = SE5.E5_NUMERO  AND "
	cQuery += " A.E5_PARCELA = SE5.E5_PARCELA AND "
	cQuery += " A.E5_TIPO	 = SE5.E5_TIPO    AND "
	cQuery += " A.E5_CLIFOR  = SE5.E5_CLIFOR  AND "
	cQuery += " A.E5_LOJA	 = SE5.E5_LOJA    AND "

	If cTpSE5 == "C" 
		cQuery += " A.E5_FILORIG = '" + cFilAnt + "' AND "
	Else
		cQuery += " A.E5_FILIAL  = '" + cFilAnt + "' AND "
	Endif 	

   	cQuery += " A.E5_DATA     >= '" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
	cQuery += " A.E5_DATA     <= '" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
	cQuery += " A.E5_MULTNAT  <> '1'  AND "
	cQuery += " A.E5_TIPODOC   = 'ES' AND "
	cQuery += " A.E5_RECPAG    = 'P'  AND "
	cQuery += " A.E5_SEQ	   = SE5.E5_SEQ AND "
	cQuery += " A.D_E_L_E_T_   = ' ') AND "
	cQuery += " SE5.D_E_L_E_T_ = ' '  AND "
	cQuery += " SE1.D_E_L_E_T_ = ' ' "
	
	If lPrjCni
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E1_MOEDA "
 	Else
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_RECPAG, E1_MOEDA, E5_MOEDA, E5_TXMOEDA " 
		If lFinc24
			cQuery += " , A1_RISCO"
		EndIf
	EndIf
	
	cQuery += " UNION ALL "

	//Baixas por Contas a Receber dos Impostos
	If !lPrjCni
		
		If lOrcaleDb2
			cQuery += " SELECT E1_FILORIG, E1_FILIAL, E1_NATUREZ, E1_BAIXA, E1_TIPO, CAST('0'||CAST(E1_MOEDA AS FLOAT) AS FLOAT) MOEDA, CAST(SUM(0) AS CHAR(2)) MOEDABX, "
		Else
			cQuery += " SELECT E1_FILORIG, E1_FILIAL, E1_NATUREZ, E1_BAIXA, E1_TIPO, CAST('0'||CAST(E1_MOEDA AS CHAR(1)) AS CHAR(2)) MOEDA, SUM(0) MOEDABX, "		
		EndIf
		
		cQuery += " 'R' CARTEIRA, SUM(0) TXMOEDA, SUM(0) ABATI, "
		
		If lFinc24
			cQuery += " COALESCE(A1_RISCO,' ') RISCO, "
		EndIf
		
		cQuery += " SUM(E1_VALOR) NVALOR, SUM(E1_VALOR) NVLCRUZ "
		cQuery += " FROM " + RetSQLTab('SE1')
		
		If lFinc24
			cQuery += " LEFT JOIN " + RetSQLTab('SA1') + " ON E1_CLIENTE = A1_COD "
			cQuery += " AND A1_RISCO >= '" + aPerguntes[6] + "'"
			cQuery += "	AND	A1_RISCO <= '" + aPerguntes[7] + "'"
		EndIf
		
		cQuery += " WHERE "
		
		If cTpSE1 == "C" 
			cQuery += " E1_FILORIG = '" + cFilAnt + "' AND "
		Else
			cQuery += " E1_FILIAL  = '" + cFilAnt + "' AND "
		Endif 
		
		cQuery += " E1_BAIXA >=  '" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
		cQuery += " E1_BAIXA <=  '" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
		cQuery += " E1_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
		cQuery += " E1_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
		cQuery += " E1_TIPO IN ('CF-','PI-','CS-') AND "
		cQuery += " E1_SALDO = 0 "
		
	 	If lFinc24
			If(!Empty(aPerguntes[1]),cQuery +=  " AND E1_CCUSTO IN (" + aPerguntes[1] + ")",Nil)
		EndIf
		
		cQuery += " GROUP BY E1_FILORIG, E1_FILIAL, E1_NATUREZ, E1_BAIXA, E1_TIPO, E1_MOEDA " 
		
   		If lFinc24
			cQuery += " , A1_RISCO"
		EndIf

 		cQuery += " UNION ALL "

		//Abatimentos por Contas a Receber de Impostos
		If lOrcaleDb2 
			cQuery += " SELECT E1_FILORIG, E1_FILIAL, E1_NATUREZ, E1_BAIXA, E1_TIPO, CAST('0'||CAST(E1_MOEDA AS FLOAT) AS FLOAT) MOEDA, CAST(SUM(0) AS CHAR(2)) MOEDABX, "
		Else
			cQuery += " SELECT E1_FILORIG, E1_FILIAL, E1_NATUREZ, E1_BAIXA, E1_TIPO, CAST('0'||CAST(E1_MOEDA AS CHAR(1)) AS CHAR(2)) MOEDA, SUM(0) MOEDABX, "		
		EndIf
		
		cQuery += " 'R' CARTEIRA, SUM(0) TXMOEDA, SUM(E1_COFINS+E1_CSLL+E1_PIS) ABATI, "

		If lFinc24
			cQuery += " COALESCE(A1_RISCO,' ') RISCO, "
		EndIf

		cQuery += " SUM(E1_VALOR) NVALOR, SUM(0) NVLCRUZ  "
		cQuery += " FROM " + RetSQLTab('SE1')
		If lFinc24
			cQuery += " LEFT JOIN " + RetSQLTab('SA1') + " ON E1_CLIENTE = A1_COD "
			cQuery += " AND A1_RISCO >= '" + aPerguntes[6] + "'"
			cQuery += " AND A1_RISCO <= '" + aPerguntes[7] + "'"
		EndIf
		
		cQuery += " WHERE "
		
		If cTpSE1 == "C" 
			cQuery += " E1_FILORIG = '" + cFilAnt + "' AND "
		Else
			cQuery += " E1_FILIAL  = '" + cFilAnt + "' AND "
		EndIf
		 	
		cQuery += " E1_BAIXA   >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
		cQuery += " E1_BAIXA   <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
		cQuery += " E1_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
		cQuery += " E1_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
		cQuery += " E1_TIPO IN ('"+MVIRABT+"','"+MVINABT+"','"+MVISABT+"','"+MVI2ABT+"') AND "
		cQuery += " E1_SALDO = 0 "
 		If lFinc24
			Iif (!Empty(aPerguntes[1]), cQuery += " AND E1_CCUSTO IN (" + aPerguntes[1] + ")", Nil)
		EndIf
		
		cQuery += " GROUP BY E1_FILORIG, E1_FILIAL, E1_NATUREZ, E1_BAIXA, E1_TIPO, E1_MOEDA " 
		
   		If lFinc24
			cQuery += " , A1_RISCO"
		EndIf

	   	cQuery += " UNION ALL "

	Endif

	//Baixas por Contas Pagar
	If lPrjCni
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, 'P' CARTEIRA, "
	Else
	 	cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E2_MOEDA MOEDA, E5_MOEDA MOEDABX, E5_RECPAG CARTEIRA, E5_TXMOEDA TXMOEDA, SUM(0) ABATI,"
		If lFinc24
			cQuery += " ' ' RISCO, "
		EndIf
	EndIf	
	cQuery += " SUM(E5_VALOR) NVALOR, "
	cQuery += " SUM(E5_VLMOED2) NVLCRUZ "
	cQuery += " FROM " + RetSQLTab('SE5')
	cQuery += " JOIN " + RetSQLTab('SE2')
	cQuery += " ON "

	//Compara o modo de compartilhamento de SE5 e SE2. Se ambas forem Exclusivas - considera-se a filial
	If cTpE2E5 == "EE"
		cQuery += " SE5.E5_FILIAL  = SE2.E2_FILIAL  AND "
	Else
		cQuery += " SE5.E5_FILORIG = SE2.E2_FILORIG AND "
	EndIf

	cQuery += " SE5.E5_PREFIXO = SE2.E2_PREFIXO AND "
	cQuery += " SE5.E5_NUMERO  = SE2.E2_NUM AND "
	cQuery += " SE5.E5_PARCELA = SE2.E2_PARCELA AND "
	cQuery += " SE5.E5_TIPO	   = SE2.E2_TIPO AND "
	cQuery += " SE5.E5_FORNECE = SE2.E2_FORNECE AND "
	cQuery += " SE5.E5_LOJA	   = SE2.E2_LOJA "
	
	cQuery += " WHERE "

	If cTpSE5 == "C"
		cQuery += " SE5.E5_FILORIG = '" + cFilAnt + "' AND "
	Else
		cQuery += " SE5.E5_FILIAL  = '" + cFilAnt + "' AND "
	Endif
	
	cQuery += " E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
	cQuery += " E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
	cQuery += " E5_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
	cQuery += " E5_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
	cQuery += " E5_SITUACA <> 'C' AND "
	cQuery += " E5_MULTNAT <> '1' AND "
	cQuery += " E5_MOTBX NOT IN ('FAT','LIQ','CMP') AND " // Desconsidera movimentos por geração de Fatura/Liquidação a Pagar
	cQuery += " E5_TIPODOC NOT IN ('JR','MT','DC','VM','CM','VA') AND "	//Desconsidera registros acess¢rios da baixa	//aqui kco
	cQuery += " E5_FORNECE	<> '" + cCliVazio + "' AND "
	
	If lFinc24
		Iif (!Empty(aPerguntes[1]),cQuery +=  " E5_CCUSTO IN (" + aPerguntes[1] + ") AND", Nil)
	EndIf
	cQuery += " NOT EXISTS ("
	cQuery += " SELECT ESTOR.E5_NUMERO"
	cQuery += " FROM " + RetSqlName("SE5") + " ESTOR "
	
	cQuery += " WHERE "
	
	If cTpSE5 == "C" 
		cQuery += " ESTOR.E5_FILORIG = '" + cFilAnt + "' "
	Else
		cQuery += " ESTOR.E5_FILIAL  = '" + cFilAnt + "' "
	Endif 	
		
	cQuery += " AND ESTOR.E5_PREFIXO = SE5.E5_PREFIXO "
	cQuery += " AND ESTOR.E5_NUMERO  = SE5.E5_NUMERO "
	cQuery += " AND ESTOR.E5_PARCELA = SE5.E5_PARCELA "
	cQuery += " AND ESTOR.E5_TIPO    = SE5.E5_TIPO "
	cQuery += " AND ESTOR.E5_CLIFOR  = SE5.E5_CLIFOR "
	cQuery += " AND ESTOR.E5_LOJA    = SE5.E5_LOJA "
	cQuery += " AND ESTOR.E5_SEQ     = SE5.E5_SEQ "
	cQuery += " AND ESTOR.E5_TIPODOC = 'ES' "
	cQuery += " AND ESTOR.E5_RECPAG  = 'R' "
	cQuery += " AND ESTOR.D_E_L_E_T_ = ' ' ) "
	
	If lPrjCni
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA "
	Else
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_RECPAG, E2_MOEDA, E5_MOEDA, E5_TXMOEDA "  
	EndIf

	cQuery += " UNION ALL "

	//Baixas por Inclusão de Empréstimos Financeiros
	If lPrjCni
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ FROM  " + RetSQLTab('SEH') + " "
	Else
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, EH_MOEDA MOEDA, E5_MOEDA MOEDABX, E5_RECPAG CARTEIRA, E5_TXMOEDA TXMOEDA, SUM(0) ABATI "
		If lFinc24
			cQuery += " , COALESCE(A1_RISCO,' ') RISCO "
		EndIf
		cQuery += " , E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ "
		cQuery += " FROM  " + RetSQLTab('SEH') + " "
	EndIf
	
	cQuery += " INNER JOIN  "
	cQuery += "	" + RetSQLTab('SE5') + "  ON SE5.D_E_L_E_T_ = ' ' AND  "
	cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND  "
	cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN,    " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + "  ) = SEH.EH_REVISAO "
	If lFinc24
		cQuery += " LEFT JOIN " + RetSQLTab('SA1') + " ON E5_CLIFOR = A1_COD AND E5_RECPAG = 'R' "
		cQuery += " AND A1_RISCO >= '" + aPerguntes[6] + "'"
		cQuery += " AND A1_RISCO <= '" + aPerguntes[7] + "'"
	EndIf
	
	cQuery += " WHERE "
	
	If cTpSE5 == "C" 
		cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
	Else
		cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
	Endif 	
	
	cQuery += "	E5_DATA    >='" +	If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04))	+ "' AND "
	cQuery += "	E5_DATA    <='" +	If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05))	+ "' AND "
	cQuery += "	E5_NATUREZ >='" +	If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
	cQuery += "	E5_NATUREZ <='" +	If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
	cQuery += "	E5_TIPODOC  = 'EP' AND  "
	cQuery += " E5_FORNECE	= '" + cCliVazio + "' AND "
	
	If lFinc24
		Iif (!Empty(aPerguntes[1]), cQuery += " E5_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
	EndIf
	
	cQuery += " NOT EXISTS ("
	cQuery += " SELECT ESTOR.E5_NUMERO"
	cQuery += " FROM " + RetSqlName("SE5") + " ESTOR "
	
	cQuery += " WHERE "
	
	If cTpSE5 == "C" 
		cQuery += " ESTOR.E5_FILORIG = '" + cFilAnt + "' "
	Else
		cQuery += " ESTOR.E5_FILIAL  = '" + cFilAnt + "' "
	Endif 	
	
	cQuery += " AND ESTOR.E5_PREFIXO = SE5.E5_PREFIXO "
	cQuery += " AND ESTOR.E5_NUMERO  = SE5.E5_NUMERO "
	cQuery += " AND ESTOR.E5_PARCELA = SE5.E5_PARCELA "
	cQuery += " AND ESTOR.E5_TIPO    = SE5.E5_TIPO "
	cQuery += " AND ESTOR.E5_CLIFOR  = SE5.E5_CLIFOR "
	cQuery += " AND ESTOR.E5_LOJA    = SE5.E5_LOJA "
	cQuery += " AND ESTOR.E5_SEQ     = SE5.E5_SEQ "
	cQuery += " AND ESTOR.E5_TIPODOC = 'ES' "
	cQuery += " AND ESTOR.E5_RECPAG  = SE5.E5_RECPAG "
	cQuery += " AND ESTOR.D_E_L_E_T_ <> '*' ) AND "
	cQuery += " SEH.D_E_L_E_T_ = ' ' "
	
	If lPrjCni
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA, E5_RECPAG, E5_VLMOED2, E5_VALOR "
 	Else
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, EH_MOEDA, E5_MOEDA, E5_RECPAG, E5_TXMOEDA, E5_VLMOED2, E5_VALOR "
    	If lFinc24
			cQuery += " , A1_RISCO"
		EndIf
    EndIf
   	cQuery += " UNION ALL "

	//Baixas por Pagamentos de Empréstimos Financeiros
	 If lPrjCni
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, 'P' CARTEIRA, "
		cQuery += " SUM(E5_VLMOED2) NVALOR, SUM(E5_VALOR) NVLCRUZ  " 
	Else
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, EH_MOEDA MOEDA, E5_MOEDA MOEDABX, E5_RECPAG CARTEIRA, E5_TXMOEDA TXMOEDA, SUM(0) ABATI "
		If lFinc24
			cQuery += " , ' ' RISCO "
		EndIf
		cQuery += " ,E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ  "
	EndIf
	
	cQuery += " FROM " + RetSQLTab('SE5') + " "
	cQuery += " INNER JOIN " + RetSqlTab("SEH") + " ON "
	cQuery += " SEH.D_E_L_E_T_ 	= ' ' AND "
	cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND "
 	cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN,    " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO "
	cQuery += " INNER JOIN " + RetSqlTab("SEI") + " ON "
	cQuery += " SEI.D_E_L_E_T_ 	= ' ' AND "
	cQuery += " SEH.EH_NUMERO	= SEI.EI_NUMERO AND "
	cQuery += " SEH.EH_REVISAO	= SEI.EI_REVISAO AND "
	cQuery += " SEI.EI_STATUS  != 	'C' AND "
	cQuery += " SEI.EI_TIPODOC 	= 	'VL' AND "
	cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + TamSX3("EH_REVISAO")[1] + 1) + "," + CVALTOCHAR(TamSX3("EI_SEQ")[1]) + ") = SEI.EI_SEQ "
	
	cQuery += " WHERE "
	
	If cTpSE5 == "C" 
		cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
	Else
		cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
	Endif 	
	
	cQuery += " E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
	cQuery += " E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
	cQuery += " E5_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
	cQuery += " E5_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
	cQuery += " E5_SITUACA <> 'C'  AND "
	cQuery += " E5_TIPODOC  = 'PE' AND "
	cQuery += " E5_FORNECE  = '" + cCliVazio + "' AND "
	
	If lFinc24
		Iif (!Empty(aPerguntes[1]), cQuery +=  " E5_CCUSTO IN (" + aPerguntes[1] + ") AND", Nil)
	EndIf
	
	cQuery += " NOT EXISTS ("
	cQuery += " SELECT ESTOR.E5_NUMERO "
	cQuery += " FROM " + RetSqlName("SE5") + " ESTOR "
	
	cQuery += " WHERE "
	
	If cTpSE5 == "C" 
		cQuery += " ESTOR.E5_FILORIG = '" + cFilAnt + "' "
	Else
		cQuery += " ESTOR.E5_FILIAL  = '" + cFilAnt + "' "
	Endif 	
	
	cQuery += " AND ESTOR.E5_PREFIXO = SE5.E5_PREFIXO "
	cQuery += " AND ESTOR.E5_NUMERO  = SE5.E5_NUMERO "
	cQuery += " AND ESTOR.E5_PARCELA = SE5.E5_PARCELA "
	cQuery += " AND ESTOR.E5_TIPO    = SE5.E5_TIPO "
	cQuery += " AND ESTOR.E5_CLIFOR  = SE5.E5_CLIFOR "
	cQuery += " AND ESTOR.E5_LOJA    = SE5.E5_LOJA "
	cQuery += " AND ESTOR.E5_SEQ     = SE5.E5_SEQ "
	cQuery += " AND ESTOR.E5_TIPODOC = 'PE' "
	cQuery += " AND ESTOR.E5_RECPAG != SE5.E5_RECPAG "
	cQuery += " AND ESTOR.D_E_L_E_T_ = ' ' "
	cQuery += " AND " + cFuncao + "(ESTOR.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]  + TamSX3("EH_REVISAO")[1] + 1) + "," + CVALTOCHAR(TamSX3("EI_SEQ")[1]) + ") = "
	cQuery += " "     + cFuncao + "(SE5.E5_DOCUMEN,   " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]  + TamSX3("EH_REVISAO")[1] + 1) + "," + CVALTOCHAR(TamSX3("EI_SEQ")[1]) + ") "
	cQuery += " AND " + cFuncao + "(ESTOR.E5_DOCUMEN,1, "+CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO "
	cQuery += " AND " + cFuncao + "(ESTOR.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]  + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO ) AND "
	cQuery += " SE5.D_E_L_E_T_ = ' ' "
	
	If lPrjCni
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA, E5_RECPAG, E5_VLMOED2, E5_VALOR "
 	Else
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_RECPAG, EH_MOEDA, E5_MOEDA, E5_TXMOEDA, E5_VLMOED2 , E5_VALOR "
	EndIf

	cQuery += " UNION ALL "

	//Baixas por Inclusão de Aplicações Financeiras
	If lPrjCni
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ FROM  " + RetSQLTab('SEH') + " "
	Else
		cQuery += "	SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, EH_MOEDA MOEDA, E5_MOEDA MOEDABX, E5_RECPAG CARTEIRA, E5_TXMOEDA TXMOEDA, SUM(0) ABATI "
		If lFinc24
			cQuery += " , ' ' RISCO "
		EndIf
		cQuery += " , E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ "
		cQuery += " FROM  " + RetSQLTab('SEH') + " "
	EndIf

	cQuery += " INNER JOIN  "
	cQuery += "	" + RetSQLTab('SE5') + "  ON SE5.D_E_L_E_T_ = ' ' AND  "
	cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND  "
	cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + "  ) = SEH.EH_REVISAO "
	cQuery += " WHERE "

	If cTpSE5 == "C" 
		cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
	Else
		cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
	Endif 	

	cQuery += " E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
	cQuery += " E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
	cQuery += " E5_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
	cQuery += " E5_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
	cQuery += " E5_SITUACA <> 'C' AND "
	cQuery += " E5_TIPODOC = 'AP' AND  "
	cQuery += " E5_FORNECE = '" + cCliVazio	+ "' AND "

	If lFinc24
		Iif (!Empty(aPerguntes[1]),cQuery += " E5_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
	EndIf
	
	cQuery += " SEH.D_E_L_E_T_ = ' ' "
	
	If lPrjCni
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_MOEDA, E5_RECPAG, E5_RECPAG, E5_VLMOED2, E5_VALOR "
 	Else
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, EH_MOEDA, E5_MOEDA, E5_TXMOEDA, E5_RECPAG, E5_VLMOED2, E5_VALOR "
	EndIf

	cQuery += " UNION ALL "

	If lPrjCni

		//Baixas por Empréstimos
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC,  E5_RECPAG, E5_MOEDA MOEDA, 'R' CARTEIRA, "
		cQuery += " SUM(E5_VLMOED2) NVALOR, SUM(E5_VALOR) NVLCRUZ  "
		cQuery += " FROM " + RetSQLTab('SE5') + " "
		cQuery += " INNER JOIN " + RetSqlTab("SEH") + " ON SEH.D_E_L_E_T_ = ' ' AND " + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND "
		cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO "
		
		cQuery += " WHERE "
		
		If cTpSE5 == "C" 
			cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
		Else
			cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
		Endif 	
		
		cQuery += " E5_DATA    >='" + DTOS(mv_par04) + "' AND "
		cQuery += " E5_DATA    <='" + DTOS(mv_par05) + "' AND "
		cQuery += " E5_NATUREZ >='" + mv_par06		 + "' AND "
		cQuery += " E5_NATUREZ <='" + mv_par07		 + "' AND "
		cQuery += " E5_SITUACA <> 'C'  AND "
		cQuery += " E5_TIPODOC  = 'EP' AND "
		cQuery += " E5_FORNECE	= '" + cCliVazio + "' AND "
		cQuery += " SE5.D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA "

	   	cQuery += " UNION ALL "

		//Baixas por Pagamentos de Empréstimos
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, 'P' CARTEIRA, "
		cQuery += " SUM(E5_VLMOED2) NVALOR, SUM(E5_VALOR) NVLCRUZ  "
		cQuery += " FROM " + RetSQLTab('SE5') + " "
		cQuery += " INNER JOIN " + RetSqlTab("SEH") + " ON SEH.D_E_L_E_T_ = ' ' AND " + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND "
		cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO "
		cQuery += " INNER JOIN " + RetSqlTab("SEI") + " ON SEI.D_E_L_E_T_ = ' ' AND SEH.EH_NUMERO = SEI.EI_NUMERO AND SEH.EH_REVISAO = SEI.EI_REVISAO AND SEI.EI_STATUS != 'C' AND SEI.EI_TIPODOC = 'VL' "
		
		cQuery += " WHERE "

		If cTpSE5 == "C" 
			cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
		Else
			cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
		Endif 	

		cQuery += " E5_DATA    >= '" + DTOS(mv_par04) + "' AND "
		cQuery += " E5_DATA    <= '" + DTOS(mv_par05) + "' AND "
		cQuery += " E5_NATUREZ >= '" + mv_par06 + "' AND "
		cQuery += " E5_NATUREZ <= '" + mv_par07 + "' AND "
		cQuery += " E5_SITUACA <> 'C'  AND "
		cQuery += " E5_TIPODOC  = 'PG' AND "
		cQuery += " E5_FORNECE  = '" + cCliVazio + "' AND "
		cQuery += " SE5.D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA "
	
		cQuery += " UNION ALL "

		//Baixas por Resgate de Aplicações Financeiras
		cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, "
		cQuery += " SUM(E5_VLMOED2) NVALOR, SUM(E5_VALOR) NVLCRUZ  "
		cQuery += " FROM " + RetSQLTab('SE5') + " "
		cQuery += " INNER JOIN " + RetSqlTab("SEH") + " ON SEH.D_E_L_E_T_ = ' ' AND " + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND "
		cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO "
		cQuery += " INNER JOIN " + RetSqlTab("SEI") + " ON SEI.D_E_L_E_T_ = ' ' AND SEH.EH_NUMERO = SEI.EI_NUMERO AND SEH.EH_REVISAO = SEI.EI_REVISAO AND SEI.EI_STATUS != 'C' AND SEI.EI_TIPODOC IN ('RG') "
		cQuery += " WHERE "
		
		If cTpSE5 == "C" 
			cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
		Else
			cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
		Endif 	
		
		cQuery += " E5_DATA    >='" + DTOS(mv_par04) + "' AND "
		cQuery += " E5_DATA    <='" + DTOS(mv_par05) + "' AND "
		cQuery += " E5_NATUREZ >='" + mv_par06	  + "' AND "
		cQuery += " E5_NATUREZ <='" + mv_par07	  + "' AND "
		cQuery += " E5_SITUACA <> 'C'  AND "
		cQuery += " E5_TIPODOC  = 'RF' AND "
		cQuery += " E5_FORNECE	= '" + cCliVazio + "' AND "
		cQuery += " SE5.D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA "

	Else
	
		//Baixas por Resgate de Aplicações Financeiras
		cQuery += "	SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, EH_MOEDA MOEDA, E5_MOEDA MOEDABX, E5_RECPAG CARTEIRA, E5_TXMOEDA TXMOEDA, SUM(0) ABATI "

		If lFinc24
			cQuery += " , ' ' RISCO "
		EndIf

		cQuery += " , E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ "
		cQuery += " FROM  " + RetSQLTab('SEH') + " "
		cQuery += " INNER JOIN  "
		cQuery += "	" + RetSQLTab('SEI') + " ON SEI.D_E_L_E_T_ = ' ' AND  "
		cQuery += "	SEH.EH_NUMERO  = SEI.EI_NUMERO AND "
		cQuery += "	SEH.EH_REVISAO = SEI.EI_REVISAO AND  "
		cQuery += "	SEI.EI_STATUS <> 'C' AND "
		cQuery += "	SEI.EI_TIPODOC IN ('VL') "
		cQuery += " INNER JOIN  "
		cQuery += "	" + RetSQLTab('SE5') + "  ON SE5.D_E_L_E_T_ = ' ' AND  "
		cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND  "
		cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + "  ) = SEH.EH_REVISAO AND "
		cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + TamSX3("EH_REVISAO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EI_SEQ")[1]) + "  ) = SEI.EI_SEQ "
		cQuery += " WHERE "
		cQuery += "	EI_DTDIGIT >='" +	If(lFinc24,DTOS(aPerguntes[2])  ,DTOS(mv_par04))	+ "' AND "
		cQuery += "	EI_DTDIGIT <='" +	If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05))	+ "' AND "
		cQuery += "	EI_NATUREZ >='" +	If(lFinc24,aPerguntes[4],mv_par06)			+ "' AND "
		cQuery += "	EI_NATUREZ <='" +	If(lFinc24,aPerguntes[5],mv_par07)		+ "' AND "
		cQuery += "	EI_STATUS <> 'C' AND "
		cQuery += "	E5_TIPODOC = 'RF' AND  "
		cQuery += " E5_FORNECE	= '" + cCliVazio	+"' AND "

		If lFinc24
			Iif (!Empty(aPerguntes[1]), cQuery += " E5_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
		EndIf
		
		cQuery += " SEI.D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY "
		cQuery += "	E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, EH_MOEDA, E5_MOEDA, E5_RECPAG, E5_TXMOEDA, E5_VLMOED2, E5_VALOR "

		cQuery += " UNION ALL "

		//Movimentos de Caixa (Pagar/Receber)
		cQuery += "	SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, " + If(lOrcaleDb2, "CAST('01' AS FLOAT) ", "'01' ") + " MOEDA, '01' MOEDABX, E5_RECPAG CARTEIRA, E5_TXMOEDA TXMOEDA, SUM(0) ABATI "
		
		If lFinc24
			cQuery += " , ' ' RISCO "
		EndIf
		
		cQuery += " , SUM(E5_VALOR) NVALOR, SUM(E5_VLMOED2) NVLCRUZ "
		cQuery += " FROM  " + RetSQLTab('SE5') + " "
		cQuery += " WHERE "
		
		If cTpSE5 == "C" 
			cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
		Else
			cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
		Endif 
		
		cQuery += "	E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
		cQuery += "	E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
		cQuery += "	E5_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
		cQuery += "	E5_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
		cQuery += "	E5_TIPODOC = '" + Space( TamSX3('E5_TIPODOC')[1] )   + "' AND "
		cQuery += " E5_SITUACA <> 'C' AND "
		
		If lFinc24
			Iif (!Empty(aPerguntes[1]), cQuery += " E5_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
		EndIf
		
		cQuery += " SE5.D_E_L_E_T_ = ' ' "
		cQuery += " GROUP BY "
		cQuery += "	E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_RECPAG, E5_TXMOEDA, E5_VALOR, E5_VLMOED2 "
	
	EndIf
	
	//Movimentos gerados via CNAB - Despesas Bancarias / Outras Despesas / Outros Creditos
	cQuery += " UNION ALL "
	
    If lPrjCni
        cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, " + If(lOrcaleDb2, "CAST('01' AS FLOAT) ", "'01' ") + " E5_TIPODOC, E5_RECPAG, E5_TXMOEDA TXMOEDA,E5_RECPAG CARTEIRA,SUM(0) ABATI, SUM(E5_VALOR) NVALOR FROM  " + RetSQLTab('SE5') + " "
    Else 
        cQuery += " SELECT E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, " + If(lOrcaleDb2, "CAST('01' AS FLOAT) ", "'01' ") + " MOEDA, '01' MOEDABX, E5_RECPAG CARTEIRA, E5_TXMOEDA TXMOEDA, SUM(0) ABATI"
        If lFinc24
        	cQuery += ", ' ' RISCO "
        EndIf
		cQuery += " , SUM(E5_VALOR) NVALOR, SUM(E5_VLMOED2) NVLCRUZ "
        cQuery += " FROM  " + RetSQLTab('SE5') + " "
    EndIf
	
	cQuery += " WHERE "
	
	If cTpSE5 == "C" 
		cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
	Else
		cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
	Endif 	
	cQuery += "	E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
	cQuery += "	E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
	cQuery += "	E5_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
	cQuery += "	E5_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
	cQuery += "	E5_TIPODOC IN ('DB','OD') AND  "
	cQuery += " E5_MOTBX = 'NOR'	AND "
	cQuery += " E5_SITUACA <> 'C'	AND "
	cQuery += " SE5.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY "

	If lPrjCni
    	cQuery += " E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO,  E5_TIPODOC, E5_RECPAG, E5_TXMOEDA "
    Else 
		cQuery += " E5_FILORIG, E5_FILIAL, E5_NATUREZ, E5_DATA, E5_TIPO, E5_RECPAG, E5_TXMOEDA, E5_VLMOED2, E5_VALOR "
    Endif
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "E5_DATA" , "D")
	DbGotop()
	If !EOF() .AND. !BOF()
		While !(cAliasQry)->(Eof())

			If oSelf <> nil
				oSelf:IncRegua2(STR0015) //"Atualizando saldos Realizados das naturezas..."
			EndIf

			//Movimento de adiantamento no SE5 DEVE ser desconsiderado
			//Foram realizados na emissao
			If (cAliasQry)->E5_TIPO $ MV_CRNEG+"/"+MV_CPNEG
				(cAliasQry)->(dbSkip())
				Loop
			Endif

			//Atualizo o valor atual para o saldo da natureza
			If lPrjCni
				AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
						 	(cAliasQry)->E5_DATA,;
						 	(cAliasQry)->MOEDA,;
							"3",;
							(cAliasQry)->CARTEIRA,;
							(cAliasQry)->NVALOR,;
							(cAliasQry)->NVLCRUZ,;
							"+",;
							"D",;
							FunName(),;
							"SE5",;
							,;
							,;
							(cAliasQry)->E5_TIPODOC,;
						    0,;
						    (cAliasQry)->E5_FILORIG)
			Else
				If AllTrim((cAliasQry)->E5_TIPO) $ MVABATIM 

					If lFinc24
						FC24SldNat(cAliasQry, 'SE5', (cAliasQry)->CARTEIRA, "-")
					Else
						AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
							 		(cAliasQry)->E5_DATA,;
							 		(cAliasQry)->MOEDA,;
								"3",;
									(cAliasQry)->CARTEIRA,;
									(cAliasQry)->NVALOR,;
									(cAliasQry)->NVLCRUZ,;
									"-",;
									"D",;
									FunName(),;
									,;
									0,;
									"",;
									"",;
									0,;
									(cAliasQry)->E5_FILORIG)
					EndIf
				Else

					If	!lPrjCni .and. (cAliasQry)->MOEDA <> 1 .and. ((cAliasQry)->MOEDA == If(lOrcaleDb2, VAL((cAliasQry)->MOEDABX), (cAliasQry)->MOEDABX)) 
						nValForeing := Round(NoRound(xMoeda((cAliasQry)->NVLCRUZ, If(lOrcaleDb2, VAL((cAliasQry)->MOEDABX), (cAliasQry)->MOEDABX),1,(cAliasQry)->E5_DATA,3,(cAliasQry)->TXMOEDA),3),2)
					Else
						nValForeing := (cAliasQry)->NVLCRUZ
					EndIf
														
					If lFinc24
						FC24SldNat(cAliasQry, 'SE5', (cAliasQry)->CARTEIRA, "+")
					Else
						AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
							 		(cAliasQry)->E5_DATA,;
							 		(cAliasQry)->MOEDA,;
							 		"3",;
							 		(cAliasQry)->CARTEIRA,;
							 		(cAliasQry)->NVALOR,;
							 		nValForeing,;
							 		"+",;
							 		"D",;
							 		FunName(),;
							 		,;
							 		,;
							 		,;
							 		,;
							 		(cAliasQry)->ABATI,;
							 		(cAliasQry)->E5_FILORIG)
					EndIf
				Endif
			EndIf
			
			dbSelectArea(cAliasQry)
			dbSkip()

		EndDo
	EndIf

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE5")

Endif

RestArea(aArea)

Return .T.

/*/{Protheus.doc} F800SRMOV
Reprocessa Saldos Realizados - Movimentos Bancários Manuais

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function F800SRMOV(oSelf ,nInc, aPerguntes)
Local aArea			:= GetArea()
Local cQuery		:= ""
Local cFilSE5       := ""
Local cTpSE5        := GetTpShare("SE5",mcFIL)  
Local cAliasQry		:= "TRB800K"
Local cCliVazio		:= Space(TamSx3("E5_CLIFOR")[1])
Local cLoteVazio	:= Space(TamSx3("E5_LOTE")[1])
Local lPrjCni		:= ValidaCNI()
Local lFinc24		:= IsIncallStack("FINC024")
Local lProcessa		:= .F. 

DEFAULT oSelf		:= NIL
Default aPerguntes	:= {}

If lFinc24
	lProcessa := .T.
	cFilSE5 := xFilial("SE5")
ElseIf cTpSE5 == "C" 
	If nInc = 1
		lProcessa := .T.
		cFilSE5   := xFilial("SE5")
	EndIf
Else
	lProcessa := .T.
	cFilSE5   := cFilAnt
EndIf

dbSelectArea("SE5")
dbSetOrder(1)

If oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

If lProcessa

	cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_RECPAG CARTEIRA, A6_MOEDA MOEDA, "
	cQuery += " SUM(E5_VALOR) NVALOR, SUM(E5_VLMOED2) NVLCRUZ  "

	If lFinc24
		cQuery += " ,COALESCE(A1_RISCO,' ') RISCO "
	EndIf

	cQuery += " FROM " + RetSQLTab('SE5')
	cQuery += " JOIN " + RetSQLTab('SA6')
	cQuery += "  ON  SE5.E5_BANCO   = SA6.A6_COD AND "
	cQuery += "      SE5.E5_AGENCIA = SA6.A6_AGENCIA AND "
	cQuery += "      SE5.E5_CONTA   = SA6.A6_NUMCON "

	//Compara o modo de compartilhamento de SA6 e SE5. Se ambas forem Exclusivas - considera-se a filial
	If (GetTpShare("SA6",mcFIL) + GetTpShare("SE5",mcFIL)) $ "EE"
		cQuery += " AND SE5.E5_FILIAL  = SA6.A6_FILIAL "
	Endif
	
	If lFinc24
		cQuery += " LEFT JOIN " + RetSQLTab('SA1') +" ON E5_CLIFOR = A1_COD AND E5_RECPAG = 'R' "
		cQuery += " AND A1_RISCO >= '" + aPerguntes[6] + "' "
		cQuery += " AND A1_RISCO <= '" + aPerguntes[7] + "' "
	EndIf

	cQuery += " WHERE "

	cQuery += " E5_FILIAL    = '" + cFilSE5 + "' AND "
	cQuery += " E5_DATA     >= '" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
	cQuery += " E5_DATA     <= '" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
	cQuery += " E5_NATUREZ  >= '" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
	cQuery += " E5_NATUREZ  <= '" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
	cQuery += " E5_SITUACA	<> 'C' AND "
	cQuery += " E5_SITUACA	<> 'X' AND "
	cQuery += " E5_SITUACA	<> 'E' AND "
	cQuery += " E5_MULTNAT	 = ' ' AND "
	cQuery += " E5_CLIFOR	 = '" + cCliVazio		+ "' AND "
	cQuery += " E5_LOTE		 = '" + cLoteVazio		+ "' AND "
	cQuery += " E5_TIPODOC NOT IN ('AP','EP','RF','PE','" + Space( TamSX3('E5_TIPODOC')[1] )  + "' ) AND "
	cQuery += " NOT EXISTS("
	cQuery += " SELECT COUNT(E5_NUMCHEQ) "
	cQuery += " FROM " + RetSQLName('SE5') + " E5 "
	cQuery += " WHERE E5.E5_FILIAL = SE5.E5_FILIAL "
	cQuery += " AND E5.E5_BANCO = SE5.E5_BANCO "
	cQuery += " AND E5.E5_AGENCIA = SE5.E5_AGENCIA "
	cQuery += " AND E5.E5_CONTA = SE5.E5_CONTA "
	cQuery += " AND E5.E5_DTDISPO = SE5.E5_DTDISPO "
	cQuery += " AND E5.E5_NUMCHEQ = SE5.E5_NUMCHEQ "
	cQuery += " AND E5.R_E_C_N_O_ <> SE5.R_E_C_N_O_) AND "

	If lFinc24
		Iif(!Empty(aPerguntes[1]), cQuery += " E5_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
	EndIf
	
	cQuery += " SE5.D_E_L_E_T_ = ' ' AND "
	cQuery += " SA6.D_E_L_E_T_ = ' '"
	cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_RECPAG, A6_MOEDA "
	
	If lFinc24
		cQuery += " , A1_RISCO "
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "E5_DATA" , "D")

	dbSelectArea(cAliasQry)
	DbGotop()
	If !EOF() .AND. !BOF()
		While !(cAliasQry)->(Eof())

			If oSelf <> nil
				oSelf:IncRegua2(STR0015) //"Atualizando saldos Realizados das naturezas..."
			EndIf

			//Atualizo o valor atual para o saldo da natureza
			If lPrjCni
				AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
							 	(cAliasQry)->E5_DATA,;
							 	(cAliasQry)->MOEDA,;
								"3",;
								(cAliasQry)->CARTEIRA,;
								(cAliasQry)->NVALOR,;
								(cAliasQry)->NVLCRUZ,;
								"+",;
								"D",;
								FunName(),;
								"SE5",;
								0,;
								"",;
								"",;
								0,;
								cFilAnt)
			Else

				If lFinc24
					If (cAliasQry)->CARTEIRA == 'P' .OR. ((cAliasQry)->CARTEIRA == 'R' .AND. !Empty((cAliasQry)->RISCO))
						FC24SldNat(cAliasQry, 'SE5', (cAliasQry)->CARTEIRA, "+")
					EndIf
				Else
					AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
							 	(cAliasQry)->E5_DATA,;
							 	(cAliasQry)->MOEDA,;
								"3",;
								(cAliasQry)->CARTEIRA,;
								(cAliasQry)->NVALOR,;
								(cAliasQry)->NVLCRUZ,;
								"+",;
								"D",;
								FunName(),;
								,;
								,;
								,;
								,;
								(cAliasQry)->ABATI,;
								cFilAnt)
				EndIf
			EndIf
			dbSelectArea(cAliasQry)
			dbSkip()

		EndDo
	Endif

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())
	dbSelectArea("SE5")

Endif

RestArea(aArea)

Return .T.

/*/{Protheus.doc} F800SRSEV
Reprocessa Saldos Realizados - MultiNaturezas

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function F800SRSEV(oSelf ,nInc,aPerguntes)
Local aArea			:= GetArea()
Local cQuery		:= ""
Local cTpSEV        := GetTpShare("SEV",mcFIL)
Local cTpSE5        := GetTpShare("SE5",mcFIL)
Local cTpEVE1       := cTpSEV + GetTpShare("SE1",mcFIL)
Local cTpEVE2       := cTpSEV + GetTpShare("SE2",mcFIL)
Local cTpEVE5       := cTpSEV + cTpSE5
Local cAliasQry		:= "TRB800H"
Local lPrjCni		:= ValidaCNI()
Local lFinc24		:= IsIncallStack("FINC024")
Local lProcessa     := .F.

Default aPerguntes	:= {}
DEFAULT oSelf		:= NIL

dbSelectArea("SEV")
dbSetOrder(2)

If oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

// Registro de Baixa 
cQuery := " SELECT EV_NATUREZ, E5_DATA EV_VENCREA, EV_TIPO, E1_MOEDA MOEDA, EV_IDENT IDENT, 'R' CARTEIRA, "
cQuery += " SUM(EV_VALOR) NVALOR, SUM(E5_VALOR * EV_PERC) NVLCRUZ "
cQuery += " FROM " + RetSQLTab('SEV')

cQuery += " JOIN " + RetSQLTab('SE5') + " ON "

If cTpEVE5 == "EE"
	cQuery += " SEV.EV_FILIAL = SE5.E5_FILIAL AND "
ElseIf cTpEVE5 == "EC"
	cQuery += " SEV.EV_FILIAL = SE5.E5_FILORIG AND "
EndIf

cQuery += " SEV.EV_PREFIXO = SE5.E5_PREFIXO AND "
cQuery += " SEV.EV_NUM	   = SE5.E5_NUMERO AND "
cQuery += " SEV.EV_PARCELA = SE5.E5_PARCELA AND "
cQuery += " SEV.EV_TIPO	   = SE5.E5_TIPO AND "
cQuery += " SEV.EV_CLIFOR  = SE5.E5_CLIENTE AND "
cQuery += " SEV.EV_LOJA    = SE5.E5_LOJA AND "
cQuery += " SE5.E5_MULTNAT = '1' AND "
cQuery += " SE5.E5_RECPAG  = 'R' "	// Baixa a receber

cQuery += " JOIN " + RetSQLTab('SE1') + " ON "

If cTpEVE1 == "EE"
	cQuery += " SEV.EV_FILIAL = SE1.E1_FILIAL AND "
ElseIf cTpEVE1 == "EC"
	cQuery += " SEV.EV_FILIAL = SE1.E1_FILORIG AND "
EndIf

cQuery += " SEV.EV_PREFIXO = SE1.E1_PREFIXO AND "
cQuery += " SEV.EV_NUM	   = SE1.E1_NUM AND "
cQuery += " SEV.EV_PARCELA = SE1.E1_PARCELA AND "
cQuery += " SEV.EV_TIPO	   = SE1.E1_TIPO AND "
cQuery += " SEV.EV_CLIFOR  = SE1.E1_CLIENTE AND "
cQuery += " SEV.EV_LOJA	   = SE1.E1_LOJA "
	
cQuery += " WHERE "

If cTpSE5 == "C"
	cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
Else
	cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
Endif

cQuery += " E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
cQuery += " E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
cQuery += " EV_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
cQuery += " EV_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "	
cQuery += " EV_IDENT	= '2' AND "	// 1 - Rateio na Inclusão ; 2 - Rateio na Baixa 
cQuery += " EV_RECPAG	= 'R' AND "	// 
cQuery += " EV_SITUACA  = ' ' AND "

If lFinc24
	cQuery +=  "EV_RATEICC = '2' AND " //Rateio por centro de custo é filtrado na função F800SRSEZ
	Iif(!Empty(aPerguntes[1]),cQuery += "E1_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
EndIf

cQuery += " SEV.D_E_L_E_T_ = ' ' AND "
cQuery += " SE1.D_E_L_E_T_ = ' ' AND "
cQuery += " SE5.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY EV_NATUREZ, E5_DATA, EV_TIPO, E1_MOEDA, EV_IDENT "

cQuery += " UNION ALL "

// Registro de Estorno de Baixa a Receber
cQuery += " SELECT EV_NATUREZ, E5_DATA EV_VENCREA, EV_TIPO, E1_MOEDA MOEDA, EV_IDENT IDENT, 'R' CARTEIRA, "
cQuery += " SUM(EV_VALOR) * (-1) NVALOR, SUM(E5_VALOR * EV_PERC) * (-1) NVLCRUZ "
cQuery += " FROM " + RetSQLTab('SEV')

cQuery += " JOIN " + RetSQLTab('SE5') + " ON "

If cTpEVE5 == "EE"
	cQuery += " SEV.EV_FILIAL = SE5.E5_FILIAL AND "
ElseIf cTpEVE5 == "EC"
	cQuery += " SEV.EV_FILIAL = SE5.E5_FILORIG AND "
EndIf

cQuery += " SEV.EV_PREFIXO = SE5.E5_PREFIXO AND "
cQuery += " SEV.EV_NUM	   = SE5.E5_NUMERO AND "
cQuery += " SEV.EV_PARCELA = SE5.E5_PARCELA AND "
cQuery += " SEV.EV_TIPO	   = SE5.E5_TIPO AND "
cQuery += " SEV.EV_CLIFOR  = SE5.E5_CLIENTE AND "
cQuery += " SEV.EV_LOJA    = SE5.E5_LOJA AND "
cQuery += " SE5.E5_MULTNAT = '1' AND "
cQuery += " SE5.E5_RECPAG  = 'P' "	// Estorno de Baixa a Receber

cQuery += " JOIN " + RetSQLTab('SE1') + " ON "

If cTpEVE1 == "EE"
	cQuery += " SEV.EV_FILIAL = SE1.E1_FILIAL AND "
ElseIf cTpEVE1 == "EC"
	cQuery += " SEV.EV_FILIAL = SE1.E1_FILORIG AND "
EndIf

cQuery += " SEV.EV_PREFIXO = SE1.E1_PREFIXO AND "
cQuery += " SEV.EV_NUM	   = SE1.E1_NUM AND "
cQuery += " SEV.EV_PARCELA = SE1.E1_PARCELA AND "
cQuery += " SEV.EV_TIPO	   = SE1.E1_TIPO AND "
cQuery += " SEV.EV_CLIFOR  = SE1.E1_CLIENTE AND "
cQuery += " SEV.EV_LOJA    = SE1.E1_LOJA "

cQuery += " WHERE "

If cTpSE5 == "C"
	cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
Else
	cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
Endif

cQuery += " E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
cQuery += " E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
cQuery += " EV_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
cQuery += " EV_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
cQuery += " EV_IDENT	= '2' AND "	// 1 - Rateio na Inclusão ; 2 - Rateio na Baixa
cQuery += " EV_RECPAG	= 'R' AND "
cQuery += " EV_SITUACA  = ' ' AND "

If lFinc24
	cQuery += " EV_RATEICC = '2' AND " //Rateio por centro de custo é filtrado na função F800SRSEZ
	If (!Empty(aPerguntes[1]),cQuery += "E1_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
EndIf
	
cQuery += " SEV.D_E_L_E_T_ = ' ' AND "
cQuery += " SE1.D_E_L_E_T_ = ' ' AND "
cQuery += " SE5.D_E_L_E_T_ = ' '     "
cQuery += " GROUP BY EV_NATUREZ, E5_DATA, EV_TIPO, E1_MOEDA, EV_IDENT "

cQuery += " UNION ALL "

cQuery += " SELECT EV_NATUREZ, E5_DATA EV_VENCREA, EV_TIPO, E2_MOEDA MOEDA, EV_IDENT IDENT, 'P' CARTEIRA, "
cQuery += " SUM(EV_VALOR) NVALOR, SUM(E5_VALOR * EV_PERC) NVLCRUZ "
cQuery += " FROM " + RetSQLTab('SEV')

cQuery += " JOIN " + RetSQLTab('SE5') + " ON "

If cTpEVE5 == "EE" 
	cQuery += " SEV.EV_FILIAL = SE5.E5_FILIAL AND "
ElseIf cTpEVE5 == "EC"
	cQuery += " SEV.EV_FILIAL = SE5.E5_FILORIG AND "
EndIf

cQuery += " SEV.EV_PREFIXO = SE5.E5_PREFIXO AND "
cQuery += " SEV.EV_NUM	   = SE5.E5_NUMERO AND "
cQuery += " SEV.EV_PARCELA = SE5.E5_PARCELA AND "
cQuery += " SEV.EV_TIPO	   = SE5.E5_TIPO AND "
cQuery += " SEV.EV_CLIFOR  = SE5.E5_FORNECE AND "
cQuery += " SEV.EV_LOJA    = SE5.E5_LOJA AND "
cQuery += " SE5.E5_MULTNAT = '1' AND "
cQuery += " SE5.E5_RECPAG  = 'P' "

cQuery += " JOIN " + RetSQLTab('SE2') + " ON "

If cTpEVE2 == "EE"
	cQuery += " SEV.EV_FILIAL = SE2.E2_FILIAL AND "
ElseIf cTpEVE2 == "EC"
	cQuery += " SEV.EV_FILIAL = SE2.E2_FILORIG AND "
EndIf

cQuery += " SEV.EV_PREFIXO = SE2.E2_PREFIXO AND "
cQuery += " SEV.EV_NUM	   = SE2.E2_NUM AND "
cQuery += " SEV.EV_PARCELA = SE2.E2_PARCELA AND "
cQuery += " SEV.EV_TIPO	   = SE2.E2_TIPO AND "
cQuery += " SEV.EV_CLIFOR  = SE2.E2_FORNECE AND "
cQuery += " SEV.EV_LOJA	   = SE2.E2_LOJA "

cQuery += " WHERE "

If cTpSE5 == "C"
	cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
Else
	cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
Endif
	
cQuery += " E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
cQuery += " E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
cQuery += " EV_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
cQuery += " EV_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
cQuery += " EV_IDENT	= '2' AND "	// 1 - Rateio na Inclusão ; 2 - Rateio na Baixa
cQuery += " EV_RECPAG	= 'P' AND "
cQuery += " EV_SITUACA  = ' ' AND "

If lFinc24
	cQuery += " EV_RATEICC = '2' AND "  //Rateio por centro de custo é filtrada na função F800SRSEZ
	If(!Empty(aPerguntes[1]), cQuery += " E2_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
EndIf
	
cQuery += " SEV.D_E_L_E_T_ = ' ' AND "
cQuery += " SE2.D_E_L_E_T_ = ' ' AND "
cQuery += " SE5.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY EV_NATUREZ, E5_DATA, EV_TIPO, E2_MOEDA, EV_IDENT "

cQuery += " UNION ALL "

cQuery += " SELECT EV_NATUREZ, E5_DATA EV_VENCREA, EV_TIPO, E2_MOEDA MOEDA, EV_IDENT IDENT, 'P' CARTEIRA, "
cQuery += " SUM(EV_VALOR) * (-1) NVALOR, SUM(E5_VALOR * EV_PERC) * (-1) NVLCRUZ "
cQuery += " FROM " + RetSQLTab('SEV')

cQuery += " JOIN " + RetSQLTab('SE5') + " ON "

If cTpEVE5 == "EE"
	cQuery += " SEV.EV_FILIAL = SE5.E5_FILIAL AND "
ElseIf cTpEVE5 == "EC"
	cQuery += " SEV.EV_FILIAL = SE5.E5_FILORIG AND "
EndIf	
	
cQuery += " SEV.EV_PREFIXO = SE5.E5_PREFIXO AND "
cQuery += " SEV.EV_NUM	   = SE5.E5_NUMERO AND "
cQuery += " SEV.EV_PARCELA = SE5.E5_PARCELA AND "
cQuery += " SEV.EV_TIPO	   = SE5.E5_TIPO AND "
cQuery += " SEV.EV_CLIFOR  = SE5.E5_FORNECE AND "
cQuery += " SEV.EV_LOJA    = SE5.E5_LOJA AND "
cQuery += " SE5.E5_MULTNAT = '1' AND "
cQuery += " SE5.E5_RECPAG  = 'R' "

cQuery += " JOIN " + RetSQLTab('SE2') + " ON "

If cTpEVE2 == "EE"
	cQuery += " SEV.EV_FILIAL = SE2.E2_FILIAL AND "
ElseIf cTpEVE2 == "EC"
	cQuery += " SEV.EV_FILIAL = SE2.E2_FILORIG AND "
EndIf

cQuery += " SEV.EV_PREFIXO = SE2.E2_PREFIXO AND "
cQuery += " SEV.EV_NUM	   = SE2.E2_NUM AND "
cQuery += " SEV.EV_PARCELA = SE2.E2_PARCELA AND "
cQuery += " SEV.EV_TIPO	   = SE2.E2_TIPO AND "
cQuery += " SEV.EV_CLIFOR  = SE2.E2_FORNECE AND "
cQuery += " SEV.EV_LOJA	   = SE2.E2_LOJA "

cQuery += " WHERE "

If cTpSE5 == "C"
	cQuery += " E5_FILORIG = '" + cFilAnt + "' AND "
Else
	cQuery += " E5_FILIAL  = '" + cFilAnt + "' AND "
Endif

cQuery += " E5_DATA    >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
cQuery += " E5_DATA    <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
cQuery += " EV_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
cQuery += " EV_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
cQuery += " EV_IDENT	= '2' AND "	// 1 - Rateio na Inclusão ; 2 - Rateio na Baixa
cQuery += " EV_RECPAG	= 'P' AND "
cQuery += " EV_SITUACA  = ' ' AND "

If lFinc24
	cQuery += " EV_RATEICC = '2' AND "  //Rateio por centro de custo é filtrada na função F800SRSEZ
	If(!Empty(aPerguntes[1]), cQuery += " E2_CCUSTO IN (" + aPerguntes[1] + ") AND ", Nil)
EndIf
	
cQuery += " SEV.D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY EV_NATUREZ, E5_DATA, EV_TIPO, E2_MOEDA, EV_IDENT "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
TcSetField(cAliasQry, "EV_VENCREA" , "D")

dbSelectArea(cAliasQry)
DbGotop()
If !EOF() .AND. !BOF()
	While !(cAliasQry)->(Eof())

		If oSelf <> nil
			oSelf:IncRegua2(STR0014) //"Atualizando Saldos Previstos Multinaturezas..."
		EndIf

		//Atualizo o valor atual para o saldo da natureza
		If lFinc24
			FC24SldNat(cAliasQry, 'SEV', (cAliasQry)->CARTEIRA, If((cAliasQry)->EV_TIPO $ MVABATIM,"-","+"))
		ElseIf lPrjCni
			AtuSldNat(	(cAliasQry)->EV_NATUREZ,;
					 	(cAliasQry)->EV_VENCREA,;
					 	(cAliasQry)->MOEDA,;
						If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"2","3"),;
						(cAliasQry)->CARTEIRA,;
						(cAliasQry)->NVALOR,;
						(cAliasQry)->NVLCRUZ,;
						If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"-","+"),;
						"D",;
						FunName(),;
						,;
						0,;
						"",;
						"",;
						0,;
						cFilAnt)
		Else
			AtuSldNat(	(cAliasQry)->EV_NATUREZ,;
					 	(cAliasQry)->EV_VENCREA,;
					 	(cAliasQry)->MOEDA,;
						If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"2","3"),;
						(cAliasQry)->CARTEIRA,;
						(cAliasQry)->NVALOR,;
						(cAliasQry)->NVLCRUZ,;
						If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"-","+"),;
						"D",;
						FunName(),;
						,;
						0,;
						"",;
						"",;
						0,;
						cFilAnt,;
						.T.)
		EndIf

		dbSelectArea(cAliasQry)
		dbSkip()

	EndDo
Endif

dbSelectArea(cAliasQry)
dbCloseArea()
fErase(cAliasQry + OrdBagExt())
fErase(cAliasQry + GetDbExtension())

dbSelectArea("SE1")

RestArea(aArea)

Return .T.

/*/{Protheus.doc} F800SNMES
Reprocessa Saldos Previstos - Receber

@Author Mauricio Pequim Jr.
@Since 25/05/2010
@Param oSelf
@Param nInc
@Version 11.80
@Return .T.
/*/
Static Function F800SNMES(oSelf ,nInc,cTpSEV)		
Local aArea		:= GetArea()
Local cQuery	:= ""
Local cFilFIV   := ""
Local cAliasQry	:= "TRB800H"
Local cDataDe	:= DTOS(FirstDay(mv_par04))
Local cDataAte	:= DTOS(LastDay(mv_par05))
Local lPrjCni	:= ValidaCNI()

DEFAULT oSelf := NIL

If cTpSEV == "C" 
	cFilFIV   := xFilial("FIV")
Else
	cFilFIV   := cFilAnt
EndIf

If oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

dbSelectArea("FIV")
dbSetOrder(1)

cQuery := " SELECT FIV_FILIAL, FIV_NATUR,FIV_MOEDA, FIV_TPSALD, FIV_CARTEI, FIV_DATA, FIV_VALOR, FIV_ABATI"
cQuery += " FROM " + RetSQLTab('FIV')
cQuery += " WHERE "
cQuery += " FIV_FILIAL = '" + cFilFIV  + "' AND "
cQuery += " FIV_NATUR >= '" + mv_par06 + "' AND "
cQuery += " FIV_NATUR <= '" + mv_par07 + "' AND "

Do Case
//Todos ou Orcado
Case mv_par08 == 1 .OR. mv_par08 == 2
	cQuery += " FIV_TPSALD <> '1' AND "
	cQuery += " FIV_DATA >= '" + cDataDe + "' AND FIV_DATA <= '" + cDataAte + "' AND "
//Previsto
Case mv_par08 == 3
	cQuery += " FIV_TPSALD = '2' AND "
	cQuery += " FIV_DATA  >= '" + cDataDe + "' AND FIV_DATA    <= '" + cDataAte + "' AND "		
//Realizado
Case mv_par08 == 4
	cQuery += " FIV_TPSALD = '3' AND "
	cQuery += " FIV_DATA  >= '" + cDataDe + "' AND FIV_DATA    <= '" + cDataAte + "' AND "		
EndCase

cQuery += " FIV.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY FIV_FILIAL,FIV_DATA,FIV_NATUR,FIV_MOEDA,FIV_TPSALD,FIV_CARTEI "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
TcSetField(cAliasQry, "FIV_DATA" , "D")

dbSelectArea(cAliasQry)
DbGotop()
If !EOF() .AND. !BOF()
	While !(cAliasQry)->(Eof())

		If oSelf <> nil
			oSelf:IncRegua2(STR0012) //"Atualizando saldos Previstos CR das naturezas..."
		EndIf

		//Atualizo o valor atual para o saldo da natureza 
		If lPrjCni
			AtuSldNat(	(cAliasQry)->FIV_NATUR ,;
					 	(cAliasQry)->FIV_DATA ,;
					 	(cAliasQry)->FIV_MOEDA ,;
						(cAliasQry)->FIV_TPSALD ,;
						(cAliasQry)->FIV_CARTEI ,;
						(cAliasQry)->FIV_VALOR ,;
						(cAliasQry)->FIV_VALOR ,;
						"+" ,;
						"M",;
						FunName(),;
						"SEV",;
						0,;
						"",;
						"",;
						0,;
						cFilAnt)
		Else
			AtuSldNat(	(cAliasQry)->FIV_NATUR ,;
					 	(cAliasQry)->FIV_DATA ,;
					 	(cAliasQry)->FIV_MOEDA ,;
						(cAliasQry)->FIV_TPSALD ,;
						(cAliasQry)->FIV_CARTEI ,;
						(cAliasQry)->FIV_VALOR,;
						(cAliasQry)->FIV_VALOR ,;
						"+" ,;
						"M",;
						FunName(),;
						"SEV",;
						,;
						,;
						,;
						(cAliasQry)->FIV_ABATI,;
						cFilAnt,;
						.T.)
		Endif
		
		dbSelectArea(cAliasQry)
		dbSkip()

	EndDo
Endif

dbSelectArea(cAliasQry)
dbCloseArea()
fErase(cAliasQry + OrdBagExt())
fErase(cAliasQry + GetDbExtension())

dbSelectArea("SE1")

RestArea(aArea)
Return(.T.)


/*/{Protheus.doc} F800VLDSE7
Valida se os saldos orçados não tem natureza sem condição

@Author Rodrigo Gimenes
@Since 31/07/2012
@Version 11.80
@Return lRet
/*/
Static Function F800VLDSE7(oSelf ,nInc, aPerguntes)	//Function
Local aArea		:= GetArea()
Local cQuery	:= ""
Local cAliasQry	:= "TRB800VLD"
Local cMensagem	:= ""
Local cTpE7ED   := GetTpShare("SE7",mcFIL) + GetTpShare("SED",mcFIL)
Local lProcessa := .F.
Local lProcFil  := .F.

If cTpE7ED == "EE"
	lProcessa := .T.
	lProcFil  := .T.
ElseIf cTpE7ED == "CC"
	If nInc == 1
		lProcessa := .T.
	EndIf
	lProcFil  := .F.
Else
	lProcessa := .T.
	lProcFil  := .F.
EndIf

If lProcessa
	cQuery := " SELECT SE7.E7_ANO,SED.ED_CODIGO "
	cQuery += " FROM " + RetSQLTab('SE7')
	cQuery += " JOIN " + RetSQLTab('SED')
	
	If lProcFil
		cQuery += " ON (SE7.E7_FILIAL = SED.ED_FILIAL   "
		cQuery += " AND SE7.E7_NATUREZ = SED.ED_CODIGO) "
	Else 
		cQuery += " ON (SE7.E7_NATUREZ = SED.ED_CODIGO) "
	EndIf

	cQuery += " WHERE "

	If lProcFil
		cQuery += " E7_FILIAL = '" + cFilAnt + "' AND "
	EndIf

	cQuery += " E7_ANO >='"+RIGHT(STR(YEAR(mv_par04)),4)+"' AND "
	cQuery += " E7_ANO <='"+RIGHT(STR(YEAR(mv_par05)),4)+"' AND "
	cQuery += " E7_NATUREZ >='" + mv_par06 +"' AND "
	cQuery += " E7_NATUREZ <='" + mv_par07 +"' AND "
	cQuery += " SED.ED_COND NOT IN ('R', 'D') AND "
	cQuery += " SE7.D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY SED.ED_CODIGO, SE7.E7_ANO  "
	cQuery := ChangeQuery(cQuery)
	
	cMensagem := ""
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	DbGotop()
	If !EOF() .AND. !BOF()
		cMensagem := STR0020 //"O reprocessamento não pode ser efetuado, pois o(s) seguinte(s) orçamento(s) contém naturezas sem a condição (Receita ou Despesa) :"
		While !(cAliasQry)->(Eof())
			cMensagem += CRLF + STR0018 + " " + (cAliasQry)->(E7_ANO) +  STR0019 +  (cAliasQry)->(ED_CODIGO) // Ano : +  + Natureza
			dbSelectArea(cAliasQry)
			dbSkip()
		EndDo
		cMensagem += CRLF +CRLF +  STR0021 //" "Para efetuar o processamento dos saldos orçados, informe a condição (Receita ou Despesa) para no cadastro das naturezas informadas nessa mensagem"
		Help(" ",1,"CARTNAT",,cMensagem,1,0)
	
	Endif

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

EndIf

RestArea(aArea)

Return(Empty(cMensagem))

/*/{Protheus.doc}F800SPSEZ
Realiza Filtro na SEZ - Rateio por centro de Custo.
@author William Matos Gundim Junior
@since  06/03/2014
@version 12
/*/
Static Function F800SPSEZ(aPerguntes)	//Function
Local aArea		:= GetArea()
Local cQuery	:= ""
Local cAliasQry	:= "TRB800D"
Local lFinc24 	:= IsIncallStack("FINC024")
Default aPerguntes:= {}

dbSelectArea("SE1")
dbSetOrder(1)

cQuery := " SELECT EZ_NATUREZ, E1_VENCREA EZ_VENCREA, EZ_TIPO, E1_MOEDA MOEDA, EZ_IDENT IDENT, 'R' CARTEIRA, "
cQuery += " SUM(EZ_VALOR) NVALOR, SUM(E1_VLCRUZ * EZ_PERC) NVLCRUZ "
cQuery += " FROM " + RetSQLTab('SE1')

//SA1 - Filtra clientes pelo risco.
cQuery += " JOIN " + RetSQLTab('SA1')
cQuery += " ON SA1.A1_COD    = SE1.E1_CLIENTE AND "
cQuery += "    SA1.A1_LOJA   = SE1.E1_LOJA    AND "
cQuery += "	   SA1.A1_RISCO >='" + aPerguntes[6] + "' AND "
cQuery += "	   SA1.A1_RISCO <='" + aPerguntes[7] + "'"

//SEV
cQuery += " JOIN " + RetSQLTab('SEV')
cQuery += " ON   SEV.EV_FILIAL  = SE1.E1_FILIAL AND "
cQuery += "      SEV.EV_PREFIXO = SE1.E1_PREFIXO AND "
cQuery += "      SEV.EV_NUM	    = SE1.E1_NUM AND "
cQuery += "      SEV.EV_PARCELA = SE1.E1_PARCELA AND "
cQuery += "      SEV.EV_TIPO	= SE1.E1_TIPO AND "
cQuery += "      SEV.EV_CLIFOR  = SE1.E1_CLIENTE AND "
cQuery += "      SEV.EV_LOJA	= SE1.E1_LOJA "

//SEZ
cQuery += " JOIN " + RetSQLTab('SEZ')
cQuery += " ON   SEZ.EZ_FILIAL  = SEV.EV_FILIAL AND "
cQuery += "      SEZ.EZ_PREFIXO = SEV.EV_PREFIXO AND "
cQuery += "      SEZ.EZ_NUM	    = SEV.EV_NUM AND "
cQuery += "      SEZ.EZ_PARCELA = SEV.EV_PARCELA AND "
cQuery += "      SEZ.EZ_TIPO	= SEV.EV_TIPO AND "
cQuery += "      SEZ.EZ_CLIFOR  = SEV.EV_CLIFOR AND "
cQuery += "      SEZ.EZ_LOJA	= SEV.EV_LOJA AND "
cQuery += " 	 SEZ.EZ_NATUREZ = SEV.EV_NATUREZ "
If(!Empty(aPerguntes[1]), cQuery += " AND SEZ.EZ_CCUSTO IN (" + aPerguntes[1] + ")", Nil)

cQuery += " WHERE "
cQuery += " E1_VENCREA >='" + If(lFinc24,DTOS(aPerguntes[2]) ,DTOS(mv_par04)) + "' AND "
cQuery += " E1_VENCREA <='" + If(lFinc24,DTOS(aPerguntes[3]) ,DTOS(mv_par05)) + "' AND "
cQuery += " EZ_NATUREZ >='" + If(lFinc24,aPerguntes[4],mv_par06) + "' AND "
cQuery += " EZ_NATUREZ <='" + If(lFinc24,aPerguntes[5],mv_par07) + "' AND "
cQuery += " EV_IDENT	= EZ_IDENT AND "
cQuery += " EV_IDENT	= '1' AND "
cQuery += " EV_RECPAG	= 'R' AND "
cQuery += " SEV.D_E_L_E_T_ = ' ' AND "
cQuery += " SE1.D_E_L_E_T_ = ' '     "
cQuery += " GROUP BY EZ_NATUREZ, E1_VENCREA , EZ_TIPO, E1_MOEDA, EZ_IDENT "

cQuery += " UNION ALL "

cQuery += " SELECT EZ_NATUREZ, E2_VENCREA EZ_VENCREA, EZ_TIPO, E2_MOEDA, EZ_IDENT IDENT, 'P' CARTEIRA, "
cQuery += " SUM(EZ_VALOR) NVALOR, SUM(E2_VLCRUZ * EZ_PERC) NVLCRUZ "
cQuery += " FROM " + RetSQLTab('SE2')

//SEV
cQuery += " JOIN " + RetSQLTab('SEV')
cQuery += " ON   SEV.EV_FILIAL  = SE2.E2_FILIAL AND "
cQuery += "      SEV.EV_PREFIXO = SE2.E2_PREFIXO AND "
cQuery += "      SEV.EV_NUM	    = SE2.E2_NUM AND "
cQuery += "      SEV.EV_PARCELA = SE2.E2_PARCELA AND "
cQuery += "      SEV.EV_TIPO	= SE2.E2_TIPO AND "
cQuery += "      SEV.EV_CLIFOR  = SE2.E2_FORNECE AND "
cQuery += "      SEV.EV_LOJA	= SE2.E2_LOJA "

//SEZ
cQuery += " JOIN " + RetSQLTab('SEZ')
cQuery += " ON   SEZ.EZ_FILIAL  = SEV.EV_FILIAL AND "
cQuery += "      SEZ.EZ_PREFIXO = SEV.EV_PREFIXO AND "
cQuery += "      SEZ.EZ_NUM	    = SEV.EV_NUM AND "
cQuery += "      SEZ.EZ_PARCELA = SEV.EV_PARCELA AND "
cQuery += "      SEZ.EZ_TIPO	= SEV.EV_TIPO AND "
cQuery += "      SEZ.EZ_CLIFOR  = SEV.EV_CLIFOR AND "
cQuery += "      SEZ.EZ_LOJA	= SEV.EV_LOJA AND "
cQuery += " 	 SEZ.EZ_NATUREZ = SEV.EV_NATUREZ "
If(!Empty(aPerguntes[1]), cQuery += " AND SEZ.EZ_CCUSTO IN (" + aPerguntes[1] + ")", Nil)

cQuery += " WHERE "
cQuery += " E2_VENCREA >='" + DTOS(aPerguntes[2]) +"' AND "
cQuery += " E2_VENCREA <='" + DTOS(aPerguntes[3])+"' AND "
cQuery += " EZ_NATUREZ >='" + aPerguntes[4]  +"' AND "
cQuery += " EZ_NATUREZ <='" + aPerguntes[5] +"' AND "
cQuery += " EV_IDENT    = EZ_IDENT AND "
cQuery += " EV_IDENT    = '1' AND "
cQuery += " EV_RECPAG   = 'P' AND "
cQuery += " SEV.D_E_L_E_T_ = ' ' AND "
cQuery += " SE2.D_E_L_E_T_ = ' '     "
cQuery += " GROUP BY EZ_NATUREZ, E2_VENCREA, EZ_TIPO, E2_MOEDA, EZ_IDENT "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
TcSetField(cAliasQry, "E1_VENCREA" , "D")

dbSelectArea(cAliasQry)
DbGotop()
If !EOF() .AND. !BOF()
	While !(cAliasQry)->(Eof())
		FC24SldNat(cAliasQry, 'SEZ', (cAliasQry)->CARTEIRA, If((cAliasQry)->EZ_TIPO $ MVABATIM,"-","+"))
		dbSkip()
	EndDo
Endif

dbSelectArea(cAliasQry)
dbCloseArea()
fErase(cAliasQry + OrdBagExt())
fErase(cAliasQry + GetDbExtension())

dbSelectArea("SE1")

RestArea(aArea)
Return

/*/{Protheus.doc}F800SRSEZ
Realiza Filtro na SEZ - Rateio por centro de Custo.
@author William Matos Gundim Junior
@since  06/03/2014
@version 12
/*/
Static Function F800SRSEZ(aPerguntes)	//Function
Local aArea		:= GetArea()
Local cQuery		:= ""
Local cAliasQry	:= "TRB800D"

Default aPerguntes:= {}

dbSelectArea("SE1")
dbSetOrder(1)

cQuery := " SELECT EZ_NATUREZ, E1_VENCREA EZ_VENCREA, EZ_TIPO, E1_MOEDA MOEDA, EZ_IDENT IDENT, 'R' CARTEIRA, " + CRLF
cQuery += " SUM(EZ_VALOR) NVALOR, SUM(E1_VLCRUZ * EZ_PERC) NVLCRUZ " + CRLF
cQuery += " FROM " + RetSQLTab('SE1') + CRLF

//SA1 - Filtra clientes pelo risco.
cQuery += " JOIN " + RetSQLTab('SA1') + CRLF
cQuery += " ON  SA1.A1_COD    = SE1.E1_CLIENTE AND " + CRLF
cQuery += "     SA1.A1_LOJA   = SE1.E1_LOJA    AND " + CRLF
cQuery += "	    SA1.A1_RISCO >='" + aPerguntes[6] + "' AND " + CRLF
cQuery += "	    SA1.A1_RISCO <='" + aPerguntes[7] + "'" + CRLF

//SEV
cQuery += " JOIN " + RetSQLTab('SEV') + CRLF
cQuery += " ON   SEV.EV_FILIAL  = SE1.E1_FILIAL AND " + CRLF
cQuery += "      SEV.EV_PREFIXO = SE1.E1_PREFIXO AND " + CRLF
cQuery += "      SEV.EV_NUM	    = SE1.E1_NUM AND " + CRLF
cQuery += "      SEV.EV_PARCELA = SE1.E1_PARCELA AND " + CRLF
cQuery += "      SEV.EV_TIPO	= SE1.E1_TIPO AND " + CRLF
cQuery += "      SEV.EV_CLIFOR  = SE1.E1_CLIENTE AND " + CRLF
cQuery += "      SEV.EV_LOJA	= SE1.E1_LOJA " + CRLF

//SEZ
cQuery += " JOIN " + RetSQLTab('SEZ') + CRLF
cQuery += " ON   SEZ.EZ_FILIAL  = SEV.EV_FILIAL AND " + CRLF
cQuery += "      SEZ.EZ_PREFIXO = SEV.EV_PREFIXO AND " + CRLF
cQuery += "      SEZ.EZ_NUM	    = SEV.EV_NUM AND " + CRLF
cQuery += "      SEZ.EZ_PARCELA = SEV.EV_PARCELA AND " + CRLF
cQuery += "      SEZ.EZ_TIPO	= SEV.EV_TIPO AND " + CRLF
cQuery += "      SEZ.EZ_CLIFOR  = SEV.EV_CLIFOR AND " + CRLF
cQuery += "      SEZ.EZ_LOJA	= SEV.EV_LOJA AND " + CRLF
cQuery += " 	 SEZ.EZ_NATUREZ = SEV.EV_NATUREZ " + CRLF
If(!Empty(aPerguntes[1]), cQuery += " AND SEZ.EZ_CCUSTO IN (" + aPerguntes[1] + ")" + CRLF, Nil)

cQuery += " WHERE "
cQuery += " E1_VENCREA >='" + DTOS(aPerguntes[2]) + "' AND " + CRLF
cQuery += " E1_VENCREA <='" + DTOS(aPerguntes[3]) + "' AND " + CRLF
cQuery += " EZ_NATUREZ >='" + aPerguntes[4]		  + "' AND " + CRLF
cQuery += " EZ_NATUREZ <='" + aPerguntes[5]		  + "' AND " + CRLF
cQuery += " EV_IDENT	= EZ_IDENT AND "+ CRLF
cQuery += " EV_IDENT	= '2' AND " + CRLF
cQuery += " EV_RECPAG	= 'R' AND " + CRLF
cQuery += " SEV.D_E_L_E_T_ = ' ' AND "
cQuery += " SE1.D_E_L_E_T_ = ' '     "
cQuery += " GROUP BY EZ_NATUREZ, E1_VENCREA, EZ_TIPO, E1_MOEDA, EZ_IDENT" + CRLF

cQuery += " UNION ALL " + CRLF

cQuery += " SELECT EZ_NATUREZ, E2_VENCREA EZ_VENCREA , EZ_TIPO, E2_MOEDA MOEDA, EZ_IDENT IDENT, 'P' CARTEIRA, " + CRLF
cQuery += " SUM(EZ_VALOR) NVALOR, SUM(E2_VLCRUZ * EZ_PERC) NVLCRUZ " + CRLF
cQuery += " FROM " + RetSQLTab('SE2') + CRLF
cQuery += " JOIN " + RetSQLTab('SEV') + CRLF
cQuery += " ON   SEV.EV_FILIAL  = SE2.E2_FILIAL AND " + CRLF
cQuery += "      SEV.EV_PREFIXO = SE2.E2_PREFIXO AND " + CRLF
cQuery += "      SEV.EV_NUM	    = SE2.E2_NUM AND " + CRLF
cQuery += "      SEV.EV_PARCELA = SE2.E2_PARCELA AND " + CRLF
cQuery += "      SEV.EV_TIPO	= SE2.E2_TIPO AND " + CRLF
cQuery += "      SEV.EV_CLIFOR  = SE2.E2_FORNECE AND " + CRLF
cQuery += "      SEV.EV_LOJA	= SE2.E2_LOJA " + CRLF

//SEZ
cQuery += " JOIN " + RetSQLTab('SEZ') + CRLF
cQuery += " ON   SEZ.EZ_FILIAL  = SEV.EV_FILIAL AND " + CRLF
cQuery += "      SEZ.EZ_PREFIXO = SEV.EV_PREFIXO AND " + CRLF
cQuery += "      SEZ.EZ_NUM	    = SEV.EV_NUM AND " + CRLF
cQuery += "      SEZ.EZ_PARCELA = SEV.EV_PARCELA AND " + CRLF
cQuery += "      SEZ.EZ_TIPO	= SEV.EV_TIPO AND " + CRLF
cQuery += "      SEZ.EZ_CLIFOR  = SEV.EV_CLIFOR AND " + CRLF
cQuery += "      SEZ.EZ_LOJA	= SEV.EV_LOJA AND " + CRLF
cQuery += " 	 SEZ.EZ_NATUREZ = SEV.EV_NATUREZ " + CRLF
If(!Empty(aPerguntes[1]), cQuery += " AND SEZ.EZ_CCUSTO IN (" + aPerguntes[1] + ")" + CRLF, Nil)

cQuery += " WHERE " + CRLF
cQuery += " E2_VENCREA >='" + DTOS(aPerguntes[2]) + "' AND " + CRLF
cQuery += " E2_VENCREA <='" + DTOS(aPerguntes[3]) + "' AND " + CRLF
cQuery += " EZ_NATUREZ >='" + aPerguntes[4]	+ "' AND " + CRLF
cQuery += " EZ_NATUREZ <='" + aPerguntes[5]	+ "' AND " + CRLF
cQuery += " EV_IDENT    = EZ_IDENT AND "+ CRLF
cQuery += " EV_IDENT	= '2' AND " + CRLF
cQuery += " EV_RECPAG	= 'P' AND " + CRLF
cQuery += " SEV.D_E_L_E_T_ = ' ' AND "
cQuery += " SE2.D_E_L_E_T_ = ' '     "
cQuery += " GROUP BY EZ_NATUREZ, E2_VENCREA, EZ_TIPO, E2_MOEDA, EZ_IDENT" + CRLF
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
TcSetField(cAliasQry, "E1_VENCREA" , "D")

dbSelectArea(cAliasQry)
DbGotop()
If !EOF() .AND. !BOF()
	While !(cAliasQry)->(Eof())
		FC24SldNat(cAliasQry, 'SEZ', (cAliasQry)->CARTEIRA, If((cAliasQry)->EZ_TIPO $ MVABATIM,"-","+"))
		dbSkip()
	EndDo
Endif

dbSelectArea(cAliasQry)
dbCloseArea()
fErase(cAliasQry + OrdBagExt())
fErase(cAliasQry + GetDbExtension())

dbSelectArea("SE1")

RestArea(aArea)

Return

/*{Protheus.doc} GetTpShare 
 Obtem o modo de compartilhamento de tabelas do dicionário. Faz uso da variável Estática aLSTBMDAC
 @author norbertom
 @since 28/08/2015
 @version 1.0
 @param c_Alias, CARACTERE, Alias da tabela que se deseja consultar o modo de compartilhamento
 @param nMode, NUMERICO, Representa o nivel que se deseja conhecer: 1 - Empresa ; 2 - Unidade de Negócio ; 3 - Filial
 @return cRet, Caractere Contendo representando:  (E)xclusivo ou (C)ompartilhado
 @example
 	GetTpShare('SA1',3) --> 'E' ou 'C'
*/
Static Function GetTpShare(c_Alias,nMode)
Local cRet	:= ''
Local nPos	:= 0 

Default nMode := mcFIL 

If (nPos := AScan(aLSTBMDAC,{|E| E[1] == c_Alias})) == 0
	AAdd(aLSTBMDAC, {c_Alias,FWMODEACCESS(c_Alias,mcEMP),FWMODEACCESS(c_Alias,mcUNG),FWMODEACCESS(c_Alias,mcFIL)})
EndIf

nPos := AScan(aLSTBMDAC,{|E| E[1] == c_Alias})
If !Empty(nPos) .and. !Empty(nMode) 
	cRet := aLSTBMDAC[nPos][nMode+1]
EndIf

Return cRet

/*/{Protheus.doc} FA800VLDT
Validação da pergunta de data final, evitando que a mesma seja preenchida com valor menor

@Author Pedro Pereira Lima
@Since 26/07/2017
@Version 11.80
@Return lRet
/*/
Static Function FA800VLDT()	//Function
Local lRet := .T.

If MV_PAR05 < MV_PAR04
	lRet := .F.
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} ATUSLDNAT
Atualiza tabelas de saldo de naturezas
Arquivo original: FINXATU.PRX 

@param cNatureza - Codigo da natureza em que o saldo sera atualizado
@param dData - Data em que o saldo deve ser atualizado
@param cMoeda - Codigo da moeda do saldo
@param cTipoSld - Tipo de saldo (1=Orcado, 2=Previsto, 3=Realizado)
@param cCarteira - Codigo da carteira (P=Pagar, R=Receber)
@param nValor - Valor que atualizara o saldo na moeda do saldo
@param nVlrCor - Valor que atualizara o saldo na moeda corrente
@param cSinal - Sinal para atualizacao (+) ou (-)
@param cPeriodo - Saldo a ser atualizado (D = Diario, M = Mensal, NIL = Ambos	(importante apenas no recalculo)
@param cOrigem - Rotina de Origem do movimento de fluxo de caixa. Ex. FUNNAME()
@param cAlias - Alias onde ocorreu a movimentação de fluxo de caixa. Ex. SE2
@param nRecno - Número do registro no alias onde ocorreu a movimentação de fluxo de caixa.
@param nOpcRot - Opção de manipulação da rotina de origem da chamada da função AtuSldNat()	
@param cTipoDoc - Tipo do documento E5_TIPODOC
@param nVlAbat - Valor de abatimento E5_ABATI

@author Claudio Donizete de Souza
@since 16/04/2010
/*/
//-------------------------------------------------------------------
Static Function AtuSldNat(cNatureza		,;	// 01 -> Codigo da natureza em que o saldo sera atualizado
							 dData		,;	// 02 -> Data em que o saldo deve ser atualizado
							 cMoeda		,;	// 03 -> Codigo da moeda do saldo
							 cTipoSld	,;	// 04 -> Tipo de saldo (1=Orcado, 2=Previsto, 3=Realizado)
							 cCarteira	,;	// 05 -> Codigo da carteira (P=Pagar, R=Receber)
							 nValor		,; 	// 06 -> Valor que atualizara o saldo na moeda do saldo
	 						 nVlrCor	,; 	// 07 -> Valor que atualizara o saldo na moeda corrente
							 cSinal		,;	// 08 -> Sinal para atualizacao (+) ou (-)
							 cPeriodo	,;	// 09 -> Saldo a ser atualizado (D = Diario, M = Mensal, NIL = Ambos	(importante apenas no recalculo)
							 cOrigem	,;	// 10 -> Rotina de Origem do movimento de fluxo de caixa. Ex. FUNNAME()
							 cAlias		,;	// 11 -> Alias onde ocorreu a movimentação de fluxo de caixa. Ex. SE2
							 nRecno		,;	// 12 -> Número do registro no alias onde ocorreu a movimentação de fluxo de caixa.
							 nOpcRot	,;  // 13 -> Opção de manipulação da rotina de origem da chamada da função AtuSldNat()	
							 cTipoDoc	,;	// 14 -> Tipo do documento E5_TIPODOC
							 nVlAbat	,;  // 15 -> Valor de abatimento E5_ABATI
							 cFilSE1	,;	// 16 -> Filial do registro compartilhado XX_FILORIG
							 lRatNat)		// 17 -> Indica se é rateio por natureza

Local cMovFlxCxNt	:= GetNewPar("MV_FINATFN","1") // Verifica se movimenta fluxo de caixa "1" - On-line / "2" - Off-Line
Local lRet			:= .F.
Local aArea			:= GetArea()
Local aAreaFIV		:= {}
Local aAreaFIW		:= {}
Local lFASLDNAT		:= ExistBlock("FASLDNAT") // Ponto de Entrada
Local lAtuSldNat	:= .T.
Local lF022GRA		:= ExistBlock("F022GRA") // Ponto de Entrada
Local cCodFJV 		:= ""
Local lGrvSld 		:= .T.
Local nAux			:= 0
Local lIntPfs       := SuperGetMV("MV_JURXFIN",,.F.) //Habilita a integracao entre os modulos SIGAFIN - Financeiro e SIGAPFS - Juridico
Local cFilFIV		:= ""
Local cFilFIW		:= ""
Local cFilFJV		:= ""

DEFAULT cPeriodo	:= "A"					// Atualizar saldo Diario e Mensal do Fluxo de Caixa por Natureza Financeira
DEFAULT cOrigem		:= FunName()			// Função de Origem da Chamada da Função AtuSldNat()
DEFAULT cAlias		:= Alias()				// Alias posicionado no momento da chamada da função AtuSldNat()
DEFAULT nRecno		:= (cAlias)->(Recno())	// Número do Recno da tabela posicionada no momento da chamada da função AtuSldNat()
DEFAULT nOpcRot		:= 0					// Modo de Edição da rotina de origem da chamada da função AtuSldNat()
DEFAULT cTipoDoc    := ""
DEFAULT cMoeda		:= '01'					// Moeda Padrão utilizada no processso
DEFAULT nVlAbat     := 0                  // Valor do Abatimento
Default lFASLDNAT	:= ExistBlock("FASLDNAT") // Ponto de Entrada
Default nTamNatur   := TamSX3("FIV_NATUR")[1]  
Default __lFivAbati := .T.
Default __lFiwAbati := .T.  
Default __lExistFJV := .T.
Default cFilSE1		:= Nil
Default lRatNat 	:= .F.

cFilFIV		:= xFilial("FIV", cFilSE1 )
cFilFIW		:= xFilial("FIW", cFilSE1 )
cFilFJV		:= xFilial("FJV", cFilSE1 )

If lIntPfs .And. !FwIsInCallStack("J241ExcAtu")
	lRet := .T.

Else
	If !Empty(nVlrCor) .and. (cTipoSld == '3') .and. (nValor == nVlrCor) .and. (If(ValType(cMoeda) == "N",cMoeda,Val(cMoeda)) <> 1) 
		nVlrCor := xMoeda(nVlrCor,If(ValType(cMoeda) == "N",cMoeda,Val(cMoeda)),1,dData)
	EndIf

	/*
	* Se as tabelas não existirem no dicionário de dados, a atualização de saldos não é executada (Proteção)
	* E se Fluxo de Caixa somente para a localização BRASIL 
	*/ 
	aAreaFIV		:= FIV->(GetArea())
	aAreaFIW		:= FIW->(GetArea())

	If cPaisLoc == "BRA" .OR. cPaisLoc == "BOL"
		DbSelectArea("FIV")
		aAreaFIV := FIV->(GetArea())
		DbSelectArea("FIW")
		aAreaFIW := FIW->(GetArea())
		
		// Esta rotina esta disponivel apenas para ambientes TOPCONNECT
		// Converte o codigo da moeda para facilitar as chamadas em que o codigo da moeda eh numerico, ex. Financeiro
		If EMPTY(cMoeda)
			cMoeda := '01'
		ElseIf ValType(cMoeda) != "C"
			cMoeda := StrZero(cMoeda,2)
		ElseIf Len(AllTrim(cMoeda)) < 2
			cMoeda := StrZero(VAL(cMoeda),2)  	
		Endif
		
		/*
		* Formatando o parâmetro da natureza para o tamanho do campo do banco de dados para efetuar a
		* pesquisa corretamente nos saldos do fluxo de caixa por natureza.
		*/
		cNatureza := PADR(cNatureza,nTamNatur," ")

		If cMovFlxCxNt == "1" .or. (cMovFlxCxNt == "2" .and. cOrigem == "FINA800")

			/*
			* Ponto de Entrada no processo de atualização do saldos do fluxo de caixa por natureza financeira.
			*/
			If lFASLDNAT
				lAtuSldNat := ExecBlock("FASLDNAT",.F.,.F.,{cOrigem, cAlias, nRecno, nOpcRot})
				lAtuSldNat := IIF(Valtype(lAtuSldNat) == "L", lAtuSldNat, .T.)
			EndIf
				
			If lAtuSldNat
				/* Verifica se a movimentacao possui origem nas SEs.
				Movimentacoes avulsas relacionadas a natureza nao podem ter seu saldo gravado,
				pois nunca existiu saldo orcado e previsto ou 
				ja efetuaram movimentacao do saldo no momento de sua origem.
				obs: validacao exclusiva para FINA800()
				*/
				If cOrigem == "FINA800"  
					dbSelectArea("SE1")
					dbSetOrder(3)
					If !SE1->(dbSeek(xFilial("SE1") + Alltrim(cNatureza)))
						lGrvSld := .F.
					EndIf
					// Se nao encontrou na SE1, procura na SE2
					If !lGrvSld
						dbSelectArea("SE2")
						dbSetOrder(2)
						If SE2->(dbSeek(xFilial("SE2") + AllTrim(cNatureza)))
							lGrvSld := .T.
						EndIf
					EndIf
					//Se não achou na SE1 e na SE2, pode ser movimento bancário
					If !lGrvSld
						dbSelectArea("SE5")
						dbSetOrder(4)
						If SE5->(dbSeek(xFilial("SE5") + Alltrim(cNatureza)))
							If SE5->E5_IDMOVI <> ''
								lGrvSld := .T.
							EndIf 
						EndIf
					EndIf
					
					If !lGrvSld .And. lRatNat
						SEV->(DbSetOrder(3))
						If SEV->(dbSeek(xFilial("SEV") + Alltrim(cNatureza))) .OR. cAlias == "SEV"
							lGrvSld := .T.
						EndIf
					EndIf 
					
					RestArea(aAreaFIV)
				EndIf
			
				lRet := .T.

				If cPeriodo $ "A#D" .And. lGrvSld
					// Grava FIV (Movimentos diarios)
					FIV->(DbSetOrder(1)) // FIV_FILIAL+FIV_NATUR+FIV_MOEDA+FIV_TPSALD+FIV_CARTEI+DTOS(FIV_DATA)
					If FIV->(MsSeek(cFilFIV + cNatureza + cMoeda + cTipoSld + cCarteira + DTOS(dData))	)
						RecLock("FIV",.F.)
					Else	
						RecLock("FIV",.T.)
						FIV->FIV_FILIAL	:= cFilFIV
						FIV->FIV_NATUR		:= cNatureza
						FIV->FIV_MOEDA		:= cMoeda
						FIV->FIV_TPSALD	:= cTipoSld
						FIV->FIV_CARTEI	:= cCarteira
						FIV->FIV_DATA		:= dData
					Endif
					If cSinal == "+"
						FIV->FIV_VALOR += nValor
						If __lFivAbati 
							FIV->FIV_ABATI += nVlAbat
						Endif
					Else
						FIV->FIV_VALOR -= nValor
						If __lFivAbati
							FIV->FIV_ABATI -= nVlAbat
						Endif
					Endif
					MsUnlock()
					FIV->( dbCommit() )
				Endif

				If cPeriodo $ "A#M" .And. lGrvSld			
					// Grava FIW (Saldos mensais)
					FIW->(DbSetOrder(1)) // FIW_FILIAL+FIW_NATUR+FIW_MOEDA+FIW_TPSALD+FIW_CARTEI+DTOS(FIW_DATA)
					If FIW->(MsSeek(cFilFIW + cNatureza + cMoeda + cTipoSld + cCarteira + DTOS(LastDay(dData)))	)
						RecLock("FIW",.F.)
					Else	
						RecLock("FIW",.T.)
						FIW->FIW_FILIAL	:= cFilFIW
						FIW->FIW_NATUR		:= cNatureza
						FIW->FIW_MOEDA		:= cMoeda
						FIW->FIW_TPSALD	:= cTipoSld
						FIW->FIW_CARTEI	:= cCarteira
						FIW->FIW_DATA		:= LastDay(dData)
					Endif
					If cSinal == "+"
						FIW->FIW_VALOR += nValor
						If !Empty( __lFiwAbati )
							FIW->FIW_ABATI += nVlAbat
						Endif
					Else
						FIW->FIW_VALOR -= nValor
						If !Empty( __lFiwAbati )
							FIW->FIW_ABATI -= nVlAbat
						Endif
					Endif
					MsUnlock()
					FIW->( dbCommit() )
				Endif

				If cPeriodo $ "A#D" .and. Val(cMoeda) > 1 .AND. nVlrCor > 0
						AtuSldNat(cNatureza		,;	// 1  -> Codigo da natureza em que o saldo sera atualizado
									dData 	 	,;	// 2  -> Data em que o saldo deve ser atualizado
									"01"  	 	,;	// 3  -> Codigo da moeda do saldo
									cTipoSld 	,;	// 4  -> Tipo de saldo (1=Orcado, 2=Previsto, 3=Realizado)
									cCarteira	,;	// 5  -> Codigo da carteira (P=Pagar, R=Receber)
									nVlrCor  	,; 	// 6  -> Valor que atualizara o saldo na moeda do saldo
									0			,; 	// 7  -> Valor que atualizara o saldo na moeda corrente
									cSinal	 	,;	// 8  -> Sinal para atualizacao (+) ou (-)
									cPeriodo	,;  // 9  -> Saldo a ser atualizado (D = Diario, M = Mensal, A = Ambos	(default)
									cOrigem	,;	// 10 -> Rotina de Origem do movimento de fluxo de caixa. Ex. FUNNAME()
									cAlias		,;	// 11 -> Alias onde ocorreu a movimentação de fluxo de caixa. Ex. SE2
									nRecno		,;	// 12 -> Número do registro no alias onde ocorreu a movimentação de fluxo de caixa.
									nOpcRot	)	// 13 -> Opção de manipulação da rotina de origem da chamada da função AtuSldNat()
				Endif
				// Atualização da FJV
				// Gravação dos campos padrões da FJV   
				If __lExistFJV
					If cPeriodo $ "A#D"
						cCodFJV := FaGetCodFJV()

						FJV->(DbSetOrder(1)) 
						RecLock("FJV", .T.)
						FJV->FJV_FILIAL 	:= cFilFJV
						FJV->FJV_CODIGO 	:= cCodFJV
						FJV->FJV_NATUR		:= cNatureza
						FJV->FJV_MOEDA		:= cMoeda
						FJV->FJV_TPSALD		:= cTipoSld
						FJV->FJV_CARTEI		:= cCarteira
						FJV->FJV_DATA		:= dData
						FJV->FJV_ALIAS		:= cAlias
						FJV->FJV_RECNO		:= nRecno
						FJV->FJV_TPMOV		:= Iif( cSinal == '+', '1', '2' ) // cSinal "1"-ADICAO OU "2"-ESTORNO
						FJV->FJV_ORIGEM 	:= cOrigem // Rotina que gerou o movimento
						FJV->FJV_CLORIG 	:= RetOriAli(cAlias , cCarteira, Alltrim(cOrigem), cTipoDoc ) // ( cAlias, cCarteira )

						If cSinal == "+"
							FJV->FJV_VALOR	:= nValor
						Else
							FJV->FJV_VALOR	:= nValor * -1
						Endif

						MsUnLock()  
						FJV->( dbCommit() )

						// Ponto de entrada para dados complementares
						If lF022GRA
							ExecBlock("F022GRA",.F.,.F.,{ cNatureza, dData, cMoeda, cAlias  })
						Endif
					Endif
				Endif
			Endif
		Endif
	Endif

	// Restauro a area anterior, se esta nao estava em branco
	If !Empty(cAlias)
		DbSelectArea(cAlias)
	Endif
	RestArea(aAreaFIW)
	RestArea(aAreaFIV)
	RestArea(aArea)
EndIf

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} RETORIALI

Retorna a origem do movimento para o Alias informado.
Arquivo original: FINXATU.PRX 

@param cNatureza - Codigo da natureza que se deseja o saldo
@param dData - Data em que se deseja o saldo
@param cMoeda - Codigo da moeda que se deseja o saldo
@param cTipoSld - Tipo do saldo desejado (1=Orçado, 2=Previsto, 3=Realizado)
@param cCarteira - Codigo da carteira desejada (P=Pagar, R=Receber)

@author TOTVS
@since 28/11/2011
/*/
//-------------------------------------------------------------------
Static Function RetOriAli( cAlias, cCarteira, cOrigem, cTipoDoc )                   
Local cRet := ''
cAlias := Alltrim(cAlias)

/*
"	TITR = Títulos a receber
"	TITP = Títulos a pagar
"	COMV = Comissão de vendas
"	APL  = Transações referentes a Aplicações 
"   EMP  = Transações referentes a Empréstimos
"   MVBR = Movimentação bancaria a Receber
"   MVBP = Movimentação bancaria a Pagar
*/
   
/* condiçoes abaixo foram feitas conforme a ultima versao do fonte do sourcesafe DATA: 02/12/2011*/
Do case
   Case cAlias == 'SE1' // Titulos a Receber
       cRet := 'TITR'   

   Case cAlias == "SEV" .AND. cCarteira == "R"   //Titulos a Receber Multinatureza
	   cRet := 'TITR'
                        
   Case cAlias == 'SE2' // Titulos a Pagar
       cRet := 'TITP'  
                       
                       
   Case cAlias == 'SEV' .AND. cCarteira == "P" // Titulos a Pagar Multinatureza
       cRet := 'TITP' 
   
   Case cAlias == 'SE3' // Comissoes de vendas
       cRet := 'COMV'

   Case cAlias == 'SEH' .AND. cCarteira == 'P' // Aplicacao 
       cRet := 'APL'

   Case cAlias == 'SE5' .AND. cCarteira == 'P' .AND. ( cOrigem == 'FINA171' .OR. cTipoDoc == 'AP' )//Aplicacao com FINA171 SE5
       cRet := 'APL'

   Case cAlias == 'SEH' .AND. cCarteira == 'R' .AND. ( cOrigem == 'FINA181' .OR. cTipoDoc == 'AP' )// Resgaste da Aplicacao -- Testado porem com o parametro cAlias o valor "SE5" em vez de "SEH"
       cRet := 'APL'
  
   Case cAlias == 'SEH' .AND. cCarteira == 'R'  //Emprestimo 
       cRet := 'EMP' 

   Case cAlias == 'SE5' .AND. cCarteira == 'R' .AND. ( cOrigem == 'FINA171' .OR. cTipoDoc == 'EP' )//Emprestimo com Fina171 SE5
       cRet := 'EMP' 
   
   Case cAlias == 'SE5' .AND. cCarteira == 'P' .AND. ( cOrigem == 'FINA181' .OR. cTipoDoc == 'EP' )//Resgate do emprestimo
       cRet := 'EMP' 
   
   Case cAlias == 'SE5' .AND. cCarteira == 'R' // Movimento bancario a Receber
       cRet := 'MVBR'

   Case cAlias == 'SE5' .AND. cCarteira == 'P'  // Movimento Bancario a Pagar
       cRet := 'MVBP'
   
   OtherWise
       cRet := 'NIDENTIF'
       
End Case

Return cRet

