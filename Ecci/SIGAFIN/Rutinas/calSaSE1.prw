#INCLUDE "Protheus.CH"

/*                       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcSaldos ³Nahim Terrazas  		       º Data ³  04/05/17   º±±
±±ºDesc.     ³Calcula los Saldos de los titulos de cuenta Por Cobrar		    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ General                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/ 

User Function CalSaSE1() 

SE1->(DbSelectArea("SE1"))
DbSetOrder(1)
//DbGoTop()
//	ALERT(SE1->E1_CLIENTE+' NUM:'+SE1->E1_NUM+' tipo:'+SE1->E1_TIPO)
	While SE1->(!EOF())
		If SE1->E1_TIPO = 'NF ' //.AND. SE1->E1_CLIENTE = '100002'
			nSaldo := Saldotit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,;
			       "R",SE1->E1_CLIENTE,SE1->E1_MOEDA,DDATABASE,DDATABASE,SE1->E1_LOJA,)
			//ALERT(SE1->E1_CLIENTE+' NUM:'+SE1->E1_NUM+' SALDO:'+NTOC(nSaldo,10,12))
			Reclock("SE1")
			    SE1->E1_SALDO := nSaldo
			    SE1->E1_VALLIQ := SE1->E1_VALOR - nSaldo
			MsUnlock()
		EndIf
		SE1->(DbSkip())
	End

DbCloseArea()
Alert ("Ha sido realizado el calculo de saldo")
return
