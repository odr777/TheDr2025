#include 'protheus.ch'
#include 'parmtype.ch'

User Function A085AFM2()     
Local aArea    := GetArea()
	private aRegOrPag := aClone(ParamIxb[1])

	if !empty(aRegOrPag)
		SX1->(DbSetOrder(1))
		SX1->(DbGoTop())       
		If SX1->(DbSeek('FIR85A'+Space(4)+'01') )
		RecLock('SX1',.F.) 
			SX1->X1_CNT01 := dtoc(DDATABASE)  
		SX1->(MsUnlock())	
		End
		
		If SX1->(DbSeek('FIR85A'+Space(4)+'02'))
		RecLock('SX1',.F.) 
			SX1->X1_CNT01 := dtoc(DDATABASE)
		SX1->(MsUnlock())	
		End
		
		If SX1->(DbSeek('FIR85A'+Space(4)+'03'))
		RecLock('SX1',.F.)
			SX1->X1_CNT01 := aRegOrPag[1][1]
		SX1->(MsUnlock())	
		End                     	
		
		If SX1->(DbSeek('FIR85A'+Space(4)+'04'))
		RecLock('SX1',.F.)
			SX1->X1_CNT01 := aRegOrPag[1][1]
		SX1->(MsUnlock())	
		End
		
		SX1->(DbSetOrder(1))
		If SX1->(DbSeek('FIR85A'+Space(4)+'05'))               
		RecLock('SX1',.F.)
			SX1->X1_CNT01 := ''  
			SX1->(MsUnlock())	
		End
		
		If SX1->(DbSeek('FIR85A'+Space(4)+'06'))
		RecLock('SX1',.F.)
			SX1->X1_CNT01 := 'ZZZZZZ'
			SX1->(MsUnlock())	
		End
		RestArea( aArea )
	//	U_FINR85A(aDatos[1][1])
		U_ORDPAGO()
	ENDIF
Return
