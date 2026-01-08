#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCustoObr บAutor   ณEDUAR ANDIA        บFecha ณ  04/10/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna la Cuenta (CT5_DEBITO / CT5_CREDIT)     			  บฑฑ
ฑฑบ          ณ cDebCrd - D: Debito / C: Credito                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Teledifusora\Argentina                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CContaCt5( cDebCrd, cLP, cSeq )
Local aArea 	:= GetArea()
Local cQuery 	:= ""
Local cConta	:= ""

Default cDebCrd	:= "D"

cQuery := " SELECT * "
cQuery += " FROM " + RetSqlName("CT5")
cQuery += " WHERE CT5_FILIAL = '" + xFilial("CT5") + "'"
cQuery += " 	AND CT5_LANPAD = '" + cLP  + "'"
cQuery += " 	AND CT5_SEQUEN = '" + cSeq + "'"
cQuery += " 	AND D_E_L_E_T_ <> '*' "

If Select("TRBCT5") > 0  //En uso
	TRBCT5->(DbCloseArea())
Endif
							
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS 'TRBCT5'
//DbUseArea( .T. ,"TOPCONN",TCGENQry(,,cQuery),'TRBCT5',.T.,.T.)
//DbSelectArea('TRBCT5')
   
If TRBCT5->(!Eof())
	If 	cDebCrd == "D"
		cConta := TRBCT5->CT5_DEBITO
		cConta := &(cConta)
	Elseif 	cDebCrd == "C"
			cConta := TRBCT5->CT5_CREDIT		
			cConta := &(cConta)
	Endif
  //	TRBCT5->(DbCloseArea())
Endif

If Type("cConta") <> "C"
	cConta := cValToChar(cConta)
Endif


RestArea(aArea)
Return(cConta)
