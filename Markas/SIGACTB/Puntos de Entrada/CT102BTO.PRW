#Include "rwmake.ch"

User Function CT102BTO()
	aButton:= {}
	Aadd(aButton, {'NOTE',{||ImpLanc()},"Imp.Asiento"})//Adiciona el Boton
Return(aButton) 

                                                                                                                        

static Function ImpLanc()
   cPerg:="CTR070"   

   SX1->(DbSetOrder(1))
   If SX1->(DbSeek(cPerg+Space(4)+'01'))               
   	RecLock('SX1',.F.)                              
   	SX1->X1_CNT01 := DTOS(M->DDATALANC)
   	SX1->(MsUnlock())
   End
   If SX1->(DbSeek(cPerg+Space(4)+'02'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  DTOS(M->DDATALANC )
    SX1->(MsUnlock())
   END  
   If SX1->(DbSeek(cPerg+Space(4)+'03'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  M->CLOTE
    SX1->(MsUnlock())
   END                        
   If SX1->(DbSeek(cPerg+Space(4)+'04'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  M->CLOTE
    SX1->(MsUnlock())
   END 
   If SX1->(DbSeek(cPerg+Space(4)+'05'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  M->CDOC
    SX1->(MsUnlock())
   END 
   If SX1->(DbSeek(cPerg+Space(4)+'06'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  M->CDOC
    SX1->(MsUnlock())
   END  
   If SX1->(DbSeek(cPerg+Space(4)+'07'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  '01'
    SX1->(MsUnlock())
   END 
    If SX1->(DbSeek(cPerg+Space(4)+'12'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  '3'
    SX1->(MsUnlock())
   END 
   If SX1->(DbSeek(cPerg+Space(4)+'15'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  M->cSubLote
    SX1->(MsUnlock())
   END 
   If SX1->(DbSeek(cPerg+Space(4)+'16'))
    RecLock('SX1',.F.)                  
    SX1->X1_CNT01 :=  M->cSubLote
    SX1->(MsUnlock())
   END 
   
  U_CtbcR070() 
Return