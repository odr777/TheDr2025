#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'
#INCLUDE "GPER680.CH"
#INCLUDE "FIVEWIN.CH"

#DEFINE NDATOS         35

#DEFINE NNUM           1
#DEFINE NCI            2
#DEFINE NCIEXP         3
#DEFINE NAPELLIDOS     4
#DEFINE NNACIONAL      5
#DEFINE NNASCIMENTO    6
#DEFINE NSEXO          7
#DEFINE NOCUPACION     8
#DEFINE NINGRESSO      9
#DEFINE NDIASHPM       10
#DEFINE NHORASDP       11
#DEFINE NHABERB        12
#DEFINE NBONOANT       13
#DEFINE NHENUMERO      14
#DEFINE NHEMONTO       15
#DEFINE NREMBONO       16
#DEFINE NREMOTROS      17
#DEFINE NSDSRNUM       18
#DEFINE NSDSRSUE       19
#DEFINE NTOTGANADO     20
#DEFINE NDAFP          21
#DEFINE NDRCIVA        22
#DEFINE NDODESC        23
#DEFINE NTOTDCTOS      24
#DEFINE NLIQUIDOP      25
#DEFINE NFIRMA         26
#DEFINE NMATRICULA     27
#DEFINE NCCOSTO        28	//Codigo Centro de Costo
#DEFINE NCCDESC        29	//Descripcion Centro de Costo
#DEFINE NAGRUPADO      30	//Agrupado por: 1:=Sucursal, 2:=Centro Costo
#DEFINE NSUCURSAL      31
#DEFINE NSUCNOMBR      32
#DEFINE NEMPCOD        33
#DEFINE NEMPDESC       34
#DEFINE NANTICIPO      35

#DEFINE VIGENTES	" A*FT"
#DEFINE DESPEDIDOS	"**D**"
#DEFINE TODOS		" ADFT"

User_Dataset DFOL2PAG
title "Planilla de sueldos"
description "Detalle de la planilla"
PERGUNTE "FOLPAGA2"

columns

define column NUM          	type 	numeric size 4 													label	"NUM"
define column CI           	type 	character size tamSX3("RA_CIC")[1]								label	"CI"
define column CIEXP         type 	character size tamSX3("RA_UFCI")[1]								label	"CIEXP"
define column APELLIDOS    	type 	character size tamSX3("RA_NOMECMP")[1]  						label	"APELLIDOS"
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
define column MATRICULA    	type 	character size tamSX3("RA_MAT")[1]  							label	"MATRICULA"
define column CCOSTO    	type 	character size tamSX3("RA_CC")[1]  								label	"CCOSTO"
define column CCDESC    	type 	character size tamSX3("CTT_DESC01")[1]  						label	"CCDESC"
define column AGRUPADO    	type 	numeric size 1  												label	"AGRUPADO"
define column SUCURSAL    	type 	character size tamSX3("RA_FILIAL")[1]  							label	"SUCURSAL"
define column SUCNOMBR    	type 	character size 30					 							label	"SUCNOMBR"
define column EMPCOD    	type 	character size 04					 							label	"EMPCOD"
define column EMPDESC    	type 	character size 60					 							label	"EMPDESC"

define column DANTICIPO     type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"DANTICIPO"

//define column NOMEPROV   	type 	character size tamSX3("A2_NOME")[1]  				label	"NOMEPROV"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local aDetalle		:= {}

Private cProcesso 	:= self:execParamValue("MV_PAR01")
Private cCompet		:= self:execParamValue("MV_PAR03")
Private cSemana		:= self:execParamValue("MV_PAR04") //Nro de pago
Private cFilDe   	:= self:execParamValue("MV_PAR05")
Private cFilAte  	:= self:execParamValue("MV_PAR06")
Private cCcDe    	:= self:execParamValue("MV_PAR07")
Private cCcAte   	:= self:execParamValue("MV_PAR08")
Private cMatDe   	:= self:execParamValue("MV_PAR09")
Private cMatAte  	:= self:execParamValue("MV_PAR10")
Private nSituacao  	:= self:execParamValue("MV_PAR11")
Private cSituacao  	:= VIGENTES
Private cCategoria 	:= self:execParamValue("MV_PAR12")
Private nPerEvent	:= self:execParamValue("MV_PAR13")
Private cNomEmpr	:= self:execParamValue("MV_PAR14")
Private cNumDocId	:= self:execParamValue("MV_PAR15")
Private nOrdem		:= self:execParamValue("MV_PAR16")
Private nAgrupa		:= IIF(EMPTY(self:execParamValue("MV_PAR17")), 1, self:execParamValue("MV_PAR17"))//Agrupado por: 1:=Empresa, 2:=Sucursal, 3:=Centro Costo
Private nTpCiabol 	:= IIF(EMPTY(self:execParamValue("MV_PAR18")), 1, self:execParamValue("MV_PAR18"))
Private cTpCiabol  	:= "N"
Private aRoteiros	:= {}

