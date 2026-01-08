#Include "Protheus.ch"
#DEFINE CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA080CMI  บAutor  ณEDUAR ANDIA         บ Data ณ  03/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE -Sera utilizado para validacao do valor em moeda forte  บฑฑ
ฑฑบ			 ณ e sera executado para validar o valor de moeda estrangeira บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Mercado Internacional                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FA080CMI
Local __cMsg	:= ""
Local nDCEuro	:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Diferencia Cambiaria EURO	ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If TrazCodMot(cMotBx) $ "EUR"
	__cMsg := "Realiza el cแlculo de Dif. cambiaria en Euro?"
	If Aviso("FA080CMI",__cMsg,{"Si","No"})==1
		nDCEuro := AtuVlrEuro()
				
		If nDCEuro < 0
			nDCEuro := ABS(nDCEuro)	//Perdida (Gasto)
			nValEstrang := nDCEuro
		Else
			If nDCEuro > 0
				//No configurado	//Ganancia (Ingreso)
			Endif
		Endif		
	Endif
Endif

Return

//+-----------------------------------------------------+
//|Valor de la Dif.Cambio Euro (SE2 /SEK)				|
//+-----------------------------------------------------+
Static Function AtuVlrEuro
Local __cMsg := ""
Local nVlEur := 0

If RecMoeda(dDataBase,3)==0
	__cMsg := "Tasa de Cambio de la Moneda Euro en 0.00"
	Aviso("A V I S O ",__cMsg,{"OK"})
	Return 0
Endif

If SE2->E2_MOEDA<> 2
	__cMsg := "El Tํtulo no estแ en moneda D๓lar"
	Aviso("A V I S O ",__cMsg,{"OK"})
	Return 0
Endif

If AllTrim(SE2->E2_TIPO) $ "PA " .AND. "FINA085A" $ SE2->E2_ORIGEM
	SEK->(DbSetOrder(1))
	If SEK->(DbSeek(xFilial("SEK")+SE2->E2_ORDPAGO+"PA"+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+"PA "))
		__nTxOPEur := SEK->EK_TXMOE03			//	1,12890		
		__nTxM2Eur := RecMoeda(dDataBase,3)		//	0,90440		
		
		nBco 	:= SE2->E2_VALOR
		nBcb 	:= (SE2->E2_VALOR /__nTxOPEur) /__nTxM2Eur
		nVlEur 	:= nBcb - nBco
	Endif
Else
	__cMsg := "El Tํtulo a Bajar: "
	__cMsg += SE2->E2_TIPO + ": " + SE2->E2_PREFIXO + " /"+SE2->E2_NUM
	__cMsg += "No fue generado desde Orden de Pago"
	Aviso("A V I S O ",__cMsg,{"OK"})
	Return 0
Endif
		
Return(nVlEur)