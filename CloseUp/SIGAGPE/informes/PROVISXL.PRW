#Include "GPER680.CH"
#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PROVISXL  ³ Autor ³ Repote	: Yamyl Saavedra                  ³±±
±±										Query	: Nain Terrazas                   ³±±
±±         							Empresa: TdeP Partner Totvs	             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reporte Resumen Provisión                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PROVISXL()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Yamyl       ³02/12/2014³													      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()
	Local oReport
	Local oSection
	Local nCodSeq		:= 1    	//N. sequencial
	Private cPeriodo	:= ""
	
	oReport  := TReport():New("PROVISXL",OemToAnsi(STR0001),"GPR680",{|oReport| PROVISXLImp(oReport)},OemToAnsi(STR0002)+OemToAnsi(STR0003))
	oSection := TRSection():New(oReport,OemToAnsi(STR0001),{"SRC","SRA"})
//	oReport:SetTotalInLine(.F.)
	
	TRCell():New(oSection,"cPeriodo",	"   ", "PERIODO",	/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cPeriodo })
//	TRCell():New(oSection,"RA_CC",		"SRA", "BU")
//	TRCell():New(oSection,"RA_MAT",		"SRA", "MATRICULA")
//	TRCell():New(oSection,"RA_NOME",	"SRA", "NOMBRE")
	TRCell():New(oSection,"RA_CC",		"SRA", "CC")
	TRCell():New(oSection,"RA_ADMISSA","SRA", "FECHA INGRESO")
	TRCell():New(oSection,"RA_NASC",	"SRA", "FECHA NACIMIENTO")	
	TRCell():New(oSection,"TOTGA",		"   ", "ACTUAL")
	TRCell():New(oSection,"TGANB",		"   ", "ANTERIOR")
	TRCell():New(oSection,"TGANC",		"   ", "ANT-ANTER")
	TRCell():New(oSection,"TOT_PRO",	"   ", "TOTAL-PROMEDIO")
	TRCell():New(oSection,"AGUIN",		"   ", "AGUINALDO")
	TRCell():New(oSection,"AGUIN2",		"   ", "SEGUNDO AGUINALDO")
	TRCell():New(oSection,"BODPR",		"   ", "BONO DE PRODUCCION")
	TRCell():New(oSection,"PRIMA",		"   ", "PRIMA")
	TRCell():New(oSection,"PRINS",		"   ", "PROVISIÓN INCEMENTO SALARIAL 10% (2014)")
	TRCell():New(oSection,"INDEM",		"   ", "PROVISIÓN INDMNIZACIÓN AL 31/06/2014")
	TRCell():New(oSection,"VACAC",		"   ", "PROVISIÓN VACACIONES")
		
Return oReport


User Function PROVISXL( )
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis utilizadas para parametros                         ³
	³ mv_par01        //  Processo						              ³
	³ mv_par02        //  Roteiro                                  ³
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
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	
	pergunte("GPR680",.F.)
	oReport:= ReportDef()
	oReport:PrintDialog()	
Return
 
Static Function PROVISXLImp(lEnd,WnRel,cString)
	LOCAL cFiltro   := ""
	LOCAL cQuery    := ""
	
	cPeriAbi := GetAdvFVal("RCH","RCH_PER",XFILIAL("RCH")+"00001FOL        ",5,"")
	If !Empty(mv_par03)
		cPeriodo := substr(mv_par03,3,4)+substr(mv_par03,1,2)
	EndIf
	
