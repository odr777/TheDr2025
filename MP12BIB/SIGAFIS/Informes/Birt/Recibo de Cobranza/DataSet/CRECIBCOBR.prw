#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset CRECIBCOBR
title "Recibo de cobranza"
description "Cabecera y detalle del recibo"
PERGUNTE "RECIBOCOBR"

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
define column MONEDA   		type 	character size tamSX3("EL_MOEDA")[1]  				label	"MONEDA"
define column TASA			type 	numeric size tamSX3("EL_TXMOE02")[1] decimals 4 	label	"TASA"
define column TOTAL			type 	numeric size tamSX3("EL_VALOR")[1] decimals 2 		label	"TOTAL"
define column TOTALDESC   	type 	character size 100  								label	"TOTALDESC"

define column TOTALBS		type 	numeric size tamSX3("EL_VALOR")[1] decimals 2 	label	"TOTALBS"

define column TCDOLAR		type 	numeric size tamSX3("M2_MOEDA2")[1] decimals 5		label	"TCDOLAR"
define column TCUFV			type 	numeric size tamSX3("M2_MOEDA4")[1] decimals 5		label	"TCUFV"
define column TCEURO		type 	numeric size tamSX3("M2_MOEDA3")[1] decimals 5		label	"TCEURO"

define column USUARIO  		type 	character size tamSX3("A1_NOME")[1]					label	"USUARIO"

define column SALDO			type 	numeric size tamSX3("A1_MSALDO")[1] decimals 2 		label	"SALDO"

define column CANCEL   		type 	character size 7                    	        	label	"CANCEL"

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local cTemp			:= getNextAlias()
local cRecibo1		:= ""
local cRecibo2		:= ""
local cSerie1		:= ""
local cSerie2		:= ""
local cSucursal		:= xFilial("SEL")
local nTotal		:= 0

Local lQuantid 	:= .F.
Local nMoeda			//Identifica em que moeda se dara o retorno.
Local cIdioma	:= "2"	//.(1=Port.2=Espa.3=Ingl)
Local lCent		:= .T.
Local lFrac		:= .T.
Local cMoeda	:= ""
Local nCancel	:= ""

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
	//	SELECT EL_DTDIGIT, A1_COD, A1_NOME, A1_MUN, A1_END, A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_MOEDA, EL_TXMOE02, A1_MSALDO, SUM(EL_VALOR) TOTAL
	//	FROM %table:SEL% SEL
	//	JOIN %table:SA1% SA1 ON EL_CLIORIG = A1_COD AND EL_LOJORIG = A1_LOJA
	//	WHERE EL_FILIAL = %exp:cSucursal%
	//	AND EL_RECIBO BETWEEN %exp:cRecibo1% AND %exp:cRecibo2%
	//	AND EL_SERIE BETWEEN %exp:cSerie1% AND %exp:cSerie2%
	//	AND EL_BANCO <> '   '
	//	AND SEL.%notDel%
	//	AND SA1.%notDel%
	//	GROUP BY EL_DTDIGIT, A1_COD, A1_NOME, A1_MUN, A1_END, A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_MOEDA, EL_TXMOE02, A1_MSALDO

	SELECT EL_DTDIGIT,A1_FILIAL, A1_COD, A1_LOJA, A1_NOME,A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_MOEDA, EL_TXMOE02, SUM(EL_VALOR) TOTAL ,EL_CANCEL
	FROM %table:SEL% SEL
	JOIN %table:SA1% SA1 ON EL_CLIORIG = A1_COD AND EL_LOJORIG = A1_LOJA
	WHERE EL_FILIAL = %exp:cSucursal%
	AND EL_RECIBO BETWEEN %exp:cRecibo1% AND %exp:cRecibo2%
	AND EL_SERIE BETWEEN %exp:cSerie1% AND %exp:cSerie2%
	AND EL_BANCO <> '   '
	AND SEL.%notDel%
	AND SA1.%notDel%
	GROUP BY EL_DTDIGIT,A1_FILIAL, A1_COD, A1_LOJA, A1_NOME,A1_UNITFAC, EL_SERIE, EL_RECIBO, EL_MOEDA, EL_TXMOE02, EL_CANCEL

EndSql

cursorarrow()

//cQuery:=GetLastQuery()
//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL

dbSelectArea( cTemp )
(cTemp)->(dbGotop())
//if (cTemp)->( !Eof() )

//cRecAnt:= (cTemp)->EL_RECIBO

