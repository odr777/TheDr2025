#Include "REPORT.CH"
#Include 'protheus.ch'
#Include 'parmtype.ch'

#DEFINE NITTYPE "5" //5 NIT - Tabla F3I010 - F3I_CODIGO = 'S007' AND F3I_SEQUEN = '00005'

/**
* @author: Denar Terrazas Parada
* @since: 25/03/2022
* @description: Función para verificar si un NIT es válido.
* @parameters:	cTipDoc	-> Tipo de Documento de Identidad
*				cNIT 	-> Número de NIT a ser verificado, ejemplo "193850055"
* @help: https://tdn.totvs.com/display/framework/FWRest
* @call: U_ValidNIT("5","193850055")
* @return: Valor Lógico(.T. / .F.)
*/
User Function ValidNIT(cTipDoc, cNIT)

	Local aArea		:= getArea()
	Local cUrl		:= Trim(SUPERGETMV("MV_WSRTSS", .F., ""))
	Local aHeader	:= {}
	Local lRet		:= .F.
	Local cEndpoint	:= "/msinvoice/api/integrations/nit-check/"//TODO Obtener endpoint del catálogo cuando sea adicionado
	Local cToken    := ""
	Local oRestNIT

	cNIT:= AllTrim(cNIT)

	If( AllTrim(cTipDoc) == NITTYPE .AND. !Empty(cNIT) )//Sólo validar cuando sea NIT

		If(!Empty(cUrl))

			oRestNIT:= FWRest():New(cUrl)
			cToken	:= authenticate(oRestNIT)

			If(!Empty(cToken))

				//Adding authentication
				aAdd(aHeader,"Authorization: Bearer " + cToken)

				//Endpoint
				oRestNIT:setPath(cEndpoint + cNIT)
				//Call
				If( oRestNIT:Get(aHeader) )
					if(oRestNIT:GetResult() == "true")
						lRet:= .T.
					EndIf
				Else
					ConOut("GET nit-check", oRestNIT:GetLastError())
					ShowError("GET nit-check", oRestNIT:GetLastError())
				EndIf

			EndIf
		Else
			ShowError("MV_WSRTSS", "Por favor contacte al administrador del sistema, parámetro MV_WSRTSS no informado.")
		EndIf

	Else
		lRet:= .T.
	EndIf

	if(!lRet)
		ShowError("NIT Inválido", "Por favor verificar el NIT digitado.")
	EndIf

	restArea(aArea)

Return lRet

/**
* @author: Denar Terrazas Parada
* @since: 25/03/2022
* @description: Función para autenticarse a los servicios de Vulcan y obtener el token para consumir los servicios
* @parameters:	oRest -> Objeto FWRest
* @return: caracter -> token para consumir servicios de Vulcan
*/
Static Function authenticate(oRest)

	Local aArea		:= getArea()
	Local aHeader	:= {}
	Local cRet		:= ""
	Local cEndpoint	:= "/gateway/api/authenticate"	//TODO Obtener endpoint del catálogo "AUTHENTICATE"
	Local cUser		:= Trim(SUPERGETMV("MV_CFDI_US", .F., ""))
	Local cPass		:= Trim(SUPERGETMV("MV_CFDI_CO", .F., ""))
	Local cBody

	if(!Empty(cUser))

		aAdd(aHeader,"Content-Type: application/json")

		cBody := '{                              '
		cBody += '	"username" : "' + cUser + '",'
		cBody += '	"password" : "' + cPass + '" '
		cBody += '}                              '

		//Endpoint
		oRest:setPath(cEndpoint)

		//Body
		oRest:SetPostParams(cBody)
		//Call
		If( oRest:Post(aHeader) )
			oJsonResponse	:= JsonObject():new()
			//Efectuar el parser del JSON
			cParser := oJsonResponse:fromJson(oRest:GetResult())
			if cParser == NIL
				cRet:= Trim(oJsonResponse['id_token'])
			else
				//En caso de que falle el parser, mostrar error en la consola
				ConOut("Erro parsing JSON:", cParser)
				ShowError("Erro parsing JSON", cParser)
			EndIf
		Else
			ConOut("POST authenticate", oRestNIT:GetLastError())
			ShowError("POST authenticate", oRestNIT:GetLastError())
		EndIf
	Else
		ShowError("MV_CFDI_US", "Por favor contacte al administrador del sistema, parámetro MV_CFDI_US no informado.")
	EndIf

	restArea(aArea)

Return cRet

/**
* @author: Denar Terrazas Parada
* @since: 25/03/2022
* @description: Función para mostrar un error:
*				- Si es desde un smartclient	-> Se muestra un Alert
*				- Si NO es desde un smartclient	-> Se imprime en la consola(ConOut)
* @parameters:	cTitle	-> Título
*				cMessage-> Mensaje de error
*/
Static Function ShowError(cTitle, cMessage)

	Local aArea	:= getArea()
	Local lBlind:= IsBlind()//Verifica si la conexión con Protheus no posee interface de usuario

	If(!lBlind)//Si es desde un SmartClient
		FWAlertError(cMessage, cTitle)
	Else//Si es un execAuto, JOB o WS
		ConOut(cTitle, cMessage)
	EndIf

	restArea(aArea)

Return
