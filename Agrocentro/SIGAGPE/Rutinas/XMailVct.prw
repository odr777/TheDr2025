#Include "Totvs.ch"
#Include "topconn.ch"
#INCLUDE "TBICONN.CH"

/**
* @author: Denar Terrazas Parada
* @since: 31/01/2022
* @description: Programa para enviar correo sobre los funcionarios con fecha de vencimiento de contrato
*/

user function XMailVct()
	Local cMailFrom	:= "", cPass    := "", cSendSrv := "", cMailTo:= ""
	Local cFrom     := "", cTo      := "", cSubject := "", cBody:= ""
	Local nSendPort := 0, nTimeout  := 0
	Local cMsg      := ""
	Local xRet
	Local oServer, oMessage
	Local lUseAuth	:= .F., lUseSSL:= .F., lUseTLS:= .F.

	conout("XMailVct (" + DTOC( Date() ) + " " + TIME() + ")")
	conout("Enviando mail Vencimiento de Contrato (" + DTOC( Date() ) + " " + TIME() + ")")

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "GPE" TABLES "RCH","SRA"

	cSendSrv	:= TRIM(SuperGetMV("MV_XGPSERV"	, .F., "", ""))	//define the send server				//MV_RELSERV
	cMailFrom	:= TRIM(SuperGetMV("MV_XGPFROM"	, .F., "", ""))	//define the e-mail account username	//MV_RELACNT
	cPass		:= TRIM(SuperGetMV("MV_XGPPASS"	, .F., "", ""))	//define the e-mail account password	//MV_RELPSW
	cMailTo		:= TRIM(SuperGetMV("MV_XGPTO"	, .F., "", ""))	//define the e-mails to receive the mail

	lUseAuth	:= SuperGetMV("MV_XGPAUTH", .F., .F., "")	//MV_RELAUTH
	lUseSSL		:= SuperGetMV("MV_RELSSL", .F., .F., "")
	lUseTLS		:= SuperGetMV("MV_RELTLS", .F., .F., "")

	nTimeout	:= SuperGetMV("MV_RELTIME", .F., 60, "") //define the timout to 60 seconds

	if(Empty(cSendSrv))
		cMsg := "No se ha informado el nombre del servidor de envío en el parámetro MV_XGPSERV."
		conout( cMsg )
		RESET ENVIRONMENT
		return
	EndIf

	if(Empty(cMailFrom))
		cMsg := "No se ha informado el correo encargado de hacer el envío en el parámetro MV_XGPFROM."
		conout( cMsg )
		RESET ENVIRONMENT
		return
	EndIf

	if(Empty(cMailTo))
		cMsg := "No se ha informado el correo de recepción en el parámetro MV_XGPTO."
		conout( cMsg )
		RESET ENVIRONMENT
		return
	EndIf

	cFrom   	:= cMailFrom
	cTo     	:= cMailTo
	cOpenPeriod	:= getOpenPeriod()
	cSubject	:= "Protheus: Funcionarios con vencimiento de contrato " + cOpenPeriod
	cBody   	:= getEmployeesExpirationDateList(cOpenPeriod)

	oServer := TMailManager():New()

	oServer:SetUseSSL( lUseSSL )
	oServer:SetUseTLS( lUseTLS )

	nSendPort := 25//SuperGetMV("MV_RELPORT", .F., 25, "") //default port for SMTPS protocol with TLS

	// once it will only send messages, the receiver server will be passed as ""
	// and the receive port number won't be passed, once it is optional
	xRet := oServer:Init( "", cSendSrv, cMailFrom, cPass, , nSendPort )
	if xRet != 0
		cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		RESET ENVIRONMENT
		return
	endif

	// the method set the timout for the SMTP server
	xRet := oServer:SetSMTPTimeout( nTimeout )
	if xRet != 0
		cMsg := "Could not set " + cProtocol + " timeout to " + cValToChar( nTimeout )
		conout( cMsg )
	endif

	// estabilish the connection with the SMTP server
	xRet := oServer:SMTPConnect()
	if xRet <> 0
		cMsg := "Could not connect on SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		RESET ENVIRONMENT
		return
	endif

	if(lUseAuth)
		// authenticate on the SMTP server (if needed)
		xRet := oServer:SmtpAuth( cMailFrom, cPass )
		if xRet <> 0
			cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
			conout( cMsg )
			oServer:SMTPDisconnect()
			RESET ENVIRONMENT
			return
		endif
	EndIf

	oMessage:= TMailMessage():New()
	oMessage:Clear()

	oMessage:cDate    := cValToChar( Date() )
	oMessage:cFrom    := cFrom
	oMessage:cTo      := cTo
	oMessage:cSubject := cSubject
	oMessage:cBody    := cBody

	xRet := oMessage:Send( oServer )
	if xRet <> 0
		cMsg := "Could not send message: " + oServer:GetErrorString( xRet )
		conout( cMsg )
	endif

	xRet := oServer:SMTPDisconnect()
	if xRet <> 0
		cMsg := "Could not disconnect from SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
	endif

	RESET ENVIRONMENT

