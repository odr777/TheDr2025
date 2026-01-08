#include "protheus.ch"

/**
* @author: Denar Terrazas Parada
* @since: 04/08/2022
* @description: Programa para enviar correo a los proovedores cuando se aprueba un pedido de compra.
*/

User Function XMailPro(cBranch, cNumber, cProvider, cProvStore, cProvEmail)

	Local aArea		:= getArea()
	Local lEmailSent:= .F.

	cHtml:= getPurchaseOrder(cBranch, cNumber)

	If(!Empty(cHtml))
		//Aviso("HTML", cHtml, {'Ok'},,,,,.T.)
		lEmailSent:= sendMail(;
			cProvEmail,;
			cHtml)
	EndIf

	ShowMessage(cProvider, cProvStore, lEmailSent)

	restArea(aArea)

Return


Static Function sendMail(cProvEmail, cMessageHTML)
	Local cMailFrom	:= "", cPass    := "", cSendSrv := ""
	Local cFrom     := "", cTo      := "", cSubject := "", cBody:= ""
	Local nSendPort := 0, nSendSec  := 2, nTimeout  := 0
	Local cMsg      := ""
	Local lOk		:= .T.
	Local xRet
	Local oServer, oMessage
	conout("Enviando mail a proveedor")
	cSendSrv	:= TRIM(SuperGetMV("MV_XGMSMTP", .F., "")) // define the send server
	cMailFrom	:= TRIM(SuperGetMV("MV_XGMFROM", .F., "")) //define the e-mail account username
	cPass		:= TRIM(SuperGetMV("MV_XGMPASS", .F., "")) //define the e-mail account password
	nTimeout	:= 60 // define the timout to 60 seconds

	if(Empty(cSendSrv))
		cMsg := "No se ha informado el nombre del servidor SMTP en el parámetro MV_XGMSMTP"
		conout( cMsg )
		return .F.
	EndIf

	if(Empty(cMailFrom))
		cMsg := "No se ha informado el correo de envío en el parámetro MV_XGMFROM"
		conout( cMsg )
		return .F.
	EndIf

	if(Empty(cPass))
		cMsg := "No se ha informado la Contraseña de correo de envío en el parámetro MV_XGMPASS"
		conout( cMsg )
		return .F.
	EndIf

	cFrom   := cMailFrom
	cTo     := cProvEmail//TRIM(SuperGetMV("MV_XMCTO", .F., ""))
	cSubject:= "Pedido de compra"
	cBody   := cMessageHTML

	oServer := TMailManager():New()

	oServer:SetUseSSL( .T. )
	oServer:SetUseTLS( .T. )

	if nSendSec == 0
		nSendPort := 25 //default port for SMTP protocol
	elseif nSendSec == 1
		nSendPort := 465 //default port for SMTP protocol with SSL
		oServer:SetUseSSL( .T. )
	else
		nSendPort := 587 //default port for SMTPS protocol with TLS
		oServer:SetUseTLS( .T. )
	endif

	// once it will only send messages, the receiver server will be passed as ""
	// and the receive port number won't be passed, once it is optional
	xRet := oServer:Init( "", cSendSrv, cMailFrom, cPass, , nSendPort )
	if xRet != 0
		cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		return .F.
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
		return .F.
	endif

	// authenticate on the SMTP server (if needed)
	xRet := oServer:SmtpAuth( cMailFrom, cPass )
	if xRet <> 0
		cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		oServer:SMTPDisconnect()
		return .F.
	endif

	oMessage:= TMailMessage():New()
	oMessage:Clear()

	oMessage:cDate		:= cValToChar( Date() )
	oMessage:cFrom		:= cFrom
	oMessage:cTo		:= cTo
	oMessage:cCC		:= TRIM(SuperGetMV("MV_XMPTO", .F., ""))//Correos en copia
	oMessage:cSubject	:= cSubject
	oMessage:cBody		:= cBody

	xRet := oMessage:Send( oServer )
	if xRet <> 0
		cMsg := "Could not send message: " + oServer:GetErrorString( xRet )
		conout( cMsg )
		lOk:= .F.
	endif

	xRet := oServer:SMTPDisconnect()
	if xRet <> 0
		cMsg := "Could not disconnect from SMTP server: " + oServer:GetErrorString( xRet )
		conout( cMsg )
	endif
