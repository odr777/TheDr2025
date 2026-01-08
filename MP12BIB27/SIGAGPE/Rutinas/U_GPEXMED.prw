#include 'protheus.ch'
#include 'parmtype.ch'

#DEFINE AGU_ROTEIR	'AGU'//Procedimiento de Aguinaldo
/**
*
* @author: Denar Terrazas Parada
* @since: 27/01/2020
* @description: Funcion que devuelve el promedio del total ganado de los ultimos 3 meses del periodo enviado
*				incluyendose como uno de esos periodos
*				Utilizada en la fórmula U_UCALCAGU -> NMEDAGUI:= U_GPEXMED()
* @parameters:	cParamPer	->	Periodo de referencia para obtener el total ganado los 3 periodos anteriores
*								incluyendose como 1 de ellos
*				cFiltroSRV	->	Campo de filtro para la SRV, ejemplo: "RV_MED13 = 'S'"
*/
user function GPEXMED(cParamPer, cFiltroSRV, cRoteir, nMeses)
	Local aArea			:= getArea()
	Local nRet			:= 0
	Local cPeriodos		:= "" //"% '" + cAnho + "09', '" + cAnho + "10', '" + cAnho + "11' %"
	Local nFactor		:= 3 //3 meses
	Local OrdenConsul
	Default cParamPer 	:= NIL
	Default cFiltroSRV	:= NIL
	Default cRoteir		:= NIL
	Default nMeses		:= 3

	If( cRoteir <> NIL )
		IF( cRoteir == AGU_ROTEIR )
			If(nMeses <= 3)	//If(nMeses < 3)	
				If( SuperGetMV("MV_XPROMAGU",,1) == 2) //1= Divide entre 3; 2=divide según los meses trabajados
					nFactor:= INT(nMeses-0.01) //Meses trabajados sin contar diciembre porque no está calculado
					If(nFactor <= 0)
						nFactor:= 3
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	If( !Empty(cParamPer) .OR. (cParamPer <> NIL) )
		cPeriodos:= get3Periodos(cParamPer)

		If( !Empty(cFiltroSRV) .OR. (cFiltroSRV <> NIL) )
			cFiltroSRV:= "% AND SRV." + TRIM(cFiltroSRV) + " %"
		else
			cFiltroSRV:= "%%"
		EndIf

		OrdenConsul	:= GetNextAlias()
		// consulta a la base de datos
		BeginSql Alias OrdenConsul

			SELECT SRD.RD_MAT, SUM(SRD.RD_VALOR)/ (%Exp:nFactor%) AS AGUI
			FROM %table:SRD% SRD
			JOIN %table:SRV% SRV ON SRV.RV_COD = SRD.RD_PD
			WHERE SRD.RD_MAT = %Exp:SRA->RA_MAT%
			AND SRD.RD_PERIODO IN (%Exp:cPeriodos%)
			AND SRV.RV_TIPOCOD = '1'
			AND SRD.RD_ROTEIR = 'FOL'
			AND SRD.%notdel%
			AND SRV.%notdel%
			%Exp:cFiltroSRV%
			GROUP BY SRD.RD_MAT
			ORDER BY SRD.RD_MAT

		EndSql

		DbSelectArea(OrdenConsul)
		If (OrdenConsul)->(!Eof())
			nRet:= (OrdenConsul)->AGUI
		endIf
		(OrdenConsul)->(dbCloseArea())
	EndIf

	restArea(aArea)
return nRet

/**
*
* @author: Denar Terrazas Parada
* @since: 20/11/2020
* @description: Funcion que devuelve el los ultimos 3 meses del periodo enviado en los parametros(incluyendose)
*				para ser utilizado en el query
* @parameters:	cPer ->	Periodo de referencia para obtener los 3 periodos anteriores
*						incluyendose como 1 de ellos
*/
Static Function get3Periodos(cPer)
	Local aArea		:= getArea()
	Local cRet		:= "% '"
	Local nPeriodo	:= Val(cPer)
	Local nI		:= 0

	for nI:= 1 to 3
		cRet+= cValToChar(nPeriodo) + "', '"
		nPeriodo--
	next

	cRet:= Substr(cRet, 1, (Len(cRet) - 3) ) + " %"

	restArea(aArea)
Return cRet
