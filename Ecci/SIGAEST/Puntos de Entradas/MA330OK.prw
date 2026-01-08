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
±±ºUso       ³ Constructoras Bolivia                                      º±±
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

/*
	If U_UPTM008() // Actualiza D3_NUMSEQ para D3_CF = 'DE6' AND D3_TM BETWEEN '000' AND '498'
		lRet := .T.
	else
		lRet := .F.
	end
*/

	If U_ACTSD3DOL() // Actualiza SD3 Costo en dólares cuándo está con 0 
		lRet := .T.
	else
		lRet := .F.
	end

	If U_ACTCUSEQ() // Actualiza SD3 Costo de equipos por Clase de valor 
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
     //MsgAlert("ERROR AL ACTUALIZAR SD1 CON SD2 CUSTO DE TRANSFERENCIA")
	 aviso("ERROR AL ACTUALIZAR SD1 CON SD2 CUSTO DE TRANSFERENCIA",StrSql,{'ok'},,,,,.t.)
     return .F.
 EndIf

Return .T.


//ACTUALIZA LA SECUENCIA PARA QUE LOS TM 008 QUEDEN ANTES
User Function UPTM008()
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SD3')+ " SET D3_NUMSEQ = ' '+SUBSTRING(D3_NUMSEQ, 2, 6), D3_USEQCAL = D3_NUMSEQ "
StrSql+=" WHERE D3_CF = 'DE6' AND D3_TM BETWEEN '000' AND '498' "
StrSql+=" AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'"

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
StrSql+=" AND D3_EMISSAO > '" + DTOS(GetMv("MV_ULMES")+1) + "'"

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
     //MsgAlert("ERROR AL ACTUALIZAR D3_NUMSEQ EN TM 008")
     aviso("ERROR AL ACTUALIZAR D3_CUSTO2 CUANDO ES 0 ",StrSql,{'ok'},,,,,.t.)
     return .F.
 EndIf

Return .T.

User Function ACTCUSMEC() //Actualiza Costo de Mecánicos
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SD3')+ " SET D3_CUSTO1 = D3_QUANT* (SELECT (SELECT ISNULL(SUM(CQ7_DEBITO),0)-ISNULL(SUM(CQ7_CREDIT),0) FROM CQ7010 CQ7, SB1010 SB1 "
StrSql+="   WHERE CQ7.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_CLVL = CQ7_CLVL AND CQ7_DATA BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'" + "AND B1_COD = D3_COD "
StrSql+="   AND B1_COD = D3_COD AND B1_TIPO = 'MO' AND CQ7_TPSALD = '1' AND CQ7_MOEDA = '01' AND CQ7_CONTA IN(SELECT CT1_CONTA FROM CT1010 c WHERE D_E_L_E_T_ = ' ' AND CT1_GRUPO LIKE 'MAOBRA'))"
StrSql+="  / SUM(D3_QUANT) FROM SD3010 SD3 WHERE D_E_L_E_T_ = ' ' AND D3_COD = SD3010.D3_COD AND D3_ESTORNO <> 'S' AND D3_CF LIKE 'RE%' AND D3_QUANT <> 0 AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'" + "GROUP BY D3_COD),"
StrSql+=" D3_CUSTO2 = D3_QUANT*(SELECT (SELECT ISNULL(SUM(CQ7_DEBITO),0)-ISNULL(SUM(CQ7_CREDIT),0) FROM CQ7010 CQ7, SB1010 SB1 "
StrSql+="    WHERE CQ7.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_CLVL = CQ7_CLVL AND CQ7_DATA BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'" + " AND B1_COD = D3_COD "
StrSql+="    AND B1_COD = D3_COD AND B1_TIPO = 'MO' AND CQ7_TPSALD = '1' AND CQ7_MOEDA = '02' AND CQ7_CONTA IN(SELECT CT1_CONTA FROM CT1010 c WHERE D_E_L_E_T_ = ' ' AND CT1_GRUPO LIKE 'MAOBRA')) "
StrSql+="  / SUM(D3_QUANT) FROM SD3010 SD3 WHERE D_E_L_E_T_ = ' ' AND D3_COD = SD3010.D3_COD AND D3_ESTORNO <> 'S' AND D3_CF LIKE 'RE%' AND D3_QUANT <> 0 AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'" + "GROUP BY D3_COD),"
StrSql+=" D3_CF = 'RE6' "
StrSql+=" WHERE D3_COD IN(SELECT B1_COD FROM SB1010 WHERE D_E_L_E_T_ = ' ' AND B1_CLVL <> ' ' AND B1_TIPO = 'MO') "
StrSql+=" AND D3_CF LIKE 'RE%' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = ' ' "
StrSql+=" AND D3_QUANT <> 0 AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'"

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
     //MsgAlert("ERROR AL ACTUALIZAR SD3 Costo de Equipo por Clase de Valor")
     aviso("ERROR AL ACTUALIZAR Costo de Mecánicos ",StrSql,{'ok'},,,,,.t.)
     return .F.
 EndIf

 If __CUSERID = '000000' .OR. cUserName = 'nterrazas'
	aviso("QUERY PARA ACTUALIZAR Costo de Mecánicos ",StrSql,{'ok'},,,,,.t.)
 EndIf
