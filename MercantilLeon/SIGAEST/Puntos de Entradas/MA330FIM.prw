#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "TOPCONN.CH"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA330OK   บAutor  ณTdeP Bolivia บ Data ณ16/04/2023บ		   ฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Punto de entrada que es ejecutado despues de todo el 	  บฑฑ
ฑฑบ          ณ procesamiento del recalculo de Costo Medio para actualizar บฑฑ
ฑฑบ          ณ el costo en la SB2 que tenga costo negativo                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MERCANTIL LEON Bolivia                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function MA330FIM()

Local lRet := .T.
/*
	If U_UPRDEVFAT() // ACTUALIZAR D2_CUSTO1 y D2_CUSTO2 para las Facturas con Remito
		lRet := .T.
	else
		lRet := .F.
	end
*/

	If U_USB2NEG() // ACTUALIZAR en la SB2 los costos negativos
		lRet := .T.
	else
		lRet := .F.
	end

/*	
	If U_ACTNUMSEQ() // Actualiza/Restaura D3_NUMSEQ para las D3_CF = 'DE6'  AND D3_TM BETWEEN '000' AND '498'
		lRet := .T.
	else
		lRet := .F.
	end
*/	
	
/*
	If U_UPRDEVPRO() // Actualiza/Restaura D2_TIPO para las devoluciones a Proveedores sin DOC.ORIG.
		lRet := .T.
	else
		lRet := .F.
	end
	*/
return


//ACTUALIZAR en la SB2 los costos negativos
User Function USB2NEG()
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SB2')+ " SET B2_VFIM1 = ABS(B2_VFIM1), B2_VATU1 = ABS(B2_VATU1), B2_CM1 = ABS(B2_CM1), B2_VFIM2=ABS(B2_VFIM2), B2_VATU2=ABS(B2_VATU2), B2_CM2=ABS(B2_CM2) "
StrSql+=" WHERE D_E_L_E_T_ = ' ' AND (B2_VFIM1 < 0 OR B2_VATU1 < 0 OR B2_CM1 < 0 OR B2_VFIM2 < 0 OR B2_VATU2 < 0 OR B2_CM2 < 0) "
//StrSql+=" AND D2_DTDIGIT >= '" + DTOS(GetMv("MV_ULMES")+1) + "'"

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
//     MsgAlert("ERROR AL ACTUALIZAR en la SB2 los costos negativos")
     aviso("ERROR AL ACTUALIZAR en la SB2 los costos negativos",StrSql,{'ok'},,,,,.t.)
     return .F.
 EndIf

Return .T.

//ACTUALIZAR D2_CUSTO1 y D2_CUSTO2 para las Facturas con Remito
User Function UPRDEVFAT()
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SD2')+ " SET D2_CUSTO1 = "
StrSql+=" (SELECT D2_CUSTO1 FROM " + RETSQLNAME('SD2')+ " SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_FILIAL+SD2.D2_CLIENTE+SD2.D2_LOJA+SD2.D2_DOC+SD2.D2_ITEM = SD2010.D2_FILIAL+SD2010.D2_CLIENTE+SD2010.D2_LOJA+SD2010.D2_REMITO+SD2010.D2_ITEMREM AND SD2.D2_COD = SD2010.D2_COD AND SD2.D2_FILIAL = SD2010.D2_FILIAL AND SD2.D2_LOCAL = SD2010.D2_LOCAL AND SD2.D2_ESPECIE <> 'NF'), "
StrSql+=" D2_CUSTO2 =(SELECT D2_CUSTO2 FROM " + RETSQLNAME('SD2')+ " SD2 WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_FILIAL+SD2.D2_CLIENTE+SD2.D2_LOJA+SD2.D2_DOC+SD2.D2_ITEM = SD2010.D2_FILIAL+SD2010.D2_CLIENTE+SD2010.D2_LOJA+SD2010.D2_REMITO+SD2010.D2_ITEMREM AND SD2.D2_COD = SD2010.D2_COD AND SD2.D2_FILIAL = SD2010.D2_FILIAL AND SD2.D2_LOCAL = SD2010.D2_LOCAL AND SD2.D2_ESPECIE <> 'NF') "
StrSql+=" WHERE D_E_L_E_T_ = ' ' AND D2_ESPECIE = 'NF' AND D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_REMITO+D2_ITEMREM IN(SELECT D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_DOC+D2_ITEM FROM SD2010 SD2 WHERE D_E_L_E_T_ = ' ' AND SD2.D2_COD = SD2010.D2_COD AND SD2.D2_FILIAL = SD2010.D2_FILIAL AND SD2.D2_LOCAL = SD2010.D2_LOCAL AND SD2.D2_ESPECIE <> 'NF') "
//StrSql+=" 	WHERE D_E_L_E_T_ = ' ' "
StrSql+=" AND D2_DTDIGIT >= '" + DTOS(GetMv("MV_ULMES")+1) + "'"

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
//     MsgAlert("ERROR AL ACTUALIZAR D2_CUSTO1 y D2_CUSTO2 para las Facturas con Remito")
     aviso("ERROR AL ACTUALIZAR D2_CUSTO1 y D2_CUSTO2 para las Facturas con Remito",StrSql,{'ok'},,,,,.t.)
     return .F.
 EndIf

Return .T.

//RESTAURA LA SECUENCIA PARA QUE LOS D3_CF = 'DE6' QUEDEN ANTES
User Function ACTNUMSEQ()
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SD3')+ " SET D3_NUMSEQ = D3_USEQCAL "
StrSql+=" WHERE D3_CF = 'DE6' AND D3_TM BETWEEN '000' AND '498' AND D3_USEQCAL <> ' '"
StrSql+=" AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'"

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
     //MsgAlert("ERROR AL ACTUALIZAR D3_NUMSEQ EN TM 008")
     aviso("ERROR AL ACTUALIZAR D3_NUMSEQ EN D3_CF DE6",StrSql,{'ok'},,,,,.t.)
     return .F.
 EndIf
Return .T.

//ACTUALIZAR/RESTAURA D2_TIPO para las devoluciones a Proveedores
User Function UPRDEVPRO()
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SD2')+ " SET D2_TIPO = 'D', D2_ESPECIE = 'RCD' "
StrSql+=" 	WHERE D_E_L_E_T_ = ' ' "
StrSql+=" 	AND D2_TIPO = 'Z' "
StrSql+=" AND D2_DTDIGIT BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'"

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
     MsgAlert("ERROR AL ACTUALIZAR D2_TIPO PARA RESTAURAR LAS DEVOLUCIONES A PROVEEDORES SIN DOC.ORIG.")
     return .F.
 EndIf

Return .T.
