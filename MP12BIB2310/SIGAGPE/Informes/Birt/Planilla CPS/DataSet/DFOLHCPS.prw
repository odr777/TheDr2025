#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'
#INCLUDE "GPER680.CH"
#INCLUDE "FIVEWIN.CH"

#DEFINE NDATOS			32

#DEFINE NCARNET			1
#DEFINE NMATCPS			2	//Matricula de la CPS
#DEFINE NNOMBRECMP		3
#DEFINE NOCUPACION		4
#DEFINE NINGRESSO		5
#DEFINE NRETIRO			6
#DEFINE NHABERB			7
#DEFINE NDIASPAG		8
#DEFINE NPBONOANT		9
#DEFINE NBONOANT		10
#DEFINE NHENUM			11
#DEFINE NHEMONTO		12
#DEFINE NHNNUM			13
#DEFINE NHNMONTO		14
#DEFINE NBONOPROD		15
#DEFINE NREMOTROS		16
#DEFINE NDOMNUM			17
#DEFINE NDOMMONTO		18
#DEFINE NTOTGANADO		19
#DEFINE NAFP			20
#DEFINE NRCIVA			21
#DEFINE NFALTASYAT		22
#DEFINE NOTROSDESC		23
#DEFINE NTOTALDESC		24
#DEFINE NLIQUIDO		25

#DEFINE NCCOSTO			26
#DEFINE NCCDESC			27	//Descripcion Centro de Costo
#DEFINE NAGRUPADO		28	//Agrupado por: 1:=Sucursal, 2:=Centro Costo
#DEFINE NSUCURSAL		29
#DEFINE NSUCNOMBR		30
#DEFINE NEMPCOD			31
#DEFINE NEMPDESC		32

#DEFINE VIGENTES	" A*FT"
#DEFINE DESPEDIDOS	"**D**"
#DEFINE TODOS		" ADFT"
#DEFINE CODFOLS		"% '0031', '0671', '0779', '0769', '0066', '0047' %"//'0031'=HB;'0671'=BA;'0779'=Dom.;'0769'=AFP TOTAL;'0066'=RC-IVA;'0047'=LIQ
#DEFINE HBCODFOL	"0031"
#DEFINE BACODFOL	"0671"
#DEFINE DOMCODFOL	"0779"
#DEFINE AFPCODFOL	"0769"
#DEFINE IVACODFOL	"0066"
#DEFINE LIQCODFOL	"0047"

#DEFINE OPCHE		"A"		//Horas Extras
#DEFINE OPCHN		"B"		//Horas Nocturnas
#DEFINE OPCBONOP	"C"		//Bono de Produccion
#DEFINE OPCOTRIN	"D"		//Otros Ingresos
#DEFINE OPCFYA		"E"		//Faltas y Atrasos
#DEFINE OPCOTRDE	"F"		//Otros Descuentos

User_Dataset DFOLHCPS
title "Planilla CPS"
description "Detalle de la planilla CPS"
PERGUNTE "FOLHACPS"

columns

define column CARNET        type 	character size (tamSX3("RA_RG")[1] + tamSX3("RA_ALFANUM")[1] + tamSX3("RA_UFCI")[1])		label	"CARNET"
define column MATCPS    	type 	character size tamSX3("RA_SEGUROS")[1]  						label	"MATCPS"
define column NOMBRECMP		type 	character size (tamSX3("RA_PRISOBR")[1] + tamSX3("RA_SECSOBR")[1] + tamSX3("RA_PRINOME")[1] + tamSX3("RA_SECNOME")[1])	label	"NOMBRECMP"
define column OCUPACION    	type 	character size tamSX3("RJ_DESC")[1]  							label	"OCUPACION"
define column INGRESSO     	type 	character size (tamSX3("RA_ADMISSA")[1] + 2)  					label	"INGRESSO"
define column RETIRO     	type 	character size (tamSX3("RA_DEMISSA")[1] + 2)  					label	"RETIRO"
define column HABERB       	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HABERB"
define column DIASPAG      	type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"DIASPAG"
define column PBONOANT      type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"PBONOANT"
define column BONOANT      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"BONOANT"
define column HENUM      	type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"HENUM"
define column HEMONTO      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HEMONTO"
define column HNNUM      	type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"HNNUM"
define column HNMONTO      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HNMONTO"
define column BONOPROD      type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"BONOPROD"
define column REMOTROS     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"REMOTROS"
define column DOMNUM      	type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"DOMNUM"
define column DOMMONTO      type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"DOMMONTO"
define column TOTGANADO    	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"TOTGANADO"
define column AFP         	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"AFP"
define column RCIVA       	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"RCIVA"
define column FALTASYAT		type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"FALTASYAT"
define column OTROSDESC     type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"OTROSDESC"
define column TOTALDESC     type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"TOTALDESC"
define column LIQUIDO     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"LIQUIDO"