Return .T.


User Function ACTCUSEQ() //Actualiza Costo de Equipo por Clase de Valor
Local StrSql:=""

StrSql:=" UPDATE " + RETSQLNAME('SD3')+ " SET D3_CUSTO1 = D3_QUANT* (SELECT ISNULL(CASE WHEN MAX(CODMOEVALOR) IN('US$', 'USD' ) THEN MAX(M2_MOEDA2) ELSE 1 END * MAX(MISM.VALOR), D3_CUSTO2/D3_QUANT) "
StrSql+="		FROM SM2010 M2, SB1010 B1, SN3010 N3, ST9010 T9, IPATRIMONIO I "
StrSql+="		JOIN MISMBEM ON MISMBEM.CODCOLIGADA = MISMBEM.CODCOLIGADA AND MISMBEM.CODBEM = SUBSTRING(I.CODPATRIMONIO,1,4) "
StrSql+="		JOIN MISM ON I.CODCOLIGADA = MISM.CODCOLIGADA AND MISM.IDPRJ = MISMBEM.IDPRJ AND MISM.IDISM = MISMBEM.IDISM "
StrSql+="		JOIN MPRJ M ON MISM.IDPRJ = M.IDPRJ JOIN MISMPRC P ON MISM.IDPRJ = P.IDPRJ AND MISM.IDISM = P.IDISM AND P.PRECOATIVO = 1 "
StrSql+="		WHERE B1.D_E_L_E_T_ = ' ' AND B1_COD = D3_COD AND N3.D_E_L_E_T_ = ' ' AND N3_CLVL = B1_CLVL AND T9.D_E_L_E_T_ = ' ' AND SUBSTRING(T9_CODIMOB, 1, 10) = N3_CBASE "
StrSql+="		AND M2.D_E_L_E_T_ = ' ' AND M2_DATA = D3_EMISSAO AND T9.T9_CODBEM COLLATE LATIN1_GENERAL_CS_AI = I.PATRIMONIO "
StrSql+="		AND D3_CC COLLATE LATIN1_GENERAL_CS_AI = M.CODCCUSTO AND D3_COD = B1_COD ), "
StrSql+="	D3_CUSTO2 = D3_QUANT*(SELECT ISNULL(MAX(MISM.VALOR) / CASE WHEN MAX(CODMOEVALOR) NOT IN('US$', 'USD' ) THEN MAX(M2_MOEDA2) ELSE 1 END, D3_CUSTO1/D3_QUANT) "
StrSql+="		FROM SM2010 M2, SB1010 B1, SN3010 N3, ST9010 T9, IPATRIMONIO I "
StrSql+="		JOIN MISMBEM ON MISMBEM.CODCOLIGADA = MISMBEM.CODCOLIGADA AND MISMBEM.CODBEM = SUBSTRING(I.CODPATRIMONIO,1,4) "
StrSql+="		JOIN MISM ON I.CODCOLIGADA = MISM.CODCOLIGADA AND MISM.IDPRJ = MISMBEM.IDPRJ AND MISM.IDISM = MISMBEM.IDISM "
StrSql+="		JOIN MPRJ M ON MISM.IDPRJ = M.IDPRJ JOIN MISMPRC P ON MISM.IDPRJ = P.IDPRJ AND MISM.IDISM = P.IDISM AND P.PRECOATIVO = 1 "
StrSql+="		WHERE B1.D_E_L_E_T_ = ' ' AND B1_COD = D3_COD AND N3.D_E_L_E_T_ = ' ' AND N3_CLVL = B1_CLVL "
StrSql+="		AND T9.D_E_L_E_T_ = ' ' AND SUBSTRING(T9_CODIMOB, 1, 10) = N3_CBASE AND M2.D_E_L_E_T_ = ' ' AND M2_DATA = D3_EMISSAO "
StrSql+="		AND T9.T9_CODBEM COLLATE LATIN1_GENERAL_CS_AI = I.PATRIMONIO AND D3_CC COLLATE LATIN1_GENERAL_CS_AI = M.CODCCUSTO "
StrSql+="		AND D3_COD = B1_COD), D3_CF = 'RE6' "
StrSql+=" WHERE D3_COD IN(SELECT B1_COD FROM SB1010 WHERE D_E_L_E_T_ = ' ' AND B1_CLVL <> ' ' AND B1_TIPO = 'MO') "
StrSql+=" AND D3_CF LIKE 'RE%' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = ' ' "
StrSql+=" AND D3_QUANT <> 0 AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'"

