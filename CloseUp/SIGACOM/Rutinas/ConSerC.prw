#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function conserc(lRt)
	Local oOK := LoadBitmap(GetResources(),'br_verde')
	Local oNO := LoadBitmap(GetResources(),'br_vermelho')
	IF FUNNAME() $ "MATA102N"
		@ 000,000 To 440,905 DIALOG oDlg TITLE "Consulta de Serie"
		@ 040,160 BUTTON "&Confirmar" SIZE 040,010 ACTION oDlg:End() Object oBnt2

		oBrowse := TWBrowse():New( 070,05,445,085,,{'','Serie'},{20,30},;
		oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		aBrowse   := {{.T.,'PTD'},;
		{.T.,'PTM'} }
		oBrowse:SetArray(aBrowse)
		oBrowse:bLine := {||{If(aBrowse[oBrowse:nAt,01],oOK,oNO),aBrowse[oBrowse:nAt,02]} }
		// Troca a imagem no duplo click do mouse
		oBrowse:bLDblClick := {|| M->F1_SERIE := aBrowse[oBrowse:nAt][2],&(READVAR()) := aBrowse[oBrowse:nAt][2],oBrowse:DrawSelect()}

		ACTIVATE DIALOG oDlg CENTERED
	ENDIF
Return lRt