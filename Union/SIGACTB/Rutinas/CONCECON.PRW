#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A085APAG   º Autor ³ Nahim Terrazas   º Fecha ³  13/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescripcion ³ Punto de Entrada que se ejecuta al Grabar un OP          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BASE BOLIVIA                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CONCECON()
	//Local lPregunta := Alltrim(SEK->EK_FORNECE) $ SuperGetMv("MV_PIDBEN",.F.,"")
	Local oDlg,Proveedor,oSay2,Valor,oSay4,Beneficiario,oGet6,oSBtn7

	if type("cGlosaCon") <> "U"
		return cGlosaCon
	else
		public cGlosaCon := Space(50)
		DEFINE MSDIALOG oDlg TITLE "Concepto - Glosa" From 9,0 To 20,90
		//		@ 1  ,1 SAY SA2->A2_NOME
		//		@ 2  ,1 SAY "Valor    :     "+ TransForm( SEK->EK_VALOR , "@E 999,999,999,999,999.999")
		@ 3  ,1 SAY OemToAnsi("Concepto")
		@ 3  ,5  MSGET cGlosaCon  Picture "@!" Valid !Empty(cGlosaCon)
//		CT5_FILIAL+CT5_LANPAD+CT5_SEQUEN
		fEjecutar :=  GetAdvFVal("CT5","CT5_HIST",xFilial("CT5")+CT5->CT5_LANPAD ,1,"") 
		
		cGlosaCon := &fEjecutar
		
		DEFINE SBUTTON FROM 5 ,166  TYPE 1 ACTION oDlg:End() ENABLE OF oDlg

		ACTIVATE MSDIALOG oDlg centered
	endif
Return cGlosaCon
