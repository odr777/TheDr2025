#Include "Rwmake.ch"
#Include "TOPCONN.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VlrCompRC   ºAutor  ³EDUAR ANDIA    	 ºFecha ³  08/06/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Función -Retorna el valor compensado en un Cobro Diverso	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ NIPPONFLEX/Bolivia                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VlrCompRC
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local nVlrComp 	:= 0

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SEL") + " SEL"
cQuery += " WHERE EL_FILIAL = '" + xFilial("SEL") +"'"
cQuery += " AND EL_RECIBO = '" + SEL->EL_RECIBO + "'"
cQuery += " AND EL_SERIE = '" + SEL->EL_SERIE + "'"
cQuery += " AND SEL.D_E_L_E_T_<> '*'"
cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0
	StrSQL->(DbCloseArea())
Endif
dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")

While StrSQL->(!Eof())
	If  AllTrim(StrSQL->(EL_TIPO)) $ "RA|NCC" .AND.	StrSQL->(EL_TIPODOC)$"TB"
		nVlrComp := nVlrComp + StrSQL->(EL_VLMOED1)				
	Endif
	
	StrSQL->(DbSkip())
EndDo

RestArea(aArea)
Return(nVlrComp)
