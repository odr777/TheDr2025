#Include 'protheus.ch'
#Include 'parmtype.ch'

/*/{Protheus.doc} User Function GP670ARR

	Punto de entrada adiciona cuenta contable de definición de títulos 
	+ descripción del título.

	Esse Ponto de entrada deve ser utilizado para adicionar, na integração do titulo, campos criados pelo usuario. 
	Ele somente será executado quando estiver sendo efetuada a integraçcao do titulo, se isso não ocorrer 
	sera apresentado log com os titulos não integrado.
	@type  Function
	@author Nahim Terrazas
	@since 12/05/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6079137
	/*/

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
