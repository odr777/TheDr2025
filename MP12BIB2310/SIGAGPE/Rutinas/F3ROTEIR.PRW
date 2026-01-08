#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
/**
* @author: Denar Terrazas Parada
* @since: 10/10/2021
* @description: Funcion que presenta una pantalla para que el usuario seleccione el procedimiento de cálculo
*/
User Function F3ROTEIR(cPeriodo)
	Local aArea		:= getArea()
	Local cRet		:= ""
	Local cProced	:= "FOL"//Procedimiento
	Local _oDlg

	if(existeRET(cPeriodo))//Si existe algún periodo de Retroactivo(RE1, RE2, RE3, RE4)

		DEFINE MSDIALOG _oDlg TITLE "Procedimiento de cálculo" FROM C(288),C(463) TO C(460),C(660) PIXEL

		// Cria Componentes Padroes do Sistema
		@ C(018),C(011) Say "Procedimiento: " Size C(030),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
		@ C(017),C(042) MsGet oProced Var cProced Size C(45),C(009) COLOR CLR_BLACK PIXEL OF _oDlg F3 "SRY"
		@ C(060),C(060) Button "&Confirmar" Size C(030),C(012) PIXEL OF _oDlg ACTION _oDlg:END()

		ACTIVATE MSDIALOG _oDlg CENTERED

		if(!Empty(cProced))
			cRet:= cProced
		EndIf

	EndIf

	restArea(aArea)

return cRet

/**
* @author: Denar Terrazas Parada
* @since: 14/06/2021
* @description: Funcion que indica si existe algún procedimiento de retroactivo(RE1, RE2, RE3, RE4) en el periodo enviado
*/
Static Function existeRET(cPeriodo)
	Local aArea			:= getArea()
	Local lRet			:= .F.
	Local OrdenConsul	:= GetNextAlias()

	BeginSql Alias OrdenConsul

		SELECT COUNT(*) AS CANTIDAD
		FROM %table:RCH% RCH
		WHERE RCH.RCH_FILIAL = %exp:xFilial('RCH')%
		AND RCH.RCH_PER = %exp:cPeriodo%
		AND RCH.RCH_ROTEIR IN ('RE1', 'RE2', 'RE3', 'RE4')
		AND RCH.%notdel%

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		If((OrdenConsul)->CANTIDAD > 0)
			lRet:= .T.
		EndIf
	endIf
	restArea(aArea)
Return lRet

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
