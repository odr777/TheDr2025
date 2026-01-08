

user function SendEmail(cFrom,cTo,cSubject,cBody)
  Local cUser := "", cPass := "", cSendSrv := ""
  Local cMsg := ""
  Local nSendPort := 0, nSendSec := 2, nTimeout := 0
  Local xRet
  Local oServer, oMessage
   conout("EJECUTANDO mail")
  // cUser := "totvs.erp.bolivia@gmail.com" //define the e-mail account username
  // cPass := "totvs.tdep" //define the e-mail account password
  // cSendSrv := "smtp.gmail.com" // define the send server
  cUser := "ecommerce@mercantilleon.com" //define the e-mail account username
  cPass := "Mleon143953021" //define the e-mail account password
  cSendSrv := "mail.mercantilleon.com" // define the send server
  nTimeout := 60 // define the timout to 60 seconds
   
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
  xRet := oServer:Init( "", cSendSrv, cUser, cPass, , nSendPort )
  if xRet != 0
  cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
  conout( cMsg )
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
    return
  endif
   
  // authenticate on the SMTP server (if needed)
  xRet := oServer:SmtpAuth( cUser, cPass )
  if xRet <> 0
    cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
    conout( cMsg )
    oServer:SMTPDisconnect()
    return
  endif
   
  oMessage := TMailMessage():New()
  oMessage:Clear()
   
  oMessage:cDate := cValToChar( Date() )
  oMessage:cFrom := cFrom
  oMessage:cTo := cTo
  oMessage:cSubject := cSubject
  oMessage:cBody := cBody
   
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
return