/*/
⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
≥ mv_par01        //  Processo						           ≥
≥ mv_par02        //  Roteiro							       ≥
≥ mv_par03        //  Competencia                              ≥
≥ MV_PAR05        //  Filial  De                               ≥
≥ MV_PAR06        //  Filial  Ate                              ≥
≥ MV_PAR07        //  Centro de Custo De                       ≥
≥ MV_PAR08        //  Centro de Custo Ate                      ≥
≥ MV_PAR09        //  Matricula De                             ≥
≥ MV_PAR10        //  Matricula Ate                            ≥
≥ MV_PAR11        //  Situacao                                 ≥
≥ MV_PAR12        //  Categoria                                ≥
≥ MV_PAR13        //  Personal - Eventual/Permanente           ≥
¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ/*/

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

aDetalle:= R680ImpR4()

cursorarrow()

for i:= 1 to len(aDetalle)

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)-> NUM        := aDetalle[i,NNUM       ]
	(cWTabAlias)-> CI         := aDetalle[i,NCI        ]
	(cWTabAlias)-> CIEXP      := aDetalle[i,NCIEXP     ]
	(cWTabAlias)-> APELLIDOS  := aDetalle[i,NAPELLIDOS ]
	(cWTabAlias)-> NACIONAL   := aDetalle[i,NNACIONAL  ]
	(cWTabAlias)-> NASCIMENTO := DTOC(STOD(Trim(aDetalle[i, NNASCIMENTO])))
	(cWTabAlias)-> SEXO       := aDetalle[i,NSEXO      ]
	(cWTabAlias)-> OCUPACION  := aDetalle[i,NOCUPACION ]
	(cWTabAlias)-> INGRESSO   := DTOC(STOD(Trim(aDetalle[i, NINGRESSO])))
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
	(cWTabAlias)-> DANTICIPO  := aDetalle[i,NANTICIPO  ]
	(cWTabAlias)-> DODESC     := aDetalle[i,NDODESC    ]
	(cWTabAlias)-> TOTDCTOS   := aDetalle[i,NTOTDCTOS  ]
	(cWTabAlias)-> LIQUIDOP   := aDetalle[i,NLIQUIDOP  ]
	(cWTabAlias)-> FIRMA      := aDetalle[i,NFIRMA     ]
	(cWTabAlias)-> MATRICULA  := aDetalle[i,NMATRICULA ]
	(cWTabAlias)-> CCOSTO  	  := aDetalle[i,NCCOSTO    ]
	(cWTabAlias)-> CCDESC  	  := aDetalle[i,NCCDESC    ]
	(cWTabAlias)-> AGRUPADO   := aDetalle[i,NAGRUPADO  ]
	(cWTabAlias)-> SUCURSAL   := aDetalle[i,NSUCURSAL  ]
	(cWTabAlias)-> SUCNOMBR   := aDetalle[i,NSUCNOMBR  ]
	(cWTabAlias)-> EMPCOD	  := aDetalle[i,NEMPCOD    ]
	(cWTabAlias)-> EMPDESC	  := aDetalle[i,NEMPDESC   ]

	(cWTabAlias)->(MsUnlock())

next i

