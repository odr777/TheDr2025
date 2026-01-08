#Include "Protheus.ch"
#Include "Parmtype.ch"
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT462MNU ºAutor  ³Nahim Terrazas    º Data ³  05/04/19   	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±	Punto de entrada al hacer una anulación en la rutina FINA088		   ±±
±±	Anulacion de cobros diversos 									      ¹±±
±±ºUso       ³ BELEN                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function FA088OK()
	Local aArea	:= GetArea()
	Local cTemp	:= getNextAlias()
	Local lRet	:= .T.

	lRet :=  MSGYESNO( "¿Está seguro de que desea Realizar la transacción Seleccionada ?", "Confirmación" )
	if !lRet
		return lRet
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica si Anticipo tiene bajas - EDUAR 19/08/2019	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SEL")
	SEL->(DbSetOrder(8)) //EL_FILIAL+EL_SERIE+EL_RECIBO+EL_TIPODOC+EL_PREFIXO+EL_NUMERO+EL_PARCELA+EL_TIPO
	If DbSeek(xFilial("SEL")+TRB->SERIE+TRB->NUMERO+"RA")
		While SEL->(!Eof()) .AND. SEL->(EL_FILIAL+EL_SERIE+EL_RECIBO+EL_TIPODOC) == xFilial("SEL")+TRB->SERIE+TRB->NUMERO+"RA"

			DbSelectArea("SE1")
			SE1->(DbSetOrder(2)) //E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
			If SE1->(DbSeek(xFilial("SE1")+SEL->EL_CLIENTE+SEL->EL_LOJA+SEL->EL_PREFIXO+SEL->EL_NUMERO))
				If AllTrim(SE1->E1_TIPO) $ "RA"
					If SE1->E1_SALDO < SE1->E1_VALOR //Tiene baja
						lRet := .F.
						__cMsg :="Problema al Borrar/Anular Recibo "+Chr(13)+Chr(10)
						__cMsg +="Título: '"+SE1->E1_TIPO +"' / "+SE1->E1_NUM+" tiene bajas realizadas"
						Msgbox(__cMsg,"FA088OK","ALERT")
						Exit
					Endif
				Endif
			EndIf
			SEL->(DbSkip())
		EndDo
	Endif

	// nahim borrando pedido status
	BeginSql alias cTemp

		select C5_USERIE,C5_NUM,C5_URECIBO
		from %table:SC5% SC5
		where
		C5_FILIAL = %exp: xFilial("SC5") %
		and C5_URECIBO = %exp: TRB->NUMERO %
		and C5_CLIENTE =  %exp: TRB->CLIENTE %
		and C5_USERIE =  %exp: TRB->SERIE %
		AND SC5.%notDel%

	EndSql

	dbSelectArea( cTemp )
	(cTemp)->(dbGotop())
	cQuery:=GetLastQuery()
	//Aviso("",cQuery[2],{"Ok"},,,,,.T.)

	while (cTemp)->(!EOF())
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(FWxFilial('SC5') + (cTemp)->C5_NUM )) // me posiciono en el pedido
			RecLock("SC5",.F.)
			Replace 	C5_USTATUS      With " "
			Replace 	C5_USERIE      With " "
			Replace 	C5_URECIBO      With " "
			MsUnlock()
		endif
		DbCloseArea("SC5")
		(cTemp)->(dbSkip())
	Enddo
	// nahim borrando pedido status




	RestArea( aArea )
Return(lRet)
