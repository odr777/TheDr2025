#Include "Protheus.ch"
#DEFINE H_TOTALVL 	15
//Posicoes do Array  ASE2

#DEFINE _PREFIXO  9
#DEFINE _RECNO   13

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA085TUDOK บAutor  ณEDUAR ANDIA         บ Data ณ  11/11/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE -Valida็ใo do painel de ordem de pagamento 			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Mercado Internacional                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A085TUDOK
Local aSE2	:= ParamIxb
Local lRet	:= .T.
Local nA	:= 0

//Return .F.	//<------------------------------

For nA := 1 To Len(aPagos)

	//Aviso("A085TUDOK - Mensaje","aPagos[nA][H_TOTALVL] : '" + AllTrim(Str(aPagos[nA][H_TOTALVL])) +"'" ,{"OK"})
	If (aPagos[nA][H_TOTALVL] > 0)
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Si forma de Pago es Cheque Suelto                       	 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nPagar == 1	
			lRet := .F.
			Aviso("A085TUDOK - Mensaje","No puede seleccionar la Opci๓n de Cheque Suelto",{"OK"})
			Exit
		Endif
	EndIf
Next nA

If lRet
	lRet := !(lPoliza(aSE2))
Endif

If lRet
	lRet := !(lProviso(aSE2))
Endif

Return(lRet)


//+---------------------------------------------------------------------+
//|Verifica si existe Titulo/Pagar de Poliza (PLZ)			      		|
//+---------------------------------------------------------------------+
Static Function lPoliza(aSE2)
Local	nI		:= 0
Local 	aTits	:= {}
Local 	aCXP	:= {}
Local 	lRet	:= .F.

If Len(aSE2)>0
	If Len(aSE2[1])>0
		If Len(aSE2[1][1])>0
			aTits := aSE2[1][1]			
		Endif
	Endif
Endif

For nI := 1 To Len(aTits)
	aCXP := aTits[nI]
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Titulos de Poliza (PLZ) no se tiene que Pagar                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aCXP[_PREFIXO]$ "PLZ"
		If aCXP[_RECNO]> 0
			SE2->(MsGoTo(aCXP[_RECNO]  ))
			If AllTrim(SE2->E2_TIPO) $ "NF |NDP"
				If SE2->E2_PREFIXO $ "PLZ" .AND. AllTrim(SE2->E2_ORIGEM) $ "FINA050"					
					Aviso("AVISO - A085TUDOK","No se puede hacer pagos de Titulos provisorios de Seguro de Polizas",{"OK"})
					lRet := .T.
					Exit
				Endif
			Endif
		Endif		
	EndIf
Next nI

Return(lRet)

//+---------------------------------------------------------------------+
//|Verifica si existe Titulo/Pagar Provisorio (PRV) /INIAF,...			|
//+---------------------------------------------------------------------+
Static Function lProviso(aSE2)
Local	nI		:= 0
Local 	aTits	:= {}
Local 	aCXP	:= {}
Local 	lOk		:= .F.

If Len(aSE2)>0
	If Len(aSE2[1])>0
		If Len(aSE2[1][1])>0
			aTits := aSE2[1][1]			
		Endif
	Endif
Endif

For nI := 1 To Len(aTits)
	aCXP := aTits[nI]
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Titulos Provisorios (Serie - PRV) no se tiene que Pagar      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aCXP[_PREFIXO]$ "PRV"
		If aCXP[_RECNO]> 0
			SE2->(MsGoTo(aCXP[_RECNO]  ))
			If AllTrim(SE2->E2_TIPO) $ "NF|NDP"
				If SE2->E2_PREFIXO $ "PRV" .AND. AllTrim(SE2->E2_ORIGEM) $ "MATA100"					
					Aviso("AVISO - A085TUDOK","No se puede hacer pagos de Titulos provisorios",{"OK"})
					lOk := .T.
					Exit
				Endif
			Endif
		Endif		
	EndIf
Next nI

Return(lOk)