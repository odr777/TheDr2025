#Include "Protheus.ch"
#Include "Topconn.ch"  

#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DifCBco  ºAutor  ³EDUAR ANDIA			º Data ³ 28/08/2019   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica Diferencia Cambiaria T.C. de la Transf. Bancaria  º±±
±±º          ³ vs T.C. Actual (SM2)                            		      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bolivia \ Belén 		                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DifCBco(lRev)
Local aArea 	:= GetArea()
Local aAreaSA6	:= SA6->(GetArea())
Local nVlrDia	:= 0
Local nVlrMov	:= 0
Local nDifCmb	:= 0
Local aTxMda	:= {}
Default lRev	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ De Moeda 1 (Bs) a Moeda 2 (Usd)		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA6->(DbSetOrder(1))
If SA6->(DbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
	If SA6->A6_MOEDA ==2
		If SE5->E5_TXMOEDA <> RecMoeda(SE5->E5_DTDIGIT,2)
			nVlrDia := xMoeda(SE5->E5_VALOR,SA6->A6_MOEDA,1,SE5->E5_DTDIGIT,4,RecMoeda(SE5->E5_DTDIGIT,2))	//6.96
			nVlrMov := xMoeda(SE5->E5_VALOR,SA6->A6_MOEDA,1,SE5->E5_DTDIGIT,4,SE5->E5_TXMOEDA)				//6.97
			nDifCmb := nVlrMov - nVlrDia
			
			__cMsg := "nVlrDia: "+AllTrim(Str(nVlrDia))+ CRLF
			__cMsg += "nVlrMov: "+AllTrim(Str(nVlrMov))+ CRLF
			__cMsg += "nDifCmb: "+AllTrim(Str(nDifCmb))+ CRLF
			//Aviso("DifCBco", __cMsg,{"OK"})			
		Endif
	Endif
	
	If SA6->A6_MOEDA ==1 .AND. SE5->E5_RECPAG=="R"
		
		aTxMda := U_TxMoeOrig()
		If aTxMda[1]==2
			If RecMoeda(SE5->E5_DTDIGIT,2) <> aTxMda[2]
				nVlrDia := xMoeda(SE5->E5_VALOR,SA6->A6_MOEDA,1,SE5->E5_DTDIGIT,4,RecMoeda(SE5->E5_DTDIGIT,2))	//6.96
				nVlrMov := xMoeda(SE5->E5_VALOR,SA6->A6_MOEDA,1,SE5->E5_DTDIGIT,4,aTxMda[2])					//6.97
				nDifCmb := nVlrMov - nVlrDia
				
				__cMsg := "nVlrDia: "+AllTrim(Str(nVlrDia))+ CRLF
				__cMsg += "nVlrMov: "+AllTrim(Str(nVlrMov))+ CRLF
				__cMsg += "nDifCmb: "+AllTrim(Str(nDifCmb))+ CRLF
				//Aviso("DifCBco", __cMsg,{"OK"})
			Endif 
		Endif
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ É Mov.Bancario Rev.?			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If U_lTrfRev() .AND. lRev
	nDifCmb := nDifCmb * -1
Endif

SA6->(RestArea(aAreaSA6))
RestArea(aArea)
Return(nDifCmb)


User Function TxMoeOrig()
Local __aArea 		:= GetArea()
Local __aAreaSE5	:= SE5->(GetArea())
Local cNumero		:= SubStr(SE5->E5_DOCUMEN,1,TamSX3("E5_NUMCHEQ")[1])
Local nTxMoe		:= 0
Local aRet 			:= {0,0,0}
Local cQuery 		:= ""

cQuery := "SELECT E5_FILIAL,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,E5_TIPODOC,E5_VALOR,A6_MOEDA,E5_TXMOEDA,E5_DTDIGIT"
cQuery += " FROM " + RetSqlName("SE5") + " SE5, "+RetSqlName("SA6")+ " SA6"   				
cQuery += " WHERE E5_ORIGEM = 'FINA100 '"
cQuery += " AND E5_TIPODOC  = 'TR'"
cQuery += " AND E5_RECPAG 	= 'P'"
cQuery += " AND E5_NUMCHEQ 	= '" + cNumero + "'"
cQuery += " AND E5_PROCTRA <> ' ' "
cQuery += " AND A6_COD=E5_BANCO AND A6_AGENCIA=E5_AGENCIA AND A6_NUMCON=E5_CONTA"
cQuery += " AND SE5.D_E_L_E_T_ <> '*' AND SA6.D_E_L_E_T_ <> '*'"
cQuery := ChangeQuery(cQuery)

//Aviso("cQuery1",cQuery,{"OK"},,,,,.T.)	
If Select("StrSQL") > 0  //En uso
	StrSQL->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"StrSQL", .F., .T.)
