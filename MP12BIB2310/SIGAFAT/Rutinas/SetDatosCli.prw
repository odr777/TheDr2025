#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProgram   ณGetCodigo  บAuthor ณTdePบ Date ณ  12/05/2017 				  บฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบModificaciones														  บฑฑ
ฑฑ			บ Adecuaciones para Facturaci๓n en Lํnea	Date ณ 26/03/2024 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para colocar el Nombre y NIT a Facturar           บฑฑ
ฑฑบ          ณ                                               			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUse       ณ MP11BIB                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


user function SetDatosCli(cTipDoc, cNitCli, cClDocI, cNomcli, cEmail) 
// Variaveis Locais da Funcao
Local ccTipDoc	:= cTipDoc
Local ccNitCli	:= cNitCli
Local ccClDocI	:= cClDocI
Local ccNomCli	:= cNomcli
Local ccEmail	:= cEmail
Local ocTipDoc 
Local ocNitCli 
Local ocClDocI
Local ocNomCli 
Local ocEmail

Local aReturn


// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
Private lConfirmar := .F.

iF EMPTY(ccNomCli)
	ccTipDoc	:= Space(TamSX3("C5_XTIPDOC")[1])
	ccNitCli	:= Space(TamSX3("C5_UNITCLI")[1])
	ccClDocI	:= Space(TamSX3("C5_XCLDOCI")[1])
	ccNomCli	:= Space(TamSX3("C5_UNOMCLI")[1])
	ccEmail		:= Space(TamSX3("C5_XEMAIL")[1])
END

DEFINE MSDIALOG _oDlg TITLE "Datos del Cliente" FROM C(288),C(463) TO C(580),C(859) PIXEL

	// Cria as Groups do Sistema
	@ C(004),C(004) TO C(140),C(192) LABEL "Datos para Facturar" PIXEL OF _oDlg

	// Cria Componentes Padroes do Sistema
	
	@ C(017),C(011) Say "Tipo Doc.: " Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(017),C(045) MsGet ocTipDoc Var ccTipDoc Size C(10),C(009) COLOR CLR_BLACK PIXEL OF _oDlg F3 "BOL007" VALID (ValidF3I("S007",ccTipDoc,1,1)) //WHEN SC5->C5_CONDPAG = '002'

	@ C(037),C(011) Say "Nro. Doc." Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(037),C(045) MsGet ocNitCli Var ccNitCli Size C(050),C(009) COLOR CLR_BLACK PIXEL OF _oDlg  VALID !EMPTY(ccNitCli) .AND. IIF(SUBS(ALLTRIM(ccNitCli),1,1)=="0",.F.,.T.) // .AND. U_ValidNIT(ccTipDoc,ALLTRIM(cValToChar(ccNitCli)))
																															// ValNITVu(M->A1_CGC)
	@ C(057),C(011) Say "Complemento:" Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(057),C(045) MsGet ocClDocI Var ccClDocI Size C(10),C(009) COLOR CLR_BLACK PIXEL OF _oDlg 

	@ C(077),C(011) Say "Raz๓n Social: " Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(077),C(045) MsGet ocNomCli Var ccNomCli Size C(138),C(009) COLOR CLR_BLACK PIXEL OF _oDlg VALID !EMPTY(ccNomCli) 
	
	@ C(097),C(011) Say "Correo: " Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(097),C(045) MsGet ocEmail Var ccEmail Size C(138),C(009) COLOR CLR_BLACK PIXEL OF _oDlg VALID (EMPTY(TRIM(ccEmail)) .OR. IsEmail(TRIM(ccEmail)))

 	//@ C(117),C(146) Button "&Confirmar" Size C(037),C(012) PIXEL OF _oDlg ACTION (lConfirmar := .T.) _oDlg:END()
	//@ C(117),C(146) Button "&Cancelar" Size C(037),C(012) PIXEL OF _oDlg ACTION _oDlg:END()

	DEFINE SBUTTON FROM 146,86 	TYPE 1 ACTION( Confirmar() ) ENABLE OF _oDlg
	DEFINE SBUTTON FROM 146,146 TYPE 2 ACTION( _oDlg:End() ) ENABLE OF _oDlg

ACTIVATE MSDIALOG _oDlg CENTERED 

	If lConfirmar 
		aReturn := cValtoChar(ccTipDoc) +"|"+ cValtoChar(ccNitCli) +"|"+ ccClDocI +"|"+ ccNomCli +"|"+ ccEmail
	Else
		aReturn := cValtoChar(cTipDoc) +"|"+ cValtoChar(cNitCli) +"|"+ cClDocI +"|"+ cNomCli +"|"+ cEmail
	EndIf
	
Return aReturn

static Function Confirmar()
	lConfirmar := .T.
	_oDlg:End()
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
	//ณTratamento para tema "Flat"ณ                                               
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)    
