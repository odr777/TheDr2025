#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DCOMPENS
title "Recibo de cobranza"
description "Cabecera y detalle del recibo"
PERGUNTE "COMPENSA"

columns
define column RECIBODET   	type 	character size tamSX3("EL_RECIBO")[1]  				label	"RECIBODET"
define column PRF  			type 	character size tamSX3("EL_PREFIXO")[1]				label	"PRF"
define column NUMERO  		type 	character size tamSX3("EL_NUMERO")[1]				label	"NUMERO"
define column PC 			type 	character size tamSX3("E1_PARCELA")[1]  			label	"PC"
define column TIPO   		type 	character size tamSX3("EL_TIPO")[1]   				label	"TIPO"
define column CLIEPROV   	type 	character size (tamSX3("A1_COD")[1] + tamSX3("A1_LOJA")[1] + tamSX3("A1_NOME")[1] + 2)		label	"CLIEPROV"
define column VALORTIT		type 	numeric size tamSX3("EL_VALOR")[1] decimals 2 		label	"VALORTIT"
define column VALORCOM		type 	numeric size tamSX3("EL_VALOR")[1] decimals 2 		label	"VALORCOM"
define column SALDOTIT		type 	numeric size tamSX3("E1_SALDO")[1] decimals 2 		label	"SALDOTIT"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local cTemp			:= getNextAlias()
local cRecibo1		:= ""
local cRecibo2		:= ""
local cSerie1		:= ""
local cSerie2		:= ""
local nMoeda		:= 1
local cSucursal		:= xFilial("SEL")
local nValor		:= 0
local nValCom		:= 0
local nSaldo		:= 0

if(FUNNAME() == 'FINA087A')
	cRecibo1 	  	:= cRecibo
	cRecibo2 	  	:= cRecibo
	cSerie1			:= cSerie
	cSerie2			:= cSerie
	//nMoeda			:= 
else
	//recebendo o valor dos parametros
	cRecibo1 	  	:= self:execParamValue( "MV_PAR01" )
	cRecibo2 	  	:= self:execParamValue( "MV_PAR02" )
	cSerie1			:= self:execParamValue( "MV_PAR03" )
	cSerie2			:= self:execParamValue( "MV_PAR04" )
	nMoeda			:= self:execParamValue( "MV_PAR05" )
endIf

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

BeginSql alias cTemp

	SELECT EL_RECIBO, EL_PREFIXO, EL_NUMERO, E1_PARCELA, EL_TIPO, A1_COD, A1_LOJA, A1_NOME, E1_VALOR VALOR, EL_VALOR VALORCOM, E1_SALDO,
	EL_MOEDA, EL_TXMOE02
	FROM %table:SEL% SEL
	JOIN %table:SE1% SE1 ON RTRIM(E1_PREFIXO) + RTRIM(E1_NUM) + RTRIM(E1_PARCELA) + RTRIM(E1_TIPO) = RTRIM(EL_PREFIXO) + RTRIM(EL_NUMERO) + RTRIM(EL_PARCELA) + RTRIM(EL_TIPO)
	JOIN %table:SA1% SA1 ON EL_CLIORIG = A1_COD AND EL_LOJORIG = A1_LOJA
	WHERE EL_FILIAL = %exp:cSucursal%
	AND EL_FILIAL = E1_FILIAL
	AND EL_RECIBO BETWEEN %exp:cRecibo1% AND %exp:cRecibo2%
	AND EL_SERIE BETWEEN %exp:cSerie1% AND %exp:cSerie2%
	AND SEL.%notDel%
	AND SE1.%notDel%
	ORDER BY EL_RECIBO

EndSql

cursorarrow()

dbSelectArea( cTemp )
(cTemp)->(dbGotop())

While (cTemp)->(!EOF())
	if(nMoeda == 2)	// Si la moneda del parametro es Dolar - Moneda 2
		if(VAL((cTemp)->EL_MOEDA) == 2)
			nValor	:= ((cTemp)->VALOR)
			nValCom	:= ((cTemp)->VALORCOM)
			nSaldo	:= ((cTemp)->E1_SALDO)
		else
			nValor	:= ((cTemp)->VALOR / (cTemp)->EL_TXMOE02)		//Se convierte a Dolar
			nValCom	:= ((cTemp)->VALORCOM / (cTemp)->EL_TXMOE02)	//Se convierte a Dolar
			nSaldo	:= ((cTemp)->E1_SALDO / (cTemp)->EL_TXMOE02)	//Se convierte a Dolar
		endIf
	else	// Si la moneda del parametro es Bs. - Moneda 1
		if(VAL((cTemp)->EL_MOEDA) == 2)
			nValor	:= ((cTemp)->VALOR * (cTemp)->EL_TXMOE02)	//Se convierte a Bs
			nValCom	:= ((cTemp)->VALORCOM * (cTemp)->EL_TXMOE02)	//Se convierte a Bs
			nSaldo	:= ((cTemp)->E1_SALDO * (cTemp)->EL_TXMOE02)	//Se convierte a Bs
		else
			nValor	:= ((cTemp)->VALOR)
			nValCom	:= ((cTemp)->VALORCOM)
			nSaldo	:= ((cTemp)->E1_SALDO)
		endIf
	endIf
	
	/*cFechaVto		:= 		alltrim((cTemp)->EL_DTVCTO)
	cAnho			:= 		SubStr(cFechaVto, 1,4 )
	cMes			:= 		SubStr(cFechaVto, 5,2 )
	cDia			:= 		SubStr(cFechaVto, 7,2 )
	cFechaVto		:= 		cDia + "/" + cMes + "/" + cAnho*/

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)->RECIBODET		:= AllTrim((cTemp)->EL_RECIBO)
	(cWTabAlias)->PRF			:= AllTrim((cTemp)->EL_PREFIXO)
	(cWTabAlias)->NUMERO 		:= AllTrim((cTemp)->EL_NUMERO)
	(cWTabAlias)->PC			:= AllTrim((cTemp)->E1_PARCELA)
	(cWTabAlias)->TIPO			:= AllTrim((cTemp)->EL_TIPO)
	(cWTabAlias)->CLIEPROV		:= AllTrim((cTemp)->A1_COD) + "-" + AllTrim((cTemp)->A1_LOJA) + "-" + AllTrim((cTemp)->A1_NOME)
	(cWTabAlias)->VALORTIT		:= nValor
	(cWTabAlias)->VALORCOM		:= nValCom
	(cWTabAlias)->SALDOTIT		:= nSaldo

	(cWTabAlias)->(MsUnlock())

	(cTemp)->(dbSkip())
EndDo

return .T.