return lOk

/**
* @author: Denar Terrazas Parada
* @since: 04/08/2022
* @description: Función que obtiene el pedido de compra, ya en formato html para enviar correo.
* @parameters:	cBranch -> Sucursal del pedido de compra
*				cNumber -> Número del pedido de compra
*/
Static Function getPurchaseOrder(cBranch, cNumber)
	Local aArea			:= getArea()
	Local cRet			:= ""
	Local cHTML     	:= ""
	Local cNextAlias	:= GetNextAlias()
	Local nTotalQuantity:= 0
	Local nTotalPrice	:= 0
	Local nTotal		:= 0

	// consulta a la base de datos
	BeginSql Alias cNextAlias

		SELECT SC7.C7_ITEM, SC7.C7_PRODUTO, SC7.C7_DESCRI, SC7.C7_UM, SC7.C7_QUANT, SC7.C7_PRECO, SC7.C7_TOTAL, SC7.C7_DATPRF, C7_CC, C7_NUMSC,
		SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NOME, SA2.A2_NREDUZ, SA2.A2_EMAIL
		FROM %table:SC7% SC7 (NOLOCK)
		LEFT JOIN %table:SA2% SA2 (NOLOCK) ON SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_LOJA = SC7.C7_LOJA AND SA2.%notdel%
		JOIN %table:SB1% SB1 (NOLOCK) ON SC7.C7_PRODUTO = SB1.B1_COD
		WHERE SC7.%notdel%
		AND SB1.%notdel%
		AND SC7.C7_FILIAL = %exp:cBranch%
		AND C7_NUM = %exp:cNumber%
		ORDER BY SC7.C7_ITEM

	EndSql

	/*
	cQuery:=GetLastQuery()
	Aviso("query",cvaltochar(cQuery[2]`````),{"si"},,,,,.t.)//   usar este en esste caso cuando es BEGIN SQL
	*/

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
		cHTML+= ".right{"
		cHTML+= "	text-align:right;"
		cHTML+= "}"
		cHTML+= "</style>"
      /*** FIN CSS **/

		cHTML+= "<body>"
		cHTML+= "    <p>Señores “" + TRIM((cNextAlias)->A2_NOME) + "”</p>"
		cHTML+= "    <h2>Pedido de compra</h2>"
		cHTML+= "    <table>"
		cHTML+= "        <tr>"
		cHTML+= "            <th>" + getFieldTitle("C7_ITEM")	+ "</th>"
		cHTML+= "            <th>" + getFieldTitle("C7_PRODUTO")+ "</th>"
		cHTML+= "            <th>" + getFieldTitle("C7_DESCRI")	+ "</th>"
		cHTML+= "            <th>" + getFieldTitle("C7_UM")		+ "</th>"
		cHTML+= "            <th>" + getFieldTitle("C7_QUANT")	+ "</th>"
		cHTML+= "            <th>" + getFieldTitle("C7_PRECO")	+ "</th>"
		cHTML+= "            <th>" + getFieldTitle("C7_TOTAL")	+ "</th>"
		cHTML+= "            <th>" + getFieldTitle("C7_DATPRF")	+ "</th>"
		cHTML+= "            <th>" + getFieldTitle("C7_CC")		+ "</th>"
		cHTML+= "            <th>" + getFieldTitle("C7_NUMSC")	+ "</th>"
		cHTML+= "        </tr>"
		while ( (cNextAlias)->(!Eof()))

			cHTML+= "        <tr>"
			cHTML+= "            <td>" + TRIM((cNextAlias)->C7_ITEM) + "</td>"
			cHTML+= "            <td>" + TRIM((cNextAlias)->C7_PRODUTO) + "</td>"
			cHTML+= "            <td>" + TRIM((cNextAlias)->C7_DESCRI) + "</td>"
			cHTML+= "            <td>" + TRIM((cNextAlias)->C7_UM) + "</td>"
			cHTML+= '            <td class="right">' + TRANSFORM( (cNextAlias)->C7_QUANT, PesqPict( "SC7", "C7_QUANT") ) + '</td>'
			cHTML+= '            <td class="right">' + TRANSFORM( (cNextAlias)->C7_PRECO, PesqPict( "SC7", "C7_PRECO") ) + '</td>'
			cHTML+= '            <td class="right">' + TRANSFORM( (cNextAlias)->C7_TOTAL, PesqPict( "SC7", "C7_TOTAL") ) + '</td>'
			cHTML+= "            <td>" + DTOC(STOD((cNextAlias)->C7_DATPRF)) + "</td>"
			cHTML+= "            <td>" + TRIM((cNextAlias)->C7_CC) + "</td>"
			cHTML+= "            <td>" + TRIM((cNextAlias)->C7_NUMSC) + "</td>"
			cHTML+= "        </tr>"

			nTotalQuantity	+= (cNextAlias)->C7_QUANT
			nTotalPrice		+= (cNextAlias)->C7_PRECO
			nTotal			+= (cNextAlias)->C7_TOTAL

			(cNextAlias)->(dbSkip())

		End
		cHTML+= "        <tfoot>"
		cHTML+= "            <tr>"
		cHTML+= '                <th class="right" colspan="4">TOTAL</th>'
		cHTML+= '                <th class="right">' + TRANSFORM( nTotalQuantity, PesqPict( "SC7", "C7_QUANT") ) + '</th>'
		cHTML+= '                <th class="right">' + TRANSFORM( nTotalPrice, PesqPict( "SC7", "C7_PRECO") ) + '</th>'
		cHTML+= '                <th class="right">' + TRANSFORM( nTotal, PesqPict( "SC7", "C7_TOTAL") ) + '</th>'
		cHTML+= "            </tr>"
		cHTML+= "        </tfoot>"
		cHTML+= "    </table>"
		cHTML+= "    <br>"
		cHTML+= "    <p>Saludos cordiales.</p>"
		cHTML+= "</body>"
		cHTML+= "</html>"
	endIf

	cRet:= cHTML

	restArea(aArea)

