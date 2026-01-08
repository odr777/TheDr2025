#INCLUDE "RWMAKE.CH"
#Include "TOPCONN.ch"

#DEFINE TP_MANUAL   "06"
#DEFINE TP_INGRESO  "07"
#DEFINE TP_EGRESO   "08"
#DEFINE TP_TRASPASO "09"

#DEFINE H_TOTALVL 	15
#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CTBRDIACTB  บAutor  ณEDUAR ANDIA		บ Data ณ  27/02/2019  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE para Asignar automaticamente el Control de Correlativos บฑฑ
ฑฑบ          ณ Contables                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLIVIA                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTBRDIACTB
Local cLancPad 	:= ParamIxb[1]
Local cCodDia	:= ParamIxb[2]	//2019

DO CASE
	//+-------------------------------------+
	//|Orden de Pago						|
	//+-------------------------------------+
	CASE cLancPad $ "570"
		
		If FUNNAME() $ "FINA085A"
			For nA := 1 To Len(aPagos)
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Orden de Pagamento / S๓ Compensa็ใo     ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If aPagos[nA][H_TOTALVL] == 0
					cCodDia := TP_TRASPASO
				EndIf
			Next nA
		Endif
		
		If FUNNAME() $ "FINA371"
			If Type("cOrdPAgo")=="C"
				If lSoCompOP(cOrdPAgo)
					cCodDia := TP_TRASPASO
				Endif
			Endif
		Endif
		
		If Empty(cCodDia)
			cCodDia := TP_EGRESO
		Endif
		
		__cMens := ""
		If cCodDia == TP_EGRESO
			__cMens := "ORDEN DE PAGO [NO COMPENSACIำN]"+ CRLF+"cCodDia := '08' --->(EGRESO)"
		Endif
		If cCodDia == TP_TRASPASO
			__cMens := "ORDEN DE PAGO [SI COMPENSACIำN]"+ CRLF+"cCodDia := '09' --->(TRASPASO)"
		Endif
		
		//Aviso("CTBRDIACTB","cLancPad /cCodDia : '"+cLancPad+"' /'"+cCodDia+"'",{"OK"})
		//Aviso("CTBRDIACTB",__cMens,{"OK"})
		
	//+-------------------------------------+
	//|Anular Orden de Pago					|
	//+-------------------------------------+
	CASE cLancPad $ "571"
		//FUNNAME() $ "FINA086"
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Orden de Pagamento / S๓ Compensa็ใo     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lSoCompOP(TRB->NUMERO)
			cCodDia := TP_TRASPASO
		Endif
		
		If Empty(cCodDia)
			cCodDia := TP_INGRESO
		Endif
	//+-------------------------------------+
	//|Cobros Diveros						|
	//+-------------------------------------+
	CASE cLancPad $ "575"
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Recibos Diversos / S๓ Compensa็ใo       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		If FUNNAME() $ "FINA087A"
			If Len(aLinReceb)== 0
				cCodDia := TP_TRASPASO
			Endif
		Else
			If lSoCompRC(cRecibo,cSerRec)	//lSoCompRC(SEL->EL_RECIBO,SEL->EL_SERIE)
				cCodDia := TP_TRASPASO
			Endif
		Endif
		
		If Empty(cCodDia)
			cCodDia := TP_INGRESO
		Endif
	//+-------------------------------------+
	//|Anul. Cobros Diveros					|
	//+-------------------------------------+
	CASE cLancPad $ "576"
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Recibos Diversos / S๓ Compensa็ใo       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lSoCompRC(TRB->NUMERO,TRB->SERIE)
			cCodDia := TP_TRASPASO
		Endif
		
		If Empty(cCodDia)
			cCodDia := TP_EGRESO
		Endif
	
	OTHERWISE
		//cCodDia := CTBSeqComp(cLancPad)	//2019
ENDCASE

Return(cCodDia)


