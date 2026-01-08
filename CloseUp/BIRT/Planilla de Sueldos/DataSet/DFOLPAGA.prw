#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'
#INCLUDE "GPER680.CH"
#INCLUDE "FIVEWIN.CH"

#DEFINE NNUM           1
#DEFINE NCI            2
#DEFINE NAPELLIDOS     3
#DEFINE NNACIONAL      4
#DEFINE NNASCIMENTO    5
#DEFINE NSEXO          6
#DEFINE NOCUPACION     7
#DEFINE NINGRESSO      8
#DEFINE NDIASHPM       9
#DEFINE NHORASDP       10
#DEFINE NHABERB        11
#DEFINE NBONOANT       12
#DEFINE NHENUMERO      13
#DEFINE NHEMONTO       14
#DEFINE NREMBONO       15
#DEFINE NREMOTROS      16
#DEFINE NSDSRNUM       17
#DEFINE NSDSRSUE       18
#DEFINE NTOTGANADO     19
#DEFINE NDAFP          20
#DEFINE NDRCIVA        21
#DEFINE NDODESC        22
#DEFINE NTOTDCTOS      23
#DEFINE NLIQUIDOP      24
#DEFINE NFIRMA         25

User_Dataset DFOLPAGA
title "Planilla de sueldos"
description "Detalle de la planilla"
PERGUNTE "GPR680"

columns

define column NUM          	type 	numeric size 4 													label	"NUM"
define column CI           	type 	character size (tamSX3("RA_CIC")[1] + tamSX3("RA_UFCI")[1])  	label	"CI"
define column APELLIDOS    	type 	character size tamSX3("RA_NOME")[1]  							label	"APELLIDOS"
define column NACIONAL     	type 	character size tamSX3("X5_DESCRI")[1]  							label	"NACIONAL"
define column NASCIMENTO   	type 	character size (tamSX3("RA_NASC")[1] + 2)  						label	"NASCIMENTO"
define column SEXO         	type 	character size tamSX3("RA_SEXO")[1]  							label	"SEXO"
define column OCUPACION    	type 	character size tamSX3("RJ_DESC")[1]  							label	"OCUPACION"
define column INGRESSO     	type 	character size (tamSX3("RA_ADMISSA")[1] + 2)  					label	"INGRESSO"
define column DIASHPM      	type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"DIASHPM"
define column HORASDP      	type 	numeric size tamSX3("RCF_HRSDIA")[1] 	decimals 2 				label	"HORASDP"
define column HABERB       	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HABERB"
define column BONOANT      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"BONOANT"
define column HENUMERO     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HENUMERO"
define column HEMONTO      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HEMONTO"
define column REMBONO      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"REMBONO"
define column REMOTROS     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"REMOTROS"
define column SDSRNUM      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"SDSRNUM"
define column SDSRSUE      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"SDSRSUE"
define column TOTGANADO    	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"TOTGANADO"
define column DAFP         	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"DAFP"
define column DRCIVA       	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"DRCIVA"
define column DODESC       	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"DODESC"
define column TOTDCTOS     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"TOTDCTOS"
define column LIQUIDOP     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"LIQUIDOP"
define column FIRMA        	type 	character size 15												label	"FIRMA"

//define column NOMEPROV   	type 	character size tamSX3("A2_NOME")[1]  				label	"NOMEPROV"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local aDetalle		:= {}

Private cProcesso 	:= self:execParamValue("MV_PAR01")
Private cCompet		:= self:execParamValue("MV_PAR03")
Private cFilDe   	:= self:execParamValue("MV_PAR04")
Private cFilAte  	:= self:execParamValue("MV_PAR05")
Private cCcDe    	:= self:execParamValue("MV_PAR06")
Private cCcAte   	:= self:execParamValue("MV_PAR07")
Private cMatDe   	:= self:execParamValue("MV_PAR08")
Private cMatAte  	:= self:execParamValue("MV_PAR09")
Private cNomDe   	:= self:execParamValue("MV_PAR10")
Private cNomAte  	:= self:execParamValue("MV_PAR11")
Private cSituacao  	:= self:execParamValue("MV_PAR12")
Private cCategoria 	:= self:execParamValue("MV_PAR13")
Private nPerEvent	:= self:execParamValue("MV_PAR14")
Private cNomEmpr	:= self:execParamValue("MV_PAR15")
Private cNumDocId	:= self:execParamValue("MV_PAR16")
Private aRoteiros	:= {}

