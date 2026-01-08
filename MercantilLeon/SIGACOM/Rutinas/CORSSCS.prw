#Include "rwmake.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºProgram   ³CORSSCSºAuthor ³Erick etcheverry    º Date ³  12/17/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Trae correlativo de transferencia, crear serie por cada suc³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUse       ³ por cada serie UNION 	                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CORSSCS()///////13
	Local _cRet		:= ""
	Local _aArea	:= GetArea()
	Local _cQuery	:= ""

	cFiltro := "S"

	if alltrim(funname()) $ "MATA110"

		_cQuery := " SELECT MAX(SUBSTRING(C1_NUM,2,5)) AS MAXSEQ "
		_cQuery += " FROM " + RetSqlName("SC1") + " SC1 "
		_cQuery += " WHERE "  /////DIFERENTE DE IMPORTACION
		_cQuery += " C1_NUM LIKE '%" + cFiltro +"%' "
		_cQuery += " AND C1_FILIAL LIKE '%" + xfilial("SC1") +"%' "
		_cQuery += " AND SUBSTRING(C1_NUM,2,5)  NOT LIKE '%[A-Z]%' "

		//Aviso("",_cQuery,{'ok'},,,,,.t.)

		If Select("strSQL") > 0
			strSQL->(dbCloseArea())
		End

		TcQuery _cQuery New Alias "strSQL"


		if empty(strSQL->MAXSEQ) .or. 	strSQL->MAXSEQ == nil
			_cRet := cFiltro + StrZero(0 + 1, 5)
		else
			nValCorr := quitZero(strSQL->MAXSEQ)
			nValCorr = val(nValCorr)
			_cRet := cFiltro + StrZero(nValCorr + 1, 5)
		endif

	endif

	RestArea(_aArea)
Return _cRet

static Function quitZero(cTexto)
	private aArea     := GetArea()
	private cRetorno  := ""
	private lContinua := .T.

	cRetorno := Alltrim(cTexto)

	While lContinua

		If SubStr(cRetorno, 1, 1) <> "0" .Or. Len(cRetorno) ==0
			lContinua := .f.
		EndIf

		If lContinua
			cRetorno := Substr(cRetorno, 2, Len(cRetorno))
		EndIf
	EndDo

	RestArea(aArea)

Return cRetorno
