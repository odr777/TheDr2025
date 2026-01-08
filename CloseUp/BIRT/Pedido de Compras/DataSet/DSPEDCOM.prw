#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DSPEDCOM
title "Pedido de Compra"
description "Cabecera y detalle del pedido"
PERGUNTE "PEDCOM01"

columns

define column TITULO   	type 	character size 50  				label	"TITULO"

//CABECERA - DATOS EMPRESA
define column NIT   	    type 	character size 50 			label	"NIT"
define column EMPRESA   	type 	character size 50 			label	"EMPRESA"
define column EMPDIR   		type 	character size 100 			label	"EMPDIR"
define column EMPCP   		type 	character size 100 			label	"EMPCP"
define column EMPTELFAX   	type 	character size 50 			label	"EMPTELFAX"
define column EMPRUC   		type 	character size 50 			label	"EMPRUC"

//CABECERA - DATOS PROVEEDOR
define column NOMEPROV   	type 	character size tamSX3("A2_NOME")[1]  				label	"NOMEPROV"
define column CODPROV   	type 	character size tamSX3("A2_COD")[1]  				label	"CODPROV"
define column LOJAPROV   	type 	character size tamSX3("A2_LOJA")[1]  				label	"LOJAPROV"
define column ENDPROV   	type 	character size tamSX3("A2_END")[1]  				label	"ENDPROV"
define column BARRPROV   	type 	character size tamSX3("A2_BAIRRO")[1]  				label	"BARRPROV"
define column CEPPROV   	type 	character size tamSX3("A2_CEP")[1]  				label	"CEPPROV"
define column MUNPROV   	type 	character size tamSX3("A2_MUN")[1]  				label	"MUNPROV"
define column ESTPROV   	type 	character size tamSX3("A2_EST")[1]  				label	"ESTPROV"
define column CGCPROV   	type 	character size tamSX3("A2_CGC")[1]  				label	"CGCPROV"
define column TELPROV   	type 	character size tamSX3("A2_TEL")[1]  				label	"TELPROV"
define column FAXPROV   	type 	character size tamSX3("A2_FAX")[1]  				label	"FAXPROV"
//CABECERA - DATOS PEDIDO
define column NUMPED   		type 	character size tamSX3("C7_NUM")[1]  				label	"NUMPED"
define column NUMSC   		type 	character size tamSX3("C7_NUMSC")[1]  				label	"NUMSC"

//DETALLE
define column ITEMPED   	type 	character size tamSX3("C7_ITEM")[1]  				label	"ITEMPED"
define column CODPROD   	type 	character size tamSX3("C7_PRODUTO")[1]  			label	"CODPROD"
define column DESCPROD   	type 	character size tamSX3("B1_ESPECIF")[1]  				label	"DESCPROD"
define column UMPROD   		type 	character size tamSX3("C7_UM")[1]  					label	"UMPROD"
define column CANTPROD   	type 	numeric size tamSX3("C7_QUANT")[1] decimals 2 		label	"CANTPROD"
define column PRECPROD   	type 	numeric size tamSX3("C7_PRECO")[1] decimals 2		label	"PRECPROD"
define column TOTAL   		type 	numeric size tamSX3("C7_TOTAL")[1] decimals 2		label	"TOTAL"
define column CCPED   		type 	character size tamSX3("C7_CC")[1]  					label	"CCPED"
define column FECHAEMI		type 	character size (tamSX3("C7_EMISSAO")[1]+ 2)  					label	"FECHAEMI"
define column IMPUESTO   	type 	numeric size tamSX3("C7_VALIMP1")[1] decimals 2		label	"IMPUESTO"

