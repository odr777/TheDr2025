
//PE VALIDA LIMITE DE SALDO
User Function F85ASDBCO()
	Local aArea:=GetArea()
	Local lValid:= .T.
	Local nValLimite:= 0
	Local nSaldoB := 0
	Local nValliq := IIF(AllTrim(CMOEDA)='DOLAR',XMOEDA(PARAMIXB[4],2,1,DDATABASE),PARAMIXB[4])
	DbSelectArea('SA6')
	DbSetOrder(1)
	DbSeek(xFilial()+PARAMIXB[1]+PARAMIXB[2]+PARAMIXB[3])
	nSaldoB := XMOEDA(SA6->A6_SALATU,SA6->A6_MOEDA,1,DDATABASE)

	If nValliq > nSaldoB //.And. (nValliq - nSaldoB ) > nValLimite
		MsgAlert("Banco sin saldo o valor de pago superior al saldo. Saldo Actual: "+TRANSFORM(SA6->A6_SALATU,"@E 9,999,999,999,999.99"))
		lValid:= .F.
	EndIf
	RestArea(aArea)
Return lValid
