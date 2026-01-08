User Function AVALCOT()

Local nEvento := PARAMIXB[1]
Local aArea := GetArea()

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