#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'
#INCLUDE "GPER680.CH"
#INCLUDE "FIVEWIN.CH"

#DEFINE NDATOS         30

#DEFINE NCI            1
#DEFINE NCIEXP         2
#DEFINE NNACIONAL      3
#DEFINE NNASCIMENTO    4
#DEFINE NOCUPACION     5
#DEFINE NINGRESSO      6
#DEFINE NHABERB        7
#DEFINE NBONOANT       8
#DEFINE NHEMONTO       9
#DEFINE NREMBONO       10
#DEFINE NREMOTROS      11
#DEFINE NSDSRSUE       12
#DEFINE NTOTGANADO     13
#DEFINE NPRIMA	       14
#DEFINE NMATRICULA     15
#DEFINE NCCOSTO        16	//Codigo Centro de Costo
#DEFINE NCCDESC        17	//Descripcion Centro de Costo
#DEFINE NAGRUPADO      18	//Agrupado por: 1:=Sucursal, 2:=Centro Costo
#DEFINE NSUCURSAL      19
#DEFINE NSUCNOMBR      20
#DEFINE NEMPCOD        21
#DEFINE NEMPDESC       22
#DEFINE NRETIRO		   23
#DEFINE NMESESTRAB	   24
#DEFINE NAPPATERNO	   25
#DEFINE NAPMATERNO	   26
#DEFINE NPNOMBRE	   27
#DEFINE NOTRNOMBRE	   28
#DEFINE NSUBSFRONT	   29
#DEFINE NSEXO		   30

#DEFINE CODFOLS		"% '1276', '0775' %"//'1276'=Subs.Front.
#DEFINE SFCODFOL	"1276"//Subs.Front.
#DEFINE PRCODFOL	"0775"//Primas

#DEFINE OPCREMUN	"A"	//"Remuneraciones"
#DEFINE OPCBANTIG	"B"	//"Antiguedad"
#DEFINE OPCHEYN		"C"	//"Horas Extras y Nocturnas"
#DEFINE OPCBONOP	"D"	//"Bono de Produccion"
#DEFINE OPCDOM		"E"	//"Dominical"
#DEFINE OPCOTRB		"F"	//"Otros Bonos"

User_Dataset DFOLPRIM
title "Planilla de Primas"
description "Detalle de la planilla"
PERGUNTE "FOLHAPRI"

columns

