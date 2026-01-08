#include 'protheus.ch'
#include 'parmtype.ch'
#Include "rwmake.ch"
#include "Topconn.ch"

user function SERMOVIN(cTm)
	Local cSerTran := ""

	if !empty(cTm)
		IF UPPER(funname()) $ 'MATA241'
			cTipo := POSICIONE('SF5',1,XFILIAL('SF5')+ cTm,'F5_TIPO')

			if alltrim(cTipo) == 'D' // ENTRADA
				cSerTran := CORSERTRA("PE",cTm)
			endif
			if alltrim(cTipo) == 'R' // SALIDA
				cSerTran := CORSERTRA("VC",cTm)
			endif

		ENDIF
	endif
return cSerTran

static function CORSERTRA(cTit,cTm)///////13
	Local _cRet		:= ""
	Local _aArea	:= GetArea()
	Local _cQuery	:= ""

	cFiltro := cTit + cTm

	_cQuery := " SELECT MAX(SUBSTRING(D3_DOC,6,18)) AS MAXSEQ "
	_cQuery += " FROM " + RetSqlName("SD3") + " SD3 "
	_cQuery += " WHERE "
	_cQuery += " D3_DOC LIKE '%" + cFiltro +"%' "

	//Aviso("",_cQuery,{'ok'},,,,,.t.)

	If Select("strSQL")>0
		strSQL->(dbCloseArea())
	End

	TcQuery _cQuery New Alias "strSQL"

	if empty(strSQL->MAXSEQ) .or. 	strSQL->MAXSEQ == nil
		_cRet := cFiltro + StrZero(1, 13)
	else
		nValCorr := quitZero(strSQL->MAXSEQ)
		nValCorr = val(nValCorr)
		_cRet := cFiltro + StrZero(nValCorr + 1, 13)
	endif

	/*if valtype(strSQL->MAXSEQ) == 'N'
	if strSQL->MAXSEQ == 0
	_cRet := cFiltro + StrZero(strSQL->MAXSEQ + 1, 13)
	else
	_cRet := cFiltro + StrZero(strSQL->MAXSEQ + 1, 13)
	endif
	ELSE
	if Val(strSQL->MAXSEQ) == 0
	_cRet := cFiltro + StrZero(Val(strSQL->MAXSEQ) + 1, 13)
	else
	_cRet := cFiltro + StrZero(Val(strSQL->MAXSEQ) + 1, 13)
	endif
	ENDIF*/

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