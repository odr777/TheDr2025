#include 'protheus.ch'
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRODCOD	 ºAutor  ³Nicolas Duran 	 ºFecha ³  01/02/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Return the next product's code correlative 				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BASE BOLIVIA                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProdCod(cType,cGroup)

	Local aArea	:= GetArea()
	Local cQuery := ""
	Local _cRet		:= ""

	/*
	SELECT  MAX(SUBSTRING(B1_COD,7,9)) AS MAXSEQ 
FROM SB1010
WHERE B1_TIPO = 'SE'
  AND B1_GRUPO = 'RVIC'

	*/
	//Trae el codigo del Grupo de producto
	cFiltro:=alltrim(cType)+alltrim(GetAdvFVal("SBM","BM_UCODPRO",xFilial("SBM")+cGroup,1,""))
	//Alert(cFiltro2)
	//cFiltro := alltrim(cType)+alltrim(cGroup)

	nAumen := 6 - len(cFiltro)  ///cuantos caracteres falta por el espacio

	nInicia := 7 - nAumen  ///donde empieza el codigo

	nFinal := 5 + nAumen  ///donde termina el codigo
	
	cQuery := "SELECT MAX(SUBSTRING(B1_COD,"+ cvaltochar(nInicia) +", " + cvaltochar(nFinal) + ")) AS MAXSEQ  " 
	cQuery += " FROM " + RetSqlName("SB1") + " SB1 "
	cQuery += " WHERE B1_GRUPO = '" + cGroup + "' "
	cQuery += " AND SUBSTRING(B1_COD,"+ cvaltochar(nInicia) +", " + cvaltochar(nFinal) + ") NOT LIKE '%[A-Z]%' "
	
	TCQuery cQuery New Alias "QRYSB1"
	
	//Aviso("",cQuery,{'ok'},,,,,.t.)
	
	If Select("QRYSB1")>0
		QRYSB1->(dbCloseArea())
	End

	TcQuery cQuery New Alias "QRYSB1"

	    //// si tiene menos de 6 letras

	if empty(QRYSB1->MAXSEQ) .or. 	QRYSB1->MAXSEQ == nil
		_cRet := cFiltro + StrZero(0 + 1, 5 + nAumen)
	else
		nValCorr := quitZero(QRYSB1->MAXSEQ)
		nValCorr = val(nValCorr)
		_cRet := cFiltro + StrZero(nValCorr + 1, 5 + nAumen)
	endif
	
	QRYSB1->(dbCloseArea())
	RestArea(aArea)
	
return _cRet

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
