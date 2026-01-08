#Include 'protheus.ch'
#Include 'parmtype.ch'

User Function GP670ARR

	Local aCposUsr := {{"E2_HIST" , RC1->RC1_DESCRI ,  Nil},{"E2_FILORIG" , RC1->RC1_FILTIT ,  Nil}}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Conta contáveil definição de titulos	³
	//³ Crear campo RC0_XCTA, idem a E2_CONTAD 	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(RC1->RC1_CODTIT)
		RC0->(DbSetOrder(1))
		If RC0->(DbSeek(xFilial("RC0")+RC1->RC1_CODTIT))
			If !Empty(RC0->RC0_XCTA)
				Aadd(aCposUsr,{"E2_CONTAD"	, RC0->RC0_XCTA	,   Nil})
			Endif
		Endif
	Endif

Return (aCposUsr)
