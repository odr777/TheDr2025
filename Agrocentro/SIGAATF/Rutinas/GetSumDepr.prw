#include "rwmake.ch"
#include "topconn.ch"

/*/{Protheus.doc} GetSumDepr
	(Sumatoria Total de las depreaciaciones realizadas mediante la rutina ATFA050.)
	@type  User Function
	@author Jim Bravo
	@since 13/06/2023
	@version 1.0
/*/
User Function GetSumDepr()
	Local cQuery	:=	""
	Local nRet		:=	0
	Local _aArea	:=	GetArea()
						
	cQuery := " SELECT SUM(N4_VLROC1) SUMDEPR FROM  " + RETSQLNAME("SN4") + " SN4 " 
	cQuery += " WHERE SN4.D_E_L_E_T_ = ' ' AND N4_OCORR = '06' AND N4_TIPOCNT = '3' AND N4_ORIGEM = 'ATFA050' "
	cQuery += " AND N4_CBASE = '" + SN4->N4_CBASE + "' AND N4_ITEM = '" + SN4->N4_ITEM + "'"
	
	If SELECT("nSumDepr") > 0
		nSumDepr->(dbCloseArea())
	End 

	TcQuery cQuery New Alias "nSumDepr"            

	If !Empty(nSumDepr->SUMDEPR) 
		nRet := nSumDepr->SUMDEPR
	End

	RestArea(_aArea)

Return nRet
