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
±±³WS     ³ RestClieVen ³ Autor ³ Denar Terrazas      ³ Data ³ 07/12/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Web service obtiene los clientes por vendedor				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ TdeP Horeb                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

WSRESTFUL CLIENTESVEN DESCRIPTION "Servicio clientes por vendedor"

	WSDATA cVend   AS String

	WSMETHOD GET DESCRIPTION "Retorna lista de clientes por vendedor informado" WSSYNTAX "/CLIENTESVEN || /CLIENTESVEN /{cVend}"

END WSRESTFUL

WSMETHOD GET WSRECEIVE cVend  WSSERVICE CLIENTESVEN
	Local aArea 	 := GetArea()
	Local cNextAlias := GetNextAlias()
	LOCAL aClientes  := {}
	Local cJSON		 := ""
	Local lRet		 := .T.

	::SetContentType("application/json;charset=utf-8")

	cVend:= ::cVend

	BeginSQL Alias cNextAlias
		SELECT A1_COD, A1_LOJA, RTRIM(A1_NOME) A1_NOME, A1_END, A1_CGC, A1_EST, A1_TEL,A1_MUN,A1_TABELA,
		A1_CONTA,A1_COND,A1_NREDUZ,RTRIM(A1_UNOMFAC) A1_UNOMFAC,
		A1_TIPDOC, A1_CLDOCID, A1_EMAIL, A1_UNITFAC
		FROM %table:SA1% SA1
		WHERE A1_VEND = (SELECT A3_COD FROM %table:SA3% SA3 WHERE A3_CODUSR = %exp:cVend% AND SA3.%notdel%)
		AND SA1.%notdel%
	EndSQL

	DbSelectArea(cNextAlias) // seleccionar area Area

	(cNextAlias)->( DbGoTop() )

	If (cNextAlias)->( !Eof() )
		While !(cNextAlias)->(Eof() )
			objClie := JsonObject():new()
			objClie['A1_COD']			:= (cNextAlias)->A1_COD
			objClie['A1_LOJA']			:= (cNextAlias)->A1_LOJA
			objClie['A1_NOME']			:= (cNextAlias)->A1_NOME
			objClie['A1_END']			:= (cNextAlias)->A1_END
			objClie['A1_CGC']			:= (cNextAlias)->A1_CGC
			objClie['A1_EST']			:= (cNextAlias)->A1_EST
			objClie['A1_TEL']			:= (cNextAlias)->A1_TEL
			objClie['A1_MUN']			:= (cNextAlias)->A1_MUN
			objClie['A1_TAB']			:= (cNextAlias)->A1_TABELA
			objClie['A1_CONTA']			:= (cNextAlias)->A1_CONTA
			objClie['A1_COND']			:= (cNextAlias)->A1_COND
			objClie['A1_NREDUZ']		:= (cNextAlias)->A1_NREDUZ
			objClie['A1_UNOMFAC']		:= Alltrim((cNextAlias)->A1_UNOMFAC)
			objClie['A1_TIPDOC']		:= (cNextAlias)->A1_TIPDOC
			objClie['A1_CLDOCID']		:= (cNextAlias)->A1_CLDOCID
			objClie['A1_EMAIL']			:= (cNextAlias)->A1_EMAIL
			objClie['A1_UNITFAC']		:= (cNextAlias)->A1_UNITFAC


			AADD(aClientes,objClie)

			(cNextAlias)->( DbSkip() )

		EndDo

		cResponse:= '{'
		cResponse+= '"status" : "success",'
		cResponse+= '"data" : '
		cJson:= FWJsonSerialize(aClientes,.T.,.T.)
		cResponse+= cJson
		cResponse+= '}'
		cResponse := EncodeUtf8(cResponse)
		::SetResponse(cResponse)

	Else
		cResponse:= '{'
		cResponse+= '"status" : "fail",'
		cResponse+= '"data" : "No hay datos para exhibir"'
		cResponse+= '}'
		cResponse := EncodeUtf8(cResponse)
		::SetResponse(cResponse)
	EndIf
	RestArea(aArea)

Return(lRet)
