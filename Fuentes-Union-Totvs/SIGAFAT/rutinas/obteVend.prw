#Include "TopConn.ch"
#include 'protheus.ch'
#INCLUDE "TOTVS.CH"
#include 'parmtype.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OBTbanc  ºAutor ³TdeP Horeb SRL º Data ³  10/07/2019        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
A±ºDesc.     ³funcion que obtiene el cobrador según el usuario			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB -UNION											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER Function obteVend(cCodUsr) // trae codigo de Cobrador AQ_UCODUSR
	Local cQryAux := ""
	Local cRet := ""
	Local aRet := {}

	cQryAux := ""
	cQryAux += " SELECT A3_FILIAL, A3_COD, A3_USERIEF FROM " + RetSqlName("SA3") + " SA3 WHERE D_E_L_E_T_ = ' ' AND A3_CODUSR LIKE '%" + AllTrim(cCodUsr) + "%' "

	cQryAux := ChangeQuery(cQryAux)

	TCQuery cQryAux New Alias "QRY_AUX"

	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		cRet := QRY_AUX->(A3_COD)
		aRet := {}
		AADD(aRet, cRet)
		AADD(aRet, QRY_AUX->(A3_FILIAL))
		AADD(aRet, QRY_AUX->(A3_USERIEF))
		AADD(aRet, .T.)

		QRY_AUX->(dbSkip())
	EndDo
	if Empty(aRet)
		AADD(aRet, .F.)
	endif
	QRY_AUX->(dbCloseArea())

Return aRet