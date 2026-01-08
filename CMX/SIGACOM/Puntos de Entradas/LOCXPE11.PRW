#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} LocxPe11
Entry point called within the inflow invoice all items validation
@version 0.1.0
/*/
User Function LocxPe11()
	local aArea				:= getArea()
	Local aAreaSD1			:= {}
	local aAreaZA3			:= {}
	local nTamOrigin		:= 0
	local nTamIdOrg			:= 0
	local nTamItemOrg		:= 0
	local cFunName			:= upper(alltrim(FUNNAME()))
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

return