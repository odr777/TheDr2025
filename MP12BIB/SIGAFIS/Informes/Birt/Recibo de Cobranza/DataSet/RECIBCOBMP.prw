#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset RECIBCOBMP
title "Recibo de cobranza"
description "Medio de pago del recibo"
PERGUNTE "RECIBOCOBR"

columns
define column VL  			type 	character size tamSX3("EL_TIPO")[1]					label	"VL"
define column NUMERO  		type 	character size tamSX3("EL_NUMERO")[1]				label	"NUMERO"
define column VALOR			type 	numeric size tamSX3("EL_VALOR")[1] decimals 2 		label	"VALOR"
define column MONEDA   		type 	character size 5					  				label	"MONEDA"
define column BANCO 		type 	character size tamSX3("EL_BANCO")[1]  				label	"BANCO"
define column SUCURSAL 		type 	character size tamSX3("EL_FILIAL")[1]  				label	"SUCURSAL"
define column CUENTA 		type 	character size tamSX3("EL_CONTA")[1]  				label	"CUENTA"
define column FECHA   		type 	character size (tamSX3("EL_DTDIGIT")[1] + 2)   		label	"FECHA"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local cTemp			:= getNextAlias()
local cRecibo1		:= ""
local cRecibo2		:= ""
local cSerie1		:= ""
local cSerie2		:= ""
local cSucursal		:= xFilial("SEL")

if(FUNNAME() == 'FINA087A')
	cRecibo1 	  	:= cRecibo
	cRecibo2 	  	:= cRecibo
	cSerie1			:= cSerie
	cSerie2			:= cSerie
else
	//recebendo o valor dos parametros
	cRecibo1 	  	:= self:execParamValue( "MV_PAR01" )
	cRecibo2 	  	:= self:execParamValue( "MV_PAR02" )
	cSerie1			:= self:execParamValue( "MV_PAR03" )
	cSerie2			:= self:execParamValue( "MV_PAR04" )
endIf

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

BeginSql alias cTemp
	
	SELECT EL_TIPO, EL_NUMERO, EL_VALOR, EL_MOEDA,EL_BANCO, EL_FILIAL, EL_CONTA, EL_DTDIGIT
	FROM %table:SEL% SEL
	WHERE EL_FILIAL = %exp:cSucursal%
	AND EL_RECIBO BETWEEN %exp:cRecibo1% AND %exp:cRecibo2%
	AND EL_SERIE BETWEEN %exp:cSerie1% AND %exp:cSerie2%
	AND EL_BANCO <> '   '
	AND SEL.%notDel%

EndSql

cursorarrow()

dbSelectArea( cTemp )
(cTemp)->(dbGotop())

While (cTemp)->(!EOF())
	
	cFecha	:= 		alltrim((cTemp)->EL_DTDIGIT)
	cAnho	:= 		SubStr(cFecha, 1,4 )
	cMes	:= 		SubStr(cFecha, 5,2 )
	cDia	:= 		SubStr(cFecha, 7,2 )
	cFecha	:= 		cDia + "/" + cMes + "/" + cAnho

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)->VL		:= AllTrim((cTemp)->EL_TIPO)
	(cWTabAlias)->NUMERO 	:= AllTrim((cTemp)->EL_NUMERO)
	(cWTabAlias)->VALOR		:= (cTemp)->EL_VALOR
	(cWTabAlias)->MONEDA	:= GETMV("MV_SIMB"+ALLTRIM(CVALTOCHAR(VAL((cTemp)->EL_MOEDA))))
	(cWTabAlias)->BANCO		:= AllTrim((cTemp)->EL_BANCO)
	(cWTabAlias)->SUCURSAL	:= AllTrim((cTemp)->EL_FILIAL)
	(cWTabAlias)->CUENTA	:= AllTrim((cTemp)->EL_CONTA)
	(cWTabAlias)->FECHA		:= AllTrim(cFecha)
	
	(cWTabAlias)->(MsUnlock())

	(cTemp)->(dbSkip())
EndDo

return .T.