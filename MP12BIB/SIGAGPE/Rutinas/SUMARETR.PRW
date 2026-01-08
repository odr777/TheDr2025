#include 'protheus.ch'
#include 'parmtype.ch'

/**
* @author: Denar Terrazas Parada
* @since: 26/05/2021
* @description: Funcion que suma los valores de los retroactivos para el finiquito.
* 				Esta función se utiliza en el cálculo de Finiquito(Rescisión) Fórmula USUMARET.
*/
User Function SUMARETR(cRotRET)
	Local aArea			:= getArea()
	Local nRet			:= 0
	Local cAliasQry		:= GetNextAlias()
	Local cQuery		:= ""
	Local cPer			:= SUBSTR(CPERIODO, 1, 4) + "05"//Periodo de retroactivo

	cQuery+= "SELECT SUM(VALOR) AS VALOR"
	cQuery+= " FROM"
	cQuery+= " ("
	cQuery+= " SELECT SUM(RC_VALOR) AS VALOR"
	cQuery+= " FROM " + RetSqlName("SRC") + " SRC"
	cQuery+= " WHERE SRC.RC_FILIAL = '" + SRA->RA_FILIAL + "'"
	cQuery+= " AND SRC.RC_MAT = '" + SRA->RA_MAT + "'"
	cQuery+= " AND SRC.RC_PERIODO = '" + cPer + "'"
	cQuery+= " AND SRC.RC_ROTEIR = '" + cRotRET + "'"
	cQuery+= " AND SRC.RC_PD IN (SELECT RV_COD FROM " + RetSqlName("SRV") + " WHERE D_E_L_E_T_ <> '*' AND RV_TIPOCOD = '1')"
	cQuery+= " AND SRC.D_E_L_E_T_ <> '*'"
	cQuery+= " UNION"
	cQuery+= " SELECT SUM(RD_VALOR) AS VALOR"
	cQuery+= " FROM " + RetSqlName("SRD") + " SRD"
	cQuery+= " WHERE SRD.RD_FILIAL = '" + SRA->RA_FILIAL + "'"
	cQuery+= " AND SRD.RD_MAT = '" + SRA->RA_MAT + "'"
	cQuery+= " AND SRD.RD_PERIODO = '" + cPer + "'"
	cQuery+= " AND SRD.RD_ROTEIR = '" + cRotRET + "'"
	cQuery+= " AND SRD.RD_PD IN (SELECT RV_COD FROM " + RetSqlName("SRV") + " WHERE D_E_L_E_T_ <> '*' AND RV_TIPOCOD = '1')"
	cQuery+= " AND SRD.D_E_L_E_T_ <> '*'"
	cQuery+= " ) AS A"

	//aviso("Query",cQuery,{'Ok'},,,,,.t.)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()

	If (cAliasQry)->(! EOF())
		nRet:= (cAliasQry)->VALOR
	EndIf

	restArea(aArea)

Return nRet