define column CCOSTO    	type 	character size tamSX3("RA_CC")[1]  								label	"CCOSTO"
define column CCDESC    	type 	character size tamSX3("CTT_DESC01")[1]  						label	"CCDESC"
define column AGRUPADO    	type 	numeric size 1  												label	"AGRUPADO"
define column SUCURSAL    	type 	character size tamSX3("RA_FILIAL")[1]  							label	"SUCURSAL"
define column SUCNOMBR    	type 	character size 30					 							label	"SUCNOMBR"
define column EMPCOD    	type 	character size 04					 							label	"EMPCOD"
define column EMPDESC    	type 	character size 60					 							label	"EMPDESC"

//define column NOMEPROV   	type 	character size tamSX3("A2_NOME")[1]  				label	"NOMEPROV"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local aDetalle		:= {}

Private cProcesso 	:= self:execParamValue("MV_PAR01")
Private cCompet		:= self:execParamValue("MV_PAR02")
Private cSemana		:= self:execParamValue("MV_PAR03")
Private cFilDe   	:= self:execParamValue("MV_PAR04")
Private cFilAte  	:= self:execParamValue("MV_PAR05")
Private cCcDe    	:= self:execParamValue("MV_PAR06")
Private cCcAte   	:= self:execParamValue("MV_PAR07")
Private cMatDe   	:= self:execParamValue("MV_PAR08")
Private cMatAte  	:= self:execParamValue("MV_PAR09")
Private cSituacao  	:= self:execParamValue("MV_PAR10")
Private cCategoria 	:= self:execParamValue("MV_PAR11")
Private nOrdem		:= self:execParamValue("MV_PAR12")
Private nAgrupa		:= IIF(EMPTY(self:execParamValue("MV_PAR13")), 1, self:execParamValue("MV_PAR13"))//Agrupado por: 1:=Empresa, 2:=Sucursal, 3:=Centro Costo
Private aRoteiros	:= {}
Private cPeriodo	:= cCompet
Private cCodFols	:= CODFOLS
Private dDiaIniPer	:= Nil

Private aTabS011	:= {}

/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ mv_par01        //  Processo						           ³
³ MV_PAR02        //  Competencia                              ³
³ MV_PAR04        //  Filial  De                               ³
³ MV_PAR05        //  Filial  Ate                              ³
³ MV_PAR06        //  Centro de Custo De                       ³
³ MV_PAR07        //  Centro de Custo Ate                      ³
³ MV_PAR08        //  Matricula De                             ³
³ MV_PAR09        //  Matricula Ate                            ³
³ MV_PAR10        //  Situacao                                 ³
³ MV_PAR11        //  Categoria                                ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

aDetalle:= R680ImpR4()

cursorarrow()

