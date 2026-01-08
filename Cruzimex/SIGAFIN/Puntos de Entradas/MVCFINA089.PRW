#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

//-------------------------------------------------------------------

User Function Fina089()
	// COMP011M É o ID do modelo de dados de Autores/Interpretes
	//	ALERT("Fina089...")
Return Verifica()

//-------------------------------------------------------------------

Static Function Verifica()
	Local aArea    := GetArea()
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj     //   := aParam[1]
	Local cIdPonto //  := aParam[2]
	Local cIdModel //  := IIf( oObj<> NIL, oObj:GetId(), aParam[3] )
	Local cClasse  //  := IIf( oObj<> NIL, oObj:ClassName(), '' )

	Local nLinha     := 0
	Local nQtdLinhas := 0
	Local cMsg       := ''

	IF VALTYPE(aParam) == "U"
		DbSelectArea("SEL")
		SEL->(DbSetOrder(2))
		If SEL->(DbSeek(FWxFilial('SEL') +SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + "CH " + SE1->E1_CLIENTE + SE1->E1_LOJA )) // me posiciono en el registro de la SEL

			cTemp		:= getNextAlias()

			BeginSql alias cTemp

				select C5_USERIE,C5_NUM,C5_URECIBO
				from %table:SC5% SC5
				where
				C5_FILIAL = %exp: xFilial("SC5") %
				and C5_URECIBO = %exp: SEL->EL_RECIBO %
				and C5_CLIENTE =  %exp: SEL->EL_CLIENTE %
				and C5_USERIE =  %exp: SEL->EL_SERIE %
				AND SC5.%notDel%

			EndSql

			dbSelectArea( cTemp )
			(cTemp)->(dbGotop())
			cQuery:=GetLastQuery()

			while (cTemp)->(!EOF())

				cNumPed := (cTemp)->C5_NUM // obtengo el nro de pedido
				DbSelectArea("SC5")
				SC5->(DbSetOrder(1))
				If SC5->(DbSeek(FWxFilial('SC5') + cNumPed )) // me posiciono en el pedido
					RecLock("SC5",.F.)
					//			Replace 	C5_USTATUS      With "2"  deberia mudar de 2 a 1 cuando se liquide.
					if SE1->E1_STATUS == "A" // esta anulando
						Replace C5_USTATUS      With "2"
					else // SE1->E1_STATUS == "B" está siendo liquidado el cheque
						Replace C5_USTATUS      With "1"
					endif
					MsUnlock()
				endif
				(cTemp)->(dbSkip())
			enddo
		endif
	ENDIF
	/*
	//  Nahim adicionando temporalmente para que modificque el caimpo E5_TIPODOC 25/05/2019
	IF INCLUI //.and. !(E5_HISTOR $ 'rechazado') // si está liquidando y no esté visualizando un chéque rechazado.	
		RecLock("SE5",.F.)
			Replace 	E5_TIPODOC      With "VL"
		MsUnlock()
	endif
	// nahim termina
	*/
	RestArea( aArea )

Return 