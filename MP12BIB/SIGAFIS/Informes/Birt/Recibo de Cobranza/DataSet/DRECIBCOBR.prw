#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DRECIBCOBR
title "Recibo de cobranza"
description "Cabecera y detalle del recibo"
PERGUNTE "RECIBOCOBR"

columns
define column SERIE  		type 	character size tamSX3("EL_PREFIXO")[1]				label	"SERIE"
define column NUMERO  		type 	character size tamSX3("EL_NUMERO")[1]				label	"NUMERO"
define column TIENDA 		type 	character size tamSX3("EL_LOJORIG")[1]  				label	"TIENDA"
define column VENCTO   		type 	character size (tamSX3("EL_DTVCTO")[1] + 2)   		label	"VENCTO"
define column VALOR   		type 	numeric size tamSX3("E1_VALOR")[1] decimals 2		label	"VALOR"
define column MONEDA   		type 	character size 5					  				label	"MONEDA"
define column IMPORTESUS	type 	numeric size tamSX3("EL_VALOR")[1] decimals 2 		label	"IMPORTESUS"
define column VALORCOB		type 	numeric size tamSX3("EL_VALOR")[1] decimals 2 		label	"VALORCOB"
define column SALDO			type 	numeric size tamSX3("E1_SALDO")[1] decimals 2 		label	"SALDO"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local cTemp			:= getNextAlias()
local cRecibo1		:= ""
local cRecibo2		:= ""
local cSerie1		:= ""
local cSerie2		:= ""
local cSucursal		:= xFilial("SEL")
local nImpDolar		:= 0
local nValCDol		:= 0
local nSaldDol		:= 0

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

	SELECT EL_PREFIXO, EL_NUMERO, EL_LOJORIG,EL_DTVCTO, E1_VALOR VALOR, EL_MOEDA, EL_TXMOE02, EL_VALOR VALORCOB, E1_SALDO
	FROM %table:SEL% SEL
	JOIN %table:SE1% SE1 ON E1_PREFIXO = EL_PREFIXO AND E1_NUM = EL_NUMERO AND E1_PARCELA = EL_PARCELA AND E1_TIPO = EL_TIPO
	JOIN %table:SE5% SE5 ON E5_FILIAL = EL_FILIAL AND E5_ORDREC = EL_RECIBO AND E5_SERREC = EL_SERIE AND E5_CLIFOR = EL_CLIORIG AND E5_LOJA = EL_LOJORIG
	AND E5_PREFIXO = EL_PREFIXO AND E5_NUMERO = EL_NUMERO AND E5_PARCELA = EL_PARCELA AND E5_TIPO = EL_TIPO
	WHERE EL_FILIAL = %exp:cSucursal%
	AND EL_BANCO = '   '
	AND EL_RECIBO BETWEEN %exp:cRecibo1% AND %exp:cRecibo2%
	AND EL_SERIE BETWEEN %exp:cSerie1% AND %exp:cSerie2%
	AND EL_TIPO <> 'RA '
	AND EL_TIPODOC <> 'RA '
	AND (SE5.E5_SITUACA <> 'C' OR (SE5.E5_SITUACA = 'C' AND SEL.EL_CANCEL = 'T'))
	AND SEL.%notDel%
	AND SE1.%notDel%
	AND SE5.%notDel%

EndSql

cursorarrow()

dbSelectArea( cTemp )
(cTemp)->(dbGotop())

While (cTemp)->(!EOF())
	if(VAL((cTemp)->EL_MOEDA) == 1 )	// Si es Bs.
		nImpDolar:= ((cTemp)->VALOR / (cTemp)->EL_TXMOE02)	//Se convierte a Dolar
		nValCDol:= ((cTemp)->VALORCOB / (cTemp)->EL_TXMOE02)	//Se convierte a Dolar
		nSaldDol:= ((cTemp)->E1_SALDO / (cTemp)->EL_TXMOE02)	//Se convierte a Dolar
	else
		nImpDolar:= (cTemp)->VALOR
		nValCDol:= (cTemp)->VALORCOB
		nSaldDol:= (cTemp)->E1_SALDO
	endIf
	
	cFechaVto		:= 		alltrim((cTemp)->EL_DTVCTO)
	cAnho			:= 		SubStr(cFechaVto, 1,4 )
	cMes			:= 		SubStr(cFechaVto, 5,2 )
	cDia			:= 		SubStr(cFechaVto, 7,2 )
	cFechaVto		:= 		cDia + "/" + cMes + "/" + cAnho

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)->SERIE			:= AllTrim((cTemp)->EL_PREFIXO)
	(cWTabAlias)->NUMERO 		:= AllTrim((cTemp)->EL_NUMERO)
	(cWTabAlias)->TIENDA		:= AllTrim((cTemp)->EL_LOJORIG)
	(cWTabAlias)->VENCTO		:= AllTrim(cFechaVto)
	(cWTabAlias)->VALOR			:= (cTemp)->VALOR
	(cWTabAlias)->MONEDA		:= GETMV("MV_SIMB"+ALLTRIM(CVALTOCHAR(VAL((cTemp)->EL_MOEDA))))
	(cWTabAlias)->IMPORTESUS	:= nImpDolar
	(cWTabAlias)->VALORCOB		:= nValCDol
	(cWTabAlias)->SALDO			:= nSaldDol

	(cWTabAlias)->(MsUnlock())

	(cTemp)->(dbSkip())
EndDo

return .T.