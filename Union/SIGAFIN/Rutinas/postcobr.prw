#include "totvs.ch"

User Function postcobr(cbody)

	//
	local cUrlTdeP :=  GETNEWPAR("MV_RESTURL", "http://LOCALHOST:8093")
	Local oRestClient := FWRest():New(cUrlTdeP)
	Local aHeader := {}
	local cUsuRest := GETNEWPAR("MV_RESTUSU", "admin")// MV_RESTUSU
	local cPassRest := GETNEWPAR("MV_RESTPAS", " ")// MV_RESTPAS
	
	if '8093' $ cUrlTdeP .and. !('MP12PRD' $ UPPER(GetEnvServer())) // SI ES DIFERENTE DE PRD y es 8093 debería dar error
		alert("ES NECESARIO CAMBIAR EL PARAMETRO 'MV_RESTURL' para el ambiente: " +GetEnvServer())
		RETURN
	endif
	
	// inclui o campo Authorization no formato <usuario>:<senha> na base64
	//	MV_RESTLOG
	
	Aadd(aHeader, "Authorization: Basic " + Encode64(cUsuRest + ":" + cPassRest))
	Aadd(aHeader, "tenantId: 01," + xfilial("SC5") )

	// chamada da classe exemplo de REST com retorno de lista
	oRestClient:setPath("/rest/Cobranza")
	/*If oRestClient:Get(aHeader)
	ConOut("GET", oRestClient:GetResult())
	Else
	ConOut("GET", oRestClient:GetLastError())
	EndIf*/

	// chamada da classe exemplo de REST para operações CRUD
	//	oRestClient:setPath("/rest/sample/1")
	//	If oRestClient:Get(aHeader)
	//		ConOut("GET", oRestClient:GetResult())
	//	Else
	//		ConOut("GET", oRestClient:GetLastError())
	//	EndIf

	// define o conteúdo do body
	oRestClient:SetPostParams(cbody)

	If oRestClient:Post(aHeader)
		return oRestClient:GetResult()
		//		aviso("",oRestClient:GetResult(),{'ok'},,,,,.t.)
		//		ConOut("POST", oRestClient:GetResult())
	Else
		return oRestClient:GetLastError()
		//		aviso("",oRestClient:GetLastError(),{'ok'},,,,,.t.)
		//		ConOut("POST", oRestClient:GetLastError())
	EndIf

	// para os métodos PUT e DELETE o conteúdo body é enviado por parametro
	//	If oRestClient:Put(aHeader, "body")
	//		ConOut("PUT", oRestClient:GetResult())
	//	Else
	//		ConOut("PUT", oRestClient:GetLastError())
	//	EndIf
	//
	//	If oRestClient:Delete(aHeader, "body")
	//		ConOut("DELETE", oRestClient:GetResult())
	//	Else
	//		ConOut("DELETE", oRestClient:GetLastError())
	//	EndIf
Return 