define column CI           	type 	character size tamSX3("RA_RG")[1]								label	"CI"
define column APPATERNO		type 	character size tamSX3("RA_PRISOBR")[1]							label	"APPATERNO"
define column APMATERNO		type 	character size tamSX3("RA_SECSOBR")[1]							label	"APMATERNO"
define column PNOMBRE		type 	character size tamSX3("RA_PRINOME")[1]							label	"PNOMBRE"
define column OTRNOMBRE		type 	character size tamSX3("RA_SECNOME")[1]							label	"OTRNOMBRE"
define column CIEXP         type 	character size tamSX3("RA_UFCI")[1]								label	"CIEXP"
define column NACIONAL     	type 	character size tamSX3("X5_DESCRI")[1]  							label	"NACIONAL"
define column NASCIMENTO   	type 	character size (tamSX3("RA_NASC")[1] + 2)  						label	"NASCIMENTO"
define column SEXO         	type 	character size tamSX3("RA_SEXO")[1]								label	"SEXO"
define column OCUPACION    	type 	character size tamSX3("RJ_DESC")[1]  							label	"OCUPACION"
define column INGRESSO     	type 	character size (tamSX3("RA_ADMISSA")[1] + 2)  					label	"INGRESSO"
define column RETIRO     	type 	character size (tamSX3("RA_DEMISSA")[1] + 2)  					label	"RETIRO"
define column HABERB       	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HABERB"
define column BONOANT      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"BONOANT"
define column HEMONTO      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"HEMONTO"
define column REMBONO      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"REMBONO"
define column SUBSFRONT		type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"SUBSFRONT"
define column REMOTROS     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"REMOTROS"
define column SDSRSUE      	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"SDSRSUE"
define column TOTGANADO    	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"TOTGANADO"
define column PRIMA     	type 	numeric size tamSX3("RD_VALOR")[1] 		decimals 2 				label	"PRIMA"
define column MESESTRAB     type 	numeric size tamSX3("RD_HORAS")[1] 		decimals 2 				label	"MESESTRAB"
define column MATRICULA    	type 	character size tamSX3("RA_MAT")[1]  							label	"MATRICULA"
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
Private cNomEmpr	:= self:execParamValue("MV_PAR12")
Private cNumDocId	:= self:execParamValue("MV_PAR13")
Private nOrdem		:= self:execParamValue("MV_PAR14")
Private nAgrupa		:= IIF(EMPTY(self:execParamValue("MV_PAR15")), 1, self:execParamValue("MV_PAR15"))//Agrupado por: 1:=Empresa, 2:=Sucursal, 3:=Centro Costo
Private cCodFols	:= CODFOLS
Private dDiaIniPer	:= Nil
Private aTabS008	:= {}
Private cPerPago	:= ""	//Periodo de Pago de Prima

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

	(cWTabAlias)-> CI         := aDetalle[i,NCI        ]
	(cWTabAlias)-> APPATERNO  := aDetalle[i,NAPPATERNO ]
	(cWTabAlias)-> APMATERNO  := aDetalle[i,NAPMATERNO ]
	(cWTabAlias)-> PNOMBRE	  := aDetalle[i,NPNOMBRE   ]
	(cWTabAlias)-> OTRNOMBRE  := aDetalle[i,NOTRNOMBRE ]
	(cWTabAlias)-> CIEXP      := aDetalle[i,NCIEXP     ]
	(cWTabAlias)-> NACIONAL   := aDetalle[i,NNACIONAL  ]
	(cWTabAlias)-> NASCIMENTO := DTOC(STOD(Trim(aDetalle[i, NNASCIMENTO])))
	(cWTabAlias)-> SEXO  	  := aDetalle[i,NSEXO	   ]
	(cWTabAlias)-> OCUPACION  := aDetalle[i,NOCUPACION ]
	(cWTabAlias)-> INGRESSO   := DTOC(STOD(Trim(aDetalle[i, NINGRESSO])))
	(cWTabAlias)-> RETIRO	  := IIF(EMPTY(aDetalle[i, NRETIRO]), '', DTOC(STOD(Trim(aDetalle[i, NRETIRO]))))
	(cWTabAlias)-> HABERB     := aDetalle[i,NHABERB    ]
	(cWTabAlias)-> BONOANT    := aDetalle[i,NBONOANT   ]
	(cWTabAlias)-> HEMONTO    := aDetalle[i,NHEMONTO   ]
	(cWTabAlias)-> REMBONO    := aDetalle[i,NREMBONO   ]
	(cWTabAlias)-> SUBSFRONT  := aDetalle[i,NSUBSFRONT ]
	(cWTabAlias)-> REMOTROS   := aDetalle[i,NREMOTROS  ]
	(cWTabAlias)-> SDSRSUE    := aDetalle[i,NSDSRSUE   ]
	(cWTabAlias)-> TOTGANADO  := aDetalle[i,NTOTGANADO ]
	(cWTabAlias)-> MESESTRAB  := aDetalle[i,NMESESTRAB ]
	(cWTabAlias)-> PRIMA  	  := aDetalle[i,NPRIMA ]
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
	Local nTotalGa	:= 0
	Local cSitQuery	:= ""
	Local cCatQuery	:= ""
	Local cAuxPrc	:= ""
	Local cProcs	:= ""
	Local cCondicao := ""
	Local cPrCodFol	:= PRCODFOL
	Local cSFCodFol	:= SFCODFOL

	Local i			:= 0
	Local iX		:= 0
	Local nQtdFun	:= 0
	Local nTotPage	:= 0
	Local nPageAtu	:= 1
	Local aVerba 	:= Array(8,2)
	Local aCols		:= ARRAY(NDATOS)
	Local cPerFin	:= ""	//Periodo de Fin
	Local cPerBusq	:= ""	//Periodos de búsqueda
	Local aRet		:= {}

	Local cTab		:= "S008"

	Local lDespedido:= .F.

	fCarrTab ( @aTabS008, cTab, Date(), .T.)
	//Se recorre el array para obtener los periodos: Final y de Pago
	for i:= 1 to Len(aTabS008)
		if( SUBSTR( ALLTRIM(aTabS008[i][5]), 1, 4 ) == ALLTRIM(cCompet) )
			cPerFin:= aTabS008[i][6]
			cPerPago:= aTabS008[i][7]
			exit
		endIf
	next i

	cPerBusq:= getPeriodosPrima(cPerFin)

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

		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, RA_UFCI, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_NACIONA, SRA.RA_NASC, SRA.RA_SEXO, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,
		SRC.RC_PERIODO, SRC.RC_PD, SRC.RC_HORAS, SRC.RC_VALOR, SRV.RV_CODFOL, SRV.RV_INFSAL
		FROM %table:SRA% SRA
		JOIN %table:SRC% SRC ON SRA.RA_FILIAL = SRC.RC_FILIAL AND SRA.RA_MAT = SRC.RC_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRC.RC_PD
		WHERE SRC.RC_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte%
		AND SRA.RA_MAT BETWEEN %Exp:cMatDe% AND %Exp:cMatAte%
		AND SRC.RC_CC BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%
		AND SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%)
		AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%)
		AND SRC.RC_PROCES = %exp:Upper(cProcesso)%
		AND SRC.RC_PERIODO = %exp:Upper(cPerPago)%
		AND SRC.RC_SEMANA = %exp:Upper(cSemana)%
		AND SRC.RC_ROTEIR IN ('FOL')
		AND SRV.RV_CODFOL = %exp:cPrCodFol%
		AND SRA.RA_RESCRAI NOT IN ('30', '31')
		AND SRA.%notDel%
		AND SRC.%notDel%
		AND SRV.%notDel%
		UNION
		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, SRA.RA_UFCI, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_NACIONA, SRA.RA_NASC, SRA.RA_SEXO, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,
		SRD.RD_PERIODO, SRD.RD_PD, SRD.RD_HORAS, SRD.RD_VALOR, SRV.RV_CODFOL, SRV.RV_INFSAL
		FROM %table:SRA% SRA
		JOIN %table:SRD% SRD ON SRA.RA_FILIAL = SRD.RD_FILIAL AND SRA.RA_MAT = SRD.RD_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRD.RD_PD
		WHERE SRD.RD_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte%
		AND SRA.RA_MAT BETWEEN %Exp:cMatDe% AND %Exp:cMatAte%
		AND SRD.RD_CC BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%
		AND SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%)
		AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%)
		AND SRD.RD_PROCES = %exp:Upper(cProcesso)%
		AND SRD.RD_PERIODO = %exp:Upper(cPerPago)%
		AND SRD.RD_SEMANA = %exp:Upper(cSemana)%
		AND SRD.RD_ROTEIR IN ('FOL')
		AND SRV.RV_CODFOL = %exp:cPrCodFol%
		AND SRA.RA_RESCRAI NOT IN ('30', '31')
		AND SRA.%notDel%
		AND SRD.%notDel%
		AND SRV.%notDel%
		UNION
		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, SRA.RA_UFCI, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_NACIONA, SRA.RA_NASC, SRA.RA_SEXO, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,
		SRD.RD_PERIODO, SRD.RD_PD, SRD.RD_HORAS, SRD.RD_VALOR, SRV.RV_CODFOL, SRV.RV_INFSAL
		FROM %table:SRA% SRA
		JOIN %table:SRD% SRD ON SRA.RA_FILIAL = SRD.RD_FILIAL AND SRA.RA_MAT = SRD.RD_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRD.RD_PD
		WHERE
		SRD.RD_MAT IN
		(
		SELECT SRA.RA_MAT
		FROM %table:SRA% SRA
		JOIN %table:SRC% SRC ON SRA.RA_FILIAL = SRC.RC_FILIAL AND SRA.RA_MAT = SRC.RC_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRC.RC_PD
		WHERE SRC.RC_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte%
		AND SRA.RA_MAT BETWEEN %Exp:cMatDe% AND %Exp:cMatAte%
		AND SRC.RC_CC BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%
		AND SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%)
		AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%)
		AND SRC.RC_PROCES = %exp:Upper(cProcesso)%
		AND SRC.RC_PERIODO = %exp:Upper(cPerPago)%
		AND SRC.RC_SEMANA = %exp:Upper(cSemana)%
		AND SRC.RC_ROTEIR IN ('FOL')
		AND SRV.RV_CODFOL = %exp:cPrCodFol%
		AND SRA.RA_RESCRAI NOT IN ('30', '31')
		AND SRA.%notDel%
		AND SRC.%notDel%
		AND SRV.%notDel%
		UNION
		SELECT SRA.RA_MAT
		FROM %table:SRA% SRA
		JOIN %table:SRD% SRD ON SRA.RA_FILIAL = SRD.RD_FILIAL AND SRA.RA_MAT = SRD.RD_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRD.RD_PD
		WHERE SRD.RD_FILIAL BETWEEN %Exp:cFilDe% AND %Exp:cFilAte%
		AND SRA.RA_MAT BETWEEN %Exp:cMatDe% AND %Exp:cMatAte%
		AND SRD.RD_CC BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%
		AND SRA.RA_SITFOLH IN (%exp:Upper(cSitQuery)%)
		AND SRA.RA_CATFUNC IN (%exp:Upper(cCatQuery)%)
		AND SRD.RD_PROCES = %exp:Upper(cProcesso)%
		AND SRD.RD_PERIODO = %exp:Upper(cPerPago)%
		AND SRD.RD_SEMANA = %exp:Upper(cSemana)%
		AND SRD.RD_ROTEIR IN ('FOL')
		AND SRV.RV_CODFOL = %exp:cPrCodFol%
		AND SRA.RA_RESCRAI NOT IN ('30', '31')
		AND SRA.%notDel%
		AND SRD.%notDel%
		AND SRV.%notDel%
		)
		AND SRD.RD_PERIODO IN (%exp:Upper(cPerBusq)%)
		AND SRD.RD_SEMANA = %exp:Upper(cSemana)%
		AND SRD.RD_ROTEIR IN ('FOL')
		AND (SRV.RV_INFSAL <> '' OR SRV.RV_CODFOL = %exp:cSFCodFol%)
		AND SRV.RV_PRIMA = '1'
		AND SRA.RA_RESCRAI NOT IN ('30', '31')
		AND SRA.%notDel%
		AND SRD.%notDel%
		AND SRV.%notDel%
		ORDER BY %exp:cOrdLan%

	EndSql
	//cQuery:=GetLastQuery()
	//Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.t.)//   usar este en esste caso cuando es BEGIN SQL

	For i := 1 To 8
		For iX := 1 to 2
			aVerba[i,iX] := 0
		Next iX
	Next i

	While (cAliasQry)->(!Eof())
		cCondicao	:= (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT
		cRg			:= (cAliasQry)->RA_RG
		cPriSobr	:= (cAliasQry)->RA_PRISOBR
		cSecSobr	:= (cAliasQry)->RA_SECSOBR
		cPriNome	:= (cAliasQry)->RA_PRINOME
		cSecNome	:= (cAliasQry)->RA_SECNOME
		cUfci		:= (cAliasQry)->RA_UFCI
		cNaciona	:= (cAliasQry)->RA_NACIONA
		cNasc		:= (cAliasQry)->RA_NASC
		cSexo		:= (cAliasQry)->RA_SEXO
		cAdmissa	:= (cAliasQry)->RA_ADMISSA
		cDemissa	:= (cAliasQry)->RA_DEMISSA
		cMat		:= (cAliasQry)->RA_MAT
		cCC			:= (cAliasQry)->RA_CC
		cSucursal	:= (cAliasQry)->RA_FILIAL
		cCodFunc	:= (cAliasQry)->RA_CODFUNC

		If( !EMPTY(cDemissa) .AND. STOD(cDemissa) < STOD(cPerPago + '01'))
			lDespedido:= .T.
		Else
			lDespedido:= .F.

			Do Case
				Case (cAliasQry)->RV_INFSAL == OPCBONOP	//Bono de Produccion
				aVerba[1,1] += (cAliasQry)->RC_VALOR
				nTotalGa	+= (cAliasQry)->RC_VALOR
				Case (cAliasQry)->RV_INFSAL == OPCHEYN	//Horas extras y Nocturnas
				aVerba[2,1] += (cAliasQry)->RC_VALOR
				nTotalGa	+= (cAliasQry)->RC_VALOR
				Case (cAliasQry)->RV_INFSAL == OPCDOM	//Dominical
				aVerba[3,1] += (cAliasQry)->RC_VALOR
				nTotalGa	+= (cAliasQry)->RC_VALOR
				Case (cAliasQry)->RV_INFSAL == OPCOTRB	//Otros bonos
				aVerba[4,1] += (cAliasQry)->RC_VALOR
				nTotalGa	+= (cAliasQry)->RC_VALOR
				Case (cAliasQry)->RV_INFSAL == OPCREMUN	//Haber básico
				aVerba[5,1] += (cAliasQry)->RC_VALOR
				nTotalGa	+= (cAliasQry)->RC_VALOR
				Case (cAliasQry)->RV_INFSAL == OPCBANTIG//Bono de Antiguedad
				aVerba[6,1] += (cAliasQry)->RC_VALOR
				nTotalGa	+= (cAliasQry)->RC_VALOR
				Case (cAliasQry)->RV_CODFOL == SFCODFOL	//Subsidio de Frontera
				aVerba[7,1] += (cAliasQry)->RC_VALOR
				nTotalGa	+= (cAliasQry)->RC_VALOR
				Case (cAliasQry)->RV_CODFOL == PRCODFOL	//Primas
				aVerba[8,1] += (cAliasQry)->RC_VALOR
				aVerba[8,2] += (cAliasQry)->RC_HORAS
			EndCase

		EndIf

		(cAliasQry)->(DbSkip())
		If(cCondicao <> (cAliasQry)->RA_FILIAL + (cAliasQry)->RA_MAT)

			If(lDespedido)
				aDesp:= valoresDespedidos(cMat, STOD(cAdmissa), STOD(cDemissa))
				If(len(aDesp) > 0)
					AADD(aRet, aDesp[1])
				EndIf
			Else
				If(aVerba[8,1] > 0)//Sólo se imprime si el empleado tiene el concepto de Primas
					aCols := ARRAY(NDATOS)
					cOcupa:= fDesc("SRJ",cCodFunc,"RJ_DESC")
					cOcupa:= Left(cOcupa, 1) + LOWER(Right(cOcupa, len(cOcupa)-1))

					aCols[NCI        ]:= ( AllTrim(cRg) )
					aCols[NAPPATERNO ]:= ( AllTrim(cPriSobr) )
					aCols[NAPMATERNO ]:= ( AllTrim(cSecSobr) )
					aCols[NPNOMBRE	 ]:= ( AllTrim(cPriNome) )
					aCols[NOTRNOMBRE ]:= ( AllTrim(cSecNome) )
					aCols[NCIEXP	 ]:= ( AllTrim(cUfci) )
					aCols[NNACIONAL  ]:= ( fDesc("SX5","34"+cNaciona,"X5_DESCRI") )
					aCols[NNASCIMENTO]:= ( cNasc )
					aCols[NSEXO		 ]:= ( cSexo )
					aCols[NOCUPACION ]:= ( cOcupa )
					aCols[NINGRESSO  ]:= ( cAdmissa )
					aCols[NRETIRO	 ]:= ( cDemissa )
					aCols[NHABERB    ]:= ( aVerba[5,1] / 3)
					aCols[NBONOANT   ]:= ( aVerba[6,1] / 3)
					aCols[NHEMONTO   ]:= ( aVerba[2,1] / 3)
					aCols[NREMBONO   ]:= ( aVerba[1,1] / 3)
					aCols[NSUBSFRONT ]:= ( aVerba[7,1] / 3)
					aCols[NREMOTROS  ]:= ( aVerba[4,1] / 3)
					aCols[NSDSRSUE   ]:= ( aVerba[3,1] / 3)
					aCols[NTOTGANADO ]:= ( nTotalGa / 3 )
					aCols[NPRIMA 	 ]:= ( aVerba[8,1])
					aCols[NMESESTRAB ]:= ( aVerba[8,2] / 3)
					aCols[NMATRICULA ]:= ( cMat )
					aCols[NCCOSTO	 ]:= ( cCC )
					aCols[NCCDESC	 ]:= ( TRIM(fDesc("CTT", cCC, "CTT->CTT_DESC01", 30)) )
					aCols[NAGRUPADO	 ]:= ( nAgrupa )
					aCols[NSUCURSAL  ]:= ( cSucursal )
					aCols[NSUCNOMBR  ]:= ( FWFilName(FWCodEmp(), cSucursal) )
					aCols[NEMPCOD    ]:= ( SUBSTR(cSucursal,1,2))
					aCols[NEMPDESC   ]:= ( TRIM(FWCompanyName())/*FWEmpName(SUBSTR(cSucursal,1,2))*/)

					AADD(aRet, aCols)

				EndIF

				nTotalGa  := 0
				For i := 1 To 8
					For iX := 1 to 2
						aVerba[i,iX] := 0
					Next iX
				Next i
			EndIf

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

/**
*
* @author: Denar Terrazas Parada
* @since: 09/09/2020
* @description: Función que devuelve los periodos de los 3 meses que fueron tomados para el cálculo de las Primas
*/
static function getPeriodosPrima(cPerFin)
	Local aArea	:= getArea()
	Local cRet	:= ""
	Local OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT TOP 3 RCH_PER
		FROM %table:RCH% RCH
		WHERE RCH_FILIAL = %exp:xFilial('RCH')%
		AND RCH_PROCES = %exp:cProcesso%
		AND RCH_ROTEIR = 'FOL'
		AND RCH_PER <= %exp:cPerFin%
		AND RCH.%notdel%
		ORDER BY 1 DESC

	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		While (OrdenConsul)->(!Eof())
			cRet+= "'" + (OrdenConsul)->RCH_PER + "', "
			(OrdenConsul)->(dbSkip())
		Enddo
		cRet:= "% " + SUBSTR(cRet, 1, (LEN(cRet) - 2)) + " %"
	else
		cRet:= "%%"
	endIf
	restArea(aArea)
return cRet

/**
*
* @author: Denar Terrazas Parada
* @since: 03/12/2020
* @description: Función para obtener los valores de los empleados que fueron despedidos antes del periodo de la prima
*/
static function valoresDespedidos(cMat, dAdmissa, dDemissa)
	Local aArea			:= getArea()
	Local aRet			:= {}
	Local OrdenConsul	:= GetNextAlias()
	Local nNroMeses		:= 0 //Meses trabajados
	Local cPeriodos		:= ""
	Local cPerFin		:= ""

	Local cCondicao := ""
	Local cPrCodFol	:= PRCODFOL
	Local cSFCodFol	:= SFCODFOL
	Local aVerba	:= Array(8,2)
	Local nTotalGa	:= 0

	nNroMeses := DATEDIFFMONTH( dAdmissa , dDemissa ) + 1
	IF ( nNroMeses == 4 )
		cPerFin:= MESANO(dDemissa)
		IF ( FIRSTDATE(dAdmissa) == dAdmissa  .AND. LASTDATE(dDemissa) <> dDemissa )
			cPerFin:= CVALTOCHAR(VAL(MESANO(dDemissa)) - 1)
		EndIF
	EndIF

	IF ( nNroMeses > 4 )
		IF ( LASTDATE(dDemissa) == dDemissa )
			cPerFin:= MESANO(dDemissa)
		EndIF
		IF ( LASTDATE(dDemissa) <> dDemissa )
			cPerFin:= CVALTOCHAR(VAL(MESANO(dDemissa)) - 1)
		EndIF
	EndIF
	cPeriodos:= getPeriodosPrima(cPerFin)

	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, RA_UFCI, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_NACIONA, SRA.RA_NASC, SRA.RA_SEXO, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,
		SRC.RC_PERIODO, SRC.RC_PD, SRC.RC_HORAS, SRC.RC_VALOR, SRV.RV_CODFOL, SRV.RV_INFSAL
		FROM %table:SRA% SRA
		JOIN %table:SRC% SRC ON SRA.RA_FILIAL = SRC.RC_FILIAL AND SRA.RA_MAT = SRC.RC_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRC.RC_PD
		WHERE SRA.RA_MAT = %Exp:cMat%
		AND SRC.RC_CC BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%
		AND SRC.RC_PROCES = %exp:Upper(cProcesso)%
		AND SRC.RC_PERIODO = %exp:Upper(cPerPago)%
		AND SRC.RC_SEMANA = %exp:Upper(cSemana)%
		AND SRC.RC_ROTEIR IN ('FOL')
		AND SRV.RV_CODFOL = %exp:cPrCodFol%
		AND SRA.%notDel%
		AND SRC.%notDel%
		AND SRV.%notDel%
		UNION
		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, SRA.RA_UFCI, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_NACIONA, SRA.RA_NASC, SRA.RA_SEXO, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,
		SRD.RD_PERIODO, SRD.RD_PD, SRD.RD_HORAS, SRD.RD_VALOR, SRV.RV_CODFOL, SRV.RV_INFSAL
		FROM %table:SRA% SRA
		JOIN %table:SRD% SRD ON SRA.RA_FILIAL = SRD.RD_FILIAL AND SRA.RA_MAT = SRD.RD_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRD.RD_PD
		WHERE SRA.RA_MAT = %Exp:cMat%
		AND SRD.RD_CC BETWEEN %Exp:cCcDe%  AND %Exp:cCcAte%
		AND SRD.RD_PROCES = %exp:Upper(cProcesso)%
		AND SRD.RD_PERIODO = %exp:Upper(cPerPago)%
		AND SRD.RD_SEMANA = %exp:Upper(cSemana)%
		AND SRD.RD_ROTEIR IN ('FOL')
		AND SRV.RV_CODFOL = %exp:cPrCodFol%
		AND SRA.%notDel%
		AND SRD.%notDel%
		AND SRV.%notDel%

		UNION

		SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_RG, SRA.RA_ALFANUM, SRA.RA_UFCI, SRA.RA_CC, SRA.RA_PRISOBR, SRA.RA_SECSOBR, SRA.RA_PRINOME, SRA.RA_SECNOME, SRA.RA_NACIONA, SRA.RA_NASC, SRA.RA_SEXO, SRA.RA_CODFUNC, SRA.RA_ADMISSA, SRA.RA_DEMISSA,
		SRD.RD_PERIODO, SRD.RD_PD, SRD.RD_HORAS, SRD.RD_VALOR, SRV.RV_CODFOL, SRV.RV_INFSAL
		FROM %table:SRA% SRA
		JOIN %table:SRD% SRD ON SRA.RA_FILIAL = SRD.RD_FILIAL AND SRA.RA_MAT = SRD.RD_MAT
		JOIN %table:SRV% SRV ON SRV.RV_COD = SRD.RD_PD
		WHERE SRA.RA_MAT = %Exp:cMat%
		AND SRD.RD_PERIODO IN (%exp:Upper(cPeriodos)%)
		AND SRD.RD_SEMANA = %Exp:cSemana%
		AND SRD.RD_ROTEIR IN ('FOL')
		AND (SRV.RV_INFSAL <> '' OR SRV.RV_CODFOL = '1276')
		AND SRV.RV_PRIMA = '1'
		AND SRA.%notdel%
		AND SRD.%notdel%
		AND SRV.%notdel%
		ORDER BY RA_FILIAL, RA_MAT

	EndSql

	DbSelectArea(OrdenConsul)

	For i := 1 To 8
		For iX := 1 to 2
			aVerba[i,iX] := 0
		Next iX
	Next i

	While (OrdenConsul)->(!Eof())
		cCondicao	:= (OrdenConsul)->RA_FILIAL + (OrdenConsul)->RA_MAT
		cRg			:= (OrdenConsul)->RA_RG
		cPriSobr	:= (OrdenConsul)->RA_PRISOBR
		cSecSobr	:= (OrdenConsul)->RA_SECSOBR
		cPriNome	:= (OrdenConsul)->RA_PRINOME
		cSecNome	:= (OrdenConsul)->RA_SECNOME
		cUfci		:= (OrdenConsul)->RA_UFCI
		cNaciona	:= (OrdenConsul)->RA_NACIONA
		cNasc		:= (OrdenConsul)->RA_NASC
		cSexo		:= (OrdenConsul)->RA_SEXO
		cAdmissa	:= (OrdenConsul)->RA_ADMISSA
		cDemissa	:= (OrdenConsul)->RA_DEMISSA
		cMat		:= (OrdenConsul)->RA_MAT
		cCC			:= (OrdenConsul)->RA_CC
		cSucursal	:= (OrdenConsul)->RA_FILIAL
		cCodFunc	:= (OrdenConsul)->RA_CODFUNC
		Do Case
			Case (OrdenConsul)->RV_INFSAL == OPCBONOP	//Bono de Produccion
			aVerba[1,1] += (OrdenConsul)->RC_VALOR
			nTotalGa	+= (OrdenConsul)->RC_VALOR
			Case (OrdenConsul)->RV_INFSAL == OPCHEYN	//Horas extras y Nocturnas
			aVerba[2,1] += (OrdenConsul)->RC_VALOR
			nTotalGa	+= (OrdenConsul)->RC_VALOR
			Case (OrdenConsul)->RV_INFSAL == OPCDOM	//Dominical
			aVerba[3,1] += (OrdenConsul)->RC_VALOR
			nTotalGa	+= (OrdenConsul)->RC_VALOR
			Case (OrdenConsul)->RV_INFSAL == OPCOTRB	//Otros bonos
			aVerba[4,1] += (OrdenConsul)->RC_VALOR
			nTotalGa	+= (OrdenConsul)->RC_VALOR
			Case (OrdenConsul)->RV_INFSAL == OPCREMUN	//Haber básico
			aVerba[5,1] += (OrdenConsul)->RC_VALOR
			nTotalGa	+= (OrdenConsul)->RC_VALOR
			Case (OrdenConsul)->RV_INFSAL == OPCBANTIG//Bono de Antiguedad
			aVerba[6,1] += (OrdenConsul)->RC_VALOR
			nTotalGa	+= (OrdenConsul)->RC_VALOR
			Case (OrdenConsul)->RV_CODFOL == SFCODFOL	//Subsidio de Frontera
			aVerba[7,1] += (OrdenConsul)->RC_VALOR
			nTotalGa	+= (OrdenConsul)->RC_VALOR
			Case (OrdenConsul)->RV_CODFOL == PRCODFOL	//Primas
			aVerba[8,1] += (OrdenConsul)->RC_VALOR
			aVerba[8,2] += (OrdenConsul)->RC_HORAS
		EndCase

		(OrdenConsul)->(DbSkip())
		If(cCondicao <> (OrdenConsul)->RA_FILIAL + (OrdenConsul)->RA_MAT)

			If(aVerba[8,1] > 0)//Sólo se imprime si el empleado tiene el concepto de Primas
				aCols := ARRAY(NDATOS)
				cOcupa:= fDesc("SRJ",cCodFunc,"RJ_DESC")
				cOcupa:= Left(cOcupa, 1) + LOWER(Right(cOcupa, len(cOcupa)-1))

				aCols[NCI        ]:= ( AllTrim(cRg) )
				aCols[NAPPATERNO ]:= ( AllTrim(cPriSobr) )
				aCols[NAPMATERNO ]:= ( AllTrim(cSecSobr) )
				aCols[NPNOMBRE	 ]:= ( AllTrim(cPriNome) )
				aCols[NOTRNOMBRE ]:= ( AllTrim(cSecNome) )
				aCols[NCIEXP	 ]:= ( AllTrim(cUfci) )
				aCols[NNACIONAL  ]:= ( fDesc("SX5","34"+cNaciona,"X5_DESCRI") )
				aCols[NNASCIMENTO]:= ( cNasc )
				aCols[NSEXO		 ]:= ( cSexo )
				aCols[NOCUPACION ]:= ( cOcupa )
				aCols[NINGRESSO  ]:= ( cAdmissa )
				aCols[NRETIRO	 ]:= ( cDemissa )
				aCols[NHABERB    ]:= ( aVerba[5,1] / 3)
				aCols[NBONOANT   ]:= ( aVerba[6,1] / 3)
				aCols[NHEMONTO   ]:= ( aVerba[2,1] / 3)
				aCols[NREMBONO   ]:= ( aVerba[1,1] / 3)
				aCols[NSUBSFRONT ]:= ( aVerba[7,1] / 3)
				aCols[NREMOTROS  ]:= ( aVerba[4,1] / 3)
				aCols[NSDSRSUE   ]:= ( aVerba[3,1] / 3)
				aCols[NTOTGANADO ]:= ( nTotalGa / 3 )
				aCols[NPRIMA 	 ]:= ( aVerba[8,1])
				aCols[NMESESTRAB ]:= ( aVerba[8,2] / 3)
				aCols[NMATRICULA ]:= ( cMat )
				aCols[NCCOSTO	 ]:= ( cCC )
				aCols[NCCDESC	 ]:= ( TRIM(fDesc("CTT", cCC, "CTT->CTT_DESC01", 30)) )
				aCols[NAGRUPADO	 ]:= ( nAgrupa )
				aCols[NSUCURSAL  ]:= ( cSucursal )
				aCols[NSUCNOMBR  ]:= ( FWFilName(FWCodEmp(), cSucursal) )
				aCols[NEMPCOD    ]:= ( SUBSTR(cSucursal,1,2))
				aCols[NEMPDESC   ]:= ( TRIM(FWCompanyName())/*FWEmpName(SUBSTR(cSucursal,1,2))*/)

				AADD(aRet, aCols)

			EndIF

			nTotalGa  := 0
			For i := 1 To 8
				For iX := 1 to 2
					aVerba[i,iX] := 0
				Next iX
			Next i

		EndIf
	EndDo

	restArea(aArea)

return aRet
