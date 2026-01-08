#Include 'Protheus.ch'
#include "Birtdataset.ch"
#Include 'topConn.ch'

User_Dataset Dcom
title "REPORTE COMPARATIVO DE CONTROL PRESUPUESTARIO2 prueba"
description "Cabecera"
PERGUNTE "CVent"

columns

define column IVE           type 	numeric size 20  decimals 3   label   "IVE"

//date set que se arrastran  a las columnas
define column CXC           type 	numeric size 20  decimals 2   label   "CXC"
define column MORA          type 	numeric size 20  decimals 2   label   "MORA"
define column PORC_MORA     type 	numeric size 20  decimals 2   label   "PORC_MORA"

define column RANGO_0       type 	numeric size 20  decimals 3   label   "RANGO_0"
define column RANGO_30      type 	numeric size 20  decimals 3   label   "RANGO_30"
define column RANGO_60      type 	numeric size 20  decimals 3   label   "RANGO_60"
define column RANGO_90      type 	numeric size 20  decimals 3   label   "RANGO_90"
define column RANGO_120     type 	numeric size 20  decimals 3   label   "RANGO_120"
define column RANGO_150     type 	numeric size 20  decimals 3   label   "RANGO_150"
define column RANGO_180     type 	numeric size 20  decimals 3   label   "RANGO_180"
define column RANGO_365     type 	numeric size 20  decimals 3   label   "RANGO_365"
define column RANGO_366     type 	numeric size 20  decimals 3   label   "RANGO_366"


//fDesc("SX5","34"+(cAliasFun)->RA_NACIONA,"X5_DESCRI")

define query "SELECT * FROM %WTable:1% "

process dataset

local cWTabAlias	:= ""
local cTemp			:= getNextAlias() 
private nMoeda		:= ""
//local cSucursal		:= xFilial("SEL")
//Local cQuery	    := ""
private cFechaFin	:= ""
private cSucursal	:= ""
private cTipo_Titulo	:= ""
private ctipo_cli	:= ""
private cDeCond_pago := ""
private cACond_pago  := ""

cFechaFin	:= self:execParamValue( "MV_PAR01" )
nMoeda		:= self:execParamValue( "MV_PAR02" )
cSucursal	:= self:execParamValue( "MV_PAR03" )
ctipo_cli	:= self:execParamValue( "MV_PAR04" )
cTipo_Titulo := self:execParamValue( "MV_PAR05" )
cDeCond_pago := self:execParamValue( "MV_PAR06" )
cACond_pago	 := self:execParamValue( "MV_PAR07" )

