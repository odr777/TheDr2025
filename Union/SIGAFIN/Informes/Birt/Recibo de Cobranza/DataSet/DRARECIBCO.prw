#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DRARECIBCO
title "Recibo de cobranza"
description "Detalle del recibo - RA"
PERGUNTE "RECIBOCOBR"

columns
define column SERIE  		type 	character size tamSX3("EL_PREFIXO")[1]				label	"SERIE"
define column NUMERO  		type 	character size tamSX3("EL_NUMERO")[1]				label	"NUMERO"
define column VALOR   		type 	numeric size tamSX3("E1_VALOR")[1] decimals 2		label	"VALOR"
define column MONEDA   		type 	character size 5					  				label	"MONEDA"
define column VALORCOB		type 	numeric size tamSX3("EL_VALOR")[1] decimals 2 		label	"VALORCOB"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local cTemp			:= getNextAlias()
local cRecibo1		:= ""
local cRecibo2		:= ""
local cSerie1		:= ""
local cSerie2		:= ""
local cSucursal		:= xFilial("SEL")
local nValCDol		:= 0

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

	SELECT EL_PREFIXO, EL_NUMERO, E1_VALOR VALOR, EL_MOEDA, EL_TXMOE02, EL_VALOR VALORCOB
	FROM %table:SEL% SEL
	JOIN %table:SE1% SE1 ON E1_PREFIXO = EL_PREFIXO AND E1_NUM = EL_NUMERO AND E1_PARCELA = EL_PARCELA AND E1_TIPO = EL_TIPO
	AND SEL.EL_CLIORIG = SE1.E1_CLIENTE AND SEL.EL_LOJORIG = SE1.E1_LOJA
	WHERE EL_FILIAL = %exp:cSucursal%
	AND EL_BANCO = '   '
	AND EL_RECIBO BETWEEN %exp:cRecibo1% AND %exp:cRecibo2%
	AND EL_SERIE BETWEEN %exp:cSerie1% AND %exp:cSerie2%
	AND EL_TIPO = 'RA '
	AND EL_TIPODOC = 'RA '
	AND SEL.%notDel%
	AND SE1.%notDel%

EndSql

cursorarrow()

dbSelectArea( cTemp )
(cTemp)->(dbGotop())

While (cTemp)->(!EOF())
	if(VAL((cTemp)->EL_MOEDA) == 1 )	// Si es Bs.
		nValCDol:= ((cTemp)->VALORCOB / (cTemp)->EL_TXMOE02)	//Se convierte a Dolar
	else
		nValCDol:= (cTemp)->VALORCOB
	endIf

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)->SERIE			:= AllTrim((cTemp)->EL_PREFIXO)
	(cWTabAlias)->NUMERO 		:= AllTrim((cTemp)->EL_NUMERO)
	(cWTabAlias)->VALOR			:= (cTemp)->VALOR
	(cWTabAlias)->MONEDA		:= GETMV("MV_SIMB"+ALLTRIM(CVALTOCHAR(VAL((cTemp)->EL_MOEDA))))
	(cWTabAlias)->VALORCOB		:= nValCDol

	(cWTabAlias)->(MsUnlock())

	(cTemp)->(dbSkip())
EndDo

return .T.