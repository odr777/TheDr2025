

/*/{Protheus.doc} User Function AVALCOT
	
	Punto de entrada
	Manipula Pedido de Compras da tabela SC7
	EM QUE PONTO :  O ponto se encontra no final do evento 4 da MaAvalCot (Analise da Cotação) após a gravação do item do PC gerado a partir da cotação vencedora. e pode ser utilizado para manipular o item do pedido de compras posicionado tabela SC7 para gravar campo customizados do usuario por exemplo.
	Eventos	
	@type  Function
	@author user
	@since 26/08/2021
	@version version
	@see

	https://tdn.totvs.com/display/public/PROT/AVALCOT+-+Manipula+Pedido+de+Compras+da+tabela+SC7

	
	/*/



User Function AVALCOT()

Local nEvento := PARAMIXB[1]
Local aArea := GetArea()

If FwIsAdmin() .and. SuperGetMV("MV_UACTAVI",.F.,.F.) //Si perteneces al grupo de Administradores y El parámetro de aviso de PE está activado
   Aviso("MV_UACTAVI","MV_UACTAVI Activo - ProcName: "+ProcName(),{'ok'},,,,,.t.)
ENDIF

If nEvento == 4    
	dbSelectArea('SC7')    
	IF ALLTRIM(SC8->C8_XPRODAL) <>''
		RecLock('SC7',.F.)    
			SC7->C7_PRODUTO := SC8->C8_XPRODAL
			MsUnlock()
	Endif     
	RestArea(aArea) 
EndIf
Return