//alert(cFechaFin)
//alert("hola")
//alert( DTOS(cFechaFin))
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
			 ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO 
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
				   ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO 
				ELSE
				   ROUND(SALDO, 2)*SIGNO 
			 END
			 ELSE
				0 
	   END
	) MORA, 
		SUM(CASE
               WHEN RANGO = '0' THEN CASE
                                         WHEN MONEDA = 2 THEN ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO
                                         ELSE ROUND(SALDO, 2)*SIGNO
                                     END
               ELSE 0
           END) RANGO_0,    
       SUM(CASE
               WHEN RANGO = '30' THEN CASE
                                         WHEN MONEDA = 2 THEN ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO
                                         ELSE ROUND(SALDO, 2)*SIGNO
                                     END
               ELSE 0
           END) RANGO_30,
       SUM(CASE
               WHEN RANGO = '60' THEN CASE
                                          WHEN MONEDA = 2 THEN ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO
                                          ELSE ROUND(SALDO, 2)*SIGNO
                                      END
               ELSE 0
           END) RANGO_60,
       SUM(CASE
               WHEN RANGO = '90' THEN CASE
                                          WHEN MONEDA = 2 THEN ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO
                                          ELSE ROUND(SALDO, 2)*SIGNO
                                      END
               ELSE 0
           END) RANGO_90,
       SUM(CASE
               WHEN RANGO = '120' THEN CASE
                                          WHEN MONEDA = 2 THEN ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO
                                          ELSE ROUND(SALDO, 2)*SIGNO
                                      END
               ELSE 0
           END) RANGO_120,
       SUM(CASE
               WHEN RANGO = '150' THEN CASE
                                          WHEN MONEDA = 2 THEN ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO
                                          ELSE ROUND(SALDO, 2)*SIGNO
                                      END
               ELSE 0
           END) RANGO_150,
       SUM(CASE
               WHEN RANGO = '180' THEN CASE
                                          WHEN MONEDA = 2 THEN ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO
                                          ELSE ROUND(SALDO, 2)*SIGNO
                                      END
               ELSE 0
           END) RANGO_180,
       SUM(CASE
	           WHEN RANGO = '365' THEN CASE
	                                      WHEN MONEDA = 2 THEN ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO
	                                      ELSE ROUND(SALDO, 2)*SIGNO
	                                  END
	           ELSE 0
           END) RANGO_365,
      SUM(CASE
	           WHEN RANGO = '366' THEN CASE
	                                      WHEN MONEDA = 2 THEN ROUND(SALDO * dbo.UC_FUN_TASA(%Exp:cFechaFin%), 2)*SIGNO
	                                      ELSE ROUND(SALDO, 2)*SIGNO
	                                  END
	           ELSE 0
           END) RANGO_366 
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
				   DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) <= 0 
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
                   WHEN DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) <= 0 THEN '0'
                   WHEN DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) > 0
                        AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) <= 30 THEN '30'
                   WHEN DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) > 31
                        AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) <= 60 THEN '60'
                   WHEN DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) > 61
                        AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) <= 90 THEN '90'
                   WHEN DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) > 91
                        AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) <= 120 THEN '120'
                   WHEN DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) > 121
                    	AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) <= 150 THEN '150'
                   WHEN DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) > 151
                    	AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) <= 180 THEN '180'
                   WHEN DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) > 181
                    	AND DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) <= 365 THEN '365'
                   WHEN DATEDIFF(dayofyear, E1.E1_VENCTO, %Exp:cFechaFin%) > 365 THEN '366'
               END RANGO
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
					  AND E5_DATA <= %Exp:cFechaFin%
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
			 E1.%notDel% 
			 AND A1.%notDel%
			 AND E1.E1_FILIAL IN ( %Exp:getParametro(cSucursal)% )
			 AND E1.E1_EMISSAO <= %Exp:cFechaFin% ) TBL_A

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
	nIve  :=   (nCxc/Getvnt100()) 

	RecLock(cWTabAlias, .T.)
		
	if(nMoeda == 1)		
	
		(cWTabAlias)->IVE	        := nIve
		(cWTabAlias)->CXC	        := nCxc
		(cWTabAlias)->MORA	        := nMora
		(cWTabAlias)->PORC_MORA     := nPorcentaje_mora
		(cWTabAlias)->RANGO_0	    := (cTemp)->RANGO_0
		(cWTabAlias)->RANGO_30	    := (cTemp)->RANGO_30
		(cWTabAlias)->RANGO_60	    := (cTemp)->RANGO_60
		(cWTabAlias)->RANGO_90	    := (cTemp)->RANGO_90
		(cWTabAlias)->RANGO_120	    := (cTemp)->RANGO_120
		(cWTabAlias)->RANGO_150	    := (cTemp)->RANGO_150
		(cWTabAlias)->RANGO_180	    := (cTemp)->RANGO_180
		(cWTabAlias)->RANGO_365	    := (cTemp)->RANGO_365
		(cWTabAlias)->RANGO_366	    := (cTemp)->RANGO_366
		
		
	elseif(nMoeda == 2)
		
		(cWTabAlias)->IVE	        := cambMoeda(nIve)
		(cWTabAlias)->CXC	        := cambMoeda(nCxc)
		(cWTabAlias)->MORA	        := cambMoeda(nMora)
		(cWTabAlias)->PORC_MORA     := cambMoeda(nPorcentaje_mora)
		(cWTabAlias)->RANGO_0	    := cambMoeda((cTemp)->RANGO_0)
		(cWTabAlias)->RANGO_30	    := cambMoeda((cTemp)->RANGO_30)
		(cWTabAlias)->RANGO_60	    := cambMoeda((cTemp)->RANGO_60)
		(cWTabAlias)->RANGO_90	    := cambMoeda((cTemp)->RANGO_90)
		(cWTabAlias)->RANGO_120	    := cambMoeda((cTemp)->RANGO_120)
		(cWTabAlias)->RANGO_150	    := cambMoeda((cTemp)->RANGO_150)
		(cWTabAlias)->RANGO_180	    := cambMoeda((cTemp)->RANGO_180)
		(cWTabAlias)->RANGO_365	    := cambMoeda((cTemp)->RANGO_365)
		(cWTabAlias)->RANGO_366	    := cambMoeda((cTemp)->RANGO_366)	
			

	endif
		
	(cWTabAlias)->(MsUnlock())
	(cTemp)->(dbSkip())
enddo
return .T.

Static Function Getvnt100()

local cTemp			:= getNextAlias()
Local cQuery	    := ""
Local nValor   

	cQuery+= "SELECT"    
    cQuery+= "ROUND(SUM(VNT_BS),0) VNT_100,"
    cQuery+= "ROUND(SUM(MUB_87_BS),0) MUB_87,"
    cQuery+= "ROUND(SUM(CASE WHEN COD_PAGO BETWEEN '"+ cDeCond_pago  +"' and '" + cACond_pago + "'THEN  VNT_BS ELSE 0 END),0) VNT_100_CONTADO,"
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
	
//	Aviso("",cQuery,{'ok'},,,,,.t.)
	
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cTemp, .F., .T.)
	dbSelectArea(cTemp)
	dbGoTop()
	
	While (cTemp)->(!EOF())

	nValor := (cTemp)->VNT_100	
//	alert(nValor)
	
	(cTemp)->(dbSkip())
	
enddo		
return nValor

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

	cResSuc := + "'" + cSucursales + "'"

return cResSuc 

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



