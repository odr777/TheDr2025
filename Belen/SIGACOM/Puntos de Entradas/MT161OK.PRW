#include 'protheus.ch'
#include 'parmtype.ch'
#Include "Topconn.ch"
#INCLUDE 'RWMAKE.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT161OK  ºAutor  ³Denar Terrazas TdeP ºFecha ³ 11/04/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Punto de Entrada para validacion TUDOOK-Analiza cotizacion º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Casa Grande                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT161OK()
	Local _lRet:= .T.
	Local cNumSc	:= SC1->C1_NUM
	
	If GETNEWPAR("MV_UANTCOM", "N") = 'N'
		Return _lRet
	EndIf

	If Alltrim(FUNNAME()) == 'MATA161'	//Analiza Cotizacion
		
		_lRet:= existAnt(cNumSc)
		
		if(!_lRet)
			alert("El proyecto no cuenta con anticipo, notificar al gerente de proyecto")
		endif
	EndIf

Return(_lRet)

static function existAnt(cNum)
	Local _cQuery
	Local cAnticip
	Local lExiste := .F.

	_cQuery := "select E1_TIPO"
	_cQuery += " From " + RetSqlName("SE1") + " SE1"
	_cQuery += " Join " + RetSqlName("AFT") + " AFT" + " on SE1.E1_NUM = AFT.AFT_NUM"
	_cQuery += " where AFT.AFT_PROJET = (select AFG_PROJET from AFG010 AFG where AFG_NUMSC = '" + cNum + "' group by AFG_PROJET)"
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
