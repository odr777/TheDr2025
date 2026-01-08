#Include "GPER680.CH"
#Include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CONCEPXLS ³ Autor ³ Repote	: Yamyl Saavedra				³±±
±±									Query	: Nain Terrazas					³±±
±±         							Empresa	: TdeP Partner Totvs			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reporte de Concepto											³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CONCEPXLS()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Yamyl       ³01/07/2016³													³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/

Static Function ReportDef()
	Local oReport
	Local oSection
	
	Private cPeriodo := ""
	
	oReport := TReport():New("CONCEPXLS",OemToAnsi(STR0001),"GPR680",;
	{|oReport| CONCEPXLSImp(oReport)},OemToAnsi(STR0002)+OemToAnsi(STR0003))
	
	oSection := TRSection():New(oReport,OemToAnsi(STR0001),{"SRC","SRA"})
	
	TRCell():New(oSection,"RA_FILIAL",	"SRA", "FILIAL")
	TRCell():New(oSection,"RA_MAT",		"SRA", "MATRICULA")
	TRCell():New(oSection,"RA_NOME",	"SRA", "EMPLEADO")
	TRCell():New(oSection,"RA_RG",		"SRA", "CI")
	TRCell():New(oSection,"RA_TPAFP",	"SRA", "TIPO AFP")
	TRCell():New(oSection,"RA_AFPOPC",	"SRA", "TIPO APORTE")
	TRCell():New(oSection,"RV_DESC",	"SRV", "CONCEPTO")
	TRCell():New(oSection,"RC_PD",		"SRC", "CONCEPTO")
	TRCell():New(oSection,"RC_HORINFO",	"SRC", "HORA INF")
	TRCell():New(oSection,"RC_HORAS",	"SRC", "HORA")
	TRCell():New(oSection,"RC_VALINFO",	"SRC", "VALOR INF")
	TRCell():New(oSection,"RC_VALOR",	"SRC", "VALOR")
	TRCell():New(oSection,"RC_PERIODO",	"SRC", "PERIDO")
	TRCell():New(oSection,"RC_ROTEIR",	"SRC", "CÁLCULO")
Return oReport


User Function CONCEPXLS( )

	/*/   
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis utilizadas para parametros                         ³
	³ mv_par01        //  Processo						           ³
	³ mv_par02        //  Roteiro							       ³
	³ mv_par03        //  Competencia                              ³
	³ mv_par04        //  Filial  De                               ³
	³ mv_par05        //  Filial  Ate                              ³
	³ mv_par06        //  Centro de Custo De                       ³
	³ mv_par07        //  Centro de Custo Ate                      ³
	³ mv_par08        //  Matricula De                             ³
	³ mv_par09        //  Matricula Ate                            ³
	³ mv_par10        //  Nome De                                  ³
	³ mv_par11        //  Nome Ate                                 ³
	³ mv_par12        //  Situacao                                 ³
	³ mv_par13        //  Categoria                                ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*/
	
	pergunte("GPR680",.F.)
	oReport := ReportDef()
	oReport:PrintDialog()	
Return


 
Static Function CONCEPXLSImp(lEnd,WnRel,cString)
	LOCAL cFiltro   := ""
	LOCAL cQuery    := ""
	
	If !Empty(mv_par03)
		cPeriodo := substr(mv_par03,3,4)+substr(mv_par03,1,2)
	EndIf
	
	#IFDEF TOP
		MakeSqlExpr("CONCEPXLS")
		
		oReport:Section(1):BeginQuery()
		BeginSql alias "QRYSA1"
			SELECT RA_FILIAL, RA_MAT, RA_TPCIC, RA_RG, RA_CODPAIS, RA_NRNUA, RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME, RA_NOME, RA_TPAFP, RA_AFPOPC, RV_DESC, RC_PD, RC_HORAS, RC_HORINFO, RC_VALINFO, RC_VALOR, RC_PERIODO, RC_ROTEIR
			FROM %table:SRA% SRA, %table:SRC% SRC, %table:SRV% SRV
			WHERE SRA.D_E_L_E_T_ = ' '
			AND SRC.D_E_L_E_T_ = ' '
			AND SRV.D_E_L_E_T_ = ' '
			AND RA_FILIAL BETWEEN %Exp:mv_par04% AND %Exp:mv_par05%
			AND RA_FILIAL = RC_FILIAL
			AND RA_CC BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
			AND RA_MAT BETWEEN %Exp:mv_par08% AND %Exp:mv_par09%
			AND RA_MAT = RC_MAT
			AND RC_PD = RV_COD
			AND RC_PERIODO = %Exp:cPeriodo%
			AND RC_ROTEIR = %Exp:mv_par02%
		UNION
			SELECT RA_FILIAL, RA_MAT, RA_TPCIC, RA_RG, RA_CODPAIS, RA_NRNUA, RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME, RA_NOME, RA_TPAFP, RA_AFPOPC, RV_DESC, RD_PD, RD_HORAS, RD_HORINFO, RD_VALINFO, RD_VALOR, RD_PERIODO, RD_ROTEIR
			FROM %table:SRA% SRA, %table:SRD% SRD, %table:SRV% SRV
			WHERE SRA.D_E_L_E_T_ = ' '
			AND SRD.D_E_L_E_T_ = ' '
			AND SRV.D_E_L_E_T_ = ' '
			AND RA_FILIAL BETWEEN %Exp:mv_par04% AND %Exp:mv_par05%
			AND RA_FILIAL = RD_FILIAL
			AND RA_CC BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
			AND RA_MAT BETWEEN %Exp:mv_par08% AND %Exp:mv_par09%
			AND RA_MAT = RD_MAT
			AND RD_PD = RV_COD
			AND RD_PERIODO = %Exp:cPeriodo%
			AND RD_ROTEIR = %Exp:mv_par02%
			ORDER BY RA_NOME
		EndSql
		
		oReport:Section(1):EndQuery("")
		TRPosition():New(oReport:Section(1),"SRA",1,"xFilial() + QRYSA1->RA_MAT") 
	#ENDIF	
	
	oReport:Section(1):Print()
Return