#include 'protheus.ch'
#include 'parmtype.ch'

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA087GRV  ºAutor  ³TdeP Horeb SRL  º Data ³  30/05/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PUNTO DE ENTRADA PARA LA IMPRESION DEL RECIBO DE COBRANZAS  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BIB									                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function FA087GRV()
aArea    := GetArea()
    
SX1->(DbSetOrder(1))
SX1->(DbGoTop())         
If SX1->(DbSeek('FIR087'+Space(4)+'01'))
   RecLock('SX1',.F.)
   SX1->X1_CNT01 := cRecibo
   SX1->(MsUnlock())
End
         
If SX1->(DbSeek('FIR087'+Space(4)+'02'))
   RecLock('SX1',.F.)
   SX1->X1_CNT01 := cRecibo
   SX1->(MsUnlock())
End                                 
                                 
SX1->(DbSetOrder(1))
SX1->(DbGoTop())         
If SX1->(DbSeek('FIR087'+Space(4)+'03'))
   RecLock('SX1',.F.)
   SX1->X1_CNT01 := cSerie
   SX1->(MsUnlock())
End                                                                  


/*IF(FUNNAME()$'FINA087A')
	U_CFinI204()
	//U_CobrDiv()                                    
END
*/                
              
  
RestArea( aArea )
	
return