define column FECHAENT   	type 	character size (tamSX3("C7_DATPRF")[1] + 2)  		label	"FECHAENT"
define column PRIORIZA   	type 	character size (tamSX3("C7_UPRIORI")[1])  		label	"PRIORIZA"
define column CHEQNOME   	type 	character size (20 + tamSX3("A2_UNUMCON")[1] + tamSX3("A2_MOEDCTA")[1] + tamSX3("A2_UBANCOP")[1] + tamSX3("A2_UAGENCI")[1] + tamSX3("A2_UTITCTA")[1])	label	"CHEQNOME"
define column OBSERV   		type 	character size tamSX3("C7_OBS")[1]  				label	"OBSERV"
define column FORMPAGO   	type 	character size tamSX3("E4_DESCRI")[1]  				label	"FORMPAGO"
define column FECVALID   	type 	character size (tamSX3("C8_VALIDA")[1] + 2)			label	"FECVALID"
define column SUCURSAL   	type 	character size 4 		label	"SUCURSAL"
define column VAlORLIT   	type 	character size 100 		label	"VAlORLIT"

//A2_NUMCON, A2_MOEDCTA, A2_UBANCOP, A2_UAGENCI, A2_UTITCTA

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local cTemp			:= getNextAlias()

local cNumDe		:= ""
local cNumA			:= ""
local cDataDe		:= ""
local cDataA		:= ""
local nMoeda		:= 1

local nPrecio		:= 0
local nTotal		:= 0
local nImpuesto		:= 0
private cSuc	    := xFilial("SC7")
private nPrecioU    := 0.0
private nIpuesto    := 0.0

//recebendo o valor dos parametros
cNumDe		:= self:execParamValue("MV_PAR01")
// cNumA		:= self:execParamValue("MV_PAR02")
// cDataDe		:= DTOS(self:execParamValue("MV_PAR03"))
// cDataA		:= DTOS(self:execParamValue("MV_PAR04"))
nMoeda		:= self:execParamValue("MV_PAR02")
bPedidoApr		:= GETNEWPAR("MV_XIMPPCB",.F.)
cImpPedBlo := "%%"

if(!bPedidoApr)
	cImpPedBlo := "% AND C7_CONAPRO <> 'B' %"
    lBloqueado := GetAdvFVal("SC7","C7_CONAPRO",xFilial("SC7")+MV_PAR01,1,"")=="B"
	if (lBloqueado)
		MsgAlert("EL pedido de compra no está aprobado, por lo tanto no puede ser impreso ","Aviso")
	endif
EndIf

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

BeginSql alias cTemp

	//	SELECT A2_NOME, A2_COD, A2_LOJA, A2_END, A2_BAIRRO, A2_CEP, A2_MUN, A2_EST, A2_CGC, A2_TEL, A2_FAX,
	//	C7_NUM, C7_NUMSC, C7_ITEM, C7_PRODUTO, B1_DESC, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, C7_CC, C7_MOEDA, C7_TXMOEDA, C7_EMISSAO,
	//	C7_VALIMP1, C7_OBS, E4_DESCRI,A2_NUMCON, A2_MOEDCTA, A2_UBANCOP, A2_UAGENCI, A2_UTITCTA, C7_DATPRF, C7_UPRIORI
	//	FROM %table:SC7% SC7
	//	JOIN %table:SA2% SA2 ON C7_FORNECE = A2_COD
	//	JOIN %table:SB1% SB1 ON C7_PRODUTO = B1_COD
	//	JOIN %table:SE4% SE4 ON C7_COND = E4_CODIGO
	//	WHERE C7_FILIAL = %exp:cSuc%
	//	AND C7_NUM BETWEEN %exp:cNumDe% AND %exp:cNumA%
	//	AND C7_EMISSAO BETWEEN %exp:cDataDe% AND %exp:cDataA%
	//	AND SC7.%notDel%
	//	AND SA2.%notDel%
	//	AND SB1.%notDel%
	//	AND SE4.%notDel%
	//	ORDER BY C7_NUM ASC

	SELECT C7_FILIAL, A2_NOME,A2_COD,A2_LOJA,A2_END,A2_BAIRRO,A2_CEP,A2_MUN,A2_EST,A2_CGC,A2_TEL,A2_FAX,C7_NUM,C7_NUMSC,C7_ITEM,
	C7_PRODUTO,B1_DESC,C7_UM,C7_QUANT,C7_PRECO,C7_TOTAL,C7_CC,C7_MOEDA,C7_TXMOEDA,C7_EMISSAO,B1_ESPECIF,A2_UNUMCON,
	C7_VALIMP1,C7_OBS,E4_DESCRI,A2_NUMCON,A2_MOEDCTA,A2_UBANCOP,A2_UAGENCI,A2_UTITCTA,C7_DATPRF,C7_UPRIORI , C8_VALIDA,
	A2_UTIPCTA
	FROM %table:SC7% SC7
	JOIN %table:SA2% SA2
	ON C7_FORNECE = A2_COD
	AND SA2.%notDel%
	JOIN %table:SB1% SB1
	ON C7_PRODUTO = B1_COD
	AND SB1.%notDel%
	JOIN %table:SE4% SE4
	ON C7_COND = E4_CODIGO
	AND SE4.%notDel%
	LEFT JOIN %table:SC8% SC8
	ON C7_NUMCOT = C8_NUM AND C8_ITEM = C7_ITEM AND C8_PRODUTO = C7_PRODUTO AND C8_FORNECE = C7_FORNECE  AND C8_NUMPED = C7_NUM AND SC8.%notDel%
	WHERE  C7_FILIAL = %exp:cSuc%
	AND C7_NUM = %exp:cNumDe% 
	AND 1=1 %Exp:cImpPedBlo%
	AND SC7.%notDel%

