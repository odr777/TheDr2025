#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'
#INCLUDE "GPER680.CH"
#INCLUDE "FIVEWIN.CH"

User_Dataset DCABPRIM
title "Planilla de Primas"
description "Cabecera de la planilla"
PERGUNTE "FOLHAPRI"

columns

define column EMPRESA    	type 	character size (len(STR0008) + 45)  				label	"EMPRESA"
define column EMPLEADOR    	type 	character size (len(STR0009) + 25)  				label	"EMPLEADOR"
define column DESCMES    	type 	character size (len(STR0012) + len(STR0013) + 25)  	label	"DESCMES"
define column NOMEMPL  		type 	character size 50  									label	"NOMEMPL"
define column CIEMPL   		type 	character size 20  									label	"CIEMPL"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local aDetalle		:= {}
Local cEmpresa	:= TRIM(OemToAnsi(STR0008)) + ": " + TRIM(FWCompanyName())//TRIM(SM0->M0_NOME)
Local cCompet	:= self:execParamValue("MV_PAR02")
Local cNomEmpr	:= self:execParamValue("MV_PAR12")
Local cNumDocId	:= self:execParamValue("MV_PAR13")
Private aTabS007:= {}

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

dDataRef	:= cToD( "01/12/" + cCompet )
fCarrTab ( @aTabS007, "S007", dDataRef, .T.)
cEmplead	:= aTabS007[1][6]
cEmpMTrab	:= OemToAnsi(STR0009) + ": " + allTrim(cEmplead)

cDescMes 	:= "GESTION " + cCompet//OemToAnsi(STR0012) +" "+ UPPER(FDESC_MES(Val("12"))) +" "+ STR0013 +" "+ cCompet
cFechImp	:= DtoC(dDataBase)

cursorarrow()

RecLock(cWTabAlias, .T.)

(cWTabAlias)-> EMPRESA		:= cEmpresa
(cWTabAlias)-> EMPLEADOR	:= cEmpMTrab
(cWTabAlias)-> DESCMES		:= cDescMes
(cWTabAlias)-> NOMEMPL		:= cNomEmpr
(cWTabAlias)-> CIEMPL		:= cNumDocId

(cWTabAlias)->(MsUnlock())

return .T.
