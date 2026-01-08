#include 'protheus.ch'
#include 'parmtype.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A085APAG   º Autor ³ Jorge Saavedra   º Fecha ³  13/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescripcion ³ Punto de Entrada que se ejecuta al Grabar un OP           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³BASE BOLIVIA                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A085APAG
Local lPregunta := .T.
Local cBenef := Space(50)
//Local lPregunta := Alltrim(SEK->EK_FORNECE) $ SuperGetMv("MV_PIDBEN",.F.,"")
Local oDlg,Proveedor,oSay2,Valor,oSay4,Beneficiario,oGet6,oSBtn7

If lPregunta .and. Alltrim(SEK->EK_TIPO) $ "CH"
	While Empty(cBenef)
			cBenef := SA2->A2_NOME  
			DEFINE MSDIALOG oDlg TITLE "Solicitud de Beneficiario" From 9,0 To 20,90
			@ 1  ,1 SAY SA2->A2_NOME
			@ 2  ,1 SAY "Valor    :     "+ TransForm( SEK->EK_VALOR , "@E 999,999,999,999,999.999")
			@ 3  ,1 SAY OemToAnsi("Beneficiario")
			@ 3  ,5  MSGET cBenef  Picture "@!" Valid !Empty(cBenef) 
			
			DEFINE SBUTTON FROM 5 ,166  TYPE 1 ACTION oDlg:End() ENABLE OF oDlg

			ACTIVATE MSDIALOG oDlg centered
	End
	RecLock("SEF" , .F.)
	EF_BENEF := cBenef
	MsUnLock()
ElseIf Alltrim(SEF->EF_TIPO) $ "CH"
	RecLock("SEF" , .F.)
//	EF_BENEF := Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CHEQUE")
	If Empty(EF_BENEF)
		EF_BENEF := Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_NOME")
	EndIf	
	MsUnLock()
EndIf

Return
