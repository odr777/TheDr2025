User Function OM200QRY()
Local cQuery     := PARAMIXB[1] //ARRAY DE CAMPOS
Local aArrayTipo := PARAMIXB[2] 
Local aArrayMod := PARAMIXB[3] 
Local cTipo      := ""
Local nX         := 0//-- Carrega String com tipos de cargas selecionados pelo usuário.
For nX := 1 To Len(aArrayTipo)	
	If aArrayTipo[nX,1]		
		cTipo += aArrayTipo[nX,2]+"/"	
	EndIf
Next nX

// 

//  Local cString := "To compute, or not to compute?"
//  cQuery:=  StrTran( cQuery, "SELECT SC9.R_E_C_N_O_", "SELECT SC9.C9_LOCAL , SC9.R_E_C_N_O_" ) // NAHIM 2019/08/15
//MsgAlert(cTipo)
//-- processo especifico...
//cQuery := "AND C5_CONDPAG <> '002'"
//cQuery += "AND C5_CONDPAG NOT IN(SELECT E4_CODIGO FROM SE4010 WHERE E4_TIPO = '1' AND E4_COND IN('0', '00'))"


//AND SA1.D_E_L_E_T_ = ' ' 
//cQuery +=

// Nahim descomentar para tomar en cuenta el código de segmento
cQuery := StrTran( cQuery, "AND SA1.D_E_L_E_T_  = ' '", "AND SA1.D_E_L_E_T_  = ' ' AND SA1.A1_CODSEG >= '" + MV_PAR23 + "' AND SA1.A1_CODSEG <= '" + MV_PAR24 + "'" ) // NAHIM 2019/08/15

cQuery += "AND C6_BLOQUEI NOT IN ('01')"
cQuery += "AND (C5_CONDPAG NOT IN(SELECT E4_CODIGO FROM SE4010 WHERE E4_TIPO = '1' AND E4_COND IN('0', '00'))"
//cQuery += "OR C5_USTATUS = '1') " // NTP 18/04/2019
cQuery += "OR (C5_USTATUS = '1' OR C5_DOCGER = 2)) " // NTP 20/08/2019



//Aviso("",cQuery,{"Ok"},,,,,.T.)
//cQuery += "OR C5_FILIAL+C5_NUM+C5_CLIENTE IN (SELECT EL_FILIAL+EL_UPV+EL_CLIORIG FROM SEL010 WHERE D_E_L_E_T_ = ' ' AND EL_TIPO <> 'CH' AND EL_CANCEL = 'F' AND EL_UPV <> ' ') "
//cQuery += "OR C5_FILIAL+C5_NUM+C5_CLIENTE IN (SELECT EL_FILIAL+EL_UPV+EL_CLIORIG FROM SEL010 WHERE D_E_L_E_T_ = ' ' AND EL_TIPO = 'CH' AND EL_CANCEL = 'F' AND EL_UPV <> ' ' AND EL_FILIAL+EL_NUMERO+EL_CLIORIG IN(SELECT E1_FILIAL+E1_NUM+E1_CLIENTE FROM SE1010 WHERE D_E_L_E_T_ = ' ' AND E1_TIPO = 'CH' AND E1_SALDO = 0 AND E1_STATUS = 'B'))"
//cQuery += "OR C5_FILIAL+C5_NUM+C5_CLIENTE IN (SELECT C5_FILIAL+C5_NUM+C5_CLIENTE FROM SC5010 WHERE (C5_FILIAL+C5_UPVFUT+C5_CLIENTE) IN (SELECT EL_FILIAL+EL_UPV+EL_CLIORIG FROM SEL010 WHERE D_E_L_E_T_ = ' ' AND EL_TIPO <> 'CH' AND EL_CANCEL = 'F' AND EL_UPV <> ' '))"
//cQuery += "OR C5_FILIAL+C5_NUM+C5_CLIENTE IN (SELECT C5_FILIAL+C5_NUM+C5_CLIENTE FROM SC5010 WHERE (C5_FILIAL+C5_UPVFUT+C5_CLIENTE) IN (SELECT EL_FILIAL+EL_UPV+EL_CLIORIG FROM SEL010 WHERE D_E_L_E_T_ = ' ' AND EL_TIPO = 'CH' AND EL_CANCEL = 'F' AND EL_UPV <> ' ' AND EL_FILIAL+EL_NUMERO+EL_CLIORIG IN(SELECT E1_FILIAL+E1_NUM+E1_CLIENTE FROM SE1010 WHERE D_E_L_E_T_ = ' ' AND E1_TIPO = 'CH' AND E1_SALDO = 0 AND E1_STATUS = 'B'))))"

//RetSqlName('SE4')+" SE4, "

// ("",cQuery,{"Ok"},,,,,.T.)

Return cQuery
