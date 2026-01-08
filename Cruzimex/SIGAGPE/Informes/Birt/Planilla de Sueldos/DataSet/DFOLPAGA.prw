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
#DEFINE NHABERB        11	//Haber basico
#DEFINE NSALARIO       12	//Salario Ganado
#DEFINE NSDSRNUM       13	//Dominical dias
#DEFINE NSDSRSUE       14	//Dominical monto
#DEFINE NRNHORA        15	//Recargo nocturno horas
#DEFINE NRNMONTO       16	//Recargo nocturno monto
#DEFINE NHENUMERO      17	//Horas extra
#DEFINE NHEMONTO       18	//Horas extra monto
#DEFINE NBONOANT       19	//Bono de antiguedad
#DEFINE NOTROSINGR     20	//Otros ingresos
#DEFINE NTOTCOTI       21	//Total cotizable
#DEFINE NNATSEP        22	//Natalidad o Sepelio
#DEFINE NTOTINGRESO    23	//Total ingresos
#DEFINE NDAFP          24	//Descuento AFP
#DEFINE NDRCIVA        25	//RC-IVA
#DEFINE NANTQUIN       26	//Anticipo Quincena
#DEFINE NMULTAS        27	//Multas
#DEFINE NSINDICATO     28	//Sindicato
#DEFINE NOTRODESC      29	//Otros descuentos
#DEFINE NTOTDCTOS      30	//Total descuentos
#DEFINE NLIQUIDOP      31	//Liquido pagable
#DEFINE NFIRMA         32	//Firma
#DEFINE NMATRICULA	   33	//Matricula
#DEFINE NCAJASALUD	   34	//Codigo Caja de Salud
#DEFINE NCCOSTO		   35	//Codigo Centro de Costo
#DEFINE NCCDESC        36	//Descripcion Centro de Costo

#DEFINE N0001		1	//"Salario Ganado"
#DEFINE N0002		2	//"Dominical"
#DEFINE N0003		3	//"Recargo Nocturno"
#DEFINE N0004		4	//"Horas Extras"
#DEFINE N0005		5	//"Bono de Antiguedad"
#DEFINE N0006		6	//"Otros Ingresos"
#DEFINE N0007		7	//"Natalidad o Sepelio"
#DEFINE N0008		8	//"Descuentos AFP"
#DEFINE N0009		9	//"RC-IVA"
#DEFINE N0010		10	//"Anticipo Quincena"
#DEFINE N0011		11	//"Multas"
#DEFINE N0012		12	//"Sindicato"
#DEFINE N0013		13	//"Otros Descuentos"
#DEFINE N0014		14	//"LÌquido Pagable"

#DEFINE VIGENTES	" A*FT"
#DEFINE DESPEDIDOS	"**D**"
#DEFINE TODOS		" ADFT"

User_Dataset DFOLPAGA
title "Planilla de sueldos"
description "Detalle de la planilla"
PERGUNTE "FOLPAGAM"

columns

