#Include "REPORT.CH"
#include 'protheus.ch'
#include 'parmtype.ch'

/**
* @author: Denar Terrazas Parada
* @since: 22/07/2021
* @description: Función para verificar si un campo existe o no.
* @parameters:	cAlias -> Alias de la tabla. Ejemplo: "SRA"
* 				cCampo -> Campo a ser verificado. Ejemplo: "RA_XNEW"
* @help: https://tdn.totvs.com/pages/viewpage.action?pageId=27675725
* @call: U_existSX3("SRA", "RA_XNEW")
* @return: Valor Lógico(.T. / .F.)
*/
User Function existSX3(cAlias, cCampo)
	Local aArea		:= getArea()
	Local lRet		:= .F.

	DbSelectArea(cAlias)

	If FieldPos(cCampo) > 0	//Si el campo existe
		lRet:= .T.
	EndIf

	DbCloseArea()

	restArea(aArea)
Return lRet
