#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³MT110TEL  ºAuthor ³Denar Terrazas    	 º Date ³  26/04/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE - Manipulación de cabecera del Pedido de Compras 	      º±±
±±º          ³Para adicionar campos nuevos		              			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ Bolivia				                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120TEL
	Local aArea     := GetArea()
	Local oDlg      := PARAMIXB[1]
	Local aPosGet   := PARAMIXB[2]
	Local aObj		:= PARAMIXB[3]
	Local nOpcx     := PARAMIXB[4]
	Local nRecPC    := PARAMIXB[5]
	Local aDlgFiel	:= PARAMIXB[6]
	Local lMT12ATE	:= ExistBlock("MT12ATE" )
	//Public cGetNomP	:= Space(TamSX3('C7_UNOME')[1])

	If nOpcx == 2 .OR. nOpcx == 4	//Visualizar o Modificar
		//cGetNomP	:= SC7->C7_UNOME
	Else
		nTxMoeda := 1
	Endif
	/*/{Protheus.doc} MT12ATEL
	Campos Pedido de Venda Campaña
	@type function
	@version 1.0
	@author Luiz Fael
	@since 28/11/2022
	@return variant, Nill
	/*/	
	If lMT12ATE // Cahamada para campos da campaña
		ExecBlock("MT12ATE",.F.,.F.,{@oDlg, aPosGet, aObj, nOpcx, nRecPC, @aDlgFiel} )
	EndIf
	//@ 055, 550 SAY oTxtNomP PROMPT "Nomb. Prov.:" SIZE 040, 006 OF oDlg COLORS 0, 16777215 PIXEL
	//@ 055, 585 MSGET oGetNomP VAR cGetNomP WHEN .F. SIZE 80, 006 OF oDlg COLORS 0, 16777215 PIXEL
	RestArea(aArea)
Return


