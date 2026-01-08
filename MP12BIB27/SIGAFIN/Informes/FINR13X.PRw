#DEFINE BOTTOMPAGE 60
#INCLUDE "FINR13X.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "TOPCONN.CH"
#Include "Protheus.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± ±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR13X  ³ Autor ³ Bruno Sobieski        ³ Data ³ 01.03.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cuenta corriente de Cliente                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  DATA    ³ BOPS ³                  ALTERACAO                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³09.05.00  ³Melhor³Bruno : Considerar data de digitacao no parametros.  ³±±
±±³07.03.01  ³Melhor³Rubens: Aumento dos campos numericos do arquivo temp.³±±
±±³          ³      ³        e da mascara na impressao dos valores        ³±±
±±³20/04/01  ³Melhor|Rubens: Considera tambem as baixas manuais, juros,   ³±±
±±³          |      |        multas e descontos.                          ³±±
±±³06.02.02  |013163|Ajuste no Saldo Inicial por Cliente.                 ³±±
±±³25/05/17|MMI-5220|Se modifica informe para que considere Ambos tipos de³±±
±±³          |      |Recibos en el parametro 14.                          ³±±
±±³29/11/2018    nahim modificado para Bolivia CIMA						  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Finr13X        // incluido pelo assistente de conversao do AP5 IDE em 09/09/99
	Local oReport
	private nPagntp := 0

	If TRepInUse()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oReport	:= ReportDef()
		oReport:PrintDialog()
	Else

		U_FINR13XR3()
	EndIf

	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³Paulo Augusto       º Data ³  21/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tratamanto release 04                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

	Local oReport,oSection1,oSection2
	Local cReport := "FINR13X"
	Local cTitulo :=OemToAnsi(STR0003) 	// "Informe de Pagos"
	Local cDescri := OemToAnsi(STR0003)

	Pergunte("FIR13X",.F.)

	oReport  := TReport():New( cReport, cTitulo, "FIR13X" , { |oReport| ReportPrint( oReport, "SE1" ) }, cDescri )

	oSection1 := TRSection():New( oReport,STR0039, {"SA1"}, )

	TRCell():New( oSection1, "A1_COD" 	,"SA1",/*X3Titulo*/	,/*Picture*/,TamSX3("A1_COD")[1]+TamSx3("A1_LOJA")[1]+2,/*lPixel*/,)
	TRCell():New( oSection1, "A1_NOME"	,"SA1",/*X3Titulo*/	,/*Picture*/,TamSX3("A1_NOME")[1]/*Tamanho*/,/*lPixel*/,)

	TrPosition():New(oSection1,'SA1',1,{|| xFilial('SA1')+TRB->CODCLI+TRB->LOJA} )

	oSection2 := TRSection():New( oSection1,STR0040 ,  )
	TRCell():New( oSection2,"E1_EMISSAO"	,"SE1","Fch Emisión"/*X3Titulo*/	,/*Picture*/,20/*Tamanho*/,/*lPixel*/)
	TRCell():New( oSection2,"E1_TIPO"		,"SE1",/*X3Titulo*/	,/*Picture*/,TamSX3("E1_TIPO")[1]+5/*Tamanho*/,/*lPixel*/)
	TRCell():New( oSection2,"E1_NUM"		,"SE1",/*X3Titulo*/	,/*Picture*/,TamSX3("E1_NUM")[1]+TamSx3("E1_PREFIXO")[1]+4+7/*Tamanho*/,/*lPixel*/)
	TRCell():New( oSection2,"E1_RECIBO"		,"SE1",/*X3Titulo*/	,/*Picture*/,TamSX3("E1_RECIBO")[1] + 12/*Tamanho*/,/*lPixel*/) // nahim añadiendo
	//If MV_PAR05==2 // nahim 2 significa RESUMEN
	TRCell():New( oSection2, "A1_COD" 	,"SA1",/*X3Titulo*/	,/*Picture*/,TamSX3("A1_COD")[1]+TamSx3("A1_LOJA")[1]+2,/*lPixel*/,)
	TRCell():New( oSection2, "A1_NOME"	,"SA1",/*X3Titulo*/	,/*Picture*/,TamSX3("A1_NOME")[1]/*Tamanho*/,/*lPixel*/,)
	//endif
	If cPaisLoc == "PTG"
		TRCell():New( oSection2,"NODIA","TRB",STR0042	,/*Picture*/,10/*Tamanho*/,/*lPixel*/,)//"Diario CTB"
	Endif
	TRCell():New( oSection2,"E1_VENCREA"	,"SE1",STR0033+CHR(13)+CHR(10) +STR0034/*X3Titulo*/	,/*Picture*/,/*Tamanho*/20,/*lPixel*/)
	//If MV_PAR05==2 // nahim 2 significa RESUMEN
	TRCell():New( oSection2,"SALDOINI"		,"   ","Saldo "+ CHR(13)+CHR(10) + "Inicial"/*X3Titulo*/,,TamSX3("E1_VALOR")[1]+10,,,,,"CENTER")// ,,,"RIGHT",,"RIGHT")
	//endif
	//TRCell():New( oSection2,"DEBITO"		,"   ",STR0035/*X3Titulo*/	,PesqPict("SE1","E1_VALOR")/*Picture*/,TamSX3("E1_VALOR")[1])
	TRCell():New( oSection2,"DEBITO"		,"   ",STR0035/*X3Titulo*/,,TamSX3("E1_VALOR")[1]+10,,,,,"CENTER")// ,,,"RIGHT",,"RIGHT")
	//TRCell():New( oSection2,"CREDITO"		,"   ",STR0036/*X3Titulo*/		,PesqPict("SE1","E1_VALOR")/*Picture*/,TamSX3("E1_VALOR")[1])
	TRCell():New( oSection2,"CREDITO"		,"   ",STR0036/*X3Titulo*/,,TamSX3("E1_VALOR")[1]+13,,,,,"CENTER")//,,,"RIGHT",,"RIGHT")
	//TRCell():New( oSection2,"SALDO"		,"   ",STR0038+CHR(13)+CHR(10) + STR0037	,/*Picture*/,TAMSX3("E1_VALOR")[1]  ,.F.,		,,,"RIGHT")
	//TRCell():New( oSection2,"SALDO" 		,"   ",STR0038+CHR(13)+CHR(10) + STR0037,PesqPict("SE1","E1_VALOR")	,TamSx3("E2_VALOR")[1] )
	TRCell():New( oSection2,"SALDO" 		,"   ",STR0038+CHR(13)+CHR(10) + STR0037,,TamSX3("E1_VALOR")[1]+10,,,,,"CENTER")//,,,"RIGHT",,"RIGHT")
	//TRCell():New( oSection2,"SALDO" 		,"   ",Alltrim(STR0064)							,				,TamSx3("E2_VLCRUZ")[1]	,.F.,		,,,"RIGHT") //"SALDO ATUAL"
	//Nain T Adicionado para sacar días de mora
	TRCell():New( oSection2,"VENCTO"	,"SE1","Obs."/*X3Titulo*/	,/*Picture*/,/*Tamanho*/20,/*lPixel*/)
	//TRCell():New( oSection2,"VENCTO" 		,"   ","Obs."/*X3Titulo*/	,,TamSX3("E1_NUM")[1]/*Picture*/,/*Tamanho*/10,/*lPixel*/)
	oReport:SetCustomText( {|| CabecPak(oReport) })   // Esta funcion edita la cabecera
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintºAutor  ³Paulo Augusto       º Data ³  21/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de impressao                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint( oReport )
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oSection1:Section(1)
	Local lAgregSEK := .F., cLoja
	Local _aOrdem    := {}                // Ordem do Relatorio

	Local _nOrden    := 1                 // [8] Ordem a ser selecionada

	Local aTipDoc  := { { "FT ", "FT" }, { "NF ", "FT" }, { "NCC", "NC" }, ;
	{ "NDC", "ND" } }
	Local nDebCli  := 0
	Local nCredCli := 0
	Local nCredNahim := 0 // Nahim Nuevo
	Local nDebNahim := 0 // Nahim Nuevo
	Local nSalAC   := 0
	Local nTotDeb  := 0
	Local nTotCred := 0
	Local nTotMO   := 0
	Local nRecno   := 0
	local nTotSaldo := 0
	Local aFields  := Array( 0 )
	Local cDbfTmp
	Local cNtxTmp
	Local cSerie
	Local cRecibo
	Local nOrdSe1
	Local nRecSe1
	Local cTipo
	Local nPosTp
	Local cFiltro	:=	oSection1:GetAdvPlExp('SA1')
	Local nMoeda:= mv_par13
	Local nElMoeda := 0
	Local	nTx := 0
	Local lShow	:= .F.
	Local aRecOri := {,,,,,,,,,}
	Local lNewRec := .F.
	Local bBlock
	Private nDecs := MsDecimais(1)
	Private cCodCli  := Space( 0 )
	Private cCliente := Space( 0 )
	Private cTelef   := Space( 0 )
	Private cContact := Space( 0 )
	Private nQtMoedas:= Moedfin()
	Private aTaxa	 := Array(nQtMoedas)

	//Aviso("Array IVA",u_zArrToTxt(aTaxa, .T.),{'ok'},,,,,.t.)

	If MV_PAR14 == 1
		bBlock := {|| !EMPTY(E1_RECIBO)}
	ElseIf MV_PAR14 == 2

		bBlock := {|| EMPTY(E1_RECIBO)}
	Else
		bBlock := {|| .T.}
	EndIf

	Pergunte("FIR13X",.F.)
	If !Empty(oReport:uParam)
		Pergunte(oReport:uParam,.F.)
	EndIf
	//oReport:SetTitle(OemToAnsi(STR0003) + OemToAnsi(STR0041)  + GetMv("MV_MOEDA"+LTrim(Str(MV_PAR13))))
	If MV_PAR05==2 // nahim 2 significa RESUMEN
		oReport:SetTitle(OemToAnsi(STR0003) + OemToAnsi(STR0041)  + GetMv("MV_MOEDA"+LTrim(Str(MV_PAR13))) + " - Resumen")
	else //analitico
		oReport:SetTitle(OemToAnsi(STR0003) + OemToAnsi(STR0041)  + GetMv("MV_MOEDA"+LTrim(Str(MV_PAR13))) + " - Detalle")
	endif

	AAdd( aFields, { "CODCLI",    "C", TamSX3('A1_COD')[1], 0 } )
	AAdd( aFields, { "LOJA"	,    	"C", TamSX3('A1_LOJA')[1], 0 } )
	AAdd( aFields, { "CLIENTE",   "C", 35, 0 } )
	AAdd( aFields, { "TIPODOC",   "C",  2, 0 } )
	AAdd( aFields, { "SERIE",     "C",  3, 0 } )
	AAdd( aFields, { "NRODOC",    "C", 13 + 8, 0 } ) // nahim modificando
	AAdd( aFields, { "NUMLIQ",    "C", 13, 0 } )
	AAdd( aFields, { "FECHA",     "D",  8, 0 } )
	AAdd( aFields, { "FECVTO",    "D",  8, 0 } )
	AAdd( aFields, { "CREDITO",   "N", 15, 2 } )
	AAdd( aFields, { "DEBITO",    "N", 15, 2 } )
	AAdd( aFields, { "SALDO",     "N", 15, 2 } )
	AAdd( aFields, { "TIPSAL",    "C",  1, 2 } )
	AAdd( aFields, { "TELEFONOS", "C", 40, 0 } )
	AAdd( aFields, { "RECIBO", "C", 40, 0 } )
	AAdd( aFields, { "CONTACTO",   "C", 40, 0 } )
	AAdd( aFields, { "NODIA"	 , "C", 10, 0 } )
	AADD( aFields, { "VENCTO"  ,   "C", 20, 0 } )

	cDbfTmp := CriaTrab( aFields, .t. ) + GetDBExtension()
	cNtxTmp := CriaTrab( , .f. ) + OrdBagExt()

	IF !Empty( Select( "TRB" ) )
		DbSelectArea( "TRB" )
		DbCloseArea()
	ENDIF

	FErase( cNtxTmp )

	DbUseArea( .T., __cRDDNTTS, cDbfTmp, "TRB", .f., .f. )
	DbCreateIndex( cNtxTmp, "CODCLI+TIPODOC+SERIE+NRODOC", { || CODCLI+TIPODOC+SERIE+NRODOC }, .f. )

	SE5->(DbSetOrder(7))
	DbSelectArea( "SA1" )
	DbSetOrder( 1 )

	DbSelectArea( "SE1" )
	DbSetOrder( 2 )

	If mv_par08 == 2
		oSection1:SetPageBreak()
	endif
	IF !Empty( mv_par01 )
		DbSeek( xFilial( "SE1" ) + mv_par01, .T. )
	ELSE
		DbSeek(xFilial())
	ENDIF

	WHILE !EoF() .AND. E1_FILIAL == xFilial() .AND. E1_CLIENTE <= mv_par02

		DbSelectArea( "SA1" )
		DbSeek( xFilial( "SA1" ) + SE1->E1_CLIENTE + SE1->E1_LOJA )
		If !Empty(cFiltro) .And. !(&(cFiltro))
			DbSelectArea( "SE1" )
			DbSkip()
			Loop
		Endif
		DbSelectArea( "SE1" )
		/*
		If  cPaisLoc<>"BRA" .And. MV_PAR13 == SE1->E1_MOEDA   .And. MV_PAR13 == SE1->E1_MOEDA  .And. MV_PAR12 == 1 .And. MV_PAR12 == 1
		dbSkip()
		Loop
		Endif
		*/
		//Ao extrair o relatório em moeda 2 não deve exibir os títulos oriundos de variação cambial (FINA074)
		If nMoeda == 2 .And. Upper(AllTrim(E1_ORIGEM)) $ 'FINA074'
			dbSkip()
			Loop
		EndIf

		IF !SubStr(Alltrim(E1_TIPO), 1, 2 ) $ "TF-CH-EF" .And. E1_EMISSAO <= dDataBase .AND. (UPPER(AllTrim(E1_ORIGEM)) $ 'MATA467N#MATA465N#FINA074#FINA096#MATA460' .or. Eval(bBlock)).And. IIf(mv_par06 != 1,E1_SALDO > 0,.T.)
			If ((Alltrim(E1_TIPO) $ MV_CRNEG+"|"+MVRECANT) .And. Alltrim(E1_ORIGEM)<>"FINA087A".And. Alltrim(E1_ORIGEM)<>"FINA840") .or. !(Alltrim(E1_TIPO) $ MV_CRNEG+"|"+MVRECANT)
				cCodCli  := SA1->A1_COD
				cCliente := SA1->A1_NOME
				cTelef   := SA1->A1_TEL
				cContact := SA1->A1_CONTATO

				IF ( mv_par10 < 2 .AND. E1_EMISSAO < Min(mv_par03,dDatabase) ) .OR.;
				( mv_par10 > 1 .AND. E1_VENCREA < mv_par03 )

					DbSelectArea( "TRB" )

					IF !DbSeek( SE1->E1_CLIENTE+"SA")

						TRB->( DbAppend() )
						TRB->CODCLI    := cCodCli
						TRB->LOJA      := SA1->A1_LOJA
						TRB->CLIENTE   := cCliente
						TRB->TELEFONOS := cTelef
						TRB->CONTACTO  := cContact
						TRB->TIPODOC   := "SA"
						TRB->FECHA     := mv_par03 - 1

					ENDIF

					DbSelectArea( "SE1" )
					// nahim debug 1
					IF E1_TIPO $ MV_CRNEG .OR. SubStr( E1_TIPO, 3, 1 ) == "-"
						TRB->CREDITO := TRB->CREDITO + xMoeda(E1_VALOR - E1_DESCONT,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0))

						TRB->SALDO   := TRB->SALDO -   xMoeda(E1_SALDO - E1_DESCONT,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0))
					ELSEIF (Alltrim(E1_TIPO) <> Alltrim(GetMV("MV_SIMB1") )) .and. EMPTY(E1_NUMLIQ)
						TRB->DEBITO  := TRB->DEBITO  + xMoeda(E1_VALOR,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0))
						TRB->SALDO   := TRB->SALDO   + xMoeda(E1_SALDO,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2 ,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0))
					ELSEIF !EMPTY(E1_NUMLIQ)
						TRB->NUMLIQ	 := E1_NUMLIQ
						TRB->DEBITO  := TRB->DEBITO + xMoeda(E1_VALOR,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0))
						TRB->SALDO   := TRB->SALDO + xMoeda(E1_SALDO,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2 ,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0))
					ENDIF
					LeBaixaMfatur(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))
					DbSelectArea( "SE1" )
				ELSEIF (Alltrim(E1_TIPO) <> Alltrim(GetMV("MV_SIMB1") ))

					IF ( mv_par10 < 2 .AND. E1_EMISSAO <= mv_par04 ) .OR.;
					( mv_par10 > 1 .AND. E1_VENCREA <= mv_par04 )

						TRB->( DbAppend() )
						TRB->CODCLI    := cCodCli
						TRB->LOJA      := SA1->A1_LOJA
						TRB->CLIENTE   := cCliente
						TRB->TELEFONOS := cTelef
						TRB->CONTACTO  := cContact

						DbSelectArea( "SE1" )
						cTipo 	:= SE1->E1_TIPO
						nPosTp	:=	AScan( aTipDoc, { |a| a[1] == E1_TIPO })
						//            		AScan( aTipDoc, { |a| If( a[1] == E1_TIPO, cTipo := a[2], ) } )
						cTipo	:=	IIf(nPosTp	>	0	, aTipDoc[nPosTp][2],cTipo)
						TRB->SERIE   := AllTrim( E1_PREFIXO )
						TRB->NRODOC  := E1_NUM
						TRB->FECHA   := E1_EMISSAO
						TRB->FECVTO  := E1_VENCREA
						TRB->TIPODOC := cTipo
						TRB->TIPSAL  := If (Alltrim(E1_TIPO) $ MV_CRNEG+"|"+MVRECANT .Or. Substr(Alltrim(E1_TIPO), 3, 1 ) == "-", "A", "D")

						If cPaisLoc =="PTG"
							TRB->NODIA  := E1_NODIA
						Endif

						//Nain T. Adicionado para tener los días de mora
						//					Alert("2 SE1->E1_NUM"+SE1->E1_NUM)
						//					alert("Ven"+Str(dDataBase-SE1->E1_VENCTO,4))
						If SE1->E1_SALDO > 0.00
							If SE1->E1_VENCTO == dDataBase
								TRB->VENCTO := cvaltochar(0) //OemToAnsi(STR0022)  // "Vence HOY"
							ElseIf SE1->E1_VENCTO < dDataBase.And.!Empty(SE2->E2_VENCTO )
								TRB->VENCTO := cvaltochar(Str(dDataBase-SE1->E1_VENCTO,4)) //+ OemToAnsi(STR0023)  // " dias de atraso"
							Else
								//							TRB->VENCTO := Dtoc(SE1->E1_VENCTO)
							Endif
						Else
							//						TRB->VENCTO := "Cobrado el:" + Dtoc(SE1->E1_BAIXA) // "Cobrado el "
						Endif
						// nahim debug 2
						If TRB->TIPSAL == "A"

							TRB->SALDO     := xMoeda(E1_SALDO,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0) )  * -1
							TRB->CREDITO   := xMoeda(E1_VALOR,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0) )
						Elseif EMPTY(E1_NUMLIQ)
							TRB->SALDO     := xMoeda(E1_SALDO,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0) )
							TRB->DEBITO    := xMoeda(E1_VALOR,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0) )
						Elseif !EMPTY(E1_NUMLIQ)

							TRB->NUMLIQ		:= E1_NUMLIQ
							TRB->SALDO     := xMoeda(E1_SALDO,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0) )
							TRB->DEBITO    := xMoeda(E1_VALOR,E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0))
						Endif

						LeBaixaMfatur(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))
						DbSelectArea( "SE1" )
					ENDIF
				ENDIF
			EndIf
		ENDIF

		DbSkip()

	ENDDO

	DbSelectArea( "SEL" )
	DbSetOrder( 3 )

	IF !Empty( mv_par01 )
		DbSeek( xFilial( "SEL") +  mv_par01, .T. )
	ELSE
		DbSeek(xFilial())
	ENDIF

	WHILE MV_PAR14 != 2 .and. !EoF() .AND. EL_FILIAL == xFilial("SEL") .AND.  EL_CLIENTE  <=  mv_par02

		DbSelectArea( "SA1" )
		DbSeek( xFilial( "SA1" ) + SEL->EL_CLIENTE + SEL->EL_LOJA )
		If !Empty(cFiltro) .And. !(&(cFiltro))
			DbSelectArea( "SEL" )
			DbSkip()
			Loop
		Endif

		DbSelectArea( "SEL" )

		cCodCli  := SA1->A1_COD
		cCliente := SA1->A1_NOME

		If EL_DTDIGIT > dDataBase
			DbSkip()
			Loop
		Endif

		If !VerAtu()
			DbSkip()
			Loop
		EndIf

		IF EL_DTDIGIT < mv_par03

			IF !EL_CANCEL

				DbSelectArea( "TRB" )

				IF !DbSeek( SEL->EL_CLIENTE+"SA", .F. )

					TRB->( DbAppend() )
					TRB->CODCLI    := cCodCli
					TRB->LOJA      := SA1->A1_LOJA
					TRB->CLIENTE   := cCliente
					TRB->TIPODOC   := "SA"
					TRB->FECHA     := mv_par03 - 1
					TRB->TELEFONOS := SA1->A1_TEL
					TRB->CONTACTO  := SA1->A1_ENDREC

				ENDIF

				DbSelectArea( "SEL" )

				cRecibo := EL_RECIBO
				cSerRec := EL_SERIE

				WHILE !EoF() .AND. xFilial( "SEL" ) == EL_FILIAL .AND. EL_RECIBO == cRecibo .AND. EL_SERIE == cSerRec

					nElMoeda := SEL->EL_TXMOEDA
					For nTx := 2 to Len(aTaxa)
						If Val( SEL->EL_MOEDA ) == nTx
							nElMoeda := SEL->&("EL_TXMOE"+StrZero(nTx,2))
						EndIf
					Next

					IF EL_TIPODOC $ "TB/RA" .AND. !EL_CANCEL
						If (Alltrim(EL_TIPO) $ "RA "+MV_CPNEG.And.EL_TIPODOC <> "RA") // debug 5 Nahim
							TRB->CREDITO := TRB->CREDITO - xMoeda(EL_VALOR,Val(SEL->EL_MOEDA),nMoeda,IIf(MV_PAR12 == 2, SEL->EL_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(nElMoeda>0,nElMoeda,RecMoeda(SEL->EL_EMISSAO,Val(SEL->EL_MOEDA))),0)  )
						ElseIf (Alltrim(EL_TIPO) $ "NCC ")
							TRB->DEBITO :=  TRB->DEBITO  + xMoeda(EL_VALOR,Val(SEL->EL_MOEDA),nMoeda,IIf(MV_PAR12 == 2, SEL->EL_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(nElMoeda>0,nElMoeda,RecMoeda(SEL->EL_EMISSAO,Val(SEL->EL_MOEDA))),0)  )
						Else
							TRB->CREDITO := TRB->CREDITO + xMoeda(EL_VALOR,Val(SEL->EL_MOEDA),nMoeda,IIf(MV_PAR12 == 2, SEL->EL_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(nElMoeda>0,nElMoeda,RecMoeda(SEL->EL_EMISSAO,Val(SEL->EL_MOEDA))),0)  )
						Endif

						If EL_TIPODOC == "RA"
							nOrdSE1  := SE1->(IndexOrd())
							nRecSE1  := SE1->(Recno())
							SE1->(DbSetOrder(2))
							If SE1->(DbSeek(xFilial()+SEL->(EL_CLIENTE+EL_LOJA+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO)))
								TRB->SALDO := TRB->SALDO -  xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, SE1->E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)  )
							Endif
							SE1->(DbSetOrder(nOrdSE1))
							SE1->(DbGoTo(nRecSE1))
						Endif
					ENDIF

					DbSkip()

				ENDDO
				If TRB->CREDITO > TRB->DEBITO
					TRB->TIPSAL := "A"
				Else
					TRB->TIPSAL := "D"
				Endif

			ELSE
				DbSkip()

			ENDIF

		ELSE

			IF EL_DTDIGIT <= mv_par04 .AND. !EL_CANCEL  .and.  MV_PAR05 == 2 // nahim para que no sume resumido

				aRecOri[01]	:= cCodCli
				aRecOri[02]	:= cCliente
				aRecOri[03]	:= SEL->EL_SERIE
				aRecOri[04]	:= If(!Empty(Val(SEL->EL_RECIBO)),StrZero(Val(SEL->EL_RECIBO),12),SEL->EL_RECIBO)
				aRecOri[05]	:= SEL->EL_DTDIGIT
				aRecOri[06]	:= SEL->EL_DTDIGIT
				aRecOri[07]	:= "RG"
				aRecOri[08]	:= "A"
				aRecOri[09]	:=	SA1->A1_TEL
				aRecOri[10]	:= SA1->A1_ENDREC
				DbSelectArea( "TRB" )

				DbSelectArea( "SEL" )
				cRecibo := EL_RECIBO
				cSerrec := EL_SERIE
				WHILE !EoF() .AND. xFilial( "SEL" ) == EL_FILIAL .AND. EL_RECIBO == cRecibo.AND. EL_SERIE == cSerRec

					nElMoeda := SEL->EL_TXMOEDA
					For nTx := 2 to Len(aTaxa)
						If Val( SEL->EL_MOEDA ) == nTx
							nElMoeda := SEL->&("EL_TXMOE"+StrZero(nTx,2))
						EndIf
					Next

					IF EL_TIPODOC $ "TB/RA" .AND. !EL_CANCEL
						If	mv_par06 != 1 //Imprime saldo zero 'Não'
							If SE1->(DbSeek(xFilial("SE1")+SEL->(EL_CLIORIG+EL_LOJORIG+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO)))
								If SE1->E1_SALDO > 0
									lNewRec := .T.
								Else
									lNewRec := .F.
								EndIf
							Else
								lNewRec := .T.
							EndIf
						Else
							lNewRec := .T.
						EndIf

						If lNewRec
							DbSelectArea( "TRB" )

							TRB->( DbAppend() )
							TRB->CODCLI    := aRecOri[01]
							TRB->CLIENTE   := aRecOri[02]
							TRB->SERIE     := aRecOri[03]
							TRB->NRODOC    := aRecOri[04]
							TRB->FECHA     := aRecOri[05]
							TRB->FECVTO    := aRecOri[06]
							TRB->TIPODOC   := aRecOri[07]
							TRB->TIPSAL    := aRecOri[08]
							TRB->TELEFONOS := aRecOri[09]
							TRB->CONTACTO  :=	aRecOri[10]

							DbSelectArea("SEL")
						Else
							DbSkip()
							Loop
						EndIf
						// nahim debug 3
						If (Alltrim(EL_TIPO) $ "RA "+MV_CPNEG.And.EL_TIPODOC <> "RA")
							TRB->CREDITO := TRB->CREDITO - xMoeda(EL_VALOR,Val(SEL->EL_MOEDA),nMoeda,IIf(MV_PAR12 == 2, SEL->EL_EMISSAO, Nil),,Iif(MV_PAR12 == 2,Iif(nElMoeda>0,nElMoeda,RecMoeda(SEL->EL_EMISSAO,Val(SEL->EL_MOEDA))),0)  )
						ElseIf (Alltrim(EL_TIPO) $ "NCC ")
							TRB->DEBITO := TRB->DEBITO + xMoeda(EL_VALOR,Val(SEL->EL_MOEDA),nMoeda,IIf(MV_PAR12 == 2, SEL->EL_EMISSAO, Nil),,Iif(MV_PAR12 == 2,Iif(nElMoeda>0,nElMoeda,RecMoeda(SEL->EL_EMISSAO,Val(SEL->EL_MOEDA))),0)  )
						Else
							TRB->CREDITO := TRB->CREDITO + xMoeda(EL_VALOR,Val(SEL->EL_MOEDA),nMoeda,IIf(MV_PAR12 == 2, SEL->EL_EMISSAO, Nil),,Iif(MV_PAR12 == 2,Iif(nElMoeda>0,nElMoeda,RecMoeda(SEL->EL_EMISSAO ,Val(SEL->EL_MOEDA))),0)  )
						Endif                           // xMoeda(EL_VALOR,Val(SEL->EL_MOEDA),nMoeda,IIf(MV_PAR12 == 2, SEL->EL_EMISSAO, Nil),,Iif(MV_PAR12 == 2,Iif(nElMoeda>0,nElMoeda,RecMoeda(SEL->EL_EMISSAO ,Val(SEL->EL_MOEDA))),0)  )

						IF EL_TIPODOC == "RA"
							nOrdSE1   := SE1->(IndexOrd())
							nRecSE1  := SE1->(Recno())
							SE1->(DbSetOrder(2))
							If SE1->(DbSeek(xFilial()+SEL->(EL_CLIENTE+EL_LOJA+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO)))
								TRB->SALDO := TRB->SALDO - xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,nMoeda,IIf(MV_PAR12 == 2, SE1->E1_EMISSAO, Nil ),,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)  )
							Endif
							SE1->(DbSetOrder(nOrdSE1))
							SE1->(DbGoTo(nRecSE1))
						Endif
					ENDIF

					DbSkip()

				ENDDO

			ELSE

				DbSkip()

			ENDIF

		ENDIF

	ENDDO

	DbSelectArea( "TRB" )
	DbClearIndex()
	FErase( cNtxTmp )

	IF mv_par07 < 2
		IF mv_par10 < 2
			DbCreateIndex( cNtxTmp, "CODCLI+DTOS(FECHA)+TIPODOC+SERIE+NRODOC", ;
			{ || CODCLI+DTOS(FECHA)+TIPODOC+SERIE+NRODOC }, .f. )
		ELSE
			DbCreateIndex( cNtxTmp, "CODCLI+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC", ;
			{ || CODCLI+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC }, .f. )
		ENDIF
	ELSE
		IF mv_par10 < 2
			DbCreateIndex( cNtxTmp, "CLIENTE+DTOS(FECHA)+TIPODOC+SERIE+NRODOC", ;
			{ || CODCLI+DTOS(FECHA)+TIPODOC+SERIE+NRODOC }, .f. )
		ELSE
			DbCreateIndex( cNtxTmp, "CLIENTE+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC", ;
			{ || CODCLI+DTOS(FECVTO)+TIPODOC+SERIE+NRODOC }, .f. )
		ENDIF
	ENDIF

	DbSelectArea("TRB")
	DbGoTop()

	oReport:SetMeter(TRB->( RecCount() ) + 1)
	If MV_PAR05==2 // nahim 2 significa RESUMEN
		oSection2:Cell("E1_TIPO"):Disable()
		oSection2:Cell("E1_EMISSAO"):Disable()
		oSection2:Cell("E1_VENCREA"):Disable()
		oSection2:Cell("E1_RECIBO"):Disable()
		//	oSection2:Cell("E1_EMISSAO"):Disable()
		oSection2:Cell("E1_NUM"):SetTitle(" ")
		oSection2:Cell("E1_RECIBO"):SetTitle(" ")
		//	oSection2:Cell("SALDOINI"):SetTitle(" ")
		oSection2:Cell("VENCTO"):SetTitle(" ")
		oSection1:Disable()

		//	oSection1:Cell("A1_NOME"):Disable()
		//TRCell():New( oSection1, "A1_COD" 	,"SA1",/*X3Titulo*/	,/*Picture*/,TamSX3("A1_COD")[1]+TamSx3("A1_LOJA")[1]+2,/*lPixel*/,)
		//TRCell():New( oSection1, "A1_NOME"	,"SA1",/*X3Titulo*/	,/*Picture*/,TamSX3("A1_NOME")[1]/*Tamanho*/,/*lPixel*/,)
	else
		oSection2:Cell("SALDOINI"):Disable()
		oSection2:Cell("SALDOINI"):SetTitle(" ")
	EndIf

	oSection1:SetHeaderPage(.F.)
	oSection2:SetHeaderPage(.F.)
	lpaso := .f.
	WHILE !EoF()

		//	oSection2:Cell("A1_COD"):SetTitle("nahimCOD")
		cCodCli  := CODCLI
		cCliente := AllTrim( CLIENTE )
		cTelef   := AllTrim( TELEFONOS )
		cContact := AllTrim( CONTACTO )
		cNahCodCli := TRB->CODCLI
		cNahnomCli := TRB->CLIENTE

		oSection1:Init()
		If MV_PAR05==1 // nahim 2 significa RESUMEN
			oSection1:Cell("A1_COD"):SetBlock({|| TRB->CODCLI  })
			oSection1:Cell("A1_NOME"):SetBlock({|| TRB->CLIENTE})
			oSection2:Cell("VENCTO"):SetBlock({|| TRB->VENCTO})

		endif
		// nahim modificando para resumen
		oSection1:PrintLine()
		oReport:SkipLine()
		oSection1 :Finish()
		oSection2:Init()
		// nahim adicionado para imprimir un solo titulo
		If MV_PAR05==2 // nahim 2 significa RESUMEN
			if lpaso
				oSection2:Cell("A1_NOME"):SetTitle("                ")
				oSection2:Cell("A1_COD"):SetTitle("                ")
				oSection2:Cell("DEBITO"):SetTitle("                ")
				oSection2:Cell("CREDITO"):SetTitle("                ")
				oSection2:Cell("SALDO"):SetTitle("                ")
				oSection2:Cell("E1_RECIBO"):SetTitle("                ")
			else
				lpaso := .T.
			endif
		endif
		WHILE !EoF() .AND. CODCLI ==  cCodCli
			If MV_PAR05==2 // nahim 2 significa RESUMEN
				oSection2:Cell("A1_COD"):SetBlock({||cNahCodCli })
				oSection2:Cell("A1_NOME"):SetBlock({|| cNahnomCli})
			endif

			If MV_PAR05 == 2 .And. MV_PAR11 == 1 .AND. EMPTY(TRB->NUMLIQ)	// Resumido e Com Saldo Inicial
				If TIPODOC <> "SA"
					nCredCli := nCredCli + CREDITO
					nDebCli  := nDebCli  + DEBITO
					nTotCred := nTotCred + CREDITO
					nTotDeb  := nTotDeb  + DEBITO
				Endif
				If TIPODOC == "SA"
					nCredNahim := nCredNahim + CREDITO
					nDebNahim  := nDebNahim + DEBITO
				Endif
				
				If oReport:nDevice == IMP_EXCEL
					oSection2:Cell("SALDOINI"):SetBlock({||nDebNahim - nCredNahim})
				else
					oSection2:Cell("SALDOINI"):SetBlock({||Transform( nDebNahim - nCredNahim , PesqPict("SE1","E1_VALOR"))})
				endif
			ElseIF EMPTY(TRB->NUMLIQ)
				//			alert("NASJK")
				nCredCli := nCredCli + CREDITO
				nDebCli  := nDebCli  + DEBITO
				nTotCred := nTotCred + CREDITO
				nTotDeb  := nTotDeb  + DEBITO

			Endif

			IF EMPTY(TRB->NUMLIQ)
				nSalAC   := nSalAC   + (DEBITO - CREDITO)
				nTotMO   := nTotMO   + SALDO
			Endif
			IF mv_par05 == 1 // .AND. !Empty( VALOR ) COMIENZA ANALITICO
				DbSelectArea("TRB")
				// nahim validar aqui
				If TIPODOC == "SA"
					oSection2:Cell("E1_NUM"):SetBlock({||OemToAnsi(STR0012) })
					//				oSection2:Cell("E1_EMISSAO"):SetBlock({||TRB->FECHA }) // nahim validando
					oSection2:Cell("E1_RECIBO"):SetBlock({||  TRB->RECIBO})
				Else
					oSection2:Cell("E1_RECIBO"):SetBlock({|| TRB->RECIBO})
					oSection2:Cell("E1_TIPO"):SetBlock({||TRB->TIPODOC })
					IF !Empty(TRB->NUMLIQ)
						oSection2:Cell("E1_NUM"):SetBlock({||TRB->NRODOC})
						//					oSection2:Cell("E1_NUM"):SetBlock({||transform(TRB->NRODOC+"/LIQ", Iif(TRB->TIPODOC='RC',PesqPict('SEL','EL_RECIBO'),PesqPict('SE1','E1_NUM')))})
					ELSE
						//					oSection2:Cell("E1_NUM"):SetBlock({||transform(TRB->NRODOC, Iif(TRB->TIPODOC='RC',PesqPict('SEL','EL_RECIBO'),PesqPict('SE1','E1_NUM')))})
						oSection2:Cell("E1_NUM"):SetBlock({||TRB->NRODOC})
					ENDIF
					oSection2:Cell("E1_EMISSAO"):SetBlock({||OemToAnsi(STR0012) })
					oSection2:Cell("E1_VENCREA"):SetBlock({||TRB->FECVTO })
					oSection2:Cell("E1_EMISSAO"):SetBlock({||TRB->FECHA })
					If cPaisLoc == "PTG"
						oSection2:Cell("NODIA"):SetBlock({||TRB->NODIA })
					Endif
				Endif
				if TRB->TIPODOC == "SA" .or. TRB->TIPODOC == "NF" // Nahim adicion para que muestr debito credito
					oSection2:Cell("E1_NUM"):SetBlock({||OemToAnsi(STR0012) })
					oSection2:Cell("E1_RECIBO"):SetBlock({||  ""})
					oSection2:Cell("E1_VENCREA"):SetBlock({||""})
					oSection2:Cell("DEBITO"):SetBlock({||TRB->DEBITO })
					oSection2:Cell("CREDITO"):SetBlock({||TRB->CREDITO})

				endif

				If TIPODOC == "RC" .And. CREDITO > 0 .And. DEBITO > 0
					If oReport:nDevice == IMP_EXCEL
						oSection2:Cell("DEBITO"):SetBlock({||TRB->DEBITO })
						oSection2:Cell("CREDITO"):SetBlock({||TRB->CREDITO})
					Else
						oSection2:Cell("DEBITO"):SetBlock({|| Transform( TRB->DEBITO, PesqPict("SE1","E1_VALOR")) })
						oSection2:Cell("CREDITO"):SetBlock({||Transform( TRB->CREDITO, PesqPict("SE1","E1_VALOR"))})
					ENDIF
				Else
					//				Alert("6. SE1->E1_NUM-"+SE1->EL_TIPODOC+"-"+SE1->E1_NUM)

					IF DEBITO > 0
						If oReport:nDevice == IMP_EXCEL
							oSection2:Cell("DEBITO"):SetBlock({||TRB->DEBITO })
						else
							oSection2:Cell("DEBITO"):SetBlock({||Transform( TRB->DEBITO, PesqPict("SE1","E1_VALOR"))  })
						ENDIF
						//					oSection2:Cell("CREDITO"):Hide()
					ENDIF

					IF CREDITO > 0
						If oReport:nDevice == IMP_EXCEL
							oSection2:Cell("CREDITO"):SetBlock({||TRB->CREDITO})
						else
							oSection2:Cell("CREDITO"):SetBlock({||Transform( TRB->CREDITO, PesqPict("SE1","E1_VALOR"))})
						ENDIF
						//					oSection2:Cell("DEBITO"):Hide()

					Endif
				EndIf
				If oReport:nDevice == IMP_EXCEL
					oSection2:Cell("SALDO"):SetBlock({||nSalAC})
				ELSE
					oSection2:Cell("SALDO"):SetBlock({|| transform(nSalAC,PesqPict('SE1','E1_VALOR')) })
				EndIf

				oSection2:PrintLine()

				oSection2:Cell("CREDITO"):Show()
				oSection2:Cell("DEBITO"):Show()
			ENDIF // termina ANALITICO

			DbSkip()
			oReport:IncMeter()

		ENDDO

		IF ( mv_par06 < 2 .OR. IIf(MV_PAR01 == MV_PAR02,.F.,cCodCli <> CODCLI) ) .AND. mv_par09 == 1

			cDisp := cTelef + " - " + cContact

			If nSalAc != 0 .Or. mv_par06 == 1
				IF mv_par05 < 2
					oReport:ThinLine()
					oReport:SkipLine()

					oReport:PrintText(OemToAnsi(STR0010) + cCodCli + " (" + Left( cDisp, 40 ) + ")" )
				ELSE
					// nahim quitando impresion de linha
					//quitando Nahim		oReport:PrintText( cCodCli  +  "  " + cCliente + " (" +  Left( cDisp, 40 ) + ")"  )
				ENDIF
			EndIf

			//		oSection2:Cell("E1_EMISSAO"):disable() // nahim ultimo cambio
			oSection2:Cell("E1_EMISSAO"):hide()
			oSection2:Cell("E1_TIPO"):Hide()
			oSection2:Cell("E1_NUM"):Hide()
			oSection2:Cell("E1_VENCREA"):Hide()

			if MV_PAR05 == 1 // analitico
				/*oSection2:Cell("E1_EMISSAO"):SetTitle("                ")
				oSection2:Cell("E1_TIPO"):SetTitle("                ")
				oSection2:Cell("E1_NUM"):SetTitle("                ")
				oSection2:Cell("E1_VENCREA"):SetTitle("                ")
				oSection2:Cell("DEBITO"):SetTitle("                ")
				oSection2:Cell("CREDITO"):SetTitle("                ")
				oSection2:Cell("SALDO"):SetTitle("                ")
				//			oSection2:Cell("SALDOINI"):SetTitle("                ")
				oSection2:Cell("E1_RECIBO"):SetTitle("                ")
				oSection2:Cell("VENCTO"):SetTitle("                ")	*/
			endif

			If oReport:nDevice == IMP_EXCEL
				nTotSaldo   := nTotSaldo + nSalAC
				oSection2:Cell("DEBITO"):SetBlock({||nDebCLi})
				oSection2:Cell("CREDITO"):SetBlock({||nCredCli})
				oSection2:Cell("SALDO"):SetBlock({||nSalAC})   //aqui entra
			Else
				nTotSaldo   := nTotSaldo + nSalAC
				oSection2:Cell("DEBITO"):SetBlock({|| Transform(nDebCLi, PesqPict("SE1","E1_VALOR")) })
				oSection2:Cell("CREDITO"):SetBlock({|| Transform(nCredCli, PesqPict("SE1","E1_VALOR")) })
				oSection2:Cell("SALDO"):SetBlock({||transform(nSalAC,PesqPict('SE1','E1_VALOR')) })
			EndIf
			If nSalAc == 0 .And. mv_par06 == 2
				oSection2:Cell("DEBITO"):Hide()
				oSection2:Cell("CREDITO"):Hide()
				oSection2:Cell("SALDO"):Hide()
				lShow := .T.
			EndIf

			//		oSection2:Cell("E1_EMISSAO"):Show()
			oSection2:PrintLine()
			oSection2:Cell("E1_TIPO"):Show()
			oSection2:Cell("E1_NUM"):Show()
			oSection2:Cell("E1_VENCREA"):Show()
			oSection2:Cell("E1_EMISSAO"):Show()
			If cPaisLoc == "PTG"
				oSection2:Cell("NODIA"):Show()
			Endif

			IF mv_par05 < 2
				//			oReport:ThinLine()
				oReport:SkipLine()
			ENDIF
			If lShow
				oSection2:Cell("DEBITO"):Hide()
				oSection2:Cell("CREDITO"):Hide()
				oSection2:Cell("SALDO"):Show()
				lShow := .F.
			EndIf

			nDebCli  := 0
			nCredCli := 0
			nSalAC   := 0
			nCredNahim := 0
			nDebNahim := 0
		ENDIF
		oSection2 :Finish()
	ENDDO

	IF  mv_par09 == 1 //entra aqui normal

		oSection2:Init()
		If cPaisLoc == "PTG"  //portugal
			oSection2:Cell("NODIA"):Hide()
		Endif
		oSection2:Cell("E1_EMISSAO"):Hide()
		oSection2:Cell("E1_TIPO"):Hide()
		oSection2:Cell("E1_VENCREA"):Hide()
		oSection2:Cell("E1_EMISSAO"):Hide()
		oSection2:Cell("E1_NUM"):Hide()

		If oReport:nDevice == IMP_EXCEL
			//alert(nTotCred)   								//aqui trae el valor del credito total al final
			oSection2:Cell("DEBITO"):SetBlock({||nTotDeb})
			oSection2:Cell("CREDITO"):SetBlock({||nTotCred})
			oSection2:Cell("SALDO"):SetBlock({||nTotSaldo})

			If MV_PAR05==2 // nahim 2 significa RESUMEN
				oSection2:Cell("A1_COD"):SetBlock({||" "})
				oSection2:Cell("A1_NOME"):SetBlock({|| " "})
			endif

		Else
			oSection2:Cell("A1_COD"):Hide()
			oSection2:Cell("A1_NOME"):Hide()
			oSection2:Cell("SALDOINI"):Hide()
			/*
			If MV_PAR05==2 // nahim 2 significa RESUMEN
			oSection2:Cell("A1_COD"):SetBlock({||" "})
			oSection2:Cell("A1_NOME"):SetBlock({|| " "})
			endif*/
			oSection2:Cell("A1_COD"):SetTitle("")
			oSection2:Cell("A1_NOME"):SetTitle("")
			oSection2:Cell("E1_EMISSAO"):SetTitle("")
			oSection2:Cell("E1_TIPO"):SetTitle("")
			oSection2:Cell("E1_NUM"):SetTitle("")
			oSection2:Cell("E1_VENCREA"):SetTitle("")
			oSection2:Cell("DEBITO"):SetTitle("")
			oSection2:Cell("CREDITO"):SetTitle("")
			oSection2:Cell("SALDO"):SetTitle("")
			oSection2:Cell("SALDOINI"):SetTitle("")
			oSection2:Cell("E1_RECIBO"):SetTitle("")
			oSection2:Cell("VENCTO"):SetTitle("")

			//oReport:PageTotalText(OemToAnsi(STR0011))

			oSection2:Cell("DEBITO"):SetBlock({|| Transform(nTotDeb,PesqPict('SE1','E1_VALOR'))})
			oSection2:Cell("CREDITO"):SetBlock({|| Transform(nTotCred,PesqPict('SE1','E1_VALOR')) })
			oSection2:Cell("SALDO"):SetBlock({|| transform(nTotSaldo,PesqPict('SE1','E1_VALOR')) })
			//		oSection2:Cell("SALDO"):SetBlock({|| transform(nTotDeb-nTotCred,PesqPict('SE1','E1_VALOR')) })

		EndIf
		oSection2:PrintLine()
		oReport:PrintText(OemToAnsi(STR0011),oReport:row()- 40)
		oReport:SkipLine()
		//	oReport:FatLine()
	EndIf
	TRB->( DbCloseArea() )
	FErase( cDbfTmp )
	FErase( cNtxTmp )

