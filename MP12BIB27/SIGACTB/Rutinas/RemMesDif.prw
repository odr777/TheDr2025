#Include "Rwmake.ch"
#Include "TOPCONN.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RemMesDif   ºAutor  ³EDUAR ANDIA    	 ºFecha ³  03/06/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Función -Verifica si Remito a Facturar es de mes anterior	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia /ECCI                                         	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RemMesDif
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local nMesRem 	:= 0
Local nMesFat	:= 0
Local lRet		:= .F.

If AllTrim(SD1->D1_ESPECIE) =="NF" .AND. !Empty(SD1->D1_REMITO)
	cQuery := "SELECT * "
	cQuery += " FROM " + RetSqlName("SD1") + " SD1"
	cQuery += " WHERE D1_FILIAL = '" + xFilial("SD1") +"'"
	cQuery += " AND D1_DOC = '" + SD1->D1_REMITO + "'"
	cQuery += " AND D1_SERIE = '" + SD1->D1_SERIREM+ "'"
	cQuery += " AND D1_FORNECE = '" + SD1->D1_FORNECE + "'"
	cQuery += " AND D1_LOJA = '" + SD1->D1_LOJA + "'"
	cQuery += " AND D1_ESPECIE = 'RCN'"
	cQuery += " AND SD1.D_E_L_E_T_ <> '*'"

	cQuery := ChangeQuery(cQuery)

	If Select("StrSQL") > 0
		StrSQL->(DbCloseArea())
	Endif
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
	dbSelectArea("StrSQL")

	If StrSQL->(!Eof())
		nMesRem := Month ( STOD(StrSQL->(D1_DTDIGIT)) )
		nMesFat := Month ( SD1->D1_DTDIGIT )
		lRet 	:= (nMesRem <>	nMesFat	)		//São Diferentes?
	Endif
	StrSQL->(DbCloseArea())
Endif

RestArea(aArea)
Return(lRet)
