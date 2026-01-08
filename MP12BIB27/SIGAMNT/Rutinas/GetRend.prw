#Include "Protheus.ch"

/*/{Protheus.doc} User Function GetRend
	(Extracción de valores)
	@type  Function
	@author wico2k
	@since 10/04/2021
	@version 1.0
	/*/

User Function GetRend(cSuc,cBien)
Local aArea	:= Getarea() 
Local nRet	:= 0
Local cSql	:= ""

cSql := " SELECT (SELECT MAX(TP_POSCONT) FROM " + RetSqlName("STP") + " WHERE D_E_L_E_T_ = ' ' AND TP_FILIAL = T9_FILIAL AND TP_CODBEM = T9_CODBEM) - "
cSql += " (SELECT TP_POSCONT FROM " + RetSqlName("STP") + " WHERE D_E_L_E_T_ = ' ' AND TP_FILIAL = T9_FILIAL AND TP_CODBEM = T9_CODBEM AND TP_TIPOLAN = 'I') REND "
cSql += " FROM "+ RetSqlName("ST9") +" ST9 "
cSql += " WHERE ST9.D_E_L_E_T_ = ' ' "
cSql += " AND T9_FILIAL = '"+cSuc+"'"
cSql += " AND T9_TEMCONT = 'P' "
cSql += " AND T9_CODFAMI LIKE 'NEU%' "
cSql += " AND T9_CODBEM = '"+cBien+"'"

cSql := ChangeQuery(cSql)

If Select('NextArea') > 0
	NextArea->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),'NextArea',.F.,.T.)   
dbSelectArea("NextArea")
dbGoTop()

If NextArea->(!Eof())
	nRet := NextArea->(REND)
EndIf

NextArea->(dbCloseArea())
RestArea(aArea)

Return(nRet)
