#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  S4Import_ArticleFilter  ºAutor  ³Ariel Dominguez             º±±
±±ºFecha ³  05/03/2023                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Desarrollo de interfaz de integración con SLIM              º±±
±±º Maestro de Articulos                                                  º±±
±±º                                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ UNION                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function S4Import_ArticleFilter()

    Local aArea := GetArea()
    Local cArea := GetNextAlias()

	BeginSql Alias cArea

		SELECT E2_VALOR,E2_SALDO FROM %table:SE2% SE2
				WHERE SE2.%NotDEL% 
			   		AND %Exp: SF1->F1_FILIAL% 	= E2_FILIAL  
					AND %Exp: SF1->F1_SERIE%  	= E2_PREFIXO 
					AND %Exp: SF1->F1_DOC% 		= E2_NUM  
					AND %Exp: SF1->F1_FORNECE% 	= E2_FORNECE 
					AND %Exp: SF1->F1_LOJA%   	= E2_LOJA    
					AND %Exp: SF1->F1_DTDIGIT%	= E2_EMIS1 
					
	EndSql
	
	DbSelectArea(cArea) 
	DbGoTop()
	If !Eof()
		If (cArea)->E2_SALDO < (cArea)->E2_VALOR
			lRet := .F.
			alert("No puede borrar una factura cuya CxP haya sido dada de baja")
		EndIf
	EndIf
    DbCloseArea()
	RestArea(aArea)

Return 
