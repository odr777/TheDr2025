#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DPLANANT
title "Planilla de Anticipos"
description "Detalle Planilla de Anticipos"
PERGUNTE "PLANANT"

columns
define column SUCURSAL   	type 	character size tamSX3("RA_FILIAL")[1]  				label	"SUCURSAL"
define column MATRICULA  	type 	character size tamSX3("RA_MAT")[1]					label	"MATRICULA"
define column NOMBRECMP  	type 	character size tamSX3("RA_NOMECMP")[1]				label	"NOMBRECMP"
define column SALARIO		type 	numeric size tamSX3("RA_SALARIO")[1] decimals 2 	label	"SALARIO"
define column PORCENTAJE	type 	numeric size tamSX3("RA_PERCADT")[1] 				label	"PORCENTAJE"
define column VALORANT		type 	numeric size tamSX3("RC_VALOR")[1] decimals 2 		label	"VALORANT"
define column CONCEPTO  	type 	character size tamSX3("RC_PD")[1]					label	"CONCEPTO"
define column CCOSTO  		type 	character size tamSX3("RA_CC")[1]					label	"CCOSTO"
define column CCOSTODESC  	type 	character size tamSX3("CTT_DESC01")[1]				label	"CCOSTODESC"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias:= ""
local cTemp		:= getNextAlias()
local cDeFilial	:= ""
local cAFilial	:= ""
local cDeMat	:= ""
local cAMat		:= ""
local cPeriodo	:= ""
local cRoteir	:= ""
local nOrden	:= 1

local cCodFol	:= ""
local cOrden	:= ""

cDeFilial	:= self:execParamValue( "MV_PAR01" )
cAFilial	:= self:execParamValue( "MV_PAR02" )
cDeMat		:= self:execParamValue( "MV_PAR03" )
cAMat		:= self:execParamValue( "MV_PAR04" )
cPeriodo	:= self:execParamValue( "MV_PAR05" )
cRoteir		:= self:execParamValue( "MV_PAR06" )
nOrden		:= self:execParamValue( "MV_PAR07" )

cCodFol:= iif(cRoteir == 'FOL', '0007', '0006')
if(nOrden == 1)
	cOrden:= "% RA_FILIAL, RA_MAT %"
elseif(nOrden == 2)
	cOrden:= "% RA_FILIAL, RA_CC, RA_MAT %"
else
	cOrden:= "% RA_FILIAL, RA_NOMECMP %"
endIf

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

BeginSql alias cTemp

	SELECT RA_FILIAL, RA_MAT, RA_NOMECMP, RA_SALARIO, RA_PERCADT, RC_VALOR, RC_PD, RA_CC, CTT_DESC01
	FROM %table:SRA% SRA
	JOIN %table:SRC% SRC ON SRA.RA_FILIAL = SRC.RC_FILIAL AND SRA.RA_MAT = SRC.RC_MAT
	JOIN %table:SRV% SRV ON SRC.RC_PD = SRV.RV_COD
	JOIN %table:CTT% CTT ON CTT.CTT_CUSTO = SRA.RA_CC
	WHERE SRA.RA_FILIAL BETWEEN %Exp:cDeFilial% AND %Exp:cAFilial%
	AND SRA.RA_MAT BETWEEN %Exp:cDeMat% AND %Exp:cAMat%
	AND SRC.RC_PERIODO = %Exp:cPeriodo%
	AND SRC.RC_ROTEIR = %Exp:cRoteir%
	AND SRV.RV_CODFOL = %Exp:cCodFol%
	AND SRA.%notDel%
	AND SRC.%notDel%
	AND SRV.%notDel%
	AND CTT.%notDel%
	UNION
	(SELECT RA_FILIAL, RA_MAT, RA_NOMECMP, RA_SALARIO, RA_PERCADT, RD_VALOR, RD_PD, RA_CC, CTT_DESC01
	FROM %table:SRA% SRA
	JOIN %table:SRD% SRD ON SRA.RA_FILIAL = SRD.RD_FILIAL AND SRA.RA_MAT = SRD.RD_MAT
	JOIN %table:SRV% SRV ON SRD.RD_PD = SRV.RV_COD
	JOIN %table:CTT% CTT ON CTT.CTT_CUSTO = SRA.RA_CC
	WHERE SRA.RA_FILIAL BETWEEN %Exp:cDeFilial% AND %Exp:cAFilial%
	AND SRA.RA_MAT BETWEEN %Exp:cDeMat% AND %Exp:cAMat%
	AND SRD.RD_PERIODO = %Exp:cPeriodo%
	AND SRD.RD_ROTEIR = %Exp:cRoteir%
	AND SRV.RV_CODFOL = %Exp:cCodFol%
	AND SRA.%notDel%
	AND SRD.%notDel%
	AND SRV.%notDel%
	AND CTT.%notDel%)
	ORDER BY %exp:cOrden%

EndSql

cursorarrow()

dbSelectArea( cTemp )
(cTemp)->(dbGotop())

While (cTemp)->(!EOF())

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)->SUCURSAL	:= Trim((cTemp)->RA_FILIAL)
	(cWTabAlias)->MATRICULA	:= Trim((cTemp)->RA_MAT)
	(cWTabAlias)->NOMBRECMP	:= Trim((cTemp)->RA_NOMECMP)
	(cWTabAlias)->SALARIO	:= (cTemp)->RA_SALARIO
	(cWTabAlias)->PORCENTAJE:= (cTemp)->RA_PERCADT
	(cWTabAlias)->VALORANT	:= (cTemp)->RC_VALOR
	(cWTabAlias)->CONCEPTO	:= Trim((cTemp)->RC_PD)
	(cWTabAlias)->CCOSTO	:= Trim((cTemp)->RA_CC)
	(cWTabAlias)->CCOSTODESC:= Trim((cTemp)->CTT_DESC01)

	(cWTabAlias)->(MsUnlock())

	(cTemp)->(dbSkip())
EndDo

return .T.