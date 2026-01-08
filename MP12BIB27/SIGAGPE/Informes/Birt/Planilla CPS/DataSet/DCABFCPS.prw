#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'
#INCLUDE "GPER680.CH"
#INCLUDE "FIVEWIN.CH"

User_Dataset DCABFCPS
title "Planilla CPS"
description "Cabecera de la planilla CPS"
PERGUNTE "FOLHACPS"

columns

define column EMPRESA    	type 	character size (len(STR0008) + 45)  				label	"EMPRESA"
define column CPSEMPLE    	type 	character size 40  									label	"CPSEMPLE"	//NUMERO DE EMPLEADOR CPS
define column NRONIT    	type 	character size 35  									label	"NRONIT"	//NUMERO DE NIT EMPRESA
define column DIREMPR    	type 	character size 75  									label	"DIREMPR"	//DIRECCION EMPRESA
define column TELEMPR    	type 	character size 30  									label	"TELEMPR"	//TELEFONO EMPRESA
define column MAILEMPR    	type 	character size 50  									label	"MAILEMPR"	//CORREO DE LA EMPRESA
define column MTEPS    		type 	character size 45  									label	"MTEPS"		//NUMERO EMPLEADOR MTEPS
define column RPLNOME  		type 	character size 70  									label	"RPLNOME"	//NOMBRE REPRESENTANTE LEGAL
define column RPLCI   		type 	character size 35  									label	"RPLCI"		//CI REPRESENTANTE LEGAL
define column RPLDIR   		type 	character size 65  									label	"RPLDIR"	//DIRECCION REPRESENTANTE LEGAL
define column RPLTEL   		type 	character size 35  									label	"RPLTEL"	//TELEDONO REPRESENTANTE LEGAL
define column RPLMAIL   	type 	character size 50  									label	"RPLMAIL"	//CORREO REPRESENTANTE LEGAL

define column DESCMES    	type 	character size (len(STR0012) + len(STR0013) + 25)  	label	"DESCMES"


define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local aDetalle		:= {}
Local cEmpresa	:= TRIM(OemToAnsi(STR0008)) + ": " + TRIM(FWCompanyName())//TRIM(SM0->M0_NOME)
Local cCompet	:= self:execParamValue("MV_PAR02")
Local cCPSEmpl	:= "NUMERO DE EMPLEADOR CPS: "
Local cNroNit	:= "NUMERO DE NIT: "
Local cDirEmpr	:= "DIRECCION: "
Local cTelEmpr	:= "TELEFONO: "
Local cMailEmpr	:= "CORREOELECTRONICO: "
Local cMTEPS	:= "NRO. DE EMPLEADOR MTEPS: "
Local cRPLNOME	:= "NOMBRE REPRESENTANTE LEGAL: "
Local cRPLCI	:= "NUMERO DE CI: "
Local cRPLDIR	:= "DIRECCION: "
Local cRPLTEL	:= "NRO. DE TELEFONO: "
Local cRPLMAIL	:= "CORREO ELECTRONICO: "
Private aTabU001:= {}

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

dDataRef 	:= cToD( "01/" + SubStr(cCompet,5,2) + "/" + SubStr(cCompet,1,4))
/*
aTabU001->
aTabU001[1][1]	= Código de la tabla("U001")
aTabU001[1][2]	= Filial
aTabU001[1][3]	= Mes/Anho
aTabU001[1][4]	= Secuencia
aTabU001[1][5]	= Numero del empleador CPS
aTabU001[1][6]	= Numero de Nit empresa
aTabU001[1][7]	= Correo empresa
aTabU001[1][8]	= Numero empleador Ministerio de trabajo
aTabU001[1][9]	= Nombre Representante Legal
aTabU001[1][10]	= CI Representante Legal
aTabU001[1][11]	= Direccion Representante Legal
aTabU001[1][12]	= Telefono Representante Legal
aTabU001[1][13]	= Correo Representante Legal
*/
fCarrTab ( @aTabU001, "U001", dDataRef, .T.)

cDescMes	:= OemToAnsi(STR0012) +" "+ TRIM(UPPER(FDESC_MES(Val(SubStr(cCompet,5,2))))) +" "+ STR0013 +" "+ SubStr(cCompet,1,4)

cCPSEmpl	+= TRIM(aTabU001[1][5])
cNroNit		+= TRIM(aTabU001[1][6])
cDirEmpr	+= TRIM(SM0->M0_ENDENT)
cTelEmpr	+= TRIM(SM0->M0_TEL)
cMailEmpr	+= TRIM(aTabU001[1][7])
cMTEPS		+= TRIM(aTabU001[1][8])
cRPLNOME	+= TRIM(aTabU001[1][9])
cRPLCI		+= TRIM(aTabU001[1][10])
cRPLDIR		+= TRIM(aTabU001[1][11])
cRPLTEL		+= TRIM(aTabU001[1][12])
cRPLMAIL	+= TRIM(aTabU001[1][13])

cursorarrow()

RecLock(cWTabAlias, .T.)

(cWTabAlias)-> EMPRESA		:= cEmpresa
(cWTabAlias)-> CPSEMPLE		:= cCPSEmpl
(cWTabAlias)-> NRONIT		:= cNroNit
(cWTabAlias)-> DIREMPR		:= cDirEmpr
(cWTabAlias)-> TELEMPR		:= cTelEmpr
(cWTabAlias)-> MAILEMPR		:= cMailEmpr
(cWTabAlias)-> MTEPS		:= cMTEPS
(cWTabAlias)-> RPLNOME		:= cRPLNOME
(cWTabAlias)-> RPLCI		:= cRPLCI
(cWTabAlias)-> RPLDIR		:= cRPLDIR
(cWTabAlias)-> RPLTEL		:= cRPLTEL
(cWTabAlias)-> RPLMAIL		:= cRPLMAIL

(cWTabAlias)-> DESCMES		:= cDescMes


(cWTabAlias)->(MsUnlock())

return .T.
