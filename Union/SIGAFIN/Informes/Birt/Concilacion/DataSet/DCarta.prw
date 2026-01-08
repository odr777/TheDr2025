#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DCarta
title "REPORTE CARTA DE CONCILACION DE CLIENTE"
description "Cabecera"
PERGUNTE "CCarta"

columns

define column NOMBRECLI   type 	character size 50  label "NOMBRECLI"
define column FECHA       type 	character size 40  label "FECHA"
define column DIRECCION   type 	character size 80  label "DIRECCION"
define column NOMRESPO    type 	character size 80  label "NOMRESPO"
define column CARGRESPO   type 	character size 80  label "CARGRESPO"
define column NOMUSER     type 	character size 80  label "NOMUSER"
define column TELUSER     type 	character size 80  label "TELUSER"
define column MONTO       type 	numeric size 20  decimals 2  label "MONTO"
define column IMPRISALDO  type 	numeric size 1  label "IMPRISALDO"
define column LOGO       type 	character size 2  label "LOGO"



//fDesc("SX5","34"+(cAliasFun)->RA_NACIONA,"X5_DESCRI")

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local cTemp			:= getNextAlias()
//local cSucursal		:= xFilial("SEL")
//Local cQuery	    := ""
private MV_PAR01	:= ""
private MV_PAR02    := ""
private MV_PAR03	:= ""
private MV_PAR04    := ""
private MV_PAR05	:= ""
private MV_PAR06	:= ""
private MV_PAR07    := ""
private MV_PAR08    := ""

MV_PAR01 := self:execParamValue( "MV_PAR01" )
MV_PAR02 := self:execParamValue( "MV_PAR02" )
MV_PAR03 := self:execParamValue( "MV_PAR03" )
MV_PAR04 := self:execParamValue( "MV_PAR04" )
MV_PAR05 := self:execParamValue( "MV_PAR05" )
MV_PAR06 := self:execParamValue( "MV_PAR06" )
MV_PAR07 := self:execParamValue( "MV_PAR07" )
MV_PAR08 := self:execParamValue( "MV_PAR08" )


//recebendo o valor dos parametros

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()

// tb producto
BeginSql alias cTemp

       	
		SELECT sum(E1_SALDO) AS TOTAL , A1_NOME
		FROM  %table:SE1% SE1
		INNER JOIN %table:SA1% SA1
		ON (E1_CLIENTE = A1_COD 
		AND E1_LOJA = A1_LOJA)
		WHERE  E1_CLIENTE = %exp:MV_PAR01%
		AND E1_LOJA BETWEEN %exp:MV_PAR02% AND %exp:MV_PAR03%
		AND E1_EMISSAO <= %exp:MV_PAR04% 
		AND E1_TIPO <> 'RA' 
		AND SE1.%notDel%
		AND SA1.%notDel% 
		GROUP by A1_NOME
		
EndSql

cursorarrow()

cQuery:=GetLastQuery()
//Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.T.)//   usar este en esste caso cuando es BEGIN SQL


dbSelectArea( cTemp )
(cTemp)->(dbGotop())

//cfecha := "Santa Cruz " + cValToChar(DTOC(date()))

cfecha          := 		cValToChar(date())
cDia			:= 		SubStr(cfecha, 1,2 )
cMes			:= 		SubStr(cfecha, 4,6 )
cAnho			:= 		SubStr(cfecha, 7,10 )
cfecha	        := 		"Santa Cruz "+cDia + " de " + MesExtenso(cMes) + " de " + cAnho

cDireccion := AllTrim(SM0->M0_ENDENT) + " / Telf.: " + AllTrim(SM0->M0_TEL)
cNombreUsr := PswRet()[1][14]

nMonto := Round((cTemp)->TOTAL,2)

While (cTemp)->(!EOF())

	RecLock(cWTabAlias, .T.)

	(cWTabAlias)->NOMBRECLI   :=  (cTemp)->A1_NOME
	(cWTabAlias)->FECHA       :=  cfecha
	(cWTabAlias)->NOMUSER     :=  cNombreUsr
	(cWTabAlias)->DIRECCION   :=  cDireccion
	(cWTabAlias)->NOMRESPO    :=  MV_PAR05
    (cWTabAlias)->CARGRESPO   :=  MV_PAR06
    (cWTabAlias)->LOGO        :=  cValToChar(MV_PAR07)    
   
   
   
   
    if(MV_PAR08 == 1)
    	
    	(cWTabAlias)->MONTO       :=  nMonto
    	(cWTabAlias)->IMPRISALDO  :=  1 // IMPRIME MONTO
    elseif(MV_PAR08 == 2)
    	(cWTabAlias)->MONTO       :=  nil
    	(cWTabAlias)->IMPRISALDO  :=  2 // NO IMPRIME MONTO
    
    end if
        
    
	(cWTabAlias)->(MsUnlock())
	(cTemp)->(dbSkip())

enddo
return .T.

//static function cambMoeda(cValor)
//	local cNewVal
//	cNewVal = xMoeda(cValor,1,2,,2,1,0)
//return cNewVal
//
//
//static function getSucursales(cSuc)
//
//	local cSucursales := ""
//	local nCount
//	local cResSuc := ""
//	local array := {}
//	array := StrTokArr( cSuc , "," )	
//	if(len(array) == 1)
//		cSucursales := array[1]
//	else
//		cSucursales := array[1]
//		FOR nCount:= 2 TO Len(array) Step 1			
//			cSucursales += " ',' "+ array[nCount]			
//		Next
//	end if
//
//	cResSuc := + " '" + cSucursales + "' "
//
//return cResSuc 