While (cTemp)->(!EOF())
	if(VAL((cTemp)->EL_MOEDA) == 1 )	// Si es Bs.
		nDolar:= ((cTemp)->TOTAL / (cTemp)->EL_TXMOE02)	//Se convierte a Dolar
		nTotal+= nDolar
	else
		nTotal+= (cTemp)->TOTAL
	endIf
	nMoeda:= 2	//2= Dolar
	cMoeda:= "DÓLARES"
	(cTemp)->(dbSkip())
	if((cTemp)->(EOF()))	//if(cRecAnt != (cTemp)->EL_RECIBO)
		(cTemp)->(dbGotop())

		cFechaDia		:= 		alltrim((cTemp)->EL_DTDIGIT)
		cAnho			:= 		SubStr(cFechaDia, 1,4 )
		cMes			:= 		SubStr(cFechaDia, 5,2 )
		cDia			:= 		SubStr(cFechaDia, 7,2 )
		cFechaDia		:= 		cDia + "/" + cMes + "/" + cAnho
		auxCancel       :=      alltrim((cTemp)->EL_CANCEL)

		if(auxCancel == 'T')
			nCancel := "ANULADO"
		else
			nCancel := " "
		end

		nTC_SUS		:= Posicione("SM2", 1, alltrim((cTemp)->EL_DTDIGIT), "SM2->M2_MOEDA2")
		nTC_UFV		:= Posicione("SM2", 1, alltrim((cTemp)->EL_DTDIGIT), "SM2->M2_MOEDA4")
		nTC_EURO	:= Posicione("SM2", 1, alltrim((cTemp)->EL_DTDIGIT), "SM2->M2_MOEDA3")

		RecLock(cWTabAlias, .T.)

		(cWTabAlias)->DIREMPR	:= AllTrim(UPPER(SM0->M0_ENDENT))
		(cWTabAlias)->TELEMPR	:= AllTrim(UPPER(SM0->M0_CIDENT)) + " - Bolivia/ Telf:" + AllTrim(SM0->M0_TEL)
		(cWTabAlias)->IMPRESION	:= DTOC(DATE()) + " " + SUBSTR(TIME(), 1, 2) + ":" + SUBSTR(TIME(), 4, 2)

		(cWTabAlias)->CANCEL	:= nCancel
		(cWTabAlias)->FECHADIA	:= AllTrim(cFechaDia)
		(cWTabAlias)->FECHADIA	:= AllTrim(cFechaDia)
		(cWTabAlias)->CODCL		:= AllTrim((cTemp)->A1_COD)
		(cWTabAlias)->NOMBRECL 	:= AllTrim((cTemp)->A1_NOME)
		//		(cWTabAlias)->LOCALIDAD	:= AllTrim((cTemp)->A1_MUN)
		(cWTabAlias)->LOCALIDAD	:= AllTrim(Posicione("SA1", 1, (cTemp)->A1_FILIAL + (cTemp)->A1_COD, "SA1->A1_MUN")) //edson 11.10.2019
		//		(cWTabAlias)->DIRECCION	:= AllTrim((cTemp)->A1_END)
		(cWTabAlias)->DIRECCION	:= AllTrim(Posicione("SA1", 1, (cTemp)->A1_FILIAL + (cTemp)->A1_COD, "SA1->A1_END")) //edson 11.10.2019
		(cWTabAlias)->NIT		:= AllTrim((cTemp)->A1_UNITFAC)
		(cWTabAlias)->RECIBO	:= AllTrim((cTemp)->EL_RECIBO) + " / " + AllTrim((cTemp)->EL_SERIE)
		(cWTabAlias)->MONEDA	:= (cTemp)->EL_MOEDA
		(cWTabAlias)->TASA		:= (cTemp)->EL_TXMOE02
		(cWTabAlias)->TOTAL		:= ROUND(nTotal, 2)
		(cWTabAlias)->TOTALDESC	:= TRIM(Extenso( ROUND(nTotal, 2),lQuantid,nMoeda,,cIdioma,lCent,lFrac)) + " " + cMoeda

		(cWTabAlias)->TOTALBS	:= (nTotal * (cTemp)->EL_TXMOE02)

		(cWTabAlias)->TCDOLAR	:= nTC_SUS
		(cWTabAlias)->TCUFV		:= nTC_UFV
		(cWTabAlias)->TCEURO	:= nTC_EURO

		(cWTabAlias)->USUARIO 	:= allTrim(subStr(cUsuario,7,15))

		(cWTabAlias)->SALDO		:= getSaldo((cTemp)->A1_FILIAL, (cTemp)->A1_COD, STOD((cTemp)->EL_DTDIGIT))

		(cWTabAlias)->(MsUnlock())

		/*cRecAnt	:= (cTemp)->EL_RECIBO
		nTotal	:= 0
		(cTemp)->(dbSkip())*/
		Exit
	endIf

EndDo
//endIf

return .T.

Static Function getSaldo(cSucCli, cCodCli, dDigit)
	Local aArea			:= getArea()
	Local nRet			:= 0
	Local OrdenConsul	:= GetNextAlias()
	Local nMoedaLocal	:= 1 //Moneda local
	Local nMoeda		:= 2 //Dolar
	// consulta a la base de datos
	BeginSql Alias OrdenConsul
		
		SELECT SUM(A1_SALDUP) SALDOP
		FROM %table:SA1% SA1
		WHERE A1_FILIAL = %exp:cSucCli%
		AND A1_COD = %exp:cCodCli%
		AND SA1.%notdel%
	
	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		nRet:= xMoeda((OrdenConsul)->SALDOP, nMoedaLocal, nMoeda, dDigit)
	endIf
	restArea(aArea)
return nRet