//	If cPeriAbi==cPeriodo
		#IFDEF TOP
			MakeSqlExpr("PROVISXL")
			
			oReport:Section(1):BeginQuery()
			BeginSql alias "QRYSA1"
				SELECT AA.RA_FILIAL, AA.RA_MAT, AA.RA_NOME, AA.RA_CIC, AA.RA_CC, AA.RC_PERIODO, AA.RC_ROTEIR, AA.RA_ADMISSA, AA.RA_NASC, 
				PRIMA, AGUIN, AGUIN2, INDEM, VACAC, BB.TOTGA, SALB.TGAN TGANB, SALC.TGAN TGANC,
				(BB.TOTGA + ISNULL((SALB.TGAN),0) + ISNULL((SALC.TGAN),0))/
					(1+CASE WHEN ISNULL((SALB.TGAN),0) = 0 THEN 0 ELSE 1 END+
					CASE WHEN ISNULL((SALC.TGAN),0) = 0 THEN 0 ELSE 1 END) TOT_PROM
			FROM
			(
			SELECT	RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RC_PERIODO, RC_ROTEIR, RA_ADMISSA, RA_NASC, 
					SUM(PRIMA) PRIMA, SUM(AGUIN) AGUIN, SUM(AGUIN2) AGUIN2, SUM(INDEM) INDEM, SUM(VACAC) VACAC
			FROM
			(
			SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RC_PERIODO, RC_ROTEIR, RA_ADMISSA, RA_NASC,
			CASE RV_COD    WHEN '252'  THEN RC_HORAS ELSE 0 END AS DNOC,
			CASE RV_COD	 WHEN '777'  THEN RC_VALOR ELSE 0 END AS PRIMA,
			CASE RV_CODFOL WHEN '0777' THEN RC_VALOR ELSE 0 END AS AGUIN,
			CASE RV_CODFOL WHEN '0777' THEN RC_VALOR ELSE 0 END AS AGUIN2,
			CASE RV_CODFOL WHEN '0778' THEN RC_VALOR ELSE 0 END AS INDEM,
			CASE RV_CODFOL WHEN '0130' THEN RC_VALOR ELSE 0 END AS VACAC,
			CASE RV_INFSAL WHEN 'D'    THEN RC_VALOR ELSE 0 END AS BODPR
			FROM %table:SRA% RA, %table:SRC% RC, %table:SRV% RV
			WHERE RA.D_E_L_E_T_ = ' '
			AND RC.D_E_L_E_T_ = ' '
			AND RV.D_E_L_E_T_ = ' '
			AND RA_FILIAL BETWEEN %Exp:mv_par04% AND %Exp:mv_par05%
			AND RA_FILIAL = RC_FILIAL
			AND RA_CC BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
			AND RA_MAT = RC_MAT
			AND RC_PD = RV_COD
			AND RC_PERIODO = %Exp:cPeriodo%
			AND RC_ROTEIR = 'PRV'
			) AS SALARIO
//			GROUP BY RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RC_PERIODO, RC_ROTEIR, RA_ADMISSA, RA_NASC
			GROUP BY RA_CC, RC_PERIODO, RC_ROTEIR
			UNION
			SELECT	RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RD_PERIODO, RD_ROTEIR, RA_ADMISSA, RA_NASC,
					SUM(PRIMA) PRIMA, SUM(AGUIN) AGUIN, SUM(AGUIN2) AGUIN2, SUM(INDEM) INDEM, SUM(VACAC) VACAC
			FROM
			(
			SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RD_PERIODO, RD_ROTEIR, RA_ADMISSA, RA_NASC,
			CASE RV_COD	 WHEN '777'  THEN RD_VALOR ELSE 0 END AS PRIMA,
			CASE RV_CODFOL WHEN '0777' THEN RD_VALOR ELSE 0 END AS AGUIN,
			CASE RV_CODFOL WHEN '0777' THEN RD_VALOR ELSE 0 END AS AGUIN2,
			CASE RV_CODFOL WHEN '0778' THEN RD_VALOR ELSE 0 END AS INDEM,
			CASE RV_CODFOL WHEN '0130' THEN RD_VALOR ELSE 0 END AS VACAC,
			CASE RV_INFSAL WHEN 'D'    THEN RD_VALOR ELSE 0 END AS BODPR
			FROM %table:SRA% RA, %table:SRD% RD, %table:SRV% RV
			WHERE RA.D_E_L_E_T_ = ' '
			AND RD.D_E_L_E_T_ = ' '
			AND RV.D_E_L_E_T_ = ' '
			AND RA_FILIAL BETWEEN %Exp:mv_par04% AND %Exp:mv_par05%
			AND RA_FILIAL = RD_FILIAL
			AND RA_CC BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
			AND RA_MAT = RD_MAT
			AND RD_PD = RV_COD
			AND RD_PERIODO = %Exp:cPeriodo%
			AND RD_ROTEIR = 'PRV'
			) AS SALARIO
//			GROUP BY RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RD_PERIODO, RD_ROTEIR, RA_ADMISSA, RA_NASC
			GROUP BY RA_CC, RD_PERIODO, RD_ROTEIR
			) AA LEFT JOIN
			(
			SELECT	RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RC_PERIODO, RC_ROTEIR, RA_ADMISSA, RA_NASC, 
					SUM(G) TOTGA
			FROM
			(
			SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RC_PERIODO, RC_ROTEIR, RA_ADMISSA, RA_NASC,
			CASE RV_INFSAL WHEN 'G' THEN RC_VALOR 
				WHEN 'A' THEN RC_VALOR 
				WHEN 'B' THEN RC_VALOR 
				WHEN 'C' THEN RC_VALOR 
				WHEN 'D' THEN RC_VALOR 
				WHEN 'E' THEN RC_VALOR 
				WHEN 'F' THEN RC_VALOR 
				ELSE 0 END AS G
			FROM %table:SRA% RA, %table:SRC% RC, %table:SRV% RV
			WHERE RA.D_E_L_E_T_ = ' '
			AND RC.D_E_L_E_T_ = ' '
			AND RV.D_E_L_E_T_ = ' '
			AND RA_FILIAL BETWEEN %Exp:mv_par04% AND %Exp:mv_par05%
			AND RA_FILIAL = RC_FILIAL
			AND RA_CC BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
			AND RA_MAT = RC_MAT
			AND RC_PD = RV_COD
			AND RC_PERIODO = %Exp:cPeriodo%
			AND RC_ROTEIR = 'FOL'
			AND RV_MED13 = 'S'
			) AS SALARIO
//			GROUP BY RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RC_PERIODO, RC_ROTEIR, RA_ADMISSA, RA_NASC
			GROUP BY RA_CC, RC_PERIODO, RC_ROTEIR
			UNION
			SELECT	RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RD_PERIODO, RD_ROTEIR, RA_ADMISSA, RA_NASC,
					SUM(G) TOTGA
			FROM
			(
			SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RD_PERIODO, RD_ROTEIR, RA_ADMISSA, RA_NASC,
			CASE RV_INFSAL WHEN 'G' THEN RD_VALOR 
				WHEN 'A' THEN RD_VALOR 
				WHEN 'B' THEN RD_VALOR 
				WHEN 'C' THEN RD_VALOR 
				WHEN 'D' THEN RD_VALOR 
				WHEN 'E' THEN RD_VALOR 
				WHEN 'F' THEN RD_VALOR 
				ELSE 0 END AS G
			FROM %table:SRA% RA, %table:SRD% RD, %table:SRV% RV
			WHERE RA.D_E_L_E_T_ = ' '
			AND RD.D_E_L_E_T_ = ' '
			AND RV.D_E_L_E_T_ = ' '
			AND RA_FILIAL BETWEEN %Exp:mv_par04% AND %Exp:mv_par05%
			AND RA_FILIAL = RD_FILIAL
			AND RA_CC BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
			AND RA_MAT = RD_MAT
			AND RD_PD = RV_COD
			AND RD_PERIODO = %Exp:cPeriodo%
			AND RD_ROTEIR = 'FOL'
			AND RV_MED13 = 'S'
			) AS SALARIO
//			GROUP BY RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_CC, RD_PERIODO, RD_ROTEIR, RA_ADMISSA, RA_NASC
			GROUP BY RA_CC, RD_PERIODO, RD_ROTEIR
			) BB ON(AA.RA_MAT = BB.RA_MAT
			AND AA.RA_FILIAL = BB.RA_FILIAL)
			LEFT JOIN
			(SELECT RA_FILIAL, RA_MAT, RD_PERIODO, SUM(G) TGAN
			FROM
			(
			SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_TPAFP, RA_AFPOPC, RD_PERIODO, RD_ROTEIR, RA_ADMISSA, RA_NASC,
			CASE RV_INFSAL WHEN 'C'    THEN RD_HORAS ELSE 0 END AS DEXT,
			CASE RV_COD    WHEN '252'  THEN RD_HORAS ELSE 0 END AS DNOC,
			CASE RV_CODFOL WHEN '0031' THEN RD_HORAS
				WHEN '0048' THEN RD_HORAS
				ELSE 0 END AS DIAS,
			CASE RV_CODFOL WHEN '0733' THEN RD_VNAOAPL ELSE 0 END AS SALIVA,
			CASE RV_INFSAL WHEN 'A' THEN RD_VALOR ELSE 0 END AS A,
			CASE RV_INFSAL WHEN 'B' THEN RD_VALOR ELSE 0 END AS B,
			CASE RV_INFSAL WHEN 'C' THEN RD_VALOR ELSE 0 END AS C,
			CASE RV_INFSAL WHEN 'D' THEN RD_VALOR ELSE 0 END AS D,
			CASE RV_INFSAL WHEN 'E' THEN RD_VALOR ELSE 0 END AS E,
			CASE RV_INFSAL WHEN 'F' THEN RD_VALOR ELSE 0 END AS F,
			CASE RV_INFSAL WHEN 'G' THEN RD_VALOR 
				WHEN 'A' THEN RD_VALOR 
				WHEN 'B' THEN RD_VALOR 
				WHEN 'C' THEN RD_VALOR 
				WHEN 'D' THEN RD_VALOR 
				WHEN 'E' THEN RD_VALOR 
				WHEN 'F' THEN RD_VALOR 
				ELSE 0 END AS G,
			CASE RV_INFSAL WHEN 'H' THEN RD_VALOR ELSE 0 END AS H,
			CASE RV_INFSAL WHEN 'I' THEN RD_VALOR ELSE 0 END AS I,
			CASE RV_INFSAL WHEN 'J' THEN RD_VALOR ELSE 0 END AS J,
			CASE RV_INFSAL WHEN 'K' THEN RD_VALOR ELSE 0 END AS K,
			CASE RV_INFSAL WHEN 'L' THEN RD_VALOR 
				WHEN 'H' THEN RD_VALOR 
				WHEN 'I' THEN RD_VALOR 
				WHEN 'J' THEN RD_VALOR 
				WHEN 'K' THEN RD_VALOR 
				ELSE 0 END AS L,
			CASE RV_INFSAL WHEN 'M' THEN RD_VALOR ELSE 0 END AS M
			FROM %table:SRA% RA, %table:SRD% RD, %table:SRV% RV
			WHERE RA.D_E_L_E_T_ = ' '
			AND RD.D_E_L_E_T_ = ' '
			AND RV.D_E_L_E_T_ = ' '
			AND RA_FILIAL BETWEEN %Exp:mv_par04% AND %Exp:mv_par05%
			AND RA_FILIAL = RD_FILIAL
			AND RA_CC BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
			AND RA_MAT = RD_MAT
			AND RD_PD = RV_COD
			AND RD_PERIODO IN(
				SELECT MAX(RCF_PER)
				FROM RCF010
				WHERE D_E_L_E_T_ = ' '
				AND RCF_ROTEIR = 'FOL'
				AND RCF_PER < %Exp:cPeriodo%
			)
			AND RV_MED13 = 'S'
			AND RD_ROTEIR = 'FOL'
			) AS SALARIO
			GROUP BY RA_FILIAL, RA_MAT, RD_PERIODO
			) SALB
			ON (AA.RA_MAT = SALB.RA_MAT
			AND AA.RA_FILIAL = SALB.RA_FILIAL)
			LEFT JOIN
			(SELECT	RA_FILIAL, RA_MAT, RD_PERIODO, SUM(G) TGAN
			FROM
			(
			SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_TPAFP, RA_AFPOPC, RD_PERIODO, RD_ROTEIR, RA_ADMISSA, RA_NASC,
			CASE RV_INFSAL WHEN 'C'    THEN RD_HORAS ELSE 0 END AS DEXT,
			CASE RV_COD    WHEN '252'  THEN RD_HORAS ELSE 0 END AS DNOC,
			CASE RV_CODFOL WHEN '0031' THEN RD_HORAS
				WHEN '0048' THEN RD_HORAS
				ELSE 0 END AS DIAS,
			CASE RV_CODFOL WHEN '0733' THEN RD_VNAOAPL ELSE 0 END AS SALIVA,
			CASE RV_INFSAL WHEN 'A' THEN RD_VALOR ELSE 0 END AS A,
			CASE RV_INFSAL WHEN 'B' THEN RD_VALOR ELSE 0 END AS B,
			CASE RV_INFSAL WHEN 'C' THEN RD_VALOR ELSE 0 END AS C,
			CASE RV_INFSAL WHEN 'D' THEN RD_VALOR ELSE 0 END AS D,
			CASE RV_INFSAL WHEN 'E' THEN RD_VALOR ELSE 0 END AS E,
			CASE RV_INFSAL WHEN 'F' THEN RD_VALOR ELSE 0 END AS F,
			CASE RV_INFSAL WHEN 'G' THEN RD_VALOR 
				WHEN 'A' THEN RD_VALOR 
				WHEN 'B' THEN RD_VALOR 
				WHEN 'C' THEN RD_VALOR 
				WHEN 'D' THEN RD_VALOR 
				WHEN 'E' THEN RD_VALOR 
				WHEN 'F' THEN RD_VALOR 
				ELSE 0 END AS G,
			CASE RV_INFSAL WHEN 'H' THEN RD_VALOR ELSE 0 END AS H,
			CASE RV_INFSAL WHEN 'I' THEN RD_VALOR ELSE 0 END AS I,
			CASE RV_INFSAL WHEN 'J' THEN RD_VALOR ELSE 0 END AS J,
			CASE RV_INFSAL WHEN 'K' THEN RD_VALOR ELSE 0 END AS K,
			CASE RV_INFSAL WHEN 'L' THEN RD_VALOR 
				WHEN 'H' THEN RD_VALOR 
				WHEN 'I' THEN RD_VALOR 
				WHEN 'J' THEN RD_VALOR 
				WHEN 'K' THEN RD_VALOR 
				ELSE 0 END AS L,
			CASE RV_INFSAL WHEN 'M' THEN RD_VALOR ELSE 0 END AS M
			FROM %table:SRA% RA, %table:SRD% RD, %table:SRV% RV
			WHERE RA.D_E_L_E_T_ = ' '
			AND RD.D_E_L_E_T_ = ' '
			AND RV.D_E_L_E_T_ = ' '
			AND RA_FILIAL BETWEEN %Exp:mv_par04% AND %Exp:mv_par05%
			AND RA_FILIAL = RD_FILIAL
			AND RA_CC BETWEEN %Exp:mv_par06% AND %Exp:mv_par07%
			AND RA_MAT = RD_MAT
			AND RD_PD = RV_COD
			AND RD_PERIODO IN(SELECT MAX(RCF_PER)
				FROM RCF010
				WHERE D_E_L_E_T_ = ' '
				AND RCF_ROTEIR = 'FOL'
				AND RCF_PER < (SELECT MAX(RCF_PER)
				FROM RCF010
				WHERE D_E_L_E_T_ = ' '
				AND RCF_ROTEIR = 'FOL'
				AND RV_MED13 = 'S'
				AND RCF_PER < %Exp:cPeriodo% )
			)
			AND RD_ROTEIR = 'FOL'
			AND RV_MED13 = 'S'
			) AS SALARIO
			GROUP BY RA_FILIAL, RA_MAT, RD_PERIODO
			) SALC
			ON (AA.RA_MAT = SALC.RA_MAT
			AND AA.RA_FILIAL = SALC.RA_FILIAL)
			EndSql
			
			oReport:Section(1):EndQuery("")
			TRPosition():New(oReport:Section(1),"SRA",2,"xFilial() + QRYSA1->RA_MAT") 
		#ENDIF
//	EndIf
	
	oReport:Section(1):Print()
Return