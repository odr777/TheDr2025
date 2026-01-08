#Include "Protheus.ch"

/*/{Protheus.doc} MT160WF
Registra nombre del proveedor y número de parte
@type function
@author wico2k
@since 28/4/2022
/*/

User Function MT160WF()
Local cC7Num 	:= xFilial("SC7")+SC7->C7_NUM
Local aArea 	:= GetArea()
Local aAreaSC7 	:= SC7->(GetArea())

DBSelectArea('SC7')
DbSetOrder(1)
DbSeek(cC7Num)

While xFilial("SC7")+SC7->C7_NUM == cC7Num	
	
	RecLock("SC7", .F.)
		SC7->C7_UNOME 	:= GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA),1,"")
		SC7->C7_XNUMPAR := GetAdvFVal("SB1","B1_NUMPART",xFilial("SB1")+SC7->(C7_PRODUTO),1,"")
	MsUnLock()

	DbSelectArea("SC7")
	DbSkip()
EndDo

RestArea(aAreaSC7)
RestArea(aArea)

Return