/*/
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
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
	³ mv_par14        //  Personal - Eventual/Permanente           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

aDetalle:= R680ImpR4()

cursorarrow()

for i:= 1 to len(aDetalle)
	cFchNac	:= Trim(aDetalle[i,NNASCIMENTO])
	cAnho	:= SubStr(cFchNac, 1,4 )
	cMes	:= SubStr(cFchNac, 5,2 )
	cDia	:= SubStr(cFchNac, 7,2 )
	cFchNac	:= cDia + "/" + cMes + "/" + cAnho

	cFchAdm	:= Trim(aDetalle[i,NINGRESSO])
	cAnho	:= SubStr(cFchAdm, 1,4 )
	cMes	:= SubStr(cFchAdm, 5,2 )
	cDia	:= SubStr(cFchAdm, 7,2 )
	cFchAdm	:= cDia + "/" + cMes + "/" + cAnho

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)-> NUM        := aDetalle[i,NNUM       ]
	(cWTabAlias)-> CI         := aDetalle[i,NCI        ]
	(cWTabAlias)-> APELLIDOS  := aDetalle[i,NAPELLIDOS ]
	(cWTabAlias)-> NACIONAL   := aDetalle[i,NNACIONAL  ]
	(cWTabAlias)-> NASCIMENTO := cFchNac
	(cWTabAlias)-> SEXO       := aDetalle[i,NSEXO      ]
	(cWTabAlias)-> OCUPACION  := aDetalle[i,NOCUPACION ]
	(cWTabAlias)-> INGRESSO   := cFchAdm
	(cWTabAlias)-> DIASHPM    := aDetalle[i,NDIASHPM   ]
	(cWTabAlias)-> HORASDP    := aDetalle[i,NHORASDP   ]
	(cWTabAlias)-> HABERB     := aDetalle[i,NHABERB    ]
	(cWTabAlias)-> BONOANT    := aDetalle[i,NBONOANT   ]
	(cWTabAlias)-> HENUMERO   := aDetalle[i,NHENUMERO  ]
	(cWTabAlias)-> HEMONTO    := aDetalle[i,NHEMONTO   ]
	(cWTabAlias)-> REMBONO    := aDetalle[i,NREMBONO   ]
	(cWTabAlias)-> REMOTROS   := aDetalle[i,NREMOTROS  ]
	(cWTabAlias)-> SDSRNUM    := aDetalle[i,NSDSRNUM   ]
	(cWTabAlias)-> SDSRSUE    := aDetalle[i,NSDSRSUE   ]
	(cWTabAlias)-> TOTGANADO  := aDetalle[i,NTOTGANADO ]
	(cWTabAlias)-> DAFP       := aDetalle[i,NDAFP      ]
	(cWTabAlias)-> DRCIVA     := aDetalle[i,NDRCIVA    ]
	(cWTabAlias)-> DODESC     := aDetalle[i,NDODESC    ]
	(cWTabAlias)-> TOTDCTOS   := aDetalle[i,NTOTDCTOS  ]
	(cWTabAlias)-> LIQUIDOP   := aDetalle[i,NLIQUIDOP  ]
	(cWTabAlias)-> FIRMA      := aDetalle[i,NFIRMA     ]

	(cWTabAlias)->(MsUnlock())

next i

return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ R680ImpR4  ³ Autor ³ Marcelo Silveira      ³ Data ³05/11/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio de Saldos e Salarios                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPER680                                                      ³±±
±±³Modificado³ ³ Denar Terrazas      					  ³ Data ³15/03/2019³±±
±±³Descri‡ao ³ Modificado para imprimir en birt                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R680ImpR4()

	Local nX		:= 0
	Local nReg		:= 0
	Local nTamProc	:= 0
	Local nVHDiaPg 	:= 0
	Local nDiaPgMes	:= 0
	Local cMatAnt	:= ""
	Local cSitQuery	:= ""
	Local cCatQuery	:= ""
	Local cAuxPrc	:= ""
	Local cProcs	:= ""
	Local cFilPd	:= ""
	Local cFilPer	:= ""
	Local cPersona	:= ""
	Local cEmpMTrab	:= ""
	Local cCondicao := ""

	Local cFirma	:= "..............."

	Local i			:= 0
	Local iX		:= 0
	Local nQtdFun	:= 0
	Local nTotPage	:= 0
	Local nPageAtu	:= 1
	Local aVerba 	:= Array(14,2)
	Local aCols		:= {}
	Local aRet		:= {}

	Local nPerEvent

	nOrdem		:= 1//oReport:GetOrder()

	cPersona 	:= If( nPerEvent == 1, STR0010, STR0075) 	//1-PERMANENTE / 2-EVENTUAL
	cEmpMTrab	:= OemToAnsi(STR0009) +": "+ allTrim(FWCompanyName())
	// cEmpMTrab	:= OemToAnsi(STR0009) +": "+ If( fTabela("S007",1,5 ) <> Nil, fTabela("S007",1,5 ), " " )
	//cNomEmpr	:= If( (cNomEmpr := fTabela("S007",1,10 )) <> Nil, cNomEmpr, mv_par15 )
	//cNumDocId	:= If( (cNumDocId := fTabela("S007",1,11 )) <> Nil, cNumDocId, mv_par16 )

	If !Empty(cCompet)
		cPeriodo := SubStr(cCompet,3,4) + SubStr(cCompet,1,2)
	EndIf

	cSitQuery	:= ""
	If !Empty(cSituacao)
		For nReg:=1 to Len(cSituacao)
			cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
			If ( nReg+1 ) <= Len(cSituacao)
				cSitQuery += ","
			Endif
		Next nReg
		cSitQuery := "%" + cSitQuery + "%"
	EndIf

	cCatQuery	:= ""
	If !Empty(cSituacao)
		For nReg:=1 to Len(cCategoria)
			cCatQuery += "'"+Subs(cCategoria,nReg,1)+"'"
			If ( nReg+1 ) <= Len(cCategoria)
				cCatQuery += ","
			Endif
		Next nReg
		cCatQuery := "%" + cCatQuery + "%"
	EndIf

	//Trata os roteiros para a query
	SelecRoteiros()
	For nX := 1 to Len(aRoteiros)
		cRoteiro += "'" + aRoteiros[nX, 1] + "'"
		If( nX+1 ) <=  Len(aRoteiros)
			cRoteiro += ","
		EndIf
	Next
	//TODO revisar funcion SelecRoteiros()
	cRoteiro:= "'FOL'"
	cRoteiro := "%" + cRoteiro + "%"

	//Trata os processos para a query
	nTamProc := GetSx3Cache( "RCJ_CODIGO", "X3_TAMANHO" )
	For nX := 1 to Len(Alltrim(cProcesso)) Step 5
		If Len(Subs(cProcesso,nX,5)) < nTamProc
			cAuxPrc := Subs(cProcesso,nX,5) + Space(nTamProc - Len(Subs(cProcesso,nX,5)))
		Else
			cAuxPrc := Subs(cProcesso,nX,5)
		EndIf
		cProcs += "'" + cAuxPrc + "',"
	Next nX
	cProcs := "%" + Substr( cProcs, 1, Len(cProcs)-1) + "%"

	cAliasFun := GetNextAlias()
	cAliasQry := GetNextAlias()

	lExeQry	  := .T.

	If nOrdem == 1
		cOrdFun   := "% RA_FILIAL, RA_MAT %"
		cOrdLan	  := "% RA_FILIAL, RA_MAT, PD, SEQ %"
		cCondicao := "(cAliasQry)->FILIAL == (cAliasFun)->RA_FILIAL .And. (cAliasQry)->RA_MAT == (cAliasFun)->RA_MAT"
	Else
		cOrdFun   := "% RA_FILIAL, RA_CC, RA_MAT %"
		cOrdLan   := "% RA_FILIAL, RA_CC, RA_MAT, PD, SEQ %"
		cCondicao := "(cAliasQry)->FILIAL == (cAliasFun)->RA_FILIAL .And. (cAliasQry)->RA_CC == (cAliasFun)->RA_CC .And. (cAliasQry)->RA_MAT == (cAliasFun)->RA_MAT"
	EndIf

	cFilPd	:= If( Alltrim(FWModeAccess("SRV",3)) == "C", "%'" + xFilial("SRV") + "'%", "%SRA.RA_FILIAL%" )
	cFilPer	:= If( Alltrim(FWModeAccess("RCF",3)) == "C", "%'" + xFilial("RCF") + "'%", "%SRA.RA_FILIAL%" )

	BeginSql alias cAliasFun

		SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,			SRA.RA_CC,			SRA.RA_NOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,		SRA.RA_SALARIO,		SRA.RA_SITFOLH,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,		SRA.RA_CIC,  		SRA.RA_UFCI,			SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,		SRA.RA_ADMISSA,		SRA.RA_CODFUNC,
		SRA.RA_TNOTRAB,			SRA.RA_PROCES,		SRA.RA_HRSMES,		SRA.RA_CARGO,
		SRC.RC_FILIAL FILIAL,	SRC.RC_CC CCUSTO, 	SRC.RC_HORAS HORAS,
		RCF.RCF_HRSDIA,			RCF.RCF_DIATRA

		FROM %table:SRA% SRA

		INNER JOIN  %table:SRC% SRC
		ON 	    SRA.RA_FILIAL = SRC.RC_FILIAL	AND
		SRA.RA_MAT    = SRC.RC_MAT
		INNER JOIN %table:RCF% RCF
		ON		RCF.RCF_FILIAL	=	%exp:cFilPer%	AND
		RCF.RCF_PROCES	=	SRA.RA_PROCES	AND
		RCF.RCF_PER 	=	%exp:Upper(cPeriodo)%
		INNER JOIN %table:SRV% SRV
		ON		SRV.RV_COD 		=	SRC.RC_PD
		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_NOME   BETWEEN %Exp:cNomDe% AND %Exp:cNomAte% AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRC.RC_PROCES  IN (%exp:Upper(cProcs)%)  	AND
		SRC.RC_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRC.RC_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SRV.RV_CODFOL = '0031' AND
		SRA.%notDel% AND SRC.%notDel% AND RCF.%notDel%

		UNION

		(SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,			SRA.RA_CC,			SRA.RA_NOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,		SRA.RA_SALARIO,		SRA.RA_SITFOLH,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,		SRA.RA_CIC,  		SRA.RA_UFCI,			SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,		SRA.RA_ADMISSA,		SRA.RA_CODFUNC,
		SRA.RA_TNOTRAB,			SRA.RA_PROCES,		SRA.RA_HRSMES,		SRA.RA_CARGO,
		SRD.RD_FILIAL FILIAL,	SRD.RD_CC CCUSTO,	SRD.RD_HORAS HORAS,
		RCF.RCF_HRSDIA,			RCF.RCF_DIATRA

		FROM %table:SRA% SRA

		INNER JOIN  %table:SRD% SRD
		ON 	    SRA.RA_FILIAL = SRD.RD_FILIAL	AND
		SRA.RA_MAT    = SRD.RD_MAT
		INNER JOIN %table:RCF% RCF
		ON		RCF.RCF_FILIAL	=	%exp:cFilPer%	AND
		RCF.RCF_PROCES	=	SRA.RA_PROCES	AND
		RCF.RCF_PER 	=	%exp:Upper(cPeriodo)%
		INNER JOIN %table:SRV% SRV
		ON		SRV.RV_COD		=	SRD.RD_PD
		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_NOME   BETWEEN %Exp:cNomDe% AND %Exp:cNomAte% AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRD.RD_PROCES  IN (%exp:Upper(cProcs)%)  	AND
		SRD.RD_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRD.RD_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SRV.RV_CODFOL = '0031' AND
		SRA.%notDel% AND SRD.%notDel% AND RCF.%notDel%)
		ORDER BY %exp:cOrdFun%

	EndSql

	BeginSql alias cAliasQry

		SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,				SRA.RA_CC,				SRA.RA_NOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,			SRA.RA_SALARIO,			SRA.RA_SITFOLH,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,			SRA.RA_CIC,				SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,			SRA.RA_ADMISSA,			SRA.RA_CODFUNC,
		SRA.RA_CARGO,
		SRC.RC_FILIAL FILIAL,	SRC.RC_MAT MAT,			SRC.RC_CC CCUSTO,		SRC.RC_PD PD,
		SRC.RC_TIPO1 TIPO1,		SRC.RC_QTDSEM QTDSEM,	SRC.RC_HORINFO HORINFO,	SRC.RC_HORAS HORAS,
		SRC.RC_VALINFO VALINFO,	SRC.RC_VALOR VALOR,		SRC.RC_VNAOAPL VNAOAPL,	SRC.RC_DATA DATPGT,
		SRC.RC_DTREF DTREF,		SRC.RC_SEMANA SEMANA,	SRC.RC_SEQ SEQ,			SRC.RC_PROCES PROCES,
		SRC.RC_PERIODO PERIODO,	SRC.RC_NUMID NUMID,		SRC.RC_ROTEIR ROTEIR,
		SRV.RV_COD,				SRV.RV_INFSAL INFSAL,	SRV.RV_CODFOL CODFOL
		FROM %table:SRA% SRA
		INNER JOIN	%table:SRC% SRC
		ON 	    SRA.RA_FILIAL = SRC.RC_FILIAL	AND
		SRA.RA_MAT    = SRC.RC_MAT
		INNER JOIN 	%table:SRV% SRV
		ON		SRV.RV_FILIAL = %exp:cFilPd%	AND
		SRV.RV_COD    = SRC.RC_PD

		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_NOME   BETWEEN %Exp:cNomDe% AND %Exp:cNomAte% AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRC.RC_PROCES  IN (%exp:Upper(cProcs)%)  	AND
		SRC.RC_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRC.RC_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SRV.RV_INFSAL <> (%exp:""%) AND
		SRA.%notDel% AND SRC.%notDel% AND SRV.%notDel%
		UNION

		(SELECT SRA.RA_FILIAL,			SRA.RA_MAT,				SRA.RA_CC,				SRA.RA_NOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,			SRA.RA_SALARIO,			SRA.RA_SITFOLH,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,			SRA.RA_CIC,				SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,			SRA.RA_ADMISSA,			SRA.RA_CODFUNC,
		SRA.RA_CARGO,
		SRD.RD_FILIAL FILIAL,	SRD.RD_MAT MAT,			SRD.RD_CC CCUSTO,		SRD.RD_PD PD,
		SRD.RD_TIPO1 TIPO1,		SRD.RD_QTDSEM QTDSEM,	SRD.RD_HORINFO HORINFO,	SRD.RD_HORAS HORAS,
		SRD.RD_VALINFO VALINFO,	SRD.RD_VALOR VALOR,		SRD.RD_VNAOAPL VNAOAPL,	SRD.RD_DATPGT DATPGT,
		SRD.RD_DTREF DTREF,		SRD.RD_SEMANA SEMANA,	SRD.RD_SEQ SEQ,			SRD.RD_PROCES PROCES,
		SRD.RD_PERIODO PERIODO,	SRD.RD_NUMID NUMID,		SRD.RD_ROTEIR ROTEIR,
		SRV.RV_COD,				SRV.RV_INFSAL INFSAL,	SRV.RV_CODFOL CODFOL
		FROM %table:SRA% SRA

		INNER JOIN %table:SRD% SRD
		ON 	    SRA.RA_FILIAL = SRD.RD_FILIAL	AND
		SRA.RA_MAT    = SRD.RD_MAT
		INNER JOIN %table:SRV% SRV
		ON		SRV.RV_FILIAL 	= %exp:cFilPd%	AND
		SRV.RV_COD    	= SRD.RD_PD

		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_NOME   BETWEEN %Exp:cNomDe% AND %Exp:cNomAte% AND
		SRA.RA_SITFOLH	IN	(%exp:Upper(cSitQuery)%)	AND
		SRA.RA_CATFUNC	IN	(%exp:Upper(cCatQuery)%)	AND
		SRD.RD_PROCES	IN	(%exp:Upper(cProcs)%)		AND
		SRD.RD_PERIODO	=	%exp:Upper(cPeriodo)%		AND
		SRD.RD_ROTEIR	IN	(%exp:Upper(cRoteiro)%)		AND
		SRV.RV_INFSAL	<>	(%exp:""%) AND
		SRA.%notDel% AND SRD.%notDel% AND SRV.%notDel%)
		ORDER BY %exp:cOrdLan%

	EndSql

	(cAliasFun)->( dbGoTop())

	Do While (cAliasFun)->(!Eof())

		nDiaPgMes := 0
		nVHDiaPg  := 0

		For i := 1 To 14
			For iX := 1 to 2
				aVerba[i,iX] := 0
			Next iX
		Next i

		IF (cAliasFun)->RA_MAT <> cMatAnt .And. &cCondicao
			nDiaPgMes	:= (cAliasFun)->HORAS
		EndIf

		Do While (cAliasQry)->(!Eof()) .And. &cCondicao

			If (cAliasQry)->CODFOL $ "0031|0048"
				nVHDiaPg := (cAliasFun)->RCF_HRSDIA
			EndIf

			Do Case
				Case (cAliasQry)->INFSAL == "A"
				aVerba[1,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "B"
				aVerba[2,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "C"
				aVerba[3,1] += (cAliasQry)->VALOR
				aVerba[3,2] += (cAliasQry)->HORAS
				Case (cAliasQry)->INFSAL == "D"
				aVerba[4,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "F"
				aVerba[5,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "E"
				aVerba[6,1] += (cAliasQry)->VALOR
				aVerba[6,2] += (cAliasQry)->HORAS
				Case (cAliasQry)->INFSAL == "H"
				aVerba[7,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "I"
				aVerba[8,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "J"
				aVerba[9,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "K" 			//Nao mais usado (retirado em 2013/11)
				aVerba[13,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "L"
				aVerba[14,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "N"     		//Nao mais usado (retirado em 2013/11)
				aVerba[14,1] += (cAliasQry)->VALOR
			EndCase

			(cAliasQry)->(DbSkip())
		EndDo

		If aVerba[1,1] > 0

			aVerba[10,1] := aVerba[1,1] + aVerba[2,1] + aVerba[3,1] + aVerba[4,1] + aVerba[5,1] + aVerba[6,1]	//TOTAL GANADO (G)
			aVerba[11,1] := aVerba[7,1] + aVerba[8,1] + aVerba[9,1] 				 								//TOTAL DESCONTOS (L)
			aVerba[12,1] := aVerba[10,1] - aVerba[11,1] 															//LIQUIDO PAGABLE (N)

			aCols := {}

			AADD(aCols, ( nQtdFun += 1 )                                                                    )
			AADD(aCols, ( /*PadL(*/ AllTrim((cAliasFun)->RA_CIC)/*, 12)*/ + AllTrim((cAliasFun)->RA_UFCI) ) )
			AADD(aCols, ( (cAliasFun)->RA_NOME )                                                            )
			AADD(aCols, ( fDesc("SX5","34"+(cAliasFun)->RA_NACIONA,"X5_DESCRI") )                           )
			AADD(aCols, ( (cAliasFun)->RA_NASC )                                                            )
			AADD(aCols, ( (cAliasFun)->RA_SEXO )                                                            )
			AADD(aCols, ( fDesc("SRJ",(cAliasFun)->RA_CARGO,"RJ_DESC") )                                    )
			AADD(aCols, ( (cAliasFun)->RA_ADMISSA )                                                         )
			AADD(aCols, ( nDiaPgMes)                                                                        )
			AADD(aCols, ( nVHDiaPg)                                                                         )
			AADD(aCols, ( aVerba[1,1])                                                                      )
			AADD(aCols, ( aVerba[2,1])                                                                      )
			AADD(aCols, ( aVerba[3,2])                                                                      )
			AADD(aCols, ( aVerba[3,1])                                                                      )
			AADD(aCols, ( aVerba[4,1])                                                                      )
			AADD(aCols, ( aVerba[5,1])                                                                      )
			AADD(aCols, ( aVerba[6,2])                                                                      )
			AADD(aCols, ( aVerba[6,1])                                                                      )
			AADD(aCols, ( aVerba[10,1])                                                                     )
			AADD(aCols, ( aVerba[7,1])                                                                      )
			AADD(aCols, ( aVerba[8,1])                                                                      )
			AADD(aCols, ( aVerba[9,1])                                                                      )
			AADD(aCols, ( aVerba[11,1])                                                                     )
			AADD(aCols, ( aVerba[12,1])                                                                     )
			AADD(aCols, ( cFirma )                                                                          )

			AADD(aRet, aCols)
		EndIf

		cMatAnt:= (cAliasFun)->RA_MAT
		(cAliasFun)->(DbSkip())

	EndDo

Return aRet

