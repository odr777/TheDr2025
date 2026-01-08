#Include "rwmake.ch"
#include "Topconn.ch"

User Function GCodProv()
Local _cRet		:= ""
Local _aArea	:= GetArea()
Local _cQuery	:= ""
                                          
_cQuery := " SELECT MAX(A2_COD) AS MAXSEQ "
_cQuery += " FROM " + RetSqlName("SA2") + " SA2 "
_cQuery += " WHERE SA2.D_E_L_E_T_ = ' ' "
_cQuery += " AND A2_COD NOT IN ('MARKAS','EASY') "

If Select("strSQL")>0
	strSQL->(dbCloseArea())
End 

TcQuery _cQuery New Alias "strSQL"            

If !Empty(strSQL->MAXSEQ) 
	_cRet := StrZero(Val(strSQL->MAXSEQ) + 1, 6)
End

RestArea(_aArea)
Return _cRet