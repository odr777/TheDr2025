
#include "Topconn.ch"

/*/{Protheus.doc} User Function MaxSE5Co
    Nahim obtiene el mayor para sumar el correlativo utilizado en movimientos bancarios

    @type  Function
    @author Nahim Terrazas
    @since 10/09/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MaxSE5Co()

	Local _cRet		:= ""
	Local _aArea	:= GetArea()
	Local _cQuery	:= ""

	// cFiltro := ""// + xfilial("SF2")//filial mas Serie

	_cQuery := " SELECT MAX(E5_XCORREL) AS MAXSEQ "
	_cQuery += " FROM " + RetSqlName("SE5") + " SE5 "
	_cQuery += " WHERE D_E_L_E_T_ LIKE ''"

		// Aviso("",_cQuery,{'ok'},,,,,.t.)

	If Select("strSQL")>0
		strSQL->(dbCloseArea())
	End

	TcQuery _cQuery New Alias "strSQL"

	if empty(strSQL->MAXSEQ) .or. 	strSQL->MAXSEQ == nil
		_cRet := StrZero(0 + 1, 7)
	else
		nValCorr := quitZero(strSQL->MAXSEQ)
		nValCorr = val(nValCorr)
		_cRet := StrZero(nValCorr + 1, 7)
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
