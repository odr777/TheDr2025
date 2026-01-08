
#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³GetNumRem  ºAuthor ³Jose Carlos Taborga  º Date ³  19/04/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para Generar Correlativo para los Remitos de      º±±
±±º          ³ Entrada sin saltar numeración				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ TdeP                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetNumRem(cSerie)
Local _cQuery 
Local _cCodigo :=""

if  INCLUI 
		
		_cQuery := " SELECT MAX(F1_UCORREL) F1_UCORREL"
		_cQuery += " From " + RetSqlName("SF1") 
		_cQuery += " Where F1_FILIAL = '" + xFilial("SF1")+ "' "
		_cQuery += " AND F1_ESPECIE = 'RCN'"
		_cQuery += " AND D_E_L_E_T_ = ' '"
		_cQuery += " And UPPER(F1_SERIE)= UPPER('" + cSerie + "')"
		
//		_cQuery += " And UPPER(F1_SERIE)= UPPER('" +  GetNewPar("MV_USEREM", "REM") + "')"
//		_cQuery += " ORDER BY F1_UCORREL DESC"
		
		If Select("StrSQL") > 0  //En uso
		   StrSQL->(DbCloseArea())
		End   
		TcQuery _cQuery New Alias "StrSQL"
		
		//Suma uno al Valor numérico y luego Concatena con el Código del Grupo
		If Empty(StrSQL->F1_UCORREL)
//			alert("tamaño: " + cvaltochar(TAMSX3("F1_UCORREL")[1]))
			_cCodigo := STRZERO(1, TAMSX3("F1_UCORREL")[1], 0)
		else                              
			_cCodigo:=soma1(StrSQL->F1_UCORREL)		
		End

End If	
Return _cCodigo
