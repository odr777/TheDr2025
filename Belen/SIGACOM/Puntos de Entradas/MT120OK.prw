#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"
#INCLUDE 'RWMAKE.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120OK  ºAutor  ³Denar Terrazas(TdeP ºFecha ³ 04/04/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada para validacion TUDOOK -Pedido de Compras º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Casa Grande                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120OK()
	Local _lRet:= .T.
	Local _lRet:= .T.
	/*
	Local _lRet:= .T.
	Local cNumPc	:= SC7->C7_NUM
	Local nItem		:= aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEM"})

	//If Alltrim(FUNNAME()) == 'MATA110'	//Solicitud de Compra
	//EndIf
	
	If GETNEWPAR("MV_UANTCOM", "N") = 'S'
		Return _lRet
	EndIf

	If Alltrim(FUNNAME()) == 'MATA121'	//Pedidos de Compra

		//		Aviso("query",U_zArrToTxt(aCols,,),{"si"})
		//		Aviso("query",U_zArrToTxt(aRatAJ7,,),{"si"})
		//		alert(len(aRatAJ7))
		//		alert(aRatAJ7[1,1])
		//		alert(aRatAJ7[1,2][1][1])

		//		alert(AJ7->AJ7_PROJET)

		if len(aRatAJ7) > 0 .and. len(acols) > 0
			For nI:= 1 to Len(aCols)
				cItem:= acols[nI][nItem]
				For nX := 1 to Len(aRatAJ7)
					if cItem == aRatAJ7[nX,1]
						_lRet:= existAnt(aRatAJ7[nX,2][1][1])
					endif
				Next nX
			next nI
			if(!_lRet)
				alert("El proyecto no cuenta con anticipo, notificar al gerente de proyecto")
			endif
		endif
	EndIf
	*/
Return(_lRet)

static function existAnt(cProj)
	Local _cQuery
	Local cAnticip
	Local lExiste := .F.

	_cQuery := "select E1_TIPO"
	_cQuery += " From " + RetSqlName("SE1") + " SE1"
	_cQuery += " Join " + RetSqlName("AFT") + " AFT" + " on SE1.E1_NUM = AFT.AFT_NUM"
	_cQuery += " where AFT.AFT_PROJET = '" + cProj + "'"
	_cQuery += " And SE1.D_E_L_E_T_ <> '*' "
	_cQuery += " And AFT.D_E_L_E_T_ <> '*' "

	//	Aviso("",_cQuery,{'ok'},,,,,.t.)

	If Select("StrSQL") > 0  //En uso
		StrSQL->(DbCloseArea())
	End

	TcQuery _cQuery New Alias "StrSQL"

	cAnticip := alltrim(StrSql->E1_TIPO)

	if(cAnticip == 'RA')
		lExiste := .T.
	endif

return lExiste