EndSql

//cQuery:=GetLastQuery()
//Aviso("",cQuery[2],{"Ok"},,,,,.T.)
cursorarrow()

dbSelectArea( cTemp )
(cTemp)->(dbGotop())

//	C7_UTIPCTA, C7_MOEDCTA
cTipoCuenta := ""
DO CASE
case (cTemp)->A2_UTIPCTA  == "1" // 1
	cTipoCuenta := "SAFI"
case (cTemp)->A2_UTIPCTA  == "2" // 1
	cTipoCuenta := "CAJA DE AHORRO"
case (cTemp)->A2_UTIPCTA  == "3" // 1
	cTipoCuenta := "CTA CORRIENTE"
ENDCASE
DO CASE
case (cTemp)->A2_MOEDCTA == "1" // 1
	cMoneda := "M/N"
case (cTemp)->A2_MOEDCTA  == "2" // 1
	cMoneda := "M/E"
otherwise
	cMoneda :=""
endcase

While (cTemp)->(!EOF())

	//Aqui se hace la conversion a la moneda del parametro
	if(nMoeda != (cTemp)->C7_MOEDA)
		if((cTemp)->C7_MOEDA != 1)	//Si es diferente de la moneda local
			nPrecio		:= (cTemp)->C7_PRECO * (cTemp)->C7_TXMOEDA	//Se convierte a moneda local //me convierte en boli
//			nTotal		:= ((cTemp)->C7_TOTAL - (cTemp)->C7_VALIMP1) * (cTemp)->C7_TXMOEDA	//Se convierte a moneda local
			nTotal		:= (cTemp)->C7_TOTAL * (cTemp)->C7_TXMOEDA	//Se convierte a moneda local
			nImpuesto	:= (cTemp)->C7_VALIMP1 * (cTemp)->C7_TXMOEDA//Se convierte a moneda local
			nPrecioU +=  nTotal
			nIpuesto +=  nImpuesto
			totalAux := (nPrecioU )
			valorliteral  := "Son: "+Extenso(totalAux,.F.,1)+" BOLIVIANOS "
			if(nMoeda != 1)
				nPrecio		:= nPrecio / (Posicione("SM2", 1, Trim((cTemp)->C7_EMISSAO), "SM2->M2_MOEDA" + cValToChar(nMoeda)))
				nTotal		:= nTotal / (Posicione("SM2", 1, Trim((cTemp)->C7_EMISSAO), "SM2->M2_MOEDA" + cValToChar(nMoeda)))
				nImpuesto	:= nTotal / (Posicione("SM2", 1, Trim((cTemp)->C7_EMISSAO), "SM2->M2_MOEDA" + cValToChar(nMoeda)))
			endIf
		else
			nPrecio		:= (cTemp)->C7_PRECO / (Posicione("SM2", 1, Trim((cTemp)->C7_EMISSAO), "SM2->M2_MOEDA" + cValToChar(nMoeda)))
