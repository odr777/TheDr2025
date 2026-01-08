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

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fo_SomaIncSrv   ³ Autor ³Tatiane Matias    ³ Data ³14/01/2005³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Soma Valores conforme Incidencias do SRV	  			     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³fo_SomaIncSrv ( @oObj )	    	   			                 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide parametros formais>									 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³Soma dos valores do campo passado em cCpoSoma        	     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Observa‡„o³                                                      	     ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso       ³Formulas		                                             ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
User Function XSomaIncSrv( oObj , cCpoSoma , uRvCpos , uRvCnts , cSrvFilial )
	Local nRet := 0
	Local nValor
	Local nX := 1
	Local lConsidera  
	Local cTIPOCOD

	oObj:GoTop()
	While (!oObj:EOF())
	 	//cMat 	:= oObj:GETVAL(CCPOMAT)
		cPd 	:= oObj:GETVAL(CCPOPD)
		nValor 	:= oObj:GETVAL(CCPOVALOR)

		lConsidera := .T.
		if( (Len(uRvCpos) > 0 .AND. Len(uRvCnts) > 0) )
			for nX := 1 to Len(uRvCpos)
				xVal := GETADVFVAL("SRV", uRvCpos[nX], XFILIAL("SRV") + cPd,1,0) 
				if xVal <> uRvCnts[nx]
					lConsidera := .F.
				EndIf
			next nX
		EndIf
		
		IF lConsidera
			cTIPOCOD  := GETADVFVAL("SRV", "RV_TIPOCOD", XFILIAL("SRV") + cPd,1,0)
			IF cTIPOCOD = "1" .OR. cTIPOCOD = "3"
				nRet += nValor
			ELSEIF cTIPOCOD = "2" .OR. cTIPOCOD = "4"
				nRet -= nValor
			EndIF
		ENDIF
		oObj:Skip()
	 End
Return (nRet)
