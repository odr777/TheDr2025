#Include "REPORT.CH"
#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE NPOSFUNC 1
#DEFINE NPOSNETO 2

/**
* @author: Denar Terrazas Parada
* @since: 09/07/2021
* @description: Punto de Entrada para realizar validaciones antes de cerrar el Cierre de Periodos.
* @routine: GPEM120 - Cierre de Periodo
* @help: https://tdn.totvs.com/pages/releaseview.action?pageId=566473659
*/
User Function GP120VLD()
	Local lOk       := .F.
	//Local cFilRCH   := PARAMIXB[1]
	Local cProces   := PARAMIXB[2]
	Local cPeriod   := PARAMIXB[3]
	Local cNumPag   := PARAMIXB[4]
	Local cRot      := PARAMIXB[5]
	Local cFOL		:= "FOL"
	Local cFIN		:= "FIN"
	Local cQUI		:= "QUI"
	Local cAGU		:= "AGU"
	Local cDAG		:= "DAG"
	Local cANT		:= "ANT"
	Local cPRV		:= "PRV"
	Local cPDValid	:= ""//Concepto de Validación por Procedimiento
	Local aNetos	:= {}
	Local cMensaje	:= ""

	Do Case
	Case cRot == cFOL
		cPDValid:= FGETCODFOL("0047")//LIQ. PAGABLE SUELDO
	Case cRot == cFIN
		cPDValid:= FGETCODFOL("0126")//LIQ. PAGABLE FINIQUI
	Case cRot == cQUI
		cPDValid:= FGETCODFOL("1273")//BASE PARA QUINQUENIO
	Case cRot == cAGU
		cPDValid:= FGETCODFOL("0021")//NETO PAGO AGUINALDO
	Case cRot == cDAG
		cPDValid:= FGETCODFOL("1729")//NETO PAGO 2DO AGUINA
	Case cRot == cANT
		cPDValid:= FGETCODFOL("0546")//LIQ. PAGABLE ANTICIP
	Case cRot == cPRV
		cPDValid:= FGETCODFOL("0774")//PROV. MENSUAL INDEMN
	EndCase

	aNetos:= getNetos(cProces, cPeriod, cNumPag, cRot, cPDValid)
	cMensaje:= "Está a punto de cerrar el Periodo '" + cPeriod + "' del Procedimiento '" + TRIM(cRot) + "' "
	cMensaje+= "con la siguiente información: " + CRLF + CRLF
	If(Len(aNetos) > 0)
		cMensaje+= "- Total de Funcionarios con información: " + cValToChar(aNetos[1][NPOSFUNC]) + CRLF
		cMensaje+= "- Valor neto: Bs. " + cValToChar(aNetos[1][NPOSNETO])
	Else
		cMensaje+= "- Total de Funcionarios con información: 0" + CRLF
		cMensaje+= "- Valor neto: Bs. 0"
	EndIf

	lOk:= confirmar(cMensaje)

	If(!lOk)
		aAdd(aLogErros[1], "El cierre del periodo '" + cPeriod + "' del Procedimiento '" + TRIM(cRot) + "' ha sido cancelado por el usuario.")
	EndIf

Return lOk

/**
* @author: Denar Terrazas Parada
* @since: 09/07/2021
* @description: Funcion que devuelve:
*				1. Cantidad de funcionarios.
*				2. Valor Neto.
*				Del procedimiento y periodo que se está cerrando.
*/
Static Function getNetos(cProces, cPeriod, cNumPag, cRot, cPDValid)
	Local aArea			:= getArea()
	Local OrdenConsul	:= GetNextAlias()
	Local aRet			:= {}
	// consulta a la base de datos
	BeginSql Alias OrdenConsul

		SELECT COUNT(*) AS FUNCIONARIOS, SUM(RC_VALOR) AS NETO
		FROM
		(
		SELECT RC_FILIAL, RC_MAT, SUM(RC_VALOR) AS RC_VALOR
		FROM %table:SRC%
		WHERE RC_PROCES = %exp:cProces%
		AND RC_PERIODO = %exp:cPeriod%
		AND RC_SEMANA = %exp:cNumPag%
		AND RC_ROTEIR = %exp:cRot%
		AND RC_PD = %exp:cPDValid%
		AND %notdel%
		GROUP BY RC_FILIAL, RC_MAT
		) A

	EndSql
	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		AADD(aRet,{(OrdenConsul)->FUNCIONARIOS, (OrdenConsul)->NETO})
	endIf

	restArea(aArea)
return aRet

/**
*
* @author: Denar Terrazas Parada
* @since: 09/07/2021
* @description: Función que pregunta si confirma el cierre del periodo de acuerdo a la información que se visualiza
*				1 = Si ; 2 = NO 
*/
static function confirmar(cMensaje)
	Local cTitulo	:= "ATENCIÓN!!! Este proceso es IRREVERSIBLE"
	Local lRet		:= .F.
	Local cTexto	:= cMensaje + CRLF + CRLF
	Local nOpcAviso

	cTexto+= "¿Está seguro que desea cerrar el periodo?"

	nOpcAviso:= Aviso(cTitulo, cTexto, {"Si", "No"})

	If(nOpcAviso == 1)//Si confirma
		lRet:= .T.
	EndIf

return lRet
