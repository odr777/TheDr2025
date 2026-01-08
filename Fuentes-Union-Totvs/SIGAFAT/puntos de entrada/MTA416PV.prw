#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ MTA416PV ºAutor  ³Nain Terrazasº Data ³23/03/2017          º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºModificaciones  ³                                                      º±±
±±º Omar Delgadillo³    Data ³23/03/2017    ³Nuevos campos por            º±±
±±º                                          Facturación en Línea         º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Punto de Entrada despues de Aprobacion de presupuestoº±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ Union                                                      º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA416PV

	cNomcli := If(Empty(Trim(SCJ->CJ_UNOMCLI)), GetAdvFVal("SA1","A1_UNOMFAC", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),Trim(SCJ->CJ_UNOMCLI))
	cTipDoc := If(Empty(Trim(SCJ->CJ_XTIPDOC)), GetAdvFVal("SA1","A1_TIPDOC",  xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),Trim(SCJ->CJ_XTIPDOC))
	cNitCli := If(Empty(Trim(SCJ->CJ_XNITCLI)), GetAdvFVal("SA1","A1_UNITFAC", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),Trim(SCJ->CJ_XNITCLI))
	cComDoc := If(Empty(Trim(SCJ->CJ_XCLDOCI)), GetAdvFVal("SA1","A1_CLDOCID", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),Trim(SCJ->CJ_XCLDOCI))
	cEmail 	:= If(Empty(Trim(SCJ->CJ_XEMAIL)),  GetAdvFVal("SA1","A1_EMAIL",   xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),Trim(SCJ->CJ_XEMAIL))

	M->C5_UNOMCLI := cNomcli //Nombre del cliente
	M->C5_XTIPDOC := cTipDoc //Tipo Documento Identidad
	M->C5_UNITCLI := cNitCli //Documento a facturar
	M->C5_XCLDOCI := cComDoc //Complemento del documento
	M->C5_XEMAIL  := cEmail	 //E-Mail Recepción Factura

    M->C5_CODMPAG := "1"
Return