for i:= 1 to len(aDetalle)

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)-> CARNET		:= aDetalle[i,NCARNET	]
	(cWTabAlias)-> MATCPS		:= aDetalle[i,NMATCPS	]
	(cWTabAlias)-> NOMBRECMP	:= aDetalle[i,NNOMBRECMP]
	(cWTabAlias)-> OCUPACION	:= aDetalle[i,NOCUPACION]
	(cWTabAlias)-> INGRESSO		:= DTOC(STOD(Trim(aDetalle[i, NINGRESSO])))
	(cWTabAlias)-> RETIRO		:= IIF(EMPTY(aDetalle[i, NRETIRO]), '', DTOC(STOD(Trim(aDetalle[i, NRETIRO]))))
	(cWTabAlias)-> HABERB		:= aDetalle[i,NHABERB	]
	(cWTabAlias)-> DIASPAG		:= aDetalle[i,NDIASPAG	]
	(cWTabAlias)-> PBONOANT		:= aDetalle[i,NPBONOANT	]
	(cWTabAlias)-> BONOANT		:= aDetalle[i,NBONOANT	]
	(cWTabAlias)-> HENUM		:= aDetalle[i,NHENUM	]
	(cWTabAlias)-> HEMONTO		:= aDetalle[i,NHEMONTO	]
	(cWTabAlias)-> HNNUM		:= aDetalle[i,NHNNUM	]
	(cWTabAlias)-> HNMONTO		:= aDetalle[i,NHNMONTO	]
	(cWTabAlias)-> BONOPROD		:= aDetalle[i,NBONOPROD	]
	(cWTabAlias)-> REMOTROS		:= aDetalle[i,NREMOTROS	]
	(cWTabAlias)-> DOMNUM		:= aDetalle[i,NDOMNUM	]
	(cWTabAlias)-> DOMMONTO		:= aDetalle[i,NDOMMONTO	]
	(cWTabAlias)-> TOTGANADO	:= aDetalle[i,NTOTGANADO]
	(cWTabAlias)-> AFP			:= aDetalle[i,NAFP		]
	(cWTabAlias)-> RCIVA		:= aDetalle[i,NRCIVA	]
	(cWTabAlias)-> FALTASYAT	:= aDetalle[i,NFALTASYAT]
	(cWTabAlias)-> OTROSDESC	:= aDetalle[i,NOTROSDESC]
	(cWTabAlias)-> TOTALDESC	:= aDetalle[i,NTOTALDESC]
	(cWTabAlias)-> LIQUIDO		:= aDetalle[i,NLIQUIDO	]

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
	Local nTotalGa	:= 0	//Total Ganado
	Local nTotDesc	:= 0	//Total Descuento
	Local cSitQuery	:= ""
	Local cCatQuery	:= ""
	Local cAuxPrc	:= ""
	Local cProcs	:= ""
	Local cCondicao := ""

	Local i			:= 0
	Local iX		:= 0
	Local nQtdFun	:= 0
	Local nTotPage	:= 0
	Local nPageAtu	:= 1
	Local aVerba 	:= Array(12,2)
	Local aCols		:= ARRAY(NDATOS)
	Local aRet		:= {}
	Local lAddCol	:= .F.
	Local cTab		:= "S011"
	Local cPDSolid	:= ""//Conceptos del fondo SOlidario (S011)

	Local nPerEvent

	//nOrdem		:= 1//oReport:GetOrder()

	if(!Empty(cPeriodo))
		dDiaIniPer:= dIniPer()
	EndIf

	fCarrTab ( @aTabS011, cTab, STOD(cPeriodo + '01'), .T.)
	//Se recorre el array para filtrar la sucursal del empleado
	for i:= 1 to Len(aTabS011)
		cPDSolid+= "'" + TRIM(aTabS011[i][8]) + "', "
	next i

	If(Len(cPDSolid) > 0)
		cPDSolid:= "% " + SUBSTRING(cPDSolid, 1, Len(cPDSolid) - 2) + " %"
	Else
		Alert("Revisar la configuración de la Tabla S011-Fondo Solidario en Mantenimiento de Tablas")
	EndIf

	cSitQuery	:= ""
	/*if(nSituacao == 1)//Empleados vigentes
	cSituacao:= VIGENTES
	elseIf(nSituacao == 2)//Empleado despedidos
	cSituacao:= DESPEDIDOS
	else//Todos los empleados
	cSituacao:= TODOS
	endIf*/
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

	//Trata os processos para a query

	cAliasQry := GetNextAlias()

	lExeQry	  := .T.

	If(nOrdem == 1)
		cOrdLan	  := "% RA_FILIAL, RA_MAT %"
	ElseIf(nOrdem == 2)
		cOrdLan   := "% RA_FILIAL, RA_CC, RA_MAT %"
	else
		cOrdLan	  := "% RA_PRISOBR, RA_SECSOBR, RA_PRINOME, RA_SECNOME %"
	EndIf

	BeginSql alias cAliasQry

		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, RA_UFCI, SRA.RA_SEGUROS, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,
		SRC.RC_PD, SRC.RC_HORAS, SRC.RC_VALOR, SRV.RV_CODFOL, SRV.RV_COD, SRV.RV_XINFCPS
		FROM %table:SRA% SRA
		JOIN %table:SRC% SRC ON SRA.RA_FILIAL = SRC.RC_FILIAL AND SRA.RA_MAT = SRC.RC_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRC.RC_PD
		WHERE SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte%
		AND SRA.RA_MAT BETWEEN %Exp:cMatDe% AND %Exp:cMatAte%
		AND SRA.RA_CC BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%
		AND SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%)
		AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%)
		AND SRC.RC_PROCES = %exp:Upper(cProcesso)%
		AND SRC.RC_PERIODO = %exp:Upper(cPeriodo)%
		AND SRC.RC_SEMANA = %exp:Upper(cSemana)%
		AND SRC.RC_ROTEIR IN ('FOL', 'FIN')
		AND SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:Upper(cPeriodo)%
		AND (SRA.RA_DEMISSA = '' OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:Upper(cPeriodo)%)
		AND (SRV.RV_XINFCPS <> '' OR SRV.RV_CODFOL IN (%exp:Upper(cCodFols)%) OR SRV.RV_COD IN (%exp:Upper(cPDSolid)%) )
		AND SRA.%notDel%
		AND SRC.%notDel%
		AND SRV.%notDel%
		UNION
		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, RA_UFCI, SRA.RA_SEGUROS, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,
		SRD.RD_PD, SRD.RD_HORAS, SRD.RD_VALOR, SRV.RV_CODFOL, SRV.RV_COD, SRV.RV_XINFCPS
		FROM %table:SRA% SRA
		JOIN %table:SRD% SRD ON SRA.RA_FILIAL = SRD.RD_FILIAL AND SRA.RA_MAT = SRD.RD_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRD.RD_PD
		WHERE SRA.RA_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte%
		AND SRA.RA_MAT BETWEEN %Exp:cMatDe% AND %Exp:cMatAte%
		AND SRA.RA_CC BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%
		AND SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%)
		AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%)
		AND SRD.RD_PROCES = %exp:Upper(cProcesso)%
		AND SRD.RD_PERIODO = %exp:Upper(cPeriodo)%
		AND SRD.RD_SEMANA = %exp:Upper(cSemana)%
		AND SRD.RD_ROTEIR IN ('FOL', 'FIN')
		AND SUBSTRING(SRA.RA_ADMISSA, 1, 6) <= %exp:Upper(cPeriodo)%
		AND (SRA.RA_DEMISSA = '' OR SUBSTRING(SRA.RA_DEMISSA, 1, 6) >= %exp:Upper(cPeriodo)%)
		AND (SRV.RV_XINFCPS <> '' OR SRV.RV_CODFOL IN (%exp:Upper(cCodFols)%) OR SRV.RV_COD IN (%exp:Upper(cPDSolid)%) )
		AND SRA.%notDel%
		AND SRD.%notDel%
		AND SRV.%notDel%
		ORDER BY %exp:cOrdLan%

	EndSql
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.t.)//   usar este en esste caso cuando es BEGIN SQL

	For i := 1 To 12
		For iX := 1 to 2
			aVerba[i,iX] := 0
		Next iX
	Next i

	While (cAliasQry)->(!Eof())
		cCondicao	:= (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT
		cCarnet		:= TRIM((cAliasQry)->RA_RG) + IIF(!EMPTY((cAliasQry)->RA_ALFANUM), "-" + TRIM((cAliasQry)->RA_ALFANUM), "") + " " + TRIM((cAliasQry)->RA_UFCI)
		cNombreCmp	:= TRIM((cAliasQry)->RA_PRISOBR) + " " + TRIM((cAliasQry)->RA_SECSOBR) + " " + TRIM((cAliasQry)->RA_PRINOME) + " " + TRIM((cAliasQry)->RA_SECNOME)
		cAdmissa	:= (cAliasQry)->RA_ADMISSA
		cDemissa	:= (cAliasQry)->RA_DEMISSA
		cMatCps		:= (cAliasQry)->RA_SEGUROS
		cSucursal	:= (cAliasQry)->RA_FILIAL
		cCodFunc	:= (cAliasQry)->RA_CODFUNC
		cCC			:= (cAliasQry)->RA_CC
		Do Case
			Case (cAliasQry)->RV_CODFOL == HBCODFOL	//Haber básico
			aVerba[1,1] += (cAliasQry)->RC_VALOR
			aVerba[1,2] += (cAliasQry)->RC_HORAS
			nTotalGa	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_CODFOL == BACODFOL	//Bono de Antiguedad
			aVerba[2,1] += (cAliasQry)->RC_VALOR
			aVerba[2,2] += (cAliasQry)->RC_HORAS
			nTotalGa	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_XINFCPS == OPCHE	//Horas extras
			aVerba[3,1] += (cAliasQry)->RC_VALOR
			aVerba[3,2] += (cAliasQry)->RC_HORAS
			nTotalGa	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_XINFCPS == OPCHN	//Horas nocturnas
			aVerba[4,1] += (cAliasQry)->RC_VALOR
			aVerba[4,2] += (cAliasQry)->RC_HORAS
			nTotalGa	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_XINFCPS == OPCBONOP	//Bono de Produccion
			aVerba[5,1] += (cAliasQry)->RC_VALOR
			nTotalGa	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_XINFCPS == OPCOTRIN	//Otros Ingresos
			aVerba[6,1] += (cAliasQry)->RC_VALOR
			nTotalGa	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_CODFOL == DOMCODFOL	//Dominical
			aVerba[7,1] += (cAliasQry)->RC_VALOR
			aVerba[7,2] += (cAliasQry)->RC_HORAS
			nTotalGa	+= (cAliasQry)->RC_VALOR
			Case ( (cAliasQry)->RV_CODFOL == AFPCODFOL .OR. ((cAliasQry)->RV_COD $ cPDSolid) )	//AFP's
			aVerba[8,1] += (cAliasQry)->RC_VALOR
			nTotDesc	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_CODFOL == IVACODFOL	//RC-IVA
			aVerba[9,1] += (cAliasQry)->RC_VALOR
			nTotDesc	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_XINFCPS == OPCFYA		//Faltas y Atrazos
			aVerba[10,1] += (cAliasQry)->RC_VALOR
			nTotDesc	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_XINFCPS == OPCOTRDE	//Otros Descuentos
			aVerba[11,1] += (cAliasQry)->RC_VALOR
			nTotDesc	+= (cAliasQry)->RC_VALOR
			Case (cAliasQry)->RV_CODFOL == LIQCODFOL	//Liquido Pagable
			aVerba[12,1] += (cAliasQry)->RC_VALOR
		EndCase

		(cAliasQry)->(DbSkip())
		If(cCondicao <> (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT)
			aCols := ARRAY(NDATOS)
			cOcupa:= fDesc("SRJ",cCodFunc,"RJ_DESC")
			//cOcupa:= Left(cOcupa, 1) + LOWER(Right(cOcupa, len(cOcupa)-1))

			aCols[NCARNET]		:= ( AllTrim(cCarnet) )
			aCols[NMATCPS]		:= ( cMatCps )
			aCols[NNOMBRECMP]	:= ( AllTrim(cNombreCmp) )
			aCols[NOCUPACION]	:= ( cOcupa )
			aCols[NINGRESSO]	:= ( cAdmissa )
			aCols[NRETIRO]		:= ( cDemissa )
			aCols[NHABERB]		:= ( aVerba[1,1])
			aCols[NDIASPAG]		:= ( aVerba[1,2])
			aCols[NPBONOANT]	:= ( aVerba[2,2])
			aCols[NBONOANT]		:= ( aVerba[2,1])
			aCols[NHENUM]		:= ( aVerba[3,2])
			aCols[NHEMONTO]		:= ( aVerba[3,1])
			aCols[NHNNUM]		:= ( aVerba[4,2])
			aCols[NHNMONTO]		:= ( aVerba[4,1])
			aCols[NBONOPROD]	:= ( aVerba[5,1])
			aCols[NREMOTROS]	:= ( aVerba[6,1])
			aCols[NDOMNUM]		:= ( aVerba[7,2])
			aCols[NDOMMONTO]	:= ( aVerba[7,1])
			aCols[NTOTGANADO]	:= ( nTotalGa )
			aCols[NAFP]			:= ( aVerba[8,1])
			aCols[NRCIVA]		:= ( aVerba[9,1])
			aCols[NFALTASYAT]	:= ( aVerba[10,1])
			aCols[NOTROSDESC]	:= ( aVerba[11,1])
			aCols[NTOTALDESC]	:= ( nTotDesc )
			aCols[NLIQUIDO]		:= ( aVerba[12,1])

			aCols[NCCOSTO	 ]:= cCC
			aCols[NCCDESC	 ]:= ( TRIM(fDesc("CTT", cCC, "CTT->CTT_DESC01", 30)) )
			aCols[NAGRUPADO	 ]:= ( nAgrupa )
			aCols[NSUCURSAL  ]:= ( cSucursal )
			aCols[NSUCNOMBR  ]:= ( FWFilName(FWCodEmp(), cSucursal) )
			aCols[NEMPCOD    ]:= ( SUBSTR(cSucursal,1,2))
			aCols[NEMPDESC   ]:= ( TRIM(FWCompanyName())/*FWEmpName(SUBSTR(cSucursal,1,2))*/)

			AADD(aRet, aCols)
			nTotalGa	:= 0
			nTotDesc	:= 0
			For i := 1 To 12
				For iX := 1 to 2
					aVerba[i,iX] := 0
				Next iX
			Next i

		EndIf
	EndDo

Return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 26/12/2019
* @description: Funcion que devuelve la fecha del dia de inicio del periodo para el calculo de los dias
trabajados para los empleados despedidos
*/
static function dIniPer()
	Local aArea	:= getArea()
	Local dRet	:= Nil
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT RFQ_DTINI
		FROM %table:RFQ% RFQ
		WHERE RFQ_MODULO = 'GPE'
		AND RFQ_PERIOD = %exp:cPeriodo%
		AND RFQ.%notdel%

	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		dRet:= STOD((OrdenConsul)->RFQ_DTINI)
	endIf
	restArea(aArea)
return dRet
