#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LocxPE37.PRW.ºAutor  ³Nain Terrazas-TdeP    ºFecha ³15/11/19º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para obtener en la descripción de la cuenta por pagar    ±±
±± El nro de pedido de compra y el Remito para identificarlo con el RA 	   ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLIVIA                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
[37] - Antes de começar a gravar os dados financeiros (SE1/SE2)
*/

User Function LocxPE37()
	//Local aDuplOri := {}
	//Local cNFiscal := "00000000000000000003" 	//Numero da NF
	//Local cSerie := "A  "    					// Serie da NF
	//Local cParcela := "   " 			   		//Parcela referente ao vencimento
	//Local dVenc := "29/07/11" 		   			//Data do Vencimento
	//Local nValor := "           1.000,00" 		//Valor do Vencimento
	//aADD(aDuplOri,cSerie+"³"+cNFiscal+"³"+cParcela+"³"+dVenc+"³"+nValor)
	//	alert("LocxPE37")
	IF FUNNAME() == "MATA101N"
		cDesc := if(!empty(SD1->D1_PEDIDO),"PC: " + SD1->D1_PEDIDO,"")
		if empty(cDesc)
			if !empty(SD1->D1_REMITO)
				cDesc := "Remito: "+ SD1->D1_REMITO  + " " + SD1->D1_SERIREM
			endif
		else
			if !empty(SD1->D1_REMITO)
				cDesc := cDesc + " - Remito: "+ SD1->D1_REMITO  + " " + SD1->D1_SERIREM
			endif
		endif

		if !empty(SF1->F1_XOBS)
			if empty(cDesc)
				SE2->E2_HIST := SF1->F1_XOBS
			else
				SE2->E2_HIST := SF1->F1_XOBS+ " "+cDesc
			endif
		endif
	endif

	//	alert(SE2->E2_HIST)
	//Alert("Finalizó LOCXPE37")

Return
