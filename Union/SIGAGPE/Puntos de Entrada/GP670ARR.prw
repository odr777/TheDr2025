#Include 'protheus.ch'
#Include 'parmtype.ch'

User Function GP670ARR
Local aCposUsr := {{"E2_HIST" , RC1->RC1_DESCRI ,  Nil}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conta contáveil definição de titulos	³
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