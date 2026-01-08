#Include "Rwmake.ch"
#Include "TOPCONN.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VlrCompOP   ºAutor  ³EDUAR ANDIA    	 ºFecha ³  28/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Función -Retorna el valor compensado en una Orden de Pago	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Teledifusora\Argentina                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VlrCompOP
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local lBanco 	:= .F.
Local nVlrComp 	:= 0

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SEK") + " SEK"
cQuery += " WHERE EK_FILIAL = '" + xFilial("SEK") +"'"
cQuery += " AND EK_ORDPAGO = '" + SEK->EK_ORDPAGO + "'"
cQuery += " AND SEK.D_E_L_E_T_<> '*'"
cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0  //En uso
	StrSQL->(DbCloseArea())
Endif
dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")

While StrSQL->(!Eof())		
	If !Empty(StrSQL->(EK_BANCO))				//Compensación sin salida de banco
		lBanco := .T.				
	Endif	
	If  AllTrim(StrSQL->(EK_TIPO)) $ "PA|NCP" 	//Compensación de anticipo
		nVlrComp := nVlrComp + StrSQL->(EK_VLMOED1)				
	Endif
	
	StrSQL->(DbSkip())
EndDo

RestArea(aArea)
Return(nVlrComp)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³lCompBco   ºAutor  ³EDUAR ANDIA    	 ºFecha ³  28/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Función -Verifica si en una Orden de Pago existe 			  º±±
±±º          ³         Compensación + Salida de Banco (Combinado)         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Teledifusora\Argentina                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function lCompBco
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local lBanco 	:= .F.
Local nVlrComp 	:= 0
Local lRet		:= .F.	//Es compensación + Pago (Banco)

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SEK") + " SEK"
cQuery += " WHERE EK_FILIAL = '" + xFilial("SEK") +"'"
cQuery += " AND EK_ORDPAGO = '" + SEK->EK_ORDPAGO + "'"
cQuery += " AND SEK.D_E_L_E_T_<> '*'"
cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0  //En uso
	StrSQL->(DbCloseArea())
Endif
dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")

While StrSQL->(!Eof())		
	If !Empty(StrSQL->(EK_BANCO))	//Compensación sin salida de banco
		lBanco := .T.				
	Endif
	
	//Compensación de anticipo
	If AllTrim(StrSQL->(EK_TIPO)) $ "PA|NCP" .AND. !(StrSQL->(EK_TIPODOC)$'PA')	
		nVlrComp := nVlrComp + StrSQL->(EK_VLMOED1)				
	Endif
	
	StrSQL->(DbSkip())
EndDo

lRet := lBanco .And. nVlrComp > 0
RestArea(aArea)

Return(lRet)
