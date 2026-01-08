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

WSRESTFUL RESTCONDPG DESCRIPTION "Condiciones de Pago"

WSDATA session_id      AS string

WSMETHOD GET  DESCRIPTION "Obtiene  Condiciones de Pago" WSSYNTAX "/RESTCONDPG"

END WSRESTFUL

WSMETHOD GET  WSSERVICE RESTCONDPG
	Local aArea 	 := GetArea()
	Local lRet := .T.
	Local oPagoc
	Local aApagos := {}
	::SetContentType("application/json")

	OrdenConsul	:= GetNextAlias()
	// consulta a la base de datos
	BeginSql Alias OrdenConsul
	SELECT E4_CODIGO, E4_DESCRI ,E4_COND , E4_TIPO
	FROM %table:SE4% SE4
	WHERE SE4.%notdel%
	AND SE4.E4_XVTA = '1'
	EndSql
	DbSelectArea(OrdenConsul)
	aObjCondPg := {}
	If (OrdenConsul)->(!Eof())
		While !(OrdenConsul)->(Eof())

			oPagoc	 := CondPA():New()
			oPagoc:SetCod( (OrdenConsul)->E4_CODIGO )
			oPagoc:SetDesc( AllTrim((OrdenConsul)->E4_DESCRI))
			oPagoc:SetCond( AllTrim((OrdenConsul)->E4_COND))
			oPagoc:SetTipo( AllTrim((OrdenConsul)->E4_TIPO))

			aadd(aApagos,oPagoc)
			(OrdenConsul)->(dbSkip())
		EndDo // hasta el final

		cJson := FWJsonSerialize(aApagos,.T.,.T.)

		cJson := EncodeUtf8(cJson)
		(OrdenConsul)->( DbCloseArea() )

		::SetResponse(cJson)
	else

		cResponse:= '{'
		cResponse+= '"status" : "fail",'
		cResponse+= '"data" : "SE4 Empty"'
		cResponse+= '}'
		::SetResponse(cResponse)

	endif
	RestArea(aArea)
Return lRet
