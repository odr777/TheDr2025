#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#Include "aarray.ch"
#Include "json.ch"
#INCLUDE "RESTFUL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³WS     ³ RESTBANC ³ Autor ³ Carlos Egüez       ³ Data ³ 02/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Web service para obtener las cobranzas por clientes		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSRESTFUL RESTBANC DESCRIPTION "Info. Cobranza"

WSDATA session_id AS string

WSMETHOD GET  DESCRIPTION "Cobranza" WSSYNTAX "/RESTBANC"

END WSRESTFUL

WSMETHOD GET  WSSERVICE RESTBANC
	Local aArea := GetArea()
	Local lRet := .T.
	//Private cEmisao
	//Private cEmisao1
	::SetContentType("application/json")

	//If Len(::aURLParms) > 0

	//cEmisao := ::aURLParms[1]
	//cEmisao1:= ::aURLParms[2]

	OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos

	BeginSql Alias OrdenConsul
		SELECT A6_FILIAL [FILIAL], A6_COD [COD], A6_NOME [NOME],A6_AGENCIA [AGENCIA], A6_NUMCON [NUMCON], A6_MOEDA [MOEDA], A6_TIPOCTA [TIPOCTA],
		A6_UCUSR
		FROM %table:SA6% SA6
		WHERE SA6.%notdel%
	EndSql
	DbSelectArea(OrdenConsul)

	aObj := {}

	if (OrdenConsul)->(!Eof())
		While !(OrdenConsul)->(Eof())

			obj := JsonObject():new()
			obj['A6_FILIAL']	:= (OrdenConsul)->FILIAL
			obj['A6_COD']		:= (OrdenConsul)->COD
			obj['A6_NOME']		:= (OrdenConsul)->NOME
			obj['A6_AGENCIA']	:= (OrdenConsul)->AGENCIA
			obj['A6_NUMCON']	:= (OrdenConsul)->NUMCON
			obj['A6_MOEDA']		:= (OrdenConsul)->MOEDA
			obj['A6_TIPOCTA']	:= (OrdenConsul)->TIPOCTA
			obj['A6_UCOB']	:= (OrdenConsul)->A6_UCUSR


			AADD(aObj,obj)
			(OrdenConsul)->(dbSkip())

		EndDo

		cResponse:= '{'
		cResponse+= '"status" : "success",'
		cResponse+= '"data" : '
		cJson:= FWJsonSerialize(aObj,.T.,.T.)
		cResponse+= cJson
		cResponse+= '}'

		cResponse:= EncodeUtf8(cResponse)

		::SetResponse(cResponse)

	else

		cResponse:= '{'
		cResponse+= '"status" : "fail",'
		cResponse+= '"data" : "SA6 Empty"'
		cResponse+= '}'
		::SetResponse(cResponse)

	endif

	RestArea(aArea)
Return lRet