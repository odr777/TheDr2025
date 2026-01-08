#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³GetCodigo  ºAuthor ³TdePº Date ³  28/02/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa que Genera el Código del Producto, en base al     º±±
±±º          ³ Codigo del Tipo y Codigo del Grupo de Productos			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ MP11BIB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GetCodProd()
Local _cQuery 
Local _cCodigo :=""
Local _cPrefijo := "" // modificado FCM 18/12/18
// Local _cPrefijo := SUBSTR(AllTrim(M->B1_TIPO) + AllTrim(M->B1_GRUPO),1,4) // modificado NTP 07/08/18
//Local _cPrefijo := SUBSTR(AllTrim(M->B1_GRUPO),1,4)

If LEN(M->B1_TIPO)=2 .AND. LEN(M->B1_GRUPO)=4 .AND. INCLUI   //  modificado - FCM 18/12/18
//If !Empty(M->B1_TIPO) .AND. !Empty(M->B1_GRUPO) .AND. INCLUI     modificado - NTP 07/08/18
//If !Empty(M->B1_GRUPO) .AND. INCLUI
        _cPrefijo := AllTrim(M->B1_TIPO) + AllTrim(M->B1_GRUPO) // modificado FCM 18/12/18

		
		_cQuery := " SELECT TOP 1 B1_COD "
		_cQuery += " From " + RetSqlName("SB1") 
		_cQuery += " Where B1_FILIAL = '" + xFilial("SB1")+ "' "
		_cQuery += " And B1_TIPO = '" + M->B1_TIPO + "' "         	   
//		_cQuery += " And LEFT(B1_GRUPO,2) = '" + SUBSTR(M->B1_GRUPO,1,2) + "' "  modificado NTP 07/08/18 - 
		_cQuery += " And LEFT(B1_GRUPO,4) = '" + SUBSTR(M->B1_GRUPO,1,4) + "' " 
		_cQuery += " And LEFT(B1_COD,6) = '" +_cPrefijo +"' "
	   	_cQuery += " And D_E_L_E_T_ <> '*' "
		_cQuery += " ORDER BY B1_COD DESC "
		
		//Aviso("",_cQuery,{'ok'},,,,,.t.)		
		
		If Select("StrSQL") > 0  //En uso
		   StrSQL->(DbCloseArea())
		End
		
		TcQuery _cQuery New Alias "StrSQL"
		
  		//Obtiene el valor Numérico del Ultimo Código
  		//_cNumero := substr(AllTrim(StrSQL->B1_COD),4,Len(AllTrim(StrSQL->B1_COD)))
  		_cNumero := right(AllTrim(StrSQL->B1_COD),4)
		
		//Suma uno al Valor numérico y luego Concatena con el Código del Grupo		
		_cCodigo:= _cPrefijo + soma1(_cNumero)
		
		//if Empty(_cCodigo) 
		If AllTrim(_cCodigo) == _cPrefijo 
			_cCodigo:= _cPrefijo + '0001'
		EndIf
ElseiF Altera
		_cCodigo:= SB1->B1_COD
End If	


Return _cCodigo
