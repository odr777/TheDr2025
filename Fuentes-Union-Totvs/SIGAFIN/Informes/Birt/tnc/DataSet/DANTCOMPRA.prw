#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset DANTCOMPRA
title "REPORTE COMPARATIVO DE CONTROL PRESUPUESTARIO3"
description "Cabecera"
PERGUNTE "CVENTA"

columns
  
//date set que se arrastran  a las columnas
define column CXC           type 	numeric size 20  decimals 3   label   "CXC"
define column MORA          type 	numeric size 20  decimals 3   label   "MORA"
define column PORC_MORA     type 	numeric size 20  decimals 3   label   "PORC_MORA"

define column RANGO_0       type 	numeric size 20  decimals 3   label   "RANGO_0"
define column RANGO_30      type 	numeric size 20  decimals 3   label   "RANGO_30"
define column RANGO_45      type 	numeric size 20  decimals 3   label   "RANGO_45"
define column RANGO_60      type 	numeric size 20  decimals 3   label   "RANGO_60"
define column RANGO_90      type 	numeric size 20  decimals 3   label   "RANGO_90"
define column RANGO_91      type 	numeric size 20  decimals 3   label   "RANGO_91"

//fDesc("SX5","34"+(cAliasFun)->RA_NACIONA,"X5_DESCRI")

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""

local cTemp 		:= getNextAlias()
//Local cQuery	    := ""
private nMoeda		:= ""
private nfechaActual
private nfechaAnt 
private cFechaFin
private cSucursal	:= ""
private cTipo_Titulo	:= ""
private ctipo_cli	:= ""

cFechaFin	:= self:execParamValue( "MV_PAR01" )
nMoeda		:= self:execParamValue( "MV_PAR02" )
cSucursal	:= self:execParamValue( "MV_PAR03" )
ctipo_cli	:= self:execParamValue( "MV_PAR04" )
cTipo_Titulo := self:execParamValue( "MV_PAR05" )

aux := MonthSub(cFechaFin,1)
nfechaActual := LastDate(aux)
nfechaAnt := DTOS(nfechaActual)

//recebendo o valor dos parametros

if ::isPreview()
endif

cWTabAlias := ::createWorkTable()

