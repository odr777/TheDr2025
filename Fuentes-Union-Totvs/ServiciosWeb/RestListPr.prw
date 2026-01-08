#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#Include "aarray.ch"
#Include "json.ch"
#INCLUDE "RESTFUL.CH"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ RESTPEDVEN ³ Autor ³ POST Denar Terrazas					  ³±±
±±      						 GET Erick Etcheverry ³ Data ³ 26/07/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Web service para Ingresar un pedido 						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSRESTFUL listPrc DESCRIPTION "Obtener historial pedido movil"
	WSDATA cCodList As String //Json Recebido

	WSMETHOD GET  	DESCRIPTION "Retorna lista de pedidos realizados" 	WSSYNTAX "/listPrc || /listPrc/{cCodList}"

END WSRESTFUL
WSMETHOD GET WSRECEIVE cCodList WSSERVICE listPrc // recibir por QueryString si hay codigo de usuario para filtrar
	Local aArea 	 := GetArea()
	Local cNextAlias := GetNextAlias()
	Local lRet		 := .T.
	::SetContentType("application/json")

	cCodList := cvaltochar(::cCodList)
	if !empty(cCodList)
		//		aUSR := bscCodVen(cCodList)
		//		if aUSR[3]
		cCodList += "%"
		conout(cCodList)
		BeginSQL Alias cNextAlias
			SELECT DA1_FILIAL, DA1_ITEM, DA1_CODTAB, RTRIM(LTRIM(DA1_CODPRO)) DA1_CODPRO, DA1_PRCVEN, DA1_MOEDA // Andre Krauss 03/27/2019 -> Fix a servicio faltaba campo DA1_MOEDA
			FROM  %Table:DA1% DA1
			JOIN %Table:DA0% DA0 ON DA0.DA0_FILIAL = DA1.DA1_FILIAL AND DA1.DA1_CODTAB = DA0.DA0_CODTAB AND DA0.%notDel%
			AND DA0.DA0_UVISTO LIKE '1' and ( DA0_DATATE >= %exp:ddatabase %  or DA0_DATATE like '' )
			WHERE DA1_CODTAB LIKE %exp: cCodList %
			AND DA0.DA0_FILIAL = %exp:xFilial("DA0")%
			And DA1.%notDel%
			ORDER BY DA1_CODTAB, DA1_ITEM
		EndSQL
	else
		BeginSQL Alias cNextAlias
			SELECT DA1_FILIAL, DA1_ITEM, DA1_CODTAB, RTRIM(LTRIM(DA1_CODPRO)) DA1_CODPRO, DA1_PRCVEN, DA1_MOEDA
			FROM  %Table:DA1% DA1
			JOIN %Table:DA0% DA0 ON DA0.DA0_FILIAL = DA1.DA1_FILIAL AND DA1.DA1_CODTAB = DA0.DA0_CODTAB AND DA0.%notDel% 
			AND DA0.DA0_UVISTO LIKE '1' and (DA0_DATATE >= %exp:ddatabase % or DA0_DATATE like '')
			WHERE DA1.%notDel%
			AND DA0.DA0_FILIAL = %exp:xFilial("DA0")%
			ORDER BY DA1_CODTAB, DA1_ITEM
		EndSQL
	endif

	// cQuery:=GetLastQuery()
	// Aviso("",cQuery[2],{"Ok"},,,,,.T.)
//	MemoWrite("D:\Protheus_12\IzzyTst\protheus_data\nahim\query_ctxcbxcl.sql",cQuery[2])
	// conout(cQuery[2])
	DbSelectArea(cNextAlias) // seleccionar area Area

	(cNextAlias)->( DbGoTop() )



	aObj := {}
	If (cNextAlias)->(!Eof())
		While !(cNextAlias)->(Eof())
			obj := JsonObject():new()
			obj['DA0_CODTAB']  := (cNextAlias)->DA1_CODTAB
			obj['DA0_DESCRI']  := Posicione("DA0",1,xFilial("DA0")+(cNextAlias)->DA1_CODTAB,"DA0_DESCRI")
			obj['DA0_CONDPG']  := DA0->DA0_CONDPG
			obj['DA0_UVIAPP']  := DA0->DA0_UVIAPP
			obj['DA0_DEPTAB']  := DA0->DA0_DEPTAB

//				Posicione("DA0",1,xFilial("DA0")+TRB->DA0_CODTAB,"DA0_DESCRI")
//				DA0_FILIAL+DA0_CODTAB

			aObjList := {}
			cCodTabl := (cNextAlias)->DA1_CODTAB
			while cCodTabl == (cNextAlias)->DA1_CODTAB .and. !(cNextAlias)->(Eof())
				obj2 := JsonObject():new()
				obj2['DA1_CODPRO']  := (cNextAlias)->DA1_CODPRO
				obj2['DA1_PRCVEN']  := (cNextAlias)->DA1_PRCVEN
				obj2['DA1_MOEDA']  := (cNextAlias)->DA1_MOEDA

				AADD(aObjList,obj2)
				(cNextAlias)->(dbSkip())
			end
//				obj['DESC']  := (cNextAlias)->X5_DESCSPA
			obj['LISTA']  := aObjList
			AADD(aObj,obj)
		EndDo // hasta el final

		cResponse:= '{'
		cResponse+= '"status" : "success",'
		cResponse+= '"data" : '
		cJson:= FWJsonSerialize(aObj,.T.,.T.)
		cResponse+= cJson
		cResponse+= '}'

		cResponse := EncodeUtf8(cResponse)

		::SetResponse(cResponse)
	else
		//SetRestFault(400, "SE4 Empty")
		cResponse:= '{'
		cResponse+= '"status" : "fail",'
		cResponse+= '"data" : "DA1 Empty"'
		cResponse+= '}'

		::SetResponse(cResponse)

		//lRet := .F.
	endif



	RestArea(aArea)
Return(lRet)
