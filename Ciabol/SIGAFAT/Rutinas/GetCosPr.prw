#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³GetCodigo  ºAuthor ³TdePº Date ³  21/11/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa que devuelve el costo del producto                º±±
±±º          ³ 			  												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP11BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetCosPro()
Local _cQuery 
Local _cCodigo :=""
Local _nCosVal := 0

	_cQuery := " SELECT TOP 1 B2_CM1 "
	_cQuery += " From " + RetSqlName("SB2") 
	_cQuery += " Where B2_FILIAL = '" + xFilial("SB2")+ "' "
	_cQuery += " And B2_COD = '" + M->DA1_CODPRO +"' "
   	_cQuery += " And D_E_L_E_T_ <> '*' "
	_cQuery += " ORDER BY B2_CM1 DESC "
		
		//Aviso("",_cQuery,{'ok'},,,,,.t.)		
		
		If Select("StrSQL") > 0  //En uso
		   StrSQL->(DbCloseArea())
		End
		
		TcQuery _cQuery New Alias "StrSQL"
		
  		//Obtiene el valor Numérico del Ultimo Código
  		_nCosVal := StrSQL->B2_CM1
// 		_cNumero := substr(AllTrim(StrSQL->B1_COD),5,Len(AllTrim(StrSQL->B1_COD)))
		
		//Suma uno al Valor numérico y luego Concatena con el Código del Grupo		
//		_cCodigo:= _cPrefijo + soma1(_cNumero)
		
		//if Empty(_cCodigo) 
		If _nCosVal <= 0 
			_nCosVal := 999999
		EndIf

Return _nCosVal
