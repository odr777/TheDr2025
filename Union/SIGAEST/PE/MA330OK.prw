#include 'protheus.ch'
#include 'parmtype.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA330OK   ºAutor  ³TdeP Bolivia º Data ³09/05/20º            ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada que es ejecutado Antes del procesamiento  º±±
±±º          ³ del recalculo de Costo Medio                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Unión Bolivia                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function MA330OK()
Local lRet := .T.
/*
	If U_UPSD1SD2() //Actualiza costos de transferencia para que queden igual
		lRet := .T.
	else
		lRet := .F.
	end
	
	If U_UPDEVFAT() // Actualiza D1_TIPO para las devoluciones
		lRet := .T.
	else
		lRet := .F.
	end

	If U_UPCOSCQ() // Actualiza Costo CQ
		lRet := .T.
	else
		lRet := .F.
	end
*/	
	If U_UPTM008() // Actualiza D3_NUMSEQ para D3_CF = 'DE6' AND D3_TM BETWEEN '000' AND '498'
		lRet := .T.
	else
		lRet := .F.
	end

	If U_ACTSD3DOL() // Actualiza SD3 Costo en dólares cuándo está con 0 
		lRet := .T.
	else
		lRet := .F.
	end

/*	
	If U_UPDEVPRO() // Actualiza D2_TIPO en Dev. a Prov. sin Doc.Orig.
		lRet := .T.
	else
		lRet := .F.
	end
	
	If U_UPSD3DE6() // Actualiza SD3 D3_CF DE6
		lRet := .T.
	else
		lRet := .F.
	end

	If U_UPSD3RE6() // Actualiza SD3 D3_CF RE6
		lRet := .T.
	else
		lRet := .F.
	end
*/

return lRet

//ACTUALIZAR SD1 CON SD2 CUSTO PARA TRANSFERENCIAS ENTRE SUCURSALES
User Function UPSD1SD2()
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SD1')+ " SET D1_CUSTO = (SELECT D2_CUSTO1 "
StrSql+=" 	FROM " + RETSQLNAME('SD2')
StrSql+=" 	WHERE D_E_L_E_T_ = ' ' "
StrSql+=" 	AND D2_DOC LIKE D1_DOC "
StrSql+=" 	AND D2_COD = D1_COD "
StrSql+=" 	AND D2_TIPODOC = '54' "
StrSql+=" 	AND D2_NUMSEQ = D1_IDENTB6 "
StrSql+=" ), "
StrSql+=" D1_CUSTO2 = (SELECT D2_CUSTO2 "
StrSql+=" 	FROM " + RETSQLNAME('SD2')
StrSql+=" 	WHERE D_E_L_E_T_ = ' ' "
StrSql+=" 	AND D2_DOC LIKE D1_DOC "
StrSql+=" 	AND D2_COD = D1_COD "
StrSql+=" 	AND D2_TIPODOC = '54' "
StrSql+=" 	AND D2_NUMSEQ = D1_IDENTB6 "
StrSql+=" ), "
StrSql+=" D1_CUSTO3 = (SELECT D2_CUSTO3 "
StrSql+=" 	FROM " + RETSQLNAME('SD2')
StrSql+=" 	WHERE D_E_L_E_T_ = ' ' "
StrSql+=" 	AND D2_DOC LIKE D1_DOC "
StrSql+=" 	AND D2_COD = D1_COD "
StrSql+=" 	AND D2_TIPODOC = '54' "
StrSql+=" 	AND D2_NUMSEQ = D1_IDENTB6 "
StrSql+=" ), "
StrSql+=" D1_CUSTO4 = (SELECT D2_CUSTO4 "
StrSql+=" 	FROM " + RETSQLNAME('SD2')
StrSql+=" 	WHERE D_E_L_E_T_ = ' ' "
StrSql+=" 	AND D2_DOC LIKE D1_DOC "
StrSql+=" 	AND D2_COD = D1_COD "
StrSql+=" 	AND D2_TIPODOC = '54' "
StrSql+=" 	AND D2_NUMSEQ = D1_IDENTB6 "
StrSql+=" ), "
StrSql+=" D1_CUSTO5 = (SELECT D2_CUSTO5 "
StrSql+=" 	FROM " + RETSQLNAME('SD2')
StrSql+=" 	WHERE D_E_L_E_T_ = ' ' "
StrSql+=" 	AND D2_DOC LIKE D1_DOC "
StrSql+=" 	AND D2_COD = D1_COD "
StrSql+=" 	AND D2_TIPODOC = '54' "
StrSql+=" 	AND D2_NUMSEQ = D1_IDENTB6 "
StrSql+=" ) "
StrSql+=" WHERE D_E_L_E_T_ = ' ' "
StrSql+=" AND D1_DTDIGIT >= '" + DTOS(GetMv("MV_ULMES")+1) + "'"
StrSql+=" AND D1_TIPODOC = '64' "
StrSql+=" AND (D1_DOC+D1_COD+D1_IDENTB6) IN(SELECT D2_DOC+D2_COD+D2_NUMSEQ "
StrSql+=" 	FROM " + RETSQLNAME('SD2')
StrSql+=" 	WHERE D_E_L_E_T_ = ' ' "
StrSql+=" 	AND D2_TIPODOC = '54') "

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
     MsgAlert("ERROR AL ACTUALIZAR SD1 CON SD2 CUSTO DE TRANSFERENCIA")
     return .F.
 EndIf

Return .T.


//ACTUALIZA LA SECUENCIA PARA QUE LOS TM 008 QUEDEN ANTES
User Function UPTM008()
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SD3')+ " SET D3_NUMSEQ = ' '+SUBSTRING(D3_NUMSEQ, 2, 6), D3_USEQCAL = D3_NUMSEQ "
StrSql+=" WHERE D3_CF = 'DE6' AND D3_TM BETWEEN '000' AND '498' "
StrSql+=" AND D3_EMISSAO > '" + DTOS(GetMv("MV_ULMES")+1) + "'"

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
     //MsgAlert("ERROR AL ACTUALIZAR D3_NUMSEQ EN TM 008")
     aviso("ERROR AL ACTUALIZAR D3_NUMSEQ EN D3_CF DE6",StrSql,{'ok'},,,,,.t.)
     return .F.
 EndIf

Return .T.

User Function ACTSD3DOL()
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SD3')+ " SET D3_CUSTO2 = ROUND(D3_CUSTO1/(SELECT MAX(M2_MOEDA2) FROM " + RETSQLNAME('SM2')+ " WHERE M2_DATA = D3_EMISSAO),6) "
StrSql+=" WHERE D3_CUSTO1 > 0.06 AND D3_CUSTO2 = 0 "
StrSql+=" AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'"

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
     //MsgAlert("ERROR AL ACTUALIZAR D3_NUMSEQ EN TM 008")
     aviso("ERROR AL ACTUALIZAR D3_CUSTO2 CUANDO ES 0 ",StrSql,{'ok'},,,,,.t.)
     return .F.
 EndIf

Return .T.
