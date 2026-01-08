#Include "Protheus.ch"

/*/{Protheus.doc} User Function GetFFBat
	(Extracción de valores)
	@type  Function
	@author wico2k
	@since 10/04/2021
	@version 1.0
	/*/

User Function GetFFBat(cSuc,cBien)
Local aArea	:= Getarea() 
Local nRet	:= ""
Local cSql	:= ""

cSql := " SELECT (SELECT MAX(TP_DTREAL) FROM " + RetSqlName("STP") + " WHERE TP_FILIAL = T9_FILIAL AND TP_CODBEM = T9_CODBEM) FFBAT "
cSql += " FROM "+ RetSqlName("ST9") +" ST9 "
cSql += " WHERE ST9.D_E_L_E_T_ = ' ' "
cSql += " AND T9_FILIAL = '"+cSuc+"'"
cSql += " AND T9_TEMCONT = 'P' "
cSql += " AND T9_CODFAMI LIKE 'BAT%' "
cSql += " AND T9_SITBEM = 'I' "
cSql += " AND T9_CODBEM = '"+cBien+"'"

cSql := ChangeQuery(cSql)

If Select('NextArea') > 0
	NextArea->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),'NextArea',.F.,.T.)   
dbSelectArea("NextArea")
dbGoTop()

If NextArea->(!Eof())
	nRet := SToD(NextArea->(FFBAT))
EndIf

NextArea->(dbCloseArea())
RestArea(aArea)

Return(nRet)
