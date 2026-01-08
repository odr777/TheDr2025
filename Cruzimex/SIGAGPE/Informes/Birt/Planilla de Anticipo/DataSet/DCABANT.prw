#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DCABANT
title "Planilla de Anticipos"
description "Cabecera Planilla de Anticipos"
PERGUNTE "PLANANT"

columns
define column PERIODO   type 	character size (tamSX3("RCH_PER")[1] + 1)  	label	"PERIODO"
define column FECHAPAGO	type 	character size (tamSX3("RCH_DTPAGO")[1] + 2)	label	"FECHAPAGO"
define column USUARIO  	type 	character size 20	label	"USUARIO"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias:= ""
local cTemp		:= getNextAlias()
local cPeriodo	:= ""
local cRoteir	:= ""

cPeriodo	:= self:execParamValue( "MV_PAR05" )
cRoteir		:= self:execParamValue( "MV_PAR06" )

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

BeginSql alias cTemp

	SELECT RCH_DTPAGO
	FROM %table:RCH% RCH
	WHERE RCH_PER = %Exp:cPeriodo%
	AND RCH_ROTEIR = %Exp:cRoteir%
	AND RCH.%notDel%

EndSql

cursorarrow()

dbSelectArea( cTemp )
(cTemp)->(dbGotop())

cFechaVto	:= Trim((cTemp)->RCH_DTPAGO)
cAnho		:= SubStr(cFechaVto, 1,4 )
cMes		:= SubStr(cFechaVto, 5,2 )
cDia		:= SubStr(cFechaVto, 7,2 )
cFechaVto	:= cDia + "/" + cMes + "/" + cAnho

cPeriodo	:= SubStr(cPeriodo, 5,2) + "/" + SubStr(cPeriodo, 1,4)

RecLock(cWTabAlias, .T.)

(cWTabAlias)->PERIODO	:= cPeriodo
(cWTabAlias)->FECHAPAGO	:= cFechaVto
(cWTabAlias)->USUARIO	:= Trim(CUSERNAME)

(cWTabAlias)->(MsUnlock())

return .T.