RETURN NIL

// Grava as baixas manuais que houverem do titulo corrente no arquivo de trabalho
Static Function LeBaixaMFatur(cChave)
	Local nMoeda:= mv_par13
	Local cSeq, nReg

	SE5->(DbSeek(xFilial("SE5") + cChave))
	While cChave== SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) ;
	.AND.  SE5->E5_MOTBX <> 'CMP' .AND. ! SE5->(EOF())
		cSeq := SE5->E5_SEQ
		nReg := SE5->(Recno())
//		If SE5->E5_TIPODOC $ "VL|CP" .And. SE5->E5_SITUACA != "C" .Or. (SE5->E5_TIPODOC == "BA" .And. SE5->E5_MOTBX $ 'CEC|NOR|DSD' ) .and.  SE5->E5_DATA >= MV_PAR03 .and. MV_PAR05 == 1 .And. SE5->E5_SITUACA != "C"// Baixa manual e baixa por compensacao entre carteiras
		If SE5->E5_TIPODOC $ "VL|CP" .And. SE5->E5_SITUACA != "C" .Or. (SE5->E5_TIPODOC == "BA" .And. SE5->E5_MOTBX $ 'CEC|NOR|DSD' ) .and.  SE5->E5_DATA >= MV_PAR03 .and. MV_PAR05 == 1 .And. SE5->E5_SITUACA != "C" .and. SE5->E5_DATA <= MV_PAR04// Nahim  validacion para tomar en cuenta fecha de baja
			SE5->(DbSkip())
			If ! (cChave+cSeq = SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) ;
			.And. SE5->E5_TIPODOC = "ES" .Or. SE5->E5_MOTBX== 'CMP')   // Nao faz nada se Houver Estorno da baixa
				SE5->(DbGoto(nReg))
				TRB->( DbAppend() )
				TRB->CODCLI    := cCodCli
				TRB->CLIENTE   := cCliente
				TRB->TELEFONOS := cTelef
				TRB->CONTACTO  := cContact // Nahim Cuando es resumen
				//                       xMoeda(E1_VALOR     ,E1_MOEDA     ,nMoeda,,,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0))
				//                       xMoeda(E1_VALOR     ,E1_MOEDA     ,nMoeda,,,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(E1_EMISSAO,E1_MOEDA)),0))
				//			TRB->Credi111to	:= Round(xMoeda(SE5->E5_VALOR,SE1->E1_MOEDA,nMoeda,,nDecs+1,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0 ) ),nDecs)
				
				//alert(SE5->E5_TIPO)
				if 'NF' $ SE5->E5_TIPO 
					TRB->Credito	:= Round(xMoeda(SE5->E5_VALOR,val(SE5->E5_MOEDA),nMoeda,,,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0 ) ),nDecs)
					//E5_SERREC E5_CLIENTE
					//alert(SE5->E5_VALOR)
					//alert(nMoeda)

					IF MV_PAR12 == 2 .AND. SE5->E5_TIPODOC == "BA" .and. nMoeda == 2
						cTxMOD02 := GetTxEL(SE5->E5_NUMERO,SE5->E5_CLIENTE,SE5->E5_ORDREC,SE5->E5_SERREC,SE5->E5_DTDIGIT,SE5->E5_FILIAL)
						//alert(cTxMOD02)
						TRB->Credito := Round(xMoeda(SE5->E5_VALOR,VAL(SE5->E5_MOEDA),nMoeda,,2,1,cTxMOD02),2)
					ENDIF
				ELSE
					TRB->Debito	:= Round(xMoeda(SE5->E5_VALOR,val(SE5->E5_MOEDA),nMoeda,,,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0 ) ),nDecs)
					IF MV_PAR12 == 2 .AND. SE5->E5_TIPODOC == "BA" .and. nMoeda == 2
						cTxMOD02 := GetTxEL(SE5->E5_NUMERO,SE5->E5_CLIENTE,SE5->E5_ORDREC,SE5->E5_SERREC,SE5->E5_DTDIGIT,SE5->E5_FILIAL)
						//alert(cTxMOD02)
						TRB->Debito := Round(xMoeda(SE5->E5_VALOR,VAL(SE5->E5_MOEDA),nMoeda,,2,1,cTxMOD02),2)
					ENDIF
				ENDIF

				TRB->TIPSAL		:= "A"
				TRB->Saldo 		:= - TRB->Credito
				TRB->NRODOC		:= alltrim(SE5->E5_NUMERO)  + IIf( !empty(alltrim(SE5->E5_SERREC)) ," - " + alltrim(SE5->E5_SERREC) ," ") + IIf( !empty(SE5->E5_PARCELA) ," - " +  SE5->E5_PARCELA ," ") // nahim validacion de nro de documento
				TRB->RECIBO := SE5->E5_ORDREC
				TRB->TIPODOC	:= SE5->E5_TIPODOC
				//ALERT(TRB->TIPODOC)   //entro
				TRB->SERIE		:= SE5->E5_PREFIXO
				TRB->FECHA		:= SE5->E5_DATA
			EndIf
			//	ElseIf SE5->E5_TIPODOC $ "JR/MT/DC/IS" .And. SE5->E5_SITUACA != "C" // Juros, Multa, Desconto, Impsubst(localiz"CHI")
		ElseIf SE5->E5_TIPODOC $ "JR/MT/IS/DC" .And. SE5->E5_SITUACA != "C" // Juros, Multa, Desconto, Impsubst(localiz"CHI")
			TRB->( DbAppend() )
			TRB->CODCLI    := cCodCli
			TRB->CLIENTE   := cCliente
			TRB->TELEFONOS := cTelef
			TRB->CONTACTO  := cContact
			If SE5->E5_TIPODOC = "DC"
				TRB->TIPSAL	:= "A"
				//			TRB->Credito	:= Round(xMoeda(SE5->E5_VALOR,SE1->E1_MOEDA,nMoeda,,nDecs+1,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0) ),nDecs)
				TRB->Credito	:= Round(xMoeda(SE5->E5_VALOR,val(SE5->E5_MOEDA),nMoeda,,,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0) ),nDecs)
				TRB->Saldo	:= - TRB->Credito
			Else
				TRB->TIPSAL	:= "D"
				//			TRB->Debito	:=     Round(xMoeda(SE5->E5_VALOR,SE1->E1_MOEDA,nMoeda,,nDecs+1,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)  ),nDecs)
				TRB->Debito	:=     Round(xMoeda(SE5->E5_VALOR,val(SE5->E5_MOEDA),nMoeda,,,Iif(MV_PAR12 == 2,Iif(SE1->E1_TXMOEDA>0,SE1->E1_TXMOEDA,RecMoeda(SE1->E1_EMISSAO,SE1->E1_MOEDA)),0)  ),nDecs)
				TRB->Saldo	:= TRB->Debito
			EndIf // nahim debug 4
			TRB->NRODOC		:= SE5->E5_NUMERO
			TRB->TIPODOC	:= SE5->E5_TIPODOC
			TRB->SERIE		:= SE5->E5_PREFIXO
			TRB->FECHA		:= SE5->E5_DATA
		EndIf
		SE5->(DbSkip())
	EndDo
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerAtu     ºAutor  ³Totvs               º Data ³  13/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o recibo está ativo                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VerAtu()

	Local lRet  := .T.
	Local aArea := GetArea()

	DbSelectArea('FJT')
	DbSetorder(1)

	If DbSeek(xFilial()+SEL->EL_SERIE+SEL->EL_RECIBO+SEL->EL_VERSAO)
		If FJT->FJT_VERATU <> '1'
			lRet := .F.
		EndIf
	EndIf

	RestArea(aArea)