cursorwait()
// tb producto
BeginSql alias cTemp

	SELECT
	   SUM(
	   CASE
		  WHEN
			 MONEDA = 2 
		  THEN
			 ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:nfechaAnt%), 2)*SIGNO 
		  ELSE
			 ROUND(SALDO, 2)*SIGNO 
	   END
	) CXC,
	   SUM(
	   CASE
		  WHEN
			 ESTADO = 'VENCIDO' 
		  THEN
			 CASE
				WHEN
				   MONEDA = 2 
				THEN
				   ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:nfechaAnt%), 2)*SIGNO 
				ELSE
				   ROUND(SALDO, 2)*SIGNO 
			 END
			 ELSE
				0 
	   END
	) MORA, SUM(
	   CASE
		  WHEN
			 RANGO = '0' 
		  THEN
			 CASE
				WHEN
				   MONEDA = 2 
				THEN
				   ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:nfechaAnt%), 2)*SIGNO 
				ELSE
				   ROUND(SALDO, 2)*SIGNO 
			 END
			 ELSE
				0 
	   END
	) RANGO_0, SUM(
	   CASE
		  WHEN
			 RANGO = '30' 
		  THEN
			 CASE
				WHEN
				   MONEDA = 2 
				THEN
				   ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:nfechaAnt%), 2)*SIGNO 
				ELSE
				   ROUND(SALDO, 2)*SIGNO 
			 END
			 ELSE
				0 
	   END
	) RANGO_30, SUM(
	   CASE
		  WHEN
			 RANGO = '45' 
		  THEN
			 CASE
				WHEN
				   MONEDA = 2 
				THEN
				   ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:nfechaAnt%), 2)*SIGNO 
				ELSE
				   ROUND(SALDO, 2)*SIGNO 
			 END
			 ELSE
				0 
	   END
	) RANGO_45, SUM(
	   CASE
		  WHEN
			 RANGO = '60' 
		  THEN
			 CASE
				WHEN
				   MONEDA = 2 
				THEN
				   ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:nfechaAnt%), 2)*SIGNO 
				ELSE
				   ROUND(SALDO, 2)*SIGNO 
			 END
			 ELSE
				0 
	   END
	) RANGO_60, SUM(
	   CASE
		  WHEN
			 RANGO = '90' 
		  THEN
			 CASE
				WHEN
				   MONEDA = 2 
				THEN
				   ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:nfechaAnt%), 2)*SIGNO 
				ELSE
				   ROUND(SALDO, 2)*SIGNO 
			 END
			 ELSE
				0 
	   END
	) RANGO_90, SUM(
	   CASE
		  WHEN
			 RANGO = '91' 
		  THEN
			 CASE
				WHEN
				   MONEDA = 2 
				THEN
				   ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:nfechaAnt%), 2)*SIGNO 
				ELSE
				   ROUND(SALDO, 2)*SIGNO 
			 END
			 ELSE
				0 
	   END
	) RANGO_91 
	FROM
	   (
		  SELECT
			 E1.E1_FILIAL,
			 E1.E1_CLIENTE,
			 E1.E1_LOJA,
			 E1.E1_PREFIXO,
			 E1.E1_NUM,
			 E1.E1_TIPO,
			 E1_MOEDA MONEDA,
			 E1.E1_EMISSAO FECHA_EMISION,
			 E1.E1_VENCTO FECHA_VCTO,
			 CASE
				WHEN
				   E1_TIPO = 'RA' 
				   OR E1_TIPO = 'NCC' 
				THEN
				   - 1 
				ELSE
				   1 
			 END
			 SIGNO, 
			 CASE
				WHEN
				   DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) <= 0 
				THEN
				   'POR_VENCER' 
				ELSE
				   'VENCIDO' 
			 END
			 ESTADO, E1.E1_VALOR MONTO, 
			 CASE
				WHEN
				   E1_ORIGEM IN 
				   (
					  'PTOVTA', 'PLUSVTA'
				   )
				THEN
				   E1.E1_VALOR 		
				ELSE
				   ROUND(ISNULL(E5.ABONO, 0), 2) 
			 END
			 ABONO, 
			 CASE
				WHEN
				   E1_ORIGEM IN 
				   (
					  'PTOVTA', 'PLUSVTA'
				   )
				THEN
				   0 		
				ELSE
				   ROUND(E1.E1_VALOR, 2) - ROUND(ISNULL(E5.ABONO, 0), 2) 
			 END
			 SALDO, 
			 CASE
				WHEN
				   DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) <= 0 
				THEN
				   '0' 
				WHEN
				   DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) > 0 
				   AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) <= 30 
				THEN
				   '30' 
				WHEN
				   DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) > 30 
				   AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) <= 45 
				THEN
				   '45' 
				WHEN
				   DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) > 45 
				   AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) <= 60 
				THEN
				   '60' 
				WHEN
				   DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) > 60 
				   AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) <= 90 
				THEN
				   '90' 
				WHEN
				   DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:nfechaAnt%) > 90 
				THEN
				   '91' 
			 END
			 RANGO 
		  FROM %table:SE1% E1
		  JOIN %table:SA1% A1 
				ON E1.E1_CLIENTE = A1.A1_COD 
				AND E1.E1_LOJA = A1.A1_LOJA 
				AND E1.E1_TIPO IN ( %Exp:getParametro(cTipo_Titulo)% )
				AND A1.A1_UCTIPO IN (%Exp:getTipoCli(ctipo_cli)%)
		  LEFT JOIN
				( SELECT
					  E5_FILIAL,
					  E5_PREFIXO,
					  E5_NUMERO,
					  E5_PARCELA,
					  E5_TIPO,
					  E5_CLIFOR,
					  E5_LOJA,
					  SUM (
					  CASE
						 WHEN
							E5_TIPODOC = 'ES' 
						 THEN
							E5_VLMOED2* - 1 
						 ELSE
							E5_VLMOED2 
					  END ) AS ABONO 
		  FROM %table:SE5%
				   WHERE
					  D_E_L_E_T_ != '*' 
					  AND E5_SITUACA = '' 
					  AND E5_DATA <= %Exp:nfechaAnt%
				   GROUP BY
					  E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA
				)E5 
				ON E1.E1_FILIAL = E5.E5_FILIAL 
				AND E1.E1_PREFIXO = E5.E5_PREFIXO 
				AND E1.E1_NUM = E5.E5_NUMERO 
				AND E1.E1_PARCELA = E5.E5_PARCELA 
				AND E1.E1_TIPO = E5.E5_TIPO 
				AND E1.E1_CLIENTE = E5.E5_CLIFOR 
				AND E1.E1_LOJA = E5.E5_LOJA 
		  WHERE
			 E1.D_E_L_E_T_ != '*' 
			 AND A1.D_E_L_E_T_ != '*' 
			 AND E1.E1_FILIAL IN ( %Exp:getParametro(cSucursal)% )
			 AND E1.E1_EMISSAO <= %Exp:nfechaAnt%) TBL_A

EndSql

cursorarrow()
cQuery:=GetLastQuery()
//Aviso("query",cvaltochar(cQuery[2]`````),{"si"})//   usar este en esste caso cuando es BEGIN SQL

dbSelectArea( cTemp )
(cTemp)->(dbGotop())

