#include 'protheus.ch'
#include 'parmtype.ch'

/**
* @author: Denar Terrazas Parada
* @since: 26/05/2021
* @description: Funcion que suma los valores de la SRC(Suma los ingresos y resta los descuentos).
*/
User Function SOMAINCSRV(aCampos, aFiltro)
	Local aArea         := getArea()
	Local nRet          := 0
	Local cAliasQry     := GetNextAlias()
	Local cWhere        := ""
	Local cQuery        := ""
	Local nX            := 1

	if( (Len(aCampos) > 0 .AND. Len(aFiltro) > 0) )
		for nX := 1 to Len(aCampos)
			cWhere+= " AND " + aCampos[nX] + " = '" + aFiltro[nx] + "'"
		next nX
	EndIf

	cQuery+= "SELECT"
	cQuery+= " (SELECT SUM(RC_VALOR)"
	cQuery+= " FROM " + RetSqlName("SRC") + " SRC"
	cQuery+= " WHERE RC_FILIAL = '" + SRA->RA_FILIAL + "'"
	cQuery+= " AND RC_MAT = '" + SRA->RA_MAT + "'"
	cQuery+= " AND RC_ROTEIR = 'FOL'"
	cQuery+= " AND RC_PD IN (SELECT RV_COD FROM " + RetSqlName("SRV") + " WHERE D_E_L_E_T_ <> '*' AND RV_TIPOCOD IN ('1', '3') " + cWhere + ")"
	cQuery+= " AND RC_PERIODO = '" + CPERIODO + "'"
	cQuery+= " AND SRC.D_E_L_E_T_ <> '*')"
	cQuery+= " -"
	cQuery+= " (SELECT SUM(RC_VALOR)"
	cQuery+= " FROM " + RetSqlName("SRC") + " SRC"
	cQuery+= " WHERE RC_FILIAL = '" + SRA->RA_FILIAL + "'"
	cQuery+= " AND RC_MAT = '" + SRA->RA_MAT + "'"
	cQuery+= " AND RC_ROTEIR = 'FOL'"
	cQuery+= " AND RC_PERIODO = '" + CPERIODO + "'"
	cQuery+= " AND RC_PD IN (SELECT RV_COD FROM " + RetSqlName("SRV") + " WHERE D_E_L_E_T_ <> '*' AND RV_TIPOCOD IN ('2', '4') " + cWhere + ")"
	cQuery+= " AND SRC.D_E_L_E_T_ <> '*')"
	cQuery+= " AS VALOR"

    //aviso("Query",cQuery,{'Ok'},,,,,.t.)
	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasQry, .F., .T.)
	dbSelectArea(cAliasQry)
	dbGoTop()

	If (cAliasQry)->(! EOF())
		nRet:= (cAliasQry)->VALOR
	EndIf

	restArea(aArea)

Return nRet
