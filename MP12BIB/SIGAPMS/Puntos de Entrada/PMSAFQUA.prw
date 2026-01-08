#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"

user function PMSAFQUA(_cProy,_cTask,cRevisa)
	Local aArea := GetArea()
	Local cQuery
	Local nNumero
	
	cQuery := " SELECT AFF_QUANT "
	cQuery += " From " + RetSqlName("AFF") + " AFF,"
	cQuery += " ("
	cQuery += " SELECT MAX(AFF_DATA) AS AFF_DATA "
	cQuery += " From " + RetSqlName("AFF") + " AFF"
	cQuery += " Where D_E_L_E_T_ <> '*' "
	cQuery += " AND AFF_PROJET LIKE  '" + _cProy + "'"
	cQuery += " AND AFF_TAREFA LIKE  '" + _cTask + "'"
	cQuery += " AND AFF_REVISA LIKE  '" + cRevisa + "'"
	cQuery += " ) as AFF2"
	cQuery += " Where D_E_L_E_T_ <> '*' AND AFF.AFF_DATA = AFF2.AFF_DATA"
	cQuery += " AND AFF_PROJET LIKE  '" + _cProy + "'"
	cQuery += " AND AFF_TAREFA LIKE  '" + _cTask + "'"
	cQuery += " AND AFF_REVISA LIKE  '" + cRevisa + "'"
	cQuery += " AND AFF.D_E_L_E_T_<>'*' "
	//		Aviso("",cQuery,{"Ok"},,,,,.T.)
	If Select("SQ") > 0  //En uso
		SQ->(DbCloseArea())
	End

	TcQuery cQuery New Alias "SQ"
	dbSelectArea("SQ")
	dbGoTop()
	nNumero := SQ->AFF_QUANT
	RestArea(aArea)

return nNumero