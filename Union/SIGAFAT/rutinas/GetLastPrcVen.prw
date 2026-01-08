#Include 'Protheus.ch'
#Include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProgram ณGetNextNrPed บAuthor ณAmby Arteaga Rivero บ Date ณ 30/06/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Trae el ultimo precio de venta de la SC6 y lo adiciona en   บฑฑ
ฑฑบ          ณ DA1 							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUse       ณ Mercantil LEON S.R.L.                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GetLastPrcVen(cCodProd,nMoneda)
Local cQuery 
Local nLastPrcVen := 0

//Alert(cCodProd)
		cQuery := " SELECT TOP 1 C6_PRUNIT,C5_MOEDA,C5_EMISSAO "
		cQuery += " From " + RetSqlName("SC6") + " SC6," + RetSqlName("SC5") + " SC5 " 
		cQuery += " Where C6_FILIAL = '" + xFilial("SC6") + "' AND C5_FILIAL = '" + xFilial("SC5") + "' "
		cQuery += " And C6_NUM = C5_NUM AND C6_CLI = C5_CLIENTE "
		cQuery += " And C6_PRODUTO = '" + cCodProd + "' "
	   	cQuery += " And SC6.D_E_L_E_T_  <> '*' And SC5.D_E_L_E_T_  <> '*' "
		cQuery += " ORDER BY SC6.R_E_C_N_O_ DESC "

//aviso("",cQuery,{'ok'},,,,,.t.)		
		If Select("StrSQL") > 0  //En uso
		   StrSQL->(DbCloseArea())
		End
		
		TcQuery cQuery New Alias "StrSQL"
		nTCamb = POSICIONE("SM2",1,StrSQL->C5_EMISSAO,"M2_MOEDA2")
		nMonedaUV := StrSQL->C5_MOEDA

		If (nMoneda == 1)
			If (nMonedaUV == 1)
				nLastPrcVen := StrSQL->C6_PRUNIT
			Else
				nLastPrcVen := StrSQL->C6_PRUNIT * nTCamb
			EndIf
		Else
			If (nMonedaUV == 2)
				nLastPrcVen := StrSQL->C6_PRUNIT
			Else
				nLastPrcVen := StrSQL->C6_PRUNIT / nTCamb
			EndIf
	  	EndIf
	  	
Return nLastPrcVen