define column NUM          	type 	numeric size 4 													label	"NUM"
define column CI           	type 	character size (tamSX3("RA_CIC")[1] + tamSX3("RA_UFCI")[1])  	label	"CI"
define column APELLIDOS    	type 	character size tamSX3("RA_NOMECMP")[1]  							label	"APELLIDOS"
define column NACIONAL     	type 	character size tamSX3("X5_DESCRI")[1]  							label	"NACIONAL"
define column NASCIMENTO   	type 	character size (tamSX3("RA_NASC")[1] + 2)  						label	"NASCIMENTO"
define column SEXO         	type 	character size tamSX3("RA_SEXO")[1]  							label	"SEXO"
define column OCUPACION    	type 	character size tamSX3("RJ_DESC")[1]  							label	"OCUPACION"
define column INGRESSO     	type 	character size (tamSX3("RA_ADMISSA")[1] + 2)  					label	"INGRESSO"
define column DIASHPM      	type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"DIASHPM"
define column HORASDP      	type 	numeric size tamSX3("RCF_HRSDIA")[1] 	decimals 2 				label	"HORASDP"
define column HABERB       	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HABERB"
define column SALARIO		type 	numeric size tamSX3("RA_SALARIO")[1] 	decimals 2 				label	"SALARIO"
define column SDSRNUM      	type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"SDSRNUM"
define column SDSRSUE      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"SDSRSUE"
define column RNHORA     	type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"RNHORA"
define column RNMONTO      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"RNMONTO"
define column HENUMERO     	type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"HENUMERO"
define column HEMONTO      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HEMONTO"
define column BONOANT      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"BONOANT"
define column OTROSING     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"OTROSING"
define column TOTCOTI     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"TOTCOTI"
define column NATSEP     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"NATSEP"
define column TOTINGRESO	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"TOTINGRESO"
define column DAFP         	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"DAFP"
define column DRCIVA       	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"DRCIVA"
define column ANTQUIN		type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"ANTQUIN"
define column MULTAS		type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"MULTAS"
define column SINDICATO		type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"SINDICATO"
define column OTRODESC		type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"OTRODESC"
define column TOTDCTOS     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"TOTDCTOS"
define column LIQUIDOP     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"LIQUIDOP"
define column FIRMA        	type 	character size 15												label	"FIRMA"
define column MATRICULA		type 	character size tamSX3("RA_MAT")[1] 								label	"MATRICULA"
define column CAJASALUD		type 	character size tamSX3("RA_SEGUROS")[1] 							label	"CAJASALUD"
define column CCOSTO    	type 	character size tamSX3("RA_CC")[1]  								label	"CCOSTO"
define column CCDESC    	type 	character size tamSX3("CTT_DESC01")[1]  						label	"CCDESC"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local aDetalle		:= {}
Local i

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
Private nSituacao  	:= self:execParamValue("MV_PAR12")
Private cSituacao  	:= VIGENTES
Private cCategoria 	:= self:execParamValue("MV_PAR13")
Private nPerEvent	:= self:execParamValue("MV_PAR14")
Private cNomEmpr	:= self:execParamValue("MV_PAR15")
Private cNumDocId	:= self:execParamValue("MV_PAR16")
Private nOrdem		:= self:execParamValue("MV_PAR17")
Private aRoteiros	:= {}

