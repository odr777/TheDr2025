#INCLUDE "RWMAKE.CH"
#Include "Protheus.ch"
#Include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³ CT105SBLOTE   ºAuthor ³EDUAR ANDIA    º Date ³  09/07/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para alterar o sub lote de um lançamento contábil de    º±±
±±º          ³ integração antes da sua gravação. 			  			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ Bolivia \Unión Agronegocios S.A.                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT105SBLOTE
Local cSbLoteExec 	:= PARAMIXB[1]	//No lo Carga
Local __cLp			:= CT5->CT5_LANPAD

If Empty(__cLp)
	__cLp := CTK->CTK_LP
Endif

If !Empty(__cLp)
	
	Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Factura de Entrada					³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case (__cLp =="650" .OR. __cLp =="655" .OR. __cLp =="656")
		If AllTrim(SF1->F1_ESPECIE) $ "NF"
			If !Empty(SF1->F1_HAWB) .OR. SF1->F1_TIPODOC $ "13|14"
				cSbLoteExec := "IMP"
			Else
				cCaixa 	:= ObtCCH(__cLp)
				If !Empty(cCaixa)
					cSbLoteExec := "CCH"
				Else
					If IsFacServ()
						cSbLoteExec := "GOP"
					Else
						//Respeta config. CT5_SBLOTE
						//(Compras Locales)
					Endif
				Endif
			Endif
		Endif
		
		If AllTrim(SF1->F1_ESPECIE) $ "NDP"
			cSbLoteExec := "NDP"
		Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Factura de Salida					³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case (__cLp =="610" .OR. __cLp =="630")
		If AllTrim(SF2->F2_ESPECIE) $ "NCP"
			cSbLoteExec := "NCP"
		Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ITF	(RECIBOS /PAGOS)				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case (__cLp =="56A")
		If AllTrim(SE5->E5_ORIGEM) $ "FINA087A"
			cSbLoteExec := "COB"
		Endif
				
		If AllTrim(SE5->E5_ORIGEM) $ "FINA085A"
			cSbLoteExec := "PAG"
		Endif	
	
	OtherWise
		//Respeta config. CT5_SBLOTE
	EndCase

Endif
Return (cSbLoteExec)


//+---------------------------------------------+
//|Es compra de Servicios?						|
//+---------------------------------------------+
Static Function IsFacServ
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local lRet 		:= .F.

If SF1->(Deleted())	
	cQuery := "SELECT * "
	cQuery += " FROM " + RetSqlName("SD1") + " SD1"
	cQuery += " WHERE D1_FILIAL = '"+ xFilial("SD1") 	+ "'"
	cQuery += " AND D1_DOC = '" 	+ SF1->F1_DOC 		+ "'"
	cQuery += " AND D1_SERIE = '" 	+ SF1->F1_SERIE 	+ "'"
	cQuery += " AND D1_FORNECE = '" + SF1->F1_FORNECE 	+ "'"
	cQuery += " AND D1_LOJA = '" 	+ SF1->F1_LOJA 		+ "'"
	cQuery += " AND SD1.D_E_L_E_T_= '*'"
	cQuery := ChangeQuery(cQuery)
	
	If Select("StrSQL") > 0
		StrSQL->(DbCloseArea())
	Endif
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
	dbSelectArea("StrSQL")	
	While StrSQL->(!Eof()) .AND. StrSQL->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+StrSQL->(D1_TES)))
		If SF4->F4_ESTOQUE=="N"	//Servicios
			lRet := .T.
		Else
			lRet := .F.
			Exit
		Endif
		StrSQL->(DbSkip())
	EndDo
	StrSQL->(DbCloseArea())
Else
	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))
	If SD1->(DbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		While SD1->(!Eof()) .AND. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4")+SD1->D1_TES))
			If SF4->F4_ESTOQUE=="N"	//Servicios
				lRet := .T.
			Else
				lRet := .F.
				Exit
			Endif
			SD1->(DbSkip())
		EndDo
	Endif
Endif
RestArea(aArea)
Return(lRet)


Static Function ObtCCH(xcLp)
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local cCaixha 	:= ""
Default xcLp  	:= ""

If SF1->(Deleted())
	
	cQuery := "SELECT * "
	cQuery += " FROM " + RetSqlName("SEU") + " SEU"
	cQuery += " WHERE EU_FILIAL = '"+ xFilial("SEU") 	+ "'"
	cQuery += " AND EU_NRCOMP = '" 	+ SF1->F1_DOC 		+ "'"
	cQuery += " AND EU_SERCOMP = '" + SF1->F1_SERIE 	+ "'"
	cQuery += " AND EU_FORNECE = '" + SF1->F1_FORNECE 	+ "'"
	cQuery += " AND EU_LOJA = '" 	+ SF1->F1_LOJA 		+ "'"
	cQuery += " AND SEU.D_E_L_E_T_= '*'"
	cQuery := ChangeQuery(cQuery)
	
	If Select("StrSQL") > 0
		StrSQL->(DbCloseArea())
	Endif
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
	dbSelectArea("StrSQL")
	
	If StrSQL->(!Eof())
		cCaixha := StrSQL->(EU_CAIXA)
	EndIf
Else
	cCaixha := POSICIONE("SEU",7,xFilial("SF1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,"EU_CAIXA")
Endif

RestArea(aArea)
Return(cCaixha)