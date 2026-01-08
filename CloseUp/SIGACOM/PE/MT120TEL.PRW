#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³MT110TEL  ºAuthor ³Denar Terrazas    	 º Date ³  26/04/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE - Manipulação do Cabeçalho do Pedido de Compras 	      º±±
±±º          ³Para adicionar novos campos					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ Bolivia/Casa Grande	                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120TEL
	Local oDlg 		:= PARAMIXB[1]
	Local aPosGet   := PARAMIXB[2]
	Local aObj		:= PARAMIXB[3]
	Local nOpcx     := PARAMIXB[4]
//Local nReg      := PARAMIXB[5]

	Local oTxtNomP
	Local oGetNomP

	Public cGetNomP	:= Space(TamSX3('C7_UNOME')[1])

	If nOpcx == 2 .OR. nOpcx == 4	//Visualizar o Modificar

		cGetNomP	:= SC7->C7_UNOME

	Endif

	@ 055, aPosGet[1][Len(aPosGet[1])] - 10 SAY oTxtNomP PROMPT Alltrim(RetTitle("C7_UNOME")) SIZE 040, 006 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055, aPosGet[1][Len(aPosGet[1])] + 35 MSGET oGetNomP VAR cGetNomP WHEN .F. SIZE 80, 006 OF oDlg COLORS 0, 16777215 PIXEL

Return


