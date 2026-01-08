#include 'protheus.ch'

/**
*
* @author: Denar Terrazas Parada
* @since: 07/02/2022
* @description: Punto de Entrada que se ejecuta en la generacion de Nota
*				Utilizado para no permitir la generación de remitos con factura anulada
* @return: boolean(.T./.F.)
* @help: https://centraldeatendimento.totvs.com/hc/pt-br/articles/360020446312-MP-ADVPL-Ponto-de-entrada-M460mark
*/
User Function M460MARK()
	Local lRet			:=.T.
	Local aArea			:= GetArea()
	Local OrdenConsul	:= GetNextAlias()
	Local cMark			:= PARAMIXB[1] // MARCA UTILIZADA
	//Local lInvert := PARAMIXB[2] // SELECIONO "MARCA TODOS"

	BeginSql Alias OrdenConsul

	SELECT *
	FROM %table:SD2%
	WHERE %notdel%
	AND D2_FILIAL = %exp:xFilial("SD2")%
	AND D2_OK = %exp:cMark%

	EndSql

	DbSelectArea(OrdenConsul)
	If (OrdenConsul)->(!Eof())
		while ( (OrdenConsul)->(!Eof()) .AND. lRet == .T.)
			If ( (OrdenConsul)->D2_OK == cMark .AND. !EMPTY( (OrdenConsul)->D2_UFACDEL ) )
				FWAlertWarning("Tiene seleccionado un remito con factura anulada.", "TOTVS")
				lRet:=.F.
			EndIf
			(OrdenConsul)->(dbSkip())
		Enddo
	endIf

	RestArea(aArea)
Return lRet
