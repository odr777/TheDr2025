#include 'protheus.ch'
#include 'parmtype.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DVEnt
title "REPORTE COMPARATIVO DE CONTROL PRESUPUESTARIO prueba"
description "Cabecera"
PERGUNTE "CVent"

columns

define column IVE_CORTE   type 	character size 30  label "IVE_CORTE"
define column FCH_CORTE   type 	character size 30  label "FCH_CORTE"
define column CIERRCORTE  type 	character size 30  label "CIERRCORTE"

define column SUCURSAL    type 	character size 20  label "SUCURSAL"
define column FECHACORTE  type 	character size 20  label "FECHACORTE"
define column MES         type 	character size 20  label "MES"
define column MOEDA       type 	character size 20  label "MOEDA"

//date set que se arrastran  a las columnas
define column VNT_100     type 	numeric size 20  decimals 2   label   "VNT_100"
define column MUB_87      type 	numeric size 20  decimals 2   label   "MUB_87"
define column TUB         type 	numeric size 20  decimals 2   label   "TUB"

define column VNT_CONT    type 	numeric size 20  decimals 2   label   "VNT_CONT"
define column VNT_CREDI   type 	numeric size 20  decimals 2   label   "VNT_CREDI"
define column VNT_TOTAL   type 	numeric size 20  decimals 2   label   "VNT_TOTAL"

//		define column PROYECCION  type 	character size tamSX3("RA_PRISOBR")[1]  label	"PROYECCION"
//		define column MONTO       type 	character size tamSX3("RA_SECSOBR")[1]  label	"MONTO"
//		define column PORCENTAJE  type 	character size tamSX3("RA_SECSOBR")[1]  label	"PORCENTAJE"

//fDesc("SX5","34"+(cAliasFun)->RA_NACIONA,"X5_DESCRI")

define query "SELECT * FROM %WTable:1% "


process dataset

local cWTabAlias	:= ""
local cTemp			:= getNextAlias()
local cSucursal		:= ""
//local cSucursal		:= xFilial("SEL")
Local cQuery	    := ""
private nMoeda		:= ""
private cFechaFin	:= ""
private nfechaAnt
private cDeCond_pago := ""
private cACond_pago  := ""

cFechaFin	 := self:execParamValue( "MV_PAR01" )
nMoeda		 := self:execParamValue( "MV_PAR02" )
cSucursal	 := self:execParamValue( "MV_PAR03" )
cDeCond_pago := self:execParamValue( "MV_PAR06" )
cACond_pago	 := self:execParamValue( "MV_PAR07" )

aux := MonthSub(cFechaFin,1)
nfechaAnt := LastDate(aux)

//recebendo o valor dos parametros

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cQuery+= "SELECT"
cQuery+= "ROUND(SUM(VNT_BS),0) VNT_100,"
cQuery+= "ROUND(SUM(MUB_87_BS),0) MUB_87,"
cQuery+= "ROUND(SUM(CASE WHEN COD_PAGO BETWEEN '"+ cDeCond_pago  +"' and '" + cACond_pago + "' THEN  VNT_BS ELSE 0 END),0) VNT_100_CONTADO,"
cQuery+= "ROUND(SUM(CASE WHEN COD_PAGO BETWEEN '"+ cDeCond_pago  +"' and '" + cACond_pago + "' THEN  0 ELSE VNT_BS END),0) VNT_100_CREDITO,"
cQuery+= "ROUND(SUM(CASE WHEN COD_PAGO BETWEEN '"+ cDeCond_pago  +"' and '" + cACond_pago + "' THEN  MUB_87_BS ELSE 0 END),0) MUB_87_CONTADO,"
cQuery+= "ROUND(SUM(CASE WHEN COD_PAGO BETWEEN '"+ cDeCond_pago  +"' and '" + cACond_pago + "' THEN  0 ELSE MUB_87_BS END),0) MUB_87_CREDITO"
cQuery+= "FROM (SELECT F2_FILIAL, F2_EMISSAO,"
cQuery+= "ROUND(CASE WHEN F2.F2_MOEDA=2 THEN D2.D2_TOTAL*dbo.UC_FUN_TASA(F2.F2_EMISSAO) ELSE D2.D2_TOTAL  END,4) VNT_BS,"
cQuery+= "ROUND(CASE WHEN F2.F2_MOEDA=1 THEN D2.D2_TOTAL*0.87-D2.D2_CUSTO1 ELSE D2.D2_TOTAL*dbo.UC_FUN_TASA(F2.F2_EMISSAO)*0.87-D2.D2_CUSTO1  END,2) MUB_87_BS,"
cQuery+= "F2.F2_COND COD_PAGO"
cQuery+= "FROM " + RetSqlName("SF2") + " F2 , " + RetSqlName("SD2") + " D2 "
cQuery+= "WHERE F2.D_E_L_E_T_!='*'"
cQuery+= " AND D2.D_E_L_E_T_!='*'"
cQuery+= " AND F2.F2_FILIAL = D2.D2_FILIAL"
cQuery+= " AND F2.F2_DOC = D2.D2_DOC"
cQuery+= " AND F2.F2_SERIE = D2.D2_SERIE"
cQuery+= " AND F2.F2_CLIENTE = D2.D2_CLIENTE"
cQuery+= " AND F2.F2_LOJA = D2.D2_LOJA"
cQuery+= ") TBL"
cQuery+= 'WHERE F2_FILIAL in (' + getSucursales(cSucursal) + ')'
cQuery+= " AND F2_EMISSAO BETWEEN '" + DTOS(FirstDate(cFechaFin)) + "' "
cQuery+= " AND '" + DTOS(cFechaFin) + "' "

