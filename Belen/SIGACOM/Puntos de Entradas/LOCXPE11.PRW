#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} LocxPe11
Entry point called within the inflow invoice all items validation
@version 0.1.0
/*/

/*
[11] - Apos a gravação da Nota Fiscal fora da transação
*/

User Function LocxPe11()
	local aArea				:= getArea()
	Local aAreaSD1			:= {}
	local aAreaZA3			:= {}
	local nTamOrigin		:= 0
	local nTamIdOrg			:= 0
	local nTamItemOrg		:= 0
	local cFunName			:= upper(alltrim(FUNNAME()))
	Local _Hist		:= ""

/* DA PROBLEMA - wico2k_20220823_2205
	If Alltrim(Funname()) == 'MATA101N' .OR. Alltrim(Funname()) =='MATA143'	//Alltrim(Funname()) <> 'MATA462TN'

		cBusq := xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

		dbSelectArea("SD1")
		DbSetOrder(1)
		dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

		While xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == cBusq

			iF SD1->D1_RATEIO == "2"
				_cCc	:= SD1->D1_CC
			Else
				_cCc := Posicione("SDE",1,XFILIAL("SDE")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"DE_CC")
			EndIf

			If alltrim(_cCc) <> ""
				Exit
			EndIf
			dbSkip()
		End

		//aviso("cc"+_cCc)
		//_Hist := SE2->E2_HIST
		_Hist := SUBSTR(SF1->F1_XOBS,1,40)

		cCond := Posicione("SE4",1,XFILIAL("SE4")+SF1->F1_COND,"E4_TIPO")

		If cCond <> "1"
			cParcela := "01"

			dbSelectArea("SE2")
			DbSetOrder(1)
			If dbSeek(xFilial("SD1")+SF1->F1_SERIE+SF1->F1_DOC+cParcela+"NF "+SF1->F1_FORNECE+SF1->F1_LOJA)

				While dbSeek(xFilial("SD1")+SF1->F1_SERIE+SF1->F1_DOC+cParcela+"NF "+SF1->F1_FORNECE+SF1->F1_LOJA) == .T.

					If Alltrim(Funname()) == 'MATA101N'.OR. Alltrim(Funname()) =='MATA143'		// facturas de entrada y despachos (importacion)
						//alert(SE2->E2_NUM)
						If alltrim(SE2->E2_NUM) <> ""
							SE2->( RecLock("SE2",.F.) )
							SE2->E2_HIST	:= _Hist
							SE2->E2_CCUSTO	:= _cCc
							SE2->( MsUnLock() )
						EndIf
					EndIf

					cParcela := STRZERO(val(cParcela)+1,2,0)

					dbSkip()
				End

			EndIf
		Else
			cParcela := " "

			If Alltrim(Funname()) == 'MATA101N' .OR. Alltrim(Funname()) =='MATA143'			// facturas de entrada
				//alert(SE2->E2_NUM)
				If alltrim(SE2->E2_NUM) <> ""
					SE2->( RecLock("SE2",.F.) )
					SE2->E2_HIST	:= _Hist
					SE2->E2_CCUSTO	:= _cCc
					SE2->( MsUnLock() )
				EndIf
			EndIf

		EndIf
	EndIf

*/

	if cFunName $ "MATA143"  //caso estemos en esta rutina.
		If !Empty(DBB->DBB_UNDB) .and. SE2->E2_NUM == DBB->DBB_DOC 
			if RecLock("SE2",.F.)
				REPLACE E2_HIST With DBB->DBB_UNDB
	//			Replace E2_BCOPAG  With GetAdvFVal("SA2","A2_BANCO",xFilial("SA2") + SE2->E2_FORNECE+SE2->E2_LOJA,1,"")
				SE2->(MsUnlock())
			endif
		EndIf
	endif

	restArea(aArea)

	//Alert("Finalizó LOCXPE11")

return
