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
±±³WS     ³ RestClieVen ³ Autor ³ Nahim Terrazas      ³ Data ³ 23/09/2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Web service Consulta Cliente moroso				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSRESTFUL CONBLOQMO DESCRIPTION "Servicio Consulta cliente moroso"

    WSDATA cClient   AS String
    WSDATA cLoja   AS String

    WSMETHOD GET DESCRIPTION "Retorna lista de clientes por vendedor informado" WSSYNTAX "/CONBLOQMO || /CONBLOQMO /{cClient}"

END WSRESTFUL

WSMETHOD GET WSRECEIVE cClient,cLoja  WSSERVICE CONBLOQMO
    Local aArea 	 := GetArea()
    Local cNextAlias := GetNextAlias()
    LOCAL aClientes  := {}
    Local cJSON		 := ""
    Local lRet		 := .T.

    ::SetContentType("application/json;charset=utf-8")

    cClient:= ::cClient
    cLoja:= ::cLoja
    objClie := JsonObject():new()
    cStatus := U_ChkBlqMo(cClient,cLoja,.F.)


    if cStatus <> NIL
        objClie['MESSAGE']		 := cStatus
        objClie['CLIENT_STATUS'] := .T.
    else
        objClie['MESSAGE']		 := 'OK'
        objClie['CLIENT_STATUS'] := .F.
    EndIf



    cResponse:= '{'
    cResponse+= '"status" : "success",'
    cResponse+= '"data" : '
    cJson:= FWJsonSerialize(objClie,.T.,.T.)
    cResponse+= cJson
    cResponse+= '}'
    cResponse := EncodeUtf8(cResponse)
    ::SetResponse(cResponse)

    RestArea(aArea)

Return(lRet)
