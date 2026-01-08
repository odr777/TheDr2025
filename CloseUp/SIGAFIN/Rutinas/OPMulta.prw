#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OPMULTA   ºAutor  ³EDUAR ANDIA         º Data ³  26/07/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Función que Busca el valor de Multa en SE5                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Gama\Colombia                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OPMulta(cRev)
Local aArea 	:= GetArea()
Local cQuery 	:= ""
Local nMulta 	:= 0
Default cRev	:= ""

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " SE5"   				
cQuery += " WHERE E5_TIPODOC = 'MT'"
cQuery += " AND E5_PREFIXO = '" + SEK->EK_PREFIXO 	+ "'"
cQuery += " AND E5_NUMERO = '" 	+ SEK->EK_NUM 		+ "'"
cQuery += " AND E5_TIPO = '" 	+ SEK->EK_TIPO 		+ "'"
/*
cQuery += " AND E5_CLIFOR = '" 	+ SEK->EK_FORNEPG 	+ "'"
cQuery += " AND E5_LOJA = '" 	+ SEK->EK_LOJAPG 	+ "'"
*/
cQuery += " AND E5_CLIFOR = '" 	+ SEK->EK_FORNECE 	+ "'"
cQuery += " AND E5_LOJA = '" 	+ SEK->EK_LOJA 		+ "'"
cQuery += " AND SUBSTRING(E5_DOCUMEN,1,6) = '" + SEK->EK_ORDPAGO + "'"

If Empty(cRev)
	cQuery += " AND SE5.D_E_L_E_T_<> '*'"
Endif

cQuery := ChangeQuery(cQuery)
				
If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
End

dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
//MemoWrite("SecTitPag.sql",cQuery)  	 
DbSelectArea("StrSQL")
DbGoTop()

If StrSQL->(!Eof())
	If StrSQL->(E5_VALOR) > 0
		nMulta := StrSQL->(E5_VALOR)
	Endif
Endif
				
StrSQL->(dbCloseArea())
RestArea(aArea)
Return(nMulta)


//+------------------------------------------------------------------------+
//|Funcion para Obtener el Valor (INTERES) de la O.P.			     	   |
//+------------------------------------------------------------------------+
User Function OPInteres(cRev)
Local aArea 	:= GetArea()
Local cQuery 	:= ""
Local nInteres 	:= 0
Default cRev	:= ""

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " SE5"   				
cQuery += " WHERE E5_TIPODOC = 'JR'"
cQuery += " AND E5_PREFIXO = '" + SEK->EK_PREFIXO 	+ "'"
cQuery += " AND E5_NUMERO = '" 	+ SEK->EK_NUM 		+ "'"
cQuery += " AND E5_TIPO = '" 	+ SEK->EK_TIPO 		+ "'"
cQuery += " AND E5_CLIFOR = '" 	+ SEK->EK_FORNEPG 	+ "'"
cQuery += " AND E5_LOJA = '" 	+ SEK->EK_LOJAPG 	+ "'"
cQuery += " AND SUBSTRING(E5_DOCUMEN,1,6) = '" + SEK->EK_ORDPAGO + "'"

If Empty(cRev)
	cQuery += " AND SE5.D_E_L_E_T_<> '*'"
Endif
cQuery := ChangeQuery(cQuery)
				
If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
End

dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
DbSelectArea("StrSQL")
DbGoTop()

If StrSQL->(!Eof())
	If StrSQL->(E5_VALOR) > 0
		nInteres := StrSQL->(E5_VALOR)
	Endif
Endif
				
StrSQL->(dbCloseArea())
RestArea(aArea)
Return(nInteres)

//+------------------------------------------------------------------------+
//|Funcion para Obtener el Valor (DESCUENTO) de la O.P.			     	   |
//+------------------------------------------------------------------------+
User Function OPDescto(cRev)
Local aArea 	:= GetArea()
Local cQuery 	:= ""
Local nDescto 	:= 0
Default cRev	:= ""

If !Empty(cRev)
	/*
	DbSelectArea("SEK")
	SEK->(DbSetOrder(1))
	If SEK->(DbSeek(xFilial("SEK")+SE5->E5_ORDREC))
			
	Endif
	*/
Endif

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " SE5"   				
cQuery += " WHERE E5_TIPODOC = 'DC'"
cQuery += " AND E5_PREFIXO = '" + SEK->EK_PREFIXO 	+ "'"
cQuery += " AND E5_NUMERO = '" 	+ SEK->EK_NUM 		+ "'"
cQuery += " AND E5_TIPO = '" 	+ SEK->EK_TIPO 		+ "'"
cQuery += " AND E5_CLIFOR = '" 	+ SEK->EK_FORNEPG 	+ "'"
cQuery += " AND E5_LOJA = '" 	+ SEK->EK_LOJAPG 	+ "'"
cQuery += " AND E5_ORDREC = '"  + SEK->EK_ORDPAGO   + "'"

If Empty(cRev)
	cQuery += " AND SE5.D_E_L_E_T_<> '*'"
Endif
cQuery := ChangeQuery(cQuery)
				
If Select("StrSQL") > 0  //En uso
   StrSQL->(DbCloseArea())
End

dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
DbSelectArea("StrSQL")
DbGoTop()

If StrSQL->(!Eof())
	If StrSQL->(E5_VALOR) > 0
		nDescto := StrSQL->(E5_VALOR)
	Endif
Endif
				
StrSQL->(dbCloseArea())
RestArea(aArea)
Return(nDescto)