Return lRet

Static Function CabecPak(oReport) // opcional, si se requiere una cabecera especifica

	Local aArea          := GetArea()
	Local aCabec     := {}
	Local cChar          := chr(160) // caracter dummy para alinhamento do cabeçalho
	Local cChar2          := chr(80) // caracter dummy para alinhamento do cabeçalho
	Local titulo     := oReport:Title()
	Local page := oReport:Page()
	If nPagntp > 0
		nPagntp++
	else
		nPagntp := 1
	EndIf
	// alert("aslkjmaslkm")
	// aCabec := {     "__LOGOEMP__" ,cChar + "        " + cChar ;
	// , " " + " " + "        " + cChar + UPPER(AllTrim(titulo)) + "        " + cChar ;
	// , "Fecha Inicial: "+ cvaltochar(MV_PAR03) + "          " + cChar + "Fecha: "+ Dtoc(dDataBase)+ cChar  ;
	// , "Fecha Final: "+ cvaltochar(MV_PAR04) +   "          " ;//+  "Grupo: "+ cvaltochar(mv_par03) ;
	// , "            " + "          " +  "Usuario: " + substr(cUsuario,7,15) ;
	// , "      " + "          " +  "      "}
	aCabec := {     "__LOGOEMP__" ,cChar + "        " + cChar ;
	, " " + " " + "        " + cChar + UPPER(AllTrim(titulo)) + "        " + cChar ;
	, "Fecha Inicial: "+ cvaltochar(MV_PAR03) + "          " + cChar + "PAGI: "+ cvaltochar(nPagntp)+ cChar  ;
	, "Fecha Final: "+ cvaltochar(MV_PAR04) +   "          " ;
	, "            " + "          " +  "Usuario: " + substr(cUsuario,7,15) ;
	, "      " + "          " +  "      "}
	RestArea( aArea )
Return aCabec

STATIC FUNCTION GetTxEL(cNumDoc,cClient,cRecib,cSeria,cData,cFilla)
	Local cTxel := ""
	Local aArea	:= GetArea()
	Local cQuery	:= ""

	cQuery := " SELECT "
	cQuery += "   EL_TXMOE02 "
	cQuery += " FROM "
	cQuery += "   "+RetSQLName("SEL")+" SEL "
	cQuery += " WHERE "
	cQuery += "   EL_NUMERO ='" +cNumDoc+ "' "
	cQuery += "   AND EL_CLIENTE ='"+cClient+"' "
	cQuery += "   AND EL_RECIBO = '" +cRecib+ "' "
	cQuery += "   AND EL_SERIE = '" +cSeria+ "' "
	cQuery += "   AND EL_DTDIGIT = '" +dtos(cData)+ "' "
	cQuery += "   AND EL_FILIAL = '" +cFilla+ "' "
	cQuery += "   AND SEL.D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)
	//Aviso("Array IVA",cQuery,{'ok'},,,,,.t.)
	TCQuery cQuery New Alias "QRY_ell"

	cTxel := QRY_ell->EL_TXMOE02

	QRY_ell->(DbCloseArea())
	RestArea(aArea)

return cTxel
