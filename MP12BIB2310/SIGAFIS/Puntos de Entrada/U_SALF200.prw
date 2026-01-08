#include 'protheus.ch'
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  SALF200  บAutor  ณOmar Delgadillo บFecha ณ  01/09/2022       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPunto de Entrada para traer el saldo desde la contabilidad  บฑฑ
ฑฑบ          ณpara el formulario 200									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP12BIB27                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user function SALF200()
    Local cPeriodo  := paramixb[1]
    Local aFiliais  := paramixb[2]
    Local cCuenta   := Posicione("SZB",1,xFilial("SZB")+"FIS"+"001","ZB_CONTA") // "1010502001" // Cuenta de Cr้dito Fiscal
    Local nSaldoCF  := 0
    Local nI        := 0
    Local cQry      := ""

	//Query
	cQry := " SELECT (SUM(CQ0.CQ0_DEBITO)-SUM(CQ0.CQ0_CREDIT)) SALDO"
	cQry += " FROM CQ0010 CQ0"
	cQry += " WHERE CQ0.D_E_L_E_T_ = ' '"
	cQry += " AND ( CQ0.CQ0_FILIAL = '" + Space(TamSX3("CQ0_FILIAL")[1]) +"'"
	For nI:=1 To Len(aFiliais)
		If aFiliais[nI,1]
			cQry += " OR CQ0.CQ0_FILIAL = '"+aFiliais[nI,2]+"'"
		EndIf
	Next nI
	cQry += " )"
	cQry += " AND CQ0.CQ0_DATA < '" + cPeriodo + "'"
	cQry += " AND CQ0.CQ0_CONTA = '" + cCuenta + "'"

	TcQuery cQry New Alias "QRY"

	dbSelectArea("QRY")
	if QRY->(!EOF())
		nSaldoCF := QRY->SALDO
    ENDIF
	QRY->(dbCloseArea())
RETURN nSaldoCF
