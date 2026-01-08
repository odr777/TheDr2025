#Include "TopConn.ch"
#include 'protheus.ch'
#INCLUDE "TOTVS.CH"
#include 'parmtype.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OBTbanc  ºAutor ³TdeP Horeb SRL º Data ³  21/12/2019        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
A±ºDesc.     ³funcion que obtiene el banco según el usuario				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP12BIB -UNION											  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


user Function obtBanc(cCodUsr) // trae codigo de Cobrador AQ_UCODUSR
	Local cQryAux := ""
	Local cRet := ""
	Local aRet := {}

	cQryAux := ""
	cQryAux += " SELECT A6_COD, A6_AGENCIA,A6_NUMCON,A6_MOEDA FROM " + RetSqlName("SA6") + " SA6 WHERE D_E_L_E_T_ = ' ' AND A6_UCUSR LIKE '%" + AllTrim(cCodUsr) + "%' ORDER BY A6_MOEDA DESC"

//	Aviso("query",cvaltochar(cQryAux),{"si"},,,,,.T.)
	cQryAux := ChangeQuery(cQryAux)

	TCQuery cQryAux New Alias "QRY_AUX"
	
	aRet := {}
	QRY_AUX->(DbGoTop())
	While QRY_AUX->(!Eof())
//		alert("pasa")
		AADD(aRet, QRY_AUX->(A6_COD))
		AADD(aRet, QRY_AUX->(A6_AGENCIA))
		AADD(aRet, QRY_AUX->(A6_NUMCON))
		AADD(aRet, QRY_AUX->(A6_MOEDA))
		QRY_AUX->(dbSkip())
	EndDo
	QRY_AUX->(dbCloseArea())

Return aRet
