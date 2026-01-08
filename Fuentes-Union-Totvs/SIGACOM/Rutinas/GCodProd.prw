#Include "rwmake.ch"
#include "Topconn.ch"

User Function GCodProd()
	Local _cRet		:= ""
	Local _aArea	:= GetArea()
	Local _cQuery	:= ""

	_cQuery := " SELECT MAX(B1_COD) AS MAXSEQ "
	_cQuery += " FROM " + RetSqlName("SB1") + " SB1 "
	_cQuery += " WHERE SB1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ISNUMERIC(B1_COD) = 1 "

	If Select("strSQL")>0
		strSQL->(dbCloseArea())
	End

	TcQuery _cQuery New Alias "strSQL"

	If !Empty(strSQL->MAXSEQ)
		_cRet := StrZero(Val(strSQL->MAXSEQ) + 1, 6)
	Endif

	RestArea(_aArea)
Return _cRet
