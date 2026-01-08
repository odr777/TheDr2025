#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProgram ณGetNextNrPed บAuthor ณAmby Arteaga Rivero บ Date ณ 30/06/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que Genera el N+umero Correlativo de los Pedidos  บฑฑ
ฑฑบ          ณ en base a la Condici๓n de Pago							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUse       ณ Mercantil LEON S.R.L.                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GetNextNrPed(cCondPag)
	Local aArea		:= getArea()
	Local cQuery  := ""
	Local cQueryx := ""
	Local cNumPed := ""
	Local lVenFut	:= FWIsInCallStack("U_GERVTAFUT")
	Local lExecWS	:= (GetRemoteType() < 0)//.T.->Ejecutado desde un WS o un Job; .F.->Ejecutado desde un smartclient

	If !Empty(cCondPag) .AND. (INCLUI .OR. FUNNAME()$"MATA416" .OR. lVenFut .OR. lExecWS) .AND. SuperGetMV("MV_UGETNEXPV",.F.,.F.)	// .AND. !IsInCallStack("A468RMFUT") .AND. !lVenFut
		If (cCondPag) == "002"
			cQueryx += " And Left(C5_NUM,1) <> 'C' "
		Else
			cQueryx += " And Left(C5_NUM,1) = 'C' "
		EndIf

		cQuery := " SELECT TOP 1 C5_NUM "
		cQuery += " From " + RetSqlName("SC5")
		cQuery += " Where C5_FILIAL = '" + xFilial("SC5")+ "' "
		cQuery += cQueryx
		cQuery += " And D_E_L_E_T_  <> '*' "
		cQuery += " AND SUBSTRING(C5_NUM,2,5)  NOT LIKE '%[A-Z]%' "
		cQuery += " ORDER BY C5_NUM DESC "

		//Aviso("",cQuery,{'ok'},,,,,.t.)
		If Select("StrSQL") > 0  //En uso
			StrSQL->(DbCloseArea())
		Endif

		TcQuery cQuery New Alias "StrSQL"
		If Empty(StrSQL->C5_NUM)
			If (cCondPag) == "002"
				cNumPed := "000001"
			Else
				cNumPed := "C00001"
			EndIf
		Else
			//Obtiene el valor Num้rico del Ultimo C๓digo
			If (cCondPag) == "002"
				cNumero := CValToChar(VAL(AllTrim(StrSQL->C5_NUM))+1)
				cNumPed := REPLICATE("0",6 - LEN(AllTrim(cNumero)))+AllTrim(cNumero)
			Else
				cNumero := CValToChar(VAL(SUBSTR(AllTrim(StrSQL->C5_NUM),2,5))+1)
				cNumPed := "C"+REPLICATE("0",5 - LEN(AllTrim(cNumero)))+AllTrim(cNumero)
			EndIf
		EndIf
	ElseIf ALTERA
		cNumPed := SC5->C5_NUM
	Else 
		cNumPed := M->C5_NUM
	End If

//Alert("GetNextNrPed - cNumPed: '" + cNumPed + "''")

Return(cNumPed)
