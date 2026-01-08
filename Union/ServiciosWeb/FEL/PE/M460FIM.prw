#include 'protheus.ch'
#include 'parmtype.ch'
#Include "TopConn.ch"

#DEFINE OFFLINE 	"-OF"	//Indica que fue realizado OFFLINE
#DEFINE TRANSMITTED "6"		//6=Transmitido

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³ Erick Etcheverry ºFecha ³  20/09/20 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de entrada para grabar datos actualizacion fiscales  º±±
±±º          ³ factura de venta y titulo desde generacion de notas        º±±
±±º          ³ ejecutado por factura caso seleccionar varias o una        º±±
±±ºModificado³ Omar Delgadillo					 ºFecha ³  21/03/2022 	  º±±
±±º      	 ³ Agregar campos personalizados Facturación En Línea         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function M460FIM()
	Local aArea		:= GetArea()
	Local lOffline	:= .F.
	cUsgrv:= ""

	cNitCli	:= If(Empty(SC5->C5_UNITCLI), GetAdvFVal("SA1","A1_UNITFAC", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNITCLI)
	cNomcli	:= If(Empty(SC5->C5_UNOMCLI), GetAdvFVal("SA1","A1_UNOMFAC", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_UNOMCLI)
	cTipDoc	:= If(Empty(SC5->C5_XTIPDOC), GetAdvFVal("SA1","A1_TIPDOC",  xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XTIPDOC)
	cComDoc	:= If(Empty(SC5->C5_XCLDOCI), GetAdvFVal("SA1","A1_CLDOCID", xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XCLDOCI)
	cEmail	:= If(Empty(SC5->C5_XEMAIL),  GetAdvFVal("SA1","A1_EMAIL", 	 xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1,"0"),SC5->C5_XEMAIL)
	cUsgrv	:= SC5->C5_USRREG

	If( !Empty(Trim(SC5->C5_UIDAPP)) )
		cToken	:= Trim(SC5->C5_UIDAPP)
		If( (SUBSTR(cToken, Len(cToken)-2, Len(cToken))) == OFFLINE )//Si fue Offline
			lOffline:= .T.
		EndIf
	EndIf

	Reclock('SF2',.F.)
	SF2->F2_UNITCLI	:= cNitCli
	SF2->F2_UNOMCLI	:= cNomCli
	SF2->F2_XTIPDOC	:= cTipDoc
	SF2->F2_XCLDOCI	:= cComDoc
	SF2->F2_XEMAIL	:= cEmail
	SF2->F2_USRREG	:= cUsgrv
	If(lOffline)
		SF2->F2_FLFTEX	:= TRANSMITTED//Estatus "Transmitido"
	EndIf
	SF2->(MsUnlock())

	IF SE1->E1_MOEDA == 2 .AND. SF2->F2_MOEDA == 1
		Reclock('SE1',.F.)
		SE1->E1_TXMOEDA := GETADVFVAL("SM2","M2_MOEDA2", SF2->F2_EMISSAO,1,"1")
		SE1->E1_VLCRUZ 	:= SF2->F2_VALBRUT
		SE1->(MsUnlock())
	ENDIF

	RestArea(aArea)
return

