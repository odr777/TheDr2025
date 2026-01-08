#INCLUDE "Protheus.ch"

/*/{Protheus.doc} MT120FIM
Grava Campos Pedido de Compra
@type function
@version 1.0
@author Luiz Fael
@since 28/11/2022
@return variant, Nill
/*/
User Function MT120FIM()
	//Local nOpcao 		:= PARAMIXB[1]   // Opção Escolhida pelo usuario Local 
	//Local cNumPC 		:= PARAMIXB[2]   // Numero do Pedido de ComprasLocal 
	Local nOpcA     	:= PARAMIXB[3]   // Indica se a ação foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICAÇÃO DO USUARIO.....
	If nOpcA  == 1
		ZZK->(dbSetOrder(1))
		ZZK->(dbSeek(xFilial('ZZK')+cCampana))
		RecLock("SC7",.F.)
		SC7->C7_CAMPANA	:= cCampana
		SC7->C7_CAMPDES	:= ZZK->ZZK_DESC
		SC7->(MsUnlock())
	Endif 
Return