return

/**
* @author: Denar Terrazas Parada
* @since: 31/01/2022
* @description: Función que obtiene el periodo abierto de FOL
*/
Static Function getOpenPeriod()
	Local aArea			:= getArea()
	Local cRet			:= ""
	Local cNextAlias:= GetNextAlias()

	// consulta a la base de datos
	BeginSql Alias cNextAlias

    SELECT TOP 1 RCH_PER
    FROM %table:RCH%
    WHERE RCH_FILIAL = %exp:xFilial("RCH")%
    AND RCH_ROTEIR = 'FOL'
    AND RCH_PERSEL = '1'
    AND %notdel%

	EndSql
	DbSelectArea(cNextAlias)
	If (cNextAlias)->(!Eof())
		cRet:= TRIM((cNextAlias)->RCH_PER)
	endIf

	restArea(aArea)

Return cRet

/**
* @author: Denar Terrazas Parada
* @since: 31/01/2022
* @description: Función que obtiene los funcionarios con fecha de fin de contrato en el mes
*/
Static Function getEmployeesExpirationDateList(cOpenPeriod)
	Local aArea			:= getArea()
	Local cRet			:= ""
	Local cHTML     	:= ""
	Local cNextAlias:= GetNextAlias()

	If(!Empty(cOpenPeriod))
		// consulta a la base de datos
		BeginSql Alias cNextAlias

			SELECT RA_FILIAL, RA_MAT, RA_RG, RA_NOMECMP, RA_ADMISSA, RA_DEMISSA, RA_XVCTOCO
			FROM %table:SRA% SRA
			WHERE SRA.RA_TPCONTR = 2
			AND SUBSTRING(RA_XVCTOCO,1,6) = %exp:cOpenPeriod%
			AND SRA.%notdel%

		EndSql
		DbSelectArea(cNextAlias)
		If (cNextAlias)->(!Eof())

			cHTML:= "<html>"
			cHTML+= "<head>"

      	/*** CSS ***/
			cHTML+= "<style>"
			cHTML+= "table {"
			cHTML+= "  font-family: arial, sans-serif;"
			cHTML+= "  border-collapse: collapse;"
			cHTML+= "  width: 100%;"
			cHTML+= "}"
			cHTML+= "td, th {"
			cHTML+= "  border: 1px solid #dddddd;"
			cHTML+= "  text-align: center;"
			cHTML+= "  padding: 7px;"
			cHTML+= "}"
			cHTML+= "</style>"
      /*** FIN CSS **/

			cHTML+= "</head>"
			cHTML+= "<body>"

			cHTML+= "<table>"
			cHTML+= "  <tr>"
			cHTML+= "    <th>Sucursal</th>"
			cHTML+= "    <th>Matrícula</th>"
			cHTML+= "    <th>C.I.</th>"
			cHTML+= "    <th>Nombre</th>"
			cHTML+= "    <th>Fecha de Ingreso</th>"
			cHTML+= "    <th>Fecha de Retiro</th>"
			cHTML+= "    <th>Fecha de Vencimiento de Contrato</th>"
			cHTML+= "  </tr>"
			while ( (cNextAlias)->(!Eof()))
				cHTML+= "<tr>"
				cHTML+= "<td>" + (cNextAlias)->RA_FILIAL + "</td>"
				cHTML+= "<td>" + (cNextAlias)->RA_MAT + "</td>"
				cHTML+= "<td>" + (cNextAlias)->RA_RG + "</td>"
				cHTML+= "<td>" + (cNextAlias)->RA_NOMECMP + "</td>"
				cHTML+= "<td>" + DTOC(STOD((cNextAlias)->RA_ADMISSA)) + "</td>"
				cHTML+= "<td>" + DTOC(STOD((cNextAlias)->RA_DEMISSA)) + "</td>"
				cHTML+= "<td>" + DTOC(STOD((cNextAlias)->RA_XVCTOCO)) + "</td>"
				cHTML+= "</tr>"
				(cNextAlias)->(dbSkip())
			End
			cHTML+= "</table>
			cHTML+= "</body>"
			cHTML+= "</html>"
		endIf
	EndIf

	If(Empty(cHTML))
		cHTML:= "<h3>No existen funcionarios con vencimiento de contrato en este periodo.</h3>"
	EndIf

	cRet:= cHTML

	restArea(aArea)

Return cRet