//			nTotal		:= ((cTemp)->C7_TOTAL  - (cTemp)->C7_VALIMP1) / (Posicione("SM2", 1, Trim((cTemp)->C7_EMISSAO), "SM2->M2_MOEDA" + cValToChar(nMoeda)))
			nTotal		:= (cTemp)->C7_TOTAL  / (Posicione("SM2", 1, Trim((cTemp)->C7_EMISSAO), "SM2->M2_MOEDA" + cValToChar(nMoeda)))
			nImpuesto	:= (cTemp)->C7_VALIMP1 / (Posicione("SM2", 1, Trim((cTemp)->C7_EMISSAO), "SM2->M2_MOEDA" + cValToChar(nMoeda)))
			nPrecioU +=  nTotal
			nIpuesto +=  nImpuesto
			totalAux := (nPrecioU )
			valorliteral  := "Son: "+Extenso(totalAux,.F.,2)+" DOLARES "
		endIf
	else

		if nMoeda == 1
			nPrecio		:= (cTemp)->C7_PRECO
			nTotal		:= (cTemp)->C7_TOTAL// Nahim quitandolé impuestos 09/12/2019 - C7_VALIMP1
			nImpuesto	:= (cTemp)->C7_VALIMP1
			nPrecioU +=  nTotal
			nIpuesto +=  nImpuesto
			totalAux := (nPrecioU )
			valorliteral  := "Son: "+Extenso(totalAux,.F.,1)+" BOLIVIANOS "
		elseif nMoeda == 2
			nPrecio		:= (cTemp)->C7_PRECO
			nTotal		:= (cTemp)->C7_TOTAL // Nahim quitandolé impuestos 09/12/2019 - C7_VALIMP1
			nImpuesto	:= (cTemp)->C7_VALIMP1
			nPrecioU +=  nTotal
			nIpuesto +=  nImpuesto
			totalAux := (nPrecioU )
			valorliteral  := "Son: "+Extenso(totalAux,.F.,2)+" DOLARES "
		end if

	endif

	cFchEnt	:= Trim((cTemp)->C7_DATPRF)
	cFchEnt2 := Trim((cTemp)->C8_VALIDA)
	cFchEmis := Trim((cTemp)->C7_EMISSAO)

	cAnho	:= SubStr(cFchEnt, 1,4 )
	cMes	:= SubStr(cFchEnt, 5,2 )
	cDia	:= SubStr(cFchEnt, 7,2 )

	cAnho2	:= SubStr(cFchEnt2, 1,4 )
	cMes2	:= SubStr(cFchEnt2, 5,2 )
	cDia2	:= SubStr(cFchEnt2, 7,2 )

	cAnho3	:= SubStr(cFchEmis, 1,4 )
	cMes3	:= SubStr(cFchEmis, 5,2 )
	cDia3	:= SubStr(cFchEmis, 7,2 )


	cFchEnt	:= cDia + "/" + cMes + "/" + cAnho
	cFchEnt2	:= cDia2 + "/" + cMes2 + "/" + cAnho2
	cFchEmis	:= cDia3 + "/" + cMes3 + "/" + cAnho3

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)->TITULO	:= "PEDIDO DE COMPRAS - " + UPPER(GETMV('MV_MOEDA' + cValtoChar(nMoeda)))

	//CABECERA

	(cWTabAlias)->NIT	    := "NIT: " + Trim(SM0->M0_CGC)
	(cWTabAlias)->EMPRESA	:= "EMPRESA: " + Trim(SM0->M0_NOMECOM)
	(cWTabAlias)->EMPDIR	:= "DIRECCION: " + Trim(SM0->M0_ENDENT)
	(cWTabAlias)->EMPCP		:= "CP: " + iif(!empty(Trim(SM0->M0_CGC)), Trim(SM0->M0_CGC) + SPACE(2) ,SPACE(5)) + "Ciudad: " + SPACE(3) + "UF: " + Trim(SM0->M0_ESTENT)
	(cWTabAlias)->EMPTELFAX	:= "TEL: " + Trim(SM0->M0_TEL) + SPACE(3) + "FAX: " + Trim(SM0->M0_FAX)
	(cWTabAlias)->EMPRUC	:= "RUC: "
	(cWTabAlias)->FECHAEMI	:= cFchEmis

	//CABECERA
	(cWTabAlias)->NOMEPROV	:= Trim((cTemp)->A2_NOME)
	(cWTabAlias)->CODPROV	:= Trim((cTemp)->A2_COD)
	(cWTabAlias)->LOJAPROV	:= Trim((cTemp)->A2_LOJA)
	(cWTabAlias)->ENDPROV	:= Trim((cTemp)->A2_END)
	(cWTabAlias)->BARRPROV	:= Trim((cTemp)->A2_BAIRRO)
	(cWTabAlias)->CEPPROV	:= Trim((cTemp)->A2_CEP)
	(cWTabAlias)->MUNPROV	:= Trim((cTemp)->A2_MUN)
	(cWTabAlias)->ESTPROV	:= Trim((cTemp)->A2_EST)
	(cWTabAlias)->CGCPROV	:= Trim((cTemp)->A2_CGC)
	(cWTabAlias)->TELPROV	:= Trim((cTemp)->A2_TEL)
	(cWTabAlias)->FAXPROV	:= Trim((cTemp)->A2_FAX)

	(cWTabAlias)->NUMPED	:= Trim((cTemp)->C7_NUM)
	(cWTabAlias)->NUMSC		:= Trim((cTemp)->C7_NUMSC)

	//DETALLE
	(cWTabAlias)->ITEMPED	:= Trim((cTemp)-> C7_ITEM)
	(cWTabAlias)->CODPROD	:= Trim((cTemp)-> C7_PRODUTO)
	(cWTabAlias)->DESCPROD	:= Trim((cTemp)-> B1_ESPECIF)
	(cWTabAlias)->UMPROD	:= Trim((cTemp)-> C7_UM)
	(cWTabAlias)->CANTPROD	:= (cTemp)->C7_QUANT
	(cWTabAlias)->PRECPROD	:= nPrecio
	(cWTabAlias)->TOTAL		:= nTotal
	(cWTabAlias)->FECHAENT	:= cFchEnt
	(cWTabAlias)->CCPED		:= Trim((cTemp)->C7_CC)

	(cWTabAlias)->IMPUESTO	:= nImpuesto

	(cWTabAlias)->FECHAENT	:= cFchEnt
	(cWTabAlias)->PRIORIZA	:= Trim((cTemp)->C7_UPRIORI)