If !Empty(StrSQL->(E5_NUMCHEQ))

	If StrSQL->(A6_MOEDA)==2
		nTxMoe := StrSQL->(E5_TXMOEDA)
	Else
		nTxMoe := RecMoeda(StrSQL->(E5_DTDIGIT),2)
	Endif
					
	aRet := {StrSQL->(A6_MOEDA),nTxMoe,StrSQL->(E5_VALOR)}
Endif
				
StrSQL->(dbCloseArea())

SE5->(RestArea(__aAreaSE5))
RestArea(__aArea)
Return(aRet)


User Function lTrfRev
Local __aArea 		:= GetArea()
Local cNumero		:= AllTrim(SE5->E5_NUMCHEQ+SE5->E5_DOCUMEN)
Local cQuery 		:= ""
Local lRet 			:= .F.

cQuery := "SELECT COUNT(*) QTD FROM  " + RetSqlName("SE5")+ " SE5"
cQuery += " WHERE '" + cNumero +"' IN (E5_DOCUMEN,E5_NUMCHEQ) "
cQuery += " AND E5_TIPODOC = 'TR' "
cQuery += " AND E5_DATA = '" +DTOS(SE5->E5_DATA) + "'"
cQuery += " AND SE5.D_E_L_E_T_ <> '*' "

//Aviso("cQuery1",cQuery,{"OK"},,,,,.T.)	
cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0  //En uso
	StrSQL->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"StrSQL", .F., .T.)
//Alert(StrSQL->(QTD)) //<------------
lRet := StrSQL->(QTD) > 2
StrSQL->(dbCloseArea())

RestArea(__aArea)
Return(lRet)

User Function TxMoe2Ori()
Local __aArea 		:= GetArea()
Local __aAreaSE5	:= SE5->(GetArea())
Local cNumero		:= SubStr(SE5->E5_NUMCHEQ,1,TamSX3("E5_DOCUMEN")[1])
Local nTxMoe		:= 0
Local aRet 			:= {0,0,0}
Local cQuery 		:= ""

cQuery := "SELECT E5_FILIAL,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,E5_TIPODOC,E5_VALOR,A6_MOEDA,E5_TXMOEDA,E5_DTDIGIT,E5_DOCUMEN"
cQuery += " FROM " + RetSqlName("SE5") + " SE5, "+RetSqlName("SA6")+ " SA6"   				
cQuery += " WHERE E5_ORIGEM = 'FINA100 '"
cQuery += " AND E5_TIPODOC  = 'TR'"
cQuery += " AND E5_RECPAG 	= 'R'"
cQuery += " AND E5_DOCUMEN 	= '" + cNumero + "'"
cQuery += " AND E5_PROCTRA <> ' ' "
cQuery += " AND A6_COD=E5_BANCO AND A6_AGENCIA=E5_AGENCIA AND A6_NUMCON=E5_CONTA"
cQuery += " AND SE5.D_E_L_E_T_ <> '*' AND SA6.D_E_L_E_T_ <> '*'"
cQuery := ChangeQuery(cQuery)

//Aviso("cQuery1",cQuery,{"OK"},,,,,.T.)	
If Select("StrSQL") > 0  //En uso
	StrSQL->(DbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"StrSQL", .F., .T.)
If !Empty(StrSQL->(E5_DOCUMEN))

	If StrSQL->(A6_MOEDA)==2
		nTxMoe := StrSQL->(E5_TXMOEDA)
	Else
		nTxMoe := RecMoeda(StrSQL->(E5_DTDIGIT),2)
	Endif
					
	aRet := {StrSQL->(A6_MOEDA),nTxMoe,StrSQL->(E5_VALOR)}
Endif
				
StrSQL->(dbCloseArea())

SE5->(RestArea(__aAreaSE5))
RestArea(__aArea)
Return(aRet)
