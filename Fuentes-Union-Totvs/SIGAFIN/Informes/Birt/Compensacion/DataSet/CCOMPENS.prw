#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset CCOMPENS
title "Recibo de compensacion"
description "Cabecera y total de la compensacion"
PERGUNTE "COMPENSA"

columns

define column DIREMPR   	type 	character size tamSX3("A1_END")[1]  				label	"DIREMPR"
define column TELEMPR   	type 	character size tamSX3("A1_END")[1]  				label	"TELEMPR"
define column IMPRESION   	type 	character size 16   								label	"IMPRESION"

define column FECHADIA   	type 	character size (tamSX3("EL_DTDIGIT")[1] + 2)   		label	"FECHADIA"

define column CODCL  		type 	character size tamSX3("A1_COD")[1]					label	"CODCL"
define column NOMBRECL  	type 	character size tamSX3("A1_NOME")[1]					label	"NOMBRECL"
define column LOCALIDAD 	type 	character size tamSX3("A1_MUN")[1]  				label	"LOCALIDAD"
define column DIRECCION   	type 	character size tamSX3("A1_END")[1]  				label	"DIRECCION"
define column NIT   		type 	character size tamSX3("A1_UNITFAC")[1]  			label	"NIT"
define column RECIBO   		type 	character size (tamSX3("EL_RECIBO")[1] + tamSX3("EL_SERIE")[1] + 3)  				label	"RECIBO"
define column MONEDA   		type 	character size 20  									label	"MONEDA"
define column TOTAL			type 	numeric size tamSX3("EL_VALOR")[1] decimals 2 		label	"TOTAL"

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
local nTotal		:= 0

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
	SELECT EL_DTDIGIT, A1_COD, A1_NOME, A1_MUN, A1_END, A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_MOEDA, EL_TXMOE02, SUM(EL_VALOR) TOTAL
	FROM %table:SEL% SEL
	JOIN %table:SA1% SA1 ON EL_CLIORIG = A1_COD AND EL_LOJORIG = A1_LOJA
	WHERE EL_FILIAL = %exp:cSucursal%
	AND EL_RECIBO BETWEEN %exp:cRecibo1% AND %exp:cRecibo2%
	AND EL_SERIE BETWEEN %exp:cSerie1% AND %exp:cSerie2%
	AND EL_BANCO = '   '
	AND (EL_TIPO = 'RA ' OR EL_TIPO = 'NCC')
	AND SEL.%notDel%
	AND SA1.%notDel%
	GROUP BY EL_DTDIGIT, A1_COD, A1_NOME, A1_MUN, A1_END, A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_MOEDA, EL_TXMOE02

EndSql

cursorarrow()

//cQuery:=GetLastQuery()
//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL

dbSelectArea( cTemp )

(cTemp)->(dbGotop())

cRecAnt:= (cTemp)->EL_RECIBO

While (cTemp)->(!EOF())

	if(nMoeda == 2)	// Si la moneda del parametro es Dolar - Moneda 2
		if(VAL((cTemp)->EL_MOEDA) == 2)
			nTotal+= ((cTemp)->TOTAL)
		else
			nDolar:= ((cTemp)->TOTAL / (cTemp)->EL_TXMOE02)	//Se convierte a Dolar
			nTotal+= nDolar
		endIf
	else	// Si la moneda del parametro es Bs. - Moneda 1
		if(VAL((cTemp)->EL_MOEDA) == 2)
			nDolar:= ((cTemp)->TOTAL * (cTemp)->EL_TXMOE02)	//Se convierte a Bs
			nTotal+= nDolar
		else
			nTotal+= ((cTemp)->TOTAL)
		endIf
	endIf
	(cTemp)->(dbSkip())
if((cTemp)->(EOF()))
		(cTemp)->(dbGotop())
//		(cTemp)->(dbSkip(-1))
		
		cFechaDia		:= 		alltrim((cTemp)->EL_DTDIGIT)
		cAnho			:= 		SubStr(cFechaDia, 1,4 )
		cMes			:= 		SubStr(cFechaDia, 5,2 )
		cDia			:= 		SubStr(cFechaDia, 7,2 )
		cFechaDia		:= 		cDia + "/" + cMes + "/" + cAnho

		RecLock(cWTabAlias, .T.)

		(cWTabAlias)->DIREMPR	:= AllTrim(UPPER(SM0->M0_ENDENT))
		(cWTabAlias)->TELEMPR	:= AllTrim(UPPER(SM0->M0_CIDENT)) + " - Bolivia/ Telf:" + AllTrim(SM0->M0_TEL)
		(cWTabAlias)->IMPRESION	:= DTOC(DATE()) + " " + SUBSTR(TIME(), 1, 2) + ":" + SUBSTR(TIME(), 4, 2)

		(cWTabAlias)->FECHADIA	:= AllTrim(cFechaDia)
		(cWTabAlias)->CODCL		:= AllTrim((cTemp)->A1_COD)
		(cWTabAlias)->NOMBRECL 	:= AllTrim((cTemp)->A1_NOME)
		(cWTabAlias)->LOCALIDAD	:= AllTrim((cTemp)->A1_MUN)
		(cWTabAlias)->DIRECCION	:= AllTrim((cTemp)->A1_END)
		(cWTabAlias)->NIT		:= AllTrim((cTemp)->A1_UNITFAC)
		(cWTabAlias)->RECIBO	:= AllTrim((cTemp)->EL_RECIBO) + " / " + AllTrim((cTemp)->EL_SERIE)
		(cWTabAlias)->MONEDA	:= UPPER(GETMV('MV_MOEDA' + cValtoChar(nMoeda)))
		(cWTabAlias)->TOTAL		:= nTotal

		(cWTabAlias)->(MsUnlock())
		
		cRecAnt	:= (cTemp)->EL_RECIBO
		//nTotal	:= 0
		Exit
	endIf
	//(cTemp)->(dbSkip())
enddo

return .T.