#include 'protheus.ch'
#include 'parmtype.ch'

user function SetDatosCli(cNitCli,cNomcli, cTipDoc, cCorreo, cTelefono)
	// Variaveis Locais da Funcao
	Local aRet		:= {}
	Local ccNitCli	:= AllTrim(CValToChar(cNitCli)) + Space((TamSX3("F2_UNITCLI")[1]) - Len(AllTrim(CValToChar(cNitCli))))
	Local ccNomCli	:= cNomcli
	Local ccCorreo	:= cCorreo
	Local ccTelefono:= cTelefono
	Local ocNitCli
	Local ocNomCli
	Local ocTipDoc
	Local ocCorreo
	Local ocTelefono

	// Variaveis Private da Funcao
	Local _oDlg				// Dialog Principal
	Private ccTipDoc:= cTipDoc
	iF EMPTY(ccNomCli)
		ccNitCli	 := Space(TamSX3("F2_UNITCLI")[1])
		ccNomCli	 := Space(TamSX3("F2_UNOMCLI")[1])
	END

	DEFINE MSDIALOG _oDlg TITLE "Datos del Cliente" FROM C(288),C(463) TO C(560),C(859) PIXEL

	// Cria as Groups do Sistema
	@ C(004),C(004) TO C(110),C(197) LABEL "Datos para Facturar" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	@ C(017),C(011) Say "Nombre: " Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(017),C(042) MsGet ocNomCli Var ccNomCli Size C(138),C(009) COLOR CLR_BLACK PIXEL OF _oDlg VALID !EMPTY(ccNomCli)

	@ C(036),C(011) Say "Tp.Doc.Ident" Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(036),C(043) MsGet ocTipDoc Var ccTipDoc Size C(020),C(009) COLOR CLR_BLACK PIXEL OF _oDlg F3 "BOL007" VALID (ValidF3I("S007",ccTipDoc,1,1))

	@ C(055),C(011) Say "NIT" Size C(011),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(055),C(043) MsGet ocNitCli Var ccNitCli Size C(081),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNitCli) .AND. U_ValidNIT(ccTipDoc,ALLTRIM(cValToChar(ccNitCli)))

	@ C(074),C(011) Say "E-Mail Fact." Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(074),C(043) MsGet ocCorreo Var ccCorreo Size C(081),C(009) COLOR CLR_BLACK PIXEL OF _oDlg VALID (EMPTY(TRIM(ccCorreo)) .OR. IsEmail(TRIM(ccCorreo)))

	@ C(093),C(011) Say "Teléfono" Size C(023),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(093),C(043) MsGet ocTelefono Var ccTelefono Size C(081),C(009) COLOR CLR_BLACK PIXEL OF _oDlg

	@ C(115),C(160) Button "&Confirmar" Size C(037),C(012) PIXEL OF _oDlg ACTION _oDlg:END()

	ACTIVATE MSDIALOG _oDlg CENTERED

	AADD(aRet, TRIM(ccNitCli))//1 - NIT
	AADD(aRet, TRIM(ccNomCli))//2 - Nombre
	AADD(aRet, TRIM(ccTipDoc))//3 - Tipo Documento Identidad
	AADD(aRet, TRIM(ccCorreo))//4 - E-Mail Recepción Factura
	AADD(aRet, TRIM(ccTelefono))//5 - Número de teléfono para recepción de la factura.

Return aRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                