//	C7_UTIPCTA, C7_MOEDCTA
	//	(cWTabAlias)->CHEQNOME	:= TRIM(TRIM((cTemp)->A2_NUMCON) + " " +if(EMPTY(TRIM((cTemp)->A2_MOEDCTA)),TRIM((cTemp)->A2_MOEDCTA), UPPER(GETMV('MV_MOEDA' + TRIM((cTemp)->A2_MOEDCTA)))) + " " + TRIM((cTemp)->A2_UBANCOP) + " " + TRIM((cTemp)->A2_UAGENCI) + " " + TRIM((cTemp)>A2_UTITCTA))
	(cWTabAlias)->CHEQNOME	:=  + TRIM(TRIM(cTipoCuenta + " " +cMoneda + " " + (cTemp)->A2_UNUMCON) + " " + TRIM((cTemp)->A2_UBANCOP) + " " + TRIM((cTemp)->A2_UAGENCI)+ " " + TRIM((cTemp)->A2_UTITCTA))  // edson 16.09.2019
	(cWTabAlias)->OBSERV	:= TRIM((cTemp)->C7_OBS)
	(cWTabAlias)->FORMPAGO	:= TRIM((cTemp)->E4_DESCRI)
	(cWTabAlias)->FECVALID	:= cFchEnt2
	(cWTabAlias)->SUCURSAL	:= cSuc
	(cWTabAlias)->VAlORLIT	:= valorliteral

	(cWTabAlias)->(MsUnlock())

	(cTemp)->(dbSkip())
EndDo

return .T.
