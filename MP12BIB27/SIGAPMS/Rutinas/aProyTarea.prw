#Include "PROTHEUS.CH"
#Include 'RWMAKE.CH'
#Include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณaProyTareaบAutor  ณEDUAR ANDIA         บFecha ณ  15/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que retorna um Array com o Codigo do Projeto/Tarefa บฑฑ
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ INESCO.                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function aProyTarea(cItemCta)
Local aArea		:= GetArea()
Local aRet 	 	:= {}
Local cQuery 	:= ""

cQuery := "SELECT AF8_PROJET,AF9_TAREFA,AF8_REVISA"
cQuery += " FROM " + RetSqlName("AF8") + " AF8, " + RetSqlName("AF9") + " AF9"
cQuery += " WHERE AF8_FILIAL = '" + xFilial("AF8") + "'"
cQuery += " AND AF9_FILIAL = '"   + xFilial("AF9") + "'"
cQuery += " AND AF9_ITEMCC = '"   + cItemCta + "'"
cQuery += " AND AF9_PROJET = AF8_PROJET AND AF9_REVISA = AF8_REVISA"
cQuery += " AND AF8.D_E_L_E_T_<> '*' AND AF9.D_E_L_E_T_<> '*'"
cQuery := ChangeQuery(cQuery)
				
If Select("StrSQL") > 0  //En uso
	StrSQL->(DbCloseArea())
Endif
dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")
dbGoTop()
If !Empty(StrSQL->(AF8_PROJET))
	AADD(aRet,StrSQL->(AF8_PROJET))
	AADD(aRet,StrSQL->(AF9_TAREFA))
	AADD(aRet,StrSQL->(AF8_REVISA))	
Else
	aRet := {"","",""}
Endif
StrSQL->(dbCloseArea())
RestArea(aArea)
Return(aRet)