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
±±³WS     ³ RESTCONDPG ³ Autor ³ Denar Terrazas       ³ Data ³ 27/07/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Web service obtener las condiciones de pago del sistema	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSRESTFUL RESTMDESC DESCRIPTION "Descuentos máximos por categoria"

WSDATA session_id      AS string

WSMETHOD GET  DESCRIPTION "Descuentos máximos por categoria" WSSYNTAX "/RESTMDESC"

END WSRESTFUL

WSMETHOD GET  WSSERVICE RESTMDESC
	Local aArea 	 := GetArea()
	Local lRet := .T.
	Local oPagoc
	Local aApagos := {}
	::SetContentType("application/json")

	OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul
	SELECT Z25_FILIAL,Z25_CODIGO,Z25_DESCRI,Z25_MAXDES,Z25_STATUS
	FROM %table:Z25% Z25
	WHERE Z25.%notdel%
	AND Z25.Z25_STATUS = '1'
	EndSql
	DbSelectArea(OrdenConsul)
	aObjCondPg := {}
	If (OrdenConsul)->(!Eof())
		While !(OrdenConsul)->(Eof())

            objMDesc := JsonObject():new()
            objMDesc['Z25_FILIAL']	:= (OrdenConsul)->Z25_FILIAL
            objMDesc['Z25_CODIGO']	:= ALLTRIM((OrdenConsul)->Z25_CODIGO)
            objMDesc['Z25_DESCRI']	:= (OrdenConsul)->Z25_DESCRI
            objMDesc['Z25_DESMAX']	:= (OrdenConsul)->Z25_MAXDES

			aadd(aObjCondPg,objMDesc)
			(OrdenConsul)->(dbSkip())
		EndDo // hasta el final

		cResponse:= '{'
		cResponse+= '"status" : "success",'
		cResponse+= '"data" : '
		cJson := FWJsonSerialize(aObjCondPg,.T.,.T.)
		// cJson:= FWJsonSerialize(aObj,.T.,.T.)
		cResponse+= cJson
		cResponse+= '}'

		cJson := EncodeUtf8(cResponse)
		(OrdenConsul)->( DbCloseArea() )

		::SetResponse(cJson)
	else

		cResponse:= '{'
		cResponse+= '"status" : "fail",'
		cResponse+= '"data" : "Z25 Empty"'
		cResponse+= '}'
		::SetResponse(cResponse)

	endif
	RestArea(aArea)
Return lRet
