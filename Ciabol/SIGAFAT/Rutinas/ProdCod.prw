#include 'protheus.ch'
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRODCOD	 บAutor  ณNicolas Duran 	 บFecha ณ  01/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Return the next product's code correlative 				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BASE BOLIVIA                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ProdCod(cType,cGroup)
	/* Returns B1_TIPO+B1_GRUPO+CORRELATIVE (the correlative is 4 chars lenght)*/
	Local aArea	:= GetArea()
	Local cQuery := ""
	Local cNextBatch := ""
	
	cQuery := "SELECT CONCAT( " 
	cQuery += " (SELECT TOP 1 SUBSTRING(B1_COD, 1, CASE WHEN LEN(B1_COD) - 4 < 0 THEN 0 ELSE LEN(B1_COD) - 4 END) FROM SB1010 WHERE B1_TIPO = '" + cType + "' AND B1_GRUPO = '" + cGroup + "'), "
	cQuery += " REPLACE(STR( MAX(CASE WHEN PATINDEX('%[^0-9]%', RTRIM(B1_COD)) = 0 THEN RTRIM(B1_COD) ELSE RIGHT(RTRIM(B1_COD), PATINDEX('%[^0-9]%',REVERSE(RTRIM(B1_COD))) - 1) END) + 1, 4), SPACE(1), '0') "
	cQuery += " ) B1_COD "
	cQuery += " FROM " + RetSqlName("SB1") + " SB1 "
	cQuery += " WHERE B1_TIPO = '" + cType + "' AND B1_GRUPO = '" + cGroup + "' "
	
	TCQuery cQuery New Alias "QRYSB1"
	
	//	Aviso("",cQuery,{'ok'},,,,,.t.)
	
	if !QRYSB1->(EoF())
		cNextBatch := QRYSB1->B1_COD
	
		if empty(cNextBatch)
			cNextBatch := ""
		endif
	endif
	
	QRYSB1->(dbCloseArea())
	RestArea(aArea)
	
return cNextBatch