return .T.

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funáao    ≥ R680ImpR4  ≥ Autor ≥ Marcelo Silveira      ≥ Data ≥05/11/2012≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descriáao ≥ Relatorio de Saldos e Salarios                               ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ GPER680                                                      ≥±±
±±≥Modificado≥ ≥ Denar Terrazas      					  ≥ Data ≥15/03/2019≥±±
±±≥Descriáao ≥ Modificado para imprimir en birt                             ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
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
	Local aVerba 	:= Array(15,2)
	Local aCols		:= ARRAY(NDATOS)
	Local aRet		:= {}
	Local lAddCol := .F.

	Local nPerEvent

	//nOrdem		:= 1//oReport:GetOrder()

	cPersona 	:= If( nPerEvent == 1, STR0010, STR0075) 	//1-PERMANENTE / 2-EVENTUAL
	cEmpMTrab	:= OemToAnsi(STR0009) +": "+ allTrim(FWCompanyName())
	// cEmpMTrab	:= OemToAnsi(STR0009) +": "+ If( fTabela("S007",1,5 ) <> Nil, fTabela("S007",1,5 ), " " )
	//cNomEmpr	:= If( (cNomEmpr := fTabela("S007",1,10 )) <> Nil, cNomEmpr, MV_PAR16 )
	//cNumDocId	:= If( (cNumDocId := fTabela("S007",1,11 )) <> Nil, cNumDocId, MV_PAR17 )

	If !Empty(cCompet)
		cPeriodo := SubStr(cCompet,3,4) + SubStr(cCompet,1,2)
	EndIf

	cSitQuery	:= ""
	if(nSituacao == 1)//Empleados vigentes
		cSituacao:= VIGENTES
	elseIf(nSituacao == 2)//Empleado despedidos
		cSituacao:= DESPEDIDOS
	else//Todos los empleados
		cSituacao:= TODOS
	endIf
	//If !Empty(cSituacao)
	For nReg:=1 to Len(cSituacao)
		cSitQuery += "'"+Subs(cSituacao,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cSituacao)
			cSitQuery += ","
		Endif
	Next nReg
	cSitQuery := "%" + cSitQuery + "%"
	//EndIf

	cCatQuery	:= ""
	//If !Empty(cSituacao)
	For nReg:=1 to Len(cCategoria)
		cCatQuery += "'"+Subs(cCategoria,nReg,1)+"'"
		If ( nReg+1 ) <= Len(cCategoria)
			cCatQuery += ","
		Endif
	Next nReg
	cCatQuery := "%" + cCatQuery + "%"
	//EndIf

	//Trata os roteiros para a query
	SelecRoteiros()
	For nX := 1 to Len(aRoteiros)
		cRoteiro += "'" + aRoteiros[nX, 1] + "'"
		If( nX+1 ) <=  Len(aRoteiros)
			cRoteiro += ","
		EndIf
	Next
	//TODO revisar funcion SelecRoteiros()
	cRoteiro:= "'FOL', 'FIN'"
	cRoteiro := "%" + cRoteiro + "%"

	cTpCiabol	:= ""
	if(nTpCiabol == 1)//Empleados vigentes
		cTpCiabol:= "N"
	elseIf(nTpCiabol == 2)//Empleado despedidos
		cTpCiabol:= "C"
	elseIf(nTpCiabol == 3)//Empleado despedidos
		cTpCiabol:= "E"
	else//Todos los empleados
		cTpCiabol:= "F"
	endIf

	//Trata os processos para a query
	/*nTamProc := GetSx3Cache( "RCJ_CODIGO", "X3_TAMANHO" )
	For nX := 1 to Len(Alltrim(cProcesso)) Step 5
	If Len(Subs(cProcesso,nX,5)) < nTamProc
	cAuxPrc := Subs(cProcesso,nX,5) + Space(nTamProc - Len(Subs(cProcesso,nX,5)))
	Else
	cAuxPrc := Subs(cProcesso,nX,5)
	EndIf
	cProcs += "'" + cAuxPrc + "',"
	Next nX
	cProcs := "%" + Substr( cProcs, 1, Len(cProcs)-1) + "%"*/

	cAliasFun := GetNextAlias()
	cAliasQry := GetNextAlias()

	lExeQry	  := .T.

	If(nOrdem == 1)
		cOrdFun   := "% RA_FILIAL, RA_MAT %"
		cOrdLan	  := "% RA_FILIAL, RA_MAT, PD, SEQ %"
		cCondicao := "(cAliasQry)->FILIAL == (cAliasFun)->RA_FILIAL .And. (cAliasQry)->RA_MAT == (cAliasFun)->RA_MAT"
	ElseIf(nOrdem == 2)
		cOrdFun   := "% RA_FILIAL, RA_CC, RA_MAT %"
		cOrdLan   := "% RA_FILIAL, RA_CC, RA_MAT, PD, SEQ %"
		cCondicao := "(cAliasQry)->FILIAL == (cAliasFun)->RA_FILIAL .And. (cAliasQry)->RA_CC == (cAliasFun)->RA_CC .And. (cAliasQry)->RA_MAT == (cAliasFun)->RA_MAT"
	else
		cOrdFun   := "% RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME %"
		cOrdLan	  := "% RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME %"
		cCondicao := "(cAliasQry)->FILIAL == (cAliasFun)->RA_FILIAL .And. (cAliasQry)->RA_MAT == (cAliasFun)->RA_MAT"
	EndIf

	cFilPd	:= If( Alltrim(FWModeAccess("SRV",3)) == "C", "%'" + xFilial("SRV") + "'%", "%SRA.RA_FILIAL%" )
	cFilPer	:= If( Alltrim(FWModeAccess("RCF",3)) == "C", "%'" + xFilial("RCF") + "'%", "%SRA.RA_FILIAL%" )

	BeginSql alias cAliasFun

		SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,			SRA.RA_CC,			SRA.RA_NOME,	SRA.RA_NOMECMP,	SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
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
		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRA.RA_XTPCIAB	= %Exp:cTpCiabol% AND
		SRC.RC_PROCES  IN (%exp:Upper(cProcesso)%)  	AND
		SRC.RC_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRC.RC_SEMANA =   %exp:Upper(cSemana)%   AND
		SRC.RC_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SRA.%notDel% AND SRC.%notDel% AND RCF.%notDel%

		UNION

		(SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,			SRA.RA_CC,			SRA.RA_NOME,	SRA.RA_NOMECMP,	SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
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
		WHERE	SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte% AND
		SRA.RA_MAT    BETWEEN %Exp:cMatDe% AND %Exp:cMatAte% AND
		SRA.RA_CC     BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%  AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRA.RA_XTPCIAB	= %Exp:cTpCiabol% AND
		SRD.RD_PROCES  IN (%exp:Upper(cProcesso)%)  	AND
		SRD.RD_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRD.RD_SEMANA =   %exp:Upper(cSemana)%   AND
		SRD.RD_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SRA.%notDel% AND SRD.%notDel% AND RCF.%notDel%)
		ORDER BY %exp:cOrdFun%

	EndSql
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL

	BeginSql alias cAliasQry

		SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,				SRA.RA_CC,				SRA.RA_NOME,	SRA.RA_NOMECMP,	SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
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
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRA.RA_XTPCIAB	= %Exp:cTpCiabol% AND
		SRC.RC_PROCES  IN (%exp:Upper(cProcesso)%)  	AND
		SRC.RC_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRC.RC_SEMANA =   %exp:Upper(cSemana)%   AND
		SRC.RC_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SRV.RV_INFSAL <> (%exp:""%) AND
		SRA.%notDel% AND SRC.%notDel% AND SRV.%notDel%

		UNION

		(SELECT SRA.RA_FILIAL,			SRA.RA_MAT,				SRA.RA_CC,				SRA.RA_NOME, SRA.RA_NOMECMP,	SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
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
		SRA.RA_SITFOLH	IN	(%exp:Upper(cSitQuery)%)	AND
		SRA.RA_CATFUNC	IN	(%exp:Upper(cCatQuery)%)	AND
		SRA.RA_XTPCIAB	= %Exp:cTpCiabol% AND
		SRD.RD_PROCES	IN	(%exp:Upper(cProcesso)%)		AND
		SRD.RD_PERIODO	=	%exp:Upper(cPeriodo)%		AND
		SRD.RD_SEMANA =   %exp:Upper(cSemana)%   AND
		SRD.RD_ROTEIR	IN	(%exp:Upper(cRoteiro)%)		AND
		SRV.RV_INFSAL	<>	(%exp:""%) AND
		SRA.%notDel% AND SRD.%notDel% AND SRV.%notDel%)
		ORDER BY %exp:cOrdLan%

	EndSql
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL
	(cAliasFun)->( dbGoTop())

	Do While (cAliasFun)->(!Eof())

		nDiaPgMes := 0
		nVHDiaPg  := 0

		For i := 1 To 15
			For iX := 1 to 2
				aVerba[i,iX] := 0
			Next iX
		Next i

		IF (cAliasFun)->RA_MAT <> cMatAnt .And. &cCondicao
			nDiaPgMes	:= (cAliasQry)->HORAS
		EndIf

		//(cAliasQry)->(dbGoTop())
		Do While (cAliasQry)->(!Eof()) .And. &cCondicao

			if(&cCondicao)
				If (cAliasQry)->CODFOL $ "0031|0048"
					nVHDiaPg := (cAliasFun)->RCF_HRSDIA
				EndIf

				If (cAliasQry)->RA_SALARIO > 0
					lAddCol := .T.
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
					Case (cAliasQry)->INFSAL == "Z"	//Z utilizado para anticipos
					aVerba[15,1] += (cAliasQry)->VALOR
				EndCase
			endif

			(cAliasQry)->(DbSkip())
		EndDo

		If lAddCol	//If aVerba[1,1] > 0

			aVerba[10,1] := aVerba[1,1] + aVerba[2,1] + aVerba[3,1] + aVerba[4,1] + aVerba[5,1] + aVerba[6,1]	//TOTAL GANADO (G)
			aVerba[11,1] := aVerba[7,1] + aVerba[8,1] + aVerba[9,1] + aVerba[15,1] 				 				//TOTAL DESCONTOS (L)
			aVerba[12,1] := aVerba[10,1] - aVerba[11,1] 														//LIQUIDO PAGABLE (N)

			aCols := ARRAY(NDATOS)
			cOcupa:= fDesc("SRJ",(cAliasFun)->RA_CODFUNC,"RJ_DESC")
			cOcupa:= Left(cOcupa, 1) + LOWER(Right(cOcupa, len(cOcupa)-1))

			aCols[NNUM       ]:= ( nQtdFun += 1 )
			aCols[NCI        ]:= ( AllTrim((cAliasFun)->RA_CIC) )
			aCols[NCIEXP	 ]:= ( AllTrim((cAliasFun)->RA_UFCI) )
			aCols[NAPELLIDOS ]:= ( (cAliasFun)->RA_NOMECMP )
			aCols[NNACIONAL  ]:= ( fDesc("SX5","34"+(cAliasFun)->RA_NACIONA,"X5_DESCRI") )
			aCols[NNASCIMENTO]:= ( (cAliasFun)->RA_NASC )
			aCols[NSEXO      ]:= ( (cAliasFun)->RA_SEXO )
			aCols[NOCUPACION ]:= ( cOcupa )
			aCols[NINGRESSO  ]:= ( (cAliasFun)->RA_ADMISSA )
			aCols[NDIASHPM   ]:= ( nDiaPgMes)
			aCols[NHORASDP   ]:= ( nVHDiaPg)
			aCols[NHABERB    ]:= ( aVerba[1,1])
			aCols[NBONOANT   ]:= ( aVerba[2,1])
			aCols[NHENUMERO  ]:= ( aVerba[3,2])
			aCols[NHEMONTO   ]:= ( aVerba[3,1])
			aCols[NREMBONO   ]:= ( aVerba[4,1])
			aCols[NREMOTROS  ]:= ( aVerba[5,1])
			aCols[NSDSRNUM   ]:= ( aVerba[6,2])
			aCols[NSDSRSUE   ]:= ( aVerba[6,1])
			aCols[NTOTGANADO ]:= ( aVerba[10,1])
			aCols[NDAFP      ]:= ( aVerba[7,1])
			aCols[NDRCIVA    ]:= ( aVerba[8,1])
			aCols[NANTICIPO	 ]:= ( aVerba[15,1])	//Anticipos
			aCols[NDODESC    ]:= ( aVerba[9,1])
			aCols[NTOTDCTOS  ]:= ( aVerba[11,1])
			aCols[NLIQUIDOP  ]:= ( aVerba[12,1])
			aCols[NFIRMA     ]:= ( cFirma )
			aCols[NMATRICULA ]:= ( (cAliasFun)->RA_MAT )
			aCols[NCCOSTO	 ]:= ( (cAliasFun)->RA_CC )
			aCols[NCCDESC	 ]:= ( TRIM(fDesc("CTT", (cAliasFun)->RA_CC, "CTT->CTT_DESC01", 30)) )
			aCols[NAGRUPADO	 ]:= ( nAgrupa )
			aCols[NSUCURSAL  ]:= ( (cAliasFun)->RA_FILIAL )
			aCols[NSUCNOMBR  ]:= ( FWFilName(FWCodEmp(), (cAliasFun)->RA_FILIAL) )
			aCols[NEMPCOD    ]:= ( SUBSTR((cAliasFun)->RA_FILIAL,1,2))
			aCols[NEMPDESC   ]:= ( TRIM(FWCompanyName())/*FWEmpName(SUBSTR((cAliasFun)->RA_FILIAL,1,2))*/)

			AADD(aRet, aCols)
			lAddCol:= .F.
		EndIf

		cMatAnt:= (cAliasFun)->RA_MAT
		(cAliasFun)->(DbSkip())

	EndDo

Return aRet

