#include 'protheus.ch'
#include 'parmtype.ch'
#include "Topconn.ch"

/*/{Protheus.doc} User Function PLACAINI
	(Obtener N1_CHAPA)
	@type  Function
	@author wico2k
	@since 06/05/2021
	@version 1.2
	/*/

User Function PlacaIni(cGroup)

Local aArea	:= Getarea() 
Local cRet	:= ""
Local cSql	:= ""
Local nLar  := 0
Local cUlt  := ""

// Primero obtener el largo de la parte numérica
cSql := " SELECT LEN(MAX(N1_CHAPA))-(SELECT LEN(NG_UCDCHAP) FROM " + RetSqlName("SNG") + " WHERE NG_GRUPO = '" + cGroup + "') LARGO"
cSql += " FROM " + RetSqlName("SN1") "
cSql += " WHERE  D_E_L_E_T_ = ' ' "
cSql += " AND N1_GRUPO = '" + cGroup + "' "

cSql := ChangeQuery(cSql)

If Select('NextArea') > 0
	NextArea->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),'NextArea',.F.,.T.)   
dbSelectArea("NextArea")
dbGoTop()

If NextArea->(!Eof())
	nLar := NextArea->(LARGO)
	If nLar = 0
		nLar := 3
	EndIf
EndIf

NextArea->(dbCloseArea())
RestArea(aArea)

//Segundo obtener el último correlativo vigente
cSql := ""

cSql := " SELECT RIGHT(TRIM(MAX(N1_CHAPA))," + Str(nLar) + " ) ULTIMO"
cSql += " FROM " + RetSqlName("SN1") "
cSql += " WHERE  D_E_L_E_T_ = ' ' "
cSql += " AND N1_GRUPO = '" + cGroup + "' "

cSql := ChangeQuery(cSql)

If Select('NextArea') > 0
	NextArea->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),'NextArea',.F.,.T.)   
dbSelectArea("NextArea")
dbGoTop()

If NextArea->(!Eof())
	cUlt := Val(NextArea->(ULTIMO)) + 1
EndIf

NextArea->(dbCloseArea())
RestArea(aArea)

//Tercero obtener caracteres
cSql := ""

cSql := " SELECT TRIM(NG_UCDCHAP) NG_UCDCHAP FROM " + RetSqlName("SNG") + " WHERE NG_GRUPO = '" + cGroup + "' AND D_E_L_E_T_ = ' ' "

If Select('QRYSNG') > 0
	QRYSNG->(DbCloseArea())
EndIf

TCQuery cSql New Alias "QRYSNG"

cRet := RTrim(QRYSNG->NG_UCDCHAP) + StrZero(cUlt, nLar)
If Empty(cRet) 
	Alert("Inconsistencia entre los valores del campo NG_UCDCHAP y N1_CHAPA del Grupo utilizado.")
EndIf

Return(cRet)
