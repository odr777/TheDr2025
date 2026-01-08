#INCLUDE "Protheus.ch"

/*/{Protheus.doc} MT120GRV
Grava Campos Pedido de Compra
@type function
@version 1.0
@author Luiz Fael
@since 28/11/2022
@return variant, Nill
/*/
User Function MT120GRV()
	If !Empty(cCampana)
		ZZK->(dbSetOrder(1))
		ZZK->(dbSeek(xFilial('ZZK')+cCampana))
		RecLock("SC7",.F.)
		SC7->C7_CAMPANA	:= cCampana
		SC7->C7_CAMPDES	:= ZZK->ZZK_DESC
	EndIf
	If !Empty(cCampro)
		ZZL->(dbSetOrder(3)+ZZK->ZZK_IDSAF)
		ZZL->(dbSeek(xFilial('ZZK')+cCampana))
		SC7->C7_CAMPRO  := cCampro
		SC7->C7_CAMPROD	:= ZZL->ZZL_DESC
	EndIf
	SC7->(MsUnlock())
Return



