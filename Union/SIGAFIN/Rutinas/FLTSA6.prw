#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TOPCONN.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FltSA6    ºAutor  ³EDUAR ANDIA       	 º Data ³  22/04/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtro en la Consulta Estándar SA6                      	  º±±
±±º          ³ 				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia\ Unión Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FltSA6
Local cCodUsr	:= RetCodUsr()
Local lRet		:= .T.
Local lTemFlt	:= .F.

If GetNewPar("MV_XFLTSA6",.T.)
	lTemFlt := xTemFlt(cCodUsr)
	
	If lTemFlt
		lRet := AllTrim(SA6->A6_UCUSR)== cCodUsr
	Endif
Endif
Return(lRet)


Static Function xTemFlt(cCodUsr)
Local aArea		:= GetArea()
Local cQuery	:= ""
Local lRet		:= .F.
Default cCodUsr	:= ""

If SA6->(FieldPos("A6_UCUSR")) > 0
	cQuery := " SELECT A6_COD "
	cQuery += " FROM " + RetSqlName("SA6") + " SA6"	
	cQuery += " WHERE  A6_FILIAL = '" + cFilAnt + "'"
	cQuery += " 	AND A6_UCUSR = '" + cCodUsr + "'"
	cQuery += " 	AND SA6.D_E_L_E_T_ <> '*'"
	cQuery := ChangeQuery(cQuery)
	
	If Select("StrSQL") > 0
		StrSQL->(DbCloseArea())
	Endif
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
	dbSelectArea("StrSQL")
	
	If StrSQL->(!Eof())
		lRet := .T.
	Endif
	StrSQL->(DbCloseArea())
Endif

RestArea(aArea)
Return(lRet)