Return cRet

/**
* @author: Denar Terrazas Parada
* @since: 27/05/2022
* @description: Funcion que devuelve el titulo de los campos enviados en el parámetro
* @parameters: cField -> Nombre del campo
*/
Static Function getFieldTitle(cField)
	Local aArea		:= getArea()
	Local cRet		:= ""

	dbSelectArea("SX3")
	dbSetOrder(2)

	If dbSeek( cField )
		cRet := TRIM( X3Titulo() )
	EndIf

	restArea(aArea)
Return cRet


/**
* @author: Denar Terrazas Parada
* @since: 25/03/2022
* @description: Función para mostrar un mensaje al usuario:
*				- Si es desde un smartclient	-> Se muestra en pantalla
*				- Si NO es desde un smartclient	-> Se imprime en la consola(ConOut)
* @parameters:	cProvider	-> Código del proveedor.
*				cProvStore	-> Tienda del proveedor.
*				lEmailSent	-> Valor booleano que indica si el correo fue enviado o no.
*/
Static Function ShowMessage(cProvider, cProvStore, lEmailSent)
	Local aArea			:= getArea()
	Local lBlind		:= IsBlind()//Verifica si la conexión con Protheus no posee interface de usuario
	Local cOkTitle		:= "Correo enviado"
	Local cErrorTitle	:=	"Error al enviar correo"

	If(!lBlind)//Si es desde un SmartClient
		If(lEmailSent)
			FWAlertSuccess("Correo enviado a Proveedor: " + cProvider + " tienda: " + cProvStore, cOkTitle)
		Else
			FWAlertError("No fue posible enviar correo al Proveedor: " + cProvider + " tienda: " + cProvStore, cErrorTitle)
		EndIf
	Else//Si es un execAuto, JOB o WS
		If(lEmailSent)
			ConOut(cOkTitle, "Correo enviado a Proveedor: " + cProvider + " tienda: " + cProvStore)
		Else
			ConOut(cErrorTitle, "No fue posible enviar correo al Proveedor: " + cProvider + " tienda: " + cProvStore)
		EndIf
	EndIf

	restArea(aArea)

Return
