#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"

/*
Nahim Terrazas 17/02/2020
Obtiene el nro de serie correlativo
*/

user function corserun()

	Local cQuery	:= ""
	local cNextBatch := ""
	//	alert(M->DB_PRODUTO)
	//	alert(SH6->H6_PRODUTO)
	//	 alert(SH6->H6_PRODUTO)
	cTipoProd:=  GetAdvFVal("SB1","B1_TIPO",xFilial("SB1")+SH6->H6_PRODUTO,1,"0")
	cCodTip := cTipoProd + SUBSTR(cvaltochar(YEAR(ddatabase)),3,2)
//	alert(cTipoProd)
	If Select("QRYSN1") > 0  //En uso
		QRYSN1->(DbCloseArea())
	End

	cQuery := " SELECT "
	cQuery += "   CONCAT(LEFT(substring(MAX(DB_NUMSERI), 1, 10), 11 - len(substring(MAX(DB_NUMSERI), 4, 16) + 1)) , substring(MAX(DB_NUMSERI), 4, 16) + 1) CORRELA "
	cQuery += " FROM "
	cQuery += "   SDB010 "
	cQuery += "WHERE"
	cQuery += "   DB_NUMSERI LIKE ('" +cCodTip + "%') "
	cQuery += "   AND D_E_L_E_T_ LIKE ''"

	TCQuery cQuery New Alias "QRYSN1"

//	Aviso("",cQuery,{'ok'},,,,,.t.)
	cNextBatch := QRYSN1->CORRELA
	if empty(cNextBatch) // NTP 29/11/2019 - Imprime si
		cNextBatch =  cCodTip+ STRZERO(1, 7, 0)
//		alert(cNextBatch)
	endif
	public cNroSeUni := cNextBatch
//	QRYSN1->(DbCloseArea())
return cNextBatch