//+---------------------------------------------------------------------+
//|Retorna o c๓digo do livro diario do comprovante de acordo ao LP		|
//+---------------------------------------------------------------------+
Static Function CTBSeqComp(cLancPad)
Local cCodDia    := ""
Local cSeqLan001 := GetNewPar("MV_SQSUB01","571")
Local cSeqLan002 := GetNewPar("MV_SQSUB02","570")
Local cSeqLan003 := GetNewPar("MV_SQSUB03","")

If AllTrim(cLancPad) $ cSeqLan001
	cCodDia := TP_INGRESO
ElseIf AllTrim(cLancPad) $ cSeqLan002
	cCodDia := TP_EGRESO
ElseIf Empty(cSeqLan003) .Or. AllTrim(cLancPad) $ cSeqLan003
	cCodDia := TP_TRASPASO
Else
   cCodDia := TP_MANUAL
EndIf

Return cCodDia

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณlCompOP   บAutor  ณEDUAR ANDIA    	 บFecha ณ  22/06/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFunci๓n que Indica si la Orden de Pago es solo Compensaci๓n บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLIVIA                                      			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function lSoCompOP(cOrdPg)
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local nVlrComp 	:= 0
Local nVlrBco 	:= 0
Local lRet		:= 0

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SEK") + " SEK"
cQuery += " WHERE EK_FILIAL = '" + xFilial("SEK") +"'"
cQuery += " AND EK_ORDPAGO = '" + cOrdPg + "'"
cQuery += " AND SEK.D_E_L_E_T_<> '*'"
cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0
	StrSQL->(DbCloseArea())
Endif
dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")

While StrSQL->(!Eof())
	If  AllTrim(StrSQL->(EK_TIPO)) $ "PA|NCP" .AND.	!(StrSQL->(EK_TIPODOC)$ "PA")
		nVlrComp := nVlrComp + StrSQL->(EK_VLMOED1)
	Endif	
	If  !Empty(StrSQL->(EK_BANCO)) .AND. StrSQL->(EK_TIPODOC)$ "CP"
		nVlrBco := nVlrBco + StrSQL->(EK_VLMOED1)
	Endif	
	StrSQL->(DbSkip())
EndDo

lRet := nVlrComp > 0 .AND. nVlrBco == 0
RestArea(aArea)
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณlSoCompRC   บAutor  ณEDUAR ANDIA    	 บFecha ณ  02/04/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFunci๓n que Indica si la Recibo es solo Compensaci๓n 		  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ BOLIVIA                                      			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function lSoCompRC(cRecibo,cSerie)
Local aArea		:= GetArea()
Local cQuery 	:= ""
Local nVlrComp 	:= 0
Local nVlrBco 	:= 0
Local lRet		:= 0

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SEL") + " SEL"
cQuery += " WHERE EL_FILIAL = '" + xFilial("SEL") +"'"
cQuery += " AND EL_RECIBO = '" 	 + cRecibo + "'"
cQuery += " AND EL_SERIE = '" 	 + cSerie + "'"
cQuery += " AND SEL.D_E_L_E_T_<> '*'"
cQuery := ChangeQuery(cQuery)

If Select("StrSQL") > 0
	StrSQL->(DbCloseArea())
Endif
dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
dbSelectArea("StrSQL")

While StrSQL->(!Eof())
	If  AllTrim(StrSQL->(EL_TIPO)) $ "RA|NCC" .AND. !(StrSQL->(EL_TIPODOC)$ "RA")
		nVlrComp := nVlrComp + StrSQL->(EL_VLMOED1)
	Endif	
	If  !Empty(StrSQL->(EL_BANCO)) .AND. StrSQL->(EL_TIPODOC)$ "EF|TF|CH"
		nVlrBco := nVlrBco + StrSQL->(EL_VLMOED1)
	Endif
	StrSQL->(DbSkip())
EndDo

lRet := nVlrComp > 0 .AND. nVlrBco == 0
RestArea(aArea)
Return(lRet)