/*/
⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
≥ mv_par01        //  Processo						           ≥
≥ mv_par02        //  Roteiro							       ≥
≥ mv_par03        //  Competencia                              ≥
≥ mv_par04        //  Filial  De                               ≥
≥ mv_par05        //  Filial  Ate                              ≥
≥ mv_par06        //  Centro de Custo De                       ≥
≥ mv_par07        //  Centro de Custo Ate                      ≥
≥ mv_par08        //  Matricula De                             ≥
≥ mv_par09        //  Matricula Ate                            ≥
≥ mv_par10        //  Nome De                                  ≥
≥ mv_par11        //  Nome Ate                                 ≥
≥ mv_par12        //  Situacao                                 ≥
≥ mv_par13        //  Categoria                                ≥
≥ mv_par14        //  Personal - Eventual/Permanente           ≥
¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ/*/

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
	(cWTabAlias)-> APELLIDOS  := TRIM(aDetalle[i,NAPELLIDOS ])
	(cWTabAlias)-> NACIONAL   := TRIM(aDetalle[i,NNACIONAL  ])
	(cWTabAlias)-> NASCIMENTO := cFchNac
	(cWTabAlias)-> SEXO       := aDetalle[i,NSEXO      ]
	(cWTabAlias)-> OCUPACION  := TRIM(aDetalle[i,NOCUPACION ])
	(cWTabAlias)-> INGRESSO   := cFchAdm
	(cWTabAlias)-> DIASHPM    := aDetalle[i,NDIASHPM   ]
	(cWTabAlias)-> HORASDP    := aDetalle[i,NHORASDP   ]
	(cWTabAlias)-> HABERB     := aDetalle[i,NHABERB    ]
	(cWTabAlias)-> SALARIO    := aDetalle[i,NSALARIO   ]
	(cWTabAlias)-> SDSRNUM    := aDetalle[i,NSDSRNUM   ]
	(cWTabAlias)-> SDSRSUE    := aDetalle[i,NSDSRSUE   ]
	(cWTabAlias)-> RNHORA     := aDetalle[i,NRNHORA    ]
	(cWTabAlias)-> RNMONTO    := aDetalle[i,NRNMONTO   ]
	(cWTabAlias)-> HENUMERO   := aDetalle[i,NHENUMERO  ]
	(cWTabAlias)-> HEMONTO    := aDetalle[i,NHEMONTO   ]
	(cWTabAlias)-> BONOANT    := aDetalle[i,NBONOANT   ]
	(cWTabAlias)-> OTROSING   := aDetalle[i,NOTROSINGR ]
	(cWTabAlias)-> TOTCOTI    := aDetalle[i,NTOTCOTI   ]
	(cWTabAlias)-> NATSEP     := aDetalle[i,NNATSEP    ]
	(cWTabAlias)-> TOTINGRESO := aDetalle[i,NTOTINGRESO]
	(cWTabAlias)-> DAFP       := aDetalle[i,NDAFP      ]
	(cWTabAlias)-> DRCIVA     := aDetalle[i,NDRCIVA    ]
	(cWTabAlias)-> ANTQUIN    := aDetalle[i,NANTQUIN   ]
	(cWTabAlias)-> MULTAS     := aDetalle[i,NMULTAS    ]
	(cWTabAlias)-> SINDICATO  := aDetalle[i,NSINDICATO ]
	(cWTabAlias)-> OTRODESC   := aDetalle[i,NOTRODESC  ]
	(cWTabAlias)-> TOTDCTOS   := aDetalle[i,NTOTDCTOS  ]
	(cWTabAlias)-> LIQUIDOP   := aDetalle[i,NLIQUIDOP  ]
	(cWTabAlias)-> FIRMA      := aDetalle[i,NFIRMA     ]
	(cWTabAlias)-> MATRICULA  := aDetalle[i,NMATRICULA ]
	(cWTabAlias)-> CAJASALUD  := TRIM(aDetalle[i,NCAJASALUD ])
	(cWTabAlias)-> CCOSTO  	  := aDetalle[i,NCCOSTO    ]
	(cWTabAlias)-> CCDESC  	  := aDetalle[i,NCCDESC    ]

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
	Local aVerba 	:= Array(14,2)
	Local aCols		:= {}
	Local aRet		:= {}

	Local nPerEvent

	//nOrdem		:= oReport:GetOrder()

	cPersona 	:= If( nPerEvent == 1, STR0010, STR0075) 	//1-PERMANENTE / 2-EVENTUAL
	cEmpMTrab	:= OemToAnsi(STR0009) +": "+ allTrim(FWCompanyName())
	// cEmpMTrab	:= OemToAnsi(STR0009) +": "+ If( fTabela("S007",1,5 ) <> Nil, fTabela("S007",1,5 ), " " )
	//cNomEmpr	:= If( (cNomEmpr := fTabela("S007",1,10 )) <> Nil, cNomEmpr, mv_par15 )
	//cNumDocId	:= If( (cNumDocId := fTabela("S007",1,11 )) <> Nil, cNumDocId, mv_par16 )

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

		SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,			SRA.RA_CC,			SRA.RA_NOME,	SRA.RA_NOMECMP, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,		SRA.RA_SALARIO,		SRA.RA_SITFOLH,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,		SRA.RA_CIC,  		SRA.RA_UFCI,			SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,		SRA.RA_ADMISSA,		SRA.RA_CODFUNC,	SRA.RA_SEGUROS,
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
		SRA.RA_NOME   BETWEEN %Exp:cNomDe% AND %Exp:cNomAte% AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRC.RC_PROCES  IN (%exp:Upper(cProcs)%)  	AND
		SRC.RC_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRC.RC_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SRA.%notDel% AND SRC.%notDel% AND RCF.%notDel%

		UNION

		(SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,			SRA.RA_CC,			SRA.RA_NOME,	SRA.RA_NOMECMP, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,		SRA.RA_SALARIO,		SRA.RA_SITFOLH,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,		SRA.RA_CIC,  		SRA.RA_UFCI,			SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,		SRA.RA_ADMISSA,		SRA.RA_CODFUNC,	SRA.RA_SEGUROS,
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
		SRA.RA_NOME   BETWEEN %Exp:cNomDe% AND %Exp:cNomAte% AND
		SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%) AND
		SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%) AND
		SRD.RD_PROCES  IN (%exp:Upper(cProcs)%)  	AND
		SRD.RD_PERIODO =   %exp:Upper(cPeriodo)%   AND
		SRD.RD_ROTEIR  IN (%exp:Upper(cRoteiro)%)  AND
		SRA.%notDel% AND SRD.%notDel% AND RCF.%notDel%)
		ORDER BY %exp:cOrdFun%

	EndSql
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL

	BeginSql alias cAliasQry

		SELECT	SRA.RA_FILIAL,			SRA.RA_MAT,				SRA.RA_CC,				SRA.RA_NOME,	SRA.RA_NOMECMP, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,			SRA.RA_SALARIO,			SRA.RA_SITFOLH,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,			SRA.RA_CIC,				SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,			SRA.RA_ADMISSA,			SRA.RA_CODFUNC,	SRA.RA_SEGUROS,
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

		(SELECT SRA.RA_FILIAL,			SRA.RA_MAT,				SRA.RA_CC,				SRA.RA_NOME,	SRA.RA_NOMECMP, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME,
		SRA.RA_DEPTO,			SRA.RA_HRSMES,			SRA.RA_SALARIO,			SRA.RA_SITFOLH,
		SRA.RA_DTREC,			SRA.RA_CATFUNC,			SRA.RA_CIC,				SRA.RA_NACIONA,
		SRA.RA_NASC,			SRA.RA_SEXO,			SRA.RA_ADMISSA,			SRA.RA_CODFUNC,	SRA.RA_SEGUROS,
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
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL

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
			nDiaPgMes	:= (cAliasQry)->HORAS
		EndIf

		Do While (cAliasQry)->(!Eof()) .And. &cCondicao

			If (cAliasQry)->CODFOL $ "0031|0048"
				nVHDiaPg := (cAliasFun)->RCF_HRSDIA
			EndIf

			Do Case
				Case (cAliasQry)->INFSAL == "A"
				aVerba[N0001,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "B"
				aVerba[N0002,1] += (cAliasQry)->VALOR
				aVerba[N0002,2] += (cAliasQry)->HORAS
				Case (cAliasQry)->INFSAL == "C"
				aVerba[N0003,1] += (cAliasQry)->VALOR
				aVerba[N0003,2] += (cAliasQry)->HORAS
				Case (cAliasQry)->INFSAL == "D"
				aVerba[N0004,1] += (cAliasQry)->VALOR
				aVerba[N0004,2] += (cAliasQry)->HORAS
				Case (cAliasQry)->INFSAL == "E"
				aVerba[N0005,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "F"
				aVerba[N0006,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "G"
				aVerba[N0007,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "H"
				aVerba[N0008,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "I"
				aVerba[N0009,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "J"
				aVerba[N0010,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "K"
				aVerba[N0011,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "L"
				aVerba[N0012,1] += (cAliasQry)->VALOR
				Case (cAliasQry)->INFSAL == "M"
				aVerba[N0013,1] += (cAliasQry)->VALOR
				//				Case (cAliasQry)->INFSAL == "N"
				//				aVerba[N0014,1] += (cAliasQry)->VALOR
			EndCase

			(cAliasQry)->(DbSkip())
		EndDo

		If aVerba[N0001,1] > 0

			nTotCoti:= aVerba[N0001,1] + aVerba[N0002,1] + aVerba[N0003,1] + aVerba[N0004,1] + aVerba[N0005,1] + aVerba[N0006,1]
			nTotGana:= nTotCoti + aVerba[N0007,1]
			nTotDesc:= aVerba[N0008,1] + aVerba[N0009,1] + aVerba[N0010,1] + aVerba[N0011,1] + aVerba[N0012,1] + aVerba[N0013,1]
			nLiquido:= nTotGana - nTotDesc

			aCols := {}

			AADD(aCols, ( nQtdFun += 1 )                                                                    )
			AADD(aCols, ( /*PadL(*/ AllTrim((cAliasFun)->RA_CIC)/*, 12)*/ + AllTrim((cAliasFun)->RA_UFCI) ) )
			AADD(aCols, ( (cAliasFun)->RA_NOMECMP )                                                         )
			AADD(aCols, ( fDesc("SX5","34"+(cAliasFun)->RA_NACIONA,"X5_DESCRI") )                           )
			AADD(aCols, ( (cAliasFun)->RA_NASC )                                                            )
			AADD(aCols, ( (cAliasFun)->RA_SEXO )                                                            )
			AADD(aCols, ( fDesc("SRJ",(cAliasFun)->RA_CARGO,"RJ_DESC") )                                    )
			AADD(aCols, ( (cAliasFun)->RA_ADMISSA )                                                         )
			AADD(aCols, ( nDiaPgMes)                                                                        )
			AADD(aCols, ( nVHDiaPg)                                                                         )
			AADD(aCols, ( (cAliasFun)->RA_SALARIO)                                                          )
			AADD(aCols, ( aVerba[N0001,1])                                                                  )
			AADD(aCols, ( aVerba[N0002,2])                                                                  )
			AADD(aCols, ( aVerba[N0002,1])                                                                  )
			AADD(aCols, ( aVerba[N0003,2])                                                                  )
			AADD(aCols, ( aVerba[N0003,1])                                                                  )
			AADD(aCols, ( aVerba[N0004,2])                                                                  )
			AADD(aCols, ( aVerba[N0004,1])                                                                  )
			AADD(aCols, ( aVerba[N0005,1])                                                                  )
			AADD(aCols, ( aVerba[N0006,1])                                                                  )
			AADD(aCols, ( nTotCoti)                                                                         )
			AADD(aCols, ( aVerba[N0007,1])                                                                  )
			AADD(aCols, ( nTotGana)                                                                         )
			AADD(aCols, ( aVerba[N0008,1])                                                                  )
			AADD(aCols, ( aVerba[N0009,1])                                                                  )
			AADD(aCols, ( aVerba[N0010,1])                                                                  )
			AADD(aCols, ( aVerba[N0011,1])                                                                  )
			AADD(aCols, ( aVerba[N0012,1])                                                                  )
			AADD(aCols, ( aVerba[N0013,1])                                                                  )
			AADD(aCols, ( nTotDesc)                                                                         )
			AADD(aCols, ( nLiquido)                                                                         )
			AADD(aCols, ( cFirma )                                                                          )
			AADD(aCols, ( (cAliasFun)->RA_MAT )                                                             )
			AADD(aCols, ( (cAliasFun)->RA_SEGUROS )                                                         )
			AADD(aCols, ( (cAliasFun)->RA_CC )                                                              )
			AADD(aCols, ( TRIM(fDesc("CTT", (cAliasFun)->RA_CC, "CTT->CTT_DESC01", 30)) )                   )

			AADD(aRet, aCols)
		EndIf

		cMatAnt:= (cAliasFun)->RA_MAT
		(cAliasFun)->(DbSkip())

	EndDo

Return aRet

