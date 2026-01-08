#include 'protheus.ch'
#include 'parmtype.ch'

#Define TIPOCOT1 '1234'	//1: Dependiente o Asegurado con Pensión del SIP < 65 años que aporta (RA_AFPOPC)
#Define TIPOCOT2 '12*4'	//8: Dependiente o Asegurado con Pensión del SIP > 65 años que aporta (RA_AFPOPC)
#Define TIPOCOTC '1*34'	//C: Asegurado con Pensión del SIP < 65 años que NO aporta (RA_AFPOPC)
#Define TIPOCOTD '1**4'	//D: Asegurado con Pensión del SIP > 65 años que NO aporta (RA_AFPOPC)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ GP010VALPE ³Denar Terrazas			   º Data ³ 14/01/2020º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Punto de entrada validar la configuracion de los campos    º±±
±±º          ³ RA_RIESPRO y RA_AFPOPC. Para la AFP                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TdeP                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function GP010VALPE()
	Local aArea		:= getArea()
	Local lRet		:= .F.
	Local cTitle	:= "Configuración quivocada para AFP"
	Local cMessage	:= ""
	Local cField	:= ""
	Local cBtnText	:= "Finalizar"
	Local cOpc1		:= (M->RA_RIESPRO == 'S' .AND. M->RA_AFPOPC == TIPOCOT1)
	Local cOpc2		:= (M->RA_RIESPRO == 'N' .AND. M->RA_AFPOPC == TIPOCOT2)
	Local cOpc3		:= (M->RA_RIESPRO == 'S' .AND. M->RA_AFPOPC == TIPOCOTC)
	Local cOpc4		:= (M->RA_RIESPRO == 'N' .AND. M->RA_AFPOPC == TIPOCOTD)
	Local cOpc5		:= (M->RA_RIESPRO == 'N' .AND. Empty(M->RA_AFPOPC))
	
	If cOpc1 .OR. cOpc2 .OR. cOpc3 .OR. cOpc4 .OR. cOpc5
		lRet:= .T.
	EndIf

	if(!lRet)
		cField:= getField()
		cMessage+= "Revisa la configuración de los campos " + cField
		Aviso(cTitle, cMessage, {cBtnText})
	endIf
	restArea(aArea)
return lRet

/**
*
* @author: Denar Terrazas Parada
* @since: 14/01/2020
* @description: Funcion que devuelve el titulo de los campos utilizados para la validación
*				RA_RIESPRO y RA_AFPOPC
*
*/
Static Function getField()
	Local aArea		:= getArea()
	Local cTitulo	:= ""
	Local cRet		:= ""
	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek( "RA_RIESPRO" )
		cTitulo := TRIM(X3Titulo())
	EndIf
	If(Empty(cTitulo))
		cTitulo:= "RA_RIESPRO"
	EndIf
	cRet	:= '"' + cTitulo + '" y '
	cTitulo	:= ""

	If dbSeek( "RA_AFPOPC" )
		cTitulo := TRIM(X3Titulo())
	EndIf
	If(Empty(cTitulo))
		cTitulo:= "RA_AFPOPC"
	EndIf
	cRet+= '"' + cTitulo + '"'
	
	restArea(aArea)
Return cRet