cQuery:= ChangeQuery(cQuery)
//Aviso("",cQuery,{'ok'},,,,,.t.)

dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cTemp, .F., .T.)
dbSelectArea(cTemp)
dbGoTop()

While (cTemp)->(!EOF())

	nVnt := (cTemp)->VNT_100
	nMub := (cTemp)->MUB_87
	nVntCont := (cTemp)->VNT_100_CONTADO
	nCreCont := (cTemp)->VNT_100_CREDITO

	auxVnt := (nVnt * 0.87)
	nTub  := (nMub / auxVnt)
	nVenTotal := (nVntCont + nCreCont)

	nIveCorte   := "IVE A LA FECHA  " + cValToChar(DTOC(cFechaFin))
	nFechaCorte := "FECHA CORTE  " + cValToChar(DTOC(cFechaFin))
	nAntCorte   := "CIERRE ANTERIOR  " + cValToChar(DTOC(nfechaAnt))

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)->IVE_CORTE    := nIveCorte
	(cWTabAlias)->FCH_CORTE    := nFechaCorte
	(cWTabAlias)->CIERRCORTE   := nAntCorte
	(cWTabAlias)->MES	       := MesExtenso(cFechaFin)
	(cWTabAlias)->FECHACORTE   := DTOC(cFechaFin)
	(cWTabAlias)->SUCURSAL     := cSucursal

	if(nMoeda == 1)
		(cWTabAlias)->MOEDA  	   := "Bolivianos"
		(cWTabAlias)->VNT_100	   := nVnt
		(cWTabAlias)->MUB_87	   := nMub
		(cWTabAlias)->TUB	       := nTub
		(cWTabAlias)->VNT_CONT     := nVntCont
		(cWTabAlias)->VNT_CREDI	   := nCreCont
		(cWTabAlias)->VNT_TOTAL    := nVenTotal

	elseif(nMoeda == 2)

		(cWTabAlias)->MOEDA  	   := "Dolares"
		(cWTabAlias)->VNT_100	   := cambMoeda(nVnt)
		(cWTabAlias)->MUB_87	   := cambMoeda(nMub)
		//		alert(nMub)
		(cWTabAlias)->TUB	       := nTub
		(cWTabAlias)->VNT_CONT     := cambMoeda(nVntCont)
		(cWTabAlias)->VNT_CREDI	   := cambMoeda(nCreCont)
		//		alert(nVenTotal)
		(cWTabAlias)->VNT_TOTAL    := cambMoeda(nVenTotal)

	endif

	(cWTabAlias)->(MsUnlock())
	(cTemp)->(dbSkip())

enddo
return .T.

static function cambMoeda(cValor)
	local cNewVal
	cNewVal = xMoeda(cValor,1,2,,2,1,0)
return cNewVal


static function getSucursales(cSuc)

	local cSucursales := ""
	local nCount
	local cResSuc := ""
	local array := {}
	array := StrTokArr( cSuc , "," )	
	if(len(array) == 1)
		cSucursales := array[1]
	else
		cSucursales := array[1]
		FOR nCount:= 2 TO Len(array) Step 1			
			cSucursales += " ',' "+ array[nCount]			
		Next
	end if

	cResSuc := + " '" + cSucursales + "' "

return cResSuc 