While (cTemp)->(!EOF())

	nCxc := (cTemp)->CXC
	nMora := (cTemp)->MORA
				
	nPorcentaje_mora := (nCxc / nMora)

	RecLock(cWTabAlias, .T.)


if(nMoeda == 1)		
	
		(cWTabAlias)->CXC	        := nCxc
		(cWTabAlias)->MORA	        := nMora
		(cWTabAlias)->PORC_MORA     := nPorcentaje_mora
		(cWTabAlias)->RANGO_0	    := (cTemp)->RANGO_0
		(cWTabAlias)->RANGO_30	    := (cTemp)->RANGO_30
		(cWTabAlias)->RANGO_45	    := (cTemp)->RANGO_45
		(cWTabAlias)->RANGO_60	    := (cTemp)->RANGO_60
		(cWTabAlias)->RANGO_90	    := (cTemp)->RANGO_90
		(cWTabAlias)->RANGO_91	    := (cTemp)->RANGO_91
		
	elseif(nMoeda == 2)
		
		(cWTabAlias)->CXC	        := cambMoeda(nCxc)
		(cWTabAlias)->MORA	        := cambMoeda(nMora)
		(cWTabAlias)->PORC_MORA     := cambMoeda(nPorcentaje_mora)
		(cWTabAlias)->RANGO_0	    := cambMoeda((cTemp)->RANGO_0)
		(cWTabAlias)->RANGO_30	    := cambMoeda((cTemp)->RANGO_30)
		(cWTabAlias)->RANGO_45	    := cambMoeda((cTemp)->RANGO_45)
		(cWTabAlias)->RANGO_60	    := cambMoeda((cTemp)->RANGO_60)
		(cWTabAlias)->RANGO_90	    := cambMoeda((cTemp)->RANGO_90)
		(cWTabAlias)->RANGO_91	    := cambMoeda((cTemp)->RANGO_91)		

	endif

	(cWTabAlias)->(MsUnlock())
	(cTemp)->(dbSkip())
enddo
return .T.

static function cambMoeda(cValor)	
	local cNewVal	
	cNewVal = xMoeda(cValor,1,2,,2,1,0)	
return cNewVal


static function getParametro(cSuc)

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

	cResSuc := + "%'" + cSucursales + "'%"

return cResSuc 


static function getTipoCli(cSuc)

	local cSucursales := ""
	local nCount
	local cResSuc := ""
	local array := {}
	local valor := ""
	array := StrTokArr( cSuc , "," )	
//	alert(array[1])
	if(len(array) == 1)
		cSucursales := array[1]	
	DO CASE		
		CASE ALLTRIM(cSucursales) == 'DGAN'
			valor  :=  "1"
		CASE ALLTRIM(cSucursales) == 'DIM'
			valor  :=  "2"
		CASE ALLTRIM(cSucursales) == 'RETAIL'
			valor  :=  "3"
		CASE ALLTRIM(cSucursales) == 'DACER'
			valor  :=  "4"		
	ENDCASE	
	else
		cSucursales := array[1]
	DO CASE		
		CASE ALLTRIM(cSucursales) == 'DGAN'
			valor  :=  "1"
		CASE ALLTRIM(cSucursales) == 'DIM'
			valor  :=  "2"
		CASE ALLTRIM(cSucursales) == 'RETAIL'
			valor  :=  "3"
		CASE ALLTRIM(cSucursales) == 'DACER'
			valor  :=  "4"		
	ENDCASE	
		FOR nCount:= 2 TO Len(array) Step 1	
			cSucursales := array[nCount]
		DO CASE		
			CASE ALLTRIM(cSucursales) == 'DGAN'
				valor  += " ',' " + "1"
			CASE ALLTRIM(cSucursales) == 'DIM'
				valor  += " ',' " + "2"
			CASE ALLTRIM(cSucursales) == 'RETAIL'
				valor  += " ',' " + "3"
			CASE ALLTRIM(cSucursales) == 'DACER'
				valor  += " ',' " + "4"		
		ENDCASE							
		Next	
	end if
		
	cResSuc := + "%'" + valor + "'%"

return cResSuc 


//static function getTipoCli(cSuc)
//
//	local valor := ""
// 	DO CASE
//		CASE ALLTRIM(cSuc) == 'TODOS'
//			valor  :=  "1" + " ',' " + "2" + " ',' " + "3" + " ',' " + "4" 
//		CASE ALLTRIM(cSuc) == 'PRODUCTOR'
//			valor  :=  "1"
//		CASE ALLTRIM(cSuc) == 'DISTRIBUIDOR'
//			valor  :=  "2"
//		CASE ALLTRIM(cSuc) == 'RETAIL'
//			valor  :=  "3"
//		CASE ALLTRIM(cSuc) == 'DACER'
//			valor  :=  "4"		
//	ENDCASE
//
//	cResSuc := + "%'" + valor + "'%"
//
//return cResSuc 



