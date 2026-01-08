#include "totvs.ch"

User Function postcobr(cbody)

	//
	local cUrlTdeP := "http://LOCALHOST:8400" // GETNEWPAR("MV_RESTURL", "http://LOCALHOST:8400")
	Local oRestClient := FWRest():New(cUrlTdeP)
	Local aHeader := {}

	// Aadd(aHeader, "Authorization: Basic " + Encode64(cUsuRest + ":" + cPassRest))
	Aadd(aHeader, "tenantId: 01," + xfilial("SF2") )

	// chamada da classe exemplo de REST com retorno de lista
	oRestClient:setPath("/rest/Cobranza")

	oRestClient:SetPostParams(cbody)

	If oRestClient:Post(aHeader)
		return oRestClient:GetResult()
	Else
		return oRestClient:GetLastError()
	EndIf

Return 