/*
StrSql:=" UPDATE " + RETSQLNAME('SD3')+ " SET D3_CUSTO1 = D3_QUANT* (SELECT (SELECT ISNULL(SUM(CQ7_DEBITO),0)-ISNULL(SUM(CQ7_CREDIT),0) FROM CQ7010 CQ7, SB1010 SB1 "
StrSql+="   WHERE CQ7.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_CLVL = CQ7_CLVL AND CQ7_DATA BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'" + "AND B1_COD = D3_COD "
StrSql+="   AND B1_COD = D3_COD AND B1_TIPO = 'MO' AND CQ7_TPSALD = '1' AND CQ7_MOEDA = '01' AND CQ7_CONTA IN(SELECT CT1_CONTA FROM CT1010 c WHERE D_E_L_E_T_ = ' ' AND CT1_GRUPO LIKE 'MAOBRA'))"
StrSql+="  / SUM(D3_QUANT) FROM SD3010 SD3 WHERE D_E_L_E_T_ = ' ' AND D3_COD = SD3010.D3_COD AND D3_ESTORNO <> 'S' AND D3_CF LIKE 'RE%' AND D3_QUANT <> 0 AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'" + "GROUP BY D3_COD),"
StrSql+=" D3_CUSTO2 = D3_QUANT*(SELECT (SELECT ISNULL(SUM(CQ7_DEBITO),0)-ISNULL(SUM(CQ7_CREDIT),0) FROM CQ7010 CQ7, SB1010 SB1 "
StrSql+="    WHERE CQ7.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND SB1.B1_CLVL = CQ7_CLVL AND CQ7_DATA BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'" + " AND B1_COD = D3_COD "
StrSql+="    AND B1_COD = D3_COD AND B1_TIPO = 'MO' AND CQ7_TPSALD = '1' AND CQ7_MOEDA = '02' AND CQ7_CONTA IN(SELECT CT1_CONTA FROM CT1010 c WHERE D_E_L_E_T_ = ' ' AND CT1_GRUPO LIKE 'MAOBRA')) "
StrSql+="  / SUM(D3_QUANT) FROM SD3010 SD3 WHERE D_E_L_E_T_ = ' ' AND D3_COD = SD3010.D3_COD AND D3_ESTORNO <> 'S' AND D3_CF LIKE 'RE%' AND D3_QUANT <> 0 AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'" + "GROUP BY D3_COD),"
StrSql+=" D3_CF = 'RE6' "
StrSql+=" WHERE D3_COD IN(SELECT B1_COD FROM SB1010 WHERE D_E_L_E_T_ = ' ' AND B1_CLVL <> ' ' AND B1_TIPO = 'MO') "
StrSql+=" AND D3_CF LIKE 'RE%' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = ' ' "
StrSql+=" AND D3_QUANT <> 0 AND D3_EMISSAO BETWEEN '" + DTOS(GetMv("MV_ULMES")+1) + "' AND '" + DTOS(mv_par01) + "'"
*/

 If tcSQLexec(StrSql) < 0   //para verificar si el query funciona
     //MsgAlert("ERROR AL ACTUALIZAR SD3 Costo de Equipo por Clase de Valor")
     aviso("ERROR AL ACTUALIZAR Costo de Equipo desde TCOP ",StrSql,{'ok'},,,,,.t.)
     return .F.
 EndIf

 If __CUSERID = '000000' .OR. cUserName = 'nterrazas'
	aviso("QUERY PARA ACTUALIZAR Costo de Equipo desde TCOP ",StrSql,{'ok'},,,,,.t.)
 EndIf
Return .T.
